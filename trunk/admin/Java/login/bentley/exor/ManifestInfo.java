/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/ManifestInfo.java-arc   1.1   May 30 2017 13:37:30   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   ManifestInfo.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   May 30 2017 13:37:30  $
 *		Date Fetched Out : $Modtime:   May 30 2017 13:36:06  $
 *		PVCS Version     : $Revision:   1.1  $
 *
 *	This class is used to get PVCS version information about the Jar.
 *
 ****************************************************************************************************
 *	  Copyright (c) 2017 Bentley Systems Incorporated.  All rights reserved.
 ****************************************************************************************************
 *
 */

package bentley.exor;

import java.io.IOException;

import java.lang.Package;

import java.net.URL;
import java.net.URLClassLoader;

import java.util.jar.Attributes;
import java.util.jar.Manifest;

public class ManifestInfo extends java.lang.ClassLoader {
	private Manifest manifest;
	private URL manifestURL;
	private String jarPath;
	
	public static void main(String args[]) {
		try {
			ManifestInfo mi = null;
			
			if(args != null && args.length > 0) {
				mi = new ManifestInfo(args[0]);
				ExorDebugger.reportDebugInfo("Jar version : " + mi.getManifestMainAttibuteVal("Application-Name"));
			} else {
				mi = new ManifestInfo();
				
				ExorDebugger.reportDebugInfo("Applet Information - ");
				ExorDebugger.reportDebugInfo("  Application Name       : ", mi.getManifestMainAttibuteVal("Application-Name"));
				ExorDebugger.reportDebugInfo("  Package Name           : ", mi.getName());
				ExorDebugger.reportDebugInfo("  Specification Title    : ", mi.getSpecificationTitle());
				ExorDebugger.reportDebugInfo("  Specification Vendor   : ", mi.getSpecificationVendor());
				ExorDebugger.reportDebugInfo("  Specification Version  : ", mi.getSpecificationVersion(), " (Applet version)");
				ExorDebugger.reportDebugInfo("  Implementation Title   : ", mi.getImplementationTitle());
				ExorDebugger.reportDebugInfo("  Implementation Vendor  : ", mi.getImplementationVendor());
				ExorDebugger.reportDebugInfo("  Implementation Version : ", mi.getImplementationVersion(), " (Product version)");
			}
		} catch (Exception mainExp) {
			ExorDebugger.reportDebugInfo("Exception mainExp caught...\n");
			mainExp.printStackTrace();
		}
	}
	
	public ManifestInfo() {
		try {
			jarPath = this.getClass().getProtectionDomain().getCodeSource().getLocation().toExternalForm();
			initialize();
		} catch (Exception mainExp) {
			ExorDebugger.reportDebugInfo("Exception mainExp caught...\n");
			mainExp.printStackTrace();
		}
	}
	
	public ManifestInfo(String jarName) {
		String classPath = this.getClass().getProtectionDomain().getCodeSource().getLocation().toExternalForm();
		jarPath = classPath.substring(0, classPath.lastIndexOf('/') + 1) + jarName;
		initialize();
	}
	
	protected final void initialize() {
		try {
			manifestURL   = new URL("jar:" + jarPath + "!/META-INF/MANIFEST.MF");
			this.manifest = new Manifest(manifestURL.openStream());
		} catch (IOException initializeExp) {
			ExorDebugger.reportDebugInfo("Exception initializeExp caught...\n");
			initializeExp.printStackTrace();
		}
	}
	
	public String getName() {
		return this.getClass().getPackage().getName();
	}
	
	public String getSpecificationTitle() {
		return this.getClass().getPackage().getSpecificationTitle();
	}
	
	public String getSpecificationVendor() {
		return this.getClass().getPackage().getSpecificationVendor();
	}
	
	public String getSpecificationVersion() {
		return this.getClass().getPackage().getSpecificationVersion();
	}
	
	public String getImplementationTitle() {
		return this.getClass().getPackage().getImplementationTitle();
	}
	
	public String getImplementationVendor() {
		return this.getClass().getPackage().getImplementationVendor();
	}
	
	public String getImplementationVersion() {
		return this.getClass().getPackage().getImplementationVersion();
	}
	
	private String getManifestMainAttibuteVal(String attributeName) {
		try {
			Attributes mainEntries = manifest.getMainAttributes();
			
			return mainEntries.getValue(attributeName);
		} catch (Exception getManifestMainAttibuteValExp) {
			ExorDebugger.reportDebugInfo("Exception getManifestMainAttibuteValExp caught...\n");
			getManifestMainAttibuteValExp.printStackTrace();
			
			return null;
		}
	}
}
