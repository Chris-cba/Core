/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/login/ExorDebugger.java-arc   1.0   Nov 24 2016 11:53:54   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   ExorDebugger.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   Nov 24 2016 11:53:54  $
 *		Date Fetched Out : $Modtime:   Feb 22 2016 07:25:20  $
 *		PVCS Version     : $Revision:   1.0  $
 *
 *	This class is used to print debug messages on console.
 *
 ****************************************************************************************************
 *	  Copyright (c) 2016 Bentley Systems Incorporated.  All rights reserved.
 ****************************************************************************************************
 *
 */

package bentley.exor.login;

import java.util.Calendar;

public class ExorDebugger {
	private static int debugLevel = 1;

	public static void setDebugLevel(int p_debugLevel) {
		debugLevel = p_debugLevel;
	}

	public static void reportDebugInfo(String exorMessage) {
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
			String currentTimeField = hours + ":" + mins + ":" + secs + ":" + milli;
			
			System.out.println("Exor (" + currentTimeField + ") : INFO : " + exorMessage);
		}
	}
}
