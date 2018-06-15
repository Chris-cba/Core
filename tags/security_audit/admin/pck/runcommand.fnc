--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/runcommand.fnc-arc   1.0   Jun 15 2018 10:08:38   Chris.Baugh  $
--       Module Name      : $Workfile:   runcommand.fnc  $
--       Date into SCCS   : $Date:   Jun 15 2018 10:08:38  $
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
