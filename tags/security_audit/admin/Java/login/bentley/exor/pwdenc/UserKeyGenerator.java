/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/pwdenc/UserKeyGenerator.java-arc   1.1   Sep 07 2017 14:40:18   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   UserKeyGenerator.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   Sep 07 2017 14:40:18  $
 *		Date Fetched Out : $Modtime:   Sep 04 2017 14:47:30  $
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

import java.io.UnsupportedEncodingException;

import java.security.SecureRandom;
 
public class UserKeyGenerator {
	private static final SecureRandom random = new SecureRandom();
	
    public static String generateRandomString(final int randomStrlen) {
		try {
			byte[] values = new byte[randomStrlen];
			random.nextBytes(values);
			
			return new String(values, "UTF-8");
		} catch(UnsupportedEncodingException uee) {
			return "ORA-20099: " + uee.getMessage();
		}
    }
}
