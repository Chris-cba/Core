/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/log/IMSLogger.java-arc   1.1   May 30 2017 13:38:34   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   IMSLogger.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   May 30 2017 13:38:34  $
 *		Date Fetched Out : $Modtime:   May 30 2017 10:12:52  $
 *		PVCS Version     : $Revision:   1.1  $
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

import org.owasp.esapi.ESAPI;

public class IMSLogger {
	final static Logger logger = Logger.getLogger(IMSLogger.class);
	
	public final static int DEBUG	= 6;
	public final static int INFO	= 5;
	public final static int TRACE	= 4;
	public final static int WARN	= 3;
	public final static int FATAL	= 2;
	public final static int ERROR	= 1;
	
	public static void log(String logMessage, int logLevel) {
		String message = removeCRLF(logMessage);
		
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
			
			default:
				logger.error("Wrong logging level. Use - DEBUG | INFO | TRACE | WARN | FATAL | ERROR.");
		}
	}
	
	private static String removeCRLF(String message) {
		// ensure no CRLF injection into logs for forging records
		String clean = message.replace( '\n', '_' ).replace( '\r', '_' );
		
		if ( ESAPI.securityConfiguration().getLogEncodingRequired() ) {
			clean = ESAPI.encoder().encodeForHTML(message);
			
			if (!message.equals(clean)) {
				clean += " (Encoded)";
			}
		}
		
		return clean;
	}
}
