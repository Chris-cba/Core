CREATE OR REPLACE PACKAGE BODY nm3rsc_o AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3rsc_o.pkb	1.1 09/23/02
--       Module Name      : nm3rsc_o.pkb
--       Date into SCCS   : 02/09/23 09:48:57
--       Date fetched Out : 07/06/13 14:13:22
--       SCCS Version     : 1.1
--
--
--   Author : Rob Coupe
--
--   NM3 Rescale (object) package body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)nm3rsc_o.pkb	1.1 09/23/02"';
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
