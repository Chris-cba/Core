CREATE OR REPLACE TRIGGER nm_inv_nw_all_b_row
 BEFORE DELETE OR UPDATE OF nin_end_date
 ON nm_inv_nw_all
 FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_nw_all_b_row.trg	1.1 05/14/02
--       Module Name      : nm_inv_nw_all_b_row.trg
--       Date into SCCS   : 02/05/14 11:22:18
--       Date fetched Out : 07/06/13 17:03:01
--       SCCS Version     : 1.1
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
BEGIN
--
   IF DELETING
    OR (UPDATING AND :NEW.nin_end_date = To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY'))
    THEN
      nm3invval.pop_nm_inv_nw_child_chk_tab (:OLD.nin_nit_inv_code);
   END IF;
--
END nm_inv_nw_all_b_row;
/
