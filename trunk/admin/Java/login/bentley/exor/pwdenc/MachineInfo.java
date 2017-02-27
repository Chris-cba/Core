/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/pwdenc/MachineInfo.java-arc   1.0   Feb 27 2017 07:05:52   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   MachineInfo.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   Feb 27 2017 07:05:52  $
 *		Date Fetched Out : $Modtime:   Feb 16 2017 07:00:00  $
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

public class MachineInfo {
	public static String getMachineName() {
		try {
			java.net.InetAddress localMachine = java.net.InetAddress.getLocalHost();
			
			return localMachine.getCanonicalHostName();
		} catch(Exception e) {
			return "Unable to get machine name";
		}
	}
	
	public static String getMachineUserName() {
		try {
			String windowsUser = System.getProperty("user.name");
			String windowsDomain = System.getenv("USERDOMAIN");
			
			return windowsDomain + "\\" + windowsUser;
		} catch(Exception e) {
			return "Unable to get machine user name";
		}
	}
}

