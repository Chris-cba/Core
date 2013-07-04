CREATE OR REPLACE PACKAGE BODY nm3_tab_nex AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3_tab_nex.pkb-arc   2.2   Jul 04 2013 15:10:54   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3_tab_nex.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:10:54  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:22  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.1
---------------------------------------------------------------------------
--   Author : 
--
--   Generated package DO NOT MODIFY
--
--   get_gen header : "@(#)nm3_tab_nex.pkb	1.1 11/24/05"
--   get_gen body   : @(#)nm3_tab_nex.pkb	1.1 11/24/05
--
-----------------------------------------------------------------------------
--
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
--
-----------------------------------------------------------------------------
--
   g_body_sccsid CONSTANT  VARCHAR2(2000) := '$Revision:   2.2  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'hig_tab_nex';
--
FUNCTION get_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
--
--   Function to get using NEX_PK constraint
--
FUNCTION get (pi_nex_relationship_type NM_ELEMENT_XREFS.nex_relationship_type%TYPE
             ,pi_nex_id1               NM_ELEMENT_XREFS.nex_id1%TYPE
             ,pi_nex_id2               NM_ELEMENT_XREFS.nex_id2%TYPE
             ,pi_raise_not_found       BOOLEAN     DEFAULT TRUE
             ,pi_not_found_sqlcode     PLS_INTEGER DEFAULT -20000
             ) RETURN NM_ELEMENT_XREFS%ROWTYPE IS
--
   CURSOR cs_nex IS
   SELECT /*+ FIRST_ROWS(1) INDEX(nex NEX_PK) */ 
          nex_relationship_type
         ,nex_id1
         ,nex_id2
    FROM  NM_ELEMENT_XREFS nex
   WHERE  nex.nex_relationship_type = pi_nex_relationship_type
    AND   nex.nex_id1               = pi_nex_id1
    AND   nex.nex_id2               = pi_nex_id2;
--
   l_found  BOOLEAN;
   l_retval NM_ELEMENT_XREFS%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get');
--
   OPEN  cs_nex;
   FETCH cs_nex INTO l_retval;
   l_found := cs_nex%FOUND;
   CLOSE cs_nex;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'NM_ELEMENT_XREFS (NEX_PK)'
                                              ||CHR(10)||'nex_relationship_type => '||pi_nex_relationship_type
                                              ||CHR(10)||'nex_id1               => '||pi_nex_id1
                                              ||CHR(10)||'nex_id2               => '||pi_nex_id2
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get');
--
   RETURN l_retval;
-- nm_elements_all
END get;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_ntx_rules(pi_nex_rec IN nm_element_xrefs%ROWTYPE) IS


 CURSOR c_nex IS
 SELECT 'X'
 FROM   nm_type_xrefs
       ,nm_elements_all ne1
       ,nm_elements_all ne2	   
 WHERE ne1.ne_id = pi_nex_rec.nex_id1
 AND   ne2.ne_id = pi_nex_rec.nex_id2
 AND   ntx_relationship_type = pi_nex_rec.nex_relationship_type
 AND   ntx_nt_type1 = ne1.ne_nt_type
 AND   ntx_nt_type2 = ne2.ne_nt_type
 AND   NVL(ntx_gty_type1,ne1.ne_gty_group_type) = ne1.ne_gty_group_type
 AND   NVL(ntx_gty_type2,ne2.ne_gty_group_type) = ne2.ne_gty_group_type
 UNION -- union required to reverse the association i.e. if NT1 can be associated with NT2 then NT2 can be against NT1 etc etc 
 SELECT 'X'
 FROM   nm_type_xrefs
       ,nm_elements_all ne1
       ,nm_elements_all ne2	   
 WHERE ne1.ne_id = pi_nex_rec.nex_id2
 AND   ne2.ne_id = pi_nex_rec.nex_id1
 AND   ntx_relationship_type = pi_nex_rec.nex_relationship_type
 AND   ntx_nt_type1 = ne1.ne_nt_type
 AND   ntx_nt_type2 = ne2.ne_nt_type
 AND   NVL(ntx_gty_type1,ne1.ne_gty_group_type) = ne1.ne_gty_group_type
 AND   NVL(ntx_gty_type2,ne2.ne_gty_group_type) = ne2.ne_gty_group_type; 
 
 l_dummy VARCHAR2(1);   
  
BEGIN

 OPEN c_nex;
 FETCH c_nex INTO l_dummy;
 CLOSE c_nex;
 
 IF l_dummy IS NULL THEN
   hig.raise_ner(pi_appl  => nm3type.c_net
                ,pi_id    => 423); 
 END IF;
 

END check_ntx_rules;
--
-----------------------------------------------------------------------------
--
END nm3_tab_nex;
/
