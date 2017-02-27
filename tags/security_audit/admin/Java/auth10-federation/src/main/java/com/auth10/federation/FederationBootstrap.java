package com.auth10.federation;

import org.opensaml.DefaultBootstrap;
import org.opensaml.xml.Configuration;

import be.fedict.eid.idp.protocol.ws_federation.wsfed.ClaimType;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.ClaimTypeBuilder;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.ClaimTypeMarshaller;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.ClaimTypeUnmarshaller;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.ClaimTypesOffered;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.ClaimTypesOfferedBuilder;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.ClaimTypesOfferedMarshaller;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.ClaimTypesOfferedUnmarshaller;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.Description;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.DescriptionBuilder;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.DescriptionMarshaller;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.DescriptionUnmarshaller;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.DisplayName;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.DisplayNameBuilder;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.DisplayNameMarshaller;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.DisplayNameUnmarshaller;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.PassiveRequestorEndpoint;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.PassiveRequestorEndpointBuilder;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.PassiveRequestorEndpointMarshaller;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.PassiveRequestorEndpointUnmarshaller;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.SecurityTokenService;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.SecurityTokenServiceBuilder;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.SecurityTokenServiceMarshaller;
import be.fedict.eid.idp.protocol.ws_federation.wsfed.SecurityTokenServiceUnmarshaller;

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

/**
 * Bootstrapper for the Federation library.
 */
public class FederationBootstrap {
	private static volatile boolean initialized = false;
	private static ThreadLocal<Boolean> initThread = new ThreadLocal<Boolean>();

	/**
	 * Bootstrap the Federation library.
	 */
	public static final void bootstrap()
	{
		if(Boolean.TRUE.equals(initThread.get()))
		{
			return;
		}
		if(!initialized)
		{
			synchronized (FederationBootstrap.class) {
				if(!initialized)
				{
					try {
						initThread.set(Boolean.TRUE);

						/*
						 * Next is because of a bug in Java 8. Apparently it is fixed in Java 9.
						 * We will have to wait and see.
						 * See https://bugs.openjdk.java.net/browse/JDK-8133196
						 */
				        System.setProperty("jdk.tls.trustNameService",String.valueOf(true));

				        /*
				         * Next is because Sun loves to endorse crippled versions of Xerces.
				         */
				        System.setProperty("javax.xml.validation.SchemaFactory:http://www.w3.org/2001/XMLSchema",
				                "org.apache.xerces.jaxp.validation.XMLSchemaFactory");

				        // register WS-Federation Metadata elements
				        Configuration.registerObjectProvider(
				                ClaimType.DEFAULT_ELEMENT_NAME,
				                new ClaimTypeBuilder(),
				                new ClaimTypeMarshaller(),
				                new ClaimTypeUnmarshaller());

				        Configuration.registerObjectProvider(
				                ClaimTypesOffered.DEFAULT_ELEMENT_NAME,
				                new ClaimTypesOfferedBuilder(),
				                new ClaimTypesOfferedMarshaller(),
				                new ClaimTypesOfferedUnmarshaller());

				        Configuration.registerObjectProvider(
				                Description.DEFAULT_ELEMENT_NAME,
				                new DescriptionBuilder(),
				                new DescriptionMarshaller(),
				                new DescriptionUnmarshaller());

				        Configuration.registerObjectProvider(
				                DisplayName.DEFAULT_ELEMENT_NAME,
				                new DisplayNameBuilder(),
				                new DisplayNameMarshaller(),
				                new DisplayNameUnmarshaller());

				        Configuration.registerObjectProvider(
				                PassiveRequestorEndpoint.DEFAULT_ELEMENT_NAME,
				                new PassiveRequestorEndpointBuilder(),
				                new PassiveRequestorEndpointMarshaller(),
				                new PassiveRequestorEndpointUnmarshaller());

				        Configuration.registerObjectProvider(
				                SecurityTokenService.DEFAULT_ELEMENT_NAME,
				                new SecurityTokenServiceBuilder(),
				                new SecurityTokenServiceMarshaller(),
				                new SecurityTokenServiceUnmarshaller());

				        Configuration.registerObjectProvider(
				                SecurityTokenService.TYPE_NAME,
				                new SecurityTokenServiceBuilder(),
				                new SecurityTokenServiceMarshaller(),
				                new SecurityTokenServiceUnmarshaller());
				        DefaultBootstrap.bootstrap();
					}
					catch (Exception e) {
			            throw new RuntimeException("Could not bootstrap the Federation library", e);
			        }
					finally {
						initialized = true;
						initThread.remove();
					}
				}
			}
		}
	}
}
