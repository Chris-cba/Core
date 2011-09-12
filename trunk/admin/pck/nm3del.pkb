CREATE OR REPLACE PACKAGE BODY nm3del IS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3del.pkb-arc   2.20   Sep 12 2011 12:34:40   Mike.Alexander  $
--       Module Name      : $Workfile:   nm3del.pkb  $
--       Date into PVCS   : $Date:   Sep 12 2011 12:34:40  $
--       Date fetched Out : $Modtime:   Sep 12 2011 11:25:58  $
--       PVCS Version     : $Revision:   2.20  $
--
--
--   Author : Jonathan Mills
--
--   Generated package DO NOT MODIFY
--
--   nm3get_gen header : "@(#)nm3get_gen.pkh	1.3 12/05/05"
--   nm3get_gen body   : "$Revision:   2.20  $"
--
-----------------------------------------------------------------------------
--
--	Copyright (c) exor corporation ltd, 2005
--
-----------------------------------------------------------------------------
--
   g_body_sccsid CONSTANT  VARCHAR2(2000) := '"$Revision:   2.20  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3del';
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DOC_PK constraint
--
PROCEDURE del_doc (pi_doc_id            docs.doc_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_doc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_doc
                   (pi_doc_id            => pi_doc_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE docs doc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_doc');
--
END del_doc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DAC_PK constraint
--
PROCEDURE del_dac (pi_dac_id            doc_actions.dac_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dac');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dac
                   (pi_dac_id            => pi_dac_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_actions dac
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dac');
--
END del_dac;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DAS_PK constraint
--
PROCEDURE del_das (pi_das_table_name    doc_assocs.das_table_name%TYPE
                  ,pi_das_rec_id        doc_assocs.das_rec_id%TYPE
                  ,pi_das_doc_id        doc_assocs.das_doc_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_das');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_das
                   (pi_das_table_name    => pi_das_table_name
                   ,pi_das_rec_id        => pi_das_rec_id
                   ,pi_das_doc_id        => pi_das_doc_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_assocs das
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_das');
--
END del_das;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DCL_PK constraint
--
PROCEDURE del_dcl (pi_dcl_dtp_code      doc_class.dcl_dtp_code%TYPE
                  ,pi_dcl_code          doc_class.dcl_code%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dcl');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dcl
                   (pi_dcl_dtp_code      => pi_dcl_dtp_code
                   ,pi_dcl_code          => pi_dcl_code
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_class dcl
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dcl');
--
END del_dcl;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DCL_UK1 constraint
--
PROCEDURE del_dcl (pi_dcl_name          doc_class.dcl_name%TYPE
                  ,pi_dcl_dtp_code      doc_class.dcl_dtp_code%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dcl');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dcl
                   (pi_dcl_name          => pi_dcl_name
                   ,pi_dcl_dtp_code      => pi_dcl_dtp_code
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_class dcl
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dcl');
--
END del_dcl;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DCP_PK constraint
--
PROCEDURE del_dcp (pi_dcp_doc_id        doc_copies.dcp_doc_id%TYPE
                  ,pi_dcp_id            doc_copies.dcp_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dcp');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dcp
                   (pi_dcp_doc_id        => pi_dcp_doc_id
                   ,pi_dcp_id            => pi_dcp_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_copies dcp
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dcp');
--
END del_dcp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DDG_PK constraint
--
PROCEDURE del_ddg (pi_ddg_id            doc_damage.ddg_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ddg');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ddg
                   (pi_ddg_id            => pi_ddg_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_damage ddg
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ddg');
--
END del_ddg;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DDC_PK constraint
--
PROCEDURE del_ddc (pi_ddc_id            doc_damage_costs.ddc_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ddc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ddc
                   (pi_ddc_id            => pi_ddc_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_damage_costs ddc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ddc');
--
END del_ddc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DEC_PK constraint
--
PROCEDURE del_dec (pi_dec_hct_id        doc_enquiry_contacts.dec_hct_id%TYPE
                  ,pi_dec_doc_id        doc_enquiry_contacts.dec_doc_id%TYPE
                  ,pi_dec_type          doc_enquiry_contacts.dec_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dec');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dec
                   (pi_dec_hct_id        => pi_dec_hct_id
                   ,pi_dec_doc_id        => pi_dec_doc_id
                   ,pi_dec_type          => pi_dec_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_enquiry_contacts dec
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dec');
--
END del_dec;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DET_PK constraint
--
PROCEDURE del_det (pi_det_dtp_code      doc_enquiry_types.det_dtp_code%TYPE
                  ,pi_det_dcl_code      doc_enquiry_types.det_dcl_code%TYPE
                  ,pi_det_code          doc_enquiry_types.det_code%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_det');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_det
                   (pi_det_dtp_code      => pi_det_dtp_code
                   ,pi_det_dcl_code      => pi_det_dcl_code
                   ,pi_det_code          => pi_det_code
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_enquiry_types det
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_det');
--
END del_det;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DET_UNQ constraint
--
PROCEDURE del_det (pi_det_dtp_code      doc_enquiry_types.det_dtp_code%TYPE
                  ,pi_det_dcl_code      doc_enquiry_types.det_dcl_code%TYPE
                  ,pi_det_code          doc_enquiry_types.det_code%TYPE
                  ,pi_det_name          doc_enquiry_types.det_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_det');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_det
                   (pi_det_dtp_code      => pi_det_dtp_code
                   ,pi_det_dcl_code      => pi_det_dcl_code
                   ,pi_det_code          => pi_det_code
                   ,pi_det_name          => pi_det_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_enquiry_types det
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_det');
--
END del_det;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DGT_PK constraint
--
PROCEDURE del_dgt (pi_dgt_table_name    doc_gateways.dgt_table_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dgt');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dgt
                   (pi_dgt_table_name    => pi_dgt_table_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_gateways dgt
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dgt');
--
END del_dgt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DGT_UK1 constraint
--
PROCEDURE del_dgt (pi_dgt_table_descr   doc_gateways.dgt_table_descr%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dgt');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dgt
                   (pi_dgt_table_descr   => pi_dgt_table_descr
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_gateways dgt
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dgt');
--
END del_dgt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DGS_PK constraint
--
PROCEDURE del_dgs (pi_dgs_dgt_table_name doc_gate_syns.dgs_dgt_table_name%TYPE
                  ,pi_dgs_table_syn      doc_gate_syns.dgs_table_syn%TYPE
                  ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dgs');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dgs
                   (pi_dgs_dgt_table_name => pi_dgs_dgt_table_name
                   ,pi_dgs_table_syn      => pi_dgs_table_syn
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   ,pi_locked_sqlcode     => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_gate_syns dgs
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dgs');
--
END del_dgs;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DHI_PK constraint
--
PROCEDURE del_dhi (pi_dhi_doc_id        doc_history.dhi_doc_id%TYPE
                  ,pi_dhi_date_changed  doc_history.dhi_date_changed%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dhi');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dhi
                   (pi_dhi_doc_id        => pi_dhi_doc_id
                   ,pi_dhi_date_changed  => pi_dhi_date_changed
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_history dhi
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dhi');
--
END del_dhi;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DKY_PK constraint
--
PROCEDURE del_dky (pi_dky_doc_id        doc_keys.dky_doc_id%TYPE
                  ,pi_dky_dkw_key_id    doc_keys.dky_dkw_key_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dky');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dky
                   (pi_dky_doc_id        => pi_dky_doc_id
                   ,pi_dky_dkw_key_id    => pi_dky_dkw_key_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_keys dky
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dky');
--
END del_dky;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DKW_PK constraint
--
PROCEDURE del_dkw (pi_dkw_key_id        doc_keywords.dkw_key_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dkw');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dkw
                   (pi_dkw_key_id        => pi_dkw_key_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_keywords dkw
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dkw');
--
END del_dkw;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DLC_PK constraint
--
PROCEDURE del_dlc (pi_dlc_id            doc_locations.dlc_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dlc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dlc
                   (pi_dlc_id            => pi_dlc_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_locations dlc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dlc');
--
END del_dlc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DLC_UK constraint
--
PROCEDURE del_dlc (pi_dlc_name          doc_locations.dlc_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dlc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dlc
                   (pi_dlc_name          => pi_dlc_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_locations dlc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dlc');
--
END del_dlc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DMD_PK constraint
--
PROCEDURE del_dmd (pi_dmd_id            doc_media.dmd_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dmd');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dmd
                   (pi_dmd_id            => pi_dmd_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_media dmd
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dmd');
--
END del_dmd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DMD_UK constraint
--
PROCEDURE del_dmd (pi_dmd_name          doc_media.dmd_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dmd');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dmd
                   (pi_dmd_name          => pi_dmd_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_media dmd
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dmd');
--
END del_dmd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DQ_PK constraint
--
PROCEDURE del_dq (pi_dq_id             doc_query.dq_id%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dq');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dq
                   (pi_dq_id             => pi_dq_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_query dq
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dq');
--
END del_dq;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DQ_UK constraint
--
PROCEDURE del_dq (pi_dq_title          doc_query.dq_title%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dq');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dq
                   (pi_dq_title          => pi_dq_title
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_query dq
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dq');
--
END del_dq;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DQC_PK constraint
--
PROCEDURE del_dqc (pi_dqc_dq_id         doc_query_cols.dqc_dq_id%TYPE
                  ,pi_dqc_seq_no        doc_query_cols.dqc_seq_no%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dqc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dqc
                   (pi_dqc_dq_id         => pi_dqc_dq_id
                   ,pi_dqc_seq_no        => pi_dqc_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_query_cols dqc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dqc');
--
END del_dqc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DSC_PK constraint
--
PROCEDURE del_dsc (pi_dsc_type          doc_std_costs.dsc_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dsc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dsc
                   (pi_dsc_type          => pi_dsc_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_std_costs dsc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dsc');
--
END del_dsc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DSY_PK constraint
--
PROCEDURE del_dsy (pi_dsy_key_id        doc_synonyms.dsy_key_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dsy');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dsy
                   (pi_dsy_key_id        => pi_dsy_key_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_synonyms dsy
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dsy');
--
END del_dsy;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DTC_PK constraint
--
PROCEDURE del_dtc (pi_dtc_template_name doc_template_columns.dtc_template_name%TYPE
                  ,pi_dtc_col_alias     doc_template_columns.dtc_col_alias%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dtc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dtc
                   (pi_dtc_template_name => pi_dtc_template_name
                   ,pi_dtc_col_alias     => pi_dtc_col_alias
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_template_columns dtc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dtc');
--
END del_dtc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DTG_PK constraint
--
PROCEDURE del_dtg (pi_dtg_template_name doc_template_gateways.dtg_template_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dtg');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dtg
                   (pi_dtg_template_name => pi_dtg_template_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_template_gateways dtg
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dtg');
--
END del_dtg;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DTU_PK constraint
--
PROCEDURE del_dtu (pi_dtu_user_id       doc_template_users.dtu_user_id%TYPE
                  ,pi_dtu_template_name doc_template_users.dtu_template_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dtu');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dtu
                   (pi_dtu_user_id       => pi_dtu_user_id
                   ,pi_dtu_template_name => pi_dtu_template_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_template_users dtu
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dtu');
--
END del_dtu;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DTP_PK constraint
--
PROCEDURE del_dtp (pi_dtp_code          doc_types.dtp_code%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dtp');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dtp
                   (pi_dtp_code          => pi_dtp_code
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_types dtp
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dtp');
--
END del_dtp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using DTP_UK constraint
--
PROCEDURE del_dtp (pi_dtp_name          doc_types.dtp_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_dtp');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_dtp
                   (pi_dtp_name          => pi_dtp_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE doc_types dtp
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_dtp');
--
END del_dtp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using GL_PK constraint
--
PROCEDURE del_gl (pi_gl_job_id         gri_lov.gl_job_id%TYPE
                 ,pi_gl_param          gri_lov.gl_param%TYPE
                 ,pi_gl_return         gri_lov.gl_return%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_gl');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_gl
                   (pi_gl_job_id         => pi_gl_job_id
                   ,pi_gl_param          => pi_gl_param
                   ,pi_gl_return         => pi_gl_return
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE gri_lov gl
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_gl');
--
END del_gl;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using GRM_PK constraint
--
PROCEDURE del_grm (pi_grm_module        gri_modules.grm_module%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_grm');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_grm
                   (pi_grm_module        => pi_grm_module
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE gri_modules grm
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_grm');
--
END del_grm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using GMP_PK constraint
--
PROCEDURE del_gmp (pi_gmp_module        gri_module_params.gmp_module%TYPE
                  ,pi_gmp_param         gri_module_params.gmp_param%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_gmp');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_gmp
                   (pi_gmp_module        => pi_gmp_module
                   ,pi_gmp_param         => pi_gmp_param
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE gri_module_params gmp
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_gmp');
--
END del_gmp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using GP_PK constraint
--
PROCEDURE del_gp (pi_gp_param          gri_params.gp_param%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_gp');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_gp
                   (pi_gp_param          => pi_gp_param
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE gri_params gp
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_gp');
--
END del_gp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using GPD_PK constraint
--
PROCEDURE del_gpd (pi_gpd_indep_param   gri_param_dependencies.gpd_indep_param%TYPE
                  ,pi_gpd_module        gri_param_dependencies.gpd_module%TYPE
                  ,pi_gpd_dep_param     gri_param_dependencies.gpd_dep_param%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_gpd');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_gpd
                   (pi_gpd_indep_param   => pi_gpd_indep_param
                   ,pi_gpd_module        => pi_gpd_module
                   ,pi_gpd_dep_param     => pi_gpd_dep_param
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE gri_param_dependencies gpd
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_gpd');
--
END del_gpd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using GPL_PK constraint
--
PROCEDURE del_gpl (pi_gpl_param         gri_param_lookup.gpl_param%TYPE
                  ,pi_gpl_value         gri_param_lookup.gpl_value%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_gpl');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_gpl
                   (pi_gpl_param         => pi_gpl_param
                   ,pi_gpl_value         => pi_gpl_value
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE gri_param_lookup gpl
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_gpl');
--
END del_gpl;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using GRR_PK constraint
--
PROCEDURE del_grr (pi_grr_job_id        gri_report_runs.grr_job_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_grr');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_grr
                   (pi_grr_job_id        => pi_grr_job_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE gri_report_runs grr
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_grr');
--
END del_grr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using GRP_PK constraint
--
PROCEDURE del_grp (pi_grp_job_id        gri_run_parameters.grp_job_id%TYPE
                  ,pi_grp_param         gri_run_parameters.grp_param%TYPE
                  ,pi_grp_seq           gri_run_parameters.grp_seq%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_grp');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_grp
                   (pi_grp_job_id        => pi_grp_job_id
                   ,pi_grp_param         => pi_grp_param
                   ,pi_grp_seq           => pi_grp_seq
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE gri_run_parameters grp
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_grp');
--
END del_grp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using GSP_PK constraint
--
PROCEDURE del_gsp (pi_gsp_gss_id        gri_saved_params.gsp_gss_id%TYPE
                  ,pi_gsp_seq           gri_saved_params.gsp_seq%TYPE
                  ,pi_gsp_param         gri_saved_params.gsp_param%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_gsp');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_gsp
                   (pi_gsp_gss_id        => pi_gsp_gss_id
                   ,pi_gsp_seq           => pi_gsp_seq
                   ,pi_gsp_param         => pi_gsp_param
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE gri_saved_params gsp
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_gsp');
--
END del_gsp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using GSS_PK constraint
--
PROCEDURE del_gss (pi_gss_id            gri_saved_sets.gss_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_gss');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_gss
                   (pi_gss_id            => pi_gss_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE gri_saved_sets gss
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_gss');
--
END del_gss;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HAD_PK constraint
--
PROCEDURE del_had (pi_had_id            hig_address.had_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_had');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_had
                   (pi_had_id            => pi_had_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_address had
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_had');
--
END del_had;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HCO_PK constraint
--
PROCEDURE del_hco (pi_hco_domain        hig_codes.hco_domain%TYPE
                  ,pi_hco_code          hig_codes.hco_code%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hco');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hco
                   (pi_hco_domain        => pi_hco_domain
                   ,pi_hco_code          => pi_hco_code
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_codes hco
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hco');
--
END del_hco;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HCL_PK constraint
--
PROCEDURE del_hcl (pi_hcl_colour        hig_colours.hcl_colour%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hcl');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hcl
                   (pi_hcl_colour        => pi_hcl_colour
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_colours hcl
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hcl');
--
END del_hcl;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HCT_PK constraint
--
PROCEDURE del_hct (pi_hct_id            hig_contacts.hct_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hct');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hct
                   (pi_hct_id            => pi_hct_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_contacts hct
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hct');
--
END del_hct;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HCA_PK constraint
--
PROCEDURE del_hca (pi_hca_hct_id        hig_contact_address.hca_hct_id%TYPE
                  ,pi_hca_had_id        hig_contact_address.hca_had_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hca');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hca
                   (pi_hca_hct_id        => pi_hca_hct_id
                   ,pi_hca_had_id        => pi_hca_had_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_contact_address hca
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hca');
--
END del_hca;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HDO_PK constraint
--
PROCEDURE del_hdo (pi_hdo_domain        hig_domains.hdo_domain%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hdo');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hdo
                   (pi_hdo_domain        => pi_hdo_domain
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_domains hdo
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hdo');
--
END del_hdo;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HER_PK constraint
--
PROCEDURE del_her (pi_her_no            hig_errors.her_no%TYPE
                  ,pi_her_appl          hig_errors.her_appl%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_her');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_her
                   (pi_her_no            => pi_her_no
                   ,pi_her_appl          => pi_her_appl
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_errors her
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_her');
--
END del_her;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HIG_HD_HHT_PK constraint
--
PROCEDURE del_hht (pi_hht_hhu_hhm_module hig_hd_join_defs.hht_hhu_hhm_module%TYPE
                  ,pi_hht_hhu_seq        hig_hd_join_defs.hht_hhu_seq%TYPE
                  ,pi_hht_join_seq       hig_hd_join_defs.hht_join_seq%TYPE
                  ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hht');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hht
                   (pi_hht_hhu_hhm_module => pi_hht_hhu_hhm_module
                   ,pi_hht_hhu_seq        => pi_hht_hhu_seq
                   ,pi_hht_join_seq       => pi_hht_join_seq
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   ,pi_locked_sqlcode     => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_hd_join_defs hht
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hht');
--
END del_hht;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HIG_HD_HHO_PK constraint
--
PROCEDURE del_hho (pi_hho_hhl_hhu_hhm_module hig_hd_lookup_join_cols.hho_hhl_hhu_hhm_module%TYPE
                  ,pi_hho_hhl_hhu_seq        hig_hd_lookup_join_cols.hho_hhl_hhu_seq%TYPE
                  ,pi_hho_hhl_join_seq       hig_hd_lookup_join_cols.hho_hhl_join_seq%TYPE
                  ,pi_hho_parent_col         hig_hd_lookup_join_cols.hho_parent_col%TYPE
                  ,pi_hho_lookup_col         hig_hd_lookup_join_cols.hho_lookup_col%TYPE
                  ,pi_raise_not_found        BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode      PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode         PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hho');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hho
                   (pi_hho_hhl_hhu_hhm_module => pi_hho_hhl_hhu_hhm_module
                   ,pi_hho_hhl_hhu_seq        => pi_hho_hhl_hhu_seq
                   ,pi_hho_hhl_join_seq       => pi_hho_hhl_join_seq
                   ,pi_hho_parent_col         => pi_hho_parent_col
                   ,pi_hho_lookup_col         => pi_hho_lookup_col
                   ,pi_raise_not_found        => pi_raise_not_found
                   ,pi_not_found_sqlcode      => pi_not_found_sqlcode
                   ,pi_locked_sqlcode         => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_hd_lookup_join_cols hho
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hho');
--
END del_hho;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HIG_HD_HHL_PK constraint
--
PROCEDURE del_hhl (pi_hhl_hhu_hhm_module hig_hd_lookup_join_defs.hhl_hhu_hhm_module%TYPE
                  ,pi_hhl_hhu_seq        hig_hd_lookup_join_defs.hhl_hhu_seq%TYPE
                  ,pi_hhl_join_seq       hig_hd_lookup_join_defs.hhl_join_seq%TYPE
                  ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hhl');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hhl
                   (pi_hhl_hhu_hhm_module => pi_hhl_hhu_hhm_module
                   ,pi_hhl_hhu_seq        => pi_hhl_hhu_seq
                   ,pi_hhl_join_seq       => pi_hhl_join_seq
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   ,pi_locked_sqlcode     => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_hd_lookup_join_defs hhl
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hhl');
--
END del_hhl;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HIG_HD_HHM_PK constraint
--
PROCEDURE del_hhm (pi_hhm_module        hig_hd_modules.hhm_module%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hhm');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hhm
                   (pi_hhm_module        => pi_hhm_module
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_hd_modules hhm
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hhm');
--
END del_hhm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HIG_HD_HHU_PK constraint
--
PROCEDURE del_hhu (pi_hhu_hhm_module    hig_hd_mod_uses.hhu_hhm_module%TYPE
                  ,pi_hhu_seq           hig_hd_mod_uses.hhu_seq%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hhu');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hhu
                   (pi_hhu_hhm_module    => pi_hhu_hhm_module
                   ,pi_hhu_seq           => pi_hhu_seq
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_hd_mod_uses hhu
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hhu');
--
END del_hhu;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HIG_HD_HHC_PK constraint
--
PROCEDURE del_hhc (pi_hhc_hhu_hhm_module hig_hd_selected_cols.hhc_hhu_hhm_module%TYPE
                  ,pi_hhc_hhu_seq        hig_hd_selected_cols.hhc_hhu_seq%TYPE
                  ,pi_hhc_column_seq     hig_hd_selected_cols.hhc_column_seq%TYPE
                  ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hhc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hhc
                   (pi_hhc_hhu_hhm_module => pi_hhc_hhu_hhm_module
                   ,pi_hhc_hhu_seq        => pi_hhc_hhu_seq
                   ,pi_hhc_column_seq     => pi_hhc_column_seq
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   ,pi_locked_sqlcode     => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_hd_selected_cols hhc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hhc');
--
END del_hhc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HIG_HD_HHJ_PK constraint
--
PROCEDURE del_hhj (pi_hhj_hht_hhu_hhm_module   hig_hd_table_join_cols.hhj_hht_hhu_hhm_module%TYPE
                  ,pi_hhj_hht_hhu_parent_table hig_hd_table_join_cols.hhj_hht_hhu_parent_table%TYPE
                  ,pi_hhj_hht_join_seq         hig_hd_table_join_cols.hhj_hht_join_seq%TYPE
                  ,pi_hhj_parent_col           hig_hd_table_join_cols.hhj_parent_col%TYPE
                  ,pi_hhj_hhu_child_table      hig_hd_table_join_cols.hhj_hhu_child_table%TYPE
                  ,pi_hhj_child_col            hig_hd_table_join_cols.hhj_child_col%TYPE
                  ,pi_raise_not_found          BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode        PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode           PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hhj');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hhj
                   (pi_hhj_hht_hhu_hhm_module   => pi_hhj_hht_hhu_hhm_module
                   ,pi_hhj_hht_hhu_parent_table => pi_hhj_hht_hhu_parent_table
                   ,pi_hhj_hht_join_seq         => pi_hhj_hht_join_seq
                   ,pi_hhj_parent_col           => pi_hhj_parent_col
                   ,pi_hhj_hhu_child_table      => pi_hhj_hhu_child_table
                   ,pi_hhj_child_col            => pi_hhj_child_col
                   ,pi_raise_not_found          => pi_raise_not_found
                   ,pi_not_found_sqlcode        => pi_not_found_sqlcode
                   ,pi_locked_sqlcode           => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_hd_table_join_cols hhj
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hhj');
--
END del_hhj;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HHO_PK constraint
--
PROCEDURE del_hho (pi_hho_id            hig_holidays.hho_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hho');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hho
                   (pi_hho_id            => pi_hho_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_holidays hho
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hho');
--
END del_hho;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HIG_MODULES_PK constraint
--
PROCEDURE del_hmo (pi_hmo_module        hig_modules.hmo_module%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hmo');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hmo
                   (pi_hmo_module        => pi_hmo_module
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_modules hmo
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hmo');
--
END del_hmo;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HMH_PK constraint
--
PROCEDURE del_hmh (pi_hmh_user_id       hig_module_history.hmh_user_id%TYPE
                  ,pi_hmh_seq_no        hig_module_history.hmh_seq_no%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hmh');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hmh
                   (pi_hmh_user_id       => pi_hmh_user_id
                   ,pi_hmh_seq_no        => pi_hmh_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_module_history hmh
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hmh');
--
END del_hmh;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HMH_UK constraint
--
PROCEDURE del_hmh (pi_hmh_user_id       hig_module_history.hmh_user_id%TYPE
                  ,pi_hmh_module        hig_module_history.hmh_module%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hmh');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hmh
                   (pi_hmh_user_id       => pi_hmh_user_id
                   ,pi_hmh_module        => pi_hmh_module
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_module_history hmh
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hmh');
--
END del_hmh;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HMK_PK constraint
--
PROCEDURE del_hmk (pi_hmk_hmo_module    hig_module_keywords.hmk_hmo_module%TYPE
                  ,pi_hmk_keyword       hig_module_keywords.hmk_keyword%TYPE
                  ,pi_hmk_owner         hig_module_keywords.hmk_owner%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hmk');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hmk
                   (pi_hmk_hmo_module    => pi_hmk_hmo_module
                   ,pi_hmk_keyword       => pi_hmk_keyword
                   ,pi_hmk_owner         => pi_hmk_owner
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_module_keywords hmk
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hmk');
--
END del_hmk;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HMR_PK constraint
--
PROCEDURE del_hmr (pi_hmr_module        hig_module_roles.hmr_module%TYPE
                  ,pi_hmr_role          hig_module_roles.hmr_role%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hmr');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hmr
                   (pi_hmr_module        => pi_hmr_module
                   ,pi_hmr_role          => pi_hmr_role
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_module_roles hmr
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hmr');
--
END del_hmr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HMU_PK constraint
--
PROCEDURE del_hmu (pi_hmu_module        hig_module_usages.hmu_module%TYPE
                  ,pi_hmu_usage         hig_module_usages.hmu_usage%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hmu');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hmu
                   (pi_hmu_module        => pi_hmu_module
                   ,pi_hmu_usage         => pi_hmu_usage
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_module_usages hmu
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hmu');
--
END del_hmu;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HOL_PK constraint
--
PROCEDURE del_hol (pi_hol_id            hig_option_list.hol_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hol');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hol
                   (pi_hol_id            => pi_hol_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_option_list hol
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hol');
--
END del_hol;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HOV_PK constraint
--
PROCEDURE del_hov (pi_hov_id            hig_option_values.hov_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hov');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hov
                   (pi_hov_id            => pi_hov_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_option_values hov
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hov');
--
END del_hov;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HPR_PK constraint
--
PROCEDURE del_hpr (pi_hpr_product       hig_products.hpr_product%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hpr');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hpr
                   (pi_hpr_product       => pi_hpr_product
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_products hpr
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hpr');
--
END del_hpr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HPR_UK1 constraint
--
PROCEDURE del_hpr (pi_hpr_product_name  hig_products.hpr_product_name%TYPE
                  ,pi_hpr_version       hig_products.hpr_version%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hpr');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hpr
                   (pi_hpr_product_name  => pi_hpr_product_name
                   ,pi_hpr_version       => pi_hpr_version
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_products hpr
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hpr');
--
END del_hpr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HRS_PK constraint
--
PROCEDURE del_hrs (pi_hrs_style_name    hig_report_styles.hrs_style_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hrs');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hrs
                   (pi_hrs_style_name    => pi_hrs_style_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_report_styles hrs
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hrs');
--
END del_hrs;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HIG_ROLES_PK constraint
--
PROCEDURE del_hro (pi_hro_role          hig_roles.hro_role%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hro');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hro
                   (pi_hro_role          => pi_hro_role
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_roles hro
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hro');
--
END del_hro;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HSC_PK constraint
--
PROCEDURE del_hsc (pi_hsc_domain_code   hig_status_codes.hsc_domain_code%TYPE
                  ,pi_hsc_status_code   hig_status_codes.hsc_status_code%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hsc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hsc
                   (pi_hsc_domain_code   => pi_hsc_domain_code
                   ,pi_hsc_status_code   => pi_hsc_status_code
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_status_codes hsc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hsc');
--
END del_hsc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HSC_UK1 constraint
--
PROCEDURE del_hsc (pi_hsc_domain_code   hig_status_codes.hsc_domain_code%TYPE
                  ,pi_hsc_status_name   hig_status_codes.hsc_status_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hsc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hsc
                   (pi_hsc_domain_code   => pi_hsc_domain_code
                   ,pi_hsc_status_name   => pi_hsc_status_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_status_codes hsc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hsc');
--
END del_hsc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HSD_PK constraint
--
PROCEDURE del_hsd (pi_hsd_domain_code   hig_status_domains.hsd_domain_code%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hsd');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hsd
                   (pi_hsd_domain_code   => pi_hsd_domain_code
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_status_domains hsd
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hsd');
--
END del_hsd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HUP_PK constraint
--
PROCEDURE del_hup (pi_hup_product       hig_upgrades.hup_product%TYPE
                  ,pi_date_upgraded     hig_upgrades.date_upgraded%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hup');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hup
                   (pi_hup_product       => pi_hup_product
                   ,pi_date_upgraded     => pi_date_upgraded
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_upgrades hup
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hup');
--
END del_hup;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HUM_PK constraint
--
PROCEDURE del_hum (pi_hum_hmo_module    hig_url_modules.hum_hmo_module%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hum');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hum
                   (pi_hum_hmo_module    => pi_hum_hmo_module
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_url_modules hum
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hum');
--
END del_hum;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HIG_USERS_PK constraint
--
PROCEDURE del_hus (pi_hus_user_id       hig_users.hus_user_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hus');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hus
                   (pi_hus_user_id       => pi_hus_user_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_users hus
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hus');
--
END del_hus;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HUS_UK constraint
--
PROCEDURE del_hus (pi_hus_username      hig_users.hus_username%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hus');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hus
                   (pi_hus_username      => pi_hus_username
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_users hus
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hus');
--
END del_hus;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HUH_PK constraint
--
PROCEDURE del_huh (pi_huh_user_id       hig_user_history.huh_user_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_huh');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_huh
                   (pi_huh_user_id       => pi_huh_user_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_user_history huh
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_huh');
--
END del_huh;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HUO_PK constraint
--
PROCEDURE del_huo (pi_huo_hus_user_id   hig_user_options.huo_hus_user_id%TYPE
                  ,pi_huo_id            hig_user_options.huo_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_huo');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_huo
                   (pi_huo_hus_user_id   => pi_huo_hus_user_id
                   ,pi_huo_id            => pi_huo_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_user_options huo
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_huo');
--
END del_huo;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HUR_PK constraint
--
PROCEDURE del_hur (pi_hur_username      hig_user_roles.hur_username%TYPE
                  ,pi_hur_role          hig_user_roles.hur_role%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_hur');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_hur
                   (pi_hur_username      => pi_hur_username
                   ,pi_hur_role          => pi_hur_role
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE hig_user_roles hur
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_hur');
--
END del_hur;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HAG_PK constraint
--
PROCEDURE del_nag (pi_nag_parent_admin_unit nm_admin_groups.nag_parent_admin_unit%TYPE
                  ,pi_nag_child_admin_unit  nm_admin_groups.nag_child_admin_unit%TYPE
                  ,pi_raise_not_found       BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode     PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode        PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nag');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nag
                   (pi_nag_parent_admin_unit => pi_nag_parent_admin_unit
                   ,pi_nag_child_admin_unit  => pi_nag_child_admin_unit
                   ,pi_raise_not_found       => pi_raise_not_found
                   ,pi_not_found_sqlcode     => pi_not_found_sqlcode
                   ,pi_locked_sqlcode        => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_admin_groups nag
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nag');
--
END del_nag;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HAU_PK constraint
--
PROCEDURE del_nau (pi_nau_admin_unit    nm_admin_units.nau_admin_unit%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nau');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nau
                   (pi_nau_admin_unit    => pi_nau_admin_unit
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_admin_units nau
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nau');
--
END del_nau;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HAU_UK2 constraint
--
PROCEDURE del_nau (pi_nau_name          nm_admin_units.nau_name%TYPE
                  ,pi_nau_admin_type    nm_admin_units.nau_admin_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nau');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nau
                   (pi_nau_name          => pi_nau_name
                   ,pi_nau_admin_type    => pi_nau_admin_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_admin_units nau
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nau');
--
END del_nau;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HAU_UK1 constraint
--
PROCEDURE del_nau (pi_nau_unit_code     nm_admin_units.nau_unit_code%TYPE
                  ,pi_nau_admin_type    nm_admin_units.nau_admin_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nau');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nau
                   (pi_nau_unit_code     => pi_nau_unit_code
                   ,pi_nau_admin_type    => pi_nau_admin_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_admin_units nau
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nau');
--
END del_nau;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HAU_PK constraint
--
PROCEDURE del_nau_all (pi_nau_admin_unit    nm_admin_units_all.nau_admin_unit%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nau_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nau_all
                   (pi_nau_admin_unit    => pi_nau_admin_unit
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_admin_units_all nau_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nau_all');
--
END del_nau_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HAU_UK2 constraint
--
PROCEDURE del_nau_all (pi_nau_name          nm_admin_units_all.nau_name%TYPE
                      ,pi_nau_admin_type    nm_admin_units_all.nau_admin_type%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nau_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nau_all
                   (pi_nau_name          => pi_nau_name
                   ,pi_nau_admin_type    => pi_nau_admin_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_admin_units_all nau_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nau_all');
--
END del_nau_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HAU_UK1 constraint
--
PROCEDURE del_nau_all (pi_nau_unit_code     nm_admin_units_all.nau_unit_code%TYPE
                      ,pi_nau_admin_type    nm_admin_units_all.nau_admin_type%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nau_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nau_all
                   (pi_nau_unit_code     => pi_nau_unit_code
                   ,pi_nau_admin_type    => pi_nau_admin_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_admin_units_all nau_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nau_all');
--
END del_nau_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NAL_PK constraint
--
PROCEDURE del_nal (pi_nal_id            nm_area_lock.nal_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nal');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nal
                   (pi_nal_id            => pi_nal_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_area_lock nal
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nal');
--
END del_nal;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NARS_PK constraint
--
PROCEDURE del_nars (pi_nars_job_id         nm_assets_on_route_store.nars_job_id%TYPE
                   ,pi_nars_ne_id_in       nm_assets_on_route_store.nars_ne_id_in%TYPE
                   ,pi_nars_ne_id_of_begin nm_assets_on_route_store.nars_ne_id_of_begin%TYPE
                   ,pi_nars_begin_mp       nm_assets_on_route_store.nars_begin_mp%TYPE
                   ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nars');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nars
                   (pi_nars_job_id         => pi_nars_job_id
                   ,pi_nars_ne_id_in       => pi_nars_ne_id_in
                   ,pi_nars_ne_id_of_begin => pi_nars_ne_id_of_begin
                   ,pi_nars_begin_mp       => pi_nars_begin_mp
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   ,pi_locked_sqlcode      => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_assets_on_route_store nars
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nars');
--
END del_nars;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NARSA_PK constraint
--
PROCEDURE del_narsa (pi_narsa_job_id      nm_assets_on_route_store_att.narsa_job_id%TYPE
                    ,pi_narsa_iit_ne_id   nm_assets_on_route_store_att.narsa_iit_ne_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_narsa');
--
   -- No lock procedure - a temporary table
   DELETE /*+ INDEX (narsa NARSA_PK) */ nm_assets_on_route_store_att narsa
   WHERE  narsa.narsa_job_id    = pi_narsa_job_id
    AND   narsa.narsa_iit_ne_id = pi_narsa_iit_ne_id;
   IF SQL%ROWCOUNT = 0 AND pi_raise_not_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_assets_on_route_store_att (NARSA_PK)'
                                              ||CHR(10)||'narsa_job_id    => '||pi_narsa_job_id
                                              ||CHR(10)||'narsa_iit_ne_id => '||pi_narsa_iit_ne_id
                    );
   END IF;
--
--
   nm_debug.proc_end(g_package_name,'del_narsa');
--
END del_narsa;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NARSD_PK constraint
--
PROCEDURE del_narsd (pi_narsd_job_id      nm_assets_on_route_store_att_d.narsd_job_id%TYPE
                    ,pi_narsd_iit_ne_id   nm_assets_on_route_store_att_d.narsd_iit_ne_id%TYPE
                    ,pi_narsd_attrib_name nm_assets_on_route_store_att_d.narsd_attrib_name%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_narsd');
--
   -- No lock procedure - a temporary table
   DELETE /*+ INDEX (narsd NARSD_PK) */ nm_assets_on_route_store_att_d narsd
   WHERE  narsd.narsd_job_id      = pi_narsd_job_id
    AND   narsd.narsd_iit_ne_id   = pi_narsd_iit_ne_id
    AND   narsd.narsd_attrib_name = pi_narsd_attrib_name;
   IF SQL%ROWCOUNT = 0 AND pi_raise_not_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_assets_on_route_store_att_d (NARSD_PK)'
                                              ||CHR(10)||'narsd_job_id      => '||pi_narsd_job_id
                                              ||CHR(10)||'narsd_iit_ne_id   => '||pi_narsd_iit_ne_id
                                              ||CHR(10)||'narsd_attrib_name => '||pi_narsd_attrib_name
                    );
   END IF;
--
--
   nm_debug.proc_end(g_package_name,'del_narsd');
--
END del_narsd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NARSH_PK constraint
--
PROCEDURE del_narsh (pi_narsh_job_id      nm_assets_on_route_store_head.narsh_job_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_narsh');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_narsh
                   (pi_narsh_job_id      => pi_narsh_job_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_assets_on_route_store_head narsh
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_narsh');
--
END del_narsh;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NARST_PK constraint
--
PROCEDURE del_narst (pi_narst_inv_type    nm_assets_on_route_store_total.narst_inv_type%TYPE
                    ,pi_narst_job_id      nm_assets_on_route_store_total.narst_job_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_narst');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_narst
                   (pi_narst_inv_type    => pi_narst_inv_type
                   ,pi_narst_job_id      => pi_narst_job_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_assets_on_route_store_total narst
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_narst');
--
END del_narst;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NM_AUDIT_PK constraint
--
PROCEDURE del_naa (pi_na_audit_id       nm_audit_actions.na_audit_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_naa');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_naa
                   (pi_na_audit_id       => pi_na_audit_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_audit_actions naa
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_naa');
--
END del_naa;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NACH_PK constraint
--
PROCEDURE del_nach (pi_nach_audit_id     nm_audit_changes.nach_audit_id%TYPE
                   ,pi_nach_column_id    nm_audit_changes.nach_column_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nach');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nach
                   (pi_nach_audit_id     => pi_nach_audit_id
                   ,pi_nach_column_id    => pi_nach_column_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_audit_changes nach
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nach');
--
END del_nach;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NM_AUDIT_COLUMNS_PK constraint
--
PROCEDURE del_nac (pi_nac_column_id     nm_audit_columns.nac_column_id%TYPE
                  ,pi_nac_table_name    nm_audit_columns.nac_table_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nac');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nac
                   (pi_nac_column_id     => pi_nac_column_id
                   ,pi_nac_table_name    => pi_nac_table_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_audit_columns nac
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nac');
--
END del_nac;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NM_AUDIT_KEY_COLS_PK constraint
--
PROCEDURE del_nkc (pi_nkc_seq_no        nm_audit_key_cols.nkc_seq_no%TYPE
                  ,pi_nkc_table_name    nm_audit_key_cols.nkc_table_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nkc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nkc
                   (pi_nkc_seq_no        => pi_nkc_seq_no
                   ,pi_nkc_table_name    => pi_nkc_table_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_audit_key_cols nkc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nkc');
--
END del_nkc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NM_AUDIT_TABLES_PK constraint
--
PROCEDURE del_natab (pi_nat_table_name    nm_audit_tables.nat_table_name%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_natab');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_natab
                   (pi_nat_table_name    => pi_nat_table_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_audit_tables natab
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_natab');
--
END del_natab;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NM_AUDIT_TEMP_PK constraint
--
PROCEDURE del_natmp (pi_nat_audit_id      nm_audit_temp.nat_audit_id%TYPE
                    ,pi_nat_old_or_new    nm_audit_temp.nat_old_or_new%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_natmp');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_natmp
                   (pi_nat_audit_id      => pi_nat_audit_id
                   ,pi_nat_old_or_new    => pi_nat_old_or_new
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_audit_temp natmp
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_natmp');
--
END del_natmp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NAT_PK constraint
--
PROCEDURE del_nat (pi_nat_admin_type    nm_au_types.nat_admin_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nat');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nat
                   (pi_nat_admin_type    => pi_nat_admin_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_au_types nat
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nat');
--
END del_nat;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NSTY_PK constraint
--
PROCEDURE del_nsty (pi_nsty_id           nm_au_sub_types.nsty_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nsty');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nsty
                   (pi_nsty_id           => pi_nsty_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_au_sub_types nsty
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nsty');
--
END del_nsty;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NSTY_UK1 constraint
--
PROCEDURE del_nsty (pi_nsty_nat_admin_type nm_au_sub_types.nsty_nat_admin_type%TYPE
                   ,pi_nsty_sub_type       nm_au_sub_types.nsty_sub_type%TYPE
                   ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nsty');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nsty
                   (pi_nsty_nat_admin_type => pi_nsty_nat_admin_type
                   ,pi_nsty_sub_type       => pi_nsty_sub_type
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   ,pi_locked_sqlcode      => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_au_sub_types nsty
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nsty');
--
END del_nsty;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NATG_PK constraint
--
PROCEDURE del_natg (pi_natg_nat_admin_type nm_au_types_groupings.natg_nat_admin_type%TYPE
                   ,pi_natg_grouping       nm_au_types_groupings.natg_grouping%TYPE
                   ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_natg');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_natg
                   (pi_natg_nat_admin_type => pi_natg_nat_admin_type
                   ,pi_natg_grouping       => pi_natg_grouping
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   ,pi_locked_sqlcode      => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_au_types_groupings natg
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_natg');
--
END del_natg;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using ND_PK constraint
--
PROCEDURE del_nd (pi_nd_id             nm_dbug.nd_id%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nd');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nd
                   (pi_nd_id             => pi_nd_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_dbug nd
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nd');
--
END del_nd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NE_PK constraint
--
PROCEDURE del_ne (pi_ne_id             nm_elements.ne_id%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ne');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ne
                   (pi_ne_id             => pi_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_elements ne
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ne');
--
END del_ne;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NE_UK constraint
--
PROCEDURE del_ne (pi_ne_unique         nm_elements.ne_unique%TYPE
                 ,pi_ne_nt_type        nm_elements.ne_nt_type%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ne');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ne
                   (pi_ne_unique         => pi_ne_unique
                   ,pi_ne_nt_type        => pi_ne_nt_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_elements ne
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ne');
--
END del_ne;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NE_PK constraint
--
PROCEDURE del_ne_all (pi_ne_id             nm_elements_all.ne_id%TYPE
                     ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                     ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                     ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                     ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ne_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ne_all
                   (pi_ne_id             => pi_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_elements_all ne_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ne_all');
--
END del_ne_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NE_UK constraint
--
PROCEDURE del_ne_all (pi_ne_unique         nm_elements_all.ne_unique%TYPE
                     ,pi_ne_nt_type        nm_elements_all.ne_nt_type%TYPE
                     ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                     ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                     ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                     ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ne_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ne_all
                   (pi_ne_unique         => pi_ne_unique
                   ,pi_ne_nt_type        => pi_ne_nt_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_elements_all ne_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ne_all');
--
END del_ne_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NEH_PK constraint
--
PROCEDURE del_neh (pi_neh_id            nm_element_history.neh_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_neh');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_neh
                   (pi_neh_id            => pi_neh_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_element_history neh
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_neh');
--
END del_neh;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NER_PK constraint
--
PROCEDURE del_ner (pi_ner_id            nm_errors.ner_id%TYPE
                  ,pi_ner_appl          nm_errors.ner_appl%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ner');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ner
                   (pi_ner_id            => pi_ner_id
                   ,pi_ner_appl          => pi_ner_appl
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_errors ner
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ner');
--
END del_ner;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NEL_PK constraint
--
PROCEDURE del_nel (pi_nel_id            nm_event_log.nel_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nel');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nel
                   (pi_nel_id            => pi_nel_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_event_log nel
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nel');
--
END del_nel;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NET_PK constraint
--
PROCEDURE del_net (pi_net_type          nm_event_types.net_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_net');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_net
                   (pi_net_type          => pi_net_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_event_types net
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_net');
--
END del_net;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NET_UK constraint
--
PROCEDURE del_net (pi_net_unique        nm_event_types.net_unique%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_net');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_net
                   (pi_net_unique        => pi_net_unique
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_event_types net
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_net');
--
END del_net;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NFP_PK constraint
--
PROCEDURE del_nfp (pi_nfp_id            nm_fill_patterns.nfp_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nfp');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nfp
                   (pi_nfp_id            => pi_nfp_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_fill_patterns nfp
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nfp');
--
END del_nfp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NGQ_PK constraint
--
PROCEDURE del_ngq (pi_ngq_id            nm_gaz_query.ngq_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ngq');
--
   -- No lock procedure - a temporary table
   DELETE /*+ INDEX (ngq NGQ_PK) */ nm_gaz_query ngq
   WHERE  ngq.ngq_id = pi_ngq_id;
   IF SQL%ROWCOUNT = 0 AND pi_raise_not_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_gaz_query (NGQ_PK)'
                                              ||CHR(10)||'ngq_id => '||pi_ngq_id
                    );
   END IF;
--
--
   nm_debug.proc_end(g_package_name,'del_ngq');
--
END del_ngq;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NGQT_PK constraint
--
PROCEDURE del_ngqt (pi_ngqt_ngq_id       nm_gaz_query_types.ngqt_ngq_id%TYPE
                   ,pi_ngqt_seq_no       nm_gaz_query_types.ngqt_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ngqt');
--
   -- No lock procedure - a temporary table
   DELETE /*+ INDEX (ngqt NGQT_PK) */ nm_gaz_query_types ngqt
   WHERE  ngqt.ngqt_ngq_id = pi_ngqt_ngq_id
    AND   ngqt.ngqt_seq_no = pi_ngqt_seq_no;
   IF SQL%ROWCOUNT = 0 AND pi_raise_not_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_gaz_query_types (NGQT_PK)'
                                              ||CHR(10)||'ngqt_ngq_id => '||pi_ngqt_ngq_id
                                              ||CHR(10)||'ngqt_seq_no => '||pi_ngqt_seq_no
                    );
   END IF;
--
--
   nm_debug.proc_end(g_package_name,'del_ngqt');
--
END del_ngqt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NGQA_PK constraint
--
PROCEDURE del_ngqa (pi_ngqa_ngq_id       nm_gaz_query_attribs.ngqa_ngq_id%TYPE
                   ,pi_ngqa_ngqt_seq_no  nm_gaz_query_attribs.ngqa_ngqt_seq_no%TYPE
                   ,pi_ngqa_seq_no       nm_gaz_query_attribs.ngqa_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ngqa');
--
   -- No lock procedure - a temporary table
   DELETE /*+ INDEX (ngqa NGQA_PK) */ nm_gaz_query_attribs ngqa
   WHERE  ngqa.ngqa_ngq_id      = pi_ngqa_ngq_id
    AND   ngqa.ngqa_ngqt_seq_no = pi_ngqa_ngqt_seq_no
    AND   ngqa.ngqa_seq_no      = pi_ngqa_seq_no;
   IF SQL%ROWCOUNT = 0 AND pi_raise_not_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_gaz_query_attribs (NGQA_PK)'
                                              ||CHR(10)||'ngqa_ngq_id      => '||pi_ngqa_ngq_id
                                              ||CHR(10)||'ngqa_ngqt_seq_no => '||pi_ngqa_ngqt_seq_no
                                              ||CHR(10)||'ngqa_seq_no      => '||pi_ngqa_seq_no
                    );
   END IF;
--
--
   nm_debug.proc_end(g_package_name,'del_ngqa');
--
END del_ngqa;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NGQV_PK constraint
--
PROCEDURE del_ngqv (pi_ngqv_ngq_id       nm_gaz_query_values.ngqv_ngq_id%TYPE
                   ,pi_ngqv_ngqt_seq_no  nm_gaz_query_values.ngqv_ngqt_seq_no%TYPE
                   ,pi_ngqv_ngqa_seq_no  nm_gaz_query_values.ngqv_ngqa_seq_no%TYPE
                   ,pi_ngqv_sequence     nm_gaz_query_values.ngqv_sequence%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ngqv');
--
   -- No lock procedure - a temporary table
   DELETE /*+ INDEX (ngqv NGQV_PK) */ nm_gaz_query_values ngqv
   WHERE  ngqv.ngqv_ngq_id      = pi_ngqv_ngq_id
    AND   ngqv.ngqv_ngqt_seq_no = pi_ngqv_ngqt_seq_no
    AND   ngqv.ngqv_ngqa_seq_no = pi_ngqv_ngqa_seq_no
    AND   ngqv.ngqv_sequence    = pi_ngqv_sequence;
   IF SQL%ROWCOUNT = 0 AND pi_raise_not_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_gaz_query_values (NGQV_PK)'
                                              ||CHR(10)||'ngqv_ngq_id      => '||pi_ngqv_ngq_id
                                              ||CHR(10)||'ngqv_ngqt_seq_no => '||pi_ngqv_ngqt_seq_no
                                              ||CHR(10)||'ngqv_ngqa_seq_no => '||pi_ngqv_ngqa_seq_no
                                              ||CHR(10)||'ngqv_sequence    => '||pi_ngqv_sequence
                    );
   END IF;
--
--
   nm_debug.proc_end(g_package_name,'del_ngqv');
--
END del_ngqv;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NGIT_PK constraint
--
PROCEDURE del_ngit (pi_ngit_ngt_group_type nm_group_inv_types.ngit_ngt_group_type%TYPE
                   ,pi_ngit_nit_inv_type   nm_group_inv_types.ngit_nit_inv_type%TYPE
                   ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ngit');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ngit
                   (pi_ngit_ngt_group_type => pi_ngit_ngt_group_type
                   ,pi_ngit_nit_inv_type   => pi_ngit_nit_inv_type
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   ,pi_locked_sqlcode      => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_group_inv_types ngit
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ngit');
--
END del_ngit;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NGIT_UK constraint
--
PROCEDURE del_ngit (pi_ngit_ngt_group_type nm_group_inv_types.ngit_ngt_group_type%TYPE
                   ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ngit');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ngit
                   (pi_ngit_ngt_group_type => pi_ngit_ngt_group_type
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   ,pi_locked_sqlcode      => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_group_inv_types ngit
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ngit');
--
END del_ngit;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NGIL_PK constraint
--
PROCEDURE del_ngil (pi_ngil_ne_ne_id     nm_group_inv_link.ngil_ne_ne_id%TYPE
                   ,pi_ngil_iit_ne_id    nm_group_inv_link.ngil_iit_ne_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ngil');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ngil
                   (pi_ngil_ne_ne_id     => pi_ngil_ne_ne_id
                   ,pi_ngil_iit_ne_id    => pi_ngil_iit_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_group_inv_link ngil
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ngil');
--
END del_ngil;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NGIL_UK constraint
--
PROCEDURE del_ngil (pi_ngil_ne_ne_id     nm_group_inv_link.ngil_ne_ne_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ngil');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ngil
                   (pi_ngil_ne_ne_id     => pi_ngil_ne_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_group_inv_link ngil
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ngil');
--
END del_ngil;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NGIL_PK constraint
--
PROCEDURE del_ngil_all (pi_ngil_ne_ne_id     nm_group_inv_link_all.ngil_ne_ne_id%TYPE
                       ,pi_ngil_iit_ne_id    nm_group_inv_link_all.ngil_iit_ne_id%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ngil_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ngil_all
                   (pi_ngil_ne_ne_id     => pi_ngil_ne_ne_id
                   ,pi_ngil_iit_ne_id    => pi_ngil_iit_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_group_inv_link_all ngil_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ngil_all');
--
END del_ngil_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NGIL_UK constraint
--
PROCEDURE del_ngil_all (pi_ngil_ne_ne_id     nm_group_inv_link_all.ngil_ne_ne_id%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ngil_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ngil_all
                   (pi_ngil_ne_ne_id     => pi_ngil_ne_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_group_inv_link_all ngil_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ngil_all');
--
END del_ngil_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NGR_PK constraint
--
PROCEDURE del_ngr (pi_ngr_parent_group_type nm_group_relations.ngr_parent_group_type%TYPE
                  ,pi_ngr_child_group_type  nm_group_relations.ngr_child_group_type%TYPE
                  ,pi_ngr_start_date        nm_group_relations.ngr_start_date%TYPE
                  ,pi_raise_not_found       BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode     PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode        PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ngr');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ngr
                   (pi_ngr_parent_group_type => pi_ngr_parent_group_type
                   ,pi_ngr_child_group_type  => pi_ngr_child_group_type
                   ,pi_ngr_start_date        => pi_ngr_start_date
                   ,pi_raise_not_found       => pi_raise_not_found
                   ,pi_not_found_sqlcode     => pi_not_found_sqlcode
                   ,pi_locked_sqlcode        => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_group_relations ngr
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ngr');
--
END del_ngr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NGR_PK constraint (without start date for Datetrack View)
--
PROCEDURE del_ngr (pi_ngr_parent_group_type nm_group_relations.ngr_parent_group_type%TYPE
                  ,pi_ngr_child_group_type  nm_group_relations.ngr_child_group_type%TYPE
                  ,pi_raise_not_found       BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode     PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode        PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ngr');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ngr
                   (pi_ngr_parent_group_type => pi_ngr_parent_group_type
                   ,pi_ngr_child_group_type  => pi_ngr_child_group_type
                   ,pi_raise_not_found       => pi_raise_not_found
                   ,pi_not_found_sqlcode     => pi_not_found_sqlcode
                   ,pi_locked_sqlcode        => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_group_relations ngr
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ngr');
--
END del_ngr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NGR_PK constraint
--
PROCEDURE del_ngr_all (pi_ngr_parent_group_type nm_group_relations_all.ngr_parent_group_type%TYPE
                      ,pi_ngr_child_group_type  nm_group_relations_all.ngr_child_group_type%TYPE
                      ,pi_ngr_start_date        nm_group_relations_all.ngr_start_date%TYPE
                      ,pi_raise_not_found       BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode     PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode        PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ngr_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ngr_all
                   (pi_ngr_parent_group_type => pi_ngr_parent_group_type
                   ,pi_ngr_child_group_type  => pi_ngr_child_group_type
                   ,pi_ngr_start_date        => pi_ngr_start_date
                   ,pi_raise_not_found       => pi_raise_not_found
                   ,pi_not_found_sqlcode     => pi_not_found_sqlcode
                   ,pi_locked_sqlcode        => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_group_relations_all ngr_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ngr_all');
--
END del_ngr_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NGT_PK constraint
--
PROCEDURE del_ngt (pi_ngt_group_type    nm_group_types.ngt_group_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ngt');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ngt
                   (pi_ngt_group_type    => pi_ngt_group_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_group_types ngt
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ngt');
--
END del_ngt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NGT_PK constraint
--
PROCEDURE del_ngt_all (pi_ngt_group_type    nm_group_types_all.ngt_group_type%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ngt_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ngt_all
                   (pi_ngt_group_type    => pi_ngt_group_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_group_types_all ngt_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ngt_all');
--
END del_ngt_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using IAL_PK constraint
--
PROCEDURE del_ial (pi_ial_domain        nm_inv_attri_lookup.ial_domain%TYPE
                  ,pi_ial_value         nm_inv_attri_lookup.ial_value%TYPE
                  ,pi_ial_start_date    nm_inv_attri_lookup.ial_start_date%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ial');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ial
                   (pi_ial_domain        => pi_ial_domain
                   ,pi_ial_value         => pi_ial_value
                   ,pi_ial_start_date    => pi_ial_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_attri_lookup ial
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ial');
--
END del_ial;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using IAL_PK constraint (without start date for Datetrack View)
--
PROCEDURE del_ial (pi_ial_domain        nm_inv_attri_lookup.ial_domain%TYPE
                  ,pi_ial_value         nm_inv_attri_lookup.ial_value%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ial');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ial
                   (pi_ial_domain        => pi_ial_domain
                   ,pi_ial_value         => pi_ial_value
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_attri_lookup ial
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ial');
--
END del_ial;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using IAL_PK constraint
--
PROCEDURE del_ial_all (pi_ial_domain        nm_inv_attri_lookup_all.ial_domain%TYPE
                      ,pi_ial_value         nm_inv_attri_lookup_all.ial_value%TYPE
                      ,pi_ial_start_date    nm_inv_attri_lookup_all.ial_start_date%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ial_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ial_all
                   (pi_ial_domain        => pi_ial_domain
                   ,pi_ial_value         => pi_ial_value
                   ,pi_ial_start_date    => pi_ial_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_attri_lookup_all ial_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ial_all');
--
END del_ial_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NIC_PK constraint
--
PROCEDURE del_nic (pi_nic_category      nm_inv_categories.nic_category%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nic');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nic
                   (pi_nic_category      => pi_nic_category
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_categories nic
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nic');
--
END del_nic;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using ICM_PK constraint
--
PROCEDURE del_icm (pi_icm_nic_category  nm_inv_category_modules.icm_nic_category%TYPE
                  ,pi_icm_hmo_module    nm_inv_category_modules.icm_hmo_module%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_icm');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_icm
                   (pi_icm_nic_category  => pi_icm_nic_category
                   ,pi_icm_hmo_module    => pi_icm_hmo_module
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_category_modules icm
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_icm');
--
END del_icm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using ID_PK constraint
--
PROCEDURE del_id (pi_id_domain         nm_inv_domains.id_domain%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_id');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_id
                   (pi_id_domain         => pi_id_domain
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_domains id
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_id');
--
END del_id;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using ID_PK constraint
--
PROCEDURE del_id_all (pi_id_domain         nm_inv_domains_all.id_domain%TYPE
                     ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                     ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                     ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                     ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_id_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_id_all
                   (pi_id_domain         => pi_id_domain
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_domains_all id_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_id_all');
--
END del_id_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using INV_ITEMS_ALL_PK constraint
--
PROCEDURE del_iit (pi_iit_ne_id         nm_inv_items.iit_ne_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_iit');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_iit
                   (pi_iit_ne_id         => pi_iit_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_items iit
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_iit');
--
END del_iit;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using IIT_UK constraint
--
PROCEDURE del_iit (pi_iit_primary_key   nm_inv_items.iit_primary_key%TYPE
                  ,pi_iit_inv_type      nm_inv_items.iit_inv_type%TYPE
                  ,pi_iit_start_date    nm_inv_items.iit_start_date%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_iit');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_iit
                   (pi_iit_primary_key   => pi_iit_primary_key
                   ,pi_iit_inv_type      => pi_iit_inv_type
                   ,pi_iit_start_date    => pi_iit_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_items iit
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_iit');
--
END del_iit;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using IIT_UK constraint (without start date for Datetrack View)
--
PROCEDURE del_iit (pi_iit_primary_key   nm_inv_items.iit_primary_key%TYPE
                  ,pi_iit_inv_type      nm_inv_items.iit_inv_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_iit');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_iit
                   (pi_iit_primary_key   => pi_iit_primary_key
                   ,pi_iit_inv_type      => pi_iit_inv_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_items iit
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_iit');
--
END del_iit;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using INV_ITEMS_ALL_PK constraint
--
PROCEDURE del_iit_all (pi_iit_ne_id         nm_inv_items_all.iit_ne_id%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_iit_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_iit_all
                   (pi_iit_ne_id         => pi_iit_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_items_all iit_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_iit_all');
--
END del_iit_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using IIT_UK constraint
--
PROCEDURE del_iit_all (pi_iit_primary_key   nm_inv_items_all.iit_primary_key%TYPE
                      ,pi_iit_inv_type      nm_inv_items_all.iit_inv_type%TYPE
                      ,pi_iit_start_date    nm_inv_items_all.iit_start_date%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_iit_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_iit_all
                   (pi_iit_primary_key   => pi_iit_primary_key
                   ,pi_iit_inv_type      => pi_iit_inv_type
                   ,pi_iit_start_date    => pi_iit_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_items_all iit_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_iit_all');
--
END del_iit_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using IIG_PK constraint
--
PROCEDURE del_iig (pi_iig_item_id       nm_inv_item_groupings.iig_item_id%TYPE
                  ,pi_iig_parent_id     nm_inv_item_groupings.iig_parent_id%TYPE
                  ,pi_iig_start_date    nm_inv_item_groupings.iig_start_date%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_iig');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_iig
                   (pi_iig_item_id       => pi_iig_item_id
                   ,pi_iig_parent_id     => pi_iig_parent_id
                   ,pi_iig_start_date    => pi_iig_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_item_groupings iig
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_iig');
--
END del_iig;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using IIG_PK constraint (without start date for Datetrack View)
--
PROCEDURE del_iig (pi_iig_item_id       nm_inv_item_groupings.iig_item_id%TYPE
                  ,pi_iig_parent_id     nm_inv_item_groupings.iig_parent_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_iig');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_iig
                   (pi_iig_item_id       => pi_iig_item_id
                   ,pi_iig_parent_id     => pi_iig_parent_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_item_groupings iig
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_iig');
--
END del_iig;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using IIG_PK constraint
--
PROCEDURE del_iig_all (pi_iig_item_id       nm_inv_item_groupings_all.iig_item_id%TYPE
                      ,pi_iig_parent_id     nm_inv_item_groupings_all.iig_parent_id%TYPE
                      ,pi_iig_start_date    nm_inv_item_groupings_all.iig_start_date%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_iig_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_iig_all
                   (pi_iig_item_id       => pi_iig_item_id
                   ,pi_iig_parent_id     => pi_iig_parent_id
                   ,pi_iig_start_date    => pi_iig_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_item_groupings_all iig_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_iig_all');
--
END del_iig_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NIN_PK constraint
--
PROCEDURE del_nin (pi_nin_nit_inv_code  nm_inv_nw.nin_nit_inv_code%TYPE
                  ,pi_nin_nw_type       nm_inv_nw.nin_nw_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nin');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nin
                   (pi_nin_nit_inv_code  => pi_nin_nit_inv_code
                   ,pi_nin_nw_type       => pi_nin_nw_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_nw nin
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nin');
--
END del_nin;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NIN_PK constraint
--
PROCEDURE del_nin_all (pi_nin_nit_inv_code  nm_inv_nw_all.nin_nit_inv_code%TYPE
                      ,pi_nin_nw_type       nm_inv_nw_all.nin_nw_type%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nin_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nin_all
                   (pi_nin_nit_inv_code  => pi_nin_nit_inv_code
                   ,pi_nin_nw_type       => pi_nin_nw_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_nw_all nin_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nin_all');
--
END del_nin_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NITH_PK constraint
--
PROCEDURE del_nith (pi_nith_nth_theme_id nm_inv_themes.nith_nth_theme_id%TYPE
                   ,pi_nith_nit_id       nm_inv_themes.nith_nit_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nith');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nith
                   (pi_nith_nth_theme_id => pi_nith_nth_theme_id
                   ,pi_nith_nit_id       => pi_nith_nit_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_themes nith
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nith');
--
END del_nith;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using ITY_PK constraint
--
PROCEDURE del_nit (pi_nit_inv_type      nm_inv_types.nit_inv_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nit');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nit
                   (pi_nit_inv_type      => pi_nit_inv_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_types nit
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nit');
--
END del_nit;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using ITY_PK constraint
--
PROCEDURE del_nit_all (pi_nit_inv_type      nm_inv_types_all.nit_inv_type%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nit_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nit_all
                   (pi_nit_inv_type      => pi_nit_inv_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_types_all nit_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nit_all');
--
END del_nit_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using ITA_PK constraint
--
PROCEDURE del_ita (pi_ita_inv_type      nm_inv_type_attribs.ita_inv_type%TYPE
                  ,pi_ita_attrib_name   nm_inv_type_attribs.ita_attrib_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ita');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ita
                   (pi_ita_inv_type      => pi_ita_inv_type
                   ,pi_ita_attrib_name   => pi_ita_attrib_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_type_attribs ita
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ita');
--
END del_ita;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using ITA_UK_VIEW_COL constraint
--
PROCEDURE del_ita (pi_ita_inv_type      nm_inv_type_attribs.ita_inv_type%TYPE
                  ,pi_ita_view_col_name nm_inv_type_attribs.ita_view_col_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ita');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ita
                   (pi_ita_inv_type      => pi_ita_inv_type
                   ,pi_ita_view_col_name => pi_ita_view_col_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_type_attribs ita
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ita');
--
END del_ita;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using ITA_UK_VIEW_ATTRI constraint
--
PROCEDURE del_ita (pi_ita_inv_type      nm_inv_type_attribs.ita_inv_type%TYPE
                  ,pi_ita_view_attri    nm_inv_type_attribs.ita_view_attri%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ita');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ita
                   (pi_ita_inv_type      => pi_ita_inv_type
                   ,pi_ita_view_attri    => pi_ita_view_attri
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_type_attribs ita
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ita');
--
END del_ita;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using ITA_PK constraint
--
PROCEDURE del_ita_all (pi_ita_inv_type      nm_inv_type_attribs_all.ita_inv_type%TYPE
                      ,pi_ita_attrib_name   nm_inv_type_attribs_all.ita_attrib_name%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ita_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ita_all
                   (pi_ita_inv_type      => pi_ita_inv_type
                   ,pi_ita_attrib_name   => pi_ita_attrib_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_type_attribs_all ita_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ita_all');
--
END del_ita_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using ITA_UK_VIEW_COL constraint
--
PROCEDURE del_ita_all (pi_ita_inv_type      nm_inv_type_attribs_all.ita_inv_type%TYPE
                      ,pi_ita_view_col_name nm_inv_type_attribs_all.ita_view_col_name%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ita_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ita_all
                   (pi_ita_inv_type      => pi_ita_inv_type
                   ,pi_ita_view_col_name => pi_ita_view_col_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_type_attribs_all ita_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ita_all');
--
END del_ita_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using ITA_UK_VIEW_ATTRI constraint
--
PROCEDURE del_ita_all (pi_ita_inv_type      nm_inv_type_attribs_all.ita_inv_type%TYPE
                      ,pi_ita_view_attri    nm_inv_type_attribs_all.ita_view_attri%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ita_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ita_all
                   (pi_ita_inv_type      => pi_ita_inv_type
                   ,pi_ita_view_attri    => pi_ita_view_attri
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_type_attribs_all ita_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ita_all');
--
END del_ita_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using ITB_PK constraint
--
PROCEDURE del_itb (pi_itb_inv_type      nm_inv_type_attrib_bandings.itb_inv_type%TYPE
                  ,pi_itb_attrib_name   nm_inv_type_attrib_bandings.itb_attrib_name%TYPE
                  ,pi_itb_banding_id    nm_inv_type_attrib_bandings.itb_banding_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_itb');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_itb
                   (pi_itb_inv_type      => pi_itb_inv_type
                   ,pi_itb_attrib_name   => pi_itb_attrib_name
                   ,pi_itb_banding_id    => pi_itb_banding_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_type_attrib_bandings itb
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_itb');
--
END del_itb;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using ITB_UK constraint
--
PROCEDURE del_itb (pi_itb_banding_id    nm_inv_type_attrib_bandings.itb_banding_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_itb');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_itb
                   (pi_itb_banding_id    => pi_itb_banding_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_type_attrib_bandings itb
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_itb');
--
END del_itb;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using ITD_PK constraint
--
PROCEDURE del_itd (pi_itd_band_seq       nm_inv_type_attrib_band_dets.itd_band_seq%TYPE
                  ,pi_itd_inv_type       nm_inv_type_attrib_band_dets.itd_inv_type%TYPE
                  ,pi_itd_attrib_name    nm_inv_type_attrib_band_dets.itd_attrib_name%TYPE
                  ,pi_itd_itb_banding_id nm_inv_type_attrib_band_dets.itd_itb_banding_id%TYPE
                  ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_itd');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_itd
                   (pi_itd_band_seq       => pi_itd_band_seq
                   ,pi_itd_inv_type       => pi_itd_inv_type
                   ,pi_itd_attrib_name    => pi_itd_attrib_name
                   ,pi_itd_itb_banding_id => pi_itd_itb_banding_id
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   ,pi_locked_sqlcode     => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_type_attrib_band_dets itd
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_itd');
--
END del_itd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NIAS_PK constraint
--
PROCEDURE del_nias (pi_nias_id           nm_inv_attribute_sets.nias_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nias');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nias
                   (pi_nias_id           => pi_nias_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_attribute_sets nias
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nias');
--
END del_nias;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NSIT_PK constraint
--
PROCEDURE del_nsit (pi_nsit_nias_id      nm_inv_attribute_set_inv_types.nsit_nias_id%TYPE
                   ,pi_nsit_nit_inv_type nm_inv_attribute_set_inv_types.nsit_nit_inv_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nsit');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nsit
                   (pi_nsit_nias_id      => pi_nsit_nias_id
                   ,pi_nsit_nit_inv_type => pi_nsit_nit_inv_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_attribute_set_inv_types nsit
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nsit');
--
END del_nsit;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NSIA_PK constraint
--
PROCEDURE del_nsia (pi_nsia_nsit_nit_inv_type nm_inv_attribute_set_inv_attr.nsia_nsit_nit_inv_type%TYPE
                   ,pi_nsia_ita_attrib_name   nm_inv_attribute_set_inv_attr.nsia_ita_attrib_name%TYPE
                   ,pi_nsia_nsit_nias_id      nm_inv_attribute_set_inv_attr.nsia_nsit_nias_id%TYPE
                   ,pi_raise_not_found        BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode      PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode         PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nsia');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nsia
                   (pi_nsia_nsit_nit_inv_type => pi_nsia_nsit_nit_inv_type
                   ,pi_nsia_ita_attrib_name   => pi_nsia_ita_attrib_name
                   ,pi_nsia_nsit_nias_id      => pi_nsia_nsit_nias_id
                   ,pi_raise_not_found        => pi_raise_not_found
                   ,pi_not_found_sqlcode      => pi_not_found_sqlcode
                   ,pi_locked_sqlcode         => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_attribute_set_inv_attr nsia
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nsia');
--
END del_nsia;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NM_INV_TYPE_COLOURS_PK constraint
--
PROCEDURE del_nitc (pi_col_id            nm_inv_type_colours.col_id%TYPE
                   ,pi_ity_inv_code      nm_inv_type_colours.ity_inv_code%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nitc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nitc
                   (pi_col_id            => pi_col_id
                   ,pi_ity_inv_code      => pi_ity_inv_code
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_type_colours nitc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nitc');
--
END del_nitc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using ITG_PK constraint
--
PROCEDURE del_itg (pi_itg_inv_type        nm_inv_type_groupings.itg_inv_type%TYPE
                  ,pi_itg_parent_inv_type nm_inv_type_groupings.itg_parent_inv_type%TYPE
                  ,pi_itg_start_date      nm_inv_type_groupings.itg_start_date%TYPE
                  ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_itg');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_itg
                   (pi_itg_inv_type        => pi_itg_inv_type
                   ,pi_itg_parent_inv_type => pi_itg_parent_inv_type
                   ,pi_itg_start_date      => pi_itg_start_date
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   ,pi_locked_sqlcode      => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_type_groupings itg
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_itg');
--
END del_itg;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using ITG_PK constraint (without start date for Datetrack View)
--
PROCEDURE del_itg (pi_itg_inv_type        nm_inv_type_groupings.itg_inv_type%TYPE
                  ,pi_itg_parent_inv_type nm_inv_type_groupings.itg_parent_inv_type%TYPE
                  ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_itg');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_itg
                   (pi_itg_inv_type        => pi_itg_inv_type
                   ,pi_itg_parent_inv_type => pi_itg_parent_inv_type
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   ,pi_locked_sqlcode      => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_type_groupings itg
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_itg');
--
END del_itg;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using ITG_PK constraint
--
PROCEDURE del_itg_all (pi_itg_inv_type        nm_inv_type_groupings_all.itg_inv_type%TYPE
                      ,pi_itg_parent_inv_type nm_inv_type_groupings_all.itg_parent_inv_type%TYPE
                      ,pi_itg_start_date      nm_inv_type_groupings_all.itg_start_date%TYPE
                      ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_itg_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_itg_all
                   (pi_itg_inv_type        => pi_itg_inv_type
                   ,pi_itg_parent_inv_type => pi_itg_parent_inv_type
                   ,pi_itg_start_date      => pi_itg_start_date
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   ,pi_locked_sqlcode      => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_type_groupings_all itg_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_itg_all');
--
END del_itg_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using ITR_PK constraint
--
PROCEDURE del_itr (pi_itr_inv_type      nm_inv_type_roles.itr_inv_type%TYPE
                  ,pi_itr_hro_role      nm_inv_type_roles.itr_hro_role%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_itr');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_itr
                   (pi_itr_inv_type      => pi_itr_inv_type
                   ,pi_itr_hro_role      => pi_itr_hro_role
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_inv_type_roles itr
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_itr');
--
END del_itr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NJC_PK constraint
--
PROCEDURE del_njc (pi_njc_job_id        nm_job_control.njc_job_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_njc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_njc
                   (pi_njc_job_id        => pi_njc_job_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_job_control njc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_njc');
--
END del_njc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NM_JOB_CONTROL_UK constraint
--
PROCEDURE del_njc (pi_njc_unique        nm_job_control.njc_unique%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_njc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_njc
                   (pi_njc_unique        => pi_njc_unique
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_job_control njc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_njc');
--
END del_njc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NJO_PK constraint
--
PROCEDURE del_njo (pi_njo_njc_job_id    nm_job_operations.njo_njc_job_id%TYPE
                  ,pi_njo_id            nm_job_operations.njo_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_njo');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_njo
                   (pi_njo_njc_job_id    => pi_njo_njc_job_id
                   ,pi_njo_id            => pi_njo_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_job_operations njo
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_njo');
--
END del_njo;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NJO_UK constraint
--
PROCEDURE del_njo (pi_njo_njc_job_id    nm_job_operations.njo_njc_job_id%TYPE
                  ,pi_njo_seq           nm_job_operations.njo_seq%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_njo');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_njo
                   (pi_njo_njc_job_id    => pi_njo_njc_job_id
                   ,pi_njo_seq           => pi_njo_seq
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_job_operations njo
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_njo');
--
END del_njo;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NJV_PK constraint
--
PROCEDURE del_njv (pi_njv_njc_job_id    nm_job_operation_data_values.njv_njc_job_id%TYPE
                  ,pi_njv_njo_id        nm_job_operation_data_values.njv_njo_id%TYPE
                  ,pi_njv_nod_data_item nm_job_operation_data_values.njv_nod_data_item%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_njv');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_njv
                   (pi_njv_njc_job_id    => pi_njv_njc_job_id
                   ,pi_njv_njo_id        => pi_njv_njo_id
                   ,pi_njv_nod_data_item => pi_njv_nod_data_item
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_job_operation_data_values njv
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_njv');
--
END del_njv;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NJT_PK constraint
--
PROCEDURE del_njt (pi_njt_type          nm_job_types.njt_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_njt');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_njt
                   (pi_njt_type          => pi_njt_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_job_types njt
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_njt');
--
END del_njt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using JTO_PK constraint
--
PROCEDURE del_jto (pi_jto_nmo_operation nm_job_types_operations.jto_nmo_operation%TYPE
                  ,pi_jto_njt_type      nm_job_types_operations.jto_njt_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_jto');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_jto
                   (pi_jto_nmo_operation => pi_jto_nmo_operation
                   ,pi_jto_njt_type      => pi_jto_njt_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_job_types_operations jto
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_jto');
--
END del_jto;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NM_LD_MC_ALL_INV_TMP_PK constraint
--
PROCEDURE del_nlm (pi_batch_no          nm_ld_mc_all_inv_tmp.batch_no%TYPE
                  ,pi_record_no         nm_ld_mc_all_inv_tmp.record_no%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nlm');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nlm
                   (pi_batch_no          => pi_batch_no
                   ,pi_record_no         => pi_record_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_ld_mc_all_inv_tmp nlm
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nlm');
--
END del_nlm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NLT_PK constraint
--
PROCEDURE del_nlt (pi_nlt_id            nm_linear_types.nlt_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nlt');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nlt
                   (pi_nlt_id            => pi_nlt_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_linear_types nlt
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nlt');
--
END del_nlt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NLT_UK constraint
--
PROCEDURE del_nlt (pi_nlt_nt_type       nm_linear_types.nlt_nt_type%TYPE
                  ,pi_nlt_gty_type      nm_linear_types.nlt_gty_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nlt');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nlt
                   (pi_nlt_nt_type       => pi_nlt_nt_type
                   ,pi_nlt_gty_type      => pi_nlt_gty_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_linear_types nlt
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nlt');
--
END del_nlt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NLB_PK constraint
--
PROCEDURE del_nlb (pi_nlb_batch_no      nm_load_batches.nlb_batch_no%TYPE
                  ,pi_nlb_filename      nm_load_batches.nlb_filename%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nlb');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nlb
                   (pi_nlb_batch_no      => pi_nlb_batch_no
                   ,pi_nlb_filename      => pi_nlb_filename
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_load_batches nlb
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nlb');
--
END del_nlb;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NLBS_PK constraint
--
PROCEDURE del_nlbs (pi_nlbs_nlb_batch_no nm_load_batch_status.nlbs_nlb_batch_no%TYPE
                   ,pi_nlbs_record_no    nm_load_batch_status.nlbs_record_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nlbs');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nlbs
                   (pi_nlbs_nlb_batch_no => pi_nlbs_nlb_batch_no
                   ,pi_nlbs_record_no    => pi_nlbs_record_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_load_batch_status nlbs
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nlbs');
--
END del_nlbs;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NLD_PK constraint
--
PROCEDURE del_nld (pi_nld_id            nm_load_destinations.nld_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nld');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nld
                   (pi_nld_id            => pi_nld_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_load_destinations nld
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nld');
--
END del_nld;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NLD_UK2 constraint
--
PROCEDURE del_nld (pi_nld_table_short_name nm_load_destinations.nld_table_short_name%TYPE
                  ,pi_raise_not_found      BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode    PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode       PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nld');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nld
                   (pi_nld_table_short_name => pi_nld_table_short_name
                   ,pi_raise_not_found      => pi_raise_not_found
                   ,pi_not_found_sqlcode    => pi_not_found_sqlcode
                   ,pi_locked_sqlcode       => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_load_destinations nld
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nld');
--
END del_nld;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NLD_UK1 constraint
--
PROCEDURE del_nld (pi_nld_table_name    nm_load_destinations.nld_table_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nld');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nld
                   (pi_nld_table_name    => pi_nld_table_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_load_destinations nld
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nld');
--
END del_nld;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NLDD_PK constraint
--
PROCEDURE del_nldd (pi_nldd_nld_id       nm_load_destination_defaults.nldd_nld_id%TYPE
                   ,pi_nldd_column_name  nm_load_destination_defaults.nldd_column_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nldd');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nldd
                   (pi_nldd_nld_id       => pi_nldd_nld_id
                   ,pi_nldd_column_name  => pi_nldd_column_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_load_destination_defaults nldd
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nldd');
--
END del_nldd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NLF_PK constraint
--
PROCEDURE del_nlf (pi_nlf_id            nm_load_files.nlf_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nlf');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nlf
                   (pi_nlf_id            => pi_nlf_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_load_files nlf
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nlf');
--
END del_nlf;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NLF_UK constraint
--
PROCEDURE del_nlf (pi_nlf_unique        nm_load_files.nlf_unique%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nlf');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nlf
                   (pi_nlf_unique        => pi_nlf_unique
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_load_files nlf
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nlf');
--
END del_nlf;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NLFC_PK constraint
--
PROCEDURE del_nlfc (pi_nlfc_nlf_id       nm_load_file_cols.nlfc_nlf_id%TYPE
                   ,pi_nlfc_seq_no       nm_load_file_cols.nlfc_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nlfc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nlfc
                   (pi_nlfc_nlf_id       => pi_nlfc_nlf_id
                   ,pi_nlfc_seq_no       => pi_nlfc_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_load_file_cols nlfc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nlfc');
--
END del_nlfc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NLFC_UK constraint
--
PROCEDURE del_nlfc (pi_nlfc_nlf_id       nm_load_file_cols.nlfc_nlf_id%TYPE
                   ,pi_nlfc_holding_col  nm_load_file_cols.nlfc_holding_col%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nlfc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nlfc
                   (pi_nlfc_nlf_id       => pi_nlfc_nlf_id
                   ,pi_nlfc_holding_col  => pi_nlfc_holding_col
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_load_file_cols nlfc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nlfc');
--
END del_nlfc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NLCD_PK constraint
--
PROCEDURE del_nlcd (pi_nlcd_nlf_id       nm_load_file_col_destinations.nlcd_nlf_id%TYPE
                   ,pi_nlcd_nld_id       nm_load_file_col_destinations.nlcd_nld_id%TYPE
                   ,pi_nlcd_seq_no       nm_load_file_col_destinations.nlcd_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nlcd');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nlcd
                   (pi_nlcd_nlf_id       => pi_nlcd_nlf_id
                   ,pi_nlcd_nld_id       => pi_nlcd_nld_id
                   ,pi_nlcd_seq_no       => pi_nlcd_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_load_file_col_destinations nlcd
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nlcd');
--
END del_nlcd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NLCD_UK constraint
--
PROCEDURE del_nlcd (pi_nlcd_nlf_id       nm_load_file_col_destinations.nlcd_nlf_id%TYPE
                   ,pi_nlcd_nld_id       nm_load_file_col_destinations.nlcd_nld_id%TYPE
                   ,pi_nlcd_dest_col     nm_load_file_col_destinations.nlcd_dest_col%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nlcd');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nlcd
                   (pi_nlcd_nlf_id       => pi_nlcd_nlf_id
                   ,pi_nlcd_nld_id       => pi_nlcd_nld_id
                   ,pi_nlcd_dest_col     => pi_nlcd_dest_col
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_load_file_col_destinations nlcd
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nlcd');
--
END del_nlcd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NLFD_PK constraint
--
PROCEDURE del_nlfd (pi_nlfd_nlf_id       nm_load_file_destinations.nlfd_nlf_id%TYPE
                   ,pi_nlfd_nld_id       nm_load_file_destinations.nlfd_nld_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nlfd');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nlfd
                   (pi_nlfd_nlf_id       => pi_nlfd_nlf_id
                   ,pi_nlfd_nld_id       => pi_nlfd_nld_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_load_file_destinations nlfd
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nlfd');
--
END del_nlfd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NLFD_UK constraint
--
PROCEDURE del_nlfd (pi_nlfd_nlf_id       nm_load_file_destinations.nlfd_nlf_id%TYPE
                   ,pi_nlfd_seq          nm_load_file_destinations.nlfd_seq%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nlfd');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nlfd
                   (pi_nlfd_nlf_id       => pi_nlfd_nlf_id
                   ,pi_nlfd_seq          => pi_nlfd_seq
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_load_file_destinations nlfd
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nlfd');
--
END del_nlfd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMG_PK constraint
--
PROCEDURE del_nmg (pi_nmg_id            nm_mail_groups.nmg_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmg');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmg
                   (pi_nmg_id            => pi_nmg_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mail_groups nmg
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmg');
--
END del_nmg;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMG_UK constraint
--
PROCEDURE del_nmg (pi_nmg_name          nm_mail_groups.nmg_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmg');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmg
                   (pi_nmg_name          => pi_nmg_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mail_groups nmg
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmg');
--
END del_nmg;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMGM_PK constraint
--
PROCEDURE del_nmgm (pi_nmgm_nmg_id       nm_mail_group_membership.nmgm_nmg_id%TYPE
                   ,pi_nmgm_nmu_id       nm_mail_group_membership.nmgm_nmu_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmgm');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmgm
                   (pi_nmgm_nmg_id       => pi_nmgm_nmg_id
                   ,pi_nmgm_nmu_id       => pi_nmgm_nmu_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mail_group_membership nmgm
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmgm');
--
END del_nmgm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMM_PK constraint
--
PROCEDURE del_nmm (pi_nmm_id            nm_mail_message.nmm_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmm');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmm
                   (pi_nmm_id            => pi_nmm_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mail_message nmm
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmm');
--
END del_nmm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMMR_PK constraint
--
PROCEDURE del_nmmr (pi_nmmr_nmm_id       nm_mail_message_recipients.nmmr_nmm_id%TYPE
                   ,pi_nmmr_rcpt_id      nm_mail_message_recipients.nmmr_rcpt_id%TYPE
                   ,pi_nmmr_rcpt_type    nm_mail_message_recipients.nmmr_rcpt_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmmr');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmmr
                   (pi_nmmr_nmm_id       => pi_nmmr_nmm_id
                   ,pi_nmmr_rcpt_id      => pi_nmmr_rcpt_id
                   ,pi_nmmr_rcpt_type    => pi_nmmr_rcpt_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mail_message_recipients nmmr
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmmr');
--
END del_nmmr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMMT_PK constraint
--
PROCEDURE del_nmmt (pi_nmmt_nmm_id       nm_mail_message_text.nmmt_nmm_id%TYPE
                   ,pi_nmmt_line_id      nm_mail_message_text.nmmt_line_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmmt');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmmt
                   (pi_nmmt_nmm_id       => pi_nmmt_nmm_id
                   ,pi_nmmt_line_id      => pi_nmmt_line_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mail_message_text nmmt
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmmt');
--
END del_nmmt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMU_PK constraint
--
PROCEDURE del_nmu (pi_nmu_id            nm_mail_users.nmu_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmu');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmu
                   (pi_nmu_id            => pi_nmu_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mail_users nmu
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmu');
--
END del_nmu;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NM_PK constraint
--
PROCEDURE del_nm (pi_nm_ne_id_in       nm_members.nm_ne_id_in%TYPE
                 ,pi_nm_ne_id_of       nm_members.nm_ne_id_of%TYPE
                 ,pi_nm_begin_mp       nm_members.nm_begin_mp%TYPE
                 ,pi_nm_start_date     nm_members.nm_start_date%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nm');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nm
                   (pi_nm_ne_id_in       => pi_nm_ne_id_in
                   ,pi_nm_ne_id_of       => pi_nm_ne_id_of
                   ,pi_nm_begin_mp       => pi_nm_begin_mp
                   ,pi_nm_start_date     => pi_nm_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_members nm
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nm');
--
END del_nm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NM_PK constraint (without start date for Datetrack View)
--
PROCEDURE del_nm (pi_nm_ne_id_in       nm_members.nm_ne_id_in%TYPE
                 ,pi_nm_ne_id_of       nm_members.nm_ne_id_of%TYPE
                 ,pi_nm_begin_mp       nm_members.nm_begin_mp%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nm');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nm
                   (pi_nm_ne_id_in       => pi_nm_ne_id_in
                   ,pi_nm_ne_id_of       => pi_nm_ne_id_of
                   ,pi_nm_begin_mp       => pi_nm_begin_mp
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_members nm
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nm');
--
END del_nm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NM_PK constraint
--
PROCEDURE del_nm_all (pi_nm_ne_id_in       nm_members_all.nm_ne_id_in%TYPE
                     ,pi_nm_ne_id_of       nm_members_all.nm_ne_id_of%TYPE
                     ,pi_nm_begin_mp       nm_members_all.nm_begin_mp%TYPE
                     ,pi_nm_start_date     nm_members_all.nm_start_date%TYPE
                     ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                     ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                     ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                     ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nm_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nm_all
                   (pi_nm_ne_id_in       => pi_nm_ne_id_in
                   ,pi_nm_ne_id_of       => pi_nm_ne_id_of
                   ,pi_nm_begin_mp       => pi_nm_begin_mp
                   ,pi_nm_start_date     => pi_nm_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_members_all nm_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nm_all');
--
END del_nm_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMH_PK constraint
--
PROCEDURE del_nmh (pi_nmh_nm_begin_mp     nm_member_history.nmh_nm_begin_mp%TYPE
                  ,pi_nmh_nm_start_date   nm_member_history.nmh_nm_start_date%TYPE
                  ,pi_nmh_nm_ne_id_in     nm_member_history.nmh_nm_ne_id_in%TYPE
                  ,pi_nmh_nm_ne_id_of_old nm_member_history.nmh_nm_ne_id_of_old%TYPE
                  ,pi_nmh_nm_ne_id_of_new nm_member_history.nmh_nm_ne_id_of_new%TYPE
                  ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmh');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmh
                   (pi_nmh_nm_begin_mp     => pi_nmh_nm_begin_mp
                   ,pi_nmh_nm_start_date   => pi_nmh_nm_start_date
                   ,pi_nmh_nm_ne_id_in     => pi_nmh_nm_ne_id_in
                   ,pi_nmh_nm_ne_id_of_old => pi_nmh_nm_ne_id_of_old
                   ,pi_nmh_nm_ne_id_of_new => pi_nmh_nm_ne_id_of_new
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   ,pi_locked_sqlcode      => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_member_history nmh
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmh');
--
END del_nmh;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NDQA_PK constraint
--
PROCEDURE del_nda (pi_nda_seq_no        nm_mrg_default_query_attribs.nda_seq_no%TYPE
                  ,pi_nda_attrib_name   nm_mrg_default_query_attribs.nda_attrib_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nda');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nda
                   (pi_nda_seq_no        => pi_nda_seq_no
                   ,pi_nda_attrib_name   => pi_nda_attrib_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_default_query_attribs nda
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nda');
--
END del_nda;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NDQT_PK constraint
--
PROCEDURE del_ndq (pi_ndq_seq_no        nm_mrg_default_query_types.ndq_seq_no%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ndq');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ndq
                   (pi_ndq_seq_no        => pi_ndq_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_default_query_types ndq
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ndq');
--
END del_ndq;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NDQT_PK constraint
--
PROCEDURE del_ndq_all (pi_ndq_seq_no        nm_mrg_default_query_types_all.ndq_seq_no%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ndq_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ndq_all
                   (pi_ndq_seq_no        => pi_ndq_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_default_query_types_all ndq_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ndq_all');
--
END del_ndq_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMID_PK constraint
--
PROCEDURE del_nmid (pi_nmid_nmq_id       nm_mrg_inv_derivation.nmid_nmq_id%TYPE
                   ,pi_nmid_inv_type     nm_mrg_inv_derivation.nmid_inv_type%TYPE
                   ,pi_nmid_attrib_name  nm_mrg_inv_derivation.nmid_attrib_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmid');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmid
                   (pi_nmid_nmq_id       => pi_nmid_nmq_id
                   ,pi_nmid_inv_type     => pi_nmid_inv_type
                   ,pi_nmid_attrib_name  => pi_nmid_attrib_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_inv_derivation nmid
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmid');
--
END del_nmid;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMC_PK constraint
--
PROCEDURE del_nmc (pi_nmc_nmf_id        nm_mrg_output_cols.nmc_nmf_id%TYPE
                  ,pi_nmc_seq_no        nm_mrg_output_cols.nmc_seq_no%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmc
                   (pi_nmc_nmf_id        => pi_nmc_nmf_id
                   ,pi_nmc_seq_no        => pi_nmc_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_output_cols nmc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmc');
--
END del_nmc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMC_UK constraint
--
PROCEDURE del_nmc (pi_nmc_nmf_id        nm_mrg_output_cols.nmc_nmf_id%TYPE
                  ,pi_nmc_view_col_name nm_mrg_output_cols.nmc_view_col_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmc
                   (pi_nmc_nmf_id        => pi_nmc_nmf_id
                   ,pi_nmc_view_col_name => pi_nmc_view_col_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_output_cols nmc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmc');
--
END del_nmc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMCD_PK constraint
--
PROCEDURE del_nmcd (pi_nmcd_nmf_id       nm_mrg_output_col_decode.nmcd_nmf_id%TYPE
                   ,pi_nmcd_nmc_seq_no   nm_mrg_output_col_decode.nmcd_nmc_seq_no%TYPE
                   ,pi_nmcd_from_value   nm_mrg_output_col_decode.nmcd_from_value%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmcd');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmcd
                   (pi_nmcd_nmf_id       => pi_nmcd_nmf_id
                   ,pi_nmcd_nmc_seq_no   => pi_nmcd_nmc_seq_no
                   ,pi_nmcd_from_value   => pi_nmcd_from_value
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_output_col_decode nmcd
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmcd');
--
END del_nmcd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMF_PK constraint
--
PROCEDURE del_nmf (pi_nmf_id            nm_mrg_output_file.nmf_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmf');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmf
                   (pi_nmf_id            => pi_nmf_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_output_file nmf
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmf');
--
END del_nmf;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMF_UK constraint
--
PROCEDURE del_nmf (pi_nmf_nmq_id        nm_mrg_output_file.nmf_nmq_id%TYPE
                  ,pi_nmf_filename      nm_mrg_output_file.nmf_filename%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmf');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmf
                   (pi_nmf_nmq_id        => pi_nmf_nmq_id
                   ,pi_nmf_filename      => pi_nmf_filename
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_output_file nmf
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmf');
--
END del_nmf;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMQ_PK constraint
--
PROCEDURE del_nmq (pi_nmq_id            nm_mrg_query.nmq_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmq');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmq
                   (pi_nmq_id            => pi_nmq_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_query nmq
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmq');
--
END del_nmq;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMQ_UK constraint
--
PROCEDURE del_nmq (pi_nmq_unique        nm_mrg_query.nmq_unique%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmq');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmq
                   (pi_nmq_unique        => pi_nmq_unique
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_query nmq
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmq');
--
END del_nmq;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMQ_PK constraint
--
PROCEDURE del_nmq_all (pi_nmq_id            nm_mrg_query_all.nmq_id%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmq_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmq_all
                   (pi_nmq_id            => pi_nmq_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_query_all nmq_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmq_all');
--
END del_nmq_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMQ_UK constraint
--
PROCEDURE del_nmq_all (pi_nmq_unique        nm_mrg_query_all.nmq_unique%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmq_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmq_all
                   (pi_nmq_unique        => pi_nmq_unique
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_query_all nmq_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmq_all');
--
END del_nmq_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMQA_PK constraint
--
PROCEDURE del_nmqa (pi_nqa_nmq_id        nm_mrg_query_attribs.nqa_nmq_id%TYPE
                   ,pi_nqa_nqt_seq_no    nm_mrg_query_attribs.nqa_nqt_seq_no%TYPE
                   ,pi_nqa_attrib_name   nm_mrg_query_attribs.nqa_attrib_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmqa');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmqa
                   (pi_nqa_nmq_id        => pi_nqa_nmq_id
                   ,pi_nqa_nqt_seq_no    => pi_nqa_nqt_seq_no
                   ,pi_nqa_attrib_name   => pi_nqa_attrib_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_query_attribs nmqa
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmqa');
--
END del_nmqa;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMQR_PK constraint
--
PROCEDURE del_nmqr (pi_nqr_mrg_job_id    nm_mrg_query_results.nqr_mrg_job_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmqr');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmqr
                   (pi_nqr_mrg_job_id    => pi_nqr_mrg_job_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_query_results nmqr
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmqr');
--
END del_nmqr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMQR_PK constraint
--
PROCEDURE del_nmqr_all (pi_nqr_mrg_job_id    nm_mrg_query_results_all.nqr_mrg_job_id%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmqr_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmqr_all
                   (pi_nqr_mrg_job_id    => pi_nqr_mrg_job_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_query_results_all nmqr_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmqr_all');
--
END del_nmqr_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NQRO_PK constraint
--
PROCEDURE del_nqro (pi_nqro_nmq_id       nm_mrg_query_roles.nqro_nmq_id%TYPE
                   ,pi_nqro_role         nm_mrg_query_roles.nqro_role%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nqro');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nqro
                   (pi_nqro_nmq_id       => pi_nqro_nmq_id
                   ,pi_nqro_role         => pi_nqro_role
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_query_roles nqro
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nqro');
--
END del_nqro;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMQT_PK constraint
--
PROCEDURE del_nmqt (pi_nqt_nmq_id        nm_mrg_query_types.nqt_nmq_id%TYPE
                   ,pi_nqt_seq_no        nm_mrg_query_types.nqt_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmqt');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmqt
                   (pi_nqt_nmq_id        => pi_nqt_nmq_id
                   ,pi_nqt_seq_no        => pi_nqt_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_query_types nmqt
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmqt');
--
END del_nmqt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMQT_PK constraint
--
PROCEDURE del_nmqt_all (pi_nqt_nmq_id        nm_mrg_query_types_all.nqt_nmq_id%TYPE
                       ,pi_nqt_seq_no        nm_mrg_query_types_all.nqt_seq_no%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmqt_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmqt_all
                   (pi_nqt_nmq_id        => pi_nqt_nmq_id
                   ,pi_nqt_seq_no        => pi_nqt_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_query_types_all nmqt_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmqt_all');
--
END del_nmqt_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMQV_PK constraint
--
PROCEDURE del_nmqv (pi_nqv_nqt_seq_no    nm_mrg_query_values.nqv_nqt_seq_no%TYPE
                   ,pi_nqv_attrib_name   nm_mrg_query_values.nqv_attrib_name%TYPE
                   ,pi_nqv_sequence      nm_mrg_query_values.nqv_sequence%TYPE
                   ,pi_nqv_nmq_id        nm_mrg_query_values.nqv_nmq_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmqv');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmqv
                   (pi_nqv_nqt_seq_no    => pi_nqv_nqt_seq_no
                   ,pi_nqv_attrib_name   => pi_nqv_attrib_name
                   ,pi_nqv_sequence      => pi_nqv_sequence
                   ,pi_nqv_nmq_id        => pi_nqv_nmq_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_query_values nmqv
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmqv');
--
END del_nmqv;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMS_PK constraint
--
PROCEDURE del_nms (pi_nms_mrg_job_id     nm_mrg_sections.nms_mrg_job_id%TYPE
                  ,pi_nms_mrg_section_id nm_mrg_sections.nms_mrg_section_id%TYPE
                  ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nms');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nms
                   (pi_nms_mrg_job_id     => pi_nms_mrg_job_id
                   ,pi_nms_mrg_section_id => pi_nms_mrg_section_id
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   ,pi_locked_sqlcode     => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_sections nms
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nms');
--
END del_nms;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMS_PK constraint
--
PROCEDURE del_nms_all (pi_nms_mrg_job_id     nm_mrg_sections_all.nms_mrg_job_id%TYPE
                      ,pi_nms_mrg_section_id nm_mrg_sections_all.nms_mrg_section_id%TYPE
                      ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nms_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nms_all
                   (pi_nms_mrg_job_id     => pi_nms_mrg_job_id
                   ,pi_nms_mrg_section_id => pi_nms_mrg_section_id
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   ,pi_locked_sqlcode     => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_sections_all nms_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nms_all');
--
END del_nms_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMSIV_PK constraint
--
PROCEDURE del_nsv (pi_nsv_mrg_job_id    nm_mrg_section_inv_values.nsv_mrg_job_id%TYPE
                  ,pi_nsv_value_id      nm_mrg_section_inv_values.nsv_value_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nsv');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nsv
                   (pi_nsv_mrg_job_id    => pi_nsv_mrg_job_id
                   ,pi_nsv_value_id      => pi_nsv_value_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_section_inv_values nsv
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nsv');
--
END del_nsv;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMSIV_PK constraint
--
PROCEDURE del_nsv_all (pi_nsv_mrg_job_id    nm_mrg_section_inv_values_all.nsv_mrg_job_id%TYPE
                      ,pi_nsv_value_id      nm_mrg_section_inv_values_all.nsv_value_id%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nsv_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nsv_all
                   (pi_nsv_mrg_job_id    => pi_nsv_mrg_job_id
                   ,pi_nsv_value_id      => pi_nsv_value_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_section_inv_values_all nsv_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nsv_all');
--
END del_nsv_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMSM_PK constraint
--
PROCEDURE del_nmsm (pi_nsm_mrg_job_id     nm_mrg_section_members.nsm_mrg_job_id%TYPE
                   ,pi_nsm_mrg_section_id nm_mrg_section_members.nsm_mrg_section_id%TYPE
                   ,pi_nsm_ne_id          nm_mrg_section_members.nsm_ne_id%TYPE
                   ,pi_nsm_begin_mp       nm_mrg_section_members.nsm_begin_mp%TYPE
                   ,pi_nsm_end_mp         nm_mrg_section_members.nsm_end_mp%TYPE
                   ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmsm');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmsm
                   (pi_nsm_mrg_job_id     => pi_nsm_mrg_job_id
                   ,pi_nsm_mrg_section_id => pi_nsm_mrg_section_id
                   ,pi_nsm_ne_id          => pi_nsm_ne_id
                   ,pi_nsm_begin_mp       => pi_nsm_begin_mp
                   ,pi_nsm_end_mp         => pi_nsm_end_mp
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   ,pi_locked_sqlcode     => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mrg_section_members nmsm
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmsm');
--
END del_nmsm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NN_PK constraint
--
PROCEDURE del_no (pi_no_node_id        nm_nodes.no_node_id%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_no');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_no
                   (pi_no_node_id        => pi_no_node_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_nodes no
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_no');
--
END del_no;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NN_UK constraint
--
PROCEDURE del_no (pi_no_node_name      nm_nodes.no_node_name%TYPE
                 ,pi_no_node_type      nm_nodes.no_node_type%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_no');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_no
                   (pi_no_node_name      => pi_no_node_name
                   ,pi_no_node_type      => pi_no_node_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_nodes no
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_no');
--
END del_no;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NN_PK constraint
--
PROCEDURE del_no_all (pi_no_node_id        nm_nodes_all.no_node_id%TYPE
                     ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                     ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                     ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                     ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_no_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_no_all
                   (pi_no_node_id        => pi_no_node_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_nodes_all no_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_no_all');
--
END del_no_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NN_UK constraint
--
PROCEDURE del_no_all (pi_no_node_name      nm_nodes_all.no_node_name%TYPE
                     ,pi_no_node_type      nm_nodes_all.no_node_type%TYPE
                     ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                     ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                     ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                     ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_no_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_no_all
                   (pi_no_node_name      => pi_no_node_name
                   ,pi_no_node_type      => pi_no_node_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_nodes_all no_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_no_all');
--
END del_no_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NNT_PK constraint
--
PROCEDURE del_nnt (pi_nnt_type          nm_node_types.nnt_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nnt');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nnt
                   (pi_nnt_type          => pi_nnt_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_node_types nnt
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nnt');
--
END del_nnt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NNU_PK constraint
--
PROCEDURE del_nnu (pi_nnu_ne_id         nm_node_usages.nnu_ne_id%TYPE
                  ,pi_nnu_chain         nm_node_usages.nnu_chain%TYPE
                  ,pi_nnu_no_node_id    nm_node_usages.nnu_no_node_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nnu');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nnu
                   (pi_nnu_ne_id         => pi_nnu_ne_id
                   ,pi_nnu_chain         => pi_nnu_chain
                   ,pi_nnu_no_node_id    => pi_nnu_no_node_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_node_usages nnu
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nnu');
--
END del_nnu;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NNU_PK constraint
--
PROCEDURE del_nnu_all (pi_nnu_ne_id         nm_node_usages_all.nnu_ne_id%TYPE
                      ,pi_nnu_chain         nm_node_usages_all.nnu_chain%TYPE
                      ,pi_nnu_no_node_id    nm_node_usages_all.nnu_no_node_id%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nnu_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nnu_all
                   (pi_nnu_ne_id         => pi_nnu_ne_id
                   ,pi_nnu_chain         => pi_nnu_chain
                   ,pi_nnu_no_node_id    => pi_nnu_no_node_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_node_usages_all nnu_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nnu_all');
--
END del_nnu_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NNG_PK constraint
--
PROCEDURE del_nng (pi_nng_group_type    nm_nt_groupings.nng_group_type%TYPE
                  ,pi_nng_nt_type       nm_nt_groupings.nng_nt_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nng');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nng
                   (pi_nng_group_type    => pi_nng_group_type
                   ,pi_nng_nt_type       => pi_nng_nt_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_nt_groupings nng
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nng');
--
END del_nng;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NNG_PK constraint
--
PROCEDURE del_nng_all (pi_nng_group_type    nm_nt_groupings_all.nng_group_type%TYPE
                      ,pi_nng_nt_type       nm_nt_groupings_all.nng_nt_type%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nng_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nng_all
                   (pi_nng_group_type    => pi_nng_group_type
                   ,pi_nng_nt_type       => pi_nng_nt_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_nt_groupings_all nng_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nng_all');
--
END del_nng_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NAD_ID_PK constraint
--
PROCEDURE del_nad (pi_nad_id            nm_nw_ad_types.nad_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nad');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nad
                   (pi_nad_id            => pi_nad_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_nw_ad_types nad
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nad');
--
END del_nad;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NPE_PK constraint
--
PROCEDURE del_npe (pi_npe_job_id        nm_nw_persistent_extents.npe_job_id%TYPE
                  ,pi_npe_ne_id_of      nm_nw_persistent_extents.npe_ne_id_of%TYPE
                  ,pi_npe_begin_mp      nm_nw_persistent_extents.npe_begin_mp%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_npe');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_npe
                   (pi_npe_job_id        => pi_npe_job_id
                   ,pi_npe_ne_id_of      => pi_npe_ne_id_of
                   ,pi_npe_begin_mp      => pi_npe_begin_mp
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_nw_persistent_extents npe
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_npe');
--
END del_npe;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NNTH_PK constraint
--
PROCEDURE del_nnth (pi_nnth_nlt_id       nm_nw_themes.nnth_nlt_id%TYPE
                   ,pi_nnth_nth_theme_id nm_nw_themes.nnth_nth_theme_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nnth');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nnth
                   (pi_nnth_nlt_id       => pi_nnth_nlt_id
                   ,pi_nnth_nth_theme_id => pi_nnth_nth_theme_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_nw_themes nnth
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nnth');
--
END del_nnth;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMO_PK constraint
--
PROCEDURE del_nmo (pi_nmo_operation     nm_operations.nmo_operation%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmo');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nmo
                   (pi_nmo_operation     => pi_nmo_operation
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_operations nmo
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmo');
--
END del_nmo;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NOD_PK constraint
--
PROCEDURE del_nod (pi_nod_nmo_operation nm_operation_data.nod_nmo_operation%TYPE
                  ,pi_nod_data_item     nm_operation_data.nod_data_item%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nod');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nod
                   (pi_nod_nmo_operation => pi_nod_nmo_operation
                   ,pi_nod_data_item     => pi_nod_data_item
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_operation_data nod
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nod');
--
END del_nod;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NOD_UK constraint
--
PROCEDURE del_nod (pi_nod_nmo_operation nm_operation_data.nod_nmo_operation%TYPE
                  ,pi_nod_seq           nm_operation_data.nod_seq%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nod');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nod
                   (pi_nod_nmo_operation => pi_nod_nmo_operation
                   ,pi_nod_seq           => pi_nod_seq
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_operation_data nod
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nod');
--
END del_nod;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NOD_SCRN_TEXT_UK constraint
--
PROCEDURE del_nod (pi_nod_nmo_operation nm_operation_data.nod_nmo_operation%TYPE
                  ,pi_nod_scrn_text     nm_operation_data.nod_scrn_text%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nod');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nod
                   (pi_nod_nmo_operation => pi_nod_nmo_operation
                   ,pi_nod_scrn_text     => pi_nod_scrn_text
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_operation_data nod
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nod');
--
END del_nod;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NPQ_PK constraint
--
PROCEDURE del_npq (pi_npq_id            nm_pbi_query.npq_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_npq');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_npq
                   (pi_npq_id            => pi_npq_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_pbi_query npq
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_npq');
--
END del_npq;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NPQ_UK constraint
--
PROCEDURE del_npq (pi_npq_unique        nm_pbi_query.npq_unique%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_npq');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_npq
                   (pi_npq_unique        => pi_npq_unique
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_pbi_query npq
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_npq');
--
END del_npq;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NQA_PK constraint
--
PROCEDURE del_npqa (pi_nqa_npq_id        nm_pbi_query_attribs.nqa_npq_id%TYPE
                   ,pi_nqa_nqt_seq_no    nm_pbi_query_attribs.nqa_nqt_seq_no%TYPE
                   ,pi_nqa_seq_no        nm_pbi_query_attribs.nqa_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_npqa');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_npqa
                   (pi_nqa_npq_id        => pi_nqa_npq_id
                   ,pi_nqa_nqt_seq_no    => pi_nqa_nqt_seq_no
                   ,pi_nqa_seq_no        => pi_nqa_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_pbi_query_attribs npqa
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_npqa');
--
END del_npqa;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NQR_PK constraint
--
PROCEDURE del_npqr (pi_nqr_npq_id        nm_pbi_query_results.nqr_npq_id%TYPE
                   ,pi_nqr_job_id        nm_pbi_query_results.nqr_job_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_npqr');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_npqr
                   (pi_nqr_npq_id        => pi_nqr_npq_id
                   ,pi_nqr_job_id        => pi_nqr_job_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_pbi_query_results npqr
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_npqr');
--
END del_npqr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NQT_PK constraint
--
PROCEDURE del_npqt (pi_nqt_npq_id        nm_pbi_query_types.nqt_npq_id%TYPE
                   ,pi_nqt_seq_no        nm_pbi_query_types.nqt_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_npqt');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_npqt
                   (pi_nqt_npq_id        => pi_nqt_npq_id
                   ,pi_nqt_seq_no        => pi_nqt_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_pbi_query_types npqt
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_npqt');
--
END del_npqt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NQV_PK constraint
--
PROCEDURE del_npqv (pi_nqv_sequence      nm_pbi_query_values.nqv_sequence%TYPE
                   ,pi_nqv_npq_id        nm_pbi_query_values.nqv_npq_id%TYPE
                   ,pi_nqv_nqt_seq_no    nm_pbi_query_values.nqv_nqt_seq_no%TYPE
                   ,pi_nqv_nqa_seq_no    nm_pbi_query_values.nqv_nqa_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_npqv');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_npqv
                   (pi_nqv_sequence      => pi_nqv_sequence
                   ,pi_nqv_npq_id        => pi_nqv_npq_id
                   ,pi_nqv_nqt_seq_no    => pi_nqv_nqt_seq_no
                   ,pi_nqv_nqa_seq_no    => pi_nqv_nqa_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_pbi_query_values npqv
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_npqv');
--
END del_npqv;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NPS_PK constraint
--
PROCEDURE del_nps (pi_nps_npq_id        nm_pbi_sections.nps_npq_id%TYPE
                  ,pi_nps_nqr_job_id    nm_pbi_sections.nps_nqr_job_id%TYPE
                  ,pi_nps_section_id    nm_pbi_sections.nps_section_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nps');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nps
                   (pi_nps_npq_id        => pi_nps_npq_id
                   ,pi_nps_nqr_job_id    => pi_nps_nqr_job_id
                   ,pi_nps_section_id    => pi_nps_section_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_pbi_sections nps
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nps');
--
END del_nps;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NPM_PK constraint
--
PROCEDURE del_npsm (pi_npm_npq_id         nm_pbi_section_members.npm_npq_id%TYPE
                   ,pi_npm_nqr_job_id     nm_pbi_section_members.npm_nqr_job_id%TYPE
                   ,pi_npm_nps_section_id nm_pbi_section_members.npm_nps_section_id%TYPE
                   ,pi_npm_ne_id_of       nm_pbi_section_members.npm_ne_id_of%TYPE
                   ,pi_npm_begin_mp       nm_pbi_section_members.npm_begin_mp%TYPE
                   ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_npsm');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_npsm
                   (pi_npm_npq_id         => pi_npm_npq_id
                   ,pi_npm_nqr_job_id     => pi_npm_nqr_job_id
                   ,pi_npm_nps_section_id => pi_npm_nps_section_id
                   ,pi_npm_ne_id_of       => pi_npm_ne_id_of
                   ,pi_npm_begin_mp       => pi_npm_begin_mp
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   ,pi_locked_sqlcode     => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_pbi_section_members npsm
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_npsm');
--
END del_npsm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NP_PK constraint
--
PROCEDURE del_np (pi_np_id             nm_points.np_id%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_np');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_np
                   (pi_np_id             => pi_np_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_points np
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_np');
--
END del_np;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NRD_PK constraint
--
PROCEDURE del_nrd (pi_nrd_job_id        nm_reclass_details.nrd_job_id%TYPE
                  ,pi_nrd_old_ne_id     nm_reclass_details.nrd_old_ne_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nrd');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nrd
                   (pi_nrd_job_id        => pi_nrd_job_id
                   ,pi_nrd_old_ne_id     => pi_nrd_old_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_reclass_details nrd
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nrd');
--
END del_nrd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NRD_UK constraint
--
PROCEDURE del_nrd (pi_nrd_job_id        nm_reclass_details.nrd_job_id%TYPE
                  ,pi_nrd_new_ne_id     nm_reclass_details.nrd_new_ne_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nrd');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nrd
                   (pi_nrd_job_id        => pi_nrd_job_id
                   ,pi_nrd_new_ne_id     => pi_nrd_new_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_reclass_details nrd
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nrd');
--
END del_nrd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMR_PK constraint
--
PROCEDURE del_nrev (pi_ne_id             nm_reversal.ne_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nrev');
--
   -- No lock procedure - a temporary table
   DELETE /*+ INDEX (nrev NMR_PK) */ nm_reversal nrev
   WHERE  nrev.ne_id = pi_ne_id;
   IF SQL%ROWCOUNT = 0 AND pi_raise_not_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_reversal (NMR_PK)'
                                              ||CHR(10)||'ne_id => '||pi_ne_id
                    );
   END IF;
--
--
   nm_debug.proc_end(g_package_name,'del_nrev');
--
END del_nrev;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NSE_PK constraint
--
PROCEDURE del_nse (pi_nse_id            nm_saved_extents.nse_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nse');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nse
                   (pi_nse_id            => pi_nse_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_saved_extents nse
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nse');
--
END del_nse;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NSE_UK constraint
--
PROCEDURE del_nse (pi_nse_name          nm_saved_extents.nse_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nse');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nse
                   (pi_nse_name          => pi_nse_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_saved_extents nse
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nse');
--
END del_nse;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NSM_PK constraint
--
PROCEDURE del_nsm (pi_nsm_nse_id        nm_saved_extent_members.nsm_nse_id%TYPE
                  ,pi_nsm_id            nm_saved_extent_members.nsm_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nsm');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nsm
                   (pi_nsm_nse_id        => pi_nsm_nse_id
                   ,pi_nsm_id            => pi_nsm_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_saved_extent_members nsm
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nsm');
--
END del_nsm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NSD_PK constraint
--
PROCEDURE del_nsd (pi_nsd_ne_id         nm_saved_extent_member_datums.nsd_ne_id%TYPE
                  ,pi_nsd_begin_mp      nm_saved_extent_member_datums.nsd_begin_mp%TYPE
                  ,pi_nsd_nse_id        nm_saved_extent_member_datums.nsd_nse_id%TYPE
                  ,pi_nsd_nsm_id        nm_saved_extent_member_datums.nsd_nsm_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nsd');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nsd
                   (pi_nsd_ne_id         => pi_nsd_ne_id
                   ,pi_nsd_begin_mp      => pi_nsd_begin_mp
                   ,pi_nsd_nse_id        => pi_nsd_nse_id
                   ,pi_nsd_nsm_id        => pi_nsd_nsm_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_saved_extent_member_datums nsd
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nsd');
--
END del_nsd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using TII_PK constraint
--
PROCEDURE del_tii (pi_tii_njc_job_id    nm_temp_inv_items.tii_njc_job_id%TYPE
                  ,pi_tii_ne_id         nm_temp_inv_items.tii_ne_id%TYPE
                  ,pi_tii_ne_id_new     nm_temp_inv_items.tii_ne_id_new%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_tii');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_tii
                   (pi_tii_njc_job_id    => pi_tii_njc_job_id
                   ,pi_tii_ne_id         => pi_tii_ne_id
                   ,pi_tii_ne_id_new     => pi_tii_ne_id_new
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_temp_inv_items tii
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_tii');
--
END del_tii;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using TII_TEMP_PK constraint
--
PROCEDURE del_tiit (pi_tii_njc_job_id    nm_temp_inv_items_temp.tii_njc_job_id%TYPE
                   ,pi_tii_ne_id         nm_temp_inv_items_temp.tii_ne_id%TYPE
                   ,pi_tii_ne_id_new     nm_temp_inv_items_temp.tii_ne_id_new%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_tiit');
--
   -- No lock procedure - a temporary table
   DELETE /*+ INDEX (tiit TII_TEMP_PK) */ nm_temp_inv_items_temp tiit
   WHERE  tiit.tii_njc_job_id = pi_tii_njc_job_id
    AND   tiit.tii_ne_id      = pi_tii_ne_id
    AND   tiit.tii_ne_id_new  = pi_tii_ne_id_new;
   IF SQL%ROWCOUNT = 0 AND pi_raise_not_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_temp_inv_items_temp (TII_TEMP_PK)'
                                              ||CHR(10)||'tii_njc_job_id => '||pi_tii_njc_job_id
                                              ||CHR(10)||'tii_ne_id      => '||pi_tii_ne_id
                                              ||CHR(10)||'tii_ne_id_new  => '||pi_tii_ne_id_new
                    );
   END IF;
--
--
   nm_debug.proc_end(g_package_name,'del_tiit');
--
END del_tiit;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using TIM_PK constraint
--
PROCEDURE del_tim (pi_tim_njc_job_id      nm_temp_inv_members.tim_njc_job_id%TYPE
                  ,pi_tim_ne_id_in        nm_temp_inv_members.tim_ne_id_in%TYPE
                  ,pi_tim_ne_id_in_new    nm_temp_inv_members.tim_ne_id_in_new%TYPE
                  ,pi_tim_ne_id_of        nm_temp_inv_members.tim_ne_id_of%TYPE
                  ,pi_tim_extent_begin_mp nm_temp_inv_members.tim_extent_begin_mp%TYPE
                  ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_tim');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_tim
                   (pi_tim_njc_job_id      => pi_tim_njc_job_id
                   ,pi_tim_ne_id_in        => pi_tim_ne_id_in
                   ,pi_tim_ne_id_in_new    => pi_tim_ne_id_in_new
                   ,pi_tim_ne_id_of        => pi_tim_ne_id_of
                   ,pi_tim_extent_begin_mp => pi_tim_extent_begin_mp
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   ,pi_locked_sqlcode      => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_temp_inv_members tim
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_tim');
--
END del_tim;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using TIM_TEMP_PK constraint
--
PROCEDURE del_timt (pi_tim_njc_job_id      nm_temp_inv_members_temp.tim_njc_job_id%TYPE
                   ,pi_tim_ne_id_in        nm_temp_inv_members_temp.tim_ne_id_in%TYPE
                   ,pi_tim_ne_id_in_new    nm_temp_inv_members_temp.tim_ne_id_in_new%TYPE
                   ,pi_tim_ne_id_of        nm_temp_inv_members_temp.tim_ne_id_of%TYPE
                   ,pi_tim_extent_begin_mp nm_temp_inv_members_temp.tim_extent_begin_mp%TYPE
                   ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                   ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_timt');
--
   -- No lock procedure - a temporary table
   DELETE /*+ INDEX (timt TIM_TEMP_PK) */ nm_temp_inv_members_temp timt
   WHERE  timt.tim_njc_job_id      = pi_tim_njc_job_id
    AND   timt.tim_ne_id_in        = pi_tim_ne_id_in
    AND   timt.tim_ne_id_in_new    = pi_tim_ne_id_in_new
    AND   timt.tim_ne_id_of        = pi_tim_ne_id_of
    AND   timt.tim_extent_begin_mp = pi_tim_extent_begin_mp;
   IF SQL%ROWCOUNT = 0 AND pi_raise_not_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_temp_inv_members_temp (TIM_TEMP_PK)'
                                              ||CHR(10)||'tim_njc_job_id      => '||pi_tim_njc_job_id
                                              ||CHR(10)||'tim_ne_id_in        => '||pi_tim_ne_id_in
                                              ||CHR(10)||'tim_ne_id_in_new    => '||pi_tim_ne_id_in_new
                                              ||CHR(10)||'tim_ne_id_of        => '||pi_tim_ne_id_of
                                              ||CHR(10)||'tim_extent_begin_mp => '||pi_tim_extent_begin_mp
                    );
   END IF;
--
--
   nm_debug.proc_end(g_package_name,'del_timt');
--
END del_timt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NM_TEMP_NODES_PK constraint
--
PROCEDURE del_ntn (pi_ntn_route_id      nm_temp_nodes.ntn_route_id%TYPE
                  ,pi_ntn_node_id       nm_temp_nodes.ntn_node_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ntn');
--
   -- No lock procedure - a temporary table
   DELETE /*+ INDEX (ntn NM_TEMP_NODES_PK) */ nm_temp_nodes ntn
   WHERE  ntn.ntn_route_id = pi_ntn_route_id
    AND   ntn.ntn_node_id  = pi_ntn_node_id;
   IF SQL%ROWCOUNT = 0 AND pi_raise_not_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_temp_nodes (NM_TEMP_NODES_PK)'
                                              ||CHR(10)||'ntn_route_id => '||pi_ntn_route_id
                                              ||CHR(10)||'ntn_node_id  => '||pi_ntn_node_id
                    );
   END IF;
--
--
   nm_debug.proc_end(g_package_name,'del_ntn');
--
END del_ntn;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NTH_PK constraint
--
PROCEDURE del_nth (pi_nth_theme_id      nm_themes_all.nth_theme_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nth');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nth
                   (pi_nth_theme_id      => pi_nth_theme_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_themes_all nth
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nth');
--
END del_nth;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NTH_UK constraint
--
PROCEDURE del_nth (pi_nth_theme_name    nm_themes_all.nth_theme_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nth');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nth
                   (pi_nth_theme_name    => pi_nth_theme_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_themes_all nth
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nth');
--
END del_nth;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NTG_UK constraint
--
PROCEDURE del_ntg (pi_ntg_theme_id      nm_theme_gtypes.ntg_theme_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ntg');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ntg
                   (pi_ntg_theme_id      => pi_ntg_theme_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_theme_gtypes ntg
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ntg');
--
END del_ntg;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NTF_PK constraint
--
PROCEDURE del_ntf (pi_ntf_nth_theme_id  nm_theme_functions_all.ntf_nth_theme_id%TYPE
                  ,pi_ntf_hmo_module    nm_theme_functions_all.ntf_hmo_module%TYPE
                  ,pi_ntf_parameter     nm_theme_functions_all.ntf_parameter%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ntf');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ntf
                   (pi_ntf_nth_theme_id  => pi_ntf_nth_theme_id
                   ,pi_ntf_hmo_module    => pi_ntf_hmo_module
                   ,pi_ntf_parameter     => pi_ntf_parameter
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_theme_functions_all ntf
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ntf');
--
END del_ntf;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NTHR_PK constraint
--
PROCEDURE del_nthr (pi_nthr_role         nm_theme_roles.nthr_role%TYPE
                   ,pi_nthr_theme_id     nm_theme_roles.nthr_theme_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nthr');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nthr
                   (pi_nthr_role         => pi_nthr_role
                   ,pi_nthr_theme_id     => pi_nthr_theme_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_theme_roles nthr
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nthr');
--
END del_nthr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NTS_PK constraint
--
PROCEDURE del_nts (pi_nts_theme_id      nm_theme_snaps.nts_theme_id%TYPE
                  ,pi_nts_snap_to       nm_theme_snaps.nts_snap_to%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nts');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nts
                   (pi_nts_theme_id      => pi_nts_theme_id
                   ,pi_nts_snap_to       => pi_nts_snap_to
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_theme_snaps nts
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nts');
--
END del_nts;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NT_PK constraint
--
PROCEDURE del_nt (pi_nt_type           nm_types.nt_type%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nt');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nt
                   (pi_nt_type           => pi_nt_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_types nt
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nt');
--
END del_nt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NT_UK constraint
--
PROCEDURE del_nt (pi_nt_unique         nm_types.nt_unique%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nt');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nt
                   (pi_nt_unique         => pi_nt_unique
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_types nt
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nt');
--
END del_nt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NTC_PK constraint
--
PROCEDURE del_ntc (pi_ntc_nt_type       nm_type_columns.ntc_nt_type%TYPE
                  ,pi_ntc_column_name   nm_type_columns.ntc_column_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ntc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ntc
                   (pi_ntc_nt_type       => pi_ntc_nt_type
                   ,pi_ntc_column_name   => pi_ntc_column_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_type_columns ntc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ntc');
--
END del_ntc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NTI_PK constraint
--
PROCEDURE del_nti (pi_nti_nw_parent_type nm_type_inclusion.nti_nw_parent_type%TYPE
                  ,pi_nti_nw_child_type  nm_type_inclusion.nti_nw_child_type%TYPE
                  ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nti');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nti
                   (pi_nti_nw_parent_type => pi_nti_nw_parent_type
                   ,pi_nti_nw_child_type  => pi_nti_nw_child_type
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   ,pi_locked_sqlcode     => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_type_inclusion nti
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nti');
--
END del_nti;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NTI_UK constraint
--
PROCEDURE del_nti (pi_nti_nw_child_type nm_type_inclusion.nti_nw_child_type%TYPE
                  ,pi_nti_child_column  nm_type_inclusion.nti_child_column%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nti');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nti
                   (pi_nti_nw_child_type => pi_nti_nw_child_type
                   ,pi_nti_child_column  => pi_nti_child_column
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_type_inclusion nti
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nti');
--
END del_nti;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NTL_PK constraint
--
PROCEDURE del_ntl (pi_ntl_nt_type       nm_type_layers.ntl_nt_type%TYPE
                  ,pi_ntl_layer_id      nm_type_layers.ntl_layer_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ntl');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ntl
                   (pi_ntl_nt_type       => pi_ntl_nt_type
                   ,pi_ntl_layer_id      => pi_ntl_layer_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_type_layers ntl
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ntl');
--
END del_ntl;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NTL_PK constraint
--
PROCEDURE del_ntl_all (pi_ntl_nt_type       nm_type_layers_all.ntl_nt_type%TYPE
                      ,pi_ntl_layer_id      nm_type_layers_all.ntl_layer_id%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ntl_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ntl_all
                   (pi_ntl_nt_type       => pi_ntl_nt_type
                   ,pi_ntl_layer_id      => pi_ntl_layer_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_type_layers_all ntl_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ntl_all');
--
END del_ntl_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NSC_PK constraint
--
PROCEDURE del_nsc (pi_nsc_nw_type       nm_type_subclass.nsc_nw_type%TYPE
                  ,pi_nsc_sub_class     nm_type_subclass.nsc_sub_class%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nsc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nsc
                   (pi_nsc_nw_type       => pi_nsc_nw_type
                   ,pi_nsc_sub_class     => pi_nsc_sub_class
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_type_subclass nsc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nsc');
--
END del_nsc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NSR_PK constraint
--
PROCEDURE del_nsr (pi_nsr_nw_type            nm_type_subclass_restrictions.nsr_nw_type%TYPE
                  ,pi_nsr_sub_class_new      nm_type_subclass_restrictions.nsr_sub_class_new%TYPE
                  ,pi_nsr_sub_class_existing nm_type_subclass_restrictions.nsr_sub_class_existing%TYPE
                  ,pi_raise_not_found        BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode      PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode         PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nsr');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nsr
                   (pi_nsr_nw_type            => pi_nsr_nw_type
                   ,pi_nsr_sub_class_new      => pi_nsr_sub_class_new
                   ,pi_nsr_sub_class_existing => pi_nsr_sub_class_existing
                   ,pi_raise_not_found        => pi_raise_not_found
                   ,pi_not_found_sqlcode      => pi_not_found_sqlcode
                   ,pi_locked_sqlcode         => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_type_subclass_restrictions nsr
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nsr');
--
END del_nsr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using UN_PK constraint
--
PROCEDURE del_un (pi_un_unit_id        nm_units.un_unit_id%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_un');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_un
                   (pi_un_unit_id        => pi_un_unit_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_units un
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_un');
--
END del_un;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using UC_PK constraint
--
PROCEDURE del_uc (pi_uc_unit_id_in     nm_unit_conversions.uc_unit_id_in%TYPE
                 ,pi_uc_unit_id_out    nm_unit_conversions.uc_unit_id_out%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_uc');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_uc
                   (pi_uc_unit_id_in     => pi_uc_unit_id_in
                   ,pi_uc_unit_id_out    => pi_uc_unit_id_out
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_unit_conversions uc
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_uc');
--
END del_uc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using UK_PK constraint
--
PROCEDURE del_ud (pi_ud_domain_id      nm_unit_domains.ud_domain_id%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ud');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_ud
                   (pi_ud_domain_id      => pi_ud_domain_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_unit_domains ud
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_ud');
--
END del_ud;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NUF_PK constraint
--
PROCEDURE del_nuf (pi_name              nm_upload_files.name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nuf');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nuf
                   (pi_name              => pi_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_upload_files nuf
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nuf');
--
END del_nuf;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NUFPART_PK constraint
--
PROCEDURE del_nufp (pi_document          nm_upload_filespart.document%TYPE
                   ,pi_part              nm_upload_filespart.part%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nufp');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nufp
                   (pi_document          => pi_document
                   ,pi_part              => pi_part
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_upload_filespart nufp
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nufp');
--
END del_nufp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NUA_PK constraint
--
PROCEDURE del_nua (pi_nua_user_id       nm_user_aus.nua_user_id%TYPE
                  ,pi_nua_admin_unit    nm_user_aus.nua_admin_unit%TYPE
                  ,pi_nua_start_date    nm_user_aus.nua_start_date%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nua');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nua
                   (pi_nua_user_id       => pi_nua_user_id
                   ,pi_nua_admin_unit    => pi_nua_admin_unit
                   ,pi_nua_start_date    => pi_nua_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_user_aus nua
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nua');
--
END del_nua;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NUA_PK constraint (without start date for Datetrack View)
--
PROCEDURE del_nua (pi_nua_user_id       nm_user_aus.nua_user_id%TYPE
                  ,pi_nua_admin_unit    nm_user_aus.nua_admin_unit%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nua');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nua
                   (pi_nua_user_id       => pi_nua_user_id
                   ,pi_nua_admin_unit    => pi_nua_admin_unit
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_user_aus nua
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nua');
--
END del_nua;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NUA_PK constraint
--
PROCEDURE del_nua_all (pi_nua_user_id       nm_user_aus_all.nua_user_id%TYPE
                      ,pi_nua_admin_unit    nm_user_aus_all.nua_admin_unit%TYPE
                      ,pi_nua_start_date    nm_user_aus_all.nua_start_date%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nua_all');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nua_all
                   (pi_nua_user_id       => pi_nua_user_id
                   ,pi_nua_admin_unit    => pi_nua_admin_unit
                   ,pi_nua_start_date    => pi_nua_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_user_aus_all nua_all
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nua_all');
--
END del_nua_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NVA_PK constraint
--
PROCEDURE del_nva (pi_nva_id            nm_visual_attributes.nva_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nva');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nva
                   (pi_nva_id            => pi_nva_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_visual_attributes nva
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nva');
--
END del_nva;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NM_XML_FILES_PK constraint
--
PROCEDURE del_nxf (pi_nxf_file_type     nm_xml_files.nxf_file_type%TYPE
                  ,pi_nxf_type          nm_xml_files.nxf_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nxf');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nxf
                   (pi_nxf_file_type     => pi_nxf_file_type
                   ,pi_nxf_type          => pi_nxf_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_xml_files nxf
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nxf');
--
END del_nxf;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NM_XML_BATCHES_PK constraint
--
PROCEDURE del_nxb (pi_nxb_batch_id      nm_xml_load_batches.nxb_batch_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nxb');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nxb
                   (pi_nxb_batch_id      => pi_nxb_batch_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_xml_load_batches nxb
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nxb');
--
END del_nxb;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NM_XML_LOAD_ERRORS_PK constraint
--
PROCEDURE del_nxle (pi_nxl_batch_id      nm_xml_load_errors.nxl_batch_id%TYPE
                   ,pi_nxl_record_id     nm_xml_load_errors.nxl_record_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nxle');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nxle
                   (pi_nxl_batch_id      => pi_nxl_batch_id
                   ,pi_nxl_record_id     => pi_nxl_record_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_xml_load_errors nxle
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nxle');
--
END del_nxle;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NWX_PK constraint
--
PROCEDURE del_nwx (pi_nwx_nw_type       nm_nw_xsp.nwx_nw_type%TYPE
                  ,pi_nwx_x_sect        nm_nw_xsp.nwx_x_sect%TYPE
                  ,pi_nwx_nsc_sub_class nm_nw_xsp.nwx_nsc_sub_class%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nwx');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nwx
                   (pi_nwx_nw_type       => pi_nwx_nw_type
                   ,pi_nwx_x_sect        => pi_nwx_x_sect
                   ,pi_nwx_nsc_sub_class => pi_nwx_nsc_sub_class
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_nw_xsp nwx
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nwx');
--
END del_nwx;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NXD_PK constraint
--
PROCEDURE del_nxd (pi_nxd_rule_id       nm_x_driving_conditions.nxd_rule_id%TYPE
                  ,pi_nxd_rule_seq_no   nm_x_driving_conditions.nxd_rule_seq_no%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nxd');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nxd
                   (pi_nxd_rule_id       => pi_nxd_rule_id
                   ,pi_nxd_rule_seq_no   => pi_nxd_rule_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_x_driving_conditions nxd
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nxd');
--
END del_nxd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NXE_PK constraint
--
PROCEDURE del_nxe (pi_nxe_id            nm_x_errors.nxe_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nxe');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nxe
                   (pi_nxe_id            => pi_nxe_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_x_errors nxe
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nxe');
--
END del_nxe;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NXIC_PK constraint
--
PROCEDURE del_nxic (pi_nxic_id           nm_x_inv_conditions.nxic_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nxic');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nxic
                   (pi_nxic_id           => pi_nxic_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_x_inv_conditions nxic
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nxic');
--
END del_nxic;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NXL_PK constraint
--
PROCEDURE del_nxl (pi_nxl_rule_id       nm_x_location_rules.nxl_rule_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nxl');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nxl
                   (pi_nxl_rule_id       => pi_nxl_rule_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_x_location_rules nxl
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nxl');
--
END del_nxl;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NXN_PK constraint
--
PROCEDURE del_nxn (pi_nxn_rule_id       nm_x_nw_rules.nxn_rule_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nxn');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nxn
                   (pi_nxn_rule_id       => pi_nxn_rule_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_x_nw_rules nxn
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nxn');
--
END del_nxn;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using PK_NM_X_RULES constraint
--
PROCEDURE del_nxr (pi_nxr_rule_id       nm_x_rules.nxr_rule_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nxr');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nxr
                   (pi_nxr_rule_id       => pi_nxr_rule_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_x_rules nxr
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nxr');
--
END del_nxr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NXV_PK constraint
--
PROCEDURE del_nxv (pi_nxv_rule_id       nm_x_val_conditions.nxv_rule_id%TYPE
                  ,pi_nxv_rule_seq_no   nm_x_val_conditions.nxv_rule_seq_no%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nxv');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_nxv
                   (pi_nxv_rule_id       => pi_nxv_rule_id
                   ,pi_nxv_rule_seq_no   => pi_nxv_rule_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_x_val_conditions nxv
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nxv');
--
END del_nxv;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using XSR_PK constraint
--
PROCEDURE del_xsr (pi_xsr_nw_type       nm_xsp_restraints.xsr_nw_type%TYPE
                  ,pi_xsr_ity_inv_code  nm_xsp_restraints.xsr_ity_inv_code%TYPE
                  ,pi_xsr_scl_class     nm_xsp_restraints.xsr_scl_class%TYPE
                  ,pi_xsr_x_sect_value  nm_xsp_restraints.xsr_x_sect_value%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_xsr');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_xsr
                   (pi_xsr_nw_type       => pi_xsr_nw_type
                   ,pi_xsr_ity_inv_code  => pi_xsr_ity_inv_code
                   ,pi_xsr_scl_class     => pi_xsr_scl_class
                   ,pi_xsr_x_sect_value  => pi_xsr_x_sect_value
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_xsp_restraints xsr
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_xsr');
--
END del_xsr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using XRV_PK constraint
--
PROCEDURE del_xrv (pi_xrv_nw_type       nm_xsp_reversal.xrv_nw_type%TYPE
                  ,pi_xrv_old_sub_class nm_xsp_reversal.xrv_old_sub_class%TYPE
                  ,pi_xrv_old_xsp       nm_xsp_reversal.xrv_old_xsp%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_xrv');
--
   -- Lock the row first
   l_rowid := nm3lock_gen.lock_xrv
                   (pi_xrv_nw_type       => pi_xrv_nw_type
                   ,pi_xrv_old_sub_class => pi_xrv_old_sub_class
                   ,pi_xrv_old_xsp       => pi_xrv_old_xsp
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_xsp_reversal xrv
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_xrv');
--
END del_xrv;
--
-----------------------------------------------------------------------------
--
END nm3del;
/
