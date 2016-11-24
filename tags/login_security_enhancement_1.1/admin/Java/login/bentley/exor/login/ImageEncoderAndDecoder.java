/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/login/ImageEncoderAndDecoder.java-arc   1.0   Nov 24 2016 11:53:54   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   ImageEncoderAndDecoder.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   Nov 24 2016 11:53:54  $
 *		Date Fetched Out : $Modtime:   Feb 22 2016 07:23:56  $
 *		PVCS Version     : $Revision:   1.0  $
 *
 *	This class is used to enocde byte array to String and decode String to byte array.
 *
 ****************************************************************************************************
 *	  Copyright (c) 2016 Bentley Systems Incorporated.  All rights reserved.
 ****************************************************************************************************
 *
 */

package bentley.exor.login;

import javax.xml.bind.DatatypeConverter;

public class ImageEncoderAndDecoder {
	/**
     * Encodes the byte array into base64 string
     *
     * @param imageByteArray - byte array
     * @return String a {@link java.lang.String}
     */
    public static String encodeImage(byte[] imageByteArray) {
        return DatatypeConverter.printBase64Binary(imageByteArray);
    }
 
    /**
     * Decodes the base64 string into byte array
     *
     * @param imageDataString - a {@link java.lang.String}
     * @return byte array
     */
    public static byte[] decodeImage(String imageDataString) {
    	
        return DatatypeConverter.parseBase64Binary(imageDataString);
    }
}
