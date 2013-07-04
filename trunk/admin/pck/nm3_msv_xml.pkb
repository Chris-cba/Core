CREATE OR REPLACE PACKAGE BODY nm3_msv_xml AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3_msv_xml.pkb	1.1 02/15/06
--       Module Name      : nm3_msv_xml.pkb
--       Date into SCCS   : 06/02/15 16:52:23
--       Date fetched Out : 07/06/13 14:10:49
--       SCCS Version     : 1.1
--
--
--   Author : Francis Fish
--
--   nm3_msv_xml body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid   CONSTANT varchar2(2000) := '"@(#)nm3_msv_xml.pkb	1.1 02/15/06"';

  g_package_name  CONSTANT varchar2(30) := 'nm3_msv_xml';
  
  ------------------
  --global variables
  ------------------
  --
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
 function update_def_xml
  ( p_xml                  in varchar2
  , p_search_Node          in varchar2
  , p_search_Attrib_Name   in varchar2
  , p_search_Attrib_Value  in varchar2
  , p_change_attrib_Name   in varchar2
  , p_new_Value            in varchar2   
  ) return varchar2 as
language java name 'com.exor.xml.UpdateXMLAttrib.updateAttrib4Map(
java.lang.String, java.lang.String
, java.lang.String, java.lang.String, java.lang.String, java.lang.String)
return java.lang.String ' ;
--
-----------------------------------------------------------------------------
--
  function  update_styling_rules
  ( p_xml                        in varchar2
  , p_search_rule_column         in varchar2 
  , p_search_rule_style          in varchar2 
  , p_search_rule_features       in varchar2 
  , p_search_rule_label_column   in varchar2 
  , p_search_rule_label_style    in varchar2 
  , p_search_rule_label          in varchar2 
  , p_update_rule_column         in varchar2 
  , p_update_rule_style          in varchar2 
  , p_update_rule_features       in varchar2 
  , p_update_rule_label_column   in varchar2 
  , p_update_rule_label_style    in varchar2 
  , p_update_rule_label          in varchar2
  ) return varchar2 as
language java name 'com.exor.xml.UpdateXMLAttrib.updateStylingRules(
java.lang.String, java.lang.String, java.lang.String, java.lang.String
, java.lang.String, java.lang.String, java.lang.String, java.lang.String
, java.lang.String, java.lang.String, java.lang.String, java.lang.String
, java.lang.String
)
return java.lang.String ';
--
-----------------------------------------------------------------------------
--
  function  test_xpath
  ( xml    in varchar2
  , xPath  in varchar2
  ) return varchar2 as
language java name 'com.exor.xml.UpdateXMLAttrib.testXpath(
java.lang.String, java.lang.String
)
return java.lang.String ';
--
-----------------------------------------------------------------------------
--
END nm3_msv_xml ;
/
