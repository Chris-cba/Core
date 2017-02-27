/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/pwdenc/ClientMachineInfo.java-arc   1.0   Feb 27 2017 07:05:52   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   ClientMachineInfo.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   Feb 27 2017 07:05:52  $
 *		Date Fetched Out : $Modtime:   Feb 17 2017 06:12:30  $
 *		PVCS Version     : $Revision:   1.0  $
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

import javax.swing.SwingUtilities;

import oracle.forms.handler.IHandler;
import oracle.forms.properties.ID;
import oracle.forms.ui.CustomEvent;
import oracle.forms.ui.CustomListener;
import oracle.forms.ui.VBean;

public class ClientMachineInfo extends VBean {
	private IHandler handler;
	private ID GET_HOST_NAME = ID.registerProperty("GET_HOST_NAME");
	private ID GET_USER_NAME = ID.registerProperty("GET_USER_NAME");
	
	public void init(IHandler handler) {
		this.handler = handler;
        super.init(handler);
    }
	
	public boolean setProperty(ID paramID, Object valueObj) {
		if(paramID == GET_HOST_NAME) {
			getClientMachineName();
		} else if(paramID == GET_USER_NAME) {
			getClientMachineUserName();
		}
		
		return super.setProperty(paramID, valueObj);
	}
		
	protected void getClientMachineName() {
		String clientHostName = MachineInfo.getMachineName();
		
		ExorDebugger.reportDebugInfo("getClientMachineName() : client host name: " + clientHostName);
		
		dispatchCustomEvent("HostNameEvent", clientHostName);
	}
	
	protected void getClientMachineUserName() {
		String clientMachineUserName = MachineInfo.getMachineUserName();
		
		ExorDebugger.reportDebugInfo("getClientMachineUserName() : client machine user name: " + clientMachineUserName);
		
		dispatchCustomEvent("UserNameEvent", clientMachineUserName);
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
