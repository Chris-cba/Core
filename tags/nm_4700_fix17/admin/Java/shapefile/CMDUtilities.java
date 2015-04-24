/**
 *    PVCS Identifiers :-
 *
 *       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/Java/shapefile/CMDUtilities.java-arc   1.0   Apr 24 2015 06:20:58   Upendra.Hukeri  $
 *       Module Name      : $Workfile:   CMDUtilities.java  $
 *       Date into SCCS   : $Date:   Apr 24 2015 06:20:58  $
 *       Date fetched Out : $Modtime:   Apr 21 2015 12:54:50  $
 *       SCCS Version     : $Revision:   1.0  $
 *       Based on 
 *
 *
 *
 *    Author : Upendra Hukeri
 *
 *    CMDUtilities.java
 ****************************************************************************************************
 *	  Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
 ****************************************************************************************************
 *
 */

import java.io.*;

public class CMDUtilities {
	String exitVal = "-1";
	boolean checkProcOutput = false;
	boolean isStrOutput = false;
	String result = null;
	
	public static String runCommand(String command, String successStr, String outputMode) {
		CMDUtilities cmdUtil = new CMDUtilities();
		
		if (outputMode != null) {
			if (outputMode.equalsIgnoreCase("STRING")) {
				cmdUtil.isStrOutput = true;
			} else if (outputMode.equalsIgnoreCase("INTEGER")) {
				cmdUtil.isStrOutput = false;
			} else {
				return cmdUtil.exitVal;
			}
		} else {
			return cmdUtil.exitVal;
		}
		
		String s = null;
	
		try {
			Runtime rt = Runtime.getRuntime();
		  
			Process proc = rt.exec(command);
			proc.waitFor();
			
			if (successStr != null) {
				if (successStr.length() > 0) {
					cmdUtil.checkProcOutput = true;
				}
			}
			
			if (cmdUtil.checkProcOutput) {
				InputStream is = proc.getInputStream();
				InputStreamReader reader = new InputStreamReader(is);
				BufferedReader br = new BufferedReader(reader);
				
				while ((s = br.readLine()) != null) {
					if (cmdUtil.result == null) {
						cmdUtil.result = s;
					} else {
						cmdUtil.result = cmdUtil.result + "\n" + s;
					}
					
					if (s.equals(successStr)) {
						cmdUtil.exitVal = "1";
						break;
					}
				}
				
				reader.close();
				br.close();
			} else {
				cmdUtil.exitVal = Integer.toString(proc.exitValue());
			}
		} catch (Exception processException) {
			String expMsg = "Error: Process Exception:\n" + processException.getMessage();
			
			System.out.println(expMsg);
		  
			if (cmdUtil.result == null) {
				cmdUtil.result = expMsg;
			} else {
				cmdUtil.result = cmdUtil.result + "\n" + expMsg;
			}
		}
		
		if (cmdUtil.result != null) {
			if (cmdUtil.result.length() > 32767) {
				cmdUtil.result = cmdUtil.result.substring(0, 32767);
			}
		}
		
		if (cmdUtil.isStrOutput) {
			return cmdUtil.result;
		} else {
			return cmdUtil.exitVal;
		}
	}
}
