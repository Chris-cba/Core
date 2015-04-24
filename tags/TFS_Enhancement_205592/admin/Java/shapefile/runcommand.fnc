--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/Java/shapefile/runcommand.fnc-arc   1.0   Apr 24 2015 15:44:04   Upendra.Hukeri  $
--       Module Name      : $Workfile:   runcommand.fnc  $
--       Date into SCCS   : $Date:   Apr 24 2015 15:44:04  $
--       Date fetched Out : $Modtime:   Apr 24 2015 15:42:58  $
--       SCCS Version     : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
----------------------------------------------------------------------------------------------------
--
CREATE OR REPLACE FUNCTION runcommand(p_command IN VARCHAR2, p_success_str IN VARCHAR2, p_output_mode IN VARCHAR2)
RETURN VARCHAR2 
AS LANGUAGE JAVA 
	NAME 'CMDUtilities.runCommand(java.lang.String, java.lang.String, java.lang.String) return oracle.sql.string';
/
