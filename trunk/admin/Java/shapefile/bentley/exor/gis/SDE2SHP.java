/**
 *    PVCS Identifiers :-
 *
 *       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/Java/shapefile/bentley/exor/gis/SDE2SHP.java-arc   1.3   Oct 09 2017 10:07:40   Upendra.Hukeri  $
 *       Module Name      : $Workfile:   SDE2SHP.java  $
 *       Date into SCCS   : $Date:   Oct 09 2017 10:07:40  $
 *       Date fetched Out : $Modtime:   Oct 09 2017 08:20:10  $
 *       SCCS Version     : $Revision:   1.3  $
 *       Based on 
 *
 *
 *
 *    Author : Upendra Hukeri
 *    SDE2SHP.java
 *
 ****************************************************************************************************
 *	  Copyright (c) 2017 Bentley Systems Incorporated.  All rights reserved.
 ****************************************************************************************************
 *
 */
 
package bentley.exor.gis;

import com.vividsolutions.jts.geom.Geometry;

import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.Serializable;

import java.net.URI;

import java.nio.charset.StandardCharsets;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;

import java.util.Arrays;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Set;

import oracle.jdbc.OracleTypes;

import oracle.sql.STRUCT;

import org.geotools.data.FeatureWriter;
import org.geotools.data.oracle.sdo.GeometryConverter;
import org.geotools.data.shapefile.ShapefileDataStore;
import org.geotools.data.shapefile.ShapefileDataStoreFactory;
import org.geotools.data.Transaction;
import org.geotools.feature.simple.SimpleFeatureBuilder;
import org.geotools.feature.simple.SimpleFeatureTypeBuilder;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;

/**
 * This program writes all the features and there attributes from a database table/view to a Shapefile 
 * and also creates corresponding supporting files.
 */

public class SDE2SHP extends ShapefileUtility {
	private		  String 		whereClause		 	= null;
	private		  String  		whereClauseParams	= null;
	private		  List<String> 	whereClauseValList 	= new ArrayList<String>();
	private		  String[] 		whereClauseValArray = null;
	private		  File 			shapeFile			= null;
	private		  boolean 		needWhereHelp 		= false;
	private		  String 		whereClauseID		= null;
	private		  int    		oracleSRID		   	= 0;
	private		  int    		epsgSRID		   	= 0;
	
	private	static final String ID					= " ID";
	private	static final String WHERE_CLAUSE		= " WHERE CLAUSE";
	private	static final String DESCRIPTION			= " DESCRIPTION";
	
	public SDE2SHP() {
		super();
	}
	
	protected String getHelpMessage() {
		StringBuilder helpMsg  = new StringBuilder();
		
		helpMsg.append("\nUSAGE: java -cp sdeutil.jar bentley.exor.gis.SDE2SHP -help -nc -h db_host -p db_port -s db_sid -u db_username -d db_password -t db_tablename,column_name -w where_clause_id [where_clause_parameters] -f shapefile_name -a column_name_mapping_file -whelp where_clause_id");
		helpMsg.append("\n\tUsage explaination (parameters used):");
		helpMsg.append("\n\t[-help] : Specify this option to see the command line usage of Shapefile Extractor (for command line use only)");
		helpMsg.append("\n\t(-nc)   : Specify this option, if the jar is loaded in database and called from a PL/SQL procedure or function");
		helpMsg.append("\n\t          (no values for this parameter)");
		helpMsg.append("\n\t(-h)    : Host machine with existing Oracle database");
		helpMsg.append("\n\t(-p)    : Host machine's port with existing Oracle database (e.g. 1521)");
		helpMsg.append("\n\t(-s)    : Host machine's SID with existing Oracle database");
		helpMsg.append("\n\t(-u)    : Database user");
		helpMsg.append("\n\t(-d)    : Database user's password");
		helpMsg.append("\n\t(-t)    : Input feature table name and spatial column name (separated by COMMA only)");
		helpMsg.append("\n\t[-w]    : WHERE Clause ID for the query followed by any parameters enclosed in square brackets [] separated by space");
		helpMsg.append("\n\t          (in case parameter value contains space itself enclose the value in double quotes)");
		helpMsg.append("\n\t(-f)    : File name of an output Shapefile WITHOUT EXTENSION");
		helpMsg.append("\n\t[-a]    : File name containing column-name(attribute) mappings WITH EXTENSION");
		helpMsg.append("\n\t(-whelp): WHERE Clause ID for which details are required (for command line use only)");
		helpMsg.append("\n\t          (use ID 'all' for details of all available WHERE clauses)");
		helpMsg.append("\n\n\tNOTE: \t() indicate MANDATORY ALTERNATE field e.g. either (-nc) or (-h -p -s -u -d) AND  either (-whelp) or (-t -f)");
		helpMsg.append("\n\t\t[] indicate OPTIONAL field");
		
		return helpMsg.toString();
	}
	
	private void init(String[] nuh) {
		String		 usage			= "\nError: following key(s)/value(s) is/are missing: ";
		String 		 cmdLineArgsStr	= Arrays.deepToString(nuh);
		int			 numOfErrors 	= 0;
		
		Set <String> validKeySet	= new HashSet<String>(Arrays.asList(ShapefileUtility.validExtractKeysArray));
		List<String> argumentsList 	= new ArrayList<String>(Arrays.asList(nuh));
		List<String> missingKV 		= new ArrayList<String>();
		Map <String, String> hm  	= new HashMap<String, String>();
		
		try {
			for (Enumeration e = Collections.enumeration(argumentsList); e.hasMoreElements();) {
				String key   = null;
				String value = null;
		
				key = (String) e.nextElement();
				boolean isNormalParam = true;
				
				if("-nc".equals(key)) {
					hm.put(key, null);
					isNormalParam = false;
				} else if ("-w".equals(key)) {
					try {
						value = (String) e.nextElement();
						
						if (value != null && !value.isEmpty()) {
							hm.put(key, value);
							
							try {
								key = (String) e.nextElement();
								
								if(key.startsWith("[")) {
									isNormalParam = false;
									
									if((cmdLineArgsStr.length() > (cmdLineArgsStr.replace("[", "").length() + 2)) || (cmdLineArgsStr.length() > (cmdLineArgsStr.replace("]", "").length() + 2))) { 
										setErrorMsg("\nError: square brackets [] not allowed in WHERE clause values");
										writeLog(getErrorMsg(), false);
										setExitSystem(true);
									} else {
										boolean isCloseBracket = false;
										
										if("[".equals(key)) {
											key = (String) e.nextElement();
										} else {
											key = key.substring(1);
										}
											
										if(key.endsWith("]")) {
											key = key.substring(0, key.length() - 1);
											whereClauseParams = key.length() + "$" + key;
											whereClauseValList.add(key);
											isCloseBracket = true;
											
											continue;
										}
									
										whereClauseParams = key.length() + "$" + key;
										whereClauseValList.add(key);
										
										while(e.hasMoreElements()) {
											key = (String) e.nextElement();
											
											if("]".equals(key)) {
												isCloseBracket = true;
												break;
											} else if(key.endsWith("]")) {
												key = key.substring(0, key.length() - 1);
												whereClauseParams += key.length() + "$" + key;
												whereClauseValList.add(key);
												
												isCloseBracket = true;
												
												break;
											}
											
											whereClauseParams += key.length() + "$" + key;
											whereClauseValList.add(key);
										}
										
										if(!isCloseBracket) {
											setErrorMsg("\nError: missing WHERE clause parameters closing bracket");
											writeLog(getErrorMsg(), false);
											setExitSystem(true);
											
											break;
										}
									}
								}
							} catch(NoSuchElementException nseException) {
								isNormalParam = false;
							}
						}
					} catch(NoSuchElementException nseException) {
						missingKV.add("missing value for: " + key);
						numOfErrors++;
					}
				} 
				
				if(isNormalParam) {
					try {
						value = (String) e.nextElement();
					} catch(NoSuchElementException nseException) {
						missingKV.add("missing value for: " + key);
						numOfErrors++;
					}
					
					if (key != null && value != null && !key.isEmpty() && !value.isEmpty()) {
						hm.put(key, value);
					}
				}
			}
			
			if(!getExitSystem()) {
				if (hm.containsKey("-nc")) {
					writeLog("use_nested_connection: true", false);
				}
				
				if(!getUseNestedConn()) {
					if (hm.containsKey("-h")) {
						setHost((String) hm.get("-h"));
						writeLog("host: " + getHost(), false);
					} else {
						missingKV.add("-h db_host");
						numOfErrors++;
					}
					
					if (hm.containsKey("-p")) {
						setPort(Integer.parseInt((String) hm.get("-p")));
						writeLog("port: " + getPort(), false);
					} else {
						missingKV.add("-p db_port");
						numOfErrors++;
					}
					
					if (hm.containsKey("-s")) {
						setSID((String) hm.get("-s"));
						writeLog("sid: " + getSID(), false);
					} else {
						missingKV.add("-s db_sid");
						numOfErrors++;
					}
					
					if (hm.containsKey("-u")) {
						setUserName((String) hm.get("-u"));
						writeLog("db_username: " + getUserName(), false);
					} else {
						missingKV.add("-u db_username");
						numOfErrors++;
					}
					
					if (hm.containsKey("-d")) {
						setPassword((String) hm.get("-d"));
						writeLog("db_password: *******", false);
					} else {
						missingKV.add("-d password");
						numOfErrors++;
					}
				}
				
				if (hm.containsKey("-t")) {
					String tableColumn = ((String) hm.get("-t")).toUpperCase(Locale.ENGLISH);
					writeLog("db_tablename: " + tableColumn, false);
					
					String[] tabCol = tableColumn.split(",");
					
					if (tabCol.length != 2) {
						missingKV.add("wrong value passed to -t, usage: -t db_tablename,column_name");
						numOfErrors++;
					} else {
						setViewName(tabCol[0]);
						
						if(!conformOracleNamingConvention(getViewName())) {
							missingKV.add("wrong value passed to -t, special characters not allowed in table name (allowed: A-Z a-z 0-9 _ $ #)");
							numOfErrors++;
						}
						
						setGeomColName(tabCol[1]);
						
						if(!conformOracleNamingConvention(getGeomColName())) {
							missingKV.add("wrong value passed to -t, special characters not allowed in geometry column name (allowed: A-Z a-z 0-9 _ $ #)");
							numOfErrors++;
						}
					}
				} else if(!hm.containsKey("-whelp")) {
					missingKV.add("-t db_tablename,column_name");
					numOfErrors++;
				}
				
				if (hm.containsKey("-w")) {
					whereClause = (String) hm.get("-w");
					writeLog("where_clause_id: " + whereClause, false);
					
					if(whereClauseParams != null && !whereClauseParams.isEmpty()) {
						writeLog("where_clause_parameters: " + Arrays.deepToString(whereClauseValList.toArray()), false);
					}
				} else {
					whereClause = "";
				}
				
				if (hm.containsKey("-whelp")) {
					whereClauseID = (String) hm.get("-whelp");
					needWhereHelp = true;
					writeLog("need_where_clause_details: " + whereClauseID, false);
				} else {
					whereClauseID = "";
				}
				
				if (hm.containsKey("-f")) {
					setSHPFileName((String) hm.get("-f"));
					writeLog("shapefile_name: " + getSHPFileName() + ".shp", false);
					
					if(getSHPFileName().indexOf('\\') > -1 || getSHPFileName().indexOf('/') > -1) {
						missingKV.add("wrong value passed to -f, path not allowed here");
						numOfErrors++;
					}
				} else if(!hm.containsKey("-whelp")) {
					missingKV.add("-f shapefile_name");
					numOfErrors++;
				}
					
				if (hm.containsKey("-a")) {
					setColMapFileName((String) hm.get("-a"));
					writeLog("use_column_mapping: true, file name: " + getColMapFileName(), false);
					
					if(getColMapFileName().indexOf('\\') > -1 || getColMapFileName().indexOf('/') > -1) {
						missingKV.add("wrong value passed to -a, path not allowed here");
						numOfErrors++;
					}
					
					setUseColumnMapping(true);
				} else {
					writeLog("use_column_mapping: false", false);
				}
				
				Set<String> keySet 		= hm.keySet();
				Iterator 	keyIterator = keySet.iterator();
				
				while(keyIterator.hasNext()) {
					String currKey = (String)keyIterator.next();
					
					if(!validKeySet.contains(currKey)) {
						setErrorMsg("\nError: invalid key - " + currKey);
						writeLog(getErrorMsg(), false);
						setExitSystem(true);
					}
				}
				
				if(!getExitSystem()) {
					if (numOfErrors > 0) {
						writeLog(usage, false);
						
						Iterator itr = missingKV.iterator();
						
						while(itr.hasNext()) {
							writeLog("\t\t" + itr.next(), false);
						}
						
						setErrorMsg("\nError: missing key(s), please check system log file for more details");
						setExitSystem(true);
					} else if (!needWhereHelp) {
						shapeFile = getNewShapeFile();
						
						systemExit();							
						setLogger(new BufferedWriter(new OutputStreamWriter(new FileOutputStream(setLogFile("sde2shp")), StandardCharsets.UTF_8)));
						writeLog("starting extract process...");
					}
				}
			}
		} catch (Exception initException) {
			setErrorMsg("\nError: " + initException.getMessage());
			logException(initException, "<init>");
			writeLog(ShapefileUtility.SDE2SHPFAILUREMSG, false);
			setExitSystem(true);
		}
	}
	
	public static String createShapeFileDB(java.sql.Array array) {
		String[] nuh = null;
		
		try {
			Object params = array.getArray();
			int arrayLength = java.lang.reflect.Array.getLength(params);
			nuh = new String[arrayLength];
			
			for (int i=0; i<arrayLength; i++) {
				nuh[i] = String.valueOf(java.lang.reflect.Array.get(params, i));
			}
		} catch(SQLException createShapeFileDBException) {
			return createShapeFileDBException.getMessage();
		}
		
		SDE2SHP sde2shp = new SDE2SHP();
		sde2shp.doExtract(nuh, sde2shp);
		String errorMessage = sde2shp.getErrorMsg();
		
		if(errorMessage != null) {
			errorMessage = sde2shp.getSystemLogFileName() + '\n' + errorMessage;
			
			if(errorMessage.length() > 32767) {
				return errorMessage.substring(0, 32767);
			} 
			
			return errorMessage;
		} else {
			return "success" + '\n' + sde2shp.getSystemLogFileName();
		}
	}
	
	public static void main(String[] nuh) {
		SDE2SHP sde2shp = new SDE2SHP();
		sde2shp.doExtract(nuh, sde2shp);
	}
	
	protected void doExtract(String[] nuh, SDE2SHP sde2shp) {
		try {
			if(nuh != null && nuh.length >= 1) {
				if(Arrays.asList(nuh).contains("-nc")) {
					sde2shp.setUseNestedConn(true);
				}
				
				if(Arrays.asList(nuh).contains("-help")) {
					if(sde2shp.getUseNestedConn()) {
						sde2shp.setErrorMsg("Error: -help is for command line usage only");
					} else {
						System.out.println(sde2shp.getHelpMessage());
					}
				} else {
					if(sde2shp.getUseNestedConn() && Arrays.asList(nuh).contains("-whelp")) {
						sde2shp.setErrorMsg("Error: -whelp is for command line usage only");
					} else {
						String result = sde2shp.setBasicDirectories("sde2shp");
						
						if("Y".equals(result)) {
							sde2shp.init(nuh);
							
							if(!sde2shp.getExitSystem()) {
								if(sde2shp.needWhereHelp) {
									System.out.println(sde2shp.displayWhereClauseDetails(sde2shp.whereClauseID));
								} else {
									sde2shp.setColumnMap();
									
									if(!sde2shp.getExitSystem()) {
										int numOfRows = sde2shp.generateShapeFile();
										
										if (numOfRows > 0) {
											sde2shp.writeLog(String.valueOf(numOfRows) + " features added to shapefile");
											sde2shp.writeLog("shapefile creation is complete: " + sde2shp.shapeFile.getName());
											
											System.out.println(ShapefileUtility.SHPSUCCESSMSG);
										} else {
											if(numOfRows == 0) {
												sde2shp.writeLog("\nError: no records found...", false);
											} else if(numOfRows == -1) {
												sde2shp.writeLog(sde2shp.getErrorMsg(), false);
											}
											
											sde2shp.writeLog(ShapefileUtility.SDE2SHPFAILUREMSG, false);
										}
									} else {
										writeLog(ShapefileUtility.SHP2SDEFAILUREMSG, false);
									}
								}
							}
						} else {
							sde2shp.setErrorMsg(result);
						}
					}
				}
			} else {
				System.out.println("\nError: Invalid argument/s passed..." + sde2shp.getHelpMessage());
			}
		} catch (Throwable doExtractException) {
			sde2shp.logException(doExtractException, "doExtract");
			sde2shp.writeLog(ShapefileUtility.SDE2SHPFAILUREMSG, false);
		} finally {
			sde2shp.systemExit();
		}
	}
	
	protected int generateShapeFile() 
	throws Throwable {
		int 					  numOfRows			= 0;
		int 					  numOfColumns 		= 0;
		String 					  shapeQuery 		= null;
		String 					  sridQuery 		= null;
		String 					  typeName2 		= null;
		QuerryConnectionDetails	  shapefileData 	= null;
		ResultSet				  viewData 			= null;
		ResultSetMetaData 		  viewMD 			= null;
		Connection 				  con				= null;
		boolean 				  checkSRID			= true;
		ShapefileDataStore 		  newDataStore 		= null;
		ShapefileDataStoreFactory dataStoreFactory 	= null;
		Map<String, Serializable> params 			= null;
		File 					  dir				= null;
		
		try {
			dataStoreFactory = new ShapefileDataStoreFactory();
			dir = new File(getDirectoryPath(Directory.EXTRACTDIR));
			
			if (!dir.exists()) {
				throw new FileNotFoundException("Path - " + getDirectoryPath(Directory.EXTRACTDIR) + " - not found!");
			}
			
			shapefileData   = getData();
			
			if(shapefileData != null) {
				con 			= shapefileData.conn;
				viewData 		= shapefileData.resultSet;
				viewMD 			= viewData.getMetaData();
				numOfColumns 	= viewMD.getColumnCount();
				
				SimpleFeatureType TYPE 		 = null;
				SimpleFeatureType TYPEPrevs  = null;
				
				FeatureWriter<SimpleFeatureType, SimpleFeature> sfw = null;
				
				while (viewData.next()) {
					List columns = new ArrayList();
					List row = new ArrayList();
					
					SimpleFeatureBuilder featureBuilder = null;
					
					for (int i = 1; i <= numOfColumns; i++) {
						int 		size 			= -1;
						String 		columnName 		= viewMD.getColumnName(i);
						String 		classTypeName 	= viewMD.getColumnClassName(i);
						String 		typeName 		= viewMD.getColumnTypeName(i);
						String 		srs 			= null;
						int 		nullable		= viewMD.isNullable(i);
						Map 		typeForShp 		= new HashMap();
						Class<?> 	cls 			= null;
						
						if("get_data_exp".equalsIgnoreCase(columnName)) {
							String errorText = viewData.getString(columnName);
							setErrorMsg("\nError: " + errorText);
							
							return -1;
						}
						
						if ("java.lang.String".equals(classTypeName)) {
							size = viewMD.getColumnDisplaySize(i);							
						} else if ("java.math.BigDecimal".equals(classTypeName) && viewMD.getScale(i) == 0) {
							int precision = viewMD.getPrecision(i);
							
							if(precision > 0) {
								if (precision <= 9) {
									classTypeName = "java.lang.Integer";
								} else if (precision <= 18) {
									classTypeName = "java.lang.Long";
								}
								
								size = precision;
							} else {
								size = 38;
							}
						} else if ("java.math.BigDecimal".equals(classTypeName) && viewMD.getScale(i) != 0) {
							size = 38;
						}
						
						if (getGeometryColumnClass().equals(classTypeName)) {
							if (checkSRID) {
								String viewNameWOSchema = getViewName();
								
								if (viewNameWOSchema.contains(".")) {
									String[] s = viewNameWOSchema.split("\\.");
									viewNameWOSchema = s[1];
								}
								
								String result = getSRID();
								
								if(!"Y".equals(result)) {
									return -1;
								} else if(epsgSRID == 0) {
									setErrorMsg("\nError: no SRID found, check the Geometry for column: '" + columnName + "'");
									return -1;
								}
								
								writeLog("found geometry column: '" + columnName + "' with Oracle SRID: " + oracleSRID + " (EPSG SRID - " + epsgSRID + ')');
								
								
								checkSRID = false;
							}
							
							Object geometry = viewData.getObject(columnName);
							STRUCT sqlGeo   = getSTRUCT(geometry);
							
							GeometryConverter gc = new GeometryConverter((oracle.jdbc.OracleConnection) con);
							Geometry gt = gc.asGeometry(sqlGeo);
	
							row.add(0, gt);
							
							classTypeName = gt.getClass().toString().split(" ")[1];
							
							srs = "EPSG:" + epsgSRID;
							
							gt = null;
							gc = null;
							sqlGeo = null;
						} else if ("com.vividsolutions.jts.geom.Point".equals(classTypeName)) {
							classTypeName = "com.vividsolutions.jts.geom.MultiPoint";
						} else if ("com.vividsolutions.jts.geom.LineString".equals(classTypeName)) {
							classTypeName = "com.vividsolutions.jts.geom.MultiLineString";
						} else if ("com.vividsolutions.jts.geom.Polygon".equals(classTypeName)) {
							classTypeName = "com.vividsolutions.jts.geom.MultiPolygon";
						} else {
							Map<String, Class<?>> m = new HashMap<String, Class<?>>();
							cls = viewMD.getClass();
							m.put(typeName, cls);
							
							Object value = viewData.getObject(columnName, m);
							
							row.add(value);
							
							value = null;
						}
						
						if (numOfRows == 0) {
							typeForShp.put("name", columnName);
							typeForShp.put("className", classTypeName);
							typeForShp.put("size", size);
							typeForShp.put("srs", srs);
							typeForShp.put("nullable", nullable);
							
							columns.add(typeForShp);
						}
					}
					
					if (numOfRows == 0) {
						writeLog("writing features to shapefile...");
						TYPE = getFeatureType(getViewName(), columns);
						params = new HashMap<String, Serializable>();
						params.put("url", shapeFile.toURI().toURL());
						params.put("create spatial index", Boolean.TRUE);
						newDataStore = (ShapefileDataStore) dataStoreFactory.createNewDataStore(params);
						
						newDataStore.createSchema(TYPE);
						typeName2 = newDataStore.getTypeNames()[0];
						sfw = newDataStore.getFeatureWriter(typeName2, Transaction.AUTO_COMMIT);
						sfw.hasNext();
						
						SimpleFeature feature = (SimpleFeature) sfw.next();
						feature.setAttributes(row);
						
						sfw.write();
						sfw.close();
						
						newDataStore.dispose();
						
						numOfRows++;
						
						continue;
					} 
					
					if (numOfRows == 1) {
						newDataStore = (ShapefileDataStore) dataStoreFactory.createDataStore(shapeFile.toURI().toURL());
						newDataStore.getSchema();					
						sfw = newDataStore.getFeatureWriterAppend(typeName2, Transaction.AUTO_COMMIT);
					}
					
					sfw.hasNext();
					
					SimpleFeature feature = (SimpleFeature) sfw.next();
					feature.setAttributes(row);
					
					sfw.write();
					
					numOfRows++;
				}
				
				if (numOfRows > 0) {
					sfw.close();
					newDataStore.dispose();
				}
				
				if (!viewData.isClosed())
					viewData.close();
				if (!con.isClosed())
					con.close();
			} else {
				return -2;
			}
			
			return numOfRows;
		} finally {
			if(shapefileData != null) {
				closeOracle("generateShapeFile", shapefileData.cstmt, shapefileData.conn, shapefileData.resultSet);
			}
		}
	}
	
	protected SimpleFeatureType getFeatureType(String featureTypeName, List attributes) 
	throws ClassNotFoundException, IOException, Exception {
		SimpleFeatureTypeBuilder builder = new SimpleFeatureTypeBuilder();
		
		String 	name 		= null;
		String 	className 	= null;
		String 	srs  		= null;
		int 	size 		= -1;
		int 	nullable  	= -1;
		
		builder.setName(featureTypeName);
		URI namespaceURI = null;
		builder.setNamespaceURI(namespaceURI);
		
		Iterator attribItr = attributes.iterator();
		
		while (attribItr.hasNext()) {
			
			Map attribute = (HashMap) attribItr.next();
			
			name 		= (String)  attribute.get("name");
			className 	= (String)  attribute.get("className");
			srs 		= (String)  attribute.get("srs");
			size 		= (Integer) attribute.get("size");
			nullable	= (Integer) attribute.get("nullable");
			
			if ((name != null) && (className != null)) {
				if (srs != null) {
					builder.srs(srs);
				} 
				
				if (size != -1) {
					builder.length(size);
				} 
				
				if (nullable == 0) {
					builder.nillable(false);
				} else {
					builder.nillable(true);
				}
				
				builder.add(name, Class.forName(className));
			}
		}
		
		return builder.buildFeatureType();
	}
	
	protected final File getNewShapeFile() {
		File shapeFile = null;
		
		if (getSHPFileName() != null) 
			if (!getSHPFileName().isEmpty()) {
				shapeFile = new File(getDirectoryPath(Directory.EXTRACTDIR) + getSHPFileName() + ".shp");
			}
		
		return shapeFile;
	}
	
	protected String getGeometryColumnClass() {
		if(getUseNestedConn()) {
			return "oracle.jdbc.OracleStruct";
		} else {
			return "oracle.sql.STRUCT";
		}
	}
	
	protected STRUCT getSTRUCT(Object geometry) throws Exception  {
		return (STRUCT) geometry;
	}
	
	protected void writeLog(String log) {
		writeLog(log, true);
	}
	
	private QuerryConnectionDetails getData() {
		String 		  				sqlStmt			= null;
		QuerryConnectionDetails 	shapefileData	= new QuerryConnectionDetails();
		oracle.sql.ArrayDescriptor 	des				= null;
		oracle.sql.ARRAY 			colArrToPass	= null;
		oracle.sql.ARRAY 			whereArrToPass	= null;
		
		try {
			shapefileData.conn = getConnection();
			
			if(getColumnMapArray() != null && getColumnMapArray().length > 0) {
				des = oracle.sql.ArrayDescriptor.createDescriptor("SDE_VARCHAR_2D_ARRAY", shapefileData.conn);
				colArrToPass = new oracle.sql.ARRAY(des, shapefileData.conn, getColumnMapArray());
			}
			
			if(whereClauseValList.size() > 0) {
				whereClauseValArray = whereClauseValList.toArray(new String[whereClauseValList.size()]);
				
				des = oracle.sql.ArrayDescriptor.createDescriptor("SDE_VARCHAR_ARRAY", shapefileData.conn);
				whereArrToPass = new oracle.sql.ARRAY(des, shapefileData.conn, whereClauseValArray);
			}
			
			sqlStmt = "{? = call sde_util.get_data(?, ?, ?, ?)}";
			shapefileData.cstmt   = shapefileData.conn.prepareCall(sqlStmt);
			shapefileData.cstmt.registerOutParameter(1, OracleTypes.CURSOR);
			shapefileData.cstmt.setString(2, getViewName());
			
			if(colArrToPass == null) {
				shapefileData.cstmt.setNull(3, Types.ARRAY, "SDE_VARCHAR_2D_ARRAY");
			} else {
				shapefileData.cstmt.setArray(3, colArrToPass);
			}
			
			shapefileData.cstmt.setString(4, whereClause);
			
			if(whereArrToPass == null) {
				shapefileData.cstmt.setNull(5, Types.ARRAY, "SDE_VARCHAR_ARRAY");
			} else {
				shapefileData.cstmt.setArray(5, whereArrToPass);
			}
			
			shapefileData.cstmt.execute();
			
			shapefileData.resultSet = (ResultSet)shapefileData.cstmt.getObject(1);
			
			return shapefileData;
		} catch(Exception getDataException) {
			logException(getDataException, "getData");
			
			return null;
		}
	}
	
	private String getSRID() 
	throws SQLException, ClassNotFoundException, Exception {
		Connection        conn    = null;
		CallableStatement cstmt   = null;
		String 			  result  = null;
		String 			  sqlStmt = null;
		
		try {
			conn = getConnection();
			
			sqlStmt = "{? = call sde_util.get_srid(?, ?, ?, ?)}";
			cstmt   = conn.prepareCall(sqlStmt);
			cstmt.registerOutParameter(1, Types.VARCHAR);
			cstmt.setString(2, getViewName());
			cstmt.setString(3, getGeomColName());
			cstmt.registerOutParameter(4, Types.NUMERIC);
			cstmt.registerOutParameter(5, Types.NUMERIC);
			cstmt.execute();
			
			result = cstmt.getString(1);
			
			if("Y".equals(result)) {
				oracleSRID 	= cstmt.getInt(4);
				epsgSRID 	= cstmt.getInt(5);
				
				return "Y";
			} else {
				setErrorMsg("\nError: " + result);
				return "N";
			}
		} finally {
			closeOracle("getSRID", cstmt, conn, null);
		}
	}
	
	private QuerryConnectionDetails getWhereCaluseDetails(String whereClauseID) 
	throws SQLException {
		String 			  			sqlStmt 		= null;
		QuerryConnectionDetails     whereClauseData = new QuerryConnectionDetails();
		
		try {
			if("all".equalsIgnoreCase(whereClauseID)) {
				whereClauseID = null;
			}
			
			whereClauseData.conn = getConnection();
			sqlStmt = "{? = call sde_util.get_where_clause_details(?)}";
			whereClauseData.cstmt   = whereClauseData.conn.prepareCall(sqlStmt);
			whereClauseData.cstmt.registerOutParameter(1, OracleTypes.CURSOR);
			whereClauseData.cstmt.setString(2, whereClauseID);
			whereClauseData.cstmt.execute();
			whereClauseData.resultSet = (ResultSet)whereClauseData.cstmt.getObject(1);
			
			return whereClauseData;
		} catch(Exception validateColumnNamesException) {
			logException(validateColumnNamesException, "validateColumnNames");
		}
		
		return whereClauseData;
	}
	
	private String displayWhereClauseDetails(String whereClauseID) {
		ResultSet 		  		whereClauseDetails	= null;
		ResultSetMetaData 		whereMD				= null;
		int 			  		numOfColumns		= 0;
		QuerryConnectionDetails	whereClauseData		= null;
		List<List<String>>		details			 	= null;
		
		final StringBuilder whereClauseDetailsStr 	= new StringBuilder();
		
		List<Integer> maxLenList = new ArrayList<Integer>();
		
		maxLenList.add(ID.length());
		maxLenList.add(WHERE_CLAUSE.length());
		maxLenList.add(DESCRIPTION.length());
		
		try {
			whereClauseData = getWhereCaluseDetails(whereClauseID);
			
			if(whereClauseData != null && whereClauseData.resultSet != null) {
				details				= new ArrayList<List<String>>();
				whereClauseDetails 	= whereClauseData.resultSet;
				whereMD 		 	= whereClauseDetails.getMetaData();
				numOfColumns 		= whereMD.getColumnCount();
				
				while (whereClauseDetails.next()) {
					List<String> row = new ArrayList<String>();
					
					for (int i = 1; i <= numOfColumns; i++) {
						String columnName = whereMD.getColumnName(i);
						String value 	  = whereClauseDetails.getString(columnName);
						int    valuelen   = value.length();
						
						if("where_clause_exp".equalsIgnoreCase(columnName)) {
							return value;
						}
						
						row.add(value);
						maxLenList.set(i-1, maxLenList.get(i-1) > valuelen ? maxLenList.get(i-1) : valuelen);
					}
					
					details.add(row);
				}
				
				if(details.size() > 0) {
					Iterator rowIterator = details.iterator();
					
					int totalMaxLen = maxLenList.get(0) + maxLenList.get(1) + maxLenList.get(2) + 12;
					
					whereClauseDetailsStr.append('\n');
					
					whereClauseDetailsStr.append(String.format("%1$-" + totalMaxLen     		 + "s", "").replace(' ', '-')).append('\n');
					whereClauseDetailsStr.append(String.format("%1$-" + (maxLenList.get(0) 	+ 4) + "s", ID));
					whereClauseDetailsStr.append(String.format("%1$-" + (maxLenList.get(1) 	+ 4) + "s", WHERE_CLAUSE));
					whereClauseDetailsStr.append(String.format("%1$-" + (maxLenList.get(2) 	+ 4) + "s", DESCRIPTION)).append('\n');
					whereClauseDetailsStr.append(String.format("%1$-" + totalMaxLen     		 + "s", "").replace(' ', '-')).append('\n');
					
					while(rowIterator.hasNext()) {
						Iterator colIterator = ((List)rowIterator.next()).iterator();
						int j = 0;
						
						while(colIterator.hasNext()) {
							String value = ' ' + (String)colIterator.next();
							whereClauseDetailsStr.append(String.format("%1$-" + (maxLenList.get(j) + 4) + "s", value));
							j++;
						}
						
						whereClauseDetailsStr.append('\n');
					}
					
					whereClauseDetailsStr.append(String.format("%1$-" + totalMaxLen + "s", "").replace(' ', '-')).append('\n');
					maxLenList.clear();
					
					return whereClauseDetailsStr.toString();
				} else {
					return "No records found";
				}
				
			} else {
				return "Error: something went wrong, error getting WHERE clause details";
			}
		} catch(Exception displayWhereClauseDetailsException) {
			logException(displayWhereClauseDetailsException, "displayWhereClauseDetails");
			return displayWhereClauseDetailsException.getMessage();
		} finally {
			if(whereClauseData != null) {
				closeOracle("displayWhereClauseDetails", whereClauseData.cstmt, whereClauseData.conn, whereClauseData.resultSet);
			}
		}
	}
	
	private class QuerryConnectionDetails {
		Connection        conn      = null;
		CallableStatement cstmt     = null;
		ResultSet         resultSet = null;
	}
	
	public String toString() { 
        return super.toString().replace("ShapefileUtility:", "SDE2SHP:");
    }
}
