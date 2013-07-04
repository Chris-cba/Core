CREATE OR REPLACE TRIGGER nm_x_location_rules_a_stm 
 AFTER INSERT OR UPDATE ON NM_X_LOCATION_RULES
DECLARE
--   SCCS Identifiers :-
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_x_location_rules_a_stm.trg	1.1 03/26/02
--       Module Name      : nm_x_location_rules_a_stm.trg
--       Date into SCCS   : 02/03/26 11:09:45
--       Date fetched Out : 07/06/13 17:03:43
--       SCCS Version     : 1.1
--
--
--   Author : Rob Coupe
--
--   Dependency loop check
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

dummy integer;  
BEGIN
  select 1 into dummy from nm_x_location_rules
  where rownum =1
  connect by prior nxl_dep_type = nxl_indep_type;
END nm_x_location_rules_a_stm;
/
