CREATE OR REPLACE PACKAGE BODY nm3nw_edit
AS
	-------------------------------------------------------------------------
	--	 PVCS Identifiers :-
	--
	--			 PVCS id					: $Header:   //new_vm_latest/archives/nm3/admin/pck/nm3nw_edit.pkb-arc   3.2   Apr 16 2018 09:23:16   Gaurav.Gaurkar  $
	--			 Module Name			: $Workfile:   nm3nw_edit.pkb  $
	--			 Date into PVCS 	: $Date:   Apr 16 2018 09:23:16  $
	--			 Date fetched Out : $Modtime:   Apr 16 2018 09:04:32  $
	--			 Version					: $Revision:   3.2  $
	-------------------------------------------------------------------------
	--
	--all global package variables here
    --
    ------------------------------------------------------------------
    --   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
    ------------------------------------------------------------------
    --
	-----------
	--constants
	-----------
	--g_body_sccsid is the SCCS ID for the package body
	g_body_sccsid 	CONSTANT VARCHAR2(2000) := '$Revision:   3.2  $';

	g_package_name	CONSTANT VARCHAR2(30) := 'nm3nw_edit';
	--
	-----------------------------------------------------------------------------
	--
	FUNCTION get_version
		RETURN VARCHAR2
	IS
	BEGIN
		RETURN g_sccsid;
	END get_version;
	--
	-----------------------------------------------------------------------------
	--
	FUNCTION get_body_version
		RETURN VARCHAR2
	IS
	BEGIN
		RETURN g_body_sccsid;
	END get_body_version;
	--
	-----------------------------------------------------------------------------
	--
	PROCEDURE ins_neh(p_rec_neh IN OUT nm_element_history%ROWTYPE)
	IS
	BEGIN
		--
		nm_debug.proc_start(g_package_name, 'ins_neh');
		--
		p_rec_neh.neh_id	 := nvl(p_rec_neh.neh_id, nm3seq.next_neh_id_seq);
		nm3ins.ins_neh(p_rec_neh => p_rec_neh);
		--
		nm_debug.proc_end(g_package_name, 'ins_neh');
	--
	END ins_neh;
--
-----------------------------------------------------------------------------
--
END nm3nw_edit;
/
