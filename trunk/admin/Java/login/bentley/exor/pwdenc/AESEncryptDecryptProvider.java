/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/pwdenc/AESEncryptDecryptProvider.java-arc   1.0   Feb 27 2017 07:05:52   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   AESEncryptDecryptProvider.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   Feb 27 2017 07:05:52  $
 *		Date Fetched Out : $Modtime:   Feb 20 2017 10:21:28  $
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

import bentley.exor.ExorDebugger;

import java.security.Key;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import javax.crypto.spec.IvParameterSpec;

import sun.misc.*;

public class AESEncryptDecryptProvider {
    public static String encrypt(String inputText, String key) {
		try {
			// Create key and cipher
			Key aesKey = new SecretKeySpec(key.getBytes(), "AES");
			Cipher cipher = Cipher.getInstance("AES");
			
			// encrypt the inputText
			cipher.init(Cipher.ENCRYPT_MODE, aesKey);
			byte[] encrypted = cipher.doFinal(inputText.getBytes());
			return new BASE64Encoder().encode(encrypted);
		}catch(Exception e) {
			e.printStackTrace();
			
			return "ORA-20099: " + e.getMessage();
		}
    }
	
	public static String decrypt(String encryptedText, String key) {
		try {
			// Create key and cipher
			Key aesKey = new SecretKeySpec(key.getBytes(), "AES");
			Cipher cipher = Cipher.getInstance("AES");
			
			// decrypt the encryptedText
			cipher.init(Cipher.DECRYPT_MODE, aesKey);
			String decrypted = new String(cipher.doFinal(new BASE64Decoder().decodeBuffer(encryptedText)));
			return decrypted;
		}catch(Exception e) {
			e.printStackTrace();
			
			return "ORA-20099: " + e.getMessage();
		}
    }
}