/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/ExorDebugger.java-arc   1.0   Feb 27 2017 07:05:26   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   ExorDebugger.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   Feb 27 2017 07:05:26  $
 *		Date Fetched Out : $Modtime:   Feb 20 2017 10:18:30  $
 *		PVCS Version     : $Revision:   1.0  $
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
