/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/pwdenc/AESEncryptDecryptProvider.java-arc   1.1   Sep 07 2017 14:39:10   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   AESEncryptDecryptProvider.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   Sep 07 2017 14:39:10  $
 *		Date Fetched Out : $Modtime:   Sep 04 2017 15:55:26  $
 *		PVCS Version     : $Revision:   1.1  $
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
import java.security.SecureRandom;
import java.security.Security;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import javax.crypto.spec.IvParameterSpec;

import org.apache.commons.codec.binary.Base64;

import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.util.Arrays;

public class AESEncryptDecryptProvider {
	private static final SecureRandom random = new SecureRandom();
	
	static {
		Security.addProvider(new BouncyCastleProvider());
	}
	
	public static String encryptString(String plaintext, String key) {
		try {
			return Base64.encodeBase64String(encrypt(plaintext, key));
		} catch(Exception e) {
			return "ORA-20099: " + e.getMessage();
		}
	}
	
	public static String decryptString(String encryptedText, String key) {
		try {
			return decrypt(Base64.decodeBase64(encryptedText), key);
		} catch(Exception e) {
			return "ORA-20099: " + e.getMessage();
		}
	}
	
    private static byte[] encrypt(String inputText, String key) throws Exception {
		Key aesKey = new SecretKeySpec(key.getBytes("UTF-8"), "AES/GCM/NoPadding");
		Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding", "BC");
		
		byte [] ivBytes = new byte[12];
        random.nextBytes(ivBytes);
		
		cipher.init(Cipher.ENCRYPT_MODE, aesKey, new IvParameterSpec(ivBytes), random);
		return Arrays.concatenate(ivBytes, cipher.doFinal(inputText.getBytes("UTF-8")));
    }
	
	private static String decrypt(byte[] encrypted, String key) throws Exception {
		Key aesKey = new SecretKeySpec(key.getBytes("UTF-8"), "AES/GCM/NoPadding");
		Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding", "BC");
		
		cipher.init(Cipher.DECRYPT_MODE, aesKey, new IvParameterSpec(Arrays.copyOfRange(encrypted, 0, 12)), random);
		
		return new String(cipher.doFinal(Arrays.copyOfRange(encrypted, 12, encrypted.length)), "UTF-8");
    }
}