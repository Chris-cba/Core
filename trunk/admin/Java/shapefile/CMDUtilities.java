/**
 *    PVCS Identifiers :-
 *
 *       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/Java/shapefile/CMDUtilities.java-arc   1.1   Jul 11 2019 12:45:50   Upendra.Hukeri  $
 *       Module Name      : $Workfile:   CMDUtilities.java  $
 *       Date into SCCS   : $Date:   Jul 11 2019 12:45:50  $
 *       Date fetched Out : $Modtime:   Jul 11 2019 12:43:26  $
 *       SCCS Version     : $Revision:   1.1  $
 *       Based on 
 *
 *
 *
 *    Author : Upendra Hukeri
 *
 *    CMDUtilities.java
 ****************************************************************************************************
 *	  Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved. 
 ****************************************************************************************************
 *
 */

import java.io.*;

public class CMDUtilities { 
	private static final String revision = "$Revision:   1.1  $"; 
	
	public static String getVersion() { 
		return revision; 
	} 
	
	private static String executeCommand(String command) {
		String result = null; 
		
		try { 
			Runtime rt = Runtime.getRuntime();
			
			Process proc = rt.exec(command);
			proc.waitFor();
			
			BufferedReader isReader = new BufferedReader(new InputStreamReader(proc.getInputStream()));
			BufferedReader esReader = new BufferedReader(new InputStreamReader(proc.getErrorStream()));
			
			String s = null;
			
			while ((s = isReader.readLine()) != null) {
				if (result == null) {
					result = s;
				} else {
					result += "\n" + s; 
				}
			}
			
			if(result == null) {
				while ((s = esReader.readLine()) != null) {
					if (result == null) {
						result = s;
					} else {
						result += "\n" + s; 
					}
				}
			}
			
			isReader.close();
			esReader.close();
		} catch (Exception processException) { 
			StringWriter sw = new StringWriter();
			PrintWriter  pw = new PrintWriter(sw);
			
			processException.printStackTrace(pw);
			
			String expMsg = "Error: Process Exception:\n" + sw.toString();
			
			if (result == null) {
				result = expMsg;
			} else {
				result += "\n" + expMsg;
			}
		}
		
		if (result != null && result.length() > 32767) { 
			result = result.substring(0, 32767); 
		} 
		
		return result; 
	} 
	
	public static String extractShapefile(String host, Integer port, String sid, String username, String password, String tableColumn, String filePath, String whereClause, String attributeMappingFilePath) {
		String sdeUtilPath = System.getenv("SDE_UTIL_PATH");
		
		if(sdeUtilPath == null || sdeUtilPath.length() <= 0) {
			return "SDE_UTIL_PATH Environment Variable not found"; 
		}
		
		String command = "java -jar \"" + sdeUtilPath + "\\lib\\sde2shp.jar\""; 
		
		if(host != null && host.length() > 0) {
			command += " -h " + host; 
		}  
		
		if(port != null) {
			command += " -p " + port; 
		}  
		
		if(sid != null && sid.length() > 0) {
			command += " -s " + sid; 
		}  
		
		if(username != null && username.length() > 0) {
			command += " -u " + username; 
		}  
		
		if(password != null && password.length() > 0) {
			command += " -d " + password; 
		}  
		
		if(tableColumn != null && tableColumn.length() > 0) {
			command += " -t " + tableColumn; 
		}  
		
		if(filePath != null && filePath.length() > 0) {
			command += " -f \"" + filePath + "\""; 
		} 
		
		if(whereClause != null && whereClause.length() > 0) {
			command += " -w \"" + whereClause + "\""; 
		} 
		
		if(attributeMappingFilePath != null && attributeMappingFilePath.length() > 0) {
			command += " -a \"" + attributeMappingFilePath + "\""; 
		} 
		
		return executeCommand(command); 
	} 
	public static String uploadShapefile(String host, Integer port, String sid, String username, String password, String tableName, String filePath, String uniqueColumnName, Integer srid, String geomColumnName, String xBounds, String yBounds, String tolerance, String modeOfOperation, Integer uniqueColumnStartID, Integer commitInterval, String attributeMappingFilePath) {
		String sdeUtilPath = System.getenv("SDE_UTIL_PATH");
		
		if(sdeUtilPath == null || sdeUtilPath.length() <= 0) {
			return "SDE_UTIL_PATH Environment Variable not found"; 
		}
		
		String command = "java -jar \"" + sdeUtilPath + "\\lib\\shp2sde.jar\""; 
		
		if(host != null && host.length() > 0) {
			command += " -h " + host; 
		} 
		
		if(port != null) {
			command += " -p " + port; 
		} 
		
		if(sid != null && sid.length() > 0) {
			command += " -s " + sid; 
		} 
		
		if(username != null && username.length() > 0) {
			command += " -u " + username; 
		} 
		
		if(password != null && password.length() > 0) {
			command += " -d " + password; 
		} 
		
		if(tableName != null && tableName.length() > 0) {
			command += " -t " + tableName; 
		} 
		
		if(filePath != null && filePath.length() > 0) {
			command += " -f \"" + filePath + "\""; 
		} 
		
		if(uniqueColumnName != null && uniqueColumnName.length() > 0) {
			command += " -i " + uniqueColumnName; 
		} 
		
		if(srid != null) {
			command += " -r " + srid; 
		} 
		
		if(geomColumnName != null && geomColumnName.length() > 0) {
			command += " -g " + geomColumnName; 
		} 
		
		if(xBounds != null && xBounds.length() > 0) {
			command += " -x \"" + xBounds + "\""; 
		} 
		
		if(yBounds != null && yBounds.length() > 0) {
			command += " -y \"" + yBounds + "\""; 
		} 
		
		if(tolerance != null && tolerance.length() > 0) {
			try {
			Double d_tolerance = Double.valueOf(tolerance);
			command += " -m " + tolerance; 
			} catch(NumberFormatException nfe) {
				return "Invalid tolerance value";
			}
		} 
		
		if(modeOfOperation != null && modeOfOperation.length() > 0) {
			command += " -o " + modeOfOperation; 
		} 
		
		if(uniqueColumnStartID != null) {
			command += " -n " + uniqueColumnStartID; 
		} 
		
		if(commitInterval != null) {
			command += " -c " + commitInterval; 
		} 
		
		if(attributeMappingFilePath != null && attributeMappingFilePath.length() > 0) {
			command += " -a \"" + attributeMappingFilePath + "\""; 
		} 
		
		return executeCommand(command); 
	} 
	
	public static String checkXSS(String urlParameters) {
		String xssUtilPath = System.getenv("XSS_UTIL_PATH");
		
		if(xssUtilPath == null || xssUtilPath.length() <= 0) {
			return "XSS_UTIL_PATH Environment Variable not found"; 
		}
		
		String command = "java -jar \"" + xssUtilPath + "\\tig-xss.jar\" \"" + urlParameters + "\""; 
		
		return executeCommand(command); 
	} 
}
 