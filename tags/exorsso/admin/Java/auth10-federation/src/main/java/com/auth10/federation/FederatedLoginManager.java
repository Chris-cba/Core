//-----------------------------------------------------------------------
// <copyright file="FederatedLoginManager.java" company="Microsoft">
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
// - Added support for multiple thumbprints.
// - Modified FederatedPrincipal constructors
// - Changed method signatures.
// ----------------------------------------------------------------------------------------------

package com.auth10.federation;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.Arrays;
import java.util.Calendar;

import org.joda.time.DateTimeZone;
import org.joda.time.format.DateTimeFormatter;
import org.joda.time.format.ISODateTimeFormat;
import org.opensaml.common.SignableSAMLObject;

public class FederatedLoginManager {
    private static final DateTimeFormatter CHECKING_FORMAT = ISODateTimeFormat.dateTime().withZone(DateTimeZone.UTC);

    private FederatedAuthenticationListener listener;

    public FederatedLoginManager() {
        this(null);
    }

    public FederatedLoginManager(FederatedAuthenticationListener listener) {
        this.listener = listener;
    }

    public final FederatedPrincipal authenticate(String token) throws FederationException {
        SignableSAMLObject samlObject = null;

        try {
            SamlTokenValidator validator = new SamlTokenValidator();

            this.setTrustedIssuers(validator);

            this.setAudienceUris(validator);

            this.setThumbprints(validator);

            samlObject = validator.validate(token);
            if (samlObject == null) {
                throw new FederationException("Invalid Token");
            }

            FederatedPrincipal principal = new FederatedPrincipal(samlObject);

            if (listener != null) listener.OnAuthenticationSucceed(principal);

            return principal;
        } catch (FederationException e) {
            throw e;
        } catch (Exception e) {
            throw new FederationException("Federated Login failed", e);
        }
    }

    private void setTrustedIssuers(SamlTokenValidator validator)
            throws FederationException {
        String[] trustedIssuers = FederatedConfiguration.getInstance().getTrustedIssuers();
        if (trustedIssuers != null) {
            validator.getTrustedIssuers().addAll(Arrays.asList(trustedIssuers));
        }
    }

    private void setAudienceUris(SamlTokenValidator validator)
            throws FederationException {
        String[] audienceUris = FederatedConfiguration.getInstance().getAudienceUris();
        for (String audienceUriStr : audienceUris) {
            try {
                validator.getAudienceUris().add(new URI(audienceUriStr));
            } catch (URISyntaxException e) {
                throw new FederationException("Federated Login Configuration failure: Invalid Audience URI", e);
            }
        }
    }

    private void setThumbprints(SamlTokenValidator validator)
            throws FederationException {
        String[] thumbprints = FederatedConfiguration.getInstance().getThumbprints();
        validator.setThumbprints(thumbprints);
    }

    public static String getFederatedLoginUrl(String returnURL) {
        return getFederatedLoginUrl(null, null, returnURL);
    }

    public static String getFederatedLoginUrl(String realm, String replyURL, String returnURL) {
        Calendar c = Calendar.getInstance();

        String encodedDate = URLUTF8Encoder.encode(CHECKING_FORMAT.print(c.getTimeInMillis()));

        if (realm == null) {
            realm = FederatedConfiguration.getInstance().getRealm();
        }
        String encodedRealm = URLUTF8Encoder.encode(realm);

        String encodedReply = null;
        if (replyURL != null) {
            encodedReply = URLUTF8Encoder.encode(replyURL);
        }
        else {
            encodedReply = (FederatedConfiguration.getInstance().getReply() != null) ? URLUTF8Encoder.encode(FederatedConfiguration.getInstance().getReply()) : null;
        }

        String encodedRequest = (returnURL != null) ? URLUTF8Encoder.encode(returnURL) : "";

        String federatedLoginURL = FederatedConfiguration.getInstance()
                .getStsUrl()
                + "?wa=wsignin1.0&wtrealm="    + encodedRealm
                + "&wctx=" + encodedRequest
                + "&id=passive"
                + "&wct=" + encodedDate;

        if (encodedReply != null) {
            federatedLoginURL += "&wreply=" + encodedReply;
        }

        return federatedLoginURL;
    }
}
