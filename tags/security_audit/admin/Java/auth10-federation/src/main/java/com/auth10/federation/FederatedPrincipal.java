//-----------------------------------------------------------------------
// <copyright file="FederatedPrincipal.java" company="Microsoft">
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
// - Modified constructor to accept SAML object.
// - Added extraction of claims.
// - Added extraction of validity times and expiration test.
// - Removed getClaims() and getValueFrom() methods.
// ----------------------------------------------------------------------------------------------

package com.auth10.federation;

import java.security.KeyException;
import java.security.Principal;
import java.security.cert.CertificateException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.joda.time.Instant;
import org.opensaml.common.SignableSAMLObject;
import org.opensaml.xml.ConfigurationException;
import org.opensaml.xml.XMLObject;
import org.opensaml.xml.io.UnmarshallingException;
import org.opensaml.xml.security.SecurityException;
import org.opensaml.xml.validation.ValidationException;

public class FederatedPrincipal implements Principal {
    private static final String NameClaimType = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name";
    private static final String EmailClaimType = "http://schemas.xmlsoap.org/claims/EmailAddress";

    private SignableSAMLObject samlObject;
    private volatile List<Claim> claims = null;
    private volatile Instant notValidBefore = null;
    private volatile Instant notValidOnOrAfter = null;

    public FederatedPrincipal(SignableSAMLObject samlObject) {
        this.samlObject = samlObject;
    }

    @Override
    public String getName() {
        String name = "";

        List<Claim> claims = getClaims();

        for (Claim claim : claims) {
            if (claim.getClaimType().equals(NameClaimType))
                name = claim.getClaimValue();
        }

        if (name.isEmpty()){
            for (Claim claim : claims) {
                if (claim.getClaimType().equals(EmailClaimType))
                    name = claim.getClaimValue();
            }
        }

        return name;
    }

    public SignableSAMLObject getSamlObject()
    {
        return samlObject;
    }

    public Instant getNotValidBefore()
    {
        Instant notValidBefore = this.notValidBefore;
        if(notValidBefore == null)
        {
            synchronized (this)
            {
                notValidBefore = this.notValidBefore;
                if(notValidBefore == null)
                {
                    if (samlObject instanceof org.opensaml.saml1.core.Assertion) {
                        notValidBefore = ((org.opensaml.saml1.core.Assertion) samlObject).getConditions().getNotBefore().toInstant();
                    }

                    if (samlObject instanceof org.opensaml.saml2.core.Assertion) {
                        notValidBefore = ((org.opensaml.saml2.core.Assertion) samlObject).getConditions().getNotBefore().toInstant();
                    }

                }
            }
        }
        return notValidBefore;
    }

    public Instant getNotValidOnOrAfter()
    {
        Instant notValidOnOrAfter = this.notValidOnOrAfter;
        if(notValidOnOrAfter == null)
        {
            synchronized (this)
            {
                notValidOnOrAfter = this.notValidOnOrAfter;
                if(notValidOnOrAfter == null)
                {
                    if (samlObject instanceof org.opensaml.saml1.core.Assertion) {
                        notValidOnOrAfter = ((org.opensaml.saml1.core.Assertion) samlObject).getConditions().getNotOnOrAfter().toInstant();
                    }

                    if (samlObject instanceof org.opensaml.saml2.core.Assertion) {
                        notValidOnOrAfter = ((org.opensaml.saml2.core.Assertion) samlObject).getConditions().getNotOnOrAfter().toInstant();
                    }
                }
            }
        }
        return notValidOnOrAfter;
    }

    public boolean isExpired()
    {
        return SamlTokenValidator.validateExpiration(getNotValidBefore(), getNotValidOnOrAfter());
    }

    public List<Claim> getClaims() {
        List<Claim> claims = this.claims;
        if(claims == null)
        {
            synchronized (this)
            {
                claims = this.claims;
                if(claims == null)
                {
                    try
                    {
                        if (samlObject instanceof org.opensaml.saml1.core.Assertion)
                        {
                            claims = getClaims((org.opensaml.saml1.core.Assertion) samlObject);
                        }
                        if (samlObject instanceof org.opensaml.saml2.core.Assertion)
                        {
                            claims = getClaims((org.opensaml.saml2.core.Assertion) samlObject);
                        }
                    }
                    catch (Exception e)
                    {
                        claims = null;
                    }
                    this.claims = claims = claims == null?Collections.<Claim>emptyList():Collections.<Claim>unmodifiableList(claims);
                }
            }
        }
        return claims;
    }

    private List<Claim> getClaims(
            org.opensaml.saml2.core.Assertion samlAssertion)
            throws SecurityException, ValidationException,
            ConfigurationException, UnmarshallingException,
            CertificateException, KeyException {

        ArrayList<Claim> claims = new ArrayList<Claim>();

        List<org.opensaml.saml2.core.AttributeStatement> attributeStmts = samlAssertion
                .getAttributeStatements();

        for (org.opensaml.saml2.core.AttributeStatement attributeStmt : attributeStmts) {
            List<org.opensaml.saml2.core.Attribute> attributes = attributeStmt
                    .getAttributes();

            for (org.opensaml.saml2.core.Attribute attribute : attributes) {
                String claimType = attribute.getName();
                String claimValue = getValueFrom(attribute.getAttributeValues());
                claims.add(new Claim(claimType, claimValue));
            }
        }

        return claims;
    }

    private List<Claim> getClaims(
            org.opensaml.saml1.core.Assertion samlAssertion)
            throws SecurityException, ValidationException,
            ConfigurationException, UnmarshallingException,
            CertificateException, KeyException {

        ArrayList<Claim> claims = new ArrayList<Claim>();

        List<org.opensaml.saml1.core.AttributeStatement> attributeStmts = samlAssertion.getAttributeStatements();

        for (org.opensaml.saml1.core.AttributeStatement attributeStmt : attributeStmts) {
            List<org.opensaml.saml1.core.Attribute> attributes = attributeStmt.getAttributes();

            for (org.opensaml.saml1.core.Attribute attribute : attributes) {
                String claimType = attribute.getAttributeNamespace() + "/" + attribute.getAttributeName();
                String claimValue = getValueFrom(attribute.getAttributeValues());
                claims.add(new Claim(claimType, claimValue));
            }
        }

        return claims;
    }

    private String getValueFrom(List<XMLObject> attributeValues) {

        StringBuffer buffer = new StringBuffer();

        for (XMLObject value : attributeValues) {
            if (buffer.length() > 0)
                buffer.append(',');
            buffer.append(value.getDOM().getTextContent());
        }

        return buffer.toString();
    }
}
