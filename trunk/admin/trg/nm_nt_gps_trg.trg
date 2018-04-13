CREATE OR REPLACE TRIGGER nm_nt_gps_trg
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_nt_gps_trg.trg-arc   3.2   Apr 13 2018 11:06:36   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm_nt_gps_trg.trg  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:06:36  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:00:02  $
--       PVCS Version     : $Revision:   3.2  $
--
--------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
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
