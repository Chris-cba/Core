/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/pwdenc/EncryptionKeyStore.java-arc   1.2   May 26 2021 08:39:10   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   EncryptionKeyStore.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   May 26 2021 08:39:10  $
 *		Date Fetched Out : $Modtime:   May 18 2021 11:08:40  $
 *		PVCS Version     : $Revision:   1.2  $
 *
 *	
 *
 ****************************************************************************************************
 *	  Copyright (c) 2021 Bentley Systems Incorporated.  All rights reserved.
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
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			e.printStackTrace(pw);
			String sStackTrace = sw.toString();
			
			return "failure - " + e.getMessage() + "\n" + sStackTrace; 
		}
	}
	
	protected static String getPath() {
		try {
			String jarPath = EncryptionKeyStore.class.getProtectionDomain().getCodeSource().getLocation().toExternalForm();
			
			int beginIndex = jarPath.indexOf('/') + 1;
			int endIndex = jarPath.lastIndexOf('/') + 1;
			
			String keyStorePath = jarPath.substring(beginIndex, endIndex) + "exor_keystore/";
			
			File f = new File(keyStorePath);
			
			if(!f.exists()) {
				boolean keyStoredCreated = f.mkdir();
				
				if(!keyStoredCreated) {
					return "failure - unable to create key store";
				}
			}
			
			return keyStorePath;
		} catch(Exception e) {
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			e.printStackTrace(pw);
			String sStackTrace = sw.toString();
			
			return "failure - " + e.getMessage() + "\n" + sStackTrace; 
		}
	}
		
	public static String createKeyStore(String keyStoreName, String alias, final String keyStr, String keyPasswordStr, String storePasswordStr) {
		try {
			String keyStorePath = getPath();
			
			if(!keyStorePath.startsWith("failure - ")) {
				FileOutputStream fos = null;
				
				try {
					fos = new FileOutputStream(keyStorePath + keyStoreName);
					
					KeyStore ks = KeyStore.getInstance("JCEKS");
					char[] storePasswordChrArr = storePasswordStr.toCharArray();
					ks.load(null, storePasswordChrArr);
					
					Key key = new Key() {
						private static final long serialVersionUID = 1234567890L;
						
						@Override
						public String getAlgorithm() {
							return keyStr;
						}
						
						@Override
						public byte[] getEncoded() {
							return new byte[0];
						}
						
						@Override
						public String getFormat() {
							return null;
						}
					};
					
					ks.setKeyEntry(alias, key, keyPasswordStr.toCharArray(), null);
					
					ks.store(fos, storePasswordChrArr);
					
					fos.flush();
				} finally {
					if(fos != null) {
						try {
							fos.close();
						} catch(IOException ioe) {
						}
					}
				}
				
				return "success";
			} else {
				return keyStorePath;
			}
		} catch(Exception e) {
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			e.printStackTrace(pw);
			String sStackTrace = sw.toString();
			
			return "failure - " + e.getMessage() + "\n" + sStackTrace; 
		}
	}
	
	public static String getKey(String keyStoreName, String alias, String keyPasswordStr, String storePasswordStr) {
		try {
			String keyStorePath = getPath();
			
			if(!keyStorePath.startsWith("failure - ")) { 
				KeyStore ks = KeyStore.getInstance("JCEKS");
				FileInputStream fis = null;
				
				try {
					fis = new FileInputStream(keyStorePath + keyStoreName);
					ks.load(fis, storePasswordStr.toCharArray());
				} finally {
					if(fis != null) {
						try {
							fis.close();
						} catch(IOException ioe) {
						}
					}
				} 
				
				String prop = Security.getProperty("jceks.key.serialFilter"); 
				prop = prop.substring(0, prop.length() - 2); 
				
				Security.setProperty("jceks.key.serialFilter", prop + "bentley.exor.pwdenc.EncryptionKeyStore$1;!*"); 
				
				return ks.getKey(alias, keyPasswordStr.toCharArray()).getAlgorithm();
			} else {
				return keyStorePath;
			}
		} catch(Exception e) { 
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			e.printStackTrace(pw);
			String sStackTrace = sw.toString();
			
			return "failure - " + e.getMessage() + "\n" + sStackTrace; 
		}
	}
}
