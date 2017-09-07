/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/pwdenc/MachineInfo.java-arc   1.1   Sep 07 2017 14:40:10   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   MachineInfo.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   Sep 07 2017 14:40:10  $
 *		Date Fetched Out : $Modtime:   Sep 04 2017 15:52:40  $
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

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;

public class MachineInfo {
	public static String getMachineName() {
		try {
			StringBuilder ipAddresses = new StringBuilder();
			String ipconfig = null;
			
			Runtime run = Runtime.getRuntime();
			Process proc = run.exec("hostname");
			BufferedReader in = null;
			
			try {
				in = new BufferedReader(new InputStreamReader(proc.getInputStream(), "UTF-8"));
				
				ipconfig = in.readLine();
				
				ipAddresses.append(ipconfig);
				
				proc.waitFor();
				in.close();
				
				proc = run.exec("ipconfig");
				in = new BufferedReader(new InputStreamReader(proc.getInputStream(), "UTF-8"));
				
				while ((ipconfig = in.readLine()) != null) {
					if(ipconfig.indexOf("IPv4 Address") > -1) {
						ipAddresses.append(':').append(ipconfig.substring(ipconfig.indexOf(':') + 2));
					}
				}
				
				proc.waitFor();
			} finally {
				if(in != null) {
					try {	
						in.close();
					} catch(IOException ioe) {
					}
				}
			}
			
			return ipAddresses.toString();
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

