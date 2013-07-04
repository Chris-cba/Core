CREATE OR REPLACE TRIGGER nm_types_del_nlt_trg_br
   BEFORE DELETE
   ON nm_types
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_types_del_nlt_trg_br.trg	1.2 04/20/06
--       Module Name      : nm_types_del_nlt_trg_br.trg
--       Date into SCCS   : 06/04/20 10:38:09
--       Date fetched Out : 07/06/13 17:03:41
--       SCCS Version     : 1.2
--
--
--   Author : Sarah Scanlon
--
--    Create NM_LINEAR_TYPE Trigger
--
-----------------------------------------------------------------------------
-- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
   l_rec_nt               nm_types%ROWTYPE;
   i                      NUMBER DEFAULT   nm3net.g_tab_nt.COUNT
                                         + 1;
BEGIN
   --get data to be deleted from nm_types and call into temporary table to be used later
   nm3net.g_tab_nt (i).nt_type           := :OLD.nt_type;
   nm3net.g_tab_nt (i).nt_unique         := :OLD.nt_unique;
   nm3net.g_tab_nt (i).nt_linear         := :OLD.nt_linear;
   nm3net.g_tab_nt (i).nt_node_type      := :OLD.nt_node_type;
   nm3net.g_tab_nt (i).nt_descr          := :OLD.nt_descr;
   nm3net.g_tab_nt (i).nt_admin_type     := :OLD.nt_admin_type;
   nm3net.g_tab_nt (i).nt_length_unit    := :OLD.nt_length_unit;
   nm3net.g_tab_nt (i).nt_datum          := :OLD.nt_datum;
   nm3net.g_tab_nt (i).nt_pop_unique     := :OLD.nt_pop_unique;
--
END nm_types_del_nlt_trg_br;
/
