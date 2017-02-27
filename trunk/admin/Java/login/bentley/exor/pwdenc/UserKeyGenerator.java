/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/pwdenc/UserKeyGenerator.java-arc   1.0   Feb 27 2017 07:05:52   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   UserKeyGenerator.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   Feb 27 2017 07:05:52  $
 *		Date Fetched Out : $Modtime:   Feb 06 2017 08:57:12  $
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

import java.security.SecureRandom;
 
public class UserKeyGenerator {
    public static String generateRandomString(final int randomStrlen) {
        SecureRandom random = new SecureRandom();
		byte[] values = new byte[randomStrlen];
		random.nextBytes(values);
		
		return values.toString();
    }
}
