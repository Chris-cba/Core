/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/login/LoginUtil.java-arc   1.0.1.2   Jul 04 2017 10:07:34   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   LoginUtil.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   Jul 04 2017 10:07:34  $
 *		Date Fetched Out : $Modtime:   Jul 04 2017 10:02:04  $
 *		PVCS Version     : $Revision:   1.0.1.2  $
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

import bentley.exor.log.IMSLogger;

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
	private static final String errorMessage = "Something went wrong!\nPlease contact your System Administrator.";
	
	public static String changePassword(String connectionString, String userName, String oldPassword, String newPassword) {
		Connection conn   = null;
		Properties info   = null;
		String     result = null;
			
		try {
			IMSLogger.log("changePassword(): Changing password...", IMSLogger.DEBUG);
			
			if ((connectionString != null) && (userName != null) && (oldPassword != null) && (newPassword != null)) {
				connectionString = "jdbc:oracle:oci8:@" + connectionString;
				
				info   = new Properties();
				info.setProperty("user", userName);
				info.setProperty("password", oldPassword);
				info.setProperty("OCINewPassword", newPassword);
				
				conn = DriverManager.getConnection(connectionString, info);
				
				if(conn != null) {
					result = "success";
				} else {
					result = errorMessage;
				}
				
				IMSLogger.log("changePassword(): Password changed successfully", IMSLogger.DEBUG);
			} else {
				result = "Invalid parameters passed";
				IMSLogger.log("changePassword(): Invalid parameters passed", IMSLogger.DEBUG);
			} 
		} catch(SQLException changePasswordSQLException) {
			logException(changePasswordSQLException, "changePassword", IMSLogger.ERROR);
			String error = changePasswordSQLException.getMessage();
			
			if(error.contains("password verification for the specified password failed")) {
				result = error.substring(error.lastIndexOf(": ") + 2);
			} else if(error.contains("invalid username/password; logon denied")) {
				result = "Invalid username/password";
			} else if(error.contains("the account is locked")) {
				result = "The account is locked";
			} else {
				result = errorMessage;
			} 
		} catch(Exception changePasswordException) {
			logException(changePasswordException, "changePassword", IMSLogger.ERROR);
			
			result = errorMessage;
		} 
		
		return result;
	} 
	
	private void setDataSource(String dataSource) {
		this.dataSource = "jdbc/" + dataSource + "_LOGINDS";
	} 
	
	private OracleConnection getOracleConnection() throws Exception {
		IMSLogger.log("getOracleConnection(): Getting Oracle DB Connection...", IMSLogger.DEBUG);
		
		Hashtable env = new Hashtable();
		env.put(Context.INITIAL_CONTEXT_FACTORY, "weblogic.jndi.WLInitialContextFactory");
		env.put(Context.PROVIDER_URL, formsURL);
		
		OracleConnection conn = null;
		DataSource ds = null;
		Context context = new InitialContext(env);
		
		//you will need to create a Data Source with JNDI name <TNS-NAME>_LOGINDS
		ds   = (javax.sql.DataSource) context.lookup (dataSource);
		return (OracleConnection) ds.getConnection();
	} 
	
	private void setFormsURL(String formsURL) {
		this.formsURL = "t3://" + formsURL;
	} 
	
	/**
     * Used to read an image and convert it into a java.lang.String array
     *
     * @param imagePath - java.lang.String - full path of the image
     * @return java.lang.String[]
     */
	public static String[] getAppServImage() {
		File            imageFile          = null;
		File            resizedImgFile     = null;
		FileInputStream imageInFile        = null;
		String          imageDataString    = null;
		byte[]          imageData          = null;
		String[]        imageDataStringArr = null;
		double 			orgImgWidth   	   = 0;
		double 			orgImgHeight  	   = 0;
		double 			imgWidth   		   = 512;
		double 			imgHeight  		   = 277;
		BufferedImage 	originalImage 	   = null;
		BufferedImage 	resizedImage 	   = null;
		
		/**
		 * Because of the below bug, the length of String element in the retruning 
		 * String arr has to be restricted to 4096 characters.
		 * (More details on My Oracle Support) - 
		 * BUG#993409
		 * But,this is the problem of JDBC thin driver.   
		 */
		int 			arrElmtLen 		   = 4096;
		
		try {
			String classPath = LoginUtil.class.getProtectionDomain().getCodeSource().getLocation().toExternalForm();
			String imagePath = classPath.substring(classPath.indexOf('/') + 1, classPath.lastIndexOf('/') + 1) + "resources/login_background.jpg";
			
			String resourcesDir = classPath.substring(classPath.indexOf('/') + 1, classPath.lastIndexOf('/') + 1) + "resources";
			File f = new File(resourcesDir);
			
			IMSLogger.log("getAppServImage(): checking 'resources' directory for write privileges...", IMSLogger.DEBUG);
			
			if(!f.canWrite()) { 
			  throw new Exception("No write privileges on 'resources' directory");
			}
			
			imageFile = new File(imagePath);
			
			if(imageFile.exists()) {
				long   lastModified   = imageFile.lastModified();
				String resizedImgPath = imagePath.replace("login_background", String.valueOf(lastModified));
				
				resizedImgFile = new File(resizedImgPath);
				
				if(!resizedImgFile.exists()) {
					originalImage = ImageIO.read(imageFile);
					
					if(originalImage != null) {
						IMSLogger.log("getAppServImage(): resizing image to fit image panel...", IMSLogger.DEBUG);
						
						int type = originalImage.getType() == 0 ? BufferedImage.TYPE_INT_ARGB : originalImage.getType();
						
						orgImgWidth   = originalImage.getWidth(null);
						orgImgHeight  = originalImage.getHeight(null);
						
						while(!((imgWidth >= orgImgWidth) && (imgHeight >= orgImgHeight))) {
							if(imgWidth < orgImgWidth) {
								orgImgHeight = orgImgHeight * (imgWidth/orgImgWidth);
								orgImgWidth  = imgWidth;
							} 
							
							if(imgHeight < orgImgHeight) {
								orgImgWidth  = orgImgWidth * (imgHeight/orgImgHeight);
								orgImgHeight = imgHeight;
							}
						}
						
						resizedImage = new BufferedImage((int)orgImgWidth, (int)orgImgHeight, type);
						Graphics2D g = resizedImage.createGraphics();
						g.drawImage(originalImage, 0, 0, (int)orgImgWidth, (int)orgImgHeight, null);
						g.dispose();
						
						ImageIO.write(resizedImage, "jpg", resizedImgFile);
						
						while(!resizedImgFile.exists()) {
							continue;
						}
					}
				} else {
					resizedImage = ImageIO.read(resizedImgFile);
				}
				
				if(resizedImage != null) {
					imageInFile = new FileInputStream(resizedImgFile);
					imageData   = new byte[(int) resizedImgFile.length()];
					
					IMSLogger.log("getAppServImage(): reading image into a byte array...", IMSLogger.DEBUG);
					
					int bytesRead = imageInFile.read(imageData);
					
					if(bytesRead > 0) {
						IMSLogger.log("getAppServImage(): converting image to a String...", IMSLogger.DEBUG);
						imageDataString = ImageEncoderAndDecoder.encodeImage(imageData);
						
						int imageDataStringLen = imageDataString.length();
						
						if(imageDataStringLen%arrElmtLen == 0) {
							imageDataStringArr = new String[imageDataStringLen/arrElmtLen];
						} else {
							imageDataStringArr = new String[imageDataStringLen/arrElmtLen + 1];
						} 
						
						int start = 0;
						int end   = 0;
						
						IMSLogger.log("getAppServImage(): splitting image String into a String array - each element of length 4096...", IMSLogger.DEBUG);
						
						for(int i=0; i<imageDataStringArr.length - 1; i++) {
							end  = (i+1)*(arrElmtLen + 1) - (i + 1);
							
							imageDataStringArr[i] = imageDataString.substring(start, end);
							
							start = end;
						} 
						
						int imgLen = imageDataStringArr.length;
						
						imageDataStringArr[imgLen - 1] = imageDataString.substring(start);
					} else {
						imageDataStringArr = new String[1];
						imageDataStringArr[0] = "1";
						
						IMSLogger.log("getAppServImage(): Bad image", IMSLogger.ERROR);
					} 
				} else {
					imageDataStringArr = new String[1];
					imageDataStringArr[0] = "1";
					
					IMSLogger.log("getAppServImage(): NOT an image", IMSLogger.ERROR);
				} 
			} else {
				imageDataStringArr = new String[1];
				imageDataStringArr[0] = "0";
				
				IMSLogger.log("getAppServImage(): Image not found", IMSLogger.TRACE);
			}
		} catch (FileNotFoundException fnfe) {
			imageDataStringArr = new String[1];
			imageDataStringArr[0] = "0";
			
			IMSLogger.log("getAppServImage(): Image not found", IMSLogger.TRACE);
		} catch (Exception e) {
			imageDataStringArr = new String[1];
			imageDataStringArr[0] = "1";
			
			logException(e, "getAppServImage", IMSLogger.ERROR);
		} finally {
			try {
				if(imageInFile != null) {
					imageInFile.close();
				}
			} catch(IOException ioe) {
				logException(ioe, "getAppServImage", IMSLogger.WARN);
			}
		} 
		return imageDataStringArr;
	}
	
	public static String validatePassword(String formsURL, String dataSource, String username, String password) {
		String logMessage = formDebugMessage("validatePassword", "Forms URL", formsURL, "Datasource", dataSource, "Username", username, "Password", "*******");
		IMSLogger.log(logMessage, IMSLogger.DEBUG);
		
		OracleConnection  conn    = null;
		CallableStatement cstmt   = null;
		String            result  = null;
		String 			  sqlStmt = null;
		
		try {
			LoginUtil dsc = new LoginUtil();
			dsc.setFormsURL(formsURL);
			dsc.setDataSource(dataSource);
			conn = dsc.getOracleConnection();
			
			sqlStmt = "{? = call hig_user_login_util.validate_password(?, ?)}";
			cstmt  = conn.prepareCall(sqlStmt);
			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
			cstmt.setString(2, username);
			cstmt.setString(3, password);
			cstmt.execute();
			
			result = cstmt.getString(1);
			
			return result;
		} catch(Exception validatePasswordException) {
			logException(validatePasswordException, "validatePassword", IMSLogger.ERROR);
			return errorMessage;
		} finally {
			closeOracle("validatePassword", cstmt, conn);
		} 
	}
	
	public static int getUserId(String formsURL, String dataSource, String username) {
		String logMessage = formDebugMessage("getUserId", "Forms URL", formsURL, "Datasource", dataSource, "Username", username);
		IMSLogger.log(logMessage, IMSLogger.DEBUG);
		
		OracleConnection  conn    = null;
		CallableStatement cstmt   = null;
		int            	  result  = -1;
		String 			  sqlStmt = null;
		
		try {
			LoginUtil dsc = new LoginUtil();
			dsc.setFormsURL(formsURL);
			dsc.setDataSource(dataSource);
			conn = dsc.getOracleConnection();
			
			sqlStmt = "{? = call hig_user_login_util.get_user_id(?)}";
			cstmt  = conn.prepareCall(sqlStmt);
			cstmt.registerOutParameter(1, java.sql.Types.NUMERIC);
			cstmt.setString(2, username);
			cstmt.execute();
			
			result = cstmt.getInt(1);
		} catch(Exception getUserIdException) {
			logException(getUserIdException, "getUserId", IMSLogger.ERROR);
		} finally {
			closeOracle("getUserId", cstmt, conn);
		}
		
		return result;
	}
	
	public static String emailUnlock(String formsURL, String dataSource, String username) {
		String logMessage = formDebugMessage("emailUnlock", "Forms URL", formsURL, "Datasource", dataSource, "Username", username);
		IMSLogger.log(logMessage, IMSLogger.DEBUG);
		
		OracleConnection  conn    = null;
		CallableStatement cstmt   = null;
		String            result  = null;
		String 			  sqlStmt = null;
		
		try {
			LoginUtil dsc = new LoginUtil();
			dsc.setFormsURL(formsURL);
			dsc.setDataSource(dataSource);
			conn = dsc.getOracleConnection();
			
			sqlStmt = "{? = call hig_user_login_util.email_unlock(?)}";
			cstmt  = conn.prepareCall(sqlStmt);
			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
			cstmt.setString(2, username);
			cstmt.execute();
			
			result = cstmt.getString(1);
			
			return result;
		} catch(Exception getUserIdException) {
			logException(getUserIdException, "emailUnlock", IMSLogger.ERROR);
			return errorMessage;
		} finally {
			closeOracle("emailUnlock", cstmt, conn);
		}
	}
	
	public static String emailSystemAdmin(String formsURL, String dataSource, String username) {
		String logMessage = formDebugMessage("emailSystemAdmin", "Forms URL", formsURL, "Datasource", dataSource, "Username", username);
		IMSLogger.log(logMessage, IMSLogger.DEBUG);
		
		OracleConnection  conn    = null;
		CallableStatement cstmt   = null;
		String            result  = null;
		String 			  sqlStmt = null;
		
		try {
			LoginUtil dsc = new LoginUtil();
			dsc.setFormsURL(formsURL);
			dsc.setDataSource(dataSource);
			conn = dsc.getOracleConnection();
			
			sqlStmt = "{? = call hig_user_login_util.email_system_admin(?)}";
			cstmt  = conn.prepareCall(sqlStmt);
			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
			cstmt.setString(2, username);
			cstmt.execute();
			
			result = cstmt.getString(1);
			
			if("Y".equals(result)) {
				return result;
			} else {
				throw new Exception(result);
			}
		} catch(Exception getUserIdException) {
			logException(getUserIdException, "emailSystemAdmin", IMSLogger.ERROR);
			return errorMessage;
		} finally {
			closeOracle("emailSystemAdmin", cstmt, conn);
		}
	}
	
	public static String checkBirthDate(String formsURL, String dataSource, int userId, String birthDate) {
		String logMessage = formDebugMessage("checkBirthDate", "Forms URL", formsURL, "Datasource", dataSource, "User Id", String.valueOf(userId), "Birthdate", "*******");
		IMSLogger.log(logMessage, IMSLogger.DEBUG);
		
		OracleConnection  conn    = null;
		CallableStatement cstmt   = null;
		String            result  = null;
		String 			  sqlStmt = null;
		
		try {
			LoginUtil dsc = new LoginUtil();
			dsc.setFormsURL(formsURL);
			dsc.setDataSource(dataSource);
			conn = dsc.getOracleConnection();
			
			sqlStmt = "{? = call hig_user_login_util.check_birthdate(?, ?)}";
			cstmt  = conn.prepareCall(sqlStmt);
			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
			cstmt.setInt(2, userId);
			cstmt.setString(3, birthDate);
			cstmt.execute();
			
			result = cstmt.getString(1);
			
			return result;
		} catch(Exception checkBirthDateException) {
			logException(checkBirthDateException, "checkBirthDate", IMSLogger.ERROR);
			return errorMessage;
		} finally {
			closeOracle("checkBirthDate", cstmt, conn);
		}
	}
	
	public static String checkSecurityAnswer(String formsURL, String dataSource, int userId, String securityAnswer) {
		String logMessage = formDebugMessage("checkSecurityAnswer", "Forms URL", formsURL, "Datasource", dataSource, "User Id", String.valueOf(userId), "Security Answer", "*******");
		IMSLogger.log(logMessage, IMSLogger.DEBUG);
		
		OracleConnection  conn    = null;
		CallableStatement cstmt   = null;
		String            result  = null;
		String 			  sqlStmt = null;
		
		try {
			LoginUtil dsc = new LoginUtil();
			dsc.setFormsURL(formsURL);
			dsc.setDataSource(dataSource);
			conn = dsc.getOracleConnection();
			
			sqlStmt = "{? = call hig_user_login_util.check_security_answer(?, ?)}";
			cstmt  = conn.prepareCall(sqlStmt);
			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
			cstmt.setInt(2, userId);
			cstmt.setString(3, securityAnswer);
			cstmt.execute();
			
			result = cstmt.getString(1);
			
			return result;
		} catch(Exception checkSecurityAnswerException) {
			logException(checkSecurityAnswerException, "checkSecurityAnswer", IMSLogger.ERROR);
			return errorMessage;
		} finally {
			closeOracle("checkSecurityAnswer", cstmt, conn);
		}
	}
	
	public static String getUserSecurityQuestion(String formsURL, String dataSource, int userId) {
		String logMessage = formDebugMessage("getUserSecurityQuestion", "Forms URL", formsURL, "Datasource", dataSource, "User Id", String.valueOf(userId));
		IMSLogger.log(logMessage, IMSLogger.DEBUG);
		
		OracleConnection  conn    = null;
		CallableStatement cstmt   = null;
		String            result  = null;
		String 			  sqlStmt = null;
		
		try {
			LoginUtil dsc = new LoginUtil();
			dsc.setFormsURL(formsURL);
			dsc.setDataSource(dataSource);
			conn = dsc.getOracleConnection();
			
			sqlStmt = "{call hig_user_login_util.get_user_security_question(?, ?)}";
			cstmt  = conn.prepareCall(sqlStmt);
			cstmt.setInt(1, userId);
			cstmt.registerOutParameter(2, OracleTypes.CURSOR);
			cstmt.execute();
			ResultSet rset = (ResultSet)cstmt.getObject(2);
			
			int fetchSize = 0;
			
			while (rset.next()) {
				fetchSize++;
				
				if(fetchSize > 1) {
					result = "Multiple records";
					break;
				} else {
					result = rset.getString(1);
				}
			}
			
			if(fetchSize < 1) {
				result = "No record found";
			}
			
			return result;
		} catch(Exception getUserSecurityQuestionException) {
			logException(getUserSecurityQuestionException, "getUserSecurityQuestion", IMSLogger.ERROR);
			return errorMessage;
		} finally {
			closeOracle("getUserSecurityQuestion", cstmt, conn);
		}
	}
	
	public static String generateUserPassword(String formsURL, String dataSource, String username) {
		String logMessage = formDebugMessage("generateUserPassword", "Forms URL", formsURL, "Datasource", dataSource, "Username", username);
		IMSLogger.log(logMessage, IMSLogger.DEBUG);
		
		OracleConnection  conn    = null;
		CallableStatement cstmt   = null;
		String            result  = null;
		String 			  sqlStmt = null;
		
		try {
			LoginUtil dsc = new LoginUtil();
			dsc.setFormsURL(formsURL);
			dsc.setDataSource(dataSource);
			conn = dsc.getOracleConnection();
			
			sqlStmt = "{? = call hig_user_login_util.generate_user_password(?)}";
			cstmt  = conn.prepareCall(sqlStmt);
			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
			cstmt.setString(2, username);
			cstmt.execute();
			
			result = cstmt.getString(1);
			
			if("Y".equals(result)) {
				return result;
			} else if(  result.contains("Missing email-id") 
					 || result.contains("Email address not specified in the system for user")
					 || result.contains("Missing SMTP settings")
			         ) {
				return result.substring(result.lastIndexOf(": ") + 2);
			} else {
				throw new Exception(result);
			}
		} catch(Exception generateUserPasswordException) {
			logException(generateUserPasswordException, "generateUserPassword", IMSLogger.ERROR);
			return errorMessage;
		} finally {
			closeOracle("generateUserPassword", cstmt, conn);
		}
	}
	
	private static String formDebugMessage(String functionName, String... params) {
		StringBuilder logMessage = new StringBuilder();
		logMessage.append(functionName).append("()");
		
		int count = 1;
		
		for(String s:params) {
			if(count%2 != 0) {
				logMessage.append("\n\t").append(s).append(" - ");
			} else {
				logMessage.append(s);
			}
			
			count++;
		}
		
		return logMessage.toString();
	}
	
	private static void logException(Exception e, String functionName, int logLevel) {
		StringWriter errors = new StringWriter();
		errors.append(functionName).append("() : Exception caught...\n");
		e.printStackTrace(new PrintWriter(errors));
		
		IMSLogger.log(errors.toString(), logLevel);
	}
	
	private static void closeOracle(String functionName, CallableStatement cstmt, OracleConnection conn) {
		try {
			if(cstmt != null) {
				cstmt.close();
			}
			
			if(conn != null) {
				conn.close();
			}
		} catch(Exception closeException) {
			logException(closeException, functionName, IMSLogger.WARN);
		}
	}
}