/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/pwdenc/AESEncryptDecryptProvider.java-arc   1.2   May 26 2021 08:38:52   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   AESEncryptDecryptProvider.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   May 26 2021 08:38:52  $
 *		Date Fetched Out : $Modtime:   May 18 2021 11:13:32  $
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

import bentley.exor.ExorDebugger; 

import java.security.Key;
import java.security.SecureRandom;
import java.security.Security;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec; 
import javax.crypto.spec.GCMParameterSpec; 

import org.apache.commons.codec.binary.Base64;
import java.io.StringWriter;
import java.io.PrintWriter; 
import java.util.Arrays; 
import java.nio.ByteBuffer; 

public class AESEncryptDecryptProvider { 
	private static final SecureRandom random = new SecureRandom(); 
	 
    public static final int GCM_IV_LENGTH = 12;
    public static final int GCM_TAG_LENGTH = 16;

	public static String encryptString(String plaintext, String key) {
		try {
			return Base64.encodeBase64String(encrypt(plaintext, key));
		} catch(Exception e) { 
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			e.printStackTrace(pw);
			String sStackTrace = sw.toString();
			
			return "ORA-20099: " + e.getMessage() + "\n" + sStackTrace; 
		}
	}
	
	public static String decryptString(String encryptedText, String key) {
		try {
			return decrypt(Base64.decodeBase64(encryptedText), key);
		} catch(Exception e) { 
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			e.printStackTrace(pw);
			String sStackTrace = sw.toString();
			
			return "ORA-20099: " + e.getMessage() + "\n" + sStackTrace; 
		}
	}
	
    private static byte[] encrypt(String inputText, String key) throws Exception {
		Key aesKey = new SecretKeySpec(key.getBytes("UTF-8"), "AES");
		Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
		
		byte [] ivBytes = new byte[GCM_IV_LENGTH];
        random.nextBytes(ivBytes);
		
		GCMParameterSpec gcmParameterSpec = new GCMParameterSpec(GCM_TAG_LENGTH * 8, ivBytes);
		
		cipher.init(Cipher.ENCRYPT_MODE, aesKey, gcmParameterSpec); 
		byte[] encryptedBytes = cipher.doFinal(inputText.getBytes("UTF-8")); 
		
		return ByteBuffer.allocate(ivBytes.length + encryptedBytes.length)
            .put(ivBytes)
            .put(encryptedBytes)
            .array(); 
    }
	
	private static String decrypt(byte[] encrypted, String key) throws Exception {
		Key aesKey = new SecretKeySpec(key.getBytes("UTF-8"), "AES");
		Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
		
		GCMParameterSpec gcmParameterSpec = new GCMParameterSpec(GCM_TAG_LENGTH * 8, Arrays.copyOfRange(encrypted, 0, 12));
		
		cipher.init(Cipher.DECRYPT_MODE, aesKey, gcmParameterSpec); 
		
		return new String(cipher.doFinal(Arrays.copyOfRange(encrypted, 12, encrypted.length)), "UTF-8"); 
    } 
}