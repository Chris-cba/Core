/**
 *    PVCS Identifiers :-
 *
 *       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/Java/shapefile/bentley/exor/gis/ShapefileUtility.java-arc   1.0   Oct 13 2017 10:15:26   Upendra.Hukeri  $
 *       Module Name      : $Workfile:   ShapefileUtility.java  $
 *       Date into SCCS   : $Date:   Oct 13 2017 10:15:26  $
 *       Date fetched Out : $Modtime:   Oct 13 2017 10:14:14  $
 *       SCCS Version     : $Revision:   1.0  $
 *       Based on 
 *
 *
 *
 *    Author : Upendra Hukeri
 *    ShapefileUtility.java
 *
 ****************************************************************************************************
 *	  Copyright (c) 2017 Bentley Systems Incorporated.  All rights reserved.
 ****************************************************************************************************
 *
 */
 
package bentley.exor.gis;

import bentley.exor.util.UnzipUtil;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StringWriter;

import java.net.URISyntaxException;

import java.nio.charset.StandardCharsets;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * This program provides common functionality required to extract/upload a Shapefile.
 */

public class ShapefileUtility {
	private	boolean 		useNestedConn 	  	= false;
	private	String 			host 			  	= null;
	private	int				port			  	= 0;
	private	String 			userName		  	= null;
	private	String 			password			= null;
	private	String 			sid				 	= null;
	private	String 			viewName			= null; 
	private	String  		geomColName			= null;
	private	String  		shpFileName			= null;
	private	String			colMapFileName		= null;
	private	boolean			useColumnMapping	= false;
	
	private	String[][] 		columnMapArray		= null;
	private Map<String, String> columnMap		= new HashMap<String, String>();
	
	private	BufferedWriter  logger				= null;
	private	String 		    errorMsg			= null;
	
	private	String 			extractDir   		= null;
	private	String 			uploadDir   		= null;
	private	String 			colMapDir    		= null;
	private	String 			systemLogDir		= null;
	private	String 			epsgDbDir			= null;
	
	private	String 			systemLogFileName  	= null;
	
	private	boolean 		exitSystem  		= false;
	
	static final String[] validExtractKeysArray = {"-help", "-nc", "-h", "-p", "-s", "-u", "-d", "-t", "-w", "-f", "-a", "-whelp"};
	static final String[] validUploadKeysArray  = {"-help", "-nc", "-h", "-p", "-s", "-u", "-d", "-t", "-f", "-i", "-r", "-g", "-x", "-y", "-m", "-o", "-n", "-c", "-a"};
	
	protected enum Directory {SYSTEMLOGDIR, EXTRACTDIR, UPLOADDIR, COLMAPDIR, EPSGDBDIR}
	
	protected static final String SHPSUCCESSMSG 	= "success";
	protected static final String SDE2SHPFAILUREMSG = "\nError: shapefile creation failed!";
	protected static final String SHP2SDEFAILUREMSG = "\nError: shapefile upload failed!";
	
	protected void setExitSystem(boolean exitVal) {
		exitSystem = exitVal;
	}
	
	protected boolean getExitSystem() {
		return exitSystem;
	}
	
	public ShapefileUtility() {
		super();
	}
	protected void setUseNestedConn(boolean useNestedConn) {
		this.useNestedConn = useNestedConn;
	}

	protected boolean getUseNestedConn() {
		return useNestedConn;
	}

	protected void setHost(String host) {
		this.host = host;
	}

	protected String getHost() {
		return host;
	}

	protected void setPort(int port) {
		this.port = port;
	}

	protected int getPort() {
		return port;
	}

	protected void setUserName(String userName) {
		this.userName = userName;
	}

	protected String getUserName() {
		return userName;
	}

	protected void setPassword(String password) {
		this.password = password;
	}

	protected String getPassword() {
		return password;
	}

	protected void setSID(String sid) {
		this.sid = sid;
	}

	protected String getSID() {
		return sid;
	}
	
	protected void setViewName(String viewName) {
		this.viewName = viewName.toUpperCase(Locale.ENGLISH);
	}

	protected String getViewName() {
		return viewName;
	}
	
	protected void setGeomColName(String geomColName) {
		this.geomColName = geomColName;
	}

	protected String getGeomColName() {
		return geomColName;
	}
	
	protected void setSHPFileName(String shpFileName) {
		this.shpFileName = shpFileName;
	}
	
	protected String getSHPFileName() {
		return shpFileName;
	}
	
	protected void setColMapFileName(String colMapFileName) {
		this.colMapFileName = colMapFileName;
	}
	
	protected String getColMapFileName() {
		return colMapFileName;
	}
	
	protected void setUseColumnMapping(boolean useColumnMapping) {
		this.useColumnMapping = useColumnMapping;
	}
	
	protected boolean getUseColumnMapping() {
		return useColumnMapping;
	}
	
	
	protected void setLogFileName(String shpFileName) {
		this.shpFileName = shpFileName;
	}
	
	protected String[][] getColumnMapArray() {
		return columnMapArray;
	}
	
	protected String getAttributeAlias(String dbColumnName) 
	throws Exception {			
		return columnMap.get(dbColumnName);
	}
	
	protected String getDirectoryPath(Directory directoryName) {
		switch(directoryName) {
			case SYSTEMLOGDIR:
				return systemLogDir;
			case EXTRACTDIR:
				return extractDir;
			case UPLOADDIR:
				return uploadDir;
			case COLMAPDIR:
				return colMapDir;
			case EPSGDBDIR:
				return epsgDbDir;
			default:
				return null;
		}
	}
	
	protected String setBasicDirectories(String operation) {
		String jarDir		= null;
				
		//1. SETTING BASIC DIRECTORY PATHS
		try {
			jarDir = System.getenv("SDE_UTIL_PATH");
			
			if(jarDir != null && !jarDir.isEmpty()) {
				jarDir = jarDir.endsWith("\\") ? jarDir.substring(0, jarDir.length() - 1) : jarDir;
				jarDir = jarDir.replace('\\', '/');
			} else {
				if(useNestedConn) {
					jarDir = System.getProperty("user.dir");
				} else { 
					try {
						jarDir = ShapefileUtility.class.getProtectionDomain().getCodeSource().getLocation().toURI().getPath();
						jarDir = jarDir.substring(0, jarDir.lastIndexOf('/'));
					} catch(URISyntaxException use) {
						return use.getMessage();
					}
				}
			}
		} catch(Exception getEnvException) {
			return getEnvException.getMessage();
		}
		
		systemLogDir = jarDir + "/log/";
		extractDir   = jarDir + "/extract/";
		uploadDir    = jarDir + "/upload/";
		colMapDir    = jarDir + "/column_map/";
		epsgDbDir    = jarDir + "/epsg_db/";
		
		//2. SETTING SYSTEM LOG FILE
		String result = createDir(systemLogDir);
		
		if("Y".equals(result)) {
			try {
				DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
				Calendar cal = Calendar.getInstance();
				String timeExtension = dateFormat.format(cal.getTime());
				
				if("SDE2SHP".equalsIgnoreCase(operation)) {
					systemLogFileName = "sde2shp_" + timeExtension + ".log";
				} else if("SHP2SDE".equalsIgnoreCase(operation)) {
					systemLogFileName = "shp2sde_" + timeExtension + ".log";
				}
				
				File systemLogFile = new File(systemLogDir + systemLogFileName);
				
				setLogger(new BufferedWriter(new OutputStreamWriter(new FileOutputStream(systemLogFile), StandardCharsets.UTF_8)));
				
				System.out.println(systemLogFile.toString());
			} catch(IOException ie) {
				return ie.getMessage();
			}
		} else if("N".equals(result)) {
			return "error creating system log directory";
		} else {
			return result;
		}
		
		//3. SETTING EXTRACT DIRECTORY
		result = createDir(extractDir);
		
		if("Y".equals(result)) {
			
		} else if("N".equals(result)) {
			return "error creating extract directory";
		} else {
			return result;
		}
		
		
		//4. SETTING UPLOAD DIRECTORY
		result = createDir(uploadDir);
		
		if("Y".equals(result)) {
			
		} else if("N".equals(result)) {
			return "error creating upload directory";
		} else {
			return result;
		}
		
		//5 SETTING COLUMN MAPPING DIRECTORY
		result = createDir(colMapDir);
		
		if("Y".equals(result)) {
			
		} else if("N".equals(result)) {
			return "error creating column mapping directory";
		} else {
			return result;
		}
		
		//6. SETTING EPSG DATABASE DIRECTORY
		result = createDir(epsgDbDir);
		
		if("Y".equals(result)) {
			try {
				InputStream zipfileInputStream = getClass().getResourceAsStream("/resources/EPSG.zip");
				result = UnzipUtil.unzip(zipfileInputStream, jarDir);
				
				if(!"success".equals(result)) {
					return result;
				}
				
				System.setProperty("EPSG-HSQL.directory", epsgDbDir);
			} catch (Throwable epsgDbDirExp) {
				return epsgDbDirExp.getMessage();
			}
		} else if("N".equals(result)) {
			return "error creating epsg database directory";
		} else {
			return result;
		}
		
		return "Y";
	}
	
	protected String createDir(String dirLoc) { 
		try {
			File f = new File(dirLoc);
			
			if (f.isDirectory()) {
				return "Y";
			} else {
				boolean dirCreated = f.mkdir();
				
				if (!dirCreated) {
					return "N";
				} else {
					return "Y";
				}
			}
		} catch(SecurityException se) {
			return se.getMessage();
		}
	}
	
	protected Connection getConnection() 
	throws SQLException, ClassNotFoundException, Exception { 
		Connection connection = null;
		
		if(useNestedConn) {
			connection = DriverManager.getConnection("jdbc:default:connection");
		} else {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			connection = DriverManager.getConnection("jdbc:oracle:thin:@" + host + ":" + port + ":" + sid, userName, password);
		}
		
		return connection;
	}
	
	protected final File setLogFile(String operation) {
		if (shpFileName != null && !shpFileName.isEmpty()) {
			if("SDE2SHP".equalsIgnoreCase(operation)) {
				return new File(extractDir + shpFileName + ".log");
			} else if("SHP2SDE".equalsIgnoreCase(operation)) {
				return new File(uploadDir + shpFileName + ".log");
			}
		}
		
		return null;
	}
	
	protected File getColumnMapFile() 
	throws FileNotFoundException {
		File colMapFile = null;
		
		if (useColumnMapping && colMapFileName != null && !colMapFileName.isEmpty()) {
				colMapFile = new File(colMapDir + colMapFileName);
				
				if (!colMapFile.exists()) {
					setErrorMsg("\nError: File - " + colMapFileName + " - not found!\n");
					writeLog(getErrorMsg(), false);
					setExitSystem(true);
					
					colMapFile = null; 
				}
		}
		
		return colMapFile;
	}
	
	protected boolean conformOracleNamingConvention(String oracleObjName) {
		Pattern pattern = Pattern.compile("[^a-zA-Z0-9_$#]");
		
		return !pattern.matcher(oracleObjName).find();
	}
	
	protected void setColumnMap() 
	throws IOException, Exception {
		BufferedReader colMapReader = null;
		
		try {
			if(useColumnMapping) {
				writeLog("reading column-mapping file...");
				
				File    colMapFile = getColumnMapFile();
				
				if (colMapFile != null) {
					colMapReader = new BufferedReader(new InputStreamReader(new FileInputStream(colMapFile), StandardCharsets.UTF_8));
					
					String read = null;
					
					while ((read = colMapReader.readLine()) != null) {
						String[] keyValue    = read.split(" ");
						String   columnName  = keyValue[0].toUpperCase(Locale.ENGLISH);
						String   columnAlias = keyValue[1].toUpperCase(Locale.ENGLISH);
						
						if(conformOracleNamingConvention(columnName) && conformOracleNamingConvention(columnAlias)) {
							columnMap.put(columnName, columnAlias);
						} else {
							setErrorMsg("\nError: column/alias name with special characters not allowed - " + columnName + " " + columnAlias + " (allowed: A-Z a-z 0-9 _ $ #)");
							writeLog(getErrorMsg(), false);
							setExitSystem(true);
						}
					}
					
					columnMap.put(geomColName, geomColName);
					
					if(columnMap.size() > 0) {
						columnMapArray = new String[columnMap.size()][]; 
						int i = 0;
						
						Iterator itr = columnMap.entrySet().iterator();
						
						while (itr.hasNext()) {
							Map.Entry pair = (Map.Entry)itr.next();
							columnMapArray[i] = new String[] {(String)pair.getKey(), (String)pair.getValue()};
							
							i++;
						}
					}
				}
			}
		} finally {
			if(colMapReader != null) {
				try {
					colMapReader.close();
				} catch(Exception e) {
					logException(e, "setColumnMap");
				}
			}
		}
	}
	
	protected void writeLog(String log) {
		writeLog(log, true);
	}
	
	protected void writeLog(String log, boolean includeDate) {
		try {
			String errorMessage = includeDate ? new Date().toString() + ": " + log : log;
			logger.write(errorMessage);
			logger.newLine();
		} catch (IOException ioe) {
			System.out.println("\nError: Exception IOException caught...\n");
			ioe.printStackTrace();
		}
	}
	
	protected final void systemExit() {
		try {
			if(logger != null) {
				logger.flush();
				logger.close();
			}
		} catch (IOException ioe) {
			System.out.println("\nError: Exception IOException caught...\n");
			ioe.printStackTrace();
		}
	}
	
	protected void setLogger(BufferedWriter bufferedLogWriter) {
		logger = bufferedLogWriter;
	}
	
	protected void closeOracle(String functionName, Statement stmt, Connection conn, ResultSet resultSet) {
		try {
			if(resultSet != null) {
				resultSet.close();
			}
			
			if(stmt != null) {
				stmt.close();
			}
			
			if(conn != null) {
				conn.close();
			}
		} catch(SQLException closeOracleException) {
			logException(closeOracleException, "closeOracle");
		}
	}
	
	protected void logException(Throwable e, String functionName) {
		StringWriter errors = new StringWriter();
		errors.append(functionName).append("() : Exception caught...\n");
		e.printStackTrace(new PrintWriter(errors));
		
		setErrorMsg(errors.toString());
		
		writeLog(getErrorMsg(), false);
	}
	
	protected void setErrorMsg(String errorMsg) {
		this.errorMsg = errorMsg;
	}
	
	protected String getErrorMsg() {
		return errorMsg;
	}
	
	protected String getSystemLogFileName() {
		return systemLogFileName;
	}
	
	public String toString() { 
        return "ShapefileUtility: " + userName + '@' + sid + " on " + viewName + " to " + shpFileName;
    }
}
