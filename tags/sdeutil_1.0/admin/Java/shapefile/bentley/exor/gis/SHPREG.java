/**
 *    PVCS Identifiers :-
 *
 *       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/Java/shapefile/bentley/exor/gis/SHPREG.java-arc   1.1   Feb 26 2018 06:04:50   Upendra.Hukeri  $
 *       Module Name      : $Workfile:   SHPREG.java  $
 *       Date into SCCS   : $Date:   Feb 26 2018 06:04:50  $
 *       Date fetched Out : $Modtime:   Feb 26 2018 05:55:40  $
 *       SCCS Version     : $Revision:   1.1  $
 *       Based on 
 *
 *
 *
 *    Author : Upendra Hukeri
 *    SHPREG.java
 *
 ****************************************************************************************************
 *	  Copyright (c) 2018 Bentley Systems Incorporated.  All rights reserved.
 ****************************************************************************************************
 *
 */
 
package bentley.exor.gis;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

import java.util.Arrays;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Set;

/**
 * This program registers required tables/views and WHERE clauses in database 
 * which are to be used to extract/upload Shapefiles
 */

public class SHPREG extends ShapefileUtility {
	private String[] tableNamesArray       = null;
	private String[] whereClauseIDArray    = null;
	private String[] whereClauseIDArray2   = null;
	private String   whereClause           = null;
	private String   whereClauseDescr      = null;
	private String[] whereClauseTableNamesArray = null;
	private String   tableUpdateAction     = "append"; //possible values {append|init|delete}
	private String   whereUpdateAction     = "append"; //possible values {append|init|delete}
	
	public SHPREG() {
		super();
	}
	
	protected String getHelpMessage() {
		StringBuilder helpMsg  = new StringBuilder();
		
		helpMsg.append("\nUSAGE1: java -jar sdeutil.jar -shpreg -help");
		helpMsg.append("\n\nUSAGE2: java -jar sdeutil.jar -shpreg [-rt] [-nc | -h db_host -p db_port -s db_sid -u db_username -d db_password] [-t db_tablename/s] (-w where_clause_id/s | -w \"*\")");
		helpMsg.append("\n\nUSAGE3: java -jar sdeutil.jar -shpreg [-ut] [-nc | -h db_host -p db_port -s db_sid -u db_username -d db_password] [-t db_tablename] [-w {-append|-init|-delete} where_clause_id/s | -w {-append|-delete} \"*\"]");
		helpMsg.append("\n\nUSAGE3: java -jar sdeutil.jar -shpreg [-dt] [-nc | -h db_host -p db_port -s db_sid -u db_username -d db_password] [-t db_tablename/s | -t \"*\"]");
		helpMsg.append("\n\nUSAGE3: java -jar sdeutil.jar -shpreg [-rw] [-nc | -h db_host -p db_port -s db_sid -u db_username -d db_password] [-wid where_clause_id] [-wh where_clause] (-wd where_clause_description) (-wt db_tablename/s | -wt \"*\")");
		helpMsg.append("\n\nUSAGE4: java -jar sdeutil.jar -shpreg [-uw] [-nc | -h db_host -p db_port -s db_sid -u db_username -d db_password] [-wid where_clause_id] (-wh where_clause) (-wd where_clause_description) (-wt {-append|-init|-delete} db_tablename/s | -wt {-append|-delete} \"*\")");
		helpMsg.append("\n\nUSAGE5: java -jar sdeutil.jar -shpreg [-dw] [-nc | -h db_host -p db_port -s db_sid -u db_username -d db_password] [-wid where_clause_id/s | -wid \"*\"]");
		helpMsg.append("\n\nUsage explaination (parameters used):");
		helpMsg.append("\n\t-help : Specify this option to see the command line usage of Shapefile-Registration-Utility (no values for this parameter)");
		helpMsg.append("\n\t-rt   : Specify this option to register table(s) for Shapefile-Utility");
		helpMsg.append("\n\t-ut   : Specify this option to update a registered table for Shapefile-Utility");
		helpMsg.append("\n\t-dt   : Specify this option to unregister table(s) from Shapefile-Utility");
		helpMsg.append("\n\t-rw   : Specify this option to register WHERE clause for Shapefile-Utility");
		helpMsg.append("\n\t-uw   : Specify this option to update a registered WHERE clause for Shapefile-Utility");
		helpMsg.append("\n\t-dw   : Specify this option to unregister WHERE clause(s) from Shapefile-Utility");
		helpMsg.append("\n\t-nc   : Specify this option, if the jar is loaded in database and called from a PL/SQL procedure or function (no values for this parameter)");
		helpMsg.append("\n\t-h    : Host machine name or IP address with existing Oracle database");
		helpMsg.append("\n\t-p    : Port to connect to existing Oracle database (e.g. 1521)");
		helpMsg.append("\n\t-s    : SID of existing Oracle database (e.g. orcl)");
		helpMsg.append("\n\t-u    : Database user's username");
		helpMsg.append("\n\t-d    : Database user's password");
		helpMsg.append("\n\t-t    : Feature table name(s) that need to be registered with Shapefile-Utility (separated by COMMA only)");
		helpMsg.append("\n\t-w    : WHERE clause ID(s) to be registered with table specified in '-t' option (separated by COMMA only)");
		helpMsg.append("\n\t-wid  : ID for WHERE clause to be registered with Shapefile-Utility, maximum 50 characters long (allowed characters: A-Z a-z 0-9 _ $ #)");
		helpMsg.append("\n\t-wh   : WHERE clause to be registered with Shapefile-Utility (in case WHERE clause contains space itself enclose it in double quotes)");
		helpMsg.append("\n\t-wd   : Description for WHERE clause to be registered with Shapefile-Utility");
		helpMsg.append("\n\t-wt   : Feature table name(s) to be registered with WHERE clause ID specified in '-wid' option (separated by COMMA only)");
		helpMsg.append("\n\n\tNOTE: \t[] indicate MANDATORY field in USAGE");
		helpMsg.append("\n\t\t() indicate OPTIONAL field in USAGE");
		helpMsg.append("\n\n\t\t| represents OR");
		helpMsg.append("\n\n\t\t\"*\" represents all registered table(s) OR WHERE clause ID(s) as applicable, * MUST ALWAYS BE ENCLOSED IN DOUBLE QUOTES");
		helpMsg.append("\n\n\t\t{-append|-init|-delete} represent update action to be performed - ");
		helpMsg.append("\n\t\t   -append - To add specified table(s) to existing list of tables for a WHERE clause ID OR");
		helpMsg.append("\n\t\t           - To add specified WHERE clause ID(s) to existing list of WHERE clause IDs for a table");
		helpMsg.append("\n\t\t   -init   - To replace existing list of tables for a WHERE clause ID with specified tables OR");
		helpMsg.append("\n\t\t           - To replace existing list of WHERE clause IDs for a table with specified WHERE clause ID(s)");
		helpMsg.append("\n\t\t   -delete - To delete specified tables from existing list of tables for a WHERE clause ID OR");
		helpMsg.append("\n\t\t           - To delete specified WHERE clause ID(s) from existing list of tables for a table");
		
		return helpMsg.toString();
	}
	
	private void init(String[] nuh) {
		String		 usage			= "\nError: following key(s)/value(s) is/are missing: ";
		int			 numOfErrors 	= 0;
		
		Set <String> validKeySet	= new HashSet<String>(Arrays.asList(ShapefileUtility.validRegistryKeysArray));
		List<String> argumentsList 	= new ArrayList<String>(Arrays.asList(nuh));
		List<String> missingKV 		= new ArrayList<String>();
		Map <String, String> hm  	= new HashMap<String, String>();
		
		try {
			for (Enumeration e = Collections.enumeration(argumentsList); e.hasMoreElements();) {
				if(!getExitSystem()) {
					String key   = null;
					String value = null;
			
					key = (String) e.nextElement();
					
					boolean isNormalParam = true;
					
					if("-nc".equals(key)     || 
					   "-rt".equals(key)     || 
					   "-ut".equals(key)     ||
					   "-dt".equals(key)     ||
					   "-rw".equals(key)     ||
					   "-uw".equals(key)     ||
					   "-dw".equals(key)     ||
					   "-append".equals(key) ||
					   "-init".equals(key)   ||
					   "-delete".equals(key)
					) {
						hm.put(key, null);
						isNormalParam = false;
					}
					
					if(isNormalParam) {
						try {
							value = (String) e.nextElement();
							
							if("-append".equals(value) || "-init".equals(value) || "-delete".equals(value)) {
								hm.put(value, null);
								value = (String) e.nextElement();
							}
						} catch(NoSuchElementException nseException) {
							setErrorMsg("\nError: missing value for: " + key);
							setExitSystem(true);
						}
						
						if (key != null && value != null && !key.isEmpty() && !value.isEmpty()) {
							hm.put(key, value);
						}
					}
				}
			}
			
			if(!getExitSystem()) {
				String[]    mandatoryKeysArray  = new String[] {};
				String[]    optionalKeysArray  = new String[] {};
				String[]    mandatoryKeysArray2 = new String[] {};
				Set<String> mandatoryKeySet     = new HashSet<String>();
				Set<String> mandatoryKeySet2    = new HashSet<String>();
				Set<String> optionalKeySet      = new HashSet<String>();
				
				if (hm.containsKey("-rt") || hm.containsKey("-dt")) {
					mandatoryKeysArray  = new String[] {"-t"};
					optionalKeysArray   = new String[] {"-w"};
				} else if(hm.containsKey("-ut")) {
					mandatoryKeysArray  = new String[] {"-t", "-w"};
					optionalKeysArray = new String[] {"-append", "-init", "-delete"};
				} else if(hm.containsKey("-rw")) {
					mandatoryKeysArray  = new String[] {"-wid", "-wh"};
					optionalKeysArray   = new String[] {"-wd", "-wt"};
				} else if(hm.containsKey("-uw")) {
					mandatoryKeysArray  = new String[] {"-wid"};
					mandatoryKeysArray2 = new String[] {"-wh", "-wd", "-wr", "-wt"};
					optionalKeysArray = new String[] {"-append", "-init", "-delete"};
				} else if(hm.containsKey("-dw")) {
					mandatoryKeysArray  = new String[] {"-wid"};
				} else {
					missingKV.add("any of the keys from - [-rt, -ut, -dt, -rw, -uw, -dw]");
					numOfErrors++;
				}
				
				Set<String> keySet 		= hm.keySet();
				Iterator 	keyIterator = keySet.iterator();
				
				mandatoryKeySet  = new HashSet<String>(Arrays.asList(mandatoryKeysArray));
				mandatoryKeySet2 = new HashSet<String>(Arrays.asList(mandatoryKeysArray2));
				optionalKeySet   = new HashSet<String>(Arrays.asList(optionalKeysArray));
				
				while(keyIterator.hasNext()) {
					String currKey = (String)keyIterator.next();
					
					if(!validKeySet.contains(currKey)
					&& !mandatoryKeySet.contains(currKey)
					&& !mandatoryKeySet2.contains(currKey)
					&& !optionalKeySet.contains(currKey)
					) {
						setErrorMsg("\nError: invalid key - " + currKey);
						setExitSystem(true);
						
						break;
					}
				}
				
				if(!getExitSystem()) {
					if(!getUseNestedConn()) {
						if (hm.containsKey("-h")) {
							setHost((String) hm.get("-h"));
						} else {
							missingKV.add("-h db_host");
							numOfErrors++;
						}
						
						if (hm.containsKey("-p")) {
							setPort(Integer.parseInt((String) hm.get("-p")));
						} else {
							missingKV.add("-p db_port");
							numOfErrors++;
						}
						
						if (hm.containsKey("-s")) {
							setSID((String) hm.get("-s"));
						} else {
							missingKV.add("-s db_sid");
							numOfErrors++;
						}
						
						if (hm.containsKey("-u")) {
							setUserName((String) hm.get("-u"));
						} else {
							missingKV.add("-u db_username");
							numOfErrors++;
						}
						
						if (hm.containsKey("-d")) {
							setPassword((String) hm.get("-d"));
						} else {
							missingKV.add("-d password");
							numOfErrors++;
						}
					}
					
					if (hm.containsKey("-w")) {
						String whereClauseIDs = ((String) hm.get("-w")).toUpperCase(Locale.ENGLISH);
						boolean allowStar = false;
						
						if("*".equals(whereClauseIDs)) {
							if(hm.containsKey("-rt") || hm.containsKey("-ut")) {
								allowStar = true;
							}
						}
						
						String[] whereClauseIDArr = whereClauseIDs.split(",");
						
						if(!allowStar) {
							for(int i = 0; i < whereClauseIDArr.length; i++) {
								if(!conformOracleNamingConvention(whereClauseIDArr[i])) {
									missingKV.add("wrong value passed to -w, special characters not allowed in WHERE clause ID (allowed: A-Z a-z 0-9 _ $ #)");
									numOfErrors++;
									
									break;
								}
							}
						}
						
						whereClauseIDArray = whereClauseIDArr;
						
						if(hm.containsKey("-ut")) {
							if(hm.containsKey("-append")) {
								whereUpdateAction = "append";
							}
							else if(hm.containsKey("-init")) {
								if("*".equals(whereClauseIDArray[0])) {
									missingKV.add("wrong value passed to update table action (-ut)");
									numOfErrors++;
								} else {
									whereUpdateAction = "init";
								}
							} else if(hm.containsKey("-delete")) {
								whereUpdateAction = "delete";
							} else {
								missingKV.add("no update table operation specified");
								numOfErrors++;
							}
						}
					}
					
					if (hm.containsKey("-t")) {
						String tableNames = ((String) hm.get("-t")).toUpperCase(Locale.ENGLISH);
						boolean allowStar = false;
						
						if("*".equals(tableNames)) {
							if(hm.containsKey("-dt")) {
								allowStar = true;
							}
						}
						
						String[] tableNamesArr = tableNames.split(",");
						
						if(tableNamesArr.length > 1 && hm.containsKey("-ut")) {
							missingKV.add("wrong value passed to -t, only one table can be updated at a time");
							numOfErrors++;
						} else {
							if(!allowStar) {
								for(int i = 0; i < tableNamesArr.length; i++) {
									if(!conformOracleNamingConvention(tableNamesArr[i])) {
										missingKV.add("wrong value passed to -t, special characters not allowed in table name (allowed: A-Z a-z 0-9 _ $ #)");
										numOfErrors++;
										
										break;
									}
								}
							}
							
							tableNamesArray = tableNamesArr;
						}
					}
					
					if (hm.containsKey("-wid")) { 
						String whereClauseIDs = ((String) hm.get("-wid")).toUpperCase(Locale.ENGLISH);
						boolean allowStar = false;
						
						if("*".equals(whereClauseIDs)) {
							if(hm.containsKey("-dw")) {
								allowStar = true;
							}
						}
						
						String[] whereClauseIDArr = whereClauseIDs.split(",");
						
						if((hm.containsKey("-rw") || hm.containsKey("-uw")) && whereClauseIDArr.length > 1) {
							missingKV.add("wrong value passed to -wid, only one WHERE clause can be registered or updated at a time");
							numOfErrors++;
						} else {
							if(!allowStar) {
								for(int i = 0; i < whereClauseIDArr.length; i++) {
									if(whereClauseIDArr[i].length() > 50) {
										missingKV.add("wrong value passed to -wid, allowed length <= 50");
										numOfErrors++;
										
										break;
									}
									
									if(!conformOracleNamingConvention(whereClauseIDArr[i])) {
										missingKV.add("wrong value passed to -wid, special characters not allowed in WHERE clause ID (allowed: A-Z a-z 0-9 _ $ #)");
										numOfErrors++;
										
										break;
									}
								}
							}
							
							whereClauseIDArray2 = whereClauseIDArr;
						}
					}
					
					if (hm.containsKey("-wh")) {
						whereClause = (String) hm.get("-wh");
					}
					
					if (hm.containsKey("-wd")) {
						whereClauseDescr = (String) hm.get("-wd");
					}
					
					if (hm.containsKey("-wt")) {
						String tableNames = ((String) hm.get("-wt")).toUpperCase(Locale.ENGLISH);
						boolean allowStar = false;
						
						if("*".equals(tableNames)) {
							if(hm.containsKey("-rw") || hm.containsKey("-uw")) {
								allowStar = true;
							}
						}
						
						String[] tableNamesArr = tableNames.split(",");
						
						if(!allowStar) {
							for(int i = 0; i < tableNamesArr.length; i++) {
								if(!conformOracleNamingConvention(tableNamesArr[i])) {
									missingKV.add("wrong value passed to -wt, special characters not allowed in table name (allowed: A-Z a-z 0-9 _ $ #)");
									numOfErrors++;
									
									break;
								}
							}
						}
						
						whereClauseTableNamesArray = tableNamesArr;
						
						if(hm.containsKey("-uw")) {
							if(hm.containsKey("-append")) {
								tableUpdateAction = "append";
							}
							else if(hm.containsKey("-init")) {
								if("*".equals(whereClauseTableNamesArray[0])) {
									missingKV.add("wrong value passed to update where action (-uw)");
									numOfErrors++;
								} else {
									tableUpdateAction = "init";
								}
							} else if(hm.containsKey("-delete")) {
								tableUpdateAction = "delete";
							} else {
								missingKV.add("no update where operation specified");
								numOfErrors++;
							}
						}
					}
					
					keyIterator = mandatoryKeySet.iterator();
					
					while(keyIterator.hasNext()) {
						String currKey = (String)keyIterator.next();
						
						if(!keySet.contains(currKey)) {
							missingKV.add(currKey);
							numOfErrors++;
						}
					}
					
					mandatoryKeySet2 = new HashSet<String>(Arrays.asList(mandatoryKeysArray2));
					
					keyIterator = mandatoryKeySet2.iterator();
					
					int actualKeysCount = 0;
					
					while(keyIterator.hasNext()) {
						String currKey = (String)keyIterator.next();
						
						if(keySet.contains(currKey)) {
							actualKeysCount++;
							
							break;
						}
					}
					
					if(actualKeysCount == 0 && mandatoryKeySet2.size() > 0) {
						missingKV.add("at least one key from - " + Arrays.deepToString(mandatoryKeysArray2));
						numOfErrors++;
					}
					
					if (numOfErrors > 0) {
						writeLog(usage, false);
						
						Iterator itr = missingKV.iterator();
						
						while(itr.hasNext()) {
							writeLog("\t\t" + itr.next(), false);
						}
						
						setExitSystem(true);
					}
				}
			}
		} catch (Exception initException) {
			setErrorMsg("\nError: " + initException.getMessage());
			logException(initException, "<init>");
			
			setExitSystem(true);
		}
	}
	
	protected void doRegister(String[] nuh, SHPREG shpreg) {
		try {
			if(nuh != null && nuh.length >= 1) {
				if(Arrays.asList(nuh).contains("-nc")) {
					shpreg.setUseNestedConn(true);
				}
				
				if(Arrays.asList(nuh).contains("-help")) {
					String helpMsg = shpreg.getHelpMessage();
					
					shpreg.setErrorMsg(helpMsg);
					System.out.println(helpMsg);
				} else {
					shpreg.init(nuh);
					
					if(!shpreg.getExitSystem()) {
						String result = null;
						
						if(Arrays.asList(nuh).contains("-rt")) {
							result = shpreg.registerTable();
						} else if(Arrays.asList(nuh).contains("-ut")) {
							result = shpreg.updateTable();
						} else if(Arrays.asList(nuh).contains("-dt")) {
							result = shpreg.unregisterTable();
						} if(Arrays.asList(nuh).contains("-rw")) {
							result = shpreg.registerWhereClause();
						} if(Arrays.asList(nuh).contains("-uw")) {
							result = shpreg.updateWhereClause();
						} if(Arrays.asList(nuh).contains("-dw")) {
							result = shpreg.unregisterWhereClause();
						}
						
						if(!"Y".equals(result)) {
							setErrorMsg("\nError: " + result);
							writeLog("\nError: " + result, false);
						} else {
							writeLog("success", false);
						}
					} else {
						String errorMsg = shpreg.getErrorMsg();
						
						if(errorMsg != null && !errorMsg.isEmpty()) {
							writeLog(errorMsg, false);
						}
					}
				}
			} else {
				String invalidArgErrM = "\nError: Invalid argument/s passed..." + shpreg.getHelpMessage();
				
				shpreg.setErrorMsg(invalidArgErrM);
				System.out.println(invalidArgErrM);
			}
		} catch (Throwable doExtractException) {
			shpreg.logException(doExtractException, "doRegister");
		} finally {
			shpreg.systemExit();
		}
	}
	
	protected void writeLog(String log) {
		writeLog(log, true);
	}
	
	private String registerTable() 
	throws SQLException, ClassNotFoundException, Exception {
		Connection        conn    = null;
		CallableStatement cstmt   = null;
		String 			  result  = null;
		String 			  sqlStmt = null;
		
		oracle.sql.ARRAY  tablesArrToPass  = null;
		oracle.sql.ARRAY  whereIDArrToPass = null;
		oracle.sql.ArrayDescriptor des     = null;
		
		try {
			conn = getConnection();
			
			des = oracle.sql.ArrayDescriptor.createDescriptor("SDE_VARCHAR_ARRAY", conn);
			
			if(tableNamesArray != null && tableNamesArray.length > 0) {
				tablesArrToPass = new oracle.sql.ARRAY(des, conn, tableNamesArray);
			}
			
			if(whereClauseIDArray != null && whereClauseIDArray.length > 0) {
				whereIDArrToPass = new oracle.sql.ARRAY(des, conn, whereClauseIDArray);
			}
			
			sqlStmt = "{? = call sde_util.register_table(?, ?)}";
			cstmt   = conn.prepareCall(sqlStmt);
			cstmt.registerOutParameter(1, Types.VARCHAR);
			
			if(tablesArrToPass == null) {
				cstmt.setNull(2, Types.ARRAY, "SDE_VARCHAR_ARRAY");
			} else {
				cstmt.setArray(2, tablesArrToPass);
			}
			
			if(whereIDArrToPass == null) {
				cstmt.setNull(3, Types.ARRAY, "SDE_VARCHAR_ARRAY");
			} else {
				cstmt.setArray(3, whereIDArrToPass);
			}
			
			cstmt.execute();
			
			return cstmt.getString(1);
		} finally {
			closeOracle("registerTable", cstmt, conn, null);
		}
	}
	
	private String updateTable() 
	throws SQLException, ClassNotFoundException, Exception {
		Connection        conn    = null;
		CallableStatement cstmt   = null;
		String 			  result  = null;
		String 			  sqlStmt = null;
		
		oracle.sql.ARRAY  whereIDArrToPass = null;
		oracle.sql.ArrayDescriptor des     = null;
		
		try {
			conn = getConnection();
			
			if(whereClauseIDArray != null && whereClauseIDArray.length > 0) {
				des = oracle.sql.ArrayDescriptor.createDescriptor("SDE_VARCHAR_ARRAY", conn);
				whereIDArrToPass = new oracle.sql.ARRAY(des, conn, whereClauseIDArray);
			}
			
			sqlStmt = "{? = call sde_util.update_table(?, ?, ?)}";
			cstmt   = conn.prepareCall(sqlStmt);
			cstmt.registerOutParameter(1, Types.VARCHAR);
			cstmt.setString(2, tableNamesArray[0]);
			cstmt.setString(3, whereUpdateAction);
			
			if(whereIDArrToPass == null) {
				cstmt.setNull(4, Types.ARRAY, "SDE_VARCHAR_ARRAY");
			} else {
				cstmt.setArray(4, whereIDArrToPass);
			}
			
			cstmt.execute();
			
			return cstmt.getString(1);
		} finally {
			closeOracle("updateTable", cstmt, conn, null);
		}
	}
	
	private String unregisterTable() 
	throws SQLException, ClassNotFoundException, Exception {
		Connection        conn    = null;
		CallableStatement cstmt   = null;
		String 			  result  = null;
		String 			  sqlStmt = null;
		
		oracle.sql.ARRAY  tablesArrToPass = null;
		
		oracle.sql.ArrayDescriptor des    = null;
		
		try {
			conn = getConnection();
			
			if(tableNamesArray != null && tableNamesArray.length > 0) {
				des = oracle.sql.ArrayDescriptor.createDescriptor("SDE_VARCHAR_ARRAY", conn);
				tablesArrToPass = new oracle.sql.ARRAY(des, conn, tableNamesArray);
			}
			
			sqlStmt = "{? = call sde_util.unregister_table(?)}";
			cstmt   = conn.prepareCall(sqlStmt);
			cstmt.registerOutParameter(1, Types.VARCHAR);
			
			if(tablesArrToPass == null) {
				cstmt.setNull(2, Types.ARRAY, "SDE_VARCHAR_ARRAY");
			} else {
				cstmt.setArray(2, tablesArrToPass);
			}
			
			cstmt.execute();
			
			return cstmt.getString(1);
		} finally {
			closeOracle("unregisterTable", cstmt, conn, null);
		}
	}
	
	private String registerWhereClause() 
	throws SQLException, ClassNotFoundException, Exception {
		Connection        conn            = null;
		CallableStatement cstmt           = null;
		String 			  result          = null;
		String 			  sqlStmt         = null;
		
		oracle.sql.ARRAY  rolesArrToPass  = null;
		oracle.sql.ARRAY  tablesArrToPass = null;
		
		oracle.sql.ArrayDescriptor des    = null;
		
		try {
			conn = getConnection();
			
			if(whereClauseTableNamesArray != null && whereClauseTableNamesArray.length > 0) {
				des  = oracle.sql.ArrayDescriptor.createDescriptor("SDE_VARCHAR_ARRAY", conn);
				tablesArrToPass = new oracle.sql.ARRAY(des, conn, whereClauseTableNamesArray);
			}
			
			sqlStmt = "{? = call sde_util.register_where_clause(?, ?, ?, ?)}";
			cstmt   = conn.prepareCall(sqlStmt);
			cstmt.registerOutParameter(1, Types.VARCHAR);
			cstmt.setString(2, whereClauseIDArray2[0]);
			cstmt.setString(3, whereClause);
			cstmt.setString(4, whereClauseDescr);
			
			if(tablesArrToPass == null) {
				cstmt.setNull(5, Types.ARRAY, "SDE_VARCHAR_ARRAY");
			} else {
				cstmt.setArray(5, tablesArrToPass);
			}
			
			cstmt.execute();
			
			return cstmt.getString(1);
		} finally {
			closeOracle("registerWhereClause", cstmt, conn, null);
		}
	}
	
	private String updateWhereClause() 
	throws SQLException, ClassNotFoundException, Exception {
		Connection        conn        = null;
		CallableStatement cstmt       = null;
		String 			  sqlStmt     = null;
		
		oracle.sql.ARRAY  tablesArrToPass = null;
		
		oracle.sql.ArrayDescriptor des    = null;
		
		try {
			conn = getConnection();
			
			if(whereClauseTableNamesArray != null && whereClauseTableNamesArray.length > 0) {
				des  = oracle.sql.ArrayDescriptor.createDescriptor("SDE_VARCHAR_ARRAY", conn);
				tablesArrToPass = new oracle.sql.ARRAY(des, conn, whereClauseTableNamesArray);
			}
			
			sqlStmt = "{? = call sde_util.update_where_clause(?, ?, ?, ?, ?)}";
			cstmt   = conn.prepareCall(sqlStmt);
			cstmt.registerOutParameter(1, Types.VARCHAR);
			cstmt.setString(2, whereClauseIDArray2[0]);
			cstmt.setString(3, whereClause);
			cstmt.setString(4, whereClauseDescr);
			
			if(tablesArrToPass == null) {
				cstmt.setNull(5, Types.ARRAY, "SDE_VARCHAR_ARRAY");
			} else {
				cstmt.setArray(5, tablesArrToPass);
			}
			
			cstmt.setString(6, tableUpdateAction);
			
			cstmt.execute();
			
			return cstmt.getString(1);
		} finally {
			closeOracle("updateWhereClause", cstmt, conn, null);
		}
	}
	
	private String unregisterWhereClause() 
	throws SQLException, ClassNotFoundException, Exception {
		Connection        conn    = null;
		CallableStatement cstmt   = null;
		String 			  result  = null;
		String 			  sqlStmt = null;
		
		oracle.sql.ARRAY  whereIDArrToPass = null;
		
		oracle.sql.ArrayDescriptor des    = null;
		
		try {
			conn = getConnection();
			
			if(whereClauseIDArray2 != null && whereClauseIDArray2.length > 0) {
				des  = oracle.sql.ArrayDescriptor.createDescriptor("SDE_VARCHAR_ARRAY", conn);
				whereIDArrToPass = new oracle.sql.ARRAY(des, conn, whereClauseIDArray2);
			}
			
			sqlStmt = "{? = call sde_util.unregister_where_clause(?)}";
			cstmt   = conn.prepareCall(sqlStmt);
			cstmt.registerOutParameter(1, Types.VARCHAR);
			
			if(whereIDArrToPass == null) {
				cstmt.setNull(2, Types.ARRAY, "SDE_VARCHAR_ARRAY");
			} else {
				cstmt.setArray(2, whereIDArrToPass);
			}
			
			cstmt.execute();
			
			return cstmt.getString(1);
		} finally {
			closeOracle("unregisterWhereClause", cstmt, conn, null);
		}
	}
	
	protected void writeLog(String log, boolean includeDate) {
		String errorMessage = includeDate ? new Date().toString() + ": " + log : log;
		System.out.println(errorMessage);
	}
	
	public String toString() { 
        return super.toString().replace("ShapefileUtility:", "SHPREG:");
    }
}
