CREATE OR REPLACE TRIGGER nm_ngr_ngt_trg
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_ngr_ngt_trg.trg-arc   3.2   Apr 13 2018 11:06:36   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm_ngr_ngt_trg.trg  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:06:36  $
--       Date fetched Out : $Modtime:   Apr 13 2018 10:58:46  $
--       PVCS Version     : $Revision:   3.2  $
--
------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
BEFORE INSERT OR UPDATE
ON nm_group_relations_all  FOR EACH ROW
--
DECLARE
  CURSOR nm_group_type_cur(p_ngr_parent_group_type nm_group_relations_all.ngr_parent_group_type%TYPE)  IS
  SELECT 'x' 
    FROM nm_group_types 
   WHERE ngt_group_type = p_ngr_parent_group_type
     AND ngt_sub_group_allowed = 'N';
--
  dummy VARCHAR2(1);
--
BEGIN
--
  OPEN nm_group_type_cur(:new.ngr_parent_group_type);
  FETCH nm_group_type_cur INTO dummy;
-- 
  IF ( nm_group_type_cur%FOUND) THEN
    hig.raise_ner('NET',463,NULL,:new.ngr_parent_group_type );
  END IF;
  CLOSE nm_group_type_cur;
--
END nm_ngr_ngt_trg;
/
