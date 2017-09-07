/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/pwdenc/ClientMachineInfo.java-arc   1.1   Sep 07 2017 14:39:46   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   ClientMachineInfo.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   Sep 07 2017 14:39:46  $
 *		Date Fetched Out : $Modtime:   Sep 07 2017 11:39:10  $
 *		PVCS Version     : $Revision:   1.1  $
 *
 *	
 *
 ****************************************************************************************************
 *	  Copyright (c) 2017 Bentley Systems Incorporated.  All rights reserved.
 ****************************************************************************************************
 *
 */

package bentley.exor.pwdenc;

import bentley.exor.ExorDebugger;

import java.util.Locale;

import javax.swing.SwingUtilities;

import oracle.forms.handler.IHandler;
import oracle.forms.properties.ID;
import oracle.forms.ui.CustomEvent;
import oracle.forms.ui.CustomListener;
import oracle.forms.ui.VBean;

public class ClientMachineInfo extends VBean {
	private transient IHandler handler;
	private transient ID GET_CLIENT_MACHINE_DETAILS = ID.registerProperty("GET_CLIENT_MACHINE_DETAILS");
	
	public void init(IHandler handler) {
		this.handler = handler;
        super.init(handler);
    }
	
	public boolean setProperty(ID paramID, Object valueObj) {
		if(paramID == GET_CLIENT_MACHINE_DETAILS) {
			getClientMachineDetails();
		}
		
		return super.setProperty(paramID, valueObj);
	}
		
	protected void getClientMachineDetails() {
		String clientHostName = MachineInfo.getMachineName();
		clientHostName = clientHostName.substring(0, clientHostName.indexOf(':')).toUpperCase(Locale.ENGLISH);
		ExorDebugger.reportDebugInfo("getClientMachineDetails() : client machine - host name: " + clientHostName);
		
		String clientMachineUserName = MachineInfo.getMachineUserName();
		ExorDebugger.reportDebugInfo("getClientMachineDetails() : client machine - user name: " + clientMachineUserName);
		
		dispatchCustomEvent("ClientMachineDetails", clientHostName + ':' + clientMachineUserName);
	}
	
	protected void dispatchCustomEvent(String eventType, String name) {
		try {
			ExorDebugger.reportDebugInfo("dispatchCustomEvent() : Dispatching custom item event...");
			
			ID NAME = ID.registerProperty("NAME");
			
			final CustomEvent ce = new CustomEvent(handler, eventType);
			ce.setProperty(NAME, name);
			
			SwingUtilities.invokeLater(new Runnable() {
				@Override
				public void run() {
					if (SwingUtilities.isEventDispatchThread()) {
						ClientMachineInfo.this.dispatchCustomEvent(ce);
					}
				}
			});
			
			ExorDebugger.reportDebugInfo("dispatchCustomEvent() : Dispatched custom item event successfully");
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}
