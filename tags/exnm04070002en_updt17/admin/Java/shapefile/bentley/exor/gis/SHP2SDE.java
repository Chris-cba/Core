/**
 *    PVCS Identifiers :-
 *
 *       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/Java/shapefile/bentley/exor/gis/SHP2SDE.java-arc   1.1   Aug 17 2015 07:25:48   Upendra.Hukeri  $
 *       Module Name      : $Workfile:   SHP2SDE.java  $
 *       Date into SCCS   : $Date:   Aug 17 2015 07:25:48  $
 *       Date fetched Out : $Modtime:   Aug 17 2015 07:06:14  $
 *       SCCS Version     : $Revision:   1.1  $
 *       Based on 
 *
 *
 *
 *    Author : Upendra Hukeri
 *
 *    SHP2SDE.java
 ****************************************************************************************************
 *	  Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
 ****************************************************************************************************
 *
 */
 
package bentley.exor.gis;

import com.vividsolutions.jts.geom.Geometry;
import java.io.*;

import java.sql.*;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.List;
import java.util.ListIterator;
import java.util.Set;
import java.util.StringTokenizer;
import java.util.TreeSet;
import java.util.Vector;

import oracle.jdbc.driver.*;
import oracle.jdbc.OracleConnection;

import oracle.spatial.util.*;

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

public class SHP2SDE {
	private String 	m_host 				= null;
	private String 	m_port 				= null;
	private String 	m_sid 				= null;
	private String 	m_user 				= null;
	private String 	m_password		 	= null;
	private String 	m_tableName 		= null;
	private String 	m_shapefileName 	= null;
	private String 	m_idName 			= null;
	private int 	m_srid 				= 0;
	private String 	geomMetaDataTable 	= "user_sdo_geom_metadata";
	private String 	m_geom	 			= "GEOMETRY";
	private String 	min_x 				= "-180";
	private String	min_y 				= "-90";
	private String 	max_x 				= "180";
	private String 	max_y 				= "90";
	private String 	m_tolerance 		= "0.05";
	private String 	mg_tolerance 		= "0.000000005";
	private int 	m_start_id 			= 1;
	private int 	m_commit_interval 	= -1;
	private String 	dimArray 			= null;
	private String 	dimArrayMig 		= null;
	private boolean defaultX 			= true;
	private boolean defaultY 			= true;
	private String 	operation			= null;
	
	private String	attributeMode	 	= null;
	private Map<String, String> 	attributeMap	 = new HashMap<String, String>();
	private boolean	useAttribMapping 	= false;
	
	private String 	usage 				= "\nError: The following mandatory key(s)/value(s) is/are missing: ";
	private static final String 	SHPFAILUREMSG 		= "shapefile upload failed!";
	private static final String 	SHPSUCCESSMSG 		= "success";
	
	private static final int 		SHPSUCCESSMSGNUM 		= 1;
	
	private static String			errorMsg 			= null;
	
	private String 	value				= null;
	private String 	key					= null;
	
	private HashMap hm 					= new HashMap();
	
	private Vector 	v 					= new Vector();
	
	private int 	skip_create_table 	= 0;
	private int 	delete_rows 		= 0;
	
	private File 	logFile				= null;
	private String	logFilePath		 	= null;
	
	private static 	BufferedWriter logger = null;
	
	private Set<Integer> atrbFileCols	= new TreeSet<Integer>();
	
	public SHP2SDE () {
		errorMsg  = "\n\t\tUSAGE: java -jar shp2sde.jar -h db_host -p db_port -s db_sid -u db_username -d db_password -t db_table -f shapefile_name -i table_id_column_name -r srid -g db_geometry_column -x max_x,min_x -y max_y,min_y -m tolerance -o {append|create|init} -n start_id -c commit_interval -a attribute_map_file";
		errorMsg += "\n\t\tUsage explanation (parameters used):";
		errorMsg += "\n\t\t<-h>: Host machine with existing Oracle database";
		errorMsg += "\n\t\t<-p>: Host machine's port with existing Oracle database (e.g. 1521)";
		errorMsg += "\n\t\t<-s>: Host machine's SID with existing Oracle database";
		errorMsg += "\n\t\t<-u>: Database user";
		errorMsg += "\n\t\t<-d>: Database user's password";
		errorMsg += "\n\t\t<-t>: Table name for the result";
		errorMsg += "\n\t\t<-f>: File name of an input Shapefile WITHOUT EXTENSION";
		errorMsg += "\n\t\t[-i]: Column name for unique numeric ID; if required";
		errorMsg += "\n\t\t[-r]: Valid Oracle SRID for coordinate system; use 0 if unknown";
		errorMsg += "\n\t\t[-g]: Preferred or valid SDO_GEOMETRY column name";
		errorMsg += "\n\t\t[-x]: Bounds for the X dimension; use -180,180 if unknown";
		errorMsg += "\n\t\t[-y]: Bounds for the Y dimension; use -90,90 if unknown";
		errorMsg += "\n\t\t[-m]: Load tolerance fields (x and y) in metadata, if not specified, tolerance fields are 0.05";
		errorMsg += "\n\t\t[-o]: Mode to add shapefile data to a table. Possible Values - {append|create|init} (values are CASE-SENSITIVE)";
		errorMsg += "\n\t\t[-n]: Start ID for column specified in -i parameter";
		errorMsg += "\n\t\t[-c]: Commit interval. Default, only commits at the end of a run.";
		errorMsg += "\n\t\t[-a]: Attribute Mapping File WITH EXTENSION";
		errorMsg += "\n\n\t\tNOTE: \t<> indicates MANDATORY field";
		errorMsg += "\n\t\t\t\t[] indicates OPTIONAL field";
		
	}
	
	public SHP2SDE (String args[]) {
		int numOfErrors = 0;
		String[] missingKV = new String[7];
		
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
				m_host = (String) hm.get("-h");
			} else {
				missingKV[numOfErrors] = "-h db_host";
				numOfErrors++;
			}

			if (hm.containsKey("-p")) {
				writeLog(logger, "port: " + (String) hm.get("-p"));
				m_port = (String) hm.get("-p");
			} else {
				missingKV[numOfErrors] = "-p db_port";
				numOfErrors++;
			}

			if (hm.containsKey("-s")) {
				writeLog(logger, "sid: " + (String) hm.get("-s"));
				m_sid = (String) hm.get("-s");
			} else {
				missingKV[numOfErrors] = "-s db_sid";
				numOfErrors++;
			}

			if (hm.containsKey("-u")) {
				writeLog(logger, "db_username: " + (String) hm.get("-u"));
				m_user = (String) hm.get("-u");
			} else {
				missingKV[numOfErrors] = "-u db_username";
				numOfErrors++;
			}

			if (hm.containsKey("-d")) {
				writeLog(logger, "db_password: ******");
				m_password = (String) hm.get("-d");
			} else {
				missingKV[numOfErrors] = "-d password";
				numOfErrors++;
			}

			if (hm.containsKey("-t")) {
				writeLog(logger, "db_tablename: " + (String) hm.get("-t"));
				m_tableName = (String) hm.get("-t");
			} else {
				missingKV[numOfErrors] = "-t tablename";
				numOfErrors++;
			}

			if (hm.containsKey("-f")) {
				writeLog(logger, "shapefile_name: " + ((String) hm.get("-f")).replace("\\\\", "\\") + ".shp");
				m_shapefileName = ((String) hm.get("-f")) + ".shp";
			} else {
				missingKV[numOfErrors] = "-f shapefile_name";
				numOfErrors++;
			}
			
			if (hm.containsKey("-i")) {
				writeLog(logger, "table_id_column_name: " + (String) hm.get("-i"));
				m_idName = (String) hm.get("-i");
			}

			if (hm.containsKey("-r")) {
				writeLog(logger, "SRID: " + (String) hm.get("-r"));
				m_srid = Integer.parseInt((String) hm.get("-r"));
			}

			if (hm.containsKey("-g")) {
				writeLog(logger, "db_geometry_column: " + (String) hm.get("-g"));
				m_geom = (String) hm.get("-g");
			}

			if (hm.containsKey("-x")) {
				writeLog(logger, "X: " + (String) hm.get("-x"));
				StringTokenizer stx = new StringTokenizer((String) hm.get("-x"), ",");
				while (stx.hasMoreTokens()) {
					min_x = stx.nextToken();
					max_x = stx.nextToken();
					defaultX = false;
				}
			}

			if (hm.containsKey("-y")) {
				writeLog(logger, "Y: " + (String) hm.get("-y"));
				StringTokenizer sty = new StringTokenizer((String) hm.get("-y"),
						",");
				while (sty.hasMoreTokens()) {
					min_y = sty.nextToken();
					max_y = sty.nextToken();
					defaultY = false;
				}
			}

			if (hm.containsKey("-m")) {
				writeLog(logger, "tolerance: " + (String) hm.get("-o"));
				m_tolerance = (String) hm.get("-o");
			}
			
			if (hm.containsKey("-o")) {
				writeLog(logger, "operation: " + (String) hm.get("-o"));
				operation = (String) hm.get("-o");
				
				if (operation.equals("append")) {
					skip_create_table = 1;
					delete_rows = 0;
				} else if (operation.equals("create")) {
					skip_create_table = 0;
				} else if (operation.equals("init")) {
					skip_create_table = 1;
					delete_rows = 1;
				} else {
					missingKV[numOfErrors] = "wrong value passed to argument -o: possible values - append|create|init";
					numOfErrors++;
				}
			} else {
				missingKV[numOfErrors] = "-o operation";
				numOfErrors++;
			}
			
			if (hm.containsKey("-n")) {
				writeLog(logger, "start_id: " + (String) hm.get("-n"));
				m_start_id = Integer.parseInt((String) hm.get("-n"));
			}

			if (hm.containsKey("-c")) {
				writeLog(logger, "commit_interval: " + (String) hm.get("-c"));
				m_commit_interval = Integer.parseInt((String) hm.get("-c"));
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
			
			logFile				= setLogFile();
			
			File f_shp = new File(m_shapefileName);
				
			if (!f_shp.exists()) {
				writeLog(logger, "\nError: Cannot find the shapefile specified - " + ((String) hm.get("-f")).replace("\\\\", "\\") + ".shp");
				
				systemExit(logger);
			} else {
				f_shp = null;
			}
			
			if(new File(logFilePath).isDirectory()) {
				logger.flush();
				logger.close();
				
				logger = new BufferedWriter(new FileWriter(logFile));
				writeLog(logger, new Date().toString() + ": starting upload process...");
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
			writeLog(logger, "Error: " + SHPFAILUREMSG);
			systemExit(logger);
		}
	}
	
	public static void main(String args[]) {
		try {
			SHP2SDE shp2sde = new SHP2SDE();
			
			String currentDir = shp2sde.getClass().getProtectionDomain().getCodeSource().getLocation().toURI().getPath().replace("shp2sde.jar", "");
			shp2sde = null;
			
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
			
			systemLog = new File(currentDir + "\\log\\shp2sde_" + timeExtension + ".log");
			
			System.out.println(systemLog.toString());
						
			logger = new BufferedWriter(new FileWriter(systemLog));
			
			if (args.length <= 1) {				
				writeLog(logger, new Date().toString() + ": Error: Invalid argument/s passed..." + errorMsg);
			} else {
				shp2sde = new SHP2SDE(args);
				String[] rowsAdded = shp2sde.uploadShapeFile().split(":");
				
				int addedRows = Integer.parseInt(rowsAdded[0]);
				int errorRows = Integer.parseInt(rowsAdded[1]);
				
				writeLog(logger, new Date().toString() + ": " + errorRows + " errors occurred while adding rows to the table.");
				writeLog(logger, new Date().toString() + ": " + (addedRows - errorRows) + " rows added to the table.");
				
				if (errorRows > 0) {
					writeLog(logger, new Date().toString() + ": shapefile is uploaded to table '" + shp2sde.m_tableName + "' with error/s");
					
					System.out.println(SHPFAILUREMSG);
				} else {
					writeLog(logger, new Date().toString() + ": shapefile is uploaded successfully to table '" + shp2sde.m_tableName + "'");
					
					System.out.println(SHPSUCCESSMSG);
					//System.out.print(SHPSUCCESSMSGNUM);
				}
			}
		} catch (Exception mainException) {
			String error = new Date().toString() + ": Error: Exception mainException caught...\n";
			
			StringWriter stw = new StringWriter();
			PrintWriter pw = new PrintWriter(stw);
			
			mainException.printStackTrace(pw);
			
			writeLog(logger, error + stw.toString());
			writeLog(logger, "Error: " + SHPFAILUREMSG);
		} finally {
			systemExit(logger);
		}
	}
	
	protected String uploadShapeFile() 
	throws Exception {
		File shapeFile = new File(m_shapefileName);
		ShapefileDataStore ds = new ShapefileDataStore(shapeFile.toURI().toURL());
		FeatureSource fs = ds.getFeatureSource();
		FeatureCollection fc = fs.getFeatures();

		SimpleFeatureType ft = (SimpleFeatureType) fs.getSchema();
		
		// Make connection to DB
		writeLog(logger, new Date().toString() + ": connecting to Oracle Database...");
		
		String url = "jdbc:oracle:thin:@ " + m_host + ":" + m_port + ":" + m_sid;
		
		OracleConnection conn = null;
		
		DriverManager.registerDriver(new OracleDriver());
		
		conn = (OracleConnection) DriverManager.getConnection(url, m_user, m_password);
		conn.setAutoCommit(false);
		
		writeLog(logger, new Date().toString() + ": connected to Oracle Database successfully!");
		
		String sridQuery = "SELECT sdo_cs.map_oracle_srid_to_epsg(NVL(nm3sdo.get_nw_srids, 0)) srid FROM DUAL";
		
		Statement statement = conn.createStatement();
		ResultSet sridData = statement.executeQuery(sridQuery);
		
		int db_srid = 0;
		int prj_srid = 0;
		
		if(sridData.next()) {
			db_srid = sridData.getInt("srid");
			
			writeLog(logger, new Date().toString() + ": database default SRID - " + db_srid);
		} else {
			writeLog(logger, new Date().toString() + ": Error: Error in getting database default SRID!\n");
			
			systemExit(logger);
		}
		
		File prjFile = new File(m_shapefileName.replace(".shp", ".prj"));
		
		if (prjFile.isFile()) {
			try {
				CoordinateReferenceSystem crs = ft.getCoordinateReferenceSystem();
				
				prj_srid = CRS.lookupEpsgCode(crs, true);
				
				writeLog(logger, new Date().toString() + ": SRID from '.prj' file - " + prj_srid);
			} catch (Exception noCRSException) {
				writeLog(logger, new Date().toString() + ": Error: Error in getting SRID from '.prj' file\n");
					
				systemExit(logger);
			}
			
			if (prj_srid != db_srid) {
				writeLog(logger, new Date().toString() + ": Error: SRID retrieved from '.prj' file does not match the database default SRID\n");
				
				systemExit(logger);
			} else {
				
			}
			
			m_srid = prj_srid;
		} else if (m_srid != 0) {
			writeLog(logger, "\n" + new Date().toString() + ": Warning: No '.prj' file found! Using SRID from command line argument '-r' - " + m_srid + "\n");
			
			if (m_srid != db_srid) {
				writeLog(logger, new Date().toString() + ": Error: SRID provided with command line argument '-r' does not match the database default SRID\n");
				
				systemExit(logger);
			} 
		} else {
			writeLog(logger, "\n" + new Date().toString() + ": Error: No SRID found! Check if '.prj' file exists or command line argument '-r' is specified\n");
				
			systemExit(logger);
		}
		
		ShapefileReaderJGeom sfh = new ShapefileReaderJGeom(m_shapefileName);

		int shpFileType = sfh.getShpFileType();
		
		double minMeasure = sfh.getMinMeasure();
		double maxMeasure = sfh.getMaxMeasure();
		
		if (maxMeasure <= -10E38) {
			maxMeasure = Double.NaN;
		}
		
		double minZ = sfh.getMinZ();
		double maxZ = sfh.getMaxZ();

		// Get X,Y extents if srid is not geodetic
		if (defaultX && m_srid != 0) {
			PreparedStatement psSrid = conn.prepareStatement("SELECT COUNT(*) cnt FROM MDSYS.GEODETIC_SRIDS WHERE srid = ?");
			psSrid.setInt(1, m_srid);
			
			ResultSet rs = psSrid.executeQuery();
			
			if (rs.next()) {
				if (rs.getInt("cnt") == 0) {
					min_x = String.valueOf(sfh.getMinX());
					max_x = String.valueOf(sfh.getMaxX());
					writeLog(logger, new Date().toString() + ": X: " + min_x +", "+ max_x);
				}
			}
			
			psSrid.close();
		}
		
		if (defaultY && m_srid != 0) {
			PreparedStatement psSrid = conn.prepareStatement("SELECT COUNT(*) cnt FROM MDSYS.GEODETIC_SRIDS WHERE srid = ?");
			psSrid.setInt(1, m_srid);
			
			ResultSet rs = psSrid.executeQuery();
			
			if (rs.next()) {
				if (rs.getInt("cnt") == 0) {
					min_y = String.valueOf(sfh.getMinY());
					max_y = String.valueOf(sfh.getMaxY());
					writeLog(logger, new Date().toString() + ": Y: " + min_y +", "+ max_y);
				}
			}
			
			psSrid.close();
		}

		// Get dimension of shapefile
		int shpDims = sfh.getShpDims(shpFileType, maxMeasure);

		// Construct dimArrarys
		if (shpDims == 2 || shpDims == 0) {
			dimArray = "MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', "
					+ min_x + ", " + max_x + ", " + m_tolerance + "), "
					+ "MDSYS.SDO_DIM_ELEMENT('Y', " + min_y + ", " + max_y
					+ ", " + m_tolerance + "))";
			dimArrayMig = "MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', "
					+ min_x + ", " + max_x + ", " + mg_tolerance + "), "
					+ "MDSYS.SDO_DIM_ELEMENT('Y', " + min_y + ", " + max_y
					+ ", " + mg_tolerance + "))";
		} else if (shpDims == 3 && Double.isNaN(maxMeasure)) {
			dimArray = "MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', "
					+ min_x + ", " + max_x + ", " + m_tolerance + "), "
					+ "MDSYS.SDO_DIM_ELEMENT('Y', " + min_y + ", " + max_y
					+ ", " + m_tolerance + "), "
					+ "MDSYS.SDO_DIM_ELEMENT('Z', " + minZ + ", " + maxZ + ", "
					+ m_tolerance + "))";
			dimArrayMig = "MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', "
					+ min_x + ", " + max_x + ", " + mg_tolerance + "), "
					+ "MDSYS.SDO_DIM_ELEMENT('Y', " + min_y + ", " + max_y
					+ ", " + mg_tolerance + "), "
					+ "MDSYS.SDO_DIM_ELEMENT('Z', " + minZ + ", " + maxZ + ", "
					+ mg_tolerance + "))";
		} else if (shpDims == 3) {
			dimArray = "MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', "
					+ min_x + ", " + max_x + ", " + m_tolerance + "), "
					+ "MDSYS.SDO_DIM_ELEMENT('Y', " + min_y + ", " + max_y
					+ ", " + m_tolerance + "), "
					+ "MDSYS.SDO_DIM_ELEMENT('M', " + minMeasure + ", "
					+ maxMeasure + ", " + m_tolerance + "))";
			dimArrayMig = "MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', "
					+ min_x + ", " + max_x + ", " + mg_tolerance + "), "
					+ "MDSYS.SDO_DIM_ELEMENT('Y', " + min_y + ", " + max_y
					+ ", " + mg_tolerance + "), "
					+ "MDSYS.SDO_DIM_ELEMENT('M', " + minMeasure + ", "
					+ maxMeasure + ", " + mg_tolerance + "))";
		} else if (shpDims == 4) {
			dimArray = "MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', "
					+ min_x + ", " + max_x + ", " + m_tolerance + "), "
					+ "MDSYS.SDO_DIM_ELEMENT('Y', " + min_y + ", " + max_y
					+ ", " + m_tolerance + "), "
					+ "MDSYS.SDO_DIM_ELEMENT('Z', " + minZ + ", " + maxZ + ", "
					+ m_tolerance + "), " + "MDSYS.SDO_DIM_ELEMENT('M', "
					+ minMeasure + ", " + maxMeasure + ", " + m_tolerance
					+ "))";
			dimArrayMig = "MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', "
					+ min_x + ", " + max_x + ", " + mg_tolerance + "), "
					+ "MDSYS.SDO_DIM_ELEMENT('Y', " + min_y + ", " + max_y
					+ ", " + mg_tolerance + "), "
					+ "MDSYS.SDO_DIM_ELEMENT('Z', " + minZ + ", " + maxZ + ", "
					+ mg_tolerance + "), " + "MDSYS.SDO_DIM_ELEMENT('M', "
					+ minMeasure + ", " + maxMeasure + ", " + mg_tolerance
					+ "))";
		}
		
		sfh.closeShapefile();
		
		String relSchema = null;
		String columns	 = null;
		
		List<AttributeType> l = ft.getTypes();
		ListIterator<AttributeType> lItr = l.listIterator();
		
		String columnName = null;
		String columnDataType = null;
		String javaObjectType = null;
		String geomColDataType = "SDO_GEOMETRY";
				
		int numFields = 0;
		
		int size = 10;
		
		while (lItr.hasNext()) {
			AttributeType at = lItr.next();
						
			List<Filter> rest = at.getRestrictions();

			Iterator<Filter> restItr = rest.iterator();
			
			while (restItr.hasNext()) {
				Filter flt = restItr.next();

				String fltStr = flt.toString();
				
				if (fltStr.contains("length")) {
					int i = fltStr.indexOf("=", fltStr.indexOf("length")) + 2;
					int j = fltStr.indexOf(" ", i);
					try {
						size = Integer.parseInt(fltStr.substring(i, j));
					} catch (NumberFormatException nfe) {
						size = 10;
					}
				}
			}
			
			columnName = at.getName().toString();
			
			if (useAttribMapping) {
				columnName = this.getAttributeAlias(columnName);
			}
			
			javaObjectType = at.getBinding().getName();
						
			if (javaObjectType.startsWith("com.vividsolutions.jts.geom.")) {
				continue;
			}
			
			if (javaObjectType.equals("java.lang.String") && size == 1)
				javaObjectType = "Char";
			
			columnDataType = getODBDataType(javaObjectType, size);
			
			if (columnDataType == null) {
				throw new RuntimeException("Unsupported Column Type");
			} else if (columnDataType.length() == 0 || columnDataType.isEmpty()) {
				throw new RuntimeException("Unsupported Column Type");
			} else if (columnName != null) {
				atrbFileCols.add(numFields);
				
				if (relSchema == null) {
					relSchema = columnName + " " + columnDataType;
					columns	  = columnName;
				} else {
					relSchema = relSchema + ", " + columnName + " " + columnDataType;
					columns	  = columns + ", " + columnName;
				}
			}
			
			numFields++;
		}
		
		numFields++;
		
		if(m_idName == null) {
			relSchema = relSchema + ", " + m_geom + " " + geomColDataType;
			columns	  = columns + ", " + m_geom;
		} else {
			relSchema = m_idName + " NUMBER, " + relSchema + ", " + m_geom + " " + geomColDataType;
			columns	  = m_idName + ", " + columns + ", " + m_geom;
			
			numFields++;
			
			atrbFileCols.add(-1);
		}
		
		String appendAddLog = null;
		
		// Call create table
		if (skip_create_table == 0) {
			prepareTableForData(conn, relSchema);
			appendAddLog = "adding";
		} else {
			appendAddLog = "appending";
			writeLog(logger, new Date().toString() + ": checking if table exists in database?");
			
			String checkTableQuery = "SELECT 1 FROM " + m_tableName;
			Statement checkTableStmt = conn.createStatement();
			ResultSet rset = checkTableStmt.executeQuery(checkTableQuery);
		}
		
		if (delete_rows == 1) {
			writeLog(logger, new Date().toString() + ": deleting existing records from table...");
			
			Statement deleteRowsStmt = conn.createStatement();
			String deleteRoewQuery = "DELETE FROM " + m_tableName;
			int numOfAffectedRecs = deleteRowsStmt.executeUpdate(deleteRoewQuery);
			deleteRowsStmt.close();
			
			writeLog(logger, new Date().toString() + ": " + numOfAffectedRecs + " records are deleted from table...");
			writeLog(logger, new Date().toString() + ": adding records from shapefile to table...");
		} else {
			writeLog(logger, new Date().toString() + ": " + appendAddLog + " records from shapefile to table...");
		}
		
		FeatureIterator featureItr = fc.features();
		
		int numRecords = fc.size();
		
		// Open shp and input files
		int error_cnt = 0;
	 	 
		String params = null;
		String paramsM = null;
	 
		params = "(";
		for (int i=0; i <= atrbFileCols.size(); i++) {
		if (i==0)
			params = params + " ?";
		else
			params = params + ", ?";
		}
		params = params + ")";
		paramsM = params.substring(0,(params.length()-2)) + "MDSYS.SDO_MIGRATE.TO_CURRENT(?, " + dimArrayMig + "))";
		
		// Create prepared statements
		String insertRec = "INSERT INTO " + m_tableName + "(" + columns + ")" + " VALUES" + params;
		PreparedStatement ps = conn.prepareStatement(insertRec);
		
		PreparedStatement psCom = conn.prepareStatement("COMMIT");
		
		String insertMig = "INSERT INTO " + m_tableName + "(" + columns + ")" + " VALUES" + paramsM;
		PreparedStatement psMig = conn.prepareStatement(insertMig);
		
		ResultSet resMig = null;
		STRUCT str = null;
		
		int i = 0;
		
		for (; featureItr.hasNext(); i++) {			
			SimpleFeature feature = (SimpleFeature) featureItr.next();
			Collection<Property> propertyColl = feature.getProperties();
			Iterator<Property> propertyItr = propertyColl.iterator();
			
			oracle.sql.STRUCT geometry = null;
			
			if (m_idName == null) {
				try {  
					// Migrate geometry if polygon, polygonz, or polygonm
					if (shpFileType == 5 || shpFileType == 15 || shpFileType == 25) {
						for (int j=0, k=0; propertyItr.hasNext(); j++) {
							Property p =  propertyItr.next();
							Class<?> propertyClass = p.getType().getBinding();
							
							if (!atrbFileCols.contains(j) && !propertyClass.getName().startsWith("com.vividsolutions.jts.geom.")) {
								continue;
							}
							
							Object propertyValue = p.getValue();
							
							if (propertyValue == null) {
								psMig.setNull((k+1), (java.sql.Types.NULL));
							} else if (propertyClass.getName().startsWith("com.vividsolutions.jts.geom.")) {
								Geometry g = (Geometry)propertyValue;
								GeometryConverter gc = new GeometryConverter(conn);
								geometry = (oracle.sql.STRUCT)gc.toSDO(g, m_srid);
								
								j--;
								continue;
							} else {
								setXXX(psMig, propertyClass, (k+1), propertyValue);
							}
							
							k++;
						}
						psMig.setObject(atrbFileCols.size()+1, geometry);
						psMig.executeUpdate();
					} else {
						for (int j=0, k=0; propertyItr.hasNext(); j++) {
							Property p =  propertyItr.next();
							Class<?> propertyClass = p.getType().getBinding();
							
							if (!atrbFileCols.contains(j) && !propertyClass.getName().startsWith("com.vividsolutions.jts.geom.")) {
								continue;
							}
							
							Object propertyValue = p.getValue();
							
							if (propertyValue == null) {
								ps.setNull((k+1), (java.sql.Types.NULL));
							} else if (propertyClass.getName().startsWith("com.vividsolutions.jts.geom.")) {
								Geometry g = (Geometry)propertyValue;
								GeometryConverter gc = new GeometryConverter(conn);
								geometry = (oracle.sql.STRUCT)gc.toSDO(g, m_srid);
								
								j--;
								continue;
							} else {
								setXXX(ps, propertyClass, (k+1), propertyValue);
							}
							
							k++;
						}
						ps.setObject(atrbFileCols.size()+1, geometry);
						ps.executeUpdate();
					}
				} catch (SQLException e) {
					error_cnt = error_cnt + 1;
					
					StringWriter stw = new StringWriter();
					PrintWriter pw = new PrintWriter(stw);
					e.printStackTrace(pw);
					writeLog(logger, new Date().toString() + ": Error: " + stw.toString() + "\nrecord #" + (i+1) + " not converted.");
				}
			} else {
				int id = i + m_start_id;
				
				try {
					// Migrate geometry if polygon, polygonz, or polygonm
					if (shpFileType == 5 || shpFileType == 15 || shpFileType == 25) {
						for (int j=0,k=0; propertyItr.hasNext(); j++) {
							psMig.setInt(1, id);
					  
							Property p =  propertyItr.next();
							Class<?> propertyClass = p.getType().getBinding();
							
							if (!atrbFileCols.contains(j) && !propertyClass.getName().startsWith("com.vividsolutions.jts.geom.")) {
								continue;
							}
							
							Object propertyValue = p.getValue();
							
							if (propertyValue == null) {
								psMig.setNull((k+2), (java.sql.Types.NULL));
							} else if (propertyClass.getName().startsWith("com.vividsolutions.jts.geom.")) {
								Geometry g = (Geometry)propertyValue;
								GeometryConverter gc = new GeometryConverter(conn);
								geometry = (oracle.sql.STRUCT)gc.toSDO(g, m_srid);
								
								j--;
								continue;
							} else {
								setXXX(psMig, propertyClass, (k+2), propertyValue);
							}
							
							k++;
						}
						psMig.setObject(atrbFileCols.size()+1, geometry);
						psMig.executeUpdate();
					} else {
						for (int j=0, k=0; propertyItr.hasNext(); j++) {
							ps.setInt(1, id);
							
							Property p =  propertyItr.next();
							Class<?> propertyClass = p.getType().getBinding();
							
							if (!atrbFileCols.contains(j) && !propertyClass.getName().startsWith("com.vividsolutions.jts.geom.")) {
								continue;
							}
							
							Object propertyValue = p.getValue();
							
							if (propertyValue == null) {
								ps.setNull((k+2), (java.sql.Types.NULL));
							} else if (propertyClass.getName().startsWith("com.vividsolutions.jts.geom.")) {
								Geometry g = (Geometry)propertyValue;
								GeometryConverter gc = new GeometryConverter(conn);
								geometry = (oracle.sql.STRUCT)gc.toSDO(g, m_srid);
								
								j--;
								continue;
							} else {
								setXXX(ps, propertyClass, (k+2), propertyValue);
							}
							
							k++;
						}
						ps.setObject(atrbFileCols.size()+1, geometry);
						ps.executeUpdate();
					}
				} catch (SQLException e) {
					error_cnt = error_cnt + 1;
					
					StringWriter stw = new StringWriter();
					PrintWriter pw = new PrintWriter(stw);
					e.printStackTrace(pw);
					writeLog(logger, new Date().toString() + ": Error: " + stw.toString() + "\nrecord #" + (i+1) + " not converted.");
				}
			}
				  
			//Edit to adjust, or comment to remove COMMIT interval; default 1000
			if (m_commit_interval == -1) {
				if ((i+1)%1000 == 0)
					conn.commit();
			} else {
				if ((i+1)%m_commit_interval == 0)
					conn.commit();
			}
			//end_for_each_record
		}
		
		conn.commit();
		
		if (!conn.isClosed()) {
			conn.close();
		}
		
		featureItr.close();
		ds.dispose();
		
		return (i + ":" + error_cnt);
	}

	protected void prepareTableForData(Connection conn, String relSchema) 
	throws IOException, SQLException, Exception {
		// Preparation of the database
		
		// Drop table
		Statement stmt 	= null;
		String update	= null;
		
		// Try to find and replace instances of "geometry" with m_geom
		String updatedRelSchema = replaceAllWords(relSchema, "GEOMETRY", m_geom);
		
		// Create feature table
		writeLog(logger, new Date().toString() + ": creating new table...");
		
		stmt = conn.createStatement();
		update = "CREATE TABLE " + m_tableName + " (" + updatedRelSchema + ")";
				
		stmt.executeUpdate(update);
		stmt.close();
		
		writeLog(logger, new Date().toString() + ": adding reference to Geometry MetaData Table...");
		
		String geomMDTabTableName = m_tableName;
		
		if (geomMDTabTableName.contains(".")) {
			String[] s = geomMDTabTableName.split("\\.");
			geomMDTabTableName = s[1];
		}
						
		if (m_srid != 0) {
			// Add reference to geometry MetaData Table.
			stmt = conn.createStatement();
			update = "INSERT INTO " + geomMetaDataTable + " VALUES ('" + geomMDTabTableName + "', '" + m_geom.toUpperCase() + "', " + dimArray + ", " + m_srid + ")";
			stmt.executeUpdate(update);
			conn.commit();
			stmt.close();
		} else {
			// Add reference to geometry MetaData Table.
			stmt = conn.createStatement();
			update = "INSERT INTO " + geomMetaDataTable + " VALUES ('" + geomMDTabTableName + "', '" + m_geom.toUpperCase() + "', " + dimArray + ", NULL)";
			stmt.executeUpdate(update);
			conn.commit();
			stmt.close();
		}
	}

	protected String replaceAllWords(String original, String find, String replacement) {
		String result = "";
		String delimiters = "+-*/(),. ";
		StringTokenizer st = new StringTokenizer(original, delimiters, true);
		
		while (st.hasMoreTokens()) {
			String w = st.nextToken();
			if (w.equals(find)) {
				result = result + replacement;
			} else {
				result = result + w;
			}
		}
		return result;
	}
	
	protected String getODBDataType (String className, int size) {
		String odbDataType = null;
		
		try {
			if (className.equals("java.lang.Integer") || className.equals("java.lang.Byte") || className.equals("java.lang.Short") || className.equals("java.lang.Long"))
				odbDataType = "NUMBER(" + size + ")";
			else if (className.equals("java.lang.Double") || className.equals("java.math.BigDecimal") || className.equals("java.lang.Float") || className.equals("oracle.sql.NUMBER"))
				odbDataType = "NUMBER";
			else if (className.equals("java.lang.String"))
				odbDataType = "VARCHAR2(" + size + ")";
			else if (className.equals("Char"))
				odbDataType = "CHAR";
			else if (className.equals("java.util.Date") || className.equals("oracle.sql.DATE") || className.equals("java.sql.Time") || className.equals("java.sql.Date"))
				odbDataType = "DATE";
			else if (className.equals("java.lang.Boolean"))
				odbDataType = "BOOLEAN";
			else if (className.equals("oracle.sql.ROWID") || className.equals("java.sql.RowId"))
				odbDataType = "ROWID";
			else if (className.equals("java.sql.Clob") || className.equals("oracle.sql.CLOB") || className.equals("java.io.Reader"))
				odbDataType = "CLOB";
			else if (className.equals("java.sql.Blob") || className.equals("oracle.sql.BLOB") || className.equals("java.io.InputStream"))
				odbDataType = "BLOB";
			else if (className.equals("oracle.sql.BFILE"))
				odbDataType = "BFILE";
			else if (className.equals("java.sql.Array") || className.equals("oracle.sql.ARRAY"))
				odbDataType = "VARRAY";
			else if (className.equals("oracle.sql.BINARY_FLOAT"))
				odbDataType = "BINARY_FLOAT";
			else if (className.equals("oracle.sql.BINARY_DOUBLE"))
				odbDataType = "BINARY_DOUBLE";
			else if (className.equals("java.sql.Timestamp") || className.equals("oracle.sql.TIMESTAMP"))
				odbDataType = "TIMESTAMP";
			else if (className.equals("oracle.sql.TIMESTAMPTZ"))
				odbDataType = "TIMESTAMP WITH TIME ZONE";
			else if (className.equals("oracle.sql.TIMESTAMPLTZ"))
				odbDataType = "TIMESTAMP WITH LOCAL TIME ZONE";
			else if (className.equals("oracle.xdb.XMLType") || className.equals("java.sql.SQLXML"))
				odbDataType = "XMLTYPEE";
			else if (className.equals("java.sql.NClob") || className.equals("oracle.sql.NCLOB"))
				odbDataType = "NCLOB";
			else if (className.equals("java.net.URL"))
				odbDataType = "URITYPE";
		
			return odbDataType;
		} catch (Exception e) {
			StringWriter stw = new StringWriter();
			PrintWriter pw = new PrintWriter(stw);
			e.printStackTrace(pw);
			writeLog(logger, new Date().toString() + ": Error: unsupported column type\n" + stw.toString());
			
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
			StringWriter stw = new StringWriter();
			PrintWriter pw = new PrintWriter(stw);
			e.printStackTrace(pw);
			writeLog(logger, new Date().toString() + ": Error: unsupported column type\n" + stw.toString());
		}
	}
		
	protected File setLogFile() {
		File logFile = null;
		
		if (this.m_shapefileName != null) 
			if (!this.m_shapefileName.isEmpty())
					logFile = new File(this.m_shapefileName.substring(0, (this.m_shapefileName.length() - 4)) + ".log");
		
		this.logFilePath = this.m_shapefileName.substring(0, (this.m_shapefileName.lastIndexOf('\\') - 1));
		
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
			}
						
			useAttribMapping = true;
		}
	}
	
	protected String getAttributeAlias (String dbColumnName) 
	throws Exception {			
		String shpColumnName = null;
		
		if (this.attributeMap.containsKey(dbColumnName)) {
			shpColumnName = this.attributeMap.get(dbColumnName);
		}
		
		return shpColumnName;
	}
	
	protected static void writeLog(BufferedWriter logger, String log) {
		try {
			logger.write(log);
			logger.newLine();
		} catch (IOException ioe) {
			System.out.println("Exception IOException caught...\n");
			ioe.printStackTrace();
		}
	}
	
	protected static void systemExit(BufferedWriter logger) {
		try {
			logger.flush();
			logger.close();
		} catch (IOException ioe) {
			System.out.println("Exception IOException caught...\n");
			ioe.printStackTrace();
		} finally {
			System.exit(1);
		}
	}
	
	protected static void systemPrint(String s) {
		System.out.println(s);
	}
}
