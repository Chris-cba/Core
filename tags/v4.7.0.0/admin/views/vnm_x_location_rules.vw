CREATE OR REPLACE FORCE VIEW VNM_X_LOCATION_RULES
AS
select
--   SCCS Identifiers :-
--
--       sccsid           : @(#)vnm_x_location_rules.vw	1.2 12/18/01
--       Module Name      : vnm_x_location_rules.vw
--       Date into SCCS   : 01/12/18 12:40:52
--       Date fetched Out : 07/06/13 17:08:42
--       SCCS Version     : 1.2
--
--
-- VNM_X_LOCATION_RULES
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
 a.*, nm3inv_xattr.get_loc_constraint( a.nxl_rule_id ) nxl_constraint
from nm_x_location_rules a
/
