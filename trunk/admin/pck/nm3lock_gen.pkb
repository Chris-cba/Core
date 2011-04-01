CREATE OR REPLACE PACKAGE BODY nm3lock_gen IS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3lock_gen.pkb-arc   2.19   Apr 01 2011 12:51:54   Mike.Alexander  $
--       Module Name      : $Workfile:   nm3lock_gen.pkb  $
--       Date into PVCS   : $Date:   Apr 01 2011 12:51:54  $
--       Date fetched Out : $Modtime:   Mar 31 2011 16:06:26  $
--       PVCS Version     : $Revision:   2.19  $
--
--
--   Author : Jonathan Mills
--
--   Generated package DO NOT MODIFY
--
--   nm3get_gen header : "@(#)nm3get_gen.pkh	1.3 12/05/05"
--   nm3get_gen body   : "$Revision:   2.19  $"
--
-----------------------------------------------------------------------------
--
--	Copyright (c) exor corporation ltd, 2005
--
-----------------------------------------------------------------------------
--
   g_body_sccsid CONSTANT  VARCHAR2(2000) := '"$Revision:   2.19  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3lock_gen';
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
--   Function to lock using DOC_PK constraint
--
FUNCTION lock_doc (pi_doc_id            docs.doc_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_doc IS
   SELECT /*+ INDEX (doc DOC_PK) */ ROWID
    FROM  docs doc
   WHERE  doc.doc_id = pi_doc_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_doc');
--
   OPEN  cs_doc;
   FETCH cs_doc INTO l_retval;
   l_found := cs_doc%FOUND;
   CLOSE cs_doc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'docs (DOC_PK)'
                                              ||CHR(10)||'doc_id => '||pi_doc_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_doc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'docs (DOC_PK)'
                                              ||CHR(10)||'doc_id => '||pi_doc_id
                    );
--
END lock_doc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DOC_PK constraint
--
PROCEDURE lock_doc (pi_doc_id            docs.doc_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_doc');
--
   l_rowid := lock_doc
                   (pi_doc_id            => pi_doc_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_doc');
--
END lock_doc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DAC_PK constraint
--
FUNCTION lock_dac (pi_dac_id            doc_actions.dac_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dac IS
   SELECT /*+ INDEX (dac DAC_PK) */ ROWID
    FROM  doc_actions dac
   WHERE  dac.dac_id = pi_dac_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dac');
--
   OPEN  cs_dac;
   FETCH cs_dac INTO l_retval;
   l_found := cs_dac%FOUND;
   CLOSE cs_dac;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_actions (DAC_PK)'
                                              ||CHR(10)||'dac_id => '||pi_dac_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dac');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_actions (DAC_PK)'
                                              ||CHR(10)||'dac_id => '||pi_dac_id
                    );
--
END lock_dac;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DAC_PK constraint
--
PROCEDURE lock_dac (pi_dac_id            doc_actions.dac_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dac');
--
   l_rowid := lock_dac
                   (pi_dac_id            => pi_dac_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dac');
--
END lock_dac;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DAS_PK constraint
--
FUNCTION lock_das (pi_das_table_name    doc_assocs.das_table_name%TYPE
                  ,pi_das_rec_id        doc_assocs.das_rec_id%TYPE
                  ,pi_das_doc_id        doc_assocs.das_doc_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_das IS
   SELECT /*+ INDEX (das DAS_PK) */ ROWID
    FROM  doc_assocs das
   WHERE  das.das_table_name = pi_das_table_name
    AND   das.das_rec_id     = pi_das_rec_id
    AND   das.das_doc_id     = pi_das_doc_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_das');
--
   OPEN  cs_das;
   FETCH cs_das INTO l_retval;
   l_found := cs_das%FOUND;
   CLOSE cs_das;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_assocs (DAS_PK)'
                                              ||CHR(10)||'das_table_name => '||pi_das_table_name
                                              ||CHR(10)||'das_rec_id     => '||pi_das_rec_id
                                              ||CHR(10)||'das_doc_id     => '||pi_das_doc_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_das');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_assocs (DAS_PK)'
                                              ||CHR(10)||'das_table_name => '||pi_das_table_name
                                              ||CHR(10)||'das_rec_id     => '||pi_das_rec_id
                                              ||CHR(10)||'das_doc_id     => '||pi_das_doc_id
                    );
--
END lock_das;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DAS_PK constraint
--
PROCEDURE lock_das (pi_das_table_name    doc_assocs.das_table_name%TYPE
                   ,pi_das_rec_id        doc_assocs.das_rec_id%TYPE
                   ,pi_das_doc_id        doc_assocs.das_doc_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_das');
--
   l_rowid := lock_das
                   (pi_das_table_name    => pi_das_table_name
                   ,pi_das_rec_id        => pi_das_rec_id
                   ,pi_das_doc_id        => pi_das_doc_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_das');
--
END lock_das;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DCL_PK constraint
--
FUNCTION lock_dcl (pi_dcl_dtp_code      doc_class.dcl_dtp_code%TYPE
                  ,pi_dcl_code          doc_class.dcl_code%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dcl IS
   SELECT /*+ INDEX (dcl DCL_PK) */ ROWID
    FROM  doc_class dcl
   WHERE  dcl.dcl_dtp_code = pi_dcl_dtp_code
    AND   dcl.dcl_code     = pi_dcl_code
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dcl');
--
   OPEN  cs_dcl;
   FETCH cs_dcl INTO l_retval;
   l_found := cs_dcl%FOUND;
   CLOSE cs_dcl;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_class (DCL_PK)'
                                              ||CHR(10)||'dcl_dtp_code => '||pi_dcl_dtp_code
                                              ||CHR(10)||'dcl_code     => '||pi_dcl_code
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dcl');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_class (DCL_PK)'
                                              ||CHR(10)||'dcl_dtp_code => '||pi_dcl_dtp_code
                                              ||CHR(10)||'dcl_code     => '||pi_dcl_code
                    );
--
END lock_dcl;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DCL_PK constraint
--
PROCEDURE lock_dcl (pi_dcl_dtp_code      doc_class.dcl_dtp_code%TYPE
                   ,pi_dcl_code          doc_class.dcl_code%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dcl');
--
   l_rowid := lock_dcl
                   (pi_dcl_dtp_code      => pi_dcl_dtp_code
                   ,pi_dcl_code          => pi_dcl_code
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dcl');
--
END lock_dcl;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DCL_UK1 constraint
--
FUNCTION lock_dcl (pi_dcl_name          doc_class.dcl_name%TYPE
                  ,pi_dcl_dtp_code      doc_class.dcl_dtp_code%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dcl IS
   SELECT /*+ INDEX (dcl DCL_UK1) */ ROWID
    FROM  doc_class dcl
   WHERE  dcl.dcl_name     = pi_dcl_name
    AND   dcl.dcl_dtp_code = pi_dcl_dtp_code
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dcl');
--
   OPEN  cs_dcl;
   FETCH cs_dcl INTO l_retval;
   l_found := cs_dcl%FOUND;
   CLOSE cs_dcl;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_class (DCL_UK1)'
                                              ||CHR(10)||'dcl_name     => '||pi_dcl_name
                                              ||CHR(10)||'dcl_dtp_code => '||pi_dcl_dtp_code
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dcl');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_class (DCL_UK1)'
                                              ||CHR(10)||'dcl_name     => '||pi_dcl_name
                                              ||CHR(10)||'dcl_dtp_code => '||pi_dcl_dtp_code
                    );
--
END lock_dcl;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DCL_UK1 constraint
--
PROCEDURE lock_dcl (pi_dcl_name          doc_class.dcl_name%TYPE
                   ,pi_dcl_dtp_code      doc_class.dcl_dtp_code%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dcl');
--
   l_rowid := lock_dcl
                   (pi_dcl_name          => pi_dcl_name
                   ,pi_dcl_dtp_code      => pi_dcl_dtp_code
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dcl');
--
END lock_dcl;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DCP_PK constraint
--
FUNCTION lock_dcp (pi_dcp_doc_id        doc_copies.dcp_doc_id%TYPE
                  ,pi_dcp_id            doc_copies.dcp_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dcp IS
   SELECT /*+ INDEX (dcp DCP_PK) */ ROWID
    FROM  doc_copies dcp
   WHERE  dcp.dcp_doc_id = pi_dcp_doc_id
    AND   dcp.dcp_id     = pi_dcp_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dcp');
--
   OPEN  cs_dcp;
   FETCH cs_dcp INTO l_retval;
   l_found := cs_dcp%FOUND;
   CLOSE cs_dcp;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_copies (DCP_PK)'
                                              ||CHR(10)||'dcp_doc_id => '||pi_dcp_doc_id
                                              ||CHR(10)||'dcp_id     => '||pi_dcp_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dcp');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_copies (DCP_PK)'
                                              ||CHR(10)||'dcp_doc_id => '||pi_dcp_doc_id
                                              ||CHR(10)||'dcp_id     => '||pi_dcp_id
                    );
--
END lock_dcp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DCP_PK constraint
--
PROCEDURE lock_dcp (pi_dcp_doc_id        doc_copies.dcp_doc_id%TYPE
                   ,pi_dcp_id            doc_copies.dcp_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dcp');
--
   l_rowid := lock_dcp
                   (pi_dcp_doc_id        => pi_dcp_doc_id
                   ,pi_dcp_id            => pi_dcp_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dcp');
--
END lock_dcp;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DDG_PK constraint
--
FUNCTION lock_ddg (pi_ddg_id            doc_damage.ddg_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_ddg IS
   SELECT /*+ INDEX (ddg DDG_PK) */ ROWID
    FROM  doc_damage ddg
   WHERE  ddg.ddg_id = pi_ddg_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ddg');
--
   OPEN  cs_ddg;
   FETCH cs_ddg INTO l_retval;
   l_found := cs_ddg%FOUND;
   CLOSE cs_ddg;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_damage (DDG_PK)'
                                              ||CHR(10)||'ddg_id => '||pi_ddg_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ddg');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_damage (DDG_PK)'
                                              ||CHR(10)||'ddg_id => '||pi_ddg_id
                    );
--
END lock_ddg;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DDG_PK constraint
--
PROCEDURE lock_ddg (pi_ddg_id            doc_damage.ddg_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ddg');
--
   l_rowid := lock_ddg
                   (pi_ddg_id            => pi_ddg_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ddg');
--
END lock_ddg;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DDC_PK constraint
--
FUNCTION lock_ddc (pi_ddc_id            doc_damage_costs.ddc_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_ddc IS
   SELECT /*+ INDEX (ddc DDC_PK) */ ROWID
    FROM  doc_damage_costs ddc
   WHERE  ddc.ddc_id = pi_ddc_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ddc');
--
   OPEN  cs_ddc;
   FETCH cs_ddc INTO l_retval;
   l_found := cs_ddc%FOUND;
   CLOSE cs_ddc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_damage_costs (DDC_PK)'
                                              ||CHR(10)||'ddc_id => '||pi_ddc_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ddc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_damage_costs (DDC_PK)'
                                              ||CHR(10)||'ddc_id => '||pi_ddc_id
                    );
--
END lock_ddc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DDC_PK constraint
--
PROCEDURE lock_ddc (pi_ddc_id            doc_damage_costs.ddc_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ddc');
--
   l_rowid := lock_ddc
                   (pi_ddc_id            => pi_ddc_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ddc');
--
END lock_ddc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DEC_PK constraint
--
FUNCTION lock_dec (pi_dec_hct_id        doc_enquiry_contacts.dec_hct_id%TYPE
                  ,pi_dec_doc_id        doc_enquiry_contacts.dec_doc_id%TYPE
                  ,pi_dec_type          doc_enquiry_contacts.dec_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dec IS
   SELECT /*+ INDEX (dec DEC_PK) */ ROWID
    FROM  doc_enquiry_contacts dec
   WHERE  dec.dec_hct_id = pi_dec_hct_id
    AND   dec.dec_doc_id = pi_dec_doc_id
    AND   dec.dec_type   = pi_dec_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dec');
--
   OPEN  cs_dec;
   FETCH cs_dec INTO l_retval;
   l_found := cs_dec%FOUND;
   CLOSE cs_dec;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_enquiry_contacts (DEC_PK)'
                                              ||CHR(10)||'dec_hct_id => '||pi_dec_hct_id
                                              ||CHR(10)||'dec_doc_id => '||pi_dec_doc_id
                                              ||CHR(10)||'dec_type   => '||pi_dec_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dec');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_enquiry_contacts (DEC_PK)'
                                              ||CHR(10)||'dec_hct_id => '||pi_dec_hct_id
                                              ||CHR(10)||'dec_doc_id => '||pi_dec_doc_id
                                              ||CHR(10)||'dec_type   => '||pi_dec_type
                    );
--
END lock_dec;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DEC_PK constraint
--
PROCEDURE lock_dec (pi_dec_hct_id        doc_enquiry_contacts.dec_hct_id%TYPE
                   ,pi_dec_doc_id        doc_enquiry_contacts.dec_doc_id%TYPE
                   ,pi_dec_type          doc_enquiry_contacts.dec_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dec');
--
   l_rowid := lock_dec
                   (pi_dec_hct_id        => pi_dec_hct_id
                   ,pi_dec_doc_id        => pi_dec_doc_id
                   ,pi_dec_type          => pi_dec_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dec');
--
END lock_dec;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DET_PK constraint
--
FUNCTION lock_det (pi_det_dtp_code      doc_enquiry_types.det_dtp_code%TYPE
                  ,pi_det_dcl_code      doc_enquiry_types.det_dcl_code%TYPE
                  ,pi_det_code          doc_enquiry_types.det_code%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_det IS
   SELECT /*+ INDEX (det DET_PK) */ ROWID
    FROM  doc_enquiry_types det
   WHERE  det.det_dtp_code = pi_det_dtp_code
    AND   det.det_dcl_code = pi_det_dcl_code
    AND   det.det_code     = pi_det_code
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_det');
--
   OPEN  cs_det;
   FETCH cs_det INTO l_retval;
   l_found := cs_det%FOUND;
   CLOSE cs_det;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_enquiry_types (DET_PK)'
                                              ||CHR(10)||'det_dtp_code => '||pi_det_dtp_code
                                              ||CHR(10)||'det_dcl_code => '||pi_det_dcl_code
                                              ||CHR(10)||'det_code     => '||pi_det_code
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_det');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_enquiry_types (DET_PK)'
                                              ||CHR(10)||'det_dtp_code => '||pi_det_dtp_code
                                              ||CHR(10)||'det_dcl_code => '||pi_det_dcl_code
                                              ||CHR(10)||'det_code     => '||pi_det_code
                    );
--
END lock_det;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DET_PK constraint
--
PROCEDURE lock_det (pi_det_dtp_code      doc_enquiry_types.det_dtp_code%TYPE
                   ,pi_det_dcl_code      doc_enquiry_types.det_dcl_code%TYPE
                   ,pi_det_code          doc_enquiry_types.det_code%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_det');
--
   l_rowid := lock_det
                   (pi_det_dtp_code      => pi_det_dtp_code
                   ,pi_det_dcl_code      => pi_det_dcl_code
                   ,pi_det_code          => pi_det_code
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_det');
--
END lock_det;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DET_UNQ constraint
--
FUNCTION lock_det (pi_det_dtp_code      doc_enquiry_types.det_dtp_code%TYPE
                  ,pi_det_dcl_code      doc_enquiry_types.det_dcl_code%TYPE
                  ,pi_det_code          doc_enquiry_types.det_code%TYPE
                  ,pi_det_name          doc_enquiry_types.det_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_det IS
   SELECT /*+ INDEX (det DET_UNQ) */ ROWID
    FROM  doc_enquiry_types det
   WHERE  det.det_dtp_code = pi_det_dtp_code
    AND   det.det_dcl_code = pi_det_dcl_code
    AND   det.det_code     = pi_det_code
    AND   det.det_name     = pi_det_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_det');
--
   OPEN  cs_det;
   FETCH cs_det INTO l_retval;
   l_found := cs_det%FOUND;
   CLOSE cs_det;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_enquiry_types (DET_UNQ)'
                                              ||CHR(10)||'det_dtp_code => '||pi_det_dtp_code
                                              ||CHR(10)||'det_dcl_code => '||pi_det_dcl_code
                                              ||CHR(10)||'det_code     => '||pi_det_code
                                              ||CHR(10)||'det_name     => '||pi_det_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_det');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_enquiry_types (DET_UNQ)'
                                              ||CHR(10)||'det_dtp_code => '||pi_det_dtp_code
                                              ||CHR(10)||'det_dcl_code => '||pi_det_dcl_code
                                              ||CHR(10)||'det_code     => '||pi_det_code
                                              ||CHR(10)||'det_name     => '||pi_det_name
                    );
--
END lock_det;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DET_UNQ constraint
--
PROCEDURE lock_det (pi_det_dtp_code      doc_enquiry_types.det_dtp_code%TYPE
                   ,pi_det_dcl_code      doc_enquiry_types.det_dcl_code%TYPE
                   ,pi_det_code          doc_enquiry_types.det_code%TYPE
                   ,pi_det_name          doc_enquiry_types.det_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_det');
--
   l_rowid := lock_det
                   (pi_det_dtp_code      => pi_det_dtp_code
                   ,pi_det_dcl_code      => pi_det_dcl_code
                   ,pi_det_code          => pi_det_code
                   ,pi_det_name          => pi_det_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_det');
--
END lock_det;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DGT_PK constraint
--
FUNCTION lock_dgt (pi_dgt_table_name    doc_gateways.dgt_table_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dgt IS
   SELECT /*+ INDEX (dgt DGT_PK) */ ROWID
    FROM  doc_gateways dgt
   WHERE  dgt.dgt_table_name = pi_dgt_table_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dgt');
--
   OPEN  cs_dgt;
   FETCH cs_dgt INTO l_retval;
   l_found := cs_dgt%FOUND;
   CLOSE cs_dgt;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_gateways (DGT_PK)'
                                              ||CHR(10)||'dgt_table_name => '||pi_dgt_table_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dgt');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_gateways (DGT_PK)'
                                              ||CHR(10)||'dgt_table_name => '||pi_dgt_table_name
                    );
--
END lock_dgt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DGT_PK constraint
--
PROCEDURE lock_dgt (pi_dgt_table_name    doc_gateways.dgt_table_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dgt');
--
   l_rowid := lock_dgt
                   (pi_dgt_table_name    => pi_dgt_table_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dgt');
--
END lock_dgt;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DGT_UK1 constraint
--
FUNCTION lock_dgt (pi_dgt_table_descr   doc_gateways.dgt_table_descr%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dgt IS
   SELECT /*+ INDEX (dgt DGT_UK1) */ ROWID
    FROM  doc_gateways dgt
   WHERE  dgt.dgt_table_descr = pi_dgt_table_descr
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dgt');
--
   OPEN  cs_dgt;
   FETCH cs_dgt INTO l_retval;
   l_found := cs_dgt%FOUND;
   CLOSE cs_dgt;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_gateways (DGT_UK1)'
                                              ||CHR(10)||'dgt_table_descr => '||pi_dgt_table_descr
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dgt');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_gateways (DGT_UK1)'
                                              ||CHR(10)||'dgt_table_descr => '||pi_dgt_table_descr
                    );
--
END lock_dgt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DGT_UK1 constraint
--
PROCEDURE lock_dgt (pi_dgt_table_descr   doc_gateways.dgt_table_descr%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dgt');
--
   l_rowid := lock_dgt
                   (pi_dgt_table_descr   => pi_dgt_table_descr
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dgt');
--
END lock_dgt;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DGS_PK constraint
--
FUNCTION lock_dgs (pi_dgs_dgt_table_name doc_gate_syns.dgs_dgt_table_name%TYPE
                  ,pi_dgs_table_syn      doc_gate_syns.dgs_table_syn%TYPE
                  ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dgs IS
   SELECT /*+ INDEX (dgs DGS_PK) */ ROWID
    FROM  doc_gate_syns dgs
   WHERE  dgs.dgs_dgt_table_name = pi_dgs_dgt_table_name
    AND   dgs.dgs_table_syn      = pi_dgs_table_syn
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dgs');
--
   OPEN  cs_dgs;
   FETCH cs_dgs INTO l_retval;
   l_found := cs_dgs%FOUND;
   CLOSE cs_dgs;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_gate_syns (DGS_PK)'
                                              ||CHR(10)||'dgs_dgt_table_name => '||pi_dgs_dgt_table_name
                                              ||CHR(10)||'dgs_table_syn      => '||pi_dgs_table_syn
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dgs');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_gate_syns (DGS_PK)'
                                              ||CHR(10)||'dgs_dgt_table_name => '||pi_dgs_dgt_table_name
                                              ||CHR(10)||'dgs_table_syn      => '||pi_dgs_table_syn
                    );
--
END lock_dgs;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DGS_PK constraint
--
PROCEDURE lock_dgs (pi_dgs_dgt_table_name doc_gate_syns.dgs_dgt_table_name%TYPE
                   ,pi_dgs_table_syn      doc_gate_syns.dgs_table_syn%TYPE
                   ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dgs');
--
   l_rowid := lock_dgs
                   (pi_dgs_dgt_table_name => pi_dgs_dgt_table_name
                   ,pi_dgs_table_syn      => pi_dgs_table_syn
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dgs');
--
END lock_dgs;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DHI_PK constraint
--
FUNCTION lock_dhi (pi_dhi_doc_id        doc_history.dhi_doc_id%TYPE
                  ,pi_dhi_date_changed  doc_history.dhi_date_changed%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dhi IS
   SELECT /*+ INDEX (dhi DHI_PK) */ ROWID
    FROM  doc_history dhi
   WHERE  dhi.dhi_doc_id       = pi_dhi_doc_id
    AND   dhi.dhi_date_changed = pi_dhi_date_changed
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dhi');
--
   OPEN  cs_dhi;
   FETCH cs_dhi INTO l_retval;
   l_found := cs_dhi%FOUND;
   CLOSE cs_dhi;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_history (DHI_PK)'
                                              ||CHR(10)||'dhi_doc_id       => '||pi_dhi_doc_id
                                              ||CHR(10)||'dhi_date_changed => '||pi_dhi_date_changed
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dhi');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_history (DHI_PK)'
                                              ||CHR(10)||'dhi_doc_id       => '||pi_dhi_doc_id
                                              ||CHR(10)||'dhi_date_changed => '||pi_dhi_date_changed
                    );
--
END lock_dhi;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DHI_PK constraint
--
PROCEDURE lock_dhi (pi_dhi_doc_id        doc_history.dhi_doc_id%TYPE
                   ,pi_dhi_date_changed  doc_history.dhi_date_changed%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dhi');
--
   l_rowid := lock_dhi
                   (pi_dhi_doc_id        => pi_dhi_doc_id
                   ,pi_dhi_date_changed  => pi_dhi_date_changed
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dhi');
--
END lock_dhi;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DKY_PK constraint
--
FUNCTION lock_dky (pi_dky_doc_id        doc_keys.dky_doc_id%TYPE
                  ,pi_dky_dkw_key_id    doc_keys.dky_dkw_key_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dky IS
   SELECT /*+ INDEX (dky DKY_PK) */ ROWID
    FROM  doc_keys dky
   WHERE  dky.dky_doc_id     = pi_dky_doc_id
    AND   dky.dky_dkw_key_id = pi_dky_dkw_key_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dky');
--
   OPEN  cs_dky;
   FETCH cs_dky INTO l_retval;
   l_found := cs_dky%FOUND;
   CLOSE cs_dky;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_keys (DKY_PK)'
                                              ||CHR(10)||'dky_doc_id     => '||pi_dky_doc_id
                                              ||CHR(10)||'dky_dkw_key_id => '||pi_dky_dkw_key_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dky');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_keys (DKY_PK)'
                                              ||CHR(10)||'dky_doc_id     => '||pi_dky_doc_id
                                              ||CHR(10)||'dky_dkw_key_id => '||pi_dky_dkw_key_id
                    );
--
END lock_dky;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DKY_PK constraint
--
PROCEDURE lock_dky (pi_dky_doc_id        doc_keys.dky_doc_id%TYPE
                   ,pi_dky_dkw_key_id    doc_keys.dky_dkw_key_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dky');
--
   l_rowid := lock_dky
                   (pi_dky_doc_id        => pi_dky_doc_id
                   ,pi_dky_dkw_key_id    => pi_dky_dkw_key_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dky');
--
END lock_dky;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DKW_PK constraint
--
FUNCTION lock_dkw (pi_dkw_key_id        doc_keywords.dkw_key_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dkw IS
   SELECT /*+ INDEX (dkw DKW_PK) */ ROWID
    FROM  doc_keywords dkw
   WHERE  dkw.dkw_key_id = pi_dkw_key_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dkw');
--
   OPEN  cs_dkw;
   FETCH cs_dkw INTO l_retval;
   l_found := cs_dkw%FOUND;
   CLOSE cs_dkw;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_keywords (DKW_PK)'
                                              ||CHR(10)||'dkw_key_id => '||pi_dkw_key_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dkw');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_keywords (DKW_PK)'
                                              ||CHR(10)||'dkw_key_id => '||pi_dkw_key_id
                    );
--
END lock_dkw;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DKW_PK constraint
--
PROCEDURE lock_dkw (pi_dkw_key_id        doc_keywords.dkw_key_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dkw');
--
   l_rowid := lock_dkw
                   (pi_dkw_key_id        => pi_dkw_key_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dkw');
--
END lock_dkw;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DLC_PK constraint
--
FUNCTION lock_dlc (pi_dlc_id            doc_locations.dlc_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dlc IS
   SELECT /*+ INDEX (dlc DLC_PK) */ ROWID
    FROM  doc_locations dlc
   WHERE  dlc.dlc_id = pi_dlc_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dlc');
--
   OPEN  cs_dlc;
   FETCH cs_dlc INTO l_retval;
   l_found := cs_dlc%FOUND;
   CLOSE cs_dlc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_locations (DLC_PK)'
                                              ||CHR(10)||'dlc_id => '||pi_dlc_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dlc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_locations (DLC_PK)'
                                              ||CHR(10)||'dlc_id => '||pi_dlc_id
                    );
--
END lock_dlc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DLC_PK constraint
--
PROCEDURE lock_dlc (pi_dlc_id            doc_locations.dlc_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dlc');
--
   l_rowid := lock_dlc
                   (pi_dlc_id            => pi_dlc_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dlc');
--
END lock_dlc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DLC_UK constraint
--
FUNCTION lock_dlc (pi_dlc_name          doc_locations.dlc_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dlc IS
   SELECT /*+ INDEX (dlc DLC_UK) */ ROWID
    FROM  doc_locations dlc
   WHERE  dlc.dlc_name = pi_dlc_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dlc');
--
   OPEN  cs_dlc;
   FETCH cs_dlc INTO l_retval;
   l_found := cs_dlc%FOUND;
   CLOSE cs_dlc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_locations (DLC_UK)'
                                              ||CHR(10)||'dlc_name => '||pi_dlc_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dlc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_locations (DLC_UK)'
                                              ||CHR(10)||'dlc_name => '||pi_dlc_name
                    );
--
END lock_dlc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DLC_UK constraint
--
PROCEDURE lock_dlc (pi_dlc_name          doc_locations.dlc_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dlc');
--
   l_rowid := lock_dlc
                   (pi_dlc_name          => pi_dlc_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dlc');
--
END lock_dlc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DMD_PK constraint
--
FUNCTION lock_dmd (pi_dmd_id            doc_media.dmd_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dmd IS
   SELECT /*+ INDEX (dmd DMD_PK) */ ROWID
    FROM  doc_media dmd
   WHERE  dmd.dmd_id = pi_dmd_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dmd');
--
   OPEN  cs_dmd;
   FETCH cs_dmd INTO l_retval;
   l_found := cs_dmd%FOUND;
   CLOSE cs_dmd;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_media (DMD_PK)'
                                              ||CHR(10)||'dmd_id => '||pi_dmd_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dmd');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_media (DMD_PK)'
                                              ||CHR(10)||'dmd_id => '||pi_dmd_id
                    );
--
END lock_dmd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DMD_PK constraint
--
PROCEDURE lock_dmd (pi_dmd_id            doc_media.dmd_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dmd');
--
   l_rowid := lock_dmd
                   (pi_dmd_id            => pi_dmd_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dmd');
--
END lock_dmd;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DMD_UK constraint
--
FUNCTION lock_dmd (pi_dmd_name          doc_media.dmd_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dmd IS
   SELECT /*+ INDEX (dmd DMD_UK) */ ROWID
    FROM  doc_media dmd
   WHERE  dmd.dmd_name = pi_dmd_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dmd');
--
   OPEN  cs_dmd;
   FETCH cs_dmd INTO l_retval;
   l_found := cs_dmd%FOUND;
   CLOSE cs_dmd;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_media (DMD_UK)'
                                              ||CHR(10)||'dmd_name => '||pi_dmd_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dmd');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_media (DMD_UK)'
                                              ||CHR(10)||'dmd_name => '||pi_dmd_name
                    );
--
END lock_dmd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DMD_UK constraint
--
PROCEDURE lock_dmd (pi_dmd_name          doc_media.dmd_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dmd');
--
   l_rowid := lock_dmd
                   (pi_dmd_name          => pi_dmd_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dmd');
--
END lock_dmd;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DQ_PK constraint
--
FUNCTION lock_dq (pi_dq_id             doc_query.dq_id%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) RETURN ROWID IS
--
   CURSOR cs_dq IS
   SELECT /*+ INDEX (dq DQ_PK) */ ROWID
    FROM  doc_query dq
   WHERE  dq.dq_id = pi_dq_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dq');
--
   OPEN  cs_dq;
   FETCH cs_dq INTO l_retval;
   l_found := cs_dq%FOUND;
   CLOSE cs_dq;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_query (DQ_PK)'
                                              ||CHR(10)||'dq_id => '||pi_dq_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dq');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_query (DQ_PK)'
                                              ||CHR(10)||'dq_id => '||pi_dq_id
                    );
--
END lock_dq;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DQ_PK constraint
--
PROCEDURE lock_dq (pi_dq_id             doc_query.dq_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dq');
--
   l_rowid := lock_dq
                   (pi_dq_id             => pi_dq_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dq');
--
END lock_dq;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DQ_UK constraint
--
FUNCTION lock_dq (pi_dq_title          doc_query.dq_title%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) RETURN ROWID IS
--
   CURSOR cs_dq IS
   SELECT /*+ INDEX (dq DQ_UK) */ ROWID
    FROM  doc_query dq
   WHERE  dq.dq_title = pi_dq_title
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dq');
--
   OPEN  cs_dq;
   FETCH cs_dq INTO l_retval;
   l_found := cs_dq%FOUND;
   CLOSE cs_dq;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_query (DQ_UK)'
                                              ||CHR(10)||'dq_title => '||pi_dq_title
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dq');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_query (DQ_UK)'
                                              ||CHR(10)||'dq_title => '||pi_dq_title
                    );
--
END lock_dq;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DQ_UK constraint
--
PROCEDURE lock_dq (pi_dq_title          doc_query.dq_title%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dq');
--
   l_rowid := lock_dq
                   (pi_dq_title          => pi_dq_title
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dq');
--
END lock_dq;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DQC_PK constraint
--
FUNCTION lock_dqc (pi_dqc_dq_id         doc_query_cols.dqc_dq_id%TYPE
                  ,pi_dqc_seq_no        doc_query_cols.dqc_seq_no%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dqc IS
   SELECT /*+ INDEX (dqc DQC_PK) */ ROWID
    FROM  doc_query_cols dqc
   WHERE  dqc.dqc_dq_id  = pi_dqc_dq_id
    AND   dqc.dqc_seq_no = pi_dqc_seq_no
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dqc');
--
   OPEN  cs_dqc;
   FETCH cs_dqc INTO l_retval;
   l_found := cs_dqc%FOUND;
   CLOSE cs_dqc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_query_cols (DQC_PK)'
                                              ||CHR(10)||'dqc_dq_id  => '||pi_dqc_dq_id
                                              ||CHR(10)||'dqc_seq_no => '||pi_dqc_seq_no
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dqc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_query_cols (DQC_PK)'
                                              ||CHR(10)||'dqc_dq_id  => '||pi_dqc_dq_id
                                              ||CHR(10)||'dqc_seq_no => '||pi_dqc_seq_no
                    );
--
END lock_dqc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DQC_PK constraint
--
PROCEDURE lock_dqc (pi_dqc_dq_id         doc_query_cols.dqc_dq_id%TYPE
                   ,pi_dqc_seq_no        doc_query_cols.dqc_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dqc');
--
   l_rowid := lock_dqc
                   (pi_dqc_dq_id         => pi_dqc_dq_id
                   ,pi_dqc_seq_no        => pi_dqc_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dqc');
--
END lock_dqc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DSC_PK constraint
--
FUNCTION lock_dsc (pi_dsc_type          doc_std_costs.dsc_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dsc IS
   SELECT /*+ INDEX (dsc DSC_PK) */ ROWID
    FROM  doc_std_costs dsc
   WHERE  dsc.dsc_type = pi_dsc_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dsc');
--
   OPEN  cs_dsc;
   FETCH cs_dsc INTO l_retval;
   l_found := cs_dsc%FOUND;
   CLOSE cs_dsc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_std_costs (DSC_PK)'
                                              ||CHR(10)||'dsc_type => '||pi_dsc_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dsc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_std_costs (DSC_PK)'
                                              ||CHR(10)||'dsc_type => '||pi_dsc_type
                    );
--
END lock_dsc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DSC_PK constraint
--
PROCEDURE lock_dsc (pi_dsc_type          doc_std_costs.dsc_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dsc');
--
   l_rowid := lock_dsc
                   (pi_dsc_type          => pi_dsc_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dsc');
--
END lock_dsc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DSY_PK constraint
--
FUNCTION lock_dsy (pi_dsy_key_id        doc_synonyms.dsy_key_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dsy IS
   SELECT /*+ INDEX (dsy DSY_PK) */ ROWID
    FROM  doc_synonyms dsy
   WHERE  dsy.dsy_key_id = pi_dsy_key_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dsy');
--
   OPEN  cs_dsy;
   FETCH cs_dsy INTO l_retval;
   l_found := cs_dsy%FOUND;
   CLOSE cs_dsy;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_synonyms (DSY_PK)'
                                              ||CHR(10)||'dsy_key_id => '||pi_dsy_key_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dsy');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_synonyms (DSY_PK)'
                                              ||CHR(10)||'dsy_key_id => '||pi_dsy_key_id
                    );
--
END lock_dsy;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DSY_PK constraint
--
PROCEDURE lock_dsy (pi_dsy_key_id        doc_synonyms.dsy_key_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dsy');
--
   l_rowid := lock_dsy
                   (pi_dsy_key_id        => pi_dsy_key_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dsy');
--
END lock_dsy;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DTC_PK constraint
--
FUNCTION lock_dtc (pi_dtc_template_name doc_template_columns.dtc_template_name%TYPE
                  ,pi_dtc_col_alias     doc_template_columns.dtc_col_alias%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dtc IS
   SELECT /*+ INDEX (dtc DTC_PK) */ ROWID
    FROM  doc_template_columns dtc
   WHERE  dtc.dtc_template_name = pi_dtc_template_name
    AND   dtc.dtc_col_alias     = pi_dtc_col_alias
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dtc');
--
   OPEN  cs_dtc;
   FETCH cs_dtc INTO l_retval;
   l_found := cs_dtc%FOUND;
   CLOSE cs_dtc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_template_columns (DTC_PK)'
                                              ||CHR(10)||'dtc_template_name => '||pi_dtc_template_name
                                              ||CHR(10)||'dtc_col_alias     => '||pi_dtc_col_alias
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dtc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_template_columns (DTC_PK)'
                                              ||CHR(10)||'dtc_template_name => '||pi_dtc_template_name
                                              ||CHR(10)||'dtc_col_alias     => '||pi_dtc_col_alias
                    );
--
END lock_dtc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DTC_PK constraint
--
PROCEDURE lock_dtc (pi_dtc_template_name doc_template_columns.dtc_template_name%TYPE
                   ,pi_dtc_col_alias     doc_template_columns.dtc_col_alias%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dtc');
--
   l_rowid := lock_dtc
                   (pi_dtc_template_name => pi_dtc_template_name
                   ,pi_dtc_col_alias     => pi_dtc_col_alias
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dtc');
--
END lock_dtc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DTG_PK constraint
--
FUNCTION lock_dtg (pi_dtg_template_name doc_template_gateways.dtg_template_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dtg IS
   SELECT /*+ INDEX (dtg DTG_PK) */ ROWID
    FROM  doc_template_gateways dtg
   WHERE  dtg.dtg_template_name = pi_dtg_template_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dtg');
--
   OPEN  cs_dtg;
   FETCH cs_dtg INTO l_retval;
   l_found := cs_dtg%FOUND;
   CLOSE cs_dtg;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_template_gateways (DTG_PK)'
                                              ||CHR(10)||'dtg_template_name => '||pi_dtg_template_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dtg');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_template_gateways (DTG_PK)'
                                              ||CHR(10)||'dtg_template_name => '||pi_dtg_template_name
                    );
--
END lock_dtg;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DTG_PK constraint
--
PROCEDURE lock_dtg (pi_dtg_template_name doc_template_gateways.dtg_template_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dtg');
--
   l_rowid := lock_dtg
                   (pi_dtg_template_name => pi_dtg_template_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dtg');
--
END lock_dtg;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DTU_PK constraint
--
FUNCTION lock_dtu (pi_dtu_user_id       doc_template_users.dtu_user_id%TYPE
                  ,pi_dtu_template_name doc_template_users.dtu_template_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dtu IS
   SELECT /*+ INDEX (dtu DTU_PK) */ ROWID
    FROM  doc_template_users dtu
   WHERE  dtu.dtu_user_id       = pi_dtu_user_id
    AND   dtu.dtu_template_name = pi_dtu_template_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dtu');
--
   OPEN  cs_dtu;
   FETCH cs_dtu INTO l_retval;
   l_found := cs_dtu%FOUND;
   CLOSE cs_dtu;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_template_users (DTU_PK)'
                                              ||CHR(10)||'dtu_user_id       => '||pi_dtu_user_id
                                              ||CHR(10)||'dtu_template_name => '||pi_dtu_template_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dtu');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_template_users (DTU_PK)'
                                              ||CHR(10)||'dtu_user_id       => '||pi_dtu_user_id
                                              ||CHR(10)||'dtu_template_name => '||pi_dtu_template_name
                    );
--
END lock_dtu;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DTU_PK constraint
--
PROCEDURE lock_dtu (pi_dtu_user_id       doc_template_users.dtu_user_id%TYPE
                   ,pi_dtu_template_name doc_template_users.dtu_template_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dtu');
--
   l_rowid := lock_dtu
                   (pi_dtu_user_id       => pi_dtu_user_id
                   ,pi_dtu_template_name => pi_dtu_template_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dtu');
--
END lock_dtu;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DTP_PK constraint
--
FUNCTION lock_dtp (pi_dtp_code          doc_types.dtp_code%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dtp IS
   SELECT /*+ INDEX (dtp DTP_PK) */ ROWID
    FROM  doc_types dtp
   WHERE  dtp.dtp_code = pi_dtp_code
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dtp');
--
   OPEN  cs_dtp;
   FETCH cs_dtp INTO l_retval;
   l_found := cs_dtp%FOUND;
   CLOSE cs_dtp;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_types (DTP_PK)'
                                              ||CHR(10)||'dtp_code => '||pi_dtp_code
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dtp');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_types (DTP_PK)'
                                              ||CHR(10)||'dtp_code => '||pi_dtp_code
                    );
--
END lock_dtp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DTP_PK constraint
--
PROCEDURE lock_dtp (pi_dtp_code          doc_types.dtp_code%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dtp');
--
   l_rowid := lock_dtp
                   (pi_dtp_code          => pi_dtp_code
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dtp');
--
END lock_dtp;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using DTP_UK constraint
--
FUNCTION lock_dtp (pi_dtp_name          doc_types.dtp_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_dtp IS
   SELECT /*+ INDEX (dtp DTP_UK) */ ROWID
    FROM  doc_types dtp
   WHERE  dtp.dtp_name = pi_dtp_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dtp');
--
   OPEN  cs_dtp;
   FETCH cs_dtp INTO l_retval;
   l_found := cs_dtp%FOUND;
   CLOSE cs_dtp;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'doc_types (DTP_UK)'
                                              ||CHR(10)||'dtp_name => '||pi_dtp_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_dtp');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'doc_types (DTP_UK)'
                                              ||CHR(10)||'dtp_name => '||pi_dtp_name
                    );
--
END lock_dtp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using DTP_UK constraint
--
PROCEDURE lock_dtp (pi_dtp_name          doc_types.dtp_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_dtp');
--
   l_rowid := lock_dtp
                   (pi_dtp_name          => pi_dtp_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_dtp');
--
END lock_dtp;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using GL_PK constraint
--
FUNCTION lock_gl (pi_gl_job_id         gri_lov.gl_job_id%TYPE
                 ,pi_gl_param          gri_lov.gl_param%TYPE
                 ,pi_gl_return         gri_lov.gl_return%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) RETURN ROWID IS
--
   CURSOR cs_gl IS
   SELECT /*+ INDEX (gl GL_PK) */ ROWID
    FROM  gri_lov gl
   WHERE  gl.gl_job_id = pi_gl_job_id
    AND   gl.gl_param  = pi_gl_param
    AND   gl.gl_return = pi_gl_return
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_gl');
--
   OPEN  cs_gl;
   FETCH cs_gl INTO l_retval;
   l_found := cs_gl%FOUND;
   CLOSE cs_gl;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'gri_lov (GL_PK)'
                                              ||CHR(10)||'gl_job_id => '||pi_gl_job_id
                                              ||CHR(10)||'gl_param  => '||pi_gl_param
                                              ||CHR(10)||'gl_return => '||pi_gl_return
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_gl');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'gri_lov (GL_PK)'
                                              ||CHR(10)||'gl_job_id => '||pi_gl_job_id
                                              ||CHR(10)||'gl_param  => '||pi_gl_param
                                              ||CHR(10)||'gl_return => '||pi_gl_return
                    );
--
END lock_gl;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using GL_PK constraint
--
PROCEDURE lock_gl (pi_gl_job_id         gri_lov.gl_job_id%TYPE
                  ,pi_gl_param          gri_lov.gl_param%TYPE
                  ,pi_gl_return         gri_lov.gl_return%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_gl');
--
   l_rowid := lock_gl
                   (pi_gl_job_id         => pi_gl_job_id
                   ,pi_gl_param          => pi_gl_param
                   ,pi_gl_return         => pi_gl_return
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_gl');
--
END lock_gl;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using GRM_PK constraint
--
FUNCTION lock_grm (pi_grm_module        gri_modules.grm_module%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_grm IS
   SELECT /*+ INDEX (grm GRM_PK) */ ROWID
    FROM  gri_modules grm
   WHERE  grm.grm_module = pi_grm_module
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_grm');
--
   OPEN  cs_grm;
   FETCH cs_grm INTO l_retval;
   l_found := cs_grm%FOUND;
   CLOSE cs_grm;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'gri_modules (GRM_PK)'
                                              ||CHR(10)||'grm_module => '||pi_grm_module
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_grm');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'gri_modules (GRM_PK)'
                                              ||CHR(10)||'grm_module => '||pi_grm_module
                    );
--
END lock_grm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using GRM_PK constraint
--
PROCEDURE lock_grm (pi_grm_module        gri_modules.grm_module%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_grm');
--
   l_rowid := lock_grm
                   (pi_grm_module        => pi_grm_module
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_grm');
--
END lock_grm;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using GMP_PK constraint
--
FUNCTION lock_gmp (pi_gmp_module        gri_module_params.gmp_module%TYPE
                  ,pi_gmp_param         gri_module_params.gmp_param%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_gmp IS
   SELECT /*+ INDEX (gmp GMP_PK) */ ROWID
    FROM  gri_module_params gmp
   WHERE  gmp.gmp_module = pi_gmp_module
    AND   gmp.gmp_param  = pi_gmp_param
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_gmp');
--
   OPEN  cs_gmp;
   FETCH cs_gmp INTO l_retval;
   l_found := cs_gmp%FOUND;
   CLOSE cs_gmp;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'gri_module_params (GMP_PK)'
                                              ||CHR(10)||'gmp_module => '||pi_gmp_module
                                              ||CHR(10)||'gmp_param  => '||pi_gmp_param
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_gmp');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'gri_module_params (GMP_PK)'
                                              ||CHR(10)||'gmp_module => '||pi_gmp_module
                                              ||CHR(10)||'gmp_param  => '||pi_gmp_param
                    );
--
END lock_gmp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using GMP_PK constraint
--
PROCEDURE lock_gmp (pi_gmp_module        gri_module_params.gmp_module%TYPE
                   ,pi_gmp_param         gri_module_params.gmp_param%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_gmp');
--
   l_rowid := lock_gmp
                   (pi_gmp_module        => pi_gmp_module
                   ,pi_gmp_param         => pi_gmp_param
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_gmp');
--
END lock_gmp;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using GP_PK constraint
--
FUNCTION lock_gp (pi_gp_param          gri_params.gp_param%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) RETURN ROWID IS
--
   CURSOR cs_gp IS
   SELECT /*+ INDEX (gp GP_PK) */ ROWID
    FROM  gri_params gp
   WHERE  gp.gp_param = pi_gp_param
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_gp');
--
   OPEN  cs_gp;
   FETCH cs_gp INTO l_retval;
   l_found := cs_gp%FOUND;
   CLOSE cs_gp;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'gri_params (GP_PK)'
                                              ||CHR(10)||'gp_param => '||pi_gp_param
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_gp');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'gri_params (GP_PK)'
                                              ||CHR(10)||'gp_param => '||pi_gp_param
                    );
--
END lock_gp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using GP_PK constraint
--
PROCEDURE lock_gp (pi_gp_param          gri_params.gp_param%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_gp');
--
   l_rowid := lock_gp
                   (pi_gp_param          => pi_gp_param
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_gp');
--
END lock_gp;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using GPD_PK constraint
--
FUNCTION lock_gpd (pi_gpd_indep_param   gri_param_dependencies.gpd_indep_param%TYPE
                  ,pi_gpd_module        gri_param_dependencies.gpd_module%TYPE
                  ,pi_gpd_dep_param     gri_param_dependencies.gpd_dep_param%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_gpd IS
   SELECT /*+ INDEX (gpd GPD_PK) */ ROWID
    FROM  gri_param_dependencies gpd
   WHERE  gpd.gpd_indep_param = pi_gpd_indep_param
    AND   gpd.gpd_module      = pi_gpd_module
    AND   gpd.gpd_dep_param   = pi_gpd_dep_param
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_gpd');
--
   OPEN  cs_gpd;
   FETCH cs_gpd INTO l_retval;
   l_found := cs_gpd%FOUND;
   CLOSE cs_gpd;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'gri_param_dependencies (GPD_PK)'
                                              ||CHR(10)||'gpd_indep_param => '||pi_gpd_indep_param
                                              ||CHR(10)||'gpd_module      => '||pi_gpd_module
                                              ||CHR(10)||'gpd_dep_param   => '||pi_gpd_dep_param
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_gpd');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'gri_param_dependencies (GPD_PK)'
                                              ||CHR(10)||'gpd_indep_param => '||pi_gpd_indep_param
                                              ||CHR(10)||'gpd_module      => '||pi_gpd_module
                                              ||CHR(10)||'gpd_dep_param   => '||pi_gpd_dep_param
                    );
--
END lock_gpd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using GPD_PK constraint
--
PROCEDURE lock_gpd (pi_gpd_indep_param   gri_param_dependencies.gpd_indep_param%TYPE
                   ,pi_gpd_module        gri_param_dependencies.gpd_module%TYPE
                   ,pi_gpd_dep_param     gri_param_dependencies.gpd_dep_param%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_gpd');
--
   l_rowid := lock_gpd
                   (pi_gpd_indep_param   => pi_gpd_indep_param
                   ,pi_gpd_module        => pi_gpd_module
                   ,pi_gpd_dep_param     => pi_gpd_dep_param
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_gpd');
--
END lock_gpd;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using GPL_PK constraint
--
FUNCTION lock_gpl (pi_gpl_param         gri_param_lookup.gpl_param%TYPE
                  ,pi_gpl_value         gri_param_lookup.gpl_value%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_gpl IS
   SELECT /*+ INDEX (gpl GPL_PK) */ ROWID
    FROM  gri_param_lookup gpl
   WHERE  gpl.gpl_param = pi_gpl_param
    AND   gpl.gpl_value = pi_gpl_value
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_gpl');
--
   OPEN  cs_gpl;
   FETCH cs_gpl INTO l_retval;
   l_found := cs_gpl%FOUND;
   CLOSE cs_gpl;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'gri_param_lookup (GPL_PK)'
                                              ||CHR(10)||'gpl_param => '||pi_gpl_param
                                              ||CHR(10)||'gpl_value => '||pi_gpl_value
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_gpl');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'gri_param_lookup (GPL_PK)'
                                              ||CHR(10)||'gpl_param => '||pi_gpl_param
                                              ||CHR(10)||'gpl_value => '||pi_gpl_value
                    );
--
END lock_gpl;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using GPL_PK constraint
--
PROCEDURE lock_gpl (pi_gpl_param         gri_param_lookup.gpl_param%TYPE
                   ,pi_gpl_value         gri_param_lookup.gpl_value%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_gpl');
--
   l_rowid := lock_gpl
                   (pi_gpl_param         => pi_gpl_param
                   ,pi_gpl_value         => pi_gpl_value
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_gpl');
--
END lock_gpl;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using GRR_PK constraint
--
FUNCTION lock_grr (pi_grr_job_id        gri_report_runs.grr_job_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_grr IS
   SELECT /*+ INDEX (grr GRR_PK) */ ROWID
    FROM  gri_report_runs grr
   WHERE  grr.grr_job_id = pi_grr_job_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_grr');
--
   OPEN  cs_grr;
   FETCH cs_grr INTO l_retval;
   l_found := cs_grr%FOUND;
   CLOSE cs_grr;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'gri_report_runs (GRR_PK)'
                                              ||CHR(10)||'grr_job_id => '||pi_grr_job_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_grr');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'gri_report_runs (GRR_PK)'
                                              ||CHR(10)||'grr_job_id => '||pi_grr_job_id
                    );
--
END lock_grr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using GRR_PK constraint
--
PROCEDURE lock_grr (pi_grr_job_id        gri_report_runs.grr_job_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_grr');
--
   l_rowid := lock_grr
                   (pi_grr_job_id        => pi_grr_job_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_grr');
--
END lock_grr;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using GRP_PK constraint
--
FUNCTION lock_grp (pi_grp_job_id        gri_run_parameters.grp_job_id%TYPE
                  ,pi_grp_param         gri_run_parameters.grp_param%TYPE
                  ,pi_grp_seq           gri_run_parameters.grp_seq%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_grp IS
   SELECT /*+ INDEX (grp GRP_PK) */ ROWID
    FROM  gri_run_parameters grp
   WHERE  grp.grp_job_id = pi_grp_job_id
    AND   grp.grp_param  = pi_grp_param
    AND   grp.grp_seq    = pi_grp_seq
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_grp');
--
   OPEN  cs_grp;
   FETCH cs_grp INTO l_retval;
   l_found := cs_grp%FOUND;
   CLOSE cs_grp;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'gri_run_parameters (GRP_PK)'
                                              ||CHR(10)||'grp_job_id => '||pi_grp_job_id
                                              ||CHR(10)||'grp_param  => '||pi_grp_param
                                              ||CHR(10)||'grp_seq    => '||pi_grp_seq
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_grp');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'gri_run_parameters (GRP_PK)'
                                              ||CHR(10)||'grp_job_id => '||pi_grp_job_id
                                              ||CHR(10)||'grp_param  => '||pi_grp_param
                                              ||CHR(10)||'grp_seq    => '||pi_grp_seq
                    );
--
END lock_grp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using GRP_PK constraint
--
PROCEDURE lock_grp (pi_grp_job_id        gri_run_parameters.grp_job_id%TYPE
                   ,pi_grp_param         gri_run_parameters.grp_param%TYPE
                   ,pi_grp_seq           gri_run_parameters.grp_seq%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_grp');
--
   l_rowid := lock_grp
                   (pi_grp_job_id        => pi_grp_job_id
                   ,pi_grp_param         => pi_grp_param
                   ,pi_grp_seq           => pi_grp_seq
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_grp');
--
END lock_grp;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using GSP_PK constraint
--
FUNCTION lock_gsp (pi_gsp_gss_id        gri_saved_params.gsp_gss_id%TYPE
                  ,pi_gsp_seq           gri_saved_params.gsp_seq%TYPE
                  ,pi_gsp_param         gri_saved_params.gsp_param%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_gsp IS
   SELECT /*+ INDEX (gsp GSP_PK) */ ROWID
    FROM  gri_saved_params gsp
   WHERE  gsp.gsp_gss_id = pi_gsp_gss_id
    AND   gsp.gsp_seq    = pi_gsp_seq
    AND   gsp.gsp_param  = pi_gsp_param
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_gsp');
--
   OPEN  cs_gsp;
   FETCH cs_gsp INTO l_retval;
   l_found := cs_gsp%FOUND;
   CLOSE cs_gsp;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'gri_saved_params (GSP_PK)'
                                              ||CHR(10)||'gsp_gss_id => '||pi_gsp_gss_id
                                              ||CHR(10)||'gsp_seq    => '||pi_gsp_seq
                                              ||CHR(10)||'gsp_param  => '||pi_gsp_param
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_gsp');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'gri_saved_params (GSP_PK)'
                                              ||CHR(10)||'gsp_gss_id => '||pi_gsp_gss_id
                                              ||CHR(10)||'gsp_seq    => '||pi_gsp_seq
                                              ||CHR(10)||'gsp_param  => '||pi_gsp_param
                    );
--
END lock_gsp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using GSP_PK constraint
--
PROCEDURE lock_gsp (pi_gsp_gss_id        gri_saved_params.gsp_gss_id%TYPE
                   ,pi_gsp_seq           gri_saved_params.gsp_seq%TYPE
                   ,pi_gsp_param         gri_saved_params.gsp_param%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_gsp');
--
   l_rowid := lock_gsp
                   (pi_gsp_gss_id        => pi_gsp_gss_id
                   ,pi_gsp_seq           => pi_gsp_seq
                   ,pi_gsp_param         => pi_gsp_param
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_gsp');
--
END lock_gsp;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using GSS_PK constraint
--
FUNCTION lock_gss (pi_gss_id            gri_saved_sets.gss_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_gss IS
   SELECT /*+ INDEX (gss GSS_PK) */ ROWID
    FROM  gri_saved_sets gss
   WHERE  gss.gss_id = pi_gss_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_gss');
--
   OPEN  cs_gss;
   FETCH cs_gss INTO l_retval;
   l_found := cs_gss%FOUND;
   CLOSE cs_gss;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'gri_saved_sets (GSS_PK)'
                                              ||CHR(10)||'gss_id => '||pi_gss_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_gss');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'gri_saved_sets (GSS_PK)'
                                              ||CHR(10)||'gss_id => '||pi_gss_id
                    );
--
END lock_gss;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using GSS_PK constraint
--
PROCEDURE lock_gss (pi_gss_id            gri_saved_sets.gss_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_gss');
--
   l_rowid := lock_gss
                   (pi_gss_id            => pi_gss_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_gss');
--
END lock_gss;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HAD_PK constraint
--
FUNCTION lock_had (pi_had_id            hig_address.had_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_had IS
   SELECT /*+ INDEX (had HAD_PK) */ ROWID
    FROM  hig_address had
   WHERE  had.had_id = pi_had_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_had');
--
   OPEN  cs_had;
   FETCH cs_had INTO l_retval;
   l_found := cs_had%FOUND;
   CLOSE cs_had;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_address (HAD_PK)'
                                              ||CHR(10)||'had_id => '||pi_had_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_had');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_address (HAD_PK)'
                                              ||CHR(10)||'had_id => '||pi_had_id
                    );
--
END lock_had;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HAD_PK constraint
--
PROCEDURE lock_had (pi_had_id            hig_address.had_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_had');
--
   l_rowid := lock_had
                   (pi_had_id            => pi_had_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_had');
--
END lock_had;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HCO_PK constraint
--
FUNCTION lock_hco (pi_hco_domain        hig_codes.hco_domain%TYPE
                  ,pi_hco_code          hig_codes.hco_code%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hco IS
   SELECT /*+ INDEX (hco HCO_PK) */ ROWID
    FROM  hig_codes hco
   WHERE  hco.hco_domain = pi_hco_domain
    AND   hco.hco_code   = pi_hco_code
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hco');
--
   OPEN  cs_hco;
   FETCH cs_hco INTO l_retval;
   l_found := cs_hco%FOUND;
   CLOSE cs_hco;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_codes (HCO_PK)'
                                              ||CHR(10)||'hco_domain => '||pi_hco_domain
                                              ||CHR(10)||'hco_code   => '||pi_hco_code
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hco');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_codes (HCO_PK)'
                                              ||CHR(10)||'hco_domain => '||pi_hco_domain
                                              ||CHR(10)||'hco_code   => '||pi_hco_code
                    );
--
END lock_hco;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HCO_PK constraint
--
PROCEDURE lock_hco (pi_hco_domain        hig_codes.hco_domain%TYPE
                   ,pi_hco_code          hig_codes.hco_code%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hco');
--
   l_rowid := lock_hco
                   (pi_hco_domain        => pi_hco_domain
                   ,pi_hco_code          => pi_hco_code
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hco');
--
END lock_hco;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HCL_PK constraint
--
FUNCTION lock_hcl (pi_hcl_colour        hig_colours.hcl_colour%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hcl IS
   SELECT /*+ INDEX (hcl HCL_PK) */ ROWID
    FROM  hig_colours hcl
   WHERE  hcl.hcl_colour = pi_hcl_colour
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hcl');
--
   OPEN  cs_hcl;
   FETCH cs_hcl INTO l_retval;
   l_found := cs_hcl%FOUND;
   CLOSE cs_hcl;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_colours (HCL_PK)'
                                              ||CHR(10)||'hcl_colour => '||pi_hcl_colour
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hcl');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_colours (HCL_PK)'
                                              ||CHR(10)||'hcl_colour => '||pi_hcl_colour
                    );
--
END lock_hcl;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HCL_PK constraint
--
PROCEDURE lock_hcl (pi_hcl_colour        hig_colours.hcl_colour%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hcl');
--
   l_rowid := lock_hcl
                   (pi_hcl_colour        => pi_hcl_colour
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hcl');
--
END lock_hcl;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HCT_PK constraint
--
FUNCTION lock_hct (pi_hct_id            hig_contacts.hct_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hct IS
   SELECT /*+ INDEX (hct HCT_PK) */ ROWID
    FROM  hig_contacts hct
   WHERE  hct.hct_id = pi_hct_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hct');
--
   OPEN  cs_hct;
   FETCH cs_hct INTO l_retval;
   l_found := cs_hct%FOUND;
   CLOSE cs_hct;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_contacts (HCT_PK)'
                                              ||CHR(10)||'hct_id => '||pi_hct_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hct');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_contacts (HCT_PK)'
                                              ||CHR(10)||'hct_id => '||pi_hct_id
                    );
--
END lock_hct;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HCT_PK constraint
--
PROCEDURE lock_hct (pi_hct_id            hig_contacts.hct_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hct');
--
   l_rowid := lock_hct
                   (pi_hct_id            => pi_hct_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hct');
--
END lock_hct;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HCA_PK constraint
--
FUNCTION lock_hca (pi_hca_hct_id        hig_contact_address.hca_hct_id%TYPE
                  ,pi_hca_had_id        hig_contact_address.hca_had_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hca IS
   SELECT /*+ INDEX (hca HCA_PK) */ ROWID
    FROM  hig_contact_address hca
   WHERE  hca.hca_hct_id = pi_hca_hct_id
    AND   hca.hca_had_id = pi_hca_had_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hca');
--
   OPEN  cs_hca;
   FETCH cs_hca INTO l_retval;
   l_found := cs_hca%FOUND;
   CLOSE cs_hca;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_contact_address (HCA_PK)'
                                              ||CHR(10)||'hca_hct_id => '||pi_hca_hct_id
                                              ||CHR(10)||'hca_had_id => '||pi_hca_had_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hca');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_contact_address (HCA_PK)'
                                              ||CHR(10)||'hca_hct_id => '||pi_hca_hct_id
                                              ||CHR(10)||'hca_had_id => '||pi_hca_had_id
                    );
--
END lock_hca;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HCA_PK constraint
--
PROCEDURE lock_hca (pi_hca_hct_id        hig_contact_address.hca_hct_id%TYPE
                   ,pi_hca_had_id        hig_contact_address.hca_had_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hca');
--
   l_rowid := lock_hca
                   (pi_hca_hct_id        => pi_hca_hct_id
                   ,pi_hca_had_id        => pi_hca_had_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hca');
--
END lock_hca;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HDO_PK constraint
--
FUNCTION lock_hdo (pi_hdo_domain        hig_domains.hdo_domain%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hdo IS
   SELECT /*+ INDEX (hdo HDO_PK) */ ROWID
    FROM  hig_domains hdo
   WHERE  hdo.hdo_domain = pi_hdo_domain
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hdo');
--
   OPEN  cs_hdo;
   FETCH cs_hdo INTO l_retval;
   l_found := cs_hdo%FOUND;
   CLOSE cs_hdo;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_domains (HDO_PK)'
                                              ||CHR(10)||'hdo_domain => '||pi_hdo_domain
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hdo');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_domains (HDO_PK)'
                                              ||CHR(10)||'hdo_domain => '||pi_hdo_domain
                    );
--
END lock_hdo;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HDO_PK constraint
--
PROCEDURE lock_hdo (pi_hdo_domain        hig_domains.hdo_domain%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hdo');
--
   l_rowid := lock_hdo
                   (pi_hdo_domain        => pi_hdo_domain
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hdo');
--
END lock_hdo;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HER_PK constraint
--
FUNCTION lock_her (pi_her_no            hig_errors.her_no%TYPE
                  ,pi_her_appl          hig_errors.her_appl%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_her IS
   SELECT /*+ INDEX (her HER_PK) */ ROWID
    FROM  hig_errors her
   WHERE  her.her_no   = pi_her_no
    AND   her.her_appl = pi_her_appl
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_her');
--
   OPEN  cs_her;
   FETCH cs_her INTO l_retval;
   l_found := cs_her%FOUND;
   CLOSE cs_her;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_errors (HER_PK)'
                                              ||CHR(10)||'her_no   => '||pi_her_no
                                              ||CHR(10)||'her_appl => '||pi_her_appl
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_her');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_errors (HER_PK)'
                                              ||CHR(10)||'her_no   => '||pi_her_no
                                              ||CHR(10)||'her_appl => '||pi_her_appl
                    );
--
END lock_her;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HER_PK constraint
--
PROCEDURE lock_her (pi_her_no            hig_errors.her_no%TYPE
                   ,pi_her_appl          hig_errors.her_appl%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_her');
--
   l_rowid := lock_her
                   (pi_her_no            => pi_her_no
                   ,pi_her_appl          => pi_her_appl
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_her');
--
END lock_her;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HIG_HD_HHT_PK constraint
--
FUNCTION lock_hht (pi_hht_hhu_hhm_module hig_hd_join_defs.hht_hhu_hhm_module%TYPE
                  ,pi_hht_hhu_seq        hig_hd_join_defs.hht_hhu_seq%TYPE
                  ,pi_hht_join_seq       hig_hd_join_defs.hht_join_seq%TYPE
                  ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hht IS
   SELECT /*+ INDEX (hht HIG_HD_HHT_PK) */ ROWID
    FROM  hig_hd_join_defs hht
   WHERE  hht.hht_hhu_hhm_module = pi_hht_hhu_hhm_module
    AND   hht.hht_hhu_seq        = pi_hht_hhu_seq
    AND   hht.hht_join_seq       = pi_hht_join_seq
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hht');
--
   OPEN  cs_hht;
   FETCH cs_hht INTO l_retval;
   l_found := cs_hht%FOUND;
   CLOSE cs_hht;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_hd_join_defs (HIG_HD_HHT_PK)'
                                              ||CHR(10)||'hht_hhu_hhm_module => '||pi_hht_hhu_hhm_module
                                              ||CHR(10)||'hht_hhu_seq        => '||pi_hht_hhu_seq
                                              ||CHR(10)||'hht_join_seq       => '||pi_hht_join_seq
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hht');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_hd_join_defs (HIG_HD_HHT_PK)'
                                              ||CHR(10)||'hht_hhu_hhm_module => '||pi_hht_hhu_hhm_module
                                              ||CHR(10)||'hht_hhu_seq        => '||pi_hht_hhu_seq
                                              ||CHR(10)||'hht_join_seq       => '||pi_hht_join_seq
                    );
--
END lock_hht;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HIG_HD_HHT_PK constraint
--
PROCEDURE lock_hht (pi_hht_hhu_hhm_module hig_hd_join_defs.hht_hhu_hhm_module%TYPE
                   ,pi_hht_hhu_seq        hig_hd_join_defs.hht_hhu_seq%TYPE
                   ,pi_hht_join_seq       hig_hd_join_defs.hht_join_seq%TYPE
                   ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hht');
--
   l_rowid := lock_hht
                   (pi_hht_hhu_hhm_module => pi_hht_hhu_hhm_module
                   ,pi_hht_hhu_seq        => pi_hht_hhu_seq
                   ,pi_hht_join_seq       => pi_hht_join_seq
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hht');
--
END lock_hht;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HIG_HD_HHO_PK constraint
--
FUNCTION lock_hho (pi_hho_hhl_hhu_hhm_module hig_hd_lookup_join_cols.hho_hhl_hhu_hhm_module%TYPE
                  ,pi_hho_hhl_hhu_seq        hig_hd_lookup_join_cols.hho_hhl_hhu_seq%TYPE
                  ,pi_hho_hhl_join_seq       hig_hd_lookup_join_cols.hho_hhl_join_seq%TYPE
                  ,pi_hho_parent_col         hig_hd_lookup_join_cols.hho_parent_col%TYPE
                  ,pi_hho_lookup_col         hig_hd_lookup_join_cols.hho_lookup_col%TYPE
                  ,pi_raise_not_found        BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode      PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode         PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hho IS
   SELECT /*+ INDEX (hho HIG_HD_HHO_PK) */ ROWID
    FROM  hig_hd_lookup_join_cols hho
   WHERE  hho.hho_hhl_hhu_hhm_module = pi_hho_hhl_hhu_hhm_module
    AND   hho.hho_hhl_hhu_seq        = pi_hho_hhl_hhu_seq
    AND   hho.hho_hhl_join_seq       = pi_hho_hhl_join_seq
    AND   hho.hho_parent_col         = pi_hho_parent_col
    AND   hho.hho_lookup_col         = pi_hho_lookup_col
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hho');
--
   OPEN  cs_hho;
   FETCH cs_hho INTO l_retval;
   l_found := cs_hho%FOUND;
   CLOSE cs_hho;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_hd_lookup_join_cols (HIG_HD_HHO_PK)'
                                              ||CHR(10)||'hho_hhl_hhu_hhm_module => '||pi_hho_hhl_hhu_hhm_module
                                              ||CHR(10)||'hho_hhl_hhu_seq        => '||pi_hho_hhl_hhu_seq
                                              ||CHR(10)||'hho_hhl_join_seq       => '||pi_hho_hhl_join_seq
                                              ||CHR(10)||'hho_parent_col         => '||pi_hho_parent_col
                                              ||CHR(10)||'hho_lookup_col         => '||pi_hho_lookup_col
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hho');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_hd_lookup_join_cols (HIG_HD_HHO_PK)'
                                              ||CHR(10)||'hho_hhl_hhu_hhm_module => '||pi_hho_hhl_hhu_hhm_module
                                              ||CHR(10)||'hho_hhl_hhu_seq        => '||pi_hho_hhl_hhu_seq
                                              ||CHR(10)||'hho_hhl_join_seq       => '||pi_hho_hhl_join_seq
                                              ||CHR(10)||'hho_parent_col         => '||pi_hho_parent_col
                                              ||CHR(10)||'hho_lookup_col         => '||pi_hho_lookup_col
                    );
--
END lock_hho;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HIG_HD_HHO_PK constraint
--
PROCEDURE lock_hho (pi_hho_hhl_hhu_hhm_module hig_hd_lookup_join_cols.hho_hhl_hhu_hhm_module%TYPE
                   ,pi_hho_hhl_hhu_seq        hig_hd_lookup_join_cols.hho_hhl_hhu_seq%TYPE
                   ,pi_hho_hhl_join_seq       hig_hd_lookup_join_cols.hho_hhl_join_seq%TYPE
                   ,pi_hho_parent_col         hig_hd_lookup_join_cols.hho_parent_col%TYPE
                   ,pi_hho_lookup_col         hig_hd_lookup_join_cols.hho_lookup_col%TYPE
                   ,pi_raise_not_found        BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode      PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode         PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hho');
--
   l_rowid := lock_hho
                   (pi_hho_hhl_hhu_hhm_module => pi_hho_hhl_hhu_hhm_module
                   ,pi_hho_hhl_hhu_seq        => pi_hho_hhl_hhu_seq
                   ,pi_hho_hhl_join_seq       => pi_hho_hhl_join_seq
                   ,pi_hho_parent_col         => pi_hho_parent_col
                   ,pi_hho_lookup_col         => pi_hho_lookup_col
                   ,pi_raise_not_found        => pi_raise_not_found
                   ,pi_not_found_sqlcode      => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hho');
--
END lock_hho;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HIG_HD_HHL_PK constraint
--
FUNCTION lock_hhl (pi_hhl_hhu_hhm_module hig_hd_lookup_join_defs.hhl_hhu_hhm_module%TYPE
                  ,pi_hhl_hhu_seq        hig_hd_lookup_join_defs.hhl_hhu_seq%TYPE
                  ,pi_hhl_join_seq       hig_hd_lookup_join_defs.hhl_join_seq%TYPE
                  ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hhl IS
   SELECT /*+ INDEX (hhl HIG_HD_HHL_PK) */ ROWID
    FROM  hig_hd_lookup_join_defs hhl
   WHERE  hhl.hhl_hhu_hhm_module = pi_hhl_hhu_hhm_module
    AND   hhl.hhl_hhu_seq        = pi_hhl_hhu_seq
    AND   hhl.hhl_join_seq       = pi_hhl_join_seq
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hhl');
--
   OPEN  cs_hhl;
   FETCH cs_hhl INTO l_retval;
   l_found := cs_hhl%FOUND;
   CLOSE cs_hhl;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_hd_lookup_join_defs (HIG_HD_HHL_PK)'
                                              ||CHR(10)||'hhl_hhu_hhm_module => '||pi_hhl_hhu_hhm_module
                                              ||CHR(10)||'hhl_hhu_seq        => '||pi_hhl_hhu_seq
                                              ||CHR(10)||'hhl_join_seq       => '||pi_hhl_join_seq
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hhl');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_hd_lookup_join_defs (HIG_HD_HHL_PK)'
                                              ||CHR(10)||'hhl_hhu_hhm_module => '||pi_hhl_hhu_hhm_module
                                              ||CHR(10)||'hhl_hhu_seq        => '||pi_hhl_hhu_seq
                                              ||CHR(10)||'hhl_join_seq       => '||pi_hhl_join_seq
                    );
--
END lock_hhl;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HIG_HD_HHL_PK constraint
--
PROCEDURE lock_hhl (pi_hhl_hhu_hhm_module hig_hd_lookup_join_defs.hhl_hhu_hhm_module%TYPE
                   ,pi_hhl_hhu_seq        hig_hd_lookup_join_defs.hhl_hhu_seq%TYPE
                   ,pi_hhl_join_seq       hig_hd_lookup_join_defs.hhl_join_seq%TYPE
                   ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hhl');
--
   l_rowid := lock_hhl
                   (pi_hhl_hhu_hhm_module => pi_hhl_hhu_hhm_module
                   ,pi_hhl_hhu_seq        => pi_hhl_hhu_seq
                   ,pi_hhl_join_seq       => pi_hhl_join_seq
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hhl');
--
END lock_hhl;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HIG_HD_HHM_PK constraint
--
FUNCTION lock_hhm (pi_hhm_module        hig_hd_modules.hhm_module%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hhm IS
   SELECT /*+ INDEX (hhm HIG_HD_HHM_PK) */ ROWID
    FROM  hig_hd_modules hhm
   WHERE  hhm.hhm_module = pi_hhm_module
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hhm');
--
   OPEN  cs_hhm;
   FETCH cs_hhm INTO l_retval;
   l_found := cs_hhm%FOUND;
   CLOSE cs_hhm;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_hd_modules (HIG_HD_HHM_PK)'
                                              ||CHR(10)||'hhm_module => '||pi_hhm_module
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hhm');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_hd_modules (HIG_HD_HHM_PK)'
                                              ||CHR(10)||'hhm_module => '||pi_hhm_module
                    );
--
END lock_hhm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HIG_HD_HHM_PK constraint
--
PROCEDURE lock_hhm (pi_hhm_module        hig_hd_modules.hhm_module%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hhm');
--
   l_rowid := lock_hhm
                   (pi_hhm_module        => pi_hhm_module
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hhm');
--
END lock_hhm;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HIG_HD_HHU_PK constraint
--
FUNCTION lock_hhu (pi_hhu_hhm_module    hig_hd_mod_uses.hhu_hhm_module%TYPE
                  ,pi_hhu_seq           hig_hd_mod_uses.hhu_seq%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hhu IS
   SELECT /*+ INDEX (hhu HIG_HD_HHU_PK) */ ROWID
    FROM  hig_hd_mod_uses hhu
   WHERE  hhu.hhu_hhm_module = pi_hhu_hhm_module
    AND   hhu.hhu_seq        = pi_hhu_seq
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hhu');
--
   OPEN  cs_hhu;
   FETCH cs_hhu INTO l_retval;
   l_found := cs_hhu%FOUND;
   CLOSE cs_hhu;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_hd_mod_uses (HIG_HD_HHU_PK)'
                                              ||CHR(10)||'hhu_hhm_module => '||pi_hhu_hhm_module
                                              ||CHR(10)||'hhu_seq        => '||pi_hhu_seq
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hhu');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_hd_mod_uses (HIG_HD_HHU_PK)'
                                              ||CHR(10)||'hhu_hhm_module => '||pi_hhu_hhm_module
                                              ||CHR(10)||'hhu_seq        => '||pi_hhu_seq
                    );
--
END lock_hhu;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HIG_HD_HHU_PK constraint
--
PROCEDURE lock_hhu (pi_hhu_hhm_module    hig_hd_mod_uses.hhu_hhm_module%TYPE
                   ,pi_hhu_seq           hig_hd_mod_uses.hhu_seq%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hhu');
--
   l_rowid := lock_hhu
                   (pi_hhu_hhm_module    => pi_hhu_hhm_module
                   ,pi_hhu_seq           => pi_hhu_seq
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hhu');
--
END lock_hhu;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HIG_HD_HHC_PK constraint
--
FUNCTION lock_hhc (pi_hhc_hhu_hhm_module hig_hd_selected_cols.hhc_hhu_hhm_module%TYPE
                  ,pi_hhc_hhu_seq        hig_hd_selected_cols.hhc_hhu_seq%TYPE
                  ,pi_hhc_column_seq     hig_hd_selected_cols.hhc_column_seq%TYPE
                  ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hhc IS
   SELECT /*+ INDEX (hhc HIG_HD_HHC_PK) */ ROWID
    FROM  hig_hd_selected_cols hhc
   WHERE  hhc.hhc_hhu_hhm_module = pi_hhc_hhu_hhm_module
    AND   hhc.hhc_hhu_seq        = pi_hhc_hhu_seq
    AND   hhc.hhc_column_seq     = pi_hhc_column_seq
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hhc');
--
   OPEN  cs_hhc;
   FETCH cs_hhc INTO l_retval;
   l_found := cs_hhc%FOUND;
   CLOSE cs_hhc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_hd_selected_cols (HIG_HD_HHC_PK)'
                                              ||CHR(10)||'hhc_hhu_hhm_module => '||pi_hhc_hhu_hhm_module
                                              ||CHR(10)||'hhc_hhu_seq        => '||pi_hhc_hhu_seq
                                              ||CHR(10)||'hhc_column_seq     => '||pi_hhc_column_seq
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hhc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_hd_selected_cols (HIG_HD_HHC_PK)'
                                              ||CHR(10)||'hhc_hhu_hhm_module => '||pi_hhc_hhu_hhm_module
                                              ||CHR(10)||'hhc_hhu_seq        => '||pi_hhc_hhu_seq
                                              ||CHR(10)||'hhc_column_seq     => '||pi_hhc_column_seq
                    );
--
END lock_hhc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HIG_HD_HHC_PK constraint
--
PROCEDURE lock_hhc (pi_hhc_hhu_hhm_module hig_hd_selected_cols.hhc_hhu_hhm_module%TYPE
                   ,pi_hhc_hhu_seq        hig_hd_selected_cols.hhc_hhu_seq%TYPE
                   ,pi_hhc_column_seq     hig_hd_selected_cols.hhc_column_seq%TYPE
                   ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hhc');
--
   l_rowid := lock_hhc
                   (pi_hhc_hhu_hhm_module => pi_hhc_hhu_hhm_module
                   ,pi_hhc_hhu_seq        => pi_hhc_hhu_seq
                   ,pi_hhc_column_seq     => pi_hhc_column_seq
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hhc');
--
END lock_hhc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HIG_HD_HHJ_PK constraint
--
FUNCTION lock_hhj (pi_hhj_hht_hhu_hhm_module   hig_hd_table_join_cols.hhj_hht_hhu_hhm_module%TYPE
                  ,pi_hhj_hht_hhu_parent_table hig_hd_table_join_cols.hhj_hht_hhu_parent_table%TYPE
                  ,pi_hhj_hht_join_seq         hig_hd_table_join_cols.hhj_hht_join_seq%TYPE
                  ,pi_hhj_parent_col           hig_hd_table_join_cols.hhj_parent_col%TYPE
                  ,pi_hhj_hhu_child_table      hig_hd_table_join_cols.hhj_hhu_child_table%TYPE
                  ,pi_hhj_child_col            hig_hd_table_join_cols.hhj_child_col%TYPE
                  ,pi_raise_not_found          BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode        PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode           PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hhj IS
   SELECT /*+ INDEX (hhj HIG_HD_HHJ_PK) */ ROWID
    FROM  hig_hd_table_join_cols hhj
   WHERE  hhj.hhj_hht_hhu_hhm_module   = pi_hhj_hht_hhu_hhm_module
    AND   hhj.hhj_hht_hhu_parent_table = pi_hhj_hht_hhu_parent_table
    AND   hhj.hhj_hht_join_seq         = pi_hhj_hht_join_seq
    AND   hhj.hhj_parent_col           = pi_hhj_parent_col
    AND   hhj.hhj_hhu_child_table      = pi_hhj_hhu_child_table
    AND   hhj.hhj_child_col            = pi_hhj_child_col
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hhj');
--
   OPEN  cs_hhj;
   FETCH cs_hhj INTO l_retval;
   l_found := cs_hhj%FOUND;
   CLOSE cs_hhj;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_hd_table_join_cols (HIG_HD_HHJ_PK)'
                                              ||CHR(10)||'hhj_hht_hhu_hhm_module   => '||pi_hhj_hht_hhu_hhm_module
                                              ||CHR(10)||'hhj_hht_hhu_parent_table => '||pi_hhj_hht_hhu_parent_table
                                              ||CHR(10)||'hhj_hht_join_seq         => '||pi_hhj_hht_join_seq
                                              ||CHR(10)||'hhj_parent_col           => '||pi_hhj_parent_col
                                              ||CHR(10)||'hhj_hhu_child_table      => '||pi_hhj_hhu_child_table
                                              ||CHR(10)||'hhj_child_col            => '||pi_hhj_child_col
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hhj');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_hd_table_join_cols (HIG_HD_HHJ_PK)'
                                              ||CHR(10)||'hhj_hht_hhu_hhm_module   => '||pi_hhj_hht_hhu_hhm_module
                                              ||CHR(10)||'hhj_hht_hhu_parent_table => '||pi_hhj_hht_hhu_parent_table
                                              ||CHR(10)||'hhj_hht_join_seq         => '||pi_hhj_hht_join_seq
                                              ||CHR(10)||'hhj_parent_col           => '||pi_hhj_parent_col
                                              ||CHR(10)||'hhj_hhu_child_table      => '||pi_hhj_hhu_child_table
                                              ||CHR(10)||'hhj_child_col            => '||pi_hhj_child_col
                    );
--
END lock_hhj;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HIG_HD_HHJ_PK constraint
--
PROCEDURE lock_hhj (pi_hhj_hht_hhu_hhm_module   hig_hd_table_join_cols.hhj_hht_hhu_hhm_module%TYPE
                   ,pi_hhj_hht_hhu_parent_table hig_hd_table_join_cols.hhj_hht_hhu_parent_table%TYPE
                   ,pi_hhj_hht_join_seq         hig_hd_table_join_cols.hhj_hht_join_seq%TYPE
                   ,pi_hhj_parent_col           hig_hd_table_join_cols.hhj_parent_col%TYPE
                   ,pi_hhj_hhu_child_table      hig_hd_table_join_cols.hhj_hhu_child_table%TYPE
                   ,pi_hhj_child_col            hig_hd_table_join_cols.hhj_child_col%TYPE
                   ,pi_raise_not_found          BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode        PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode           PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hhj');
--
   l_rowid := lock_hhj
                   (pi_hhj_hht_hhu_hhm_module   => pi_hhj_hht_hhu_hhm_module
                   ,pi_hhj_hht_hhu_parent_table => pi_hhj_hht_hhu_parent_table
                   ,pi_hhj_hht_join_seq         => pi_hhj_hht_join_seq
                   ,pi_hhj_parent_col           => pi_hhj_parent_col
                   ,pi_hhj_hhu_child_table      => pi_hhj_hhu_child_table
                   ,pi_hhj_child_col            => pi_hhj_child_col
                   ,pi_raise_not_found          => pi_raise_not_found
                   ,pi_not_found_sqlcode        => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hhj');
--
END lock_hhj;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HHO_PK constraint
--
FUNCTION lock_hho (pi_hho_id            hig_holidays.hho_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hho IS
   SELECT /*+ INDEX (hho HHO_PK) */ ROWID
    FROM  hig_holidays hho
   WHERE  hho.hho_id = pi_hho_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hho');
--
   OPEN  cs_hho;
   FETCH cs_hho INTO l_retval;
   l_found := cs_hho%FOUND;
   CLOSE cs_hho;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_holidays (HHO_PK)'
                                              ||CHR(10)||'hho_id => '||pi_hho_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hho');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_holidays (HHO_PK)'
                                              ||CHR(10)||'hho_id => '||pi_hho_id
                    );
--
END lock_hho;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HHO_PK constraint
--
PROCEDURE lock_hho (pi_hho_id            hig_holidays.hho_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hho');
--
   l_rowid := lock_hho
                   (pi_hho_id            => pi_hho_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hho');
--
END lock_hho;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HIG_MODULES_PK constraint
--
FUNCTION lock_hmo (pi_hmo_module        hig_modules.hmo_module%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hmo IS
   SELECT /*+ INDEX (hmo HIG_MODULES_PK) */ ROWID
    FROM  hig_modules hmo
   WHERE  hmo.hmo_module = pi_hmo_module
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hmo');
--
   OPEN  cs_hmo;
   FETCH cs_hmo INTO l_retval;
   l_found := cs_hmo%FOUND;
   CLOSE cs_hmo;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_modules (HIG_MODULES_PK)'
                                              ||CHR(10)||'hmo_module => '||pi_hmo_module
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hmo');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_modules (HIG_MODULES_PK)'
                                              ||CHR(10)||'hmo_module => '||pi_hmo_module
                    );
--
END lock_hmo;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HIG_MODULES_PK constraint
--
PROCEDURE lock_hmo (pi_hmo_module        hig_modules.hmo_module%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hmo');
--
   l_rowid := lock_hmo
                   (pi_hmo_module        => pi_hmo_module
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hmo');
--
END lock_hmo;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HMH_PK constraint
--
FUNCTION lock_hmh (pi_hmh_user_id       hig_module_history.hmh_user_id%TYPE
                  ,pi_hmh_seq_no        hig_module_history.hmh_seq_no%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hmh IS
   SELECT /*+ INDEX (hmh HMH_PK) */ ROWID
    FROM  hig_module_history hmh
   WHERE  hmh.hmh_user_id = pi_hmh_user_id
    AND   hmh.hmh_seq_no  = pi_hmh_seq_no
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hmh');
--
   OPEN  cs_hmh;
   FETCH cs_hmh INTO l_retval;
   l_found := cs_hmh%FOUND;
   CLOSE cs_hmh;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_module_history (HMH_PK)'
                                              ||CHR(10)||'hmh_user_id => '||pi_hmh_user_id
                                              ||CHR(10)||'hmh_seq_no  => '||pi_hmh_seq_no
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hmh');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_module_history (HMH_PK)'
                                              ||CHR(10)||'hmh_user_id => '||pi_hmh_user_id
                                              ||CHR(10)||'hmh_seq_no  => '||pi_hmh_seq_no
                    );
--
END lock_hmh;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HMH_PK constraint
--
PROCEDURE lock_hmh (pi_hmh_user_id       hig_module_history.hmh_user_id%TYPE
                   ,pi_hmh_seq_no        hig_module_history.hmh_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hmh');
--
   l_rowid := lock_hmh
                   (pi_hmh_user_id       => pi_hmh_user_id
                   ,pi_hmh_seq_no        => pi_hmh_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hmh');
--
END lock_hmh;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HMH_UK constraint
--
FUNCTION lock_hmh (pi_hmh_user_id       hig_module_history.hmh_user_id%TYPE
                  ,pi_hmh_module        hig_module_history.hmh_module%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hmh IS
   SELECT /*+ INDEX (hmh HMH_UK) */ ROWID
    FROM  hig_module_history hmh
   WHERE  hmh.hmh_user_id = pi_hmh_user_id
    AND   hmh.hmh_module  = pi_hmh_module
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hmh');
--
   OPEN  cs_hmh;
   FETCH cs_hmh INTO l_retval;
   l_found := cs_hmh%FOUND;
   CLOSE cs_hmh;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_module_history (HMH_UK)'
                                              ||CHR(10)||'hmh_user_id => '||pi_hmh_user_id
                                              ||CHR(10)||'hmh_module  => '||pi_hmh_module
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hmh');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_module_history (HMH_UK)'
                                              ||CHR(10)||'hmh_user_id => '||pi_hmh_user_id
                                              ||CHR(10)||'hmh_module  => '||pi_hmh_module
                    );
--
END lock_hmh;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HMH_UK constraint
--
PROCEDURE lock_hmh (pi_hmh_user_id       hig_module_history.hmh_user_id%TYPE
                   ,pi_hmh_module        hig_module_history.hmh_module%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hmh');
--
   l_rowid := lock_hmh
                   (pi_hmh_user_id       => pi_hmh_user_id
                   ,pi_hmh_module        => pi_hmh_module
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hmh');
--
END lock_hmh;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HMK_PK constraint
--
FUNCTION lock_hmk (pi_hmk_hmo_module    hig_module_keywords.hmk_hmo_module%TYPE
                  ,pi_hmk_keyword       hig_module_keywords.hmk_keyword%TYPE
                  ,pi_hmk_owner         hig_module_keywords.hmk_owner%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hmk IS
   SELECT /*+ INDEX (hmk HMK_PK) */ ROWID
    FROM  hig_module_keywords hmk
   WHERE  hmk.hmk_hmo_module = pi_hmk_hmo_module
    AND   hmk.hmk_keyword    = pi_hmk_keyword
    AND   hmk.hmk_owner      = pi_hmk_owner
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hmk');
--
   OPEN  cs_hmk;
   FETCH cs_hmk INTO l_retval;
   l_found := cs_hmk%FOUND;
   CLOSE cs_hmk;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_module_keywords (HMK_PK)'
                                              ||CHR(10)||'hmk_hmo_module => '||pi_hmk_hmo_module
                                              ||CHR(10)||'hmk_keyword    => '||pi_hmk_keyword
                                              ||CHR(10)||'hmk_owner      => '||pi_hmk_owner
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hmk');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_module_keywords (HMK_PK)'
                                              ||CHR(10)||'hmk_hmo_module => '||pi_hmk_hmo_module
                                              ||CHR(10)||'hmk_keyword    => '||pi_hmk_keyword
                                              ||CHR(10)||'hmk_owner      => '||pi_hmk_owner
                    );
--
END lock_hmk;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HMK_PK constraint
--
PROCEDURE lock_hmk (pi_hmk_hmo_module    hig_module_keywords.hmk_hmo_module%TYPE
                   ,pi_hmk_keyword       hig_module_keywords.hmk_keyword%TYPE
                   ,pi_hmk_owner         hig_module_keywords.hmk_owner%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hmk');
--
   l_rowid := lock_hmk
                   (pi_hmk_hmo_module    => pi_hmk_hmo_module
                   ,pi_hmk_keyword       => pi_hmk_keyword
                   ,pi_hmk_owner         => pi_hmk_owner
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hmk');
--
END lock_hmk;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HMR_PK constraint
--
FUNCTION lock_hmr (pi_hmr_module        hig_module_roles.hmr_module%TYPE
                  ,pi_hmr_role          hig_module_roles.hmr_role%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hmr IS
   SELECT /*+ INDEX (hmr HMR_PK) */ ROWID
    FROM  hig_module_roles hmr
   WHERE  hmr.hmr_module = pi_hmr_module
    AND   hmr.hmr_role   = pi_hmr_role
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hmr');
--
   OPEN  cs_hmr;
   FETCH cs_hmr INTO l_retval;
   l_found := cs_hmr%FOUND;
   CLOSE cs_hmr;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_module_roles (HMR_PK)'
                                              ||CHR(10)||'hmr_module => '||pi_hmr_module
                                              ||CHR(10)||'hmr_role   => '||pi_hmr_role
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hmr');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_module_roles (HMR_PK)'
                                              ||CHR(10)||'hmr_module => '||pi_hmr_module
                                              ||CHR(10)||'hmr_role   => '||pi_hmr_role
                    );
--
END lock_hmr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HMR_PK constraint
--
PROCEDURE lock_hmr (pi_hmr_module        hig_module_roles.hmr_module%TYPE
                   ,pi_hmr_role          hig_module_roles.hmr_role%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hmr');
--
   l_rowid := lock_hmr
                   (pi_hmr_module        => pi_hmr_module
                   ,pi_hmr_role          => pi_hmr_role
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hmr');
--
END lock_hmr;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HMU_PK constraint
--
FUNCTION lock_hmu (pi_hmu_module        hig_module_usages.hmu_module%TYPE
                  ,pi_hmu_usage         hig_module_usages.hmu_usage%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hmu IS
   SELECT /*+ INDEX (hmu HMU_PK) */ ROWID
    FROM  hig_module_usages hmu
   WHERE  hmu.hmu_module = pi_hmu_module
    AND   hmu.hmu_usage  = pi_hmu_usage
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hmu');
--
   OPEN  cs_hmu;
   FETCH cs_hmu INTO l_retval;
   l_found := cs_hmu%FOUND;
   CLOSE cs_hmu;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_module_usages (HMU_PK)'
                                              ||CHR(10)||'hmu_module => '||pi_hmu_module
                                              ||CHR(10)||'hmu_usage  => '||pi_hmu_usage
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hmu');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_module_usages (HMU_PK)'
                                              ||CHR(10)||'hmu_module => '||pi_hmu_module
                                              ||CHR(10)||'hmu_usage  => '||pi_hmu_usage
                    );
--
END lock_hmu;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HMU_PK constraint
--
PROCEDURE lock_hmu (pi_hmu_module        hig_module_usages.hmu_module%TYPE
                   ,pi_hmu_usage         hig_module_usages.hmu_usage%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hmu');
--
   l_rowid := lock_hmu
                   (pi_hmu_module        => pi_hmu_module
                   ,pi_hmu_usage         => pi_hmu_usage
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hmu');
--
END lock_hmu;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HOL_PK constraint
--
FUNCTION lock_hol (pi_hol_id            hig_option_list.hol_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hol IS
   SELECT /*+ INDEX (hol HOL_PK) */ ROWID
    FROM  hig_option_list hol
   WHERE  hol.hol_id = pi_hol_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hol');
--
   OPEN  cs_hol;
   FETCH cs_hol INTO l_retval;
   l_found := cs_hol%FOUND;
   CLOSE cs_hol;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_option_list (HOL_PK)'
                                              ||CHR(10)||'hol_id => '||pi_hol_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hol');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_option_list (HOL_PK)'
                                              ||CHR(10)||'hol_id => '||pi_hol_id
                    );
--
END lock_hol;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HOL_PK constraint
--
PROCEDURE lock_hol (pi_hol_id            hig_option_list.hol_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hol');
--
   l_rowid := lock_hol
                   (pi_hol_id            => pi_hol_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hol');
--
END lock_hol;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HOV_PK constraint
--
FUNCTION lock_hov (pi_hov_id            hig_option_values.hov_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hov IS
   SELECT /*+ INDEX (hov HOV_PK) */ ROWID
    FROM  hig_option_values hov
   WHERE  hov.hov_id = pi_hov_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hov');
--
   OPEN  cs_hov;
   FETCH cs_hov INTO l_retval;
   l_found := cs_hov%FOUND;
   CLOSE cs_hov;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_option_values (HOV_PK)'
                                              ||CHR(10)||'hov_id => '||pi_hov_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hov');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_option_values (HOV_PK)'
                                              ||CHR(10)||'hov_id => '||pi_hov_id
                    );
--
END lock_hov;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HOV_PK constraint
--
PROCEDURE lock_hov (pi_hov_id            hig_option_values.hov_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hov');
--
   l_rowid := lock_hov
                   (pi_hov_id            => pi_hov_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hov');
--
END lock_hov;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HPR_PK constraint
--
FUNCTION lock_hpr (pi_hpr_product       hig_products.hpr_product%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hpr IS
   SELECT /*+ INDEX (hpr HPR_PK) */ ROWID
    FROM  hig_products hpr
   WHERE  hpr.hpr_product = pi_hpr_product
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hpr');
--
   OPEN  cs_hpr;
   FETCH cs_hpr INTO l_retval;
   l_found := cs_hpr%FOUND;
   CLOSE cs_hpr;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_products (HPR_PK)'
                                              ||CHR(10)||'hpr_product => '||pi_hpr_product
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hpr');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_products (HPR_PK)'
                                              ||CHR(10)||'hpr_product => '||pi_hpr_product
                    );
--
END lock_hpr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HPR_PK constraint
--
PROCEDURE lock_hpr (pi_hpr_product       hig_products.hpr_product%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hpr');
--
   l_rowid := lock_hpr
                   (pi_hpr_product       => pi_hpr_product
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hpr');
--
END lock_hpr;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HPR_UK1 constraint
--
FUNCTION lock_hpr (pi_hpr_product_name  hig_products.hpr_product_name%TYPE
                  ,pi_hpr_version       hig_products.hpr_version%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hpr IS
   SELECT /*+ INDEX (hpr HPR_UK1) */ ROWID
    FROM  hig_products hpr
   WHERE  hpr.hpr_product_name = pi_hpr_product_name
    AND   hpr.hpr_version      = pi_hpr_version
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hpr');
--
   OPEN  cs_hpr;
   FETCH cs_hpr INTO l_retval;
   l_found := cs_hpr%FOUND;
   CLOSE cs_hpr;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_products (HPR_UK1)'
                                              ||CHR(10)||'hpr_product_name => '||pi_hpr_product_name
                                              ||CHR(10)||'hpr_version      => '||pi_hpr_version
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hpr');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_products (HPR_UK1)'
                                              ||CHR(10)||'hpr_product_name => '||pi_hpr_product_name
                                              ||CHR(10)||'hpr_version      => '||pi_hpr_version
                    );
--
END lock_hpr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HPR_UK1 constraint
--
PROCEDURE lock_hpr (pi_hpr_product_name  hig_products.hpr_product_name%TYPE
                   ,pi_hpr_version       hig_products.hpr_version%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hpr');
--
   l_rowid := lock_hpr
                   (pi_hpr_product_name  => pi_hpr_product_name
                   ,pi_hpr_version       => pi_hpr_version
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hpr');
--
END lock_hpr;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HRS_PK constraint
--
FUNCTION lock_hrs (pi_hrs_style_name    hig_report_styles.hrs_style_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hrs IS
   SELECT /*+ INDEX (hrs HRS_PK) */ ROWID
    FROM  hig_report_styles hrs
   WHERE  hrs.hrs_style_name = pi_hrs_style_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hrs');
--
   OPEN  cs_hrs;
   FETCH cs_hrs INTO l_retval;
   l_found := cs_hrs%FOUND;
   CLOSE cs_hrs;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_report_styles (HRS_PK)'
                                              ||CHR(10)||'hrs_style_name => '||pi_hrs_style_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hrs');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_report_styles (HRS_PK)'
                                              ||CHR(10)||'hrs_style_name => '||pi_hrs_style_name
                    );
--
END lock_hrs;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HRS_PK constraint
--
PROCEDURE lock_hrs (pi_hrs_style_name    hig_report_styles.hrs_style_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hrs');
--
   l_rowid := lock_hrs
                   (pi_hrs_style_name    => pi_hrs_style_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hrs');
--
END lock_hrs;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HIG_ROLES_PK constraint
--
FUNCTION lock_hro (pi_hro_role          hig_roles.hro_role%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hro IS
   SELECT /*+ INDEX (hro HIG_ROLES_PK) */ ROWID
    FROM  hig_roles hro
   WHERE  hro.hro_role = pi_hro_role
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hro');
--
   OPEN  cs_hro;
   FETCH cs_hro INTO l_retval;
   l_found := cs_hro%FOUND;
   CLOSE cs_hro;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_roles (HIG_ROLES_PK)'
                                              ||CHR(10)||'hro_role => '||pi_hro_role
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hro');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_roles (HIG_ROLES_PK)'
                                              ||CHR(10)||'hro_role => '||pi_hro_role
                    );
--
END lock_hro;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HIG_ROLES_PK constraint
--
PROCEDURE lock_hro (pi_hro_role          hig_roles.hro_role%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hro');
--
   l_rowid := lock_hro
                   (pi_hro_role          => pi_hro_role
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hro');
--
END lock_hro;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HSC_PK constraint
--
FUNCTION lock_hsc (pi_hsc_domain_code   hig_status_codes.hsc_domain_code%TYPE
                  ,pi_hsc_status_code   hig_status_codes.hsc_status_code%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hsc IS
   SELECT /*+ INDEX (hsc HSC_PK) */ ROWID
    FROM  hig_status_codes hsc
   WHERE  hsc.hsc_domain_code = pi_hsc_domain_code
    AND   hsc.hsc_status_code = pi_hsc_status_code
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hsc');
--
   OPEN  cs_hsc;
   FETCH cs_hsc INTO l_retval;
   l_found := cs_hsc%FOUND;
   CLOSE cs_hsc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_status_codes (HSC_PK)'
                                              ||CHR(10)||'hsc_domain_code => '||pi_hsc_domain_code
                                              ||CHR(10)||'hsc_status_code => '||pi_hsc_status_code
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hsc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_status_codes (HSC_PK)'
                                              ||CHR(10)||'hsc_domain_code => '||pi_hsc_domain_code
                                              ||CHR(10)||'hsc_status_code => '||pi_hsc_status_code
                    );
--
END lock_hsc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HSC_PK constraint
--
PROCEDURE lock_hsc (pi_hsc_domain_code   hig_status_codes.hsc_domain_code%TYPE
                   ,pi_hsc_status_code   hig_status_codes.hsc_status_code%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hsc');
--
   l_rowid := lock_hsc
                   (pi_hsc_domain_code   => pi_hsc_domain_code
                   ,pi_hsc_status_code   => pi_hsc_status_code
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hsc');
--
END lock_hsc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HSC_UK1 constraint
--
FUNCTION lock_hsc (pi_hsc_domain_code   hig_status_codes.hsc_domain_code%TYPE
                  ,pi_hsc_status_name   hig_status_codes.hsc_status_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hsc IS
   SELECT /*+ INDEX (hsc HSC_UK1) */ ROWID
    FROM  hig_status_codes hsc
   WHERE  hsc.hsc_domain_code = pi_hsc_domain_code
    AND   hsc.hsc_status_name = pi_hsc_status_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hsc');
--
   OPEN  cs_hsc;
   FETCH cs_hsc INTO l_retval;
   l_found := cs_hsc%FOUND;
   CLOSE cs_hsc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_status_codes (HSC_UK1)'
                                              ||CHR(10)||'hsc_domain_code => '||pi_hsc_domain_code
                                              ||CHR(10)||'hsc_status_name => '||pi_hsc_status_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hsc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_status_codes (HSC_UK1)'
                                              ||CHR(10)||'hsc_domain_code => '||pi_hsc_domain_code
                                              ||CHR(10)||'hsc_status_name => '||pi_hsc_status_name
                    );
--
END lock_hsc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HSC_UK1 constraint
--
PROCEDURE lock_hsc (pi_hsc_domain_code   hig_status_codes.hsc_domain_code%TYPE
                   ,pi_hsc_status_name   hig_status_codes.hsc_status_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hsc');
--
   l_rowid := lock_hsc
                   (pi_hsc_domain_code   => pi_hsc_domain_code
                   ,pi_hsc_status_name   => pi_hsc_status_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hsc');
--
END lock_hsc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HSD_PK constraint
--
FUNCTION lock_hsd (pi_hsd_domain_code   hig_status_domains.hsd_domain_code%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hsd IS
   SELECT /*+ INDEX (hsd HSD_PK) */ ROWID
    FROM  hig_status_domains hsd
   WHERE  hsd.hsd_domain_code = pi_hsd_domain_code
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hsd');
--
   OPEN  cs_hsd;
   FETCH cs_hsd INTO l_retval;
   l_found := cs_hsd%FOUND;
   CLOSE cs_hsd;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_status_domains (HSD_PK)'
                                              ||CHR(10)||'hsd_domain_code => '||pi_hsd_domain_code
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hsd');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_status_domains (HSD_PK)'
                                              ||CHR(10)||'hsd_domain_code => '||pi_hsd_domain_code
                    );
--
END lock_hsd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HSD_PK constraint
--
PROCEDURE lock_hsd (pi_hsd_domain_code   hig_status_domains.hsd_domain_code%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hsd');
--
   l_rowid := lock_hsd
                   (pi_hsd_domain_code   => pi_hsd_domain_code
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hsd');
--
END lock_hsd;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HUP_PK constraint
--
FUNCTION lock_hup (pi_hup_product       hig_upgrades.hup_product%TYPE
                  ,pi_date_upgraded     hig_upgrades.date_upgraded%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hup IS
   SELECT /*+ INDEX (hup HUP_PK) */ ROWID
    FROM  hig_upgrades hup
   WHERE  hup.hup_product   = pi_hup_product
    AND   hup.date_upgraded = pi_date_upgraded
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hup');
--
   OPEN  cs_hup;
   FETCH cs_hup INTO l_retval;
   l_found := cs_hup%FOUND;
   CLOSE cs_hup;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_upgrades (HUP_PK)'
                                              ||CHR(10)||'hup_product   => '||pi_hup_product
                                              ||CHR(10)||'date_upgraded => '||pi_date_upgraded
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hup');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_upgrades (HUP_PK)'
                                              ||CHR(10)||'hup_product   => '||pi_hup_product
                                              ||CHR(10)||'date_upgraded => '||pi_date_upgraded
                    );
--
END lock_hup;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HUP_PK constraint
--
PROCEDURE lock_hup (pi_hup_product       hig_upgrades.hup_product%TYPE
                   ,pi_date_upgraded     hig_upgrades.date_upgraded%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hup');
--
   l_rowid := lock_hup
                   (pi_hup_product       => pi_hup_product
                   ,pi_date_upgraded     => pi_date_upgraded
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hup');
--
END lock_hup;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HUM_PK constraint
--
FUNCTION lock_hum (pi_hum_hmo_module    hig_url_modules.hum_hmo_module%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hum IS
   SELECT /*+ INDEX (hum HUM_PK) */ ROWID
    FROM  hig_url_modules hum
   WHERE  hum.hum_hmo_module = pi_hum_hmo_module
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hum');
--
   OPEN  cs_hum;
   FETCH cs_hum INTO l_retval;
   l_found := cs_hum%FOUND;
   CLOSE cs_hum;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_url_modules (HUM_PK)'
                                              ||CHR(10)||'hum_hmo_module => '||pi_hum_hmo_module
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hum');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_url_modules (HUM_PK)'
                                              ||CHR(10)||'hum_hmo_module => '||pi_hum_hmo_module
                    );
--
END lock_hum;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HUM_PK constraint
--
PROCEDURE lock_hum (pi_hum_hmo_module    hig_url_modules.hum_hmo_module%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hum');
--
   l_rowid := lock_hum
                   (pi_hum_hmo_module    => pi_hum_hmo_module
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hum');
--
END lock_hum;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HIG_USERS_PK constraint
--
FUNCTION lock_hus (pi_hus_user_id       hig_users.hus_user_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hus IS
   SELECT /*+ INDEX (hus HIG_USERS_PK) */ ROWID
    FROM  hig_users hus
   WHERE  hus.hus_user_id = pi_hus_user_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hus');
--
   OPEN  cs_hus;
   FETCH cs_hus INTO l_retval;
   l_found := cs_hus%FOUND;
   CLOSE cs_hus;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_users (HIG_USERS_PK)'
                                              ||CHR(10)||'hus_user_id => '||pi_hus_user_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hus');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_users (HIG_USERS_PK)'
                                              ||CHR(10)||'hus_user_id => '||pi_hus_user_id
                    );
--
END lock_hus;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HIG_USERS_PK constraint
--
PROCEDURE lock_hus (pi_hus_user_id       hig_users.hus_user_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hus');
--
   l_rowid := lock_hus
                   (pi_hus_user_id       => pi_hus_user_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hus');
--
END lock_hus;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HUS_UK constraint
--
FUNCTION lock_hus (pi_hus_username      hig_users.hus_username%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hus IS
   SELECT /*+ INDEX (hus HUS_UK) */ ROWID
    FROM  hig_users hus
   WHERE  hus.hus_username = pi_hus_username
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hus');
--
   OPEN  cs_hus;
   FETCH cs_hus INTO l_retval;
   l_found := cs_hus%FOUND;
   CLOSE cs_hus;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_users (HUS_UK)'
                                              ||CHR(10)||'hus_username => '||pi_hus_username
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hus');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_users (HUS_UK)'
                                              ||CHR(10)||'hus_username => '||pi_hus_username
                    );
--
END lock_hus;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HUS_UK constraint
--
PROCEDURE lock_hus (pi_hus_username      hig_users.hus_username%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hus');
--
   l_rowid := lock_hus
                   (pi_hus_username      => pi_hus_username
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hus');
--
END lock_hus;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HUH_PK constraint
--
FUNCTION lock_huh (pi_huh_user_id       hig_user_history.huh_user_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_huh IS
   SELECT /*+ INDEX (huh HUH_PK) */ ROWID
    FROM  hig_user_history huh
   WHERE  huh.huh_user_id = pi_huh_user_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_huh');
--
   OPEN  cs_huh;
   FETCH cs_huh INTO l_retval;
   l_found := cs_huh%FOUND;
   CLOSE cs_huh;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_user_history (HUH_PK)'
                                              ||CHR(10)||'huh_user_id => '||pi_huh_user_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_huh');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_user_history (HUH_PK)'
                                              ||CHR(10)||'huh_user_id => '||pi_huh_user_id
                    );
--
END lock_huh;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HUH_PK constraint
--
PROCEDURE lock_huh (pi_huh_user_id       hig_user_history.huh_user_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_huh');
--
   l_rowid := lock_huh
                   (pi_huh_user_id       => pi_huh_user_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_huh');
--
END lock_huh;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HUO_PK constraint
--
FUNCTION lock_huo (pi_huo_hus_user_id   hig_user_options.huo_hus_user_id%TYPE
                  ,pi_huo_id            hig_user_options.huo_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_huo IS
   SELECT /*+ INDEX (huo HUO_PK) */ ROWID
    FROM  hig_user_options huo
   WHERE  huo.huo_hus_user_id = pi_huo_hus_user_id
    AND   huo.huo_id          = pi_huo_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_huo');
--
   OPEN  cs_huo;
   FETCH cs_huo INTO l_retval;
   l_found := cs_huo%FOUND;
   CLOSE cs_huo;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_user_options (HUO_PK)'
                                              ||CHR(10)||'huo_hus_user_id => '||pi_huo_hus_user_id
                                              ||CHR(10)||'huo_id          => '||pi_huo_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_huo');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_user_options (HUO_PK)'
                                              ||CHR(10)||'huo_hus_user_id => '||pi_huo_hus_user_id
                                              ||CHR(10)||'huo_id          => '||pi_huo_id
                    );
--
END lock_huo;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HUO_PK constraint
--
PROCEDURE lock_huo (pi_huo_hus_user_id   hig_user_options.huo_hus_user_id%TYPE
                   ,pi_huo_id            hig_user_options.huo_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_huo');
--
   l_rowid := lock_huo
                   (pi_huo_hus_user_id   => pi_huo_hus_user_id
                   ,pi_huo_id            => pi_huo_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_huo');
--
END lock_huo;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HUR_PK constraint
--
FUNCTION lock_hur (pi_hur_username      hig_user_roles.hur_username%TYPE
                  ,pi_hur_role          hig_user_roles.hur_role%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hur IS
   SELECT /*+ INDEX (hur HUR_PK) */ ROWID
    FROM  hig_user_roles hur
   WHERE  hur.hur_username = pi_hur_username
    AND   hur.hur_role     = pi_hur_role
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hur');
--
   OPEN  cs_hur;
   FETCH cs_hur INTO l_retval;
   l_found := cs_hur%FOUND;
   CLOSE cs_hur;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_user_roles (HUR_PK)'
                                              ||CHR(10)||'hur_username => '||pi_hur_username
                                              ||CHR(10)||'hur_role     => '||pi_hur_role
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_hur');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_user_roles (HUR_PK)'
                                              ||CHR(10)||'hur_username => '||pi_hur_username
                                              ||CHR(10)||'hur_role     => '||pi_hur_role
                    );
--
END lock_hur;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HUR_PK constraint
--
PROCEDURE lock_hur (pi_hur_username      hig_user_roles.hur_username%TYPE
                   ,pi_hur_role          hig_user_roles.hur_role%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_hur');
--
   l_rowid := lock_hur
                   (pi_hur_username      => pi_hur_username
                   ,pi_hur_role          => pi_hur_role
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_hur');
--
END lock_hur;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HAG_PK constraint
--
FUNCTION lock_nag (pi_nag_parent_admin_unit nm_admin_groups.nag_parent_admin_unit%TYPE
                  ,pi_nag_child_admin_unit  nm_admin_groups.nag_child_admin_unit%TYPE
                  ,pi_raise_not_found       BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode     PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode        PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nag IS
   SELECT /*+ INDEX (nag HAG_PK) */ ROWID
    FROM  nm_admin_groups nag
   WHERE  nag.nag_parent_admin_unit = pi_nag_parent_admin_unit
    AND   nag.nag_child_admin_unit  = pi_nag_child_admin_unit
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nag');
--
   OPEN  cs_nag;
   FETCH cs_nag INTO l_retval;
   l_found := cs_nag%FOUND;
   CLOSE cs_nag;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_admin_groups (HAG_PK)'
                                              ||CHR(10)||'nag_parent_admin_unit => '||pi_nag_parent_admin_unit
                                              ||CHR(10)||'nag_child_admin_unit  => '||pi_nag_child_admin_unit
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nag');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_admin_groups (HAG_PK)'
                                              ||CHR(10)||'nag_parent_admin_unit => '||pi_nag_parent_admin_unit
                                              ||CHR(10)||'nag_child_admin_unit  => '||pi_nag_child_admin_unit
                    );
--
END lock_nag;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HAG_PK constraint
--
PROCEDURE lock_nag (pi_nag_parent_admin_unit nm_admin_groups.nag_parent_admin_unit%TYPE
                   ,pi_nag_child_admin_unit  nm_admin_groups.nag_child_admin_unit%TYPE
                   ,pi_raise_not_found       BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode     PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode        PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nag');
--
   l_rowid := lock_nag
                   (pi_nag_parent_admin_unit => pi_nag_parent_admin_unit
                   ,pi_nag_child_admin_unit  => pi_nag_child_admin_unit
                   ,pi_raise_not_found       => pi_raise_not_found
                   ,pi_not_found_sqlcode     => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nag');
--
END lock_nag;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HAU_PK constraint
--
FUNCTION lock_nau (pi_nau_admin_unit    nm_admin_units.nau_admin_unit%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nau IS
   SELECT /*+ INDEX (nau HAU_PK) */ ROWID
    FROM  nm_admin_units nau
   WHERE  nau.nau_admin_unit = pi_nau_admin_unit
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nau');
--
   OPEN  cs_nau;
   FETCH cs_nau INTO l_retval;
   l_found := cs_nau%FOUND;
   CLOSE cs_nau;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_admin_units (HAU_PK)'
                                              ||CHR(10)||'nau_admin_unit => '||pi_nau_admin_unit
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nau');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_admin_units (HAU_PK)'
                                              ||CHR(10)||'nau_admin_unit => '||pi_nau_admin_unit
                    );
--
END lock_nau;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HAU_PK constraint
--
PROCEDURE lock_nau (pi_nau_admin_unit    nm_admin_units.nau_admin_unit%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nau');
--
   l_rowid := lock_nau
                   (pi_nau_admin_unit    => pi_nau_admin_unit
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nau');
--
END lock_nau;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HAU_UK2 constraint
--
FUNCTION lock_nau (pi_nau_name          nm_admin_units.nau_name%TYPE
                  ,pi_nau_admin_type    nm_admin_units.nau_admin_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nau IS
   SELECT /*+ INDEX (nau HAU_UK2) */ ROWID
    FROM  nm_admin_units nau
   WHERE  nau.nau_name       = pi_nau_name
    AND   nau.nau_admin_type = pi_nau_admin_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nau');
--
   OPEN  cs_nau;
   FETCH cs_nau INTO l_retval;
   l_found := cs_nau%FOUND;
   CLOSE cs_nau;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_admin_units (HAU_UK2)'
                                              ||CHR(10)||'nau_name       => '||pi_nau_name
                                              ||CHR(10)||'nau_admin_type => '||pi_nau_admin_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nau');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_admin_units (HAU_UK2)'
                                              ||CHR(10)||'nau_name       => '||pi_nau_name
                                              ||CHR(10)||'nau_admin_type => '||pi_nau_admin_type
                    );
--
END lock_nau;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HAU_UK2 constraint
--
PROCEDURE lock_nau (pi_nau_name          nm_admin_units.nau_name%TYPE
                   ,pi_nau_admin_type    nm_admin_units.nau_admin_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nau');
--
   l_rowid := lock_nau
                   (pi_nau_name          => pi_nau_name
                   ,pi_nau_admin_type    => pi_nau_admin_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nau');
--
END lock_nau;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HAU_UK1 constraint
--
FUNCTION lock_nau (pi_nau_unit_code     nm_admin_units.nau_unit_code%TYPE
                  ,pi_nau_admin_type    nm_admin_units.nau_admin_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nau IS
   SELECT /*+ INDEX (nau HAU_UK1) */ ROWID
    FROM  nm_admin_units nau
   WHERE  nau.nau_unit_code  = pi_nau_unit_code
    AND   nau.nau_admin_type = pi_nau_admin_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nau');
--
   OPEN  cs_nau;
   FETCH cs_nau INTO l_retval;
   l_found := cs_nau%FOUND;
   CLOSE cs_nau;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_admin_units (HAU_UK1)'
                                              ||CHR(10)||'nau_unit_code  => '||pi_nau_unit_code
                                              ||CHR(10)||'nau_admin_type => '||pi_nau_admin_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nau');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_admin_units (HAU_UK1)'
                                              ||CHR(10)||'nau_unit_code  => '||pi_nau_unit_code
                                              ||CHR(10)||'nau_admin_type => '||pi_nau_admin_type
                    );
--
END lock_nau;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HAU_UK1 constraint
--
PROCEDURE lock_nau (pi_nau_unit_code     nm_admin_units.nau_unit_code%TYPE
                   ,pi_nau_admin_type    nm_admin_units.nau_admin_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nau');
--
   l_rowid := lock_nau
                   (pi_nau_unit_code     => pi_nau_unit_code
                   ,pi_nau_admin_type    => pi_nau_admin_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nau');
--
END lock_nau;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HAU_PK constraint
--
FUNCTION lock_nau_all (pi_nau_admin_unit    nm_admin_units_all.nau_admin_unit%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_nau_all IS
   SELECT /*+ INDEX (nau_all HAU_PK) */ ROWID
    FROM  nm_admin_units_all nau_all
   WHERE  nau_all.nau_admin_unit = pi_nau_admin_unit
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nau_all');
--
   OPEN  cs_nau_all;
   FETCH cs_nau_all INTO l_retval;
   l_found := cs_nau_all%FOUND;
   CLOSE cs_nau_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_admin_units_all (HAU_PK)'
                                              ||CHR(10)||'nau_admin_unit => '||pi_nau_admin_unit
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nau_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_admin_units_all (HAU_PK)'
                                              ||CHR(10)||'nau_admin_unit => '||pi_nau_admin_unit
                    );
--
END lock_nau_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HAU_PK constraint
--
PROCEDURE lock_nau_all (pi_nau_admin_unit    nm_admin_units_all.nau_admin_unit%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nau_all');
--
   l_rowid := lock_nau_all
                   (pi_nau_admin_unit    => pi_nau_admin_unit
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nau_all');
--
END lock_nau_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HAU_UK2 constraint
--
FUNCTION lock_nau_all (pi_nau_name          nm_admin_units_all.nau_name%TYPE
                      ,pi_nau_admin_type    nm_admin_units_all.nau_admin_type%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_nau_all IS
   SELECT /*+ INDEX (nau_all HAU_UK2) */ ROWID
    FROM  nm_admin_units_all nau_all
   WHERE  nau_all.nau_name       = pi_nau_name
    AND   nau_all.nau_admin_type = pi_nau_admin_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nau_all');
--
   OPEN  cs_nau_all;
   FETCH cs_nau_all INTO l_retval;
   l_found := cs_nau_all%FOUND;
   CLOSE cs_nau_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_admin_units_all (HAU_UK2)'
                                              ||CHR(10)||'nau_name       => '||pi_nau_name
                                              ||CHR(10)||'nau_admin_type => '||pi_nau_admin_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nau_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_admin_units_all (HAU_UK2)'
                                              ||CHR(10)||'nau_name       => '||pi_nau_name
                                              ||CHR(10)||'nau_admin_type => '||pi_nau_admin_type
                    );
--
END lock_nau_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HAU_UK2 constraint
--
PROCEDURE lock_nau_all (pi_nau_name          nm_admin_units_all.nau_name%TYPE
                       ,pi_nau_admin_type    nm_admin_units_all.nau_admin_type%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nau_all');
--
   l_rowid := lock_nau_all
                   (pi_nau_name          => pi_nau_name
                   ,pi_nau_admin_type    => pi_nau_admin_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nau_all');
--
END lock_nau_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HAU_UK1 constraint
--
FUNCTION lock_nau_all (pi_nau_unit_code     nm_admin_units_all.nau_unit_code%TYPE
                      ,pi_nau_admin_type    nm_admin_units_all.nau_admin_type%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_nau_all IS
   SELECT /*+ INDEX (nau_all HAU_UK1) */ ROWID
    FROM  nm_admin_units_all nau_all
   WHERE  nau_all.nau_unit_code  = pi_nau_unit_code
    AND   nau_all.nau_admin_type = pi_nau_admin_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nau_all');
--
   OPEN  cs_nau_all;
   FETCH cs_nau_all INTO l_retval;
   l_found := cs_nau_all%FOUND;
   CLOSE cs_nau_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_admin_units_all (HAU_UK1)'
                                              ||CHR(10)||'nau_unit_code  => '||pi_nau_unit_code
                                              ||CHR(10)||'nau_admin_type => '||pi_nau_admin_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nau_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_admin_units_all (HAU_UK1)'
                                              ||CHR(10)||'nau_unit_code  => '||pi_nau_unit_code
                                              ||CHR(10)||'nau_admin_type => '||pi_nau_admin_type
                    );
--
END lock_nau_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HAU_UK1 constraint
--
PROCEDURE lock_nau_all (pi_nau_unit_code     nm_admin_units_all.nau_unit_code%TYPE
                       ,pi_nau_admin_type    nm_admin_units_all.nau_admin_type%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nau_all');
--
   l_rowid := lock_nau_all
                   (pi_nau_unit_code     => pi_nau_unit_code
                   ,pi_nau_admin_type    => pi_nau_admin_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nau_all');
--
END lock_nau_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NAL_PK constraint
--
FUNCTION lock_nal (pi_nal_id            nm_area_lock.nal_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nal IS
   SELECT /*+ INDEX (nal NAL_PK) */ ROWID
    FROM  nm_area_lock nal
   WHERE  nal.nal_id = pi_nal_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nal');
--
   OPEN  cs_nal;
   FETCH cs_nal INTO l_retval;
   l_found := cs_nal%FOUND;
   CLOSE cs_nal;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_area_lock (NAL_PK)'
                                              ||CHR(10)||'nal_id => '||pi_nal_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nal');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_area_lock (NAL_PK)'
                                              ||CHR(10)||'nal_id => '||pi_nal_id
                    );
--
END lock_nal;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NAL_PK constraint
--
PROCEDURE lock_nal (pi_nal_id            nm_area_lock.nal_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nal');
--
   l_rowid := lock_nal
                   (pi_nal_id            => pi_nal_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nal');
--
END lock_nal;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NARS_PK constraint
--
FUNCTION lock_nars (pi_nars_job_id         nm_assets_on_route_store.nars_job_id%TYPE
                   ,pi_nars_ne_id_in       nm_assets_on_route_store.nars_ne_id_in%TYPE
                   ,pi_nars_ne_id_of_begin nm_assets_on_route_store.nars_ne_id_of_begin%TYPE
                   ,pi_nars_begin_mp       nm_assets_on_route_store.nars_begin_mp%TYPE
                   ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nars IS
   SELECT /*+ INDEX (nars NARS_PK) */ ROWID
    FROM  nm_assets_on_route_store nars
   WHERE  nars.nars_job_id         = pi_nars_job_id
    AND   nars.nars_ne_id_in       = pi_nars_ne_id_in
    AND   nars.nars_ne_id_of_begin = pi_nars_ne_id_of_begin
    AND   nars.nars_begin_mp       = pi_nars_begin_mp
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nars');
--
   OPEN  cs_nars;
   FETCH cs_nars INTO l_retval;
   l_found := cs_nars%FOUND;
   CLOSE cs_nars;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_assets_on_route_store (NARS_PK)'
                                              ||CHR(10)||'nars_job_id         => '||pi_nars_job_id
                                              ||CHR(10)||'nars_ne_id_in       => '||pi_nars_ne_id_in
                                              ||CHR(10)||'nars_ne_id_of_begin => '||pi_nars_ne_id_of_begin
                                              ||CHR(10)||'nars_begin_mp       => '||pi_nars_begin_mp
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nars');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_assets_on_route_store (NARS_PK)'
                                              ||CHR(10)||'nars_job_id         => '||pi_nars_job_id
                                              ||CHR(10)||'nars_ne_id_in       => '||pi_nars_ne_id_in
                                              ||CHR(10)||'nars_ne_id_of_begin => '||pi_nars_ne_id_of_begin
                                              ||CHR(10)||'nars_begin_mp       => '||pi_nars_begin_mp
                    );
--
END lock_nars;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NARS_PK constraint
--
PROCEDURE lock_nars (pi_nars_job_id         nm_assets_on_route_store.nars_job_id%TYPE
                    ,pi_nars_ne_id_in       nm_assets_on_route_store.nars_ne_id_in%TYPE
                    ,pi_nars_ne_id_of_begin nm_assets_on_route_store.nars_ne_id_of_begin%TYPE
                    ,pi_nars_begin_mp       nm_assets_on_route_store.nars_begin_mp%TYPE
                    ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nars');
--
   l_rowid := lock_nars
                   (pi_nars_job_id         => pi_nars_job_id
                   ,pi_nars_ne_id_in       => pi_nars_ne_id_in
                   ,pi_nars_ne_id_of_begin => pi_nars_ne_id_of_begin
                   ,pi_nars_begin_mp       => pi_nars_begin_mp
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nars');
--
END lock_nars;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NARSH_PK constraint
--
FUNCTION lock_narsh (pi_narsh_job_id      nm_assets_on_route_store_head.narsh_job_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) RETURN ROWID IS
--
   CURSOR cs_narsh IS
   SELECT /*+ INDEX (narsh NARSH_PK) */ ROWID
    FROM  nm_assets_on_route_store_head narsh
   WHERE  narsh.narsh_job_id = pi_narsh_job_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_narsh');
--
   OPEN  cs_narsh;
   FETCH cs_narsh INTO l_retval;
   l_found := cs_narsh%FOUND;
   CLOSE cs_narsh;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_assets_on_route_store_head (NARSH_PK)'
                                              ||CHR(10)||'narsh_job_id => '||pi_narsh_job_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_narsh');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_assets_on_route_store_head (NARSH_PK)'
                                              ||CHR(10)||'narsh_job_id => '||pi_narsh_job_id
                    );
--
END lock_narsh;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NARSH_PK constraint
--
PROCEDURE lock_narsh (pi_narsh_job_id      nm_assets_on_route_store_head.narsh_job_id%TYPE
                     ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                     ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                     ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                     ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_narsh');
--
   l_rowid := lock_narsh
                   (pi_narsh_job_id      => pi_narsh_job_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_narsh');
--
END lock_narsh;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NARST_PK constraint
--
FUNCTION lock_narst (pi_narst_inv_type    nm_assets_on_route_store_total.narst_inv_type%TYPE
                    ,pi_narst_job_id      nm_assets_on_route_store_total.narst_job_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) RETURN ROWID IS
--
   CURSOR cs_narst IS
   SELECT /*+ INDEX (narst NARST_PK) */ ROWID
    FROM  nm_assets_on_route_store_total narst
   WHERE  narst.narst_inv_type = pi_narst_inv_type
    AND   narst.narst_job_id   = pi_narst_job_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_narst');
--
   OPEN  cs_narst;
   FETCH cs_narst INTO l_retval;
   l_found := cs_narst%FOUND;
   CLOSE cs_narst;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_assets_on_route_store_total (NARST_PK)'
                                              ||CHR(10)||'narst_inv_type => '||pi_narst_inv_type
                                              ||CHR(10)||'narst_job_id   => '||pi_narst_job_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_narst');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_assets_on_route_store_total (NARST_PK)'
                                              ||CHR(10)||'narst_inv_type => '||pi_narst_inv_type
                                              ||CHR(10)||'narst_job_id   => '||pi_narst_job_id
                    );
--
END lock_narst;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NARST_PK constraint
--
PROCEDURE lock_narst (pi_narst_inv_type    nm_assets_on_route_store_total.narst_inv_type%TYPE
                     ,pi_narst_job_id      nm_assets_on_route_store_total.narst_job_id%TYPE
                     ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                     ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                     ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                     ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_narst');
--
   l_rowid := lock_narst
                   (pi_narst_inv_type    => pi_narst_inv_type
                   ,pi_narst_job_id      => pi_narst_job_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_narst');
--
END lock_narst;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NM_AUDIT_PK constraint
--
FUNCTION lock_naa (pi_na_audit_id       nm_audit_actions.na_audit_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_naa IS
   SELECT /*+ INDEX (naa NM_AUDIT_PK) */ ROWID
    FROM  nm_audit_actions naa
   WHERE  naa.na_audit_id = pi_na_audit_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_naa');
--
   OPEN  cs_naa;
   FETCH cs_naa INTO l_retval;
   l_found := cs_naa%FOUND;
   CLOSE cs_naa;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_audit_actions (NM_AUDIT_PK)'
                                              ||CHR(10)||'na_audit_id => '||pi_na_audit_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_naa');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_audit_actions (NM_AUDIT_PK)'
                                              ||CHR(10)||'na_audit_id => '||pi_na_audit_id
                    );
--
END lock_naa;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NM_AUDIT_PK constraint
--
PROCEDURE lock_naa (pi_na_audit_id       nm_audit_actions.na_audit_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_naa');
--
   l_rowid := lock_naa
                   (pi_na_audit_id       => pi_na_audit_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_naa');
--
END lock_naa;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NACH_PK constraint
--
FUNCTION lock_nach (pi_nach_audit_id     nm_audit_changes.nach_audit_id%TYPE
                   ,pi_nach_column_id    nm_audit_changes.nach_column_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nach IS
   SELECT /*+ INDEX (nach NACH_PK) */ ROWID
    FROM  nm_audit_changes nach
   WHERE  nach.nach_audit_id  = pi_nach_audit_id
    AND   nach.nach_column_id = pi_nach_column_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nach');
--
   OPEN  cs_nach;
   FETCH cs_nach INTO l_retval;
   l_found := cs_nach%FOUND;
   CLOSE cs_nach;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_audit_changes (NACH_PK)'
                                              ||CHR(10)||'nach_audit_id  => '||pi_nach_audit_id
                                              ||CHR(10)||'nach_column_id => '||pi_nach_column_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nach');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_audit_changes (NACH_PK)'
                                              ||CHR(10)||'nach_audit_id  => '||pi_nach_audit_id
                                              ||CHR(10)||'nach_column_id => '||pi_nach_column_id
                    );
--
END lock_nach;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NACH_PK constraint
--
PROCEDURE lock_nach (pi_nach_audit_id     nm_audit_changes.nach_audit_id%TYPE
                    ,pi_nach_column_id    nm_audit_changes.nach_column_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nach');
--
   l_rowid := lock_nach
                   (pi_nach_audit_id     => pi_nach_audit_id
                   ,pi_nach_column_id    => pi_nach_column_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nach');
--
END lock_nach;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NM_AUDIT_COLUMNS_PK constraint
--
FUNCTION lock_nac (pi_nac_column_id     nm_audit_columns.nac_column_id%TYPE
                  ,pi_nac_table_name    nm_audit_columns.nac_table_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nac IS
   SELECT /*+ INDEX (nac NM_AUDIT_COLUMNS_PK) */ ROWID
    FROM  nm_audit_columns nac
   WHERE  nac.nac_column_id  = pi_nac_column_id
    AND   nac.nac_table_name = pi_nac_table_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nac');
--
   OPEN  cs_nac;
   FETCH cs_nac INTO l_retval;
   l_found := cs_nac%FOUND;
   CLOSE cs_nac;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_audit_columns (NM_AUDIT_COLUMNS_PK)'
                                              ||CHR(10)||'nac_column_id  => '||pi_nac_column_id
                                              ||CHR(10)||'nac_table_name => '||pi_nac_table_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nac');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_audit_columns (NM_AUDIT_COLUMNS_PK)'
                                              ||CHR(10)||'nac_column_id  => '||pi_nac_column_id
                                              ||CHR(10)||'nac_table_name => '||pi_nac_table_name
                    );
--
END lock_nac;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NM_AUDIT_COLUMNS_PK constraint
--
PROCEDURE lock_nac (pi_nac_column_id     nm_audit_columns.nac_column_id%TYPE
                   ,pi_nac_table_name    nm_audit_columns.nac_table_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nac');
--
   l_rowid := lock_nac
                   (pi_nac_column_id     => pi_nac_column_id
                   ,pi_nac_table_name    => pi_nac_table_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nac');
--
END lock_nac;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NM_AUDIT_KEY_COLS_PK constraint
--
FUNCTION lock_nkc (pi_nkc_seq_no        nm_audit_key_cols.nkc_seq_no%TYPE
                  ,pi_nkc_table_name    nm_audit_key_cols.nkc_table_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nkc IS
   SELECT /*+ INDEX (nkc NM_AUDIT_KEY_COLS_PK) */ ROWID
    FROM  nm_audit_key_cols nkc
   WHERE  nkc.nkc_seq_no     = pi_nkc_seq_no
    AND   nkc.nkc_table_name = pi_nkc_table_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nkc');
--
   OPEN  cs_nkc;
   FETCH cs_nkc INTO l_retval;
   l_found := cs_nkc%FOUND;
   CLOSE cs_nkc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_audit_key_cols (NM_AUDIT_KEY_COLS_PK)'
                                              ||CHR(10)||'nkc_seq_no     => '||pi_nkc_seq_no
                                              ||CHR(10)||'nkc_table_name => '||pi_nkc_table_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nkc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_audit_key_cols (NM_AUDIT_KEY_COLS_PK)'
                                              ||CHR(10)||'nkc_seq_no     => '||pi_nkc_seq_no
                                              ||CHR(10)||'nkc_table_name => '||pi_nkc_table_name
                    );
--
END lock_nkc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NM_AUDIT_KEY_COLS_PK constraint
--
PROCEDURE lock_nkc (pi_nkc_seq_no        nm_audit_key_cols.nkc_seq_no%TYPE
                   ,pi_nkc_table_name    nm_audit_key_cols.nkc_table_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nkc');
--
   l_rowid := lock_nkc
                   (pi_nkc_seq_no        => pi_nkc_seq_no
                   ,pi_nkc_table_name    => pi_nkc_table_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nkc');
--
END lock_nkc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NM_AUDIT_TABLES_PK constraint
--
FUNCTION lock_natab (pi_nat_table_name    nm_audit_tables.nat_table_name%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) RETURN ROWID IS
--
   CURSOR cs_natab IS
   SELECT /*+ INDEX (natab NM_AUDIT_TABLES_PK) */ ROWID
    FROM  nm_audit_tables natab
   WHERE  natab.nat_table_name = pi_nat_table_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_natab');
--
   OPEN  cs_natab;
   FETCH cs_natab INTO l_retval;
   l_found := cs_natab%FOUND;
   CLOSE cs_natab;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_audit_tables (NM_AUDIT_TABLES_PK)'
                                              ||CHR(10)||'nat_table_name => '||pi_nat_table_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_natab');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_audit_tables (NM_AUDIT_TABLES_PK)'
                                              ||CHR(10)||'nat_table_name => '||pi_nat_table_name
                    );
--
END lock_natab;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NM_AUDIT_TABLES_PK constraint
--
PROCEDURE lock_natab (pi_nat_table_name    nm_audit_tables.nat_table_name%TYPE
                     ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                     ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                     ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                     ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_natab');
--
   l_rowid := lock_natab
                   (pi_nat_table_name    => pi_nat_table_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_natab');
--
END lock_natab;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NM_AUDIT_TEMP_PK constraint
--
FUNCTION lock_natmp (pi_nat_audit_id      nm_audit_temp.nat_audit_id%TYPE
                    ,pi_nat_old_or_new    nm_audit_temp.nat_old_or_new%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) RETURN ROWID IS
--
   CURSOR cs_natmp IS
   SELECT /*+ INDEX (natmp NM_AUDIT_TEMP_PK) */ ROWID
    FROM  nm_audit_temp natmp
   WHERE  natmp.nat_audit_id   = pi_nat_audit_id
    AND   natmp.nat_old_or_new = pi_nat_old_or_new
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_natmp');
--
   OPEN  cs_natmp;
   FETCH cs_natmp INTO l_retval;
   l_found := cs_natmp%FOUND;
   CLOSE cs_natmp;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_audit_temp (NM_AUDIT_TEMP_PK)'
                                              ||CHR(10)||'nat_audit_id   => '||pi_nat_audit_id
                                              ||CHR(10)||'nat_old_or_new => '||pi_nat_old_or_new
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_natmp');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_audit_temp (NM_AUDIT_TEMP_PK)'
                                              ||CHR(10)||'nat_audit_id   => '||pi_nat_audit_id
                                              ||CHR(10)||'nat_old_or_new => '||pi_nat_old_or_new
                    );
--
END lock_natmp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NM_AUDIT_TEMP_PK constraint
--
PROCEDURE lock_natmp (pi_nat_audit_id      nm_audit_temp.nat_audit_id%TYPE
                     ,pi_nat_old_or_new    nm_audit_temp.nat_old_or_new%TYPE
                     ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                     ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                     ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                     ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_natmp');
--
   l_rowid := lock_natmp
                   (pi_nat_audit_id      => pi_nat_audit_id
                   ,pi_nat_old_or_new    => pi_nat_old_or_new
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_natmp');
--
END lock_natmp;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NAT_PK constraint
--
FUNCTION lock_nat (pi_nat_admin_type    nm_au_types.nat_admin_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nat IS
   SELECT /*+ INDEX (nat NAT_PK) */ ROWID
    FROM  nm_au_types nat
   WHERE  nat.nat_admin_type = pi_nat_admin_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nat');
--
   OPEN  cs_nat;
   FETCH cs_nat INTO l_retval;
   l_found := cs_nat%FOUND;
   CLOSE cs_nat;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_au_types (NAT_PK)'
                                              ||CHR(10)||'nat_admin_type => '||pi_nat_admin_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nat');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_au_types (NAT_PK)'
                                              ||CHR(10)||'nat_admin_type => '||pi_nat_admin_type
                    );
--
END lock_nat;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NAT_PK constraint
--
PROCEDURE lock_nat (pi_nat_admin_type    nm_au_types.nat_admin_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nat');
--
   l_rowid := lock_nat
                   (pi_nat_admin_type    => pi_nat_admin_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nat');
--
END lock_nat;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NSTY_PK constraint
--
FUNCTION lock_nsty (pi_nsty_id           nm_au_sub_types.nsty_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nsty IS
   SELECT /*+ INDEX (nsty NSTY_PK) */ ROWID
    FROM  nm_au_sub_types nsty
   WHERE  nsty.nsty_id = pi_nsty_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsty');
--
   OPEN  cs_nsty;
   FETCH cs_nsty INTO l_retval;
   l_found := cs_nsty%FOUND;
   CLOSE cs_nsty;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_au_sub_types (NSTY_PK)'
                                              ||CHR(10)||'nsty_id => '||pi_nsty_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nsty');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_au_sub_types (NSTY_PK)'
                                              ||CHR(10)||'nsty_id => '||pi_nsty_id
                    );
--
END lock_nsty;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NSTY_PK constraint
--
PROCEDURE lock_nsty (pi_nsty_id           nm_au_sub_types.nsty_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsty');
--
   l_rowid := lock_nsty
                   (pi_nsty_id           => pi_nsty_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nsty');
--
END lock_nsty;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NSTY_UK1 constraint
--
FUNCTION lock_nsty (pi_nsty_nat_admin_type nm_au_sub_types.nsty_nat_admin_type%TYPE
                   ,pi_nsty_sub_type       nm_au_sub_types.nsty_sub_type%TYPE
                   ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nsty IS
   SELECT /*+ INDEX (nsty NSTY_UK1) */ ROWID
    FROM  nm_au_sub_types nsty
   WHERE  nsty.nsty_nat_admin_type = pi_nsty_nat_admin_type
    AND   nsty.nsty_sub_type       = pi_nsty_sub_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsty');
--
   OPEN  cs_nsty;
   FETCH cs_nsty INTO l_retval;
   l_found := cs_nsty%FOUND;
   CLOSE cs_nsty;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_au_sub_types (NSTY_UK1)'
                                              ||CHR(10)||'nsty_nat_admin_type => '||pi_nsty_nat_admin_type
                                              ||CHR(10)||'nsty_sub_type       => '||pi_nsty_sub_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nsty');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_au_sub_types (NSTY_UK1)'
                                              ||CHR(10)||'nsty_nat_admin_type => '||pi_nsty_nat_admin_type
                                              ||CHR(10)||'nsty_sub_type       => '||pi_nsty_sub_type
                    );
--
END lock_nsty;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NSTY_UK1 constraint
--
PROCEDURE lock_nsty (pi_nsty_nat_admin_type nm_au_sub_types.nsty_nat_admin_type%TYPE
                    ,pi_nsty_sub_type       nm_au_sub_types.nsty_sub_type%TYPE
                    ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsty');
--
   l_rowid := lock_nsty
                   (pi_nsty_nat_admin_type => pi_nsty_nat_admin_type
                   ,pi_nsty_sub_type       => pi_nsty_sub_type
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nsty');
--
END lock_nsty;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NATG_PK constraint
--
FUNCTION lock_natg (pi_natg_nat_admin_type nm_au_types_groupings.natg_nat_admin_type%TYPE
                   ,pi_natg_grouping       nm_au_types_groupings.natg_grouping%TYPE
                   ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_natg IS
   SELECT /*+ INDEX (natg NATG_PK) */ ROWID
    FROM  nm_au_types_groupings natg
   WHERE  natg.natg_nat_admin_type = pi_natg_nat_admin_type
    AND   natg.natg_grouping       = pi_natg_grouping
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_natg');
--
   OPEN  cs_natg;
   FETCH cs_natg INTO l_retval;
   l_found := cs_natg%FOUND;
   CLOSE cs_natg;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_au_types_groupings (NATG_PK)'
                                              ||CHR(10)||'natg_nat_admin_type => '||pi_natg_nat_admin_type
                                              ||CHR(10)||'natg_grouping       => '||pi_natg_grouping
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_natg');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_au_types_groupings (NATG_PK)'
                                              ||CHR(10)||'natg_nat_admin_type => '||pi_natg_nat_admin_type
                                              ||CHR(10)||'natg_grouping       => '||pi_natg_grouping
                    );
--
END lock_natg;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NATG_PK constraint
--
PROCEDURE lock_natg (pi_natg_nat_admin_type nm_au_types_groupings.natg_nat_admin_type%TYPE
                    ,pi_natg_grouping       nm_au_types_groupings.natg_grouping%TYPE
                    ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_natg');
--
   l_rowid := lock_natg
                   (pi_natg_nat_admin_type => pi_natg_nat_admin_type
                   ,pi_natg_grouping       => pi_natg_grouping
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_natg');
--
END lock_natg;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using ND_PK constraint
--
FUNCTION lock_nd (pi_nd_id             nm_dbug.nd_id%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) RETURN ROWID IS
--
   CURSOR cs_nd IS
   SELECT /*+ INDEX (nd ND_PK) */ ROWID
    FROM  nm_dbug nd
   WHERE  nd.nd_id = pi_nd_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nd');
--
   OPEN  cs_nd;
   FETCH cs_nd INTO l_retval;
   l_found := cs_nd%FOUND;
   CLOSE cs_nd;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_dbug (ND_PK)'
                                              ||CHR(10)||'nd_id => '||pi_nd_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nd');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_dbug (ND_PK)'
                                              ||CHR(10)||'nd_id => '||pi_nd_id
                    );
--
END lock_nd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using ND_PK constraint
--
PROCEDURE lock_nd (pi_nd_id             nm_dbug.nd_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nd');
--
   l_rowid := lock_nd
                   (pi_nd_id             => pi_nd_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nd');
--
END lock_nd;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NE_PK constraint
--
FUNCTION lock_ne (pi_ne_id             nm_elements.ne_id%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) RETURN ROWID IS
--
   CURSOR cs_ne IS
   SELECT /*+ INDEX (ne NE_PK) */ ROWID
    FROM  nm_elements ne
   WHERE  ne.ne_id = pi_ne_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ne');
--
   OPEN  cs_ne;
   FETCH cs_ne INTO l_retval;
   l_found := cs_ne%FOUND;
   CLOSE cs_ne;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_elements (NE_PK)'
                                              ||CHR(10)||'ne_id => '||pi_ne_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ne');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_elements (NE_PK)'
                                              ||CHR(10)||'ne_id => '||pi_ne_id
                    );
--
END lock_ne;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NE_PK constraint
--
PROCEDURE lock_ne (pi_ne_id             nm_elements.ne_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ne');
--
   l_rowid := lock_ne
                   (pi_ne_id             => pi_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ne');
--
END lock_ne;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NE_UK constraint
--
FUNCTION lock_ne (pi_ne_unique         nm_elements.ne_unique%TYPE
                 ,pi_ne_nt_type        nm_elements.ne_nt_type%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) RETURN ROWID IS
--
   CURSOR cs_ne IS
   SELECT /*+ INDEX (ne NE_UK) */ ROWID
    FROM  nm_elements ne
   WHERE  ne.ne_unique  = pi_ne_unique
    AND   ne.ne_nt_type = pi_ne_nt_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ne');
--
   OPEN  cs_ne;
   FETCH cs_ne INTO l_retval;
   l_found := cs_ne%FOUND;
   CLOSE cs_ne;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_elements (NE_UK)'
                                              ||CHR(10)||'ne_unique  => '||pi_ne_unique
                                              ||CHR(10)||'ne_nt_type => '||pi_ne_nt_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ne');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_elements (NE_UK)'
                                              ||CHR(10)||'ne_unique  => '||pi_ne_unique
                                              ||CHR(10)||'ne_nt_type => '||pi_ne_nt_type
                    );
--
END lock_ne;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NE_UK constraint
--
PROCEDURE lock_ne (pi_ne_unique         nm_elements.ne_unique%TYPE
                  ,pi_ne_nt_type        nm_elements.ne_nt_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ne');
--
   l_rowid := lock_ne
                   (pi_ne_unique         => pi_ne_unique
                   ,pi_ne_nt_type        => pi_ne_nt_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ne');
--
END lock_ne;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NE_PK constraint
--
FUNCTION lock_ne_all (pi_ne_id             nm_elements_all.ne_id%TYPE
                     ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                     ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                     ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                     ) RETURN ROWID IS
--
   CURSOR cs_ne_all IS
   SELECT /*+ INDEX (ne_all NE_PK) */ ROWID
    FROM  nm_elements_all ne_all
   WHERE  ne_all.ne_id = pi_ne_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ne_all');
--
   OPEN  cs_ne_all;
   FETCH cs_ne_all INTO l_retval;
   l_found := cs_ne_all%FOUND;
   CLOSE cs_ne_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_elements_all (NE_PK)'
                                              ||CHR(10)||'ne_id => '||pi_ne_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ne_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_elements_all (NE_PK)'
                                              ||CHR(10)||'ne_id => '||pi_ne_id
                    );
--
END lock_ne_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NE_PK constraint
--
PROCEDURE lock_ne_all (pi_ne_id             nm_elements_all.ne_id%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ne_all');
--
   l_rowid := lock_ne_all
                   (pi_ne_id             => pi_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ne_all');
--
END lock_ne_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NE_UK constraint
--
FUNCTION lock_ne_all (pi_ne_unique         nm_elements_all.ne_unique%TYPE
                     ,pi_ne_nt_type        nm_elements_all.ne_nt_type%TYPE
                     ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                     ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                     ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                     ) RETURN ROWID IS
--
   CURSOR cs_ne_all IS
   SELECT /*+ INDEX (ne_all NE_UK) */ ROWID
    FROM  nm_elements_all ne_all
   WHERE  ne_all.ne_unique  = pi_ne_unique
    AND   ne_all.ne_nt_type = pi_ne_nt_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ne_all');
--
   OPEN  cs_ne_all;
   FETCH cs_ne_all INTO l_retval;
   l_found := cs_ne_all%FOUND;
   CLOSE cs_ne_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_elements_all (NE_UK)'
                                              ||CHR(10)||'ne_unique  => '||pi_ne_unique
                                              ||CHR(10)||'ne_nt_type => '||pi_ne_nt_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ne_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_elements_all (NE_UK)'
                                              ||CHR(10)||'ne_unique  => '||pi_ne_unique
                                              ||CHR(10)||'ne_nt_type => '||pi_ne_nt_type
                    );
--
END lock_ne_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NE_UK constraint
--
PROCEDURE lock_ne_all (pi_ne_unique         nm_elements_all.ne_unique%TYPE
                      ,pi_ne_nt_type        nm_elements_all.ne_nt_type%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ne_all');
--
   l_rowid := lock_ne_all
                   (pi_ne_unique         => pi_ne_unique
                   ,pi_ne_nt_type        => pi_ne_nt_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ne_all');
--
END lock_ne_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NEH_PK constraint
--
FUNCTION lock_neh (pi_neh_id            nm_element_history.neh_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_neh IS
   SELECT /*+ INDEX (neh NEH_PK) */ ROWID
    FROM  nm_element_history neh
   WHERE  neh.neh_id = pi_neh_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_neh');
--
   OPEN  cs_neh;
   FETCH cs_neh INTO l_retval;
   l_found := cs_neh%FOUND;
   CLOSE cs_neh;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_element_history (NEH_PK)'
                                              ||CHR(10)||'neh_id => '||pi_neh_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_neh');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_element_history (NEH_PK)'
                                              ||CHR(10)||'neh_id => '||pi_neh_id
                    );
--
END lock_neh;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NEH_PK constraint
--
PROCEDURE lock_neh (pi_neh_id            nm_element_history.neh_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_neh');
--
   l_rowid := lock_neh
                   (pi_neh_id            => pi_neh_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_neh');
--
END lock_neh;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NER_PK constraint
--
FUNCTION lock_ner (pi_ner_id            nm_errors.ner_id%TYPE
                  ,pi_ner_appl          nm_errors.ner_appl%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_ner IS
   SELECT /*+ INDEX (ner NER_PK) */ ROWID
    FROM  nm_errors ner
   WHERE  ner.ner_id   = pi_ner_id
    AND   ner.ner_appl = pi_ner_appl
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ner');
--
   OPEN  cs_ner;
   FETCH cs_ner INTO l_retval;
   l_found := cs_ner%FOUND;
   CLOSE cs_ner;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_errors (NER_PK)'
                                              ||CHR(10)||'ner_id   => '||pi_ner_id
                                              ||CHR(10)||'ner_appl => '||pi_ner_appl
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ner');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_errors (NER_PK)'
                                              ||CHR(10)||'ner_id   => '||pi_ner_id
                                              ||CHR(10)||'ner_appl => '||pi_ner_appl
                    );
--
END lock_ner;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NER_PK constraint
--
PROCEDURE lock_ner (pi_ner_id            nm_errors.ner_id%TYPE
                   ,pi_ner_appl          nm_errors.ner_appl%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ner');
--
   l_rowid := lock_ner
                   (pi_ner_id            => pi_ner_id
                   ,pi_ner_appl          => pi_ner_appl
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ner');
--
END lock_ner;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NEL_PK constraint
--
FUNCTION lock_nel (pi_nel_id            nm_event_log.nel_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nel IS
   SELECT /*+ INDEX (nel NEL_PK) */ ROWID
    FROM  nm_event_log nel
   WHERE  nel.nel_id = pi_nel_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nel');
--
   OPEN  cs_nel;
   FETCH cs_nel INTO l_retval;
   l_found := cs_nel%FOUND;
   CLOSE cs_nel;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_event_log (NEL_PK)'
                                              ||CHR(10)||'nel_id => '||pi_nel_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nel');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_event_log (NEL_PK)'
                                              ||CHR(10)||'nel_id => '||pi_nel_id
                    );
--
END lock_nel;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NEL_PK constraint
--
PROCEDURE lock_nel (pi_nel_id            nm_event_log.nel_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nel');
--
   l_rowid := lock_nel
                   (pi_nel_id            => pi_nel_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nel');
--
END lock_nel;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NET_PK constraint
--
FUNCTION lock_net (pi_net_type          nm_event_types.net_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_net IS
   SELECT /*+ INDEX (net NET_PK) */ ROWID
    FROM  nm_event_types net
   WHERE  net.net_type = pi_net_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_net');
--
   OPEN  cs_net;
   FETCH cs_net INTO l_retval;
   l_found := cs_net%FOUND;
   CLOSE cs_net;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_event_types (NET_PK)'
                                              ||CHR(10)||'net_type => '||pi_net_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_net');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_event_types (NET_PK)'
                                              ||CHR(10)||'net_type => '||pi_net_type
                    );
--
END lock_net;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NET_PK constraint
--
PROCEDURE lock_net (pi_net_type          nm_event_types.net_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_net');
--
   l_rowid := lock_net
                   (pi_net_type          => pi_net_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_net');
--
END lock_net;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NET_UK constraint
--
FUNCTION lock_net (pi_net_unique        nm_event_types.net_unique%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_net IS
   SELECT /*+ INDEX (net NET_UK) */ ROWID
    FROM  nm_event_types net
   WHERE  net.net_unique = pi_net_unique
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_net');
--
   OPEN  cs_net;
   FETCH cs_net INTO l_retval;
   l_found := cs_net%FOUND;
   CLOSE cs_net;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_event_types (NET_UK)'
                                              ||CHR(10)||'net_unique => '||pi_net_unique
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_net');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_event_types (NET_UK)'
                                              ||CHR(10)||'net_unique => '||pi_net_unique
                    );
--
END lock_net;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NET_UK constraint
--
PROCEDURE lock_net (pi_net_unique        nm_event_types.net_unique%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_net');
--
   l_rowid := lock_net
                   (pi_net_unique        => pi_net_unique
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_net');
--
END lock_net;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NFP_PK constraint
--
FUNCTION lock_nfp (pi_nfp_id            nm_fill_patterns.nfp_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nfp IS
   SELECT /*+ INDEX (nfp NFP_PK) */ ROWID
    FROM  nm_fill_patterns nfp
   WHERE  nfp.nfp_id = pi_nfp_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nfp');
--
   OPEN  cs_nfp;
   FETCH cs_nfp INTO l_retval;
   l_found := cs_nfp%FOUND;
   CLOSE cs_nfp;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_fill_patterns (NFP_PK)'
                                              ||CHR(10)||'nfp_id => '||pi_nfp_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nfp');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_fill_patterns (NFP_PK)'
                                              ||CHR(10)||'nfp_id => '||pi_nfp_id
                    );
--
END lock_nfp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NFP_PK constraint
--
PROCEDURE lock_nfp (pi_nfp_id            nm_fill_patterns.nfp_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nfp');
--
   l_rowid := lock_nfp
                   (pi_nfp_id            => pi_nfp_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nfp');
--
END lock_nfp;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NGIT_PK constraint
--
FUNCTION lock_ngit (pi_ngit_ngt_group_type nm_group_inv_types.ngit_ngt_group_type%TYPE
                   ,pi_ngit_nit_inv_type   nm_group_inv_types.ngit_nit_inv_type%TYPE
                   ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_ngit IS
   SELECT /*+ INDEX (ngit NGIT_PK) */ ROWID
    FROM  nm_group_inv_types ngit
   WHERE  ngit.ngit_ngt_group_type = pi_ngit_ngt_group_type
    AND   ngit.ngit_nit_inv_type   = pi_ngit_nit_inv_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngit');
--
   OPEN  cs_ngit;
   FETCH cs_ngit INTO l_retval;
   l_found := cs_ngit%FOUND;
   CLOSE cs_ngit;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_group_inv_types (NGIT_PK)'
                                              ||CHR(10)||'ngit_ngt_group_type => '||pi_ngit_ngt_group_type
                                              ||CHR(10)||'ngit_nit_inv_type   => '||pi_ngit_nit_inv_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ngit');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_group_inv_types (NGIT_PK)'
                                              ||CHR(10)||'ngit_ngt_group_type => '||pi_ngit_ngt_group_type
                                              ||CHR(10)||'ngit_nit_inv_type   => '||pi_ngit_nit_inv_type
                    );
--
END lock_ngit;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NGIT_PK constraint
--
PROCEDURE lock_ngit (pi_ngit_ngt_group_type nm_group_inv_types.ngit_ngt_group_type%TYPE
                    ,pi_ngit_nit_inv_type   nm_group_inv_types.ngit_nit_inv_type%TYPE
                    ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngit');
--
   l_rowid := lock_ngit
                   (pi_ngit_ngt_group_type => pi_ngit_ngt_group_type
                   ,pi_ngit_nit_inv_type   => pi_ngit_nit_inv_type
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ngit');
--
END lock_ngit;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NGIT_UK constraint
--
FUNCTION lock_ngit (pi_ngit_ngt_group_type nm_group_inv_types.ngit_ngt_group_type%TYPE
                   ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_ngit IS
   SELECT /*+ INDEX (ngit NGIT_UK) */ ROWID
    FROM  nm_group_inv_types ngit
   WHERE  ngit.ngit_ngt_group_type = pi_ngit_ngt_group_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngit');
--
   OPEN  cs_ngit;
   FETCH cs_ngit INTO l_retval;
   l_found := cs_ngit%FOUND;
   CLOSE cs_ngit;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_group_inv_types (NGIT_UK)'
                                              ||CHR(10)||'ngit_ngt_group_type => '||pi_ngit_ngt_group_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ngit');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_group_inv_types (NGIT_UK)'
                                              ||CHR(10)||'ngit_ngt_group_type => '||pi_ngit_ngt_group_type
                    );
--
END lock_ngit;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NGIT_UK constraint
--
PROCEDURE lock_ngit (pi_ngit_ngt_group_type nm_group_inv_types.ngit_ngt_group_type%TYPE
                    ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngit');
--
   l_rowid := lock_ngit
                   (pi_ngit_ngt_group_type => pi_ngit_ngt_group_type
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ngit');
--
END lock_ngit;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NGIL_PK constraint
--
FUNCTION lock_ngil (pi_ngil_ne_ne_id     nm_group_inv_link.ngil_ne_ne_id%TYPE
                   ,pi_ngil_iit_ne_id    nm_group_inv_link.ngil_iit_ne_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_ngil IS
   SELECT /*+ INDEX (ngil NGIL_PK) */ ROWID
    FROM  nm_group_inv_link ngil
   WHERE  ngil.ngil_ne_ne_id  = pi_ngil_ne_ne_id
    AND   ngil.ngil_iit_ne_id = pi_ngil_iit_ne_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngil');
--
   OPEN  cs_ngil;
   FETCH cs_ngil INTO l_retval;
   l_found := cs_ngil%FOUND;
   CLOSE cs_ngil;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_group_inv_link (NGIL_PK)'
                                              ||CHR(10)||'ngil_ne_ne_id  => '||pi_ngil_ne_ne_id
                                              ||CHR(10)||'ngil_iit_ne_id => '||pi_ngil_iit_ne_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ngil');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_group_inv_link (NGIL_PK)'
                                              ||CHR(10)||'ngil_ne_ne_id  => '||pi_ngil_ne_ne_id
                                              ||CHR(10)||'ngil_iit_ne_id => '||pi_ngil_iit_ne_id
                    );
--
END lock_ngil;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NGIL_PK constraint
--
PROCEDURE lock_ngil (pi_ngil_ne_ne_id     nm_group_inv_link.ngil_ne_ne_id%TYPE
                    ,pi_ngil_iit_ne_id    nm_group_inv_link.ngil_iit_ne_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngil');
--
   l_rowid := lock_ngil
                   (pi_ngil_ne_ne_id     => pi_ngil_ne_ne_id
                   ,pi_ngil_iit_ne_id    => pi_ngil_iit_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ngil');
--
END lock_ngil;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NGIL_UK constraint
--
FUNCTION lock_ngil (pi_ngil_ne_ne_id     nm_group_inv_link.ngil_ne_ne_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_ngil IS
   SELECT /*+ INDEX (ngil NGIL_UK) */ ROWID
    FROM  nm_group_inv_link ngil
   WHERE  ngil.ngil_ne_ne_id = pi_ngil_ne_ne_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngil');
--
   OPEN  cs_ngil;
   FETCH cs_ngil INTO l_retval;
   l_found := cs_ngil%FOUND;
   CLOSE cs_ngil;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_group_inv_link (NGIL_UK)'
                                              ||CHR(10)||'ngil_ne_ne_id => '||pi_ngil_ne_ne_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ngil');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_group_inv_link (NGIL_UK)'
                                              ||CHR(10)||'ngil_ne_ne_id => '||pi_ngil_ne_ne_id
                    );
--
END lock_ngil;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NGIL_UK constraint
--
PROCEDURE lock_ngil (pi_ngil_ne_ne_id     nm_group_inv_link.ngil_ne_ne_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngil');
--
   l_rowid := lock_ngil
                   (pi_ngil_ne_ne_id     => pi_ngil_ne_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ngil');
--
END lock_ngil;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NGIL_PK constraint
--
FUNCTION lock_ngil_all (pi_ngil_ne_ne_id     nm_group_inv_link_all.ngil_ne_ne_id%TYPE
                       ,pi_ngil_iit_ne_id    nm_group_inv_link_all.ngil_iit_ne_id%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) RETURN ROWID IS
--
   CURSOR cs_ngil_all IS
   SELECT /*+ INDEX (ngil_all NGIL_PK) */ ROWID
    FROM  nm_group_inv_link_all ngil_all
   WHERE  ngil_all.ngil_ne_ne_id  = pi_ngil_ne_ne_id
    AND   ngil_all.ngil_iit_ne_id = pi_ngil_iit_ne_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngil_all');
--
   OPEN  cs_ngil_all;
   FETCH cs_ngil_all INTO l_retval;
   l_found := cs_ngil_all%FOUND;
   CLOSE cs_ngil_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_group_inv_link_all (NGIL_PK)'
                                              ||CHR(10)||'ngil_ne_ne_id  => '||pi_ngil_ne_ne_id
                                              ||CHR(10)||'ngil_iit_ne_id => '||pi_ngil_iit_ne_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ngil_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_group_inv_link_all (NGIL_PK)'
                                              ||CHR(10)||'ngil_ne_ne_id  => '||pi_ngil_ne_ne_id
                                              ||CHR(10)||'ngil_iit_ne_id => '||pi_ngil_iit_ne_id
                    );
--
END lock_ngil_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NGIL_PK constraint
--
PROCEDURE lock_ngil_all (pi_ngil_ne_ne_id     nm_group_inv_link_all.ngil_ne_ne_id%TYPE
                        ,pi_ngil_iit_ne_id    nm_group_inv_link_all.ngil_iit_ne_id%TYPE
                        ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                        ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                        ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                        ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngil_all');
--
   l_rowid := lock_ngil_all
                   (pi_ngil_ne_ne_id     => pi_ngil_ne_ne_id
                   ,pi_ngil_iit_ne_id    => pi_ngil_iit_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ngil_all');
--
END lock_ngil_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NGIL_UK constraint
--
FUNCTION lock_ngil_all (pi_ngil_ne_ne_id     nm_group_inv_link_all.ngil_ne_ne_id%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) RETURN ROWID IS
--
   CURSOR cs_ngil_all IS
   SELECT /*+ INDEX (ngil_all NGIL_UK) */ ROWID
    FROM  nm_group_inv_link_all ngil_all
   WHERE  ngil_all.ngil_ne_ne_id = pi_ngil_ne_ne_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngil_all');
--
   OPEN  cs_ngil_all;
   FETCH cs_ngil_all INTO l_retval;
   l_found := cs_ngil_all%FOUND;
   CLOSE cs_ngil_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_group_inv_link_all (NGIL_UK)'
                                              ||CHR(10)||'ngil_ne_ne_id => '||pi_ngil_ne_ne_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ngil_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_group_inv_link_all (NGIL_UK)'
                                              ||CHR(10)||'ngil_ne_ne_id => '||pi_ngil_ne_ne_id
                    );
--
END lock_ngil_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NGIL_UK constraint
--
PROCEDURE lock_ngil_all (pi_ngil_ne_ne_id     nm_group_inv_link_all.ngil_ne_ne_id%TYPE
                        ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                        ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                        ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                        ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngil_all');
--
   l_rowid := lock_ngil_all
                   (pi_ngil_ne_ne_id     => pi_ngil_ne_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ngil_all');
--
END lock_ngil_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NGR_PK constraint
--
FUNCTION lock_ngr (pi_ngr_parent_group_type nm_group_relations.ngr_parent_group_type%TYPE
                  ,pi_ngr_child_group_type  nm_group_relations.ngr_child_group_type%TYPE
                  ,pi_ngr_start_date        nm_group_relations.ngr_start_date%TYPE
                  ,pi_raise_not_found       BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode     PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode        PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_ngr IS
   SELECT /*+ INDEX (ngr NGR_PK) */ ROWID
    FROM  nm_group_relations ngr
   WHERE  ngr.ngr_parent_group_type = pi_ngr_parent_group_type
    AND   ngr.ngr_child_group_type  = pi_ngr_child_group_type
    AND   ngr.ngr_start_date        = pi_ngr_start_date
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngr');
--
   OPEN  cs_ngr;
   FETCH cs_ngr INTO l_retval;
   l_found := cs_ngr%FOUND;
   CLOSE cs_ngr;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_group_relations (NGR_PK)'
                                              ||CHR(10)||'ngr_parent_group_type => '||pi_ngr_parent_group_type
                                              ||CHR(10)||'ngr_child_group_type  => '||pi_ngr_child_group_type
                                              ||CHR(10)||'ngr_start_date        => '||pi_ngr_start_date
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ngr');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_group_relations (NGR_PK)'
                                              ||CHR(10)||'ngr_parent_group_type => '||pi_ngr_parent_group_type
                                              ||CHR(10)||'ngr_child_group_type  => '||pi_ngr_child_group_type
                                              ||CHR(10)||'ngr_start_date        => '||pi_ngr_start_date
                    );
--
END lock_ngr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NGR_PK constraint
--
PROCEDURE lock_ngr (pi_ngr_parent_group_type nm_group_relations.ngr_parent_group_type%TYPE
                   ,pi_ngr_child_group_type  nm_group_relations.ngr_child_group_type%TYPE
                   ,pi_ngr_start_date        nm_group_relations.ngr_start_date%TYPE
                   ,pi_raise_not_found       BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode     PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode        PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngr');
--
   l_rowid := lock_ngr
                   (pi_ngr_parent_group_type => pi_ngr_parent_group_type
                   ,pi_ngr_child_group_type  => pi_ngr_child_group_type
                   ,pi_ngr_start_date        => pi_ngr_start_date
                   ,pi_raise_not_found       => pi_raise_not_found
                   ,pi_not_found_sqlcode     => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ngr');
--
END lock_ngr;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NGR_PK constraint (without start date for Datetrack View)
--
FUNCTION lock_ngr (pi_ngr_parent_group_type nm_group_relations.ngr_parent_group_type%TYPE
                  ,pi_ngr_child_group_type  nm_group_relations.ngr_child_group_type%TYPE
                  ,pi_raise_not_found       BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode     PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode        PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_ngr IS
   SELECT /*+ INDEX (ngr NGR_PK) */ ROWID
    FROM  nm_group_relations ngr
   WHERE  ngr.ngr_parent_group_type = pi_ngr_parent_group_type
    AND   ngr.ngr_child_group_type  = pi_ngr_child_group_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngr');
--
   OPEN  cs_ngr;
   FETCH cs_ngr INTO l_retval;
   l_found := cs_ngr%FOUND;
   CLOSE cs_ngr;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_group_relations (NGR_PK)'
                                              ||CHR(10)||'ngr_parent_group_type => '||pi_ngr_parent_group_type
                                              ||CHR(10)||'ngr_child_group_type  => '||pi_ngr_child_group_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ngr');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_group_relations (NGR_PK)'
                                              ||CHR(10)||'ngr_parent_group_type => '||pi_ngr_parent_group_type
                                              ||CHR(10)||'ngr_child_group_type  => '||pi_ngr_child_group_type
                    );
--
END lock_ngr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NGR_PK constraint (without start date for Datetrack View)
--
PROCEDURE lock_ngr (pi_ngr_parent_group_type nm_group_relations.ngr_parent_group_type%TYPE
                   ,pi_ngr_child_group_type  nm_group_relations.ngr_child_group_type%TYPE
                   ,pi_raise_not_found       BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode     PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode        PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngr');
--
   l_rowid := lock_ngr
                   (pi_ngr_parent_group_type => pi_ngr_parent_group_type
                   ,pi_ngr_child_group_type  => pi_ngr_child_group_type
                   ,pi_raise_not_found       => pi_raise_not_found
                   ,pi_not_found_sqlcode     => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ngr');
--
END lock_ngr;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NGR_PK constraint
--
FUNCTION lock_ngr_all (pi_ngr_parent_group_type nm_group_relations_all.ngr_parent_group_type%TYPE
                      ,pi_ngr_child_group_type  nm_group_relations_all.ngr_child_group_type%TYPE
                      ,pi_ngr_start_date        nm_group_relations_all.ngr_start_date%TYPE
                      ,pi_raise_not_found       BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode     PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode        PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_ngr_all IS
   SELECT /*+ INDEX (ngr_all NGR_PK) */ ROWID
    FROM  nm_group_relations_all ngr_all
   WHERE  ngr_all.ngr_parent_group_type = pi_ngr_parent_group_type
    AND   ngr_all.ngr_child_group_type  = pi_ngr_child_group_type
    AND   ngr_all.ngr_start_date        = pi_ngr_start_date
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngr_all');
--
   OPEN  cs_ngr_all;
   FETCH cs_ngr_all INTO l_retval;
   l_found := cs_ngr_all%FOUND;
   CLOSE cs_ngr_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_group_relations_all (NGR_PK)'
                                              ||CHR(10)||'ngr_parent_group_type => '||pi_ngr_parent_group_type
                                              ||CHR(10)||'ngr_child_group_type  => '||pi_ngr_child_group_type
                                              ||CHR(10)||'ngr_start_date        => '||pi_ngr_start_date
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ngr_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_group_relations_all (NGR_PK)'
                                              ||CHR(10)||'ngr_parent_group_type => '||pi_ngr_parent_group_type
                                              ||CHR(10)||'ngr_child_group_type  => '||pi_ngr_child_group_type
                                              ||CHR(10)||'ngr_start_date        => '||pi_ngr_start_date
                    );
--
END lock_ngr_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NGR_PK constraint
--
PROCEDURE lock_ngr_all (pi_ngr_parent_group_type nm_group_relations_all.ngr_parent_group_type%TYPE
                       ,pi_ngr_child_group_type  nm_group_relations_all.ngr_child_group_type%TYPE
                       ,pi_ngr_start_date        nm_group_relations_all.ngr_start_date%TYPE
                       ,pi_raise_not_found       BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode     PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode        PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngr_all');
--
   l_rowid := lock_ngr_all
                   (pi_ngr_parent_group_type => pi_ngr_parent_group_type
                   ,pi_ngr_child_group_type  => pi_ngr_child_group_type
                   ,pi_ngr_start_date        => pi_ngr_start_date
                   ,pi_raise_not_found       => pi_raise_not_found
                   ,pi_not_found_sqlcode     => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ngr_all');
--
END lock_ngr_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NGT_PK constraint
--
FUNCTION lock_ngt (pi_ngt_group_type    nm_group_types.ngt_group_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_ngt IS
   SELECT /*+ INDEX (ngt NGT_PK) */ ROWID
    FROM  nm_group_types ngt
   WHERE  ngt.ngt_group_type = pi_ngt_group_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngt');
--
   OPEN  cs_ngt;
   FETCH cs_ngt INTO l_retval;
   l_found := cs_ngt%FOUND;
   CLOSE cs_ngt;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_group_types (NGT_PK)'
                                              ||CHR(10)||'ngt_group_type => '||pi_ngt_group_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ngt');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_group_types (NGT_PK)'
                                              ||CHR(10)||'ngt_group_type => '||pi_ngt_group_type
                    );
--
END lock_ngt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NGT_PK constraint
--
PROCEDURE lock_ngt (pi_ngt_group_type    nm_group_types.ngt_group_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngt');
--
   l_rowid := lock_ngt
                   (pi_ngt_group_type    => pi_ngt_group_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ngt');
--
END lock_ngt;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NGT_PK constraint
--
FUNCTION lock_ngt_all (pi_ngt_group_type    nm_group_types_all.ngt_group_type%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_ngt_all IS
   SELECT /*+ INDEX (ngt_all NGT_PK) */ ROWID
    FROM  nm_group_types_all ngt_all
   WHERE  ngt_all.ngt_group_type = pi_ngt_group_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngt_all');
--
   OPEN  cs_ngt_all;
   FETCH cs_ngt_all INTO l_retval;
   l_found := cs_ngt_all%FOUND;
   CLOSE cs_ngt_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_group_types_all (NGT_PK)'
                                              ||CHR(10)||'ngt_group_type => '||pi_ngt_group_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ngt_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_group_types_all (NGT_PK)'
                                              ||CHR(10)||'ngt_group_type => '||pi_ngt_group_type
                    );
--
END lock_ngt_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NGT_PK constraint
--
PROCEDURE lock_ngt_all (pi_ngt_group_type    nm_group_types_all.ngt_group_type%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ngt_all');
--
   l_rowid := lock_ngt_all
                   (pi_ngt_group_type    => pi_ngt_group_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ngt_all');
--
END lock_ngt_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using IAL_PK constraint
--
FUNCTION lock_ial (pi_ial_domain        nm_inv_attri_lookup.ial_domain%TYPE
                  ,pi_ial_value         nm_inv_attri_lookup.ial_value%TYPE
                  ,pi_ial_start_date    nm_inv_attri_lookup.ial_start_date%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_ial IS
   SELECT /*+ INDEX (ial IAL_PK) */ ROWID
    FROM  nm_inv_attri_lookup ial
   WHERE  ial.ial_domain     = pi_ial_domain
    AND   ial.ial_value      = pi_ial_value
    AND   ial.ial_start_date = pi_ial_start_date
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ial');
--
   OPEN  cs_ial;
   FETCH cs_ial INTO l_retval;
   l_found := cs_ial%FOUND;
   CLOSE cs_ial;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_attri_lookup (IAL_PK)'
                                              ||CHR(10)||'ial_domain     => '||pi_ial_domain
                                              ||CHR(10)||'ial_value      => '||pi_ial_value
                                              ||CHR(10)||'ial_start_date => '||pi_ial_start_date
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ial');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_attri_lookup (IAL_PK)'
                                              ||CHR(10)||'ial_domain     => '||pi_ial_domain
                                              ||CHR(10)||'ial_value      => '||pi_ial_value
                                              ||CHR(10)||'ial_start_date => '||pi_ial_start_date
                    );
--
END lock_ial;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using IAL_PK constraint
--
PROCEDURE lock_ial (pi_ial_domain        nm_inv_attri_lookup.ial_domain%TYPE
                   ,pi_ial_value         nm_inv_attri_lookup.ial_value%TYPE
                   ,pi_ial_start_date    nm_inv_attri_lookup.ial_start_date%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ial');
--
   l_rowid := lock_ial
                   (pi_ial_domain        => pi_ial_domain
                   ,pi_ial_value         => pi_ial_value
                   ,pi_ial_start_date    => pi_ial_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ial');
--
END lock_ial;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using IAL_PK constraint (without start date for Datetrack View)
--
FUNCTION lock_ial (pi_ial_domain        nm_inv_attri_lookup.ial_domain%TYPE
                  ,pi_ial_value         nm_inv_attri_lookup.ial_value%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_ial IS
   SELECT /*+ INDEX (ial IAL_PK) */ ROWID
    FROM  nm_inv_attri_lookup ial
   WHERE  ial.ial_domain = pi_ial_domain
    AND   ial.ial_value  = pi_ial_value
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ial');
--
   OPEN  cs_ial;
   FETCH cs_ial INTO l_retval;
   l_found := cs_ial%FOUND;
   CLOSE cs_ial;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_attri_lookup (IAL_PK)'
                                              ||CHR(10)||'ial_domain => '||pi_ial_domain
                                              ||CHR(10)||'ial_value  => '||pi_ial_value
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ial');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_attri_lookup (IAL_PK)'
                                              ||CHR(10)||'ial_domain => '||pi_ial_domain
                                              ||CHR(10)||'ial_value  => '||pi_ial_value
                    );
--
END lock_ial;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using IAL_PK constraint (without start date for Datetrack View)
--
PROCEDURE lock_ial (pi_ial_domain        nm_inv_attri_lookup.ial_domain%TYPE
                   ,pi_ial_value         nm_inv_attri_lookup.ial_value%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ial');
--
   l_rowid := lock_ial
                   (pi_ial_domain        => pi_ial_domain
                   ,pi_ial_value         => pi_ial_value
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ial');
--
END lock_ial;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using IAL_PK constraint
--
FUNCTION lock_ial_all (pi_ial_domain        nm_inv_attri_lookup_all.ial_domain%TYPE
                      ,pi_ial_value         nm_inv_attri_lookup_all.ial_value%TYPE
                      ,pi_ial_start_date    nm_inv_attri_lookup_all.ial_start_date%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_ial_all IS
   SELECT /*+ INDEX (ial_all IAL_PK) */ ROWID
    FROM  nm_inv_attri_lookup_all ial_all
   WHERE  ial_all.ial_domain     = pi_ial_domain
    AND   ial_all.ial_value      = pi_ial_value
    AND   ial_all.ial_start_date = pi_ial_start_date
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ial_all');
--
   OPEN  cs_ial_all;
   FETCH cs_ial_all INTO l_retval;
   l_found := cs_ial_all%FOUND;
   CLOSE cs_ial_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_attri_lookup_all (IAL_PK)'
                                              ||CHR(10)||'ial_domain     => '||pi_ial_domain
                                              ||CHR(10)||'ial_value      => '||pi_ial_value
                                              ||CHR(10)||'ial_start_date => '||pi_ial_start_date
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ial_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_attri_lookup_all (IAL_PK)'
                                              ||CHR(10)||'ial_domain     => '||pi_ial_domain
                                              ||CHR(10)||'ial_value      => '||pi_ial_value
                                              ||CHR(10)||'ial_start_date => '||pi_ial_start_date
                    );
--
END lock_ial_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using IAL_PK constraint
--
PROCEDURE lock_ial_all (pi_ial_domain        nm_inv_attri_lookup_all.ial_domain%TYPE
                       ,pi_ial_value         nm_inv_attri_lookup_all.ial_value%TYPE
                       ,pi_ial_start_date    nm_inv_attri_lookup_all.ial_start_date%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ial_all');
--
   l_rowid := lock_ial_all
                   (pi_ial_domain        => pi_ial_domain
                   ,pi_ial_value         => pi_ial_value
                   ,pi_ial_start_date    => pi_ial_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ial_all');
--
END lock_ial_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NIC_PK constraint
--
FUNCTION lock_nic (pi_nic_category      nm_inv_categories.nic_category%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nic IS
   SELECT /*+ INDEX (nic NIC_PK) */ ROWID
    FROM  nm_inv_categories nic
   WHERE  nic.nic_category = pi_nic_category
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nic');
--
   OPEN  cs_nic;
   FETCH cs_nic INTO l_retval;
   l_found := cs_nic%FOUND;
   CLOSE cs_nic;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_categories (NIC_PK)'
                                              ||CHR(10)||'nic_category => '||pi_nic_category
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nic');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_categories (NIC_PK)'
                                              ||CHR(10)||'nic_category => '||pi_nic_category
                    );
--
END lock_nic;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NIC_PK constraint
--
PROCEDURE lock_nic (pi_nic_category      nm_inv_categories.nic_category%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nic');
--
   l_rowid := lock_nic
                   (pi_nic_category      => pi_nic_category
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nic');
--
END lock_nic;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using ICM_PK constraint
--
FUNCTION lock_icm (pi_icm_nic_category  nm_inv_category_modules.icm_nic_category%TYPE
                  ,pi_icm_hmo_module    nm_inv_category_modules.icm_hmo_module%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_icm IS
   SELECT /*+ INDEX (icm ICM_PK) */ ROWID
    FROM  nm_inv_category_modules icm
   WHERE  icm.icm_nic_category = pi_icm_nic_category
    AND   icm.icm_hmo_module   = pi_icm_hmo_module
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_icm');
--
   OPEN  cs_icm;
   FETCH cs_icm INTO l_retval;
   l_found := cs_icm%FOUND;
   CLOSE cs_icm;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_category_modules (ICM_PK)'
                                              ||CHR(10)||'icm_nic_category => '||pi_icm_nic_category
                                              ||CHR(10)||'icm_hmo_module   => '||pi_icm_hmo_module
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_icm');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_category_modules (ICM_PK)'
                                              ||CHR(10)||'icm_nic_category => '||pi_icm_nic_category
                                              ||CHR(10)||'icm_hmo_module   => '||pi_icm_hmo_module
                    );
--
END lock_icm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using ICM_PK constraint
--
PROCEDURE lock_icm (pi_icm_nic_category  nm_inv_category_modules.icm_nic_category%TYPE
                   ,pi_icm_hmo_module    nm_inv_category_modules.icm_hmo_module%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_icm');
--
   l_rowid := lock_icm
                   (pi_icm_nic_category  => pi_icm_nic_category
                   ,pi_icm_hmo_module    => pi_icm_hmo_module
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_icm');
--
END lock_icm;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using ID_PK constraint
--
FUNCTION lock_id (pi_id_domain         nm_inv_domains.id_domain%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) RETURN ROWID IS
--
   CURSOR cs_id IS
   SELECT /*+ INDEX (id ID_PK) */ ROWID
    FROM  nm_inv_domains id
   WHERE  id.id_domain = pi_id_domain
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_id');
--
   OPEN  cs_id;
   FETCH cs_id INTO l_retval;
   l_found := cs_id%FOUND;
   CLOSE cs_id;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_domains (ID_PK)'
                                              ||CHR(10)||'id_domain => '||pi_id_domain
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_id');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_domains (ID_PK)'
                                              ||CHR(10)||'id_domain => '||pi_id_domain
                    );
--
END lock_id;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using ID_PK constraint
--
PROCEDURE lock_id (pi_id_domain         nm_inv_domains.id_domain%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_id');
--
   l_rowid := lock_id
                   (pi_id_domain         => pi_id_domain
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_id');
--
END lock_id;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using ID_PK constraint
--
FUNCTION lock_id_all (pi_id_domain         nm_inv_domains_all.id_domain%TYPE
                     ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                     ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                     ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                     ) RETURN ROWID IS
--
   CURSOR cs_id_all IS
   SELECT /*+ INDEX (id_all ID_PK) */ ROWID
    FROM  nm_inv_domains_all id_all
   WHERE  id_all.id_domain = pi_id_domain
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_id_all');
--
   OPEN  cs_id_all;
   FETCH cs_id_all INTO l_retval;
   l_found := cs_id_all%FOUND;
   CLOSE cs_id_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_domains_all (ID_PK)'
                                              ||CHR(10)||'id_domain => '||pi_id_domain
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_id_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_domains_all (ID_PK)'
                                              ||CHR(10)||'id_domain => '||pi_id_domain
                    );
--
END lock_id_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using ID_PK constraint
--
PROCEDURE lock_id_all (pi_id_domain         nm_inv_domains_all.id_domain%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_id_all');
--
   l_rowid := lock_id_all
                   (pi_id_domain         => pi_id_domain
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_id_all');
--
END lock_id_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using INV_ITEMS_ALL_PK constraint
--
FUNCTION lock_iit (pi_iit_ne_id         nm_inv_items.iit_ne_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_iit IS
   SELECT /*+ INDEX (iit INV_ITEMS_ALL_PK) */ ROWID
    FROM  nm_inv_items iit
   WHERE  iit.iit_ne_id = pi_iit_ne_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_iit');
--
   OPEN  cs_iit;
   FETCH cs_iit INTO l_retval;
   l_found := cs_iit%FOUND;
   CLOSE cs_iit;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_items (INV_ITEMS_ALL_PK)'
                                              ||CHR(10)||'iit_ne_id => '||pi_iit_ne_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_iit');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_items (INV_ITEMS_ALL_PK)'
                                              ||CHR(10)||'iit_ne_id => '||pi_iit_ne_id
                    );
--
END lock_iit;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using INV_ITEMS_ALL_PK constraint
--
PROCEDURE lock_iit (pi_iit_ne_id         nm_inv_items.iit_ne_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_iit');
--
   l_rowid := lock_iit
                   (pi_iit_ne_id         => pi_iit_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_iit');
--
END lock_iit;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using IIT_UK constraint
--
FUNCTION lock_iit (pi_iit_primary_key   nm_inv_items.iit_primary_key%TYPE
                  ,pi_iit_inv_type      nm_inv_items.iit_inv_type%TYPE
                  ,pi_iit_start_date    nm_inv_items.iit_start_date%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_iit IS
   SELECT /*+ INDEX (iit IIT_UK) */ ROWID
    FROM  nm_inv_items iit
   WHERE  iit.iit_primary_key = pi_iit_primary_key
    AND   iit.iit_inv_type    = pi_iit_inv_type
    AND   iit.iit_start_date  = pi_iit_start_date
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_iit');
--
   OPEN  cs_iit;
   FETCH cs_iit INTO l_retval;
   l_found := cs_iit%FOUND;
   CLOSE cs_iit;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_items (IIT_UK)'
                                              ||CHR(10)||'iit_primary_key => '||pi_iit_primary_key
                                              ||CHR(10)||'iit_inv_type    => '||pi_iit_inv_type
                                              ||CHR(10)||'iit_start_date  => '||pi_iit_start_date
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_iit');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_items (IIT_UK)'
                                              ||CHR(10)||'iit_primary_key => '||pi_iit_primary_key
                                              ||CHR(10)||'iit_inv_type    => '||pi_iit_inv_type
                                              ||CHR(10)||'iit_start_date  => '||pi_iit_start_date
                    );
--
END lock_iit;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using IIT_UK constraint
--
PROCEDURE lock_iit (pi_iit_primary_key   nm_inv_items.iit_primary_key%TYPE
                   ,pi_iit_inv_type      nm_inv_items.iit_inv_type%TYPE
                   ,pi_iit_start_date    nm_inv_items.iit_start_date%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_iit');
--
   l_rowid := lock_iit
                   (pi_iit_primary_key   => pi_iit_primary_key
                   ,pi_iit_inv_type      => pi_iit_inv_type
                   ,pi_iit_start_date    => pi_iit_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_iit');
--
END lock_iit;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using IIT_UK constraint (without start date for Datetrack View)
--
FUNCTION lock_iit (pi_iit_primary_key   nm_inv_items.iit_primary_key%TYPE
                  ,pi_iit_inv_type      nm_inv_items.iit_inv_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_iit IS
   SELECT /*+ INDEX (iit IIT_UK) */ ROWID
    FROM  nm_inv_items iit
   WHERE  iit.iit_primary_key = pi_iit_primary_key
    AND   iit.iit_inv_type    = pi_iit_inv_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_iit');
--
   OPEN  cs_iit;
   FETCH cs_iit INTO l_retval;
   l_found := cs_iit%FOUND;
   CLOSE cs_iit;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_items (IIT_UK)'
                                              ||CHR(10)||'iit_primary_key => '||pi_iit_primary_key
                                              ||CHR(10)||'iit_inv_type    => '||pi_iit_inv_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_iit');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_items (IIT_UK)'
                                              ||CHR(10)||'iit_primary_key => '||pi_iit_primary_key
                                              ||CHR(10)||'iit_inv_type    => '||pi_iit_inv_type
                    );
--
END lock_iit;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using IIT_UK constraint (without start date for Datetrack View)
--
PROCEDURE lock_iit (pi_iit_primary_key   nm_inv_items.iit_primary_key%TYPE
                   ,pi_iit_inv_type      nm_inv_items.iit_inv_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_iit');
--
   l_rowid := lock_iit
                   (pi_iit_primary_key   => pi_iit_primary_key
                   ,pi_iit_inv_type      => pi_iit_inv_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_iit');
--
END lock_iit;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using INV_ITEMS_ALL_PK constraint
--
FUNCTION lock_iit_all (pi_iit_ne_id         nm_inv_items_all.iit_ne_id%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_iit_all IS
   SELECT /*+ INDEX (iit_all INV_ITEMS_ALL_PK) */ ROWID
    FROM  nm_inv_items_all iit_all
   WHERE  iit_all.iit_ne_id = pi_iit_ne_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_iit_all');
--
   OPEN  cs_iit_all;
   FETCH cs_iit_all INTO l_retval;
   l_found := cs_iit_all%FOUND;
   CLOSE cs_iit_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_items_all (INV_ITEMS_ALL_PK)'
                                              ||CHR(10)||'iit_ne_id => '||pi_iit_ne_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_iit_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_items_all (INV_ITEMS_ALL_PK)'
                                              ||CHR(10)||'iit_ne_id => '||pi_iit_ne_id
                    );
--
END lock_iit_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using INV_ITEMS_ALL_PK constraint
--
PROCEDURE lock_iit_all (pi_iit_ne_id         nm_inv_items_all.iit_ne_id%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_iit_all');
--
   l_rowid := lock_iit_all
                   (pi_iit_ne_id         => pi_iit_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_iit_all');
--
END lock_iit_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using IIT_UK constraint
--
FUNCTION lock_iit_all (pi_iit_primary_key   nm_inv_items_all.iit_primary_key%TYPE
                      ,pi_iit_inv_type      nm_inv_items_all.iit_inv_type%TYPE
                      ,pi_iit_start_date    nm_inv_items_all.iit_start_date%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_iit_all IS
   SELECT /*+ INDEX (iit_all IIT_UK) */ ROWID
    FROM  nm_inv_items_all iit_all
   WHERE  iit_all.iit_primary_key = pi_iit_primary_key
    AND   iit_all.iit_inv_type    = pi_iit_inv_type
    AND   iit_all.iit_start_date  = pi_iit_start_date
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_iit_all');
--
   OPEN  cs_iit_all;
   FETCH cs_iit_all INTO l_retval;
   l_found := cs_iit_all%FOUND;
   CLOSE cs_iit_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_items_all (IIT_UK)'
                                              ||CHR(10)||'iit_primary_key => '||pi_iit_primary_key
                                              ||CHR(10)||'iit_inv_type    => '||pi_iit_inv_type
                                              ||CHR(10)||'iit_start_date  => '||pi_iit_start_date
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_iit_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_items_all (IIT_UK)'
                                              ||CHR(10)||'iit_primary_key => '||pi_iit_primary_key
                                              ||CHR(10)||'iit_inv_type    => '||pi_iit_inv_type
                                              ||CHR(10)||'iit_start_date  => '||pi_iit_start_date
                    );
--
END lock_iit_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using IIT_UK constraint
--
PROCEDURE lock_iit_all (pi_iit_primary_key   nm_inv_items_all.iit_primary_key%TYPE
                       ,pi_iit_inv_type      nm_inv_items_all.iit_inv_type%TYPE
                       ,pi_iit_start_date    nm_inv_items_all.iit_start_date%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_iit_all');
--
   l_rowid := lock_iit_all
                   (pi_iit_primary_key   => pi_iit_primary_key
                   ,pi_iit_inv_type      => pi_iit_inv_type
                   ,pi_iit_start_date    => pi_iit_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_iit_all');
--
END lock_iit_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using IIG_PK constraint
--
FUNCTION lock_iig (pi_iig_item_id       nm_inv_item_groupings.iig_item_id%TYPE
                  ,pi_iig_parent_id     nm_inv_item_groupings.iig_parent_id%TYPE
                  ,pi_iig_start_date    nm_inv_item_groupings.iig_start_date%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_iig IS
   SELECT /*+ INDEX (iig IIG_PK) */ ROWID
    FROM  nm_inv_item_groupings iig
   WHERE  iig.iig_item_id    = pi_iig_item_id
    AND   iig.iig_parent_id  = pi_iig_parent_id
    AND   iig.iig_start_date = pi_iig_start_date
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_iig');
--
   OPEN  cs_iig;
   FETCH cs_iig INTO l_retval;
   l_found := cs_iig%FOUND;
   CLOSE cs_iig;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_item_groupings (IIG_PK)'
                                              ||CHR(10)||'iig_item_id    => '||pi_iig_item_id
                                              ||CHR(10)||'iig_parent_id  => '||pi_iig_parent_id
                                              ||CHR(10)||'iig_start_date => '||pi_iig_start_date
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_iig');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_item_groupings (IIG_PK)'
                                              ||CHR(10)||'iig_item_id    => '||pi_iig_item_id
                                              ||CHR(10)||'iig_parent_id  => '||pi_iig_parent_id
                                              ||CHR(10)||'iig_start_date => '||pi_iig_start_date
                    );
--
END lock_iig;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using IIG_PK constraint
--
PROCEDURE lock_iig (pi_iig_item_id       nm_inv_item_groupings.iig_item_id%TYPE
                   ,pi_iig_parent_id     nm_inv_item_groupings.iig_parent_id%TYPE
                   ,pi_iig_start_date    nm_inv_item_groupings.iig_start_date%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_iig');
--
   l_rowid := lock_iig
                   (pi_iig_item_id       => pi_iig_item_id
                   ,pi_iig_parent_id     => pi_iig_parent_id
                   ,pi_iig_start_date    => pi_iig_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_iig');
--
END lock_iig;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using IIG_PK constraint (without start date for Datetrack View)
--
FUNCTION lock_iig (pi_iig_item_id       nm_inv_item_groupings.iig_item_id%TYPE
                  ,pi_iig_parent_id     nm_inv_item_groupings.iig_parent_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_iig IS
   SELECT /*+ INDEX (iig IIG_PK) */ ROWID
    FROM  nm_inv_item_groupings iig
   WHERE  iig.iig_item_id   = pi_iig_item_id
    AND   iig.iig_parent_id = pi_iig_parent_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_iig');
--
   OPEN  cs_iig;
   FETCH cs_iig INTO l_retval;
   l_found := cs_iig%FOUND;
   CLOSE cs_iig;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_item_groupings (IIG_PK)'
                                              ||CHR(10)||'iig_item_id   => '||pi_iig_item_id
                                              ||CHR(10)||'iig_parent_id => '||pi_iig_parent_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_iig');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_item_groupings (IIG_PK)'
                                              ||CHR(10)||'iig_item_id   => '||pi_iig_item_id
                                              ||CHR(10)||'iig_parent_id => '||pi_iig_parent_id
                    );
--
END lock_iig;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using IIG_PK constraint (without start date for Datetrack View)
--
PROCEDURE lock_iig (pi_iig_item_id       nm_inv_item_groupings.iig_item_id%TYPE
                   ,pi_iig_parent_id     nm_inv_item_groupings.iig_parent_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_iig');
--
   l_rowid := lock_iig
                   (pi_iig_item_id       => pi_iig_item_id
                   ,pi_iig_parent_id     => pi_iig_parent_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_iig');
--
END lock_iig;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using IIG_PK constraint
--
FUNCTION lock_iig_all (pi_iig_item_id       nm_inv_item_groupings_all.iig_item_id%TYPE
                      ,pi_iig_parent_id     nm_inv_item_groupings_all.iig_parent_id%TYPE
                      ,pi_iig_start_date    nm_inv_item_groupings_all.iig_start_date%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_iig_all IS
   SELECT /*+ INDEX (iig_all IIG_PK) */ ROWID
    FROM  nm_inv_item_groupings_all iig_all
   WHERE  iig_all.iig_item_id    = pi_iig_item_id
    AND   iig_all.iig_parent_id  = pi_iig_parent_id
    AND   iig_all.iig_start_date = pi_iig_start_date
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_iig_all');
--
   OPEN  cs_iig_all;
   FETCH cs_iig_all INTO l_retval;
   l_found := cs_iig_all%FOUND;
   CLOSE cs_iig_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_item_groupings_all (IIG_PK)'
                                              ||CHR(10)||'iig_item_id    => '||pi_iig_item_id
                                              ||CHR(10)||'iig_parent_id  => '||pi_iig_parent_id
                                              ||CHR(10)||'iig_start_date => '||pi_iig_start_date
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_iig_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_item_groupings_all (IIG_PK)'
                                              ||CHR(10)||'iig_item_id    => '||pi_iig_item_id
                                              ||CHR(10)||'iig_parent_id  => '||pi_iig_parent_id
                                              ||CHR(10)||'iig_start_date => '||pi_iig_start_date
                    );
--
END lock_iig_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using IIG_PK constraint
--
PROCEDURE lock_iig_all (pi_iig_item_id       nm_inv_item_groupings_all.iig_item_id%TYPE
                       ,pi_iig_parent_id     nm_inv_item_groupings_all.iig_parent_id%TYPE
                       ,pi_iig_start_date    nm_inv_item_groupings_all.iig_start_date%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_iig_all');
--
   l_rowid := lock_iig_all
                   (pi_iig_item_id       => pi_iig_item_id
                   ,pi_iig_parent_id     => pi_iig_parent_id
                   ,pi_iig_start_date    => pi_iig_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_iig_all');
--
END lock_iig_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NIN_PK constraint
--
FUNCTION lock_nin (pi_nin_nit_inv_code  nm_inv_nw.nin_nit_inv_code%TYPE
                  ,pi_nin_nw_type       nm_inv_nw.nin_nw_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nin IS
   SELECT /*+ INDEX (nin NIN_PK) */ ROWID
    FROM  nm_inv_nw nin
   WHERE  nin.nin_nit_inv_code = pi_nin_nit_inv_code
    AND   nin.nin_nw_type      = pi_nin_nw_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nin');
--
   OPEN  cs_nin;
   FETCH cs_nin INTO l_retval;
   l_found := cs_nin%FOUND;
   CLOSE cs_nin;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_nw (NIN_PK)'
                                              ||CHR(10)||'nin_nit_inv_code => '||pi_nin_nit_inv_code
                                              ||CHR(10)||'nin_nw_type      => '||pi_nin_nw_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nin');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_nw (NIN_PK)'
                                              ||CHR(10)||'nin_nit_inv_code => '||pi_nin_nit_inv_code
                                              ||CHR(10)||'nin_nw_type      => '||pi_nin_nw_type
                    );
--
END lock_nin;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NIN_PK constraint
--
PROCEDURE lock_nin (pi_nin_nit_inv_code  nm_inv_nw.nin_nit_inv_code%TYPE
                   ,pi_nin_nw_type       nm_inv_nw.nin_nw_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nin');
--
   l_rowid := lock_nin
                   (pi_nin_nit_inv_code  => pi_nin_nit_inv_code
                   ,pi_nin_nw_type       => pi_nin_nw_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nin');
--
END lock_nin;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NIN_PK constraint
--
FUNCTION lock_nin_all (pi_nin_nit_inv_code  nm_inv_nw_all.nin_nit_inv_code%TYPE
                      ,pi_nin_nw_type       nm_inv_nw_all.nin_nw_type%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_nin_all IS
   SELECT /*+ INDEX (nin_all NIN_PK) */ ROWID
    FROM  nm_inv_nw_all nin_all
   WHERE  nin_all.nin_nit_inv_code = pi_nin_nit_inv_code
    AND   nin_all.nin_nw_type      = pi_nin_nw_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nin_all');
--
   OPEN  cs_nin_all;
   FETCH cs_nin_all INTO l_retval;
   l_found := cs_nin_all%FOUND;
   CLOSE cs_nin_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_nw_all (NIN_PK)'
                                              ||CHR(10)||'nin_nit_inv_code => '||pi_nin_nit_inv_code
                                              ||CHR(10)||'nin_nw_type      => '||pi_nin_nw_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nin_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_nw_all (NIN_PK)'
                                              ||CHR(10)||'nin_nit_inv_code => '||pi_nin_nit_inv_code
                                              ||CHR(10)||'nin_nw_type      => '||pi_nin_nw_type
                    );
--
END lock_nin_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NIN_PK constraint
--
PROCEDURE lock_nin_all (pi_nin_nit_inv_code  nm_inv_nw_all.nin_nit_inv_code%TYPE
                       ,pi_nin_nw_type       nm_inv_nw_all.nin_nw_type%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nin_all');
--
   l_rowid := lock_nin_all
                   (pi_nin_nit_inv_code  => pi_nin_nit_inv_code
                   ,pi_nin_nw_type       => pi_nin_nw_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nin_all');
--
END lock_nin_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NITH_PK constraint
--
FUNCTION lock_nith (pi_nith_nth_theme_id nm_inv_themes.nith_nth_theme_id%TYPE
                   ,pi_nith_nit_id       nm_inv_themes.nith_nit_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nith IS
   SELECT /*+ INDEX (nith NITH_PK) */ ROWID
    FROM  nm_inv_themes nith
   WHERE  nith.nith_nth_theme_id = pi_nith_nth_theme_id
    AND   nith.nith_nit_id       = pi_nith_nit_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nith');
--
   OPEN  cs_nith;
   FETCH cs_nith INTO l_retval;
   l_found := cs_nith%FOUND;
   CLOSE cs_nith;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_themes (NITH_PK)'
                                              ||CHR(10)||'nith_nth_theme_id => '||pi_nith_nth_theme_id
                                              ||CHR(10)||'nith_nit_id       => '||pi_nith_nit_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nith');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_themes (NITH_PK)'
                                              ||CHR(10)||'nith_nth_theme_id => '||pi_nith_nth_theme_id
                                              ||CHR(10)||'nith_nit_id       => '||pi_nith_nit_id
                    );
--
END lock_nith;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NITH_PK constraint
--
PROCEDURE lock_nith (pi_nith_nth_theme_id nm_inv_themes.nith_nth_theme_id%TYPE
                    ,pi_nith_nit_id       nm_inv_themes.nith_nit_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nith');
--
   l_rowid := lock_nith
                   (pi_nith_nth_theme_id => pi_nith_nth_theme_id
                   ,pi_nith_nit_id       => pi_nith_nit_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nith');
--
END lock_nith;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using ITY_PK constraint
--
FUNCTION lock_nit (pi_nit_inv_type      nm_inv_types.nit_inv_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nit IS
   SELECT /*+ INDEX (nit ITY_PK) */ ROWID
    FROM  nm_inv_types nit
   WHERE  nit.nit_inv_type = pi_nit_inv_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nit');
--
   OPEN  cs_nit;
   FETCH cs_nit INTO l_retval;
   l_found := cs_nit%FOUND;
   CLOSE cs_nit;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_types (ITY_PK)'
                                              ||CHR(10)||'nit_inv_type => '||pi_nit_inv_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nit');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_types (ITY_PK)'
                                              ||CHR(10)||'nit_inv_type => '||pi_nit_inv_type
                    );
--
END lock_nit;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using ITY_PK constraint
--
PROCEDURE lock_nit (pi_nit_inv_type      nm_inv_types.nit_inv_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nit');
--
   l_rowid := lock_nit
                   (pi_nit_inv_type      => pi_nit_inv_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nit');
--
END lock_nit;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using ITY_PK constraint
--
FUNCTION lock_nit_all (pi_nit_inv_type      nm_inv_types_all.nit_inv_type%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_nit_all IS
   SELECT /*+ INDEX (nit_all ITY_PK) */ ROWID
    FROM  nm_inv_types_all nit_all
   WHERE  nit_all.nit_inv_type = pi_nit_inv_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nit_all');
--
   OPEN  cs_nit_all;
   FETCH cs_nit_all INTO l_retval;
   l_found := cs_nit_all%FOUND;
   CLOSE cs_nit_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_types_all (ITY_PK)'
                                              ||CHR(10)||'nit_inv_type => '||pi_nit_inv_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nit_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_types_all (ITY_PK)'
                                              ||CHR(10)||'nit_inv_type => '||pi_nit_inv_type
                    );
--
END lock_nit_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using ITY_PK constraint
--
PROCEDURE lock_nit_all (pi_nit_inv_type      nm_inv_types_all.nit_inv_type%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nit_all');
--
   l_rowid := lock_nit_all
                   (pi_nit_inv_type      => pi_nit_inv_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nit_all');
--
END lock_nit_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using ITA_PK constraint
--
FUNCTION lock_ita (pi_ita_inv_type      nm_inv_type_attribs.ita_inv_type%TYPE
                  ,pi_ita_attrib_name   nm_inv_type_attribs.ita_attrib_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_ita IS
   SELECT /*+ INDEX (ita ITA_PK) */ ROWID
    FROM  nm_inv_type_attribs ita
   WHERE  ita.ita_inv_type    = pi_ita_inv_type
    AND   ita.ita_attrib_name = pi_ita_attrib_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ita');
--
   OPEN  cs_ita;
   FETCH cs_ita INTO l_retval;
   l_found := cs_ita%FOUND;
   CLOSE cs_ita;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_attribs (ITA_PK)'
                                              ||CHR(10)||'ita_inv_type    => '||pi_ita_inv_type
                                              ||CHR(10)||'ita_attrib_name => '||pi_ita_attrib_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ita');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_attribs (ITA_PK)'
                                              ||CHR(10)||'ita_inv_type    => '||pi_ita_inv_type
                                              ||CHR(10)||'ita_attrib_name => '||pi_ita_attrib_name
                    );
--
END lock_ita;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using ITA_PK constraint
--
PROCEDURE lock_ita (pi_ita_inv_type      nm_inv_type_attribs.ita_inv_type%TYPE
                   ,pi_ita_attrib_name   nm_inv_type_attribs.ita_attrib_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ita');
--
   l_rowid := lock_ita
                   (pi_ita_inv_type      => pi_ita_inv_type
                   ,pi_ita_attrib_name   => pi_ita_attrib_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ita');
--
END lock_ita;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using ITA_UK_VIEW_COL constraint
--
FUNCTION lock_ita (pi_ita_inv_type      nm_inv_type_attribs.ita_inv_type%TYPE
                  ,pi_ita_view_col_name nm_inv_type_attribs.ita_view_col_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_ita IS
   SELECT /*+ INDEX (ita ITA_UK_VIEW_COL) */ ROWID
    FROM  nm_inv_type_attribs ita
   WHERE  ita.ita_inv_type      = pi_ita_inv_type
    AND   ita.ita_view_col_name = pi_ita_view_col_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ita');
--
   OPEN  cs_ita;
   FETCH cs_ita INTO l_retval;
   l_found := cs_ita%FOUND;
   CLOSE cs_ita;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_attribs (ITA_UK_VIEW_COL)'
                                              ||CHR(10)||'ita_inv_type      => '||pi_ita_inv_type
                                              ||CHR(10)||'ita_view_col_name => '||pi_ita_view_col_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ita');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_attribs (ITA_UK_VIEW_COL)'
                                              ||CHR(10)||'ita_inv_type      => '||pi_ita_inv_type
                                              ||CHR(10)||'ita_view_col_name => '||pi_ita_view_col_name
                    );
--
END lock_ita;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using ITA_UK_VIEW_COL constraint
--
PROCEDURE lock_ita (pi_ita_inv_type      nm_inv_type_attribs.ita_inv_type%TYPE
                   ,pi_ita_view_col_name nm_inv_type_attribs.ita_view_col_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ita');
--
   l_rowid := lock_ita
                   (pi_ita_inv_type      => pi_ita_inv_type
                   ,pi_ita_view_col_name => pi_ita_view_col_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ita');
--
END lock_ita;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using ITA_UK_VIEW_ATTRI constraint
--
FUNCTION lock_ita (pi_ita_inv_type      nm_inv_type_attribs.ita_inv_type%TYPE
                  ,pi_ita_view_attri    nm_inv_type_attribs.ita_view_attri%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_ita IS
   SELECT /*+ INDEX (ita ITA_UK_VIEW_ATTRI) */ ROWID
    FROM  nm_inv_type_attribs ita
   WHERE  ita.ita_inv_type   = pi_ita_inv_type
    AND   ita.ita_view_attri = pi_ita_view_attri
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ita');
--
   OPEN  cs_ita;
   FETCH cs_ita INTO l_retval;
   l_found := cs_ita%FOUND;
   CLOSE cs_ita;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_attribs (ITA_UK_VIEW_ATTRI)'
                                              ||CHR(10)||'ita_inv_type   => '||pi_ita_inv_type
                                              ||CHR(10)||'ita_view_attri => '||pi_ita_view_attri
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ita');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_attribs (ITA_UK_VIEW_ATTRI)'
                                              ||CHR(10)||'ita_inv_type   => '||pi_ita_inv_type
                                              ||CHR(10)||'ita_view_attri => '||pi_ita_view_attri
                    );
--
END lock_ita;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using ITA_UK_VIEW_ATTRI constraint
--
PROCEDURE lock_ita (pi_ita_inv_type      nm_inv_type_attribs.ita_inv_type%TYPE
                   ,pi_ita_view_attri    nm_inv_type_attribs.ita_view_attri%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ita');
--
   l_rowid := lock_ita
                   (pi_ita_inv_type      => pi_ita_inv_type
                   ,pi_ita_view_attri    => pi_ita_view_attri
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ita');
--
END lock_ita;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using ITA_PK constraint
--
FUNCTION lock_ita_all (pi_ita_inv_type      nm_inv_type_attribs_all.ita_inv_type%TYPE
                      ,pi_ita_attrib_name   nm_inv_type_attribs_all.ita_attrib_name%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_ita_all IS
   SELECT /*+ INDEX (ita_all ITA_PK) */ ROWID
    FROM  nm_inv_type_attribs_all ita_all
   WHERE  ita_all.ita_inv_type    = pi_ita_inv_type
    AND   ita_all.ita_attrib_name = pi_ita_attrib_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ita_all');
--
   OPEN  cs_ita_all;
   FETCH cs_ita_all INTO l_retval;
   l_found := cs_ita_all%FOUND;
   CLOSE cs_ita_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_attribs_all (ITA_PK)'
                                              ||CHR(10)||'ita_inv_type    => '||pi_ita_inv_type
                                              ||CHR(10)||'ita_attrib_name => '||pi_ita_attrib_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ita_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_attribs_all (ITA_PK)'
                                              ||CHR(10)||'ita_inv_type    => '||pi_ita_inv_type
                                              ||CHR(10)||'ita_attrib_name => '||pi_ita_attrib_name
                    );
--
END lock_ita_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using ITA_PK constraint
--
PROCEDURE lock_ita_all (pi_ita_inv_type      nm_inv_type_attribs_all.ita_inv_type%TYPE
                       ,pi_ita_attrib_name   nm_inv_type_attribs_all.ita_attrib_name%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ita_all');
--
   l_rowid := lock_ita_all
                   (pi_ita_inv_type      => pi_ita_inv_type
                   ,pi_ita_attrib_name   => pi_ita_attrib_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ita_all');
--
END lock_ita_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using ITA_UK_VIEW_COL constraint
--
FUNCTION lock_ita_all (pi_ita_inv_type      nm_inv_type_attribs_all.ita_inv_type%TYPE
                      ,pi_ita_view_col_name nm_inv_type_attribs_all.ita_view_col_name%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_ita_all IS
   SELECT /*+ INDEX (ita_all ITA_UK_VIEW_COL) */ ROWID
    FROM  nm_inv_type_attribs_all ita_all
   WHERE  ita_all.ita_inv_type      = pi_ita_inv_type
    AND   ita_all.ita_view_col_name = pi_ita_view_col_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ita_all');
--
   OPEN  cs_ita_all;
   FETCH cs_ita_all INTO l_retval;
   l_found := cs_ita_all%FOUND;
   CLOSE cs_ita_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_attribs_all (ITA_UK_VIEW_COL)'
                                              ||CHR(10)||'ita_inv_type      => '||pi_ita_inv_type
                                              ||CHR(10)||'ita_view_col_name => '||pi_ita_view_col_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ita_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_attribs_all (ITA_UK_VIEW_COL)'
                                              ||CHR(10)||'ita_inv_type      => '||pi_ita_inv_type
                                              ||CHR(10)||'ita_view_col_name => '||pi_ita_view_col_name
                    );
--
END lock_ita_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using ITA_UK_VIEW_COL constraint
--
PROCEDURE lock_ita_all (pi_ita_inv_type      nm_inv_type_attribs_all.ita_inv_type%TYPE
                       ,pi_ita_view_col_name nm_inv_type_attribs_all.ita_view_col_name%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ita_all');
--
   l_rowid := lock_ita_all
                   (pi_ita_inv_type      => pi_ita_inv_type
                   ,pi_ita_view_col_name => pi_ita_view_col_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ita_all');
--
END lock_ita_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using ITA_UK_VIEW_ATTRI constraint
--
FUNCTION lock_ita_all (pi_ita_inv_type      nm_inv_type_attribs_all.ita_inv_type%TYPE
                      ,pi_ita_view_attri    nm_inv_type_attribs_all.ita_view_attri%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_ita_all IS
   SELECT /*+ INDEX (ita_all ITA_UK_VIEW_ATTRI) */ ROWID
    FROM  nm_inv_type_attribs_all ita_all
   WHERE  ita_all.ita_inv_type   = pi_ita_inv_type
    AND   ita_all.ita_view_attri = pi_ita_view_attri
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ita_all');
--
   OPEN  cs_ita_all;
   FETCH cs_ita_all INTO l_retval;
   l_found := cs_ita_all%FOUND;
   CLOSE cs_ita_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_attribs_all (ITA_UK_VIEW_ATTRI)'
                                              ||CHR(10)||'ita_inv_type   => '||pi_ita_inv_type
                                              ||CHR(10)||'ita_view_attri => '||pi_ita_view_attri
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ita_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_attribs_all (ITA_UK_VIEW_ATTRI)'
                                              ||CHR(10)||'ita_inv_type   => '||pi_ita_inv_type
                                              ||CHR(10)||'ita_view_attri => '||pi_ita_view_attri
                    );
--
END lock_ita_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using ITA_UK_VIEW_ATTRI constraint
--
PROCEDURE lock_ita_all (pi_ita_inv_type      nm_inv_type_attribs_all.ita_inv_type%TYPE
                       ,pi_ita_view_attri    nm_inv_type_attribs_all.ita_view_attri%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ita_all');
--
   l_rowid := lock_ita_all
                   (pi_ita_inv_type      => pi_ita_inv_type
                   ,pi_ita_view_attri    => pi_ita_view_attri
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ita_all');
--
END lock_ita_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using ITB_PK constraint
--
FUNCTION lock_itb (pi_itb_inv_type      nm_inv_type_attrib_bandings.itb_inv_type%TYPE
                  ,pi_itb_attrib_name   nm_inv_type_attrib_bandings.itb_attrib_name%TYPE
                  ,pi_itb_banding_id    nm_inv_type_attrib_bandings.itb_banding_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_itb IS
   SELECT /*+ INDEX (itb ITB_PK) */ ROWID
    FROM  nm_inv_type_attrib_bandings itb
   WHERE  itb.itb_inv_type    = pi_itb_inv_type
    AND   itb.itb_attrib_name = pi_itb_attrib_name
    AND   itb.itb_banding_id  = pi_itb_banding_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_itb');
--
   OPEN  cs_itb;
   FETCH cs_itb INTO l_retval;
   l_found := cs_itb%FOUND;
   CLOSE cs_itb;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_attrib_bandings (ITB_PK)'
                                              ||CHR(10)||'itb_inv_type    => '||pi_itb_inv_type
                                              ||CHR(10)||'itb_attrib_name => '||pi_itb_attrib_name
                                              ||CHR(10)||'itb_banding_id  => '||pi_itb_banding_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_itb');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_attrib_bandings (ITB_PK)'
                                              ||CHR(10)||'itb_inv_type    => '||pi_itb_inv_type
                                              ||CHR(10)||'itb_attrib_name => '||pi_itb_attrib_name
                                              ||CHR(10)||'itb_banding_id  => '||pi_itb_banding_id
                    );
--
END lock_itb;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using ITB_PK constraint
--
PROCEDURE lock_itb (pi_itb_inv_type      nm_inv_type_attrib_bandings.itb_inv_type%TYPE
                   ,pi_itb_attrib_name   nm_inv_type_attrib_bandings.itb_attrib_name%TYPE
                   ,pi_itb_banding_id    nm_inv_type_attrib_bandings.itb_banding_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_itb');
--
   l_rowid := lock_itb
                   (pi_itb_inv_type      => pi_itb_inv_type
                   ,pi_itb_attrib_name   => pi_itb_attrib_name
                   ,pi_itb_banding_id    => pi_itb_banding_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_itb');
--
END lock_itb;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using ITB_UK constraint
--
FUNCTION lock_itb (pi_itb_banding_id    nm_inv_type_attrib_bandings.itb_banding_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_itb IS
   SELECT /*+ INDEX (itb ITB_UK) */ ROWID
    FROM  nm_inv_type_attrib_bandings itb
   WHERE  itb.itb_banding_id = pi_itb_banding_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_itb');
--
   OPEN  cs_itb;
   FETCH cs_itb INTO l_retval;
   l_found := cs_itb%FOUND;
   CLOSE cs_itb;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_attrib_bandings (ITB_UK)'
                                              ||CHR(10)||'itb_banding_id => '||pi_itb_banding_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_itb');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_attrib_bandings (ITB_UK)'
                                              ||CHR(10)||'itb_banding_id => '||pi_itb_banding_id
                    );
--
END lock_itb;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using ITB_UK constraint
--
PROCEDURE lock_itb (pi_itb_banding_id    nm_inv_type_attrib_bandings.itb_banding_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_itb');
--
   l_rowid := lock_itb
                   (pi_itb_banding_id    => pi_itb_banding_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_itb');
--
END lock_itb;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using ITD_PK constraint
--
FUNCTION lock_itd (pi_itd_band_seq       nm_inv_type_attrib_band_dets.itd_band_seq%TYPE
                  ,pi_itd_inv_type       nm_inv_type_attrib_band_dets.itd_inv_type%TYPE
                  ,pi_itd_attrib_name    nm_inv_type_attrib_band_dets.itd_attrib_name%TYPE
                  ,pi_itd_itb_banding_id nm_inv_type_attrib_band_dets.itd_itb_banding_id%TYPE
                  ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_itd IS
   SELECT /*+ INDEX (itd ITD_PK) */ ROWID
    FROM  nm_inv_type_attrib_band_dets itd
   WHERE  itd.itd_band_seq       = pi_itd_band_seq
    AND   itd.itd_inv_type       = pi_itd_inv_type
    AND   itd.itd_attrib_name    = pi_itd_attrib_name
    AND   itd.itd_itb_banding_id = pi_itd_itb_banding_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_itd');
--
   OPEN  cs_itd;
   FETCH cs_itd INTO l_retval;
   l_found := cs_itd%FOUND;
   CLOSE cs_itd;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_attrib_band_dets (ITD_PK)'
                                              ||CHR(10)||'itd_band_seq       => '||pi_itd_band_seq
                                              ||CHR(10)||'itd_inv_type       => '||pi_itd_inv_type
                                              ||CHR(10)||'itd_attrib_name    => '||pi_itd_attrib_name
                                              ||CHR(10)||'itd_itb_banding_id => '||pi_itd_itb_banding_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_itd');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_attrib_band_dets (ITD_PK)'
                                              ||CHR(10)||'itd_band_seq       => '||pi_itd_band_seq
                                              ||CHR(10)||'itd_inv_type       => '||pi_itd_inv_type
                                              ||CHR(10)||'itd_attrib_name    => '||pi_itd_attrib_name
                                              ||CHR(10)||'itd_itb_banding_id => '||pi_itd_itb_banding_id
                    );
--
END lock_itd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using ITD_PK constraint
--
PROCEDURE lock_itd (pi_itd_band_seq       nm_inv_type_attrib_band_dets.itd_band_seq%TYPE
                   ,pi_itd_inv_type       nm_inv_type_attrib_band_dets.itd_inv_type%TYPE
                   ,pi_itd_attrib_name    nm_inv_type_attrib_band_dets.itd_attrib_name%TYPE
                   ,pi_itd_itb_banding_id nm_inv_type_attrib_band_dets.itd_itb_banding_id%TYPE
                   ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_itd');
--
   l_rowid := lock_itd
                   (pi_itd_band_seq       => pi_itd_band_seq
                   ,pi_itd_inv_type       => pi_itd_inv_type
                   ,pi_itd_attrib_name    => pi_itd_attrib_name
                   ,pi_itd_itb_banding_id => pi_itd_itb_banding_id
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_itd');
--
END lock_itd;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NIAS_PK constraint
--
FUNCTION lock_nias (pi_nias_id           nm_inv_attribute_sets.nias_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nias IS
   SELECT /*+ INDEX (nias NIAS_PK) */ ROWID
    FROM  nm_inv_attribute_sets nias
   WHERE  nias.nias_id = pi_nias_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nias');
--
   OPEN  cs_nias;
   FETCH cs_nias INTO l_retval;
   l_found := cs_nias%FOUND;
   CLOSE cs_nias;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_attribute_sets (NIAS_PK)'
                                              ||CHR(10)||'nias_id => '||pi_nias_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nias');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_attribute_sets (NIAS_PK)'
                                              ||CHR(10)||'nias_id => '||pi_nias_id
                    );
--
END lock_nias;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NIAS_PK constraint
--
PROCEDURE lock_nias (pi_nias_id           nm_inv_attribute_sets.nias_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nias');
--
   l_rowid := lock_nias
                   (pi_nias_id           => pi_nias_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nias');
--
END lock_nias;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NSIT_PK constraint
--
FUNCTION lock_nsit (pi_nsit_nias_id      nm_inv_attribute_set_inv_types.nsit_nias_id%TYPE
                   ,pi_nsit_nit_inv_type nm_inv_attribute_set_inv_types.nsit_nit_inv_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nsit IS
   SELECT /*+ INDEX (nsit NSIT_PK) */ ROWID
    FROM  nm_inv_attribute_set_inv_types nsit
   WHERE  nsit.nsit_nias_id      = pi_nsit_nias_id
    AND   nsit.nsit_nit_inv_type = pi_nsit_nit_inv_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsit');
--
   OPEN  cs_nsit;
   FETCH cs_nsit INTO l_retval;
   l_found := cs_nsit%FOUND;
   CLOSE cs_nsit;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_attribute_set_inv_types (NSIT_PK)'
                                              ||CHR(10)||'nsit_nias_id      => '||pi_nsit_nias_id
                                              ||CHR(10)||'nsit_nit_inv_type => '||pi_nsit_nit_inv_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nsit');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_attribute_set_inv_types (NSIT_PK)'
                                              ||CHR(10)||'nsit_nias_id      => '||pi_nsit_nias_id
                                              ||CHR(10)||'nsit_nit_inv_type => '||pi_nsit_nit_inv_type
                    );
--
END lock_nsit;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NSIT_PK constraint
--
PROCEDURE lock_nsit (pi_nsit_nias_id      nm_inv_attribute_set_inv_types.nsit_nias_id%TYPE
                    ,pi_nsit_nit_inv_type nm_inv_attribute_set_inv_types.nsit_nit_inv_type%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsit');
--
   l_rowid := lock_nsit
                   (pi_nsit_nias_id      => pi_nsit_nias_id
                   ,pi_nsit_nit_inv_type => pi_nsit_nit_inv_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nsit');
--
END lock_nsit;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NSIA_PK constraint
--
FUNCTION lock_nsia (pi_nsia_nsit_nit_inv_type nm_inv_attribute_set_inv_attr.nsia_nsit_nit_inv_type%TYPE
                   ,pi_nsia_ita_attrib_name   nm_inv_attribute_set_inv_attr.nsia_ita_attrib_name%TYPE
                   ,pi_nsia_nsit_nias_id      nm_inv_attribute_set_inv_attr.nsia_nsit_nias_id%TYPE
                   ,pi_raise_not_found        BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode      PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode         PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nsia IS
   SELECT /*+ INDEX (nsia NSIA_PK) */ ROWID
    FROM  nm_inv_attribute_set_inv_attr nsia
   WHERE  nsia.nsia_nsit_nit_inv_type = pi_nsia_nsit_nit_inv_type
    AND   nsia.nsia_ita_attrib_name   = pi_nsia_ita_attrib_name
    AND   nsia.nsia_nsit_nias_id      = pi_nsia_nsit_nias_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsia');
--
   OPEN  cs_nsia;
   FETCH cs_nsia INTO l_retval;
   l_found := cs_nsia%FOUND;
   CLOSE cs_nsia;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_attribute_set_inv_attr (NSIA_PK)'
                                              ||CHR(10)||'nsia_nsit_nit_inv_type => '||pi_nsia_nsit_nit_inv_type
                                              ||CHR(10)||'nsia_ita_attrib_name   => '||pi_nsia_ita_attrib_name
                                              ||CHR(10)||'nsia_nsit_nias_id      => '||pi_nsia_nsit_nias_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nsia');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_attribute_set_inv_attr (NSIA_PK)'
                                              ||CHR(10)||'nsia_nsit_nit_inv_type => '||pi_nsia_nsit_nit_inv_type
                                              ||CHR(10)||'nsia_ita_attrib_name   => '||pi_nsia_ita_attrib_name
                                              ||CHR(10)||'nsia_nsit_nias_id      => '||pi_nsia_nsit_nias_id
                    );
--
END lock_nsia;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NSIA_PK constraint
--
PROCEDURE lock_nsia (pi_nsia_nsit_nit_inv_type nm_inv_attribute_set_inv_attr.nsia_nsit_nit_inv_type%TYPE
                    ,pi_nsia_ita_attrib_name   nm_inv_attribute_set_inv_attr.nsia_ita_attrib_name%TYPE
                    ,pi_nsia_nsit_nias_id      nm_inv_attribute_set_inv_attr.nsia_nsit_nias_id%TYPE
                    ,pi_raise_not_found        BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode      PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode         PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsia');
--
   l_rowid := lock_nsia
                   (pi_nsia_nsit_nit_inv_type => pi_nsia_nsit_nit_inv_type
                   ,pi_nsia_ita_attrib_name   => pi_nsia_ita_attrib_name
                   ,pi_nsia_nsit_nias_id      => pi_nsia_nsit_nias_id
                   ,pi_raise_not_found        => pi_raise_not_found
                   ,pi_not_found_sqlcode      => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nsia');
--
END lock_nsia;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NM_INV_TYPE_COLOURS_PK constraint
--
FUNCTION lock_nitc (pi_col_id            nm_inv_type_colours.col_id%TYPE
                   ,pi_ity_inv_code      nm_inv_type_colours.ity_inv_code%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nitc IS
   SELECT /*+ INDEX (nitc NM_INV_TYPE_COLOURS_PK) */ ROWID
    FROM  nm_inv_type_colours nitc
   WHERE  nitc.col_id       = pi_col_id
    AND   nitc.ity_inv_code = pi_ity_inv_code
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nitc');
--
   OPEN  cs_nitc;
   FETCH cs_nitc INTO l_retval;
   l_found := cs_nitc%FOUND;
   CLOSE cs_nitc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_colours (NM_INV_TYPE_COLOURS_PK)'
                                              ||CHR(10)||'col_id       => '||pi_col_id
                                              ||CHR(10)||'ity_inv_code => '||pi_ity_inv_code
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nitc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_colours (NM_INV_TYPE_COLOURS_PK)'
                                              ||CHR(10)||'col_id       => '||pi_col_id
                                              ||CHR(10)||'ity_inv_code => '||pi_ity_inv_code
                    );
--
END lock_nitc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NM_INV_TYPE_COLOURS_PK constraint
--
PROCEDURE lock_nitc (pi_col_id            nm_inv_type_colours.col_id%TYPE
                    ,pi_ity_inv_code      nm_inv_type_colours.ity_inv_code%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nitc');
--
   l_rowid := lock_nitc
                   (pi_col_id            => pi_col_id
                   ,pi_ity_inv_code      => pi_ity_inv_code
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nitc');
--
END lock_nitc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using ITG_PK constraint
--
FUNCTION lock_itg (pi_itg_inv_type        nm_inv_type_groupings.itg_inv_type%TYPE
                  ,pi_itg_parent_inv_type nm_inv_type_groupings.itg_parent_inv_type%TYPE
                  ,pi_itg_start_date      nm_inv_type_groupings.itg_start_date%TYPE
                  ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_itg IS
   SELECT /*+ INDEX (itg ITG_PK) */ ROWID
    FROM  nm_inv_type_groupings itg
   WHERE  itg.itg_inv_type        = pi_itg_inv_type
    AND   itg.itg_parent_inv_type = pi_itg_parent_inv_type
    AND   itg.itg_start_date      = pi_itg_start_date
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_itg');
--
   OPEN  cs_itg;
   FETCH cs_itg INTO l_retval;
   l_found := cs_itg%FOUND;
   CLOSE cs_itg;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_groupings (ITG_PK)'
                                              ||CHR(10)||'itg_inv_type        => '||pi_itg_inv_type
                                              ||CHR(10)||'itg_parent_inv_type => '||pi_itg_parent_inv_type
                                              ||CHR(10)||'itg_start_date      => '||pi_itg_start_date
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_itg');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_groupings (ITG_PK)'
                                              ||CHR(10)||'itg_inv_type        => '||pi_itg_inv_type
                                              ||CHR(10)||'itg_parent_inv_type => '||pi_itg_parent_inv_type
                                              ||CHR(10)||'itg_start_date      => '||pi_itg_start_date
                    );
--
END lock_itg;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using ITG_PK constraint
--
PROCEDURE lock_itg (pi_itg_inv_type        nm_inv_type_groupings.itg_inv_type%TYPE
                   ,pi_itg_parent_inv_type nm_inv_type_groupings.itg_parent_inv_type%TYPE
                   ,pi_itg_start_date      nm_inv_type_groupings.itg_start_date%TYPE
                   ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_itg');
--
   l_rowid := lock_itg
                   (pi_itg_inv_type        => pi_itg_inv_type
                   ,pi_itg_parent_inv_type => pi_itg_parent_inv_type
                   ,pi_itg_start_date      => pi_itg_start_date
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_itg');
--
END lock_itg;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using ITG_PK constraint (without start date for Datetrack View)
--
FUNCTION lock_itg (pi_itg_inv_type        nm_inv_type_groupings.itg_inv_type%TYPE
                  ,pi_itg_parent_inv_type nm_inv_type_groupings.itg_parent_inv_type%TYPE
                  ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_itg IS
   SELECT /*+ INDEX (itg ITG_PK) */ ROWID
    FROM  nm_inv_type_groupings itg
   WHERE  itg.itg_inv_type        = pi_itg_inv_type
    AND   itg.itg_parent_inv_type = pi_itg_parent_inv_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_itg');
--
   OPEN  cs_itg;
   FETCH cs_itg INTO l_retval;
   l_found := cs_itg%FOUND;
   CLOSE cs_itg;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_groupings (ITG_PK)'
                                              ||CHR(10)||'itg_inv_type        => '||pi_itg_inv_type
                                              ||CHR(10)||'itg_parent_inv_type => '||pi_itg_parent_inv_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_itg');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_groupings (ITG_PK)'
                                              ||CHR(10)||'itg_inv_type        => '||pi_itg_inv_type
                                              ||CHR(10)||'itg_parent_inv_type => '||pi_itg_parent_inv_type
                    );
--
END lock_itg;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using ITG_PK constraint (without start date for Datetrack View)
--
PROCEDURE lock_itg (pi_itg_inv_type        nm_inv_type_groupings.itg_inv_type%TYPE
                   ,pi_itg_parent_inv_type nm_inv_type_groupings.itg_parent_inv_type%TYPE
                   ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_itg');
--
   l_rowid := lock_itg
                   (pi_itg_inv_type        => pi_itg_inv_type
                   ,pi_itg_parent_inv_type => pi_itg_parent_inv_type
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_itg');
--
END lock_itg;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using ITG_PK constraint
--
FUNCTION lock_itg_all (pi_itg_inv_type        nm_inv_type_groupings_all.itg_inv_type%TYPE
                      ,pi_itg_parent_inv_type nm_inv_type_groupings_all.itg_parent_inv_type%TYPE
                      ,pi_itg_start_date      nm_inv_type_groupings_all.itg_start_date%TYPE
                      ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_itg_all IS
   SELECT /*+ INDEX (itg_all ITG_PK) */ ROWID
    FROM  nm_inv_type_groupings_all itg_all
   WHERE  itg_all.itg_inv_type        = pi_itg_inv_type
    AND   itg_all.itg_parent_inv_type = pi_itg_parent_inv_type
    AND   itg_all.itg_start_date      = pi_itg_start_date
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_itg_all');
--
   OPEN  cs_itg_all;
   FETCH cs_itg_all INTO l_retval;
   l_found := cs_itg_all%FOUND;
   CLOSE cs_itg_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_groupings_all (ITG_PK)'
                                              ||CHR(10)||'itg_inv_type        => '||pi_itg_inv_type
                                              ||CHR(10)||'itg_parent_inv_type => '||pi_itg_parent_inv_type
                                              ||CHR(10)||'itg_start_date      => '||pi_itg_start_date
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_itg_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_groupings_all (ITG_PK)'
                                              ||CHR(10)||'itg_inv_type        => '||pi_itg_inv_type
                                              ||CHR(10)||'itg_parent_inv_type => '||pi_itg_parent_inv_type
                                              ||CHR(10)||'itg_start_date      => '||pi_itg_start_date
                    );
--
END lock_itg_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using ITG_PK constraint
--
PROCEDURE lock_itg_all (pi_itg_inv_type        nm_inv_type_groupings_all.itg_inv_type%TYPE
                       ,pi_itg_parent_inv_type nm_inv_type_groupings_all.itg_parent_inv_type%TYPE
                       ,pi_itg_start_date      nm_inv_type_groupings_all.itg_start_date%TYPE
                       ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_itg_all');
--
   l_rowid := lock_itg_all
                   (pi_itg_inv_type        => pi_itg_inv_type
                   ,pi_itg_parent_inv_type => pi_itg_parent_inv_type
                   ,pi_itg_start_date      => pi_itg_start_date
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_itg_all');
--
END lock_itg_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using ITR_PK constraint
--
FUNCTION lock_itr (pi_itr_inv_type      nm_inv_type_roles.itr_inv_type%TYPE
                  ,pi_itr_hro_role      nm_inv_type_roles.itr_hro_role%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_itr IS
   SELECT /*+ INDEX (itr ITR_PK) */ ROWID
    FROM  nm_inv_type_roles itr
   WHERE  itr.itr_inv_type = pi_itr_inv_type
    AND   itr.itr_hro_role = pi_itr_hro_role
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_itr');
--
   OPEN  cs_itr;
   FETCH cs_itr INTO l_retval;
   l_found := cs_itr%FOUND;
   CLOSE cs_itr;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_roles (ITR_PK)'
                                              ||CHR(10)||'itr_inv_type => '||pi_itr_inv_type
                                              ||CHR(10)||'itr_hro_role => '||pi_itr_hro_role
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_itr');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_inv_type_roles (ITR_PK)'
                                              ||CHR(10)||'itr_inv_type => '||pi_itr_inv_type
                                              ||CHR(10)||'itr_hro_role => '||pi_itr_hro_role
                    );
--
END lock_itr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using ITR_PK constraint
--
PROCEDURE lock_itr (pi_itr_inv_type      nm_inv_type_roles.itr_inv_type%TYPE
                   ,pi_itr_hro_role      nm_inv_type_roles.itr_hro_role%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_itr');
--
   l_rowid := lock_itr
                   (pi_itr_inv_type      => pi_itr_inv_type
                   ,pi_itr_hro_role      => pi_itr_hro_role
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_itr');
--
END lock_itr;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NJC_PK constraint
--
FUNCTION lock_njc (pi_njc_job_id        nm_job_control.njc_job_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_njc IS
   SELECT /*+ INDEX (njc NJC_PK) */ ROWID
    FROM  nm_job_control njc
   WHERE  njc.njc_job_id = pi_njc_job_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_njc');
--
   OPEN  cs_njc;
   FETCH cs_njc INTO l_retval;
   l_found := cs_njc%FOUND;
   CLOSE cs_njc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_job_control (NJC_PK)'
                                              ||CHR(10)||'njc_job_id => '||pi_njc_job_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_njc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_job_control (NJC_PK)'
                                              ||CHR(10)||'njc_job_id => '||pi_njc_job_id
                    );
--
END lock_njc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NJC_PK constraint
--
PROCEDURE lock_njc (pi_njc_job_id        nm_job_control.njc_job_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_njc');
--
   l_rowid := lock_njc
                   (pi_njc_job_id        => pi_njc_job_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_njc');
--
END lock_njc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NM_JOB_CONTROL_UK constraint
--
FUNCTION lock_njc (pi_njc_unique        nm_job_control.njc_unique%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_njc IS
   SELECT /*+ INDEX (njc NM_JOB_CONTROL_UK) */ ROWID
    FROM  nm_job_control njc
   WHERE  njc.njc_unique = pi_njc_unique
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_njc');
--
   OPEN  cs_njc;
   FETCH cs_njc INTO l_retval;
   l_found := cs_njc%FOUND;
   CLOSE cs_njc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_job_control (NM_JOB_CONTROL_UK)'
                                              ||CHR(10)||'njc_unique => '||pi_njc_unique
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_njc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_job_control (NM_JOB_CONTROL_UK)'
                                              ||CHR(10)||'njc_unique => '||pi_njc_unique
                    );
--
END lock_njc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NM_JOB_CONTROL_UK constraint
--
PROCEDURE lock_njc (pi_njc_unique        nm_job_control.njc_unique%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_njc');
--
   l_rowid := lock_njc
                   (pi_njc_unique        => pi_njc_unique
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_njc');
--
END lock_njc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NJO_PK constraint
--
FUNCTION lock_njo (pi_njo_njc_job_id    nm_job_operations.njo_njc_job_id%TYPE
                  ,pi_njo_id            nm_job_operations.njo_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_njo IS
   SELECT /*+ INDEX (njo NJO_PK) */ ROWID
    FROM  nm_job_operations njo
   WHERE  njo.njo_njc_job_id = pi_njo_njc_job_id
    AND   njo.njo_id         = pi_njo_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_njo');
--
   OPEN  cs_njo;
   FETCH cs_njo INTO l_retval;
   l_found := cs_njo%FOUND;
   CLOSE cs_njo;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_job_operations (NJO_PK)'
                                              ||CHR(10)||'njo_njc_job_id => '||pi_njo_njc_job_id
                                              ||CHR(10)||'njo_id         => '||pi_njo_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_njo');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_job_operations (NJO_PK)'
                                              ||CHR(10)||'njo_njc_job_id => '||pi_njo_njc_job_id
                                              ||CHR(10)||'njo_id         => '||pi_njo_id
                    );
--
END lock_njo;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NJO_PK constraint
--
PROCEDURE lock_njo (pi_njo_njc_job_id    nm_job_operations.njo_njc_job_id%TYPE
                   ,pi_njo_id            nm_job_operations.njo_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_njo');
--
   l_rowid := lock_njo
                   (pi_njo_njc_job_id    => pi_njo_njc_job_id
                   ,pi_njo_id            => pi_njo_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_njo');
--
END lock_njo;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NJO_UK constraint
--
FUNCTION lock_njo (pi_njo_njc_job_id    nm_job_operations.njo_njc_job_id%TYPE
                  ,pi_njo_seq           nm_job_operations.njo_seq%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_njo IS
   SELECT /*+ INDEX (njo NJO_UK) */ ROWID
    FROM  nm_job_operations njo
   WHERE  njo.njo_njc_job_id = pi_njo_njc_job_id
    AND   njo.njo_seq        = pi_njo_seq
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_njo');
--
   OPEN  cs_njo;
   FETCH cs_njo INTO l_retval;
   l_found := cs_njo%FOUND;
   CLOSE cs_njo;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_job_operations (NJO_UK)'
                                              ||CHR(10)||'njo_njc_job_id => '||pi_njo_njc_job_id
                                              ||CHR(10)||'njo_seq        => '||pi_njo_seq
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_njo');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_job_operations (NJO_UK)'
                                              ||CHR(10)||'njo_njc_job_id => '||pi_njo_njc_job_id
                                              ||CHR(10)||'njo_seq        => '||pi_njo_seq
                    );
--
END lock_njo;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NJO_UK constraint
--
PROCEDURE lock_njo (pi_njo_njc_job_id    nm_job_operations.njo_njc_job_id%TYPE
                   ,pi_njo_seq           nm_job_operations.njo_seq%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_njo');
--
   l_rowid := lock_njo
                   (pi_njo_njc_job_id    => pi_njo_njc_job_id
                   ,pi_njo_seq           => pi_njo_seq
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_njo');
--
END lock_njo;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NJV_PK constraint
--
FUNCTION lock_njv (pi_njv_njc_job_id    nm_job_operation_data_values.njv_njc_job_id%TYPE
                  ,pi_njv_njo_id        nm_job_operation_data_values.njv_njo_id%TYPE
                  ,pi_njv_nod_data_item nm_job_operation_data_values.njv_nod_data_item%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_njv IS
   SELECT /*+ INDEX (njv NJV_PK) */ ROWID
    FROM  nm_job_operation_data_values njv
   WHERE  njv.njv_njc_job_id    = pi_njv_njc_job_id
    AND   njv.njv_njo_id        = pi_njv_njo_id
    AND   njv.njv_nod_data_item = pi_njv_nod_data_item
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_njv');
--
   OPEN  cs_njv;
   FETCH cs_njv INTO l_retval;
   l_found := cs_njv%FOUND;
   CLOSE cs_njv;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_job_operation_data_values (NJV_PK)'
                                              ||CHR(10)||'njv_njc_job_id    => '||pi_njv_njc_job_id
                                              ||CHR(10)||'njv_njo_id        => '||pi_njv_njo_id
                                              ||CHR(10)||'njv_nod_data_item => '||pi_njv_nod_data_item
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_njv');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_job_operation_data_values (NJV_PK)'
                                              ||CHR(10)||'njv_njc_job_id    => '||pi_njv_njc_job_id
                                              ||CHR(10)||'njv_njo_id        => '||pi_njv_njo_id
                                              ||CHR(10)||'njv_nod_data_item => '||pi_njv_nod_data_item
                    );
--
END lock_njv;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NJV_PK constraint
--
PROCEDURE lock_njv (pi_njv_njc_job_id    nm_job_operation_data_values.njv_njc_job_id%TYPE
                   ,pi_njv_njo_id        nm_job_operation_data_values.njv_njo_id%TYPE
                   ,pi_njv_nod_data_item nm_job_operation_data_values.njv_nod_data_item%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_njv');
--
   l_rowid := lock_njv
                   (pi_njv_njc_job_id    => pi_njv_njc_job_id
                   ,pi_njv_njo_id        => pi_njv_njo_id
                   ,pi_njv_nod_data_item => pi_njv_nod_data_item
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_njv');
--
END lock_njv;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NJT_PK constraint
--
FUNCTION lock_njt (pi_njt_type          nm_job_types.njt_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_njt IS
   SELECT /*+ INDEX (njt NJT_PK) */ ROWID
    FROM  nm_job_types njt
   WHERE  njt.njt_type = pi_njt_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_njt');
--
   OPEN  cs_njt;
   FETCH cs_njt INTO l_retval;
   l_found := cs_njt%FOUND;
   CLOSE cs_njt;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_job_types (NJT_PK)'
                                              ||CHR(10)||'njt_type => '||pi_njt_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_njt');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_job_types (NJT_PK)'
                                              ||CHR(10)||'njt_type => '||pi_njt_type
                    );
--
END lock_njt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NJT_PK constraint
--
PROCEDURE lock_njt (pi_njt_type          nm_job_types.njt_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_njt');
--
   l_rowid := lock_njt
                   (pi_njt_type          => pi_njt_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_njt');
--
END lock_njt;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using JTO_PK constraint
--
FUNCTION lock_jto (pi_jto_nmo_operation nm_job_types_operations.jto_nmo_operation%TYPE
                  ,pi_jto_njt_type      nm_job_types_operations.jto_njt_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_jto IS
   SELECT /*+ INDEX (jto JTO_PK) */ ROWID
    FROM  nm_job_types_operations jto
   WHERE  jto.jto_nmo_operation = pi_jto_nmo_operation
    AND   jto.jto_njt_type      = pi_jto_njt_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_jto');
--
   OPEN  cs_jto;
   FETCH cs_jto INTO l_retval;
   l_found := cs_jto%FOUND;
   CLOSE cs_jto;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_job_types_operations (JTO_PK)'
                                              ||CHR(10)||'jto_nmo_operation => '||pi_jto_nmo_operation
                                              ||CHR(10)||'jto_njt_type      => '||pi_jto_njt_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_jto');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_job_types_operations (JTO_PK)'
                                              ||CHR(10)||'jto_nmo_operation => '||pi_jto_nmo_operation
                                              ||CHR(10)||'jto_njt_type      => '||pi_jto_njt_type
                    );
--
END lock_jto;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using JTO_PK constraint
--
PROCEDURE lock_jto (pi_jto_nmo_operation nm_job_types_operations.jto_nmo_operation%TYPE
                   ,pi_jto_njt_type      nm_job_types_operations.jto_njt_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_jto');
--
   l_rowid := lock_jto
                   (pi_jto_nmo_operation => pi_jto_nmo_operation
                   ,pi_jto_njt_type      => pi_jto_njt_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_jto');
--
END lock_jto;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NM_LD_MC_ALL_INV_TMP_PK constraint
--
FUNCTION lock_nlm (pi_batch_no          nm_ld_mc_all_inv_tmp.batch_no%TYPE
                  ,pi_record_no         nm_ld_mc_all_inv_tmp.record_no%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nlm IS
   SELECT /*+ INDEX (nlm NM_LD_MC_ALL_INV_TMP_PK) */ ROWID
    FROM  nm_ld_mc_all_inv_tmp nlm
   WHERE  nlm.batch_no  = pi_batch_no
    AND   nlm.record_no = pi_record_no
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlm');
--
   OPEN  cs_nlm;
   FETCH cs_nlm INTO l_retval;
   l_found := cs_nlm%FOUND;
   CLOSE cs_nlm;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_ld_mc_all_inv_tmp (NM_LD_MC_ALL_INV_TMP_PK)'
                                              ||CHR(10)||'batch_no  => '||pi_batch_no
                                              ||CHR(10)||'record_no => '||pi_record_no
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nlm');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_ld_mc_all_inv_tmp (NM_LD_MC_ALL_INV_TMP_PK)'
                                              ||CHR(10)||'batch_no  => '||pi_batch_no
                                              ||CHR(10)||'record_no => '||pi_record_no
                    );
--
END lock_nlm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NM_LD_MC_ALL_INV_TMP_PK constraint
--
PROCEDURE lock_nlm (pi_batch_no          nm_ld_mc_all_inv_tmp.batch_no%TYPE
                   ,pi_record_no         nm_ld_mc_all_inv_tmp.record_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlm');
--
   l_rowid := lock_nlm
                   (pi_batch_no          => pi_batch_no
                   ,pi_record_no         => pi_record_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nlm');
--
END lock_nlm;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NLT_PK constraint
--
FUNCTION lock_nlt (pi_nlt_id            nm_linear_types.nlt_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nlt IS
   SELECT /*+ INDEX (nlt NLT_PK) */ ROWID
    FROM  nm_linear_types nlt
   WHERE  nlt.nlt_id = pi_nlt_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlt');
--
   OPEN  cs_nlt;
   FETCH cs_nlt INTO l_retval;
   l_found := cs_nlt%FOUND;
   CLOSE cs_nlt;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_linear_types (NLT_PK)'
                                              ||CHR(10)||'nlt_id => '||pi_nlt_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nlt');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_linear_types (NLT_PK)'
                                              ||CHR(10)||'nlt_id => '||pi_nlt_id
                    );
--
END lock_nlt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NLT_PK constraint
--
PROCEDURE lock_nlt (pi_nlt_id            nm_linear_types.nlt_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlt');
--
   l_rowid := lock_nlt
                   (pi_nlt_id            => pi_nlt_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nlt');
--
END lock_nlt;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NLT_UK constraint
--
FUNCTION lock_nlt (pi_nlt_nt_type       nm_linear_types.nlt_nt_type%TYPE
                  ,pi_nlt_gty_type      nm_linear_types.nlt_gty_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nlt IS
   SELECT /*+ INDEX (nlt NLT_UK) */ ROWID
    FROM  nm_linear_types nlt
   WHERE  nlt.nlt_nt_type  = pi_nlt_nt_type
    AND   nlt.nlt_gty_type = pi_nlt_gty_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlt');
--
   OPEN  cs_nlt;
   FETCH cs_nlt INTO l_retval;
   l_found := cs_nlt%FOUND;
   CLOSE cs_nlt;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_linear_types (NLT_UK)'
                                              ||CHR(10)||'nlt_nt_type  => '||pi_nlt_nt_type
                                              ||CHR(10)||'nlt_gty_type => '||pi_nlt_gty_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nlt');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_linear_types (NLT_UK)'
                                              ||CHR(10)||'nlt_nt_type  => '||pi_nlt_nt_type
                                              ||CHR(10)||'nlt_gty_type => '||pi_nlt_gty_type
                    );
--
END lock_nlt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NLT_UK constraint
--
PROCEDURE lock_nlt (pi_nlt_nt_type       nm_linear_types.nlt_nt_type%TYPE
                   ,pi_nlt_gty_type      nm_linear_types.nlt_gty_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlt');
--
   l_rowid := lock_nlt
                   (pi_nlt_nt_type       => pi_nlt_nt_type
                   ,pi_nlt_gty_type      => pi_nlt_gty_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nlt');
--
END lock_nlt;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NLB_PK constraint
--
FUNCTION lock_nlb (pi_nlb_batch_no      nm_load_batches.nlb_batch_no%TYPE
                  ,pi_nlb_filename      nm_load_batches.nlb_filename%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nlb IS
   SELECT /*+ INDEX (nlb NLB_PK) */ ROWID
    FROM  nm_load_batches nlb
   WHERE  nlb.nlb_batch_no = pi_nlb_batch_no
    AND   nlb.nlb_filename = pi_nlb_filename
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlb');
--
   OPEN  cs_nlb;
   FETCH cs_nlb INTO l_retval;
   l_found := cs_nlb%FOUND;
   CLOSE cs_nlb;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_load_batches (NLB_PK)'
                                              ||CHR(10)||'nlb_batch_no => '||pi_nlb_batch_no
                                              ||CHR(10)||'nlb_filename => '||pi_nlb_filename
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nlb');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_load_batches (NLB_PK)'
                                              ||CHR(10)||'nlb_batch_no => '||pi_nlb_batch_no
                                              ||CHR(10)||'nlb_filename => '||pi_nlb_filename
                    );
--
END lock_nlb;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NLB_PK constraint
--
PROCEDURE lock_nlb (pi_nlb_batch_no      nm_load_batches.nlb_batch_no%TYPE
                   ,pi_nlb_filename      nm_load_batches.nlb_filename%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlb');
--
   l_rowid := lock_nlb
                   (pi_nlb_batch_no      => pi_nlb_batch_no
                   ,pi_nlb_filename      => pi_nlb_filename
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nlb');
--
END lock_nlb;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NLBS_PK constraint
--
FUNCTION lock_nlbs (pi_nlbs_nlb_batch_no nm_load_batch_status.nlbs_nlb_batch_no%TYPE
                   ,pi_nlbs_record_no    nm_load_batch_status.nlbs_record_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nlbs IS
   SELECT /*+ INDEX (nlbs NLBS_PK) */ ROWID
    FROM  nm_load_batch_status nlbs
   WHERE  nlbs.nlbs_nlb_batch_no = pi_nlbs_nlb_batch_no
    AND   nlbs.nlbs_record_no    = pi_nlbs_record_no
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlbs');
--
   OPEN  cs_nlbs;
   FETCH cs_nlbs INTO l_retval;
   l_found := cs_nlbs%FOUND;
   CLOSE cs_nlbs;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_load_batch_status (NLBS_PK)'
                                              ||CHR(10)||'nlbs_nlb_batch_no => '||pi_nlbs_nlb_batch_no
                                              ||CHR(10)||'nlbs_record_no    => '||pi_nlbs_record_no
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nlbs');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_load_batch_status (NLBS_PK)'
                                              ||CHR(10)||'nlbs_nlb_batch_no => '||pi_nlbs_nlb_batch_no
                                              ||CHR(10)||'nlbs_record_no    => '||pi_nlbs_record_no
                    );
--
END lock_nlbs;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NLBS_PK constraint
--
PROCEDURE lock_nlbs (pi_nlbs_nlb_batch_no nm_load_batch_status.nlbs_nlb_batch_no%TYPE
                    ,pi_nlbs_record_no    nm_load_batch_status.nlbs_record_no%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlbs');
--
   l_rowid := lock_nlbs
                   (pi_nlbs_nlb_batch_no => pi_nlbs_nlb_batch_no
                   ,pi_nlbs_record_no    => pi_nlbs_record_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nlbs');
--
END lock_nlbs;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NLD_PK constraint
--
FUNCTION lock_nld (pi_nld_id            nm_load_destinations.nld_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nld IS
   SELECT /*+ INDEX (nld NLD_PK) */ ROWID
    FROM  nm_load_destinations nld
   WHERE  nld.nld_id = pi_nld_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nld');
--
   OPEN  cs_nld;
   FETCH cs_nld INTO l_retval;
   l_found := cs_nld%FOUND;
   CLOSE cs_nld;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_load_destinations (NLD_PK)'
                                              ||CHR(10)||'nld_id => '||pi_nld_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nld');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_load_destinations (NLD_PK)'
                                              ||CHR(10)||'nld_id => '||pi_nld_id
                    );
--
END lock_nld;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NLD_PK constraint
--
PROCEDURE lock_nld (pi_nld_id            nm_load_destinations.nld_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nld');
--
   l_rowid := lock_nld
                   (pi_nld_id            => pi_nld_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nld');
--
END lock_nld;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NLD_UK2 constraint
--
FUNCTION lock_nld (pi_nld_table_short_name nm_load_destinations.nld_table_short_name%TYPE
                  ,pi_raise_not_found      BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode    PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode       PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nld IS
   SELECT /*+ INDEX (nld NLD_UK2) */ ROWID
    FROM  nm_load_destinations nld
   WHERE  nld.nld_table_short_name = pi_nld_table_short_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nld');
--
   OPEN  cs_nld;
   FETCH cs_nld INTO l_retval;
   l_found := cs_nld%FOUND;
   CLOSE cs_nld;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_load_destinations (NLD_UK2)'
                                              ||CHR(10)||'nld_table_short_name => '||pi_nld_table_short_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nld');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_load_destinations (NLD_UK2)'
                                              ||CHR(10)||'nld_table_short_name => '||pi_nld_table_short_name
                    );
--
END lock_nld;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NLD_UK2 constraint
--
PROCEDURE lock_nld (pi_nld_table_short_name nm_load_destinations.nld_table_short_name%TYPE
                   ,pi_raise_not_found      BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode    PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode       PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nld');
--
   l_rowid := lock_nld
                   (pi_nld_table_short_name => pi_nld_table_short_name
                   ,pi_raise_not_found      => pi_raise_not_found
                   ,pi_not_found_sqlcode    => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nld');
--
END lock_nld;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NLD_UK1 constraint
--
FUNCTION lock_nld (pi_nld_table_name    nm_load_destinations.nld_table_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nld IS
   SELECT /*+ INDEX (nld NLD_UK1) */ ROWID
    FROM  nm_load_destinations nld
   WHERE  nld.nld_table_name = pi_nld_table_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nld');
--
   OPEN  cs_nld;
   FETCH cs_nld INTO l_retval;
   l_found := cs_nld%FOUND;
   CLOSE cs_nld;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_load_destinations (NLD_UK1)'
                                              ||CHR(10)||'nld_table_name => '||pi_nld_table_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nld');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_load_destinations (NLD_UK1)'
                                              ||CHR(10)||'nld_table_name => '||pi_nld_table_name
                    );
--
END lock_nld;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NLD_UK1 constraint
--
PROCEDURE lock_nld (pi_nld_table_name    nm_load_destinations.nld_table_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nld');
--
   l_rowid := lock_nld
                   (pi_nld_table_name    => pi_nld_table_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nld');
--
END lock_nld;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NLDD_PK constraint
--
FUNCTION lock_nldd (pi_nldd_nld_id       nm_load_destination_defaults.nldd_nld_id%TYPE
                   ,pi_nldd_column_name  nm_load_destination_defaults.nldd_column_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nldd IS
   SELECT /*+ INDEX (nldd NLDD_PK) */ ROWID
    FROM  nm_load_destination_defaults nldd
   WHERE  nldd.nldd_nld_id      = pi_nldd_nld_id
    AND   nldd.nldd_column_name = pi_nldd_column_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nldd');
--
   OPEN  cs_nldd;
   FETCH cs_nldd INTO l_retval;
   l_found := cs_nldd%FOUND;
   CLOSE cs_nldd;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_load_destination_defaults (NLDD_PK)'
                                              ||CHR(10)||'nldd_nld_id      => '||pi_nldd_nld_id
                                              ||CHR(10)||'nldd_column_name => '||pi_nldd_column_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nldd');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_load_destination_defaults (NLDD_PK)'
                                              ||CHR(10)||'nldd_nld_id      => '||pi_nldd_nld_id
                                              ||CHR(10)||'nldd_column_name => '||pi_nldd_column_name
                    );
--
END lock_nldd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NLDD_PK constraint
--
PROCEDURE lock_nldd (pi_nldd_nld_id       nm_load_destination_defaults.nldd_nld_id%TYPE
                    ,pi_nldd_column_name  nm_load_destination_defaults.nldd_column_name%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nldd');
--
   l_rowid := lock_nldd
                   (pi_nldd_nld_id       => pi_nldd_nld_id
                   ,pi_nldd_column_name  => pi_nldd_column_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nldd');
--
END lock_nldd;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NLF_PK constraint
--
FUNCTION lock_nlf (pi_nlf_id            nm_load_files.nlf_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nlf IS
   SELECT /*+ INDEX (nlf NLF_PK) */ ROWID
    FROM  nm_load_files nlf
   WHERE  nlf.nlf_id = pi_nlf_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlf');
--
   OPEN  cs_nlf;
   FETCH cs_nlf INTO l_retval;
   l_found := cs_nlf%FOUND;
   CLOSE cs_nlf;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_load_files (NLF_PK)'
                                              ||CHR(10)||'nlf_id => '||pi_nlf_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nlf');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_load_files (NLF_PK)'
                                              ||CHR(10)||'nlf_id => '||pi_nlf_id
                    );
--
END lock_nlf;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NLF_PK constraint
--
PROCEDURE lock_nlf (pi_nlf_id            nm_load_files.nlf_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlf');
--
   l_rowid := lock_nlf
                   (pi_nlf_id            => pi_nlf_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nlf');
--
END lock_nlf;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NLF_UK constraint
--
FUNCTION lock_nlf (pi_nlf_unique        nm_load_files.nlf_unique%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nlf IS
   SELECT /*+ INDEX (nlf NLF_UK) */ ROWID
    FROM  nm_load_files nlf
   WHERE  nlf.nlf_unique = pi_nlf_unique
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlf');
--
   OPEN  cs_nlf;
   FETCH cs_nlf INTO l_retval;
   l_found := cs_nlf%FOUND;
   CLOSE cs_nlf;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_load_files (NLF_UK)'
                                              ||CHR(10)||'nlf_unique => '||pi_nlf_unique
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nlf');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_load_files (NLF_UK)'
                                              ||CHR(10)||'nlf_unique => '||pi_nlf_unique
                    );
--
END lock_nlf;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NLF_UK constraint
--
PROCEDURE lock_nlf (pi_nlf_unique        nm_load_files.nlf_unique%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlf');
--
   l_rowid := lock_nlf
                   (pi_nlf_unique        => pi_nlf_unique
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nlf');
--
END lock_nlf;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NLFC_PK constraint
--
FUNCTION lock_nlfc (pi_nlfc_nlf_id       nm_load_file_cols.nlfc_nlf_id%TYPE
                   ,pi_nlfc_seq_no       nm_load_file_cols.nlfc_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nlfc IS
   SELECT /*+ INDEX (nlfc NLFC_PK) */ ROWID
    FROM  nm_load_file_cols nlfc
   WHERE  nlfc.nlfc_nlf_id = pi_nlfc_nlf_id
    AND   nlfc.nlfc_seq_no = pi_nlfc_seq_no
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlfc');
--
   OPEN  cs_nlfc;
   FETCH cs_nlfc INTO l_retval;
   l_found := cs_nlfc%FOUND;
   CLOSE cs_nlfc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_load_file_cols (NLFC_PK)'
                                              ||CHR(10)||'nlfc_nlf_id => '||pi_nlfc_nlf_id
                                              ||CHR(10)||'nlfc_seq_no => '||pi_nlfc_seq_no
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nlfc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_load_file_cols (NLFC_PK)'
                                              ||CHR(10)||'nlfc_nlf_id => '||pi_nlfc_nlf_id
                                              ||CHR(10)||'nlfc_seq_no => '||pi_nlfc_seq_no
                    );
--
END lock_nlfc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NLFC_PK constraint
--
PROCEDURE lock_nlfc (pi_nlfc_nlf_id       nm_load_file_cols.nlfc_nlf_id%TYPE
                    ,pi_nlfc_seq_no       nm_load_file_cols.nlfc_seq_no%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlfc');
--
   l_rowid := lock_nlfc
                   (pi_nlfc_nlf_id       => pi_nlfc_nlf_id
                   ,pi_nlfc_seq_no       => pi_nlfc_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nlfc');
--
END lock_nlfc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NLFC_UK constraint
--
FUNCTION lock_nlfc (pi_nlfc_nlf_id       nm_load_file_cols.nlfc_nlf_id%TYPE
                   ,pi_nlfc_holding_col  nm_load_file_cols.nlfc_holding_col%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nlfc IS
   SELECT /*+ INDEX (nlfc NLFC_UK) */ ROWID
    FROM  nm_load_file_cols nlfc
   WHERE  nlfc.nlfc_nlf_id      = pi_nlfc_nlf_id
    AND   nlfc.nlfc_holding_col = pi_nlfc_holding_col
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlfc');
--
   OPEN  cs_nlfc;
   FETCH cs_nlfc INTO l_retval;
   l_found := cs_nlfc%FOUND;
   CLOSE cs_nlfc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_load_file_cols (NLFC_UK)'
                                              ||CHR(10)||'nlfc_nlf_id      => '||pi_nlfc_nlf_id
                                              ||CHR(10)||'nlfc_holding_col => '||pi_nlfc_holding_col
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nlfc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_load_file_cols (NLFC_UK)'
                                              ||CHR(10)||'nlfc_nlf_id      => '||pi_nlfc_nlf_id
                                              ||CHR(10)||'nlfc_holding_col => '||pi_nlfc_holding_col
                    );
--
END lock_nlfc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NLFC_UK constraint
--
PROCEDURE lock_nlfc (pi_nlfc_nlf_id       nm_load_file_cols.nlfc_nlf_id%TYPE
                    ,pi_nlfc_holding_col  nm_load_file_cols.nlfc_holding_col%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlfc');
--
   l_rowid := lock_nlfc
                   (pi_nlfc_nlf_id       => pi_nlfc_nlf_id
                   ,pi_nlfc_holding_col  => pi_nlfc_holding_col
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nlfc');
--
END lock_nlfc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NLCD_PK constraint
--
FUNCTION lock_nlcd (pi_nlcd_nlf_id       nm_load_file_col_destinations.nlcd_nlf_id%TYPE
                   ,pi_nlcd_nld_id       nm_load_file_col_destinations.nlcd_nld_id%TYPE
                   ,pi_nlcd_seq_no       nm_load_file_col_destinations.nlcd_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nlcd IS
   SELECT /*+ INDEX (nlcd NLCD_PK) */ ROWID
    FROM  nm_load_file_col_destinations nlcd
   WHERE  nlcd.nlcd_nlf_id = pi_nlcd_nlf_id
    AND   nlcd.nlcd_nld_id = pi_nlcd_nld_id
    AND   nlcd.nlcd_seq_no = pi_nlcd_seq_no
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlcd');
--
   OPEN  cs_nlcd;
   FETCH cs_nlcd INTO l_retval;
   l_found := cs_nlcd%FOUND;
   CLOSE cs_nlcd;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_load_file_col_destinations (NLCD_PK)'
                                              ||CHR(10)||'nlcd_nlf_id => '||pi_nlcd_nlf_id
                                              ||CHR(10)||'nlcd_nld_id => '||pi_nlcd_nld_id
                                              ||CHR(10)||'nlcd_seq_no => '||pi_nlcd_seq_no
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nlcd');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_load_file_col_destinations (NLCD_PK)'
                                              ||CHR(10)||'nlcd_nlf_id => '||pi_nlcd_nlf_id
                                              ||CHR(10)||'nlcd_nld_id => '||pi_nlcd_nld_id
                                              ||CHR(10)||'nlcd_seq_no => '||pi_nlcd_seq_no
                    );
--
END lock_nlcd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NLCD_PK constraint
--
PROCEDURE lock_nlcd (pi_nlcd_nlf_id       nm_load_file_col_destinations.nlcd_nlf_id%TYPE
                    ,pi_nlcd_nld_id       nm_load_file_col_destinations.nlcd_nld_id%TYPE
                    ,pi_nlcd_seq_no       nm_load_file_col_destinations.nlcd_seq_no%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlcd');
--
   l_rowid := lock_nlcd
                   (pi_nlcd_nlf_id       => pi_nlcd_nlf_id
                   ,pi_nlcd_nld_id       => pi_nlcd_nld_id
                   ,pi_nlcd_seq_no       => pi_nlcd_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nlcd');
--
END lock_nlcd;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NLCD_UK constraint
--
FUNCTION lock_nlcd (pi_nlcd_nlf_id       nm_load_file_col_destinations.nlcd_nlf_id%TYPE
                   ,pi_nlcd_nld_id       nm_load_file_col_destinations.nlcd_nld_id%TYPE
                   ,pi_nlcd_dest_col     nm_load_file_col_destinations.nlcd_dest_col%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nlcd IS
   SELECT /*+ INDEX (nlcd NLCD_UK) */ ROWID
    FROM  nm_load_file_col_destinations nlcd
   WHERE  nlcd.nlcd_nlf_id   = pi_nlcd_nlf_id
    AND   nlcd.nlcd_nld_id   = pi_nlcd_nld_id
    AND   nlcd.nlcd_dest_col = pi_nlcd_dest_col
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlcd');
--
   OPEN  cs_nlcd;
   FETCH cs_nlcd INTO l_retval;
   l_found := cs_nlcd%FOUND;
   CLOSE cs_nlcd;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_load_file_col_destinations (NLCD_UK)'
                                              ||CHR(10)||'nlcd_nlf_id   => '||pi_nlcd_nlf_id
                                              ||CHR(10)||'nlcd_nld_id   => '||pi_nlcd_nld_id
                                              ||CHR(10)||'nlcd_dest_col => '||pi_nlcd_dest_col
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nlcd');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_load_file_col_destinations (NLCD_UK)'
                                              ||CHR(10)||'nlcd_nlf_id   => '||pi_nlcd_nlf_id
                                              ||CHR(10)||'nlcd_nld_id   => '||pi_nlcd_nld_id
                                              ||CHR(10)||'nlcd_dest_col => '||pi_nlcd_dest_col
                    );
--
END lock_nlcd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NLCD_UK constraint
--
PROCEDURE lock_nlcd (pi_nlcd_nlf_id       nm_load_file_col_destinations.nlcd_nlf_id%TYPE
                    ,pi_nlcd_nld_id       nm_load_file_col_destinations.nlcd_nld_id%TYPE
                    ,pi_nlcd_dest_col     nm_load_file_col_destinations.nlcd_dest_col%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlcd');
--
   l_rowid := lock_nlcd
                   (pi_nlcd_nlf_id       => pi_nlcd_nlf_id
                   ,pi_nlcd_nld_id       => pi_nlcd_nld_id
                   ,pi_nlcd_dest_col     => pi_nlcd_dest_col
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nlcd');
--
END lock_nlcd;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NLFD_PK constraint
--
FUNCTION lock_nlfd (pi_nlfd_nlf_id       nm_load_file_destinations.nlfd_nlf_id%TYPE
                   ,pi_nlfd_nld_id       nm_load_file_destinations.nlfd_nld_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nlfd IS
   SELECT /*+ INDEX (nlfd NLFD_PK) */ ROWID
    FROM  nm_load_file_destinations nlfd
   WHERE  nlfd.nlfd_nlf_id = pi_nlfd_nlf_id
    AND   nlfd.nlfd_nld_id = pi_nlfd_nld_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlfd');
--
   OPEN  cs_nlfd;
   FETCH cs_nlfd INTO l_retval;
   l_found := cs_nlfd%FOUND;
   CLOSE cs_nlfd;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_load_file_destinations (NLFD_PK)'
                                              ||CHR(10)||'nlfd_nlf_id => '||pi_nlfd_nlf_id
                                              ||CHR(10)||'nlfd_nld_id => '||pi_nlfd_nld_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nlfd');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_load_file_destinations (NLFD_PK)'
                                              ||CHR(10)||'nlfd_nlf_id => '||pi_nlfd_nlf_id
                                              ||CHR(10)||'nlfd_nld_id => '||pi_nlfd_nld_id
                    );
--
END lock_nlfd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NLFD_PK constraint
--
PROCEDURE lock_nlfd (pi_nlfd_nlf_id       nm_load_file_destinations.nlfd_nlf_id%TYPE
                    ,pi_nlfd_nld_id       nm_load_file_destinations.nlfd_nld_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlfd');
--
   l_rowid := lock_nlfd
                   (pi_nlfd_nlf_id       => pi_nlfd_nlf_id
                   ,pi_nlfd_nld_id       => pi_nlfd_nld_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nlfd');
--
END lock_nlfd;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NLFD_UK constraint
--
FUNCTION lock_nlfd (pi_nlfd_nlf_id       nm_load_file_destinations.nlfd_nlf_id%TYPE
                   ,pi_nlfd_seq          nm_load_file_destinations.nlfd_seq%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nlfd IS
   SELECT /*+ INDEX (nlfd NLFD_UK) */ ROWID
    FROM  nm_load_file_destinations nlfd
   WHERE  nlfd.nlfd_nlf_id = pi_nlfd_nlf_id
    AND   nlfd.nlfd_seq    = pi_nlfd_seq
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlfd');
--
   OPEN  cs_nlfd;
   FETCH cs_nlfd INTO l_retval;
   l_found := cs_nlfd%FOUND;
   CLOSE cs_nlfd;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_load_file_destinations (NLFD_UK)'
                                              ||CHR(10)||'nlfd_nlf_id => '||pi_nlfd_nlf_id
                                              ||CHR(10)||'nlfd_seq    => '||pi_nlfd_seq
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nlfd');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_load_file_destinations (NLFD_UK)'
                                              ||CHR(10)||'nlfd_nlf_id => '||pi_nlfd_nlf_id
                                              ||CHR(10)||'nlfd_seq    => '||pi_nlfd_seq
                    );
--
END lock_nlfd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NLFD_UK constraint
--
PROCEDURE lock_nlfd (pi_nlfd_nlf_id       nm_load_file_destinations.nlfd_nlf_id%TYPE
                    ,pi_nlfd_seq          nm_load_file_destinations.nlfd_seq%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nlfd');
--
   l_rowid := lock_nlfd
                   (pi_nlfd_nlf_id       => pi_nlfd_nlf_id
                   ,pi_nlfd_seq          => pi_nlfd_seq
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nlfd');
--
END lock_nlfd;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMG_PK constraint
--
FUNCTION lock_nmg (pi_nmg_id            nm_mail_groups.nmg_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nmg IS
   SELECT /*+ INDEX (nmg NMG_PK) */ ROWID
    FROM  nm_mail_groups nmg
   WHERE  nmg.nmg_id = pi_nmg_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmg');
--
   OPEN  cs_nmg;
   FETCH cs_nmg INTO l_retval;
   l_found := cs_nmg%FOUND;
   CLOSE cs_nmg;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mail_groups (NMG_PK)'
                                              ||CHR(10)||'nmg_id => '||pi_nmg_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmg');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mail_groups (NMG_PK)'
                                              ||CHR(10)||'nmg_id => '||pi_nmg_id
                    );
--
END lock_nmg;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMG_PK constraint
--
PROCEDURE lock_nmg (pi_nmg_id            nm_mail_groups.nmg_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmg');
--
   l_rowid := lock_nmg
                   (pi_nmg_id            => pi_nmg_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmg');
--
END lock_nmg;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMG_UK constraint
--
FUNCTION lock_nmg (pi_nmg_name          nm_mail_groups.nmg_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nmg IS
   SELECT /*+ INDEX (nmg NMG_UK) */ ROWID
    FROM  nm_mail_groups nmg
   WHERE  nmg.nmg_name = pi_nmg_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmg');
--
   OPEN  cs_nmg;
   FETCH cs_nmg INTO l_retval;
   l_found := cs_nmg%FOUND;
   CLOSE cs_nmg;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mail_groups (NMG_UK)'
                                              ||CHR(10)||'nmg_name => '||pi_nmg_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmg');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mail_groups (NMG_UK)'
                                              ||CHR(10)||'nmg_name => '||pi_nmg_name
                    );
--
END lock_nmg;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMG_UK constraint
--
PROCEDURE lock_nmg (pi_nmg_name          nm_mail_groups.nmg_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmg');
--
   l_rowid := lock_nmg
                   (pi_nmg_name          => pi_nmg_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmg');
--
END lock_nmg;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMGM_PK constraint
--
FUNCTION lock_nmgm (pi_nmgm_nmg_id       nm_mail_group_membership.nmgm_nmg_id%TYPE
                   ,pi_nmgm_nmu_id       nm_mail_group_membership.nmgm_nmu_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nmgm IS
   SELECT /*+ INDEX (nmgm NMGM_PK) */ ROWID
    FROM  nm_mail_group_membership nmgm
   WHERE  nmgm.nmgm_nmg_id = pi_nmgm_nmg_id
    AND   nmgm.nmgm_nmu_id = pi_nmgm_nmu_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmgm');
--
   OPEN  cs_nmgm;
   FETCH cs_nmgm INTO l_retval;
   l_found := cs_nmgm%FOUND;
   CLOSE cs_nmgm;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mail_group_membership (NMGM_PK)'
                                              ||CHR(10)||'nmgm_nmg_id => '||pi_nmgm_nmg_id
                                              ||CHR(10)||'nmgm_nmu_id => '||pi_nmgm_nmu_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmgm');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mail_group_membership (NMGM_PK)'
                                              ||CHR(10)||'nmgm_nmg_id => '||pi_nmgm_nmg_id
                                              ||CHR(10)||'nmgm_nmu_id => '||pi_nmgm_nmu_id
                    );
--
END lock_nmgm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMGM_PK constraint
--
PROCEDURE lock_nmgm (pi_nmgm_nmg_id       nm_mail_group_membership.nmgm_nmg_id%TYPE
                    ,pi_nmgm_nmu_id       nm_mail_group_membership.nmgm_nmu_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmgm');
--
   l_rowid := lock_nmgm
                   (pi_nmgm_nmg_id       => pi_nmgm_nmg_id
                   ,pi_nmgm_nmu_id       => pi_nmgm_nmu_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmgm');
--
END lock_nmgm;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMM_PK constraint
--
FUNCTION lock_nmm (pi_nmm_id            nm_mail_message.nmm_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nmm IS
   SELECT /*+ INDEX (nmm NMM_PK) */ ROWID
    FROM  nm_mail_message nmm
   WHERE  nmm.nmm_id = pi_nmm_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmm');
--
   OPEN  cs_nmm;
   FETCH cs_nmm INTO l_retval;
   l_found := cs_nmm%FOUND;
   CLOSE cs_nmm;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mail_message (NMM_PK)'
                                              ||CHR(10)||'nmm_id => '||pi_nmm_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmm');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mail_message (NMM_PK)'
                                              ||CHR(10)||'nmm_id => '||pi_nmm_id
                    );
--
END lock_nmm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMM_PK constraint
--
PROCEDURE lock_nmm (pi_nmm_id            nm_mail_message.nmm_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmm');
--
   l_rowid := lock_nmm
                   (pi_nmm_id            => pi_nmm_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmm');
--
END lock_nmm;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMMR_PK constraint
--
FUNCTION lock_nmmr (pi_nmmr_nmm_id       nm_mail_message_recipients.nmmr_nmm_id%TYPE
                   ,pi_nmmr_rcpt_id      nm_mail_message_recipients.nmmr_rcpt_id%TYPE
                   ,pi_nmmr_rcpt_type    nm_mail_message_recipients.nmmr_rcpt_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nmmr IS
   SELECT /*+ INDEX (nmmr NMMR_PK) */ ROWID
    FROM  nm_mail_message_recipients nmmr
   WHERE  nmmr.nmmr_nmm_id    = pi_nmmr_nmm_id
    AND   nmmr.nmmr_rcpt_id   = pi_nmmr_rcpt_id
    AND   nmmr.nmmr_rcpt_type = pi_nmmr_rcpt_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmmr');
--
   OPEN  cs_nmmr;
   FETCH cs_nmmr INTO l_retval;
   l_found := cs_nmmr%FOUND;
   CLOSE cs_nmmr;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mail_message_recipients (NMMR_PK)'
                                              ||CHR(10)||'nmmr_nmm_id    => '||pi_nmmr_nmm_id
                                              ||CHR(10)||'nmmr_rcpt_id   => '||pi_nmmr_rcpt_id
                                              ||CHR(10)||'nmmr_rcpt_type => '||pi_nmmr_rcpt_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmmr');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mail_message_recipients (NMMR_PK)'
                                              ||CHR(10)||'nmmr_nmm_id    => '||pi_nmmr_nmm_id
                                              ||CHR(10)||'nmmr_rcpt_id   => '||pi_nmmr_rcpt_id
                                              ||CHR(10)||'nmmr_rcpt_type => '||pi_nmmr_rcpt_type
                    );
--
END lock_nmmr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMMR_PK constraint
--
PROCEDURE lock_nmmr (pi_nmmr_nmm_id       nm_mail_message_recipients.nmmr_nmm_id%TYPE
                    ,pi_nmmr_rcpt_id      nm_mail_message_recipients.nmmr_rcpt_id%TYPE
                    ,pi_nmmr_rcpt_type    nm_mail_message_recipients.nmmr_rcpt_type%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmmr');
--
   l_rowid := lock_nmmr
                   (pi_nmmr_nmm_id       => pi_nmmr_nmm_id
                   ,pi_nmmr_rcpt_id      => pi_nmmr_rcpt_id
                   ,pi_nmmr_rcpt_type    => pi_nmmr_rcpt_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmmr');
--
END lock_nmmr;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMMT_PK constraint
--
FUNCTION lock_nmmt (pi_nmmt_nmm_id       nm_mail_message_text.nmmt_nmm_id%TYPE
                   ,pi_nmmt_line_id      nm_mail_message_text.nmmt_line_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nmmt IS
   SELECT /*+ INDEX (nmmt NMMT_PK) */ ROWID
    FROM  nm_mail_message_text nmmt
   WHERE  nmmt.nmmt_nmm_id  = pi_nmmt_nmm_id
    AND   nmmt.nmmt_line_id = pi_nmmt_line_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmmt');
--
   OPEN  cs_nmmt;
   FETCH cs_nmmt INTO l_retval;
   l_found := cs_nmmt%FOUND;
   CLOSE cs_nmmt;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mail_message_text (NMMT_PK)'
                                              ||CHR(10)||'nmmt_nmm_id  => '||pi_nmmt_nmm_id
                                              ||CHR(10)||'nmmt_line_id => '||pi_nmmt_line_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmmt');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mail_message_text (NMMT_PK)'
                                              ||CHR(10)||'nmmt_nmm_id  => '||pi_nmmt_nmm_id
                                              ||CHR(10)||'nmmt_line_id => '||pi_nmmt_line_id
                    );
--
END lock_nmmt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMMT_PK constraint
--
PROCEDURE lock_nmmt (pi_nmmt_nmm_id       nm_mail_message_text.nmmt_nmm_id%TYPE
                    ,pi_nmmt_line_id      nm_mail_message_text.nmmt_line_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmmt');
--
   l_rowid := lock_nmmt
                   (pi_nmmt_nmm_id       => pi_nmmt_nmm_id
                   ,pi_nmmt_line_id      => pi_nmmt_line_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmmt');
--
END lock_nmmt;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMU_PK constraint
--
FUNCTION lock_nmu (pi_nmu_id            nm_mail_users.nmu_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nmu IS
   SELECT /*+ INDEX (nmu NMU_PK) */ ROWID
    FROM  nm_mail_users nmu
   WHERE  nmu.nmu_id = pi_nmu_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmu');
--
   OPEN  cs_nmu;
   FETCH cs_nmu INTO l_retval;
   l_found := cs_nmu%FOUND;
   CLOSE cs_nmu;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mail_users (NMU_PK)'
                                              ||CHR(10)||'nmu_id => '||pi_nmu_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmu');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mail_users (NMU_PK)'
                                              ||CHR(10)||'nmu_id => '||pi_nmu_id
                    );
--
END lock_nmu;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMU_PK constraint
--
PROCEDURE lock_nmu (pi_nmu_id            nm_mail_users.nmu_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmu');
--
   l_rowid := lock_nmu
                   (pi_nmu_id            => pi_nmu_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmu');
--
END lock_nmu;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NM_PK constraint
--
FUNCTION lock_nm (pi_nm_ne_id_in       nm_members.nm_ne_id_in%TYPE
                 ,pi_nm_ne_id_of       nm_members.nm_ne_id_of%TYPE
                 ,pi_nm_begin_mp       nm_members.nm_begin_mp%TYPE
                 ,pi_nm_start_date     nm_members.nm_start_date%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) RETURN ROWID IS
--
   CURSOR cs_nm IS
   SELECT /*+ INDEX (nm NM_PK) */ ROWID
    FROM  nm_members nm
   WHERE  nm.nm_ne_id_in   = pi_nm_ne_id_in
    AND   nm.nm_ne_id_of   = pi_nm_ne_id_of
    AND   nm.nm_begin_mp   = pi_nm_begin_mp
    AND   nm.nm_start_date = pi_nm_start_date
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nm');
--
   OPEN  cs_nm;
   FETCH cs_nm INTO l_retval;
   l_found := cs_nm%FOUND;
   CLOSE cs_nm;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_members (NM_PK)'
                                              ||CHR(10)||'nm_ne_id_in   => '||pi_nm_ne_id_in
                                              ||CHR(10)||'nm_ne_id_of   => '||pi_nm_ne_id_of
                                              ||CHR(10)||'nm_begin_mp   => '||pi_nm_begin_mp
                                              ||CHR(10)||'nm_start_date => '||pi_nm_start_date
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nm');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_members (NM_PK)'
                                              ||CHR(10)||'nm_ne_id_in   => '||pi_nm_ne_id_in
                                              ||CHR(10)||'nm_ne_id_of   => '||pi_nm_ne_id_of
                                              ||CHR(10)||'nm_begin_mp   => '||pi_nm_begin_mp
                                              ||CHR(10)||'nm_start_date => '||pi_nm_start_date
                    );
--
END lock_nm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NM_PK constraint
--
PROCEDURE lock_nm (pi_nm_ne_id_in       nm_members.nm_ne_id_in%TYPE
                  ,pi_nm_ne_id_of       nm_members.nm_ne_id_of%TYPE
                  ,pi_nm_begin_mp       nm_members.nm_begin_mp%TYPE
                  ,pi_nm_start_date     nm_members.nm_start_date%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nm');
--
   l_rowid := lock_nm
                   (pi_nm_ne_id_in       => pi_nm_ne_id_in
                   ,pi_nm_ne_id_of       => pi_nm_ne_id_of
                   ,pi_nm_begin_mp       => pi_nm_begin_mp
                   ,pi_nm_start_date     => pi_nm_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nm');
--
END lock_nm;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NM_PK constraint (without start date for Datetrack View)
--
FUNCTION lock_nm (pi_nm_ne_id_in       nm_members.nm_ne_id_in%TYPE
                 ,pi_nm_ne_id_of       nm_members.nm_ne_id_of%TYPE
                 ,pi_nm_begin_mp       nm_members.nm_begin_mp%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) RETURN ROWID IS
--
   CURSOR cs_nm IS
   SELECT /*+ INDEX (nm NM_PK) */ ROWID
    FROM  nm_members nm
   WHERE  nm.nm_ne_id_in = pi_nm_ne_id_in
    AND   nm.nm_ne_id_of = pi_nm_ne_id_of
    AND   nm.nm_begin_mp = pi_nm_begin_mp
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nm');
--
   OPEN  cs_nm;
   FETCH cs_nm INTO l_retval;
   l_found := cs_nm%FOUND;
   CLOSE cs_nm;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_members (NM_PK)'
                                              ||CHR(10)||'nm_ne_id_in => '||pi_nm_ne_id_in
                                              ||CHR(10)||'nm_ne_id_of => '||pi_nm_ne_id_of
                                              ||CHR(10)||'nm_begin_mp => '||pi_nm_begin_mp
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nm');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_members (NM_PK)'
                                              ||CHR(10)||'nm_ne_id_in => '||pi_nm_ne_id_in
                                              ||CHR(10)||'nm_ne_id_of => '||pi_nm_ne_id_of
                                              ||CHR(10)||'nm_begin_mp => '||pi_nm_begin_mp
                    );
--
END lock_nm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NM_PK constraint (without start date for Datetrack View)
--
PROCEDURE lock_nm (pi_nm_ne_id_in       nm_members.nm_ne_id_in%TYPE
                  ,pi_nm_ne_id_of       nm_members.nm_ne_id_of%TYPE
                  ,pi_nm_begin_mp       nm_members.nm_begin_mp%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nm');
--
   l_rowid := lock_nm
                   (pi_nm_ne_id_in       => pi_nm_ne_id_in
                   ,pi_nm_ne_id_of       => pi_nm_ne_id_of
                   ,pi_nm_begin_mp       => pi_nm_begin_mp
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nm');
--
END lock_nm;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NM_PK constraint
--
FUNCTION lock_nm_all (pi_nm_ne_id_in       nm_members_all.nm_ne_id_in%TYPE
                     ,pi_nm_ne_id_of       nm_members_all.nm_ne_id_of%TYPE
                     ,pi_nm_begin_mp       nm_members_all.nm_begin_mp%TYPE
                     ,pi_nm_start_date     nm_members_all.nm_start_date%TYPE
                     ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                     ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                     ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                     ) RETURN ROWID IS
--
   CURSOR cs_nm_all IS
   SELECT /*+ INDEX (nm_all NM_PK) */ ROWID
    FROM  nm_members_all nm_all
   WHERE  nm_all.nm_ne_id_in   = pi_nm_ne_id_in
    AND   nm_all.nm_ne_id_of   = pi_nm_ne_id_of
    AND   nm_all.nm_begin_mp   = pi_nm_begin_mp
    AND   nm_all.nm_start_date = pi_nm_start_date
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nm_all');
--
   OPEN  cs_nm_all;
   FETCH cs_nm_all INTO l_retval;
   l_found := cs_nm_all%FOUND;
   CLOSE cs_nm_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_members_all (NM_PK)'
                                              ||CHR(10)||'nm_ne_id_in   => '||pi_nm_ne_id_in
                                              ||CHR(10)||'nm_ne_id_of   => '||pi_nm_ne_id_of
                                              ||CHR(10)||'nm_begin_mp   => '||pi_nm_begin_mp
                                              ||CHR(10)||'nm_start_date => '||pi_nm_start_date
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nm_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_members_all (NM_PK)'
                                              ||CHR(10)||'nm_ne_id_in   => '||pi_nm_ne_id_in
                                              ||CHR(10)||'nm_ne_id_of   => '||pi_nm_ne_id_of
                                              ||CHR(10)||'nm_begin_mp   => '||pi_nm_begin_mp
                                              ||CHR(10)||'nm_start_date => '||pi_nm_start_date
                    );
--
END lock_nm_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NM_PK constraint
--
PROCEDURE lock_nm_all (pi_nm_ne_id_in       nm_members_all.nm_ne_id_in%TYPE
                      ,pi_nm_ne_id_of       nm_members_all.nm_ne_id_of%TYPE
                      ,pi_nm_begin_mp       nm_members_all.nm_begin_mp%TYPE
                      ,pi_nm_start_date     nm_members_all.nm_start_date%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nm_all');
--
   l_rowid := lock_nm_all
                   (pi_nm_ne_id_in       => pi_nm_ne_id_in
                   ,pi_nm_ne_id_of       => pi_nm_ne_id_of
                   ,pi_nm_begin_mp       => pi_nm_begin_mp
                   ,pi_nm_start_date     => pi_nm_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nm_all');
--
END lock_nm_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMH_PK constraint
--
FUNCTION lock_nmh (pi_nmh_nm_begin_mp     nm_member_history.nmh_nm_begin_mp%TYPE
                  ,pi_nmh_nm_start_date   nm_member_history.nmh_nm_start_date%TYPE
                  ,pi_nmh_nm_ne_id_in     nm_member_history.nmh_nm_ne_id_in%TYPE
                  ,pi_nmh_nm_ne_id_of_old nm_member_history.nmh_nm_ne_id_of_old%TYPE
                  ,pi_nmh_nm_ne_id_of_new nm_member_history.nmh_nm_ne_id_of_new%TYPE
                  ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nmh IS
   SELECT /*+ INDEX (nmh NMH_PK) */ ROWID
    FROM  nm_member_history nmh
   WHERE  nmh.nmh_nm_begin_mp     = pi_nmh_nm_begin_mp
    AND   nmh.nmh_nm_start_date   = pi_nmh_nm_start_date
    AND   nmh.nmh_nm_ne_id_in     = pi_nmh_nm_ne_id_in
    AND   nmh.nmh_nm_ne_id_of_old = pi_nmh_nm_ne_id_of_old
    AND   nmh.nmh_nm_ne_id_of_new = pi_nmh_nm_ne_id_of_new
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmh');
--
   OPEN  cs_nmh;
   FETCH cs_nmh INTO l_retval;
   l_found := cs_nmh%FOUND;
   CLOSE cs_nmh;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_member_history (NMH_PK)'
                                              ||CHR(10)||'nmh_nm_begin_mp     => '||pi_nmh_nm_begin_mp
                                              ||CHR(10)||'nmh_nm_start_date   => '||pi_nmh_nm_start_date
                                              ||CHR(10)||'nmh_nm_ne_id_in     => '||pi_nmh_nm_ne_id_in
                                              ||CHR(10)||'nmh_nm_ne_id_of_old => '||pi_nmh_nm_ne_id_of_old
                                              ||CHR(10)||'nmh_nm_ne_id_of_new => '||pi_nmh_nm_ne_id_of_new
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmh');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_member_history (NMH_PK)'
                                              ||CHR(10)||'nmh_nm_begin_mp     => '||pi_nmh_nm_begin_mp
                                              ||CHR(10)||'nmh_nm_start_date   => '||pi_nmh_nm_start_date
                                              ||CHR(10)||'nmh_nm_ne_id_in     => '||pi_nmh_nm_ne_id_in
                                              ||CHR(10)||'nmh_nm_ne_id_of_old => '||pi_nmh_nm_ne_id_of_old
                                              ||CHR(10)||'nmh_nm_ne_id_of_new => '||pi_nmh_nm_ne_id_of_new
                    );
--
END lock_nmh;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMH_PK constraint
--
PROCEDURE lock_nmh (pi_nmh_nm_begin_mp     nm_member_history.nmh_nm_begin_mp%TYPE
                   ,pi_nmh_nm_start_date   nm_member_history.nmh_nm_start_date%TYPE
                   ,pi_nmh_nm_ne_id_in     nm_member_history.nmh_nm_ne_id_in%TYPE
                   ,pi_nmh_nm_ne_id_of_old nm_member_history.nmh_nm_ne_id_of_old%TYPE
                   ,pi_nmh_nm_ne_id_of_new nm_member_history.nmh_nm_ne_id_of_new%TYPE
                   ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmh');
--
   l_rowid := lock_nmh
                   (pi_nmh_nm_begin_mp     => pi_nmh_nm_begin_mp
                   ,pi_nmh_nm_start_date   => pi_nmh_nm_start_date
                   ,pi_nmh_nm_ne_id_in     => pi_nmh_nm_ne_id_in
                   ,pi_nmh_nm_ne_id_of_old => pi_nmh_nm_ne_id_of_old
                   ,pi_nmh_nm_ne_id_of_new => pi_nmh_nm_ne_id_of_new
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmh');
--
END lock_nmh;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NDQA_PK constraint
--
FUNCTION lock_nda (pi_nda_seq_no        nm_mrg_default_query_attribs.nda_seq_no%TYPE
                  ,pi_nda_attrib_name   nm_mrg_default_query_attribs.nda_attrib_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nda IS
   SELECT /*+ INDEX (nda NDQA_PK) */ ROWID
    FROM  nm_mrg_default_query_attribs nda
   WHERE  nda.nda_seq_no      = pi_nda_seq_no
    AND   nda.nda_attrib_name = pi_nda_attrib_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nda');
--
   OPEN  cs_nda;
   FETCH cs_nda INTO l_retval;
   l_found := cs_nda%FOUND;
   CLOSE cs_nda;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_default_query_attribs (NDQA_PK)'
                                              ||CHR(10)||'nda_seq_no      => '||pi_nda_seq_no
                                              ||CHR(10)||'nda_attrib_name => '||pi_nda_attrib_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nda');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_default_query_attribs (NDQA_PK)'
                                              ||CHR(10)||'nda_seq_no      => '||pi_nda_seq_no
                                              ||CHR(10)||'nda_attrib_name => '||pi_nda_attrib_name
                    );
--
END lock_nda;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NDQA_PK constraint
--
PROCEDURE lock_nda (pi_nda_seq_no        nm_mrg_default_query_attribs.nda_seq_no%TYPE
                   ,pi_nda_attrib_name   nm_mrg_default_query_attribs.nda_attrib_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nda');
--
   l_rowid := lock_nda
                   (pi_nda_seq_no        => pi_nda_seq_no
                   ,pi_nda_attrib_name   => pi_nda_attrib_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nda');
--
END lock_nda;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NDQT_PK constraint
--
FUNCTION lock_ndq (pi_ndq_seq_no        nm_mrg_default_query_types.ndq_seq_no%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_ndq IS
   SELECT /*+ INDEX (ndq NDQT_PK) */ ROWID
    FROM  nm_mrg_default_query_types ndq
   WHERE  ndq.ndq_seq_no = pi_ndq_seq_no
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ndq');
--
   OPEN  cs_ndq;
   FETCH cs_ndq INTO l_retval;
   l_found := cs_ndq%FOUND;
   CLOSE cs_ndq;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_default_query_types (NDQT_PK)'
                                              ||CHR(10)||'ndq_seq_no => '||pi_ndq_seq_no
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ndq');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_default_query_types (NDQT_PK)'
                                              ||CHR(10)||'ndq_seq_no => '||pi_ndq_seq_no
                    );
--
END lock_ndq;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NDQT_PK constraint
--
PROCEDURE lock_ndq (pi_ndq_seq_no        nm_mrg_default_query_types.ndq_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ndq');
--
   l_rowid := lock_ndq
                   (pi_ndq_seq_no        => pi_ndq_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ndq');
--
END lock_ndq;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NDQT_PK constraint
--
FUNCTION lock_ndq_all (pi_ndq_seq_no        nm_mrg_default_query_types_all.ndq_seq_no%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_ndq_all IS
   SELECT /*+ INDEX (ndq_all NDQT_PK) */ ROWID
    FROM  nm_mrg_default_query_types_all ndq_all
   WHERE  ndq_all.ndq_seq_no = pi_ndq_seq_no
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ndq_all');
--
   OPEN  cs_ndq_all;
   FETCH cs_ndq_all INTO l_retval;
   l_found := cs_ndq_all%FOUND;
   CLOSE cs_ndq_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_default_query_types_all (NDQT_PK)'
                                              ||CHR(10)||'ndq_seq_no => '||pi_ndq_seq_no
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ndq_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_default_query_types_all (NDQT_PK)'
                                              ||CHR(10)||'ndq_seq_no => '||pi_ndq_seq_no
                    );
--
END lock_ndq_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NDQT_PK constraint
--
PROCEDURE lock_ndq_all (pi_ndq_seq_no        nm_mrg_default_query_types_all.ndq_seq_no%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ndq_all');
--
   l_rowid := lock_ndq_all
                   (pi_ndq_seq_no        => pi_ndq_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ndq_all');
--
END lock_ndq_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMID_PK constraint
--
FUNCTION lock_nmid (pi_nmid_nmq_id       nm_mrg_inv_derivation.nmid_nmq_id%TYPE
                   ,pi_nmid_inv_type     nm_mrg_inv_derivation.nmid_inv_type%TYPE
                   ,pi_nmid_attrib_name  nm_mrg_inv_derivation.nmid_attrib_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nmid IS
   SELECT /*+ INDEX (nmid NMID_PK) */ ROWID
    FROM  nm_mrg_inv_derivation nmid
   WHERE  nmid.nmid_nmq_id      = pi_nmid_nmq_id
    AND   nmid.nmid_inv_type    = pi_nmid_inv_type
    AND   nmid.nmid_attrib_name = pi_nmid_attrib_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmid');
--
   OPEN  cs_nmid;
   FETCH cs_nmid INTO l_retval;
   l_found := cs_nmid%FOUND;
   CLOSE cs_nmid;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_inv_derivation (NMID_PK)'
                                              ||CHR(10)||'nmid_nmq_id      => '||pi_nmid_nmq_id
                                              ||CHR(10)||'nmid_inv_type    => '||pi_nmid_inv_type
                                              ||CHR(10)||'nmid_attrib_name => '||pi_nmid_attrib_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmid');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_inv_derivation (NMID_PK)'
                                              ||CHR(10)||'nmid_nmq_id      => '||pi_nmid_nmq_id
                                              ||CHR(10)||'nmid_inv_type    => '||pi_nmid_inv_type
                                              ||CHR(10)||'nmid_attrib_name => '||pi_nmid_attrib_name
                    );
--
END lock_nmid;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMID_PK constraint
--
PROCEDURE lock_nmid (pi_nmid_nmq_id       nm_mrg_inv_derivation.nmid_nmq_id%TYPE
                    ,pi_nmid_inv_type     nm_mrg_inv_derivation.nmid_inv_type%TYPE
                    ,pi_nmid_attrib_name  nm_mrg_inv_derivation.nmid_attrib_name%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmid');
--
   l_rowid := lock_nmid
                   (pi_nmid_nmq_id       => pi_nmid_nmq_id
                   ,pi_nmid_inv_type     => pi_nmid_inv_type
                   ,pi_nmid_attrib_name  => pi_nmid_attrib_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmid');
--
END lock_nmid;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMC_PK constraint
--
FUNCTION lock_nmc (pi_nmc_nmf_id        nm_mrg_output_cols.nmc_nmf_id%TYPE
                  ,pi_nmc_seq_no        nm_mrg_output_cols.nmc_seq_no%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nmc IS
   SELECT /*+ INDEX (nmc NMC_PK) */ ROWID
    FROM  nm_mrg_output_cols nmc
   WHERE  nmc.nmc_nmf_id = pi_nmc_nmf_id
    AND   nmc.nmc_seq_no = pi_nmc_seq_no
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmc');
--
   OPEN  cs_nmc;
   FETCH cs_nmc INTO l_retval;
   l_found := cs_nmc%FOUND;
   CLOSE cs_nmc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_output_cols (NMC_PK)'
                                              ||CHR(10)||'nmc_nmf_id => '||pi_nmc_nmf_id
                                              ||CHR(10)||'nmc_seq_no => '||pi_nmc_seq_no
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_output_cols (NMC_PK)'
                                              ||CHR(10)||'nmc_nmf_id => '||pi_nmc_nmf_id
                                              ||CHR(10)||'nmc_seq_no => '||pi_nmc_seq_no
                    );
--
END lock_nmc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMC_PK constraint
--
PROCEDURE lock_nmc (pi_nmc_nmf_id        nm_mrg_output_cols.nmc_nmf_id%TYPE
                   ,pi_nmc_seq_no        nm_mrg_output_cols.nmc_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmc');
--
   l_rowid := lock_nmc
                   (pi_nmc_nmf_id        => pi_nmc_nmf_id
                   ,pi_nmc_seq_no        => pi_nmc_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmc');
--
END lock_nmc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMC_UK constraint
--
FUNCTION lock_nmc (pi_nmc_nmf_id        nm_mrg_output_cols.nmc_nmf_id%TYPE
                  ,pi_nmc_view_col_name nm_mrg_output_cols.nmc_view_col_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nmc IS
   SELECT /*+ INDEX (nmc NMC_UK) */ ROWID
    FROM  nm_mrg_output_cols nmc
   WHERE  nmc.nmc_nmf_id        = pi_nmc_nmf_id
    AND   nmc.nmc_view_col_name = pi_nmc_view_col_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmc');
--
   OPEN  cs_nmc;
   FETCH cs_nmc INTO l_retval;
   l_found := cs_nmc%FOUND;
   CLOSE cs_nmc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_output_cols (NMC_UK)'
                                              ||CHR(10)||'nmc_nmf_id        => '||pi_nmc_nmf_id
                                              ||CHR(10)||'nmc_view_col_name => '||pi_nmc_view_col_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_output_cols (NMC_UK)'
                                              ||CHR(10)||'nmc_nmf_id        => '||pi_nmc_nmf_id
                                              ||CHR(10)||'nmc_view_col_name => '||pi_nmc_view_col_name
                    );
--
END lock_nmc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMC_UK constraint
--
PROCEDURE lock_nmc (pi_nmc_nmf_id        nm_mrg_output_cols.nmc_nmf_id%TYPE
                   ,pi_nmc_view_col_name nm_mrg_output_cols.nmc_view_col_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmc');
--
   l_rowid := lock_nmc
                   (pi_nmc_nmf_id        => pi_nmc_nmf_id
                   ,pi_nmc_view_col_name => pi_nmc_view_col_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmc');
--
END lock_nmc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMCD_PK constraint
--
FUNCTION lock_nmcd (pi_nmcd_nmf_id       nm_mrg_output_col_decode.nmcd_nmf_id%TYPE
                   ,pi_nmcd_nmc_seq_no   nm_mrg_output_col_decode.nmcd_nmc_seq_no%TYPE
                   ,pi_nmcd_from_value   nm_mrg_output_col_decode.nmcd_from_value%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nmcd IS
   SELECT /*+ INDEX (nmcd NMCD_PK) */ ROWID
    FROM  nm_mrg_output_col_decode nmcd
   WHERE  nmcd.nmcd_nmf_id     = pi_nmcd_nmf_id
    AND   nmcd.nmcd_nmc_seq_no = pi_nmcd_nmc_seq_no
    AND   nmcd.nmcd_from_value = pi_nmcd_from_value
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmcd');
--
   OPEN  cs_nmcd;
   FETCH cs_nmcd INTO l_retval;
   l_found := cs_nmcd%FOUND;
   CLOSE cs_nmcd;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_output_col_decode (NMCD_PK)'
                                              ||CHR(10)||'nmcd_nmf_id     => '||pi_nmcd_nmf_id
                                              ||CHR(10)||'nmcd_nmc_seq_no => '||pi_nmcd_nmc_seq_no
                                              ||CHR(10)||'nmcd_from_value => '||pi_nmcd_from_value
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmcd');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_output_col_decode (NMCD_PK)'
                                              ||CHR(10)||'nmcd_nmf_id     => '||pi_nmcd_nmf_id
                                              ||CHR(10)||'nmcd_nmc_seq_no => '||pi_nmcd_nmc_seq_no
                                              ||CHR(10)||'nmcd_from_value => '||pi_nmcd_from_value
                    );
--
END lock_nmcd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMCD_PK constraint
--
PROCEDURE lock_nmcd (pi_nmcd_nmf_id       nm_mrg_output_col_decode.nmcd_nmf_id%TYPE
                    ,pi_nmcd_nmc_seq_no   nm_mrg_output_col_decode.nmcd_nmc_seq_no%TYPE
                    ,pi_nmcd_from_value   nm_mrg_output_col_decode.nmcd_from_value%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmcd');
--
   l_rowid := lock_nmcd
                   (pi_nmcd_nmf_id       => pi_nmcd_nmf_id
                   ,pi_nmcd_nmc_seq_no   => pi_nmcd_nmc_seq_no
                   ,pi_nmcd_from_value   => pi_nmcd_from_value
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmcd');
--
END lock_nmcd;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMF_PK constraint
--
FUNCTION lock_nmf (pi_nmf_id            nm_mrg_output_file.nmf_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nmf IS
   SELECT /*+ INDEX (nmf NMF_PK) */ ROWID
    FROM  nm_mrg_output_file nmf
   WHERE  nmf.nmf_id = pi_nmf_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmf');
--
   OPEN  cs_nmf;
   FETCH cs_nmf INTO l_retval;
   l_found := cs_nmf%FOUND;
   CLOSE cs_nmf;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_output_file (NMF_PK)'
                                              ||CHR(10)||'nmf_id => '||pi_nmf_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmf');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_output_file (NMF_PK)'
                                              ||CHR(10)||'nmf_id => '||pi_nmf_id
                    );
--
END lock_nmf;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMF_PK constraint
--
PROCEDURE lock_nmf (pi_nmf_id            nm_mrg_output_file.nmf_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmf');
--
   l_rowid := lock_nmf
                   (pi_nmf_id            => pi_nmf_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmf');
--
END lock_nmf;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMF_UK constraint
--
FUNCTION lock_nmf (pi_nmf_nmq_id        nm_mrg_output_file.nmf_nmq_id%TYPE
                  ,pi_nmf_filename      nm_mrg_output_file.nmf_filename%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nmf IS
   SELECT /*+ INDEX (nmf NMF_UK) */ ROWID
    FROM  nm_mrg_output_file nmf
   WHERE  nmf.nmf_nmq_id   = pi_nmf_nmq_id
    AND   nmf.nmf_filename = pi_nmf_filename
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmf');
--
   OPEN  cs_nmf;
   FETCH cs_nmf INTO l_retval;
   l_found := cs_nmf%FOUND;
   CLOSE cs_nmf;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_output_file (NMF_UK)'
                                              ||CHR(10)||'nmf_nmq_id   => '||pi_nmf_nmq_id
                                              ||CHR(10)||'nmf_filename => '||pi_nmf_filename
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmf');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_output_file (NMF_UK)'
                                              ||CHR(10)||'nmf_nmq_id   => '||pi_nmf_nmq_id
                                              ||CHR(10)||'nmf_filename => '||pi_nmf_filename
                    );
--
END lock_nmf;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMF_UK constraint
--
PROCEDURE lock_nmf (pi_nmf_nmq_id        nm_mrg_output_file.nmf_nmq_id%TYPE
                   ,pi_nmf_filename      nm_mrg_output_file.nmf_filename%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmf');
--
   l_rowid := lock_nmf
                   (pi_nmf_nmq_id        => pi_nmf_nmq_id
                   ,pi_nmf_filename      => pi_nmf_filename
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmf');
--
END lock_nmf;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMQ_PK constraint
--
FUNCTION lock_nmq (pi_nmq_id            nm_mrg_query.nmq_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nmq IS
   SELECT /*+ INDEX (nmq NMQ_PK) */ ROWID
    FROM  nm_mrg_query nmq
   WHERE  nmq.nmq_id = pi_nmq_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmq');
--
   OPEN  cs_nmq;
   FETCH cs_nmq INTO l_retval;
   l_found := cs_nmq%FOUND;
   CLOSE cs_nmq;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query (NMQ_PK)'
                                              ||CHR(10)||'nmq_id => '||pi_nmq_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmq');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query (NMQ_PK)'
                                              ||CHR(10)||'nmq_id => '||pi_nmq_id
                    );
--
END lock_nmq;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMQ_PK constraint
--
PROCEDURE lock_nmq (pi_nmq_id            nm_mrg_query.nmq_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmq');
--
   l_rowid := lock_nmq
                   (pi_nmq_id            => pi_nmq_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmq');
--
END lock_nmq;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMQ_UK constraint
--
FUNCTION lock_nmq (pi_nmq_unique        nm_mrg_query.nmq_unique%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nmq IS
   SELECT /*+ INDEX (nmq NMQ_UK) */ ROWID
    FROM  nm_mrg_query nmq
   WHERE  nmq.nmq_unique = pi_nmq_unique
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmq');
--
   OPEN  cs_nmq;
   FETCH cs_nmq INTO l_retval;
   l_found := cs_nmq%FOUND;
   CLOSE cs_nmq;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query (NMQ_UK)'
                                              ||CHR(10)||'nmq_unique => '||pi_nmq_unique
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmq');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query (NMQ_UK)'
                                              ||CHR(10)||'nmq_unique => '||pi_nmq_unique
                    );
--
END lock_nmq;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMQ_UK constraint
--
PROCEDURE lock_nmq (pi_nmq_unique        nm_mrg_query.nmq_unique%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmq');
--
   l_rowid := lock_nmq
                   (pi_nmq_unique        => pi_nmq_unique
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmq');
--
END lock_nmq;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMQ_PK constraint
--
FUNCTION lock_nmq_all (pi_nmq_id            nm_mrg_query_all.nmq_id%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_nmq_all IS
   SELECT /*+ INDEX (nmq_all NMQ_PK) */ ROWID
    FROM  nm_mrg_query_all nmq_all
   WHERE  nmq_all.nmq_id = pi_nmq_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmq_all');
--
   OPEN  cs_nmq_all;
   FETCH cs_nmq_all INTO l_retval;
   l_found := cs_nmq_all%FOUND;
   CLOSE cs_nmq_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query_all (NMQ_PK)'
                                              ||CHR(10)||'nmq_id => '||pi_nmq_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmq_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query_all (NMQ_PK)'
                                              ||CHR(10)||'nmq_id => '||pi_nmq_id
                    );
--
END lock_nmq_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMQ_PK constraint
--
PROCEDURE lock_nmq_all (pi_nmq_id            nm_mrg_query_all.nmq_id%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmq_all');
--
   l_rowid := lock_nmq_all
                   (pi_nmq_id            => pi_nmq_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmq_all');
--
END lock_nmq_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMQ_UK constraint
--
FUNCTION lock_nmq_all (pi_nmq_unique        nm_mrg_query_all.nmq_unique%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_nmq_all IS
   SELECT /*+ INDEX (nmq_all NMQ_UK) */ ROWID
    FROM  nm_mrg_query_all nmq_all
   WHERE  nmq_all.nmq_unique = pi_nmq_unique
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmq_all');
--
   OPEN  cs_nmq_all;
   FETCH cs_nmq_all INTO l_retval;
   l_found := cs_nmq_all%FOUND;
   CLOSE cs_nmq_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query_all (NMQ_UK)'
                                              ||CHR(10)||'nmq_unique => '||pi_nmq_unique
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmq_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query_all (NMQ_UK)'
                                              ||CHR(10)||'nmq_unique => '||pi_nmq_unique
                    );
--
END lock_nmq_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMQ_UK constraint
--
PROCEDURE lock_nmq_all (pi_nmq_unique        nm_mrg_query_all.nmq_unique%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmq_all');
--
   l_rowid := lock_nmq_all
                   (pi_nmq_unique        => pi_nmq_unique
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmq_all');
--
END lock_nmq_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMQA_PK constraint
--
FUNCTION lock_nmqa (pi_nqa_nmq_id        nm_mrg_query_attribs.nqa_nmq_id%TYPE
                   ,pi_nqa_nqt_seq_no    nm_mrg_query_attribs.nqa_nqt_seq_no%TYPE
                   ,pi_nqa_attrib_name   nm_mrg_query_attribs.nqa_attrib_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nmqa IS
   SELECT /*+ INDEX (nmqa NMQA_PK) */ ROWID
    FROM  nm_mrg_query_attribs nmqa
   WHERE  nmqa.nqa_nmq_id      = pi_nqa_nmq_id
    AND   nmqa.nqa_nqt_seq_no  = pi_nqa_nqt_seq_no
    AND   nmqa.nqa_attrib_name = pi_nqa_attrib_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmqa');
--
   OPEN  cs_nmqa;
   FETCH cs_nmqa INTO l_retval;
   l_found := cs_nmqa%FOUND;
   CLOSE cs_nmqa;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query_attribs (NMQA_PK)'
                                              ||CHR(10)||'nqa_nmq_id      => '||pi_nqa_nmq_id
                                              ||CHR(10)||'nqa_nqt_seq_no  => '||pi_nqa_nqt_seq_no
                                              ||CHR(10)||'nqa_attrib_name => '||pi_nqa_attrib_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmqa');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query_attribs (NMQA_PK)'
                                              ||CHR(10)||'nqa_nmq_id      => '||pi_nqa_nmq_id
                                              ||CHR(10)||'nqa_nqt_seq_no  => '||pi_nqa_nqt_seq_no
                                              ||CHR(10)||'nqa_attrib_name => '||pi_nqa_attrib_name
                    );
--
END lock_nmqa;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMQA_PK constraint
--
PROCEDURE lock_nmqa (pi_nqa_nmq_id        nm_mrg_query_attribs.nqa_nmq_id%TYPE
                    ,pi_nqa_nqt_seq_no    nm_mrg_query_attribs.nqa_nqt_seq_no%TYPE
                    ,pi_nqa_attrib_name   nm_mrg_query_attribs.nqa_attrib_name%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmqa');
--
   l_rowid := lock_nmqa
                   (pi_nqa_nmq_id        => pi_nqa_nmq_id
                   ,pi_nqa_nqt_seq_no    => pi_nqa_nqt_seq_no
                   ,pi_nqa_attrib_name   => pi_nqa_attrib_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmqa');
--
END lock_nmqa;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMQR_PK constraint
--
FUNCTION lock_nmqr (pi_nqr_mrg_job_id    nm_mrg_query_results.nqr_mrg_job_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nmqr IS
   SELECT /*+ INDEX (nmqr NMQR_PK) */ ROWID
    FROM  nm_mrg_query_results nmqr
   WHERE  nmqr.nqr_mrg_job_id = pi_nqr_mrg_job_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmqr');
--
   OPEN  cs_nmqr;
   FETCH cs_nmqr INTO l_retval;
   l_found := cs_nmqr%FOUND;
   CLOSE cs_nmqr;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query_results (NMQR_PK)'
                                              ||CHR(10)||'nqr_mrg_job_id => '||pi_nqr_mrg_job_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmqr');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query_results (NMQR_PK)'
                                              ||CHR(10)||'nqr_mrg_job_id => '||pi_nqr_mrg_job_id
                    );
--
END lock_nmqr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMQR_PK constraint
--
PROCEDURE lock_nmqr (pi_nqr_mrg_job_id    nm_mrg_query_results.nqr_mrg_job_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmqr');
--
   l_rowid := lock_nmqr
                   (pi_nqr_mrg_job_id    => pi_nqr_mrg_job_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmqr');
--
END lock_nmqr;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMQR_PK constraint
--
FUNCTION lock_nmqr_all (pi_nqr_mrg_job_id    nm_mrg_query_results_all.nqr_mrg_job_id%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) RETURN ROWID IS
--
   CURSOR cs_nmqr_all IS
   SELECT /*+ INDEX (nmqr_all NMQR_PK) */ ROWID
    FROM  nm_mrg_query_results_all nmqr_all
   WHERE  nmqr_all.nqr_mrg_job_id = pi_nqr_mrg_job_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmqr_all');
--
   OPEN  cs_nmqr_all;
   FETCH cs_nmqr_all INTO l_retval;
   l_found := cs_nmqr_all%FOUND;
   CLOSE cs_nmqr_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query_results_all (NMQR_PK)'
                                              ||CHR(10)||'nqr_mrg_job_id => '||pi_nqr_mrg_job_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmqr_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query_results_all (NMQR_PK)'
                                              ||CHR(10)||'nqr_mrg_job_id => '||pi_nqr_mrg_job_id
                    );
--
END lock_nmqr_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMQR_PK constraint
--
PROCEDURE lock_nmqr_all (pi_nqr_mrg_job_id    nm_mrg_query_results_all.nqr_mrg_job_id%TYPE
                        ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                        ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                        ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                        ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmqr_all');
--
   l_rowid := lock_nmqr_all
                   (pi_nqr_mrg_job_id    => pi_nqr_mrg_job_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmqr_all');
--
END lock_nmqr_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NQRO_PK constraint
--
FUNCTION lock_nqro (pi_nqro_nmq_id       nm_mrg_query_roles.nqro_nmq_id%TYPE
                   ,pi_nqro_role         nm_mrg_query_roles.nqro_role%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nqro IS
   SELECT /*+ INDEX (nqro NQRO_PK) */ ROWID
    FROM  nm_mrg_query_roles nqro
   WHERE  nqro.nqro_nmq_id = pi_nqro_nmq_id
    AND   nqro.nqro_role   = pi_nqro_role
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nqro');
--
   OPEN  cs_nqro;
   FETCH cs_nqro INTO l_retval;
   l_found := cs_nqro%FOUND;
   CLOSE cs_nqro;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query_roles (NQRO_PK)'
                                              ||CHR(10)||'nqro_nmq_id => '||pi_nqro_nmq_id
                                              ||CHR(10)||'nqro_role   => '||pi_nqro_role
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nqro');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query_roles (NQRO_PK)'
                                              ||CHR(10)||'nqro_nmq_id => '||pi_nqro_nmq_id
                                              ||CHR(10)||'nqro_role   => '||pi_nqro_role
                    );
--
END lock_nqro;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NQRO_PK constraint
--
PROCEDURE lock_nqro (pi_nqro_nmq_id       nm_mrg_query_roles.nqro_nmq_id%TYPE
                    ,pi_nqro_role         nm_mrg_query_roles.nqro_role%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nqro');
--
   l_rowid := lock_nqro
                   (pi_nqro_nmq_id       => pi_nqro_nmq_id
                   ,pi_nqro_role         => pi_nqro_role
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nqro');
--
END lock_nqro;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMQT_PK constraint
--
FUNCTION lock_nmqt (pi_nqt_nmq_id        nm_mrg_query_types.nqt_nmq_id%TYPE
                   ,pi_nqt_seq_no        nm_mrg_query_types.nqt_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nmqt IS
   SELECT /*+ INDEX (nmqt NMQT_PK) */ ROWID
    FROM  nm_mrg_query_types nmqt
   WHERE  nmqt.nqt_nmq_id = pi_nqt_nmq_id
    AND   nmqt.nqt_seq_no = pi_nqt_seq_no
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmqt');
--
   OPEN  cs_nmqt;
   FETCH cs_nmqt INTO l_retval;
   l_found := cs_nmqt%FOUND;
   CLOSE cs_nmqt;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query_types (NMQT_PK)'
                                              ||CHR(10)||'nqt_nmq_id => '||pi_nqt_nmq_id
                                              ||CHR(10)||'nqt_seq_no => '||pi_nqt_seq_no
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmqt');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query_types (NMQT_PK)'
                                              ||CHR(10)||'nqt_nmq_id => '||pi_nqt_nmq_id
                                              ||CHR(10)||'nqt_seq_no => '||pi_nqt_seq_no
                    );
--
END lock_nmqt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMQT_PK constraint
--
PROCEDURE lock_nmqt (pi_nqt_nmq_id        nm_mrg_query_types.nqt_nmq_id%TYPE
                    ,pi_nqt_seq_no        nm_mrg_query_types.nqt_seq_no%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmqt');
--
   l_rowid := lock_nmqt
                   (pi_nqt_nmq_id        => pi_nqt_nmq_id
                   ,pi_nqt_seq_no        => pi_nqt_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmqt');
--
END lock_nmqt;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMQT_PK constraint
--
FUNCTION lock_nmqt_all (pi_nqt_nmq_id        nm_mrg_query_types_all.nqt_nmq_id%TYPE
                       ,pi_nqt_seq_no        nm_mrg_query_types_all.nqt_seq_no%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) RETURN ROWID IS
--
   CURSOR cs_nmqt_all IS
   SELECT /*+ INDEX (nmqt_all NMQT_PK) */ ROWID
    FROM  nm_mrg_query_types_all nmqt_all
   WHERE  nmqt_all.nqt_nmq_id = pi_nqt_nmq_id
    AND   nmqt_all.nqt_seq_no = pi_nqt_seq_no
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmqt_all');
--
   OPEN  cs_nmqt_all;
   FETCH cs_nmqt_all INTO l_retval;
   l_found := cs_nmqt_all%FOUND;
   CLOSE cs_nmqt_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query_types_all (NMQT_PK)'
                                              ||CHR(10)||'nqt_nmq_id => '||pi_nqt_nmq_id
                                              ||CHR(10)||'nqt_seq_no => '||pi_nqt_seq_no
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmqt_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query_types_all (NMQT_PK)'
                                              ||CHR(10)||'nqt_nmq_id => '||pi_nqt_nmq_id
                                              ||CHR(10)||'nqt_seq_no => '||pi_nqt_seq_no
                    );
--
END lock_nmqt_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMQT_PK constraint
--
PROCEDURE lock_nmqt_all (pi_nqt_nmq_id        nm_mrg_query_types_all.nqt_nmq_id%TYPE
                        ,pi_nqt_seq_no        nm_mrg_query_types_all.nqt_seq_no%TYPE
                        ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                        ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                        ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                        ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmqt_all');
--
   l_rowid := lock_nmqt_all
                   (pi_nqt_nmq_id        => pi_nqt_nmq_id
                   ,pi_nqt_seq_no        => pi_nqt_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmqt_all');
--
END lock_nmqt_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMQV_PK constraint
--
FUNCTION lock_nmqv (pi_nqv_nqt_seq_no    nm_mrg_query_values.nqv_nqt_seq_no%TYPE
                   ,pi_nqv_attrib_name   nm_mrg_query_values.nqv_attrib_name%TYPE
                   ,pi_nqv_sequence      nm_mrg_query_values.nqv_sequence%TYPE
                   ,pi_nqv_nmq_id        nm_mrg_query_values.nqv_nmq_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nmqv IS
   SELECT /*+ INDEX (nmqv NMQV_PK) */ ROWID
    FROM  nm_mrg_query_values nmqv
   WHERE  nmqv.nqv_nqt_seq_no  = pi_nqv_nqt_seq_no
    AND   nmqv.nqv_attrib_name = pi_nqv_attrib_name
    AND   nmqv.nqv_sequence    = pi_nqv_sequence
    AND   nmqv.nqv_nmq_id      = pi_nqv_nmq_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmqv');
--
   OPEN  cs_nmqv;
   FETCH cs_nmqv INTO l_retval;
   l_found := cs_nmqv%FOUND;
   CLOSE cs_nmqv;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query_values (NMQV_PK)'
                                              ||CHR(10)||'nqv_nqt_seq_no  => '||pi_nqv_nqt_seq_no
                                              ||CHR(10)||'nqv_attrib_name => '||pi_nqv_attrib_name
                                              ||CHR(10)||'nqv_sequence    => '||pi_nqv_sequence
                                              ||CHR(10)||'nqv_nmq_id      => '||pi_nqv_nmq_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmqv');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_query_values (NMQV_PK)'
                                              ||CHR(10)||'nqv_nqt_seq_no  => '||pi_nqv_nqt_seq_no
                                              ||CHR(10)||'nqv_attrib_name => '||pi_nqv_attrib_name
                                              ||CHR(10)||'nqv_sequence    => '||pi_nqv_sequence
                                              ||CHR(10)||'nqv_nmq_id      => '||pi_nqv_nmq_id
                    );
--
END lock_nmqv;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMQV_PK constraint
--
PROCEDURE lock_nmqv (pi_nqv_nqt_seq_no    nm_mrg_query_values.nqv_nqt_seq_no%TYPE
                    ,pi_nqv_attrib_name   nm_mrg_query_values.nqv_attrib_name%TYPE
                    ,pi_nqv_sequence      nm_mrg_query_values.nqv_sequence%TYPE
                    ,pi_nqv_nmq_id        nm_mrg_query_values.nqv_nmq_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmqv');
--
   l_rowid := lock_nmqv
                   (pi_nqv_nqt_seq_no    => pi_nqv_nqt_seq_no
                   ,pi_nqv_attrib_name   => pi_nqv_attrib_name
                   ,pi_nqv_sequence      => pi_nqv_sequence
                   ,pi_nqv_nmq_id        => pi_nqv_nmq_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmqv');
--
END lock_nmqv;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMS_PK constraint
--
FUNCTION lock_nms (pi_nms_mrg_job_id     nm_mrg_sections.nms_mrg_job_id%TYPE
                  ,pi_nms_mrg_section_id nm_mrg_sections.nms_mrg_section_id%TYPE
                  ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nms IS
   SELECT /*+ INDEX (nms NMS_PK) */ ROWID
    FROM  nm_mrg_sections nms
   WHERE  nms.nms_mrg_job_id     = pi_nms_mrg_job_id
    AND   nms.nms_mrg_section_id = pi_nms_mrg_section_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nms');
--
   OPEN  cs_nms;
   FETCH cs_nms INTO l_retval;
   l_found := cs_nms%FOUND;
   CLOSE cs_nms;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_sections (NMS_PK)'
                                              ||CHR(10)||'nms_mrg_job_id     => '||pi_nms_mrg_job_id
                                              ||CHR(10)||'nms_mrg_section_id => '||pi_nms_mrg_section_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nms');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_sections (NMS_PK)'
                                              ||CHR(10)||'nms_mrg_job_id     => '||pi_nms_mrg_job_id
                                              ||CHR(10)||'nms_mrg_section_id => '||pi_nms_mrg_section_id
                    );
--
END lock_nms;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMS_PK constraint
--
PROCEDURE lock_nms (pi_nms_mrg_job_id     nm_mrg_sections.nms_mrg_job_id%TYPE
                   ,pi_nms_mrg_section_id nm_mrg_sections.nms_mrg_section_id%TYPE
                   ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nms');
--
   l_rowid := lock_nms
                   (pi_nms_mrg_job_id     => pi_nms_mrg_job_id
                   ,pi_nms_mrg_section_id => pi_nms_mrg_section_id
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nms');
--
END lock_nms;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMS_PK constraint
--
FUNCTION lock_nms_all (pi_nms_mrg_job_id     nm_mrg_sections_all.nms_mrg_job_id%TYPE
                      ,pi_nms_mrg_section_id nm_mrg_sections_all.nms_mrg_section_id%TYPE
                      ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_nms_all IS
   SELECT /*+ INDEX (nms_all NMS_PK) */ ROWID
    FROM  nm_mrg_sections_all nms_all
   WHERE  nms_all.nms_mrg_job_id     = pi_nms_mrg_job_id
    AND   nms_all.nms_mrg_section_id = pi_nms_mrg_section_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nms_all');
--
   OPEN  cs_nms_all;
   FETCH cs_nms_all INTO l_retval;
   l_found := cs_nms_all%FOUND;
   CLOSE cs_nms_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_sections_all (NMS_PK)'
                                              ||CHR(10)||'nms_mrg_job_id     => '||pi_nms_mrg_job_id
                                              ||CHR(10)||'nms_mrg_section_id => '||pi_nms_mrg_section_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nms_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_sections_all (NMS_PK)'
                                              ||CHR(10)||'nms_mrg_job_id     => '||pi_nms_mrg_job_id
                                              ||CHR(10)||'nms_mrg_section_id => '||pi_nms_mrg_section_id
                    );
--
END lock_nms_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMS_PK constraint
--
PROCEDURE lock_nms_all (pi_nms_mrg_job_id     nm_mrg_sections_all.nms_mrg_job_id%TYPE
                       ,pi_nms_mrg_section_id nm_mrg_sections_all.nms_mrg_section_id%TYPE
                       ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nms_all');
--
   l_rowid := lock_nms_all
                   (pi_nms_mrg_job_id     => pi_nms_mrg_job_id
                   ,pi_nms_mrg_section_id => pi_nms_mrg_section_id
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nms_all');
--
END lock_nms_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMSIV_PK constraint
--
FUNCTION lock_nsv (pi_nsv_mrg_job_id    nm_mrg_section_inv_values.nsv_mrg_job_id%TYPE
                  ,pi_nsv_value_id      nm_mrg_section_inv_values.nsv_value_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nsv IS
   SELECT /*+ INDEX (nsv NMSIV_PK) */ ROWID
    FROM  nm_mrg_section_inv_values nsv
   WHERE  nsv.nsv_mrg_job_id = pi_nsv_mrg_job_id
    AND   nsv.nsv_value_id   = pi_nsv_value_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsv');
--
   OPEN  cs_nsv;
   FETCH cs_nsv INTO l_retval;
   l_found := cs_nsv%FOUND;
   CLOSE cs_nsv;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_section_inv_values (NMSIV_PK)'
                                              ||CHR(10)||'nsv_mrg_job_id => '||pi_nsv_mrg_job_id
                                              ||CHR(10)||'nsv_value_id   => '||pi_nsv_value_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nsv');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_section_inv_values (NMSIV_PK)'
                                              ||CHR(10)||'nsv_mrg_job_id => '||pi_nsv_mrg_job_id
                                              ||CHR(10)||'nsv_value_id   => '||pi_nsv_value_id
                    );
--
END lock_nsv;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMSIV_PK constraint
--
PROCEDURE lock_nsv (pi_nsv_mrg_job_id    nm_mrg_section_inv_values.nsv_mrg_job_id%TYPE
                   ,pi_nsv_value_id      nm_mrg_section_inv_values.nsv_value_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsv');
--
   l_rowid := lock_nsv
                   (pi_nsv_mrg_job_id    => pi_nsv_mrg_job_id
                   ,pi_nsv_value_id      => pi_nsv_value_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nsv');
--
END lock_nsv;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMSIV_PK constraint
--
FUNCTION lock_nsv_all (pi_nsv_mrg_job_id    nm_mrg_section_inv_values_all.nsv_mrg_job_id%TYPE
                      ,pi_nsv_value_id      nm_mrg_section_inv_values_all.nsv_value_id%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_nsv_all IS
   SELECT /*+ INDEX (nsv_all NMSIV_PK) */ ROWID
    FROM  nm_mrg_section_inv_values_all nsv_all
   WHERE  nsv_all.nsv_mrg_job_id = pi_nsv_mrg_job_id
    AND   nsv_all.nsv_value_id   = pi_nsv_value_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsv_all');
--
   OPEN  cs_nsv_all;
   FETCH cs_nsv_all INTO l_retval;
   l_found := cs_nsv_all%FOUND;
   CLOSE cs_nsv_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_section_inv_values_all (NMSIV_PK)'
                                              ||CHR(10)||'nsv_mrg_job_id => '||pi_nsv_mrg_job_id
                                              ||CHR(10)||'nsv_value_id   => '||pi_nsv_value_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nsv_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_section_inv_values_all (NMSIV_PK)'
                                              ||CHR(10)||'nsv_mrg_job_id => '||pi_nsv_mrg_job_id
                                              ||CHR(10)||'nsv_value_id   => '||pi_nsv_value_id
                    );
--
END lock_nsv_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMSIV_PK constraint
--
PROCEDURE lock_nsv_all (pi_nsv_mrg_job_id    nm_mrg_section_inv_values_all.nsv_mrg_job_id%TYPE
                       ,pi_nsv_value_id      nm_mrg_section_inv_values_all.nsv_value_id%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsv_all');
--
   l_rowid := lock_nsv_all
                   (pi_nsv_mrg_job_id    => pi_nsv_mrg_job_id
                   ,pi_nsv_value_id      => pi_nsv_value_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nsv_all');
--
END lock_nsv_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMSM_PK constraint
--
FUNCTION lock_nmsm (pi_nsm_mrg_job_id     nm_mrg_section_members.nsm_mrg_job_id%TYPE
                   ,pi_nsm_mrg_section_id nm_mrg_section_members.nsm_mrg_section_id%TYPE
                   ,pi_nsm_ne_id          nm_mrg_section_members.nsm_ne_id%TYPE
                   ,pi_nsm_begin_mp       nm_mrg_section_members.nsm_begin_mp%TYPE
                   ,pi_nsm_end_mp         nm_mrg_section_members.nsm_end_mp%TYPE
                   ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nmsm IS
   SELECT /*+ INDEX (nmsm NMSM_PK) */ ROWID
    FROM  nm_mrg_section_members nmsm
   WHERE  nmsm.nsm_mrg_job_id     = pi_nsm_mrg_job_id
    AND   nmsm.nsm_mrg_section_id = pi_nsm_mrg_section_id
    AND   nmsm.nsm_ne_id          = pi_nsm_ne_id
    AND   nmsm.nsm_begin_mp       = pi_nsm_begin_mp
    AND   nmsm.nsm_end_mp         = pi_nsm_end_mp
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmsm');
--
   OPEN  cs_nmsm;
   FETCH cs_nmsm INTO l_retval;
   l_found := cs_nmsm%FOUND;
   CLOSE cs_nmsm;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_section_members (NMSM_PK)'
                                              ||CHR(10)||'nsm_mrg_job_id     => '||pi_nsm_mrg_job_id
                                              ||CHR(10)||'nsm_mrg_section_id => '||pi_nsm_mrg_section_id
                                              ||CHR(10)||'nsm_ne_id          => '||pi_nsm_ne_id
                                              ||CHR(10)||'nsm_begin_mp       => '||pi_nsm_begin_mp
                                              ||CHR(10)||'nsm_end_mp         => '||pi_nsm_end_mp
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmsm');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mrg_section_members (NMSM_PK)'
                                              ||CHR(10)||'nsm_mrg_job_id     => '||pi_nsm_mrg_job_id
                                              ||CHR(10)||'nsm_mrg_section_id => '||pi_nsm_mrg_section_id
                                              ||CHR(10)||'nsm_ne_id          => '||pi_nsm_ne_id
                                              ||CHR(10)||'nsm_begin_mp       => '||pi_nsm_begin_mp
                                              ||CHR(10)||'nsm_end_mp         => '||pi_nsm_end_mp
                    );
--
END lock_nmsm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMSM_PK constraint
--
PROCEDURE lock_nmsm (pi_nsm_mrg_job_id     nm_mrg_section_members.nsm_mrg_job_id%TYPE
                    ,pi_nsm_mrg_section_id nm_mrg_section_members.nsm_mrg_section_id%TYPE
                    ,pi_nsm_ne_id          nm_mrg_section_members.nsm_ne_id%TYPE
                    ,pi_nsm_begin_mp       nm_mrg_section_members.nsm_begin_mp%TYPE
                    ,pi_nsm_end_mp         nm_mrg_section_members.nsm_end_mp%TYPE
                    ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmsm');
--
   l_rowid := lock_nmsm
                   (pi_nsm_mrg_job_id     => pi_nsm_mrg_job_id
                   ,pi_nsm_mrg_section_id => pi_nsm_mrg_section_id
                   ,pi_nsm_ne_id          => pi_nsm_ne_id
                   ,pi_nsm_begin_mp       => pi_nsm_begin_mp
                   ,pi_nsm_end_mp         => pi_nsm_end_mp
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmsm');
--
END lock_nmsm;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NN_PK constraint
--
FUNCTION lock_no (pi_no_node_id        nm_nodes.no_node_id%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) RETURN ROWID IS
--
   CURSOR cs_no IS
   SELECT /*+ INDEX (no NN_PK) */ ROWID
    FROM  nm_nodes no
   WHERE  no.no_node_id = pi_no_node_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_no');
--
   OPEN  cs_no;
   FETCH cs_no INTO l_retval;
   l_found := cs_no%FOUND;
   CLOSE cs_no;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_nodes (NN_PK)'
                                              ||CHR(10)||'no_node_id => '||pi_no_node_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_no');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_nodes (NN_PK)'
                                              ||CHR(10)||'no_node_id => '||pi_no_node_id
                    );
--
END lock_no;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NN_PK constraint
--
PROCEDURE lock_no (pi_no_node_id        nm_nodes.no_node_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_no');
--
   l_rowid := lock_no
                   (pi_no_node_id        => pi_no_node_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_no');
--
END lock_no;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NN_UK constraint
--
FUNCTION lock_no (pi_no_node_name      nm_nodes.no_node_name%TYPE
                 ,pi_no_node_type      nm_nodes.no_node_type%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) RETURN ROWID IS
--
   CURSOR cs_no IS
   SELECT /*+ INDEX (no NN_UK) */ ROWID
    FROM  nm_nodes no
   WHERE  no.no_node_name = pi_no_node_name
    AND   no.no_node_type = pi_no_node_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_no');
--
   OPEN  cs_no;
   FETCH cs_no INTO l_retval;
   l_found := cs_no%FOUND;
   CLOSE cs_no;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_nodes (NN_UK)'
                                              ||CHR(10)||'no_node_name => '||pi_no_node_name
                                              ||CHR(10)||'no_node_type => '||pi_no_node_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_no');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_nodes (NN_UK)'
                                              ||CHR(10)||'no_node_name => '||pi_no_node_name
                                              ||CHR(10)||'no_node_type => '||pi_no_node_type
                    );
--
END lock_no;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NN_UK constraint
--
PROCEDURE lock_no (pi_no_node_name      nm_nodes.no_node_name%TYPE
                  ,pi_no_node_type      nm_nodes.no_node_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_no');
--
   l_rowid := lock_no
                   (pi_no_node_name      => pi_no_node_name
                   ,pi_no_node_type      => pi_no_node_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_no');
--
END lock_no;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NN_PK constraint
--
FUNCTION lock_no_all (pi_no_node_id        nm_nodes_all.no_node_id%TYPE
                     ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                     ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                     ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                     ) RETURN ROWID IS
--
   CURSOR cs_no_all IS
   SELECT /*+ INDEX (no_all NN_PK) */ ROWID
    FROM  nm_nodes_all no_all
   WHERE  no_all.no_node_id = pi_no_node_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_no_all');
--
   OPEN  cs_no_all;
   FETCH cs_no_all INTO l_retval;
   l_found := cs_no_all%FOUND;
   CLOSE cs_no_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_nodes_all (NN_PK)'
                                              ||CHR(10)||'no_node_id => '||pi_no_node_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_no_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_nodes_all (NN_PK)'
                                              ||CHR(10)||'no_node_id => '||pi_no_node_id
                    );
--
END lock_no_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NN_PK constraint
--
PROCEDURE lock_no_all (pi_no_node_id        nm_nodes_all.no_node_id%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_no_all');
--
   l_rowid := lock_no_all
                   (pi_no_node_id        => pi_no_node_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_no_all');
--
END lock_no_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NN_UK constraint
--
FUNCTION lock_no_all (pi_no_node_name      nm_nodes_all.no_node_name%TYPE
                     ,pi_no_node_type      nm_nodes_all.no_node_type%TYPE
                     ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                     ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                     ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                     ) RETURN ROWID IS
--
   CURSOR cs_no_all IS
   SELECT /*+ INDEX (no_all NN_UK) */ ROWID
    FROM  nm_nodes_all no_all
   WHERE  no_all.no_node_name = pi_no_node_name
    AND   no_all.no_node_type = pi_no_node_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_no_all');
--
   OPEN  cs_no_all;
   FETCH cs_no_all INTO l_retval;
   l_found := cs_no_all%FOUND;
   CLOSE cs_no_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_nodes_all (NN_UK)'
                                              ||CHR(10)||'no_node_name => '||pi_no_node_name
                                              ||CHR(10)||'no_node_type => '||pi_no_node_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_no_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_nodes_all (NN_UK)'
                                              ||CHR(10)||'no_node_name => '||pi_no_node_name
                                              ||CHR(10)||'no_node_type => '||pi_no_node_type
                    );
--
END lock_no_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NN_UK constraint
--
PROCEDURE lock_no_all (pi_no_node_name      nm_nodes_all.no_node_name%TYPE
                      ,pi_no_node_type      nm_nodes_all.no_node_type%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_no_all');
--
   l_rowid := lock_no_all
                   (pi_no_node_name      => pi_no_node_name
                   ,pi_no_node_type      => pi_no_node_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_no_all');
--
END lock_no_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NNT_PK constraint
--
FUNCTION lock_nnt (pi_nnt_type          nm_node_types.nnt_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nnt IS
   SELECT /*+ INDEX (nnt NNT_PK) */ ROWID
    FROM  nm_node_types nnt
   WHERE  nnt.nnt_type = pi_nnt_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nnt');
--
   OPEN  cs_nnt;
   FETCH cs_nnt INTO l_retval;
   l_found := cs_nnt%FOUND;
   CLOSE cs_nnt;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_node_types (NNT_PK)'
                                              ||CHR(10)||'nnt_type => '||pi_nnt_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nnt');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_node_types (NNT_PK)'
                                              ||CHR(10)||'nnt_type => '||pi_nnt_type
                    );
--
END lock_nnt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NNT_PK constraint
--
PROCEDURE lock_nnt (pi_nnt_type          nm_node_types.nnt_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nnt');
--
   l_rowid := lock_nnt
                   (pi_nnt_type          => pi_nnt_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nnt');
--
END lock_nnt;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NNU_PK constraint
--
FUNCTION lock_nnu (pi_nnu_ne_id         nm_node_usages.nnu_ne_id%TYPE
                  ,pi_nnu_chain         nm_node_usages.nnu_chain%TYPE
                  ,pi_nnu_no_node_id    nm_node_usages.nnu_no_node_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nnu IS
   SELECT /*+ INDEX (nnu NNU_PK) */ ROWID
    FROM  nm_node_usages nnu
   WHERE  nnu.nnu_ne_id      = pi_nnu_ne_id
    AND   nnu.nnu_chain      = pi_nnu_chain
    AND   nnu.nnu_no_node_id = pi_nnu_no_node_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nnu');
--
   OPEN  cs_nnu;
   FETCH cs_nnu INTO l_retval;
   l_found := cs_nnu%FOUND;
   CLOSE cs_nnu;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_node_usages (NNU_PK)'
                                              ||CHR(10)||'nnu_ne_id      => '||pi_nnu_ne_id
                                              ||CHR(10)||'nnu_chain      => '||pi_nnu_chain
                                              ||CHR(10)||'nnu_no_node_id => '||pi_nnu_no_node_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nnu');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_node_usages (NNU_PK)'
                                              ||CHR(10)||'nnu_ne_id      => '||pi_nnu_ne_id
                                              ||CHR(10)||'nnu_chain      => '||pi_nnu_chain
                                              ||CHR(10)||'nnu_no_node_id => '||pi_nnu_no_node_id
                    );
--
END lock_nnu;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NNU_PK constraint
--
PROCEDURE lock_nnu (pi_nnu_ne_id         nm_node_usages.nnu_ne_id%TYPE
                   ,pi_nnu_chain         nm_node_usages.nnu_chain%TYPE
                   ,pi_nnu_no_node_id    nm_node_usages.nnu_no_node_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nnu');
--
   l_rowid := lock_nnu
                   (pi_nnu_ne_id         => pi_nnu_ne_id
                   ,pi_nnu_chain         => pi_nnu_chain
                   ,pi_nnu_no_node_id    => pi_nnu_no_node_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nnu');
--
END lock_nnu;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NNU_PK constraint
--
FUNCTION lock_nnu_all (pi_nnu_ne_id         nm_node_usages_all.nnu_ne_id%TYPE
                      ,pi_nnu_chain         nm_node_usages_all.nnu_chain%TYPE
                      ,pi_nnu_no_node_id    nm_node_usages_all.nnu_no_node_id%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_nnu_all IS
   SELECT /*+ INDEX (nnu_all NNU_PK) */ ROWID
    FROM  nm_node_usages_all nnu_all
   WHERE  nnu_all.nnu_ne_id      = pi_nnu_ne_id
    AND   nnu_all.nnu_chain      = pi_nnu_chain
    AND   nnu_all.nnu_no_node_id = pi_nnu_no_node_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nnu_all');
--
   OPEN  cs_nnu_all;
   FETCH cs_nnu_all INTO l_retval;
   l_found := cs_nnu_all%FOUND;
   CLOSE cs_nnu_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_node_usages_all (NNU_PK)'
                                              ||CHR(10)||'nnu_ne_id      => '||pi_nnu_ne_id
                                              ||CHR(10)||'nnu_chain      => '||pi_nnu_chain
                                              ||CHR(10)||'nnu_no_node_id => '||pi_nnu_no_node_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nnu_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_node_usages_all (NNU_PK)'
                                              ||CHR(10)||'nnu_ne_id      => '||pi_nnu_ne_id
                                              ||CHR(10)||'nnu_chain      => '||pi_nnu_chain
                                              ||CHR(10)||'nnu_no_node_id => '||pi_nnu_no_node_id
                    );
--
END lock_nnu_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NNU_PK constraint
--
PROCEDURE lock_nnu_all (pi_nnu_ne_id         nm_node_usages_all.nnu_ne_id%TYPE
                       ,pi_nnu_chain         nm_node_usages_all.nnu_chain%TYPE
                       ,pi_nnu_no_node_id    nm_node_usages_all.nnu_no_node_id%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nnu_all');
--
   l_rowid := lock_nnu_all
                   (pi_nnu_ne_id         => pi_nnu_ne_id
                   ,pi_nnu_chain         => pi_nnu_chain
                   ,pi_nnu_no_node_id    => pi_nnu_no_node_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nnu_all');
--
END lock_nnu_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NNG_PK constraint
--
FUNCTION lock_nng (pi_nng_group_type    nm_nt_groupings.nng_group_type%TYPE
                  ,pi_nng_nt_type       nm_nt_groupings.nng_nt_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nng IS
   SELECT /*+ INDEX (nng NNG_PK) */ ROWID
    FROM  nm_nt_groupings nng
   WHERE  nng.nng_group_type = pi_nng_group_type
    AND   nng.nng_nt_type    = pi_nng_nt_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nng');
--
   OPEN  cs_nng;
   FETCH cs_nng INTO l_retval;
   l_found := cs_nng%FOUND;
   CLOSE cs_nng;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_nt_groupings (NNG_PK)'
                                              ||CHR(10)||'nng_group_type => '||pi_nng_group_type
                                              ||CHR(10)||'nng_nt_type    => '||pi_nng_nt_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nng');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_nt_groupings (NNG_PK)'
                                              ||CHR(10)||'nng_group_type => '||pi_nng_group_type
                                              ||CHR(10)||'nng_nt_type    => '||pi_nng_nt_type
                    );
--
END lock_nng;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NNG_PK constraint
--
PROCEDURE lock_nng (pi_nng_group_type    nm_nt_groupings.nng_group_type%TYPE
                   ,pi_nng_nt_type       nm_nt_groupings.nng_nt_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nng');
--
   l_rowid := lock_nng
                   (pi_nng_group_type    => pi_nng_group_type
                   ,pi_nng_nt_type       => pi_nng_nt_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nng');
--
END lock_nng;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NNG_PK constraint
--
FUNCTION lock_nng_all (pi_nng_group_type    nm_nt_groupings_all.nng_group_type%TYPE
                      ,pi_nng_nt_type       nm_nt_groupings_all.nng_nt_type%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_nng_all IS
   SELECT /*+ INDEX (nng_all NNG_PK) */ ROWID
    FROM  nm_nt_groupings_all nng_all
   WHERE  nng_all.nng_group_type = pi_nng_group_type
    AND   nng_all.nng_nt_type    = pi_nng_nt_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nng_all');
--
   OPEN  cs_nng_all;
   FETCH cs_nng_all INTO l_retval;
   l_found := cs_nng_all%FOUND;
   CLOSE cs_nng_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_nt_groupings_all (NNG_PK)'
                                              ||CHR(10)||'nng_group_type => '||pi_nng_group_type
                                              ||CHR(10)||'nng_nt_type    => '||pi_nng_nt_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nng_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_nt_groupings_all (NNG_PK)'
                                              ||CHR(10)||'nng_group_type => '||pi_nng_group_type
                                              ||CHR(10)||'nng_nt_type    => '||pi_nng_nt_type
                    );
--
END lock_nng_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NNG_PK constraint
--
PROCEDURE lock_nng_all (pi_nng_group_type    nm_nt_groupings_all.nng_group_type%TYPE
                       ,pi_nng_nt_type       nm_nt_groupings_all.nng_nt_type%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nng_all');
--
   l_rowid := lock_nng_all
                   (pi_nng_group_type    => pi_nng_group_type
                   ,pi_nng_nt_type       => pi_nng_nt_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nng_all');
--
END lock_nng_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NAD_ID_PK constraint
--
FUNCTION lock_nad (pi_nad_id            nm_nw_ad_types.nad_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nad IS
   SELECT /*+ INDEX (nad NAD_ID_PK) */ ROWID
    FROM  nm_nw_ad_types nad
   WHERE  nad.nad_id = pi_nad_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nad');
--
   OPEN  cs_nad;
   FETCH cs_nad INTO l_retval;
   l_found := cs_nad%FOUND;
   CLOSE cs_nad;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_nw_ad_types (NAD_ID_PK)'
                                              ||CHR(10)||'nad_id => '||pi_nad_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nad');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_nw_ad_types (NAD_ID_PK)'
                                              ||CHR(10)||'nad_id => '||pi_nad_id
                    );
--
END lock_nad;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NAD_ID_PK constraint
--
PROCEDURE lock_nad (pi_nad_id            nm_nw_ad_types.nad_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nad');
--
   l_rowid := lock_nad
                   (pi_nad_id            => pi_nad_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nad');
--
END lock_nad;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NPE_PK constraint
--
FUNCTION lock_npe (pi_npe_job_id        nm_nw_persistent_extents.npe_job_id%TYPE
                  ,pi_npe_ne_id_of      nm_nw_persistent_extents.npe_ne_id_of%TYPE
                  ,pi_npe_begin_mp      nm_nw_persistent_extents.npe_begin_mp%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_npe IS
   SELECT /*+ INDEX (npe NPE_PK) */ ROWID
    FROM  nm_nw_persistent_extents npe
   WHERE  npe.npe_job_id   = pi_npe_job_id
    AND   npe.npe_ne_id_of = pi_npe_ne_id_of
    AND   npe.npe_begin_mp = pi_npe_begin_mp
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_npe');
--
   OPEN  cs_npe;
   FETCH cs_npe INTO l_retval;
   l_found := cs_npe%FOUND;
   CLOSE cs_npe;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_nw_persistent_extents (NPE_PK)'
                                              ||CHR(10)||'npe_job_id   => '||pi_npe_job_id
                                              ||CHR(10)||'npe_ne_id_of => '||pi_npe_ne_id_of
                                              ||CHR(10)||'npe_begin_mp => '||pi_npe_begin_mp
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_npe');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_nw_persistent_extents (NPE_PK)'
                                              ||CHR(10)||'npe_job_id   => '||pi_npe_job_id
                                              ||CHR(10)||'npe_ne_id_of => '||pi_npe_ne_id_of
                                              ||CHR(10)||'npe_begin_mp => '||pi_npe_begin_mp
                    );
--
END lock_npe;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NPE_PK constraint
--
PROCEDURE lock_npe (pi_npe_job_id        nm_nw_persistent_extents.npe_job_id%TYPE
                   ,pi_npe_ne_id_of      nm_nw_persistent_extents.npe_ne_id_of%TYPE
                   ,pi_npe_begin_mp      nm_nw_persistent_extents.npe_begin_mp%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_npe');
--
   l_rowid := lock_npe
                   (pi_npe_job_id        => pi_npe_job_id
                   ,pi_npe_ne_id_of      => pi_npe_ne_id_of
                   ,pi_npe_begin_mp      => pi_npe_begin_mp
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_npe');
--
END lock_npe;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NNTH_PK constraint
--
FUNCTION lock_nnth (pi_nnth_nlt_id       nm_nw_themes.nnth_nlt_id%TYPE
                   ,pi_nnth_nth_theme_id nm_nw_themes.nnth_nth_theme_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nnth IS
   SELECT /*+ INDEX (nnth NNTH_PK) */ ROWID
    FROM  nm_nw_themes nnth
   WHERE  nnth.nnth_nlt_id       = pi_nnth_nlt_id
    AND   nnth.nnth_nth_theme_id = pi_nnth_nth_theme_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nnth');
--
   OPEN  cs_nnth;
   FETCH cs_nnth INTO l_retval;
   l_found := cs_nnth%FOUND;
   CLOSE cs_nnth;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_nw_themes (NNTH_PK)'
                                              ||CHR(10)||'nnth_nlt_id       => '||pi_nnth_nlt_id
                                              ||CHR(10)||'nnth_nth_theme_id => '||pi_nnth_nth_theme_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nnth');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_nw_themes (NNTH_PK)'
                                              ||CHR(10)||'nnth_nlt_id       => '||pi_nnth_nlt_id
                                              ||CHR(10)||'nnth_nth_theme_id => '||pi_nnth_nth_theme_id
                    );
--
END lock_nnth;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NNTH_PK constraint
--
PROCEDURE lock_nnth (pi_nnth_nlt_id       nm_nw_themes.nnth_nlt_id%TYPE
                    ,pi_nnth_nth_theme_id nm_nw_themes.nnth_nth_theme_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nnth');
--
   l_rowid := lock_nnth
                   (pi_nnth_nlt_id       => pi_nnth_nlt_id
                   ,pi_nnth_nth_theme_id => pi_nnth_nth_theme_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nnth');
--
END lock_nnth;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMO_PK constraint
--
FUNCTION lock_nmo (pi_nmo_operation     nm_operations.nmo_operation%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nmo IS
   SELECT /*+ INDEX (nmo NMO_PK) */ ROWID
    FROM  nm_operations nmo
   WHERE  nmo.nmo_operation = pi_nmo_operation
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmo');
--
   OPEN  cs_nmo;
   FETCH cs_nmo INTO l_retval;
   l_found := cs_nmo%FOUND;
   CLOSE cs_nmo;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_operations (NMO_PK)'
                                              ||CHR(10)||'nmo_operation => '||pi_nmo_operation
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmo');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_operations (NMO_PK)'
                                              ||CHR(10)||'nmo_operation => '||pi_nmo_operation
                    );
--
END lock_nmo;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMO_PK constraint
--
PROCEDURE lock_nmo (pi_nmo_operation     nm_operations.nmo_operation%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmo');
--
   l_rowid := lock_nmo
                   (pi_nmo_operation     => pi_nmo_operation
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmo');
--
END lock_nmo;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NOD_PK constraint
--
FUNCTION lock_nod (pi_nod_nmo_operation nm_operation_data.nod_nmo_operation%TYPE
                  ,pi_nod_data_item     nm_operation_data.nod_data_item%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nod IS
   SELECT /*+ INDEX (nod NOD_PK) */ ROWID
    FROM  nm_operation_data nod
   WHERE  nod.nod_nmo_operation = pi_nod_nmo_operation
    AND   nod.nod_data_item     = pi_nod_data_item
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nod');
--
   OPEN  cs_nod;
   FETCH cs_nod INTO l_retval;
   l_found := cs_nod%FOUND;
   CLOSE cs_nod;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_operation_data (NOD_PK)'
                                              ||CHR(10)||'nod_nmo_operation => '||pi_nod_nmo_operation
                                              ||CHR(10)||'nod_data_item     => '||pi_nod_data_item
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nod');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_operation_data (NOD_PK)'
                                              ||CHR(10)||'nod_nmo_operation => '||pi_nod_nmo_operation
                                              ||CHR(10)||'nod_data_item     => '||pi_nod_data_item
                    );
--
END lock_nod;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NOD_PK constraint
--
PROCEDURE lock_nod (pi_nod_nmo_operation nm_operation_data.nod_nmo_operation%TYPE
                   ,pi_nod_data_item     nm_operation_data.nod_data_item%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nod');
--
   l_rowid := lock_nod
                   (pi_nod_nmo_operation => pi_nod_nmo_operation
                   ,pi_nod_data_item     => pi_nod_data_item
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nod');
--
END lock_nod;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NOD_UK constraint
--
FUNCTION lock_nod (pi_nod_nmo_operation nm_operation_data.nod_nmo_operation%TYPE
                  ,pi_nod_seq           nm_operation_data.nod_seq%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nod IS
   SELECT /*+ INDEX (nod NOD_UK) */ ROWID
    FROM  nm_operation_data nod
   WHERE  nod.nod_nmo_operation = pi_nod_nmo_operation
    AND   nod.nod_seq           = pi_nod_seq
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nod');
--
   OPEN  cs_nod;
   FETCH cs_nod INTO l_retval;
   l_found := cs_nod%FOUND;
   CLOSE cs_nod;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_operation_data (NOD_UK)'
                                              ||CHR(10)||'nod_nmo_operation => '||pi_nod_nmo_operation
                                              ||CHR(10)||'nod_seq           => '||pi_nod_seq
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nod');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_operation_data (NOD_UK)'
                                              ||CHR(10)||'nod_nmo_operation => '||pi_nod_nmo_operation
                                              ||CHR(10)||'nod_seq           => '||pi_nod_seq
                    );
--
END lock_nod;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NOD_UK constraint
--
PROCEDURE lock_nod (pi_nod_nmo_operation nm_operation_data.nod_nmo_operation%TYPE
                   ,pi_nod_seq           nm_operation_data.nod_seq%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nod');
--
   l_rowid := lock_nod
                   (pi_nod_nmo_operation => pi_nod_nmo_operation
                   ,pi_nod_seq           => pi_nod_seq
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nod');
--
END lock_nod;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NOD_SCRN_TEXT_UK constraint
--
FUNCTION lock_nod (pi_nod_nmo_operation nm_operation_data.nod_nmo_operation%TYPE
                  ,pi_nod_scrn_text     nm_operation_data.nod_scrn_text%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nod IS
   SELECT /*+ INDEX (nod NOD_SCRN_TEXT_UK) */ ROWID
    FROM  nm_operation_data nod
   WHERE  nod.nod_nmo_operation = pi_nod_nmo_operation
    AND   nod.nod_scrn_text     = pi_nod_scrn_text
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nod');
--
   OPEN  cs_nod;
   FETCH cs_nod INTO l_retval;
   l_found := cs_nod%FOUND;
   CLOSE cs_nod;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_operation_data (NOD_SCRN_TEXT_UK)'
                                              ||CHR(10)||'nod_nmo_operation => '||pi_nod_nmo_operation
                                              ||CHR(10)||'nod_scrn_text     => '||pi_nod_scrn_text
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nod');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_operation_data (NOD_SCRN_TEXT_UK)'
                                              ||CHR(10)||'nod_nmo_operation => '||pi_nod_nmo_operation
                                              ||CHR(10)||'nod_scrn_text     => '||pi_nod_scrn_text
                    );
--
END lock_nod;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NOD_SCRN_TEXT_UK constraint
--
PROCEDURE lock_nod (pi_nod_nmo_operation nm_operation_data.nod_nmo_operation%TYPE
                   ,pi_nod_scrn_text     nm_operation_data.nod_scrn_text%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nod');
--
   l_rowid := lock_nod
                   (pi_nod_nmo_operation => pi_nod_nmo_operation
                   ,pi_nod_scrn_text     => pi_nod_scrn_text
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nod');
--
END lock_nod;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NPQ_PK constraint
--
FUNCTION lock_npq (pi_npq_id            nm_pbi_query.npq_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_npq IS
   SELECT /*+ INDEX (npq NPQ_PK) */ ROWID
    FROM  nm_pbi_query npq
   WHERE  npq.npq_id = pi_npq_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_npq');
--
   OPEN  cs_npq;
   FETCH cs_npq INTO l_retval;
   l_found := cs_npq%FOUND;
   CLOSE cs_npq;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_pbi_query (NPQ_PK)'
                                              ||CHR(10)||'npq_id => '||pi_npq_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_npq');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_pbi_query (NPQ_PK)'
                                              ||CHR(10)||'npq_id => '||pi_npq_id
                    );
--
END lock_npq;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NPQ_PK constraint
--
PROCEDURE lock_npq (pi_npq_id            nm_pbi_query.npq_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_npq');
--
   l_rowid := lock_npq
                   (pi_npq_id            => pi_npq_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_npq');
--
END lock_npq;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NPQ_UK constraint
--
FUNCTION lock_npq (pi_npq_unique        nm_pbi_query.npq_unique%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_npq IS
   SELECT /*+ INDEX (npq NPQ_UK) */ ROWID
    FROM  nm_pbi_query npq
   WHERE  npq.npq_unique = pi_npq_unique
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_npq');
--
   OPEN  cs_npq;
   FETCH cs_npq INTO l_retval;
   l_found := cs_npq%FOUND;
   CLOSE cs_npq;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_pbi_query (NPQ_UK)'
                                              ||CHR(10)||'npq_unique => '||pi_npq_unique
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_npq');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_pbi_query (NPQ_UK)'
                                              ||CHR(10)||'npq_unique => '||pi_npq_unique
                    );
--
END lock_npq;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NPQ_UK constraint
--
PROCEDURE lock_npq (pi_npq_unique        nm_pbi_query.npq_unique%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_npq');
--
   l_rowid := lock_npq
                   (pi_npq_unique        => pi_npq_unique
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_npq');
--
END lock_npq;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NQA_PK constraint
--
FUNCTION lock_npqa (pi_nqa_npq_id        nm_pbi_query_attribs.nqa_npq_id%TYPE
                   ,pi_nqa_nqt_seq_no    nm_pbi_query_attribs.nqa_nqt_seq_no%TYPE
                   ,pi_nqa_seq_no        nm_pbi_query_attribs.nqa_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_npqa IS
   SELECT /*+ INDEX (npqa NQA_PK) */ ROWID
    FROM  nm_pbi_query_attribs npqa
   WHERE  npqa.nqa_npq_id     = pi_nqa_npq_id
    AND   npqa.nqa_nqt_seq_no = pi_nqa_nqt_seq_no
    AND   npqa.nqa_seq_no     = pi_nqa_seq_no
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_npqa');
--
   OPEN  cs_npqa;
   FETCH cs_npqa INTO l_retval;
   l_found := cs_npqa%FOUND;
   CLOSE cs_npqa;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_pbi_query_attribs (NQA_PK)'
                                              ||CHR(10)||'nqa_npq_id     => '||pi_nqa_npq_id
                                              ||CHR(10)||'nqa_nqt_seq_no => '||pi_nqa_nqt_seq_no
                                              ||CHR(10)||'nqa_seq_no     => '||pi_nqa_seq_no
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_npqa');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_pbi_query_attribs (NQA_PK)'
                                              ||CHR(10)||'nqa_npq_id     => '||pi_nqa_npq_id
                                              ||CHR(10)||'nqa_nqt_seq_no => '||pi_nqa_nqt_seq_no
                                              ||CHR(10)||'nqa_seq_no     => '||pi_nqa_seq_no
                    );
--
END lock_npqa;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NQA_PK constraint
--
PROCEDURE lock_npqa (pi_nqa_npq_id        nm_pbi_query_attribs.nqa_npq_id%TYPE
                    ,pi_nqa_nqt_seq_no    nm_pbi_query_attribs.nqa_nqt_seq_no%TYPE
                    ,pi_nqa_seq_no        nm_pbi_query_attribs.nqa_seq_no%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_npqa');
--
   l_rowid := lock_npqa
                   (pi_nqa_npq_id        => pi_nqa_npq_id
                   ,pi_nqa_nqt_seq_no    => pi_nqa_nqt_seq_no
                   ,pi_nqa_seq_no        => pi_nqa_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_npqa');
--
END lock_npqa;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NQR_PK constraint
--
FUNCTION lock_npqr (pi_nqr_npq_id        nm_pbi_query_results.nqr_npq_id%TYPE
                   ,pi_nqr_job_id        nm_pbi_query_results.nqr_job_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_npqr IS
   SELECT /*+ INDEX (npqr NQR_PK) */ ROWID
    FROM  nm_pbi_query_results npqr
   WHERE  npqr.nqr_npq_id = pi_nqr_npq_id
    AND   npqr.nqr_job_id = pi_nqr_job_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_npqr');
--
   OPEN  cs_npqr;
   FETCH cs_npqr INTO l_retval;
   l_found := cs_npqr%FOUND;
   CLOSE cs_npqr;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_pbi_query_results (NQR_PK)'
                                              ||CHR(10)||'nqr_npq_id => '||pi_nqr_npq_id
                                              ||CHR(10)||'nqr_job_id => '||pi_nqr_job_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_npqr');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_pbi_query_results (NQR_PK)'
                                              ||CHR(10)||'nqr_npq_id => '||pi_nqr_npq_id
                                              ||CHR(10)||'nqr_job_id => '||pi_nqr_job_id
                    );
--
END lock_npqr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NQR_PK constraint
--
PROCEDURE lock_npqr (pi_nqr_npq_id        nm_pbi_query_results.nqr_npq_id%TYPE
                    ,pi_nqr_job_id        nm_pbi_query_results.nqr_job_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_npqr');
--
   l_rowid := lock_npqr
                   (pi_nqr_npq_id        => pi_nqr_npq_id
                   ,pi_nqr_job_id        => pi_nqr_job_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_npqr');
--
END lock_npqr;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NQT_PK constraint
--
FUNCTION lock_npqt (pi_nqt_npq_id        nm_pbi_query_types.nqt_npq_id%TYPE
                   ,pi_nqt_seq_no        nm_pbi_query_types.nqt_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_npqt IS
   SELECT /*+ INDEX (npqt NQT_PK) */ ROWID
    FROM  nm_pbi_query_types npqt
   WHERE  npqt.nqt_npq_id = pi_nqt_npq_id
    AND   npqt.nqt_seq_no = pi_nqt_seq_no
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_npqt');
--
   OPEN  cs_npqt;
   FETCH cs_npqt INTO l_retval;
   l_found := cs_npqt%FOUND;
   CLOSE cs_npqt;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_pbi_query_types (NQT_PK)'
                                              ||CHR(10)||'nqt_npq_id => '||pi_nqt_npq_id
                                              ||CHR(10)||'nqt_seq_no => '||pi_nqt_seq_no
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_npqt');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_pbi_query_types (NQT_PK)'
                                              ||CHR(10)||'nqt_npq_id => '||pi_nqt_npq_id
                                              ||CHR(10)||'nqt_seq_no => '||pi_nqt_seq_no
                    );
--
END lock_npqt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NQT_PK constraint
--
PROCEDURE lock_npqt (pi_nqt_npq_id        nm_pbi_query_types.nqt_npq_id%TYPE
                    ,pi_nqt_seq_no        nm_pbi_query_types.nqt_seq_no%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_npqt');
--
   l_rowid := lock_npqt
                   (pi_nqt_npq_id        => pi_nqt_npq_id
                   ,pi_nqt_seq_no        => pi_nqt_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_npqt');
--
END lock_npqt;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NQV_PK constraint
--
FUNCTION lock_npqv (pi_nqv_sequence      nm_pbi_query_values.nqv_sequence%TYPE
                   ,pi_nqv_npq_id        nm_pbi_query_values.nqv_npq_id%TYPE
                   ,pi_nqv_nqt_seq_no    nm_pbi_query_values.nqv_nqt_seq_no%TYPE
                   ,pi_nqv_nqa_seq_no    nm_pbi_query_values.nqv_nqa_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_npqv IS
   SELECT /*+ INDEX (npqv NQV_PK) */ ROWID
    FROM  nm_pbi_query_values npqv
   WHERE  npqv.nqv_sequence   = pi_nqv_sequence
    AND   npqv.nqv_npq_id     = pi_nqv_npq_id
    AND   npqv.nqv_nqt_seq_no = pi_nqv_nqt_seq_no
    AND   npqv.nqv_nqa_seq_no = pi_nqv_nqa_seq_no
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_npqv');
--
   OPEN  cs_npqv;
   FETCH cs_npqv INTO l_retval;
   l_found := cs_npqv%FOUND;
   CLOSE cs_npqv;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_pbi_query_values (NQV_PK)'
                                              ||CHR(10)||'nqv_sequence   => '||pi_nqv_sequence
                                              ||CHR(10)||'nqv_npq_id     => '||pi_nqv_npq_id
                                              ||CHR(10)||'nqv_nqt_seq_no => '||pi_nqv_nqt_seq_no
                                              ||CHR(10)||'nqv_nqa_seq_no => '||pi_nqv_nqa_seq_no
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_npqv');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_pbi_query_values (NQV_PK)'
                                              ||CHR(10)||'nqv_sequence   => '||pi_nqv_sequence
                                              ||CHR(10)||'nqv_npq_id     => '||pi_nqv_npq_id
                                              ||CHR(10)||'nqv_nqt_seq_no => '||pi_nqv_nqt_seq_no
                                              ||CHR(10)||'nqv_nqa_seq_no => '||pi_nqv_nqa_seq_no
                    );
--
END lock_npqv;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NQV_PK constraint
--
PROCEDURE lock_npqv (pi_nqv_sequence      nm_pbi_query_values.nqv_sequence%TYPE
                    ,pi_nqv_npq_id        nm_pbi_query_values.nqv_npq_id%TYPE
                    ,pi_nqv_nqt_seq_no    nm_pbi_query_values.nqv_nqt_seq_no%TYPE
                    ,pi_nqv_nqa_seq_no    nm_pbi_query_values.nqv_nqa_seq_no%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_npqv');
--
   l_rowid := lock_npqv
                   (pi_nqv_sequence      => pi_nqv_sequence
                   ,pi_nqv_npq_id        => pi_nqv_npq_id
                   ,pi_nqv_nqt_seq_no    => pi_nqv_nqt_seq_no
                   ,pi_nqv_nqa_seq_no    => pi_nqv_nqa_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_npqv');
--
END lock_npqv;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NPS_PK constraint
--
FUNCTION lock_nps (pi_nps_npq_id        nm_pbi_sections.nps_npq_id%TYPE
                  ,pi_nps_nqr_job_id    nm_pbi_sections.nps_nqr_job_id%TYPE
                  ,pi_nps_section_id    nm_pbi_sections.nps_section_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nps IS
   SELECT /*+ INDEX (nps NPS_PK) */ ROWID
    FROM  nm_pbi_sections nps
   WHERE  nps.nps_npq_id     = pi_nps_npq_id
    AND   nps.nps_nqr_job_id = pi_nps_nqr_job_id
    AND   nps.nps_section_id = pi_nps_section_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nps');
--
   OPEN  cs_nps;
   FETCH cs_nps INTO l_retval;
   l_found := cs_nps%FOUND;
   CLOSE cs_nps;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_pbi_sections (NPS_PK)'
                                              ||CHR(10)||'nps_npq_id     => '||pi_nps_npq_id
                                              ||CHR(10)||'nps_nqr_job_id => '||pi_nps_nqr_job_id
                                              ||CHR(10)||'nps_section_id => '||pi_nps_section_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nps');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_pbi_sections (NPS_PK)'
                                              ||CHR(10)||'nps_npq_id     => '||pi_nps_npq_id
                                              ||CHR(10)||'nps_nqr_job_id => '||pi_nps_nqr_job_id
                                              ||CHR(10)||'nps_section_id => '||pi_nps_section_id
                    );
--
END lock_nps;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NPS_PK constraint
--
PROCEDURE lock_nps (pi_nps_npq_id        nm_pbi_sections.nps_npq_id%TYPE
                   ,pi_nps_nqr_job_id    nm_pbi_sections.nps_nqr_job_id%TYPE
                   ,pi_nps_section_id    nm_pbi_sections.nps_section_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nps');
--
   l_rowid := lock_nps
                   (pi_nps_npq_id        => pi_nps_npq_id
                   ,pi_nps_nqr_job_id    => pi_nps_nqr_job_id
                   ,pi_nps_section_id    => pi_nps_section_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nps');
--
END lock_nps;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NPM_PK constraint
--
FUNCTION lock_npsm (pi_npm_npq_id         nm_pbi_section_members.npm_npq_id%TYPE
                   ,pi_npm_nqr_job_id     nm_pbi_section_members.npm_nqr_job_id%TYPE
                   ,pi_npm_nps_section_id nm_pbi_section_members.npm_nps_section_id%TYPE
                   ,pi_npm_ne_id_of       nm_pbi_section_members.npm_ne_id_of%TYPE
                   ,pi_npm_begin_mp       nm_pbi_section_members.npm_begin_mp%TYPE
                   ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_npsm IS
   SELECT /*+ INDEX (npsm NPM_PK) */ ROWID
    FROM  nm_pbi_section_members npsm
   WHERE  npsm.npm_npq_id         = pi_npm_npq_id
    AND   npsm.npm_nqr_job_id     = pi_npm_nqr_job_id
    AND   npsm.npm_nps_section_id = pi_npm_nps_section_id
    AND   npsm.npm_ne_id_of       = pi_npm_ne_id_of
    AND   npsm.npm_begin_mp       = pi_npm_begin_mp
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_npsm');
--
   OPEN  cs_npsm;
   FETCH cs_npsm INTO l_retval;
   l_found := cs_npsm%FOUND;
   CLOSE cs_npsm;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_pbi_section_members (NPM_PK)'
                                              ||CHR(10)||'npm_npq_id         => '||pi_npm_npq_id
                                              ||CHR(10)||'npm_nqr_job_id     => '||pi_npm_nqr_job_id
                                              ||CHR(10)||'npm_nps_section_id => '||pi_npm_nps_section_id
                                              ||CHR(10)||'npm_ne_id_of       => '||pi_npm_ne_id_of
                                              ||CHR(10)||'npm_begin_mp       => '||pi_npm_begin_mp
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_npsm');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_pbi_section_members (NPM_PK)'
                                              ||CHR(10)||'npm_npq_id         => '||pi_npm_npq_id
                                              ||CHR(10)||'npm_nqr_job_id     => '||pi_npm_nqr_job_id
                                              ||CHR(10)||'npm_nps_section_id => '||pi_npm_nps_section_id
                                              ||CHR(10)||'npm_ne_id_of       => '||pi_npm_ne_id_of
                                              ||CHR(10)||'npm_begin_mp       => '||pi_npm_begin_mp
                    );
--
END lock_npsm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NPM_PK constraint
--
PROCEDURE lock_npsm (pi_npm_npq_id         nm_pbi_section_members.npm_npq_id%TYPE
                    ,pi_npm_nqr_job_id     nm_pbi_section_members.npm_nqr_job_id%TYPE
                    ,pi_npm_nps_section_id nm_pbi_section_members.npm_nps_section_id%TYPE
                    ,pi_npm_ne_id_of       nm_pbi_section_members.npm_ne_id_of%TYPE
                    ,pi_npm_begin_mp       nm_pbi_section_members.npm_begin_mp%TYPE
                    ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_npsm');
--
   l_rowid := lock_npsm
                   (pi_npm_npq_id         => pi_npm_npq_id
                   ,pi_npm_nqr_job_id     => pi_npm_nqr_job_id
                   ,pi_npm_nps_section_id => pi_npm_nps_section_id
                   ,pi_npm_ne_id_of       => pi_npm_ne_id_of
                   ,pi_npm_begin_mp       => pi_npm_begin_mp
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_npsm');
--
END lock_npsm;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NP_PK constraint
--
FUNCTION lock_np (pi_np_id             nm_points.np_id%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) RETURN ROWID IS
--
   CURSOR cs_np IS
   SELECT /*+ INDEX (np NP_PK) */ ROWID
    FROM  nm_points np
   WHERE  np.np_id = pi_np_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_np');
--
   OPEN  cs_np;
   FETCH cs_np INTO l_retval;
   l_found := cs_np%FOUND;
   CLOSE cs_np;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_points (NP_PK)'
                                              ||CHR(10)||'np_id => '||pi_np_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_np');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_points (NP_PK)'
                                              ||CHR(10)||'np_id => '||pi_np_id
                    );
--
END lock_np;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NP_PK constraint
--
PROCEDURE lock_np (pi_np_id             nm_points.np_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_np');
--
   l_rowid := lock_np
                   (pi_np_id             => pi_np_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_np');
--
END lock_np;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NRD_PK constraint
--
FUNCTION lock_nrd (pi_nrd_job_id        nm_reclass_details.nrd_job_id%TYPE
                  ,pi_nrd_old_ne_id     nm_reclass_details.nrd_old_ne_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nrd IS
   SELECT /*+ INDEX (nrd NRD_PK) */ ROWID
    FROM  nm_reclass_details nrd
   WHERE  nrd.nrd_job_id    = pi_nrd_job_id
    AND   nrd.nrd_old_ne_id = pi_nrd_old_ne_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nrd');
--
   OPEN  cs_nrd;
   FETCH cs_nrd INTO l_retval;
   l_found := cs_nrd%FOUND;
   CLOSE cs_nrd;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_reclass_details (NRD_PK)'
                                              ||CHR(10)||'nrd_job_id    => '||pi_nrd_job_id
                                              ||CHR(10)||'nrd_old_ne_id => '||pi_nrd_old_ne_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nrd');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_reclass_details (NRD_PK)'
                                              ||CHR(10)||'nrd_job_id    => '||pi_nrd_job_id
                                              ||CHR(10)||'nrd_old_ne_id => '||pi_nrd_old_ne_id
                    );
--
END lock_nrd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NRD_PK constraint
--
PROCEDURE lock_nrd (pi_nrd_job_id        nm_reclass_details.nrd_job_id%TYPE
                   ,pi_nrd_old_ne_id     nm_reclass_details.nrd_old_ne_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nrd');
--
   l_rowid := lock_nrd
                   (pi_nrd_job_id        => pi_nrd_job_id
                   ,pi_nrd_old_ne_id     => pi_nrd_old_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nrd');
--
END lock_nrd;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NRD_UK constraint
--
FUNCTION lock_nrd (pi_nrd_job_id        nm_reclass_details.nrd_job_id%TYPE
                  ,pi_nrd_new_ne_id     nm_reclass_details.nrd_new_ne_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nrd IS
   SELECT /*+ INDEX (nrd NRD_UK) */ ROWID
    FROM  nm_reclass_details nrd
   WHERE  nrd.nrd_job_id    = pi_nrd_job_id
    AND   nrd.nrd_new_ne_id = pi_nrd_new_ne_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nrd');
--
   OPEN  cs_nrd;
   FETCH cs_nrd INTO l_retval;
   l_found := cs_nrd%FOUND;
   CLOSE cs_nrd;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_reclass_details (NRD_UK)'
                                              ||CHR(10)||'nrd_job_id    => '||pi_nrd_job_id
                                              ||CHR(10)||'nrd_new_ne_id => '||pi_nrd_new_ne_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nrd');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_reclass_details (NRD_UK)'
                                              ||CHR(10)||'nrd_job_id    => '||pi_nrd_job_id
                                              ||CHR(10)||'nrd_new_ne_id => '||pi_nrd_new_ne_id
                    );
--
END lock_nrd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NRD_UK constraint
--
PROCEDURE lock_nrd (pi_nrd_job_id        nm_reclass_details.nrd_job_id%TYPE
                   ,pi_nrd_new_ne_id     nm_reclass_details.nrd_new_ne_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nrd');
--
   l_rowid := lock_nrd
                   (pi_nrd_job_id        => pi_nrd_job_id
                   ,pi_nrd_new_ne_id     => pi_nrd_new_ne_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nrd');
--
END lock_nrd;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NSE_PK constraint
--
FUNCTION lock_nse (pi_nse_id            nm_saved_extents.nse_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nse IS
   SELECT /*+ INDEX (nse NSE_PK) */ ROWID
    FROM  nm_saved_extents nse
   WHERE  nse.nse_id = pi_nse_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nse');
--
   OPEN  cs_nse;
   FETCH cs_nse INTO l_retval;
   l_found := cs_nse%FOUND;
   CLOSE cs_nse;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_saved_extents (NSE_PK)'
                                              ||CHR(10)||'nse_id => '||pi_nse_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nse');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_saved_extents (NSE_PK)'
                                              ||CHR(10)||'nse_id => '||pi_nse_id
                    );
--
END lock_nse;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NSE_PK constraint
--
PROCEDURE lock_nse (pi_nse_id            nm_saved_extents.nse_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nse');
--
   l_rowid := lock_nse
                   (pi_nse_id            => pi_nse_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nse');
--
END lock_nse;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NSE_UK constraint
--
FUNCTION lock_nse (pi_nse_name          nm_saved_extents.nse_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nse IS
   SELECT /*+ INDEX (nse NSE_UK) */ ROWID
    FROM  nm_saved_extents nse
   WHERE  nse.nse_name = pi_nse_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nse');
--
   OPEN  cs_nse;
   FETCH cs_nse INTO l_retval;
   l_found := cs_nse%FOUND;
   CLOSE cs_nse;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_saved_extents (NSE_UK)'
                                              ||CHR(10)||'nse_name => '||pi_nse_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nse');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_saved_extents (NSE_UK)'
                                              ||CHR(10)||'nse_name => '||pi_nse_name
                    );
--
END lock_nse;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NSE_UK constraint
--
PROCEDURE lock_nse (pi_nse_name          nm_saved_extents.nse_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nse');
--
   l_rowid := lock_nse
                   (pi_nse_name          => pi_nse_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nse');
--
END lock_nse;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NSM_PK constraint
--
FUNCTION lock_nsm (pi_nsm_nse_id        nm_saved_extent_members.nsm_nse_id%TYPE
                  ,pi_nsm_id            nm_saved_extent_members.nsm_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nsm IS
   SELECT /*+ INDEX (nsm NSM_PK) */ ROWID
    FROM  nm_saved_extent_members nsm
   WHERE  nsm.nsm_nse_id = pi_nsm_nse_id
    AND   nsm.nsm_id     = pi_nsm_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsm');
--
   OPEN  cs_nsm;
   FETCH cs_nsm INTO l_retval;
   l_found := cs_nsm%FOUND;
   CLOSE cs_nsm;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_saved_extent_members (NSM_PK)'
                                              ||CHR(10)||'nsm_nse_id => '||pi_nsm_nse_id
                                              ||CHR(10)||'nsm_id     => '||pi_nsm_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nsm');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_saved_extent_members (NSM_PK)'
                                              ||CHR(10)||'nsm_nse_id => '||pi_nsm_nse_id
                                              ||CHR(10)||'nsm_id     => '||pi_nsm_id
                    );
--
END lock_nsm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NSM_PK constraint
--
PROCEDURE lock_nsm (pi_nsm_nse_id        nm_saved_extent_members.nsm_nse_id%TYPE
                   ,pi_nsm_id            nm_saved_extent_members.nsm_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsm');
--
   l_rowid := lock_nsm
                   (pi_nsm_nse_id        => pi_nsm_nse_id
                   ,pi_nsm_id            => pi_nsm_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nsm');
--
END lock_nsm;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NSD_PK constraint
--
FUNCTION lock_nsd (pi_nsd_ne_id         nm_saved_extent_member_datums.nsd_ne_id%TYPE
                  ,pi_nsd_begin_mp      nm_saved_extent_member_datums.nsd_begin_mp%TYPE
                  ,pi_nsd_nse_id        nm_saved_extent_member_datums.nsd_nse_id%TYPE
                  ,pi_nsd_nsm_id        nm_saved_extent_member_datums.nsd_nsm_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nsd IS
   SELECT /*+ INDEX (nsd NSD_PK) */ ROWID
    FROM  nm_saved_extent_member_datums nsd
   WHERE  nsd.nsd_ne_id    = pi_nsd_ne_id
    AND   nsd.nsd_begin_mp = pi_nsd_begin_mp
    AND   nsd.nsd_nse_id   = pi_nsd_nse_id
    AND   nsd.nsd_nsm_id   = pi_nsd_nsm_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsd');
--
   OPEN  cs_nsd;
   FETCH cs_nsd INTO l_retval;
   l_found := cs_nsd%FOUND;
   CLOSE cs_nsd;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_saved_extent_member_datums (NSD_PK)'
                                              ||CHR(10)||'nsd_ne_id    => '||pi_nsd_ne_id
                                              ||CHR(10)||'nsd_begin_mp => '||pi_nsd_begin_mp
                                              ||CHR(10)||'nsd_nse_id   => '||pi_nsd_nse_id
                                              ||CHR(10)||'nsd_nsm_id   => '||pi_nsd_nsm_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nsd');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_saved_extent_member_datums (NSD_PK)'
                                              ||CHR(10)||'nsd_ne_id    => '||pi_nsd_ne_id
                                              ||CHR(10)||'nsd_begin_mp => '||pi_nsd_begin_mp
                                              ||CHR(10)||'nsd_nse_id   => '||pi_nsd_nse_id
                                              ||CHR(10)||'nsd_nsm_id   => '||pi_nsd_nsm_id
                    );
--
END lock_nsd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NSD_PK constraint
--
PROCEDURE lock_nsd (pi_nsd_ne_id         nm_saved_extent_member_datums.nsd_ne_id%TYPE
                   ,pi_nsd_begin_mp      nm_saved_extent_member_datums.nsd_begin_mp%TYPE
                   ,pi_nsd_nse_id        nm_saved_extent_member_datums.nsd_nse_id%TYPE
                   ,pi_nsd_nsm_id        nm_saved_extent_member_datums.nsd_nsm_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsd');
--
   l_rowid := lock_nsd
                   (pi_nsd_ne_id         => pi_nsd_ne_id
                   ,pi_nsd_begin_mp      => pi_nsd_begin_mp
                   ,pi_nsd_nse_id        => pi_nsd_nse_id
                   ,pi_nsd_nsm_id        => pi_nsd_nsm_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nsd');
--
END lock_nsd;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using TII_PK constraint
--
FUNCTION lock_tii (pi_tii_njc_job_id    nm_temp_inv_items.tii_njc_job_id%TYPE
                  ,pi_tii_ne_id         nm_temp_inv_items.tii_ne_id%TYPE
                  ,pi_tii_ne_id_new     nm_temp_inv_items.tii_ne_id_new%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_tii IS
   SELECT /*+ INDEX (tii TII_PK) */ ROWID
    FROM  nm_temp_inv_items tii
   WHERE  tii.tii_njc_job_id = pi_tii_njc_job_id
    AND   tii.tii_ne_id      = pi_tii_ne_id
    AND   tii.tii_ne_id_new  = pi_tii_ne_id_new
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_tii');
--
   OPEN  cs_tii;
   FETCH cs_tii INTO l_retval;
   l_found := cs_tii%FOUND;
   CLOSE cs_tii;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_temp_inv_items (TII_PK)'
                                              ||CHR(10)||'tii_njc_job_id => '||pi_tii_njc_job_id
                                              ||CHR(10)||'tii_ne_id      => '||pi_tii_ne_id
                                              ||CHR(10)||'tii_ne_id_new  => '||pi_tii_ne_id_new
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_tii');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_temp_inv_items (TII_PK)'
                                              ||CHR(10)||'tii_njc_job_id => '||pi_tii_njc_job_id
                                              ||CHR(10)||'tii_ne_id      => '||pi_tii_ne_id
                                              ||CHR(10)||'tii_ne_id_new  => '||pi_tii_ne_id_new
                    );
--
END lock_tii;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using TII_PK constraint
--
PROCEDURE lock_tii (pi_tii_njc_job_id    nm_temp_inv_items.tii_njc_job_id%TYPE
                   ,pi_tii_ne_id         nm_temp_inv_items.tii_ne_id%TYPE
                   ,pi_tii_ne_id_new     nm_temp_inv_items.tii_ne_id_new%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_tii');
--
   l_rowid := lock_tii
                   (pi_tii_njc_job_id    => pi_tii_njc_job_id
                   ,pi_tii_ne_id         => pi_tii_ne_id
                   ,pi_tii_ne_id_new     => pi_tii_ne_id_new
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_tii');
--
END lock_tii;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using TIM_PK constraint
--
FUNCTION lock_tim (pi_tim_njc_job_id      nm_temp_inv_members.tim_njc_job_id%TYPE
                  ,pi_tim_ne_id_in        nm_temp_inv_members.tim_ne_id_in%TYPE
                  ,pi_tim_ne_id_in_new    nm_temp_inv_members.tim_ne_id_in_new%TYPE
                  ,pi_tim_ne_id_of        nm_temp_inv_members.tim_ne_id_of%TYPE
                  ,pi_tim_extent_begin_mp nm_temp_inv_members.tim_extent_begin_mp%TYPE
                  ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_tim IS
   SELECT /*+ INDEX (tim TIM_PK) */ ROWID
    FROM  nm_temp_inv_members tim
   WHERE  tim.tim_njc_job_id      = pi_tim_njc_job_id
    AND   tim.tim_ne_id_in        = pi_tim_ne_id_in
    AND   tim.tim_ne_id_in_new    = pi_tim_ne_id_in_new
    AND   tim.tim_ne_id_of        = pi_tim_ne_id_of
    AND   tim.tim_extent_begin_mp = pi_tim_extent_begin_mp
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_tim');
--
   OPEN  cs_tim;
   FETCH cs_tim INTO l_retval;
   l_found := cs_tim%FOUND;
   CLOSE cs_tim;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_temp_inv_members (TIM_PK)'
                                              ||CHR(10)||'tim_njc_job_id      => '||pi_tim_njc_job_id
                                              ||CHR(10)||'tim_ne_id_in        => '||pi_tim_ne_id_in
                                              ||CHR(10)||'tim_ne_id_in_new    => '||pi_tim_ne_id_in_new
                                              ||CHR(10)||'tim_ne_id_of        => '||pi_tim_ne_id_of
                                              ||CHR(10)||'tim_extent_begin_mp => '||pi_tim_extent_begin_mp
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_tim');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_temp_inv_members (TIM_PK)'
                                              ||CHR(10)||'tim_njc_job_id      => '||pi_tim_njc_job_id
                                              ||CHR(10)||'tim_ne_id_in        => '||pi_tim_ne_id_in
                                              ||CHR(10)||'tim_ne_id_in_new    => '||pi_tim_ne_id_in_new
                                              ||CHR(10)||'tim_ne_id_of        => '||pi_tim_ne_id_of
                                              ||CHR(10)||'tim_extent_begin_mp => '||pi_tim_extent_begin_mp
                    );
--
END lock_tim;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using TIM_PK constraint
--
PROCEDURE lock_tim (pi_tim_njc_job_id      nm_temp_inv_members.tim_njc_job_id%TYPE
                   ,pi_tim_ne_id_in        nm_temp_inv_members.tim_ne_id_in%TYPE
                   ,pi_tim_ne_id_in_new    nm_temp_inv_members.tim_ne_id_in_new%TYPE
                   ,pi_tim_ne_id_of        nm_temp_inv_members.tim_ne_id_of%TYPE
                   ,pi_tim_extent_begin_mp nm_temp_inv_members.tim_extent_begin_mp%TYPE
                   ,pi_raise_not_found     BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode   PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode      PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_tim');
--
   l_rowid := lock_tim
                   (pi_tim_njc_job_id      => pi_tim_njc_job_id
                   ,pi_tim_ne_id_in        => pi_tim_ne_id_in
                   ,pi_tim_ne_id_in_new    => pi_tim_ne_id_in_new
                   ,pi_tim_ne_id_of        => pi_tim_ne_id_of
                   ,pi_tim_extent_begin_mp => pi_tim_extent_begin_mp
                   ,pi_raise_not_found     => pi_raise_not_found
                   ,pi_not_found_sqlcode   => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_tim');
--
END lock_tim;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NTH_PK constraint
--
FUNCTION lock_nth (pi_nth_theme_id      nm_themes_all.nth_theme_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nth IS
   SELECT /*+ INDEX (nth NTH_PK) */ ROWID
    FROM  nm_themes_all nth
   WHERE  nth.nth_theme_id = pi_nth_theme_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nth');
--
   OPEN  cs_nth;
   FETCH cs_nth INTO l_retval;
   l_found := cs_nth%FOUND;
   CLOSE cs_nth;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_themes_all (NTH_PK)'
                                              ||CHR(10)||'nth_theme_id => '||pi_nth_theme_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nth');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_themes_all (NTH_PK)'
                                              ||CHR(10)||'nth_theme_id => '||pi_nth_theme_id
                    );
--
END lock_nth;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NTH_PK constraint
--
PROCEDURE lock_nth (pi_nth_theme_id      nm_themes_all.nth_theme_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nth');
--
   l_rowid := lock_nth
                   (pi_nth_theme_id      => pi_nth_theme_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nth');
--
END lock_nth;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NTH_UK constraint
--
FUNCTION lock_nth (pi_nth_theme_name    nm_themes_all.nth_theme_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nth IS
   SELECT /*+ INDEX (nth NTH_UK) */ ROWID
    FROM  nm_themes_all nth
   WHERE  nth.nth_theme_name = pi_nth_theme_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nth');
--
   OPEN  cs_nth;
   FETCH cs_nth INTO l_retval;
   l_found := cs_nth%FOUND;
   CLOSE cs_nth;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_themes_all (NTH_UK)'
                                              ||CHR(10)||'nth_theme_name => '||pi_nth_theme_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nth');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_themes_all (NTH_UK)'
                                              ||CHR(10)||'nth_theme_name => '||pi_nth_theme_name
                    );
--
END lock_nth;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NTH_UK constraint
--
PROCEDURE lock_nth (pi_nth_theme_name    nm_themes_all.nth_theme_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nth');
--
   l_rowid := lock_nth
                   (pi_nth_theme_name    => pi_nth_theme_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nth');
--
END lock_nth;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NTG_UK constraint
--
FUNCTION lock_ntg (pi_ntg_theme_id      nm_theme_gtypes.ntg_theme_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_ntg IS
   SELECT /*+ INDEX (ntg NTG_UK) */ ROWID
    FROM  nm_theme_gtypes ntg
   WHERE  ntg.ntg_theme_id = pi_ntg_theme_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ntg');
--
   OPEN  cs_ntg;
   FETCH cs_ntg INTO l_retval;
   l_found := cs_ntg%FOUND;
   CLOSE cs_ntg;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_theme_gtypes (NTG_UK)'
                                              ||CHR(10)||'ntg_theme_id => '||pi_ntg_theme_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ntg');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_theme_gtypes (NTG_UK)'
                                              ||CHR(10)||'ntg_theme_id => '||pi_ntg_theme_id
                    );
--
END lock_ntg;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NTG_UK constraint
--
PROCEDURE lock_ntg (pi_ntg_theme_id      nm_theme_gtypes.ntg_theme_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ntg');
--
   l_rowid := lock_ntg
                   (pi_ntg_theme_id      => pi_ntg_theme_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ntg');
--
END lock_ntg;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NTF_PK constraint
--
FUNCTION lock_ntf (pi_ntf_nth_theme_id  nm_theme_functions_all.ntf_nth_theme_id%TYPE
                  ,pi_ntf_hmo_module    nm_theme_functions_all.ntf_hmo_module%TYPE
                  ,pi_ntf_parameter     nm_theme_functions_all.ntf_parameter%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_ntf IS
   SELECT /*+ INDEX (ntf NTF_PK) */ ROWID
    FROM  nm_theme_functions_all ntf
   WHERE  ntf.ntf_nth_theme_id = pi_ntf_nth_theme_id
    AND   ntf.ntf_hmo_module   = pi_ntf_hmo_module
    AND   ntf.ntf_parameter    = pi_ntf_parameter
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ntf');
--
   OPEN  cs_ntf;
   FETCH cs_ntf INTO l_retval;
   l_found := cs_ntf%FOUND;
   CLOSE cs_ntf;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_theme_functions_all (NTF_PK)'
                                              ||CHR(10)||'ntf_nth_theme_id => '||pi_ntf_nth_theme_id
                                              ||CHR(10)||'ntf_hmo_module   => '||pi_ntf_hmo_module
                                              ||CHR(10)||'ntf_parameter    => '||pi_ntf_parameter
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ntf');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_theme_functions_all (NTF_PK)'
                                              ||CHR(10)||'ntf_nth_theme_id => '||pi_ntf_nth_theme_id
                                              ||CHR(10)||'ntf_hmo_module   => '||pi_ntf_hmo_module
                                              ||CHR(10)||'ntf_parameter    => '||pi_ntf_parameter
                    );
--
END lock_ntf;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NTF_PK constraint
--
PROCEDURE lock_ntf (pi_ntf_nth_theme_id  nm_theme_functions_all.ntf_nth_theme_id%TYPE
                   ,pi_ntf_hmo_module    nm_theme_functions_all.ntf_hmo_module%TYPE
                   ,pi_ntf_parameter     nm_theme_functions_all.ntf_parameter%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ntf');
--
   l_rowid := lock_ntf
                   (pi_ntf_nth_theme_id  => pi_ntf_nth_theme_id
                   ,pi_ntf_hmo_module    => pi_ntf_hmo_module
                   ,pi_ntf_parameter     => pi_ntf_parameter
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ntf');
--
END lock_ntf;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NTHR_PK constraint
--
FUNCTION lock_nthr (pi_nthr_role         nm_theme_roles.nthr_role%TYPE
                   ,pi_nthr_theme_id     nm_theme_roles.nthr_theme_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nthr IS
   SELECT /*+ INDEX (nthr NTHR_PK) */ ROWID
    FROM  nm_theme_roles nthr
   WHERE  nthr.nthr_role     = pi_nthr_role
    AND   nthr.nthr_theme_id = pi_nthr_theme_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nthr');
--
   OPEN  cs_nthr;
   FETCH cs_nthr INTO l_retval;
   l_found := cs_nthr%FOUND;
   CLOSE cs_nthr;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_theme_roles (NTHR_PK)'
                                              ||CHR(10)||'nthr_role     => '||pi_nthr_role
                                              ||CHR(10)||'nthr_theme_id => '||pi_nthr_theme_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nthr');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_theme_roles (NTHR_PK)'
                                              ||CHR(10)||'nthr_role     => '||pi_nthr_role
                                              ||CHR(10)||'nthr_theme_id => '||pi_nthr_theme_id
                    );
--
END lock_nthr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NTHR_PK constraint
--
PROCEDURE lock_nthr (pi_nthr_role         nm_theme_roles.nthr_role%TYPE
                    ,pi_nthr_theme_id     nm_theme_roles.nthr_theme_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nthr');
--
   l_rowid := lock_nthr
                   (pi_nthr_role         => pi_nthr_role
                   ,pi_nthr_theme_id     => pi_nthr_theme_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nthr');
--
END lock_nthr;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NTS_PK constraint
--
FUNCTION lock_nts (pi_nts_theme_id      nm_theme_snaps.nts_theme_id%TYPE
                  ,pi_nts_snap_to       nm_theme_snaps.nts_snap_to%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nts IS
   SELECT /*+ INDEX (nts NTS_PK) */ ROWID
    FROM  nm_theme_snaps nts
   WHERE  nts.nts_theme_id = pi_nts_theme_id
    AND   nts.nts_snap_to  = pi_nts_snap_to
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nts');
--
   OPEN  cs_nts;
   FETCH cs_nts INTO l_retval;
   l_found := cs_nts%FOUND;
   CLOSE cs_nts;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_theme_snaps (NTS_PK)'
                                              ||CHR(10)||'nts_theme_id => '||pi_nts_theme_id
                                              ||CHR(10)||'nts_snap_to  => '||pi_nts_snap_to
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nts');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_theme_snaps (NTS_PK)'
                                              ||CHR(10)||'nts_theme_id => '||pi_nts_theme_id
                                              ||CHR(10)||'nts_snap_to  => '||pi_nts_snap_to
                    );
--
END lock_nts;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NTS_PK constraint
--
PROCEDURE lock_nts (pi_nts_theme_id      nm_theme_snaps.nts_theme_id%TYPE
                   ,pi_nts_snap_to       nm_theme_snaps.nts_snap_to%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nts');
--
   l_rowid := lock_nts
                   (pi_nts_theme_id      => pi_nts_theme_id
                   ,pi_nts_snap_to       => pi_nts_snap_to
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nts');
--
END lock_nts;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NT_PK constraint
--
FUNCTION lock_nt (pi_nt_type           nm_types.nt_type%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) RETURN ROWID IS
--
   CURSOR cs_nt IS
   SELECT /*+ INDEX (nt NT_PK) */ ROWID
    FROM  nm_types nt
   WHERE  nt.nt_type = pi_nt_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nt');
--
   OPEN  cs_nt;
   FETCH cs_nt INTO l_retval;
   l_found := cs_nt%FOUND;
   CLOSE cs_nt;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_types (NT_PK)'
                                              ||CHR(10)||'nt_type => '||pi_nt_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nt');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_types (NT_PK)'
                                              ||CHR(10)||'nt_type => '||pi_nt_type
                    );
--
END lock_nt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NT_PK constraint
--
PROCEDURE lock_nt (pi_nt_type           nm_types.nt_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nt');
--
   l_rowid := lock_nt
                   (pi_nt_type           => pi_nt_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nt');
--
END lock_nt;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NT_UK constraint
--
FUNCTION lock_nt (pi_nt_unique         nm_types.nt_unique%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) RETURN ROWID IS
--
   CURSOR cs_nt IS
   SELECT /*+ INDEX (nt NT_UK) */ ROWID
    FROM  nm_types nt
   WHERE  nt.nt_unique = pi_nt_unique
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nt');
--
   OPEN  cs_nt;
   FETCH cs_nt INTO l_retval;
   l_found := cs_nt%FOUND;
   CLOSE cs_nt;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_types (NT_UK)'
                                              ||CHR(10)||'nt_unique => '||pi_nt_unique
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nt');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_types (NT_UK)'
                                              ||CHR(10)||'nt_unique => '||pi_nt_unique
                    );
--
END lock_nt;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NT_UK constraint
--
PROCEDURE lock_nt (pi_nt_unique         nm_types.nt_unique%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nt');
--
   l_rowid := lock_nt
                   (pi_nt_unique         => pi_nt_unique
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nt');
--
END lock_nt;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NTC_PK constraint
--
FUNCTION lock_ntc (pi_ntc_nt_type       nm_type_columns.ntc_nt_type%TYPE
                  ,pi_ntc_column_name   nm_type_columns.ntc_column_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_ntc IS
   SELECT /*+ INDEX (ntc NTC_PK) */ ROWID
    FROM  nm_type_columns ntc
   WHERE  ntc.ntc_nt_type     = pi_ntc_nt_type
    AND   ntc.ntc_column_name = pi_ntc_column_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ntc');
--
   OPEN  cs_ntc;
   FETCH cs_ntc INTO l_retval;
   l_found := cs_ntc%FOUND;
   CLOSE cs_ntc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_type_columns (NTC_PK)'
                                              ||CHR(10)||'ntc_nt_type     => '||pi_ntc_nt_type
                                              ||CHR(10)||'ntc_column_name => '||pi_ntc_column_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ntc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_type_columns (NTC_PK)'
                                              ||CHR(10)||'ntc_nt_type     => '||pi_ntc_nt_type
                                              ||CHR(10)||'ntc_column_name => '||pi_ntc_column_name
                    );
--
END lock_ntc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NTC_PK constraint
--
PROCEDURE lock_ntc (pi_ntc_nt_type       nm_type_columns.ntc_nt_type%TYPE
                   ,pi_ntc_column_name   nm_type_columns.ntc_column_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ntc');
--
   l_rowid := lock_ntc
                   (pi_ntc_nt_type       => pi_ntc_nt_type
                   ,pi_ntc_column_name   => pi_ntc_column_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ntc');
--
END lock_ntc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NTI_PK constraint
--
FUNCTION lock_nti (pi_nti_nw_parent_type nm_type_inclusion.nti_nw_parent_type%TYPE
                  ,pi_nti_nw_child_type  nm_type_inclusion.nti_nw_child_type%TYPE
                  ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nti IS
   SELECT /*+ INDEX (nti NTI_PK) */ ROWID
    FROM  nm_type_inclusion nti
   WHERE  nti.nti_nw_parent_type = pi_nti_nw_parent_type
    AND   nti.nti_nw_child_type  = pi_nti_nw_child_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nti');
--
   OPEN  cs_nti;
   FETCH cs_nti INTO l_retval;
   l_found := cs_nti%FOUND;
   CLOSE cs_nti;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_type_inclusion (NTI_PK)'
                                              ||CHR(10)||'nti_nw_parent_type => '||pi_nti_nw_parent_type
                                              ||CHR(10)||'nti_nw_child_type  => '||pi_nti_nw_child_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nti');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_type_inclusion (NTI_PK)'
                                              ||CHR(10)||'nti_nw_parent_type => '||pi_nti_nw_parent_type
                                              ||CHR(10)||'nti_nw_child_type  => '||pi_nti_nw_child_type
                    );
--
END lock_nti;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NTI_PK constraint
--
PROCEDURE lock_nti (pi_nti_nw_parent_type nm_type_inclusion.nti_nw_parent_type%TYPE
                   ,pi_nti_nw_child_type  nm_type_inclusion.nti_nw_child_type%TYPE
                   ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nti');
--
   l_rowid := lock_nti
                   (pi_nti_nw_parent_type => pi_nti_nw_parent_type
                   ,pi_nti_nw_child_type  => pi_nti_nw_child_type
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nti');
--
END lock_nti;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NTI_UK constraint
--
FUNCTION lock_nti (pi_nti_nw_child_type nm_type_inclusion.nti_nw_child_type%TYPE
                  ,pi_nti_child_column  nm_type_inclusion.nti_child_column%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nti IS
   SELECT /*+ INDEX (nti NTI_UK) */ ROWID
    FROM  nm_type_inclusion nti
   WHERE  nti.nti_nw_child_type = pi_nti_nw_child_type
    AND   nti.nti_child_column  = pi_nti_child_column
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nti');
--
   OPEN  cs_nti;
   FETCH cs_nti INTO l_retval;
   l_found := cs_nti%FOUND;
   CLOSE cs_nti;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_type_inclusion (NTI_UK)'
                                              ||CHR(10)||'nti_nw_child_type => '||pi_nti_nw_child_type
                                              ||CHR(10)||'nti_child_column  => '||pi_nti_child_column
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nti');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_type_inclusion (NTI_UK)'
                                              ||CHR(10)||'nti_nw_child_type => '||pi_nti_nw_child_type
                                              ||CHR(10)||'nti_child_column  => '||pi_nti_child_column
                    );
--
END lock_nti;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NTI_UK constraint
--
PROCEDURE lock_nti (pi_nti_nw_child_type nm_type_inclusion.nti_nw_child_type%TYPE
                   ,pi_nti_child_column  nm_type_inclusion.nti_child_column%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nti');
--
   l_rowid := lock_nti
                   (pi_nti_nw_child_type => pi_nti_nw_child_type
                   ,pi_nti_child_column  => pi_nti_child_column
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nti');
--
END lock_nti;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NTL_PK constraint
--
FUNCTION lock_ntl (pi_ntl_nt_type       nm_type_layers.ntl_nt_type%TYPE
                  ,pi_ntl_layer_id      nm_type_layers.ntl_layer_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_ntl IS
   SELECT /*+ INDEX (ntl NTL_PK) */ ROWID
    FROM  nm_type_layers ntl
   WHERE  ntl.ntl_nt_type  = pi_ntl_nt_type
    AND   ntl.ntl_layer_id = pi_ntl_layer_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ntl');
--
   OPEN  cs_ntl;
   FETCH cs_ntl INTO l_retval;
   l_found := cs_ntl%FOUND;
   CLOSE cs_ntl;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_type_layers (NTL_PK)'
                                              ||CHR(10)||'ntl_nt_type  => '||pi_ntl_nt_type
                                              ||CHR(10)||'ntl_layer_id => '||pi_ntl_layer_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ntl');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_type_layers (NTL_PK)'
                                              ||CHR(10)||'ntl_nt_type  => '||pi_ntl_nt_type
                                              ||CHR(10)||'ntl_layer_id => '||pi_ntl_layer_id
                    );
--
END lock_ntl;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NTL_PK constraint
--
PROCEDURE lock_ntl (pi_ntl_nt_type       nm_type_layers.ntl_nt_type%TYPE
                   ,pi_ntl_layer_id      nm_type_layers.ntl_layer_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ntl');
--
   l_rowid := lock_ntl
                   (pi_ntl_nt_type       => pi_ntl_nt_type
                   ,pi_ntl_layer_id      => pi_ntl_layer_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ntl');
--
END lock_ntl;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NTL_PK constraint
--
FUNCTION lock_ntl_all (pi_ntl_nt_type       nm_type_layers_all.ntl_nt_type%TYPE
                      ,pi_ntl_layer_id      nm_type_layers_all.ntl_layer_id%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_ntl_all IS
   SELECT /*+ INDEX (ntl_all NTL_PK) */ ROWID
    FROM  nm_type_layers_all ntl_all
   WHERE  ntl_all.ntl_nt_type  = pi_ntl_nt_type
    AND   ntl_all.ntl_layer_id = pi_ntl_layer_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ntl_all');
--
   OPEN  cs_ntl_all;
   FETCH cs_ntl_all INTO l_retval;
   l_found := cs_ntl_all%FOUND;
   CLOSE cs_ntl_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_type_layers_all (NTL_PK)'
                                              ||CHR(10)||'ntl_nt_type  => '||pi_ntl_nt_type
                                              ||CHR(10)||'ntl_layer_id => '||pi_ntl_layer_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ntl_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_type_layers_all (NTL_PK)'
                                              ||CHR(10)||'ntl_nt_type  => '||pi_ntl_nt_type
                                              ||CHR(10)||'ntl_layer_id => '||pi_ntl_layer_id
                    );
--
END lock_ntl_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NTL_PK constraint
--
PROCEDURE lock_ntl_all (pi_ntl_nt_type       nm_type_layers_all.ntl_nt_type%TYPE
                       ,pi_ntl_layer_id      nm_type_layers_all.ntl_layer_id%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ntl_all');
--
   l_rowid := lock_ntl_all
                   (pi_ntl_nt_type       => pi_ntl_nt_type
                   ,pi_ntl_layer_id      => pi_ntl_layer_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ntl_all');
--
END lock_ntl_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NSC_PK constraint
--
FUNCTION lock_nsc (pi_nsc_nw_type       nm_type_subclass.nsc_nw_type%TYPE
                  ,pi_nsc_sub_class     nm_type_subclass.nsc_sub_class%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nsc IS
   SELECT /*+ INDEX (nsc NSC_PK) */ ROWID
    FROM  nm_type_subclass nsc
   WHERE  nsc.nsc_nw_type   = pi_nsc_nw_type
    AND   nsc.nsc_sub_class = pi_nsc_sub_class
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsc');
--
   OPEN  cs_nsc;
   FETCH cs_nsc INTO l_retval;
   l_found := cs_nsc%FOUND;
   CLOSE cs_nsc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_type_subclass (NSC_PK)'
                                              ||CHR(10)||'nsc_nw_type   => '||pi_nsc_nw_type
                                              ||CHR(10)||'nsc_sub_class => '||pi_nsc_sub_class
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nsc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_type_subclass (NSC_PK)'
                                              ||CHR(10)||'nsc_nw_type   => '||pi_nsc_nw_type
                                              ||CHR(10)||'nsc_sub_class => '||pi_nsc_sub_class
                    );
--
END lock_nsc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NSC_PK constraint
--
PROCEDURE lock_nsc (pi_nsc_nw_type       nm_type_subclass.nsc_nw_type%TYPE
                   ,pi_nsc_sub_class     nm_type_subclass.nsc_sub_class%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsc');
--
   l_rowid := lock_nsc
                   (pi_nsc_nw_type       => pi_nsc_nw_type
                   ,pi_nsc_sub_class     => pi_nsc_sub_class
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nsc');
--
END lock_nsc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NSR_PK constraint
--
FUNCTION lock_nsr (pi_nsr_nw_type            nm_type_subclass_restrictions.nsr_nw_type%TYPE
                  ,pi_nsr_sub_class_new      nm_type_subclass_restrictions.nsr_sub_class_new%TYPE
                  ,pi_nsr_sub_class_existing nm_type_subclass_restrictions.nsr_sub_class_existing%TYPE
                  ,pi_raise_not_found        BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode      PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode         PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nsr IS
   SELECT /*+ INDEX (nsr NSR_PK) */ ROWID
    FROM  nm_type_subclass_restrictions nsr
   WHERE  nsr.nsr_nw_type            = pi_nsr_nw_type
    AND   nsr.nsr_sub_class_new      = pi_nsr_sub_class_new
    AND   nsr.nsr_sub_class_existing = pi_nsr_sub_class_existing
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsr');
--
   OPEN  cs_nsr;
   FETCH cs_nsr INTO l_retval;
   l_found := cs_nsr%FOUND;
   CLOSE cs_nsr;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_type_subclass_restrictions (NSR_PK)'
                                              ||CHR(10)||'nsr_nw_type            => '||pi_nsr_nw_type
                                              ||CHR(10)||'nsr_sub_class_new      => '||pi_nsr_sub_class_new
                                              ||CHR(10)||'nsr_sub_class_existing => '||pi_nsr_sub_class_existing
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nsr');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_type_subclass_restrictions (NSR_PK)'
                                              ||CHR(10)||'nsr_nw_type            => '||pi_nsr_nw_type
                                              ||CHR(10)||'nsr_sub_class_new      => '||pi_nsr_sub_class_new
                                              ||CHR(10)||'nsr_sub_class_existing => '||pi_nsr_sub_class_existing
                    );
--
END lock_nsr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NSR_PK constraint
--
PROCEDURE lock_nsr (pi_nsr_nw_type            nm_type_subclass_restrictions.nsr_nw_type%TYPE
                   ,pi_nsr_sub_class_new      nm_type_subclass_restrictions.nsr_sub_class_new%TYPE
                   ,pi_nsr_sub_class_existing nm_type_subclass_restrictions.nsr_sub_class_existing%TYPE
                   ,pi_raise_not_found        BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode      PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode         PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nsr');
--
   l_rowid := lock_nsr
                   (pi_nsr_nw_type            => pi_nsr_nw_type
                   ,pi_nsr_sub_class_new      => pi_nsr_sub_class_new
                   ,pi_nsr_sub_class_existing => pi_nsr_sub_class_existing
                   ,pi_raise_not_found        => pi_raise_not_found
                   ,pi_not_found_sqlcode      => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nsr');
--
END lock_nsr;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using UN_PK constraint
--
FUNCTION lock_un (pi_un_unit_id        nm_units.un_unit_id%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) RETURN ROWID IS
--
   CURSOR cs_un IS
   SELECT /*+ INDEX (un UN_PK) */ ROWID
    FROM  nm_units un
   WHERE  un.un_unit_id = pi_un_unit_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_un');
--
   OPEN  cs_un;
   FETCH cs_un INTO l_retval;
   l_found := cs_un%FOUND;
   CLOSE cs_un;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_units (UN_PK)'
                                              ||CHR(10)||'un_unit_id => '||pi_un_unit_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_un');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_units (UN_PK)'
                                              ||CHR(10)||'un_unit_id => '||pi_un_unit_id
                    );
--
END lock_un;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using UN_PK constraint
--
PROCEDURE lock_un (pi_un_unit_id        nm_units.un_unit_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_un');
--
   l_rowid := lock_un
                   (pi_un_unit_id        => pi_un_unit_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_un');
--
END lock_un;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using UC_PK constraint
--
FUNCTION lock_uc (pi_uc_unit_id_in     nm_unit_conversions.uc_unit_id_in%TYPE
                 ,pi_uc_unit_id_out    nm_unit_conversions.uc_unit_id_out%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) RETURN ROWID IS
--
   CURSOR cs_uc IS
   SELECT /*+ INDEX (uc UC_PK) */ ROWID
    FROM  nm_unit_conversions uc
   WHERE  uc.uc_unit_id_in  = pi_uc_unit_id_in
    AND   uc.uc_unit_id_out = pi_uc_unit_id_out
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_uc');
--
   OPEN  cs_uc;
   FETCH cs_uc INTO l_retval;
   l_found := cs_uc%FOUND;
   CLOSE cs_uc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_unit_conversions (UC_PK)'
                                              ||CHR(10)||'uc_unit_id_in  => '||pi_uc_unit_id_in
                                              ||CHR(10)||'uc_unit_id_out => '||pi_uc_unit_id_out
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_uc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_unit_conversions (UC_PK)'
                                              ||CHR(10)||'uc_unit_id_in  => '||pi_uc_unit_id_in
                                              ||CHR(10)||'uc_unit_id_out => '||pi_uc_unit_id_out
                    );
--
END lock_uc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using UC_PK constraint
--
PROCEDURE lock_uc (pi_uc_unit_id_in     nm_unit_conversions.uc_unit_id_in%TYPE
                  ,pi_uc_unit_id_out    nm_unit_conversions.uc_unit_id_out%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_uc');
--
   l_rowid := lock_uc
                   (pi_uc_unit_id_in     => pi_uc_unit_id_in
                   ,pi_uc_unit_id_out    => pi_uc_unit_id_out
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_uc');
--
END lock_uc;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using UK_PK constraint
--
FUNCTION lock_ud (pi_ud_domain_id      nm_unit_domains.ud_domain_id%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                 ) RETURN ROWID IS
--
   CURSOR cs_ud IS
   SELECT /*+ INDEX (ud UK_PK) */ ROWID
    FROM  nm_unit_domains ud
   WHERE  ud.ud_domain_id = pi_ud_domain_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ud');
--
   OPEN  cs_ud;
   FETCH cs_ud INTO l_retval;
   l_found := cs_ud%FOUND;
   CLOSE cs_ud;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_unit_domains (UK_PK)'
                                              ||CHR(10)||'ud_domain_id => '||pi_ud_domain_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_ud');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_unit_domains (UK_PK)'
                                              ||CHR(10)||'ud_domain_id => '||pi_ud_domain_id
                    );
--
END lock_ud;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using UK_PK constraint
--
PROCEDURE lock_ud (pi_ud_domain_id      nm_unit_domains.ud_domain_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ud');
--
   l_rowid := lock_ud
                   (pi_ud_domain_id      => pi_ud_domain_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_ud');
--
END lock_ud;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NUF_PK constraint
--
FUNCTION lock_nuf (pi_name              nm_upload_files.name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nuf IS
   SELECT /*+ INDEX (nuf NUF_PK) */ ROWID
    FROM  nm_upload_files nuf
   WHERE  nuf.name = pi_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nuf');
--
   OPEN  cs_nuf;
   FETCH cs_nuf INTO l_retval;
   l_found := cs_nuf%FOUND;
   CLOSE cs_nuf;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_upload_files (NUF_PK)'
                                              ||CHR(10)||'name => '||pi_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nuf');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_upload_files (NUF_PK)'
                                              ||CHR(10)||'name => '||pi_name
                    );
--
END lock_nuf;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NUF_PK constraint
--
PROCEDURE lock_nuf (pi_name              nm_upload_files.name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nuf');
--
   l_rowid := lock_nuf
                   (pi_name              => pi_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nuf');
--
END lock_nuf;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NUFPART_PK constraint
--
FUNCTION lock_nufp (pi_document          nm_upload_filespart.document%TYPE
                   ,pi_part              nm_upload_filespart.part%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nufp IS
   SELECT /*+ INDEX (nufp NUFPART_PK) */ ROWID
    FROM  nm_upload_filespart nufp
   WHERE  nufp.document = pi_document
    AND   nufp.part     = pi_part
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nufp');
--
   OPEN  cs_nufp;
   FETCH cs_nufp INTO l_retval;
   l_found := cs_nufp%FOUND;
   CLOSE cs_nufp;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_upload_filespart (NUFPART_PK)'
                                              ||CHR(10)||'document => '||pi_document
                                              ||CHR(10)||'part     => '||pi_part
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nufp');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_upload_filespart (NUFPART_PK)'
                                              ||CHR(10)||'document => '||pi_document
                                              ||CHR(10)||'part     => '||pi_part
                    );
--
END lock_nufp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NUFPART_PK constraint
--
PROCEDURE lock_nufp (pi_document          nm_upload_filespart.document%TYPE
                    ,pi_part              nm_upload_filespart.part%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nufp');
--
   l_rowid := lock_nufp
                   (pi_document          => pi_document
                   ,pi_part              => pi_part
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nufp');
--
END lock_nufp;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NUA_PK constraint
--
FUNCTION lock_nua (pi_nua_user_id       nm_user_aus.nua_user_id%TYPE
                  ,pi_nua_admin_unit    nm_user_aus.nua_admin_unit%TYPE
                  ,pi_nua_start_date    nm_user_aus.nua_start_date%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nua IS
   SELECT /*+ INDEX (nua NUA_PK) */ ROWID
    FROM  nm_user_aus nua
   WHERE  nua.nua_user_id    = pi_nua_user_id
    AND   nua.nua_admin_unit = pi_nua_admin_unit
    AND   nua.nua_start_date = pi_nua_start_date
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nua');
--
   OPEN  cs_nua;
   FETCH cs_nua INTO l_retval;
   l_found := cs_nua%FOUND;
   CLOSE cs_nua;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_user_aus (NUA_PK)'
                                              ||CHR(10)||'nua_user_id    => '||pi_nua_user_id
                                              ||CHR(10)||'nua_admin_unit => '||pi_nua_admin_unit
                                              ||CHR(10)||'nua_start_date => '||pi_nua_start_date
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nua');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_user_aus (NUA_PK)'
                                              ||CHR(10)||'nua_user_id    => '||pi_nua_user_id
                                              ||CHR(10)||'nua_admin_unit => '||pi_nua_admin_unit
                                              ||CHR(10)||'nua_start_date => '||pi_nua_start_date
                    );
--
END lock_nua;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NUA_PK constraint
--
PROCEDURE lock_nua (pi_nua_user_id       nm_user_aus.nua_user_id%TYPE
                   ,pi_nua_admin_unit    nm_user_aus.nua_admin_unit%TYPE
                   ,pi_nua_start_date    nm_user_aus.nua_start_date%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nua');
--
   l_rowid := lock_nua
                   (pi_nua_user_id       => pi_nua_user_id
                   ,pi_nua_admin_unit    => pi_nua_admin_unit
                   ,pi_nua_start_date    => pi_nua_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nua');
--
END lock_nua;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NUA_PK constraint (without start date for Datetrack View)
--
FUNCTION lock_nua (pi_nua_user_id       nm_user_aus.nua_user_id%TYPE
                  ,pi_nua_admin_unit    nm_user_aus.nua_admin_unit%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nua IS
   SELECT /*+ INDEX (nua NUA_PK) */ ROWID
    FROM  nm_user_aus nua
   WHERE  nua.nua_user_id    = pi_nua_user_id
    AND   nua.nua_admin_unit = pi_nua_admin_unit
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nua');
--
   OPEN  cs_nua;
   FETCH cs_nua INTO l_retval;
   l_found := cs_nua%FOUND;
   CLOSE cs_nua;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_user_aus (NUA_PK)'
                                              ||CHR(10)||'nua_user_id    => '||pi_nua_user_id
                                              ||CHR(10)||'nua_admin_unit => '||pi_nua_admin_unit
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nua');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_user_aus (NUA_PK)'
                                              ||CHR(10)||'nua_user_id    => '||pi_nua_user_id
                                              ||CHR(10)||'nua_admin_unit => '||pi_nua_admin_unit
                    );
--
END lock_nua;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NUA_PK constraint (without start date for Datetrack View)
--
PROCEDURE lock_nua (pi_nua_user_id       nm_user_aus.nua_user_id%TYPE
                   ,pi_nua_admin_unit    nm_user_aus.nua_admin_unit%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nua');
--
   l_rowid := lock_nua
                   (pi_nua_user_id       => pi_nua_user_id
                   ,pi_nua_admin_unit    => pi_nua_admin_unit
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nua');
--
END lock_nua;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NUA_PK constraint
--
FUNCTION lock_nua_all (pi_nua_user_id       nm_user_aus_all.nua_user_id%TYPE
                      ,pi_nua_admin_unit    nm_user_aus_all.nua_admin_unit%TYPE
                      ,pi_nua_start_date    nm_user_aus_all.nua_start_date%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                      ) RETURN ROWID IS
--
   CURSOR cs_nua_all IS
   SELECT /*+ INDEX (nua_all NUA_PK) */ ROWID
    FROM  nm_user_aus_all nua_all
   WHERE  nua_all.nua_user_id    = pi_nua_user_id
    AND   nua_all.nua_admin_unit = pi_nua_admin_unit
    AND   nua_all.nua_start_date = pi_nua_start_date
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nua_all');
--
   OPEN  cs_nua_all;
   FETCH cs_nua_all INTO l_retval;
   l_found := cs_nua_all%FOUND;
   CLOSE cs_nua_all;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_user_aus_all (NUA_PK)'
                                              ||CHR(10)||'nua_user_id    => '||pi_nua_user_id
                                              ||CHR(10)||'nua_admin_unit => '||pi_nua_admin_unit
                                              ||CHR(10)||'nua_start_date => '||pi_nua_start_date
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nua_all');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_user_aus_all (NUA_PK)'
                                              ||CHR(10)||'nua_user_id    => '||pi_nua_user_id
                                              ||CHR(10)||'nua_admin_unit => '||pi_nua_admin_unit
                                              ||CHR(10)||'nua_start_date => '||pi_nua_start_date
                    );
--
END lock_nua_all;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NUA_PK constraint
--
PROCEDURE lock_nua_all (pi_nua_user_id       nm_user_aus_all.nua_user_id%TYPE
                       ,pi_nua_admin_unit    nm_user_aus_all.nua_admin_unit%TYPE
                       ,pi_nua_start_date    nm_user_aus_all.nua_start_date%TYPE
                       ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                       ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                       ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                       ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nua_all');
--
   l_rowid := lock_nua_all
                   (pi_nua_user_id       => pi_nua_user_id
                   ,pi_nua_admin_unit    => pi_nua_admin_unit
                   ,pi_nua_start_date    => pi_nua_start_date
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nua_all');
--
END lock_nua_all;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NVA_PK constraint
--
FUNCTION lock_nva (pi_nva_id            nm_visual_attributes.nva_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nva IS
   SELECT /*+ INDEX (nva NVA_PK) */ ROWID
    FROM  nm_visual_attributes nva
   WHERE  nva.nva_id = pi_nva_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nva');
--
   OPEN  cs_nva;
   FETCH cs_nva INTO l_retval;
   l_found := cs_nva%FOUND;
   CLOSE cs_nva;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_visual_attributes (NVA_PK)'
                                              ||CHR(10)||'nva_id => '||pi_nva_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nva');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_visual_attributes (NVA_PK)'
                                              ||CHR(10)||'nva_id => '||pi_nva_id
                    );
--
END lock_nva;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NVA_PK constraint
--
PROCEDURE lock_nva (pi_nva_id            nm_visual_attributes.nva_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nva');
--
   l_rowid := lock_nva
                   (pi_nva_id            => pi_nva_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nva');
--
END lock_nva;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NM_XML_FILES_PK constraint
--
FUNCTION lock_nxf (pi_nxf_file_type     nm_xml_files.nxf_file_type%TYPE
                  ,pi_nxf_type          nm_xml_files.nxf_type%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nxf IS
   SELECT /*+ INDEX (nxf NM_XML_FILES_PK) */ ROWID
    FROM  nm_xml_files nxf
   WHERE  nxf.nxf_file_type = pi_nxf_file_type
    AND   nxf.nxf_type      = pi_nxf_type
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxf');
--
   OPEN  cs_nxf;
   FETCH cs_nxf INTO l_retval;
   l_found := cs_nxf%FOUND;
   CLOSE cs_nxf;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_xml_files (NM_XML_FILES_PK)'
                                              ||CHR(10)||'nxf_file_type => '||pi_nxf_file_type
                                              ||CHR(10)||'nxf_type      => '||pi_nxf_type
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nxf');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_xml_files (NM_XML_FILES_PK)'
                                              ||CHR(10)||'nxf_file_type => '||pi_nxf_file_type
                                              ||CHR(10)||'nxf_type      => '||pi_nxf_type
                    );
--
END lock_nxf;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NM_XML_FILES_PK constraint
--
PROCEDURE lock_nxf (pi_nxf_file_type     nm_xml_files.nxf_file_type%TYPE
                   ,pi_nxf_type          nm_xml_files.nxf_type%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxf');
--
   l_rowid := lock_nxf
                   (pi_nxf_file_type     => pi_nxf_file_type
                   ,pi_nxf_type          => pi_nxf_type
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nxf');
--
END lock_nxf;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NM_XML_BATCHES_PK constraint
--
FUNCTION lock_nxb (pi_nxb_batch_id      nm_xml_load_batches.nxb_batch_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nxb IS
   SELECT /*+ INDEX (nxb NM_XML_BATCHES_PK) */ ROWID
    FROM  nm_xml_load_batches nxb
   WHERE  nxb.nxb_batch_id = pi_nxb_batch_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxb');
--
   OPEN  cs_nxb;
   FETCH cs_nxb INTO l_retval;
   l_found := cs_nxb%FOUND;
   CLOSE cs_nxb;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_xml_load_batches (NM_XML_BATCHES_PK)'
                                              ||CHR(10)||'nxb_batch_id => '||pi_nxb_batch_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nxb');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_xml_load_batches (NM_XML_BATCHES_PK)'
                                              ||CHR(10)||'nxb_batch_id => '||pi_nxb_batch_id
                    );
--
END lock_nxb;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NM_XML_BATCHES_PK constraint
--
PROCEDURE lock_nxb (pi_nxb_batch_id      nm_xml_load_batches.nxb_batch_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxb');
--
   l_rowid := lock_nxb
                   (pi_nxb_batch_id      => pi_nxb_batch_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nxb');
--
END lock_nxb;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NM_XML_LOAD_ERRORS_PK constraint
--
FUNCTION lock_nxle (pi_nxl_batch_id      nm_xml_load_errors.nxl_batch_id%TYPE
                   ,pi_nxl_record_id     nm_xml_load_errors.nxl_record_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nxle IS
   SELECT /*+ INDEX (nxle NM_XML_LOAD_ERRORS_PK) */ ROWID
    FROM  nm_xml_load_errors nxle
   WHERE  nxle.nxl_batch_id  = pi_nxl_batch_id
    AND   nxle.nxl_record_id = pi_nxl_record_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxle');
--
   OPEN  cs_nxle;
   FETCH cs_nxle INTO l_retval;
   l_found := cs_nxle%FOUND;
   CLOSE cs_nxle;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_xml_load_errors (NM_XML_LOAD_ERRORS_PK)'
                                              ||CHR(10)||'nxl_batch_id  => '||pi_nxl_batch_id
                                              ||CHR(10)||'nxl_record_id => '||pi_nxl_record_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nxle');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_xml_load_errors (NM_XML_LOAD_ERRORS_PK)'
                                              ||CHR(10)||'nxl_batch_id  => '||pi_nxl_batch_id
                                              ||CHR(10)||'nxl_record_id => '||pi_nxl_record_id
                    );
--
END lock_nxle;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NM_XML_LOAD_ERRORS_PK constraint
--
PROCEDURE lock_nxle (pi_nxl_batch_id      nm_xml_load_errors.nxl_batch_id%TYPE
                    ,pi_nxl_record_id     nm_xml_load_errors.nxl_record_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxle');
--
   l_rowid := lock_nxle
                   (pi_nxl_batch_id      => pi_nxl_batch_id
                   ,pi_nxl_record_id     => pi_nxl_record_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nxle');
--
END lock_nxle;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NWX_PK constraint
--
FUNCTION lock_nwx (pi_nwx_nw_type       nm_nw_xsp.nwx_nw_type%TYPE
                  ,pi_nwx_x_sect        nm_nw_xsp.nwx_x_sect%TYPE
                  ,pi_nwx_nsc_sub_class nm_nw_xsp.nwx_nsc_sub_class%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nwx IS
   SELECT /*+ INDEX (nwx NWX_PK) */ ROWID
    FROM  nm_nw_xsp nwx
   WHERE  nwx.nwx_nw_type       = pi_nwx_nw_type
    AND   nwx.nwx_x_sect        = pi_nwx_x_sect
    AND   nwx.nwx_nsc_sub_class = pi_nwx_nsc_sub_class
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nwx');
--
   OPEN  cs_nwx;
   FETCH cs_nwx INTO l_retval;
   l_found := cs_nwx%FOUND;
   CLOSE cs_nwx;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_nw_xsp (NWX_PK)'
                                              ||CHR(10)||'nwx_nw_type       => '||pi_nwx_nw_type
                                              ||CHR(10)||'nwx_x_sect        => '||pi_nwx_x_sect
                                              ||CHR(10)||'nwx_nsc_sub_class => '||pi_nwx_nsc_sub_class
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nwx');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_nw_xsp (NWX_PK)'
                                              ||CHR(10)||'nwx_nw_type       => '||pi_nwx_nw_type
                                              ||CHR(10)||'nwx_x_sect        => '||pi_nwx_x_sect
                                              ||CHR(10)||'nwx_nsc_sub_class => '||pi_nwx_nsc_sub_class
                    );
--
END lock_nwx;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NWX_PK constraint
--
PROCEDURE lock_nwx (pi_nwx_nw_type       nm_nw_xsp.nwx_nw_type%TYPE
                   ,pi_nwx_x_sect        nm_nw_xsp.nwx_x_sect%TYPE
                   ,pi_nwx_nsc_sub_class nm_nw_xsp.nwx_nsc_sub_class%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nwx');
--
   l_rowid := lock_nwx
                   (pi_nwx_nw_type       => pi_nwx_nw_type
                   ,pi_nwx_x_sect        => pi_nwx_x_sect
                   ,pi_nwx_nsc_sub_class => pi_nwx_nsc_sub_class
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nwx');
--
END lock_nwx;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NXD_PK constraint
--
FUNCTION lock_nxd (pi_nxd_rule_id       nm_x_driving_conditions.nxd_rule_id%TYPE
                  ,pi_nxd_rule_seq_no   nm_x_driving_conditions.nxd_rule_seq_no%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nxd IS
   SELECT /*+ INDEX (nxd NXD_PK) */ ROWID
    FROM  nm_x_driving_conditions nxd
   WHERE  nxd.nxd_rule_id     = pi_nxd_rule_id
    AND   nxd.nxd_rule_seq_no = pi_nxd_rule_seq_no
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxd');
--
   OPEN  cs_nxd;
   FETCH cs_nxd INTO l_retval;
   l_found := cs_nxd%FOUND;
   CLOSE cs_nxd;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_x_driving_conditions (NXD_PK)'
                                              ||CHR(10)||'nxd_rule_id     => '||pi_nxd_rule_id
                                              ||CHR(10)||'nxd_rule_seq_no => '||pi_nxd_rule_seq_no
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nxd');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_x_driving_conditions (NXD_PK)'
                                              ||CHR(10)||'nxd_rule_id     => '||pi_nxd_rule_id
                                              ||CHR(10)||'nxd_rule_seq_no => '||pi_nxd_rule_seq_no
                    );
--
END lock_nxd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NXD_PK constraint
--
PROCEDURE lock_nxd (pi_nxd_rule_id       nm_x_driving_conditions.nxd_rule_id%TYPE
                   ,pi_nxd_rule_seq_no   nm_x_driving_conditions.nxd_rule_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxd');
--
   l_rowid := lock_nxd
                   (pi_nxd_rule_id       => pi_nxd_rule_id
                   ,pi_nxd_rule_seq_no   => pi_nxd_rule_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nxd');
--
END lock_nxd;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NXE_PK constraint
--
FUNCTION lock_nxe (pi_nxe_id            nm_x_errors.nxe_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nxe IS
   SELECT /*+ INDEX (nxe NXE_PK) */ ROWID
    FROM  nm_x_errors nxe
   WHERE  nxe.nxe_id = pi_nxe_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxe');
--
   OPEN  cs_nxe;
   FETCH cs_nxe INTO l_retval;
   l_found := cs_nxe%FOUND;
   CLOSE cs_nxe;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_x_errors (NXE_PK)'
                                              ||CHR(10)||'nxe_id => '||pi_nxe_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nxe');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_x_errors (NXE_PK)'
                                              ||CHR(10)||'nxe_id => '||pi_nxe_id
                    );
--
END lock_nxe;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NXE_PK constraint
--
PROCEDURE lock_nxe (pi_nxe_id            nm_x_errors.nxe_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxe');
--
   l_rowid := lock_nxe
                   (pi_nxe_id            => pi_nxe_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nxe');
--
END lock_nxe;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NXIC_PK constraint
--
FUNCTION lock_nxic (pi_nxic_id           nm_x_inv_conditions.nxic_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nxic IS
   SELECT /*+ INDEX (nxic NXIC_PK) */ ROWID
    FROM  nm_x_inv_conditions nxic
   WHERE  nxic.nxic_id = pi_nxic_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxic');
--
   OPEN  cs_nxic;
   FETCH cs_nxic INTO l_retval;
   l_found := cs_nxic%FOUND;
   CLOSE cs_nxic;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_x_inv_conditions (NXIC_PK)'
                                              ||CHR(10)||'nxic_id => '||pi_nxic_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nxic');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_x_inv_conditions (NXIC_PK)'
                                              ||CHR(10)||'nxic_id => '||pi_nxic_id
                    );
--
END lock_nxic;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NXIC_PK constraint
--
PROCEDURE lock_nxic (pi_nxic_id           nm_x_inv_conditions.nxic_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxic');
--
   l_rowid := lock_nxic
                   (pi_nxic_id           => pi_nxic_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nxic');
--
END lock_nxic;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NXL_PK constraint
--
FUNCTION lock_nxl (pi_nxl_rule_id       nm_x_location_rules.nxl_rule_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nxl IS
   SELECT /*+ INDEX (nxl NXL_PK) */ ROWID
    FROM  nm_x_location_rules nxl
   WHERE  nxl.nxl_rule_id = pi_nxl_rule_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxl');
--
   OPEN  cs_nxl;
   FETCH cs_nxl INTO l_retval;
   l_found := cs_nxl%FOUND;
   CLOSE cs_nxl;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_x_location_rules (NXL_PK)'
                                              ||CHR(10)||'nxl_rule_id => '||pi_nxl_rule_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nxl');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_x_location_rules (NXL_PK)'
                                              ||CHR(10)||'nxl_rule_id => '||pi_nxl_rule_id
                    );
--
END lock_nxl;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NXL_PK constraint
--
PROCEDURE lock_nxl (pi_nxl_rule_id       nm_x_location_rules.nxl_rule_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxl');
--
   l_rowid := lock_nxl
                   (pi_nxl_rule_id       => pi_nxl_rule_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nxl');
--
END lock_nxl;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NXN_PK constraint
--
FUNCTION lock_nxn (pi_nxn_rule_id       nm_x_nw_rules.nxn_rule_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nxn IS
   SELECT /*+ INDEX (nxn NXN_PK) */ ROWID
    FROM  nm_x_nw_rules nxn
   WHERE  nxn.nxn_rule_id = pi_nxn_rule_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxn');
--
   OPEN  cs_nxn;
   FETCH cs_nxn INTO l_retval;
   l_found := cs_nxn%FOUND;
   CLOSE cs_nxn;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_x_nw_rules (NXN_PK)'
                                              ||CHR(10)||'nxn_rule_id => '||pi_nxn_rule_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nxn');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_x_nw_rules (NXN_PK)'
                                              ||CHR(10)||'nxn_rule_id => '||pi_nxn_rule_id
                    );
--
END lock_nxn;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NXN_PK constraint
--
PROCEDURE lock_nxn (pi_nxn_rule_id       nm_x_nw_rules.nxn_rule_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxn');
--
   l_rowid := lock_nxn
                   (pi_nxn_rule_id       => pi_nxn_rule_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nxn');
--
END lock_nxn;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using PK_NM_X_RULES constraint
--
FUNCTION lock_nxr (pi_nxr_rule_id       nm_x_rules.nxr_rule_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nxr IS
   SELECT /*+ INDEX (nxr PK_NM_X_RULES) */ ROWID
    FROM  nm_x_rules nxr
   WHERE  nxr.nxr_rule_id = pi_nxr_rule_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxr');
--
   OPEN  cs_nxr;
   FETCH cs_nxr INTO l_retval;
   l_found := cs_nxr%FOUND;
   CLOSE cs_nxr;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_x_rules (PK_NM_X_RULES)'
                                              ||CHR(10)||'nxr_rule_id => '||pi_nxr_rule_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nxr');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_x_rules (PK_NM_X_RULES)'
                                              ||CHR(10)||'nxr_rule_id => '||pi_nxr_rule_id
                    );
--
END lock_nxr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using PK_NM_X_RULES constraint
--
PROCEDURE lock_nxr (pi_nxr_rule_id       nm_x_rules.nxr_rule_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxr');
--
   l_rowid := lock_nxr
                   (pi_nxr_rule_id       => pi_nxr_rule_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nxr');
--
END lock_nxr;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NXV_PK constraint
--
FUNCTION lock_nxv (pi_nxv_rule_id       nm_x_val_conditions.nxv_rule_id%TYPE
                  ,pi_nxv_rule_seq_no   nm_x_val_conditions.nxv_rule_seq_no%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_nxv IS
   SELECT /*+ INDEX (nxv NXV_PK) */ ROWID
    FROM  nm_x_val_conditions nxv
   WHERE  nxv.nxv_rule_id     = pi_nxv_rule_id
    AND   nxv.nxv_rule_seq_no = pi_nxv_rule_seq_no
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxv');
--
   OPEN  cs_nxv;
   FETCH cs_nxv INTO l_retval;
   l_found := cs_nxv%FOUND;
   CLOSE cs_nxv;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_x_val_conditions (NXV_PK)'
                                              ||CHR(10)||'nxv_rule_id     => '||pi_nxv_rule_id
                                              ||CHR(10)||'nxv_rule_seq_no => '||pi_nxv_rule_seq_no
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nxv');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_x_val_conditions (NXV_PK)'
                                              ||CHR(10)||'nxv_rule_id     => '||pi_nxv_rule_id
                                              ||CHR(10)||'nxv_rule_seq_no => '||pi_nxv_rule_seq_no
                    );
--
END lock_nxv;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NXV_PK constraint
--
PROCEDURE lock_nxv (pi_nxv_rule_id       nm_x_val_conditions.nxv_rule_id%TYPE
                   ,pi_nxv_rule_seq_no   nm_x_val_conditions.nxv_rule_seq_no%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nxv');
--
   l_rowid := lock_nxv
                   (pi_nxv_rule_id       => pi_nxv_rule_id
                   ,pi_nxv_rule_seq_no   => pi_nxv_rule_seq_no
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nxv');
--
END lock_nxv;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using XSR_PK constraint
--
FUNCTION lock_xsr (pi_xsr_nw_type       nm_xsp_restraints.xsr_nw_type%TYPE
                  ,pi_xsr_ity_inv_code  nm_xsp_restraints.xsr_ity_inv_code%TYPE
                  ,pi_xsr_scl_class     nm_xsp_restraints.xsr_scl_class%TYPE
                  ,pi_xsr_x_sect_value  nm_xsp_restraints.xsr_x_sect_value%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_xsr IS
   SELECT /*+ INDEX (xsr XSR_PK) */ ROWID
    FROM  nm_xsp_restraints xsr
   WHERE  xsr.xsr_nw_type      = pi_xsr_nw_type
    AND   xsr.xsr_ity_inv_code = pi_xsr_ity_inv_code
    AND   xsr.xsr_scl_class    = pi_xsr_scl_class
    AND   xsr.xsr_x_sect_value = pi_xsr_x_sect_value
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_xsr');
--
   OPEN  cs_xsr;
   FETCH cs_xsr INTO l_retval;
   l_found := cs_xsr%FOUND;
   CLOSE cs_xsr;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_xsp_restraints (XSR_PK)'
                                              ||CHR(10)||'xsr_nw_type      => '||pi_xsr_nw_type
                                              ||CHR(10)||'xsr_ity_inv_code => '||pi_xsr_ity_inv_code
                                              ||CHR(10)||'xsr_scl_class    => '||pi_xsr_scl_class
                                              ||CHR(10)||'xsr_x_sect_value => '||pi_xsr_x_sect_value
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_xsr');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_xsp_restraints (XSR_PK)'
                                              ||CHR(10)||'xsr_nw_type      => '||pi_xsr_nw_type
                                              ||CHR(10)||'xsr_ity_inv_code => '||pi_xsr_ity_inv_code
                                              ||CHR(10)||'xsr_scl_class    => '||pi_xsr_scl_class
                                              ||CHR(10)||'xsr_x_sect_value => '||pi_xsr_x_sect_value
                    );
--
END lock_xsr;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using XSR_PK constraint
--
PROCEDURE lock_xsr (pi_xsr_nw_type       nm_xsp_restraints.xsr_nw_type%TYPE
                   ,pi_xsr_ity_inv_code  nm_xsp_restraints.xsr_ity_inv_code%TYPE
                   ,pi_xsr_scl_class     nm_xsp_restraints.xsr_scl_class%TYPE
                   ,pi_xsr_x_sect_value  nm_xsp_restraints.xsr_x_sect_value%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_xsr');
--
   l_rowid := lock_xsr
                   (pi_xsr_nw_type       => pi_xsr_nw_type
                   ,pi_xsr_ity_inv_code  => pi_xsr_ity_inv_code
                   ,pi_xsr_scl_class     => pi_xsr_scl_class
                   ,pi_xsr_x_sect_value  => pi_xsr_x_sect_value
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_xsr');
--
END lock_xsr;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using XRV_PK constraint
--
FUNCTION lock_xrv (pi_xrv_nw_type       nm_xsp_reversal.xrv_nw_type%TYPE
                  ,pi_xrv_old_sub_class nm_xsp_reversal.xrv_old_sub_class%TYPE
                  ,pi_xrv_old_xsp       nm_xsp_reversal.xrv_old_xsp%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_xrv IS
   SELECT /*+ INDEX (xrv XRV_PK) */ ROWID
    FROM  nm_xsp_reversal xrv
   WHERE  xrv.xrv_nw_type       = pi_xrv_nw_type
    AND   xrv.xrv_old_sub_class = pi_xrv_old_sub_class
    AND   xrv.xrv_old_xsp       = pi_xrv_old_xsp
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_xrv');
--
   OPEN  cs_xrv;
   FETCH cs_xrv INTO l_retval;
   l_found := cs_xrv%FOUND;
   CLOSE cs_xrv;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_xsp_reversal (XRV_PK)'
                                              ||CHR(10)||'xrv_nw_type       => '||pi_xrv_nw_type
                                              ||CHR(10)||'xrv_old_sub_class => '||pi_xrv_old_sub_class
                                              ||CHR(10)||'xrv_old_xsp       => '||pi_xrv_old_xsp
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_xrv');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_xsp_reversal (XRV_PK)'
                                              ||CHR(10)||'xrv_nw_type       => '||pi_xrv_nw_type
                                              ||CHR(10)||'xrv_old_sub_class => '||pi_xrv_old_sub_class
                                              ||CHR(10)||'xrv_old_xsp       => '||pi_xrv_old_xsp
                    );
--
END lock_xrv;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using XRV_PK constraint
--
PROCEDURE lock_xrv (pi_xrv_nw_type       nm_xsp_reversal.xrv_nw_type%TYPE
                   ,pi_xrv_old_sub_class nm_xsp_reversal.xrv_old_sub_class%TYPE
                   ,pi_xrv_old_xsp       nm_xsp_reversal.xrv_old_xsp%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_xrv');
--
   l_rowid := lock_xrv
                   (pi_xrv_nw_type       => pi_xrv_nw_type
                   ,pi_xrv_old_sub_class => pi_xrv_old_sub_class
                   ,pi_xrv_old_xsp       => pi_xrv_old_xsp
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_xrv');
--
END lock_xrv;
--
-----------------------------------------------------------------------------
--
END nm3lock_gen;
/
