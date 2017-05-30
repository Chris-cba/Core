/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/ExorDebugger.java-arc   1.1   May 30 2017 13:34:58   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   ExorDebugger.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   May 30 2017 13:34:58  $
 *		Date Fetched Out : $Modtime:   May 30 2017 13:32:32  $
 *		PVCS Version     : $Revision:   1.1  $
 *
 *	This class is used to print debug messages on console.
 *
 ****************************************************************************************************
 *	  Copyright (c) 2017 Bentley Systems Incorporated.  All rights reserved.
 ****************************************************************************************************
 *
 */

package bentley.exor;

import java.util.Calendar;

public class ExorDebugger {
	private static int debugLevel = 1;

	public static void setDebugLevel(int p_debugLevel) {
		debugLevel = p_debugLevel;
	}
	
	public static void reportDebugInfo(String... exorMessages) {
		if (debugLevel > 0) {
			Calendar currentTime = Calendar.getInstance();
			int currentHours = currentTime.get(Calendar.HOUR_OF_DAY);
			int currentMins  = currentTime.get(Calendar.MINUTE);
			int currentSecs  = currentTime.get(Calendar.SECOND);
			int currentMilli = currentTime.get(Calendar.MILLISECOND);
			
			java.text.DecimalFormat df = new java.text.DecimalFormat("00");
			String hours = df.format(currentHours);
			String mins = df.format(currentMins);
			String secs = df.format(currentSecs);
			df = new java.text.DecimalFormat("000");
			String milli = df.format(currentMilli);
			
			StringBuilder strBld = new StringBuilder();
			strBld.append("Exor (").append(hours).append(':').append(mins).append(':').append(secs).append(':').append(milli).append(") : INFO : ");
			
			for(String message:exorMessages)  {
				strBld.append(message);
			}
			
			System.out.println(strBld.toString());
		}
	}
}
