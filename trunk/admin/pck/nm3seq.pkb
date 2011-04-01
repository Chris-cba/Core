CREATE OR REPLACE PACKAGE BODY nm3seq IS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3seq.pkb-arc   2.19   Apr 01 2011 12:51:50   Mike.Alexander  $
--       Module Name      : $Workfile:   nm3seq.pkb  $
--       Date into PVCS   : $Date:   Apr 01 2011 12:51:50  $
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
   g_package_name    CONSTANT  varchar2(30)   := 'nm3seq';
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
FUNCTION next_dac_id_seq RETURN PLS_INTEGER IS
-- Get DAC_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT DAC_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_dac_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_dac_id_seq RETURN PLS_INTEGER IS
-- Get DAC_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT DAC_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_dac_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_ddc_id_seq RETURN PLS_INTEGER IS
-- Get DDC_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT DDC_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_ddc_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_ddc_id_seq RETURN PLS_INTEGER IS
-- Get DDC_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT DDC_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_ddc_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_ddg_id_seq RETURN PLS_INTEGER IS
-- Get DDG_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT DDG_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_ddg_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_ddg_id_seq RETURN PLS_INTEGER IS
-- Get DDG_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT DDG_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_ddg_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_dlc_id_seq RETURN PLS_INTEGER IS
-- Get DLC_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT DLC_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_dlc_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_dlc_id_seq RETURN PLS_INTEGER IS
-- Get DLC_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT DLC_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_dlc_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_dmd_id_seq RETURN PLS_INTEGER IS
-- Get DMD_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT DMD_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_dmd_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_dmd_id_seq RETURN PLS_INTEGER IS
-- Get DMD_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT DMD_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_dmd_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_doc_id_seq RETURN PLS_INTEGER IS
-- Get DOC_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT DOC_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_doc_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_doc_id_seq RETURN PLS_INTEGER IS
-- Get DOC_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT DOC_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_doc_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_dq_id_seq RETURN PLS_INTEGER IS
-- Get DQ_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT DQ_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_dq_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_dq_id_seq RETURN PLS_INTEGER IS
-- Get DQ_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT DQ_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_dq_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_gis_session_id RETURN PLS_INTEGER IS
-- Get GIS_SESSION_ID.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT GIS_SESSION_ID.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_gis_session_id;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_gis_session_id RETURN PLS_INTEGER IS
-- Get GIS_SESSION_ID.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT GIS_SESSION_ID.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_gis_session_id;
--
-----------------------------------------------------------------------------
--
FUNCTION next_gss_id_seq RETURN PLS_INTEGER IS
-- Get GSS_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT GSS_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_gss_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_gss_id_seq RETURN PLS_INTEGER IS
-- Get GSS_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT GSS_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_gss_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_had_id_seq RETURN PLS_INTEGER IS
-- Get HAD_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT HAD_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_had_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_had_id_seq RETURN PLS_INTEGER IS
-- Get HAD_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT HAD_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_had_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_hct_id_seq RETURN PLS_INTEGER IS
-- Get HCT_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT HCT_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_hct_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_hct_id_seq RETURN PLS_INTEGER IS
-- Get HCT_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT HCT_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_hct_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_hus_user_id_seq RETURN PLS_INTEGER IS
-- Get HUS_USER_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT HUS_USER_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_hus_user_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_hus_user_id_seq RETURN PLS_INTEGER IS
-- Get HUS_USER_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT HUS_USER_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_hus_user_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_iid_item_id_seq RETURN PLS_INTEGER IS
-- Get IID_ITEM_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT IID_ITEM_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_iid_item_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_iid_item_id_seq RETURN PLS_INTEGER IS
-- Get IID_ITEM_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT IID_ITEM_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_iid_item_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_itb_banding_id_seq RETURN PLS_INTEGER IS
-- Get ITB_BANDING_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT ITB_BANDING_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_itb_banding_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_itb_banding_id_seq RETURN PLS_INTEGER IS
-- Get ITB_BANDING_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT ITB_BANDING_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_itb_banding_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_itd_band_seq_seq RETURN PLS_INTEGER IS
-- Get ITD_BAND_SEQ_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT ITD_BAND_SEQ_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_itd_band_seq_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_itd_band_seq_seq RETURN PLS_INTEGER IS
-- Get ITD_BAND_SEQ_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT ITD_BAND_SEQ_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_itd_band_seq_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nal_seq RETURN PLS_INTEGER IS
-- Get NAL_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NAL_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nal_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nal_seq RETURN PLS_INTEGER IS
-- Get NAL_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NAL_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nal_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nau_admin_unit_seq RETURN PLS_INTEGER IS
-- Get NAU_ADMIN_UNIT_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NAU_ADMIN_UNIT_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nau_admin_unit_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nau_admin_unit_seq RETURN PLS_INTEGER IS
-- Get NAU_ADMIN_UNIT_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NAU_ADMIN_UNIT_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nau_admin_unit_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nsty_id_seq RETURN PLS_INTEGER IS
-- Get NSTY_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NSTY_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nsty_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nsty_id_seq RETURN PLS_INTEGER IS
-- Get NSTY_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NSTY_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nsty_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nd_id_seq RETURN PLS_INTEGER IS
-- Get ND_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT ND_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nd_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nd_id_seq RETURN PLS_INTEGER IS
-- Get ND_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT ND_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nd_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_neh_id_seq RETURN PLS_INTEGER IS
-- Get NEH_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NEH_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_neh_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_neh_id_seq RETURN PLS_INTEGER IS
-- Get NEH_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NEH_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_neh_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nel_id_seq RETURN PLS_INTEGER IS
-- Get NEL_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NEL_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nel_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nel_id_seq RETURN PLS_INTEGER IS
-- Get NEL_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NEL_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nel_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_ne_id_seq RETURN PLS_INTEGER IS
-- Get NE_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NE_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_ne_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_ne_id_seq RETURN PLS_INTEGER IS
-- Get NE_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NE_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_ne_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_ngq_id_seq RETURN PLS_INTEGER IS
-- Get NGQ_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NGQ_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_ngq_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_ngq_id_seq RETURN PLS_INTEGER IS
-- Get NGQ_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NGQ_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_ngq_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_ngqa_seq_no_seq RETURN PLS_INTEGER IS
-- Get NGQA_SEQ_NO_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NGQA_SEQ_NO_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_ngqa_seq_no_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_ngqa_seq_no_seq RETURN PLS_INTEGER IS
-- Get NGQA_SEQ_NO_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NGQA_SEQ_NO_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_ngqa_seq_no_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_ngqt_seq_no_seq RETURN PLS_INTEGER IS
-- Get NGQT_SEQ_NO_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NGQT_SEQ_NO_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_ngqt_seq_no_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_ngqt_seq_no_seq RETURN PLS_INTEGER IS
-- Get NGQT_SEQ_NO_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NGQT_SEQ_NO_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_ngqt_seq_no_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nias_id_seq RETURN PLS_INTEGER IS
-- Get NIAS_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NIAS_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nias_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nias_id_seq RETURN PLS_INTEGER IS
-- Get NIAS_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NIAS_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nias_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_njc_job_id_seq RETURN PLS_INTEGER IS
-- Get NJC_JOB_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NJC_JOB_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_njc_job_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_njc_job_id_seq RETURN PLS_INTEGER IS
-- Get NJC_JOB_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NJC_JOB_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_njc_job_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_njo_id_seq RETURN PLS_INTEGER IS
-- Get NJO_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NJO_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_njo_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_njo_id_seq RETURN PLS_INTEGER IS
-- Get NJO_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NJO_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_njo_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nl_layer_id_seq RETURN PLS_INTEGER IS
-- Get NL_LAYER_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NL_LAYER_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nl_layer_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nl_layer_id_seq RETURN PLS_INTEGER IS
-- Get NL_LAYER_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NL_LAYER_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nl_layer_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nld_id_seq RETURN PLS_INTEGER IS
-- Get NLD_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NLD_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nld_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nld_id_seq RETURN PLS_INTEGER IS
-- Get NLD_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NLD_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nld_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nlf_id_seq RETURN PLS_INTEGER IS
-- Get NLF_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NLF_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nlf_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nlf_id_seq RETURN PLS_INTEGER IS
-- Get NLF_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NLF_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nlf_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nlt_id_seq RETURN PLS_INTEGER IS
-- Get NLT_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NLT_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nlt_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nlt_id_seq RETURN PLS_INTEGER IS
-- Get NLT_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NLT_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nlt_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nmf_id_seq RETURN PLS_INTEGER IS
-- Get NMF_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NMF_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nmf_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nmf_id_seq RETURN PLS_INTEGER IS
-- Get NMF_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NMF_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nmf_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nmg_id_seq RETURN PLS_INTEGER IS
-- Get NMG_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NMG_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nmg_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nmg_id_seq RETURN PLS_INTEGER IS
-- Get NMG_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NMG_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nmg_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nmmt_line_id_seq RETURN PLS_INTEGER IS
-- Get NMMT_LINE_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NMMT_LINE_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nmmt_line_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nmmt_line_id_seq RETURN PLS_INTEGER IS
-- Get NMMT_LINE_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NMMT_LINE_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nmmt_line_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nmm_id_seq RETURN PLS_INTEGER IS
-- Get NMM_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NMM_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nmm_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nmm_id_seq RETURN PLS_INTEGER IS
-- Get NMM_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NMM_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nmm_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nmq_id_seq RETURN PLS_INTEGER IS
-- Get NMQ_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NMQ_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nmq_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nmq_id_seq RETURN PLS_INTEGER IS
-- Get NMQ_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NMQ_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nmq_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nmu_id_seq RETURN PLS_INTEGER IS
-- Get NMU_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NMU_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nmu_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nmu_id_seq RETURN PLS_INTEGER IS
-- Get NMU_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NMU_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nmu_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nm_audit_temp_seq RETURN PLS_INTEGER IS
-- Get NM_AUDIT_TEMP_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NM_AUDIT_TEMP_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nm_audit_temp_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nm_audit_temp_seq RETURN PLS_INTEGER IS
-- Get NM_AUDIT_TEMP_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NM_AUDIT_TEMP_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nm_audit_temp_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nm_db_seq RETURN PLS_INTEGER IS
-- Get NM_DB_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NM_DB_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nm_db_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nm_db_seq RETURN PLS_INTEGER IS
-- Get NM_DB_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NM_DB_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nm_db_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nm_mrg_query_staging_seq RETURN PLS_INTEGER IS
-- Get NM_MRG_QUERY_STAGING_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NM_MRG_QUERY_STAGING_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nm_mrg_query_staging_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nm_mrg_query_staging_seq RETURN PLS_INTEGER IS
-- Get NM_MRG_QUERY_STAGING_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NM_MRG_QUERY_STAGING_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nm_mrg_query_staging_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nm_mrg_query_values_seq RETURN PLS_INTEGER IS
-- Get NM_MRG_QUERY_VALUES_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NM_MRG_QUERY_VALUES_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nm_mrg_query_values_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nm_mrg_query_values_seq RETURN PLS_INTEGER IS
-- Get NM_MRG_QUERY_VALUES_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NM_MRG_QUERY_VALUES_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nm_mrg_query_values_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_no_node_id_seq RETURN PLS_INTEGER IS
-- Get NO_NODE_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NO_NODE_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_no_node_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_no_node_id_seq RETURN PLS_INTEGER IS
-- Get NO_NODE_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NO_NODE_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_no_node_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_npq_id_seq RETURN PLS_INTEGER IS
-- Get NPQ_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NPQ_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_npq_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_npq_id_seq RETURN PLS_INTEGER IS
-- Get NPQ_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NPQ_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_npq_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_np_id_seq RETURN PLS_INTEGER IS
-- Get NP_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NP_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_np_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_np_id_seq RETURN PLS_INTEGER IS
-- Get NP_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NP_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_np_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nqt_seq_no_seq RETURN PLS_INTEGER IS
-- Get NQT_SEQ_NO_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NQT_SEQ_NO_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nqt_seq_no_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nqt_seq_no_seq RETURN PLS_INTEGER IS
-- Get NQT_SEQ_NO_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NQT_SEQ_NO_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nqt_seq_no_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nse_id_seq RETURN PLS_INTEGER IS
-- Get NSE_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NSE_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nse_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nse_id_seq RETURN PLS_INTEGER IS
-- Get NSE_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NSE_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nse_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nsm_id_seq RETURN PLS_INTEGER IS
-- Get NSM_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NSM_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nsm_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nsm_id_seq RETURN PLS_INTEGER IS
-- Get NSM_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NSM_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nsm_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nte_id_seq RETURN PLS_INTEGER IS
-- Get NTE_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NTE_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nte_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nte_id_seq RETURN PLS_INTEGER IS
-- Get NTE_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NTE_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nte_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nth_theme_id_seq RETURN PLS_INTEGER IS
-- Get NTH_THEME_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NTH_THEME_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nth_theme_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nth_theme_id_seq RETURN PLS_INTEGER IS
-- Get NTH_THEME_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NTH_THEME_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nth_theme_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nxic_id_seq RETURN PLS_INTEGER IS
-- Get NXIC_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NXIC_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nxic_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nxic_id_seq RETURN PLS_INTEGER IS
-- Get NXIC_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NXIC_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nxic_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nxr_id_seq RETURN PLS_INTEGER IS
-- Get NXR_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NXR_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nxr_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nxr_id_seq RETURN PLS_INTEGER IS
-- Get NXR_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NXR_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nxr_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_rtg_job_id_seq RETURN PLS_INTEGER IS
-- Get RTG_JOB_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT RTG_JOB_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_rtg_job_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_rtg_job_id_seq RETURN PLS_INTEGER IS
-- Get RTG_JOB_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT RTG_JOB_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_rtg_job_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_ud_domain_id_seq RETURN PLS_INTEGER IS
-- Get UD_DOMAIN_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT UD_DOMAIN_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_ud_domain_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_ud_domain_id_seq RETURN PLS_INTEGER IS
-- Get UD_DOMAIN_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT UD_DOMAIN_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_ud_domain_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_un_unit_id_seq RETURN PLS_INTEGER IS
-- Get UN_UNIT_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT UN_UNIT_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_un_unit_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_un_unit_id_seq RETURN PLS_INTEGER IS
-- Get UN_UNIT_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT UN_UNIT_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_un_unit_id_seq;
--
-----------------------------------------------------------------------------
--
END nm3seq;
/
