CREATE OR REPLACE TRIGGER nm_type_columns_biud_stm_trg
   BEFORE INSERT OR UPDATE OR DELETE ON nm_type_columns
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_type_columns_biud_stm_trg.trg	1.1 10/22/03
--       Module Name      : nm_type_columns_biud_stm_trg.trg
--       Date into SCCS   : 03/10/22 19:02:56
--       Date fetched Out : 07/06/13 17:03:39
--       SCCS Version     : 1.1
--
--
--   Author : Kevin Angus
--
--    nm_type_columns_aiud_stm_trg
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

  l_db_action  varchar2(10);

BEGIN
  IF UPDATING
  THEN
    l_db_action := nm3type.c_updating;
  
  ELSIF INSERTING
  THEN
    l_db_action := nm3type.c_inserting;
  
  ELSIF DELETING
  THEN
    l_db_action := nm3type.c_deleting;
  END IF;

  nm3nwval.ntc_before_iud_stm_trg(pi_db_action => l_db_action);

END nm_type_columns_biud_stm_trg;
/
