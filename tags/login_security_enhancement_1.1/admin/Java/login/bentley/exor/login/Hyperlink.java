/**
 *	PVCS Identifiers :-
 *
 *		PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/Java/login/bentley/exor/login/Hyperlink.java-arc   1.0   Nov 24 2016 11:53:54   Upendra.Hukeri  $
 *		Module Name      : $Workfile:   Hyperlink.java  $
 *		Author			 : $Author:   Upendra.Hukeri  $
 *		Date Into PVCS   : $Date:   Nov 24 2016 11:53:54  $
 *		Date Fetched Out : $Modtime:   Feb 22 2016 07:24:16  $
 *		PVCS Version     : $Revision:   1.0  $
 *
 *	Based on the original source from Idiom - decompile using JAD.
 *	Used to render Hyperlinks on Oracle Forms as Java Beans.
 *
 ****************************************************************************************************
 *	  Copyright (c) 2016 Bentley Systems Incorporated.  All rights reserved.
 ****************************************************************************************************
 *
 */

package bentley.exor.login;

import java.awt.*;
import java.awt.event.*;

import java.io.PrintStream;

import javax.swing.BorderFactory;
import javax.swing.JLabel;

import oracle.ewt.laf.oracle.OracleLookAndFeel;
import oracle.ewt.UIManager;

import oracle.forms.engine.Main;
import oracle.forms.ui.ExtendedFrame;
import oracle.forms.ui.VBean;

public class Hyperlink extends JLabel implements MouseListener {
	boolean m_showVisitedColor;
    boolean m_isClicked;
	boolean m_mouseEntered = false;
    boolean m_showLine;
    boolean m_showBullet;
	
    private String         CLASSNAME;
    private String         m_URL;
    private Color          m_normalColor;
    private Color          m_activeColor;
    private Color          m_visitedColor;
    private ActionListener m_actionListener;
    private MouseListener  m_mouseListener;
    private Font           mFont;
	private Color          m_bulletColor;
    private boolean        m_debug;
	private Main           mFormsMain;
    private Component      Xe;
    private ExtendedFrame  Ef;
    private VBean          vB;
	
    private static boolean m_debugAll;
	private static Color   DEFAULTNORMAL;
    private static Color   DEFAULTACTIVE;
    private static Color   DEFAULTVISITED = Color.decode("#840084");
	
    static {
        DEFAULTNORMAL = Color.BLUE;
        DEFAULTACTIVE = Color.RED;
    }
	
    public Hyperlink() {
        this("Empty Hyperlink");
        CLASSNAME = getClass().getName();
    }
	
    public Hyperlink(String label) {
        this(label, null);
    }
	
    public Hyperlink(String label, String URL) {
        this(label, URL, DEFAULTNORMAL);
    }
	
    public Hyperlink(String label, String URL, Color normalcolor) {
        this(label, URL, normalcolor, DEFAULTVISITED);
    }
	
	public Hyperlink(String label, String URL, Color normalcolor, Color visitedcolor) {
        this(label, URL, normalcolor, visitedcolor, DEFAULTACTIVE);
    }
	
    public Hyperlink(String label, String URL, Color normalcolor, Color visitedcolor, Color activecolor) {
        mFormsMain = null;
        setOLAF();
        super.setBackground(UIManager.getColor("lightintestity"));
        setLabel(label);
        mFont = super.getFont().deriveFont(1);
        super.setFont(new Font("Arial", 1, mFont.getSize()));
        CLASSNAME = getClass().getName();
        m_URL = null;
        m_actionListener = null;
        m_mouseListener = null;
        m_isClicked = false;
        m_debug = false;
        m_showLine = true;
        m_showVisitedColor = true;
        m_showBullet = false;
        setURL(URL);
        m_bulletColor = Color.BLUE;
        setNormalColor(normalcolor);
        setActiveColor(activecolor);
        setVisitedColor(visitedcolor);
        super.addMouseListener(this);
		
        repaint();
    }
	
    private void setOLAF() {
        OracleLookAndFeel olaf = new OracleLookAndFeel();
        UIManager.setLookAndFeel(olaf);
    }
	
    private boolean formDisabled() {
        discover();
        discoverVBean();
		
        return !Ef.isActive();
    }
	
    public void discoverVBean() {
        Xe = this;
        
        while (!Xe.getClass().getName().equals("oracle.forms.ui.VBean")) {
            Xe = Xe.getParent();
        }

        vB = (VBean)Xe;
    }

    public void discover() {
        for(Xe = this; !Xe.getClass().getName().equals("oracle.forms.ui.ExtendedFrame"); Xe = Xe.getParent());
		
        Ef = (ExtendedFrame)Xe;
    }
	
    public void setLabel(String label) {
        String lclValue = new String("");
        
        if ((label != null )&&(!label.equalsIgnoreCase("null"))) {
          lclValue = label;
        }
		
        ExorDebugger.reportDebugInfo("setLabel(): label - " + lclValue);
        m_isClicked = false;
		
        super.setText(lclValue);
		
        if(label.trim().compareTo("") == 0)  {
            m_showBullet = false;
            resizeForNoBullet();
        }
    }
	
    public void setMouseEntered(boolean mouseEntered) {
        m_mouseEntered = mouseEntered;
		
        repaint();
    }
	
    public void showVisitedColor(boolean showIt) {
        m_showVisitedColor = showIt;
        repaint();
    }
	
    public void showLine(boolean showIt) {
        m_showLine = showIt;
        repaint();
    }
	
    public void showBullet(boolean showIt) {
        m_showBullet = showIt;
        if(m_showBullet)
            resizeForBullet();
        repaint();
    }
	
    public String getLabel() {
        ExorDebugger.reportDebugInfo("getLabel(): called...");
        m_isClicked = false;
        return super.getText();
    }
	
    public void setURL(String URL) {        
        if (URL != null) {
           ExorDebugger.reportDebugInfo("setURL(): URL - " + URL);
        }
		
        m_isClicked = false;
        
        if ( (URL != null) && (URL.equalsIgnoreCase("null"))) {
          m_URL = null;
        } else {
           m_URL = URL;        
        }
    }
	
    public String getURL() {
        ExorDebugger.reportDebugInfo("getURL(): called...");
		
        return m_URL;
    }
	
    public String getImplementationClass(){
        ExorDebugger.reportDebugInfo("getImplementationClass(): called...");
		
        return getClass().getName();
    }
	
    public void setBackgroundColor(Color backColor) {
        ExorDebugger.reportDebugInfo("setBackgroundColor(): backColor - " + backColor.toString());
        setBackground(backColor);
		
        repaint();
    }
	
    public void setVisitedColor(Color newVisitedColor) {
        ExorDebugger.reportDebugInfo("setVisitedColor(): newVisitedColor - " + newVisitedColor.toString());
        m_visitedColor = newVisitedColor;
		
        repaint();
    }
	
    public void setBulletColor(Color newBulletColor) {
        ExorDebugger.reportDebugInfo("setBulletColor(): newBulletColor - " + newBulletColor.toString());
        m_bulletColor = newBulletColor;
		
        repaint();
    }
	
    public void setNormalColor(Color newNormalColor) {
        ExorDebugger.reportDebugInfo("setNormalColor(): newNormalColor - " + newNormalColor.toString());
        m_normalColor = newNormalColor;
        setForeground(m_normalColor);
		
        repaint();
    }
	
    public void setActiveColor(Color newActiveColor) {
        ExorDebugger.reportDebugInfo("setActiveColor(): newActiveColor - " + newActiveColor.toString());
        m_activeColor = newActiveColor;
		
        repaint();
    }
	
    private void resizeForBullet() {
		setBorder(BorderFactory.createEmptyBorder(0, 20, 0, 0));
    }
	
    private void resizeForNoBullet() {
		setBorder(BorderFactory.createEmptyBorder(0, 0, 0, 0));
    }
	
    private void drawBullet(Graphics g) {
        int xOffset = 6;
        int yOffset = (this.getPreferredSize().height - 16)/2;
		
        Color mCol = g.getColor();
        g.setColor(m_bulletColor);
        Polygon p = new Polygon();
        p.addPoint(0 + xOffset, 0 + yOffset);
        p.addPoint(8 + xOffset, 8 + yOffset);
        p.addPoint(0 + xOffset, 16 + yOffset);
        p.addPoint(0 + xOffset, 8 + yOffset);
        g.fillPolygon(p);
        g.setColor(mCol);
    }
	
    public void paintComponent(Graphics g) {
		int bulletOffset = 0;
		
        super.paintComponent(g);
		
        if(m_showBullet) {
			bulletOffset = 20;
            drawBullet(g);
		}
		
        if(m_URL == null) {
            return;
        }
		
		FontMetrics metrics = getFontMetrics(getFont());
		int strWidth = metrics.stringWidth(getText());
		int yoffset  = metrics.getHeight();
		
        if(m_showLine && m_mouseEntered) {
            g.drawLine(bulletOffset, yoffset, bulletOffset + strWidth, yoffset);
		}
    }
	
	public Dimension getPreferredSize() {
		FontMetrics metrics = getFontMetrics(getFont());
		Dimension d = new Dimension(metrics.stringWidth(getText()) + 25, metrics.getHeight() + 5);
		
		return d;
	}
	
	public Dimension getMaximumSize() {
		FontMetrics metrics = getFontMetrics(getFont());
		Dimension d = new Dimension(metrics.stringWidth(getText()) + 25, metrics.getHeight() + 5);
		
		return d;
	}
	
	public Dimension getMinimumSize() {
		FontMetrics metrics = getFontMetrics(getFont());
		Dimension d = new Dimension(metrics.stringWidth(getText()) + 25, metrics.getHeight() + 5);
		
		return d;
	}
	
	public Dimension getSize() {
		FontMetrics metrics = getFontMetrics(getFont());
		Dimension d = new Dimension(metrics.stringWidth(getText()) + 25, metrics.getHeight() + 5);
		
		return d;
	}
	
    public synchronized void addActionListener(ActionListener listener) {
        m_actionListener = AWTEventMulticaster.add(m_actionListener, listener);
    }
	
    public synchronized void removeActionListener(ActionListener listener) {
        m_actionListener = AWTEventMulticaster.remove(m_actionListener, listener);
    }
	
    public synchronized void addMouseListener(MouseListener listener) {
        m_mouseListener = AWTEventMulticaster.add(m_mouseListener, listener);
    }
	
    public synchronized void removeActionListener(MouseListener listener) {
        m_mouseListener = AWTEventMulticaster.remove(m_mouseListener, listener);
    }
	
    public void mouseClicked(MouseEvent e) {
        if(formDisabled()) {
            return;
		}
		
        m_isClicked = true;
		
        if(m_showVisitedColor) {
            setForeground(m_visitedColor);
        } else {
            setForeground(m_normalColor);
            m_isClicked = false;
        }
        
		if(m_actionListener != null) {
            String actionString;
			
            if(m_URL == null) {
                actionString = "LINK CLICKED";
            } else {
                actionString = m_URL;
			}
			
            ActionEvent actionEvent = new ActionEvent(this, 1001, actionString);
            m_actionListener.actionPerformed(actionEvent);
        }
		
        repaint();
    }
	
    public void mouseEntered(MouseEvent e) {
        if(formDisabled()) {
			return;
		}
		
	    m_mouseEntered = true;
		
        setCursor(new Cursor(12));
		
        if(!m_isClicked) {
            if(m_URL != null && m_URL.trim().compareTo("") != 0) {
                setForeground(m_activeColor);
            }
		}
		
		repaint();
			
        if(m_mouseListener != null) {
            m_mouseListener.mouseEntered(e);
		}
    }
	
    public void mouseExited(MouseEvent e)
    {
        if(formDisabled()) {
            return;
		}
		
	    m_mouseEntered = false;
		
        setCursor(new Cursor(0));
		
        if(!m_isClicked) {
            setForeground(m_normalColor);
        }
		
		repaint();
		
        if(m_mouseListener != null) {
            m_mouseListener.mouseExited(e);
		}
    }
	
    public void mousePressed(MouseEvent mouseevent1) {
    }
	
    public void mouseReleased(MouseEvent mouseevent1) {
    }
	
    private void log(String msg) {
        if(m_debug || m_debugAll) {
            System.out.println(CLASSNAME + ": " + msg);
		}
    }
}
