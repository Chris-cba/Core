//-----------------------------------------------------------------------
// <copyright file="SamlTokenValidator.java" company="Microsoft">
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
// - Use SecurityHelper instead of deprecated SecurityTestHelper
// - Removed explicit casts.
// - Removed DefaultBootstrap initialization.
// - Added support for multiple thumbprints.
// - Converted static methods to instance methods.
// - Added metadata refresh if thumbprint does not match.
// - Modified validate() to return SAML object.
// - Removed getClaims() and getValueFrom() methods.
// - Added support for deserializing SAML 1.0 token.
// ----------------------------------------------------------------------------------------------

package com.auth10.federation;

import java.io.IOException;
import java.io.StringReader;
import java.net.URI;
import java.net.URISyntaxException;
import java.security.KeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateEncodingException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;

import org.joda.time.Duration;
import org.joda.time.Instant;
import org.opensaml.Configuration;
import org.opensaml.common.SignableSAMLObject;
import org.opensaml.xml.ConfigurationException;
import org.opensaml.xml.XMLObject;
import org.opensaml.xml.io.Unmarshaller;
import org.opensaml.xml.io.UnmarshallingException;
import org.opensaml.xml.security.CriteriaSet;
import org.opensaml.xml.security.SecurityException;
import org.opensaml.xml.security.SecurityHelper;
import org.opensaml.xml.security.credential.CollectionCredentialResolver;
import org.opensaml.xml.security.credential.Credential;
import org.opensaml.xml.security.criteria.EntityIDCriteria;
import org.opensaml.xml.security.keyinfo.KeyInfoCredentialResolver;
import org.opensaml.xml.security.keyinfo.KeyInfoHelper;
import org.opensaml.xml.security.x509.BasicX509Credential;
import org.opensaml.xml.signature.KeyInfo;
import org.opensaml.xml.signature.Signature;
import org.opensaml.xml.signature.impl.ExplicitKeySignatureTrustEngine;
import org.opensaml.xml.validation.ValidationException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

public class SamlTokenValidator {
    public static final int MAX_CLOCK_SKEW_IN_MINUTES = 3;
    private List<String> trustedIssuers;
    private List<URI> audienceUris;
    private boolean validateExpiration = true;
    private String[] thumbprints;

    public SamlTokenValidator() throws ConfigurationException {
        this(new ArrayList<String>(), new ArrayList<URI>());
    }

    public SamlTokenValidator(List<String> trustedIssuers,
            List<URI> audienceUris) throws ConfigurationException {
        super();
        this.trustedIssuers = trustedIssuers;
        this.audienceUris = audienceUris;
    }

    public List<String> getTrustedIssuers() {
        return this.trustedIssuers;
    }

    public void setTrustedIssuers(List<String> trustedIssuers) {
        this.trustedIssuers = trustedIssuers;
    }

    public List<URI> getAudienceUris() {
        return this.audienceUris;
    }

    public void setAudienceUris(List<URI> audienceUris) {
        this.audienceUris = audienceUris;
    }

    public boolean getValidateExpiration() {
        return validateExpiration;
    }

    public void setValidateExpiration(boolean value) {
        this.validateExpiration = value;
    }

    public SignableSAMLObject validate(String envelopedToken)
            throws ParserConfigurationException, SAXException, IOException,
            FederationException, ConfigurationException, CertificateException,
            KeyException, SecurityException, ValidationException,
            UnmarshallingException, URISyntaxException,
            NoSuchAlgorithmException {

        SignableSAMLObject samlToken;

        if (envelopedToken.contains("RequestSecurityTokenResponse")) {
            samlToken = getSamlTokenFromRstr(envelopedToken);
        } else {
            samlToken = getSamlTokenFromSamlResponse(envelopedToken);
        }

        boolean valid = validateToken(samlToken);

        if (!valid) {
            throw new FederationException("Invalid signature");
        }

        boolean trusted = false;

        for (String issuer : this.trustedIssuers) {
            trusted |= validateIssuerUsingSubjectName(samlToken, issuer);
        }

        if (!trusted && (this.thumbprints != null)) {
            trusted = validateIssuerUsingCertificateThumbprint(samlToken);
        }

        if (!trusted) {
            throw new FederationException(
                    "The token was issued by an authority that is not trusted");
        }

        String address = null;
        if (samlToken instanceof org.opensaml.saml1.core.Assertion) {
            address = getAudienceUri((org.opensaml.saml1.core.Assertion) samlToken);
        }

        if (samlToken instanceof org.opensaml.saml2.core.Assertion) {
            address = getAudienceUri((org.opensaml.saml2.core.Assertion) samlToken);
        }

        URI audience = new URI(address);

        boolean validAudience = false;
        for (URI audienceUri : audienceUris) {
            validAudience |= audience.equals(audienceUri);
        }

        if (!validAudience) {
            throw new FederationException(String.format("The token applies to an untrusted audience: %s", new Object[] { audience }));
        }

        if (this.validateExpiration) {

            boolean expired = false;
            if (samlToken instanceof org.opensaml.saml1.core.Assertion) {
                Instant notBefore = ((org.opensaml.saml1.core.Assertion) samlToken).getConditions().getNotBefore().toInstant();
                Instant notOnOrAfter = ((org.opensaml.saml1.core.Assertion) samlToken).getConditions().getNotOnOrAfter().toInstant();
                expired = validateExpiration(notBefore, notOnOrAfter);
            }

            if (samlToken instanceof org.opensaml.saml2.core.Assertion) {
                Instant notBefore = ((org.opensaml.saml2.core.Assertion) samlToken).getConditions().getNotBefore().toInstant();
                Instant notOnOrAfter = ((org.opensaml.saml2.core.Assertion) samlToken).getConditions().getNotOnOrAfter().toInstant();
                expired = validateExpiration(notBefore, notOnOrAfter);
            }

            if (expired) {
                throw new FederationException("The token has expired");
            }
        }

        return samlToken;
    }

    private SignableSAMLObject getSamlTokenFromSamlResponse(
            String samlResponse) throws ParserConfigurationException,
            SAXException, IOException, UnmarshallingException {
        Document document = getDocument(samlResponse);

        Unmarshaller unmarshaller = Configuration.getUnmarshallerFactory().getUnmarshaller(document.getDocumentElement());
        XMLObject object = unmarshaller.unmarshall(document.getDocumentElement());
        SignableSAMLObject samlToken = null;
        if(object instanceof org.opensaml.saml1.core.Response)
        {
            org.opensaml.saml1.core.Response response = (org.opensaml.saml1.core.Response) object;
            samlToken = response.getAssertions().get(0);
        }
        else if(object instanceof org.opensaml.saml2.core.Response)
        {
            org.opensaml.saml2.core.Response response = (org.opensaml.saml2.core.Response) object;
            samlToken = response.getAssertions().get(0);
        }
        else if(object instanceof SignableSAMLObject)
        {
            samlToken = (SignableSAMLObject)object;
        }

        return samlToken;
    }

    private SignableSAMLObject getSamlTokenFromRstr(String rstr)
            throws ParserConfigurationException, SAXException, IOException,
            UnmarshallingException, FederationException {
        Document document = getDocument(rstr);

        String xpath = "//*[local-name() = 'Assertion']";

        NodeList nodes = null;

        try {
            nodes = org.apache.xpath.XPathAPI.selectNodeList(document, xpath);
        } catch (TransformerException e) {
            e.printStackTrace();
        }

        if (nodes.getLength() == 0) {
            throw new FederationException("SAML token was not found");
        }

        Element samlTokenElement = (Element) nodes.item(0);
        Unmarshaller unmarshaller = Configuration.getUnmarshallerFactory().getUnmarshaller(samlTokenElement);
        SignableSAMLObject samlToken = (SignableSAMLObject) unmarshaller.unmarshall(samlTokenElement);

        return samlToken;
    }

    private String getAudienceUri(
            org.opensaml.saml2.core.Assertion samlAssertion) {
        org.opensaml.saml2.core.Audience audienceUri = samlAssertion.getConditions().getAudienceRestrictions().get(0)
                .getAudiences().get(0);
        return audienceUri.getAudienceURI();
    }

    private String getAudienceUri(org.opensaml.saml1.core.Assertion samlAssertion) {

        org.opensaml.saml1.core.Audience audienceUri = samlAssertion.getConditions().getAudienceRestrictionConditions().get(0).getAudiences().get(0);
        return audienceUri.getUri();
    }

    public static boolean validateExpiration(Instant notBefore, Instant notOnOrAfter) {

        Instant now = new Instant();
        Duration skew = new Duration(MAX_CLOCK_SKEW_IN_MINUTES * 60 * 1000);

        if (now.plus(skew).isBefore(notBefore)) {
            return true;
        }

        if (now.minus(skew).isAfter(notOnOrAfter)) {
            return true;
        }

        return false;
    }

    private boolean validateToken(SignableSAMLObject samlToken)
            throws SecurityException, ValidationException,
            ConfigurationException, UnmarshallingException,
            CertificateException, KeyException {

        samlToken.validate(true);
        Signature signature = samlToken.getSignature();
        KeyInfo keyInfo = signature.getKeyInfo();
        X509Certificate pubKey = KeyInfoHelper
                .getCertificates(keyInfo).get(0);

        BasicX509Credential cred = new BasicX509Credential();
        cred.setEntityCertificate(pubKey);
        cred.setEntityId("signing-entity-ID");

        ArrayList<Credential> trustedCredentials = new ArrayList<Credential>();
        trustedCredentials.add(cred);

        CollectionCredentialResolver credResolver = new CollectionCredentialResolver(
                trustedCredentials);

        KeyInfoCredentialResolver kiResolver = SecurityHelper.buildBasicInlineKeyInfoResolver();
        ExplicitKeySignatureTrustEngine engine = new ExplicitKeySignatureTrustEngine(
                credResolver, kiResolver);

        CriteriaSet criteriaSet = new CriteriaSet();
        criteriaSet.add(new EntityIDCriteria("signing-entity-ID"));

        return engine.validate(signature, criteriaSet);
    }

    private boolean validateIssuerUsingSubjectName(
            SignableSAMLObject samlToken, String subjectName)
            throws UnmarshallingException, ValidationException,
            CertificateException {

        Signature signature = samlToken.getSignature();
        KeyInfo keyInfo = signature.getKeyInfo();
        X509Certificate pubKey = KeyInfoHelper.getCertificates(keyInfo).get(0);

        String issuer = pubKey.getSubjectDN().getName();
        return issuer.equals(subjectName);
    }

    private boolean validateIssuerUsingCertificateThumbprint(
            SignableSAMLObject samlToken)
            throws UnmarshallingException, ValidationException,
            CertificateException, NoSuchAlgorithmException {

        Signature signature = samlToken.getSignature();
        KeyInfo keyInfo = signature.getKeyInfo();
        X509Certificate pubKey = KeyInfoHelper.getCertificates(keyInfo).get(0);

        String thumbprintFromToken = getThumbPrintFromCert(pubKey);

        boolean valid = validateThumbprint(thumbprintFromToken);
        if(!valid)
        {
            FederationMetadata metadata = FederationMetadata.getInstance();
            if(metadata.isEnabled())
            {
                metadata.refresh();
                metadata.updateThumbprints();
                setThumbprints(FederatedConfiguration.getInstance().getThumbprints());
                valid = validateThumbprint(thumbprintFromToken);
            }
        }
        return valid;
    }

    public boolean validateThumbprint(String thumbprintFromToken)
    {
        for(String thumbprint : this.thumbprints)
        {
            if(thumbprintFromToken.equalsIgnoreCase(thumbprint))
            {
                return true;
            }
        }
        return false;
    }

    private String getThumbPrintFromCert(X509Certificate cert)
            throws NoSuchAlgorithmException, CertificateEncodingException {

        MessageDigest md = MessageDigest.getInstance("SHA-1");
        byte[] der = cert.getEncoded();
        md.update(der);
        byte[] digest = md.digest();
        return hexify(digest);
    }

    private String hexify(byte bytes[]) {
        char[] hexDigits = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                'a', 'b', 'c', 'd', 'e', 'f' };

        StringBuffer buf = new StringBuffer(bytes.length * 2);

        for (int i = 0; i < bytes.length; ++i) {
            buf.append(hexDigits[(bytes[i] & 0xf0) >> 4]);
            buf.append(hexDigits[bytes[i] & 0x0f]);
        }

        return buf.toString();
    }

    private Document getDocument(String doc)
            throws ParserConfigurationException, SAXException, IOException {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(true);
        DocumentBuilder documentbuilder = factory.newDocumentBuilder();
        return documentbuilder.parse(new InputSource(new StringReader(doc)));
    }

    public void setThumbprints(String ... thumbprints) {
        this.thumbprints = thumbprints;
    }

    public String[] getThumbprints() {
        return thumbprints;
    }
}
