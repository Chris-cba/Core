CREATE OR REPLACE PACKAGE BODY nm3rsc_o AS
--
-----------------------------------------------------------------------------
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3rsc_o.pkb-arc   2.2   Jul 04 2013 16:21:12   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3rsc_o.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:21:12  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:18  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.1
-------------------------------------------------------------------------
--   Author : Rob Coupe
--
--   NM3 Rescale (object) package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.2  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3rsc_o';
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
FUNCTION get_rescaled_pl RETURN nm_placement_array IS
--
   retval nm_placement_array := nm3pla.initialise_placement_array;
--
   CURSOR cs_nrw is
   SELECT ne_id
         ,nm_begin_mp
         ,nm_end_mp
         ,nm_true
    FROM  nm_rescale_write
   ORDER BY nm_seq_no;
--
   l_tab_ne_id       nm3type.tab_number;
   l_tab_nm_begin_mp nm3type.tab_number;
   l_tab_nm_end_mp   nm3type.tab_number;
   l_tab_nm_true     nm3type.tab_number;
--
begin
--
   nm_debug.proc_start (g_package_name,'get_rescaled_pl');
--
   OPEN  cs_nrw;
   FETCH cs_nrw
    BULK COLLECT
    INTO l_tab_ne_id
        ,l_tab_nm_begin_mp
        ,l_tab_nm_end_mp
        ,l_tab_nm_true;
   CLOSE cs_nrw;
--
   FOR i IN 1..l_tab_ne_id.COUNT
    LOOP
      retval := retval.add_element (pl_ne_id   => l_tab_ne_id(i)
                                   ,pl_start   => l_tab_nm_begin_mp(i)
                                   ,pl_end     => l_tab_nm_end_mp(i)
                                   ,pl_measure => l_tab_nm_true(i)
                                   );
   END LOOP;
--
   nm_debug.proc_end (g_package_name,'get_rescaled_pl');
--
   return retval;
--
END get_rescaled_pl;
--
-----------------------------------------------------------------------------
--
END nm3rsc_o;
/
