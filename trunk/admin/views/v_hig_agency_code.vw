CREATE OR REPLACE FORCE VIEW v_hig_agency_code
AS
SELECT
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_hig_agency_code.vw	1.1 07/12/06
--       Module Name      : v_hig_agency_code.vw
--       Date into SCCS   : 06/07/12 17:41:53
--       Date fetched Out : 07/06/13 17:08:25
--       SCCS Version     : 1.1
--
--
--   Author : Clive Hackforth 
--   Used as part of the network model validation
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2006
----------------------------------------------------------------------------- 
          hau_authority_code agency_code
        , hau_name
		, hau_authority_code
     FROM hig_admin_units
    WHERE hau_authority_code IS NOT NULL
      AND (   EXISTS (
                 SELECT 'exists'
                   FROM hig_admin_groups
				      , hig_users
                  WHERE hag_child_admin_unit = hus_admin_unit
                    AND hag_parent_admin_unit = hau_admin_unit
                    AND hus_username = Sys_Context('NM3_SECURITY_CTX','USERNAME'))
           OR EXISTS (
                 SELECT 'exists'
                   FROM hig_admin_groups
				      , hig_users
                  WHERE hag_child_admin_unit = hau_admin_unit
                    AND hag_parent_admin_unit = hus_admin_unit
                    AND hus_username = Sys_Context('NM3_SECURITY_CTX','USERNAME'))
          )
/		  
