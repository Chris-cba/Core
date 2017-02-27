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

import java.io.StringWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.client.Entity;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.http.HttpHeaders;
import org.apache.http.client.HttpClient;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.PoolingClientConnectionManager;
import org.jboss.resteasy.client.jaxrs.ResteasyClient;
import org.jboss.resteasy.client.jaxrs.ResteasyClientBuilder;
import org.jboss.resteasy.client.jaxrs.ResteasyWebTarget;
import org.jboss.resteasy.client.jaxrs.engines.ApacheHttpClient4Engine;
import org.opensaml.Configuration;
import org.opensaml.common.SignableSAMLObject;
import org.opensaml.xml.io.Marshaller;
import org.opensaml.xml.util.Base64;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

public class WSFederationActive
{
    /**
     * Singleton instance.
     */
    private static final WSFederationActive instance = new WSFederationActive();

    /**
     * Returns the singleton instance of SamlTokenRenewer.
     *
     * @return The singleton instance.
     */
    public static final WSFederationActive getInstance()
    {
        return instance;
    }

    private ResteasyClient client;

    /**
     * Singleton, hence private.
     */
    private WSFederationActive()
    {
        ClientConnectionManager cm = new PoolingClientConnectionManager();
        final HttpClient httpClient = new DefaultHttpClient(cm);
        ApacheHttpClient4Engine engine = new ApacheHttpClient4Engine(httpClient);
        client = new ResteasyClientBuilder().httpEngine(engine).build();
        Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
            @Override
            public void run()
            {
                if(client != null)
                {
                    client.close();
                }
                httpClient.getConnectionManager().shutdown();
            }
        }));
    }

    public FederatedPrincipal renewPrincipal(HttpServletRequest request, HttpServletResponse response, FederatedPrincipal principal) throws Exception
    {
        SignableSAMLObject samlObject = principal.getSamlObject();
        Marshaller marshaller = Configuration.getMarshallerFactory().getMarshaller(samlObject);
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(true);
        DocumentBuilder documentbuilder = factory.newDocumentBuilder();
        Document doc = documentbuilder.newDocument();
        marshaller.marshall(samlObject, doc);
        DOMSource domSource = new DOMSource(doc);
        StringWriter writer = new StringWriter();
        StreamResult result = new StreamResult(writer);
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer transformer = tf.newTransformer();
        transformer.transform(domSource, result);
        String tokenString = writer.toString();

        NodeList nodes = doc.getElementsByTagName("X509Certificate");
        if(nodes.getLength() > 0)
        {
            String certString = nodes.item(0).getTextContent();
            byte[] cert = certString.getBytes("US-ASCII");
            String authHeader = "X509 access_token="+Base64.encodeBytes(cert, Base64.DONT_BREAK_LINES);

            RequestSecurityToken rsToken = new RequestSecurityToken();
            rsToken.AppliesTo = rsToken.AppliesToBootstrapToken = FederatedConfiguration.getInstance().getRealm();
            rsToken.KeyType = "Symmetric";
            rsToken.OnBehalfOf = tokenString;

            ResteasyWebTarget target = client.target(FederatedConfiguration.getInstance().getStsDelegationUrl() + "json/IssueEx");
            Response resp = target.request(MediaType.APPLICATION_JSON).header(HttpHeaders.AUTHORIZATION, authHeader).post(Entity.json(rsToken));

            RequestSecurityTokenResponse rstResponse = resp.readEntity(RequestSecurityTokenResponse.class);

            FederatedLoginManager loginManager = new FederatedLoginManager();

            return loginManager.authenticate(rstResponse.RequestedSecurityToken);
        }
        return null;
    }
}
