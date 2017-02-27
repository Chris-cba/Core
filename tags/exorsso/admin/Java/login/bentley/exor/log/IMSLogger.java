/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/log/IMSLogger.java-arc   1.0   Feb 27 2017 07:04:54   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   IMSLogger.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   Feb 27 2017 07:04:54  $
 *		Date Fetched Out : $Modtime:   Feb 20 2017 10:19:38  $
 *		PVCS Version     : $Revision:   1.0  $
 *
 *	
 *
 ****************************************************************************************************
 *	  Copyright (c) 2017 Bentley Systems Incorporated.  All rights reserved.
 ****************************************************************************************************
 *
 */

package bentley.exor.log;

import org.apache.log4j.Logger;

public class IMSLogger {
	final static Logger logger = Logger.getLogger(IMSLogger.class);
	
	private final static int DEBUG	= 6;
	private final static int INFO	= 5;
	private final static int TRACE	= 4;
	private final static int WARN	= 3;
	private final static int FATAL	= 2;
	private final static int ERROR	= 1;
	
	public static void log(String message, int logLevel) {
		switch(logLevel) {
			case DEBUG:
				if(logger.isDebugEnabled()) {
					logger.debug(message);
				}
				break;
				
			case INFO:
				if(logger.isInfoEnabled()) {
					logger.info(message);
				}
				break;
			
			case TRACE:
				if(logger.isTraceEnabled()) {
					logger.trace(message);
				}
				break;
			
			case WARN:
				logger.warn(message);
				break;
				
			case FATAL:
				logger.fatal(message);
				break;
				
			case ERROR:
				logger.error(message);
				break;
		}
	}
}
