/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/login/WebPagePanel.java-arc   1.2.1.0   May 26 2021 08:38:38   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   WebPagePanel.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   May 26 2021 08:38:38  $
 *		Date Fetched Out : $Modtime:   May 18 2021 11:22:04  $
 *		PVCS Version     : $Revision:   1.2.1.0  $
 *
 *	
 *
 ****************************************************************************************************
 *	  Copyright (c) 2021 Bentley Systems Incorporated.  All rights reserved.
 ****************************************************************************************************
 *
 */

package bentley.exor.login;

import bentley.exor.ExorDebugger; 

import java.awt.*;
import java.awt.event.*;

import java.io.*;

import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

import java.util.*;

import javax.swing.*;

import oracle.forms.handler.IHandler;
import oracle.forms.properties.ID;
import oracle.forms.ui.CustomEvent;
import oracle.forms.ui.CustomListener;
import oracle.forms.ui.VBean;

import javax.swing.SwingUtilities;

public class WebPagePanel extends VBean {
	private transient ID 		RUN_PAGE	= ID.registerProperty("RUN_PAGE");
	private transient ID 		TNS_NAME	= ID.registerProperty("TNS_NAME");
	private transient IHandler 	handler		= null; 
	
	private String 	  		tnsName		 = null;
	private String 	  		url			 = null; 
	
	public WebPagePanel() {
		super(); 
	}
	
	protected void setTNSName(String tnsName) {
		ExorDebugger.reportDebugInfo("setTNSName(): Setting TNS Name: " + tnsName);
		this.tnsName = tnsName;
	}
	
	public void init(IHandler handler) {
		this.handler = handler;
		
        super.init(handler);
    }
	
	public boolean setProperty(ID paramID, Object valueObj) {
		if(paramID == RUN_PAGE) {
			runPage(valueObj.toString());
		} else if(paramID == TNS_NAME) {
			setTNSName(valueObj.toString());
		}	
		
		return super.setProperty(paramID, valueObj);
	}
	
    private void initComponents() { 
		try {
			System.out.println("creating thread..."); 
			
			Thread t = new Thread() { 
				public void run()
				{ 
					boolean isIMSLoggingIn = true;
					
					while(isIMSLoggingIn) {  
						BufferedReader bufferedReader = null;
						
						try { 
							URL obj = new URL(WebPagePanel.this.url); 
							URLConnection conn = obj.openConnection(); 
							
							bufferedReader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
							
							String line = null;
							
							while ((line = bufferedReader.readLine()) != null) {
								if(line.contains("<title>Exor-IMS-Claims</title>")) {
									System.out.println("Successfully Authenticated by Bentley-IMS..."); 
									
									String claims = ""; 
									boolean start = false; 
									
									while ((line = bufferedReader.readLine()) != null) {
										if(line.contains("<div id=\"claims\">")) {
											start = true; 
											
											continue; 
										}
										
										if(line.contains("</div>")) {
											start = false; 
										}
										
										if(start) {
											claims += line.trim(); 
										} 
									}
									
									WebPagePanel.this.getTNSName(); 
									
									while(WebPagePanel.this.tnsName == null || WebPagePanel.this.tnsName.length() <= 0) {
										continue; 
									}
									
									String tns = WebPagePanel.this.tnsName.trim(); 
									claims = claims.trim() + tns.length() + "$" + tns; 
									
									WebPagePanel.this.dispatchCustomEvent("IMSLoginStatusEvent", claims); 
									
									isIMSLoggingIn = false; 
									
									break; 
								}
							} 
						} catch(Exception e1) {
							System.out.println("Error: " + e1.getMessage()); 
						} finally {
							if(bufferedReader != null) {
								try {
									bufferedReader.close();
								} catch(IOException ioe) {
								}
							}
						} 
						
						try {
							Thread.sleep(1000); 
						} catch(Exception e) {
							
						}
					}
				}
			}; 
			
			t.start(); 
		} catch(Exception e) {
			e.printStackTrace(); 
		} 
    }
	
	private void getTNSName() {
		SwingUtilities.invokeLater(new Runnable() {
			public void run() { 
				if (SwingUtilities.isEventDispatchThread()) { 
					while(WebPagePanel.this.tnsName == null || WebPagePanel.this.tnsName.length() <= 0) {
						String result = (String)JOptionPane.showInputDialog(
						   WebPagePanel.this,
						   "Please provide a database to connect", 
						   "Database",            
						   JOptionPane.PLAIN_MESSAGE,
						   null,            
						   null, 
						   ""
						); 
						
						if(result != null && result.length() > 0){
						   WebPagePanel.this.tnsName = result; 
						} 
					}
				}
			}	
		}); 
	}
	
    private void loadURL(final String url) {
        String tmp = toURL(url);

        if (tmp == null) {
            tmp = toURL(url);
        }
		
		this.url = tmp;
    }
	
    private static String toURL(String str) {
        try {
            return new URL(str).toExternalForm();
        } catch (MalformedURLException exception) {
                return null;
        }
    }
	
	protected void dispatchCustomEvent(String eventType, String returnStr) { 
		try { 
			ExorDebugger.reportDebugInfo("dispatchCustomEvent(): Dispatching Custom Event...");
			
			ID ELEMENT_TEXT_CONTENT = ID.registerProperty("ELEMENT_TEXT_CONTENT");
			
			final CustomEvent ce = new CustomEvent(handler, eventType);
			ce.setProperty(ELEMENT_TEXT_CONTENT, returnStr);
			
			SwingUtilities.invokeLater(new Runnable() {
				@Override
				public void run() {
					if (SwingUtilities.isEventDispatchThread()) {
						WebPagePanel.this.dispatchCustomEvent(ce);
					}
				}
			});	
		} catch(Exception e) {
			e.printStackTrace();
		}
	} 
	
	public void runPage(final String url) {
		this.loadURL(url);
		this.initComponents();
		
		this.setVisible(true);
		this.repaint();
    } 
}

