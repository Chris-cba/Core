/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/login/ErrorMessagePane.java-arc   1.0   Feb 27 2017 07:03:56   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   ErrorMessagePane.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   Feb 27 2017 07:03:56  $
 *		Date Fetched Out : $Modtime:   Feb 17 2017 12:06:14  $
 *		PVCS Version     : $Revision:   1.0  $
 *
 *	
 *
 ****************************************************************************************************
 *	  Copyright (c) 2017 Bentley Systems Incorporated.  All rights reserved.
 ****************************************************************************************************
 *
 */

package bentley.exor.login;

import bentley.exor.ExorDebugger;

import java.awt.Container;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;

import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.SwingUtilities;

import oracle.ewt.swing.JBufferedFrame;

import oracle.forms.handler.IHandler;
import oracle.forms.properties.ID;
import oracle.forms.ui.CustomEvent;
import oracle.forms.ui.CustomListener;
import oracle.forms.ui.VBean;

public class ErrorMessagePane extends VBean {
	private IHandler handler;
	
	private String errorMessage = null;
	private String windowName 	= null;
	
	private ID SET_MESSAGE	 	= ID.registerProperty("SET_MESSAGE");
	private ID SET_WIN_NAME	 	= ID.registerProperty("SET_WIN_NAME");
	private ID SHOW_MESSAGE	 	= ID.registerProperty("SHOW_MESSAGE");
	
	public void init(IHandler handler) {
		this.handler = handler;
        super.init(handler);
    }
	
	public boolean setProperty(ID paramID, Object valueObj) {
		if(paramID == SET_MESSAGE) {
			errorMessage = valueObj.toString();
		} else if(paramID == SET_WIN_NAME) {
			windowName = valueObj.toString();
		} else if(paramID == SHOW_MESSAGE) {
			showMessage();
		}
		
		return super.setProperty(paramID, valueObj);
	}
	
	public void showMessage() {
		JOptionPane jop = new JOptionPane();
		
		jop.getRootFrame().addWindowListener(new WindowListener(){
			public void windowActivated(WindowEvent e) {
			}

			public void windowClosed(WindowEvent e) {
				ErrorMessagePane.this.closeWindow();
			}

			public void windowClosing(WindowEvent e) {
			}

			public void windowDeactivated(WindowEvent e) {
			}

			public void windowDeiconified(WindowEvent e) {
			}

			public void windowIconified(WindowEvent e) {
			}

			public void windowOpened(WindowEvent e) {
			}
		});
		
		int input = jop.showOptionDialog(null, errorMessage, windowName, JOptionPane.OK_CANCEL_OPTION, JOptionPane.ERROR_MESSAGE, null, null, null);
		
		if(input == JOptionPane.OK_OPTION || input == JOptionPane.CANCEL_OPTION) {
			this.closeWindow();
		}
	}
	
	protected void dispatchCustomEvent(String eventType, String doExit) {
		try {
			ExorDebugger.reportDebugInfo("dispatchCustomEvent() : Dispatching custom item event...");
			
			ID EXIT_FORM = ID.registerProperty("EXIT_FORM");
			
			final CustomEvent ce = new CustomEvent(handler, eventType);
			ce.setProperty(EXIT_FORM, doExit);
			
			SwingUtilities.invokeLater(new Runnable() {
				@Override
				public void run() {
					if (SwingUtilities.isEventDispatchThread()) {
						ErrorMessagePane.this.dispatchCustomEvent(ce);
					}
				}
			});
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void closeWindow() {
		Container rootContainer = null;
		Container container 	= this.getParent();
		
		while (true) {
			container = container.getParent();
			
			if(container != null) {
				rootContainer = container;
			} else {
				break;
			}
		}
		
		if(rootContainer != null && rootContainer instanceof JBufferedFrame) {
			ExorDebugger.reportDebugInfo("Closing Forms window...");
			
			((JBufferedFrame)rootContainer).dispose();
		}
	}
}
