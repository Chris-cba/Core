CREATE OR REPLACE FORCE VIEW all_sdo_styles
	(OWNER
	,NAME
	,TYPE
	,DESCRIPTION
	,DEFINITION
	,IMAGE
	,GEOMETRY
	)
AS
SELECT
--
-----------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/all_sdo_styles.vw-arc   1.1   Apr 13 2018 11:47:14   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   all_sdo_styles.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:14  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:30:00  $
--       Version          : $Revision:   1.1  $
--
-----------------------------------------------------------------------------------
-- Copyright (c) 2018 Bentley Systems Incorporated.  All rights reserved.
-----------------------------------------------------------------------------------
--
	HUS_USERNAME OWNER
	,NAME
	,TYPE
	,DESCRIPTION
	,DEFINITION
	,IMAGE
	,GEOMETRY
FROM 	MDSYS.SDO_STYLES_TABLE, HIG_USERS
WHERE 	sdo_owner = USER 
AND 	hus_username IS NOT NULL
/
