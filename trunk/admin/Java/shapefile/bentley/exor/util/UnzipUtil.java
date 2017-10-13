/**
 *    PVCS Identifiers :-
 *
 *       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/Java/shapefile/bentley/exor/util/UnzipUtil.java-arc   1.0   Oct 13 2017 10:14:56   Upendra.Hukeri  $
 *       Module Name      : $Workfile:   UnzipUtil.java  $
 *       Date into SCCS   : $Date:   Oct 13 2017 10:14:56  $
 *       Date fetched Out : $Modtime:   Oct 13 2017 10:13:16  $
 *       SCCS Version     : $Revision:   1.0  $
 *       Based on 
 *
 *
 *
 *    Author : Upendra Hukeri
 *    UnzipUtil.java
 *
 ****************************************************************************************************
 *	  Copyright (c) 2017 Bentley Systems Incorporated.  All rights reserved.
 ****************************************************************************************************
 *
 */

package bentley.exor.util;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.IOException;

import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

/**
 * This utility extracts files and directories of a standard zip file to a destination directory.
 */

public class UnzipUtil {
    private static final int BUFFER_SIZE = 4096;
	
	public static String unzip(String zipFilePath, String destDirStr) 
	throws IOException {
		FileInputStream fileInputStream = new FileInputStream(zipFilePath);
		
		return unzip(fileInputStream, destDirStr);
	}
	
    public static String unzip(InputStream zipFileInputStream, String destDirStr) 
	throws IOException {
		String 		   destDirectoryStr	= null;
		ZipInputStream zipInputStream	= null;
		ZipEntry 	   entry			= null;
		
		try {
			destDirectoryStr = destDirStr.replace('\\', '/');
			destDirectoryStr = destDirectoryStr.endsWith("/") ? destDirectoryStr : destDirectoryStr + '/';
			
			File destDirectory = new File(destDirectoryStr);
			
			if (!destDirectory.exists()) {
				destDirectory.mkdir();
			}
			
			zipInputStream = new ZipInputStream(zipFileInputStream);
			entry 		   = zipInputStream.getNextEntry();
			
			while (entry != null) {
				String entryFilePath = destDirectoryStr + entry.getName();
				
				if(entry.isDirectory()) {
					File entryFile = new File(entryFilePath);
					
					if(!entryFile.exists()) {
						boolean created = entryFile.mkdir();
						
						if(!created) {
							return "failed to create destination directory for extracting the zip - " + entryFilePath;
						}
					}
				} else {
					extractFile(zipInputStream, entryFilePath);
				}
				
				zipInputStream.closeEntry();
				entry = zipInputStream.getNextEntry();
			}
			
			return "success";
		} finally {
			try {
				if(zipInputStream != null) {
					zipInputStream.close();
				}
			} catch(IOException ioe) {
			}
		}
    }
	
	private static void extractFile(ZipInputStream zipInputStream, String filePath) 
	throws IOException {
        BufferedOutputStream bos = null;
		byte[] bytesIn = new byte[BUFFER_SIZE];
        int read = 0;
		
		try {
			bos = new BufferedOutputStream(new FileOutputStream(new File(filePath)));
			
			while ((read = zipInputStream.read(bytesIn)) != -1) {
				bos.write(bytesIn, 0, read);
			}
		} finally {
			try {
				if(bos != null) {
					bos.close();
				}
			} catch(IOException ioe) {
			}
		}
    }
}