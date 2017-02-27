/*--------------------------------------------------------------------------------------+
 |
 |     $Source: $
 |    $RCSfile: $
 |   $Revision:   1.0  $
 |       $Date:   Feb 27 2017 06:48:00  $
 |     $Author:   Upendra.Hukeri  $
 |
 |  $Copyright: (c) 2009 Bentley Systems, Incorporated. All rights reserved. $
 |
 | Licensed under the Apache License, Version 2.0 (the "License");
 | you may not use this file except in compliance with the License.
 | You may obtain a copy of the License at
 | http://www.apache.org/licenses/LICENSE-2.0
 |
 | See the Apache Version 2.0 License for specific language governing
 | permissions and limitations under the License.
 +--------------------------------------------------------------------------------------*/

package com.auth10.federation;

import java.io.File;
import java.security.cert.X509Certificate;
import java.util.List;
import java.util.Timer;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.params.HttpClientParams;
import org.joda.time.DateTime;
import org.opensaml.saml2.metadata.EntityDescriptor;
import org.opensaml.saml2.metadata.KeyDescriptor;
import org.opensaml.saml2.metadata.RoleDescriptor;
import org.opensaml.saml2.metadata.provider.FileBackedHTTPMetadataProvider;
import org.opensaml.saml2.metadata.provider.MetadataProviderException;
import org.opensaml.xml.Configuration;
import org.opensaml.xml.security.keyinfo.KeyInfoHelper;

import be.fedict.eid.idp.protocol.ws_federation.wsfed.SecurityTokenService;

/**
 * Manages federation metadata.
 */
public class FederationMetadata
{
	private static final int DEFAULT_METADATA_TIMEOUT = 24*60*60*1000; // 1 day
    private static volatile FederationMetadata instance = null;

    static {
    	FederationBootstrap.bootstrap();
    }

    public static FederationMetadata getInstance()
    {
        FederationMetadata instance = FederationMetadata.instance;
        if(instance == null)
        {
            synchronized (FederationMetadata.class)
            {
                instance = FederationMetadata.instance;
                if(instance == null)
                {
                    FederationMetadata.instance = instance = new FederationMetadata();
                }
            }
        }
        return instance;
    }

    private FileBackedHTTPMetadataProvider metadataProvider = null;
    private Timer timer;
    private DateTime lastUpdated = null;

    private FederationMetadata()
    {
        refresh();
    }

    /**
     * Refresh the federation metadata.
     */
    public synchronized void refresh()
    {
        if(timer != null)
        {
            timer.cancel();
            timer = null;
        }
        metadataProvider = null;
        FederatedConfiguration config = FederatedConfiguration.getInstance();
        String metadataUri = config.getMetadataUri();
		if(metadataUri != null)
        {
            try
            {
                timer = new Timer(true);
                int requestTimeout = 1000;
                HttpClientParams clientParams = new HttpClientParams();
                clientParams.setSoTimeout(requestTimeout);
                HttpClient client = new HttpClient(clientParams);
                client.getHttpConnectionManager().getParams().setConnectionTimeout(requestTimeout);
                String backupFilePath = new File(System.getProperty("java.io.tmpdir"),"federation-metadata.txt").getAbsolutePath();
                FileBackedHTTPMetadataProvider metadataProvider = new FileBackedHTTPMetadataProvider(timer, client,
                        metadataUri, backupFilePath);
                int metadataTimeout = config.getMetadataTimeout();
                if(metadataTimeout <= 0)
                {
                	metadataTimeout = DEFAULT_METADATA_TIMEOUT;
                }
				metadataProvider.setMaxRefreshDelay(2*metadataTimeout);
                metadataProvider.setMinRefreshDelay(metadataTimeout);
                metadataProvider.setParserPool(Configuration.getParserPool());
                metadataProvider.setRequireValidMetadata(true);
                metadataProvider.initialize();
                this.metadataProvider = metadataProvider;
            }
            catch (MetadataProviderException e)
            {
                e.printStackTrace();
            }
        }
    }

    /**
     * Gets the entity descriptor for the federation metadata.
     *
     * @return the entity descriptor
     * @throws MetadataProviderException the metadata provider exception
     */
    public EntityDescriptor getEntityDescriptor() throws MetadataProviderException
    {
        String entityID = FederatedConfiguration.getInstance().getMetadataEntityID();
        if(entityID == null)
        {
        	entityID = FederatedConfiguration.getInstance().getStsUrl();
        }
		return metadataProvider.getEntityDescriptor(entityID);
    }

    /**
     * Update the STS certificate thumbprints from the federation metadata.
     */
    public synchronized void updateThumbprints()
    {
        DateTime lastUpdated = metadataProvider.getLastUpdate();
        if(this.lastUpdated == null ||(lastUpdated != null && lastUpdated.isAfter(this.lastUpdated)))
        {
            try
            {
                EntityDescriptor entityDescriptor = getEntityDescriptor();
                StringBuilder thumbprints = null;
                for(RoleDescriptor roleDescriptor : entityDescriptor.getRoleDescriptors())
                {
                    if(roleDescriptor instanceof SecurityTokenService)
                    {
                        List<KeyDescriptor> keyDescriptors = roleDescriptor.getKeyDescriptors();
                        if(!keyDescriptors.isEmpty())
                        {
                            KeyDescriptor keyDescriptor = keyDescriptors.get(0);
                            X509Certificate cert = KeyInfoHelper.getCertificates(keyDescriptor.getKeyInfo()).get(0);
                            String thumbprint = DigestUtils.shaHex(cert.getEncoded());
                            if(thumbprints == null)
                            {
                                thumbprints = new StringBuilder();
                            }
                            else
                            {
                                thumbprints.append("|");
                            }
                            thumbprints.append(thumbprint);
                        }
                    }
                }
                if(thumbprints == null)
                {
                    FederatedConfiguration.getInstance().getProperties().remove(
                            "federation.trustedissuers.thumbprint");
                }
                else
                {
                    FederatedConfiguration.getInstance().getProperties().setProperty(
                            "federation.trustedissuers.thumbprint", thumbprints.toString());
                }
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }
            finally
            {
                this.lastUpdated = lastUpdated;
            }
        }
    }

    /**
     * Checks if federation metadata is enabled.
     *
     * @return true, if this is enabled
     */
    public boolean isEnabled()
    {
        return metadataProvider != null;
    }
}
