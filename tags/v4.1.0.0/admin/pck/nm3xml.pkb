CREATE OR REPLACE PACKAGE BODY nm3xml
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3xml.pkb-arc   3.0   Jan 15 2008 11:20:52   gjohnson  $
--       Module Name      : $Workfile:   nm3xml.pkb  $
--       Date into PVCS   : $Date:   Jan 15 2008 11:20:52  $
--       Date fetched Out : $Modtime:   Jan 15 2008 11:19:24  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   3.0  $';

  g_package_name CONSTANT varchar2(30) := 'nm3xml';
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
FUNCTION xml_to_clob(pi_xml IN xmltype) RETURN CLOB IS

BEGIN

 RETURN(xmltype.extract (pi_xml,'/').getclobval);

END xml_to_clob;
--
-----------------------------------------------------------------------------
--
FUNCTION xml_to_tabvarchar(pi_xml IN xmltype) RETURN nm3type.tab_varchar32767 IS


BEGIN



 RETURN  nm3tab_varchar.cleanse_tab_vc(
                                       pi_tab_vc => nm3clob.clob_to_tab_varchar(
                                                                                pi_clob  => xml_to_clob(
                                                                                                       pi_xml => pi_xml
                                                                                                       )
                                                                               )
                                      );

END xml_to_tabvarchar;
--
-----------------------------------------------------------------------------
--
FUNCTION tab_varchar_to_xml(pi_tab_varchar nm3type.tab_varchar32767) RETURN xmltype IS

BEGIN

 RETURN( xmltype(nm3clob.tab_varchar_to_clob(pi_tab_vc => pi_tab_varchar)) );
 
EXCEPTION
  WHEN others THEN
    hig.raise_ner(pi_appl               => 'HIG'
                 ,pi_id                 => 501 -- XML read error
                 ,pi_supplementary_info => nm3flx.parse_error_message(sqlerrm)); 

END tab_varchar_to_xml;
--
-----------------------------------------------------------------------------
--

FUNCTION clob_to_xml(pi_clob clob) RETURN xmltype IS

BEGIN

 RETURN( xmltype(pi_clob) );
 
EXCEPTION
  WHEN others THEN
    hig.raise_ner(pi_appl               => 'HIG'
                 ,pi_id                 => 501 -- XML read error
                 ,pi_supplementary_info => nm3flx.parse_error_message(sqlerrm)); 

END clob_to_xml;
--
-----------------------------------------------------------------------------
--

END nm3xml;
/
