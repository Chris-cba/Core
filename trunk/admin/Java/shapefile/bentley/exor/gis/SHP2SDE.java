/**
 *    PVCS Identifiers :-
 *
 *       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/Java/shapefile/bentley/exor/gis/SHP2SDE.java-arc   1.6   Oct 31 2017 09:07:22   Upendra.Hukeri  $
 *       Module Name      : $Workfile:   SHP2SDE.java  $
 *       Date into SCCS   : $Date:   Oct 31 2017 09:07:22  $
 *       Date fetched Out : $Modtime:   Oct 31 2017 09:03:40  $
 *       SCCS Version     : $Revision:   1.6  $
 *       Based on 
 *
 *
 *
 *    Author : Upendra Hukeri
 *    SHP2SDE.java
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
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;

import java.nio.charset.StandardCharsets;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLSyntaxErrorException;
import java.sql.Statement;
import java.sql.Types;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Locale;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Set;
import java.util.StringTokenizer;
import java.util.TreeSet;

import oracle.jdbc.OracleConnection;

import oracle.spatial.util.ShapefileReaderJGeom;

import oracle.sql.STRUCT;

import org.geotools.data.FeatureSource;
import org.geotools.data.oracle.sdo.GeometryConverter;
import org.geotools.data.shapefile.ShapefileDataStore;
import org.geotools.feature.FeatureCollection;
import org.geotools.feature.FeatureIterator;
import org.geotools.referencing.CRS;

import org.opengis.feature.Property;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;
import org.opengis.feature.type.AttributeType;
import org.opengis.filter.Filter;
import org.opengis.referencing.crs.CoordinateReferenceSystem;

/**
 * This program reads all attributes and geometries from a Shapefile, and
 * converts them to spatial features. These features are written to a database
 * table. Shapefiles with measure data are converted to LRS geometries in the
 * database.
 */

public class SHP2SDE extends ShapefileUtility {
	private String 		 idColName 			= null;
	private int 		 userSRID 			= 0;
	private int 		 dbOracleSRID		= 0;
	private int 		 dbEPSGSRID			= 0;
	private int 		 shpDims			= 0;
	private double 		 minX               = -180d;
	private double 		 maxX               = 180d;
	private double 		 minY               = -90d;
	private double 		 maxY               = 90d;
	private double 		 minZ               = 0;
	private double 		 maxZ               = 0;
	private double 		 minMeasure         = 0;
	private double 		 maxMeasure         = 0;
	private double 		 mTolerance         = 0.05d;
	private double 		 mgTolerance 		= 0.000000005d;
	private int 		 startID 			= 1;
	private int 		 commitInterval 	= -1;
	private int 		 geodeticSRIDCount	= 0;
	private int 		 numOfAffectedRecs	= 0;
	private String 		 relSchema 			= null;
	private boolean 	 defaultX 			= true;
	private boolean 	 defaultY 			= true;
	private String 		 operation			= null;
	private Set<Integer> atrbFileCols		= new TreeSet<Integer>();
	
	public SHP2SDE() {
		super();
	}
	
	protected String getHelpMessage() {
		StringBuilder helpMsg  = new StringBuilder();
		
		helpMsg.append("\nUSAGE: java -jar sdeutil.jar -shp2sde -help -nc -h db_host -p db_port -s db_sid -u db_username -d db_password -t db_table -f shapefile_name -i table_id_column_name -r srid -g db_geometry_column -x max_x,min_x -y max_y,min_y -m tolerance -o {append|create|init} -n start_id -c commit_interval -a column_name_mapping_file");
		helpMsg.append("\n\tUsage explanation (parameters used):");
		helpMsg.append("\n\t[-help]: Specify this option to see the command line usage of Shapefile Uploader");
		helpMsg.append("\n\t(-nc)  : Specify this option, if the jar is loaded in database and called from a PL/SQL procedure or function");
		helpMsg.append("\n\t         (no values for this parameter)");
		helpMsg.append("\n\t(-h)   : Host machine with existing Oracle database");
		helpMsg.append("\n\t(-p)   : Host machine's port with existing Oracle database (e.g. 1521)");
		helpMsg.append("\n\t(-s)   : Host machine's SID with existing Oracle database");
		helpMsg.append("\n\t(-u)   : Database user");
		helpMsg.append("\n\t(-d)   : Database user's password");
		helpMsg.append("\n\t<-t>   : Table name for the result");
		helpMsg.append("\n\t<-f>   : File name of an input Shapefile WITHOUT EXTENSION");
		helpMsg.append("\n\t[-i]   : Column name for unique numeric ID; if required");
		helpMsg.append("\n\t[-r]   : Valid Oracle SRID for coordinate system; use 0 if unknown");
		helpMsg.append("\n\t[-g]   : Preferred or valid SDO_GEOMETRY column name");
		helpMsg.append("\n\t[-x]   : Bounds for the X dimension; use -180,180 if unknown");
		helpMsg.append("\n\t[-y]   : Bounds for the Y dimension; use -90,90 if unknown");
		helpMsg.append("\n\t[-m]   : Load tolerance fields (x and y) in metadata, if not specified, tolerance fields are 0.05");
		helpMsg.append("\n\t<-o>   : Mode to add shapefile data to a table. Possible Values - {append|create|init}");
		helpMsg.append("\n\t[-n]   : Start ID for column specified in -i parameter");
		helpMsg.append("\n\t[-c]   : Commit interval. Default - only commits at the end of a run.");
		helpMsg.append("\n\t[-a]   : File name containing column-name(attribute) mappings WITH EXTENSION");
		helpMsg.append("\n\n\tNOTE: \t() indicate MANDATORY ALTERNATE field e.g. either (-nc) or (-h -p -s -u -d)");
		helpMsg.append("\n\t\t<> indicate MANDATORY field");
		helpMsg.append("\n\t\t[] indicate OPTIONAL field");
		
		return helpMsg.toString();
	}
	
	private void init(String[] nuh) {
		int			 numOfErrors 	= 0;
		
		Set <String> validKeySet	= new HashSet<String>(Arrays.asList(ShapefileUtility.validUploadKeysArray));
		List<String> missingKV 		= new ArrayList<String>();
		List<String> argumentsList 	= new ArrayList<String>(Arrays.asList(nuh));
		Map <String, String> hm		= new HashMap<String, String>();
		
		try {
			for (Enumeration e = Collections.enumeration(argumentsList); e.hasMoreElements();) {
				String key   = null;
				String value = null;
				
				key = (String) e.nextElement();
				boolean isNormalParam = true;
				
				if("-nc".equals(key)) {
					hm.put(key, null);
					isNormalParam = false;
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
					try {
						setPort(Integer.parseInt((String) hm.get("-p")));
						writeLog("port: " + getPort(), false);
					} catch(NumberFormatException nfePort) {
						missingKV.add("not a number, please enter a valid Port number (-p)");
						numOfErrors++;
					}
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
				setViewName(((String) hm.get("-t")));
				
				if(!conformOracleNamingConvention(getViewName())) {
					missingKV.add("wrong value passed to -t, special characters not allowed in table name (allowed: A-Z a-z 0-9 _ $ #)");
					numOfErrors++;
				}
				
				writeLog("db_tablename: " + getViewName(), false);
			} else {
				missingKV.add("-t tablename");
				numOfErrors++;
			}

			if (hm.containsKey("-f")) {
				setSHPFileName(((String) hm.get("-f")));
				writeLog("shapefile_name: " + getSHPFileName() + ".shp", false);
				
				if(getSHPFileName().indexOf('\\') > -1 || getSHPFileName().indexOf('/') > -1) {
					missingKV.add("wrong value passed to -f, path not allowed here");
					numOfErrors++;
				}
			} else {
				missingKV.add("-f shapefile_name");
				numOfErrors++;
			}
			
			if (hm.containsKey("-i")) {
				idColName = (String) hm.get("-i");
				
				if(!conformOracleNamingConvention(idColName)) {
					missingKV.add("wrong value passed to -i, special characters not allowed in ID column name (allowed: A-Z a-z 0-9 _ $ #)");
					numOfErrors++;
				}
				
				writeLog("table_id_column_name: " + idColName, false);
			}

			if (hm.containsKey("-r")) {
				try {
					userSRID = Integer.parseInt((String) hm.get("-r"));
					writeLog("SRID: " + userSRID, false);
				} catch(NumberFormatException nfeSRID) {
					missingKV.add("not a number, please enter a valid SRID (-r)");
					numOfErrors++;
				}
			}

			if (hm.containsKey("-g")) {
				setGeomColName((String) hm.get("-g"));
				
				if(!conformOracleNamingConvention(getGeomColName())) {
					missingKV.add("wrong value passed to -g, special characters not allowed in geometry column name (allowed: A-Z a-z 0-9 _ $ #)");
					numOfErrors++;
				}
				
				writeLog("db_geometry_column: " + getGeomColName(), false);
			} else {
				setGeomColName("GEOMETRY");
			}
			
			if (hm.containsKey("-x")) {
				String xValue = (String) hm.get("-x");
				writeLog("X: " + xValue, false);
				
				StringTokenizer stx = new StringTokenizer(xValue, ",");
				
				try {
					while (stx.hasMoreTokens()) {
						minX = Double.parseDouble(stx.nextToken());
						maxX = Double.parseDouble(stx.nextToken());
						
						defaultX = false;
					}
				} catch(NumberFormatException nfeXValue) {
					missingKV.add("not a number, please enter valid bounds for the X dimension (-x)");
					numOfErrors++;
				}
			}

			if (hm.containsKey("-y")) {
				String yValue = (String) hm.get("-y");
				writeLog("Y: " + yValue, false);
				
				StringTokenizer sty = new StringTokenizer(yValue, ",");
				
				try {
					while (sty.hasMoreTokens()) {
						minY = Double.parseDouble(sty.nextToken());
						maxY = Double.parseDouble(sty.nextToken());
						
						defaultY = false;
					}
				} catch(NumberFormatException nfeYValue) {
					missingKV.add("not a number, please enter valid bounds for the Y dimension (-y)");
					numOfErrors++;
				}
			}

			if (hm.containsKey("-m")) {
				try {
					mTolerance = Double.parseDouble((String) hm.get("-m"));
					writeLog("tolerance: " + mTolerance, false);
				} catch(NumberFormatException nfeTolerance) {
					missingKV.add("not a number, please enter a valid tolerance value (-m)");
					numOfErrors++;
				}
			}
			
			if (hm.containsKey("-o")) {
				operation = (String) hm.get("-o").toLowerCase(Locale.ENGLISH);
				writeLog("operation: " + operation, false);
				
				if (!("append".equals(operation) || "create".equals(operation) || "init".equals(operation))) {
					missingKV.add("wrong value passed to argument -o: possible values - append|create|init");
					numOfErrors++;
				}
			} else {
				missingKV.add("-o operation");
				numOfErrors++;
			}
			
			if (hm.containsKey("-n")) {
				try {
					startID = Integer.parseInt((String) hm.get("-n"));
					writeLog("start_id: " + startID, false);
				} catch(NumberFormatException nfeStartID) {
					missingKV.add("not a number, please enter a valid Start ID (-n)");
					numOfErrors++;
				}
			}

			if (hm.containsKey("-c")) {
				try {
					commitInterval = Integer.parseInt((String) hm.get("-c"));
					writeLog("commit_interval: " + commitInterval, false);
				} catch(NumberFormatException nfeCommitInterval) {
					missingKV.add("not a number, please enter a valid Commit Interval (-c)");
					numOfErrors++;
				}
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
					writeLog("\nError: following key(s)/value(s) is/are missing: ", false);
					
					Iterator itr = missingKV.iterator();
					
					while(itr.hasNext()) {
						writeLog("\t\t" + itr.next(), false);
					}
					
					setErrorMsg("\nError: missing key(s), please check system log file for more details");
					setExitSystem(true);
				} else {
					systemExit();
					setLogger(new BufferedWriter(new OutputStreamWriter(new FileOutputStream(setLogFile("shp2sde")), StandardCharsets.UTF_8)));
					writeLog("starting upload process...");
				}
			}
		} catch (Exception initException) {
			setErrorMsg("\nError: " + initException.getMessage());
			logException(initException, "<init>");
			writeLog(ShapefileUtility.SHP2SDEFAILUREMSG, false);
			setExitSystem(true);
		}
	}
	
	protected void doUpload(String[] nuh, SHP2SDE shp2sde) {
		try {
			if(nuh != null && nuh.length >= 1) {
				if(Arrays.asList(nuh).contains("-nc")) {
					shp2sde.setUseNestedConn(true);
				}
				
				if(Arrays.asList(nuh).contains("-help")) {
					String helpMsg = shp2sde.getHelpMessage();
					
					shp2sde.setErrorMsg(helpMsg);
					System.out.println(helpMsg);
				} else {
					String result = shp2sde.setBasicDirectories("shp2sde");
					
					if("Y".equals(result)) {
						shp2sde.init(nuh);
						
						if(!shp2sde.getExitSystem()) {
							shp2sde.setColumnMap();
							
							if(!shp2sde.getExitSystem()) {
								String[] rowsAdded = shp2sde.uploadShapeFile().split(":");
								
								int addedRows = Integer.parseInt(rowsAdded[0]);
								int errorRows = Integer.parseInt(rowsAdded[1]);
								
								if(addedRows == -1 && errorRows == -1) {
									writeLog(ShapefileUtility.SHP2SDEFAILUREMSG, false);
								} else {
									writeLog(errorRows + " errors occurred while adding rows to the table");
									writeLog((addedRows - errorRows) + " rows added to the table");
									
									if (errorRows > 0) {
										shp2sde.setErrorMsg("shapefile is uploaded to table '" + shp2sde.getViewName() + "' with error/s");
										writeLog(shp2sde.getErrorMsg());
										writeLog(ShapefileUtility.SHP2SDEFAILUREMSG, false);
									} else {
										writeLog("shapefile is uploaded successfully to table '" + shp2sde.getViewName() + "'");
										System.out.println(ShapefileUtility.SHPSUCCESSMSG);
									}
								}
							} else {
								writeLog(ShapefileUtility.SHP2SDEFAILUREMSG, false);
							}
						}
					} else {
						shp2sde.setErrorMsg(result);
					}
				}
			} else {
				String invalidArgErrM = "\nError: Invalid argument/s passed..." + shp2sde.getHelpMessage();
				
				shp2sde.setErrorMsg(invalidArgErrM);
				System.out.println(invalidArgErrM);
			}
		} catch (Throwable doUploadException) {
			shp2sde.logException(doUploadException, "doUpload");
			shp2sde.writeLog(ShapefileUtility.SHP2SDEFAILUREMSG, false);
		} finally {
			shp2sde.systemExit();
		}
	}
	
	protected String uploadShapeFile() 
	throws Throwable {
		File 	shapeFile = new File(getDirectoryPath(Directory.UPLOADDIR) + getSHPFileName() + ".shp");
		String 	returnStr = "-1:-1";
		
		if(!shapeFile.exists()) {
			setErrorMsg("\nError: Shapefile not found - " +  getSHPFileName() + ".shp");
			writeLog(getErrorMsg(), false);
			
			return returnStr;
		}
		
		ShapefileDataStore 	ds		  = new ShapefileDataStore(shapeFile.toURI().toURL());
		FeatureSource 		fs		  = ds.getFeatureSource();
		FeatureCollection 	fc		  = fs.getFeatures();
		SimpleFeatureType 	ft		  = (SimpleFeatureType) fs.getSchema();
		
		Connection 			conn 	  = getConnection();
		
		String 				result 	  = null;
		
		try {
			int  prjSRID = 0;
			File prjFile = new File(getDirectoryPath(Directory.UPLOADDIR) + getSHPFileName() + ".prj");
			
			if (prjFile.isFile()) {
				try {
					CoordinateReferenceSystem crs = ft.getCoordinateReferenceSystem();
					prjSRID = CRS.lookupEpsgCode(crs, true);
					
					writeLog("SRID from '.prj' file - " + prjSRID);
				} catch (Exception noCRSException) {
					writeLog("\nError: Error in getting SRID from '.prj' file\n");
					logException(noCRSException, "uploadShapeFile");
					setExitSystem(true);
					
					return returnStr;
				}
				
				result = validateSRID(prjSRID);
				
				if("Y".equals(result)) {
					userSRID = prjSRID;
				} else {
					writeLog(getErrorMsg(), false);
					setExitSystem(true);
					
					return returnStr;
				}
			} else if (userSRID != 0) {
				writeLog("Warning: No '.prj' file found! Using SRID from command line argument '-r' - " + userSRID);
				
				result = validateSRID(userSRID);
				
				if(!"Y".equals(result)) {
					writeLog(getErrorMsg(), false);
					setExitSystem(true);
					
					return returnStr;
				}
			} else {
				setErrorMsg("\nError: No SRID found! Check if '.prj' file exists or command line argument '-r' is specified\n");
				writeLog(getErrorMsg(), false);
				setExitSystem(true);
				
				return returnStr;
			}
			
			ShapefileReaderJGeom sfh = new ShapefileReaderJGeom(getDirectoryPath(Directory.UPLOADDIR) + getSHPFileName() + ".shp");

			int shpFileType = sfh.getShpFileType();
			
			minMeasure = sfh.getMinMeasure();
			maxMeasure = sfh.getMaxMeasure();
			
			if (maxMeasure <= -10E38) {
				maxMeasure = Double.NaN;
			}
			
			minZ = sfh.getMinZ();
			maxZ = sfh.getMaxZ();
			
			// Get X,Y extents if srid is not geodetic
			if("Y".equals(getGeodeticSRIDCount())) {
				if (geodeticSRIDCount == 0 && userSRID != 0) {
					if (defaultX) {
						minX = Double.parseDouble(String.valueOf(sfh.getMinX()));
						maxX = Double.parseDouble(String.valueOf(sfh.getMaxX()));
						
						writeLog("X: " + minX +", "+ maxX);
					} 
					
					if(defaultY) {
						minY = Double.parseDouble(String.valueOf(sfh.getMinY()));
						maxY = Double.parseDouble(String.valueOf(sfh.getMaxY()));
						
						writeLog("Y: " + minY +", "+ maxY);
					}
				}
			} else {
				setExitSystem(true);
				return returnStr;
			}
			
			// Get dimension of shapefile
			shpDims = ShapefileReaderJGeom.getShpDims(shpFileType, maxMeasure);
			
			// Construct dimArrays
			String dimArrayMig = getDimArray(mgTolerance);
			
			sfh.closeShapefile();
			
			int	   numFields 		= 0;
			int	   size 			= 10;
			
			String columns	 		= null;
			String columnName 		= null;
			String columnDataType 	= null;
			String javaObjectType 	= null;
			String geomColDataType 	= "SDO_GEOMETRY";
			
			List<AttributeType> l 	= ft.getTypes();
			ListIterator<AttributeType> lItr = l.listIterator();
			
			
			while (lItr.hasNext()) {
				AttributeType at   = lItr.next();
				List<Filter>  rest = at.getRestrictions();
				Iterator<Filter> restItr = rest.iterator();
				
				while (restItr.hasNext()) {
					Filter flt	  = restItr.next();
					String fltStr = flt.toString();
					
					if (fltStr.contains("length")) {
						int i = fltStr.indexOf('=', fltStr.indexOf("length")) + 2;
						int j = fltStr.indexOf(' ', i);
						
						try {
							size = Integer.parseInt(fltStr.substring(i, j));
						} catch (NumberFormatException nfe) {
							size = 10;
						}
					}
				}
				
				columnName = at.getName().toString();
				
				if(!conformOracleNamingConvention(columnName)) {
					setErrorMsg("\nError: special characters not allowed in column name (allowed: A-Z a-z 0-9 _ $ #) - '" + columnName + '\'');
					writeLog(getErrorMsg(), false);
					setExitSystem(true);
					
					return returnStr;
				}
				
				if (getUseColumnMapping()) {
					columnName = getAttributeAlias(columnName);
				}
				
				javaObjectType = at.getBinding().getName();
				
				if (javaObjectType.startsWith("com.vividsolutions.jts.geom.")) {
					continue;
				}
				
				if (size == 1 && "java.lang.String".equals(javaObjectType)) {
					javaObjectType = "Char";
				}
				
				columnDataType = getODBDataType(javaObjectType, size);
				
				if(columnDataType != null && !columnDataType.isEmpty()) {
					if (columnName != null && !columnName.isEmpty()) {
						atrbFileCols.add(numFields);
						
						relSchema = (relSchema == null) ? (columnName + " " + columnDataType) : (relSchema + ", " + columnName + " " + columnDataType);
						columns	  = (columns == null) ? (columnName) : (columns + ", " + columnName);
					}
				} else {
					setErrorMsg("\nError: Unsupported Column Type - NULL\n");
					writeLog(getErrorMsg(), false);
					
					return returnStr;
				}
				
				numFields++;
			}
			
			numFields++;
			
			relSchema = (idColName == null) ? (relSchema + ", " + getGeomColName() + " " + geomColDataType) : (idColName + " NUMBER PRIMARY KEY, " + relSchema + ", " + getGeomColName() + " " + geomColDataType);
			columns	  = (idColName == null) ? (columns + ", " + getGeomColName()) : (idColName + ", " + columns + ", " + getGeomColName());
			
			if(idColName != null) {
				numFields++;
				atrbFileCols.add(-1);
			}
			
			String appendAddLog = "adding";
			int i = 0;
			
			// Call create table
			if ("create".equals(operation)) {
				if(!"Y".equals(prepareTableForData())) {
					return returnStr;
				}
			} else {
				writeLog("checking if table exists in database...");
				
				if("Y".equals(validateTableName())) {
					if("init".equals(operation)) {
						writeLog("deleting existing records from table...");
						
						if("Y".equals(initView())) {
							writeLog(numOfAffectedRecs + " records are deleted from table...");
						} else {
							return returnStr;
						}
					} else if("append".equals(operation)) {
						appendAddLog = "appending";
					}
				} else {
					return returnStr;
				}
			}
			
			writeLog(appendAddLog + " records from shapefile to table...");
			
			FeatureIterator featureItr = fc.features();
			
			// Open shp and input files
			int 	errorCount 	= 0;
			String 	params		= null;
			
			for (int nu=0; nu <= atrbFileCols.size(); nu++) {
				if (nu==0)
					params = " ?";
				else
					params = params + ", ?";
			}
			
			// Migrate geometry if polygon, polygonz, or polygonm
			if (shpFileType == 5 || shpFileType == 15 || shpFileType == 25) {
				params = params.substring(0, (params.length() - 1)) + "MDSYS.SDO_MIGRATE.TO_CURRENT(?, " + dimArrayMig + "))";
			}
			
			String insertRec = "INSERT INTO " + getViewName() + "(" + columns + ")" + " VALUES(" + params + ')';
			
			// Create prepared statements
			PreparedStatement ps = conn.prepareStatement(insertRec);
			
			ResultSet resMig = null;
			STRUCT str = null;
			
			for (; featureItr.hasNext(); i++) {			
				SimpleFeature feature = (SimpleFeature) featureItr.next();
				Collection<Property> propertyColl = feature.getProperties();
				Iterator<Property> propertyItr = propertyColl.iterator();
				
				oracle.sql.STRUCT geometry = null;
				
				try {
					int idCounter = 1;
					
					if (idColName != null) {
						int id = i + startID;
						idCounter = 2;
						ps.setInt(1, id);
					}
					
					for (int j=0, k=0; propertyItr.hasNext(); j++) {
						Property p =  propertyItr.next();
						Class<?> propertyClass = p.getType().getBinding();
						
						if (!atrbFileCols.contains(j) && !propertyClass.getName().startsWith("com.vividsolutions.jts.geom.")) {
							continue;
						}
						
						Object propertyValue = p.getValue();
						
						if (propertyValue == null) {
							ps.setNull((k + idCounter), (java.sql.Types.NULL));
						} else if (propertyClass.getName().startsWith("com.vividsolutions.jts.geom.")) {
							Geometry g = (Geometry)propertyValue;
							GeometryConverter gc = new GeometryConverter((OracleConnection)conn);
							geometry = (oracle.sql.STRUCT)gc.toSDO(g, userSRID);
							
							j--;
							continue;
						} else {
							setXXX(ps, propertyClass, (k + idCounter), propertyValue);
						}
						
						k++;
					}
					
					ps.setObject(atrbFileCols.size() + 1, geometry);
					ps.executeUpdate();
				} catch (SQLException e) {
					errorCount = errorCount + 1;
					logException(e, "uploadShapeFile");
					writeLog("record #" + (i + 1) + " not converted.");
				}
				
				//Edit to adjust, or comment to remove COMMIT interval; default 1000
				if (commitInterval == -1) {
					if ((i + 1)%1000 == 0) {
						conn.commit();
					}
				} else {
					if ((i + 1)%commitInterval == 0) {
						conn.commit();
					}
				}
				//end_for_each_record
			}
			
			conn.commit();
			
			featureItr.close();
			ds.dispose();
			
			return (i + ":" + errorCount);
		} finally {
			closeOracle("uploadShapeFile", null, conn, null);
		}
	}
	
	private String getDimArray(double tolerance) {
		StringBuilder dimArray 			= new StringBuilder();
		StringBuilder dimArrayBase 		= new StringBuilder();
		StringBuilder dimArray3Measure 	= new StringBuilder();
		StringBuilder dimArray3 		= new StringBuilder();
		
		dimArrayBase.append("MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', ").append(minX).append(", ").append(maxX).append(", ").append(tolerance).append("), ").append("MDSYS.SDO_DIM_ELEMENT('Y', ").append(minY).append(", ").append(maxY).append(", ").append(tolerance);
		
		dimArray3Measure.append("), ").append("MDSYS.SDO_DIM_ELEMENT('Z', ").append(minZ).append(", ").append(maxZ).append(", ").append(mTolerance).append("))");
		
		dimArray3.append("), ").append("MDSYS.SDO_DIM_ELEMENT('M', ").append(minMeasure).append(", ").append(maxMeasure).append(", ").append(mTolerance).append("))");
		
		if (shpDims == 2 || shpDims == 0) {
			dimArray.append(dimArrayBase);
		} else if (shpDims == 3 && Double.isNaN(maxMeasure)) {
			dimArray.append(dimArrayBase.append(dimArray3Measure));
		} else if (shpDims == 3) {
			dimArray.append(dimArrayBase.append(dimArray3));
		} else if (shpDims == 4) {
			dimArray.append(dimArrayBase.append(dimArray3Measure).append(dimArray3));
		}
		
		dimArray.append("))");
		
		return dimArray.toString();
	}
	
	private String prepareTableForData() 
	throws IOException, SQLException, Exception {
		Connection conn = null;
		Statement  stmt = null;
		
		try {
			// Get database connection
			conn = getConnection();
			
			// Preparation of the database
			
			// Drop table
			String 	  update = null;
			
			// Try to find and replace instances of "geometry" with getGeomColName()
			String updatedRelSchema = replaceAllWords(relSchema, "GEOMETRY", getGeomColName());
			
			// Create feature table
			writeLog("creating new table...");
			
			stmt = conn.createStatement();
			update = "CREATE TABLE " + getViewName() + " (" + updatedRelSchema + ")";
			stmt.executeUpdate(update);
			
			writeLog("adding reference to Geometry MetaData Table...");
			
			return updateSDOGeomMetadata();
		} catch(SQLSyntaxErrorException sqlSyntaxErrorException) {
			if(sqlSyntaxErrorException.getMessage().indexOf("name is already used by an existing object") >= 0) {
				setErrorMsg("\nError: Table/View - " + getViewName() + " - already exists in database");
				writeLog(getErrorMsg(), false);
				
				return "N";
			} else {
				throw sqlSyntaxErrorException;
			}
		} finally {
			closeOracle("prepareTableForData", stmt, conn, null);
		}
	}
	
	protected String replaceAllWords(String original, String find, String replacement) {
		StringBuilder result = new StringBuilder();
		String delimiters = "+-*/(),. ";
		StringTokenizer st = new StringTokenizer(original, delimiters, true);
		
		while (st.hasMoreTokens()) {
			String w = st.nextToken();
			
			if (w.equals(find)) {
				result.append(replacement);
			} else {
				result.append(w);
			}
		}
		return result.toString();
	}
	
	protected String getODBDataType(String className, int size) {
		String odbDataType = null;
		
		try {
			if ("java.lang.Integer".equals(className) || "java.lang.Byte".equals(className) || "java.lang.Short".equals(className) || "java.lang.Long".equals(className))
				odbDataType = "NUMBER(" + size + ")";
			else if ("java.lang.Double".equals(className) || "java.math.BigDecimal".equals(className) || "java.lang.Float".equals(className) || "oracle.sql.NUMBER".equals(className))
				odbDataType = "NUMBER";
			else if ("java.lang.String".equals(className))
				odbDataType = "VARCHAR2(" + size + ")";
			else if ("Char".equals(className))
				odbDataType = "CHAR";
			else if ("java.util.Date".equals(className) || "oracle.sql.DATE".equals(className) || "java.sql.Time".equals(className) || "java.sql.Date".equals(className))
				odbDataType = "DATE";
			else if ("java.lang.Boolean".equals(className))
				odbDataType = "BOOLEAN";
			else if ("oracle.sql.ROWID".equals(className) || "java.sql.RowId".equals(className))
				odbDataType = "ROWID";
			else if ("java.sql.Clob".equals(className) || "oracle.sql.CLOB".equals(className) || "java.io.Reader".equals(className))
				odbDataType = "CLOB";
			else if ("java.sql.Blob".equals(className) || "oracle.sql.BLOB".equals(className) || "java.io.InputStream".equals(className))
				odbDataType = "BLOB";
			else if ("oracle.sql.BFILE".equals(className))
				odbDataType = "BFILE";
			else if ("java.sql.Array".equals(className) || "oracle.sql.ARRAY".equals(className))
				odbDataType = "VARRAY";
			else if ("oracle.sql.BINARY_FLOAT".equals(className))
				odbDataType = "BINARY_FLOAT";
			else if ("oracle.sql.BINARY_DOUBLE".equals(className))
				odbDataType = "BINARY_DOUBLE";
			else if ("java.sql.Timestamp".equals(className) || "oracle.sql.TIMESTAMP".equals(className))
				odbDataType = "TIMESTAMP";
			else if ("oracle.sql.TIMESTAMPTZ".equals(className))
				odbDataType = "TIMESTAMP WITH TIME ZONE";
			else if ("oracle.sql.TIMESTAMPLTZ".equals(className))
				odbDataType = "TIMESTAMP WITH LOCAL TIME ZONE";
			else if ("oracle.xdb.XMLType".equals(className) || "java.sql.SQLXML".equals(className))
				odbDataType = "XMLTYPEE";
			else if ("java.sql.NClob".equals(className) || "oracle.sql.NCLOB".equals(className))
				odbDataType = "NCLOB";
			else if ("java.net.URL".equals(className))
				odbDataType = "URITYPE";
			
			return odbDataType;
		} catch (Exception e) {
			writeLog("\nError: unsupported column type - " + className, false);
			logException(e, "getODBDataType");
			
			return null;
		}
	}
	
	protected void setXXX (PreparedStatement pstmt, Class<?> propertyClass, int cloNo, Object propertyValue) 
	throws SQLException, ClassNotFoundException, Exception {
		try {
			// Number Types
			if (propertyClass == Class.forName("java.lang.Integer"))
				pstmt.setInt((cloNo), (java.lang.Integer)propertyValue);
			else if (propertyClass == Class.forName("java.lang.Long"))
				pstmt.setLong((cloNo), (java.lang.Long)propertyValue);
			else if (propertyClass == Class.forName("java.lang.Byte"))
				pstmt.setByte((cloNo), (java.lang.Byte)propertyValue);
			else if (propertyClass == Class.forName("java.lang.Short"))
				pstmt.setShort((cloNo), (java.lang.Short)propertyValue);
			// 
			else if (propertyClass == Class.forName("java.math.BigDecimal"))
				pstmt.setBigDecimal((cloNo), (java.math.BigDecimal)propertyValue);
			else if (propertyClass == Class.forName("java.lang.Float"))
				pstmt.setFloat((cloNo), (java.lang.Float)propertyValue);
			else if (propertyClass == Class.forName("java.lang.Double"))
				pstmt.setDouble((cloNo), (java.lang.Double)propertyValue);
			else if (propertyClass == Class.forName("oracle.sql.NUMBER")) {
				java.math.BigDecimal bigDecimal = ((oracle.sql.NUMBER)propertyValue).bigDecimalValue();
				pstmt.setBigDecimal((cloNo), bigDecimal);
			}
			// String Type
			else if (propertyClass == Class.forName("java.lang.String"))
				pstmt.setString((cloNo), (java.lang.String)propertyValue);
			// Boolean Type
			else if (propertyClass == Class.forName("java.lang.Boolean"))
				pstmt.setBoolean((cloNo), (java.lang.Boolean)propertyValue);
			//	Date Types
			else if (propertyClass == Class.forName("java.sql.Date"))
				pstmt.setDate((cloNo), (java.sql.Date)propertyValue);
			else if (propertyClass == Class.forName("java.util.Date")) {
				java.sql.Date date = new java.sql.Date(((java.util.Date)propertyValue).getTime());
				pstmt.setDate((cloNo), date);
			}
			else if (propertyClass == Class.forName("oracle.sql.DATE")) {
				java.sql.Date date = ((oracle.sql.DATE)propertyValue).dateValue();
				pstmt.setDate((cloNo), date);
			}
			else if (propertyClass == Class.forName("java.sql.Time"))
				pstmt.setTime((cloNo), (java.sql.Time)propertyValue);
			//	TimeStamp Types
			else if (propertyClass == Class.forName("java.sql.Timestamp"))
				pstmt.setTimestamp((cloNo), (java.sql.Timestamp)propertyValue);
			else if (propertyClass == Class.forName("oracle.sql.TIMESTAMP")) {
				java.sql.Timestamp timeStamp = ((oracle.sql.TIMESTAMP)propertyValue).timestampValue();
				pstmt.setTimestamp((cloNo), timeStamp);
			}
			else if (propertyClass == Class.forName("oracle.sql.TIMESTAMPTZ")) {
				java.sql.Timestamp timeStamp = ((oracle.sql.TIMESTAMPTZ)propertyValue).timestampValue();
				pstmt.setTimestamp((cloNo), timeStamp);
			}
			// RowId Type
			else if (propertyClass == Class.forName("java.sql.RowId"))
				pstmt.setRowId((cloNo), (java.sql.RowId)propertyValue);
			else if (propertyClass == Class.forName("oracle.sql.ROWID"))
				pstmt.setRowId((cloNo), (java.sql.RowId)((oracle.sql.ROWID)propertyValue));
			// Clob Type
			else if (propertyClass == Class.forName("java.sql.Clob"))
				pstmt.setClob((cloNo), (java.sql.Clob)propertyValue);
			else if (propertyClass == Class.forName("oracle.sql.CLOB"))
				pstmt.setClob((cloNo), (java.sql.Clob)((oracle.sql.CLOB)propertyValue));
			// Blob Type
			else if (propertyClass == Class.forName("java.sql.Blob"))
				pstmt.setBlob((cloNo), (java.sql.Blob)propertyValue);
			else if (propertyClass == Class.forName("oracle.sql.BLOB"))
				pstmt.setBlob((cloNo), (java.sql.Blob)((oracle.sql.BLOB)propertyValue));
			// Reader Type
			else if (propertyClass == Class.forName("java.io.Reader"))
				pstmt.setCharacterStream((cloNo), (java.io.Reader)propertyValue);
			// InputStream Type
			else if (propertyClass == Class.forName("java.io.InputStream"))
				pstmt.setAsciiStream((cloNo), (java.io.InputStream)propertyValue);
			//	Array Type
			else if (propertyClass == Class.forName("java.sql.Array"))
				pstmt.setArray((cloNo), (java.sql.Array)propertyValue);
			else if (propertyClass == Class.forName("oracle.sql.ARRAY"))
				pstmt.setArray((cloNo), (java.sql.Array)((oracle.sql.ARRAY)propertyValue));
			// Ref Type
			else if (propertyClass == Class.forName("java.sql.Ref"))
					pstmt.setRef((cloNo), (java.sql.Ref)propertyValue);
			//	XML Type
			else if (propertyClass == Class.forName("java.sql.SQLXML"))
				pstmt.setSQLXML((cloNo), (java.sql.SQLXML)propertyValue);
			else if (propertyClass == Class.forName("oracle.xdb.XMLType")) {
				pstmt.setSQLXML((cloNo), (java.sql.SQLXML)((oracle.xdb.XMLType)propertyValue));
			}
			//	NClob Type
			else if (propertyClass == Class.forName("java.sql.NClob"))
				pstmt.setNClob((cloNo), (java.sql.NClob)propertyValue);
			else if (propertyClass == Class.forName("oracle.sql.NCLOB"))
				pstmt.setNClob((cloNo), (java.sql.NClob)((oracle.sql.NCLOB)propertyValue));
			//	URL Type
			else if (propertyClass == Class.forName("java.net.URL"))
				pstmt.setURL((cloNo), (java.net.URL)propertyValue);
			// Object Type
			else
				pstmt.setObject((cloNo), propertyValue);
		} catch (Exception e) {
			writeLog("\nError: unsupported column type\n", false);
			logException(e, "setXXX");
		}
	}
	
	private String validateSRID(int srid) 
	throws SQLException, ClassNotFoundException, Exception {
		Connection        conn    = null;
		CallableStatement cstmt   = null;
		String 			  result  = null;
		String 			  sqlStmt = null;
		
		try {
			conn = getConnection();
			
			sqlStmt = "{? = call sde_util.validate_srid(?, ?, ?)}";
			cstmt   = conn.prepareCall(sqlStmt);
			cstmt.registerOutParameter(1, Types.VARCHAR);
			cstmt.setInt(2, srid);
			cstmt.setString(3, getViewName());
			cstmt.setString(4, getGeomColName());
			cstmt.execute();
			
			result = cstmt.getString(1);
			
			if("Y".equals(result)) {
				return "Y";
			} else {
				setErrorMsg("\nError: " + result);
				return "N";
			}
		} finally {
			closeOracle("validateSRID", cstmt, conn, null);
		}
	}
	
	private String updateSDOGeomMetadata() 
	throws SQLException, ClassNotFoundException, Exception {
		Connection        conn    = null;
		CallableStatement cstmt   = null;
		String 			  result  = null;
		String 			  sqlStmt = null;
		
		try {
			String geomMDTabTableName = getViewName();
			
			if (geomMDTabTableName.contains(".")) {
				String[] s = geomMDTabTableName.split("\\.");
				geomMDTabTableName = s[1];
			}
			
			conn = getConnection();
			
			sqlStmt = "{? = call sde_util.update_sdo_geom_metadata(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";
			cstmt   = conn.prepareCall(sqlStmt);
			cstmt.registerOutParameter(1, Types.VARCHAR);
			cstmt.setString(2, geomMDTabTableName);
			cstmt.setString(3, getGeomColName());
			cstmt.setInt(4, userSRID);
			cstmt.setDouble(5, shpDims);
			cstmt.setDouble(6, minX);
			cstmt.setDouble(7, maxX);
			cstmt.setDouble(8, minY);
			cstmt.setDouble(9, maxY);
			cstmt.setDouble(10, minZ);
			cstmt.setDouble(11, maxZ);
			cstmt.setDouble(12, minMeasure);
			cstmt.setDouble(13, maxMeasure);
			cstmt.setDouble(14, mTolerance);
			
			cstmt.execute();
			
			result = cstmt.getString(1);
			
			if(!"Y".equals(result)) {
				if(result.indexOf("duplicate entry for ") >= 0) {
					setErrorMsg("\nError: Reference for table/view - " + getViewName() + " - already present in Geometry MetaData Table");
					writeLog(getErrorMsg(), false);
				} else {
					setErrorMsg("\nError: " + result);
					writeLog(getErrorMsg(), false);
				}
				
				result = "N";
			}
			
			return result;
		} finally {
			closeOracle("updateSDOGeomMetadata", cstmt, conn, null);
		}
	}
	
	private String getGeodeticSRIDCount() 
	throws SQLException, ClassNotFoundException, Exception {
		Connection        conn    = null;
		CallableStatement cstmt   = null;
		String 			  result  = null;
		String 			  sqlStmt = null;
		
		try {
			conn = getConnection();
			
			sqlStmt = "{? = call sde_util.get_geodetic_srid_count(?, ?)}";
			cstmt   = conn.prepareCall(sqlStmt);
			cstmt.registerOutParameter(1, Types.VARCHAR);
			cstmt.setInt(2, userSRID);
			cstmt.registerOutParameter(3, Types.NUMERIC);
			cstmt.execute();
			
			result = cstmt.getString(1);
			
			if("Y".equals(result)) {
				geodeticSRIDCount = cstmt.getInt(3);
			} else {
				setErrorMsg("\nError: " + result);
				writeLog(getErrorMsg(), false);
				result = "N";
			}
			
			return result;
		} finally {
			closeOracle("getGeodeticSRIDCount", cstmt, conn, null);
		}
	}
	
	private String initView() 
	throws SQLException, ClassNotFoundException, Exception {
		Connection        conn    = null;
		CallableStatement cstmt   = null;
		String 			  result  = null;
		String 			  sqlStmt = null;
		
		try {
			conn = getConnection();
			
			sqlStmt = "{? = call sde_util.init_view(?, ?)}";
			cstmt   = conn.prepareCall(sqlStmt);
			cstmt.registerOutParameter(1, Types.VARCHAR);
			cstmt.setString(2, getViewName());
			cstmt.registerOutParameter(3, Types.NUMERIC);
			cstmt.execute();
			
			result = cstmt.getString(1);
			
			if("Y".equals(result)) {
				numOfAffectedRecs = cstmt.getInt(3);
			} else {
				setErrorMsg("\nError: " + result);
				writeLog(getErrorMsg(), false);
				result = "N";
			}
			
			return result;
		} finally {
			closeOracle("initView", cstmt, conn, null);
		}
	}
	
	private String validateTableName() 
	throws SQLException, ClassNotFoundException, Exception {
		Connection        conn    = null;
		CallableStatement cstmt   = null;
		String 			  result  = null;
		String 			  sqlStmt = null;
		
		try {
			conn = getConnection();
			
			sqlStmt = "{? = call sde_util.validate_table_name(?)}";
			cstmt   = conn.prepareCall(sqlStmt);
			cstmt.registerOutParameter(1, Types.VARCHAR);
			cstmt.setString(2, getViewName());
			cstmt.execute();
			
			result = cstmt.getString(1);
			
			if(!"Y".equals(result)) {
				setErrorMsg("\nError: " + result);
				writeLog(getErrorMsg(), false);
				result = "N";
			}
			
			return result;
		} finally {
			closeOracle("validateTableName", cstmt, conn, null);
		}
	}
	
	public String toString() { 
        return super.toString().replace("ShapefileUtility:", "SHP2SDE:");
    }
}
