set define off
CREATE OR REPLACE AND COMPILE JAVA SOURCE NAMED "com.exor.xml.UpdateXMLAttrib" AS
//
/////////////////////////////////////////////////////////////////////////////
//
//   SCCS Identifiers :-
//
//       sccsid           : @(#)UpdateXMLAttrib.sql	1.1 02/15/06
//       Module Name      : UpdateXMLAttrib.sql
//       Date into SCCS   : 06/02/15 16:51:27
//       Date fetched Out : 07/06/13 17:02:07
//       SCCS Version     : 1.1
//
//
//   Author : Francis Fish
//
//   class UpdateXMLAttrib
//
/////////////////////////////////////////////////////////////////////////////
//	Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
/////////////////////////////////////////////////////////////////////////////
package com.exor.xml;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;

import oracle.xml.parser.v2.DOMParser;
import oracle.xml.parser.v2.XMLDocument;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class UpdateXMLAttrib 
{
  private static String XMLData = "" ;
  private static boolean wholeTag = false ;
  // This uses get by tag name - warning - it will update the first 
  // one it finds with the appropriate tag name and attribute it finds in the 
  // document. This may not be what you want.
  // This is very restricted and has only been made to work with the 
  // simple example needed for the XML map
  // Restrictions:
  // It will only work for nodes in the first level, e.g.
  // <fred>
  //   <bill>
  //      <jim x="asdf" />
  //   </bill>
  //  </fred>
  // It will NOT update the attributes of jim. The code will need to be extended
  // in order to walk down to the child nodes.
  public static String updateAttrib4Map
  ( String xml          
  , String searchNode
  , String searchAttribName
  , String searchAttribValue
  , String attribName 
  , String newValue    
  ) throws Exception
  {
      DOMParser p = new DOMParser();
      p.parse(new StringReader(xml));
      Document doc = p.getDocument();
      Node n = doc.getDocumentElement().getFirstChild();
	  
      while (n!=null)
      {
        if ( n.getNodeName().equals(searchNode)) 
        {
          if ( n.hasAttributes() )
          {
            Element theNode = (Element)n ;
            String searchElement = theNode.getAttribute(searchAttribName) ;
            String changeElement ;
            if ( searchElement.equals(searchAttribValue))
            {
                if ( newValue==null)
                {
                  theNode.removeAttribute(attribName);
                }
                else
                {
                  changeElement = theNode.getAttribute(attribName) ;
        
                  theNode.setAttribute(attribName, newValue);
                }
                break ;
            }
          }
        }
        n = n.getNextSibling();
      }
      
      return dumpDocument(doc);
   }
   // send the whole doc out to a string
   private static String dumpDocument( Document doc ) throws IOException
   {

    XMLDocument xmldoc = (XMLDocument)doc ;
  
    StringWriter sw = new StringWriter() ;
    PrintWriter pw = new PrintWriter(sw);
    
    xmldoc.print(pw);
    
    return sw.toString() ; 
      
   }
   // Helper for printNode
   private static void appendOut( String val )
   {
     XMLData += val ;
   }
   // This will dump out a given node, mainly used for debugging
   // superseded by dumpDocument for the whole document
   private static synchronized void printNode(Node node, String indent)  
   {
      
      switch (node.getNodeType()) {

          case Node.DOCUMENT_NODE:
              XMLData = "" ;
              appendOut("<?xml version=\"1.0\" standalone=\"yes\"?>\n");
              // recurse on each child
              NodeList nodes = node.getChildNodes();
              if (nodes != null) {
                  for (int i=0; i<nodes.getLength(); i++) {
                      printNode(nodes.item(i), "");
                  }
              }
              // break; not needed because of the return
              
          case Node.ELEMENT_NODE:
              String name = node.getNodeName();
              appendOut(indent + "<" + name);
              NamedNodeMap attributes = node.getAttributes();
              for (int i=0; i<attributes.getLength(); i++) {
                  Node current = attributes.item(i);
                  appendOut(
                      " " + current.getNodeName() +
                      "=\"" + current.getNodeValue() +
                      "\"");
              }
              
              // recurse on each child
              NodeList children = node.getChildNodes();
              if ((children != null && children.getLength() > 0 )|| wholeTag) {
                  
                  appendOut(">");
                  for (int i=0; i<children.getLength(); i++) {
                      printNode(children.item(i), indent + "  ");
                  }
                  
                  appendOut("</" + name + ">\n");
              }
              else
              {
                  appendOut("/>\n");
              }
              
              break;

          case Node.TEXT_NODE:
              appendOut(node.getNodeValue());
              break;
      }
    }
  
  // Helper for printDoc, if set then it won't use <tag /> on empty nodes
  public static void setWholeTag(boolean _wholeTag)
  {
    wholeTag = _wholeTag;
  }

  // Accessor to test value of wholeTag member
  public static boolean isWholeTag()
  {
    return wholeTag;
  }
  // Lots and lots of test code
   public static void main( String[] args )
   {
     try
     {
      /*
       System.out.println(updateAttrib4Map("<?xml version=\"1.0\" standalone=\"yes\"?>" +
  "<map_definition>" +
  "  <theme name=\"ACCIDENTS\" />" +
  "  <theme name=\"AIRPORT\" min_scale=\"5000.00\" max_scale=\"2000.00\" />" +
  "  <theme name=\"AIRPORT TARMAC\" min_scale=\"1000.00\" max_scale=\"500.00\" />" +
  "</map_definition>", "theme", "name", "ACCIDENTS", "max_scale", "300" ));

       setWholeTag(true) ;

       System.out.println(updateValue4Map(
"<?xml version=\"1.0\" standalone=\"yes\"?>"+
"<styling_rules >"+
"  <rule column=\"PRIORITY_CODE\" >"+
"    <features style=\"IAMS:V.ENQUIRY\"> </features>"+
"    <label column=\"DOC_ID\" style=\"IAMS:T.ROAD NAME\"> 1 </label>"+
"  </rule>"+
"</styling_rules>", "label", "column", "DOC_ID", "2" ) );
      */
      String xPath ;
      String theXML ;

      theXML = 
"<?xml version=\"1.0\" standalone=\"yes\"?>" +
"<styling_rules >" +
"  <rule column=\"NAME\" >" +
"    <features style=\"IAMS:C.EXOR.ALICEBLUE\"> NAME='BELCONNEN' </features>" +
"    <label column=\"NAME\" style=\"IAMS:T.STREET NAME\">1</label>" +
"  </rule>" +
"  <rule column=\"NAME\" >" +
"    <features style=\"IAMS:C.EXOR.ANTIQUEWHITE\"> NAME='BOOTH' </features>" +
"    <label column=\"NAME\" style=\"IAMS:T.STREET NAME\">1</label>" +
"  </rule>" +
"  <rule column=\"NAME\" >" +
"    <features style=\"IAMS:C.EXOR.AQUA\"> NAME='CANBERRA CENTRAL' </features>" +
"    <label column=\"NAME\" style=\"IAMS:T.STREET NAME\">1</label>" +
"  </rule>" +
"  <rule column=\"NAME\" >" +
"    <features style=\"IAMS:C.EXOR.AQUAMARINE\"> NAME='COREE' </features>" +
"    <label column=\"NAME\" style=\"IAMS:T.STREET NAME\">1</label>" +
"  </rule>" +
"  <rule column=\"NAME\" >" +
"    <features style=\"IAMS:C.EXOR.AZURE\"> NAME='COTTER RIVER' </features>" +
"    <label column=\"NAME\" style=\"IAMS:T.STREET NAME\">1</label>" +
"  </rule>" +
"  <rule column=\"NAME\" >" +
"    <features style=\"IAMS:C.EXOR.BEIGE\"> NAME='GUNGAHLIN' </features>" +
"    <label column=\"NAME\" style=\"IAMS:T.STREET NAME\">1</label>" +
"  </rule>" +
"  <rule column=\"NAME\" >" +
"    <features style=\"IAMS:C.EXOR.BISQUE\"> NAME='HALL' </features>" +
"    <label column=\"NAME\" style=\"IAMS:T.STREET NAME\">1</label>" +
"  </rule>" +
"  <rule column=\"NAME\" >" +
"    <features style=\"IAMS:C.EXOR.BLACK\"> NAME='JERRABOMBERRA' </features>" +
"    <label column=\"NAME\" style=\"IAMS:T.STREET NAME\">1</label>" +
"  </rule>" +
"  <rule column=\"NAME\" >" +
"    <features style=\"IAMS:C.EXOR.BLANCHEDALMOND\"> NAME='KOWEN' </features>" +
"    <label column=\"NAME\" style=\"IAMS:T.STREET NAME\">1</label>" +
"  </rule>" +
"  <rule column=\"NAME\" >" +
"    <features style=\"IAMS:C.EXOR.BLUE\"> NAME='MAJURA' </features>" +
"    <label column=\"NAME\" style=\"IAMS:T.STREET NAME\">1</label>" +
"  </rule>" +
"  <rule column=\"NAME\" >" +
"    <features style=\"IAMS:C.EXOR.BLUEVIOLET\"> NAME='MOUNT CLEAR' </features>" +
"    <label column=\"NAME\" style=\"IAMS:T.STREET NAME\">1</label>" +
"  </rule>" +
"  <rule column=\"NAME\" >" +
"    <features style=\"IAMS:C.EXOR.BROWN\"> NAME='PADDYS RIVER' </features>" +
"    <label column=\"NAME\" style=\"IAMS:T.STREET NAME\">1</label>" +
"  </rule>" +
"  <rule column=\"NAME\" >" +
"    <features style=\"IAMS:C.EXOR.BURLYWOOD\"> NAME='RENDEZVOUS CREEK' </features>" +
"    <label column=\"NAME\" style=\"IAMS:T.STREET NAME\">1</label>" +
"  </rule>" +
"  <rule column=\"NAME\" >" +
"    <features style=\"IAMS:C.EXOR.CADETBLUE\"> NAME='STROMLO' </features>" +
"    <label column=\"NAME\" style=\"IAMS:T.STREET NAME\">1</label>" +
"  </rule>" +
"  <rule column=\"NAME\" >" +
"    <features style=\"IAMS:C.EXOR.CHARTREUSE\"> NAME='TENNENT' </features>" +
"    <label column=\"NAME\" style=\"IAMS:T.STREET NAME\">1</label>" +
"  </rule>" +
"  <rule column=\"NAME\" >" +
"    <features style=\"IAMS:C.EXOR.CHOCOLATE\"> NAME='TUGGERANONG' </features>" +
"    <label column=\"NAME\" style=\"IAMS:T.STREET NAME\">1</label>" +
"  </rule>" +
"  <rule column=\"NAME\" >" +
"    <features style=\"IAMS:C.EXOR.CORAL\"> NAME='WESTON CREEK' </features>" +
"    <label column=\"NAME\" style=\"IAMS:T.STREET NAME\">1</label>" +
"  </rule>" +
"  <rule column=\"NAME\" >" +
"    <features style=\"IAMS:C.EXOR.CORNFLOWERBLUE\"> NAME='WODEN VALLEY' </features>" +
"    <label column=\"NAME\" style=\"IAMS:T.STREET NAME\">1</label>" +
"  </rule>" +
"</styling_rules>" ;
//        xPath = "/styling_rules/rule[@column='NAME']/features[@style='IAMS:C.EXOR.CORNFLOWERBLUE' and ./text() = \" NAME='WODEN VALLEY' \" ]/parent::" ;
//        //xPath = "/styling_rules/rule/features[@style='IAMS:C.EXOR.CORNFLOWERBLUE']" ;
//        System.out.println(testXpath(theXML,xPath));
        System.out.println(updateStylingRules
        ( theXML                  // xml
        , "NAME"                  // search_rule_column          
        , "IAMS:C.EXOR.CORAL"     // search_rule_style           
        , " NAME='WESTON CREEK' " // search_rule_features        
        , "NAME"                  // search_rule_label_column    
        , "IAMS:T.STREET NAME"    // search_rule_label_style     
        , "1"                     // search_rule_label           
        , "NAME_CHANGED"                  // update_rule_column          
        , "IAMS:C.EXOR.CORAL2"     // update_rule_style           
        , " NAME='WESTON CREEK2' " // update_rule_features        
        , "NAME_DEFFO"                  // update_rule_label_column    
        , "IAMS:T.STREET NAME 65"    // update_rule_label_style     
        , "9"                     // update_rule_label           
        ) ) ;
/*        
        theXML = 
"<?xml version=\"1.0\" standalone=\"yes\"?>\n" +
"<styling_rules >\n" +
"  <rule column=\"PRIORITY_CODE\" >\n" +
"    <features style=\"\"> </features>\n" +
"    <label column=\"DOC_ID\" style=\"IAMS:T.ROAD NAME\"> 1 </label>\n" +
"  </rule>\n" +
"</styling_rules>" ;

        xPath = "/styling_rules/rule[@column=\"PRIORITY_CODE\"]/features[@style=\"\" and normalize-space(./text()) = \"\" ]/parent::" ;
        System.out.println(testXpath(theXML,xPath));
        xPath = "/styling_rules/rule[@column='PRIORITY_CODE']/label[@style='IAMS:T.ROAD NAME' and @column='DOC_ID' and ./text() = \" 1 \" ]/parent::" ;
        System.out.println(testXpath(theXML,xPath));
        System.out.println(updateStylingRules
        ( theXML                  // xml
        , "PRIORITY_CODE"                  // search_rule_column          
        , null     // search_rule_style           
        , null // search_rule_features        
        , "DOC_ID"                  // search_rule_label_column    
        , "IAMS:T.ROAD NAME"    // search_rule_label_style     
        , "1"                     // search_rule_label           
        , "NAME_CHANGED"                  // update_rule_column          
        , "IAMS:C.EXOR.CORAL2"     // update_rule_style           
        , null // update_rule_features        
        , "PRIORITY_CODE_DEFFO"                  // update_rule_label_column    
        , "IAMS:T.ROAD NAME 65"    // update_rule_label_style     
        , "9"                     // update_rule_label           
        ) ) ;
*/
     }
     catch (Exception e)
     {
       e.printStackTrace();
       System.out.println(e.getMessage());
     }
   }
  // Will return the node it found, formatted using printNode
  public static String testXpath
    ( String xml 
    , String xPath
    )
  {
  
    String outVal = "xPath = " + xPath + "\n" ;

    try
    {
      DOMParser p = new DOMParser();
      p.parse(new StringReader(xml));
      Document doc = p.getDocument();
      XMLDocument xmldoc = (XMLDocument)doc ;
      
      NodeList nl = xmldoc.selectNodes(xPath) ;
      
      //xmldoc.print(System.out);
      
      for ( int nodeI = 0  ; nl != null && nodeI < nl.getLength() ; nodeI ++) 
      {
        Node n = nl.item(nodeI) ;
        outVal += "<<<Node " + nodeI + "\n";
        printNode(n,"") ;
        outVal += XMLData ;
        outVal += ">>>\n" ;
      }
      //printNode(doc.getDocumentElement().getFirstChild(),"");
      //System.out.println(XMLData);
    }
    catch (Exception e)
    {
      outVal += e.getMessage();
    }
    return outVal ;
  }
  // Helper for updateStylingRules
  private static void noNullAllowed( String name, String val ) throws Exception
  {
    if ( val == null ) 
    {
      throw new Exception( name + " - may not be null" ) ;
    }
  }
  // New styling rules method, very groovy
  public static String updateStylingRules
  ( String xml
  , String search_rule_column          
  , String search_rule_style           
  , String search_rule_features        
  , String search_rule_label_column    
  , String search_rule_label_style     
  , String search_rule_label           
  , String update_rule_column          
  , String update_rule_style           
  , String update_rule_features        
  , String update_rule_label_column    
  , String update_rule_label_style     
  , String update_rule_label           
  )  throws Exception
  {
    // First, some sanity checking
    noNullAllowed("search_rule_column"       , search_rule_column          );
    noNullAllowed("search_rule_label_column" , search_rule_label_column    );
    noNullAllowed("search_rule_label_style"  , search_rule_label_style     );
    noNullAllowed("search_rule_label"        , search_rule_label           );
    noNullAllowed("update_rule_column"       , update_rule_column          );
    noNullAllowed("update_rule_label_column" , update_rule_label_column    );
    noNullAllowed("update_rule_label_style"  , update_rule_label_style     );
    noNullAllowed("update_rule_label"        , update_rule_label           );

    // In Java, unlike PL/SQL, null and the empty string are not the same
    
    String l_search_rule_style = (search_rule_style==null)?"":search_rule_style ;
    String l_search_rule_features = (search_rule_features==null)?"":search_rule_features ;

    String l_update_rule_style = (update_rule_style==null)?"":update_rule_style ;
    String l_update_rule_features = (update_rule_features==null)?"":update_rule_features ;

    DOMParser p = new DOMParser();
    p.parse(new StringReader(xml));
    Document doc = p.getDocument();
    XMLDocument xmldoc = (XMLDocument)doc ;
    
    // OK, this node has features and style subnodes.
    // Code assumes that there is only one features
    // and one label tag
    // If there are going to be more then we will need to change
    // the view and the code here.
    // Note: using normalize-space function in the xpath query because
    // some of the example XML had leading and trailing spaces, and some
    // of it didn't, therefore we have no idea what forms will be throwing
    // at us 

    String xPath1 = "/styling_rules/rule[@column=\""  +
              search_rule_column +
              "\"]/features[@style=\"" +
              l_search_rule_style +
              "\" and normalize-space(./text()) = normalize-space(\"" + l_search_rule_features + 
              "\") ]/parent::" ;

    //System.out.println(xPath1);

    NodeList nl1 = xmldoc.selectNodes(xPath1) ;
    
    if ( nl1 == null )
    {
      throw new Exception("Could not identify styling rule with column = \"" +
              search_rule_column +
              "\" style=\"" +
              l_search_rule_style +
              "\" and features = \"" +
              l_search_rule_features + "\"" ) ;
    }
    
    String xPath2 = "/styling_rules/rule[@column='"  +
              search_rule_column +
              "']/label[@style='" +
              search_rule_label_style +
              "' and @column='" +
              search_rule_label_column +
              "' and normalize-space(./text()) = normalize-space(\"" +
              search_rule_label +
              "\") ]/parent::" ;
    
    //System.out.println(xPath2);
    
    NodeList nl2 = xmldoc.selectNodes(xPath2) ;
    
    if ( nl2 == null )
    {
      throw new Exception("Could not identify styling rule with column = \"" +
              search_rule_column +
              "\" label style=\"" +
              search_rule_label_style +
              "\" label column=\"" +
              search_rule_label_column +
              "\" and label = \"" +
              search_rule_label + "\"" ) ;
    }
    
    // Now we have 2 node lists, let's find the node in common and then update it
    // NOTE: Assuming there can be only one, if not we're in trouble and
    // it will only update the first one it finds
    
    Node theNode = null;
    boolean foundMatch = false ;
    
    for ( int list1 = 0 ; list1 < nl1.getLength() && ! foundMatch ; list1 ++ ) 
    {
      theNode = nl1.item(list1);
      for ( int list2 = 0 ; list2 < nl2.getLength() && ! foundMatch ; list2 ++ ) 
      {
        foundMatch = theNode == nl2.item(list2);
      }
      
    }

    if ( ! foundMatch )
    {
      throw new Exception("No match: Could not identify styling rule with column = \"" +
              search_rule_column +
              "\" style=\"" +
              l_search_rule_style +
              "\" and features = \"" +
              l_search_rule_features + 
              "\" label style=\"" +
              search_rule_label_style +
              "\" label column=\"" +
              search_rule_label_column +
              "\" and label = \"" +
              search_rule_label + "\"" ) ;
    }
    
    // Now we have our node, which was the hard bit
    // Note: Not checking for empty lists because the xPath will have
    // failed if the nodes were empty
    
    Element theEl = (Element)theNode ;
    if ( ! search_rule_column.equals(update_rule_column) )
    {
      theEl.setAttribute("column", update_rule_column);
    }
    
    // Features node
    
    NodeList featuresNodes = theEl.getElementsByTagName("features");
    
    Node featuresNode = featuresNodes.item(0);
    
    Element featuresElement = (Element)featuresNode ;
    
    if ( ! l_search_rule_style.equals(l_update_rule_style) )
    {
      featuresElement.setAttribute("style", l_update_rule_style);
    }
    
    if ( ! l_search_rule_features.equals(l_update_rule_features) )
    {
      // This is silly, but it's how the DOM works, you have to get the
      // child text node of the node you've found to change its value
      // Trust in the Force, young Skywalker
      NodeList childNodes = featuresNode.getChildNodes() ;
      // We could probably just use item(0), but that wouldn't be
      // generic and any slightly odd data would break it
      for ( int childI = 0 ; childI < childNodes.getLength() ; childI ++ ) 
      {
        Node ch = childNodes.item(childI) ;
        if (ch.getNodeType() == Node.TEXT_NODE) 
        {
          ch.setNodeValue(l_update_rule_features);
          break ;
        }
      }
    }
    
    // Now do the label
    
    NodeList labelNodes = theEl.getElementsByTagName("label");
    
    Node labelNode = labelNodes.item(0);
    
    Element labelElement = (Element)labelNode ;
    
    if ( ! search_rule_label_column.equals(update_rule_label_column) )
    {
      labelElement.setAttribute("column",update_rule_label_column);
    }
    
    if ( ! search_rule_label_style.equals(update_rule_label_style) )
    {
      labelElement.setAttribute("style",update_rule_label_style);
    }
    
    if ( ! search_rule_label.equals(update_rule_label) )
    {
      // See earlier comments, young Skywalker
      NodeList childNodes = labelNode.getChildNodes() ;
      // Ditto
      for ( int childI = 0 ; childI < childNodes.getLength() ; childI ++ ) 
      {
        Node ch = childNodes.item(childI) ;
        if (ch.getNodeType() == Node.TEXT_NODE) 
        {
          ch.setNodeValue(update_rule_label);
          break ;
        }
      }
        
    }
 
    return dumpDocument(doc) ;
    
  }
  
};
/
