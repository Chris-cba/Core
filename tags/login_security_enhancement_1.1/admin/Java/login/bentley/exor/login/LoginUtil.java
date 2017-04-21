/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/login/LoginUtil.java-arc   1.0.1.0   Apr 21 2017 07:59:22   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   LoginUtil.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   Apr 21 2017 07:59:22  $
 *		Date Fetched Out : $Modtime:   Apr 21 2017 07:46:48  $
 *		PVCS Version     : $Revision:   1.0.1.0  $
 *
 *	This class is used to make a connection to Oracle Database using a WebLogic Data Source
 *	(jdbc/<TNS-NAME>_LOGINDS) and fire queries using it, when connection is not available from Oracle 
 *	Forms Session (generally before logging in to a Forms' Session).
 *
 ****************************************************************************************************
 *	  Copyright (c) 2017 Bentley Systems Incorporated.  All rights reserved.
 ****************************************************************************************************
 *
 */

package bentley.exor.login;

import java.awt.*;
import java.awt.image.*;

import java.io.*;

import java.sql.*;

import java.util.*;

import javax.imageio.*;

import javax.naming.Context;
import javax.naming.InitialContext;

import javax.sql.DataSource;

import oracle.jdbc.*;

public class LoginUtil {
	private String formsURL   = null;
	private String dataSource = null;
	
	public static String changePassword(String connectionString, String userName, String oldPassword, String newPassword) {
		Connection conn   = null;
		Properties info   = null;
		String     result = null;
			
		try {
			ExorDebugger.reportDebugInfo("changePassword(): Changing password...");
			
			if ((connectionString != null) && (userName != null) && (oldPassword != null) && (newPassword != null)) {
				connectionString = "jdbc:oracle:oci8:@" + connectionString;
				
				info   = new Properties();
				
				info.put("user", userName);
				info.put("password", oldPassword);
				info.put("OCINewPassword", newPassword);
				
				conn = DriverManager.getConnection(connectionString, info);
				
				result = "success";
				ExorDebugger.reportDebugInfo("changePassword(): Password changed successfully");
			} else {
				result = "Invalid parameters passed";
				ExorDebugger.reportDebugInfo("changePassword(): Invalid parameters passed");
			}
		} catch(Exception changePasswordException) {
			ExorDebugger.reportDebugInfo("changePassword(): changePasswordException Exception caught...");
			changePasswordException.printStackTrace();
			
			result = changePasswordException.getMessage();
		}
		
		return result;
	}
	
	private void setDataSource(String dataSource) {
		this.dataSource = "jdbc/" + dataSource + "_LOGINDS";
	}
	
	private OracleConnection getOracleConnection() throws Exception {
		ExorDebugger.reportDebugInfo("getOracleConnection(): Getting Oracle DB Connection...");
		
		Hashtable env = new Hashtable();
		env.put(Context.INITIAL_CONTEXT_FACTORY, "weblogic.jndi.WLInitialContextFactory");
		env.put(Context.PROVIDER_URL, formsURL);
		
		OracleConnection conn = null;
		DataSource ds = null;
		Context context = new InitialContext(env);
		
		//you will need to create a Data Source with JNDI name LOGINDS
		ds   = (javax.sql.DataSource) context.lookup (dataSource);
		conn = (OracleConnection) ds.getConnection();
		
		return conn; 
	}
	
	public String doSQL(String sqlStmt, String mode) throws Exception {
		OracleConnection  conn      = getOracleConnection();
		ResultSet 		  rs        = null;
		Statement         stmt      = null;
		CallableStatement cstmt  	= null;
		String            result    = null;
		
		try {
			if(mode.equalsIgnoreCase("select")) {
				ExorDebugger.reportDebugInfo("doSQL(): Performing SELECT Query...");
				
				stmt = conn.createStatement();
				rs	 = stmt.executeQuery(sqlStmt);
				
				int              fetchSize = 0;
				
				while (rs.next()) {
					fetchSize++;
					
					if(fetchSize > 1) {
						result = "Multiple records";
						break;
					} else {
						result = rs.getString(1).trim();
					}
				}
				
				if(fetchSize < 1) {
					result = "No rows selected";
				}
			} else if(mode.equalsIgnoreCase("update")) {
				ExorDebugger.reportDebugInfo("doSQL(): Processing UPDATE Statement...");
				
				stmt   = conn.createStatement();
				result = java.lang.Integer.toString(stmt.executeUpdate(sqlStmt)) + " rows processed";
			} else if(mode.equalsIgnoreCase("execute")) {
				ExorDebugger.reportDebugInfo("doSQL(): Processing EXECUTE Statement...");
				
				cstmt  = conn.prepareCall(sqlStmt);
				result = java.lang.Boolean.toString(cstmt.execute());
			}
		} finally {
			if(rs != null) {
				rs.close();
			}
			
			if(stmt != null) {
				stmt.close();
			}
			
			if(cstmt != null) {
				cstmt.close();
			}
			
			if(conn != null) {
				conn.close();
			}
		}
		
		return result;
	}
	
	private void setFormsURL(String formsURL) {
		this.formsURL = "t3://" + formsURL;
	}
	
	public static String dbUtility(String formsURL, String sqlStmt, String mode, String dataSource) {
		String result = null;
		
		try {
			LoginUtil dsc = new LoginUtil();
			
			dsc.setFormsURL(formsURL);
			dsc.setDataSource(dataSource);
			result = dsc.doSQL(sqlStmt, mode);
			
			return result;
		} catch(Exception dbUtilityException) {
			ExorDebugger.reportDebugInfo("dbUtility(): dbUtilityException Exception caught...");
			dbUtilityException.printStackTrace();
			
			result = "ORA-20099: " + dbUtilityException.getMessage();
		}
		
		return result;
	}
	
	/**
     * Used to read an image and convert it into a java.lang.String array
     *
     * @param imagePath - java.lang.String - full path of the image
     * @return java.lang.String[]
     */
	public static String[] getAppServImage(String imagePath) throws Exception {
		File            imageFile          = null;
		FileInputStream imageInFile        = null;
		String          imageDataString    = null;
		byte            imageData[]        = null;
		String[]        imageDataStringArr = null;
		
		/**
		 * Because of the below bug, the length of String element in the retruning 
		 * String arr has to be restricted to 4096 characters.
		 * (More details on My Oracle Support) - 
		 * BUG#993409
		 * But,this is the problem of JDBC thin driver.   
		 */
		int             arrElmtLen         = 4096;
		
		if ((imagePath != null) && (!imagePath.equalsIgnoreCase("null"))) {
			try {
				imageFile   = new File(imagePath);
				imageInFile = new FileInputStream(imageFile);
				imageData   = new byte[(int) imageFile.length()];
				
				ExorDebugger.reportDebugInfo("getAppServImage(): reading image into a byte array...");
				imageInFile.read(imageData);
				imageInFile.close();
				
				ExorDebugger.reportDebugInfo("getAppServImage(): converting image to a String...");
				imageDataString = ImageEncoderAndDecoder.encodeImage(imageData);
				
				if(imageDataString.length()%arrElmtLen == 0) {
					imageDataStringArr = new String[imageDataString.length()/arrElmtLen];
				} else {
					imageDataStringArr = new String[imageDataString.length()/arrElmtLen + 1];
				}
				
				int start = 0;
				int end   = 0;
				
				ExorDebugger.reportDebugInfo("getAppServImage(): splitting image String into a String array - each element of length " + arrElmtLen + "...");
				for(int i=0; i<imageDataStringArr.length - 1; i++) {
					end  = (i+1)*(arrElmtLen + 1) - (i + 1);
					
					imageDataStringArr[i] = imageDataString.substring(start, end);
					
					start = end;
				}
				
				int imgLen = imageDataStringArr.length;
				
				imageDataStringArr[imgLen - 1] = imageDataString.substring(start);
			} catch (Exception e) {
				imageDataStringArr = new String[1];
				imageDataStringArr[0] = "ORA-20099: " + e.getMessage();
				e.printStackTrace();
			}
        } else {
			imageDataStringArr = new String[1];
			imageDataStringArr[0] = "ORA-20099: null Image Path passed";
			ExorDebugger.reportDebugInfo("getAppServImage(): null Image Path passed");
		}
		
		return imageDataStringArr;
	}
}
