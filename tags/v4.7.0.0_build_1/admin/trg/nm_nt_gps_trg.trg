CREATE OR REPLACE TRIGGER nm_nt_gps_trg
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_nt_gps_trg.trg-arc   3.1   Jul 04 2013 09:54:08   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_nt_gps_trg.trg  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:54:08  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:35:32  $
--       PVCS Version     : $Revision:   3.1  $
--
--------------------------------------------------------------------------------
--
BEFORE INSERT OR UPDATE
ON nm_nt_groupings_all  FOR EACH ROW
--
DECLARE
  cursor nm_type_cur(p_nng_nt_type nm_nt_groupings_all.nng_nt_type%type)  IS
  SELECT 'x'
    FROM nm_types
   WHERE nt_datum = 'Y'
      AND nt_type = p_nng_nt_type;
--
  dummy VARCHAR2(1);
--
BEGIN
--
  OPEN nm_type_cur(:new.nng_nt_type);
  FETCH nm_type_cur INTO dummy;
--
  IF ( nm_type_cur%NOTFOUND) THEN
    hig.raise_ner('NET',462,NULL,:new.nng_nt_type );
  END IF;
  CLOSE nm_type_cur;
--
END nm_nt_gps_trg;
/
