//-----------------------------------------------------------------------
// <copyright file="FederatedConfiguration.java" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
//
//
//    Copyright 2012 Microsoft Corporation
//    All rights reserved.
//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//      http://www.apache.org/licenses/LICENSE-2.0
//
// THIS CODE IS PROVIDED *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OR
// CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABLITY OR NON-INFRINGEMENT.
//
// See the Apache Version 2.0 License for specific language governing
// permissions and limitations under the License.
// </copyright>
//
// <summary>
//
//
// </summary>
//----------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------
// Sunil Kamath, Bentley Systems, Inc., 01-12-2015
// ----------------------------------------------------------------------------------------------
// Modified as follows:
// - Use System properties as backup for federation.properties.
// - Added getter for properties store.
// - Added federation metadata properties.
// - Added active delegation service URI property.
// - Fixed double-check null initialization.
// - Added support for multiple thumbprints.
// - Added DefaultBootstrap initialization.
// ----------------------------------------------------------------------------------------------

package com.auth10.federation;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class FederatedConfiguration {
    private static volatile FederatedConfiguration instance = null;
    private Properties properties;

    public static FederatedConfiguration getInstance() {
        FederatedConfiguration instance = FederatedConfiguration.instance;
        if (instance == null) {
            synchronized (FederatedConfiguration.class) {
                instance = FederatedConfiguration.instance;
                if(instance == null)
                {
                    FederatedConfiguration.instance = instance = load();
                }
            }
        }

        return instance;
    }

    private static FederatedConfiguration load() {
        java.util.Properties props = new java.util.Properties(System.getProperties());

        try {
            InputStream is = FederatedConfiguration.class.getResourceAsStream("/federation.properties");
            if(is != null)
            {
                props.load(is);
            }
        } catch (IOException e) {
            throw new RuntimeException("Configuration could not be loaded", e);
        }

        return new FederatedConfiguration(props);
    }

    public FederatedConfiguration(Properties properties) {
        this.properties = properties;
    }

    public Properties getProperties()
    {
        return properties;
    }

    public String getStsUrl() {
        return this.properties.getProperty("federation.trustedissuers.issuer");
    }

    public String getStsDelegationUrl() {
        return this.properties.getProperty("federation.trustedissuers.delegation");
    }

    public String getStsActiveUrl() {
        return this.properties.getProperty("federation.trustedissuers.active");
    }

    public String getStsFriendlyName() {
        return this.properties.getProperty("federation.trustedissuers.friendlyname");
    }

    public String[] getThumbprints() {
        String thumbprints = this.properties.getProperty("federation.trustedissuers.thumbprint");

        if (thumbprints != null)
            return thumbprints.split("\\|");
        else
            return null;
    }

    public String getRealm() {
        return this.properties.getProperty("federation.realm");
    }

    public String getReply() {
        return this.properties.getProperty("federation.reply");
    }

    public String[] getTrustedIssuers() {
        String trustedIssuers = this.properties.getProperty("federation.trustedissuers.subjectname");

        if (trustedIssuers != null)
            return trustedIssuers.split("\\|");
        else
            return null;
    }

    public String[] getAudienceUris() {
        return this.properties.getProperty("federation.audienceuris").split("\\|");
    }

    public Boolean getEnableManualRedirect() {
        String manual = this.properties.getProperty("federation.enableManualRedirect");
        if (manual != null && Boolean.parseBoolean(manual)) {
            return true;
        }

        return false;
    }

    public String getMetadataUri()
    {
        return properties.getProperty("federation.metadata.uri");
    }

    public String getMetadataEntityID()
    {
        return properties.getProperty("federation.metadata.entityid");
    }

    public int getMetadataTimeout()
    {
        String timeout = this.properties.getProperty("federation.metadata.timeout");
        if (timeout != null) {
            try
            {
                return Integer.parseInt(timeout);
            }
            catch (NumberFormatException e)
            {
            }
        }

        return 0;
    }
}
