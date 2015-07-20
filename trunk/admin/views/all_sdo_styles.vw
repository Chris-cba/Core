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
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/all_sdo_styles.vw-arc   1.0   Jul 20 2015 15:07:22   Upendra.Hukeri  $
--       Module Name      : $Workfile:   all_sdo_styles.vw  $
--       Date into PVCS   : $Date:   Jul 20 2015 15:07:22  $
--       Date fetched Out : $Modtime:   Jul 14 2015 16:12:00  $
--       Version          : $Revision:   1.0  $
--
-----------------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
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
