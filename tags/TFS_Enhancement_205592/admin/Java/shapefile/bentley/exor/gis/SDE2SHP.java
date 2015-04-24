/**
 *    PVCS Identifiers :-
 *
 *       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/Java/shapefile/bentley/exor/gis/SDE2SHP.java-arc   1.0   Apr 24 2015 06:17:06   Upendra.Hukeri  $
 *       Module Name      : $Workfile:   SDE2SHP.java  $
 *       Date into SCCS   : $Date:   Apr 24 2015 06:17:06  $
 *       Date fetched Out : $Modtime:   Apr 24 2015 06:03:14  $
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
 
package bentley.exor.gis;

import com.vividsolutions.jts.geom.Geometry;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.io.Serializable;
import java.io.StringWriter;

import java.net.URI;

import java.sql.*;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

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

public class SDE2SHP {
	private String 	host 			 = null;
	private int 	port			 = 0;
	private String 	userName		 = null;
	private String 	password		 = null;
	private String 	sid				 = null;
	private String 	viewName		 = null; 
	private String 	whereClause		 = null;
	private String  shpFileName 	 = null;
	
	private String	attributeMode	 = null;
	private Map<String, String> 	attributeMap	 = new HashMap<String, String>();
	private boolean	useAttribMapping = false;
	private String	queryColumns	 = null;
	
	private String  geomColName 	 = null;
	
	private File 	shapeFile 		 = null;
	private File 	logFile			 = null;
	private String	logFilePath		 = null;
	
	private static 	BufferedWriter logger = null;
	
	private Vector 	v 				= new Vector();
	private HashMap hm 				= new HashMap();
	
	private String 	value 			= null;
	private String 	key 			= null;
	
	private String 	usage 			= "\nError: The following mandatory key(s)/value(s) is/are missing: ";
	private static final String 	SHPFAILUREMSG 		= "shapefile creation failed!";
	private static final String 	SHPSUCCESSMSG 		= "success";
	
	private static final int 		SHPSUCCESSMSGNUM 		= 1;
	
	private static String 			errorMsg = null;
	
	public SDE2SHP () {
		errorMsg  = "\n\t\tUSAGE: java -jar sde2shp.jar -h db_host -p db_port -s db_sid -u db_username -d db_password -t db_tablename,column_name -w where_clause -f shapefile_name -a attribute_map_file";
		errorMsg += "\n\t\tUsage explanation (parameters used):";
		errorMsg += "\n\t\t<-h>: Host machine with existing Oracle database";
		errorMsg += "\n\t\t<-p>: Host machine's port with existing Oracle database (e.g. 1521)";
		errorMsg += "\n\t\t<-s>: Host machine's SID with existing Oracle database";
		errorMsg += "\n\t\t<-u>: Database user";
		errorMsg += "\n\t\t<-d>: Database user's password";
		errorMsg += "\n\t\t<-t>: Input feature table name and spatial column name (separated by COMMA only)";
		errorMsg += "\n\t\t[-w]: Where Clause for the query";
		errorMsg += "\n\t\t<-f>: File name of an output Shapefile WITHOUT EXTENSION";
		errorMsg += "\n\t\t[-a]: Attribute Mapping File WITH EXTENSION";
		errorMsg += "\n\n\t\tNOTE: \t<> indicates MANDATORY field";
		errorMsg += "\n\t\t\t\t[] indicates OPTIONAL field";
	}
	
	public SDE2SHP (String[] args) {
		int numOfErrors = 0;
		String[] missingKV = new String[8];
		
		try {
			for (int j = 0; args.length > j; j++) {
				v.add(j, args[j]);
			}

			for (Enumeration e = v.elements(); e.hasMoreElements();) {
				try {
					key = (String) e.nextElement();
					value = (String) e.nextElement();
					
					if (key != null && value != null) {
						hm.put(key, value);
					}
				} catch (Exception ex) {
					writeLog(logger, "\nError: One of your key-value pairs failed. Please try again." + errorMsg);
					systemExit(logger);
				}
			}
						
			if (hm.containsKey("-h")) {
				writeLog(logger, "host: " + (String) hm.get("-h"));
				this.host = (String) hm.get("-h");
			} else {
				missingKV[numOfErrors] = "-h db_host";
				numOfErrors++;
			}

			if (hm.containsKey("-p")) {
				writeLog(logger, "port: " + (String) hm.get("-p"));
				this.port = Integer.parseInt((String) hm.get("-p"));
			} else {
				missingKV[numOfErrors] = "-p db_port";
				numOfErrors++;
			}

			if (hm.containsKey("-s")) {
				writeLog(logger, "sid: " + (String) hm.get("-s"));
				this.sid = (String) hm.get("-s");
			} else {
				missingKV[numOfErrors] = "-s db_sid";
				numOfErrors++;
			}

			if (hm.containsKey("-u")) {
				writeLog(logger, "db_username: " + (String) hm.get("-u"));
				this.userName = (String) hm.get("-u");
			} else {
				missingKV[numOfErrors] = "-u db_username";
				numOfErrors++;
			}

			if (hm.containsKey("-d")) {
				writeLog(logger, "db_password: ******");
				this.password = (String) hm.get("-d");
			} else {
				missingKV[numOfErrors] = "-d password";
				numOfErrors++;
			}

			if (hm.containsKey("-t")) {
				writeLog(logger, "db_tablename: " + ((String) hm.get("-t")).toUpperCase());
				String[] tabCol = ((String) hm.get("-t")).toUpperCase().split(",");
				
				if (tabCol.length != 2) {
					writeLog(logger, "\nError: wrong value passed to -t: usage: -t db_tablename,column_name");
					systemExit(logger);
				}
				
				this.viewName = tabCol[0];
				this.geomColName = tabCol[1];
			} else {
				missingKV[numOfErrors] = "-t db_tablename,column_name";
				numOfErrors++;
			}

			if (hm.containsKey("-w")) {
				writeLog(logger, "where_clause: " + (String) hm.get("-w"));
				this.whereClause = (String) hm.get("-w");
			} else {
				this.whereClause = "";
			}

			if (hm.containsKey("-f")) {
				writeLog(logger, "shapefile_name: " + ((String) hm.get("-f")).replace("\\\\", "\\") + ".shp");
				this.shpFileName = (String) hm.get("-f");
			} else {
				missingKV[numOfErrors] = "-f shapefile_name";
				numOfErrors++;
			}
			
			if (hm.containsKey("-a")) {
				writeLog(logger, "attribute_map_file: " + (String) hm.get("-a"));
				this.attributeMode = (String) hm.get("-a");
			} else {
				this.attributeMode = "";
			}
			
			if (numOfErrors > 0) {
				writeLog(logger, usage);
				
				for (int i=0; i<missingKV.length; i++) {
					String missingKVDescr = missingKV[i];
					
					if (missingKVDescr != null) {
						writeLog(logger, "\t\t" + missingKVDescr);
					}
				}
				
				systemExit(logger);
			}
			
			shapeFile 			= getNewShapeFile();
			logFile				= setLogFile();
						
			if(new File(logFilePath).isDirectory()) {
				logger.flush();
				logger.close();
				
				logger = new BufferedWriter(new FileWriter(logFile));
				writeLog(logger, new Date().toString() + ": starting extract process...");
			} else {
				writeLog(logger, "\nError: Cannot find the path specified to create Log file - " + logFilePath.replace("\\\\", "\\"));
				
				systemExit(logger);
			}
			
			
			this.setAttributeMap();
		} catch (Exception constructorException) {
			writeLog(logger, "\nError: Exception constructorException caught...");
			StringWriter stw = new StringWriter();
			PrintWriter pw = new PrintWriter(stw);
			constructorException.printStackTrace(pw);
			writeLog(logger, stw.toString());
			writeLog(logger, new Date().toString() + ": Error: " + SHPFAILUREMSG);
			systemExit(logger);
		}
	}
	
	public static void main(String[] args) {
		try {
			SDE2SHP sde2shp = new SDE2SHP();
			
			String currentDir = sde2shp.getClass().getProtectionDomain().getCodeSource().getLocation().toURI().getPath().replace("sde2shp.jar", "");
			sde2shp = null;
			
			File systemLog = new File(currentDir + "\\log");
			
			if (!systemLog.isDirectory()) {
				boolean dirCreated = systemLog.mkdir();
				
				if (!dirCreated) {
					System.out.println("\nError: Cannot create system log file.");
					System.exit(1);
				}
			}
			
			DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			Calendar cal = Calendar.getInstance();
			String timeExtension = dateFormat.format(cal.getTime());
			
			systemLog = new File(currentDir + "\\log\\sde2shp_" + timeExtension + ".log");
			
			System.out.println(systemLog.toString());
			
			logger = new BufferedWriter(new FileWriter(systemLog));
			
			if (args.length <= 1) {
				writeLog(logger, new Date().toString() + ": Error: Invalid argument/s passed..." + errorMsg);
			} else {
				sde2shp = new SDE2SHP(args);
				int numOfRows = sde2shp.generateShapeFile();
				
				if (numOfRows > 0) {
					writeLog(logger, new Date().toString() + ": " + numOfRows + " features added to shapefile");
					writeLog(logger, new Date().toString() + ": shapefile creation is complete: " + sde2shp.shapeFile.getName());
					
					System.out.println(SHPSUCCESSMSG);
					//System.out.print(SHPSUCCESSMSGNUM);
				} else {
					writeLog(logger, new Date().toString() + ": Error: no records found...");
					writeLog(logger, new Date().toString() + ": Error: " + SHPFAILUREMSG);
				}
				
			}
		} catch (Exception mainException) {
			String error = new Date().toString() + ": Error: Exception mainException caught...\n";
			
			StringWriter stw = new StringWriter();
			PrintWriter pw = new PrintWriter(stw);
			
			mainException.printStackTrace(pw);
			
			writeLog(logger, error + stw.toString());
			writeLog(logger, new Date().toString() + ": Error: " + SHPFAILUREMSG);
		} finally {
			systemExit(logger);
		}
	}
	
	protected int generateShapeFile () 
	throws ClassNotFoundException, SQLException, IOException, Exception {
		int 				numOfRows		= 0;
		int 				numOfColumns 	= 0;
		int 				srid			= 0;
		
		String 				shapeQuery 		= null;
		String 				sridQuery 		= null;
		String 				typeName2 		= null;
		
		ResultSet 			viewData 		= null;
		ResultSet 			sridData 		= null;
		ResultSetMetaData 	viewMD 			= null;
		Connection 			con				= null;
		
		boolean 			checkSRID		= true;
		
		ShapefileDataStore 	newDataStore 	= null;
		
		ShapefileDataStoreFactory dataStoreFactory = new ShapefileDataStoreFactory();
		
		Map<String, Serializable> params 	= null;
				
		String dirPath = shpFileName.substring(0, shpFileName.lastIndexOf("\\") - 1);
		
		File dir = new File(dirPath);
		
		if (!dir.exists()) {
			throw new FileNotFoundException("Path - " + dirPath + " - not found!");
		}
		
		if (useAttribMapping) {
			shapeQuery = "SELECT " + queryColumns + " FROM ";
		} else {
			shapeQuery = "SELECT * FROM ";
		}
		
		if (this.whereClause == null)
			shapeQuery += this.viewName;
		else if (this.whereClause.isEmpty() || this.whereClause.equalsIgnoreCase("null"))
			shapeQuery += this.viewName;
		else
			shapeQuery += this.viewName + " WHERE " + this.whereClause;
		
		writeLog(logger, new Date().toString() + ": extract running on: '" + this.viewName + "' with query: '" + shapeQuery + "'");
		
		
		con = this.getConnection();
		
		viewData 		= getViewData(con, shapeQuery);
		viewMD 			= viewData.getMetaData();
		
		numOfColumns 	= viewMD.getColumnCount();
		
		List<SimpleFeature> features = new ArrayList<SimpleFeature>();
		SimpleFeatureType TYPE = null;
		SimpleFeatureType TYPEPrevs = null;
		
		FeatureWriter<SimpleFeatureType, SimpleFeature> sfw = null;
		
		while (viewData.next()) {
			List columns 	= null;
			List row 		= null;
			
			columns 		= new ArrayList();
			row 			= new ArrayList();
			
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
								
				if (classTypeName.equals("java.lang.String")) {
					size = viewMD.getColumnDisplaySize(i);							
				} else if (classTypeName.equals("java.math.BigDecimal") && viewMD.getScale(i) == 0) {
					int precision = viewMD.getPrecision(i);
							
					if (precision <= 9) {
						classTypeName = "java.lang.Integer";
					} else if (precision <= 18) {
						classTypeName = "java.lang.Long";
					}
					
					size = precision;
				} else if (classTypeName.equals("java.math.BigDecimal") && viewMD.getScale(i) != 0) {
					size = 38;
				}
				
				if (classTypeName.equals("oracle.sql.STRUCT")) {
					if (checkSRID) {
						String viewNameWOSchema = this.viewName;
						
						if (viewNameWOSchema.contains(".")) {
							String[] s = viewNameWOSchema.split("\\.");
							viewNameWOSchema = s[1];
						}
						
						sridQuery = "SELECT sdo_cs.map_oracle_srid_to_epsg(NVL(srid, 0)) srid FROM user_sdo_geom_metadata WHERE table_name = '" + viewNameWOSchema + "' and column_name = '" + columnName + "'";
						
						sridData		= getViewData(con, sridQuery);
						
						if(sridData.next()) {
							srid			= sridData.getInt("srid");
						} else {
							writeLog(logger, new Date().toString() + ": Error: No SRID found! Check the Geometry for column: '" + columnName + "'");
							
							systemExit(logger);
						}
						
						writeLog(logger, new Date().toString() + ": found geometry column: '" + columnName + "' with SRID: " + srid);
						
						
						checkSRID = false;
					}
					
					STRUCT sqlGeo = (STRUCT) viewData.getObject(columnName);

					GeometryConverter gc = new GeometryConverter((oracle.jdbc.OracleConnection) con);
					Geometry gt = gc.asGeometry(sqlGeo);

					row.add(0, gt);
					
					classTypeName = gt.getClass().toString().split(" ")[1];
					
					srs = "EPSG:" + srid;
					
					gt = null;
					gc = null;
					sqlGeo = null;
				} else if (classTypeName.equals("com.vividsolutions.jts.geom.Point")) {
					classTypeName = "com.vividsolutions.jts.geom.MultiPoint";
				} else if (classTypeName.equals("com.vividsolutions.jts.geom.LineString")) {
					classTypeName = "com.vividsolutions.jts.geom.MultiLineString";
				} else if (classTypeName.equals("com.vividsolutions.jts.geom.Polygon")) {
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
					if (useAttribMapping && (!columnName.equals(geomColName))) {
						columnName = this.getAttributeAlias(columnName);
					}
					
					typeForShp.put("name", columnName);
					typeForShp.put("className", classTypeName);
					typeForShp.put("size", size);
					typeForShp.put("srs", srs);
					typeForShp.put("nullable", nullable);
					
					columns.add(typeForShp);
				}
			}
			
			if (numOfRows == 0) {
				writeLog(logger, new Date().toString() + ": writing features to shapefile...");
				
				
				TYPE = getFeatureType(viewName, columns);
				
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
		}
		
		if (!viewData.isClosed())
			viewData.close();
		if (!con.isClosed())
			con.close();
		
		return numOfRows;
	}
	
	protected Connection getConnection () 
	throws SQLException, ClassNotFoundException, Exception {
		Class.forName("oracle.jdbc.driver.OracleDriver");
		Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@" + this.host + ":" + this.port + ":" + this.sid, this.userName, this.password);
		
		return connection;
	}
	
	protected ResultSet getViewData (Connection con, String query)
	throws SQLException, ClassNotFoundException, Exception {
		Statement statement = con.createStatement();
		ResultSet rs = statement.executeQuery(query);
		
		return rs;
	}
	
	protected SimpleFeatureType getFeatureType (String featureTypeName, List attributes) 
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
		
		final SimpleFeatureType TYPE = builder.buildFeatureType();
		
		return TYPE;
	}
	
	protected File getNewShapeFile() {
		File shapeFile = null;
		
		if (this.shpFileName != null) 
			if (!this.shpFileName.isEmpty())
					shapeFile = new File(this.shpFileName + ".shp");
		
		return shapeFile;
	}
	
	protected File setLogFile() {
		File logFile = null;
		
		if (this.shpFileName != null) 
			if (!this.shpFileName.isEmpty())
					logFile = new File(this.shpFileName + ".log");
		
		this.logFilePath = this.shpFileName.substring(0, (this.shpFileName.lastIndexOf('\\') - 1));
		
		return logFile;
	}
	
	protected File getAttributeMapFile() 
	throws FileNotFoundException {
		File attribMappingFile = null;
		
		if (this.attributeMode != null) {
			if (!this.attributeMode.isEmpty()) {
				attribMappingFile = new File(this.attributeMode);
				if (!attribMappingFile.exists()) {
					throw new FileNotFoundException("File - " + this.attributeMode + " - not found!");
				}
			}
		}
		
		return attribMappingFile;
	}
	
	protected void setAttributeMap () 
	throws IOException, Exception {
		writeLog(logger, new Date().toString() + ": reading attribute mapping file...");
		
		File attribMappingFile = getAttributeMapFile();
		
		if (attribMappingFile != null) {
			BufferedReader attribMappingReader = new BufferedReader(new FileReader(attribMappingFile));
			
			String read = null;
			
			while ((read = attribMappingReader.readLine()) != null) {
				String[] keyValue = read.split(" ");
				this.attributeMap.put(keyValue[0], keyValue[1]);
				
				if (queryColumns == null) {
					queryColumns = keyValue[0];
				} else {
					queryColumns = queryColumns + ", " + keyValue[0];
				}
			}
			
			if (queryColumns == null) {
				queryColumns = geomColName;
			} else {
				queryColumns = queryColumns + ", " + geomColName;
			}
			
			useAttribMapping = true;
		}
	}
	
	protected String getAttributeAlias (String dbColumnName) 
	throws Exception {
		String shpColumnName = dbColumnName;
		
		if (this.attributeMap.containsKey(shpColumnName)) {
			shpColumnName = this.attributeMap.get(shpColumnName);
		}
		
		return shpColumnName;
	}
	
	protected static void writeLog(BufferedWriter logger, String log) {
		try {
			logger.write(log);
			logger.newLine();
		} catch (IOException ioe) {
			System.out.println("\nError: Exception IOException caught...\n");
			ioe.printStackTrace();
		}
	}
	
	protected static void systemExit(BufferedWriter logger) {
		try {
			logger.flush();
			logger.close();
		} catch (IOException ioe) {
			System.out.println("\nError: Exception IOException caught...\n");
			ioe.printStackTrace();
		} finally {
			System.exit(1);
		}
	}
	
	protected static void systemPrint(String s) {
		System.out.println(s);
	}
}
