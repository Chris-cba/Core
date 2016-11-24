/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/login/ImagePanel.java-arc   1.0   Nov 24 2016 11:53:54   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   ImagePanel.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   Nov 24 2016 11:53:54  $
 *		Date Fetched Out : $Modtime:   Feb 24 2016 04:41:06  $
 *		PVCS Version     : $Revision:   1.0  $
 *
 *	This class is used to render high quality images on Oracle Forms either from within the Jar 
 *	or from Application Server.
 *
 ****************************************************************************************************
 *	  Copyright (c) 2016 Bentley Systems Incorporated.  All rights reserved.
 ****************************************************************************************************
 *
 */

package bentley.exor.login;

import java.awt.*;
import java.awt.image.BufferedImage;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import java.net.URL;

import java.util.StringTokenizer;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.ImageTranscoder;

import javax.swing.*;

public class ImagePanel extends JPanel {
	private Image     img          = null;
	
	private double    imgWidth     = 0;
	private double    imgHeight    = 0;
	
	private double    beanWidth    = 0;
	private double    beanHeight   = 0;
	
	private double    vertOffset   = 0;
	private double    horOffset    = 0;
	
	private Dimension imgDim       = null;
	
	private boolean   fromAppServ  = false;
	
	private String    imageString  = null;
	
	private Color 	  bgColor      = Color.WHITE;
	private String 	  toolTipText  = null;
	private int       dismissDelay = 3000;
	
	public ImagePanel() {
		super();
		this.setOpaque(false);
	}
	
	public void setImageSource(String imageSource) {
		if(imageSource.equalsIgnoreCase("AppServer")) {
			fromAppServ = true;
		} else {
			fromAppServ = false;
		}
	}
	
	public void appendImageStr(String imgStr) {
		if((imgStr != null) && !(imgStr.equalsIgnoreCase("null"))) {
			if(imageString == null) {
				imageString = imgStr;
			} else {
				imageString = imageString + imgStr;
			}
		}
	}
	
	public void setImageStr(String imageStr) throws Exception {
		if(!fromAppServ) {
			ExorDebugger.reportDebugInfo("setImageStr(): Loading Image from Jar...");
			
			this.img = loadImage(imageStr);
		}
	}
	
	public void setImageImg(Image img) throws Exception {
		ExorDebugger.reportDebugInfo("setImageImg(): Loading Image from an Image object...");
		
		this.img = (Image)img;
	}
	
	public void setImage() throws Exception {
		ExorDebugger.reportDebugInfo("setImage(): Loading Image from App Server...");
		
		byte imageData[] = ImageEncoderAndDecoder.decodeImage(imageString);
		this.img = ImageIO.read(new ByteArrayInputStream(imageData));
	}
	
	protected BufferedImage loadImage(String imageName) {
		URL imageURL = null;
		BufferedImage bImg = null ;
		
		imageURL = getClass().getResource("images/" + imageName);
		
		if (imageURL != null) {
			try {
				bImg = ImageIO.read(imageURL);
			} catch (Exception e) {
				e.printStackTrace();
			}
        }
		
		return bImg;
	}
	
	protected void setDimensions() {
		imgWidth   = img.getWidth(null);
		imgHeight  = img.getHeight(null);
		
		beanWidth  = this.getParent().getWidth();
		beanHeight = this.getParent().getHeight();
		
		imgDim     = new Dimension((int)beanWidth, (int)beanHeight);
	}
	
	protected void rescaleImage() {
		while(!((beanWidth >= imgWidth) && (beanHeight >= imgHeight))) {
			if(beanWidth < imgWidth) {
				imgHeight = imgHeight * (beanWidth/imgWidth);
				imgWidth  = beanWidth;
			} 
			
			if(beanHeight < imgHeight) {
				imgWidth  = imgWidth * (beanHeight/imgHeight);
				imgHeight = beanHeight;
			}
		}
		
		horOffset  = (beanWidth - imgWidth)/2;
		vertOffset = (beanHeight - imgHeight)/2;
	}
	
	public void paintComponent(Graphics g) {
		super.paintComponent(g);
		
		setDimensions();
		rescaleImage();
		
		g.drawImage(img, (int)horOffset, (int)vertOffset, (int)imgWidth, (int)imgHeight, null);
	}
	
	public Dimension getPreferredSize() {
		return imgDim;
	}
	
	public Dimension getMaximumSize() {
		return imgDim;
	}
	
	public Dimension getMinimumSize() {
		return imgDim;
	}
	
	public Dimension getSize() {
		return imgDim;
	}
	
	public JToolTip createToolTip() {		
		JToolTip toolTip = super.createToolTip();
		toolTip.setBackground(this.bgColor);
		toolTip.setBorder(BorderFactory.createLineBorder(Color.black));
		
		return toolTip;
	}
	
	public void setToolTipTextBGColor(Color bgColor) {
		if(bgColor != null) {
			this.bgColor = bgColor;
		} else {
			ExorDebugger.reportDebugInfo("setToolTipTextBGColor(): bgColor passed is null");
		}
	}
	
	public void setDismissDelay(int milliseconds) {
		this.dismissDelay = milliseconds;
	}
	
	public void setInfoText(String text) {
		ToolTipManager.sharedInstance().setDismissDelay(this.dismissDelay);
		
		this.toolTipText = text;
		this.setToolTipText(text);
	}
}
