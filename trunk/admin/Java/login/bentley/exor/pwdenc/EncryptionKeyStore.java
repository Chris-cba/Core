/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/pwdenc/EncryptionKeyStore.java-arc   1.0   Feb 27 2017 07:05:52   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   EncryptionKeyStore.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   Feb 27 2017 07:05:52  $
 *		Date Fetched Out : $Modtime:   Feb 23 2017 11:26:36  $
 *		PVCS Version     : $Revision:   1.0  $
 *
 *	
 *
 ****************************************************************************************************
 *	  Copyright (c) 2017 Bentley Systems Incorporated.  All rights reserved.
 ****************************************************************************************************
 *
 */

package bentley.exor.pwdenc;

import java.io.*;

import java.security.*;


public class EncryptionKeyStore {
	public static String checkUserKey() {
		try {
			String keyStorePath = getPath() + "exor_sso_key.jks";
			
			File f = new File(keyStorePath);
			if(f.exists()) {
				return "success";
			} else {
				return "failure - key store not found";
			}
		} catch(Exception e) {
			return "failure - " + e.getMessage();
		}
	}
	
	protected static String getPath() {
		try {
			EncryptionKeyStore eks = new EncryptionKeyStore();
			
			String jarPath = eks.getClass().getProtectionDomain().getCodeSource().getLocation().toExternalForm();
			
			int beginIndex = jarPath.indexOf("/") + 1;
			int endIndex = jarPath.lastIndexOf("/") + 1;
			
			String keyStorePath = jarPath.substring(beginIndex, endIndex) + "exor_keystore/";
			
			File f = new File(keyStorePath);
			if(!f.exists()) {
				f.mkdir();
			}
			
			return keyStorePath;
		} catch(Exception e) {
			return "failure - " + e.getMessage();
		}
	}
		
	public static String createKeyStore(String keyStoreName, String alias, final String keyStr, String keyPasswordStr, String storePasswordStr) {
		try {
			String keyStorePath = getPath();
			
			if(!keyStorePath.startsWith("failure - ")) {
				FileOutputStream fos = new FileOutputStream(keyStorePath + keyStoreName);
				
				KeyStore ks = KeyStore.getInstance("JCEKS");
				ks.load(null, storePasswordStr.toCharArray());
				
				Key key = new Key() {
					public static final long serialVersionUID = 1234567890L;
					
					@Override
					public String getAlgorithm() {
						return keyStr;
					}
					
					@Override
					public byte[] getEncoded() {
						return null;
					}
					
					@Override
					public String getFormat() {
						return null;
					}
				};
				
				ks.setKeyEntry(alias, key, keyPasswordStr.toCharArray(), null);
				
				ks.store(fos, storePasswordStr.toCharArray());
				
				fos.flush();
				fos.close();
				
				return "success";
			} else {
				return keyStorePath;
			}
		} catch(Exception e) {
			return "failure - " + e.getMessage();
		}
	}
	
	public static String getKey(String keyStoreName, String alias, String keyPasswordStr, String storePasswordStr) {
		try {
			String keyStorePath = getPath();
			
			if(!keyStorePath.startsWith("failure - ")) {
				KeyStore ks = KeyStore.getInstance("JCEKS");
				FileInputStream fis = new FileInputStream(keyStorePath + keyStoreName);
				ks.load(fis, storePasswordStr.toCharArray());
				
				fis.close();
				
				return ks.getKey(alias, keyPasswordStr.toCharArray()).getAlgorithm();
			} else {
				return keyStorePath;
			}
		} catch(Exception e) {
			return "failure - " + e.getMessage();
		}
	}
}
