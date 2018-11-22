/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/login/WebPagePanel.java-arc   1.2   Nov 22 2018 14:55:12   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   WebPagePanel.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   Nov 22 2018 14:55:12  $
 *		Date Fetched Out : $Modtime:   Nov 22 2018 14:51:26  $
 *		PVCS Version     : $Revision:   1.2  $
 *
 *	
 *
 ****************************************************************************************************
 *	  Copyright (c) 2018 Bentley Systems Incorporated.  All rights reserved.
 ****************************************************************************************************
 *
 */

package bentley.exor.login;

import bentley.exor.ExorDebugger;

import chrriis.common.UIUtils;

import chrriis.dj.nativeswing.swtimpl.components.*;
import chrriis.dj.nativeswing.swtimpl.NativeInterface;

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

import org.w3c.dom.*;

public class WebPagePanel extends VBean {
	private transient ID 		RUN_PAGE	= ID.registerProperty("RUN_PAGE");
	private transient ID 		TNS_NAME	= ID.registerProperty("TNS_NAME");
	private transient IHandler 	handler		= null;
	private transient JPanel 	statusBar 	= null;
	
	private JProgressBar 	progressBar = new JProgressBar();
	private String 	  		tnsName		= null;
	private String 	  		url			= null;
	private StringBuffer 	token		= new StringBuffer();
	private Frame 	  		jw			= null;
	private JWebBrowser 	webBrowser	= null;
	
	public WebPagePanel() {
		super();
		
		ExorDebugger.reportDebugInfo("WebPagePanel(): Opening Native Interface...");
		
		NativeInterface.open();
		UIUtils.setPreferredLookAndFeel();
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
			/*
			for (StackTraceElement ste : Thread.currentThread().getStackTrace()) {
				System.out.println(ste);
			}
			*/
			
			jw = (Frame)SwingUtilities.windowForComponent(this);
			
			jw.setVisible(false);
			jw.setVisible(true);
			
			ExorDebugger.reportDebugInfo("initComponents(): Checking for IMS Tokens...");
			
			URL obj = new URL(this.url);
			URLConnection conn = obj.openConnection();
			
			Map<String, java.util.List<String>> map = conn.getHeaderFields();
			
			java.util.List<String> location = map.get("Location");
			
			int counter = (location == null) ? 1 : location.size(); 
			
			//System.out.println("counter: " + counter); 
			
			for (int i=0; i<counter; i++) {
				if(location != null) {
					obj = new URL((String)location.get(i));
					conn = obj.openConnection();
				}
				
				BufferedReader bufferedReader = null;
				
				try {
					bufferedReader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
					
					String line = null;
					
					while ((line = bufferedReader.readLine()) != null) {
						String tokenTag = "<input type=\"hidden\" name=\"wresult\" value=\"";
						
						if(line.contains(tokenTag)) {
							token.append(HtmlEntities.decode(line.substring(line.indexOf(tokenTag) + tokenTag.length(), line.indexOf("\" />", line.indexOf(tokenTag)))));
							
							ExorDebugger.reportDebugInfo("initComponents(): IMS Tokens found...");
							
							break;
						}
					}
				} finally {
					if(bufferedReader != null) {
						try {
							bufferedReader.close();
						} catch(IOException ioe) {
						}
					}
				}
			}
			
			JWebBrowser.clearSessionCookies();
			webBrowser = new JWebBrowser();
			
			SwingUtilities.invokeLater(new Runnable() {
				public void run() {
					if (SwingUtilities.isEventDispatchThread()) {
						
						webBrowser.setBarsVisible(false);
						
						WebBrowserNavigationParameters wbnp = new WebBrowserNavigationParameters();
						
						Map<String, String> paramMap = new HashMap<String, String>();
						paramMap.put("wa", "wsignin1.0");
						paramMap.put("wctx", "/exor-ims/index.jsp");
						paramMap.put("wresult", token.toString());
						
						Map<String, String> headerMap = new HashMap<String, String>();
						headerMap.put("Content-Type", "application/x-www-form-urlencoded");
						
						wbnp.setHeaders(headerMap);
						wbnp.setPostData(paramMap);
						
						ExorDebugger.reportDebugInfo("initComponents(): Navigating to Exor-IMS application...");
						
						if(token.toString().length() != 0) {
							webBrowser.navigate(url, wbnp);
						} else {
							webBrowser.navigate(url);
						}
						
						webBrowser.addWebBrowserListener(new WebBrowserListener() {
							public void commandReceived(WebBrowserCommandEvent e) {
							}
							
							public void loadingProgressChanged(WebBrowserEvent e) {
								SwingUtilities.invokeLater(new Runnable() {
									@Override public void run() {
										int loadingProgress = webBrowser.getLoadingProgress();
										
										progressBar.setValue(loadingProgress);
										progressBar.setString("");
										
										if(loadingProgress == 100) {
											statusBar.setVisible(false);
										} else {
											statusBar.setVisible(true);
										}
									}
								});
							}
							
							public void locationChangeCanceled(WebBrowserNavigationEvent e) {
							}
							
							public void locationChanged(WebBrowserNavigationEvent e) {
								
							}
							
							public void locationChanging(WebBrowserNavigationEvent e) {
							}
							
							public void statusChanged(WebBrowserEvent e) {
								if (SwingUtilities.isEventDispatchThread()) {
									try {
										String tnsVal = null;
										
										if(tnsName != null && tnsName.length() > 0) {
											webBrowser.executeJavascript("setTNSName('" + tnsName + "')");
										}
										
										String obj = (String)webBrowser.executeJavascriptWithResult("return getTestString()");
										
										if((obj != null) && !"null".equals(obj)) {
											WebPagePanel.this.setSize(0, 0);
											WebPagePanel.this.setVisible(false);
											
											WebPagePanel.this.dispatchCustomEvent("IMSLoginStatusEvent", obj);
											
											ExorDebugger.reportDebugInfo("statusChanged(): Closing Native Interface...");
											
											NativeInterface.close();
										}
									} catch(Exception ex) {
										ex.printStackTrace();
									}
								}
							}
							
							public void titleChanged(WebBrowserEvent e) {
							}
							
							public void windowClosing(WebBrowserEvent e) {
							}
							
							public void windowOpening(WebBrowserWindowOpeningEvent e) {
							}
							
							public void windowWillOpen(WebBrowserWindowWillOpenEvent e) {
							}
						});
						
						progressBar.setStringPainted(true);
						progressBar.setPreferredSize(new Dimension(500, 5));
						progressBar.setForeground(new Color(95, 115, 245));
						progressBar.setBorderPainted(false);
						
						statusBar = new WebPageStatusPanel(progressBar);
						
						statusBar.add(progressBar, BorderLayout.SOUTH);
						
						WebPagePanel.this.setLayout(new BorderLayout());
						WebPagePanel.this.add(webBrowser, BorderLayout.CENTER);
						WebPagePanel.this.add(statusBar, BorderLayout.NORTH);
					}
				}	
			});
		} catch(Exception e) {
			e.printStackTrace();
		}
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
	
	public void destroy() {
		ExorDebugger.reportDebugInfo("destroy(): Destroying Exor-IMS application...");
		
		if(jw != null) {
			jw.setVisible(false);
			jw.setVisible(true);
		}
		
		super.destroy();
	}
	
	private static class WebPageStatusPanel extends JPanel {
		private JProgressBar progressBar = null;
		
		WebPageStatusPanel(JProgressBar progressBar) {
			super(new BorderLayout());
			
			this.progressBar = progressBar;
		}
		
		public void paintComponent(Graphics gl) {
			int width = (int)this.getSize().getWidth();
			int height = 5;
			
			progressBar.setSize(new Dimension(width, height));
			progressBar.setPreferredSize(new Dimension(width, height));
			progressBar.setMinimumSize(new Dimension(width, height));
			progressBar.setMaximumSize(new Dimension(width, height));
		}
	}
}
