CREATE OR REPLACE TRIGGER nm_ngr_ngt_trg
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_ngr_ngt_trg.trg-arc   3.0   Nov 03 2009 10:55:58   aedwards  $
--       Module Name      : $Workfile:   nm_ngr_ngt_trg.trg  $
--       Date into PVCS   : $Date:   Nov 03 2009 10:55:58  $
--       Date fetched Out : $Modtime:   Nov 03 2009 10:53:24  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
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
