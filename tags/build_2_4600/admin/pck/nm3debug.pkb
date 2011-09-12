CREATE OR REPLACE PACKAGE BODY nm3debug IS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3debug.pkb-arc   2.20   Sep 12 2011 12:34:46   Mike.Alexander  $
--       Module Name      : $Workfile:   nm3debug.pkb  $
--       Date into PVCS   : $Date:   Sep 12 2011 12:34:46  $
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
   g_package_name    CONSTANT  varchar2(30)   := 'nm3debug';
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
PROCEDURE debug_doc (pi_rec_doc docs%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_doc');
--
   nm_debug.debug('doc_id                       : '||pi_rec_doc.doc_id,p_level);
   nm_debug.debug('doc_title                    : '||pi_rec_doc.doc_title,p_level);
   nm_debug.debug('doc_dcl_code                 : '||pi_rec_doc.doc_dcl_code,p_level);
   nm_debug.debug('doc_dtp_code                 : '||pi_rec_doc.doc_dtp_code,p_level);
   nm_debug.debug('doc_date_expires             : '||pi_rec_doc.doc_date_expires,p_level);
   nm_debug.debug('doc_date_issued              : '||pi_rec_doc.doc_date_issued,p_level);
   nm_debug.debug('doc_file                     : '||pi_rec_doc.doc_file,p_level);
   nm_debug.debug('doc_reference_code           : '||pi_rec_doc.doc_reference_code,p_level);
   nm_debug.debug('doc_issue_number             : '||pi_rec_doc.doc_issue_number,p_level);
   nm_debug.debug('doc_dlc_id                   : '||pi_rec_doc.doc_dlc_id,p_level);
   nm_debug.debug('doc_dlc_dmd_id               : '||pi_rec_doc.doc_dlc_dmd_id,p_level);
   nm_debug.debug('doc_descr                    : '||pi_rec_doc.doc_descr,p_level);
   nm_debug.debug('doc_user_id                  : '||pi_rec_doc.doc_user_id,p_level);
   nm_debug.debug('doc_category                 : '||pi_rec_doc.doc_category,p_level);
   nm_debug.debug('doc_admin_unit               : '||pi_rec_doc.doc_admin_unit,p_level);
   nm_debug.debug('doc_status_code              : '||pi_rec_doc.doc_status_code,p_level);
   nm_debug.debug('doc_status_date              : '||pi_rec_doc.doc_status_date,p_level);
   nm_debug.debug('doc_reason                   : '||pi_rec_doc.doc_reason,p_level);
   nm_debug.debug('doc_compl_type               : '||pi_rec_doc.doc_compl_type,p_level);
   nm_debug.debug('doc_compl_source             : '||pi_rec_doc.doc_compl_source,p_level);
   nm_debug.debug('doc_compl_ack_flag           : '||pi_rec_doc.doc_compl_ack_flag,p_level);
   nm_debug.debug('doc_compl_ack_date           : '||pi_rec_doc.doc_compl_ack_date,p_level);
   nm_debug.debug('doc_compl_flag               : '||pi_rec_doc.doc_compl_flag,p_level);
   nm_debug.debug('doc_compl_cpr_id             : '||pi_rec_doc.doc_compl_cpr_id,p_level);
   nm_debug.debug('doc_compl_user_id            : '||pi_rec_doc.doc_compl_user_id,p_level);
   nm_debug.debug('doc_compl_peo_date           : '||pi_rec_doc.doc_compl_peo_date,p_level);
   nm_debug.debug('doc_compl_target             : '||pi_rec_doc.doc_compl_target,p_level);
   nm_debug.debug('doc_compl_complete           : '||pi_rec_doc.doc_compl_complete,p_level);
   nm_debug.debug('doc_compl_referred_to        : '||pi_rec_doc.doc_compl_referred_to,p_level);
   nm_debug.debug('doc_compl_location           : '||pi_rec_doc.doc_compl_location,p_level);
   nm_debug.debug('doc_compl_remarks            : '||pi_rec_doc.doc_compl_remarks,p_level);
   nm_debug.debug('doc_compl_north              : '||pi_rec_doc.doc_compl_north,p_level);
   nm_debug.debug('doc_compl_east               : '||pi_rec_doc.doc_compl_east,p_level);
   nm_debug.debug('doc_compl_from               : '||pi_rec_doc.doc_compl_from,p_level);
   nm_debug.debug('doc_compl_to                 : '||pi_rec_doc.doc_compl_to,p_level);
   nm_debug.debug('doc_compl_claim              : '||pi_rec_doc.doc_compl_claim,p_level);
   nm_debug.debug('doc_compl_corresp_date       : '||pi_rec_doc.doc_compl_corresp_date,p_level);
   nm_debug.debug('doc_compl_corresp_deliv_date : '||pi_rec_doc.doc_compl_corresp_deliv_date,p_level);
   nm_debug.debug('doc_compl_no_of_petitioners  : '||pi_rec_doc.doc_compl_no_of_petitioners,p_level);
   nm_debug.debug('doc_compl_incident_date      : '||pi_rec_doc.doc_compl_incident_date,p_level);
   nm_debug.debug('doc_compl_police_notif_flag  : '||pi_rec_doc.doc_compl_police_notif_flag,p_level);
   nm_debug.debug('doc_compl_date_police_notif  : '||pi_rec_doc.doc_compl_date_police_notif,p_level);
   nm_debug.debug('doc_compl_cause              : '||pi_rec_doc.doc_compl_cause,p_level);
   nm_debug.debug('doc_compl_injuries           : '||pi_rec_doc.doc_compl_injuries,p_level);
   nm_debug.debug('doc_compl_damage             : '||pi_rec_doc.doc_compl_damage,p_level);
   nm_debug.debug('doc_compl_action             : '||pi_rec_doc.doc_compl_action,p_level);
   nm_debug.debug('doc_compl_litigation_flag    : '||pi_rec_doc.doc_compl_litigation_flag,p_level);
   nm_debug.debug('doc_compl_litigation_reason  : '||pi_rec_doc.doc_compl_litigation_reason,p_level);
   nm_debug.debug('doc_compl_claim_no           : '||pi_rec_doc.doc_compl_claim_no,p_level);
   nm_debug.debug('doc_compl_determination      : '||pi_rec_doc.doc_compl_determination,p_level);
   nm_debug.debug('doc_compl_est_cost           : '||pi_rec_doc.doc_compl_est_cost,p_level);
   nm_debug.debug('doc_compl_adv_cost           : '||pi_rec_doc.doc_compl_adv_cost,p_level);
   nm_debug.debug('doc_compl_act_cost           : '||pi_rec_doc.doc_compl_act_cost,p_level);
   nm_debug.debug('doc_compl_follow_up1         : '||pi_rec_doc.doc_compl_follow_up1,p_level);
   nm_debug.debug('doc_compl_follow_up2         : '||pi_rec_doc.doc_compl_follow_up2,p_level);
   nm_debug.debug('doc_compl_follow_up3         : '||pi_rec_doc.doc_compl_follow_up3,p_level);
   nm_debug.debug('doc_compl_insurance_claim    : '||pi_rec_doc.doc_compl_insurance_claim,p_level);
   nm_debug.debug('doc_compl_summons_received   : '||pi_rec_doc.doc_compl_summons_received,p_level);
   nm_debug.debug('doc_compl_user_type          : '||pi_rec_doc.doc_compl_user_type,p_level);
   nm_debug.debug('doc_date_time_arrived        : '||pi_rec_doc.doc_date_time_arrived,p_level);
   nm_debug.debug('doc_reason_for_later_arrival : '||pi_rec_doc.doc_reason_for_later_arrival,p_level);
   nm_debug.debug('doc_outcome                  : '||pi_rec_doc.doc_outcome,p_level);
   nm_debug.debug('doc_outcome_reason           : '||pi_rec_doc.doc_outcome_reason,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_doc');
--
END debug_doc;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dac (pi_rec_dac doc_actions%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dac');
--
   nm_debug.debug('dac_id              : '||pi_rec_dac.dac_id,p_level);
   nm_debug.debug('dac_doc_id          : '||pi_rec_dac.dac_doc_id,p_level);
   nm_debug.debug('dac_code            : '||pi_rec_dac.dac_code,p_level);
   nm_debug.debug('dac_descr           : '||pi_rec_dac.dac_descr,p_level);
   nm_debug.debug('dac_date_assigned   : '||pi_rec_dac.dac_date_assigned,p_level);
   nm_debug.debug('dac_priority_id     : '||pi_rec_dac.dac_priority_id,p_level);
   nm_debug.debug('dac_target_date     : '||pi_rec_dac.dac_target_date,p_level);
   nm_debug.debug('dac_completion_date : '||pi_rec_dac.dac_completion_date,p_level);
   nm_debug.debug('dac_assignee        : '||pi_rec_dac.dac_assignee,p_level);
   nm_debug.debug('dac_status          : '||pi_rec_dac.dac_status,p_level);
   nm_debug.debug('dac_seq             : '||pi_rec_dac.dac_seq,p_level);
   nm_debug.debug('dac_parallel_flag   : '||pi_rec_dac.dac_parallel_flag,p_level);
   nm_debug.debug('dac_security_level  : '||pi_rec_dac.dac_security_level,p_level);
   nm_debug.debug('dac_outcome         : '||pi_rec_dac.dac_outcome,p_level);
   nm_debug.debug('dac_reference       : '||pi_rec_dac.dac_reference,p_level);
   nm_debug.debug('dac_total_amount    : '||pi_rec_dac.dac_total_amount,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dac');
--
END debug_dac;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dah (pi_rec_dah doc_action_history%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dah');
--
   nm_debug.debug('dah_dac_id          : '||pi_rec_dah.dah_dac_id,p_level);
   nm_debug.debug('dah_code            : '||pi_rec_dah.dah_code,p_level);
   nm_debug.debug('dah_date_changed    : '||pi_rec_dah.dah_date_changed,p_level);
   nm_debug.debug('dah_changed_by      : '||pi_rec_dah.dah_changed_by,p_level);
   nm_debug.debug('dah_date_assigned   : '||pi_rec_dah.dah_date_assigned,p_level);
   nm_debug.debug('dah_priority_id     : '||pi_rec_dah.dah_priority_id,p_level);
   nm_debug.debug('dah_assignee        : '||pi_rec_dah.dah_assignee,p_level);
   nm_debug.debug('dah_status          : '||pi_rec_dah.dah_status,p_level);
   nm_debug.debug('dah_security_level  : '||pi_rec_dah.dah_security_level,p_level);
   nm_debug.debug('dah_total_amount    : '||pi_rec_dah.dah_total_amount,p_level);
   nm_debug.debug('dah_completion_date : '||pi_rec_dah.dah_completion_date,p_level);
   nm_debug.debug('dah_target_date     : '||pi_rec_dah.dah_target_date,p_level);
   nm_debug.debug('dah_outcome         : '||pi_rec_dah.dah_outcome,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dah');
--
END debug_dah;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_das (pi_rec_das doc_assocs%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_das');
--
   nm_debug.debug('das_table_name : '||pi_rec_das.das_table_name,p_level);
   nm_debug.debug('das_rec_id     : '||pi_rec_das.das_rec_id,p_level);
   nm_debug.debug('das_doc_id     : '||pi_rec_das.das_doc_id,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_das');
--
END debug_das;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dcl (pi_rec_dcl doc_class%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dcl');
--
   nm_debug.debug('dcl_code       : '||pi_rec_dcl.dcl_code,p_level);
   nm_debug.debug('dcl_name       : '||pi_rec_dcl.dcl_name,p_level);
   nm_debug.debug('dcl_descr      : '||pi_rec_dcl.dcl_descr,p_level);
   nm_debug.debug('dcl_start_date : '||pi_rec_dcl.dcl_start_date,p_level);
   nm_debug.debug('dcl_end_date   : '||pi_rec_dcl.dcl_end_date,p_level);
   nm_debug.debug('dcl_dtp_code   : '||pi_rec_dcl.dcl_dtp_code,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dcl');
--
END debug_dcl;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dec (pi_rec_dec doc_contact%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dec');
--
   nm_debug.debug('dec_hct_id                   : '||pi_rec_dec.dec_hct_id,p_level);
   nm_debug.debug('dec_doc_id                   : '||pi_rec_dec.dec_doc_id,p_level);
   nm_debug.debug('dec_type                     : '||pi_rec_dec.dec_type,p_level);
   nm_debug.debug('dec_ref                      : '||pi_rec_dec.dec_ref,p_level);
   nm_debug.debug('dec_complainant              : '||pi_rec_dec.dec_complainant,p_level);
   nm_debug.debug('dec_contact                  : '||pi_rec_dec.dec_contact,p_level);
   nm_debug.debug('hct_id                       : '||pi_rec_dec.hct_id,p_level);
   nm_debug.debug('hct_org_or_person_flag       : '||pi_rec_dec.hct_org_or_person_flag,p_level);
   nm_debug.debug('hct_vip                      : '||pi_rec_dec.hct_vip,p_level);
   nm_debug.debug('hct_title                    : '||pi_rec_dec.hct_title,p_level);
   nm_debug.debug('hct_salutation               : '||pi_rec_dec.hct_salutation,p_level);
   nm_debug.debug('hct_first_name               : '||pi_rec_dec.hct_first_name,p_level);
   nm_debug.debug('hct_middle_initial           : '||pi_rec_dec.hct_middle_initial,p_level);
   nm_debug.debug('hct_surname                  : '||pi_rec_dec.hct_surname,p_level);
   nm_debug.debug('hct_organisation             : '||pi_rec_dec.hct_organisation,p_level);
   nm_debug.debug('hct_home_phone               : '||pi_rec_dec.hct_home_phone,p_level);
   nm_debug.debug('hct_work_phone               : '||pi_rec_dec.hct_work_phone,p_level);
   nm_debug.debug('hct_mobile_phone             : '||pi_rec_dec.hct_mobile_phone,p_level);
   nm_debug.debug('hct_fax                      : '||pi_rec_dec.hct_fax,p_level);
   nm_debug.debug('hct_pager                    : '||pi_rec_dec.hct_pager,p_level);
   nm_debug.debug('hct_email                    : '||pi_rec_dec.hct_email,p_level);
   nm_debug.debug('hct_occupation               : '||pi_rec_dec.hct_occupation,p_level);
   nm_debug.debug('hct_employer                 : '||pi_rec_dec.hct_employer,p_level);
   nm_debug.debug('hct_date_of_birth            : '||pi_rec_dec.hct_date_of_birth,p_level);
   nm_debug.debug('hct_start_date               : '||pi_rec_dec.hct_start_date,p_level);
   nm_debug.debug('hct_end_date                 : '||pi_rec_dec.hct_end_date,p_level);
   nm_debug.debug('hct_notes                    : '||pi_rec_dec.hct_notes,p_level);
   nm_debug.debug('hca_hct_id                   : '||pi_rec_dec.hca_hct_id,p_level);
   nm_debug.debug('hca_had_id                   : '||pi_rec_dec.hca_had_id,p_level);
   nm_debug.debug('had_id                       : '||pi_rec_dec.had_id,p_level);
   nm_debug.debug('had_department               : '||pi_rec_dec.had_department,p_level);
   nm_debug.debug('had_po_box                   : '||pi_rec_dec.had_po_box,p_level);
   nm_debug.debug('had_organisation             : '||pi_rec_dec.had_organisation,p_level);
   nm_debug.debug('had_sub_building_name_no     : '||pi_rec_dec.had_sub_building_name_no,p_level);
   nm_debug.debug('had_building_name            : '||pi_rec_dec.had_building_name,p_level);
   nm_debug.debug('had_building_no              : '||pi_rec_dec.had_building_no,p_level);
   nm_debug.debug('had_dependent_thoroughfare   : '||pi_rec_dec.had_dependent_thoroughfare,p_level);
   nm_debug.debug('had_thoroughfare             : '||pi_rec_dec.had_thoroughfare,p_level);
   nm_debug.debug('had_double_dep_locality_name : '||pi_rec_dec.had_double_dep_locality_name,p_level);
   nm_debug.debug('had_dependent_locality_name  : '||pi_rec_dec.had_dependent_locality_name,p_level);
   nm_debug.debug('had_post_town                : '||pi_rec_dec.had_post_town,p_level);
   nm_debug.debug('had_county                   : '||pi_rec_dec.had_county,p_level);
   nm_debug.debug('had_postcode                 : '||pi_rec_dec.had_postcode,p_level);
   nm_debug.debug('had_notes                    : '||pi_rec_dec.had_notes,p_level);
   nm_debug.debug('had_xco                      : '||pi_rec_dec.had_xco,p_level);
   nm_debug.debug('had_yco                      : '||pi_rec_dec.had_yco,p_level);
   nm_debug.debug('had_osapr                    : '||pi_rec_dec.had_osapr,p_level);
   nm_debug.debug('had_property_type            : '||pi_rec_dec.had_property_type,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dec');
--
END debug_dec;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hct (pi_rec_hct doc_contact_address%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hct');
--
   nm_debug.debug('hct_id                       : '||pi_rec_hct.hct_id,p_level);
   nm_debug.debug('hct_org_or_person_flag       : '||pi_rec_hct.hct_org_or_person_flag,p_level);
   nm_debug.debug('hct_vip                      : '||pi_rec_hct.hct_vip,p_level);
   nm_debug.debug('hct_title                    : '||pi_rec_hct.hct_title,p_level);
   nm_debug.debug('hct_salutation               : '||pi_rec_hct.hct_salutation,p_level);
   nm_debug.debug('hct_first_name               : '||pi_rec_hct.hct_first_name,p_level);
   nm_debug.debug('hct_middle_initial           : '||pi_rec_hct.hct_middle_initial,p_level);
   nm_debug.debug('hct_surname                  : '||pi_rec_hct.hct_surname,p_level);
   nm_debug.debug('hct_organisation             : '||pi_rec_hct.hct_organisation,p_level);
   nm_debug.debug('hct_home_phone               : '||pi_rec_hct.hct_home_phone,p_level);
   nm_debug.debug('hct_work_phone               : '||pi_rec_hct.hct_work_phone,p_level);
   nm_debug.debug('hct_mobile_phone             : '||pi_rec_hct.hct_mobile_phone,p_level);
   nm_debug.debug('hct_fax                      : '||pi_rec_hct.hct_fax,p_level);
   nm_debug.debug('hct_pager                    : '||pi_rec_hct.hct_pager,p_level);
   nm_debug.debug('hct_email                    : '||pi_rec_hct.hct_email,p_level);
   nm_debug.debug('hct_occupation               : '||pi_rec_hct.hct_occupation,p_level);
   nm_debug.debug('hct_employer                 : '||pi_rec_hct.hct_employer,p_level);
   nm_debug.debug('hct_date_of_birth            : '||pi_rec_hct.hct_date_of_birth,p_level);
   nm_debug.debug('hct_start_date               : '||pi_rec_hct.hct_start_date,p_level);
   nm_debug.debug('hct_end_date                 : '||pi_rec_hct.hct_end_date,p_level);
   nm_debug.debug('hct_notes                    : '||pi_rec_hct.hct_notes,p_level);
   nm_debug.debug('hca_hct_id                   : '||pi_rec_hct.hca_hct_id,p_level);
   nm_debug.debug('hca_had_id                   : '||pi_rec_hct.hca_had_id,p_level);
   nm_debug.debug('had_id                       : '||pi_rec_hct.had_id,p_level);
   nm_debug.debug('had_department               : '||pi_rec_hct.had_department,p_level);
   nm_debug.debug('had_po_box                   : '||pi_rec_hct.had_po_box,p_level);
   nm_debug.debug('had_organisation             : '||pi_rec_hct.had_organisation,p_level);
   nm_debug.debug('had_sub_building_name_no     : '||pi_rec_hct.had_sub_building_name_no,p_level);
   nm_debug.debug('had_building_name            : '||pi_rec_hct.had_building_name,p_level);
   nm_debug.debug('had_building_no              : '||pi_rec_hct.had_building_no,p_level);
   nm_debug.debug('had_dependent_thoroughfare   : '||pi_rec_hct.had_dependent_thoroughfare,p_level);
   nm_debug.debug('had_thoroughfare             : '||pi_rec_hct.had_thoroughfare,p_level);
   nm_debug.debug('had_double_dep_locality_name : '||pi_rec_hct.had_double_dep_locality_name,p_level);
   nm_debug.debug('had_dependent_locality_name  : '||pi_rec_hct.had_dependent_locality_name,p_level);
   nm_debug.debug('had_post_town                : '||pi_rec_hct.had_post_town,p_level);
   nm_debug.debug('had_county                   : '||pi_rec_hct.had_county,p_level);
   nm_debug.debug('had_postcode                 : '||pi_rec_hct.had_postcode,p_level);
   nm_debug.debug('had_notes                    : '||pi_rec_hct.had_notes,p_level);
   nm_debug.debug('had_xco                      : '||pi_rec_hct.had_xco,p_level);
   nm_debug.debug('had_yco                      : '||pi_rec_hct.had_yco,p_level);
   nm_debug.debug('had_osapr                    : '||pi_rec_hct.had_osapr,p_level);
   nm_debug.debug('had_property_type            : '||pi_rec_hct.had_property_type,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hct');
--
END debug_hct;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dcp (pi_rec_dcp doc_copies%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dcp');
--
   nm_debug.debug('dcp_doc_id    : '||pi_rec_dcp.dcp_doc_id,p_level);
   nm_debug.debug('dcp_id        : '||pi_rec_dcp.dcp_id,p_level);
   nm_debug.debug('dcp_date_out  : '||pi_rec_dcp.dcp_date_out,p_level);
   nm_debug.debug('dcp_user_id   : '||pi_rec_dcp.dcp_user_id,p_level);
   nm_debug.debug('dcp_date_back : '||pi_rec_dcp.dcp_date_back,p_level);
   nm_debug.debug('dcp_remarks   : '||pi_rec_dcp.dcp_remarks,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dcp');
--
END debug_dcp;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ddg (pi_rec_ddg doc_damage%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ddg');
--
   nm_debug.debug('ddg_id                : '||pi_rec_ddg.ddg_id,p_level);
   nm_debug.debug('ddg_doc_id            : '||pi_rec_ddg.ddg_doc_id,p_level);
   nm_debug.debug('ddg_furniture_type    : '||pi_rec_ddg.ddg_furniture_type,p_level);
   nm_debug.debug('ddg_furniture_details : '||pi_rec_ddg.ddg_furniture_details,p_level);
   nm_debug.debug('ddg_vehicle           : '||pi_rec_ddg.ddg_vehicle,p_level);
   nm_debug.debug('ddg_vehicle_reg       : '||pi_rec_ddg.ddg_vehicle_reg,p_level);
   nm_debug.debug('ddg_vehicle_owner     : '||pi_rec_ddg.ddg_vehicle_owner,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ddg');
--
END debug_ddg;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ddc (pi_rec_ddc doc_damage_costs%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ddc');
--
   nm_debug.debug('ddc_id     : '||pi_rec_ddc.ddc_id,p_level);
   nm_debug.debug('ddc_ddg_id : '||pi_rec_ddc.ddc_ddg_id,p_level);
   nm_debug.debug('ddc_type   : '||pi_rec_ddc.ddc_type,p_level);
   nm_debug.debug('ddc_cost   : '||pi_rec_ddc.ddc_cost,p_level);
   nm_debug.debug('ddc_notes  : '||pi_rec_ddc.ddc_notes,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ddc');
--
END debug_ddc;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dec (pi_rec_dec doc_enquiry_contacts%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dec');
--
   nm_debug.debug('dec_hct_id      : '||pi_rec_dec.dec_hct_id,p_level);
   nm_debug.debug('dec_doc_id      : '||pi_rec_dec.dec_doc_id,p_level);
   nm_debug.debug('dec_type        : '||pi_rec_dec.dec_type,p_level);
   nm_debug.debug('dec_ref         : '||pi_rec_dec.dec_ref,p_level);
   nm_debug.debug('dec_complainant : '||pi_rec_dec.dec_complainant,p_level);
   nm_debug.debug('dec_contact     : '||pi_rec_dec.dec_contact,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dec');
--
END debug_dec;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_det (pi_rec_det doc_enquiry_types%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_det');
--
   nm_debug.debug('det_dtp_code   : '||pi_rec_det.det_dtp_code,p_level);
   nm_debug.debug('det_dcl_code   : '||pi_rec_det.det_dcl_code,p_level);
   nm_debug.debug('det_code       : '||pi_rec_det.det_code,p_level);
   nm_debug.debug('det_name       : '||pi_rec_det.det_name,p_level);
   nm_debug.debug('det_descr      : '||pi_rec_det.det_descr,p_level);
   nm_debug.debug('det_start_date : '||pi_rec_det.det_start_date,p_level);
   nm_debug.debug('det_end_date   : '||pi_rec_det.det_end_date,p_level);
   nm_debug.debug('det_con_id     : '||pi_rec_det.det_con_id,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_det');
--
END debug_det;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dgt (pi_rec_dgt doc_gateways%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dgt');
--
   nm_debug.debug('dgt_table_name         : '||pi_rec_dgt.dgt_table_name,p_level);
   nm_debug.debug('dgt_table_descr        : '||pi_rec_dgt.dgt_table_descr,p_level);
   nm_debug.debug('dgt_pk_col_name        : '||pi_rec_dgt.dgt_pk_col_name,p_level);
   nm_debug.debug('dgt_lov_descr_list     : '||pi_rec_dgt.dgt_lov_descr_list,p_level);
   nm_debug.debug('dgt_lov_from_list      : '||pi_rec_dgt.dgt_lov_from_list,p_level);
   nm_debug.debug('dgt_lov_join_condition : '||pi_rec_dgt.dgt_lov_join_condition,p_level);
   nm_debug.debug('dgt_expand_module      : '||pi_rec_dgt.dgt_expand_module,p_level);
   nm_debug.debug('dgt_start_date         : '||pi_rec_dgt.dgt_start_date,p_level);
   nm_debug.debug('dgt_end_date           : '||pi_rec_dgt.dgt_end_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dgt');
--
END debug_dgt;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dgs (pi_rec_dgs doc_gate_syns%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dgs');
--
   nm_debug.debug('dgs_dgt_table_name : '||pi_rec_dgs.dgs_dgt_table_name,p_level);
   nm_debug.debug('dgs_table_syn      : '||pi_rec_dgs.dgs_table_syn,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dgs');
--
END debug_dgs;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dhi (pi_rec_dhi doc_history%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dhi');
--
   nm_debug.debug('dhi_doc_id        : '||pi_rec_dhi.dhi_doc_id,p_level);
   nm_debug.debug('dhi_date_changed  : '||pi_rec_dhi.dhi_date_changed,p_level);
   nm_debug.debug('dhi_status_code   : '||pi_rec_dhi.dhi_status_code,p_level);
   nm_debug.debug('dhi_compl_type    : '||pi_rec_dhi.dhi_compl_type,p_level);
   nm_debug.debug('dhi_compl_cpr_id  : '||pi_rec_dhi.dhi_compl_cpr_id,p_level);
   nm_debug.debug('dhi_changed_by    : '||pi_rec_dhi.dhi_changed_by,p_level);
   nm_debug.debug('dhi_reason        : '||pi_rec_dhi.dhi_reason,p_level);
   nm_debug.debug('dhi_claim         : '||pi_rec_dhi.dhi_claim,p_level);
   nm_debug.debug('dhi_dtp_code      : '||pi_rec_dhi.dhi_dtp_code,p_level);
   nm_debug.debug('dhi_dcl_code      : '||pi_rec_dhi.dhi_dcl_code,p_level);
   nm_debug.debug('dhi_corresp_date  : '||pi_rec_dhi.dhi_corresp_date,p_level);
   nm_debug.debug('dhi_ack_date      : '||pi_rec_dhi.dhi_ack_date,p_level);
   nm_debug.debug('dhi_incident_date : '||pi_rec_dhi.dhi_incident_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dhi');
--
END debug_dhi;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dky (pi_rec_dky doc_keys%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dky');
--
   nm_debug.debug('dky_doc_id     : '||pi_rec_dky.dky_doc_id,p_level);
   nm_debug.debug('dky_dkw_key_id : '||pi_rec_dky.dky_dkw_key_id,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dky');
--
END debug_dky;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dkw (pi_rec_dkw doc_keywords%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dkw');
--
   nm_debug.debug('dkw_key_id : '||pi_rec_dkw.dkw_key_id,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dkw');
--
END debug_dkw;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dlc (pi_rec_dlc doc_locations%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dlc');
--
   nm_debug.debug('dlc_id            : '||pi_rec_dlc.dlc_id,p_level);
   nm_debug.debug('dlc_name          : '||pi_rec_dlc.dlc_name,p_level);
   nm_debug.debug('dlc_pathname      : '||pi_rec_dlc.dlc_pathname,p_level);
   nm_debug.debug('dlc_dmd_id        : '||pi_rec_dlc.dlc_dmd_id,p_level);
   nm_debug.debug('dlc_descr         : '||pi_rec_dlc.dlc_descr,p_level);
   nm_debug.debug('dlc_start_date    : '||pi_rec_dlc.dlc_start_date,p_level);
   nm_debug.debug('dlc_end_date      : '||pi_rec_dlc.dlc_end_date,p_level);
   nm_debug.debug('dlc_apps_pathname : '||pi_rec_dlc.dlc_apps_pathname,p_level);
   nm_debug.debug('dlc_url_pathname  : '||pi_rec_dlc.dlc_url_pathname,p_level);
   nm_debug.debug('dlc_location_name : '||pi_rec_dlc.dlc_location_name,p_level);
   nm_debug.debug('dlc_location_type : '||pi_rec_dlc.dlc_location_type,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dlc');
--
END debug_dlc;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dlr (pi_rec_dlr doc_lov_recs%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dlr');
--
   nm_debug.debug('dlr_rec_id    : '||pi_rec_dlr.dlr_rec_id,p_level);
   nm_debug.debug('dlr_rec_descr : '||pi_rec_dlr.dlr_rec_descr,p_level);
   nm_debug.debug('dlr_sessionid : '||pi_rec_dlr.dlr_sessionid,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dlr');
--
END debug_dlr;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dmd (pi_rec_dmd doc_media%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dmd');
--
   nm_debug.debug('dmd_id              : '||pi_rec_dmd.dmd_id,p_level);
   nm_debug.debug('dmd_name            : '||pi_rec_dmd.dmd_name,p_level);
   nm_debug.debug('dmd_descr           : '||pi_rec_dmd.dmd_descr,p_level);
   nm_debug.debug('dmd_display_command : '||pi_rec_dmd.dmd_display_command,p_level);
   nm_debug.debug('dmd_scan_command    : '||pi_rec_dmd.dmd_scan_command,p_level);
   nm_debug.debug('dmd_image_command1  : '||pi_rec_dmd.dmd_image_command1,p_level);
   nm_debug.debug('dmd_image_command2  : '||pi_rec_dmd.dmd_image_command2,p_level);
   nm_debug.debug('dmd_image_command3  : '||pi_rec_dmd.dmd_image_command3,p_level);
   nm_debug.debug('dmd_image_command4  : '||pi_rec_dmd.dmd_image_command4,p_level);
   nm_debug.debug('dmd_image_command5  : '||pi_rec_dmd.dmd_image_command5,p_level);
   nm_debug.debug('dmd_file_extension  : '||pi_rec_dmd.dmd_file_extension,p_level);
   nm_debug.debug('dmd_start_date      : '||pi_rec_dmd.dmd_start_date,p_level);
   nm_debug.debug('dmd_end_date        : '||pi_rec_dmd.dmd_end_date,p_level);
   nm_debug.debug('dmd_icon            : '||pi_rec_dmd.dmd_icon,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dmd');
--
END debug_dmd;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dq (pi_rec_dq doc_query%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dq');
--
   nm_debug.debug('dq_id    : '||pi_rec_dq.dq_id,p_level);
   nm_debug.debug('dq_title : '||pi_rec_dq.dq_title,p_level);
   nm_debug.debug('dq_descr : '||pi_rec_dq.dq_descr,p_level);
   nm_debug.debug('dq_sql   : '||pi_rec_dq.dq_sql,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dq');
--
END debug_dq;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dqc (pi_rec_dqc doc_query_cols%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dqc');
--
   nm_debug.debug('dqc_dq_id        : '||pi_rec_dqc.dqc_dq_id,p_level);
   nm_debug.debug('dqc_seq_no       : '||pi_rec_dqc.dqc_seq_no,p_level);
   nm_debug.debug('dqc_column       : '||pi_rec_dqc.dqc_column,p_level);
   nm_debug.debug('dqc_column_alias : '||pi_rec_dqc.dqc_column_alias,p_level);
   nm_debug.debug('dqc_datatype     : '||pi_rec_dqc.dqc_datatype,p_level);
   nm_debug.debug('dqc_data_len     : '||pi_rec_dqc.dqc_data_len,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dqc');
--
END debug_dqc;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dsa (pi_rec_dsa doc_std_actions%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dsa');
--
   nm_debug.debug('dsa_dtp_code         : '||pi_rec_dsa.dsa_dtp_code,p_level);
   nm_debug.debug('dsa_dcl_code         : '||pi_rec_dsa.dsa_dcl_code,p_level);
   nm_debug.debug('dsa_doc_status       : '||pi_rec_dsa.dsa_doc_status,p_level);
   nm_debug.debug('dsa_doc_type         : '||pi_rec_dsa.dsa_doc_type,p_level);
   nm_debug.debug('dsa_code             : '||pi_rec_dsa.dsa_code,p_level);
   nm_debug.debug('dsa_descr            : '||pi_rec_dsa.dsa_descr,p_level);
   nm_debug.debug('dsa_priority_id      : '||pi_rec_dsa.dsa_priority_id,p_level);
   nm_debug.debug('dsa_status           : '||pi_rec_dsa.dsa_status,p_level);
   nm_debug.debug('dsa_default_assignee : '||pi_rec_dsa.dsa_default_assignee,p_level);
   nm_debug.debug('dsa_seq              : '||pi_rec_dsa.dsa_seq,p_level);
   nm_debug.debug('dsa_parallel_flag    : '||pi_rec_dsa.dsa_parallel_flag,p_level);
   nm_debug.debug('dsa_security_level   : '||pi_rec_dsa.dsa_security_level,p_level);
   nm_debug.debug('dsa_amount           : '||pi_rec_dsa.dsa_amount,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dsa');
--
END debug_dsa;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dsc (pi_rec_dsc doc_std_costs%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dsc');
--
   nm_debug.debug('dsc_type      : '||pi_rec_dsc.dsc_type,p_level);
   nm_debug.debug('dsc_cost      : '||pi_rec_dsc.dsc_cost,p_level);
   nm_debug.debug('dsc_notes     : '||pi_rec_dsc.dsc_notes,p_level);
   nm_debug.debug('dsc_from_date : '||pi_rec_dsc.dsc_from_date,p_level);
   nm_debug.debug('dsc_to_date   : '||pi_rec_dsc.dsc_to_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dsc');
--
END debug_dsc;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dsy (pi_rec_dsy doc_synonyms%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dsy');
--
   nm_debug.debug('dsy_key_id     : '||pi_rec_dsy.dsy_key_id,p_level);
   nm_debug.debug('dsy_dkw_key_id : '||pi_rec_dsy.dsy_dkw_key_id,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dsy');
--
END debug_dsy;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dtc (pi_rec_dtc doc_template_columns%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dtc');
--
   nm_debug.debug('dtc_template_name : '||pi_rec_dtc.dtc_template_name,p_level);
   nm_debug.debug('dtc_col_name      : '||pi_rec_dtc.dtc_col_name,p_level);
   nm_debug.debug('dtc_col_type      : '||pi_rec_dtc.dtc_col_type,p_level);
   nm_debug.debug('dtc_col_alias     : '||pi_rec_dtc.dtc_col_alias,p_level);
   nm_debug.debug('dtc_col_seq       : '||pi_rec_dtc.dtc_col_seq,p_level);
   nm_debug.debug('dtc_used_in_proc  : '||pi_rec_dtc.dtc_used_in_proc,p_level);
   nm_debug.debug('dtc_image_file    : '||pi_rec_dtc.dtc_image_file,p_level);
   nm_debug.debug('dtc_function      : '||pi_rec_dtc.dtc_function,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dtc');
--
END debug_dtc;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dtg (pi_rec_dtg doc_template_gateways%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dtg');
--
   nm_debug.debug('dtg_dmd_id             : '||pi_rec_dtg.dtg_dmd_id,p_level);
   nm_debug.debug('dtg_ole_type           : '||pi_rec_dtg.dtg_ole_type,p_level);
   nm_debug.debug('dtg_table_name         : '||pi_rec_dtg.dtg_table_name,p_level);
   nm_debug.debug('dtg_template_name      : '||pi_rec_dtg.dtg_template_name,p_level);
   nm_debug.debug('dtg_dlc_id             : '||pi_rec_dtg.dtg_dlc_id,p_level);
   nm_debug.debug('dtg_template_descr     : '||pi_rec_dtg.dtg_template_descr,p_level);
   nm_debug.debug('dtg_post_run_procedure : '||pi_rec_dtg.dtg_post_run_procedure,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dtg');
--
END debug_dtg;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dtu (pi_rec_dtu doc_template_users%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dtu');
--
   nm_debug.debug('dtu_template_name       : '||pi_rec_dtu.dtu_template_name,p_level);
   nm_debug.debug('dtu_user_id             : '||pi_rec_dtu.dtu_user_id,p_level);
   nm_debug.debug('dtu_default_template    : '||pi_rec_dtu.dtu_default_template,p_level);
   nm_debug.debug('dtu_print_immediately   : '||pi_rec_dtu.dtu_print_immediately,p_level);
   nm_debug.debug('dtu_default_report_type : '||pi_rec_dtu.dtu_default_report_type,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dtu');
--
END debug_dtu;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_dtp (pi_rec_dtp doc_types%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_dtp');
--
   nm_debug.debug('dtp_code             : '||pi_rec_dtp.dtp_code,p_level);
   nm_debug.debug('dtp_name             : '||pi_rec_dtp.dtp_name,p_level);
   nm_debug.debug('dtp_descr            : '||pi_rec_dtp.dtp_descr,p_level);
   nm_debug.debug('dtp_allow_comments   : '||pi_rec_dtp.dtp_allow_comments,p_level);
   nm_debug.debug('dtp_allow_complaints : '||pi_rec_dtp.dtp_allow_complaints,p_level);
   nm_debug.debug('dtp_start_date       : '||pi_rec_dtp.dtp_start_date,p_level);
   nm_debug.debug('dtp_end_date         : '||pi_rec_dtp.dtp_end_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_dtp');
--
END debug_dtp;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_gl (pi_rec_gl gri_lov%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_gl');
--
   nm_debug.debug('gl_job_id : '||pi_rec_gl.gl_job_id,p_level);
   nm_debug.debug('gl_param  : '||pi_rec_gl.gl_param,p_level);
   nm_debug.debug('gl_return : '||pi_rec_gl.gl_return,p_level);
   nm_debug.debug('gl_descr  : '||pi_rec_gl.gl_descr,p_level);
   nm_debug.debug('gl_shown  : '||pi_rec_gl.gl_shown,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_gl');
--
END debug_gl;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_grm (pi_rec_grm gri_modules%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_grm');
--
   nm_debug.debug('grm_module      : '||pi_rec_grm.grm_module,p_level);
   nm_debug.debug('grm_module_type : '||pi_rec_grm.grm_module_type,p_level);
   nm_debug.debug('grm_module_path : '||pi_rec_grm.grm_module_path,p_level);
   nm_debug.debug('grm_file_type   : '||pi_rec_grm.grm_file_type,p_level);
   nm_debug.debug('grm_tag_flag    : '||pi_rec_grm.grm_tag_flag,p_level);
   nm_debug.debug('grm_tag_table   : '||pi_rec_grm.grm_tag_table,p_level);
   nm_debug.debug('grm_tag_column  : '||pi_rec_grm.grm_tag_column,p_level);
   nm_debug.debug('grm_tag_where   : '||pi_rec_grm.grm_tag_where,p_level);
   nm_debug.debug('grm_linesize    : '||pi_rec_grm.grm_linesize,p_level);
   nm_debug.debug('grm_pagesize    : '||pi_rec_grm.grm_pagesize,p_level);
   nm_debug.debug('grm_pre_process : '||pi_rec_grm.grm_pre_process,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_grm');
--
END debug_grm;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_gmp (pi_rec_gmp gri_module_params%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_gmp');
--
   nm_debug.debug('gmp_module            : '||pi_rec_gmp.gmp_module,p_level);
   nm_debug.debug('gmp_param             : '||pi_rec_gmp.gmp_param,p_level);
   nm_debug.debug('gmp_seq               : '||pi_rec_gmp.gmp_seq,p_level);
   nm_debug.debug('gmp_param_descr       : '||pi_rec_gmp.gmp_param_descr,p_level);
   nm_debug.debug('gmp_mandatory         : '||pi_rec_gmp.gmp_mandatory,p_level);
   nm_debug.debug('gmp_no_allowed        : '||pi_rec_gmp.gmp_no_allowed,p_level);
   nm_debug.debug('gmp_where             : '||pi_rec_gmp.gmp_where,p_level);
   nm_debug.debug('gmp_tag_restriction   : '||pi_rec_gmp.gmp_tag_restriction,p_level);
   nm_debug.debug('gmp_tag_where         : '||pi_rec_gmp.gmp_tag_where,p_level);
   nm_debug.debug('gmp_default_table     : '||pi_rec_gmp.gmp_default_table,p_level);
   nm_debug.debug('gmp_default_column    : '||pi_rec_gmp.gmp_default_column,p_level);
   nm_debug.debug('gmp_default_where     : '||pi_rec_gmp.gmp_default_where,p_level);
   nm_debug.debug('gmp_visible           : '||pi_rec_gmp.gmp_visible,p_level);
   nm_debug.debug('gmp_gazetteer         : '||pi_rec_gmp.gmp_gazetteer,p_level);
   nm_debug.debug('gmp_lov               : '||pi_rec_gmp.gmp_lov,p_level);
   nm_debug.debug('gmp_val_global        : '||pi_rec_gmp.gmp_val_global,p_level);
   nm_debug.debug('gmp_wildcard          : '||pi_rec_gmp.gmp_wildcard,p_level);
   nm_debug.debug('gmp_hint_text         : '||pi_rec_gmp.gmp_hint_text,p_level);
   nm_debug.debug('gmp_allow_partial     : '||pi_rec_gmp.gmp_allow_partial,p_level);
   nm_debug.debug('gmp_base_table        : '||pi_rec_gmp.gmp_base_table,p_level);
   nm_debug.debug('gmp_base_table_column : '||pi_rec_gmp.gmp_base_table_column,p_level);
   nm_debug.debug('gmp_operator          : '||pi_rec_gmp.gmp_operator,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_gmp');
--
END debug_gmp;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_gp (pi_rec_gp gri_params%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_gp');
--
   nm_debug.debug('gp_param           : '||pi_rec_gp.gp_param,p_level);
   nm_debug.debug('gp_param_type      : '||pi_rec_gp.gp_param_type,p_level);
   nm_debug.debug('gp_table           : '||pi_rec_gp.gp_table,p_level);
   nm_debug.debug('gp_column          : '||pi_rec_gp.gp_column,p_level);
   nm_debug.debug('gp_descr_column    : '||pi_rec_gp.gp_descr_column,p_level);
   nm_debug.debug('gp_shown_column    : '||pi_rec_gp.gp_shown_column,p_level);
   nm_debug.debug('gp_shown_type      : '||pi_rec_gp.gp_shown_type,p_level);
   nm_debug.debug('gp_descr_type      : '||pi_rec_gp.gp_descr_type,p_level);
   nm_debug.debug('gp_order           : '||pi_rec_gp.gp_order,p_level);
   nm_debug.debug('gp_case            : '||pi_rec_gp.gp_case,p_level);
   nm_debug.debug('gp_gaz_restriction : '||pi_rec_gp.gp_gaz_restriction,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_gp');
--
END debug_gp;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_gpd (pi_rec_gpd gri_param_dependencies%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_gpd');
--
   nm_debug.debug('gpd_module      : '||pi_rec_gpd.gpd_module,p_level);
   nm_debug.debug('gpd_dep_param   : '||pi_rec_gpd.gpd_dep_param,p_level);
   nm_debug.debug('gpd_indep_param : '||pi_rec_gpd.gpd_indep_param,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_gpd');
--
END debug_gpd;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_gpl (pi_rec_gpl gri_param_lookup%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_gpl');
--
   nm_debug.debug('gpl_param : '||pi_rec_gpl.gpl_param,p_level);
   nm_debug.debug('gpl_value : '||pi_rec_gpl.gpl_value,p_level);
   nm_debug.debug('gpl_descr : '||pi_rec_gpl.gpl_descr,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_gpl');
--
END debug_gpl;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_grr (pi_rec_grr gri_report_runs%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_grr');
--
   nm_debug.debug('grr_job_id          : '||pi_rec_grr.grr_job_id,p_level);
   nm_debug.debug('grr_module          : '||pi_rec_grr.grr_module,p_level);
   nm_debug.debug('grr_username        : '||pi_rec_grr.grr_username,p_level);
   nm_debug.debug('grr_submit_date     : '||pi_rec_grr.grr_submit_date,p_level);
   nm_debug.debug('grr_act_start_date  : '||pi_rec_grr.grr_act_start_date,p_level);
   nm_debug.debug('grr_prop_start_date : '||pi_rec_grr.grr_prop_start_date,p_level);
   nm_debug.debug('grr_end_date        : '||pi_rec_grr.grr_end_date,p_level);
   nm_debug.debug('grr_report_dest     : '||pi_rec_grr.grr_report_dest,p_level);
   nm_debug.debug('grr_batch_queue     : '||pi_rec_grr.grr_batch_queue,p_level);
   nm_debug.debug('grr_entry_no        : '||pi_rec_grr.grr_entry_no,p_level);
   nm_debug.debug('grr_error_no        : '||pi_rec_grr.grr_error_no,p_level);
   nm_debug.debug('grr_error_appl      : '||pi_rec_grr.grr_error_appl,p_level);
   nm_debug.debug('grr_error_descr     : '||pi_rec_grr.grr_error_descr,p_level);
   nm_debug.debug('grr_mode            : '||pi_rec_grr.grr_mode,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_grr');
--
END debug_grr;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_grp (pi_rec_grp gri_run_parameters%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_grp');
--
   nm_debug.debug('grp_job_id      : '||pi_rec_grp.grp_job_id,p_level);
   nm_debug.debug('grp_seq         : '||pi_rec_grp.grp_seq,p_level);
   nm_debug.debug('grp_param       : '||pi_rec_grp.grp_param,p_level);
   nm_debug.debug('grp_value       : '||pi_rec_grp.grp_value,p_level);
   nm_debug.debug('grp_visible     : '||pi_rec_grp.grp_visible,p_level);
   nm_debug.debug('grp_descr       : '||pi_rec_grp.grp_descr,p_level);
   nm_debug.debug('grp_shown       : '||pi_rec_grp.grp_shown,p_level);
   nm_debug.debug('grp_current_lov : '||pi_rec_grp.grp_current_lov,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_grp');
--
END debug_grp;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_gsp (pi_rec_gsp gri_saved_params%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_gsp');
--
   nm_debug.debug('gsp_gss_id  : '||pi_rec_gsp.gsp_gss_id,p_level);
   nm_debug.debug('gsp_seq     : '||pi_rec_gsp.gsp_seq,p_level);
   nm_debug.debug('gsp_param   : '||pi_rec_gsp.gsp_param,p_level);
   nm_debug.debug('gsp_value   : '||pi_rec_gsp.gsp_value,p_level);
   nm_debug.debug('gsp_visible : '||pi_rec_gsp.gsp_visible,p_level);
   nm_debug.debug('gsp_shown   : '||pi_rec_gsp.gsp_shown,p_level);
   nm_debug.debug('gsp_descr   : '||pi_rec_gsp.gsp_descr,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_gsp');
--
END debug_gsp;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_gss (pi_rec_gss gri_saved_sets%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_gss');
--
   nm_debug.debug('gss_id       : '||pi_rec_gss.gss_id,p_level);
   nm_debug.debug('gss_username : '||pi_rec_gss.gss_username,p_level);
   nm_debug.debug('gss_module   : '||pi_rec_gss.gss_module,p_level);
   nm_debug.debug('gss_descr    : '||pi_rec_gss.gss_descr,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_gss');
--
END debug_gss;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_grs (pi_rec_grs gri_spool%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_grs');
--
   nm_debug.debug('grs_job_id  : '||pi_rec_grs.grs_job_id,p_level);
   nm_debug.debug('grs_line_no : '||pi_rec_grs.grs_line_no,p_level);
   nm_debug.debug('grs_text    : '||pi_rec_grs.grs_text,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_grs');
--
END debug_grs;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_had (pi_rec_had hig_address%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_had');
--
   nm_debug.debug('had_id                       : '||pi_rec_had.had_id,p_level);
   nm_debug.debug('had_department               : '||pi_rec_had.had_department,p_level);
   nm_debug.debug('had_po_box                   : '||pi_rec_had.had_po_box,p_level);
   nm_debug.debug('had_organisation             : '||pi_rec_had.had_organisation,p_level);
   nm_debug.debug('had_sub_building_name_no     : '||pi_rec_had.had_sub_building_name_no,p_level);
   nm_debug.debug('had_building_name            : '||pi_rec_had.had_building_name,p_level);
   nm_debug.debug('had_building_no              : '||pi_rec_had.had_building_no,p_level);
   nm_debug.debug('had_dependent_thoroughfare   : '||pi_rec_had.had_dependent_thoroughfare,p_level);
   nm_debug.debug('had_thoroughfare             : '||pi_rec_had.had_thoroughfare,p_level);
   nm_debug.debug('had_double_dep_locality_name : '||pi_rec_had.had_double_dep_locality_name,p_level);
   nm_debug.debug('had_dependent_locality_name  : '||pi_rec_had.had_dependent_locality_name,p_level);
   nm_debug.debug('had_post_town                : '||pi_rec_had.had_post_town,p_level);
   nm_debug.debug('had_county                   : '||pi_rec_had.had_county,p_level);
   nm_debug.debug('had_postcode                 : '||pi_rec_had.had_postcode,p_level);
   nm_debug.debug('had_osapr                    : '||pi_rec_had.had_osapr,p_level);
   nm_debug.debug('had_xco                      : '||pi_rec_had.had_xco,p_level);
   nm_debug.debug('had_yco                      : '||pi_rec_had.had_yco,p_level);
   nm_debug.debug('had_notes                    : '||pi_rec_had.had_notes,p_level);
   nm_debug.debug('had_property_type            : '||pi_rec_had.had_property_type,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_had');
--
END debug_had;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hco (pi_rec_hco hig_codes%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hco');
--
   nm_debug.debug('hco_domain     : '||pi_rec_hco.hco_domain,p_level);
   nm_debug.debug('hco_code       : '||pi_rec_hco.hco_code,p_level);
   nm_debug.debug('hco_meaning    : '||pi_rec_hco.hco_meaning,p_level);
   nm_debug.debug('hco_system     : '||pi_rec_hco.hco_system,p_level);
   nm_debug.debug('hco_seq        : '||pi_rec_hco.hco_seq,p_level);
   nm_debug.debug('hco_start_date : '||pi_rec_hco.hco_start_date,p_level);
   nm_debug.debug('hco_end_date   : '||pi_rec_hco.hco_end_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hco');
--
END debug_hco;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hcl (pi_rec_hcl hig_colours%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hcl');
--
   nm_debug.debug('hcl_colour           : '||pi_rec_hcl.hcl_colour,p_level);
   nm_debug.debug('hcl_visual_attribute : '||pi_rec_hcl.hcl_visual_attribute,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hcl');
--
END debug_hcl;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hct (pi_rec_hct hig_contacts%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hct');
--
   nm_debug.debug('hct_id                 : '||pi_rec_hct.hct_id,p_level);
   nm_debug.debug('hct_org_or_person_flag : '||pi_rec_hct.hct_org_or_person_flag,p_level);
   nm_debug.debug('hct_vip                : '||pi_rec_hct.hct_vip,p_level);
   nm_debug.debug('hct_title              : '||pi_rec_hct.hct_title,p_level);
   nm_debug.debug('hct_salutation         : '||pi_rec_hct.hct_salutation,p_level);
   nm_debug.debug('hct_first_name         : '||pi_rec_hct.hct_first_name,p_level);
   nm_debug.debug('hct_middle_initial     : '||pi_rec_hct.hct_middle_initial,p_level);
   nm_debug.debug('hct_surname            : '||pi_rec_hct.hct_surname,p_level);
   nm_debug.debug('hct_organisation       : '||pi_rec_hct.hct_organisation,p_level);
   nm_debug.debug('hct_home_phone         : '||pi_rec_hct.hct_home_phone,p_level);
   nm_debug.debug('hct_work_phone         : '||pi_rec_hct.hct_work_phone,p_level);
   nm_debug.debug('hct_mobile_phone       : '||pi_rec_hct.hct_mobile_phone,p_level);
   nm_debug.debug('hct_fax                : '||pi_rec_hct.hct_fax,p_level);
   nm_debug.debug('hct_pager              : '||pi_rec_hct.hct_pager,p_level);
   nm_debug.debug('hct_email              : '||pi_rec_hct.hct_email,p_level);
   nm_debug.debug('hct_occupation         : '||pi_rec_hct.hct_occupation,p_level);
   nm_debug.debug('hct_employer           : '||pi_rec_hct.hct_employer,p_level);
   nm_debug.debug('hct_date_of_birth      : '||pi_rec_hct.hct_date_of_birth,p_level);
   nm_debug.debug('hct_start_date         : '||pi_rec_hct.hct_start_date,p_level);
   nm_debug.debug('hct_end_date           : '||pi_rec_hct.hct_end_date,p_level);
   nm_debug.debug('hct_notes              : '||pi_rec_hct.hct_notes,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hct');
--
END debug_hct;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hca (pi_rec_hca hig_contact_address%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hca');
--
   nm_debug.debug('hca_hct_id : '||pi_rec_hca.hca_hct_id,p_level);
   nm_debug.debug('hca_had_id : '||pi_rec_hca.hca_had_id,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hca');
--
END debug_hca;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hdo (pi_rec_hdo hig_domains%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hdo');
--
   nm_debug.debug('hdo_domain      : '||pi_rec_hdo.hdo_domain,p_level);
   nm_debug.debug('hdo_product     : '||pi_rec_hdo.hdo_product,p_level);
   nm_debug.debug('hdo_title       : '||pi_rec_hdo.hdo_title,p_level);
   nm_debug.debug('hdo_code_length : '||pi_rec_hdo.hdo_code_length,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hdo');
--
END debug_hdo;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_her (pi_rec_her hig_errors%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_her');
--
   nm_debug.debug('her_appl     : '||pi_rec_her.her_appl,p_level);
   nm_debug.debug('her_no       : '||pi_rec_her.her_no,p_level);
   nm_debug.debug('her_type     : '||pi_rec_her.her_type,p_level);
   nm_debug.debug('her_descr    : '||pi_rec_her.her_descr,p_level);
   nm_debug.debug('her_action_1 : '||pi_rec_her.her_action_1,p_level);
   nm_debug.debug('her_action_2 : '||pi_rec_her.her_action_2,p_level);
   nm_debug.debug('her_action_3 : '||pi_rec_her.her_action_3,p_level);
   nm_debug.debug('her_action_4 : '||pi_rec_her.her_action_4,p_level);
   nm_debug.debug('her_action_5 : '||pi_rec_her.her_action_5,p_level);
   nm_debug.debug('her_action_6 : '||pi_rec_her.her_action_6,p_level);
   nm_debug.debug('her_action_7 : '||pi_rec_her.her_action_7,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_her');
--
END debug_her;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hht (pi_rec_hht hig_hd_join_defs%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hht');
--
   nm_debug.debug('hht_hhu_hhm_module : '||pi_rec_hht.hht_hhu_hhm_module,p_level);
   nm_debug.debug('hht_hhu_seq        : '||pi_rec_hht.hht_hhu_seq,p_level);
   nm_debug.debug('hht_join_seq       : '||pi_rec_hht.hht_join_seq,p_level);
   nm_debug.debug('hht_type           : '||pi_rec_hht.hht_type,p_level);
   nm_debug.debug('hht_description    : '||pi_rec_hht.hht_description,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hht');
--
END debug_hht;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hho (pi_rec_hho hig_hd_lookup_join_cols%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hho');
--
   nm_debug.debug('hho_hhl_hhu_hhm_module : '||pi_rec_hho.hho_hhl_hhu_hhm_module,p_level);
   nm_debug.debug('hho_hhl_hhu_seq        : '||pi_rec_hho.hho_hhl_hhu_seq,p_level);
   nm_debug.debug('hho_hhl_join_seq       : '||pi_rec_hho.hho_hhl_join_seq,p_level);
   nm_debug.debug('hho_parent_col         : '||pi_rec_hho.hho_parent_col,p_level);
   nm_debug.debug('hho_lookup_col         : '||pi_rec_hho.hho_lookup_col,p_level);
   nm_debug.debug('hho_hhl_join_to_lookup : '||pi_rec_hho.hho_hhl_join_to_lookup,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hho');
--
END debug_hho;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hhl (pi_rec_hhl hig_hd_lookup_join_defs%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hhl');
--
   nm_debug.debug('hhl_hhu_hhm_module     : '||pi_rec_hhl.hhl_hhu_hhm_module,p_level);
   nm_debug.debug('hhl_hhu_seq            : '||pi_rec_hhl.hhl_hhu_seq,p_level);
   nm_debug.debug('hhl_join_seq           : '||pi_rec_hhl.hhl_join_seq,p_level);
   nm_debug.debug('hhl_table_name         : '||pi_rec_hhl.hhl_table_name,p_level);
   nm_debug.debug('hhl_alias              : '||pi_rec_hhl.hhl_alias,p_level);
   nm_debug.debug('hhl_outer_join         : '||pi_rec_hhl.hhl_outer_join,p_level);
   nm_debug.debug('hhl_fixed_where_clause : '||pi_rec_hhl.hhl_fixed_where_clause,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hhl');
--
END debug_hhl;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hhm (pi_rec_hhm hig_hd_modules%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hhm');
--
   nm_debug.debug('hhm_module : '||pi_rec_hhm.hhm_module,p_level);
   nm_debug.debug('hhm_tag    : '||pi_rec_hhm.hhm_tag,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hhm');
--
END debug_hhm;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hhu (pi_rec_hhu hig_hd_mod_uses%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hhu');
--
   nm_debug.debug('hhu_hhm_module         : '||pi_rec_hhu.hhu_hhm_module,p_level);
   nm_debug.debug('hhu_table_name         : '||pi_rec_hhu.hhu_table_name,p_level);
   nm_debug.debug('hhu_seq                : '||pi_rec_hhu.hhu_seq,p_level);
   nm_debug.debug('hhu_alias              : '||pi_rec_hhu.hhu_alias,p_level);
   nm_debug.debug('hhu_parent_seq         : '||pi_rec_hhu.hhu_parent_seq,p_level);
   nm_debug.debug('hhu_fixed_where_clause : '||pi_rec_hhu.hhu_fixed_where_clause,p_level);
   nm_debug.debug('hhu_load_data          : '||pi_rec_hhu.hhu_load_data,p_level);
   nm_debug.debug('hhu_hint_text          : '||pi_rec_hhu.hhu_hint_text,p_level);
   nm_debug.debug('hhu_tag                : '||pi_rec_hhu.hhu_tag,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hhu');
--
END debug_hhu;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hhc (pi_rec_hhc hig_hd_selected_cols%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hhc');
--
   nm_debug.debug('hhc_hhu_hhm_module        : '||pi_rec_hhc.hhc_hhu_hhm_module,p_level);
   nm_debug.debug('hhc_hhu_seq               : '||pi_rec_hhc.hhc_hhu_seq,p_level);
   nm_debug.debug('hhc_column_seq            : '||pi_rec_hhc.hhc_column_seq,p_level);
   nm_debug.debug('hhc_column_name           : '||pi_rec_hhc.hhc_column_name,p_level);
   nm_debug.debug('hhc_summary_view          : '||pi_rec_hhc.hhc_summary_view,p_level);
   nm_debug.debug('hhc_displayed             : '||pi_rec_hhc.hhc_displayed,p_level);
   nm_debug.debug('hhc_alias                 : '||pi_rec_hhc.hhc_alias,p_level);
   nm_debug.debug('hhc_function              : '||pi_rec_hhc.hhc_function,p_level);
   nm_debug.debug('hhc_order_by_seq          : '||pi_rec_hhc.hhc_order_by_seq,p_level);
   nm_debug.debug('hhc_unique_identifier_seq : '||pi_rec_hhc.hhc_unique_identifier_seq,p_level);
   nm_debug.debug('hhc_hhl_join_seq          : '||pi_rec_hhc.hhc_hhl_join_seq,p_level);
   nm_debug.debug('hhc_calc_ratio            : '||pi_rec_hhc.hhc_calc_ratio,p_level);
   nm_debug.debug('hhc_format                : '||pi_rec_hhc.hhc_format,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hhc');
--
END debug_hhc;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hhj (pi_rec_hhj hig_hd_table_join_cols%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hhj');
--
   nm_debug.debug('hhj_hht_hhu_hhm_module   : '||pi_rec_hhj.hhj_hht_hhu_hhm_module,p_level);
   nm_debug.debug('hhj_hht_hhu_parent_table : '||pi_rec_hhj.hhj_hht_hhu_parent_table,p_level);
   nm_debug.debug('hhj_hht_join_seq         : '||pi_rec_hhj.hhj_hht_join_seq,p_level);
   nm_debug.debug('hhj_parent_col           : '||pi_rec_hhj.hhj_parent_col,p_level);
   nm_debug.debug('hhj_hhu_child_table      : '||pi_rec_hhj.hhj_hhu_child_table,p_level);
   nm_debug.debug('hhj_child_col            : '||pi_rec_hhj.hhj_child_col,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hhj');
--
END debug_hhj;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hho (pi_rec_hho hig_holidays%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hho');
--
   nm_debug.debug('hho_id   : '||pi_rec_hho.hho_id,p_level);
   nm_debug.debug('hho_name : '||pi_rec_hho.hho_name,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hho');
--
END debug_hho;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hmo (pi_rec_hmo hig_modules%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hmo');
--
   nm_debug.debug('hmo_module           : '||pi_rec_hmo.hmo_module,p_level);
   nm_debug.debug('hmo_title            : '||pi_rec_hmo.hmo_title,p_level);
   nm_debug.debug('hmo_filename         : '||pi_rec_hmo.hmo_filename,p_level);
   nm_debug.debug('hmo_module_type      : '||pi_rec_hmo.hmo_module_type,p_level);
   nm_debug.debug('hmo_fastpath_opts    : '||pi_rec_hmo.hmo_fastpath_opts,p_level);
   nm_debug.debug('hmo_fastpath_invalid : '||pi_rec_hmo.hmo_fastpath_invalid,p_level);
   nm_debug.debug('hmo_use_gri          : '||pi_rec_hmo.hmo_use_gri,p_level);
   nm_debug.debug('hmo_application      : '||pi_rec_hmo.hmo_application,p_level);
   nm_debug.debug('hmo_menu             : '||pi_rec_hmo.hmo_menu,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hmo');
--
END debug_hmo;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hmh (pi_rec_hmh hig_module_history%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hmh');
--
   nm_debug.debug('hmh_user_id   : '||pi_rec_hmh.hmh_user_id,p_level);
   nm_debug.debug('hmh_seq_no    : '||pi_rec_hmh.hmh_seq_no,p_level);
   nm_debug.debug('hmh_module    : '||pi_rec_hmh.hmh_module,p_level);
   nm_debug.debug('hmh_used_date : '||pi_rec_hmh.hmh_used_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hmh');
--
END debug_hmh;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hmk (pi_rec_hmk hig_module_keywords%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hmk');
--
   nm_debug.debug('hmk_hmo_module : '||pi_rec_hmk.hmk_hmo_module,p_level);
   nm_debug.debug('hmk_keyword    : '||pi_rec_hmk.hmk_keyword,p_level);
   nm_debug.debug('hmk_owner      : '||pi_rec_hmk.hmk_owner,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hmk');
--
END debug_hmk;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hmr (pi_rec_hmr hig_module_roles%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hmr');
--
   nm_debug.debug('hmr_module : '||pi_rec_hmr.hmr_module,p_level);
   nm_debug.debug('hmr_role   : '||pi_rec_hmr.hmr_role,p_level);
   nm_debug.debug('hmr_mode   : '||pi_rec_hmr.hmr_mode,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hmr');
--
END debug_hmr;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hmu (pi_rec_hmu hig_module_usages%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hmu');
--
   nm_debug.debug('hmu_module    : '||pi_rec_hmu.hmu_module,p_level);
   nm_debug.debug('hmu_usage     : '||pi_rec_hmu.hmu_usage,p_level);
   nm_debug.debug('hmu_parameter : '||pi_rec_hmu.hmu_parameter,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hmu');
--
END debug_hmu;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hol (pi_rec_hol hig_option_list%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hol');
--
   nm_debug.debug('hol_id          : '||pi_rec_hol.hol_id,p_level);
   nm_debug.debug('hol_product     : '||pi_rec_hol.hol_product,p_level);
   nm_debug.debug('hol_name        : '||pi_rec_hol.hol_name,p_level);
   nm_debug.debug('hol_remarks     : '||pi_rec_hol.hol_remarks,p_level);
   nm_debug.debug('hol_domain      : '||pi_rec_hol.hol_domain,p_level);
   nm_debug.debug('hol_datatype    : '||pi_rec_hol.hol_datatype,p_level);
   nm_debug.debug('hol_mixed_case  : '||pi_rec_hol.hol_mixed_case,p_level);
   nm_debug.debug('hol_user_option : '||pi_rec_hol.hol_user_option,p_level);
   nm_debug.debug('hol_max_length  : '||pi_rec_hol.hol_max_length,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hol');
--
END debug_hol;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hop (pi_rec_hop hig_options%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hop');
--
   nm_debug.debug('hop_id         : '||pi_rec_hop.hop_id,p_level);
   nm_debug.debug('hop_product    : '||pi_rec_hop.hop_product,p_level);
   nm_debug.debug('hop_name       : '||pi_rec_hop.hop_name,p_level);
   nm_debug.debug('hop_value      : '||pi_rec_hop.hop_value,p_level);
   nm_debug.debug('hop_remarks    : '||pi_rec_hop.hop_remarks,p_level);
   nm_debug.debug('hop_domain     : '||pi_rec_hop.hop_domain,p_level);
   nm_debug.debug('hop_datatype   : '||pi_rec_hop.hop_datatype,p_level);
   nm_debug.debug('hop_mixed_case : '||pi_rec_hop.hop_mixed_case,p_level);
   nm_debug.debug('hop_max_length : '||pi_rec_hop.hop_max_length,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hop');
--
END debug_hop;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hov (pi_rec_hov hig_option_values%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hov');
--
   nm_debug.debug('hov_id    : '||pi_rec_hov.hov_id,p_level);
   nm_debug.debug('hov_value : '||pi_rec_hov.hov_value,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hov');
--
END debug_hov;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hpr (pi_rec_hpr hig_products%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hpr');
--
   nm_debug.debug('hpr_product        : '||pi_rec_hpr.hpr_product,p_level);
   nm_debug.debug('hpr_product_name   : '||pi_rec_hpr.hpr_product_name,p_level);
   nm_debug.debug('hpr_version        : '||pi_rec_hpr.hpr_version,p_level);
   nm_debug.debug('hpr_path_name      : '||pi_rec_hpr.hpr_path_name,p_level);
   nm_debug.debug('hpr_key            : '||pi_rec_hpr.hpr_key,p_level);
   nm_debug.debug('hpr_sequence       : '||pi_rec_hpr.hpr_sequence,p_level);
   nm_debug.debug('hpr_image          : '||pi_rec_hpr.hpr_image,p_level);
   nm_debug.debug('hpr_user_menu      : '||pi_rec_hpr.hpr_user_menu,p_level);
   nm_debug.debug('hpr_launchpad_icon : '||pi_rec_hpr.hpr_launchpad_icon,p_level);
   nm_debug.debug('hpr_image_type     : '||pi_rec_hpr.hpr_image_type,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hpr');
--
END debug_hpr;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hrs (pi_rec_hrs hig_report_styles%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hrs');
--
   nm_debug.debug('hrs_style_name         : '||pi_rec_hrs.hrs_style_name,p_level);
   nm_debug.debug('hrs_header_fill_colour : '||pi_rec_hrs.hrs_header_fill_colour,p_level);
   nm_debug.debug('hrs_body_fill_colour_1 : '||pi_rec_hrs.hrs_body_fill_colour_1,p_level);
   nm_debug.debug('hrs_body_fill_colour_2 : '||pi_rec_hrs.hrs_body_fill_colour_2,p_level);
   nm_debug.debug('hrs_body_fill_colour_h : '||pi_rec_hrs.hrs_body_fill_colour_h,p_level);
   nm_debug.debug('hrs_header_font_colour : '||pi_rec_hrs.hrs_header_font_colour,p_level);
   nm_debug.debug('hrs_body_font_colour_1 : '||pi_rec_hrs.hrs_body_font_colour_1,p_level);
   nm_debug.debug('hrs_body_font_colour_2 : '||pi_rec_hrs.hrs_body_font_colour_2,p_level);
   nm_debug.debug('hrs_body_font_colour_h : '||pi_rec_hrs.hrs_body_font_colour_h,p_level);
   nm_debug.debug('hrs_image_name         : '||pi_rec_hrs.hrs_image_name,p_level);
   nm_debug.debug('hrs_footer_text        : '||pi_rec_hrs.hrs_footer_text,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hrs');
--
END debug_hrs;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hro (pi_rec_hro hig_roles%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hro');
--
   nm_debug.debug('hro_role    : '||pi_rec_hro.hro_role,p_level);
   nm_debug.debug('hro_product : '||pi_rec_hro.hro_product,p_level);
   nm_debug.debug('hro_descr   : '||pi_rec_hro.hro_descr,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hro');
--
END debug_hro;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hsc (pi_rec_hsc hig_status_codes%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hsc');
--
   nm_debug.debug('hsc_domain_code     : '||pi_rec_hsc.hsc_domain_code,p_level);
   nm_debug.debug('hsc_status_code     : '||pi_rec_hsc.hsc_status_code,p_level);
   nm_debug.debug('hsc_status_name     : '||pi_rec_hsc.hsc_status_name,p_level);
   nm_debug.debug('hsc_seq_no          : '||pi_rec_hsc.hsc_seq_no,p_level);
   nm_debug.debug('hsc_allow_feature1  : '||pi_rec_hsc.hsc_allow_feature1,p_level);
   nm_debug.debug('hsc_allow_feature2  : '||pi_rec_hsc.hsc_allow_feature2,p_level);
   nm_debug.debug('hsc_allow_feature3  : '||pi_rec_hsc.hsc_allow_feature3,p_level);
   nm_debug.debug('hsc_allow_feature4  : '||pi_rec_hsc.hsc_allow_feature4,p_level);
   nm_debug.debug('hsc_allow_feature5  : '||pi_rec_hsc.hsc_allow_feature5,p_level);
   nm_debug.debug('hsc_allow_feature6  : '||pi_rec_hsc.hsc_allow_feature6,p_level);
   nm_debug.debug('hsc_allow_feature7  : '||pi_rec_hsc.hsc_allow_feature7,p_level);
   nm_debug.debug('hsc_allow_feature8  : '||pi_rec_hsc.hsc_allow_feature8,p_level);
   nm_debug.debug('hsc_allow_feature9  : '||pi_rec_hsc.hsc_allow_feature9,p_level);
   nm_debug.debug('hsc_start_date      : '||pi_rec_hsc.hsc_start_date,p_level);
   nm_debug.debug('hsc_end_date        : '||pi_rec_hsc.hsc_end_date,p_level);
   nm_debug.debug('hsc_allow_feature10 : '||pi_rec_hsc.hsc_allow_feature10,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hsc');
--
END debug_hsc;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hsd (pi_rec_hsd hig_status_domains%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hsd');
--
   nm_debug.debug('hsd_domain_code : '||pi_rec_hsd.hsd_domain_code,p_level);
   nm_debug.debug('hsd_product     : '||pi_rec_hsd.hsd_product,p_level);
   nm_debug.debug('hsd_description : '||pi_rec_hsd.hsd_description,p_level);
   nm_debug.debug('hsd_feature1    : '||pi_rec_hsd.hsd_feature1,p_level);
   nm_debug.debug('hsd_feature2    : '||pi_rec_hsd.hsd_feature2,p_level);
   nm_debug.debug('hsd_feature3    : '||pi_rec_hsd.hsd_feature3,p_level);
   nm_debug.debug('hsd_feature4    : '||pi_rec_hsd.hsd_feature4,p_level);
   nm_debug.debug('hsd_feature5    : '||pi_rec_hsd.hsd_feature5,p_level);
   nm_debug.debug('hsd_feature6    : '||pi_rec_hsd.hsd_feature6,p_level);
   nm_debug.debug('hsd_feature7    : '||pi_rec_hsd.hsd_feature7,p_level);
   nm_debug.debug('hsd_feature8    : '||pi_rec_hsd.hsd_feature8,p_level);
   nm_debug.debug('hsd_feature9    : '||pi_rec_hsd.hsd_feature9,p_level);
   nm_debug.debug('hsd_feature10   : '||pi_rec_hsd.hsd_feature10,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hsd');
--
END debug_hsd;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hup (pi_rec_hup hig_upgrades%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hup');
--
   nm_debug.debug('hup_product    : '||pi_rec_hup.hup_product,p_level);
   nm_debug.debug('date_upgraded  : '||pi_rec_hup.date_upgraded,p_level);
   nm_debug.debug('from_version   : '||pi_rec_hup.from_version,p_level);
   nm_debug.debug('to_version     : '||pi_rec_hup.to_version,p_level);
   nm_debug.debug('upgrade_script : '||pi_rec_hup.upgrade_script,p_level);
   nm_debug.debug('executed_by    : '||pi_rec_hup.executed_by,p_level);
   nm_debug.debug('remarks        : '||pi_rec_hup.remarks,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hup');
--
END debug_hup;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hum (pi_rec_hum hig_url_modules%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hum');
--
   nm_debug.debug('hum_hmo_module : '||pi_rec_hum.hum_hmo_module,p_level);
   nm_debug.debug('hum_url        : '||pi_rec_hum.hum_url,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hum');
--
END debug_hum;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hus (pi_rec_hus hig_users%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hus');
--
   nm_debug.debug('hus_user_id           : '||pi_rec_hus.hus_user_id,p_level);
   nm_debug.debug('hus_initials          : '||pi_rec_hus.hus_initials,p_level);
   nm_debug.debug('hus_name              : '||pi_rec_hus.hus_name,p_level);
   nm_debug.debug('hus_username          : '||pi_rec_hus.hus_username,p_level);
   nm_debug.debug('hus_job_title         : '||pi_rec_hus.hus_job_title,p_level);
   nm_debug.debug('hus_agent_code        : '||pi_rec_hus.hus_agent_code,p_level);
   nm_debug.debug('hus_wor_flag          : '||pi_rec_hus.hus_wor_flag,p_level);
   nm_debug.debug('hus_wor_value_min     : '||pi_rec_hus.hus_wor_value_min,p_level);
   nm_debug.debug('hus_wor_value_max     : '||pi_rec_hus.hus_wor_value_max,p_level);
   nm_debug.debug('hus_start_date        : '||pi_rec_hus.hus_start_date,p_level);
   nm_debug.debug('hus_end_date          : '||pi_rec_hus.hus_end_date,p_level);
   nm_debug.debug('hus_unrestricted      : '||pi_rec_hus.hus_unrestricted,p_level);
   nm_debug.debug('hus_is_hig_owner_flag : '||pi_rec_hus.hus_is_hig_owner_flag,p_level);
   nm_debug.debug('hus_admin_unit        : '||pi_rec_hus.hus_admin_unit,p_level);
   nm_debug.debug('hus_wor_aur_min       : '||pi_rec_hus.hus_wor_aur_min,p_level);
   nm_debug.debug('hus_wor_aur_max       : '||pi_rec_hus.hus_wor_aur_max,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hus');
--
END debug_hus;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_huh (pi_rec_huh hig_user_history%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_huh');
--
   nm_debug.debug('huh_user_id      : '||pi_rec_huh.huh_user_id,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_huh');
--
END debug_huh;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_huo (pi_rec_huo hig_user_options%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_huo');
--
   nm_debug.debug('huo_hus_user_id : '||pi_rec_huo.huo_hus_user_id,p_level);
   nm_debug.debug('huo_id          : '||pi_rec_huo.huo_id,p_level);
   nm_debug.debug('huo_value       : '||pi_rec_huo.huo_value,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_huo');
--
END debug_huo;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_hur (pi_rec_hur hig_user_roles%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_hur');
--
   nm_debug.debug('hur_username   : '||pi_rec_hur.hur_username,p_level);
   nm_debug.debug('hur_role       : '||pi_rec_hur.hur_role,p_level);
   nm_debug.debug('hur_start_date : '||pi_rec_hur.hur_start_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_hur');
--
END debug_hur;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nag (pi_rec_nag nm_admin_groups%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nag');
--
   nm_debug.debug('nag_parent_admin_unit : '||pi_rec_nag.nag_parent_admin_unit,p_level);
   nm_debug.debug('nag_child_admin_unit  : '||pi_rec_nag.nag_child_admin_unit,p_level);
   nm_debug.debug('nag_direct_link       : '||pi_rec_nag.nag_direct_link,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nag');
--
END debug_nag;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nau (pi_rec_nau nm_admin_units%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nau');
--
   nm_debug.debug('nau_admin_unit       : '||pi_rec_nau.nau_admin_unit,p_level);
   nm_debug.debug('nau_unit_code        : '||pi_rec_nau.nau_unit_code,p_level);
   nm_debug.debug('nau_level            : '||pi_rec_nau.nau_level,p_level);
   nm_debug.debug('nau_authority_code   : '||pi_rec_nau.nau_authority_code,p_level);
   nm_debug.debug('nau_name             : '||pi_rec_nau.nau_name,p_level);
   nm_debug.debug('nau_address1         : '||pi_rec_nau.nau_address1,p_level);
   nm_debug.debug('nau_address2         : '||pi_rec_nau.nau_address2,p_level);
   nm_debug.debug('nau_address3         : '||pi_rec_nau.nau_address3,p_level);
   nm_debug.debug('nau_address4         : '||pi_rec_nau.nau_address4,p_level);
   nm_debug.debug('nau_address5         : '||pi_rec_nau.nau_address5,p_level);
   nm_debug.debug('nau_phone            : '||pi_rec_nau.nau_phone,p_level);
   nm_debug.debug('nau_fax              : '||pi_rec_nau.nau_fax,p_level);
   nm_debug.debug('nau_comments         : '||pi_rec_nau.nau_comments,p_level);
   nm_debug.debug('nau_last_wor_no      : '||pi_rec_nau.nau_last_wor_no,p_level);
   nm_debug.debug('nau_start_date       : '||pi_rec_nau.nau_start_date,p_level);
   nm_debug.debug('nau_end_date         : '||pi_rec_nau.nau_end_date,p_level);
   nm_debug.debug('nau_admin_type       : '||pi_rec_nau.nau_admin_type,p_level);
   nm_debug.debug('nau_nsty_sub_type    : '||pi_rec_nau.nau_nsty_sub_type,p_level);
   nm_debug.debug('nau_prefix           : '||pi_rec_nau.nau_prefix,p_level);
   nm_debug.debug('nau_postcode         : '||pi_rec_nau.nau_postcode,p_level);
   nm_debug.debug('nau_minor_undertaker : '||pi_rec_nau.nau_minor_undertaker,p_level);
   nm_debug.debug('nau_tcpip            : '||pi_rec_nau.nau_tcpip,p_level);
   nm_debug.debug('nau_domain           : '||pi_rec_nau.nau_domain,p_level);
   nm_debug.debug('nau_directory        : '||pi_rec_nau.nau_directory,p_level);
   nm_debug.debug('nau_external_name    : '||pi_rec_nau.nau_external_name,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nau');
--
END debug_nau;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nau_all (pi_rec_nau_all nm_admin_units_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nau_all');
--
   nm_debug.debug('nau_admin_unit       : '||pi_rec_nau_all.nau_admin_unit,p_level);
   nm_debug.debug('nau_unit_code        : '||pi_rec_nau_all.nau_unit_code,p_level);
   nm_debug.debug('nau_level            : '||pi_rec_nau_all.nau_level,p_level);
   nm_debug.debug('nau_authority_code   : '||pi_rec_nau_all.nau_authority_code,p_level);
   nm_debug.debug('nau_name             : '||pi_rec_nau_all.nau_name,p_level);
   nm_debug.debug('nau_address1         : '||pi_rec_nau_all.nau_address1,p_level);
   nm_debug.debug('nau_address2         : '||pi_rec_nau_all.nau_address2,p_level);
   nm_debug.debug('nau_address3         : '||pi_rec_nau_all.nau_address3,p_level);
   nm_debug.debug('nau_address4         : '||pi_rec_nau_all.nau_address4,p_level);
   nm_debug.debug('nau_address5         : '||pi_rec_nau_all.nau_address5,p_level);
   nm_debug.debug('nau_phone            : '||pi_rec_nau_all.nau_phone,p_level);
   nm_debug.debug('nau_fax              : '||pi_rec_nau_all.nau_fax,p_level);
   nm_debug.debug('nau_comments         : '||pi_rec_nau_all.nau_comments,p_level);
   nm_debug.debug('nau_last_wor_no      : '||pi_rec_nau_all.nau_last_wor_no,p_level);
   nm_debug.debug('nau_start_date       : '||pi_rec_nau_all.nau_start_date,p_level);
   nm_debug.debug('nau_end_date         : '||pi_rec_nau_all.nau_end_date,p_level);
   nm_debug.debug('nau_admin_type       : '||pi_rec_nau_all.nau_admin_type,p_level);
   nm_debug.debug('nau_nsty_sub_type    : '||pi_rec_nau_all.nau_nsty_sub_type,p_level);
   nm_debug.debug('nau_prefix           : '||pi_rec_nau_all.nau_prefix,p_level);
   nm_debug.debug('nau_postcode         : '||pi_rec_nau_all.nau_postcode,p_level);
   nm_debug.debug('nau_minor_undertaker : '||pi_rec_nau_all.nau_minor_undertaker,p_level);
   nm_debug.debug('nau_tcpip            : '||pi_rec_nau_all.nau_tcpip,p_level);
   nm_debug.debug('nau_domain           : '||pi_rec_nau_all.nau_domain,p_level);
   nm_debug.debug('nau_directory        : '||pi_rec_nau_all.nau_directory,p_level);
   nm_debug.debug('nau_external_name    : '||pi_rec_nau_all.nau_external_name,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nau_all');
--
END debug_nau_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nal (pi_rec_nal nm_area_lock%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nal');
--
   nm_debug.debug('nal_id         : '||pi_rec_nal.nal_id,p_level);
   nm_debug.debug('nal_timestamp  : '||pi_rec_nal.nal_timestamp,p_level);
   nm_debug.debug('nal_terminal   : '||pi_rec_nal.nal_terminal,p_level);
   nm_debug.debug('nal_session_id : '||pi_rec_nal.nal_session_id,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nal');
--
END debug_nal;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nars (pi_rec_nars nm_assets_on_route_store%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nars');
--
   nm_debug.debug('nars_job_id                   : '||pi_rec_nars.nars_job_id,p_level);
   nm_debug.debug('nars_ne_id_in                 : '||pi_rec_nars.nars_ne_id_in,p_level);
   nm_debug.debug('nars_item_x_sect              : '||pi_rec_nars.nars_item_x_sect,p_level);
   nm_debug.debug('nars_ne_id_of_begin           : '||pi_rec_nars.nars_ne_id_of_begin,p_level);
   nm_debug.debug('nars_begin_mp                 : '||pi_rec_nars.nars_begin_mp,p_level);
   nm_debug.debug('nars_ne_id_of_end             : '||pi_rec_nars.nars_ne_id_of_end,p_level);
   nm_debug.debug('nars_end_mp                   : '||pi_rec_nars.nars_end_mp,p_level);
   nm_debug.debug('nars_seq_no                   : '||pi_rec_nars.nars_seq_no,p_level);
   nm_debug.debug('nars_seg_no                   : '||pi_rec_nars.nars_seg_no,p_level);
   nm_debug.debug('nars_item_type_type           : '||pi_rec_nars.nars_item_type_type,p_level);
   nm_debug.debug('nars_item_type                : '||pi_rec_nars.nars_item_type,p_level);
   nm_debug.debug('nars_item_type_descr          : '||pi_rec_nars.nars_item_type_descr,p_level);
   nm_debug.debug('nars_nm_type                  : '||pi_rec_nars.nars_nm_type,p_level);
   nm_debug.debug('nars_nm_obj_type              : '||pi_rec_nars.nars_nm_obj_type,p_level);
   nm_debug.debug('nars_placement_begin_mp       : '||pi_rec_nars.nars_placement_begin_mp,p_level);
   nm_debug.debug('nars_placement_end_mp         : '||pi_rec_nars.nars_placement_end_mp,p_level);
   nm_debug.debug('nars_reference_item_id        : '||pi_rec_nars.nars_reference_item_id,p_level);
   nm_debug.debug('nars_reference_item_x_sect    : '||pi_rec_nars.nars_reference_item_x_sect,p_level);
   nm_debug.debug('nars_begin_reference_begin_mp : '||pi_rec_nars.nars_begin_reference_begin_mp,p_level);
   nm_debug.debug('nars_begin_reference_end_mp   : '||pi_rec_nars.nars_begin_reference_end_mp,p_level);
   nm_debug.debug('nars_end_reference_begin_mp   : '||pi_rec_nars.nars_end_reference_begin_mp,p_level);
   nm_debug.debug('nars_end_reference_end_mp     : '||pi_rec_nars.nars_end_reference_end_mp,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nars');
--
END debug_nars;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_narsa (pi_rec_narsa nm_assets_on_route_store_att%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_narsa');
--
   nm_debug.debug('narsa_job_id    : '||pi_rec_narsa.narsa_job_id,p_level);
   nm_debug.debug('narsa_iit_ne_id : '||pi_rec_narsa.narsa_iit_ne_id,p_level);
   nm_debug.debug('narsa_value     : '||pi_rec_narsa.narsa_value,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_narsa');
--
END debug_narsa;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_narsd (pi_rec_narsd nm_assets_on_route_store_att_d%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_narsd');
--
   nm_debug.debug('narsd_job_id      : '||pi_rec_narsd.narsd_job_id,p_level);
   nm_debug.debug('narsd_iit_ne_id   : '||pi_rec_narsd.narsd_iit_ne_id,p_level);
   nm_debug.debug('narsd_attrib_name : '||pi_rec_narsd.narsd_attrib_name,p_level);
   nm_debug.debug('narsd_seq_no      : '||pi_rec_narsd.narsd_seq_no,p_level);
   nm_debug.debug('narsd_value       : '||pi_rec_narsd.narsd_value,p_level);
   nm_debug.debug('narsd_scrn_text   : '||pi_rec_narsd.narsd_scrn_text,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_narsd');
--
END debug_narsd;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_narsh (pi_rec_narsh nm_assets_on_route_store_head%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_narsh');
--
   nm_debug.debug('narsh_job_id                   : '||pi_rec_narsh.narsh_job_id,p_level);
   nm_debug.debug('narsh_effective_date           : '||pi_rec_narsh.narsh_effective_date,p_level);
   nm_debug.debug('narsh_source_id                : '||pi_rec_narsh.narsh_source_id,p_level);
   nm_debug.debug('narsh_source                   : '||pi_rec_narsh.narsh_source,p_level);
   nm_debug.debug('narsh_source_unique            : '||pi_rec_narsh.narsh_source_unique,p_level);
   nm_debug.debug('narsh_source_descr             : '||pi_rec_narsh.narsh_source_descr,p_level);
   nm_debug.debug('narsh_source_min_offset        : '||pi_rec_narsh.narsh_source_min_offset,p_level);
   nm_debug.debug('narsh_source_max_offset        : '||pi_rec_narsh.narsh_source_max_offset,p_level);
   nm_debug.debug('narsh_source_length            : '||pi_rec_narsh.narsh_source_length,p_level);
   nm_debug.debug('narsh_source_unit_id           : '||pi_rec_narsh.narsh_source_unit_id,p_level);
   nm_debug.debug('narsh_source_unit_name         : '||pi_rec_narsh.narsh_source_unit_name,p_level);
   nm_debug.debug('narsh_entire                   : '||pi_rec_narsh.narsh_entire,p_level);
   nm_debug.debug('narsh_begin_mp                 : '||pi_rec_narsh.narsh_begin_mp,p_level);
   nm_debug.debug('narsh_begin_datum_ne_id        : '||pi_rec_narsh.narsh_begin_datum_ne_id,p_level);
   nm_debug.debug('narsh_begin_datum_offset       : '||pi_rec_narsh.narsh_begin_datum_offset,p_level);
   nm_debug.debug('narsh_end_mp                   : '||pi_rec_narsh.narsh_end_mp,p_level);
   nm_debug.debug('narsh_end_datum_ne_id          : '||pi_rec_narsh.narsh_end_datum_ne_id,p_level);
   nm_debug.debug('narsh_end_datum_offset         : '||pi_rec_narsh.narsh_end_datum_offset,p_level);
   nm_debug.debug('narsh_ambig_sub_class          : '||pi_rec_narsh.narsh_ambig_sub_class,p_level);
   nm_debug.debug('narsh_reference_type           : '||pi_rec_narsh.narsh_reference_type,p_level);
   nm_debug.debug('narsh_reference_inv_type       : '||pi_rec_narsh.narsh_reference_inv_type,p_level);
   nm_debug.debug('narsh_reference_inv_type_descr : '||pi_rec_narsh.narsh_reference_inv_type_descr,p_level);
   nm_debug.debug('narsh_reference_item_id        : '||pi_rec_narsh.narsh_reference_item_id,p_level);
   nm_debug.debug('narsh_reference_item_xsp       : '||pi_rec_narsh.narsh_reference_item_xsp,p_level);
   nm_debug.debug('narsh_ref_negative             : '||pi_rec_narsh.narsh_ref_negative,p_level);
   nm_debug.debug('narsh_un_unit_id               : '||pi_rec_narsh.narsh_un_unit_id,p_level);
   nm_debug.debug('narsh_unit_name                : '||pi_rec_narsh.narsh_unit_name,p_level);
   nm_debug.debug('narsh_nias_id                  : '||pi_rec_narsh.narsh_nias_id,p_level);
   nm_debug.debug('narsh_date_created             : '||pi_rec_narsh.narsh_date_created,p_level);
   nm_debug.debug('narsh_date_modified            : '||pi_rec_narsh.narsh_date_modified,p_level);
   nm_debug.debug('narsh_modified_by              : '||pi_rec_narsh.narsh_modified_by,p_level);
   nm_debug.debug('narsh_created_by               : '||pi_rec_narsh.narsh_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_narsh');
--
END debug_narsh;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_narst (pi_rec_narst nm_assets_on_route_store_total%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_narst');
--
   nm_debug.debug('narst_job_id         : '||pi_rec_narst.narst_job_id,p_level);
   nm_debug.debug('narst_inv_type       : '||pi_rec_narst.narst_inv_type,p_level);
   nm_debug.debug('narst_inv_type_descr : '||pi_rec_narst.narst_inv_type_descr,p_level);
   nm_debug.debug('narst_item_count     : '||pi_rec_narst.narst_item_count,p_level);
   nm_debug.debug('narst_total_length   : '||pi_rec_narst.narst_total_length,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_narst');
--
END debug_narst;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_naa (pi_rec_naa nm_audit_actions%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_naa');
--
   nm_debug.debug('na_audit_id     : '||pi_rec_naa.na_audit_id,p_level);
   nm_debug.debug('na_timestamp    : '||pi_rec_naa.na_timestamp,p_level);
   nm_debug.debug('na_performed_by : '||pi_rec_naa.na_performed_by,p_level);
   nm_debug.debug('na_session_id   : '||pi_rec_naa.na_session_id,p_level);
   nm_debug.debug('na_table_name   : '||pi_rec_naa.na_table_name,p_level);
   nm_debug.debug('na_audit_type   : '||pi_rec_naa.na_audit_type,p_level);
   nm_debug.debug('na_key_info_1   : '||pi_rec_naa.na_key_info_1,p_level);
   nm_debug.debug('na_key_info_2   : '||pi_rec_naa.na_key_info_2,p_level);
   nm_debug.debug('na_key_info_3   : '||pi_rec_naa.na_key_info_3,p_level);
   nm_debug.debug('na_key_info_4   : '||pi_rec_naa.na_key_info_4,p_level);
   nm_debug.debug('na_key_info_5   : '||pi_rec_naa.na_key_info_5,p_level);
   nm_debug.debug('na_key_info_6   : '||pi_rec_naa.na_key_info_6,p_level);
   nm_debug.debug('na_key_info_7   : '||pi_rec_naa.na_key_info_7,p_level);
   nm_debug.debug('na_key_info_8   : '||pi_rec_naa.na_key_info_8,p_level);
   nm_debug.debug('na_key_info_9   : '||pi_rec_naa.na_key_info_9,p_level);
   nm_debug.debug('na_key_info_10  : '||pi_rec_naa.na_key_info_10,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_naa');
--
END debug_naa;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nach (pi_rec_nach nm_audit_changes%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nach');
--
   nm_debug.debug('nach_audit_id    : '||pi_rec_nach.nach_audit_id,p_level);
   nm_debug.debug('nach_column_id   : '||pi_rec_nach.nach_column_id,p_level);
   nm_debug.debug('nach_column_name : '||pi_rec_nach.nach_column_name,p_level);
   nm_debug.debug('nach_old_value   : '||pi_rec_nach.nach_old_value,p_level);
   nm_debug.debug('nach_new_value   : '||pi_rec_nach.nach_new_value,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nach');
--
END debug_nach;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nac (pi_rec_nac nm_audit_columns%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nac');
--
   nm_debug.debug('nac_table_name   : '||pi_rec_nac.nac_table_name,p_level);
   nm_debug.debug('nac_column_id    : '||pi_rec_nac.nac_column_id,p_level);
   nm_debug.debug('nac_column_name  : '||pi_rec_nac.nac_column_name,p_level);
   nm_debug.debug('nac_column_alias : '||pi_rec_nac.nac_column_alias,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nac');
--
END debug_nac;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nkc (pi_rec_nkc nm_audit_key_cols%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nkc');
--
   nm_debug.debug('nkc_table_name  : '||pi_rec_nkc.nkc_table_name,p_level);
   nm_debug.debug('nkc_seq_no      : '||pi_rec_nkc.nkc_seq_no,p_level);
   nm_debug.debug('nkc_column_name : '||pi_rec_nkc.nkc_column_name,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nkc');
--
END debug_nkc;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_natab (pi_rec_natab nm_audit_tables%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_natab');
--
   nm_debug.debug('nat_table_name   : '||pi_rec_natab.nat_table_name,p_level);
   nm_debug.debug('nat_table_alias  : '||pi_rec_natab.nat_table_alias,p_level);
   nm_debug.debug('nat_audit_insert : '||pi_rec_natab.nat_audit_insert,p_level);
   nm_debug.debug('nat_audit_update : '||pi_rec_natab.nat_audit_update,p_level);
   nm_debug.debug('nat_audit_delete : '||pi_rec_natab.nat_audit_delete,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_natab');
--
END debug_natab;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_natmp (pi_rec_natmp nm_audit_temp%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_natmp');
--
   nm_debug.debug('nat_audit_id          : '||pi_rec_natmp.nat_audit_id,p_level);
   nm_debug.debug('nat_old_or_new        : '||pi_rec_natmp.nat_old_or_new,p_level);
   nm_debug.debug('nat_audit_type        : '||pi_rec_natmp.nat_audit_type,p_level);
   nm_debug.debug('nat_audit_table       : '||pi_rec_natmp.nat_audit_table,p_level);
   nm_debug.debug('nat_timestamp         : '||pi_rec_natmp.nat_timestamp,p_level);
   nm_debug.debug('nat_performed_by      : '||pi_rec_natmp.nat_performed_by,p_level);
   nm_debug.debug('nat_session_id        : '||pi_rec_natmp.nat_session_id,p_level);
   nm_debug.debug('nat_processing_status : '||pi_rec_natmp.nat_processing_status,p_level);
   nm_debug.debug('nat_key_info_1        : '||pi_rec_natmp.nat_key_info_1,p_level);
   nm_debug.debug('nat_key_info_2        : '||pi_rec_natmp.nat_key_info_2,p_level);
   nm_debug.debug('nat_key_info_3        : '||pi_rec_natmp.nat_key_info_3,p_level);
   nm_debug.debug('nat_key_info_4        : '||pi_rec_natmp.nat_key_info_4,p_level);
   nm_debug.debug('nat_key_info_5        : '||pi_rec_natmp.nat_key_info_5,p_level);
   nm_debug.debug('nat_key_info_6        : '||pi_rec_natmp.nat_key_info_6,p_level);
   nm_debug.debug('nat_key_info_7        : '||pi_rec_natmp.nat_key_info_7,p_level);
   nm_debug.debug('nat_key_info_8        : '||pi_rec_natmp.nat_key_info_8,p_level);
   nm_debug.debug('nat_key_info_9        : '||pi_rec_natmp.nat_key_info_9,p_level);
   nm_debug.debug('nat_key_info_10       : '||pi_rec_natmp.nat_key_info_10,p_level);
   nm_debug.debug('nat_column_1          : '||pi_rec_natmp.nat_column_1,p_level);
   nm_debug.debug('nat_column_2          : '||pi_rec_natmp.nat_column_2,p_level);
   nm_debug.debug('nat_column_3          : '||pi_rec_natmp.nat_column_3,p_level);
   nm_debug.debug('nat_column_4          : '||pi_rec_natmp.nat_column_4,p_level);
   nm_debug.debug('nat_column_5          : '||pi_rec_natmp.nat_column_5,p_level);
   nm_debug.debug('nat_column_6          : '||pi_rec_natmp.nat_column_6,p_level);
   nm_debug.debug('nat_column_7          : '||pi_rec_natmp.nat_column_7,p_level);
   nm_debug.debug('nat_column_8          : '||pi_rec_natmp.nat_column_8,p_level);
   nm_debug.debug('nat_column_9          : '||pi_rec_natmp.nat_column_9,p_level);
   nm_debug.debug('nat_column_10         : '||pi_rec_natmp.nat_column_10,p_level);
   nm_debug.debug('nat_column_11         : '||pi_rec_natmp.nat_column_11,p_level);
   nm_debug.debug('nat_column_12         : '||pi_rec_natmp.nat_column_12,p_level);
   nm_debug.debug('nat_column_13         : '||pi_rec_natmp.nat_column_13,p_level);
   nm_debug.debug('nat_column_14         : '||pi_rec_natmp.nat_column_14,p_level);
   nm_debug.debug('nat_column_15         : '||pi_rec_natmp.nat_column_15,p_level);
   nm_debug.debug('nat_column_16         : '||pi_rec_natmp.nat_column_16,p_level);
   nm_debug.debug('nat_column_17         : '||pi_rec_natmp.nat_column_17,p_level);
   nm_debug.debug('nat_column_18         : '||pi_rec_natmp.nat_column_18,p_level);
   nm_debug.debug('nat_column_19         : '||pi_rec_natmp.nat_column_19,p_level);
   nm_debug.debug('nat_column_20         : '||pi_rec_natmp.nat_column_20,p_level);
   nm_debug.debug('nat_column_21         : '||pi_rec_natmp.nat_column_21,p_level);
   nm_debug.debug('nat_column_22         : '||pi_rec_natmp.nat_column_22,p_level);
   nm_debug.debug('nat_column_23         : '||pi_rec_natmp.nat_column_23,p_level);
   nm_debug.debug('nat_column_24         : '||pi_rec_natmp.nat_column_24,p_level);
   nm_debug.debug('nat_column_25         : '||pi_rec_natmp.nat_column_25,p_level);
   nm_debug.debug('nat_column_26         : '||pi_rec_natmp.nat_column_26,p_level);
   nm_debug.debug('nat_column_27         : '||pi_rec_natmp.nat_column_27,p_level);
   nm_debug.debug('nat_column_28         : '||pi_rec_natmp.nat_column_28,p_level);
   nm_debug.debug('nat_column_29         : '||pi_rec_natmp.nat_column_29,p_level);
   nm_debug.debug('nat_column_30         : '||pi_rec_natmp.nat_column_30,p_level);
   nm_debug.debug('nat_column_31         : '||pi_rec_natmp.nat_column_31,p_level);
   nm_debug.debug('nat_column_32         : '||pi_rec_natmp.nat_column_32,p_level);
   nm_debug.debug('nat_column_33         : '||pi_rec_natmp.nat_column_33,p_level);
   nm_debug.debug('nat_column_34         : '||pi_rec_natmp.nat_column_34,p_level);
   nm_debug.debug('nat_column_35         : '||pi_rec_natmp.nat_column_35,p_level);
   nm_debug.debug('nat_column_36         : '||pi_rec_natmp.nat_column_36,p_level);
   nm_debug.debug('nat_column_37         : '||pi_rec_natmp.nat_column_37,p_level);
   nm_debug.debug('nat_column_38         : '||pi_rec_natmp.nat_column_38,p_level);
   nm_debug.debug('nat_column_39         : '||pi_rec_natmp.nat_column_39,p_level);
   nm_debug.debug('nat_column_40         : '||pi_rec_natmp.nat_column_40,p_level);
   nm_debug.debug('nat_column_41         : '||pi_rec_natmp.nat_column_41,p_level);
   nm_debug.debug('nat_column_42         : '||pi_rec_natmp.nat_column_42,p_level);
   nm_debug.debug('nat_column_43         : '||pi_rec_natmp.nat_column_43,p_level);
   nm_debug.debug('nat_column_44         : '||pi_rec_natmp.nat_column_44,p_level);
   nm_debug.debug('nat_column_45         : '||pi_rec_natmp.nat_column_45,p_level);
   nm_debug.debug('nat_column_46         : '||pi_rec_natmp.nat_column_46,p_level);
   nm_debug.debug('nat_column_47         : '||pi_rec_natmp.nat_column_47,p_level);
   nm_debug.debug('nat_column_48         : '||pi_rec_natmp.nat_column_48,p_level);
   nm_debug.debug('nat_column_49         : '||pi_rec_natmp.nat_column_49,p_level);
   nm_debug.debug('nat_column_50         : '||pi_rec_natmp.nat_column_50,p_level);
   nm_debug.debug('nat_column_51         : '||pi_rec_natmp.nat_column_51,p_level);
   nm_debug.debug('nat_column_52         : '||pi_rec_natmp.nat_column_52,p_level);
   nm_debug.debug('nat_column_53         : '||pi_rec_natmp.nat_column_53,p_level);
   nm_debug.debug('nat_column_54         : '||pi_rec_natmp.nat_column_54,p_level);
   nm_debug.debug('nat_column_55         : '||pi_rec_natmp.nat_column_55,p_level);
   nm_debug.debug('nat_column_56         : '||pi_rec_natmp.nat_column_56,p_level);
   nm_debug.debug('nat_column_57         : '||pi_rec_natmp.nat_column_57,p_level);
   nm_debug.debug('nat_column_58         : '||pi_rec_natmp.nat_column_58,p_level);
   nm_debug.debug('nat_column_59         : '||pi_rec_natmp.nat_column_59,p_level);
   nm_debug.debug('nat_column_60         : '||pi_rec_natmp.nat_column_60,p_level);
   nm_debug.debug('nat_column_61         : '||pi_rec_natmp.nat_column_61,p_level);
   nm_debug.debug('nat_column_62         : '||pi_rec_natmp.nat_column_62,p_level);
   nm_debug.debug('nat_column_63         : '||pi_rec_natmp.nat_column_63,p_level);
   nm_debug.debug('nat_column_64         : '||pi_rec_natmp.nat_column_64,p_level);
   nm_debug.debug('nat_column_65         : '||pi_rec_natmp.nat_column_65,p_level);
   nm_debug.debug('nat_column_66         : '||pi_rec_natmp.nat_column_66,p_level);
   nm_debug.debug('nat_column_67         : '||pi_rec_natmp.nat_column_67,p_level);
   nm_debug.debug('nat_column_68         : '||pi_rec_natmp.nat_column_68,p_level);
   nm_debug.debug('nat_column_69         : '||pi_rec_natmp.nat_column_69,p_level);
   nm_debug.debug('nat_column_70         : '||pi_rec_natmp.nat_column_70,p_level);
   nm_debug.debug('nat_column_71         : '||pi_rec_natmp.nat_column_71,p_level);
   nm_debug.debug('nat_column_72         : '||pi_rec_natmp.nat_column_72,p_level);
   nm_debug.debug('nat_column_73         : '||pi_rec_natmp.nat_column_73,p_level);
   nm_debug.debug('nat_column_74         : '||pi_rec_natmp.nat_column_74,p_level);
   nm_debug.debug('nat_column_75         : '||pi_rec_natmp.nat_column_75,p_level);
   nm_debug.debug('nat_column_76         : '||pi_rec_natmp.nat_column_76,p_level);
   nm_debug.debug('nat_column_77         : '||pi_rec_natmp.nat_column_77,p_level);
   nm_debug.debug('nat_column_78         : '||pi_rec_natmp.nat_column_78,p_level);
   nm_debug.debug('nat_column_79         : '||pi_rec_natmp.nat_column_79,p_level);
   nm_debug.debug('nat_column_80         : '||pi_rec_natmp.nat_column_80,p_level);
   nm_debug.debug('nat_column_81         : '||pi_rec_natmp.nat_column_81,p_level);
   nm_debug.debug('nat_column_82         : '||pi_rec_natmp.nat_column_82,p_level);
   nm_debug.debug('nat_column_83         : '||pi_rec_natmp.nat_column_83,p_level);
   nm_debug.debug('nat_column_84         : '||pi_rec_natmp.nat_column_84,p_level);
   nm_debug.debug('nat_column_85         : '||pi_rec_natmp.nat_column_85,p_level);
   nm_debug.debug('nat_column_86         : '||pi_rec_natmp.nat_column_86,p_level);
   nm_debug.debug('nat_column_87         : '||pi_rec_natmp.nat_column_87,p_level);
   nm_debug.debug('nat_column_88         : '||pi_rec_natmp.nat_column_88,p_level);
   nm_debug.debug('nat_column_89         : '||pi_rec_natmp.nat_column_89,p_level);
   nm_debug.debug('nat_column_90         : '||pi_rec_natmp.nat_column_90,p_level);
   nm_debug.debug('nat_column_91         : '||pi_rec_natmp.nat_column_91,p_level);
   nm_debug.debug('nat_column_92         : '||pi_rec_natmp.nat_column_92,p_level);
   nm_debug.debug('nat_column_93         : '||pi_rec_natmp.nat_column_93,p_level);
   nm_debug.debug('nat_column_94         : '||pi_rec_natmp.nat_column_94,p_level);
   nm_debug.debug('nat_column_95         : '||pi_rec_natmp.nat_column_95,p_level);
   nm_debug.debug('nat_column_96         : '||pi_rec_natmp.nat_column_96,p_level);
   nm_debug.debug('nat_column_97         : '||pi_rec_natmp.nat_column_97,p_level);
   nm_debug.debug('nat_column_98         : '||pi_rec_natmp.nat_column_98,p_level);
   nm_debug.debug('nat_column_99         : '||pi_rec_natmp.nat_column_99,p_level);
   nm_debug.debug('nat_column_100        : '||pi_rec_natmp.nat_column_100,p_level);
   nm_debug.debug('nat_column_101        : '||pi_rec_natmp.nat_column_101,p_level);
   nm_debug.debug('nat_column_102        : '||pi_rec_natmp.nat_column_102,p_level);
   nm_debug.debug('nat_column_103        : '||pi_rec_natmp.nat_column_103,p_level);
   nm_debug.debug('nat_column_104        : '||pi_rec_natmp.nat_column_104,p_level);
   nm_debug.debug('nat_column_105        : '||pi_rec_natmp.nat_column_105,p_level);
   nm_debug.debug('nat_column_106        : '||pi_rec_natmp.nat_column_106,p_level);
   nm_debug.debug('nat_column_107        : '||pi_rec_natmp.nat_column_107,p_level);
   nm_debug.debug('nat_column_108        : '||pi_rec_natmp.nat_column_108,p_level);
   nm_debug.debug('nat_column_109        : '||pi_rec_natmp.nat_column_109,p_level);
   nm_debug.debug('nat_column_110        : '||pi_rec_natmp.nat_column_110,p_level);
   nm_debug.debug('nat_column_111        : '||pi_rec_natmp.nat_column_111,p_level);
   nm_debug.debug('nat_column_112        : '||pi_rec_natmp.nat_column_112,p_level);
   nm_debug.debug('nat_column_113        : '||pi_rec_natmp.nat_column_113,p_level);
   nm_debug.debug('nat_column_114        : '||pi_rec_natmp.nat_column_114,p_level);
   nm_debug.debug('nat_column_115        : '||pi_rec_natmp.nat_column_115,p_level);
   nm_debug.debug('nat_column_116        : '||pi_rec_natmp.nat_column_116,p_level);
   nm_debug.debug('nat_column_117        : '||pi_rec_natmp.nat_column_117,p_level);
   nm_debug.debug('nat_column_118        : '||pi_rec_natmp.nat_column_118,p_level);
   nm_debug.debug('nat_column_119        : '||pi_rec_natmp.nat_column_119,p_level);
   nm_debug.debug('nat_column_120        : '||pi_rec_natmp.nat_column_120,p_level);
   nm_debug.debug('nat_column_121        : '||pi_rec_natmp.nat_column_121,p_level);
   nm_debug.debug('nat_column_122        : '||pi_rec_natmp.nat_column_122,p_level);
   nm_debug.debug('nat_column_123        : '||pi_rec_natmp.nat_column_123,p_level);
   nm_debug.debug('nat_column_124        : '||pi_rec_natmp.nat_column_124,p_level);
   nm_debug.debug('nat_column_125        : '||pi_rec_natmp.nat_column_125,p_level);
   nm_debug.debug('nat_column_126        : '||pi_rec_natmp.nat_column_126,p_level);
   nm_debug.debug('nat_column_127        : '||pi_rec_natmp.nat_column_127,p_level);
   nm_debug.debug('nat_column_128        : '||pi_rec_natmp.nat_column_128,p_level);
   nm_debug.debug('nat_column_129        : '||pi_rec_natmp.nat_column_129,p_level);
   nm_debug.debug('nat_column_130        : '||pi_rec_natmp.nat_column_130,p_level);
   nm_debug.debug('nat_column_131        : '||pi_rec_natmp.nat_column_131,p_level);
   nm_debug.debug('nat_column_132        : '||pi_rec_natmp.nat_column_132,p_level);
   nm_debug.debug('nat_column_133        : '||pi_rec_natmp.nat_column_133,p_level);
   nm_debug.debug('nat_column_134        : '||pi_rec_natmp.nat_column_134,p_level);
   nm_debug.debug('nat_column_135        : '||pi_rec_natmp.nat_column_135,p_level);
   nm_debug.debug('nat_column_136        : '||pi_rec_natmp.nat_column_136,p_level);
   nm_debug.debug('nat_column_137        : '||pi_rec_natmp.nat_column_137,p_level);
   nm_debug.debug('nat_column_138        : '||pi_rec_natmp.nat_column_138,p_level);
   nm_debug.debug('nat_column_139        : '||pi_rec_natmp.nat_column_139,p_level);
   nm_debug.debug('nat_column_140        : '||pi_rec_natmp.nat_column_140,p_level);
   nm_debug.debug('nat_column_141        : '||pi_rec_natmp.nat_column_141,p_level);
   nm_debug.debug('nat_column_142        : '||pi_rec_natmp.nat_column_142,p_level);
   nm_debug.debug('nat_column_143        : '||pi_rec_natmp.nat_column_143,p_level);
   nm_debug.debug('nat_column_144        : '||pi_rec_natmp.nat_column_144,p_level);
   nm_debug.debug('nat_column_145        : '||pi_rec_natmp.nat_column_145,p_level);
   nm_debug.debug('nat_column_146        : '||pi_rec_natmp.nat_column_146,p_level);
   nm_debug.debug('nat_column_147        : '||pi_rec_natmp.nat_column_147,p_level);
   nm_debug.debug('nat_column_148        : '||pi_rec_natmp.nat_column_148,p_level);
   nm_debug.debug('nat_column_149        : '||pi_rec_natmp.nat_column_149,p_level);
   nm_debug.debug('nat_column_150        : '||pi_rec_natmp.nat_column_150,p_level);
   nm_debug.debug('nat_column_151        : '||pi_rec_natmp.nat_column_151,p_level);
   nm_debug.debug('nat_column_152        : '||pi_rec_natmp.nat_column_152,p_level);
   nm_debug.debug('nat_column_153        : '||pi_rec_natmp.nat_column_153,p_level);
   nm_debug.debug('nat_column_154        : '||pi_rec_natmp.nat_column_154,p_level);
   nm_debug.debug('nat_column_155        : '||pi_rec_natmp.nat_column_155,p_level);
   nm_debug.debug('nat_column_156        : '||pi_rec_natmp.nat_column_156,p_level);
   nm_debug.debug('nat_column_157        : '||pi_rec_natmp.nat_column_157,p_level);
   nm_debug.debug('nat_column_158        : '||pi_rec_natmp.nat_column_158,p_level);
   nm_debug.debug('nat_column_159        : '||pi_rec_natmp.nat_column_159,p_level);
   nm_debug.debug('nat_column_160        : '||pi_rec_natmp.nat_column_160,p_level);
   nm_debug.debug('nat_column_161        : '||pi_rec_natmp.nat_column_161,p_level);
   nm_debug.debug('nat_column_162        : '||pi_rec_natmp.nat_column_162,p_level);
   nm_debug.debug('nat_column_163        : '||pi_rec_natmp.nat_column_163,p_level);
   nm_debug.debug('nat_column_164        : '||pi_rec_natmp.nat_column_164,p_level);
   nm_debug.debug('nat_column_165        : '||pi_rec_natmp.nat_column_165,p_level);
   nm_debug.debug('nat_column_166        : '||pi_rec_natmp.nat_column_166,p_level);
   nm_debug.debug('nat_column_167        : '||pi_rec_natmp.nat_column_167,p_level);
   nm_debug.debug('nat_column_168        : '||pi_rec_natmp.nat_column_168,p_level);
   nm_debug.debug('nat_column_169        : '||pi_rec_natmp.nat_column_169,p_level);
   nm_debug.debug('nat_column_170        : '||pi_rec_natmp.nat_column_170,p_level);
   nm_debug.debug('nat_column_171        : '||pi_rec_natmp.nat_column_171,p_level);
   nm_debug.debug('nat_column_172        : '||pi_rec_natmp.nat_column_172,p_level);
   nm_debug.debug('nat_column_173        : '||pi_rec_natmp.nat_column_173,p_level);
   nm_debug.debug('nat_column_174        : '||pi_rec_natmp.nat_column_174,p_level);
   nm_debug.debug('nat_column_175        : '||pi_rec_natmp.nat_column_175,p_level);
   nm_debug.debug('nat_column_176        : '||pi_rec_natmp.nat_column_176,p_level);
   nm_debug.debug('nat_column_177        : '||pi_rec_natmp.nat_column_177,p_level);
   nm_debug.debug('nat_column_178        : '||pi_rec_natmp.nat_column_178,p_level);
   nm_debug.debug('nat_column_179        : '||pi_rec_natmp.nat_column_179,p_level);
   nm_debug.debug('nat_column_180        : '||pi_rec_natmp.nat_column_180,p_level);
   nm_debug.debug('nat_column_181        : '||pi_rec_natmp.nat_column_181,p_level);
   nm_debug.debug('nat_column_182        : '||pi_rec_natmp.nat_column_182,p_level);
   nm_debug.debug('nat_column_183        : '||pi_rec_natmp.nat_column_183,p_level);
   nm_debug.debug('nat_column_184        : '||pi_rec_natmp.nat_column_184,p_level);
   nm_debug.debug('nat_column_185        : '||pi_rec_natmp.nat_column_185,p_level);
   nm_debug.debug('nat_column_186        : '||pi_rec_natmp.nat_column_186,p_level);
   nm_debug.debug('nat_column_187        : '||pi_rec_natmp.nat_column_187,p_level);
   nm_debug.debug('nat_column_188        : '||pi_rec_natmp.nat_column_188,p_level);
   nm_debug.debug('nat_column_189        : '||pi_rec_natmp.nat_column_189,p_level);
   nm_debug.debug('nat_column_190        : '||pi_rec_natmp.nat_column_190,p_level);
   nm_debug.debug('nat_column_191        : '||pi_rec_natmp.nat_column_191,p_level);
   nm_debug.debug('nat_column_192        : '||pi_rec_natmp.nat_column_192,p_level);
   nm_debug.debug('nat_column_193        : '||pi_rec_natmp.nat_column_193,p_level);
   nm_debug.debug('nat_column_194        : '||pi_rec_natmp.nat_column_194,p_level);
   nm_debug.debug('nat_column_195        : '||pi_rec_natmp.nat_column_195,p_level);
   nm_debug.debug('nat_column_196        : '||pi_rec_natmp.nat_column_196,p_level);
   nm_debug.debug('nat_column_197        : '||pi_rec_natmp.nat_column_197,p_level);
   nm_debug.debug('nat_column_198        : '||pi_rec_natmp.nat_column_198,p_level);
   nm_debug.debug('nat_column_199        : '||pi_rec_natmp.nat_column_199,p_level);
   nm_debug.debug('nat_column_200        : '||pi_rec_natmp.nat_column_200,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_natmp');
--
END debug_natmp;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nat (pi_rec_nat nm_au_types%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nat');
--
   nm_debug.debug('nat_admin_type    : '||pi_rec_nat.nat_admin_type,p_level);
   nm_debug.debug('nat_descr         : '||pi_rec_nat.nat_descr,p_level);
   nm_debug.debug('nat_date_created  : '||pi_rec_nat.nat_date_created,p_level);
   nm_debug.debug('nat_date_modified : '||pi_rec_nat.nat_date_modified,p_level);
   nm_debug.debug('nat_modified_by   : '||pi_rec_nat.nat_modified_by,p_level);
   nm_debug.debug('nat_created_by    : '||pi_rec_nat.nat_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nat');
--
END debug_nat;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nsty (pi_rec_nsty nm_au_sub_types%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nsty');
--
   nm_debug.debug('nsty_id              : '||pi_rec_nsty.nsty_id,p_level);
   nm_debug.debug('nsty_nat_admin_type  : '||pi_rec_nsty.nsty_nat_admin_type,p_level);
   nm_debug.debug('nsty_sub_type        : '||pi_rec_nsty.nsty_sub_type,p_level);
   nm_debug.debug('nsty_descr           : '||pi_rec_nsty.nsty_descr,p_level);
   nm_debug.debug('nsty_parent_sub_type : '||pi_rec_nsty.nsty_parent_sub_type,p_level);
   nm_debug.debug('nsty_ngt_group_type  : '||pi_rec_nsty.nsty_ngt_group_type,p_level);
   nm_debug.debug('nsty_date_created    : '||pi_rec_nsty.nsty_date_created,p_level);
   nm_debug.debug('nsty_date_modified   : '||pi_rec_nsty.nsty_date_modified,p_level);
   nm_debug.debug('nsty_modified_by     : '||pi_rec_nsty.nsty_modified_by,p_level);
   nm_debug.debug('nsty_created_by      : '||pi_rec_nsty.nsty_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nsty');
--
END debug_nsty;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_natg (pi_rec_natg nm_au_types_groupings%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_natg');
--
   nm_debug.debug('natg_grouping       : '||pi_rec_natg.natg_grouping,p_level);
   nm_debug.debug('natg_nat_admin_type : '||pi_rec_natg.natg_nat_admin_type,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_natg');
--
END debug_natg;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nd (pi_rec_nd nm_dbug%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nd');
--
   nm_debug.debug('nd_id         : '||pi_rec_nd.nd_id,p_level);
   nm_debug.debug('nd_timestamp  : '||pi_rec_nd.nd_timestamp,p_level);
   nm_debug.debug('nd_terminal   : '||pi_rec_nd.nd_terminal,p_level);
   nm_debug.debug('nd_session_id : '||pi_rec_nd.nd_session_id,p_level);
   nm_debug.debug('nd_level      : '||pi_rec_nd.nd_level,p_level);
   nm_debug.debug('nd_text       : '||pi_rec_nd.nd_text,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nd');
--
END debug_nd;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ne (pi_rec_ne nm_elements%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ne');
--
   nm_debug.debug('ne_id             : '||pi_rec_ne.ne_id,p_level);
   nm_debug.debug('ne_unique         : '||pi_rec_ne.ne_unique,p_level);
   nm_debug.debug('ne_type           : '||pi_rec_ne.ne_type,p_level);
   nm_debug.debug('ne_nt_type        : '||pi_rec_ne.ne_nt_type,p_level);
   nm_debug.debug('ne_descr          : '||pi_rec_ne.ne_descr,p_level);
   nm_debug.debug('ne_length         : '||pi_rec_ne.ne_length,p_level);
   nm_debug.debug('ne_admin_unit     : '||pi_rec_ne.ne_admin_unit,p_level);
   nm_debug.debug('ne_date_created   : '||pi_rec_ne.ne_date_created,p_level);
   nm_debug.debug('ne_date_modified  : '||pi_rec_ne.ne_date_modified,p_level);
   nm_debug.debug('ne_modified_by    : '||pi_rec_ne.ne_modified_by,p_level);
   nm_debug.debug('ne_created_by     : '||pi_rec_ne.ne_created_by,p_level);
   nm_debug.debug('ne_start_date     : '||pi_rec_ne.ne_start_date,p_level);
   nm_debug.debug('ne_end_date       : '||pi_rec_ne.ne_end_date,p_level);
   nm_debug.debug('ne_gty_group_type : '||pi_rec_ne.ne_gty_group_type,p_level);
   nm_debug.debug('ne_owner          : '||pi_rec_ne.ne_owner,p_level);
   nm_debug.debug('ne_name_1         : '||pi_rec_ne.ne_name_1,p_level);
   nm_debug.debug('ne_name_2         : '||pi_rec_ne.ne_name_2,p_level);
   nm_debug.debug('ne_prefix         : '||pi_rec_ne.ne_prefix,p_level);
   nm_debug.debug('ne_number         : '||pi_rec_ne.ne_number,p_level);
   nm_debug.debug('ne_sub_type       : '||pi_rec_ne.ne_sub_type,p_level);
   nm_debug.debug('ne_group          : '||pi_rec_ne.ne_group,p_level);
   nm_debug.debug('ne_no_start       : '||pi_rec_ne.ne_no_start,p_level);
   nm_debug.debug('ne_no_end         : '||pi_rec_ne.ne_no_end,p_level);
   nm_debug.debug('ne_sub_class      : '||pi_rec_ne.ne_sub_class,p_level);
   nm_debug.debug('ne_nsg_ref        : '||pi_rec_ne.ne_nsg_ref,p_level);
   nm_debug.debug('ne_version_no     : '||pi_rec_ne.ne_version_no,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ne');
--
END debug_ne;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ne_all (pi_rec_ne_all nm_elements_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ne_all');
--
   nm_debug.debug('ne_id             : '||pi_rec_ne_all.ne_id,p_level);
   nm_debug.debug('ne_unique         : '||pi_rec_ne_all.ne_unique,p_level);
   nm_debug.debug('ne_type           : '||pi_rec_ne_all.ne_type,p_level);
   nm_debug.debug('ne_nt_type        : '||pi_rec_ne_all.ne_nt_type,p_level);
   nm_debug.debug('ne_descr          : '||pi_rec_ne_all.ne_descr,p_level);
   nm_debug.debug('ne_length         : '||pi_rec_ne_all.ne_length,p_level);
   nm_debug.debug('ne_admin_unit     : '||pi_rec_ne_all.ne_admin_unit,p_level);
   nm_debug.debug('ne_date_created   : '||pi_rec_ne_all.ne_date_created,p_level);
   nm_debug.debug('ne_date_modified  : '||pi_rec_ne_all.ne_date_modified,p_level);
   nm_debug.debug('ne_modified_by    : '||pi_rec_ne_all.ne_modified_by,p_level);
   nm_debug.debug('ne_created_by     : '||pi_rec_ne_all.ne_created_by,p_level);
   nm_debug.debug('ne_start_date     : '||pi_rec_ne_all.ne_start_date,p_level);
   nm_debug.debug('ne_end_date       : '||pi_rec_ne_all.ne_end_date,p_level);
   nm_debug.debug('ne_gty_group_type : '||pi_rec_ne_all.ne_gty_group_type,p_level);
   nm_debug.debug('ne_owner          : '||pi_rec_ne_all.ne_owner,p_level);
   nm_debug.debug('ne_name_1         : '||pi_rec_ne_all.ne_name_1,p_level);
   nm_debug.debug('ne_name_2         : '||pi_rec_ne_all.ne_name_2,p_level);
   nm_debug.debug('ne_prefix         : '||pi_rec_ne_all.ne_prefix,p_level);
   nm_debug.debug('ne_number         : '||pi_rec_ne_all.ne_number,p_level);
   nm_debug.debug('ne_sub_type       : '||pi_rec_ne_all.ne_sub_type,p_level);
   nm_debug.debug('ne_group          : '||pi_rec_ne_all.ne_group,p_level);
   nm_debug.debug('ne_no_start       : '||pi_rec_ne_all.ne_no_start,p_level);
   nm_debug.debug('ne_no_end         : '||pi_rec_ne_all.ne_no_end,p_level);
   nm_debug.debug('ne_sub_class      : '||pi_rec_ne_all.ne_sub_class,p_level);
   nm_debug.debug('ne_nsg_ref        : '||pi_rec_ne_all.ne_nsg_ref,p_level);
   nm_debug.debug('ne_version_no     : '||pi_rec_ne_all.ne_version_no,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ne_all');
--
END debug_ne_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_neh (pi_rec_neh nm_element_history%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_neh');
--
   nm_debug.debug('neh_id             : '||pi_rec_neh.neh_id,p_level);
   nm_debug.debug('neh_ne_id_old      : '||pi_rec_neh.neh_ne_id_old,p_level);
   nm_debug.debug('neh_ne_id_new      : '||pi_rec_neh.neh_ne_id_new,p_level);
   nm_debug.debug('neh_operation      : '||pi_rec_neh.neh_operation,p_level);
   nm_debug.debug('neh_effective_date : '||pi_rec_neh.neh_effective_date,p_level);
   nm_debug.debug('neh_actioned_date  : '||pi_rec_neh.neh_actioned_date,p_level);
   nm_debug.debug('neh_actioned_by    : '||pi_rec_neh.neh_actioned_by,p_level);
   nm_debug.debug('neh_old_ne_length  : '||pi_rec_neh.neh_old_ne_length,p_level);
   nm_debug.debug('neh_new_ne_length  : '||pi_rec_neh.neh_new_ne_length,p_level);
   nm_debug.debug('neh_param_1        : '||pi_rec_neh.neh_param_1,p_level);
   nm_debug.debug('neh_param_2        : '||pi_rec_neh.neh_param_2,p_level);
   nm_debug.debug('neh_descr          : '||pi_rec_neh.neh_descr,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_neh');
--
END debug_neh;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ner (pi_rec_ner nm_errors%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ner');
--
   nm_debug.debug('ner_appl   : '||pi_rec_ner.ner_appl,p_level);
   nm_debug.debug('ner_id     : '||pi_rec_ner.ner_id,p_level);
   nm_debug.debug('ner_her_no : '||pi_rec_ner.ner_her_no,p_level);
   nm_debug.debug('ner_descr  : '||pi_rec_ner.ner_descr,p_level);
   nm_debug.debug('ner_cause  : '||pi_rec_ner.ner_cause,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ner');
--
END debug_ner;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nea (pi_rec_nea nm_event_alert_mails%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nea');
--
   nm_debug.debug('nea_recipient      : '||pi_rec_nea.nea_recipient,p_level);
   nm_debug.debug('nea_recipient_type : '||pi_rec_nea.nea_recipient_type,p_level);
   nm_debug.debug('nea_send_type      : '||pi_rec_nea.nea_send_type,p_level);
   nm_debug.debug('nea_net_type       : '||pi_rec_nea.nea_net_type,p_level);
   nm_debug.debug('nea_severity       : '||pi_rec_nea.nea_severity,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nea');
--
END debug_nea;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nel (pi_rec_nel nm_event_log%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nel');
--
   nm_debug.debug('nel_id        : '||pi_rec_nel.nel_id,p_level);
   nm_debug.debug('nel_net_type  : '||pi_rec_nel.nel_net_type,p_level);
   nm_debug.debug('nel_timestamp : '||pi_rec_nel.nel_timestamp,p_level);
   nm_debug.debug('nel_terminal  : '||pi_rec_nel.nel_terminal,p_level);
   nm_debug.debug('nel_session   : '||pi_rec_nel.nel_session,p_level);
   nm_debug.debug('nel_source    : '||pi_rec_nel.nel_source,p_level);
   nm_debug.debug('nel_event     : '||pi_rec_nel.nel_event,p_level);
   nm_debug.debug('nel_severity  : '||pi_rec_nel.nel_severity,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nel');
--
END debug_nel;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_net (pi_rec_net nm_event_types%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_net');
--
   nm_debug.debug('net_type   : '||pi_rec_net.net_type,p_level);
   nm_debug.debug('net_unique : '||pi_rec_net.net_unique,p_level);
   nm_debug.debug('net_descr  : '||pi_rec_net.net_descr,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_net');
--
END debug_net;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nfp (pi_rec_nfp nm_fill_patterns%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nfp');
--
   nm_debug.debug('nfp_id    : '||pi_rec_nfp.nfp_id,p_level);
   nm_debug.debug('nfp_descr : '||pi_rec_nfp.nfp_descr,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nfp');
--
END debug_nfp;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ngq (pi_rec_ngq nm_gaz_query%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ngq');
--
   nm_debug.debug('ngq_id                 : '||pi_rec_ngq.ngq_id,p_level);
   nm_debug.debug('ngq_source_id          : '||pi_rec_ngq.ngq_source_id,p_level);
   nm_debug.debug('ngq_source             : '||pi_rec_ngq.ngq_source,p_level);
   nm_debug.debug('ngq_open_or_closed     : '||pi_rec_ngq.ngq_open_or_closed,p_level);
   nm_debug.debug('ngq_items_or_area      : '||pi_rec_ngq.ngq_items_or_area,p_level);
   nm_debug.debug('ngq_query_all_items    : '||pi_rec_ngq.ngq_query_all_items,p_level);
   nm_debug.debug('ngq_begin_mp           : '||pi_rec_ngq.ngq_begin_mp,p_level);
   nm_debug.debug('ngq_begin_datum_ne_id  : '||pi_rec_ngq.ngq_begin_datum_ne_id,p_level);
   nm_debug.debug('ngq_begin_datum_offset : '||pi_rec_ngq.ngq_begin_datum_offset,p_level);
   nm_debug.debug('ngq_end_mp             : '||pi_rec_ngq.ngq_end_mp,p_level);
   nm_debug.debug('ngq_end_datum_ne_id    : '||pi_rec_ngq.ngq_end_datum_ne_id,p_level);
   nm_debug.debug('ngq_end_datum_offset   : '||pi_rec_ngq.ngq_end_datum_offset,p_level);
   nm_debug.debug('ngq_ambig_sub_class    : '||pi_rec_ngq.ngq_ambig_sub_class,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ngq');
--
END debug_ngq;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ngqt (pi_rec_ngqt nm_gaz_query_types%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ngqt');
--
   nm_debug.debug('ngqt_ngq_id         : '||pi_rec_ngqt.ngqt_ngq_id,p_level);
   nm_debug.debug('ngqt_seq_no         : '||pi_rec_ngqt.ngqt_seq_no,p_level);
   nm_debug.debug('ngqt_item_type_type : '||pi_rec_ngqt.ngqt_item_type_type,p_level);
   nm_debug.debug('ngqt_item_type      : '||pi_rec_ngqt.ngqt_item_type,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ngqt');
--
END debug_ngqt;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ngqa (pi_rec_ngqa nm_gaz_query_attribs%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ngqa');
--
   nm_debug.debug('ngqa_ngq_id       : '||pi_rec_ngqa.ngqa_ngq_id,p_level);
   nm_debug.debug('ngqa_ngqt_seq_no  : '||pi_rec_ngqa.ngqa_ngqt_seq_no,p_level);
   nm_debug.debug('ngqa_seq_no       : '||pi_rec_ngqa.ngqa_seq_no,p_level);
   nm_debug.debug('ngqa_attrib_name  : '||pi_rec_ngqa.ngqa_attrib_name,p_level);
   nm_debug.debug('ngqa_operator     : '||pi_rec_ngqa.ngqa_operator,p_level);
   nm_debug.debug('ngqa_pre_bracket  : '||pi_rec_ngqa.ngqa_pre_bracket,p_level);
   nm_debug.debug('ngqa_post_bracket : '||pi_rec_ngqa.ngqa_post_bracket,p_level);
   nm_debug.debug('ngqa_condition    : '||pi_rec_ngqa.ngqa_condition,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ngqa');
--
END debug_ngqa;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ngqv (pi_rec_ngqv nm_gaz_query_values%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ngqv');
--
   nm_debug.debug('ngqv_ngq_id      : '||pi_rec_ngqv.ngqv_ngq_id,p_level);
   nm_debug.debug('ngqv_ngqt_seq_no : '||pi_rec_ngqv.ngqv_ngqt_seq_no,p_level);
   nm_debug.debug('ngqv_ngqa_seq_no : '||pi_rec_ngqv.ngqv_ngqa_seq_no,p_level);
   nm_debug.debug('ngqv_sequence    : '||pi_rec_ngqv.ngqv_sequence,p_level);
   nm_debug.debug('ngqv_value       : '||pi_rec_ngqv.ngqv_value,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ngqv');
--
END debug_ngqv;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ngit (pi_rec_ngit nm_group_inv_types%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ngit');
--
   nm_debug.debug('ngit_ngt_group_type : '||pi_rec_ngit.ngit_ngt_group_type,p_level);
   nm_debug.debug('ngit_nit_inv_type   : '||pi_rec_ngit.ngit_nit_inv_type,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ngit');
--
END debug_ngit;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ngil (pi_rec_ngil nm_group_inv_link%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ngil');
--
   nm_debug.debug('ngil_ne_ne_id   : '||pi_rec_ngil.ngil_ne_ne_id,p_level);
   nm_debug.debug('ngil_iit_ne_id  : '||pi_rec_ngil.ngil_iit_ne_id,p_level);
   nm_debug.debug('ngil_start_date : '||pi_rec_ngil.ngil_start_date,p_level);
   nm_debug.debug('ngil_end_date   : '||pi_rec_ngil.ngil_end_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ngil');
--
END debug_ngil;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ngil_all (pi_rec_ngil_all nm_group_inv_link_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ngil_all');
--
   nm_debug.debug('ngil_ne_ne_id   : '||pi_rec_ngil_all.ngil_ne_ne_id,p_level);
   nm_debug.debug('ngil_iit_ne_id  : '||pi_rec_ngil_all.ngil_iit_ne_id,p_level);
   nm_debug.debug('ngil_start_date : '||pi_rec_ngil_all.ngil_start_date,p_level);
   nm_debug.debug('ngil_end_date   : '||pi_rec_ngil_all.ngil_end_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ngil_all');
--
END debug_ngil_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ngr (pi_rec_ngr nm_group_relations%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ngr');
--
   nm_debug.debug('ngr_parent_group_type : '||pi_rec_ngr.ngr_parent_group_type,p_level);
   nm_debug.debug('ngr_child_group_type  : '||pi_rec_ngr.ngr_child_group_type,p_level);
   nm_debug.debug('ngr_start_date        : '||pi_rec_ngr.ngr_start_date,p_level);
   nm_debug.debug('ngr_end_date          : '||pi_rec_ngr.ngr_end_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ngr');
--
END debug_ngr;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ngr_all (pi_rec_ngr_all nm_group_relations_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ngr_all');
--
   nm_debug.debug('ngr_parent_group_type : '||pi_rec_ngr_all.ngr_parent_group_type,p_level);
   nm_debug.debug('ngr_child_group_type  : '||pi_rec_ngr_all.ngr_child_group_type,p_level);
   nm_debug.debug('ngr_start_date        : '||pi_rec_ngr_all.ngr_start_date,p_level);
   nm_debug.debug('ngr_end_date          : '||pi_rec_ngr_all.ngr_end_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ngr_all');
--
END debug_ngr_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ngt (pi_rec_ngt nm_group_types%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ngt');
--
   nm_debug.debug('ngt_group_type        : '||pi_rec_ngt.ngt_group_type,p_level);
   nm_debug.debug('ngt_descr             : '||pi_rec_ngt.ngt_descr,p_level);
   nm_debug.debug('ngt_exclusive_flag    : '||pi_rec_ngt.ngt_exclusive_flag,p_level);
   nm_debug.debug('ngt_search_group_no   : '||pi_rec_ngt.ngt_search_group_no,p_level);
   nm_debug.debug('ngt_linear_flag       : '||pi_rec_ngt.ngt_linear_flag,p_level);
   nm_debug.debug('ngt_nt_type           : '||pi_rec_ngt.ngt_nt_type,p_level);
   nm_debug.debug('ngt_partial           : '||pi_rec_ngt.ngt_partial,p_level);
   nm_debug.debug('ngt_start_date        : '||pi_rec_ngt.ngt_start_date,p_level);
   nm_debug.debug('ngt_end_date          : '||pi_rec_ngt.ngt_end_date,p_level);
   nm_debug.debug('ngt_sub_group_allowed : '||pi_rec_ngt.ngt_sub_group_allowed,p_level);
   nm_debug.debug('ngt_mandatory         : '||pi_rec_ngt.ngt_mandatory,p_level);
   nm_debug.debug('ngt_reverse_allowed   : '||pi_rec_ngt.ngt_reverse_allowed,p_level);
   nm_debug.debug('ngt_icon_name         : '||pi_rec_ngt.ngt_icon_name,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ngt');
--
END debug_ngt;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ngt_all (pi_rec_ngt_all nm_group_types_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ngt_all');
--
   nm_debug.debug('ngt_group_type        : '||pi_rec_ngt_all.ngt_group_type,p_level);
   nm_debug.debug('ngt_descr             : '||pi_rec_ngt_all.ngt_descr,p_level);
   nm_debug.debug('ngt_exclusive_flag    : '||pi_rec_ngt_all.ngt_exclusive_flag,p_level);
   nm_debug.debug('ngt_search_group_no   : '||pi_rec_ngt_all.ngt_search_group_no,p_level);
   nm_debug.debug('ngt_linear_flag       : '||pi_rec_ngt_all.ngt_linear_flag,p_level);
   nm_debug.debug('ngt_nt_type           : '||pi_rec_ngt_all.ngt_nt_type,p_level);
   nm_debug.debug('ngt_partial           : '||pi_rec_ngt_all.ngt_partial,p_level);
   nm_debug.debug('ngt_start_date        : '||pi_rec_ngt_all.ngt_start_date,p_level);
   nm_debug.debug('ngt_end_date          : '||pi_rec_ngt_all.ngt_end_date,p_level);
   nm_debug.debug('ngt_sub_group_allowed : '||pi_rec_ngt_all.ngt_sub_group_allowed,p_level);
   nm_debug.debug('ngt_mandatory         : '||pi_rec_ngt_all.ngt_mandatory,p_level);
   nm_debug.debug('ngt_reverse_allowed   : '||pi_rec_ngt_all.ngt_reverse_allowed,p_level);
   nm_debug.debug('ngt_icon_name         : '||pi_rec_ngt_all.ngt_icon_name,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ngt_all');
--
END debug_ngt_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ial (pi_rec_ial nm_inv_attri_lookup%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ial');
--
   nm_debug.debug('ial_domain        : '||pi_rec_ial.ial_domain,p_level);
   nm_debug.debug('ial_value         : '||pi_rec_ial.ial_value,p_level);
   nm_debug.debug('ial_dtp_code      : '||pi_rec_ial.ial_dtp_code,p_level);
   nm_debug.debug('ial_meaning       : '||pi_rec_ial.ial_meaning,p_level);
   nm_debug.debug('ial_start_date    : '||pi_rec_ial.ial_start_date,p_level);
   nm_debug.debug('ial_end_date      : '||pi_rec_ial.ial_end_date,p_level);
   nm_debug.debug('ial_seq           : '||pi_rec_ial.ial_seq,p_level);
   nm_debug.debug('ial_nva_id        : '||pi_rec_ial.ial_nva_id,p_level);
   nm_debug.debug('ial_date_created  : '||pi_rec_ial.ial_date_created,p_level);
   nm_debug.debug('ial_date_modified : '||pi_rec_ial.ial_date_modified,p_level);
   nm_debug.debug('ial_modified_by   : '||pi_rec_ial.ial_modified_by,p_level);
   nm_debug.debug('ial_created_by    : '||pi_rec_ial.ial_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ial');
--
END debug_ial;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ial_all (pi_rec_ial_all nm_inv_attri_lookup_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ial_all');
--
   nm_debug.debug('ial_domain        : '||pi_rec_ial_all.ial_domain,p_level);
   nm_debug.debug('ial_value         : '||pi_rec_ial_all.ial_value,p_level);
   nm_debug.debug('ial_dtp_code      : '||pi_rec_ial_all.ial_dtp_code,p_level);
   nm_debug.debug('ial_meaning       : '||pi_rec_ial_all.ial_meaning,p_level);
   nm_debug.debug('ial_start_date    : '||pi_rec_ial_all.ial_start_date,p_level);
   nm_debug.debug('ial_end_date      : '||pi_rec_ial_all.ial_end_date,p_level);
   nm_debug.debug('ial_seq           : '||pi_rec_ial_all.ial_seq,p_level);
   nm_debug.debug('ial_nva_id        : '||pi_rec_ial_all.ial_nva_id,p_level);
   nm_debug.debug('ial_date_created  : '||pi_rec_ial_all.ial_date_created,p_level);
   nm_debug.debug('ial_date_modified : '||pi_rec_ial_all.ial_date_modified,p_level);
   nm_debug.debug('ial_modified_by   : '||pi_rec_ial_all.ial_modified_by,p_level);
   nm_debug.debug('ial_created_by    : '||pi_rec_ial_all.ial_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ial_all');
--
END debug_ial_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nic (pi_rec_nic nm_inv_categories%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nic');
--
   nm_debug.debug('nic_category : '||pi_rec_nic.nic_category,p_level);
   nm_debug.debug('nic_descr    : '||pi_rec_nic.nic_descr,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nic');
--
END debug_nic;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_icm (pi_rec_icm nm_inv_category_modules%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_icm');
--
   nm_debug.debug('icm_nic_category : '||pi_rec_icm.icm_nic_category,p_level);
   nm_debug.debug('icm_hmo_module   : '||pi_rec_icm.icm_hmo_module,p_level);
   nm_debug.debug('icm_updatable    : '||pi_rec_icm.icm_updatable,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_icm');
--
END debug_icm;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_id (pi_rec_id nm_inv_domains%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_id');
--
   nm_debug.debug('id_domain        : '||pi_rec_id.id_domain,p_level);
   nm_debug.debug('id_title         : '||pi_rec_id.id_title,p_level);
   nm_debug.debug('id_start_date    : '||pi_rec_id.id_start_date,p_level);
   nm_debug.debug('id_end_date      : '||pi_rec_id.id_end_date,p_level);
   nm_debug.debug('id_datatype      : '||pi_rec_id.id_datatype,p_level);
   nm_debug.debug('id_date_created  : '||pi_rec_id.id_date_created,p_level);
   nm_debug.debug('id_date_modified : '||pi_rec_id.id_date_modified,p_level);
   nm_debug.debug('id_modified_by   : '||pi_rec_id.id_modified_by,p_level);
   nm_debug.debug('id_created_by    : '||pi_rec_id.id_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_id');
--
END debug_id;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_id_all (pi_rec_id_all nm_inv_domains_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_id_all');
--
   nm_debug.debug('id_domain        : '||pi_rec_id_all.id_domain,p_level);
   nm_debug.debug('id_title         : '||pi_rec_id_all.id_title,p_level);
   nm_debug.debug('id_start_date    : '||pi_rec_id_all.id_start_date,p_level);
   nm_debug.debug('id_end_date      : '||pi_rec_id_all.id_end_date,p_level);
   nm_debug.debug('id_datatype      : '||pi_rec_id_all.id_datatype,p_level);
   nm_debug.debug('id_date_created  : '||pi_rec_id_all.id_date_created,p_level);
   nm_debug.debug('id_date_modified : '||pi_rec_id_all.id_date_modified,p_level);
   nm_debug.debug('id_modified_by   : '||pi_rec_id_all.id_modified_by,p_level);
   nm_debug.debug('id_created_by    : '||pi_rec_id_all.id_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_id_all');
--
END debug_id_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_iit (pi_rec_iit nm_inv_items%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_iit');
--
   nm_debug.debug('iit_ne_id                 : '||pi_rec_iit.iit_ne_id,p_level);
   nm_debug.debug('iit_inv_type              : '||pi_rec_iit.iit_inv_type,p_level);
   nm_debug.debug('iit_primary_key           : '||pi_rec_iit.iit_primary_key,p_level);
   nm_debug.debug('iit_start_date            : '||pi_rec_iit.iit_start_date,p_level);
   nm_debug.debug('iit_date_created          : '||pi_rec_iit.iit_date_created,p_level);
   nm_debug.debug('iit_date_modified         : '||pi_rec_iit.iit_date_modified,p_level);
   nm_debug.debug('iit_created_by            : '||pi_rec_iit.iit_created_by,p_level);
   nm_debug.debug('iit_modified_by           : '||pi_rec_iit.iit_modified_by,p_level);
   nm_debug.debug('iit_admin_unit            : '||pi_rec_iit.iit_admin_unit,p_level);
   nm_debug.debug('iit_descr                 : '||pi_rec_iit.iit_descr,p_level);
   nm_debug.debug('iit_end_date              : '||pi_rec_iit.iit_end_date,p_level);
   nm_debug.debug('iit_foreign_key           : '||pi_rec_iit.iit_foreign_key,p_level);
   nm_debug.debug('iit_located_by            : '||pi_rec_iit.iit_located_by,p_level);
   nm_debug.debug('iit_position              : '||pi_rec_iit.iit_position,p_level);
   nm_debug.debug('iit_x_coord               : '||pi_rec_iit.iit_x_coord,p_level);
   nm_debug.debug('iit_y_coord               : '||pi_rec_iit.iit_y_coord,p_level);
   nm_debug.debug('iit_num_attrib16          : '||pi_rec_iit.iit_num_attrib16,p_level);
   nm_debug.debug('iit_num_attrib17          : '||pi_rec_iit.iit_num_attrib17,p_level);
   nm_debug.debug('iit_num_attrib18          : '||pi_rec_iit.iit_num_attrib18,p_level);
   nm_debug.debug('iit_num_attrib19          : '||pi_rec_iit.iit_num_attrib19,p_level);
   nm_debug.debug('iit_num_attrib20          : '||pi_rec_iit.iit_num_attrib20,p_level);
   nm_debug.debug('iit_num_attrib21          : '||pi_rec_iit.iit_num_attrib21,p_level);
   nm_debug.debug('iit_num_attrib22          : '||pi_rec_iit.iit_num_attrib22,p_level);
   nm_debug.debug('iit_num_attrib23          : '||pi_rec_iit.iit_num_attrib23,p_level);
   nm_debug.debug('iit_num_attrib24          : '||pi_rec_iit.iit_num_attrib24,p_level);
   nm_debug.debug('iit_num_attrib25          : '||pi_rec_iit.iit_num_attrib25,p_level);
   nm_debug.debug('iit_chr_attrib26          : '||pi_rec_iit.iit_chr_attrib26,p_level);
   nm_debug.debug('iit_chr_attrib27          : '||pi_rec_iit.iit_chr_attrib27,p_level);
   nm_debug.debug('iit_chr_attrib28          : '||pi_rec_iit.iit_chr_attrib28,p_level);
   nm_debug.debug('iit_chr_attrib29          : '||pi_rec_iit.iit_chr_attrib29,p_level);
   nm_debug.debug('iit_chr_attrib30          : '||pi_rec_iit.iit_chr_attrib30,p_level);
   nm_debug.debug('iit_chr_attrib31          : '||pi_rec_iit.iit_chr_attrib31,p_level);
   nm_debug.debug('iit_chr_attrib32          : '||pi_rec_iit.iit_chr_attrib32,p_level);
   nm_debug.debug('iit_chr_attrib33          : '||pi_rec_iit.iit_chr_attrib33,p_level);
   nm_debug.debug('iit_chr_attrib34          : '||pi_rec_iit.iit_chr_attrib34,p_level);
   nm_debug.debug('iit_chr_attrib35          : '||pi_rec_iit.iit_chr_attrib35,p_level);
   nm_debug.debug('iit_chr_attrib36          : '||pi_rec_iit.iit_chr_attrib36,p_level);
   nm_debug.debug('iit_chr_attrib37          : '||pi_rec_iit.iit_chr_attrib37,p_level);
   nm_debug.debug('iit_chr_attrib38          : '||pi_rec_iit.iit_chr_attrib38,p_level);
   nm_debug.debug('iit_chr_attrib39          : '||pi_rec_iit.iit_chr_attrib39,p_level);
   nm_debug.debug('iit_chr_attrib40          : '||pi_rec_iit.iit_chr_attrib40,p_level);
   nm_debug.debug('iit_chr_attrib41          : '||pi_rec_iit.iit_chr_attrib41,p_level);
   nm_debug.debug('iit_chr_attrib42          : '||pi_rec_iit.iit_chr_attrib42,p_level);
   nm_debug.debug('iit_chr_attrib43          : '||pi_rec_iit.iit_chr_attrib43,p_level);
   nm_debug.debug('iit_chr_attrib44          : '||pi_rec_iit.iit_chr_attrib44,p_level);
   nm_debug.debug('iit_chr_attrib45          : '||pi_rec_iit.iit_chr_attrib45,p_level);
   nm_debug.debug('iit_chr_attrib46          : '||pi_rec_iit.iit_chr_attrib46,p_level);
   nm_debug.debug('iit_chr_attrib47          : '||pi_rec_iit.iit_chr_attrib47,p_level);
   nm_debug.debug('iit_chr_attrib48          : '||pi_rec_iit.iit_chr_attrib48,p_level);
   nm_debug.debug('iit_chr_attrib49          : '||pi_rec_iit.iit_chr_attrib49,p_level);
   nm_debug.debug('iit_chr_attrib50          : '||pi_rec_iit.iit_chr_attrib50,p_level);
   nm_debug.debug('iit_chr_attrib51          : '||pi_rec_iit.iit_chr_attrib51,p_level);
   nm_debug.debug('iit_chr_attrib52          : '||pi_rec_iit.iit_chr_attrib52,p_level);
   nm_debug.debug('iit_chr_attrib53          : '||pi_rec_iit.iit_chr_attrib53,p_level);
   nm_debug.debug('iit_chr_attrib54          : '||pi_rec_iit.iit_chr_attrib54,p_level);
   nm_debug.debug('iit_chr_attrib55          : '||pi_rec_iit.iit_chr_attrib55,p_level);
   nm_debug.debug('iit_chr_attrib56          : '||pi_rec_iit.iit_chr_attrib56,p_level);
   nm_debug.debug('iit_chr_attrib57          : '||pi_rec_iit.iit_chr_attrib57,p_level);
   nm_debug.debug('iit_chr_attrib58          : '||pi_rec_iit.iit_chr_attrib58,p_level);
   nm_debug.debug('iit_chr_attrib59          : '||pi_rec_iit.iit_chr_attrib59,p_level);
   nm_debug.debug('iit_chr_attrib60          : '||pi_rec_iit.iit_chr_attrib60,p_level);
   nm_debug.debug('iit_chr_attrib61          : '||pi_rec_iit.iit_chr_attrib61,p_level);
   nm_debug.debug('iit_chr_attrib62          : '||pi_rec_iit.iit_chr_attrib62,p_level);
   nm_debug.debug('iit_chr_attrib63          : '||pi_rec_iit.iit_chr_attrib63,p_level);
   nm_debug.debug('iit_chr_attrib64          : '||pi_rec_iit.iit_chr_attrib64,p_level);
   nm_debug.debug('iit_chr_attrib65          : '||pi_rec_iit.iit_chr_attrib65,p_level);
   nm_debug.debug('iit_chr_attrib66          : '||pi_rec_iit.iit_chr_attrib66,p_level);
   nm_debug.debug('iit_chr_attrib67          : '||pi_rec_iit.iit_chr_attrib67,p_level);
   nm_debug.debug('iit_chr_attrib68          : '||pi_rec_iit.iit_chr_attrib68,p_level);
   nm_debug.debug('iit_chr_attrib69          : '||pi_rec_iit.iit_chr_attrib69,p_level);
   nm_debug.debug('iit_chr_attrib70          : '||pi_rec_iit.iit_chr_attrib70,p_level);
   nm_debug.debug('iit_chr_attrib71          : '||pi_rec_iit.iit_chr_attrib71,p_level);
   nm_debug.debug('iit_chr_attrib72          : '||pi_rec_iit.iit_chr_attrib72,p_level);
   nm_debug.debug('iit_chr_attrib73          : '||pi_rec_iit.iit_chr_attrib73,p_level);
   nm_debug.debug('iit_chr_attrib74          : '||pi_rec_iit.iit_chr_attrib74,p_level);
   nm_debug.debug('iit_chr_attrib75          : '||pi_rec_iit.iit_chr_attrib75,p_level);
   nm_debug.debug('iit_num_attrib76          : '||pi_rec_iit.iit_num_attrib76,p_level);
   nm_debug.debug('iit_num_attrib77          : '||pi_rec_iit.iit_num_attrib77,p_level);
   nm_debug.debug('iit_num_attrib78          : '||pi_rec_iit.iit_num_attrib78,p_level);
   nm_debug.debug('iit_num_attrib79          : '||pi_rec_iit.iit_num_attrib79,p_level);
   nm_debug.debug('iit_num_attrib80          : '||pi_rec_iit.iit_num_attrib80,p_level);
   nm_debug.debug('iit_num_attrib81          : '||pi_rec_iit.iit_num_attrib81,p_level);
   nm_debug.debug('iit_num_attrib82          : '||pi_rec_iit.iit_num_attrib82,p_level);
   nm_debug.debug('iit_num_attrib83          : '||pi_rec_iit.iit_num_attrib83,p_level);
   nm_debug.debug('iit_num_attrib84          : '||pi_rec_iit.iit_num_attrib84,p_level);
   nm_debug.debug('iit_num_attrib85          : '||pi_rec_iit.iit_num_attrib85,p_level);
   nm_debug.debug('iit_date_attrib86         : '||pi_rec_iit.iit_date_attrib86,p_level);
   nm_debug.debug('iit_date_attrib87         : '||pi_rec_iit.iit_date_attrib87,p_level);
   nm_debug.debug('iit_date_attrib88         : '||pi_rec_iit.iit_date_attrib88,p_level);
   nm_debug.debug('iit_date_attrib89         : '||pi_rec_iit.iit_date_attrib89,p_level);
   nm_debug.debug('iit_date_attrib90         : '||pi_rec_iit.iit_date_attrib90,p_level);
   nm_debug.debug('iit_date_attrib91         : '||pi_rec_iit.iit_date_attrib91,p_level);
   nm_debug.debug('iit_date_attrib92         : '||pi_rec_iit.iit_date_attrib92,p_level);
   nm_debug.debug('iit_date_attrib93         : '||pi_rec_iit.iit_date_attrib93,p_level);
   nm_debug.debug('iit_date_attrib94         : '||pi_rec_iit.iit_date_attrib94,p_level);
   nm_debug.debug('iit_date_attrib95         : '||pi_rec_iit.iit_date_attrib95,p_level);
   nm_debug.debug('iit_angle                 : '||pi_rec_iit.iit_angle,p_level);
   nm_debug.debug('iit_angle_txt             : '||pi_rec_iit.iit_angle_txt,p_level);
   nm_debug.debug('iit_class                 : '||pi_rec_iit.iit_class,p_level);
   nm_debug.debug('iit_class_txt             : '||pi_rec_iit.iit_class_txt,p_level);
   nm_debug.debug('iit_colour                : '||pi_rec_iit.iit_colour,p_level);
   nm_debug.debug('iit_colour_txt            : '||pi_rec_iit.iit_colour_txt,p_level);
   nm_debug.debug('iit_coord_flag            : '||pi_rec_iit.iit_coord_flag,p_level);
   nm_debug.debug('iit_description           : '||pi_rec_iit.iit_description,p_level);
   nm_debug.debug('iit_diagram               : '||pi_rec_iit.iit_diagram,p_level);
   nm_debug.debug('iit_distance              : '||pi_rec_iit.iit_distance,p_level);
   nm_debug.debug('iit_end_chain             : '||pi_rec_iit.iit_end_chain,p_level);
   nm_debug.debug('iit_gap                   : '||pi_rec_iit.iit_gap,p_level);
   nm_debug.debug('iit_height                : '||pi_rec_iit.iit_height,p_level);
   nm_debug.debug('iit_height_2              : '||pi_rec_iit.iit_height_2,p_level);
   nm_debug.debug('iit_id_code               : '||pi_rec_iit.iit_id_code,p_level);
   nm_debug.debug('iit_instal_date           : '||pi_rec_iit.iit_instal_date,p_level);
   nm_debug.debug('iit_invent_date           : '||pi_rec_iit.iit_invent_date,p_level);
   nm_debug.debug('iit_inv_ownership         : '||pi_rec_iit.iit_inv_ownership,p_level);
   nm_debug.debug('iit_itemcode              : '||pi_rec_iit.iit_itemcode,p_level);
   nm_debug.debug('iit_lco_lamp_config_id    : '||pi_rec_iit.iit_lco_lamp_config_id,p_level);
   nm_debug.debug('iit_length                : '||pi_rec_iit.iit_length,p_level);
   nm_debug.debug('iit_material              : '||pi_rec_iit.iit_material,p_level);
   nm_debug.debug('iit_material_txt          : '||pi_rec_iit.iit_material_txt,p_level);
   nm_debug.debug('iit_method                : '||pi_rec_iit.iit_method,p_level);
   nm_debug.debug('iit_method_txt            : '||pi_rec_iit.iit_method_txt,p_level);
   nm_debug.debug('iit_note                  : '||pi_rec_iit.iit_note,p_level);
   nm_debug.debug('iit_no_of_units           : '||pi_rec_iit.iit_no_of_units,p_level);
   nm_debug.debug('iit_options               : '||pi_rec_iit.iit_options,p_level);
   nm_debug.debug('iit_options_txt           : '||pi_rec_iit.iit_options_txt,p_level);
   nm_debug.debug('iit_oun_org_id_elec_board : '||pi_rec_iit.iit_oun_org_id_elec_board,p_level);
   nm_debug.debug('iit_owner                 : '||pi_rec_iit.iit_owner,p_level);
   nm_debug.debug('iit_owner_txt             : '||pi_rec_iit.iit_owner_txt,p_level);
   nm_debug.debug('iit_peo_invent_by_id      : '||pi_rec_iit.iit_peo_invent_by_id,p_level);
   nm_debug.debug('iit_photo                 : '||pi_rec_iit.iit_photo,p_level);
   nm_debug.debug('iit_power                 : '||pi_rec_iit.iit_power,p_level);
   nm_debug.debug('iit_prov_flag             : '||pi_rec_iit.iit_prov_flag,p_level);
   nm_debug.debug('iit_rev_by                : '||pi_rec_iit.iit_rev_by,p_level);
   nm_debug.debug('iit_rev_date              : '||pi_rec_iit.iit_rev_date,p_level);
   nm_debug.debug('iit_type                  : '||pi_rec_iit.iit_type,p_level);
   nm_debug.debug('iit_type_txt              : '||pi_rec_iit.iit_type_txt,p_level);
   nm_debug.debug('iit_width                 : '||pi_rec_iit.iit_width,p_level);
   nm_debug.debug('iit_xtra_char_1           : '||pi_rec_iit.iit_xtra_char_1,p_level);
   nm_debug.debug('iit_xtra_date_1           : '||pi_rec_iit.iit_xtra_date_1,p_level);
   nm_debug.debug('iit_xtra_domain_1         : '||pi_rec_iit.iit_xtra_domain_1,p_level);
   nm_debug.debug('iit_xtra_domain_txt_1     : '||pi_rec_iit.iit_xtra_domain_txt_1,p_level);
   nm_debug.debug('iit_xtra_number_1         : '||pi_rec_iit.iit_xtra_number_1,p_level);
   nm_debug.debug('iit_x_sect                : '||pi_rec_iit.iit_x_sect,p_level);
   nm_debug.debug('iit_det_xsp               : '||pi_rec_iit.iit_det_xsp,p_level);
   nm_debug.debug('iit_offset                : '||pi_rec_iit.iit_offset,p_level);
   nm_debug.debug('iit_x                     : '||pi_rec_iit.iit_x,p_level);
   nm_debug.debug('iit_y                     : '||pi_rec_iit.iit_y,p_level);
   nm_debug.debug('iit_z                     : '||pi_rec_iit.iit_z,p_level);
   nm_debug.debug('iit_num_attrib96          : '||pi_rec_iit.iit_num_attrib96,p_level);
   nm_debug.debug('iit_num_attrib97          : '||pi_rec_iit.iit_num_attrib97,p_level);
   nm_debug.debug('iit_num_attrib98          : '||pi_rec_iit.iit_num_attrib98,p_level);
   nm_debug.debug('iit_num_attrib99          : '||pi_rec_iit.iit_num_attrib99,p_level);
   nm_debug.debug('iit_num_attrib100         : '||pi_rec_iit.iit_num_attrib100,p_level);
   nm_debug.debug('iit_num_attrib101         : '||pi_rec_iit.iit_num_attrib101,p_level);
   nm_debug.debug('iit_num_attrib102         : '||pi_rec_iit.iit_num_attrib102,p_level);
   nm_debug.debug('iit_num_attrib103         : '||pi_rec_iit.iit_num_attrib103,p_level);
   nm_debug.debug('iit_num_attrib104         : '||pi_rec_iit.iit_num_attrib104,p_level);
   nm_debug.debug('iit_num_attrib105         : '||pi_rec_iit.iit_num_attrib105,p_level);
   nm_debug.debug('iit_num_attrib106         : '||pi_rec_iit.iit_num_attrib106,p_level);
   nm_debug.debug('iit_num_attrib107         : '||pi_rec_iit.iit_num_attrib107,p_level);
   nm_debug.debug('iit_num_attrib108         : '||pi_rec_iit.iit_num_attrib108,p_level);
   nm_debug.debug('iit_num_attrib109         : '||pi_rec_iit.iit_num_attrib109,p_level);
   nm_debug.debug('iit_num_attrib110         : '||pi_rec_iit.iit_num_attrib110,p_level);
   nm_debug.debug('iit_num_attrib111         : '||pi_rec_iit.iit_num_attrib111,p_level);
   nm_debug.debug('iit_num_attrib112         : '||pi_rec_iit.iit_num_attrib112,p_level);
   nm_debug.debug('iit_num_attrib113         : '||pi_rec_iit.iit_num_attrib113,p_level);
   nm_debug.debug('iit_num_attrib114         : '||pi_rec_iit.iit_num_attrib114,p_level);
   nm_debug.debug('iit_num_attrib115         : '||pi_rec_iit.iit_num_attrib115,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_iit');
--
END debug_iit;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_iit_all (pi_rec_iit_all nm_inv_items_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_iit_all');
--
   nm_debug.debug('iit_ne_id                 : '||pi_rec_iit_all.iit_ne_id,p_level);
   nm_debug.debug('iit_inv_type              : '||pi_rec_iit_all.iit_inv_type,p_level);
   nm_debug.debug('iit_primary_key           : '||pi_rec_iit_all.iit_primary_key,p_level);
   nm_debug.debug('iit_start_date            : '||pi_rec_iit_all.iit_start_date,p_level);
   nm_debug.debug('iit_date_created          : '||pi_rec_iit_all.iit_date_created,p_level);
   nm_debug.debug('iit_date_modified         : '||pi_rec_iit_all.iit_date_modified,p_level);
   nm_debug.debug('iit_created_by            : '||pi_rec_iit_all.iit_created_by,p_level);
   nm_debug.debug('iit_modified_by           : '||pi_rec_iit_all.iit_modified_by,p_level);
   nm_debug.debug('iit_admin_unit            : '||pi_rec_iit_all.iit_admin_unit,p_level);
   nm_debug.debug('iit_descr                 : '||pi_rec_iit_all.iit_descr,p_level);
   nm_debug.debug('iit_end_date              : '||pi_rec_iit_all.iit_end_date,p_level);
   nm_debug.debug('iit_foreign_key           : '||pi_rec_iit_all.iit_foreign_key,p_level);
   nm_debug.debug('iit_located_by            : '||pi_rec_iit_all.iit_located_by,p_level);
   nm_debug.debug('iit_position              : '||pi_rec_iit_all.iit_position,p_level);
   nm_debug.debug('iit_x_coord               : '||pi_rec_iit_all.iit_x_coord,p_level);
   nm_debug.debug('iit_y_coord               : '||pi_rec_iit_all.iit_y_coord,p_level);
   nm_debug.debug('iit_num_attrib16          : '||pi_rec_iit_all.iit_num_attrib16,p_level);
   nm_debug.debug('iit_num_attrib17          : '||pi_rec_iit_all.iit_num_attrib17,p_level);
   nm_debug.debug('iit_num_attrib18          : '||pi_rec_iit_all.iit_num_attrib18,p_level);
   nm_debug.debug('iit_num_attrib19          : '||pi_rec_iit_all.iit_num_attrib19,p_level);
   nm_debug.debug('iit_num_attrib20          : '||pi_rec_iit_all.iit_num_attrib20,p_level);
   nm_debug.debug('iit_num_attrib21          : '||pi_rec_iit_all.iit_num_attrib21,p_level);
   nm_debug.debug('iit_num_attrib22          : '||pi_rec_iit_all.iit_num_attrib22,p_level);
   nm_debug.debug('iit_num_attrib23          : '||pi_rec_iit_all.iit_num_attrib23,p_level);
   nm_debug.debug('iit_num_attrib24          : '||pi_rec_iit_all.iit_num_attrib24,p_level);
   nm_debug.debug('iit_num_attrib25          : '||pi_rec_iit_all.iit_num_attrib25,p_level);
   nm_debug.debug('iit_chr_attrib26          : '||pi_rec_iit_all.iit_chr_attrib26,p_level);
   nm_debug.debug('iit_chr_attrib27          : '||pi_rec_iit_all.iit_chr_attrib27,p_level);
   nm_debug.debug('iit_chr_attrib28          : '||pi_rec_iit_all.iit_chr_attrib28,p_level);
   nm_debug.debug('iit_chr_attrib29          : '||pi_rec_iit_all.iit_chr_attrib29,p_level);
   nm_debug.debug('iit_chr_attrib30          : '||pi_rec_iit_all.iit_chr_attrib30,p_level);
   nm_debug.debug('iit_chr_attrib31          : '||pi_rec_iit_all.iit_chr_attrib31,p_level);
   nm_debug.debug('iit_chr_attrib32          : '||pi_rec_iit_all.iit_chr_attrib32,p_level);
   nm_debug.debug('iit_chr_attrib33          : '||pi_rec_iit_all.iit_chr_attrib33,p_level);
   nm_debug.debug('iit_chr_attrib34          : '||pi_rec_iit_all.iit_chr_attrib34,p_level);
   nm_debug.debug('iit_chr_attrib35          : '||pi_rec_iit_all.iit_chr_attrib35,p_level);
   nm_debug.debug('iit_chr_attrib36          : '||pi_rec_iit_all.iit_chr_attrib36,p_level);
   nm_debug.debug('iit_chr_attrib37          : '||pi_rec_iit_all.iit_chr_attrib37,p_level);
   nm_debug.debug('iit_chr_attrib38          : '||pi_rec_iit_all.iit_chr_attrib38,p_level);
   nm_debug.debug('iit_chr_attrib39          : '||pi_rec_iit_all.iit_chr_attrib39,p_level);
   nm_debug.debug('iit_chr_attrib40          : '||pi_rec_iit_all.iit_chr_attrib40,p_level);
   nm_debug.debug('iit_chr_attrib41          : '||pi_rec_iit_all.iit_chr_attrib41,p_level);
   nm_debug.debug('iit_chr_attrib42          : '||pi_rec_iit_all.iit_chr_attrib42,p_level);
   nm_debug.debug('iit_chr_attrib43          : '||pi_rec_iit_all.iit_chr_attrib43,p_level);
   nm_debug.debug('iit_chr_attrib44          : '||pi_rec_iit_all.iit_chr_attrib44,p_level);
   nm_debug.debug('iit_chr_attrib45          : '||pi_rec_iit_all.iit_chr_attrib45,p_level);
   nm_debug.debug('iit_chr_attrib46          : '||pi_rec_iit_all.iit_chr_attrib46,p_level);
   nm_debug.debug('iit_chr_attrib47          : '||pi_rec_iit_all.iit_chr_attrib47,p_level);
   nm_debug.debug('iit_chr_attrib48          : '||pi_rec_iit_all.iit_chr_attrib48,p_level);
   nm_debug.debug('iit_chr_attrib49          : '||pi_rec_iit_all.iit_chr_attrib49,p_level);
   nm_debug.debug('iit_chr_attrib50          : '||pi_rec_iit_all.iit_chr_attrib50,p_level);
   nm_debug.debug('iit_chr_attrib51          : '||pi_rec_iit_all.iit_chr_attrib51,p_level);
   nm_debug.debug('iit_chr_attrib52          : '||pi_rec_iit_all.iit_chr_attrib52,p_level);
   nm_debug.debug('iit_chr_attrib53          : '||pi_rec_iit_all.iit_chr_attrib53,p_level);
   nm_debug.debug('iit_chr_attrib54          : '||pi_rec_iit_all.iit_chr_attrib54,p_level);
   nm_debug.debug('iit_chr_attrib55          : '||pi_rec_iit_all.iit_chr_attrib55,p_level);
   nm_debug.debug('iit_chr_attrib56          : '||pi_rec_iit_all.iit_chr_attrib56,p_level);
   nm_debug.debug('iit_chr_attrib57          : '||pi_rec_iit_all.iit_chr_attrib57,p_level);
   nm_debug.debug('iit_chr_attrib58          : '||pi_rec_iit_all.iit_chr_attrib58,p_level);
   nm_debug.debug('iit_chr_attrib59          : '||pi_rec_iit_all.iit_chr_attrib59,p_level);
   nm_debug.debug('iit_chr_attrib60          : '||pi_rec_iit_all.iit_chr_attrib60,p_level);
   nm_debug.debug('iit_chr_attrib61          : '||pi_rec_iit_all.iit_chr_attrib61,p_level);
   nm_debug.debug('iit_chr_attrib62          : '||pi_rec_iit_all.iit_chr_attrib62,p_level);
   nm_debug.debug('iit_chr_attrib63          : '||pi_rec_iit_all.iit_chr_attrib63,p_level);
   nm_debug.debug('iit_chr_attrib64          : '||pi_rec_iit_all.iit_chr_attrib64,p_level);
   nm_debug.debug('iit_chr_attrib65          : '||pi_rec_iit_all.iit_chr_attrib65,p_level);
   nm_debug.debug('iit_chr_attrib66          : '||pi_rec_iit_all.iit_chr_attrib66,p_level);
   nm_debug.debug('iit_chr_attrib67          : '||pi_rec_iit_all.iit_chr_attrib67,p_level);
   nm_debug.debug('iit_chr_attrib68          : '||pi_rec_iit_all.iit_chr_attrib68,p_level);
   nm_debug.debug('iit_chr_attrib69          : '||pi_rec_iit_all.iit_chr_attrib69,p_level);
   nm_debug.debug('iit_chr_attrib70          : '||pi_rec_iit_all.iit_chr_attrib70,p_level);
   nm_debug.debug('iit_chr_attrib71          : '||pi_rec_iit_all.iit_chr_attrib71,p_level);
   nm_debug.debug('iit_chr_attrib72          : '||pi_rec_iit_all.iit_chr_attrib72,p_level);
   nm_debug.debug('iit_chr_attrib73          : '||pi_rec_iit_all.iit_chr_attrib73,p_level);
   nm_debug.debug('iit_chr_attrib74          : '||pi_rec_iit_all.iit_chr_attrib74,p_level);
   nm_debug.debug('iit_chr_attrib75          : '||pi_rec_iit_all.iit_chr_attrib75,p_level);
   nm_debug.debug('iit_num_attrib76          : '||pi_rec_iit_all.iit_num_attrib76,p_level);
   nm_debug.debug('iit_num_attrib77          : '||pi_rec_iit_all.iit_num_attrib77,p_level);
   nm_debug.debug('iit_num_attrib78          : '||pi_rec_iit_all.iit_num_attrib78,p_level);
   nm_debug.debug('iit_num_attrib79          : '||pi_rec_iit_all.iit_num_attrib79,p_level);
   nm_debug.debug('iit_num_attrib80          : '||pi_rec_iit_all.iit_num_attrib80,p_level);
   nm_debug.debug('iit_num_attrib81          : '||pi_rec_iit_all.iit_num_attrib81,p_level);
   nm_debug.debug('iit_num_attrib82          : '||pi_rec_iit_all.iit_num_attrib82,p_level);
   nm_debug.debug('iit_num_attrib83          : '||pi_rec_iit_all.iit_num_attrib83,p_level);
   nm_debug.debug('iit_num_attrib84          : '||pi_rec_iit_all.iit_num_attrib84,p_level);
   nm_debug.debug('iit_num_attrib85          : '||pi_rec_iit_all.iit_num_attrib85,p_level);
   nm_debug.debug('iit_date_attrib86         : '||pi_rec_iit_all.iit_date_attrib86,p_level);
   nm_debug.debug('iit_date_attrib87         : '||pi_rec_iit_all.iit_date_attrib87,p_level);
   nm_debug.debug('iit_date_attrib88         : '||pi_rec_iit_all.iit_date_attrib88,p_level);
   nm_debug.debug('iit_date_attrib89         : '||pi_rec_iit_all.iit_date_attrib89,p_level);
   nm_debug.debug('iit_date_attrib90         : '||pi_rec_iit_all.iit_date_attrib90,p_level);
   nm_debug.debug('iit_date_attrib91         : '||pi_rec_iit_all.iit_date_attrib91,p_level);
   nm_debug.debug('iit_date_attrib92         : '||pi_rec_iit_all.iit_date_attrib92,p_level);
   nm_debug.debug('iit_date_attrib93         : '||pi_rec_iit_all.iit_date_attrib93,p_level);
   nm_debug.debug('iit_date_attrib94         : '||pi_rec_iit_all.iit_date_attrib94,p_level);
   nm_debug.debug('iit_date_attrib95         : '||pi_rec_iit_all.iit_date_attrib95,p_level);
   nm_debug.debug('iit_angle                 : '||pi_rec_iit_all.iit_angle,p_level);
   nm_debug.debug('iit_angle_txt             : '||pi_rec_iit_all.iit_angle_txt,p_level);
   nm_debug.debug('iit_class                 : '||pi_rec_iit_all.iit_class,p_level);
   nm_debug.debug('iit_class_txt             : '||pi_rec_iit_all.iit_class_txt,p_level);
   nm_debug.debug('iit_colour                : '||pi_rec_iit_all.iit_colour,p_level);
   nm_debug.debug('iit_colour_txt            : '||pi_rec_iit_all.iit_colour_txt,p_level);
   nm_debug.debug('iit_coord_flag            : '||pi_rec_iit_all.iit_coord_flag,p_level);
   nm_debug.debug('iit_description           : '||pi_rec_iit_all.iit_description,p_level);
   nm_debug.debug('iit_diagram               : '||pi_rec_iit_all.iit_diagram,p_level);
   nm_debug.debug('iit_distance              : '||pi_rec_iit_all.iit_distance,p_level);
   nm_debug.debug('iit_end_chain             : '||pi_rec_iit_all.iit_end_chain,p_level);
   nm_debug.debug('iit_gap                   : '||pi_rec_iit_all.iit_gap,p_level);
   nm_debug.debug('iit_height                : '||pi_rec_iit_all.iit_height,p_level);
   nm_debug.debug('iit_height_2              : '||pi_rec_iit_all.iit_height_2,p_level);
   nm_debug.debug('iit_id_code               : '||pi_rec_iit_all.iit_id_code,p_level);
   nm_debug.debug('iit_instal_date           : '||pi_rec_iit_all.iit_instal_date,p_level);
   nm_debug.debug('iit_invent_date           : '||pi_rec_iit_all.iit_invent_date,p_level);
   nm_debug.debug('iit_inv_ownership         : '||pi_rec_iit_all.iit_inv_ownership,p_level);
   nm_debug.debug('iit_itemcode              : '||pi_rec_iit_all.iit_itemcode,p_level);
   nm_debug.debug('iit_lco_lamp_config_id    : '||pi_rec_iit_all.iit_lco_lamp_config_id,p_level);
   nm_debug.debug('iit_length                : '||pi_rec_iit_all.iit_length,p_level);
   nm_debug.debug('iit_material              : '||pi_rec_iit_all.iit_material,p_level);
   nm_debug.debug('iit_material_txt          : '||pi_rec_iit_all.iit_material_txt,p_level);
   nm_debug.debug('iit_method                : '||pi_rec_iit_all.iit_method,p_level);
   nm_debug.debug('iit_method_txt            : '||pi_rec_iit_all.iit_method_txt,p_level);
   nm_debug.debug('iit_note                  : '||pi_rec_iit_all.iit_note,p_level);
   nm_debug.debug('iit_no_of_units           : '||pi_rec_iit_all.iit_no_of_units,p_level);
   nm_debug.debug('iit_options               : '||pi_rec_iit_all.iit_options,p_level);
   nm_debug.debug('iit_options_txt           : '||pi_rec_iit_all.iit_options_txt,p_level);
   nm_debug.debug('iit_oun_org_id_elec_board : '||pi_rec_iit_all.iit_oun_org_id_elec_board,p_level);
   nm_debug.debug('iit_owner                 : '||pi_rec_iit_all.iit_owner,p_level);
   nm_debug.debug('iit_owner_txt             : '||pi_rec_iit_all.iit_owner_txt,p_level);
   nm_debug.debug('iit_peo_invent_by_id      : '||pi_rec_iit_all.iit_peo_invent_by_id,p_level);
   nm_debug.debug('iit_photo                 : '||pi_rec_iit_all.iit_photo,p_level);
   nm_debug.debug('iit_power                 : '||pi_rec_iit_all.iit_power,p_level);
   nm_debug.debug('iit_prov_flag             : '||pi_rec_iit_all.iit_prov_flag,p_level);
   nm_debug.debug('iit_rev_by                : '||pi_rec_iit_all.iit_rev_by,p_level);
   nm_debug.debug('iit_rev_date              : '||pi_rec_iit_all.iit_rev_date,p_level);
   nm_debug.debug('iit_type                  : '||pi_rec_iit_all.iit_type,p_level);
   nm_debug.debug('iit_type_txt              : '||pi_rec_iit_all.iit_type_txt,p_level);
   nm_debug.debug('iit_width                 : '||pi_rec_iit_all.iit_width,p_level);
   nm_debug.debug('iit_xtra_char_1           : '||pi_rec_iit_all.iit_xtra_char_1,p_level);
   nm_debug.debug('iit_xtra_date_1           : '||pi_rec_iit_all.iit_xtra_date_1,p_level);
   nm_debug.debug('iit_xtra_domain_1         : '||pi_rec_iit_all.iit_xtra_domain_1,p_level);
   nm_debug.debug('iit_xtra_domain_txt_1     : '||pi_rec_iit_all.iit_xtra_domain_txt_1,p_level);
   nm_debug.debug('iit_xtra_number_1         : '||pi_rec_iit_all.iit_xtra_number_1,p_level);
   nm_debug.debug('iit_x_sect                : '||pi_rec_iit_all.iit_x_sect,p_level);
   nm_debug.debug('iit_det_xsp               : '||pi_rec_iit_all.iit_det_xsp,p_level);
   nm_debug.debug('iit_offset                : '||pi_rec_iit_all.iit_offset,p_level);
   nm_debug.debug('iit_x                     : '||pi_rec_iit_all.iit_x,p_level);
   nm_debug.debug('iit_y                     : '||pi_rec_iit_all.iit_y,p_level);
   nm_debug.debug('iit_z                     : '||pi_rec_iit_all.iit_z,p_level);
   nm_debug.debug('iit_num_attrib96          : '||pi_rec_iit_all.iit_num_attrib96,p_level);
   nm_debug.debug('iit_num_attrib97          : '||pi_rec_iit_all.iit_num_attrib97,p_level);
   nm_debug.debug('iit_num_attrib98          : '||pi_rec_iit_all.iit_num_attrib98,p_level);
   nm_debug.debug('iit_num_attrib99          : '||pi_rec_iit_all.iit_num_attrib99,p_level);
   nm_debug.debug('iit_num_attrib100         : '||pi_rec_iit_all.iit_num_attrib100,p_level);
   nm_debug.debug('iit_num_attrib101         : '||pi_rec_iit_all.iit_num_attrib101,p_level);
   nm_debug.debug('iit_num_attrib102         : '||pi_rec_iit_all.iit_num_attrib102,p_level);
   nm_debug.debug('iit_num_attrib103         : '||pi_rec_iit_all.iit_num_attrib103,p_level);
   nm_debug.debug('iit_num_attrib104         : '||pi_rec_iit_all.iit_num_attrib104,p_level);
   nm_debug.debug('iit_num_attrib105         : '||pi_rec_iit_all.iit_num_attrib105,p_level);
   nm_debug.debug('iit_num_attrib106         : '||pi_rec_iit_all.iit_num_attrib106,p_level);
   nm_debug.debug('iit_num_attrib107         : '||pi_rec_iit_all.iit_num_attrib107,p_level);
   nm_debug.debug('iit_num_attrib108         : '||pi_rec_iit_all.iit_num_attrib108,p_level);
   nm_debug.debug('iit_num_attrib109         : '||pi_rec_iit_all.iit_num_attrib109,p_level);
   nm_debug.debug('iit_num_attrib110         : '||pi_rec_iit_all.iit_num_attrib110,p_level);
   nm_debug.debug('iit_num_attrib111         : '||pi_rec_iit_all.iit_num_attrib111,p_level);
   nm_debug.debug('iit_num_attrib112         : '||pi_rec_iit_all.iit_num_attrib112,p_level);
   nm_debug.debug('iit_num_attrib113         : '||pi_rec_iit_all.iit_num_attrib113,p_level);
   nm_debug.debug('iit_num_attrib114         : '||pi_rec_iit_all.iit_num_attrib114,p_level);
   nm_debug.debug('iit_num_attrib115         : '||pi_rec_iit_all.iit_num_attrib115,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_iit_all');
--
END debug_iit_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_iig (pi_rec_iig nm_inv_item_groupings%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_iig');
--
   nm_debug.debug('iig_top_id     : '||pi_rec_iig.iig_top_id,p_level);
   nm_debug.debug('iig_item_id    : '||pi_rec_iig.iig_item_id,p_level);
   nm_debug.debug('iig_parent_id  : '||pi_rec_iig.iig_parent_id,p_level);
   nm_debug.debug('iig_start_date : '||pi_rec_iig.iig_start_date,p_level);
   nm_debug.debug('iig_end_date   : '||pi_rec_iig.iig_end_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_iig');
--
END debug_iig;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_iig_all (pi_rec_iig_all nm_inv_item_groupings_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_iig_all');
--
   nm_debug.debug('iig_top_id     : '||pi_rec_iig_all.iig_top_id,p_level);
   nm_debug.debug('iig_item_id    : '||pi_rec_iig_all.iig_item_id,p_level);
   nm_debug.debug('iig_parent_id  : '||pi_rec_iig_all.iig_parent_id,p_level);
   nm_debug.debug('iig_start_date : '||pi_rec_iig_all.iig_start_date,p_level);
   nm_debug.debug('iig_end_date   : '||pi_rec_iig_all.iig_end_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_iig_all');
--
END debug_iig_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nin (pi_rec_nin nm_inv_nw%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nin');
--
   nm_debug.debug('nin_nw_type       : '||pi_rec_nin.nin_nw_type,p_level);
   nm_debug.debug('nin_nit_inv_code  : '||pi_rec_nin.nin_nit_inv_code,p_level);
   nm_debug.debug('nin_loc_mandatory : '||pi_rec_nin.nin_loc_mandatory,p_level);
   nm_debug.debug('nin_start_date    : '||pi_rec_nin.nin_start_date,p_level);
   nm_debug.debug('nin_end_date      : '||pi_rec_nin.nin_end_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nin');
--
END debug_nin;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nin_all (pi_rec_nin_all nm_inv_nw_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nin_all');
--
   nm_debug.debug('nin_nw_type       : '||pi_rec_nin_all.nin_nw_type,p_level);
   nm_debug.debug('nin_nit_inv_code  : '||pi_rec_nin_all.nin_nit_inv_code,p_level);
   nm_debug.debug('nin_loc_mandatory : '||pi_rec_nin_all.nin_loc_mandatory,p_level);
   nm_debug.debug('nin_start_date    : '||pi_rec_nin_all.nin_start_date,p_level);
   nm_debug.debug('nin_end_date      : '||pi_rec_nin_all.nin_end_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nin_all');
--
END debug_nin_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nith (pi_rec_nith nm_inv_themes%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nith');
--
   nm_debug.debug('nith_nit_id       : '||pi_rec_nith.nith_nit_id,p_level);
   nm_debug.debug('nith_nth_theme_id : '||pi_rec_nith.nith_nth_theme_id,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nith');
--
END debug_nith;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nit (pi_rec_nit nm_inv_types%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nit');
--
   nm_debug.debug('nit_inv_type          : '||pi_rec_nit.nit_inv_type,p_level);
   nm_debug.debug('nit_pnt_or_cont       : '||pi_rec_nit.nit_pnt_or_cont,p_level);
   nm_debug.debug('nit_x_sect_allow_flag : '||pi_rec_nit.nit_x_sect_allow_flag,p_level);
   nm_debug.debug('nit_elec_drain_carr   : '||pi_rec_nit.nit_elec_drain_carr,p_level);
   nm_debug.debug('nit_contiguous        : '||pi_rec_nit.nit_contiguous,p_level);
   nm_debug.debug('nit_replaceable       : '||pi_rec_nit.nit_replaceable,p_level);
   nm_debug.debug('nit_exclusive         : '||pi_rec_nit.nit_exclusive,p_level);
   nm_debug.debug('nit_category          : '||pi_rec_nit.nit_category,p_level);
   nm_debug.debug('nit_descr             : '||pi_rec_nit.nit_descr,p_level);
   nm_debug.debug('nit_linear            : '||pi_rec_nit.nit_linear,p_level);
   nm_debug.debug('nit_use_xy            : '||pi_rec_nit.nit_use_xy,p_level);
   nm_debug.debug('nit_multiple_allowed  : '||pi_rec_nit.nit_multiple_allowed,p_level);
   nm_debug.debug('nit_end_loc_only      : '||pi_rec_nit.nit_end_loc_only,p_level);
   nm_debug.debug('nit_screen_seq        : '||pi_rec_nit.nit_screen_seq,p_level);
   nm_debug.debug('nit_view_name         : '||pi_rec_nit.nit_view_name,p_level);
   nm_debug.debug('nit_start_date        : '||pi_rec_nit.nit_start_date,p_level);
   nm_debug.debug('nit_end_date          : '||pi_rec_nit.nit_end_date,p_level);
   nm_debug.debug('nit_short_descr       : '||pi_rec_nit.nit_short_descr,p_level);
   nm_debug.debug('nit_flex_item_flag    : '||pi_rec_nit.nit_flex_item_flag,p_level);
   nm_debug.debug('nit_table_name        : '||pi_rec_nit.nit_table_name,p_level);
   nm_debug.debug('nit_lr_ne_column_name : '||pi_rec_nit.nit_lr_ne_column_name,p_level);
   nm_debug.debug('nit_lr_st_chain       : '||pi_rec_nit.nit_lr_st_chain,p_level);
   nm_debug.debug('nit_lr_end_chain      : '||pi_rec_nit.nit_lr_end_chain,p_level);
   nm_debug.debug('nit_admin_type        : '||pi_rec_nit.nit_admin_type,p_level);
   nm_debug.debug('nit_icon_name         : '||pi_rec_nit.nit_icon_name,p_level);
   nm_debug.debug('nit_top               : '||pi_rec_nit.nit_top,p_level);
   nm_debug.debug('nit_foreign_pk_column : '||pi_rec_nit.nit_foreign_pk_column,p_level);
   nm_debug.debug('nit_update_allowed    : '||pi_rec_nit.nit_update_allowed,p_level);
   nm_debug.debug('nit_date_created      : '||pi_rec_nit.nit_date_created,p_level);
   nm_debug.debug('nit_date_modified     : '||pi_rec_nit.nit_date_modified,p_level);
   nm_debug.debug('nit_modified_by       : '||pi_rec_nit.nit_modified_by,p_level);
   nm_debug.debug('nit_created_by        : '||pi_rec_nit.nit_created_by,p_level);
   nm_debug.debug('nit_notes             : '||pi_rec_nit.nit_notes,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nit');
--
END debug_nit;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nit_all (pi_rec_nit_all nm_inv_types_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nit_all');
--
   nm_debug.debug('nit_inv_type          : '||pi_rec_nit_all.nit_inv_type,p_level);
   nm_debug.debug('nit_pnt_or_cont       : '||pi_rec_nit_all.nit_pnt_or_cont,p_level);
   nm_debug.debug('nit_x_sect_allow_flag : '||pi_rec_nit_all.nit_x_sect_allow_flag,p_level);
   nm_debug.debug('nit_elec_drain_carr   : '||pi_rec_nit_all.nit_elec_drain_carr,p_level);
   nm_debug.debug('nit_contiguous        : '||pi_rec_nit_all.nit_contiguous,p_level);
   nm_debug.debug('nit_replaceable       : '||pi_rec_nit_all.nit_replaceable,p_level);
   nm_debug.debug('nit_exclusive         : '||pi_rec_nit_all.nit_exclusive,p_level);
   nm_debug.debug('nit_category          : '||pi_rec_nit_all.nit_category,p_level);
   nm_debug.debug('nit_descr             : '||pi_rec_nit_all.nit_descr,p_level);
   nm_debug.debug('nit_linear            : '||pi_rec_nit_all.nit_linear,p_level);
   nm_debug.debug('nit_use_xy            : '||pi_rec_nit_all.nit_use_xy,p_level);
   nm_debug.debug('nit_multiple_allowed  : '||pi_rec_nit_all.nit_multiple_allowed,p_level);
   nm_debug.debug('nit_end_loc_only      : '||pi_rec_nit_all.nit_end_loc_only,p_level);
   nm_debug.debug('nit_screen_seq        : '||pi_rec_nit_all.nit_screen_seq,p_level);
   nm_debug.debug('nit_view_name         : '||pi_rec_nit_all.nit_view_name,p_level);
   nm_debug.debug('nit_start_date        : '||pi_rec_nit_all.nit_start_date,p_level);
   nm_debug.debug('nit_end_date          : '||pi_rec_nit_all.nit_end_date,p_level);
   nm_debug.debug('nit_short_descr       : '||pi_rec_nit_all.nit_short_descr,p_level);
   nm_debug.debug('nit_flex_item_flag    : '||pi_rec_nit_all.nit_flex_item_flag,p_level);
   nm_debug.debug('nit_table_name        : '||pi_rec_nit_all.nit_table_name,p_level);
   nm_debug.debug('nit_lr_ne_column_name : '||pi_rec_nit_all.nit_lr_ne_column_name,p_level);
   nm_debug.debug('nit_lr_st_chain       : '||pi_rec_nit_all.nit_lr_st_chain,p_level);
   nm_debug.debug('nit_lr_end_chain      : '||pi_rec_nit_all.nit_lr_end_chain,p_level);
   nm_debug.debug('nit_admin_type        : '||pi_rec_nit_all.nit_admin_type,p_level);
   nm_debug.debug('nit_icon_name         : '||pi_rec_nit_all.nit_icon_name,p_level);
   nm_debug.debug('nit_top               : '||pi_rec_nit_all.nit_top,p_level);
   nm_debug.debug('nit_foreign_pk_column : '||pi_rec_nit_all.nit_foreign_pk_column,p_level);
   nm_debug.debug('nit_update_allowed    : '||pi_rec_nit_all.nit_update_allowed,p_level);
   nm_debug.debug('nit_date_created      : '||pi_rec_nit_all.nit_date_created,p_level);
   nm_debug.debug('nit_date_modified     : '||pi_rec_nit_all.nit_date_modified,p_level);
   nm_debug.debug('nit_modified_by       : '||pi_rec_nit_all.nit_modified_by,p_level);
   nm_debug.debug('nit_created_by        : '||pi_rec_nit_all.nit_created_by,p_level);
   nm_debug.debug('nit_notes             : '||pi_rec_nit_all.nit_notes,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nit_all');
--
END debug_nit_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ita (pi_rec_ita nm_inv_type_attribs%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ita');
--
   nm_debug.debug('ita_inv_type        : '||pi_rec_ita.ita_inv_type,p_level);
   nm_debug.debug('ita_attrib_name     : '||pi_rec_ita.ita_attrib_name,p_level);
   nm_debug.debug('ita_dynamic_attrib  : '||pi_rec_ita.ita_dynamic_attrib,p_level);
   nm_debug.debug('ita_disp_seq_no     : '||pi_rec_ita.ita_disp_seq_no,p_level);
   nm_debug.debug('ita_mandatory_yn    : '||pi_rec_ita.ita_mandatory_yn,p_level);
   nm_debug.debug('ita_format          : '||pi_rec_ita.ita_format,p_level);
   nm_debug.debug('ita_fld_length      : '||pi_rec_ita.ita_fld_length,p_level);
   nm_debug.debug('ita_dec_places      : '||pi_rec_ita.ita_dec_places,p_level);
   nm_debug.debug('ita_scrn_text       : '||pi_rec_ita.ita_scrn_text,p_level);
   nm_debug.debug('ita_id_domain       : '||pi_rec_ita.ita_id_domain,p_level);
   nm_debug.debug('ita_validate_yn     : '||pi_rec_ita.ita_validate_yn,p_level);
   nm_debug.debug('ita_dtp_code        : '||pi_rec_ita.ita_dtp_code,p_level);
   nm_debug.debug('ita_max             : '||pi_rec_ita.ita_max,p_level);
   nm_debug.debug('ita_min             : '||pi_rec_ita.ita_min,p_level);
   nm_debug.debug('ita_view_attri      : '||pi_rec_ita.ita_view_attri,p_level);
   nm_debug.debug('ita_view_col_name   : '||pi_rec_ita.ita_view_col_name,p_level);
   nm_debug.debug('ita_start_date      : '||pi_rec_ita.ita_start_date,p_level);
   nm_debug.debug('ita_end_date        : '||pi_rec_ita.ita_end_date,p_level);
   nm_debug.debug('ita_queryable       : '||pi_rec_ita.ita_queryable,p_level);
   nm_debug.debug('ita_ukpms_param_no  : '||pi_rec_ita.ita_ukpms_param_no,p_level);
   nm_debug.debug('ita_units           : '||pi_rec_ita.ita_units,p_level);
   nm_debug.debug('ita_format_mask     : '||pi_rec_ita.ita_format_mask,p_level);
   nm_debug.debug('ita_exclusive       : '||pi_rec_ita.ita_exclusive,p_level);
   nm_debug.debug('ita_keep_history_yn : '||pi_rec_ita.ita_keep_history_yn,p_level);
   nm_debug.debug('ita_date_created    : '||pi_rec_ita.ita_date_created,p_level);
   nm_debug.debug('ita_date_modified   : '||pi_rec_ita.ita_date_modified,p_level);
   nm_debug.debug('ita_modified_by     : '||pi_rec_ita.ita_modified_by,p_level);
   nm_debug.debug('ita_created_by      : '||pi_rec_ita.ita_created_by,p_level);
   nm_debug.debug('ita_query           : '||pi_rec_ita.ita_query,p_level);
   nm_debug.debug('ita_displayed       : '||pi_rec_ita.ita_displayed,p_level);
   nm_debug.debug('ita_disp_width      : '||pi_rec_ita.ita_disp_width,p_level);
   nm_debug.debug('ita_inspectable     : '||pi_rec_ita.ita_inspectable,p_level);
   nm_debug.debug('ita_case            : '||pi_rec_ita.ita_case,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ita');
--
END debug_ita;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ita_all (pi_rec_ita_all nm_inv_type_attribs_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ita_all');
--
   nm_debug.debug('ita_inv_type        : '||pi_rec_ita_all.ita_inv_type,p_level);
   nm_debug.debug('ita_attrib_name     : '||pi_rec_ita_all.ita_attrib_name,p_level);
   nm_debug.debug('ita_dynamic_attrib  : '||pi_rec_ita_all.ita_dynamic_attrib,p_level);
   nm_debug.debug('ita_disp_seq_no     : '||pi_rec_ita_all.ita_disp_seq_no,p_level);
   nm_debug.debug('ita_mandatory_yn    : '||pi_rec_ita_all.ita_mandatory_yn,p_level);
   nm_debug.debug('ita_format          : '||pi_rec_ita_all.ita_format,p_level);
   nm_debug.debug('ita_fld_length      : '||pi_rec_ita_all.ita_fld_length,p_level);
   nm_debug.debug('ita_dec_places      : '||pi_rec_ita_all.ita_dec_places,p_level);
   nm_debug.debug('ita_scrn_text       : '||pi_rec_ita_all.ita_scrn_text,p_level);
   nm_debug.debug('ita_id_domain       : '||pi_rec_ita_all.ita_id_domain,p_level);
   nm_debug.debug('ita_validate_yn     : '||pi_rec_ita_all.ita_validate_yn,p_level);
   nm_debug.debug('ita_dtp_code        : '||pi_rec_ita_all.ita_dtp_code,p_level);
   nm_debug.debug('ita_max             : '||pi_rec_ita_all.ita_max,p_level);
   nm_debug.debug('ita_min             : '||pi_rec_ita_all.ita_min,p_level);
   nm_debug.debug('ita_view_attri      : '||pi_rec_ita_all.ita_view_attri,p_level);
   nm_debug.debug('ita_view_col_name   : '||pi_rec_ita_all.ita_view_col_name,p_level);
   nm_debug.debug('ita_start_date      : '||pi_rec_ita_all.ita_start_date,p_level);
   nm_debug.debug('ita_end_date        : '||pi_rec_ita_all.ita_end_date,p_level);
   nm_debug.debug('ita_queryable       : '||pi_rec_ita_all.ita_queryable,p_level);
   nm_debug.debug('ita_ukpms_param_no  : '||pi_rec_ita_all.ita_ukpms_param_no,p_level);
   nm_debug.debug('ita_units           : '||pi_rec_ita_all.ita_units,p_level);
   nm_debug.debug('ita_format_mask     : '||pi_rec_ita_all.ita_format_mask,p_level);
   nm_debug.debug('ita_exclusive       : '||pi_rec_ita_all.ita_exclusive,p_level);
   nm_debug.debug('ita_keep_history_yn : '||pi_rec_ita_all.ita_keep_history_yn,p_level);
   nm_debug.debug('ita_date_created    : '||pi_rec_ita_all.ita_date_created,p_level);
   nm_debug.debug('ita_date_modified   : '||pi_rec_ita_all.ita_date_modified,p_level);
   nm_debug.debug('ita_modified_by     : '||pi_rec_ita_all.ita_modified_by,p_level);
   nm_debug.debug('ita_created_by      : '||pi_rec_ita_all.ita_created_by,p_level);
   nm_debug.debug('ita_query           : '||pi_rec_ita_all.ita_query,p_level);
   nm_debug.debug('ita_displayed       : '||pi_rec_ita_all.ita_displayed,p_level);
   nm_debug.debug('ita_disp_width      : '||pi_rec_ita_all.ita_disp_width,p_level);
   nm_debug.debug('ita_inspectable     : '||pi_rec_ita_all.ita_inspectable,p_level);
   nm_debug.debug('ita_case            : '||pi_rec_ita_all.ita_case,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ita_all');
--
END debug_ita_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_itb (pi_rec_itb nm_inv_type_attrib_bandings%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_itb');
--
   nm_debug.debug('itb_inv_type            : '||pi_rec_itb.itb_inv_type,p_level);
   nm_debug.debug('itb_attrib_name         : '||pi_rec_itb.itb_attrib_name,p_level);
   nm_debug.debug('itb_banding_id          : '||pi_rec_itb.itb_banding_id,p_level);
   nm_debug.debug('itb_banding_description : '||pi_rec_itb.itb_banding_description,p_level);
   nm_debug.debug('itb_date_created        : '||pi_rec_itb.itb_date_created,p_level);
   nm_debug.debug('itb_date_modified       : '||pi_rec_itb.itb_date_modified,p_level);
   nm_debug.debug('itb_modified_by         : '||pi_rec_itb.itb_modified_by,p_level);
   nm_debug.debug('itb_created_by          : '||pi_rec_itb.itb_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_itb');
--
END debug_itb;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_itd (pi_rec_itd nm_inv_type_attrib_band_dets%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_itd');
--
   nm_debug.debug('itd_inv_type         : '||pi_rec_itd.itd_inv_type,p_level);
   nm_debug.debug('itd_attrib_name      : '||pi_rec_itd.itd_attrib_name,p_level);
   nm_debug.debug('itd_itb_banding_id   : '||pi_rec_itd.itd_itb_banding_id,p_level);
   nm_debug.debug('itd_band_seq         : '||pi_rec_itd.itd_band_seq,p_level);
   nm_debug.debug('itd_band_min_value   : '||pi_rec_itd.itd_band_min_value,p_level);
   nm_debug.debug('itd_band_max_value   : '||pi_rec_itd.itd_band_max_value,p_level);
   nm_debug.debug('itd_band_description : '||pi_rec_itd.itd_band_description,p_level);
   nm_debug.debug('itd_date_created     : '||pi_rec_itd.itd_date_created,p_level);
   nm_debug.debug('itd_date_modified    : '||pi_rec_itd.itd_date_modified,p_level);
   nm_debug.debug('itd_modified_by      : '||pi_rec_itd.itd_modified_by,p_level);
   nm_debug.debug('itd_created_by       : '||pi_rec_itd.itd_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_itd');
--
END debug_itd;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nias (pi_rec_nias nm_inv_attribute_sets%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nias');
--
   nm_debug.debug('nias_id            : '||pi_rec_nias.nias_id,p_level);
   nm_debug.debug('nias_descr         : '||pi_rec_nias.nias_descr,p_level);
   nm_debug.debug('nias_date_created  : '||pi_rec_nias.nias_date_created,p_level);
   nm_debug.debug('nias_date_modified : '||pi_rec_nias.nias_date_modified,p_level);
   nm_debug.debug('nias_modified_by   : '||pi_rec_nias.nias_modified_by,p_level);
   nm_debug.debug('nias_created_by    : '||pi_rec_nias.nias_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nias');
--
END debug_nias;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nsit (pi_rec_nsit nm_inv_attribute_set_inv_types%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nsit');
--
   nm_debug.debug('nsit_nias_id      : '||pi_rec_nsit.nsit_nias_id,p_level);
   nm_debug.debug('nsit_nit_inv_type : '||pi_rec_nsit.nsit_nit_inv_type,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nsit');
--
END debug_nsit;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nsia (pi_rec_nsia nm_inv_attribute_set_inv_attr%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nsia');
--
   nm_debug.debug('nsia_nsit_nias_id      : '||pi_rec_nsia.nsia_nsit_nias_id,p_level);
   nm_debug.debug('nsia_nsit_nit_inv_type : '||pi_rec_nsia.nsia_nsit_nit_inv_type,p_level);
   nm_debug.debug('nsia_ita_attrib_name   : '||pi_rec_nsia.nsia_ita_attrib_name,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nsia');
--
END debug_nsia;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nitc (pi_rec_nitc nm_inv_type_colours%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nitc');
--
   nm_debug.debug('col_id       : '||pi_rec_nitc.col_id,p_level);
   nm_debug.debug('ity_inv_code : '||pi_rec_nitc.ity_inv_code,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nitc');
--
END debug_nitc;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_itg (pi_rec_itg nm_inv_type_groupings%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_itg');
--
   nm_debug.debug('itg_inv_type        : '||pi_rec_itg.itg_inv_type,p_level);
   nm_debug.debug('itg_parent_inv_type : '||pi_rec_itg.itg_parent_inv_type,p_level);
   nm_debug.debug('itg_mandatory       : '||pi_rec_itg.itg_mandatory,p_level);
   nm_debug.debug('itg_relation        : '||pi_rec_itg.itg_relation,p_level);
   nm_debug.debug('itg_start_date      : '||pi_rec_itg.itg_start_date,p_level);
   nm_debug.debug('itg_end_date        : '||pi_rec_itg.itg_end_date,p_level);
   nm_debug.debug('itg_date_created    : '||pi_rec_itg.itg_date_created,p_level);
   nm_debug.debug('itg_date_modified   : '||pi_rec_itg.itg_date_modified,p_level);
   nm_debug.debug('itg_modified_by     : '||pi_rec_itg.itg_modified_by,p_level);
   nm_debug.debug('itg_created_by      : '||pi_rec_itg.itg_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_itg');
--
END debug_itg;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_itg_all (pi_rec_itg_all nm_inv_type_groupings_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_itg_all');
--
   nm_debug.debug('itg_inv_type        : '||pi_rec_itg_all.itg_inv_type,p_level);
   nm_debug.debug('itg_parent_inv_type : '||pi_rec_itg_all.itg_parent_inv_type,p_level);
   nm_debug.debug('itg_mandatory       : '||pi_rec_itg_all.itg_mandatory,p_level);
   nm_debug.debug('itg_relation        : '||pi_rec_itg_all.itg_relation,p_level);
   nm_debug.debug('itg_start_date      : '||pi_rec_itg_all.itg_start_date,p_level);
   nm_debug.debug('itg_end_date        : '||pi_rec_itg_all.itg_end_date,p_level);
   nm_debug.debug('itg_date_created    : '||pi_rec_itg_all.itg_date_created,p_level);
   nm_debug.debug('itg_date_modified   : '||pi_rec_itg_all.itg_date_modified,p_level);
   nm_debug.debug('itg_modified_by     : '||pi_rec_itg_all.itg_modified_by,p_level);
   nm_debug.debug('itg_created_by      : '||pi_rec_itg_all.itg_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_itg_all');
--
END debug_itg_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_itr (pi_rec_itr nm_inv_type_roles%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_itr');
--
   nm_debug.debug('itr_inv_type : '||pi_rec_itr.itr_inv_type,p_level);
   nm_debug.debug('itr_hro_role : '||pi_rec_itr.itr_hro_role,p_level);
   nm_debug.debug('itr_mode     : '||pi_rec_itr.itr_mode,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_itr');
--
END debug_itr;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_njc (pi_rec_njc nm_job_control%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_njc');
--
   nm_debug.debug('njc_job_id         : '||pi_rec_njc.njc_job_id,p_level);
   nm_debug.debug('njc_unique         : '||pi_rec_njc.njc_unique,p_level);
   nm_debug.debug('njc_njt_type       : '||pi_rec_njc.njc_njt_type,p_level);
   nm_debug.debug('njc_job_descr      : '||pi_rec_njc.njc_job_descr,p_level);
   nm_debug.debug('njc_status         : '||pi_rec_njc.njc_status,p_level);
   nm_debug.debug('njc_date_created   : '||pi_rec_njc.njc_date_created,p_level);
   nm_debug.debug('njc_date_modified  : '||pi_rec_njc.njc_date_modified,p_level);
   nm_debug.debug('njc_created_by     : '||pi_rec_njc.njc_created_by,p_level);
   nm_debug.debug('njc_modified_by    : '||pi_rec_njc.njc_modified_by,p_level);
   nm_debug.debug('njc_route_ne_id    : '||pi_rec_njc.njc_route_ne_id,p_level);
   nm_debug.debug('njc_route_begin_mp : '||pi_rec_njc.njc_route_begin_mp,p_level);
   nm_debug.debug('njc_route_end_mp   : '||pi_rec_njc.njc_route_end_mp,p_level);
   nm_debug.debug('njc_npe_job_id     : '||pi_rec_njc.njc_npe_job_id,p_level);
   nm_debug.debug('njc_effective_date : '||pi_rec_njc.njc_effective_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_njc');
--
END debug_njc;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_njo (pi_rec_njo nm_job_operations%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_njo');
--
   nm_debug.debug('njo_njc_job_id    : '||pi_rec_njo.njo_njc_job_id,p_level);
   nm_debug.debug('njo_id            : '||pi_rec_njo.njo_id,p_level);
   nm_debug.debug('njo_nmo_operation : '||pi_rec_njo.njo_nmo_operation,p_level);
   nm_debug.debug('njo_seq           : '||pi_rec_njo.njo_seq,p_level);
   nm_debug.debug('njo_status        : '||pi_rec_njo.njo_status,p_level);
   nm_debug.debug('njo_date_created  : '||pi_rec_njo.njo_date_created,p_level);
   nm_debug.debug('njo_date_modified : '||pi_rec_njo.njo_date_modified,p_level);
   nm_debug.debug('njo_created_by    : '||pi_rec_njo.njo_created_by,p_level);
   nm_debug.debug('njo_modified_by   : '||pi_rec_njo.njo_modified_by,p_level);
   nm_debug.debug('njo_begin_mp      : '||pi_rec_njo.njo_begin_mp,p_level);
   nm_debug.debug('njo_end_mp        : '||pi_rec_njo.njo_end_mp,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_njo');
--
END debug_njo;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_njv (pi_rec_njv nm_job_operation_data_values%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_njv');
--
   nm_debug.debug('njv_njc_job_id    : '||pi_rec_njv.njv_njc_job_id,p_level);
   nm_debug.debug('njv_njo_id        : '||pi_rec_njv.njv_njo_id,p_level);
   nm_debug.debug('njv_nmo_operation : '||pi_rec_njv.njv_nmo_operation,p_level);
   nm_debug.debug('njv_nod_data_item : '||pi_rec_njv.njv_nod_data_item,p_level);
   nm_debug.debug('njv_date_created  : '||pi_rec_njv.njv_date_created,p_level);
   nm_debug.debug('njv_date_modified : '||pi_rec_njv.njv_date_modified,p_level);
   nm_debug.debug('njv_created_by    : '||pi_rec_njv.njv_created_by,p_level);
   nm_debug.debug('njv_modified_by   : '||pi_rec_njv.njv_modified_by,p_level);
   nm_debug.debug('njv_value         : '||pi_rec_njv.njv_value,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_njv');
--
END debug_njv;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_njt (pi_rec_njt nm_job_types%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_njt');
--
   nm_debug.debug('njt_type     : '||pi_rec_njt.njt_type,p_level);
   nm_debug.debug('njt_unique   : '||pi_rec_njt.njt_unique,p_level);
   nm_debug.debug('njt_descr    : '||pi_rec_njt.njt_descr,p_level);
   nm_debug.debug('njt_nw_lock  : '||pi_rec_njt.njt_nw_lock,p_level);
   nm_debug.debug('njt_inv_lock : '||pi_rec_njt.njt_inv_lock,p_level);
   nm_debug.debug('njt_inv_type : '||pi_rec_njt.njt_inv_type,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_njt');
--
END debug_njt;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_jto (pi_rec_jto nm_job_types_operations%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_jto');
--
   nm_debug.debug('jto_njt_type      : '||pi_rec_jto.jto_njt_type,p_level);
   nm_debug.debug('jto_nmo_operation : '||pi_rec_jto.jto_nmo_operation,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_jto');
--
END debug_jto;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nlm (pi_rec_nlm nm_ld_mc_all_inv_tmp%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nlm');
--
   nm_debug.debug('batch_no                  : '||pi_rec_nlm.batch_no,p_level);
   nm_debug.debug('record_no                 : '||pi_rec_nlm.record_no,p_level);
   nm_debug.debug('nlm_error_status          : '||pi_rec_nlm.nlm_error_status,p_level);
   nm_debug.debug('nlm_action_code           : '||pi_rec_nlm.nlm_action_code,p_level);
   nm_debug.debug('iit_ne_id                 : '||pi_rec_nlm.iit_ne_id,p_level);
   nm_debug.debug('iit_inv_type              : '||pi_rec_nlm.iit_inv_type,p_level);
   nm_debug.debug('iit_primary_key           : '||pi_rec_nlm.iit_primary_key,p_level);
   nm_debug.debug('iit_ne_unique             : '||pi_rec_nlm.iit_ne_unique,p_level);
   nm_debug.debug('iit_ne_nt_type            : '||pi_rec_nlm.iit_ne_nt_type,p_level);
   nm_debug.debug('ne_id                     : '||pi_rec_nlm.ne_id,p_level);
   nm_debug.debug('nm_start                  : '||pi_rec_nlm.nm_start,p_level);
   nm_debug.debug('nm_end                    : '||pi_rec_nlm.nm_end,p_level);
   nm_debug.debug('nau_unit_code             : '||pi_rec_nlm.nau_unit_code,p_level);
   nm_debug.debug('iit_start_date            : '||pi_rec_nlm.iit_start_date,p_level);
   nm_debug.debug('iit_date_created          : '||pi_rec_nlm.iit_date_created,p_level);
   nm_debug.debug('iit_date_modified         : '||pi_rec_nlm.iit_date_modified,p_level);
   nm_debug.debug('iit_created_by            : '||pi_rec_nlm.iit_created_by,p_level);
   nm_debug.debug('iit_modified_by           : '||pi_rec_nlm.iit_modified_by,p_level);
   nm_debug.debug('iit_admin_unit            : '||pi_rec_nlm.iit_admin_unit,p_level);
   nm_debug.debug('iit_descr                 : '||pi_rec_nlm.iit_descr,p_level);
   nm_debug.debug('iit_end_date              : '||pi_rec_nlm.iit_end_date,p_level);
   nm_debug.debug('iit_foreign_key           : '||pi_rec_nlm.iit_foreign_key,p_level);
   nm_debug.debug('iit_located_by            : '||pi_rec_nlm.iit_located_by,p_level);
   nm_debug.debug('iit_position              : '||pi_rec_nlm.iit_position,p_level);
   nm_debug.debug('iit_x_coord               : '||pi_rec_nlm.iit_x_coord,p_level);
   nm_debug.debug('iit_y_coord               : '||pi_rec_nlm.iit_y_coord,p_level);
   nm_debug.debug('iit_num_attrib16          : '||pi_rec_nlm.iit_num_attrib16,p_level);
   nm_debug.debug('iit_num_attrib17          : '||pi_rec_nlm.iit_num_attrib17,p_level);
   nm_debug.debug('iit_num_attrib18          : '||pi_rec_nlm.iit_num_attrib18,p_level);
   nm_debug.debug('iit_num_attrib19          : '||pi_rec_nlm.iit_num_attrib19,p_level);
   nm_debug.debug('iit_num_attrib20          : '||pi_rec_nlm.iit_num_attrib20,p_level);
   nm_debug.debug('iit_num_attrib21          : '||pi_rec_nlm.iit_num_attrib21,p_level);
   nm_debug.debug('iit_num_attrib22          : '||pi_rec_nlm.iit_num_attrib22,p_level);
   nm_debug.debug('iit_num_attrib23          : '||pi_rec_nlm.iit_num_attrib23,p_level);
   nm_debug.debug('iit_num_attrib24          : '||pi_rec_nlm.iit_num_attrib24,p_level);
   nm_debug.debug('iit_num_attrib25          : '||pi_rec_nlm.iit_num_attrib25,p_level);
   nm_debug.debug('iit_chr_attrib26          : '||pi_rec_nlm.iit_chr_attrib26,p_level);
   nm_debug.debug('iit_chr_attrib27          : '||pi_rec_nlm.iit_chr_attrib27,p_level);
   nm_debug.debug('iit_chr_attrib28          : '||pi_rec_nlm.iit_chr_attrib28,p_level);
   nm_debug.debug('iit_chr_attrib29          : '||pi_rec_nlm.iit_chr_attrib29,p_level);
   nm_debug.debug('iit_chr_attrib30          : '||pi_rec_nlm.iit_chr_attrib30,p_level);
   nm_debug.debug('iit_chr_attrib31          : '||pi_rec_nlm.iit_chr_attrib31,p_level);
   nm_debug.debug('iit_chr_attrib32          : '||pi_rec_nlm.iit_chr_attrib32,p_level);
   nm_debug.debug('iit_chr_attrib33          : '||pi_rec_nlm.iit_chr_attrib33,p_level);
   nm_debug.debug('iit_chr_attrib34          : '||pi_rec_nlm.iit_chr_attrib34,p_level);
   nm_debug.debug('iit_chr_attrib35          : '||pi_rec_nlm.iit_chr_attrib35,p_level);
   nm_debug.debug('iit_chr_attrib36          : '||pi_rec_nlm.iit_chr_attrib36,p_level);
   nm_debug.debug('iit_chr_attrib37          : '||pi_rec_nlm.iit_chr_attrib37,p_level);
   nm_debug.debug('iit_chr_attrib38          : '||pi_rec_nlm.iit_chr_attrib38,p_level);
   nm_debug.debug('iit_chr_attrib39          : '||pi_rec_nlm.iit_chr_attrib39,p_level);
   nm_debug.debug('iit_chr_attrib40          : '||pi_rec_nlm.iit_chr_attrib40,p_level);
   nm_debug.debug('iit_chr_attrib41          : '||pi_rec_nlm.iit_chr_attrib41,p_level);
   nm_debug.debug('iit_chr_attrib42          : '||pi_rec_nlm.iit_chr_attrib42,p_level);
   nm_debug.debug('iit_chr_attrib43          : '||pi_rec_nlm.iit_chr_attrib43,p_level);
   nm_debug.debug('iit_chr_attrib44          : '||pi_rec_nlm.iit_chr_attrib44,p_level);
   nm_debug.debug('iit_chr_attrib45          : '||pi_rec_nlm.iit_chr_attrib45,p_level);
   nm_debug.debug('iit_chr_attrib46          : '||pi_rec_nlm.iit_chr_attrib46,p_level);
   nm_debug.debug('iit_chr_attrib47          : '||pi_rec_nlm.iit_chr_attrib47,p_level);
   nm_debug.debug('iit_chr_attrib48          : '||pi_rec_nlm.iit_chr_attrib48,p_level);
   nm_debug.debug('iit_chr_attrib49          : '||pi_rec_nlm.iit_chr_attrib49,p_level);
   nm_debug.debug('iit_chr_attrib50          : '||pi_rec_nlm.iit_chr_attrib50,p_level);
   nm_debug.debug('iit_chr_attrib51          : '||pi_rec_nlm.iit_chr_attrib51,p_level);
   nm_debug.debug('iit_chr_attrib52          : '||pi_rec_nlm.iit_chr_attrib52,p_level);
   nm_debug.debug('iit_chr_attrib53          : '||pi_rec_nlm.iit_chr_attrib53,p_level);
   nm_debug.debug('iit_chr_attrib54          : '||pi_rec_nlm.iit_chr_attrib54,p_level);
   nm_debug.debug('iit_chr_attrib55          : '||pi_rec_nlm.iit_chr_attrib55,p_level);
   nm_debug.debug('iit_chr_attrib56          : '||pi_rec_nlm.iit_chr_attrib56,p_level);
   nm_debug.debug('iit_chr_attrib57          : '||pi_rec_nlm.iit_chr_attrib57,p_level);
   nm_debug.debug('iit_chr_attrib58          : '||pi_rec_nlm.iit_chr_attrib58,p_level);
   nm_debug.debug('iit_chr_attrib59          : '||pi_rec_nlm.iit_chr_attrib59,p_level);
   nm_debug.debug('iit_chr_attrib60          : '||pi_rec_nlm.iit_chr_attrib60,p_level);
   nm_debug.debug('iit_chr_attrib61          : '||pi_rec_nlm.iit_chr_attrib61,p_level);
   nm_debug.debug('iit_chr_attrib62          : '||pi_rec_nlm.iit_chr_attrib62,p_level);
   nm_debug.debug('iit_chr_attrib63          : '||pi_rec_nlm.iit_chr_attrib63,p_level);
   nm_debug.debug('iit_chr_attrib64          : '||pi_rec_nlm.iit_chr_attrib64,p_level);
   nm_debug.debug('iit_chr_attrib65          : '||pi_rec_nlm.iit_chr_attrib65,p_level);
   nm_debug.debug('iit_chr_attrib66          : '||pi_rec_nlm.iit_chr_attrib66,p_level);
   nm_debug.debug('iit_chr_attrib67          : '||pi_rec_nlm.iit_chr_attrib67,p_level);
   nm_debug.debug('iit_chr_attrib68          : '||pi_rec_nlm.iit_chr_attrib68,p_level);
   nm_debug.debug('iit_chr_attrib69          : '||pi_rec_nlm.iit_chr_attrib69,p_level);
   nm_debug.debug('iit_chr_attrib70          : '||pi_rec_nlm.iit_chr_attrib70,p_level);
   nm_debug.debug('iit_chr_attrib71          : '||pi_rec_nlm.iit_chr_attrib71,p_level);
   nm_debug.debug('iit_chr_attrib72          : '||pi_rec_nlm.iit_chr_attrib72,p_level);
   nm_debug.debug('iit_chr_attrib73          : '||pi_rec_nlm.iit_chr_attrib73,p_level);
   nm_debug.debug('iit_chr_attrib74          : '||pi_rec_nlm.iit_chr_attrib74,p_level);
   nm_debug.debug('iit_chr_attrib75          : '||pi_rec_nlm.iit_chr_attrib75,p_level);
   nm_debug.debug('iit_num_attrib76          : '||pi_rec_nlm.iit_num_attrib76,p_level);
   nm_debug.debug('iit_num_attrib77          : '||pi_rec_nlm.iit_num_attrib77,p_level);
   nm_debug.debug('iit_num_attrib78          : '||pi_rec_nlm.iit_num_attrib78,p_level);
   nm_debug.debug('iit_num_attrib79          : '||pi_rec_nlm.iit_num_attrib79,p_level);
   nm_debug.debug('iit_num_attrib80          : '||pi_rec_nlm.iit_num_attrib80,p_level);
   nm_debug.debug('iit_num_attrib81          : '||pi_rec_nlm.iit_num_attrib81,p_level);
   nm_debug.debug('iit_num_attrib82          : '||pi_rec_nlm.iit_num_attrib82,p_level);
   nm_debug.debug('iit_num_attrib83          : '||pi_rec_nlm.iit_num_attrib83,p_level);
   nm_debug.debug('iit_num_attrib84          : '||pi_rec_nlm.iit_num_attrib84,p_level);
   nm_debug.debug('iit_num_attrib85          : '||pi_rec_nlm.iit_num_attrib85,p_level);
   nm_debug.debug('iit_date_attrib86         : '||pi_rec_nlm.iit_date_attrib86,p_level);
   nm_debug.debug('iit_date_attrib87         : '||pi_rec_nlm.iit_date_attrib87,p_level);
   nm_debug.debug('iit_date_attrib88         : '||pi_rec_nlm.iit_date_attrib88,p_level);
   nm_debug.debug('iit_date_attrib89         : '||pi_rec_nlm.iit_date_attrib89,p_level);
   nm_debug.debug('iit_date_attrib90         : '||pi_rec_nlm.iit_date_attrib90,p_level);
   nm_debug.debug('iit_date_attrib91         : '||pi_rec_nlm.iit_date_attrib91,p_level);
   nm_debug.debug('iit_date_attrib92         : '||pi_rec_nlm.iit_date_attrib92,p_level);
   nm_debug.debug('iit_date_attrib93         : '||pi_rec_nlm.iit_date_attrib93,p_level);
   nm_debug.debug('iit_date_attrib94         : '||pi_rec_nlm.iit_date_attrib94,p_level);
   nm_debug.debug('iit_date_attrib95         : '||pi_rec_nlm.iit_date_attrib95,p_level);
   nm_debug.debug('iit_angle                 : '||pi_rec_nlm.iit_angle,p_level);
   nm_debug.debug('iit_angle_txt             : '||pi_rec_nlm.iit_angle_txt,p_level);
   nm_debug.debug('iit_class                 : '||pi_rec_nlm.iit_class,p_level);
   nm_debug.debug('iit_class_txt             : '||pi_rec_nlm.iit_class_txt,p_level);
   nm_debug.debug('iit_colour                : '||pi_rec_nlm.iit_colour,p_level);
   nm_debug.debug('iit_colour_txt            : '||pi_rec_nlm.iit_colour_txt,p_level);
   nm_debug.debug('iit_coord_flag            : '||pi_rec_nlm.iit_coord_flag,p_level);
   nm_debug.debug('iit_description           : '||pi_rec_nlm.iit_description,p_level);
   nm_debug.debug('iit_diagram               : '||pi_rec_nlm.iit_diagram,p_level);
   nm_debug.debug('iit_distance              : '||pi_rec_nlm.iit_distance,p_level);
   nm_debug.debug('iit_end_chain             : '||pi_rec_nlm.iit_end_chain,p_level);
   nm_debug.debug('iit_gap                   : '||pi_rec_nlm.iit_gap,p_level);
   nm_debug.debug('iit_height                : '||pi_rec_nlm.iit_height,p_level);
   nm_debug.debug('iit_height_2              : '||pi_rec_nlm.iit_height_2,p_level);
   nm_debug.debug('iit_id_code               : '||pi_rec_nlm.iit_id_code,p_level);
   nm_debug.debug('iit_instal_date           : '||pi_rec_nlm.iit_instal_date,p_level);
   nm_debug.debug('iit_invent_date           : '||pi_rec_nlm.iit_invent_date,p_level);
   nm_debug.debug('iit_inv_ownership         : '||pi_rec_nlm.iit_inv_ownership,p_level);
   nm_debug.debug('iit_itemcode              : '||pi_rec_nlm.iit_itemcode,p_level);
   nm_debug.debug('iit_lco_lamp_config_id    : '||pi_rec_nlm.iit_lco_lamp_config_id,p_level);
   nm_debug.debug('iit_length                : '||pi_rec_nlm.iit_length,p_level);
   nm_debug.debug('iit_material              : '||pi_rec_nlm.iit_material,p_level);
   nm_debug.debug('iit_material_txt          : '||pi_rec_nlm.iit_material_txt,p_level);
   nm_debug.debug('iit_method                : '||pi_rec_nlm.iit_method,p_level);
   nm_debug.debug('iit_method_txt            : '||pi_rec_nlm.iit_method_txt,p_level);
   nm_debug.debug('iit_note                  : '||pi_rec_nlm.iit_note,p_level);
   nm_debug.debug('iit_no_of_units           : '||pi_rec_nlm.iit_no_of_units,p_level);
   nm_debug.debug('iit_options               : '||pi_rec_nlm.iit_options,p_level);
   nm_debug.debug('iit_options_txt           : '||pi_rec_nlm.iit_options_txt,p_level);
   nm_debug.debug('iit_oun_org_id_elec_board : '||pi_rec_nlm.iit_oun_org_id_elec_board,p_level);
   nm_debug.debug('iit_owner                 : '||pi_rec_nlm.iit_owner,p_level);
   nm_debug.debug('iit_owner_txt             : '||pi_rec_nlm.iit_owner_txt,p_level);
   nm_debug.debug('iit_peo_invent_by_id      : '||pi_rec_nlm.iit_peo_invent_by_id,p_level);
   nm_debug.debug('iit_photo                 : '||pi_rec_nlm.iit_photo,p_level);
   nm_debug.debug('iit_power                 : '||pi_rec_nlm.iit_power,p_level);
   nm_debug.debug('iit_prov_flag             : '||pi_rec_nlm.iit_prov_flag,p_level);
   nm_debug.debug('iit_rev_by                : '||pi_rec_nlm.iit_rev_by,p_level);
   nm_debug.debug('iit_rev_date              : '||pi_rec_nlm.iit_rev_date,p_level);
   nm_debug.debug('iit_type                  : '||pi_rec_nlm.iit_type,p_level);
   nm_debug.debug('iit_type_txt              : '||pi_rec_nlm.iit_type_txt,p_level);
   nm_debug.debug('iit_width                 : '||pi_rec_nlm.iit_width,p_level);
   nm_debug.debug('iit_xtra_char_1           : '||pi_rec_nlm.iit_xtra_char_1,p_level);
   nm_debug.debug('iit_xtra_date_1           : '||pi_rec_nlm.iit_xtra_date_1,p_level);
   nm_debug.debug('iit_xtra_domain_1         : '||pi_rec_nlm.iit_xtra_domain_1,p_level);
   nm_debug.debug('iit_xtra_domain_txt_1     : '||pi_rec_nlm.iit_xtra_domain_txt_1,p_level);
   nm_debug.debug('iit_xtra_number_1         : '||pi_rec_nlm.iit_xtra_number_1,p_level);
   nm_debug.debug('iit_x_sect                : '||pi_rec_nlm.iit_x_sect,p_level);
   nm_debug.debug('iit_det_xsp               : '||pi_rec_nlm.iit_det_xsp,p_level);
   nm_debug.debug('iit_offset                : '||pi_rec_nlm.iit_offset,p_level);
   nm_debug.debug('iit_x                     : '||pi_rec_nlm.iit_x,p_level);
   nm_debug.debug('iit_y                     : '||pi_rec_nlm.iit_y,p_level);
   nm_debug.debug('iit_z                     : '||pi_rec_nlm.iit_z,p_level);
   nm_debug.debug('iit_num_attrib96          : '||pi_rec_nlm.iit_num_attrib96,p_level);
   nm_debug.debug('iit_num_attrib97          : '||pi_rec_nlm.iit_num_attrib97,p_level);
   nm_debug.debug('iit_num_attrib98          : '||pi_rec_nlm.iit_num_attrib98,p_level);
   nm_debug.debug('iit_num_attrib99          : '||pi_rec_nlm.iit_num_attrib99,p_level);
   nm_debug.debug('iit_num_attrib100         : '||pi_rec_nlm.iit_num_attrib100,p_level);
   nm_debug.debug('iit_num_attrib101         : '||pi_rec_nlm.iit_num_attrib101,p_level);
   nm_debug.debug('iit_num_attrib102         : '||pi_rec_nlm.iit_num_attrib102,p_level);
   nm_debug.debug('iit_num_attrib103         : '||pi_rec_nlm.iit_num_attrib103,p_level);
   nm_debug.debug('iit_num_attrib104         : '||pi_rec_nlm.iit_num_attrib104,p_level);
   nm_debug.debug('iit_num_attrib105         : '||pi_rec_nlm.iit_num_attrib105,p_level);
   nm_debug.debug('iit_num_attrib106         : '||pi_rec_nlm.iit_num_attrib106,p_level);
   nm_debug.debug('iit_num_attrib107         : '||pi_rec_nlm.iit_num_attrib107,p_level);
   nm_debug.debug('iit_num_attrib108         : '||pi_rec_nlm.iit_num_attrib108,p_level);
   nm_debug.debug('iit_num_attrib109         : '||pi_rec_nlm.iit_num_attrib109,p_level);
   nm_debug.debug('iit_num_attrib110         : '||pi_rec_nlm.iit_num_attrib110,p_level);
   nm_debug.debug('iit_num_attrib111         : '||pi_rec_nlm.iit_num_attrib111,p_level);
   nm_debug.debug('iit_num_attrib112         : '||pi_rec_nlm.iit_num_attrib112,p_level);
   nm_debug.debug('iit_num_attrib113         : '||pi_rec_nlm.iit_num_attrib113,p_level);
   nm_debug.debug('iit_num_attrib114         : '||pi_rec_nlm.iit_num_attrib114,p_level);
   nm_debug.debug('iit_num_attrib115         : '||pi_rec_nlm.iit_num_attrib115,p_level);
   nm_debug.debug('nlm_x_sect                : '||pi_rec_nlm.nlm_x_sect,p_level);
   nm_debug.debug('nlm_invent_date           : '||pi_rec_nlm.nlm_invent_date,p_level);
   nm_debug.debug('nlm_primary_key           : '||pi_rec_nlm.nlm_primary_key,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nlm');
--
END debug_nlm;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nlt (pi_rec_nlt nm_linear_types%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nlt');
--
   nm_debug.debug('nlt_id         : '||pi_rec_nlt.nlt_id,p_level);
   nm_debug.debug('nlt_nt_type    : '||pi_rec_nlt.nlt_nt_type,p_level);
   nm_debug.debug('nlt_gty_type   : '||pi_rec_nlt.nlt_gty_type,p_level);
   nm_debug.debug('nlt_descr      : '||pi_rec_nlt.nlt_descr,p_level);
   nm_debug.debug('nlt_seq_no     : '||pi_rec_nlt.nlt_seq_no,p_level);
   nm_debug.debug('nlt_units      : '||pi_rec_nlt.nlt_units,p_level);
   nm_debug.debug('nlt_start_date : '||pi_rec_nlt.nlt_start_date,p_level);
   nm_debug.debug('nlt_end_date   : '||pi_rec_nlt.nlt_end_date,p_level);
   nm_debug.debug('nlt_admin_type : '||pi_rec_nlt.nlt_admin_type,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nlt');
--
END debug_nlt;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nlb (pi_rec_nlb nm_load_batches%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nlb');
--
   nm_debug.debug('nlb_batch_no      : '||pi_rec_nlb.nlb_batch_no,p_level);
   nm_debug.debug('nlb_nlf_id        : '||pi_rec_nlb.nlb_nlf_id,p_level);
   nm_debug.debug('nlb_filename      : '||pi_rec_nlb.nlb_filename,p_level);
   nm_debug.debug('nlb_record_count  : '||pi_rec_nlb.nlb_record_count,p_level);
   nm_debug.debug('nlb_date_created  : '||pi_rec_nlb.nlb_date_created,p_level);
   nm_debug.debug('nlb_date_modified : '||pi_rec_nlb.nlb_date_modified,p_level);
   nm_debug.debug('nlb_modified_by   : '||pi_rec_nlb.nlb_modified_by,p_level);
   nm_debug.debug('nlb_created_by    : '||pi_rec_nlb.nlb_created_by,p_level);
   nm_debug.debug('nlb_batch_source  : '||pi_rec_nlb.nlb_batch_source,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nlb');
--
END debug_nlb;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nlbs (pi_rec_nlbs nm_load_batch_status%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nlbs');
--
   nm_debug.debug('nlbs_nlb_batch_no : '||pi_rec_nlbs.nlbs_nlb_batch_no,p_level);
   nm_debug.debug('nlbs_record_no    : '||pi_rec_nlbs.nlbs_record_no,p_level);
   nm_debug.debug('nlbs_status       : '||pi_rec_nlbs.nlbs_status,p_level);
   nm_debug.debug('nlbs_text         : '||pi_rec_nlbs.nlbs_text,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nlbs');
--
END debug_nlbs;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nld (pi_rec_nld nm_load_destinations%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nld');
--
   nm_debug.debug('nld_id               : '||pi_rec_nld.nld_id,p_level);
   nm_debug.debug('nld_table_name       : '||pi_rec_nld.nld_table_name,p_level);
   nm_debug.debug('nld_table_short_name : '||pi_rec_nld.nld_table_short_name,p_level);
   nm_debug.debug('nld_insert_proc      : '||pi_rec_nld.nld_insert_proc,p_level);
   nm_debug.debug('nld_validation_proc  : '||pi_rec_nld.nld_validation_proc,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nld');
--
END debug_nld;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nldd (pi_rec_nldd nm_load_destination_defaults%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nldd');
--
   nm_debug.debug('nldd_nld_id      : '||pi_rec_nldd.nldd_nld_id,p_level);
   nm_debug.debug('nldd_column_name : '||pi_rec_nldd.nldd_column_name,p_level);
   nm_debug.debug('nldd_value       : '||pi_rec_nldd.nldd_value,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nldd');
--
END debug_nldd;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nlf (pi_rec_nlf nm_load_files%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nlf');
--
   nm_debug.debug('nlf_id               : '||pi_rec_nlf.nlf_id,p_level);
   nm_debug.debug('nlf_unique           : '||pi_rec_nlf.nlf_unique,p_level);
   nm_debug.debug('nlf_descr            : '||pi_rec_nlf.nlf_descr,p_level);
   nm_debug.debug('nlf_path             : '||pi_rec_nlf.nlf_path,p_level);
   nm_debug.debug('nlf_delimiter        : '||pi_rec_nlf.nlf_delimiter,p_level);
   nm_debug.debug('nlf_date_format_mask : '||pi_rec_nlf.nlf_date_format_mask,p_level);
   nm_debug.debug('nlf_holding_table    : '||pi_rec_nlf.nlf_holding_table,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nlf');
--
END debug_nlf;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nlfc (pi_rec_nlfc nm_load_file_cols%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nlfc');
--
   nm_debug.debug('nlfc_nlf_id           : '||pi_rec_nlfc.nlfc_nlf_id,p_level);
   nm_debug.debug('nlfc_seq_no           : '||pi_rec_nlfc.nlfc_seq_no,p_level);
   nm_debug.debug('nlfc_holding_col      : '||pi_rec_nlfc.nlfc_holding_col,p_level);
   nm_debug.debug('nlfc_datatype         : '||pi_rec_nlfc.nlfc_datatype,p_level);
   nm_debug.debug('nlfc_varchar_size     : '||pi_rec_nlfc.nlfc_varchar_size,p_level);
   nm_debug.debug('nlfc_mandatory        : '||pi_rec_nlfc.nlfc_mandatory,p_level);
   nm_debug.debug('nlfc_date_format_mask : '||pi_rec_nlfc.nlfc_date_format_mask,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nlfc');
--
END debug_nlfc;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nlcd (pi_rec_nlcd nm_load_file_col_destinations%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nlcd');
--
   nm_debug.debug('nlcd_nlf_id     : '||pi_rec_nlcd.nlcd_nlf_id,p_level);
   nm_debug.debug('nlcd_nld_id     : '||pi_rec_nlcd.nlcd_nld_id,p_level);
   nm_debug.debug('nlcd_seq_no     : '||pi_rec_nlcd.nlcd_seq_no,p_level);
   nm_debug.debug('nlcd_dest_col   : '||pi_rec_nlcd.nlcd_dest_col,p_level);
   nm_debug.debug('nlcd_source_col : '||pi_rec_nlcd.nlcd_source_col,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nlcd');
--
END debug_nlcd;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nlfd (pi_rec_nlfd nm_load_file_destinations%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nlfd');
--
   nm_debug.debug('nlfd_nlf_id : '||pi_rec_nlfd.nlfd_nlf_id,p_level);
   nm_debug.debug('nlfd_nld_id : '||pi_rec_nlfd.nlfd_nld_id,p_level);
   nm_debug.debug('nlfd_seq    : '||pi_rec_nlfd.nlfd_seq,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nlfd');
--
END debug_nlfd;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmg (pi_rec_nmg nm_mail_groups%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmg');
--
   nm_debug.debug('nmg_id   : '||pi_rec_nmg.nmg_id,p_level);
   nm_debug.debug('nmg_name : '||pi_rec_nmg.nmg_name,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmg');
--
END debug_nmg;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmgm (pi_rec_nmgm nm_mail_group_membership%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmgm');
--
   nm_debug.debug('nmgm_nmg_id : '||pi_rec_nmgm.nmgm_nmg_id,p_level);
   nm_debug.debug('nmgm_nmu_id : '||pi_rec_nmgm.nmgm_nmu_id,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmgm');
--
END debug_nmgm;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmm (pi_rec_nmm nm_mail_message%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmm');
--
   nm_debug.debug('nmm_id            : '||pi_rec_nmm.nmm_id,p_level);
   nm_debug.debug('nmm_subject       : '||pi_rec_nmm.nmm_subject,p_level);
   nm_debug.debug('nmm_status        : '||pi_rec_nmm.nmm_status,p_level);
   nm_debug.debug('nmm_from_nmu_id   : '||pi_rec_nmm.nmm_from_nmu_id,p_level);
   nm_debug.debug('nmm_html          : '||pi_rec_nmm.nmm_html,p_level);
   nm_debug.debug('nmm_date_created  : '||pi_rec_nmm.nmm_date_created,p_level);
   nm_debug.debug('nmm_date_modified : '||pi_rec_nmm.nmm_date_modified,p_level);
   nm_debug.debug('nmm_modified_by   : '||pi_rec_nmm.nmm_modified_by,p_level);
   nm_debug.debug('nmm_created_by    : '||pi_rec_nmm.nmm_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmm');
--
END debug_nmm;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmmr (pi_rec_nmmr nm_mail_message_recipients%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmmr');
--
   nm_debug.debug('nmmr_nmm_id    : '||pi_rec_nmmr.nmmr_nmm_id,p_level);
   nm_debug.debug('nmmr_rcpt_id   : '||pi_rec_nmmr.nmmr_rcpt_id,p_level);
   nm_debug.debug('nmmr_rcpt_type : '||pi_rec_nmmr.nmmr_rcpt_type,p_level);
   nm_debug.debug('nmmr_send_type : '||pi_rec_nmmr.nmmr_send_type,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmmr');
--
END debug_nmmr;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmmt (pi_rec_nmmt nm_mail_message_text%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmmt');
--
   nm_debug.debug('nmmt_nmm_id    : '||pi_rec_nmmt.nmmt_nmm_id,p_level);
   nm_debug.debug('nmmt_line_id   : '||pi_rec_nmmt.nmmt_line_id,p_level);
   nm_debug.debug('nmmt_text_line : '||pi_rec_nmmt.nmmt_text_line,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmmt');
--
END debug_nmmt;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmu (pi_rec_nmu nm_mail_users%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmu');
--
   nm_debug.debug('nmu_id            : '||pi_rec_nmu.nmu_id,p_level);
   nm_debug.debug('nmu_name          : '||pi_rec_nmu.nmu_name,p_level);
   nm_debug.debug('nmu_email_address : '||pi_rec_nmu.nmu_email_address,p_level);
   nm_debug.debug('nmu_hus_user_id   : '||pi_rec_nmu.nmu_hus_user_id,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmu');
--
END debug_nmu;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nm (pi_rec_nm nm_members%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nm');
--
   nm_debug.debug('nm_ne_id_in      : '||pi_rec_nm.nm_ne_id_in,p_level);
   nm_debug.debug('nm_ne_id_of      : '||pi_rec_nm.nm_ne_id_of,p_level);
   nm_debug.debug('nm_type          : '||pi_rec_nm.nm_type,p_level);
   nm_debug.debug('nm_obj_type      : '||pi_rec_nm.nm_obj_type,p_level);
   nm_debug.debug('nm_begin_mp      : '||pi_rec_nm.nm_begin_mp,p_level);
   nm_debug.debug('nm_start_date    : '||pi_rec_nm.nm_start_date,p_level);
   nm_debug.debug('nm_end_date      : '||pi_rec_nm.nm_end_date,p_level);
   nm_debug.debug('nm_end_mp        : '||pi_rec_nm.nm_end_mp,p_level);
   nm_debug.debug('nm_slk           : '||pi_rec_nm.nm_slk,p_level);
   nm_debug.debug('nm_cardinality   : '||pi_rec_nm.nm_cardinality,p_level);
   nm_debug.debug('nm_admin_unit    : '||pi_rec_nm.nm_admin_unit,p_level);
   nm_debug.debug('nm_date_created  : '||pi_rec_nm.nm_date_created,p_level);
   nm_debug.debug('nm_date_modified : '||pi_rec_nm.nm_date_modified,p_level);
   nm_debug.debug('nm_modified_by   : '||pi_rec_nm.nm_modified_by,p_level);
   nm_debug.debug('nm_created_by    : '||pi_rec_nm.nm_created_by,p_level);
   nm_debug.debug('nm_seq_no        : '||pi_rec_nm.nm_seq_no,p_level);
   nm_debug.debug('nm_seg_no        : '||pi_rec_nm.nm_seg_no,p_level);
   nm_debug.debug('nm_true          : '||pi_rec_nm.nm_true,p_level);
   nm_debug.debug('nm_end_slk       : '||pi_rec_nm.nm_end_slk,p_level);
   nm_debug.debug('nm_end_true      : '||pi_rec_nm.nm_end_true,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nm');
--
END debug_nm;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nm_all (pi_rec_nm_all nm_members_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nm_all');
--
   nm_debug.debug('nm_ne_id_in      : '||pi_rec_nm_all.nm_ne_id_in,p_level);
   nm_debug.debug('nm_ne_id_of      : '||pi_rec_nm_all.nm_ne_id_of,p_level);
   nm_debug.debug('nm_type          : '||pi_rec_nm_all.nm_type,p_level);
   nm_debug.debug('nm_obj_type      : '||pi_rec_nm_all.nm_obj_type,p_level);
   nm_debug.debug('nm_begin_mp      : '||pi_rec_nm_all.nm_begin_mp,p_level);
   nm_debug.debug('nm_start_date    : '||pi_rec_nm_all.nm_start_date,p_level);
   nm_debug.debug('nm_end_date      : '||pi_rec_nm_all.nm_end_date,p_level);
   nm_debug.debug('nm_end_mp        : '||pi_rec_nm_all.nm_end_mp,p_level);
   nm_debug.debug('nm_slk           : '||pi_rec_nm_all.nm_slk,p_level);
   nm_debug.debug('nm_cardinality   : '||pi_rec_nm_all.nm_cardinality,p_level);
   nm_debug.debug('nm_admin_unit    : '||pi_rec_nm_all.nm_admin_unit,p_level);
   nm_debug.debug('nm_date_created  : '||pi_rec_nm_all.nm_date_created,p_level);
   nm_debug.debug('nm_date_modified : '||pi_rec_nm_all.nm_date_modified,p_level);
   nm_debug.debug('nm_modified_by   : '||pi_rec_nm_all.nm_modified_by,p_level);
   nm_debug.debug('nm_created_by    : '||pi_rec_nm_all.nm_created_by,p_level);
   nm_debug.debug('nm_seq_no        : '||pi_rec_nm_all.nm_seq_no,p_level);
   nm_debug.debug('nm_seg_no        : '||pi_rec_nm_all.nm_seg_no,p_level);
   nm_debug.debug('nm_true          : '||pi_rec_nm_all.nm_true,p_level);
   nm_debug.debug('nm_end_slk       : '||pi_rec_nm_all.nm_end_slk,p_level);
   nm_debug.debug('nm_end_true      : '||pi_rec_nm_all.nm_end_true,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nm_all');
--
END debug_nm_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmh (pi_rec_nmh nm_member_history%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmh');
--
   nm_debug.debug('nmh_nm_ne_id_in     : '||pi_rec_nmh.nmh_nm_ne_id_in,p_level);
   nm_debug.debug('nmh_nm_ne_id_of_old : '||pi_rec_nmh.nmh_nm_ne_id_of_old,p_level);
   nm_debug.debug('nmh_nm_ne_id_of_new : '||pi_rec_nmh.nmh_nm_ne_id_of_new,p_level);
   nm_debug.debug('nmh_nm_begin_mp     : '||pi_rec_nmh.nmh_nm_begin_mp,p_level);
   nm_debug.debug('nmh_nm_start_date   : '||pi_rec_nmh.nmh_nm_start_date,p_level);
   nm_debug.debug('nmh_nm_type         : '||pi_rec_nmh.nmh_nm_type,p_level);
   nm_debug.debug('nmh_nm_obj_type     : '||pi_rec_nmh.nmh_nm_obj_type,p_level);
   nm_debug.debug('nmh_nm_end_date     : '||pi_rec_nmh.nmh_nm_end_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmh');
--
END debug_nmh;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nda (pi_rec_nda nm_mrg_default_query_attribs%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nda');
--
   nm_debug.debug('nda_seq_no         : '||pi_rec_nda.nda_seq_no,p_level);
   nm_debug.debug('nda_attrib_name    : '||pi_rec_nda.nda_attrib_name,p_level);
   nm_debug.debug('nda_date_created   : '||pi_rec_nda.nda_date_created,p_level);
   nm_debug.debug('nda_date_modified  : '||pi_rec_nda.nda_date_modified,p_level);
   nm_debug.debug('nda_modified_by    : '||pi_rec_nda.nda_modified_by,p_level);
   nm_debug.debug('nda_created_by     : '||pi_rec_nda.nda_created_by,p_level);
   nm_debug.debug('nda_itb_banding_id : '||pi_rec_nda.nda_itb_banding_id,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nda');
--
END debug_nda;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ndq (pi_rec_ndq nm_mrg_default_query_types%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ndq');
--
   nm_debug.debug('ndq_seq_no        : '||pi_rec_ndq.ndq_seq_no,p_level);
   nm_debug.debug('ndq_inv_type      : '||pi_rec_ndq.ndq_inv_type,p_level);
   nm_debug.debug('ndq_x_sect        : '||pi_rec_ndq.ndq_x_sect,p_level);
   nm_debug.debug('ndq_date_created  : '||pi_rec_ndq.ndq_date_created,p_level);
   nm_debug.debug('ndq_date_modified : '||pi_rec_ndq.ndq_date_modified,p_level);
   nm_debug.debug('ndq_modified_by   : '||pi_rec_ndq.ndq_modified_by,p_level);
   nm_debug.debug('ndq_created_by    : '||pi_rec_ndq.ndq_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ndq');
--
END debug_ndq;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ndq_all (pi_rec_ndq_all nm_mrg_default_query_types_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ndq_all');
--
   nm_debug.debug('ndq_seq_no        : '||pi_rec_ndq_all.ndq_seq_no,p_level);
   nm_debug.debug('ndq_inv_type      : '||pi_rec_ndq_all.ndq_inv_type,p_level);
   nm_debug.debug('ndq_x_sect        : '||pi_rec_ndq_all.ndq_x_sect,p_level);
   nm_debug.debug('ndq_date_created  : '||pi_rec_ndq_all.ndq_date_created,p_level);
   nm_debug.debug('ndq_date_modified : '||pi_rec_ndq_all.ndq_date_modified,p_level);
   nm_debug.debug('ndq_modified_by   : '||pi_rec_ndq_all.ndq_modified_by,p_level);
   nm_debug.debug('ndq_created_by    : '||pi_rec_ndq_all.ndq_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ndq_all');
--
END debug_ndq_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmid (pi_rec_nmid nm_mrg_inv_derivation%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmid');
--
   nm_debug.debug('nmid_nmq_id      : '||pi_rec_nmid.nmid_nmq_id,p_level);
   nm_debug.debug('nmid_inv_type    : '||pi_rec_nmid.nmid_inv_type,p_level);
   nm_debug.debug('nmid_attrib_name : '||pi_rec_nmid.nmid_attrib_name,p_level);
   nm_debug.debug('nmid_derivation  : '||pi_rec_nmid.nmid_derivation,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmid');
--
END debug_nmid;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmc (pi_rec_nmc nm_mrg_output_cols%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmc');
--
   nm_debug.debug('nmc_nmf_id        : '||pi_rec_nmc.nmc_nmf_id,p_level);
   nm_debug.debug('nmc_seq_no        : '||pi_rec_nmc.nmc_seq_no,p_level);
   nm_debug.debug('nmc_length        : '||pi_rec_nmc.nmc_length,p_level);
   nm_debug.debug('nmc_column_name   : '||pi_rec_nmc.nmc_column_name,p_level);
   nm_debug.debug('nmc_sec_or_val    : '||pi_rec_nmc.nmc_sec_or_val,p_level);
   nm_debug.debug('nmc_data_type     : '||pi_rec_nmc.nmc_data_type,p_level);
   nm_debug.debug('nmc_pad           : '||pi_rec_nmc.nmc_pad,p_level);
   nm_debug.debug('nmc_dec_places    : '||pi_rec_nmc.nmc_dec_places,p_level);
   nm_debug.debug('nmc_disp_dp       : '||pi_rec_nmc.nmc_disp_dp,p_level);
   nm_debug.debug('nmc_description   : '||pi_rec_nmc.nmc_description,p_level);
   nm_debug.debug('nmc_view_col_name : '||pi_rec_nmc.nmc_view_col_name,p_level);
   nm_debug.debug('nmc_order_by      : '||pi_rec_nmc.nmc_order_by,p_level);
   nm_debug.debug('nmc_order_by_ord  : '||pi_rec_nmc.nmc_order_by_ord,p_level);
   nm_debug.debug('nmc_display_sign  : '||pi_rec_nmc.nmc_display_sign,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmc');
--
END debug_nmc;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmcd (pi_rec_nmcd nm_mrg_output_col_decode%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmcd');
--
   nm_debug.debug('nmcd_nmf_id     : '||pi_rec_nmcd.nmcd_nmf_id,p_level);
   nm_debug.debug('nmcd_nmc_seq_no : '||pi_rec_nmcd.nmcd_nmc_seq_no,p_level);
   nm_debug.debug('nmcd_from_value : '||pi_rec_nmcd.nmcd_from_value,p_level);
   nm_debug.debug('nmcd_to_value   : '||pi_rec_nmcd.nmcd_to_value,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmcd');
--
END debug_nmcd;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmf (pi_rec_nmf nm_mrg_output_file%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmf');
--
   nm_debug.debug('nmf_id                      : '||pi_rec_nmf.nmf_id,p_level);
   nm_debug.debug('nmf_nmq_id                  : '||pi_rec_nmf.nmf_nmq_id,p_level);
   nm_debug.debug('nmf_filename                : '||pi_rec_nmf.nmf_filename,p_level);
   nm_debug.debug('nmf_file_path               : '||pi_rec_nmf.nmf_file_path,p_level);
   nm_debug.debug('nmf_route                   : '||pi_rec_nmf.nmf_route,p_level);
   nm_debug.debug('nmf_datum                   : '||pi_rec_nmf.nmf_datum,p_level);
   nm_debug.debug('nmf_include_header          : '||pi_rec_nmf.nmf_include_header,p_level);
   nm_debug.debug('nmf_include_footer          : '||pi_rec_nmf.nmf_include_footer,p_level);
   nm_debug.debug('nmf_date_created            : '||pi_rec_nmf.nmf_date_created,p_level);
   nm_debug.debug('nmf_date_modified           : '||pi_rec_nmf.nmf_date_modified,p_level);
   nm_debug.debug('nmf_modified_by             : '||pi_rec_nmf.nmf_modified_by,p_level);
   nm_debug.debug('nmf_created_by              : '||pi_rec_nmf.nmf_created_by,p_level);
   nm_debug.debug('nmf_csv                     : '||pi_rec_nmf.nmf_csv,p_level);
   nm_debug.debug('nmf_sep_char                : '||pi_rec_nmf.nmf_sep_char,p_level);
   nm_debug.debug('nmf_additional_where        : '||pi_rec_nmf.nmf_additional_where,p_level);
   nm_debug.debug('nmf_varchar_rpad            : '||pi_rec_nmf.nmf_varchar_rpad,p_level);
   nm_debug.debug('nmf_number_lpad             : '||pi_rec_nmf.nmf_number_lpad,p_level);
   nm_debug.debug('nmf_date_format             : '||pi_rec_nmf.nmf_date_format,p_level);
   nm_debug.debug('nmf_description             : '||pi_rec_nmf.nmf_description,p_level);
   nm_debug.debug('nmf_template                : '||pi_rec_nmf.nmf_template,p_level);
   nm_debug.debug('nmf_append_merge_au_to_path : '||pi_rec_nmf.nmf_append_merge_au_to_path,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmf');
--
END debug_nmf;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmq (pi_rec_nmq nm_mrg_query%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmq');
--
   nm_debug.debug('nmq_id                    : '||pi_rec_nmq.nmq_id,p_level);
   nm_debug.debug('nmq_unique                : '||pi_rec_nmq.nmq_unique,p_level);
   nm_debug.debug('nmq_descr                 : '||pi_rec_nmq.nmq_descr,p_level);
   nm_debug.debug('nmq_inner_outer_join      : '||pi_rec_nmq.nmq_inner_outer_join,p_level);
   nm_debug.debug('nmq_date_created          : '||pi_rec_nmq.nmq_date_created,p_level);
   nm_debug.debug('nmq_date_modified         : '||pi_rec_nmq.nmq_date_modified,p_level);
   nm_debug.debug('nmq_modified_by           : '||pi_rec_nmq.nmq_modified_by,p_level);
   nm_debug.debug('nmq_created_by            : '||pi_rec_nmq.nmq_created_by,p_level);
   nm_debug.debug('nmq_inv_type_x_sect_count : '||pi_rec_nmq.nmq_inv_type_x_sect_count,p_level);
   nm_debug.debug('nmq_transient_query       : '||pi_rec_nmq.nmq_transient_query,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmq');
--
END debug_nmq;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmq_all (pi_rec_nmq_all nm_mrg_query_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmq_all');
--
   nm_debug.debug('nmq_id                    : '||pi_rec_nmq_all.nmq_id,p_level);
   nm_debug.debug('nmq_unique                : '||pi_rec_nmq_all.nmq_unique,p_level);
   nm_debug.debug('nmq_descr                 : '||pi_rec_nmq_all.nmq_descr,p_level);
   nm_debug.debug('nmq_inner_outer_join      : '||pi_rec_nmq_all.nmq_inner_outer_join,p_level);
   nm_debug.debug('nmq_date_created          : '||pi_rec_nmq_all.nmq_date_created,p_level);
   nm_debug.debug('nmq_date_modified         : '||pi_rec_nmq_all.nmq_date_modified,p_level);
   nm_debug.debug('nmq_modified_by           : '||pi_rec_nmq_all.nmq_modified_by,p_level);
   nm_debug.debug('nmq_created_by            : '||pi_rec_nmq_all.nmq_created_by,p_level);
   nm_debug.debug('nmq_inv_type_x_sect_count : '||pi_rec_nmq_all.nmq_inv_type_x_sect_count,p_level);
   nm_debug.debug('nmq_transient_query       : '||pi_rec_nmq_all.nmq_transient_query,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmq_all');
--
END debug_nmq_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmqa (pi_rec_nmqa nm_mrg_query_attribs%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmqa');
--
   nm_debug.debug('nqa_nmq_id         : '||pi_rec_nmqa.nqa_nmq_id,p_level);
   nm_debug.debug('nqa_nqt_seq_no     : '||pi_rec_nmqa.nqa_nqt_seq_no,p_level);
   nm_debug.debug('nqa_attrib_name    : '||pi_rec_nmqa.nqa_attrib_name,p_level);
   nm_debug.debug('nqa_condition      : '||pi_rec_nmqa.nqa_condition,p_level);
   nm_debug.debug('nqa_date_created   : '||pi_rec_nmqa.nqa_date_created,p_level);
   nm_debug.debug('nqa_date_modified  : '||pi_rec_nmqa.nqa_date_modified,p_level);
   nm_debug.debug('nqa_modified_by    : '||pi_rec_nmqa.nqa_modified_by,p_level);
   nm_debug.debug('nqa_created_by     : '||pi_rec_nmqa.nqa_created_by,p_level);
   nm_debug.debug('nqa_itb_banding_id : '||pi_rec_nmqa.nqa_itb_banding_id,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmqa');
--
END debug_nmqa;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmqr (pi_rec_nmqr nm_mrg_query_results%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmqr');
--
   nm_debug.debug('nqr_mrg_job_id                : '||pi_rec_nmqr.nqr_mrg_job_id,p_level);
   nm_debug.debug('nqr_nmq_id                    : '||pi_rec_nmqr.nqr_nmq_id,p_level);
   nm_debug.debug('nqr_source_id                 : '||pi_rec_nmqr.nqr_source_id,p_level);
   nm_debug.debug('nqr_source                    : '||pi_rec_nmqr.nqr_source,p_level);
   nm_debug.debug('nqr_description               : '||pi_rec_nmqr.nqr_description,p_level);
   nm_debug.debug('nqr_date_created              : '||pi_rec_nmqr.nqr_date_created,p_level);
   nm_debug.debug('nqr_date_modified             : '||pi_rec_nmqr.nqr_date_modified,p_level);
   nm_debug.debug('nqr_modified_by               : '||pi_rec_nmqr.nqr_modified_by,p_level);
   nm_debug.debug('nqr_created_by                : '||pi_rec_nmqr.nqr_created_by,p_level);
   nm_debug.debug('nqr_mrg_section_members_count : '||pi_rec_nmqr.nqr_mrg_section_members_count,p_level);
   nm_debug.debug('nqr_admin_unit                : '||pi_rec_nmqr.nqr_admin_unit,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmqr');
--
END debug_nmqr;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmqr_all (pi_rec_nmqr_all nm_mrg_query_results_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmqr_all');
--
   nm_debug.debug('nqr_mrg_job_id                : '||pi_rec_nmqr_all.nqr_mrg_job_id,p_level);
   nm_debug.debug('nqr_nmq_id                    : '||pi_rec_nmqr_all.nqr_nmq_id,p_level);
   nm_debug.debug('nqr_source_id                 : '||pi_rec_nmqr_all.nqr_source_id,p_level);
   nm_debug.debug('nqr_source                    : '||pi_rec_nmqr_all.nqr_source,p_level);
   nm_debug.debug('nqr_description               : '||pi_rec_nmqr_all.nqr_description,p_level);
   nm_debug.debug('nqr_date_created              : '||pi_rec_nmqr_all.nqr_date_created,p_level);
   nm_debug.debug('nqr_date_modified             : '||pi_rec_nmqr_all.nqr_date_modified,p_level);
   nm_debug.debug('nqr_modified_by               : '||pi_rec_nmqr_all.nqr_modified_by,p_level);
   nm_debug.debug('nqr_created_by                : '||pi_rec_nmqr_all.nqr_created_by,p_level);
   nm_debug.debug('nqr_mrg_section_members_count : '||pi_rec_nmqr_all.nqr_mrg_section_members_count,p_level);
   nm_debug.debug('nqr_admin_unit                : '||pi_rec_nmqr_all.nqr_admin_unit,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmqr_all');
--
END debug_nmqr_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nqro (pi_rec_nqro nm_mrg_query_roles%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nqro');
--
   nm_debug.debug('nqro_nmq_id : '||pi_rec_nqro.nqro_nmq_id,p_level);
   nm_debug.debug('nqro_role   : '||pi_rec_nqro.nqro_role,p_level);
   nm_debug.debug('nqro_mode   : '||pi_rec_nqro.nqro_mode,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nqro');
--
END debug_nqro;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmqt (pi_rec_nmqt nm_mrg_query_types%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmqt');
--
   nm_debug.debug('nqt_nmq_id        : '||pi_rec_nmqt.nqt_nmq_id,p_level);
   nm_debug.debug('nqt_seq_no        : '||pi_rec_nmqt.nqt_seq_no,p_level);
   nm_debug.debug('nqt_inv_type      : '||pi_rec_nmqt.nqt_inv_type,p_level);
   nm_debug.debug('nqt_x_sect        : '||pi_rec_nmqt.nqt_x_sect,p_level);
   nm_debug.debug('nqt_date_created  : '||pi_rec_nmqt.nqt_date_created,p_level);
   nm_debug.debug('nqt_date_modified : '||pi_rec_nmqt.nqt_date_modified,p_level);
   nm_debug.debug('nqt_modified_by   : '||pi_rec_nmqt.nqt_modified_by,p_level);
   nm_debug.debug('nqt_created_by    : '||pi_rec_nmqt.nqt_created_by,p_level);
   nm_debug.debug('nqt_default       : '||pi_rec_nmqt.nqt_default,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmqt');
--
END debug_nmqt;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmqt_all (pi_rec_nmqt_all nm_mrg_query_types_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmqt_all');
--
   nm_debug.debug('nqt_nmq_id        : '||pi_rec_nmqt_all.nqt_nmq_id,p_level);
   nm_debug.debug('nqt_seq_no        : '||pi_rec_nmqt_all.nqt_seq_no,p_level);
   nm_debug.debug('nqt_inv_type      : '||pi_rec_nmqt_all.nqt_inv_type,p_level);
   nm_debug.debug('nqt_x_sect        : '||pi_rec_nmqt_all.nqt_x_sect,p_level);
   nm_debug.debug('nqt_date_created  : '||pi_rec_nmqt_all.nqt_date_created,p_level);
   nm_debug.debug('nqt_date_modified : '||pi_rec_nmqt_all.nqt_date_modified,p_level);
   nm_debug.debug('nqt_modified_by   : '||pi_rec_nmqt_all.nqt_modified_by,p_level);
   nm_debug.debug('nqt_created_by    : '||pi_rec_nmqt_all.nqt_created_by,p_level);
   nm_debug.debug('nqt_default       : '||pi_rec_nmqt_all.nqt_default,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmqt_all');
--
END debug_nmqt_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmqv (pi_rec_nmqv nm_mrg_query_values%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmqv');
--
   nm_debug.debug('nqv_nmq_id        : '||pi_rec_nmqv.nqv_nmq_id,p_level);
   nm_debug.debug('nqv_nqt_seq_no    : '||pi_rec_nmqv.nqv_nqt_seq_no,p_level);
   nm_debug.debug('nqv_attrib_name   : '||pi_rec_nmqv.nqv_attrib_name,p_level);
   nm_debug.debug('nqv_sequence      : '||pi_rec_nmqv.nqv_sequence,p_level);
   nm_debug.debug('nqv_value         : '||pi_rec_nmqv.nqv_value,p_level);
   nm_debug.debug('nqv_date_created  : '||pi_rec_nmqv.nqv_date_created,p_level);
   nm_debug.debug('nqv_date_modified : '||pi_rec_nmqv.nqv_date_modified,p_level);
   nm_debug.debug('nqv_modified_by   : '||pi_rec_nmqv.nqv_modified_by,p_level);
   nm_debug.debug('nqv_created_by    : '||pi_rec_nmqv.nqv_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmqv');
--
END debug_nmqv;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nms (pi_rec_nms nm_mrg_sections%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nms');
--
   nm_debug.debug('nms_mrg_job_id     : '||pi_rec_nms.nms_mrg_job_id,p_level);
   nm_debug.debug('nms_mrg_section_id : '||pi_rec_nms.nms_mrg_section_id,p_level);
   nm_debug.debug('nms_offset_ne_id   : '||pi_rec_nms.nms_offset_ne_id,p_level);
   nm_debug.debug('nms_begin_offset   : '||pi_rec_nms.nms_begin_offset,p_level);
   nm_debug.debug('nms_end_offset     : '||pi_rec_nms.nms_end_offset,p_level);
   nm_debug.debug('nms_ne_id_first    : '||pi_rec_nms.nms_ne_id_first,p_level);
   nm_debug.debug('nms_begin_mp_first : '||pi_rec_nms.nms_begin_mp_first,p_level);
   nm_debug.debug('nms_ne_id_last     : '||pi_rec_nms.nms_ne_id_last,p_level);
   nm_debug.debug('nms_end_mp_last    : '||pi_rec_nms.nms_end_mp_last,p_level);
   nm_debug.debug('nms_in_results     : '||pi_rec_nms.nms_in_results,p_level);
   nm_debug.debug('nms_orig_sect_id   : '||pi_rec_nms.nms_orig_sect_id,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nms');
--
END debug_nms;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nms_all (pi_rec_nms_all nm_mrg_sections_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nms_all');
--
   nm_debug.debug('nms_mrg_job_id     : '||pi_rec_nms_all.nms_mrg_job_id,p_level);
   nm_debug.debug('nms_mrg_section_id : '||pi_rec_nms_all.nms_mrg_section_id,p_level);
   nm_debug.debug('nms_offset_ne_id   : '||pi_rec_nms_all.nms_offset_ne_id,p_level);
   nm_debug.debug('nms_begin_offset   : '||pi_rec_nms_all.nms_begin_offset,p_level);
   nm_debug.debug('nms_end_offset     : '||pi_rec_nms_all.nms_end_offset,p_level);
   nm_debug.debug('nms_ne_id_first    : '||pi_rec_nms_all.nms_ne_id_first,p_level);
   nm_debug.debug('nms_begin_mp_first : '||pi_rec_nms_all.nms_begin_mp_first,p_level);
   nm_debug.debug('nms_ne_id_last     : '||pi_rec_nms_all.nms_ne_id_last,p_level);
   nm_debug.debug('nms_end_mp_last    : '||pi_rec_nms_all.nms_end_mp_last,p_level);
   nm_debug.debug('nms_in_results     : '||pi_rec_nms_all.nms_in_results,p_level);
   nm_debug.debug('nms_orig_sect_id   : '||pi_rec_nms_all.nms_orig_sect_id,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nms_all');
--
END debug_nms_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nsv (pi_rec_nsv nm_mrg_section_inv_values%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nsv');
--
   nm_debug.debug('nsv_mrg_job_id  : '||pi_rec_nsv.nsv_mrg_job_id,p_level);
   nm_debug.debug('nsv_value_id    : '||pi_rec_nsv.nsv_value_id,p_level);
   nm_debug.debug('nsv_inv_type    : '||pi_rec_nsv.nsv_inv_type,p_level);
   nm_debug.debug('nsv_x_sect      : '||pi_rec_nsv.nsv_x_sect,p_level);
   nm_debug.debug('nsv_pnt_or_cont : '||pi_rec_nsv.nsv_pnt_or_cont,p_level);
   nm_debug.debug('nsv_attrib1     : '||pi_rec_nsv.nsv_attrib1,p_level);
   nm_debug.debug('nsv_attrib2     : '||pi_rec_nsv.nsv_attrib2,p_level);
   nm_debug.debug('nsv_attrib3     : '||pi_rec_nsv.nsv_attrib3,p_level);
   nm_debug.debug('nsv_attrib4     : '||pi_rec_nsv.nsv_attrib4,p_level);
   nm_debug.debug('nsv_attrib5     : '||pi_rec_nsv.nsv_attrib5,p_level);
   nm_debug.debug('nsv_attrib6     : '||pi_rec_nsv.nsv_attrib6,p_level);
   nm_debug.debug('nsv_attrib7     : '||pi_rec_nsv.nsv_attrib7,p_level);
   nm_debug.debug('nsv_attrib8     : '||pi_rec_nsv.nsv_attrib8,p_level);
   nm_debug.debug('nsv_attrib9     : '||pi_rec_nsv.nsv_attrib9,p_level);
   nm_debug.debug('nsv_attrib10    : '||pi_rec_nsv.nsv_attrib10,p_level);
   nm_debug.debug('nsv_attrib11    : '||pi_rec_nsv.nsv_attrib11,p_level);
   nm_debug.debug('nsv_attrib12    : '||pi_rec_nsv.nsv_attrib12,p_level);
   nm_debug.debug('nsv_attrib13    : '||pi_rec_nsv.nsv_attrib13,p_level);
   nm_debug.debug('nsv_attrib14    : '||pi_rec_nsv.nsv_attrib14,p_level);
   nm_debug.debug('nsv_attrib15    : '||pi_rec_nsv.nsv_attrib15,p_level);
   nm_debug.debug('nsv_attrib16    : '||pi_rec_nsv.nsv_attrib16,p_level);
   nm_debug.debug('nsv_attrib17    : '||pi_rec_nsv.nsv_attrib17,p_level);
   nm_debug.debug('nsv_attrib18    : '||pi_rec_nsv.nsv_attrib18,p_level);
   nm_debug.debug('nsv_attrib19    : '||pi_rec_nsv.nsv_attrib19,p_level);
   nm_debug.debug('nsv_attrib20    : '||pi_rec_nsv.nsv_attrib20,p_level);
   nm_debug.debug('nsv_attrib21    : '||pi_rec_nsv.nsv_attrib21,p_level);
   nm_debug.debug('nsv_attrib22    : '||pi_rec_nsv.nsv_attrib22,p_level);
   nm_debug.debug('nsv_attrib23    : '||pi_rec_nsv.nsv_attrib23,p_level);
   nm_debug.debug('nsv_attrib24    : '||pi_rec_nsv.nsv_attrib24,p_level);
   nm_debug.debug('nsv_attrib25    : '||pi_rec_nsv.nsv_attrib25,p_level);
   nm_debug.debug('nsv_attrib26    : '||pi_rec_nsv.nsv_attrib26,p_level);
   nm_debug.debug('nsv_attrib27    : '||pi_rec_nsv.nsv_attrib27,p_level);
   nm_debug.debug('nsv_attrib28    : '||pi_rec_nsv.nsv_attrib28,p_level);
   nm_debug.debug('nsv_attrib29    : '||pi_rec_nsv.nsv_attrib29,p_level);
   nm_debug.debug('nsv_attrib30    : '||pi_rec_nsv.nsv_attrib30,p_level);
   nm_debug.debug('nsv_attrib31    : '||pi_rec_nsv.nsv_attrib31,p_level);
   nm_debug.debug('nsv_attrib32    : '||pi_rec_nsv.nsv_attrib32,p_level);
   nm_debug.debug('nsv_attrib33    : '||pi_rec_nsv.nsv_attrib33,p_level);
   nm_debug.debug('nsv_attrib34    : '||pi_rec_nsv.nsv_attrib34,p_level);
   nm_debug.debug('nsv_attrib35    : '||pi_rec_nsv.nsv_attrib35,p_level);
   nm_debug.debug('nsv_attrib36    : '||pi_rec_nsv.nsv_attrib36,p_level);
   nm_debug.debug('nsv_attrib37    : '||pi_rec_nsv.nsv_attrib37,p_level);
   nm_debug.debug('nsv_attrib38    : '||pi_rec_nsv.nsv_attrib38,p_level);
   nm_debug.debug('nsv_attrib39    : '||pi_rec_nsv.nsv_attrib39,p_level);
   nm_debug.debug('nsv_attrib40    : '||pi_rec_nsv.nsv_attrib40,p_level);
   nm_debug.debug('nsv_attrib41    : '||pi_rec_nsv.nsv_attrib41,p_level);
   nm_debug.debug('nsv_attrib42    : '||pi_rec_nsv.nsv_attrib42,p_level);
   nm_debug.debug('nsv_attrib43    : '||pi_rec_nsv.nsv_attrib43,p_level);
   nm_debug.debug('nsv_attrib44    : '||pi_rec_nsv.nsv_attrib44,p_level);
   nm_debug.debug('nsv_attrib45    : '||pi_rec_nsv.nsv_attrib45,p_level);
   nm_debug.debug('nsv_attrib46    : '||pi_rec_nsv.nsv_attrib46,p_level);
   nm_debug.debug('nsv_attrib47    : '||pi_rec_nsv.nsv_attrib47,p_level);
   nm_debug.debug('nsv_attrib48    : '||pi_rec_nsv.nsv_attrib48,p_level);
   nm_debug.debug('nsv_attrib49    : '||pi_rec_nsv.nsv_attrib49,p_level);
   nm_debug.debug('nsv_attrib50    : '||pi_rec_nsv.nsv_attrib50,p_level);
   nm_debug.debug('nsv_attrib51    : '||pi_rec_nsv.nsv_attrib51,p_level);
   nm_debug.debug('nsv_attrib52    : '||pi_rec_nsv.nsv_attrib52,p_level);
   nm_debug.debug('nsv_attrib53    : '||pi_rec_nsv.nsv_attrib53,p_level);
   nm_debug.debug('nsv_attrib54    : '||pi_rec_nsv.nsv_attrib54,p_level);
   nm_debug.debug('nsv_attrib55    : '||pi_rec_nsv.nsv_attrib55,p_level);
   nm_debug.debug('nsv_attrib56    : '||pi_rec_nsv.nsv_attrib56,p_level);
   nm_debug.debug('nsv_attrib57    : '||pi_rec_nsv.nsv_attrib57,p_level);
   nm_debug.debug('nsv_attrib58    : '||pi_rec_nsv.nsv_attrib58,p_level);
   nm_debug.debug('nsv_attrib59    : '||pi_rec_nsv.nsv_attrib59,p_level);
   nm_debug.debug('nsv_attrib60    : '||pi_rec_nsv.nsv_attrib60,p_level);
   nm_debug.debug('nsv_attrib61    : '||pi_rec_nsv.nsv_attrib61,p_level);
   nm_debug.debug('nsv_attrib62    : '||pi_rec_nsv.nsv_attrib62,p_level);
   nm_debug.debug('nsv_attrib63    : '||pi_rec_nsv.nsv_attrib63,p_level);
   nm_debug.debug('nsv_attrib64    : '||pi_rec_nsv.nsv_attrib64,p_level);
   nm_debug.debug('nsv_attrib65    : '||pi_rec_nsv.nsv_attrib65,p_level);
   nm_debug.debug('nsv_attrib66    : '||pi_rec_nsv.nsv_attrib66,p_level);
   nm_debug.debug('nsv_attrib67    : '||pi_rec_nsv.nsv_attrib67,p_level);
   nm_debug.debug('nsv_attrib68    : '||pi_rec_nsv.nsv_attrib68,p_level);
   nm_debug.debug('nsv_attrib69    : '||pi_rec_nsv.nsv_attrib69,p_level);
   nm_debug.debug('nsv_attrib70    : '||pi_rec_nsv.nsv_attrib70,p_level);
   nm_debug.debug('nsv_attrib71    : '||pi_rec_nsv.nsv_attrib71,p_level);
   nm_debug.debug('nsv_attrib72    : '||pi_rec_nsv.nsv_attrib72,p_level);
   nm_debug.debug('nsv_attrib73    : '||pi_rec_nsv.nsv_attrib73,p_level);
   nm_debug.debug('nsv_attrib74    : '||pi_rec_nsv.nsv_attrib74,p_level);
   nm_debug.debug('nsv_attrib75    : '||pi_rec_nsv.nsv_attrib75,p_level);
   nm_debug.debug('nsv_attrib76    : '||pi_rec_nsv.nsv_attrib76,p_level);
   nm_debug.debug('nsv_attrib77    : '||pi_rec_nsv.nsv_attrib77,p_level);
   nm_debug.debug('nsv_attrib78    : '||pi_rec_nsv.nsv_attrib78,p_level);
   nm_debug.debug('nsv_attrib79    : '||pi_rec_nsv.nsv_attrib79,p_level);
   nm_debug.debug('nsv_attrib80    : '||pi_rec_nsv.nsv_attrib80,p_level);
   nm_debug.debug('nsv_attrib81    : '||pi_rec_nsv.nsv_attrib81,p_level);
   nm_debug.debug('nsv_attrib82    : '||pi_rec_nsv.nsv_attrib82,p_level);
   nm_debug.debug('nsv_attrib83    : '||pi_rec_nsv.nsv_attrib83,p_level);
   nm_debug.debug('nsv_attrib84    : '||pi_rec_nsv.nsv_attrib84,p_level);
   nm_debug.debug('nsv_attrib85    : '||pi_rec_nsv.nsv_attrib85,p_level);
   nm_debug.debug('nsv_attrib86    : '||pi_rec_nsv.nsv_attrib86,p_level);
   nm_debug.debug('nsv_attrib87    : '||pi_rec_nsv.nsv_attrib87,p_level);
   nm_debug.debug('nsv_attrib88    : '||pi_rec_nsv.nsv_attrib88,p_level);
   nm_debug.debug('nsv_attrib89    : '||pi_rec_nsv.nsv_attrib89,p_level);
   nm_debug.debug('nsv_attrib90    : '||pi_rec_nsv.nsv_attrib90,p_level);
   nm_debug.debug('nsv_attrib91    : '||pi_rec_nsv.nsv_attrib91,p_level);
   nm_debug.debug('nsv_attrib92    : '||pi_rec_nsv.nsv_attrib92,p_level);
   nm_debug.debug('nsv_attrib93    : '||pi_rec_nsv.nsv_attrib93,p_level);
   nm_debug.debug('nsv_attrib94    : '||pi_rec_nsv.nsv_attrib94,p_level);
   nm_debug.debug('nsv_attrib95    : '||pi_rec_nsv.nsv_attrib95,p_level);
   nm_debug.debug('nsv_attrib96    : '||pi_rec_nsv.nsv_attrib96,p_level);
   nm_debug.debug('nsv_attrib97    : '||pi_rec_nsv.nsv_attrib97,p_level);
   nm_debug.debug('nsv_attrib98    : '||pi_rec_nsv.nsv_attrib98,p_level);
   nm_debug.debug('nsv_attrib99    : '||pi_rec_nsv.nsv_attrib99,p_level);
   nm_debug.debug('nsv_attrib100   : '||pi_rec_nsv.nsv_attrib100,p_level);
   nm_debug.debug('nsv_attrib101   : '||pi_rec_nsv.nsv_attrib101,p_level);
   nm_debug.debug('nsv_attrib102   : '||pi_rec_nsv.nsv_attrib102,p_level);
   nm_debug.debug('nsv_attrib103   : '||pi_rec_nsv.nsv_attrib103,p_level);
   nm_debug.debug('nsv_attrib104   : '||pi_rec_nsv.nsv_attrib104,p_level);
   nm_debug.debug('nsv_attrib105   : '||pi_rec_nsv.nsv_attrib105,p_level);
   nm_debug.debug('nsv_attrib106   : '||pi_rec_nsv.nsv_attrib106,p_level);
   nm_debug.debug('nsv_attrib107   : '||pi_rec_nsv.nsv_attrib107,p_level);
   nm_debug.debug('nsv_attrib108   : '||pi_rec_nsv.nsv_attrib108,p_level);
   nm_debug.debug('nsv_attrib109   : '||pi_rec_nsv.nsv_attrib109,p_level);
   nm_debug.debug('nsv_attrib110   : '||pi_rec_nsv.nsv_attrib110,p_level);
   nm_debug.debug('nsv_attrib111   : '||pi_rec_nsv.nsv_attrib111,p_level);
   nm_debug.debug('nsv_attrib112   : '||pi_rec_nsv.nsv_attrib112,p_level);
   nm_debug.debug('nsv_attrib113   : '||pi_rec_nsv.nsv_attrib113,p_level);
   nm_debug.debug('nsv_attrib114   : '||pi_rec_nsv.nsv_attrib114,p_level);
   nm_debug.debug('nsv_attrib115   : '||pi_rec_nsv.nsv_attrib115,p_level);
   nm_debug.debug('nsv_attrib116   : '||pi_rec_nsv.nsv_attrib116,p_level);
   nm_debug.debug('nsv_attrib117   : '||pi_rec_nsv.nsv_attrib117,p_level);
   nm_debug.debug('nsv_attrib118   : '||pi_rec_nsv.nsv_attrib118,p_level);
   nm_debug.debug('nsv_attrib119   : '||pi_rec_nsv.nsv_attrib119,p_level);
   nm_debug.debug('nsv_attrib120   : '||pi_rec_nsv.nsv_attrib120,p_level);
   nm_debug.debug('nsv_attrib121   : '||pi_rec_nsv.nsv_attrib121,p_level);
   nm_debug.debug('nsv_attrib122   : '||pi_rec_nsv.nsv_attrib122,p_level);
   nm_debug.debug('nsv_attrib123   : '||pi_rec_nsv.nsv_attrib123,p_level);
   nm_debug.debug('nsv_attrib124   : '||pi_rec_nsv.nsv_attrib124,p_level);
   nm_debug.debug('nsv_attrib125   : '||pi_rec_nsv.nsv_attrib125,p_level);
   nm_debug.debug('nsv_attrib126   : '||pi_rec_nsv.nsv_attrib126,p_level);
   nm_debug.debug('nsv_attrib127   : '||pi_rec_nsv.nsv_attrib127,p_level);
   nm_debug.debug('nsv_attrib128   : '||pi_rec_nsv.nsv_attrib128,p_level);
   nm_debug.debug('nsv_attrib129   : '||pi_rec_nsv.nsv_attrib129,p_level);
   nm_debug.debug('nsv_attrib130   : '||pi_rec_nsv.nsv_attrib130,p_level);
   nm_debug.debug('nsv_attrib131   : '||pi_rec_nsv.nsv_attrib131,p_level);
   nm_debug.debug('nsv_attrib132   : '||pi_rec_nsv.nsv_attrib132,p_level);
   nm_debug.debug('nsv_attrib133   : '||pi_rec_nsv.nsv_attrib133,p_level);
   nm_debug.debug('nsv_attrib134   : '||pi_rec_nsv.nsv_attrib134,p_level);
   nm_debug.debug('nsv_attrib135   : '||pi_rec_nsv.nsv_attrib135,p_level);
   nm_debug.debug('nsv_attrib136   : '||pi_rec_nsv.nsv_attrib136,p_level);
   nm_debug.debug('nsv_attrib137   : '||pi_rec_nsv.nsv_attrib137,p_level);
   nm_debug.debug('nsv_attrib138   : '||pi_rec_nsv.nsv_attrib138,p_level);
   nm_debug.debug('nsv_attrib139   : '||pi_rec_nsv.nsv_attrib139,p_level);
   nm_debug.debug('nsv_attrib140   : '||pi_rec_nsv.nsv_attrib140,p_level);
   nm_debug.debug('nsv_attrib141   : '||pi_rec_nsv.nsv_attrib141,p_level);
   nm_debug.debug('nsv_attrib142   : '||pi_rec_nsv.nsv_attrib142,p_level);
   nm_debug.debug('nsv_attrib143   : '||pi_rec_nsv.nsv_attrib143,p_level);
   nm_debug.debug('nsv_attrib144   : '||pi_rec_nsv.nsv_attrib144,p_level);
   nm_debug.debug('nsv_attrib145   : '||pi_rec_nsv.nsv_attrib145,p_level);
   nm_debug.debug('nsv_attrib146   : '||pi_rec_nsv.nsv_attrib146,p_level);
   nm_debug.debug('nsv_attrib147   : '||pi_rec_nsv.nsv_attrib147,p_level);
   nm_debug.debug('nsv_attrib148   : '||pi_rec_nsv.nsv_attrib148,p_level);
   nm_debug.debug('nsv_attrib149   : '||pi_rec_nsv.nsv_attrib149,p_level);
   nm_debug.debug('nsv_attrib150   : '||pi_rec_nsv.nsv_attrib150,p_level);
   nm_debug.debug('nsv_attrib151   : '||pi_rec_nsv.nsv_attrib151,p_level);
   nm_debug.debug('nsv_attrib152   : '||pi_rec_nsv.nsv_attrib152,p_level);
   nm_debug.debug('nsv_attrib153   : '||pi_rec_nsv.nsv_attrib153,p_level);
   nm_debug.debug('nsv_attrib154   : '||pi_rec_nsv.nsv_attrib154,p_level);
   nm_debug.debug('nsv_attrib155   : '||pi_rec_nsv.nsv_attrib155,p_level);
   nm_debug.debug('nsv_attrib156   : '||pi_rec_nsv.nsv_attrib156,p_level);
   nm_debug.debug('nsv_attrib157   : '||pi_rec_nsv.nsv_attrib157,p_level);
   nm_debug.debug('nsv_attrib158   : '||pi_rec_nsv.nsv_attrib158,p_level);
   nm_debug.debug('nsv_attrib159   : '||pi_rec_nsv.nsv_attrib159,p_level);
   nm_debug.debug('nsv_attrib160   : '||pi_rec_nsv.nsv_attrib160,p_level);
   nm_debug.debug('nsv_attrib161   : '||pi_rec_nsv.nsv_attrib161,p_level);
   nm_debug.debug('nsv_attrib162   : '||pi_rec_nsv.nsv_attrib162,p_level);
   nm_debug.debug('nsv_attrib163   : '||pi_rec_nsv.nsv_attrib163,p_level);
   nm_debug.debug('nsv_attrib164   : '||pi_rec_nsv.nsv_attrib164,p_level);
   nm_debug.debug('nsv_attrib165   : '||pi_rec_nsv.nsv_attrib165,p_level);
   nm_debug.debug('nsv_attrib166   : '||pi_rec_nsv.nsv_attrib166,p_level);
   nm_debug.debug('nsv_attrib167   : '||pi_rec_nsv.nsv_attrib167,p_level);
   nm_debug.debug('nsv_attrib168   : '||pi_rec_nsv.nsv_attrib168,p_level);
   nm_debug.debug('nsv_attrib169   : '||pi_rec_nsv.nsv_attrib169,p_level);
   nm_debug.debug('nsv_attrib170   : '||pi_rec_nsv.nsv_attrib170,p_level);
   nm_debug.debug('nsv_attrib171   : '||pi_rec_nsv.nsv_attrib171,p_level);
   nm_debug.debug('nsv_attrib172   : '||pi_rec_nsv.nsv_attrib172,p_level);
   nm_debug.debug('nsv_attrib173   : '||pi_rec_nsv.nsv_attrib173,p_level);
   nm_debug.debug('nsv_attrib174   : '||pi_rec_nsv.nsv_attrib174,p_level);
   nm_debug.debug('nsv_attrib175   : '||pi_rec_nsv.nsv_attrib175,p_level);
   nm_debug.debug('nsv_attrib176   : '||pi_rec_nsv.nsv_attrib176,p_level);
   nm_debug.debug('nsv_attrib177   : '||pi_rec_nsv.nsv_attrib177,p_level);
   nm_debug.debug('nsv_attrib178   : '||pi_rec_nsv.nsv_attrib178,p_level);
   nm_debug.debug('nsv_attrib179   : '||pi_rec_nsv.nsv_attrib179,p_level);
   nm_debug.debug('nsv_attrib180   : '||pi_rec_nsv.nsv_attrib180,p_level);
   nm_debug.debug('nsv_attrib181   : '||pi_rec_nsv.nsv_attrib181,p_level);
   nm_debug.debug('nsv_attrib182   : '||pi_rec_nsv.nsv_attrib182,p_level);
   nm_debug.debug('nsv_attrib183   : '||pi_rec_nsv.nsv_attrib183,p_level);
   nm_debug.debug('nsv_attrib184   : '||pi_rec_nsv.nsv_attrib184,p_level);
   nm_debug.debug('nsv_attrib185   : '||pi_rec_nsv.nsv_attrib185,p_level);
   nm_debug.debug('nsv_attrib186   : '||pi_rec_nsv.nsv_attrib186,p_level);
   nm_debug.debug('nsv_attrib187   : '||pi_rec_nsv.nsv_attrib187,p_level);
   nm_debug.debug('nsv_attrib188   : '||pi_rec_nsv.nsv_attrib188,p_level);
   nm_debug.debug('nsv_attrib189   : '||pi_rec_nsv.nsv_attrib189,p_level);
   nm_debug.debug('nsv_attrib190   : '||pi_rec_nsv.nsv_attrib190,p_level);
   nm_debug.debug('nsv_attrib191   : '||pi_rec_nsv.nsv_attrib191,p_level);
   nm_debug.debug('nsv_attrib192   : '||pi_rec_nsv.nsv_attrib192,p_level);
   nm_debug.debug('nsv_attrib193   : '||pi_rec_nsv.nsv_attrib193,p_level);
   nm_debug.debug('nsv_attrib194   : '||pi_rec_nsv.nsv_attrib194,p_level);
   nm_debug.debug('nsv_attrib195   : '||pi_rec_nsv.nsv_attrib195,p_level);
   nm_debug.debug('nsv_attrib196   : '||pi_rec_nsv.nsv_attrib196,p_level);
   nm_debug.debug('nsv_attrib197   : '||pi_rec_nsv.nsv_attrib197,p_level);
   nm_debug.debug('nsv_attrib198   : '||pi_rec_nsv.nsv_attrib198,p_level);
   nm_debug.debug('nsv_attrib199   : '||pi_rec_nsv.nsv_attrib199,p_level);
   nm_debug.debug('nsv_attrib200   : '||pi_rec_nsv.nsv_attrib200,p_level);
   nm_debug.debug('nsv_attrib201   : '||pi_rec_nsv.nsv_attrib201,p_level);
   nm_debug.debug('nsv_attrib202   : '||pi_rec_nsv.nsv_attrib202,p_level);
   nm_debug.debug('nsv_attrib203   : '||pi_rec_nsv.nsv_attrib203,p_level);
   nm_debug.debug('nsv_attrib204   : '||pi_rec_nsv.nsv_attrib204,p_level);
   nm_debug.debug('nsv_attrib205   : '||pi_rec_nsv.nsv_attrib205,p_level);
   nm_debug.debug('nsv_attrib206   : '||pi_rec_nsv.nsv_attrib206,p_level);
   nm_debug.debug('nsv_attrib207   : '||pi_rec_nsv.nsv_attrib207,p_level);
   nm_debug.debug('nsv_attrib208   : '||pi_rec_nsv.nsv_attrib208,p_level);
   nm_debug.debug('nsv_attrib209   : '||pi_rec_nsv.nsv_attrib209,p_level);
   nm_debug.debug('nsv_attrib210   : '||pi_rec_nsv.nsv_attrib210,p_level);
   nm_debug.debug('nsv_attrib211   : '||pi_rec_nsv.nsv_attrib211,p_level);
   nm_debug.debug('nsv_attrib212   : '||pi_rec_nsv.nsv_attrib212,p_level);
   nm_debug.debug('nsv_attrib213   : '||pi_rec_nsv.nsv_attrib213,p_level);
   nm_debug.debug('nsv_attrib214   : '||pi_rec_nsv.nsv_attrib214,p_level);
   nm_debug.debug('nsv_attrib215   : '||pi_rec_nsv.nsv_attrib215,p_level);
   nm_debug.debug('nsv_attrib216   : '||pi_rec_nsv.nsv_attrib216,p_level);
   nm_debug.debug('nsv_attrib217   : '||pi_rec_nsv.nsv_attrib217,p_level);
   nm_debug.debug('nsv_attrib218   : '||pi_rec_nsv.nsv_attrib218,p_level);
   nm_debug.debug('nsv_attrib219   : '||pi_rec_nsv.nsv_attrib219,p_level);
   nm_debug.debug('nsv_attrib220   : '||pi_rec_nsv.nsv_attrib220,p_level);
   nm_debug.debug('nsv_attrib221   : '||pi_rec_nsv.nsv_attrib221,p_level);
   nm_debug.debug('nsv_attrib222   : '||pi_rec_nsv.nsv_attrib222,p_level);
   nm_debug.debug('nsv_attrib223   : '||pi_rec_nsv.nsv_attrib223,p_level);
   nm_debug.debug('nsv_attrib224   : '||pi_rec_nsv.nsv_attrib224,p_level);
   nm_debug.debug('nsv_attrib225   : '||pi_rec_nsv.nsv_attrib225,p_level);
   nm_debug.debug('nsv_attrib226   : '||pi_rec_nsv.nsv_attrib226,p_level);
   nm_debug.debug('nsv_attrib227   : '||pi_rec_nsv.nsv_attrib227,p_level);
   nm_debug.debug('nsv_attrib228   : '||pi_rec_nsv.nsv_attrib228,p_level);
   nm_debug.debug('nsv_attrib229   : '||pi_rec_nsv.nsv_attrib229,p_level);
   nm_debug.debug('nsv_attrib230   : '||pi_rec_nsv.nsv_attrib230,p_level);
   nm_debug.debug('nsv_attrib231   : '||pi_rec_nsv.nsv_attrib231,p_level);
   nm_debug.debug('nsv_attrib232   : '||pi_rec_nsv.nsv_attrib232,p_level);
   nm_debug.debug('nsv_attrib233   : '||pi_rec_nsv.nsv_attrib233,p_level);
   nm_debug.debug('nsv_attrib234   : '||pi_rec_nsv.nsv_attrib234,p_level);
   nm_debug.debug('nsv_attrib235   : '||pi_rec_nsv.nsv_attrib235,p_level);
   nm_debug.debug('nsv_attrib236   : '||pi_rec_nsv.nsv_attrib236,p_level);
   nm_debug.debug('nsv_attrib237   : '||pi_rec_nsv.nsv_attrib237,p_level);
   nm_debug.debug('nsv_attrib238   : '||pi_rec_nsv.nsv_attrib238,p_level);
   nm_debug.debug('nsv_attrib239   : '||pi_rec_nsv.nsv_attrib239,p_level);
   nm_debug.debug('nsv_attrib240   : '||pi_rec_nsv.nsv_attrib240,p_level);
   nm_debug.debug('nsv_attrib241   : '||pi_rec_nsv.nsv_attrib241,p_level);
   nm_debug.debug('nsv_attrib242   : '||pi_rec_nsv.nsv_attrib242,p_level);
   nm_debug.debug('nsv_attrib243   : '||pi_rec_nsv.nsv_attrib243,p_level);
   nm_debug.debug('nsv_attrib244   : '||pi_rec_nsv.nsv_attrib244,p_level);
   nm_debug.debug('nsv_attrib245   : '||pi_rec_nsv.nsv_attrib245,p_level);
   nm_debug.debug('nsv_attrib246   : '||pi_rec_nsv.nsv_attrib246,p_level);
   nm_debug.debug('nsv_attrib247   : '||pi_rec_nsv.nsv_attrib247,p_level);
   nm_debug.debug('nsv_attrib248   : '||pi_rec_nsv.nsv_attrib248,p_level);
   nm_debug.debug('nsv_attrib249   : '||pi_rec_nsv.nsv_attrib249,p_level);
   nm_debug.debug('nsv_attrib250   : '||pi_rec_nsv.nsv_attrib250,p_level);
   nm_debug.debug('nsv_attrib251   : '||pi_rec_nsv.nsv_attrib251,p_level);
   nm_debug.debug('nsv_attrib252   : '||pi_rec_nsv.nsv_attrib252,p_level);
   nm_debug.debug('nsv_attrib253   : '||pi_rec_nsv.nsv_attrib253,p_level);
   nm_debug.debug('nsv_attrib254   : '||pi_rec_nsv.nsv_attrib254,p_level);
   nm_debug.debug('nsv_attrib255   : '||pi_rec_nsv.nsv_attrib255,p_level);
   nm_debug.debug('nsv_attrib256   : '||pi_rec_nsv.nsv_attrib256,p_level);
   nm_debug.debug('nsv_attrib257   : '||pi_rec_nsv.nsv_attrib257,p_level);
   nm_debug.debug('nsv_attrib258   : '||pi_rec_nsv.nsv_attrib258,p_level);
   nm_debug.debug('nsv_attrib259   : '||pi_rec_nsv.nsv_attrib259,p_level);
   nm_debug.debug('nsv_attrib260   : '||pi_rec_nsv.nsv_attrib260,p_level);
   nm_debug.debug('nsv_attrib261   : '||pi_rec_nsv.nsv_attrib261,p_level);
   nm_debug.debug('nsv_attrib262   : '||pi_rec_nsv.nsv_attrib262,p_level);
   nm_debug.debug('nsv_attrib263   : '||pi_rec_nsv.nsv_attrib263,p_level);
   nm_debug.debug('nsv_attrib264   : '||pi_rec_nsv.nsv_attrib264,p_level);
   nm_debug.debug('nsv_attrib265   : '||pi_rec_nsv.nsv_attrib265,p_level);
   nm_debug.debug('nsv_attrib266   : '||pi_rec_nsv.nsv_attrib266,p_level);
   nm_debug.debug('nsv_attrib267   : '||pi_rec_nsv.nsv_attrib267,p_level);
   nm_debug.debug('nsv_attrib268   : '||pi_rec_nsv.nsv_attrib268,p_level);
   nm_debug.debug('nsv_attrib269   : '||pi_rec_nsv.nsv_attrib269,p_level);
   nm_debug.debug('nsv_attrib270   : '||pi_rec_nsv.nsv_attrib270,p_level);
   nm_debug.debug('nsv_attrib271   : '||pi_rec_nsv.nsv_attrib271,p_level);
   nm_debug.debug('nsv_attrib272   : '||pi_rec_nsv.nsv_attrib272,p_level);
   nm_debug.debug('nsv_attrib273   : '||pi_rec_nsv.nsv_attrib273,p_level);
   nm_debug.debug('nsv_attrib274   : '||pi_rec_nsv.nsv_attrib274,p_level);
   nm_debug.debug('nsv_attrib275   : '||pi_rec_nsv.nsv_attrib275,p_level);
   nm_debug.debug('nsv_attrib276   : '||pi_rec_nsv.nsv_attrib276,p_level);
   nm_debug.debug('nsv_attrib277   : '||pi_rec_nsv.nsv_attrib277,p_level);
   nm_debug.debug('nsv_attrib278   : '||pi_rec_nsv.nsv_attrib278,p_level);
   nm_debug.debug('nsv_attrib279   : '||pi_rec_nsv.nsv_attrib279,p_level);
   nm_debug.debug('nsv_attrib280   : '||pi_rec_nsv.nsv_attrib280,p_level);
   nm_debug.debug('nsv_attrib281   : '||pi_rec_nsv.nsv_attrib281,p_level);
   nm_debug.debug('nsv_attrib282   : '||pi_rec_nsv.nsv_attrib282,p_level);
   nm_debug.debug('nsv_attrib283   : '||pi_rec_nsv.nsv_attrib283,p_level);
   nm_debug.debug('nsv_attrib284   : '||pi_rec_nsv.nsv_attrib284,p_level);
   nm_debug.debug('nsv_attrib285   : '||pi_rec_nsv.nsv_attrib285,p_level);
   nm_debug.debug('nsv_attrib286   : '||pi_rec_nsv.nsv_attrib286,p_level);
   nm_debug.debug('nsv_attrib287   : '||pi_rec_nsv.nsv_attrib287,p_level);
   nm_debug.debug('nsv_attrib288   : '||pi_rec_nsv.nsv_attrib288,p_level);
   nm_debug.debug('nsv_attrib289   : '||pi_rec_nsv.nsv_attrib289,p_level);
   nm_debug.debug('nsv_attrib290   : '||pi_rec_nsv.nsv_attrib290,p_level);
   nm_debug.debug('nsv_attrib291   : '||pi_rec_nsv.nsv_attrib291,p_level);
   nm_debug.debug('nsv_attrib292   : '||pi_rec_nsv.nsv_attrib292,p_level);
   nm_debug.debug('nsv_attrib293   : '||pi_rec_nsv.nsv_attrib293,p_level);
   nm_debug.debug('nsv_attrib294   : '||pi_rec_nsv.nsv_attrib294,p_level);
   nm_debug.debug('nsv_attrib295   : '||pi_rec_nsv.nsv_attrib295,p_level);
   nm_debug.debug('nsv_attrib296   : '||pi_rec_nsv.nsv_attrib296,p_level);
   nm_debug.debug('nsv_attrib297   : '||pi_rec_nsv.nsv_attrib297,p_level);
   nm_debug.debug('nsv_attrib298   : '||pi_rec_nsv.nsv_attrib298,p_level);
   nm_debug.debug('nsv_attrib299   : '||pi_rec_nsv.nsv_attrib299,p_level);
   nm_debug.debug('nsv_attrib300   : '||pi_rec_nsv.nsv_attrib300,p_level);
   nm_debug.debug('nsv_attrib301   : '||pi_rec_nsv.nsv_attrib301,p_level);
   nm_debug.debug('nsv_attrib302   : '||pi_rec_nsv.nsv_attrib302,p_level);
   nm_debug.debug('nsv_attrib303   : '||pi_rec_nsv.nsv_attrib303,p_level);
   nm_debug.debug('nsv_attrib304   : '||pi_rec_nsv.nsv_attrib304,p_level);
   nm_debug.debug('nsv_attrib305   : '||pi_rec_nsv.nsv_attrib305,p_level);
   nm_debug.debug('nsv_attrib306   : '||pi_rec_nsv.nsv_attrib306,p_level);
   nm_debug.debug('nsv_attrib307   : '||pi_rec_nsv.nsv_attrib307,p_level);
   nm_debug.debug('nsv_attrib308   : '||pi_rec_nsv.nsv_attrib308,p_level);
   nm_debug.debug('nsv_attrib309   : '||pi_rec_nsv.nsv_attrib309,p_level);
   nm_debug.debug('nsv_attrib310   : '||pi_rec_nsv.nsv_attrib310,p_level);
   nm_debug.debug('nsv_attrib311   : '||pi_rec_nsv.nsv_attrib311,p_level);
   nm_debug.debug('nsv_attrib312   : '||pi_rec_nsv.nsv_attrib312,p_level);
   nm_debug.debug('nsv_attrib313   : '||pi_rec_nsv.nsv_attrib313,p_level);
   nm_debug.debug('nsv_attrib314   : '||pi_rec_nsv.nsv_attrib314,p_level);
   nm_debug.debug('nsv_attrib315   : '||pi_rec_nsv.nsv_attrib315,p_level);
   nm_debug.debug('nsv_attrib316   : '||pi_rec_nsv.nsv_attrib316,p_level);
   nm_debug.debug('nsv_attrib317   : '||pi_rec_nsv.nsv_attrib317,p_level);
   nm_debug.debug('nsv_attrib318   : '||pi_rec_nsv.nsv_attrib318,p_level);
   nm_debug.debug('nsv_attrib319   : '||pi_rec_nsv.nsv_attrib319,p_level);
   nm_debug.debug('nsv_attrib320   : '||pi_rec_nsv.nsv_attrib320,p_level);
   nm_debug.debug('nsv_attrib321   : '||pi_rec_nsv.nsv_attrib321,p_level);
   nm_debug.debug('nsv_attrib322   : '||pi_rec_nsv.nsv_attrib322,p_level);
   nm_debug.debug('nsv_attrib323   : '||pi_rec_nsv.nsv_attrib323,p_level);
   nm_debug.debug('nsv_attrib324   : '||pi_rec_nsv.nsv_attrib324,p_level);
   nm_debug.debug('nsv_attrib325   : '||pi_rec_nsv.nsv_attrib325,p_level);
   nm_debug.debug('nsv_attrib326   : '||pi_rec_nsv.nsv_attrib326,p_level);
   nm_debug.debug('nsv_attrib327   : '||pi_rec_nsv.nsv_attrib327,p_level);
   nm_debug.debug('nsv_attrib328   : '||pi_rec_nsv.nsv_attrib328,p_level);
   nm_debug.debug('nsv_attrib329   : '||pi_rec_nsv.nsv_attrib329,p_level);
   nm_debug.debug('nsv_attrib330   : '||pi_rec_nsv.nsv_attrib330,p_level);
   nm_debug.debug('nsv_attrib331   : '||pi_rec_nsv.nsv_attrib331,p_level);
   nm_debug.debug('nsv_attrib332   : '||pi_rec_nsv.nsv_attrib332,p_level);
   nm_debug.debug('nsv_attrib333   : '||pi_rec_nsv.nsv_attrib333,p_level);
   nm_debug.debug('nsv_attrib334   : '||pi_rec_nsv.nsv_attrib334,p_level);
   nm_debug.debug('nsv_attrib335   : '||pi_rec_nsv.nsv_attrib335,p_level);
   nm_debug.debug('nsv_attrib336   : '||pi_rec_nsv.nsv_attrib336,p_level);
   nm_debug.debug('nsv_attrib337   : '||pi_rec_nsv.nsv_attrib337,p_level);
   nm_debug.debug('nsv_attrib338   : '||pi_rec_nsv.nsv_attrib338,p_level);
   nm_debug.debug('nsv_attrib339   : '||pi_rec_nsv.nsv_attrib339,p_level);
   nm_debug.debug('nsv_attrib340   : '||pi_rec_nsv.nsv_attrib340,p_level);
   nm_debug.debug('nsv_attrib341   : '||pi_rec_nsv.nsv_attrib341,p_level);
   nm_debug.debug('nsv_attrib342   : '||pi_rec_nsv.nsv_attrib342,p_level);
   nm_debug.debug('nsv_attrib343   : '||pi_rec_nsv.nsv_attrib343,p_level);
   nm_debug.debug('nsv_attrib344   : '||pi_rec_nsv.nsv_attrib344,p_level);
   nm_debug.debug('nsv_attrib345   : '||pi_rec_nsv.nsv_attrib345,p_level);
   nm_debug.debug('nsv_attrib346   : '||pi_rec_nsv.nsv_attrib346,p_level);
   nm_debug.debug('nsv_attrib347   : '||pi_rec_nsv.nsv_attrib347,p_level);
   nm_debug.debug('nsv_attrib348   : '||pi_rec_nsv.nsv_attrib348,p_level);
   nm_debug.debug('nsv_attrib349   : '||pi_rec_nsv.nsv_attrib349,p_level);
   nm_debug.debug('nsv_attrib350   : '||pi_rec_nsv.nsv_attrib350,p_level);
   nm_debug.debug('nsv_attrib351   : '||pi_rec_nsv.nsv_attrib351,p_level);
   nm_debug.debug('nsv_attrib352   : '||pi_rec_nsv.nsv_attrib352,p_level);
   nm_debug.debug('nsv_attrib353   : '||pi_rec_nsv.nsv_attrib353,p_level);
   nm_debug.debug('nsv_attrib354   : '||pi_rec_nsv.nsv_attrib354,p_level);
   nm_debug.debug('nsv_attrib355   : '||pi_rec_nsv.nsv_attrib355,p_level);
   nm_debug.debug('nsv_attrib356   : '||pi_rec_nsv.nsv_attrib356,p_level);
   nm_debug.debug('nsv_attrib357   : '||pi_rec_nsv.nsv_attrib357,p_level);
   nm_debug.debug('nsv_attrib358   : '||pi_rec_nsv.nsv_attrib358,p_level);
   nm_debug.debug('nsv_attrib359   : '||pi_rec_nsv.nsv_attrib359,p_level);
   nm_debug.debug('nsv_attrib360   : '||pi_rec_nsv.nsv_attrib360,p_level);
   nm_debug.debug('nsv_attrib361   : '||pi_rec_nsv.nsv_attrib361,p_level);
   nm_debug.debug('nsv_attrib362   : '||pi_rec_nsv.nsv_attrib362,p_level);
   nm_debug.debug('nsv_attrib363   : '||pi_rec_nsv.nsv_attrib363,p_level);
   nm_debug.debug('nsv_attrib364   : '||pi_rec_nsv.nsv_attrib364,p_level);
   nm_debug.debug('nsv_attrib365   : '||pi_rec_nsv.nsv_attrib365,p_level);
   nm_debug.debug('nsv_attrib366   : '||pi_rec_nsv.nsv_attrib366,p_level);
   nm_debug.debug('nsv_attrib367   : '||pi_rec_nsv.nsv_attrib367,p_level);
   nm_debug.debug('nsv_attrib368   : '||pi_rec_nsv.nsv_attrib368,p_level);
   nm_debug.debug('nsv_attrib369   : '||pi_rec_nsv.nsv_attrib369,p_level);
   nm_debug.debug('nsv_attrib370   : '||pi_rec_nsv.nsv_attrib370,p_level);
   nm_debug.debug('nsv_attrib371   : '||pi_rec_nsv.nsv_attrib371,p_level);
   nm_debug.debug('nsv_attrib372   : '||pi_rec_nsv.nsv_attrib372,p_level);
   nm_debug.debug('nsv_attrib373   : '||pi_rec_nsv.nsv_attrib373,p_level);
   nm_debug.debug('nsv_attrib374   : '||pi_rec_nsv.nsv_attrib374,p_level);
   nm_debug.debug('nsv_attrib375   : '||pi_rec_nsv.nsv_attrib375,p_level);
   nm_debug.debug('nsv_attrib376   : '||pi_rec_nsv.nsv_attrib376,p_level);
   nm_debug.debug('nsv_attrib377   : '||pi_rec_nsv.nsv_attrib377,p_level);
   nm_debug.debug('nsv_attrib378   : '||pi_rec_nsv.nsv_attrib378,p_level);
   nm_debug.debug('nsv_attrib379   : '||pi_rec_nsv.nsv_attrib379,p_level);
   nm_debug.debug('nsv_attrib380   : '||pi_rec_nsv.nsv_attrib380,p_level);
   nm_debug.debug('nsv_attrib381   : '||pi_rec_nsv.nsv_attrib381,p_level);
   nm_debug.debug('nsv_attrib382   : '||pi_rec_nsv.nsv_attrib382,p_level);
   nm_debug.debug('nsv_attrib383   : '||pi_rec_nsv.nsv_attrib383,p_level);
   nm_debug.debug('nsv_attrib384   : '||pi_rec_nsv.nsv_attrib384,p_level);
   nm_debug.debug('nsv_attrib385   : '||pi_rec_nsv.nsv_attrib385,p_level);
   nm_debug.debug('nsv_attrib386   : '||pi_rec_nsv.nsv_attrib386,p_level);
   nm_debug.debug('nsv_attrib387   : '||pi_rec_nsv.nsv_attrib387,p_level);
   nm_debug.debug('nsv_attrib388   : '||pi_rec_nsv.nsv_attrib388,p_level);
   nm_debug.debug('nsv_attrib389   : '||pi_rec_nsv.nsv_attrib389,p_level);
   nm_debug.debug('nsv_attrib390   : '||pi_rec_nsv.nsv_attrib390,p_level);
   nm_debug.debug('nsv_attrib391   : '||pi_rec_nsv.nsv_attrib391,p_level);
   nm_debug.debug('nsv_attrib392   : '||pi_rec_nsv.nsv_attrib392,p_level);
   nm_debug.debug('nsv_attrib393   : '||pi_rec_nsv.nsv_attrib393,p_level);
   nm_debug.debug('nsv_attrib394   : '||pi_rec_nsv.nsv_attrib394,p_level);
   nm_debug.debug('nsv_attrib395   : '||pi_rec_nsv.nsv_attrib395,p_level);
   nm_debug.debug('nsv_attrib396   : '||pi_rec_nsv.nsv_attrib396,p_level);
   nm_debug.debug('nsv_attrib397   : '||pi_rec_nsv.nsv_attrib397,p_level);
   nm_debug.debug('nsv_attrib398   : '||pi_rec_nsv.nsv_attrib398,p_level);
   nm_debug.debug('nsv_attrib399   : '||pi_rec_nsv.nsv_attrib399,p_level);
   nm_debug.debug('nsv_attrib400   : '||pi_rec_nsv.nsv_attrib400,p_level);
   nm_debug.debug('nsv_attrib401   : '||pi_rec_nsv.nsv_attrib401,p_level);
   nm_debug.debug('nsv_attrib402   : '||pi_rec_nsv.nsv_attrib402,p_level);
   nm_debug.debug('nsv_attrib403   : '||pi_rec_nsv.nsv_attrib403,p_level);
   nm_debug.debug('nsv_attrib404   : '||pi_rec_nsv.nsv_attrib404,p_level);
   nm_debug.debug('nsv_attrib405   : '||pi_rec_nsv.nsv_attrib405,p_level);
   nm_debug.debug('nsv_attrib406   : '||pi_rec_nsv.nsv_attrib406,p_level);
   nm_debug.debug('nsv_attrib407   : '||pi_rec_nsv.nsv_attrib407,p_level);
   nm_debug.debug('nsv_attrib408   : '||pi_rec_nsv.nsv_attrib408,p_level);
   nm_debug.debug('nsv_attrib409   : '||pi_rec_nsv.nsv_attrib409,p_level);
   nm_debug.debug('nsv_attrib410   : '||pi_rec_nsv.nsv_attrib410,p_level);
   nm_debug.debug('nsv_attrib411   : '||pi_rec_nsv.nsv_attrib411,p_level);
   nm_debug.debug('nsv_attrib412   : '||pi_rec_nsv.nsv_attrib412,p_level);
   nm_debug.debug('nsv_attrib413   : '||pi_rec_nsv.nsv_attrib413,p_level);
   nm_debug.debug('nsv_attrib414   : '||pi_rec_nsv.nsv_attrib414,p_level);
   nm_debug.debug('nsv_attrib415   : '||pi_rec_nsv.nsv_attrib415,p_level);
   nm_debug.debug('nsv_attrib416   : '||pi_rec_nsv.nsv_attrib416,p_level);
   nm_debug.debug('nsv_attrib417   : '||pi_rec_nsv.nsv_attrib417,p_level);
   nm_debug.debug('nsv_attrib418   : '||pi_rec_nsv.nsv_attrib418,p_level);
   nm_debug.debug('nsv_attrib419   : '||pi_rec_nsv.nsv_attrib419,p_level);
   nm_debug.debug('nsv_attrib420   : '||pi_rec_nsv.nsv_attrib420,p_level);
   nm_debug.debug('nsv_attrib421   : '||pi_rec_nsv.nsv_attrib421,p_level);
   nm_debug.debug('nsv_attrib422   : '||pi_rec_nsv.nsv_attrib422,p_level);
   nm_debug.debug('nsv_attrib423   : '||pi_rec_nsv.nsv_attrib423,p_level);
   nm_debug.debug('nsv_attrib424   : '||pi_rec_nsv.nsv_attrib424,p_level);
   nm_debug.debug('nsv_attrib425   : '||pi_rec_nsv.nsv_attrib425,p_level);
   nm_debug.debug('nsv_attrib426   : '||pi_rec_nsv.nsv_attrib426,p_level);
   nm_debug.debug('nsv_attrib427   : '||pi_rec_nsv.nsv_attrib427,p_level);
   nm_debug.debug('nsv_attrib428   : '||pi_rec_nsv.nsv_attrib428,p_level);
   nm_debug.debug('nsv_attrib429   : '||pi_rec_nsv.nsv_attrib429,p_level);
   nm_debug.debug('nsv_attrib430   : '||pi_rec_nsv.nsv_attrib430,p_level);
   nm_debug.debug('nsv_attrib431   : '||pi_rec_nsv.nsv_attrib431,p_level);
   nm_debug.debug('nsv_attrib432   : '||pi_rec_nsv.nsv_attrib432,p_level);
   nm_debug.debug('nsv_attrib433   : '||pi_rec_nsv.nsv_attrib433,p_level);
   nm_debug.debug('nsv_attrib434   : '||pi_rec_nsv.nsv_attrib434,p_level);
   nm_debug.debug('nsv_attrib435   : '||pi_rec_nsv.nsv_attrib435,p_level);
   nm_debug.debug('nsv_attrib436   : '||pi_rec_nsv.nsv_attrib436,p_level);
   nm_debug.debug('nsv_attrib437   : '||pi_rec_nsv.nsv_attrib437,p_level);
   nm_debug.debug('nsv_attrib438   : '||pi_rec_nsv.nsv_attrib438,p_level);
   nm_debug.debug('nsv_attrib439   : '||pi_rec_nsv.nsv_attrib439,p_level);
   nm_debug.debug('nsv_attrib440   : '||pi_rec_nsv.nsv_attrib440,p_level);
   nm_debug.debug('nsv_attrib441   : '||pi_rec_nsv.nsv_attrib441,p_level);
   nm_debug.debug('nsv_attrib442   : '||pi_rec_nsv.nsv_attrib442,p_level);
   nm_debug.debug('nsv_attrib443   : '||pi_rec_nsv.nsv_attrib443,p_level);
   nm_debug.debug('nsv_attrib444   : '||pi_rec_nsv.nsv_attrib444,p_level);
   nm_debug.debug('nsv_attrib445   : '||pi_rec_nsv.nsv_attrib445,p_level);
   nm_debug.debug('nsv_attrib446   : '||pi_rec_nsv.nsv_attrib446,p_level);
   nm_debug.debug('nsv_attrib447   : '||pi_rec_nsv.nsv_attrib447,p_level);
   nm_debug.debug('nsv_attrib448   : '||pi_rec_nsv.nsv_attrib448,p_level);
   nm_debug.debug('nsv_attrib449   : '||pi_rec_nsv.nsv_attrib449,p_level);
   nm_debug.debug('nsv_attrib450   : '||pi_rec_nsv.nsv_attrib450,p_level);
   nm_debug.debug('nsv_attrib451   : '||pi_rec_nsv.nsv_attrib451,p_level);
   nm_debug.debug('nsv_attrib452   : '||pi_rec_nsv.nsv_attrib452,p_level);
   nm_debug.debug('nsv_attrib453   : '||pi_rec_nsv.nsv_attrib453,p_level);
   nm_debug.debug('nsv_attrib454   : '||pi_rec_nsv.nsv_attrib454,p_level);
   nm_debug.debug('nsv_attrib455   : '||pi_rec_nsv.nsv_attrib455,p_level);
   nm_debug.debug('nsv_attrib456   : '||pi_rec_nsv.nsv_attrib456,p_level);
   nm_debug.debug('nsv_attrib457   : '||pi_rec_nsv.nsv_attrib457,p_level);
   nm_debug.debug('nsv_attrib458   : '||pi_rec_nsv.nsv_attrib458,p_level);
   nm_debug.debug('nsv_attrib459   : '||pi_rec_nsv.nsv_attrib459,p_level);
   nm_debug.debug('nsv_attrib460   : '||pi_rec_nsv.nsv_attrib460,p_level);
   nm_debug.debug('nsv_attrib461   : '||pi_rec_nsv.nsv_attrib461,p_level);
   nm_debug.debug('nsv_attrib462   : '||pi_rec_nsv.nsv_attrib462,p_level);
   nm_debug.debug('nsv_attrib463   : '||pi_rec_nsv.nsv_attrib463,p_level);
   nm_debug.debug('nsv_attrib464   : '||pi_rec_nsv.nsv_attrib464,p_level);
   nm_debug.debug('nsv_attrib465   : '||pi_rec_nsv.nsv_attrib465,p_level);
   nm_debug.debug('nsv_attrib466   : '||pi_rec_nsv.nsv_attrib466,p_level);
   nm_debug.debug('nsv_attrib467   : '||pi_rec_nsv.nsv_attrib467,p_level);
   nm_debug.debug('nsv_attrib468   : '||pi_rec_nsv.nsv_attrib468,p_level);
   nm_debug.debug('nsv_attrib469   : '||pi_rec_nsv.nsv_attrib469,p_level);
   nm_debug.debug('nsv_attrib470   : '||pi_rec_nsv.nsv_attrib470,p_level);
   nm_debug.debug('nsv_attrib471   : '||pi_rec_nsv.nsv_attrib471,p_level);
   nm_debug.debug('nsv_attrib472   : '||pi_rec_nsv.nsv_attrib472,p_level);
   nm_debug.debug('nsv_attrib473   : '||pi_rec_nsv.nsv_attrib473,p_level);
   nm_debug.debug('nsv_attrib474   : '||pi_rec_nsv.nsv_attrib474,p_level);
   nm_debug.debug('nsv_attrib475   : '||pi_rec_nsv.nsv_attrib475,p_level);
   nm_debug.debug('nsv_attrib476   : '||pi_rec_nsv.nsv_attrib476,p_level);
   nm_debug.debug('nsv_attrib477   : '||pi_rec_nsv.nsv_attrib477,p_level);
   nm_debug.debug('nsv_attrib478   : '||pi_rec_nsv.nsv_attrib478,p_level);
   nm_debug.debug('nsv_attrib479   : '||pi_rec_nsv.nsv_attrib479,p_level);
   nm_debug.debug('nsv_attrib480   : '||pi_rec_nsv.nsv_attrib480,p_level);
   nm_debug.debug('nsv_attrib481   : '||pi_rec_nsv.nsv_attrib481,p_level);
   nm_debug.debug('nsv_attrib482   : '||pi_rec_nsv.nsv_attrib482,p_level);
   nm_debug.debug('nsv_attrib483   : '||pi_rec_nsv.nsv_attrib483,p_level);
   nm_debug.debug('nsv_attrib484   : '||pi_rec_nsv.nsv_attrib484,p_level);
   nm_debug.debug('nsv_attrib485   : '||pi_rec_nsv.nsv_attrib485,p_level);
   nm_debug.debug('nsv_attrib486   : '||pi_rec_nsv.nsv_attrib486,p_level);
   nm_debug.debug('nsv_attrib487   : '||pi_rec_nsv.nsv_attrib487,p_level);
   nm_debug.debug('nsv_attrib488   : '||pi_rec_nsv.nsv_attrib488,p_level);
   nm_debug.debug('nsv_attrib489   : '||pi_rec_nsv.nsv_attrib489,p_level);
   nm_debug.debug('nsv_attrib490   : '||pi_rec_nsv.nsv_attrib490,p_level);
   nm_debug.debug('nsv_attrib491   : '||pi_rec_nsv.nsv_attrib491,p_level);
   nm_debug.debug('nsv_attrib492   : '||pi_rec_nsv.nsv_attrib492,p_level);
   nm_debug.debug('nsv_attrib493   : '||pi_rec_nsv.nsv_attrib493,p_level);
   nm_debug.debug('nsv_attrib494   : '||pi_rec_nsv.nsv_attrib494,p_level);
   nm_debug.debug('nsv_attrib495   : '||pi_rec_nsv.nsv_attrib495,p_level);
   nm_debug.debug('nsv_attrib496   : '||pi_rec_nsv.nsv_attrib496,p_level);
   nm_debug.debug('nsv_attrib497   : '||pi_rec_nsv.nsv_attrib497,p_level);
   nm_debug.debug('nsv_attrib498   : '||pi_rec_nsv.nsv_attrib498,p_level);
   nm_debug.debug('nsv_attrib499   : '||pi_rec_nsv.nsv_attrib499,p_level);
   nm_debug.debug('nsv_attrib500   : '||pi_rec_nsv.nsv_attrib500,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nsv');
--
END debug_nsv;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nsv_all (pi_rec_nsv_all nm_mrg_section_inv_values_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nsv_all');
--
   nm_debug.debug('nsv_mrg_job_id  : '||pi_rec_nsv_all.nsv_mrg_job_id,p_level);
   nm_debug.debug('nsv_value_id    : '||pi_rec_nsv_all.nsv_value_id,p_level);
   nm_debug.debug('nsv_inv_type    : '||pi_rec_nsv_all.nsv_inv_type,p_level);
   nm_debug.debug('nsv_x_sect      : '||pi_rec_nsv_all.nsv_x_sect,p_level);
   nm_debug.debug('nsv_pnt_or_cont : '||pi_rec_nsv_all.nsv_pnt_or_cont,p_level);
   nm_debug.debug('nsv_attrib1     : '||pi_rec_nsv_all.nsv_attrib1,p_level);
   nm_debug.debug('nsv_attrib2     : '||pi_rec_nsv_all.nsv_attrib2,p_level);
   nm_debug.debug('nsv_attrib3     : '||pi_rec_nsv_all.nsv_attrib3,p_level);
   nm_debug.debug('nsv_attrib4     : '||pi_rec_nsv_all.nsv_attrib4,p_level);
   nm_debug.debug('nsv_attrib5     : '||pi_rec_nsv_all.nsv_attrib5,p_level);
   nm_debug.debug('nsv_attrib6     : '||pi_rec_nsv_all.nsv_attrib6,p_level);
   nm_debug.debug('nsv_attrib7     : '||pi_rec_nsv_all.nsv_attrib7,p_level);
   nm_debug.debug('nsv_attrib8     : '||pi_rec_nsv_all.nsv_attrib8,p_level);
   nm_debug.debug('nsv_attrib9     : '||pi_rec_nsv_all.nsv_attrib9,p_level);
   nm_debug.debug('nsv_attrib10    : '||pi_rec_nsv_all.nsv_attrib10,p_level);
   nm_debug.debug('nsv_attrib11    : '||pi_rec_nsv_all.nsv_attrib11,p_level);
   nm_debug.debug('nsv_attrib12    : '||pi_rec_nsv_all.nsv_attrib12,p_level);
   nm_debug.debug('nsv_attrib13    : '||pi_rec_nsv_all.nsv_attrib13,p_level);
   nm_debug.debug('nsv_attrib14    : '||pi_rec_nsv_all.nsv_attrib14,p_level);
   nm_debug.debug('nsv_attrib15    : '||pi_rec_nsv_all.nsv_attrib15,p_level);
   nm_debug.debug('nsv_attrib16    : '||pi_rec_nsv_all.nsv_attrib16,p_level);
   nm_debug.debug('nsv_attrib17    : '||pi_rec_nsv_all.nsv_attrib17,p_level);
   nm_debug.debug('nsv_attrib18    : '||pi_rec_nsv_all.nsv_attrib18,p_level);
   nm_debug.debug('nsv_attrib19    : '||pi_rec_nsv_all.nsv_attrib19,p_level);
   nm_debug.debug('nsv_attrib20    : '||pi_rec_nsv_all.nsv_attrib20,p_level);
   nm_debug.debug('nsv_attrib21    : '||pi_rec_nsv_all.nsv_attrib21,p_level);
   nm_debug.debug('nsv_attrib22    : '||pi_rec_nsv_all.nsv_attrib22,p_level);
   nm_debug.debug('nsv_attrib23    : '||pi_rec_nsv_all.nsv_attrib23,p_level);
   nm_debug.debug('nsv_attrib24    : '||pi_rec_nsv_all.nsv_attrib24,p_level);
   nm_debug.debug('nsv_attrib25    : '||pi_rec_nsv_all.nsv_attrib25,p_level);
   nm_debug.debug('nsv_attrib26    : '||pi_rec_nsv_all.nsv_attrib26,p_level);
   nm_debug.debug('nsv_attrib27    : '||pi_rec_nsv_all.nsv_attrib27,p_level);
   nm_debug.debug('nsv_attrib28    : '||pi_rec_nsv_all.nsv_attrib28,p_level);
   nm_debug.debug('nsv_attrib29    : '||pi_rec_nsv_all.nsv_attrib29,p_level);
   nm_debug.debug('nsv_attrib30    : '||pi_rec_nsv_all.nsv_attrib30,p_level);
   nm_debug.debug('nsv_attrib31    : '||pi_rec_nsv_all.nsv_attrib31,p_level);
   nm_debug.debug('nsv_attrib32    : '||pi_rec_nsv_all.nsv_attrib32,p_level);
   nm_debug.debug('nsv_attrib33    : '||pi_rec_nsv_all.nsv_attrib33,p_level);
   nm_debug.debug('nsv_attrib34    : '||pi_rec_nsv_all.nsv_attrib34,p_level);
   nm_debug.debug('nsv_attrib35    : '||pi_rec_nsv_all.nsv_attrib35,p_level);
   nm_debug.debug('nsv_attrib36    : '||pi_rec_nsv_all.nsv_attrib36,p_level);
   nm_debug.debug('nsv_attrib37    : '||pi_rec_nsv_all.nsv_attrib37,p_level);
   nm_debug.debug('nsv_attrib38    : '||pi_rec_nsv_all.nsv_attrib38,p_level);
   nm_debug.debug('nsv_attrib39    : '||pi_rec_nsv_all.nsv_attrib39,p_level);
   nm_debug.debug('nsv_attrib40    : '||pi_rec_nsv_all.nsv_attrib40,p_level);
   nm_debug.debug('nsv_attrib41    : '||pi_rec_nsv_all.nsv_attrib41,p_level);
   nm_debug.debug('nsv_attrib42    : '||pi_rec_nsv_all.nsv_attrib42,p_level);
   nm_debug.debug('nsv_attrib43    : '||pi_rec_nsv_all.nsv_attrib43,p_level);
   nm_debug.debug('nsv_attrib44    : '||pi_rec_nsv_all.nsv_attrib44,p_level);
   nm_debug.debug('nsv_attrib45    : '||pi_rec_nsv_all.nsv_attrib45,p_level);
   nm_debug.debug('nsv_attrib46    : '||pi_rec_nsv_all.nsv_attrib46,p_level);
   nm_debug.debug('nsv_attrib47    : '||pi_rec_nsv_all.nsv_attrib47,p_level);
   nm_debug.debug('nsv_attrib48    : '||pi_rec_nsv_all.nsv_attrib48,p_level);
   nm_debug.debug('nsv_attrib49    : '||pi_rec_nsv_all.nsv_attrib49,p_level);
   nm_debug.debug('nsv_attrib50    : '||pi_rec_nsv_all.nsv_attrib50,p_level);
   nm_debug.debug('nsv_attrib51    : '||pi_rec_nsv_all.nsv_attrib51,p_level);
   nm_debug.debug('nsv_attrib52    : '||pi_rec_nsv_all.nsv_attrib52,p_level);
   nm_debug.debug('nsv_attrib53    : '||pi_rec_nsv_all.nsv_attrib53,p_level);
   nm_debug.debug('nsv_attrib54    : '||pi_rec_nsv_all.nsv_attrib54,p_level);
   nm_debug.debug('nsv_attrib55    : '||pi_rec_nsv_all.nsv_attrib55,p_level);
   nm_debug.debug('nsv_attrib56    : '||pi_rec_nsv_all.nsv_attrib56,p_level);
   nm_debug.debug('nsv_attrib57    : '||pi_rec_nsv_all.nsv_attrib57,p_level);
   nm_debug.debug('nsv_attrib58    : '||pi_rec_nsv_all.nsv_attrib58,p_level);
   nm_debug.debug('nsv_attrib59    : '||pi_rec_nsv_all.nsv_attrib59,p_level);
   nm_debug.debug('nsv_attrib60    : '||pi_rec_nsv_all.nsv_attrib60,p_level);
   nm_debug.debug('nsv_attrib61    : '||pi_rec_nsv_all.nsv_attrib61,p_level);
   nm_debug.debug('nsv_attrib62    : '||pi_rec_nsv_all.nsv_attrib62,p_level);
   nm_debug.debug('nsv_attrib63    : '||pi_rec_nsv_all.nsv_attrib63,p_level);
   nm_debug.debug('nsv_attrib64    : '||pi_rec_nsv_all.nsv_attrib64,p_level);
   nm_debug.debug('nsv_attrib65    : '||pi_rec_nsv_all.nsv_attrib65,p_level);
   nm_debug.debug('nsv_attrib66    : '||pi_rec_nsv_all.nsv_attrib66,p_level);
   nm_debug.debug('nsv_attrib67    : '||pi_rec_nsv_all.nsv_attrib67,p_level);
   nm_debug.debug('nsv_attrib68    : '||pi_rec_nsv_all.nsv_attrib68,p_level);
   nm_debug.debug('nsv_attrib69    : '||pi_rec_nsv_all.nsv_attrib69,p_level);
   nm_debug.debug('nsv_attrib70    : '||pi_rec_nsv_all.nsv_attrib70,p_level);
   nm_debug.debug('nsv_attrib71    : '||pi_rec_nsv_all.nsv_attrib71,p_level);
   nm_debug.debug('nsv_attrib72    : '||pi_rec_nsv_all.nsv_attrib72,p_level);
   nm_debug.debug('nsv_attrib73    : '||pi_rec_nsv_all.nsv_attrib73,p_level);
   nm_debug.debug('nsv_attrib74    : '||pi_rec_nsv_all.nsv_attrib74,p_level);
   nm_debug.debug('nsv_attrib75    : '||pi_rec_nsv_all.nsv_attrib75,p_level);
   nm_debug.debug('nsv_attrib76    : '||pi_rec_nsv_all.nsv_attrib76,p_level);
   nm_debug.debug('nsv_attrib77    : '||pi_rec_nsv_all.nsv_attrib77,p_level);
   nm_debug.debug('nsv_attrib78    : '||pi_rec_nsv_all.nsv_attrib78,p_level);
   nm_debug.debug('nsv_attrib79    : '||pi_rec_nsv_all.nsv_attrib79,p_level);
   nm_debug.debug('nsv_attrib80    : '||pi_rec_nsv_all.nsv_attrib80,p_level);
   nm_debug.debug('nsv_attrib81    : '||pi_rec_nsv_all.nsv_attrib81,p_level);
   nm_debug.debug('nsv_attrib82    : '||pi_rec_nsv_all.nsv_attrib82,p_level);
   nm_debug.debug('nsv_attrib83    : '||pi_rec_nsv_all.nsv_attrib83,p_level);
   nm_debug.debug('nsv_attrib84    : '||pi_rec_nsv_all.nsv_attrib84,p_level);
   nm_debug.debug('nsv_attrib85    : '||pi_rec_nsv_all.nsv_attrib85,p_level);
   nm_debug.debug('nsv_attrib86    : '||pi_rec_nsv_all.nsv_attrib86,p_level);
   nm_debug.debug('nsv_attrib87    : '||pi_rec_nsv_all.nsv_attrib87,p_level);
   nm_debug.debug('nsv_attrib88    : '||pi_rec_nsv_all.nsv_attrib88,p_level);
   nm_debug.debug('nsv_attrib89    : '||pi_rec_nsv_all.nsv_attrib89,p_level);
   nm_debug.debug('nsv_attrib90    : '||pi_rec_nsv_all.nsv_attrib90,p_level);
   nm_debug.debug('nsv_attrib91    : '||pi_rec_nsv_all.nsv_attrib91,p_level);
   nm_debug.debug('nsv_attrib92    : '||pi_rec_nsv_all.nsv_attrib92,p_level);
   nm_debug.debug('nsv_attrib93    : '||pi_rec_nsv_all.nsv_attrib93,p_level);
   nm_debug.debug('nsv_attrib94    : '||pi_rec_nsv_all.nsv_attrib94,p_level);
   nm_debug.debug('nsv_attrib95    : '||pi_rec_nsv_all.nsv_attrib95,p_level);
   nm_debug.debug('nsv_attrib96    : '||pi_rec_nsv_all.nsv_attrib96,p_level);
   nm_debug.debug('nsv_attrib97    : '||pi_rec_nsv_all.nsv_attrib97,p_level);
   nm_debug.debug('nsv_attrib98    : '||pi_rec_nsv_all.nsv_attrib98,p_level);
   nm_debug.debug('nsv_attrib99    : '||pi_rec_nsv_all.nsv_attrib99,p_level);
   nm_debug.debug('nsv_attrib100   : '||pi_rec_nsv_all.nsv_attrib100,p_level);
   nm_debug.debug('nsv_attrib101   : '||pi_rec_nsv_all.nsv_attrib101,p_level);
   nm_debug.debug('nsv_attrib102   : '||pi_rec_nsv_all.nsv_attrib102,p_level);
   nm_debug.debug('nsv_attrib103   : '||pi_rec_nsv_all.nsv_attrib103,p_level);
   nm_debug.debug('nsv_attrib104   : '||pi_rec_nsv_all.nsv_attrib104,p_level);
   nm_debug.debug('nsv_attrib105   : '||pi_rec_nsv_all.nsv_attrib105,p_level);
   nm_debug.debug('nsv_attrib106   : '||pi_rec_nsv_all.nsv_attrib106,p_level);
   nm_debug.debug('nsv_attrib107   : '||pi_rec_nsv_all.nsv_attrib107,p_level);
   nm_debug.debug('nsv_attrib108   : '||pi_rec_nsv_all.nsv_attrib108,p_level);
   nm_debug.debug('nsv_attrib109   : '||pi_rec_nsv_all.nsv_attrib109,p_level);
   nm_debug.debug('nsv_attrib110   : '||pi_rec_nsv_all.nsv_attrib110,p_level);
   nm_debug.debug('nsv_attrib111   : '||pi_rec_nsv_all.nsv_attrib111,p_level);
   nm_debug.debug('nsv_attrib112   : '||pi_rec_nsv_all.nsv_attrib112,p_level);
   nm_debug.debug('nsv_attrib113   : '||pi_rec_nsv_all.nsv_attrib113,p_level);
   nm_debug.debug('nsv_attrib114   : '||pi_rec_nsv_all.nsv_attrib114,p_level);
   nm_debug.debug('nsv_attrib115   : '||pi_rec_nsv_all.nsv_attrib115,p_level);
   nm_debug.debug('nsv_attrib116   : '||pi_rec_nsv_all.nsv_attrib116,p_level);
   nm_debug.debug('nsv_attrib117   : '||pi_rec_nsv_all.nsv_attrib117,p_level);
   nm_debug.debug('nsv_attrib118   : '||pi_rec_nsv_all.nsv_attrib118,p_level);
   nm_debug.debug('nsv_attrib119   : '||pi_rec_nsv_all.nsv_attrib119,p_level);
   nm_debug.debug('nsv_attrib120   : '||pi_rec_nsv_all.nsv_attrib120,p_level);
   nm_debug.debug('nsv_attrib121   : '||pi_rec_nsv_all.nsv_attrib121,p_level);
   nm_debug.debug('nsv_attrib122   : '||pi_rec_nsv_all.nsv_attrib122,p_level);
   nm_debug.debug('nsv_attrib123   : '||pi_rec_nsv_all.nsv_attrib123,p_level);
   nm_debug.debug('nsv_attrib124   : '||pi_rec_nsv_all.nsv_attrib124,p_level);
   nm_debug.debug('nsv_attrib125   : '||pi_rec_nsv_all.nsv_attrib125,p_level);
   nm_debug.debug('nsv_attrib126   : '||pi_rec_nsv_all.nsv_attrib126,p_level);
   nm_debug.debug('nsv_attrib127   : '||pi_rec_nsv_all.nsv_attrib127,p_level);
   nm_debug.debug('nsv_attrib128   : '||pi_rec_nsv_all.nsv_attrib128,p_level);
   nm_debug.debug('nsv_attrib129   : '||pi_rec_nsv_all.nsv_attrib129,p_level);
   nm_debug.debug('nsv_attrib130   : '||pi_rec_nsv_all.nsv_attrib130,p_level);
   nm_debug.debug('nsv_attrib131   : '||pi_rec_nsv_all.nsv_attrib131,p_level);
   nm_debug.debug('nsv_attrib132   : '||pi_rec_nsv_all.nsv_attrib132,p_level);
   nm_debug.debug('nsv_attrib133   : '||pi_rec_nsv_all.nsv_attrib133,p_level);
   nm_debug.debug('nsv_attrib134   : '||pi_rec_nsv_all.nsv_attrib134,p_level);
   nm_debug.debug('nsv_attrib135   : '||pi_rec_nsv_all.nsv_attrib135,p_level);
   nm_debug.debug('nsv_attrib136   : '||pi_rec_nsv_all.nsv_attrib136,p_level);
   nm_debug.debug('nsv_attrib137   : '||pi_rec_nsv_all.nsv_attrib137,p_level);
   nm_debug.debug('nsv_attrib138   : '||pi_rec_nsv_all.nsv_attrib138,p_level);
   nm_debug.debug('nsv_attrib139   : '||pi_rec_nsv_all.nsv_attrib139,p_level);
   nm_debug.debug('nsv_attrib140   : '||pi_rec_nsv_all.nsv_attrib140,p_level);
   nm_debug.debug('nsv_attrib141   : '||pi_rec_nsv_all.nsv_attrib141,p_level);
   nm_debug.debug('nsv_attrib142   : '||pi_rec_nsv_all.nsv_attrib142,p_level);
   nm_debug.debug('nsv_attrib143   : '||pi_rec_nsv_all.nsv_attrib143,p_level);
   nm_debug.debug('nsv_attrib144   : '||pi_rec_nsv_all.nsv_attrib144,p_level);
   nm_debug.debug('nsv_attrib145   : '||pi_rec_nsv_all.nsv_attrib145,p_level);
   nm_debug.debug('nsv_attrib146   : '||pi_rec_nsv_all.nsv_attrib146,p_level);
   nm_debug.debug('nsv_attrib147   : '||pi_rec_nsv_all.nsv_attrib147,p_level);
   nm_debug.debug('nsv_attrib148   : '||pi_rec_nsv_all.nsv_attrib148,p_level);
   nm_debug.debug('nsv_attrib149   : '||pi_rec_nsv_all.nsv_attrib149,p_level);
   nm_debug.debug('nsv_attrib150   : '||pi_rec_nsv_all.nsv_attrib150,p_level);
   nm_debug.debug('nsv_attrib151   : '||pi_rec_nsv_all.nsv_attrib151,p_level);
   nm_debug.debug('nsv_attrib152   : '||pi_rec_nsv_all.nsv_attrib152,p_level);
   nm_debug.debug('nsv_attrib153   : '||pi_rec_nsv_all.nsv_attrib153,p_level);
   nm_debug.debug('nsv_attrib154   : '||pi_rec_nsv_all.nsv_attrib154,p_level);
   nm_debug.debug('nsv_attrib155   : '||pi_rec_nsv_all.nsv_attrib155,p_level);
   nm_debug.debug('nsv_attrib156   : '||pi_rec_nsv_all.nsv_attrib156,p_level);
   nm_debug.debug('nsv_attrib157   : '||pi_rec_nsv_all.nsv_attrib157,p_level);
   nm_debug.debug('nsv_attrib158   : '||pi_rec_nsv_all.nsv_attrib158,p_level);
   nm_debug.debug('nsv_attrib159   : '||pi_rec_nsv_all.nsv_attrib159,p_level);
   nm_debug.debug('nsv_attrib160   : '||pi_rec_nsv_all.nsv_attrib160,p_level);
   nm_debug.debug('nsv_attrib161   : '||pi_rec_nsv_all.nsv_attrib161,p_level);
   nm_debug.debug('nsv_attrib162   : '||pi_rec_nsv_all.nsv_attrib162,p_level);
   nm_debug.debug('nsv_attrib163   : '||pi_rec_nsv_all.nsv_attrib163,p_level);
   nm_debug.debug('nsv_attrib164   : '||pi_rec_nsv_all.nsv_attrib164,p_level);
   nm_debug.debug('nsv_attrib165   : '||pi_rec_nsv_all.nsv_attrib165,p_level);
   nm_debug.debug('nsv_attrib166   : '||pi_rec_nsv_all.nsv_attrib166,p_level);
   nm_debug.debug('nsv_attrib167   : '||pi_rec_nsv_all.nsv_attrib167,p_level);
   nm_debug.debug('nsv_attrib168   : '||pi_rec_nsv_all.nsv_attrib168,p_level);
   nm_debug.debug('nsv_attrib169   : '||pi_rec_nsv_all.nsv_attrib169,p_level);
   nm_debug.debug('nsv_attrib170   : '||pi_rec_nsv_all.nsv_attrib170,p_level);
   nm_debug.debug('nsv_attrib171   : '||pi_rec_nsv_all.nsv_attrib171,p_level);
   nm_debug.debug('nsv_attrib172   : '||pi_rec_nsv_all.nsv_attrib172,p_level);
   nm_debug.debug('nsv_attrib173   : '||pi_rec_nsv_all.nsv_attrib173,p_level);
   nm_debug.debug('nsv_attrib174   : '||pi_rec_nsv_all.nsv_attrib174,p_level);
   nm_debug.debug('nsv_attrib175   : '||pi_rec_nsv_all.nsv_attrib175,p_level);
   nm_debug.debug('nsv_attrib176   : '||pi_rec_nsv_all.nsv_attrib176,p_level);
   nm_debug.debug('nsv_attrib177   : '||pi_rec_nsv_all.nsv_attrib177,p_level);
   nm_debug.debug('nsv_attrib178   : '||pi_rec_nsv_all.nsv_attrib178,p_level);
   nm_debug.debug('nsv_attrib179   : '||pi_rec_nsv_all.nsv_attrib179,p_level);
   nm_debug.debug('nsv_attrib180   : '||pi_rec_nsv_all.nsv_attrib180,p_level);
   nm_debug.debug('nsv_attrib181   : '||pi_rec_nsv_all.nsv_attrib181,p_level);
   nm_debug.debug('nsv_attrib182   : '||pi_rec_nsv_all.nsv_attrib182,p_level);
   nm_debug.debug('nsv_attrib183   : '||pi_rec_nsv_all.nsv_attrib183,p_level);
   nm_debug.debug('nsv_attrib184   : '||pi_rec_nsv_all.nsv_attrib184,p_level);
   nm_debug.debug('nsv_attrib185   : '||pi_rec_nsv_all.nsv_attrib185,p_level);
   nm_debug.debug('nsv_attrib186   : '||pi_rec_nsv_all.nsv_attrib186,p_level);
   nm_debug.debug('nsv_attrib187   : '||pi_rec_nsv_all.nsv_attrib187,p_level);
   nm_debug.debug('nsv_attrib188   : '||pi_rec_nsv_all.nsv_attrib188,p_level);
   nm_debug.debug('nsv_attrib189   : '||pi_rec_nsv_all.nsv_attrib189,p_level);
   nm_debug.debug('nsv_attrib190   : '||pi_rec_nsv_all.nsv_attrib190,p_level);
   nm_debug.debug('nsv_attrib191   : '||pi_rec_nsv_all.nsv_attrib191,p_level);
   nm_debug.debug('nsv_attrib192   : '||pi_rec_nsv_all.nsv_attrib192,p_level);
   nm_debug.debug('nsv_attrib193   : '||pi_rec_nsv_all.nsv_attrib193,p_level);
   nm_debug.debug('nsv_attrib194   : '||pi_rec_nsv_all.nsv_attrib194,p_level);
   nm_debug.debug('nsv_attrib195   : '||pi_rec_nsv_all.nsv_attrib195,p_level);
   nm_debug.debug('nsv_attrib196   : '||pi_rec_nsv_all.nsv_attrib196,p_level);
   nm_debug.debug('nsv_attrib197   : '||pi_rec_nsv_all.nsv_attrib197,p_level);
   nm_debug.debug('nsv_attrib198   : '||pi_rec_nsv_all.nsv_attrib198,p_level);
   nm_debug.debug('nsv_attrib199   : '||pi_rec_nsv_all.nsv_attrib199,p_level);
   nm_debug.debug('nsv_attrib200   : '||pi_rec_nsv_all.nsv_attrib200,p_level);
   nm_debug.debug('nsv_attrib201   : '||pi_rec_nsv_all.nsv_attrib201,p_level);
   nm_debug.debug('nsv_attrib202   : '||pi_rec_nsv_all.nsv_attrib202,p_level);
   nm_debug.debug('nsv_attrib203   : '||pi_rec_nsv_all.nsv_attrib203,p_level);
   nm_debug.debug('nsv_attrib204   : '||pi_rec_nsv_all.nsv_attrib204,p_level);
   nm_debug.debug('nsv_attrib205   : '||pi_rec_nsv_all.nsv_attrib205,p_level);
   nm_debug.debug('nsv_attrib206   : '||pi_rec_nsv_all.nsv_attrib206,p_level);
   nm_debug.debug('nsv_attrib207   : '||pi_rec_nsv_all.nsv_attrib207,p_level);
   nm_debug.debug('nsv_attrib208   : '||pi_rec_nsv_all.nsv_attrib208,p_level);
   nm_debug.debug('nsv_attrib209   : '||pi_rec_nsv_all.nsv_attrib209,p_level);
   nm_debug.debug('nsv_attrib210   : '||pi_rec_nsv_all.nsv_attrib210,p_level);
   nm_debug.debug('nsv_attrib211   : '||pi_rec_nsv_all.nsv_attrib211,p_level);
   nm_debug.debug('nsv_attrib212   : '||pi_rec_nsv_all.nsv_attrib212,p_level);
   nm_debug.debug('nsv_attrib213   : '||pi_rec_nsv_all.nsv_attrib213,p_level);
   nm_debug.debug('nsv_attrib214   : '||pi_rec_nsv_all.nsv_attrib214,p_level);
   nm_debug.debug('nsv_attrib215   : '||pi_rec_nsv_all.nsv_attrib215,p_level);
   nm_debug.debug('nsv_attrib216   : '||pi_rec_nsv_all.nsv_attrib216,p_level);
   nm_debug.debug('nsv_attrib217   : '||pi_rec_nsv_all.nsv_attrib217,p_level);
   nm_debug.debug('nsv_attrib218   : '||pi_rec_nsv_all.nsv_attrib218,p_level);
   nm_debug.debug('nsv_attrib219   : '||pi_rec_nsv_all.nsv_attrib219,p_level);
   nm_debug.debug('nsv_attrib220   : '||pi_rec_nsv_all.nsv_attrib220,p_level);
   nm_debug.debug('nsv_attrib221   : '||pi_rec_nsv_all.nsv_attrib221,p_level);
   nm_debug.debug('nsv_attrib222   : '||pi_rec_nsv_all.nsv_attrib222,p_level);
   nm_debug.debug('nsv_attrib223   : '||pi_rec_nsv_all.nsv_attrib223,p_level);
   nm_debug.debug('nsv_attrib224   : '||pi_rec_nsv_all.nsv_attrib224,p_level);
   nm_debug.debug('nsv_attrib225   : '||pi_rec_nsv_all.nsv_attrib225,p_level);
   nm_debug.debug('nsv_attrib226   : '||pi_rec_nsv_all.nsv_attrib226,p_level);
   nm_debug.debug('nsv_attrib227   : '||pi_rec_nsv_all.nsv_attrib227,p_level);
   nm_debug.debug('nsv_attrib228   : '||pi_rec_nsv_all.nsv_attrib228,p_level);
   nm_debug.debug('nsv_attrib229   : '||pi_rec_nsv_all.nsv_attrib229,p_level);
   nm_debug.debug('nsv_attrib230   : '||pi_rec_nsv_all.nsv_attrib230,p_level);
   nm_debug.debug('nsv_attrib231   : '||pi_rec_nsv_all.nsv_attrib231,p_level);
   nm_debug.debug('nsv_attrib232   : '||pi_rec_nsv_all.nsv_attrib232,p_level);
   nm_debug.debug('nsv_attrib233   : '||pi_rec_nsv_all.nsv_attrib233,p_level);
   nm_debug.debug('nsv_attrib234   : '||pi_rec_nsv_all.nsv_attrib234,p_level);
   nm_debug.debug('nsv_attrib235   : '||pi_rec_nsv_all.nsv_attrib235,p_level);
   nm_debug.debug('nsv_attrib236   : '||pi_rec_nsv_all.nsv_attrib236,p_level);
   nm_debug.debug('nsv_attrib237   : '||pi_rec_nsv_all.nsv_attrib237,p_level);
   nm_debug.debug('nsv_attrib238   : '||pi_rec_nsv_all.nsv_attrib238,p_level);
   nm_debug.debug('nsv_attrib239   : '||pi_rec_nsv_all.nsv_attrib239,p_level);
   nm_debug.debug('nsv_attrib240   : '||pi_rec_nsv_all.nsv_attrib240,p_level);
   nm_debug.debug('nsv_attrib241   : '||pi_rec_nsv_all.nsv_attrib241,p_level);
   nm_debug.debug('nsv_attrib242   : '||pi_rec_nsv_all.nsv_attrib242,p_level);
   nm_debug.debug('nsv_attrib243   : '||pi_rec_nsv_all.nsv_attrib243,p_level);
   nm_debug.debug('nsv_attrib244   : '||pi_rec_nsv_all.nsv_attrib244,p_level);
   nm_debug.debug('nsv_attrib245   : '||pi_rec_nsv_all.nsv_attrib245,p_level);
   nm_debug.debug('nsv_attrib246   : '||pi_rec_nsv_all.nsv_attrib246,p_level);
   nm_debug.debug('nsv_attrib247   : '||pi_rec_nsv_all.nsv_attrib247,p_level);
   nm_debug.debug('nsv_attrib248   : '||pi_rec_nsv_all.nsv_attrib248,p_level);
   nm_debug.debug('nsv_attrib249   : '||pi_rec_nsv_all.nsv_attrib249,p_level);
   nm_debug.debug('nsv_attrib250   : '||pi_rec_nsv_all.nsv_attrib250,p_level);
   nm_debug.debug('nsv_attrib251   : '||pi_rec_nsv_all.nsv_attrib251,p_level);
   nm_debug.debug('nsv_attrib252   : '||pi_rec_nsv_all.nsv_attrib252,p_level);
   nm_debug.debug('nsv_attrib253   : '||pi_rec_nsv_all.nsv_attrib253,p_level);
   nm_debug.debug('nsv_attrib254   : '||pi_rec_nsv_all.nsv_attrib254,p_level);
   nm_debug.debug('nsv_attrib255   : '||pi_rec_nsv_all.nsv_attrib255,p_level);
   nm_debug.debug('nsv_attrib256   : '||pi_rec_nsv_all.nsv_attrib256,p_level);
   nm_debug.debug('nsv_attrib257   : '||pi_rec_nsv_all.nsv_attrib257,p_level);
   nm_debug.debug('nsv_attrib258   : '||pi_rec_nsv_all.nsv_attrib258,p_level);
   nm_debug.debug('nsv_attrib259   : '||pi_rec_nsv_all.nsv_attrib259,p_level);
   nm_debug.debug('nsv_attrib260   : '||pi_rec_nsv_all.nsv_attrib260,p_level);
   nm_debug.debug('nsv_attrib261   : '||pi_rec_nsv_all.nsv_attrib261,p_level);
   nm_debug.debug('nsv_attrib262   : '||pi_rec_nsv_all.nsv_attrib262,p_level);
   nm_debug.debug('nsv_attrib263   : '||pi_rec_nsv_all.nsv_attrib263,p_level);
   nm_debug.debug('nsv_attrib264   : '||pi_rec_nsv_all.nsv_attrib264,p_level);
   nm_debug.debug('nsv_attrib265   : '||pi_rec_nsv_all.nsv_attrib265,p_level);
   nm_debug.debug('nsv_attrib266   : '||pi_rec_nsv_all.nsv_attrib266,p_level);
   nm_debug.debug('nsv_attrib267   : '||pi_rec_nsv_all.nsv_attrib267,p_level);
   nm_debug.debug('nsv_attrib268   : '||pi_rec_nsv_all.nsv_attrib268,p_level);
   nm_debug.debug('nsv_attrib269   : '||pi_rec_nsv_all.nsv_attrib269,p_level);
   nm_debug.debug('nsv_attrib270   : '||pi_rec_nsv_all.nsv_attrib270,p_level);
   nm_debug.debug('nsv_attrib271   : '||pi_rec_nsv_all.nsv_attrib271,p_level);
   nm_debug.debug('nsv_attrib272   : '||pi_rec_nsv_all.nsv_attrib272,p_level);
   nm_debug.debug('nsv_attrib273   : '||pi_rec_nsv_all.nsv_attrib273,p_level);
   nm_debug.debug('nsv_attrib274   : '||pi_rec_nsv_all.nsv_attrib274,p_level);
   nm_debug.debug('nsv_attrib275   : '||pi_rec_nsv_all.nsv_attrib275,p_level);
   nm_debug.debug('nsv_attrib276   : '||pi_rec_nsv_all.nsv_attrib276,p_level);
   nm_debug.debug('nsv_attrib277   : '||pi_rec_nsv_all.nsv_attrib277,p_level);
   nm_debug.debug('nsv_attrib278   : '||pi_rec_nsv_all.nsv_attrib278,p_level);
   nm_debug.debug('nsv_attrib279   : '||pi_rec_nsv_all.nsv_attrib279,p_level);
   nm_debug.debug('nsv_attrib280   : '||pi_rec_nsv_all.nsv_attrib280,p_level);
   nm_debug.debug('nsv_attrib281   : '||pi_rec_nsv_all.nsv_attrib281,p_level);
   nm_debug.debug('nsv_attrib282   : '||pi_rec_nsv_all.nsv_attrib282,p_level);
   nm_debug.debug('nsv_attrib283   : '||pi_rec_nsv_all.nsv_attrib283,p_level);
   nm_debug.debug('nsv_attrib284   : '||pi_rec_nsv_all.nsv_attrib284,p_level);
   nm_debug.debug('nsv_attrib285   : '||pi_rec_nsv_all.nsv_attrib285,p_level);
   nm_debug.debug('nsv_attrib286   : '||pi_rec_nsv_all.nsv_attrib286,p_level);
   nm_debug.debug('nsv_attrib287   : '||pi_rec_nsv_all.nsv_attrib287,p_level);
   nm_debug.debug('nsv_attrib288   : '||pi_rec_nsv_all.nsv_attrib288,p_level);
   nm_debug.debug('nsv_attrib289   : '||pi_rec_nsv_all.nsv_attrib289,p_level);
   nm_debug.debug('nsv_attrib290   : '||pi_rec_nsv_all.nsv_attrib290,p_level);
   nm_debug.debug('nsv_attrib291   : '||pi_rec_nsv_all.nsv_attrib291,p_level);
   nm_debug.debug('nsv_attrib292   : '||pi_rec_nsv_all.nsv_attrib292,p_level);
   nm_debug.debug('nsv_attrib293   : '||pi_rec_nsv_all.nsv_attrib293,p_level);
   nm_debug.debug('nsv_attrib294   : '||pi_rec_nsv_all.nsv_attrib294,p_level);
   nm_debug.debug('nsv_attrib295   : '||pi_rec_nsv_all.nsv_attrib295,p_level);
   nm_debug.debug('nsv_attrib296   : '||pi_rec_nsv_all.nsv_attrib296,p_level);
   nm_debug.debug('nsv_attrib297   : '||pi_rec_nsv_all.nsv_attrib297,p_level);
   nm_debug.debug('nsv_attrib298   : '||pi_rec_nsv_all.nsv_attrib298,p_level);
   nm_debug.debug('nsv_attrib299   : '||pi_rec_nsv_all.nsv_attrib299,p_level);
   nm_debug.debug('nsv_attrib300   : '||pi_rec_nsv_all.nsv_attrib300,p_level);
   nm_debug.debug('nsv_attrib301   : '||pi_rec_nsv_all.nsv_attrib301,p_level);
   nm_debug.debug('nsv_attrib302   : '||pi_rec_nsv_all.nsv_attrib302,p_level);
   nm_debug.debug('nsv_attrib303   : '||pi_rec_nsv_all.nsv_attrib303,p_level);
   nm_debug.debug('nsv_attrib304   : '||pi_rec_nsv_all.nsv_attrib304,p_level);
   nm_debug.debug('nsv_attrib305   : '||pi_rec_nsv_all.nsv_attrib305,p_level);
   nm_debug.debug('nsv_attrib306   : '||pi_rec_nsv_all.nsv_attrib306,p_level);
   nm_debug.debug('nsv_attrib307   : '||pi_rec_nsv_all.nsv_attrib307,p_level);
   nm_debug.debug('nsv_attrib308   : '||pi_rec_nsv_all.nsv_attrib308,p_level);
   nm_debug.debug('nsv_attrib309   : '||pi_rec_nsv_all.nsv_attrib309,p_level);
   nm_debug.debug('nsv_attrib310   : '||pi_rec_nsv_all.nsv_attrib310,p_level);
   nm_debug.debug('nsv_attrib311   : '||pi_rec_nsv_all.nsv_attrib311,p_level);
   nm_debug.debug('nsv_attrib312   : '||pi_rec_nsv_all.nsv_attrib312,p_level);
   nm_debug.debug('nsv_attrib313   : '||pi_rec_nsv_all.nsv_attrib313,p_level);
   nm_debug.debug('nsv_attrib314   : '||pi_rec_nsv_all.nsv_attrib314,p_level);
   nm_debug.debug('nsv_attrib315   : '||pi_rec_nsv_all.nsv_attrib315,p_level);
   nm_debug.debug('nsv_attrib316   : '||pi_rec_nsv_all.nsv_attrib316,p_level);
   nm_debug.debug('nsv_attrib317   : '||pi_rec_nsv_all.nsv_attrib317,p_level);
   nm_debug.debug('nsv_attrib318   : '||pi_rec_nsv_all.nsv_attrib318,p_level);
   nm_debug.debug('nsv_attrib319   : '||pi_rec_nsv_all.nsv_attrib319,p_level);
   nm_debug.debug('nsv_attrib320   : '||pi_rec_nsv_all.nsv_attrib320,p_level);
   nm_debug.debug('nsv_attrib321   : '||pi_rec_nsv_all.nsv_attrib321,p_level);
   nm_debug.debug('nsv_attrib322   : '||pi_rec_nsv_all.nsv_attrib322,p_level);
   nm_debug.debug('nsv_attrib323   : '||pi_rec_nsv_all.nsv_attrib323,p_level);
   nm_debug.debug('nsv_attrib324   : '||pi_rec_nsv_all.nsv_attrib324,p_level);
   nm_debug.debug('nsv_attrib325   : '||pi_rec_nsv_all.nsv_attrib325,p_level);
   nm_debug.debug('nsv_attrib326   : '||pi_rec_nsv_all.nsv_attrib326,p_level);
   nm_debug.debug('nsv_attrib327   : '||pi_rec_nsv_all.nsv_attrib327,p_level);
   nm_debug.debug('nsv_attrib328   : '||pi_rec_nsv_all.nsv_attrib328,p_level);
   nm_debug.debug('nsv_attrib329   : '||pi_rec_nsv_all.nsv_attrib329,p_level);
   nm_debug.debug('nsv_attrib330   : '||pi_rec_nsv_all.nsv_attrib330,p_level);
   nm_debug.debug('nsv_attrib331   : '||pi_rec_nsv_all.nsv_attrib331,p_level);
   nm_debug.debug('nsv_attrib332   : '||pi_rec_nsv_all.nsv_attrib332,p_level);
   nm_debug.debug('nsv_attrib333   : '||pi_rec_nsv_all.nsv_attrib333,p_level);
   nm_debug.debug('nsv_attrib334   : '||pi_rec_nsv_all.nsv_attrib334,p_level);
   nm_debug.debug('nsv_attrib335   : '||pi_rec_nsv_all.nsv_attrib335,p_level);
   nm_debug.debug('nsv_attrib336   : '||pi_rec_nsv_all.nsv_attrib336,p_level);
   nm_debug.debug('nsv_attrib337   : '||pi_rec_nsv_all.nsv_attrib337,p_level);
   nm_debug.debug('nsv_attrib338   : '||pi_rec_nsv_all.nsv_attrib338,p_level);
   nm_debug.debug('nsv_attrib339   : '||pi_rec_nsv_all.nsv_attrib339,p_level);
   nm_debug.debug('nsv_attrib340   : '||pi_rec_nsv_all.nsv_attrib340,p_level);
   nm_debug.debug('nsv_attrib341   : '||pi_rec_nsv_all.nsv_attrib341,p_level);
   nm_debug.debug('nsv_attrib342   : '||pi_rec_nsv_all.nsv_attrib342,p_level);
   nm_debug.debug('nsv_attrib343   : '||pi_rec_nsv_all.nsv_attrib343,p_level);
   nm_debug.debug('nsv_attrib344   : '||pi_rec_nsv_all.nsv_attrib344,p_level);
   nm_debug.debug('nsv_attrib345   : '||pi_rec_nsv_all.nsv_attrib345,p_level);
   nm_debug.debug('nsv_attrib346   : '||pi_rec_nsv_all.nsv_attrib346,p_level);
   nm_debug.debug('nsv_attrib347   : '||pi_rec_nsv_all.nsv_attrib347,p_level);
   nm_debug.debug('nsv_attrib348   : '||pi_rec_nsv_all.nsv_attrib348,p_level);
   nm_debug.debug('nsv_attrib349   : '||pi_rec_nsv_all.nsv_attrib349,p_level);
   nm_debug.debug('nsv_attrib350   : '||pi_rec_nsv_all.nsv_attrib350,p_level);
   nm_debug.debug('nsv_attrib351   : '||pi_rec_nsv_all.nsv_attrib351,p_level);
   nm_debug.debug('nsv_attrib352   : '||pi_rec_nsv_all.nsv_attrib352,p_level);
   nm_debug.debug('nsv_attrib353   : '||pi_rec_nsv_all.nsv_attrib353,p_level);
   nm_debug.debug('nsv_attrib354   : '||pi_rec_nsv_all.nsv_attrib354,p_level);
   nm_debug.debug('nsv_attrib355   : '||pi_rec_nsv_all.nsv_attrib355,p_level);
   nm_debug.debug('nsv_attrib356   : '||pi_rec_nsv_all.nsv_attrib356,p_level);
   nm_debug.debug('nsv_attrib357   : '||pi_rec_nsv_all.nsv_attrib357,p_level);
   nm_debug.debug('nsv_attrib358   : '||pi_rec_nsv_all.nsv_attrib358,p_level);
   nm_debug.debug('nsv_attrib359   : '||pi_rec_nsv_all.nsv_attrib359,p_level);
   nm_debug.debug('nsv_attrib360   : '||pi_rec_nsv_all.nsv_attrib360,p_level);
   nm_debug.debug('nsv_attrib361   : '||pi_rec_nsv_all.nsv_attrib361,p_level);
   nm_debug.debug('nsv_attrib362   : '||pi_rec_nsv_all.nsv_attrib362,p_level);
   nm_debug.debug('nsv_attrib363   : '||pi_rec_nsv_all.nsv_attrib363,p_level);
   nm_debug.debug('nsv_attrib364   : '||pi_rec_nsv_all.nsv_attrib364,p_level);
   nm_debug.debug('nsv_attrib365   : '||pi_rec_nsv_all.nsv_attrib365,p_level);
   nm_debug.debug('nsv_attrib366   : '||pi_rec_nsv_all.nsv_attrib366,p_level);
   nm_debug.debug('nsv_attrib367   : '||pi_rec_nsv_all.nsv_attrib367,p_level);
   nm_debug.debug('nsv_attrib368   : '||pi_rec_nsv_all.nsv_attrib368,p_level);
   nm_debug.debug('nsv_attrib369   : '||pi_rec_nsv_all.nsv_attrib369,p_level);
   nm_debug.debug('nsv_attrib370   : '||pi_rec_nsv_all.nsv_attrib370,p_level);
   nm_debug.debug('nsv_attrib371   : '||pi_rec_nsv_all.nsv_attrib371,p_level);
   nm_debug.debug('nsv_attrib372   : '||pi_rec_nsv_all.nsv_attrib372,p_level);
   nm_debug.debug('nsv_attrib373   : '||pi_rec_nsv_all.nsv_attrib373,p_level);
   nm_debug.debug('nsv_attrib374   : '||pi_rec_nsv_all.nsv_attrib374,p_level);
   nm_debug.debug('nsv_attrib375   : '||pi_rec_nsv_all.nsv_attrib375,p_level);
   nm_debug.debug('nsv_attrib376   : '||pi_rec_nsv_all.nsv_attrib376,p_level);
   nm_debug.debug('nsv_attrib377   : '||pi_rec_nsv_all.nsv_attrib377,p_level);
   nm_debug.debug('nsv_attrib378   : '||pi_rec_nsv_all.nsv_attrib378,p_level);
   nm_debug.debug('nsv_attrib379   : '||pi_rec_nsv_all.nsv_attrib379,p_level);
   nm_debug.debug('nsv_attrib380   : '||pi_rec_nsv_all.nsv_attrib380,p_level);
   nm_debug.debug('nsv_attrib381   : '||pi_rec_nsv_all.nsv_attrib381,p_level);
   nm_debug.debug('nsv_attrib382   : '||pi_rec_nsv_all.nsv_attrib382,p_level);
   nm_debug.debug('nsv_attrib383   : '||pi_rec_nsv_all.nsv_attrib383,p_level);
   nm_debug.debug('nsv_attrib384   : '||pi_rec_nsv_all.nsv_attrib384,p_level);
   nm_debug.debug('nsv_attrib385   : '||pi_rec_nsv_all.nsv_attrib385,p_level);
   nm_debug.debug('nsv_attrib386   : '||pi_rec_nsv_all.nsv_attrib386,p_level);
   nm_debug.debug('nsv_attrib387   : '||pi_rec_nsv_all.nsv_attrib387,p_level);
   nm_debug.debug('nsv_attrib388   : '||pi_rec_nsv_all.nsv_attrib388,p_level);
   nm_debug.debug('nsv_attrib389   : '||pi_rec_nsv_all.nsv_attrib389,p_level);
   nm_debug.debug('nsv_attrib390   : '||pi_rec_nsv_all.nsv_attrib390,p_level);
   nm_debug.debug('nsv_attrib391   : '||pi_rec_nsv_all.nsv_attrib391,p_level);
   nm_debug.debug('nsv_attrib392   : '||pi_rec_nsv_all.nsv_attrib392,p_level);
   nm_debug.debug('nsv_attrib393   : '||pi_rec_nsv_all.nsv_attrib393,p_level);
   nm_debug.debug('nsv_attrib394   : '||pi_rec_nsv_all.nsv_attrib394,p_level);
   nm_debug.debug('nsv_attrib395   : '||pi_rec_nsv_all.nsv_attrib395,p_level);
   nm_debug.debug('nsv_attrib396   : '||pi_rec_nsv_all.nsv_attrib396,p_level);
   nm_debug.debug('nsv_attrib397   : '||pi_rec_nsv_all.nsv_attrib397,p_level);
   nm_debug.debug('nsv_attrib398   : '||pi_rec_nsv_all.nsv_attrib398,p_level);
   nm_debug.debug('nsv_attrib399   : '||pi_rec_nsv_all.nsv_attrib399,p_level);
   nm_debug.debug('nsv_attrib400   : '||pi_rec_nsv_all.nsv_attrib400,p_level);
   nm_debug.debug('nsv_attrib401   : '||pi_rec_nsv_all.nsv_attrib401,p_level);
   nm_debug.debug('nsv_attrib402   : '||pi_rec_nsv_all.nsv_attrib402,p_level);
   nm_debug.debug('nsv_attrib403   : '||pi_rec_nsv_all.nsv_attrib403,p_level);
   nm_debug.debug('nsv_attrib404   : '||pi_rec_nsv_all.nsv_attrib404,p_level);
   nm_debug.debug('nsv_attrib405   : '||pi_rec_nsv_all.nsv_attrib405,p_level);
   nm_debug.debug('nsv_attrib406   : '||pi_rec_nsv_all.nsv_attrib406,p_level);
   nm_debug.debug('nsv_attrib407   : '||pi_rec_nsv_all.nsv_attrib407,p_level);
   nm_debug.debug('nsv_attrib408   : '||pi_rec_nsv_all.nsv_attrib408,p_level);
   nm_debug.debug('nsv_attrib409   : '||pi_rec_nsv_all.nsv_attrib409,p_level);
   nm_debug.debug('nsv_attrib410   : '||pi_rec_nsv_all.nsv_attrib410,p_level);
   nm_debug.debug('nsv_attrib411   : '||pi_rec_nsv_all.nsv_attrib411,p_level);
   nm_debug.debug('nsv_attrib412   : '||pi_rec_nsv_all.nsv_attrib412,p_level);
   nm_debug.debug('nsv_attrib413   : '||pi_rec_nsv_all.nsv_attrib413,p_level);
   nm_debug.debug('nsv_attrib414   : '||pi_rec_nsv_all.nsv_attrib414,p_level);
   nm_debug.debug('nsv_attrib415   : '||pi_rec_nsv_all.nsv_attrib415,p_level);
   nm_debug.debug('nsv_attrib416   : '||pi_rec_nsv_all.nsv_attrib416,p_level);
   nm_debug.debug('nsv_attrib417   : '||pi_rec_nsv_all.nsv_attrib417,p_level);
   nm_debug.debug('nsv_attrib418   : '||pi_rec_nsv_all.nsv_attrib418,p_level);
   nm_debug.debug('nsv_attrib419   : '||pi_rec_nsv_all.nsv_attrib419,p_level);
   nm_debug.debug('nsv_attrib420   : '||pi_rec_nsv_all.nsv_attrib420,p_level);
   nm_debug.debug('nsv_attrib421   : '||pi_rec_nsv_all.nsv_attrib421,p_level);
   nm_debug.debug('nsv_attrib422   : '||pi_rec_nsv_all.nsv_attrib422,p_level);
   nm_debug.debug('nsv_attrib423   : '||pi_rec_nsv_all.nsv_attrib423,p_level);
   nm_debug.debug('nsv_attrib424   : '||pi_rec_nsv_all.nsv_attrib424,p_level);
   nm_debug.debug('nsv_attrib425   : '||pi_rec_nsv_all.nsv_attrib425,p_level);
   nm_debug.debug('nsv_attrib426   : '||pi_rec_nsv_all.nsv_attrib426,p_level);
   nm_debug.debug('nsv_attrib427   : '||pi_rec_nsv_all.nsv_attrib427,p_level);
   nm_debug.debug('nsv_attrib428   : '||pi_rec_nsv_all.nsv_attrib428,p_level);
   nm_debug.debug('nsv_attrib429   : '||pi_rec_nsv_all.nsv_attrib429,p_level);
   nm_debug.debug('nsv_attrib430   : '||pi_rec_nsv_all.nsv_attrib430,p_level);
   nm_debug.debug('nsv_attrib431   : '||pi_rec_nsv_all.nsv_attrib431,p_level);
   nm_debug.debug('nsv_attrib432   : '||pi_rec_nsv_all.nsv_attrib432,p_level);
   nm_debug.debug('nsv_attrib433   : '||pi_rec_nsv_all.nsv_attrib433,p_level);
   nm_debug.debug('nsv_attrib434   : '||pi_rec_nsv_all.nsv_attrib434,p_level);
   nm_debug.debug('nsv_attrib435   : '||pi_rec_nsv_all.nsv_attrib435,p_level);
   nm_debug.debug('nsv_attrib436   : '||pi_rec_nsv_all.nsv_attrib436,p_level);
   nm_debug.debug('nsv_attrib437   : '||pi_rec_nsv_all.nsv_attrib437,p_level);
   nm_debug.debug('nsv_attrib438   : '||pi_rec_nsv_all.nsv_attrib438,p_level);
   nm_debug.debug('nsv_attrib439   : '||pi_rec_nsv_all.nsv_attrib439,p_level);
   nm_debug.debug('nsv_attrib440   : '||pi_rec_nsv_all.nsv_attrib440,p_level);
   nm_debug.debug('nsv_attrib441   : '||pi_rec_nsv_all.nsv_attrib441,p_level);
   nm_debug.debug('nsv_attrib442   : '||pi_rec_nsv_all.nsv_attrib442,p_level);
   nm_debug.debug('nsv_attrib443   : '||pi_rec_nsv_all.nsv_attrib443,p_level);
   nm_debug.debug('nsv_attrib444   : '||pi_rec_nsv_all.nsv_attrib444,p_level);
   nm_debug.debug('nsv_attrib445   : '||pi_rec_nsv_all.nsv_attrib445,p_level);
   nm_debug.debug('nsv_attrib446   : '||pi_rec_nsv_all.nsv_attrib446,p_level);
   nm_debug.debug('nsv_attrib447   : '||pi_rec_nsv_all.nsv_attrib447,p_level);
   nm_debug.debug('nsv_attrib448   : '||pi_rec_nsv_all.nsv_attrib448,p_level);
   nm_debug.debug('nsv_attrib449   : '||pi_rec_nsv_all.nsv_attrib449,p_level);
   nm_debug.debug('nsv_attrib450   : '||pi_rec_nsv_all.nsv_attrib450,p_level);
   nm_debug.debug('nsv_attrib451   : '||pi_rec_nsv_all.nsv_attrib451,p_level);
   nm_debug.debug('nsv_attrib452   : '||pi_rec_nsv_all.nsv_attrib452,p_level);
   nm_debug.debug('nsv_attrib453   : '||pi_rec_nsv_all.nsv_attrib453,p_level);
   nm_debug.debug('nsv_attrib454   : '||pi_rec_nsv_all.nsv_attrib454,p_level);
   nm_debug.debug('nsv_attrib455   : '||pi_rec_nsv_all.nsv_attrib455,p_level);
   nm_debug.debug('nsv_attrib456   : '||pi_rec_nsv_all.nsv_attrib456,p_level);
   nm_debug.debug('nsv_attrib457   : '||pi_rec_nsv_all.nsv_attrib457,p_level);
   nm_debug.debug('nsv_attrib458   : '||pi_rec_nsv_all.nsv_attrib458,p_level);
   nm_debug.debug('nsv_attrib459   : '||pi_rec_nsv_all.nsv_attrib459,p_level);
   nm_debug.debug('nsv_attrib460   : '||pi_rec_nsv_all.nsv_attrib460,p_level);
   nm_debug.debug('nsv_attrib461   : '||pi_rec_nsv_all.nsv_attrib461,p_level);
   nm_debug.debug('nsv_attrib462   : '||pi_rec_nsv_all.nsv_attrib462,p_level);
   nm_debug.debug('nsv_attrib463   : '||pi_rec_nsv_all.nsv_attrib463,p_level);
   nm_debug.debug('nsv_attrib464   : '||pi_rec_nsv_all.nsv_attrib464,p_level);
   nm_debug.debug('nsv_attrib465   : '||pi_rec_nsv_all.nsv_attrib465,p_level);
   nm_debug.debug('nsv_attrib466   : '||pi_rec_nsv_all.nsv_attrib466,p_level);
   nm_debug.debug('nsv_attrib467   : '||pi_rec_nsv_all.nsv_attrib467,p_level);
   nm_debug.debug('nsv_attrib468   : '||pi_rec_nsv_all.nsv_attrib468,p_level);
   nm_debug.debug('nsv_attrib469   : '||pi_rec_nsv_all.nsv_attrib469,p_level);
   nm_debug.debug('nsv_attrib470   : '||pi_rec_nsv_all.nsv_attrib470,p_level);
   nm_debug.debug('nsv_attrib471   : '||pi_rec_nsv_all.nsv_attrib471,p_level);
   nm_debug.debug('nsv_attrib472   : '||pi_rec_nsv_all.nsv_attrib472,p_level);
   nm_debug.debug('nsv_attrib473   : '||pi_rec_nsv_all.nsv_attrib473,p_level);
   nm_debug.debug('nsv_attrib474   : '||pi_rec_nsv_all.nsv_attrib474,p_level);
   nm_debug.debug('nsv_attrib475   : '||pi_rec_nsv_all.nsv_attrib475,p_level);
   nm_debug.debug('nsv_attrib476   : '||pi_rec_nsv_all.nsv_attrib476,p_level);
   nm_debug.debug('nsv_attrib477   : '||pi_rec_nsv_all.nsv_attrib477,p_level);
   nm_debug.debug('nsv_attrib478   : '||pi_rec_nsv_all.nsv_attrib478,p_level);
   nm_debug.debug('nsv_attrib479   : '||pi_rec_nsv_all.nsv_attrib479,p_level);
   nm_debug.debug('nsv_attrib480   : '||pi_rec_nsv_all.nsv_attrib480,p_level);
   nm_debug.debug('nsv_attrib481   : '||pi_rec_nsv_all.nsv_attrib481,p_level);
   nm_debug.debug('nsv_attrib482   : '||pi_rec_nsv_all.nsv_attrib482,p_level);
   nm_debug.debug('nsv_attrib483   : '||pi_rec_nsv_all.nsv_attrib483,p_level);
   nm_debug.debug('nsv_attrib484   : '||pi_rec_nsv_all.nsv_attrib484,p_level);
   nm_debug.debug('nsv_attrib485   : '||pi_rec_nsv_all.nsv_attrib485,p_level);
   nm_debug.debug('nsv_attrib486   : '||pi_rec_nsv_all.nsv_attrib486,p_level);
   nm_debug.debug('nsv_attrib487   : '||pi_rec_nsv_all.nsv_attrib487,p_level);
   nm_debug.debug('nsv_attrib488   : '||pi_rec_nsv_all.nsv_attrib488,p_level);
   nm_debug.debug('nsv_attrib489   : '||pi_rec_nsv_all.nsv_attrib489,p_level);
   nm_debug.debug('nsv_attrib490   : '||pi_rec_nsv_all.nsv_attrib490,p_level);
   nm_debug.debug('nsv_attrib491   : '||pi_rec_nsv_all.nsv_attrib491,p_level);
   nm_debug.debug('nsv_attrib492   : '||pi_rec_nsv_all.nsv_attrib492,p_level);
   nm_debug.debug('nsv_attrib493   : '||pi_rec_nsv_all.nsv_attrib493,p_level);
   nm_debug.debug('nsv_attrib494   : '||pi_rec_nsv_all.nsv_attrib494,p_level);
   nm_debug.debug('nsv_attrib495   : '||pi_rec_nsv_all.nsv_attrib495,p_level);
   nm_debug.debug('nsv_attrib496   : '||pi_rec_nsv_all.nsv_attrib496,p_level);
   nm_debug.debug('nsv_attrib497   : '||pi_rec_nsv_all.nsv_attrib497,p_level);
   nm_debug.debug('nsv_attrib498   : '||pi_rec_nsv_all.nsv_attrib498,p_level);
   nm_debug.debug('nsv_attrib499   : '||pi_rec_nsv_all.nsv_attrib499,p_level);
   nm_debug.debug('nsv_attrib500   : '||pi_rec_nsv_all.nsv_attrib500,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nsv_all');
--
END debug_nsv_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmsm (pi_rec_nmsm nm_mrg_section_members%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmsm');
--
   nm_debug.debug('nsm_mrg_job_id     : '||pi_rec_nmsm.nsm_mrg_job_id,p_level);
   nm_debug.debug('nsm_mrg_section_id : '||pi_rec_nmsm.nsm_mrg_section_id,p_level);
   nm_debug.debug('nsm_ne_id          : '||pi_rec_nmsm.nsm_ne_id,p_level);
   nm_debug.debug('nsm_begin_mp       : '||pi_rec_nmsm.nsm_begin_mp,p_level);
   nm_debug.debug('nsm_end_mp         : '||pi_rec_nmsm.nsm_end_mp,p_level);
   nm_debug.debug('nsm_measure        : '||pi_rec_nmsm.nsm_measure,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmsm');
--
END debug_nmsm;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_no (pi_rec_no nm_nodes%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_no');
--
   nm_debug.debug('no_node_id       : '||pi_rec_no.no_node_id,p_level);
   nm_debug.debug('no_node_name     : '||pi_rec_no.no_node_name,p_level);
   nm_debug.debug('no_start_date    : '||pi_rec_no.no_start_date,p_level);
   nm_debug.debug('no_end_date      : '||pi_rec_no.no_end_date,p_level);
   nm_debug.debug('no_np_id         : '||pi_rec_no.no_np_id,p_level);
   nm_debug.debug('no_descr         : '||pi_rec_no.no_descr,p_level);
   nm_debug.debug('no_node_type     : '||pi_rec_no.no_node_type,p_level);
   nm_debug.debug('no_date_created  : '||pi_rec_no.no_date_created,p_level);
   nm_debug.debug('no_date_modified : '||pi_rec_no.no_date_modified,p_level);
   nm_debug.debug('no_modified_by   : '||pi_rec_no.no_modified_by,p_level);
   nm_debug.debug('no_created_by    : '||pi_rec_no.no_created_by,p_level);
   nm_debug.debug('no_purpose       : '||pi_rec_no.no_purpose,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_no');
--
END debug_no;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_no_all (pi_rec_no_all nm_nodes_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_no_all');
--
   nm_debug.debug('no_node_id       : '||pi_rec_no_all.no_node_id,p_level);
   nm_debug.debug('no_node_name     : '||pi_rec_no_all.no_node_name,p_level);
   nm_debug.debug('no_start_date    : '||pi_rec_no_all.no_start_date,p_level);
   nm_debug.debug('no_end_date      : '||pi_rec_no_all.no_end_date,p_level);
   nm_debug.debug('no_np_id         : '||pi_rec_no_all.no_np_id,p_level);
   nm_debug.debug('no_descr         : '||pi_rec_no_all.no_descr,p_level);
   nm_debug.debug('no_node_type     : '||pi_rec_no_all.no_node_type,p_level);
   nm_debug.debug('no_date_created  : '||pi_rec_no_all.no_date_created,p_level);
   nm_debug.debug('no_date_modified : '||pi_rec_no_all.no_date_modified,p_level);
   nm_debug.debug('no_modified_by   : '||pi_rec_no_all.no_modified_by,p_level);
   nm_debug.debug('no_created_by    : '||pi_rec_no_all.no_created_by,p_level);
   nm_debug.debug('no_purpose       : '||pi_rec_no_all.no_purpose,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_no_all');
--
END debug_no_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nnt (pi_rec_nnt nm_node_types%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nnt');
--
   nm_debug.debug('nnt_type           : '||pi_rec_nnt.nnt_type,p_level);
   nm_debug.debug('nnt_name           : '||pi_rec_nnt.nnt_name,p_level);
   nm_debug.debug('nnt_descr          : '||pi_rec_nnt.nnt_descr,p_level);
   nm_debug.debug('nnt_no_name_format : '||pi_rec_nnt.nnt_no_name_format,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nnt');
--
END debug_nnt;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nnu (pi_rec_nnu nm_node_usages%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nnu');
--
   nm_debug.debug('nnu_no_node_id : '||pi_rec_nnu.nnu_no_node_id,p_level);
   nm_debug.debug('nnu_ne_id      : '||pi_rec_nnu.nnu_ne_id,p_level);
   nm_debug.debug('nnu_node_type  : '||pi_rec_nnu.nnu_node_type,p_level);
   nm_debug.debug('nnu_chain      : '||pi_rec_nnu.nnu_chain,p_level);
   nm_debug.debug('nnu_leg_no     : '||pi_rec_nnu.nnu_leg_no,p_level);
   nm_debug.debug('nnu_start_date : '||pi_rec_nnu.nnu_start_date,p_level);
   nm_debug.debug('nnu_end_date   : '||pi_rec_nnu.nnu_end_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nnu');
--
END debug_nnu;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nnu_all (pi_rec_nnu_all nm_node_usages_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nnu_all');
--
   nm_debug.debug('nnu_no_node_id : '||pi_rec_nnu_all.nnu_no_node_id,p_level);
   nm_debug.debug('nnu_ne_id      : '||pi_rec_nnu_all.nnu_ne_id,p_level);
   nm_debug.debug('nnu_node_type  : '||pi_rec_nnu_all.nnu_node_type,p_level);
   nm_debug.debug('nnu_chain      : '||pi_rec_nnu_all.nnu_chain,p_level);
   nm_debug.debug('nnu_leg_no     : '||pi_rec_nnu_all.nnu_leg_no,p_level);
   nm_debug.debug('nnu_start_date : '||pi_rec_nnu_all.nnu_start_date,p_level);
   nm_debug.debug('nnu_end_date   : '||pi_rec_nnu_all.nnu_end_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nnu_all');
--
END debug_nnu_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nng (pi_rec_nng nm_nt_groupings%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nng');
--
   nm_debug.debug('nng_group_type : '||pi_rec_nng.nng_group_type,p_level);
   nm_debug.debug('nng_nt_type    : '||pi_rec_nng.nng_nt_type,p_level);
   nm_debug.debug('nng_start_date : '||pi_rec_nng.nng_start_date,p_level);
   nm_debug.debug('nng_end_date   : '||pi_rec_nng.nng_end_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nng');
--
END debug_nng;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nng_all (pi_rec_nng_all nm_nt_groupings_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nng_all');
--
   nm_debug.debug('nng_group_type : '||pi_rec_nng_all.nng_group_type,p_level);
   nm_debug.debug('nng_nt_type    : '||pi_rec_nng_all.nng_nt_type,p_level);
   nm_debug.debug('nng_start_date : '||pi_rec_nng_all.nng_start_date,p_level);
   nm_debug.debug('nng_end_date   : '||pi_rec_nng_all.nng_end_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nng_all');
--
END debug_nng_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nad (pi_rec_nad nm_nw_ad_types%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nad');
--
   nm_debug.debug('nad_id            : '||pi_rec_nad.nad_id,p_level);
   nm_debug.debug('nad_inv_type      : '||pi_rec_nad.nad_inv_type,p_level);
   nm_debug.debug('nad_nt_type       : '||pi_rec_nad.nad_nt_type,p_level);
   nm_debug.debug('nad_gty_type      : '||pi_rec_nad.nad_gty_type,p_level);
   nm_debug.debug('nad_descr         : '||pi_rec_nad.nad_descr,p_level);
   nm_debug.debug('nad_start_date    : '||pi_rec_nad.nad_start_date,p_level);
   nm_debug.debug('nad_end_date      : '||pi_rec_nad.nad_end_date,p_level);
   nm_debug.debug('nad_primary_ad    : '||pi_rec_nad.nad_primary_ad,p_level);
   nm_debug.debug('nad_display_order : '||pi_rec_nad.nad_display_order,p_level);
   nm_debug.debug('nad_single_row    : '||pi_rec_nad.nad_single_row,p_level);
   nm_debug.debug('nad_mandatory     : '||pi_rec_nad.nad_mandatory,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nad');
--
END debug_nad;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_npe (pi_rec_npe nm_nw_persistent_extents%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_npe');
--
   nm_debug.debug('npe_job_id      : '||pi_rec_npe.npe_job_id,p_level);
   nm_debug.debug('npe_ne_id_of    : '||pi_rec_npe.npe_ne_id_of,p_level);
   nm_debug.debug('npe_begin_mp    : '||pi_rec_npe.npe_begin_mp,p_level);
   nm_debug.debug('npe_end_mp      : '||pi_rec_npe.npe_end_mp,p_level);
   nm_debug.debug('npe_cardinality : '||pi_rec_npe.npe_cardinality,p_level);
   nm_debug.debug('npe_seq_no      : '||pi_rec_npe.npe_seq_no,p_level);
   nm_debug.debug('npe_route_ne_id : '||pi_rec_npe.npe_route_ne_id,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_npe');
--
END debug_npe;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nnth (pi_rec_nnth nm_nw_themes%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nnth');
--
   nm_debug.debug('nnth_nlt_id       : '||pi_rec_nnth.nnth_nlt_id,p_level);
   nm_debug.debug('nnth_nth_theme_id : '||pi_rec_nnth.nnth_nth_theme_id,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nnth');
--
END debug_nnth;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmo (pi_rec_nmo nm_operations%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmo');
--
   nm_debug.debug('nmo_operation : '||pi_rec_nmo.nmo_operation,p_level);
   nm_debug.debug('nmo_descr     : '||pi_rec_nmo.nmo_descr,p_level);
   nm_debug.debug('nmo_proc_name : '||pi_rec_nmo.nmo_proc_name,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmo');
--
END debug_nmo;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nod (pi_rec_nod nm_operation_data%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nod');
--
   nm_debug.debug('nod_nmo_operation : '||pi_rec_nod.nod_nmo_operation,p_level);
   nm_debug.debug('nod_data_item     : '||pi_rec_nod.nod_data_item,p_level);
   nm_debug.debug('nod_data_type     : '||pi_rec_nod.nod_data_type,p_level);
   nm_debug.debug('nod_mandatory     : '||pi_rec_nod.nod_mandatory,p_level);
   nm_debug.debug('nod_seq           : '||pi_rec_nod.nod_seq,p_level);
   nm_debug.debug('nod_scrn_text     : '||pi_rec_nod.nod_scrn_text,p_level);
   nm_debug.debug('nod_query_sql     : '||pi_rec_nod.nod_query_sql,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nod');
--
END debug_nod;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_npq (pi_rec_npq nm_pbi_query%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_npq');
--
   nm_debug.debug('npq_id            : '||pi_rec_npq.npq_id,p_level);
   nm_debug.debug('npq_unique        : '||pi_rec_npq.npq_unique,p_level);
   nm_debug.debug('npq_descr         : '||pi_rec_npq.npq_descr,p_level);
   nm_debug.debug('npq_date_created  : '||pi_rec_npq.npq_date_created,p_level);
   nm_debug.debug('npq_date_modified : '||pi_rec_npq.npq_date_modified,p_level);
   nm_debug.debug('npq_modified_by   : '||pi_rec_npq.npq_modified_by,p_level);
   nm_debug.debug('npq_created_by    : '||pi_rec_npq.npq_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_npq');
--
END debug_npq;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_npqa (pi_rec_npqa nm_pbi_query_attribs%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_npqa');
--
   nm_debug.debug('nqa_npq_id       : '||pi_rec_npqa.nqa_npq_id,p_level);
   nm_debug.debug('nqa_nqt_seq_no   : '||pi_rec_npqa.nqa_nqt_seq_no,p_level);
   nm_debug.debug('nqa_seq_no       : '||pi_rec_npqa.nqa_seq_no,p_level);
   nm_debug.debug('nqa_attrib_name  : '||pi_rec_npqa.nqa_attrib_name,p_level);
   nm_debug.debug('nqa_operator     : '||pi_rec_npqa.nqa_operator,p_level);
   nm_debug.debug('nqa_pre_bracket  : '||pi_rec_npqa.nqa_pre_bracket,p_level);
   nm_debug.debug('nqa_post_bracket : '||pi_rec_npqa.nqa_post_bracket,p_level);
   nm_debug.debug('nqa_condition    : '||pi_rec_npqa.nqa_condition,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_npqa');
--
END debug_npqa;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_npqr (pi_rec_npqr nm_pbi_query_results%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_npqr');
--
   nm_debug.debug('nqr_npq_id        : '||pi_rec_npqr.nqr_npq_id,p_level);
   nm_debug.debug('nqr_job_id        : '||pi_rec_npqr.nqr_job_id,p_level);
   nm_debug.debug('nqr_source_id     : '||pi_rec_npqr.nqr_source_id,p_level);
   nm_debug.debug('nqr_source        : '||pi_rec_npqr.nqr_source,p_level);
   nm_debug.debug('nqr_description   : '||pi_rec_npqr.nqr_description,p_level);
   nm_debug.debug('nqr_date_created  : '||pi_rec_npqr.nqr_date_created,p_level);
   nm_debug.debug('nqr_date_modified : '||pi_rec_npqr.nqr_date_modified,p_level);
   nm_debug.debug('nqr_modified_by   : '||pi_rec_npqr.nqr_modified_by,p_level);
   nm_debug.debug('nqr_created_by    : '||pi_rec_npqr.nqr_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_npqr');
--
END debug_npqr;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_npqt (pi_rec_npqt nm_pbi_query_types%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_npqt');
--
   nm_debug.debug('nqt_npq_id         : '||pi_rec_npqt.nqt_npq_id,p_level);
   nm_debug.debug('nqt_seq_no         : '||pi_rec_npqt.nqt_seq_no,p_level);
   nm_debug.debug('nqt_item_type_type : '||pi_rec_npqt.nqt_item_type_type,p_level);
   nm_debug.debug('nqt_item_type      : '||pi_rec_npqt.nqt_item_type,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_npqt');
--
END debug_npqt;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_npqv (pi_rec_npqv nm_pbi_query_values%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_npqv');
--
   nm_debug.debug('nqv_npq_id     : '||pi_rec_npqv.nqv_npq_id,p_level);
   nm_debug.debug('nqv_nqt_seq_no : '||pi_rec_npqv.nqv_nqt_seq_no,p_level);
   nm_debug.debug('nqv_nqa_seq_no : '||pi_rec_npqv.nqv_nqa_seq_no,p_level);
   nm_debug.debug('nqv_sequence   : '||pi_rec_npqv.nqv_sequence,p_level);
   nm_debug.debug('nqv_value      : '||pi_rec_npqv.nqv_value,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_npqv');
--
END debug_npqv;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nps (pi_rec_nps nm_pbi_sections%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nps');
--
   nm_debug.debug('nps_npq_id         : '||pi_rec_nps.nps_npq_id,p_level);
   nm_debug.debug('nps_nqr_job_id     : '||pi_rec_nps.nps_nqr_job_id,p_level);
   nm_debug.debug('nps_section_id     : '||pi_rec_nps.nps_section_id,p_level);
   nm_debug.debug('nps_offset_ne_id   : '||pi_rec_nps.nps_offset_ne_id,p_level);
   nm_debug.debug('nps_begin_offset   : '||pi_rec_nps.nps_begin_offset,p_level);
   nm_debug.debug('nps_end_offset     : '||pi_rec_nps.nps_end_offset,p_level);
   nm_debug.debug('nps_ne_id_first    : '||pi_rec_nps.nps_ne_id_first,p_level);
   nm_debug.debug('nps_begin_mp_first : '||pi_rec_nps.nps_begin_mp_first,p_level);
   nm_debug.debug('nps_ne_id_last     : '||pi_rec_nps.nps_ne_id_last,p_level);
   nm_debug.debug('nps_end_mp_last    : '||pi_rec_nps.nps_end_mp_last,p_level);
   nm_debug.debug('nps_date_created   : '||pi_rec_nps.nps_date_created,p_level);
   nm_debug.debug('nps_date_modified  : '||pi_rec_nps.nps_date_modified,p_level);
   nm_debug.debug('nps_modified_by    : '||pi_rec_nps.nps_modified_by,p_level);
   nm_debug.debug('nps_created_by     : '||pi_rec_nps.nps_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nps');
--
END debug_nps;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_npsm (pi_rec_npsm nm_pbi_section_members%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_npsm');
--
   nm_debug.debug('npm_npq_id         : '||pi_rec_npsm.npm_npq_id,p_level);
   nm_debug.debug('npm_nqr_job_id     : '||pi_rec_npsm.npm_nqr_job_id,p_level);
   nm_debug.debug('npm_nps_section_id : '||pi_rec_npsm.npm_nps_section_id,p_level);
   nm_debug.debug('npm_ne_id_of       : '||pi_rec_npsm.npm_ne_id_of,p_level);
   nm_debug.debug('npm_begin_mp       : '||pi_rec_npsm.npm_begin_mp,p_level);
   nm_debug.debug('npm_end_mp         : '||pi_rec_npsm.npm_end_mp,p_level);
   nm_debug.debug('npm_measure        : '||pi_rec_npsm.npm_measure,p_level);
   nm_debug.debug('npm_date_created   : '||pi_rec_npsm.npm_date_created,p_level);
   nm_debug.debug('npm_date_modified  : '||pi_rec_npsm.npm_date_modified,p_level);
   nm_debug.debug('npm_modified_by    : '||pi_rec_npsm.npm_modified_by,p_level);
   nm_debug.debug('npm_created_by     : '||pi_rec_npsm.npm_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_npsm');
--
END debug_npsm;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_np (pi_rec_np nm_points%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_np');
--
   nm_debug.debug('np_id            : '||pi_rec_np.np_id,p_level);
   nm_debug.debug('np_grid_east     : '||pi_rec_np.np_grid_east,p_level);
   nm_debug.debug('np_grid_north    : '||pi_rec_np.np_grid_north,p_level);
   nm_debug.debug('np_descr         : '||pi_rec_np.np_descr,p_level);
   nm_debug.debug('np_date_created  : '||pi_rec_np.np_date_created,p_level);
   nm_debug.debug('np_date_modified : '||pi_rec_np.np_date_modified,p_level);
   nm_debug.debug('np_modified_by   : '||pi_rec_np.np_modified_by,p_level);
   nm_debug.debug('np_created_by    : '||pi_rec_np.np_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_np');
--
END debug_np;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nrd (pi_rec_nrd nm_reclass_details%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nrd');
--
   nm_debug.debug('nrd_job_id    : '||pi_rec_nrd.nrd_job_id,p_level);
   nm_debug.debug('nrd_old_ne_id : '||pi_rec_nrd.nrd_old_ne_id,p_level);
   nm_debug.debug('nrd_new_ne_id : '||pi_rec_nrd.nrd_new_ne_id,p_level);
   nm_debug.debug('nrd_timestamp : '||pi_rec_nrd.nrd_timestamp,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nrd');
--
END debug_nrd;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nrev (pi_rec_nrev nm_reversal%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nrev');
--
   nm_debug.debug('ne_id            : '||pi_rec_nrev.ne_id,p_level);
   nm_debug.debug('ne_unique        : '||pi_rec_nrev.ne_unique,p_level);
   nm_debug.debug('ne_type          : '||pi_rec_nrev.ne_type,p_level);
   nm_debug.debug('ne_nt_type       : '||pi_rec_nrev.ne_nt_type,p_level);
   nm_debug.debug('ne_descr         : '||pi_rec_nrev.ne_descr,p_level);
   nm_debug.debug('ne_length        : '||pi_rec_nrev.ne_length,p_level);
   nm_debug.debug('ne_admin_unit    : '||pi_rec_nrev.ne_admin_unit,p_level);
   nm_debug.debug('ne_owner         : '||pi_rec_nrev.ne_owner,p_level);
   nm_debug.debug('ne_name_1        : '||pi_rec_nrev.ne_name_1,p_level);
   nm_debug.debug('ne_name_2        : '||pi_rec_nrev.ne_name_2,p_level);
   nm_debug.debug('ne_prefix        : '||pi_rec_nrev.ne_prefix,p_level);
   nm_debug.debug('ne_number        : '||pi_rec_nrev.ne_number,p_level);
   nm_debug.debug('ne_sub_type      : '||pi_rec_nrev.ne_sub_type,p_level);
   nm_debug.debug('ne_group         : '||pi_rec_nrev.ne_group,p_level);
   nm_debug.debug('ne_no_start      : '||pi_rec_nrev.ne_no_start,p_level);
   nm_debug.debug('ne_no_end        : '||pi_rec_nrev.ne_no_end,p_level);
   nm_debug.debug('ne_sub_class     : '||pi_rec_nrev.ne_sub_class,p_level);
   nm_debug.debug('ne_nsg_ref       : '||pi_rec_nrev.ne_nsg_ref,p_level);
   nm_debug.debug('ne_version_no    : '||pi_rec_nrev.ne_version_no,p_level);
   nm_debug.debug('ne_new_id        : '||pi_rec_nrev.ne_new_id,p_level);
   nm_debug.debug('ne_sub_class_old : '||pi_rec_nrev.ne_sub_class_old,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nrev');
--
END debug_nrev;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nse (pi_rec_nse nm_saved_extents%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nse');
--
   nm_debug.debug('nse_id            : '||pi_rec_nse.nse_id,p_level);
   nm_debug.debug('nse_owner         : '||pi_rec_nse.nse_owner,p_level);
   nm_debug.debug('nse_name          : '||pi_rec_nse.nse_name,p_level);
   nm_debug.debug('nse_descr         : '||pi_rec_nse.nse_descr,p_level);
   nm_debug.debug('nse_pbi           : '||pi_rec_nse.nse_pbi,p_level);
   nm_debug.debug('nse_date_created  : '||pi_rec_nse.nse_date_created,p_level);
   nm_debug.debug('nse_date_modified : '||pi_rec_nse.nse_date_modified,p_level);
   nm_debug.debug('nse_modified_by   : '||pi_rec_nse.nse_modified_by,p_level);
   nm_debug.debug('nse_created_by    : '||pi_rec_nse.nse_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nse');
--
END debug_nse;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nsm (pi_rec_nsm nm_saved_extent_members%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nsm');
--
   nm_debug.debug('nsm_nse_id                  : '||pi_rec_nsm.nsm_nse_id,p_level);
   nm_debug.debug('nsm_id                      : '||pi_rec_nsm.nsm_id,p_level);
   nm_debug.debug('nsm_ne_id                   : '||pi_rec_nsm.nsm_ne_id,p_level);
   nm_debug.debug('nsm_begin_mp                : '||pi_rec_nsm.nsm_begin_mp,p_level);
   nm_debug.debug('nsm_end_mp                  : '||pi_rec_nsm.nsm_end_mp,p_level);
   nm_debug.debug('nsm_begin_no                : '||pi_rec_nsm.nsm_begin_no,p_level);
   nm_debug.debug('nsm_end_no                  : '||pi_rec_nsm.nsm_end_no,p_level);
   nm_debug.debug('nsm_begin_sect              : '||pi_rec_nsm.nsm_begin_sect,p_level);
   nm_debug.debug('nsm_begin_sect_offset       : '||pi_rec_nsm.nsm_begin_sect_offset,p_level);
   nm_debug.debug('nsm_end_sect                : '||pi_rec_nsm.nsm_end_sect,p_level);
   nm_debug.debug('nsm_end_sect_offset         : '||pi_rec_nsm.nsm_end_sect_offset,p_level);
   nm_debug.debug('nsm_seq_no                  : '||pi_rec_nsm.nsm_seq_no,p_level);
   nm_debug.debug('nsm_datum                   : '||pi_rec_nsm.nsm_datum,p_level);
   nm_debug.debug('nsm_date_created            : '||pi_rec_nsm.nsm_date_created,p_level);
   nm_debug.debug('nsm_date_modified           : '||pi_rec_nsm.nsm_date_modified,p_level);
   nm_debug.debug('nsm_created_by              : '||pi_rec_nsm.nsm_created_by,p_level);
   nm_debug.debug('nsm_modified_by             : '||pi_rec_nsm.nsm_modified_by,p_level);
   nm_debug.debug('nsm_sub_class               : '||pi_rec_nsm.nsm_sub_class,p_level);
   nm_debug.debug('nsm_sub_class_excl          : '||pi_rec_nsm.nsm_sub_class_excl,p_level);
   nm_debug.debug('nsm_restrict_excl_sub_class : '||pi_rec_nsm.nsm_restrict_excl_sub_class,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nsm');
--
END debug_nsm;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nsd (pi_rec_nsd nm_saved_extent_member_datums%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nsd');
--
   nm_debug.debug('nsd_nse_id      : '||pi_rec_nsd.nsd_nse_id,p_level);
   nm_debug.debug('nsd_nsm_id      : '||pi_rec_nsd.nsd_nsm_id,p_level);
   nm_debug.debug('nsd_ne_id       : '||pi_rec_nsd.nsd_ne_id,p_level);
   nm_debug.debug('nsd_begin_mp    : '||pi_rec_nsd.nsd_begin_mp,p_level);
   nm_debug.debug('nsd_end_mp      : '||pi_rec_nsd.nsd_end_mp,p_level);
   nm_debug.debug('nsd_seq_no      : '||pi_rec_nsd.nsd_seq_no,p_level);
   nm_debug.debug('nsd_cardinality : '||pi_rec_nsd.nsd_cardinality,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nsd');
--
END debug_nsd;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_tii (pi_rec_tii nm_temp_inv_items%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_tii');
--
   nm_debug.debug('tii_njc_job_id            : '||pi_rec_tii.tii_njc_job_id,p_level);
   nm_debug.debug('tii_ne_id                 : '||pi_rec_tii.tii_ne_id,p_level);
   nm_debug.debug('tii_ne_id_new             : '||pi_rec_tii.tii_ne_id_new,p_level);
   nm_debug.debug('tii_inv_type              : '||pi_rec_tii.tii_inv_type,p_level);
   nm_debug.debug('tii_primary_key_orig      : '||pi_rec_tii.tii_primary_key_orig,p_level);
   nm_debug.debug('tii_primary_key           : '||pi_rec_tii.tii_primary_key,p_level);
   nm_debug.debug('tii_start_date            : '||pi_rec_tii.tii_start_date,p_level);
   nm_debug.debug('tii_date_created          : '||pi_rec_tii.tii_date_created,p_level);
   nm_debug.debug('tii_date_modified         : '||pi_rec_tii.tii_date_modified,p_level);
   nm_debug.debug('tii_created_by            : '||pi_rec_tii.tii_created_by,p_level);
   nm_debug.debug('tii_modified_by           : '||pi_rec_tii.tii_modified_by,p_level);
   nm_debug.debug('tii_admin_unit            : '||pi_rec_tii.tii_admin_unit,p_level);
   nm_debug.debug('tii_descr                 : '||pi_rec_tii.tii_descr,p_level);
   nm_debug.debug('tii_end_date              : '||pi_rec_tii.tii_end_date,p_level);
   nm_debug.debug('tii_foreign_key           : '||pi_rec_tii.tii_foreign_key,p_level);
   nm_debug.debug('tii_located_by            : '||pi_rec_tii.tii_located_by,p_level);
   nm_debug.debug('tii_position              : '||pi_rec_tii.tii_position,p_level);
   nm_debug.debug('tii_x_coord               : '||pi_rec_tii.tii_x_coord,p_level);
   nm_debug.debug('tii_y_coord               : '||pi_rec_tii.tii_y_coord,p_level);
   nm_debug.debug('tii_num_attrib16          : '||pi_rec_tii.tii_num_attrib16,p_level);
   nm_debug.debug('tii_num_attrib17          : '||pi_rec_tii.tii_num_attrib17,p_level);
   nm_debug.debug('tii_num_attrib18          : '||pi_rec_tii.tii_num_attrib18,p_level);
   nm_debug.debug('tii_num_attrib19          : '||pi_rec_tii.tii_num_attrib19,p_level);
   nm_debug.debug('tii_num_attrib20          : '||pi_rec_tii.tii_num_attrib20,p_level);
   nm_debug.debug('tii_num_attrib21          : '||pi_rec_tii.tii_num_attrib21,p_level);
   nm_debug.debug('tii_num_attrib22          : '||pi_rec_tii.tii_num_attrib22,p_level);
   nm_debug.debug('tii_num_attrib23          : '||pi_rec_tii.tii_num_attrib23,p_level);
   nm_debug.debug('tii_num_attrib24          : '||pi_rec_tii.tii_num_attrib24,p_level);
   nm_debug.debug('tii_num_attrib25          : '||pi_rec_tii.tii_num_attrib25,p_level);
   nm_debug.debug('tii_chr_attrib26          : '||pi_rec_tii.tii_chr_attrib26,p_level);
   nm_debug.debug('tii_chr_attrib27          : '||pi_rec_tii.tii_chr_attrib27,p_level);
   nm_debug.debug('tii_chr_attrib28          : '||pi_rec_tii.tii_chr_attrib28,p_level);
   nm_debug.debug('tii_chr_attrib29          : '||pi_rec_tii.tii_chr_attrib29,p_level);
   nm_debug.debug('tii_chr_attrib30          : '||pi_rec_tii.tii_chr_attrib30,p_level);
   nm_debug.debug('tii_chr_attrib31          : '||pi_rec_tii.tii_chr_attrib31,p_level);
   nm_debug.debug('tii_chr_attrib32          : '||pi_rec_tii.tii_chr_attrib32,p_level);
   nm_debug.debug('tii_chr_attrib33          : '||pi_rec_tii.tii_chr_attrib33,p_level);
   nm_debug.debug('tii_chr_attrib34          : '||pi_rec_tii.tii_chr_attrib34,p_level);
   nm_debug.debug('tii_chr_attrib35          : '||pi_rec_tii.tii_chr_attrib35,p_level);
   nm_debug.debug('tii_chr_attrib36          : '||pi_rec_tii.tii_chr_attrib36,p_level);
   nm_debug.debug('tii_chr_attrib37          : '||pi_rec_tii.tii_chr_attrib37,p_level);
   nm_debug.debug('tii_chr_attrib38          : '||pi_rec_tii.tii_chr_attrib38,p_level);
   nm_debug.debug('tii_chr_attrib39          : '||pi_rec_tii.tii_chr_attrib39,p_level);
   nm_debug.debug('tii_chr_attrib40          : '||pi_rec_tii.tii_chr_attrib40,p_level);
   nm_debug.debug('tii_chr_attrib41          : '||pi_rec_tii.tii_chr_attrib41,p_level);
   nm_debug.debug('tii_chr_attrib42          : '||pi_rec_tii.tii_chr_attrib42,p_level);
   nm_debug.debug('tii_chr_attrib43          : '||pi_rec_tii.tii_chr_attrib43,p_level);
   nm_debug.debug('tii_chr_attrib44          : '||pi_rec_tii.tii_chr_attrib44,p_level);
   nm_debug.debug('tii_chr_attrib45          : '||pi_rec_tii.tii_chr_attrib45,p_level);
   nm_debug.debug('tii_chr_attrib46          : '||pi_rec_tii.tii_chr_attrib46,p_level);
   nm_debug.debug('tii_chr_attrib47          : '||pi_rec_tii.tii_chr_attrib47,p_level);
   nm_debug.debug('tii_chr_attrib48          : '||pi_rec_tii.tii_chr_attrib48,p_level);
   nm_debug.debug('tii_chr_attrib49          : '||pi_rec_tii.tii_chr_attrib49,p_level);
   nm_debug.debug('tii_chr_attrib50          : '||pi_rec_tii.tii_chr_attrib50,p_level);
   nm_debug.debug('tii_chr_attrib51          : '||pi_rec_tii.tii_chr_attrib51,p_level);
   nm_debug.debug('tii_chr_attrib52          : '||pi_rec_tii.tii_chr_attrib52,p_level);
   nm_debug.debug('tii_chr_attrib53          : '||pi_rec_tii.tii_chr_attrib53,p_level);
   nm_debug.debug('tii_chr_attrib54          : '||pi_rec_tii.tii_chr_attrib54,p_level);
   nm_debug.debug('tii_chr_attrib55          : '||pi_rec_tii.tii_chr_attrib55,p_level);
   nm_debug.debug('tii_chr_attrib56          : '||pi_rec_tii.tii_chr_attrib56,p_level);
   nm_debug.debug('tii_chr_attrib57          : '||pi_rec_tii.tii_chr_attrib57,p_level);
   nm_debug.debug('tii_chr_attrib58          : '||pi_rec_tii.tii_chr_attrib58,p_level);
   nm_debug.debug('tii_chr_attrib59          : '||pi_rec_tii.tii_chr_attrib59,p_level);
   nm_debug.debug('tii_chr_attrib60          : '||pi_rec_tii.tii_chr_attrib60,p_level);
   nm_debug.debug('tii_chr_attrib61          : '||pi_rec_tii.tii_chr_attrib61,p_level);
   nm_debug.debug('tii_chr_attrib62          : '||pi_rec_tii.tii_chr_attrib62,p_level);
   nm_debug.debug('tii_chr_attrib63          : '||pi_rec_tii.tii_chr_attrib63,p_level);
   nm_debug.debug('tii_chr_attrib64          : '||pi_rec_tii.tii_chr_attrib64,p_level);
   nm_debug.debug('tii_chr_attrib65          : '||pi_rec_tii.tii_chr_attrib65,p_level);
   nm_debug.debug('tii_chr_attrib66          : '||pi_rec_tii.tii_chr_attrib66,p_level);
   nm_debug.debug('tii_chr_attrib67          : '||pi_rec_tii.tii_chr_attrib67,p_level);
   nm_debug.debug('tii_chr_attrib68          : '||pi_rec_tii.tii_chr_attrib68,p_level);
   nm_debug.debug('tii_chr_attrib69          : '||pi_rec_tii.tii_chr_attrib69,p_level);
   nm_debug.debug('tii_chr_attrib70          : '||pi_rec_tii.tii_chr_attrib70,p_level);
   nm_debug.debug('tii_chr_attrib71          : '||pi_rec_tii.tii_chr_attrib71,p_level);
   nm_debug.debug('tii_chr_attrib72          : '||pi_rec_tii.tii_chr_attrib72,p_level);
   nm_debug.debug('tii_chr_attrib73          : '||pi_rec_tii.tii_chr_attrib73,p_level);
   nm_debug.debug('tii_chr_attrib74          : '||pi_rec_tii.tii_chr_attrib74,p_level);
   nm_debug.debug('tii_chr_attrib75          : '||pi_rec_tii.tii_chr_attrib75,p_level);
   nm_debug.debug('tii_num_attrib76          : '||pi_rec_tii.tii_num_attrib76,p_level);
   nm_debug.debug('tii_num_attrib77          : '||pi_rec_tii.tii_num_attrib77,p_level);
   nm_debug.debug('tii_num_attrib78          : '||pi_rec_tii.tii_num_attrib78,p_level);
   nm_debug.debug('tii_num_attrib79          : '||pi_rec_tii.tii_num_attrib79,p_level);
   nm_debug.debug('tii_num_attrib80          : '||pi_rec_tii.tii_num_attrib80,p_level);
   nm_debug.debug('tii_num_attrib81          : '||pi_rec_tii.tii_num_attrib81,p_level);
   nm_debug.debug('tii_num_attrib82          : '||pi_rec_tii.tii_num_attrib82,p_level);
   nm_debug.debug('tii_num_attrib83          : '||pi_rec_tii.tii_num_attrib83,p_level);
   nm_debug.debug('tii_num_attrib84          : '||pi_rec_tii.tii_num_attrib84,p_level);
   nm_debug.debug('tii_num_attrib85          : '||pi_rec_tii.tii_num_attrib85,p_level);
   nm_debug.debug('tii_date_attrib86         : '||pi_rec_tii.tii_date_attrib86,p_level);
   nm_debug.debug('tii_date_attrib87         : '||pi_rec_tii.tii_date_attrib87,p_level);
   nm_debug.debug('tii_date_attrib88         : '||pi_rec_tii.tii_date_attrib88,p_level);
   nm_debug.debug('tii_date_attrib89         : '||pi_rec_tii.tii_date_attrib89,p_level);
   nm_debug.debug('tii_date_attrib90         : '||pi_rec_tii.tii_date_attrib90,p_level);
   nm_debug.debug('tii_date_attrib91         : '||pi_rec_tii.tii_date_attrib91,p_level);
   nm_debug.debug('tii_date_attrib92         : '||pi_rec_tii.tii_date_attrib92,p_level);
   nm_debug.debug('tii_date_attrib93         : '||pi_rec_tii.tii_date_attrib93,p_level);
   nm_debug.debug('tii_date_attrib94         : '||pi_rec_tii.tii_date_attrib94,p_level);
   nm_debug.debug('tii_date_attrib95         : '||pi_rec_tii.tii_date_attrib95,p_level);
   nm_debug.debug('tii_angle                 : '||pi_rec_tii.tii_angle,p_level);
   nm_debug.debug('tii_angle_txt             : '||pi_rec_tii.tii_angle_txt,p_level);
   nm_debug.debug('tii_class                 : '||pi_rec_tii.tii_class,p_level);
   nm_debug.debug('tii_class_txt             : '||pi_rec_tii.tii_class_txt,p_level);
   nm_debug.debug('tii_colour                : '||pi_rec_tii.tii_colour,p_level);
   nm_debug.debug('tii_colour_txt            : '||pi_rec_tii.tii_colour_txt,p_level);
   nm_debug.debug('tii_coord_flag            : '||pi_rec_tii.tii_coord_flag,p_level);
   nm_debug.debug('tii_description           : '||pi_rec_tii.tii_description,p_level);
   nm_debug.debug('tii_diagram               : '||pi_rec_tii.tii_diagram,p_level);
   nm_debug.debug('tii_distance              : '||pi_rec_tii.tii_distance,p_level);
   nm_debug.debug('tii_end_chain             : '||pi_rec_tii.tii_end_chain,p_level);
   nm_debug.debug('tii_gap                   : '||pi_rec_tii.tii_gap,p_level);
   nm_debug.debug('tii_height                : '||pi_rec_tii.tii_height,p_level);
   nm_debug.debug('tii_height_2              : '||pi_rec_tii.tii_height_2,p_level);
   nm_debug.debug('tii_id_code               : '||pi_rec_tii.tii_id_code,p_level);
   nm_debug.debug('tii_instal_date           : '||pi_rec_tii.tii_instal_date,p_level);
   nm_debug.debug('tii_invent_date           : '||pi_rec_tii.tii_invent_date,p_level);
   nm_debug.debug('tii_inv_ownership         : '||pi_rec_tii.tii_inv_ownership,p_level);
   nm_debug.debug('tii_itemcode              : '||pi_rec_tii.tii_itemcode,p_level);
   nm_debug.debug('tii_lco_lamp_config_id    : '||pi_rec_tii.tii_lco_lamp_config_id,p_level);
   nm_debug.debug('tii_length                : '||pi_rec_tii.tii_length,p_level);
   nm_debug.debug('tii_material              : '||pi_rec_tii.tii_material,p_level);
   nm_debug.debug('tii_material_txt          : '||pi_rec_tii.tii_material_txt,p_level);
   nm_debug.debug('tii_method                : '||pi_rec_tii.tii_method,p_level);
   nm_debug.debug('tii_method_txt            : '||pi_rec_tii.tii_method_txt,p_level);
   nm_debug.debug('tii_note                  : '||pi_rec_tii.tii_note,p_level);
   nm_debug.debug('tii_no_of_units           : '||pi_rec_tii.tii_no_of_units,p_level);
   nm_debug.debug('tii_options               : '||pi_rec_tii.tii_options,p_level);
   nm_debug.debug('tii_options_txt           : '||pi_rec_tii.tii_options_txt,p_level);
   nm_debug.debug('tii_oun_org_id_elec_board : '||pi_rec_tii.tii_oun_org_id_elec_board,p_level);
   nm_debug.debug('tii_owner                 : '||pi_rec_tii.tii_owner,p_level);
   nm_debug.debug('tii_owner_txt             : '||pi_rec_tii.tii_owner_txt,p_level);
   nm_debug.debug('tii_peo_invent_by_id      : '||pi_rec_tii.tii_peo_invent_by_id,p_level);
   nm_debug.debug('tii_photo                 : '||pi_rec_tii.tii_photo,p_level);
   nm_debug.debug('tii_power                 : '||pi_rec_tii.tii_power,p_level);
   nm_debug.debug('tii_prov_flag             : '||pi_rec_tii.tii_prov_flag,p_level);
   nm_debug.debug('tii_rev_by                : '||pi_rec_tii.tii_rev_by,p_level);
   nm_debug.debug('tii_rev_date              : '||pi_rec_tii.tii_rev_date,p_level);
   nm_debug.debug('tii_type                  : '||pi_rec_tii.tii_type,p_level);
   nm_debug.debug('tii_type_txt              : '||pi_rec_tii.tii_type_txt,p_level);
   nm_debug.debug('tii_width                 : '||pi_rec_tii.tii_width,p_level);
   nm_debug.debug('tii_xtra_char_1           : '||pi_rec_tii.tii_xtra_char_1,p_level);
   nm_debug.debug('tii_xtra_date_1           : '||pi_rec_tii.tii_xtra_date_1,p_level);
   nm_debug.debug('tii_xtra_domain_1         : '||pi_rec_tii.tii_xtra_domain_1,p_level);
   nm_debug.debug('tii_xtra_domain_txt_1     : '||pi_rec_tii.tii_xtra_domain_txt_1,p_level);
   nm_debug.debug('tii_xtra_number_1         : '||pi_rec_tii.tii_xtra_number_1,p_level);
   nm_debug.debug('tii_x_sect                : '||pi_rec_tii.tii_x_sect,p_level);
   nm_debug.debug('tii_det_xsp               : '||pi_rec_tii.tii_det_xsp,p_level);
   nm_debug.debug('tii_offset                : '||pi_rec_tii.tii_offset,p_level);
   nm_debug.debug('tii_x                     : '||pi_rec_tii.tii_x,p_level);
   nm_debug.debug('tii_y                     : '||pi_rec_tii.tii_y,p_level);
   nm_debug.debug('tii_z                     : '||pi_rec_tii.tii_z,p_level);
   nm_debug.debug('tii_num_attrib96          : '||pi_rec_tii.tii_num_attrib96,p_level);
   nm_debug.debug('tii_num_attrib97          : '||pi_rec_tii.tii_num_attrib97,p_level);
   nm_debug.debug('tii_num_attrib98          : '||pi_rec_tii.tii_num_attrib98,p_level);
   nm_debug.debug('tii_num_attrib99          : '||pi_rec_tii.tii_num_attrib99,p_level);
   nm_debug.debug('tii_num_attrib100         : '||pi_rec_tii.tii_num_attrib100,p_level);
   nm_debug.debug('tii_num_attrib101         : '||pi_rec_tii.tii_num_attrib101,p_level);
   nm_debug.debug('tii_num_attrib102         : '||pi_rec_tii.tii_num_attrib102,p_level);
   nm_debug.debug('tii_num_attrib103         : '||pi_rec_tii.tii_num_attrib103,p_level);
   nm_debug.debug('tii_num_attrib104         : '||pi_rec_tii.tii_num_attrib104,p_level);
   nm_debug.debug('tii_num_attrib105         : '||pi_rec_tii.tii_num_attrib105,p_level);
   nm_debug.debug('tii_num_attrib106         : '||pi_rec_tii.tii_num_attrib106,p_level);
   nm_debug.debug('tii_num_attrib107         : '||pi_rec_tii.tii_num_attrib107,p_level);
   nm_debug.debug('tii_num_attrib108         : '||pi_rec_tii.tii_num_attrib108,p_level);
   nm_debug.debug('tii_num_attrib109         : '||pi_rec_tii.tii_num_attrib109,p_level);
   nm_debug.debug('tii_num_attrib110         : '||pi_rec_tii.tii_num_attrib110,p_level);
   nm_debug.debug('tii_num_attrib111         : '||pi_rec_tii.tii_num_attrib111,p_level);
   nm_debug.debug('tii_num_attrib112         : '||pi_rec_tii.tii_num_attrib112,p_level);
   nm_debug.debug('tii_num_attrib113         : '||pi_rec_tii.tii_num_attrib113,p_level);
   nm_debug.debug('tii_num_attrib114         : '||pi_rec_tii.tii_num_attrib114,p_level);
   nm_debug.debug('tii_num_attrib115         : '||pi_rec_tii.tii_num_attrib115,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_tii');
--
END debug_tii;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_tiit (pi_rec_tiit nm_temp_inv_items_temp%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_tiit');
--
   nm_debug.debug('tii_njc_job_id            : '||pi_rec_tiit.tii_njc_job_id,p_level);
   nm_debug.debug('tii_ne_id                 : '||pi_rec_tiit.tii_ne_id,p_level);
   nm_debug.debug('tii_ne_id_new             : '||pi_rec_tiit.tii_ne_id_new,p_level);
   nm_debug.debug('tii_inv_type              : '||pi_rec_tiit.tii_inv_type,p_level);
   nm_debug.debug('tii_primary_key_orig      : '||pi_rec_tiit.tii_primary_key_orig,p_level);
   nm_debug.debug('tii_primary_key           : '||pi_rec_tiit.tii_primary_key,p_level);
   nm_debug.debug('tii_start_date            : '||pi_rec_tiit.tii_start_date,p_level);
   nm_debug.debug('tii_date_created          : '||pi_rec_tiit.tii_date_created,p_level);
   nm_debug.debug('tii_date_modified         : '||pi_rec_tiit.tii_date_modified,p_level);
   nm_debug.debug('tii_created_by            : '||pi_rec_tiit.tii_created_by,p_level);
   nm_debug.debug('tii_modified_by           : '||pi_rec_tiit.tii_modified_by,p_level);
   nm_debug.debug('tii_admin_unit            : '||pi_rec_tiit.tii_admin_unit,p_level);
   nm_debug.debug('tii_descr                 : '||pi_rec_tiit.tii_descr,p_level);
   nm_debug.debug('tii_end_date              : '||pi_rec_tiit.tii_end_date,p_level);
   nm_debug.debug('tii_foreign_key           : '||pi_rec_tiit.tii_foreign_key,p_level);
   nm_debug.debug('tii_located_by            : '||pi_rec_tiit.tii_located_by,p_level);
   nm_debug.debug('tii_position              : '||pi_rec_tiit.tii_position,p_level);
   nm_debug.debug('tii_x_coord               : '||pi_rec_tiit.tii_x_coord,p_level);
   nm_debug.debug('tii_y_coord               : '||pi_rec_tiit.tii_y_coord,p_level);
   nm_debug.debug('tii_num_attrib16          : '||pi_rec_tiit.tii_num_attrib16,p_level);
   nm_debug.debug('tii_num_attrib17          : '||pi_rec_tiit.tii_num_attrib17,p_level);
   nm_debug.debug('tii_num_attrib18          : '||pi_rec_tiit.tii_num_attrib18,p_level);
   nm_debug.debug('tii_num_attrib19          : '||pi_rec_tiit.tii_num_attrib19,p_level);
   nm_debug.debug('tii_num_attrib20          : '||pi_rec_tiit.tii_num_attrib20,p_level);
   nm_debug.debug('tii_num_attrib21          : '||pi_rec_tiit.tii_num_attrib21,p_level);
   nm_debug.debug('tii_num_attrib22          : '||pi_rec_tiit.tii_num_attrib22,p_level);
   nm_debug.debug('tii_num_attrib23          : '||pi_rec_tiit.tii_num_attrib23,p_level);
   nm_debug.debug('tii_num_attrib24          : '||pi_rec_tiit.tii_num_attrib24,p_level);
   nm_debug.debug('tii_num_attrib25          : '||pi_rec_tiit.tii_num_attrib25,p_level);
   nm_debug.debug('tii_chr_attrib26          : '||pi_rec_tiit.tii_chr_attrib26,p_level);
   nm_debug.debug('tii_chr_attrib27          : '||pi_rec_tiit.tii_chr_attrib27,p_level);
   nm_debug.debug('tii_chr_attrib28          : '||pi_rec_tiit.tii_chr_attrib28,p_level);
   nm_debug.debug('tii_chr_attrib29          : '||pi_rec_tiit.tii_chr_attrib29,p_level);
   nm_debug.debug('tii_chr_attrib30          : '||pi_rec_tiit.tii_chr_attrib30,p_level);
   nm_debug.debug('tii_chr_attrib31          : '||pi_rec_tiit.tii_chr_attrib31,p_level);
   nm_debug.debug('tii_chr_attrib32          : '||pi_rec_tiit.tii_chr_attrib32,p_level);
   nm_debug.debug('tii_chr_attrib33          : '||pi_rec_tiit.tii_chr_attrib33,p_level);
   nm_debug.debug('tii_chr_attrib34          : '||pi_rec_tiit.tii_chr_attrib34,p_level);
   nm_debug.debug('tii_chr_attrib35          : '||pi_rec_tiit.tii_chr_attrib35,p_level);
   nm_debug.debug('tii_chr_attrib36          : '||pi_rec_tiit.tii_chr_attrib36,p_level);
   nm_debug.debug('tii_chr_attrib37          : '||pi_rec_tiit.tii_chr_attrib37,p_level);
   nm_debug.debug('tii_chr_attrib38          : '||pi_rec_tiit.tii_chr_attrib38,p_level);
   nm_debug.debug('tii_chr_attrib39          : '||pi_rec_tiit.tii_chr_attrib39,p_level);
   nm_debug.debug('tii_chr_attrib40          : '||pi_rec_tiit.tii_chr_attrib40,p_level);
   nm_debug.debug('tii_chr_attrib41          : '||pi_rec_tiit.tii_chr_attrib41,p_level);
   nm_debug.debug('tii_chr_attrib42          : '||pi_rec_tiit.tii_chr_attrib42,p_level);
   nm_debug.debug('tii_chr_attrib43          : '||pi_rec_tiit.tii_chr_attrib43,p_level);
   nm_debug.debug('tii_chr_attrib44          : '||pi_rec_tiit.tii_chr_attrib44,p_level);
   nm_debug.debug('tii_chr_attrib45          : '||pi_rec_tiit.tii_chr_attrib45,p_level);
   nm_debug.debug('tii_chr_attrib46          : '||pi_rec_tiit.tii_chr_attrib46,p_level);
   nm_debug.debug('tii_chr_attrib47          : '||pi_rec_tiit.tii_chr_attrib47,p_level);
   nm_debug.debug('tii_chr_attrib48          : '||pi_rec_tiit.tii_chr_attrib48,p_level);
   nm_debug.debug('tii_chr_attrib49          : '||pi_rec_tiit.tii_chr_attrib49,p_level);
   nm_debug.debug('tii_chr_attrib50          : '||pi_rec_tiit.tii_chr_attrib50,p_level);
   nm_debug.debug('tii_chr_attrib51          : '||pi_rec_tiit.tii_chr_attrib51,p_level);
   nm_debug.debug('tii_chr_attrib52          : '||pi_rec_tiit.tii_chr_attrib52,p_level);
   nm_debug.debug('tii_chr_attrib53          : '||pi_rec_tiit.tii_chr_attrib53,p_level);
   nm_debug.debug('tii_chr_attrib54          : '||pi_rec_tiit.tii_chr_attrib54,p_level);
   nm_debug.debug('tii_chr_attrib55          : '||pi_rec_tiit.tii_chr_attrib55,p_level);
   nm_debug.debug('tii_chr_attrib56          : '||pi_rec_tiit.tii_chr_attrib56,p_level);
   nm_debug.debug('tii_chr_attrib57          : '||pi_rec_tiit.tii_chr_attrib57,p_level);
   nm_debug.debug('tii_chr_attrib58          : '||pi_rec_tiit.tii_chr_attrib58,p_level);
   nm_debug.debug('tii_chr_attrib59          : '||pi_rec_tiit.tii_chr_attrib59,p_level);
   nm_debug.debug('tii_chr_attrib60          : '||pi_rec_tiit.tii_chr_attrib60,p_level);
   nm_debug.debug('tii_chr_attrib61          : '||pi_rec_tiit.tii_chr_attrib61,p_level);
   nm_debug.debug('tii_chr_attrib62          : '||pi_rec_tiit.tii_chr_attrib62,p_level);
   nm_debug.debug('tii_chr_attrib63          : '||pi_rec_tiit.tii_chr_attrib63,p_level);
   nm_debug.debug('tii_chr_attrib64          : '||pi_rec_tiit.tii_chr_attrib64,p_level);
   nm_debug.debug('tii_chr_attrib65          : '||pi_rec_tiit.tii_chr_attrib65,p_level);
   nm_debug.debug('tii_chr_attrib66          : '||pi_rec_tiit.tii_chr_attrib66,p_level);
   nm_debug.debug('tii_chr_attrib67          : '||pi_rec_tiit.tii_chr_attrib67,p_level);
   nm_debug.debug('tii_chr_attrib68          : '||pi_rec_tiit.tii_chr_attrib68,p_level);
   nm_debug.debug('tii_chr_attrib69          : '||pi_rec_tiit.tii_chr_attrib69,p_level);
   nm_debug.debug('tii_chr_attrib70          : '||pi_rec_tiit.tii_chr_attrib70,p_level);
   nm_debug.debug('tii_chr_attrib71          : '||pi_rec_tiit.tii_chr_attrib71,p_level);
   nm_debug.debug('tii_chr_attrib72          : '||pi_rec_tiit.tii_chr_attrib72,p_level);
   nm_debug.debug('tii_chr_attrib73          : '||pi_rec_tiit.tii_chr_attrib73,p_level);
   nm_debug.debug('tii_chr_attrib74          : '||pi_rec_tiit.tii_chr_attrib74,p_level);
   nm_debug.debug('tii_chr_attrib75          : '||pi_rec_tiit.tii_chr_attrib75,p_level);
   nm_debug.debug('tii_num_attrib76          : '||pi_rec_tiit.tii_num_attrib76,p_level);
   nm_debug.debug('tii_num_attrib77          : '||pi_rec_tiit.tii_num_attrib77,p_level);
   nm_debug.debug('tii_num_attrib78          : '||pi_rec_tiit.tii_num_attrib78,p_level);
   nm_debug.debug('tii_num_attrib79          : '||pi_rec_tiit.tii_num_attrib79,p_level);
   nm_debug.debug('tii_num_attrib80          : '||pi_rec_tiit.tii_num_attrib80,p_level);
   nm_debug.debug('tii_num_attrib81          : '||pi_rec_tiit.tii_num_attrib81,p_level);
   nm_debug.debug('tii_num_attrib82          : '||pi_rec_tiit.tii_num_attrib82,p_level);
   nm_debug.debug('tii_num_attrib83          : '||pi_rec_tiit.tii_num_attrib83,p_level);
   nm_debug.debug('tii_num_attrib84          : '||pi_rec_tiit.tii_num_attrib84,p_level);
   nm_debug.debug('tii_num_attrib85          : '||pi_rec_tiit.tii_num_attrib85,p_level);
   nm_debug.debug('tii_date_attrib86         : '||pi_rec_tiit.tii_date_attrib86,p_level);
   nm_debug.debug('tii_date_attrib87         : '||pi_rec_tiit.tii_date_attrib87,p_level);
   nm_debug.debug('tii_date_attrib88         : '||pi_rec_tiit.tii_date_attrib88,p_level);
   nm_debug.debug('tii_date_attrib89         : '||pi_rec_tiit.tii_date_attrib89,p_level);
   nm_debug.debug('tii_date_attrib90         : '||pi_rec_tiit.tii_date_attrib90,p_level);
   nm_debug.debug('tii_date_attrib91         : '||pi_rec_tiit.tii_date_attrib91,p_level);
   nm_debug.debug('tii_date_attrib92         : '||pi_rec_tiit.tii_date_attrib92,p_level);
   nm_debug.debug('tii_date_attrib93         : '||pi_rec_tiit.tii_date_attrib93,p_level);
   nm_debug.debug('tii_date_attrib94         : '||pi_rec_tiit.tii_date_attrib94,p_level);
   nm_debug.debug('tii_date_attrib95         : '||pi_rec_tiit.tii_date_attrib95,p_level);
   nm_debug.debug('tii_angle                 : '||pi_rec_tiit.tii_angle,p_level);
   nm_debug.debug('tii_angle_txt             : '||pi_rec_tiit.tii_angle_txt,p_level);
   nm_debug.debug('tii_class                 : '||pi_rec_tiit.tii_class,p_level);
   nm_debug.debug('tii_class_txt             : '||pi_rec_tiit.tii_class_txt,p_level);
   nm_debug.debug('tii_colour                : '||pi_rec_tiit.tii_colour,p_level);
   nm_debug.debug('tii_colour_txt            : '||pi_rec_tiit.tii_colour_txt,p_level);
   nm_debug.debug('tii_coord_flag            : '||pi_rec_tiit.tii_coord_flag,p_level);
   nm_debug.debug('tii_description           : '||pi_rec_tiit.tii_description,p_level);
   nm_debug.debug('tii_diagram               : '||pi_rec_tiit.tii_diagram,p_level);
   nm_debug.debug('tii_distance              : '||pi_rec_tiit.tii_distance,p_level);
   nm_debug.debug('tii_end_chain             : '||pi_rec_tiit.tii_end_chain,p_level);
   nm_debug.debug('tii_gap                   : '||pi_rec_tiit.tii_gap,p_level);
   nm_debug.debug('tii_height                : '||pi_rec_tiit.tii_height,p_level);
   nm_debug.debug('tii_height_2              : '||pi_rec_tiit.tii_height_2,p_level);
   nm_debug.debug('tii_id_code               : '||pi_rec_tiit.tii_id_code,p_level);
   nm_debug.debug('tii_instal_date           : '||pi_rec_tiit.tii_instal_date,p_level);
   nm_debug.debug('tii_invent_date           : '||pi_rec_tiit.tii_invent_date,p_level);
   nm_debug.debug('tii_inv_ownership         : '||pi_rec_tiit.tii_inv_ownership,p_level);
   nm_debug.debug('tii_itemcode              : '||pi_rec_tiit.tii_itemcode,p_level);
   nm_debug.debug('tii_lco_lamp_config_id    : '||pi_rec_tiit.tii_lco_lamp_config_id,p_level);
   nm_debug.debug('tii_length                : '||pi_rec_tiit.tii_length,p_level);
   nm_debug.debug('tii_material              : '||pi_rec_tiit.tii_material,p_level);
   nm_debug.debug('tii_material_txt          : '||pi_rec_tiit.tii_material_txt,p_level);
   nm_debug.debug('tii_method                : '||pi_rec_tiit.tii_method,p_level);
   nm_debug.debug('tii_method_txt            : '||pi_rec_tiit.tii_method_txt,p_level);
   nm_debug.debug('tii_note                  : '||pi_rec_tiit.tii_note,p_level);
   nm_debug.debug('tii_no_of_units           : '||pi_rec_tiit.tii_no_of_units,p_level);
   nm_debug.debug('tii_options               : '||pi_rec_tiit.tii_options,p_level);
   nm_debug.debug('tii_options_txt           : '||pi_rec_tiit.tii_options_txt,p_level);
   nm_debug.debug('tii_oun_org_id_elec_board : '||pi_rec_tiit.tii_oun_org_id_elec_board,p_level);
   nm_debug.debug('tii_owner                 : '||pi_rec_tiit.tii_owner,p_level);
   nm_debug.debug('tii_owner_txt             : '||pi_rec_tiit.tii_owner_txt,p_level);
   nm_debug.debug('tii_peo_invent_by_id      : '||pi_rec_tiit.tii_peo_invent_by_id,p_level);
   nm_debug.debug('tii_photo                 : '||pi_rec_tiit.tii_photo,p_level);
   nm_debug.debug('tii_power                 : '||pi_rec_tiit.tii_power,p_level);
   nm_debug.debug('tii_prov_flag             : '||pi_rec_tiit.tii_prov_flag,p_level);
   nm_debug.debug('tii_rev_by                : '||pi_rec_tiit.tii_rev_by,p_level);
   nm_debug.debug('tii_rev_date              : '||pi_rec_tiit.tii_rev_date,p_level);
   nm_debug.debug('tii_type                  : '||pi_rec_tiit.tii_type,p_level);
   nm_debug.debug('tii_type_txt              : '||pi_rec_tiit.tii_type_txt,p_level);
   nm_debug.debug('tii_width                 : '||pi_rec_tiit.tii_width,p_level);
   nm_debug.debug('tii_xtra_char_1           : '||pi_rec_tiit.tii_xtra_char_1,p_level);
   nm_debug.debug('tii_xtra_date_1           : '||pi_rec_tiit.tii_xtra_date_1,p_level);
   nm_debug.debug('tii_xtra_domain_1         : '||pi_rec_tiit.tii_xtra_domain_1,p_level);
   nm_debug.debug('tii_xtra_domain_txt_1     : '||pi_rec_tiit.tii_xtra_domain_txt_1,p_level);
   nm_debug.debug('tii_xtra_number_1         : '||pi_rec_tiit.tii_xtra_number_1,p_level);
   nm_debug.debug('tii_x_sect                : '||pi_rec_tiit.tii_x_sect,p_level);
   nm_debug.debug('tii_det_xsp               : '||pi_rec_tiit.tii_det_xsp,p_level);
   nm_debug.debug('tii_offset                : '||pi_rec_tiit.tii_offset,p_level);
   nm_debug.debug('tii_x                     : '||pi_rec_tiit.tii_x,p_level);
   nm_debug.debug('tii_y                     : '||pi_rec_tiit.tii_y,p_level);
   nm_debug.debug('tii_z                     : '||pi_rec_tiit.tii_z,p_level);
   nm_debug.debug('tii_num_attrib96          : '||pi_rec_tiit.tii_num_attrib96,p_level);
   nm_debug.debug('tii_num_attrib97          : '||pi_rec_tiit.tii_num_attrib97,p_level);
   nm_debug.debug('tii_num_attrib98          : '||pi_rec_tiit.tii_num_attrib98,p_level);
   nm_debug.debug('tii_num_attrib99          : '||pi_rec_tiit.tii_num_attrib99,p_level);
   nm_debug.debug('tii_num_attrib100         : '||pi_rec_tiit.tii_num_attrib100,p_level);
   nm_debug.debug('tii_num_attrib101         : '||pi_rec_tiit.tii_num_attrib101,p_level);
   nm_debug.debug('tii_num_attrib102         : '||pi_rec_tiit.tii_num_attrib102,p_level);
   nm_debug.debug('tii_num_attrib103         : '||pi_rec_tiit.tii_num_attrib103,p_level);
   nm_debug.debug('tii_num_attrib104         : '||pi_rec_tiit.tii_num_attrib104,p_level);
   nm_debug.debug('tii_num_attrib105         : '||pi_rec_tiit.tii_num_attrib105,p_level);
   nm_debug.debug('tii_num_attrib106         : '||pi_rec_tiit.tii_num_attrib106,p_level);
   nm_debug.debug('tii_num_attrib107         : '||pi_rec_tiit.tii_num_attrib107,p_level);
   nm_debug.debug('tii_num_attrib108         : '||pi_rec_tiit.tii_num_attrib108,p_level);
   nm_debug.debug('tii_num_attrib109         : '||pi_rec_tiit.tii_num_attrib109,p_level);
   nm_debug.debug('tii_num_attrib110         : '||pi_rec_tiit.tii_num_attrib110,p_level);
   nm_debug.debug('tii_num_attrib111         : '||pi_rec_tiit.tii_num_attrib111,p_level);
   nm_debug.debug('tii_num_attrib112         : '||pi_rec_tiit.tii_num_attrib112,p_level);
   nm_debug.debug('tii_num_attrib113         : '||pi_rec_tiit.tii_num_attrib113,p_level);
   nm_debug.debug('tii_num_attrib114         : '||pi_rec_tiit.tii_num_attrib114,p_level);
   nm_debug.debug('tii_num_attrib115         : '||pi_rec_tiit.tii_num_attrib115,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_tiit');
--
END debug_tiit;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_tim (pi_rec_tim nm_temp_inv_members%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_tim');
--
   nm_debug.debug('tim_njc_job_id      : '||pi_rec_tim.tim_njc_job_id,p_level);
   nm_debug.debug('tim_ne_id_in        : '||pi_rec_tim.tim_ne_id_in,p_level);
   nm_debug.debug('tim_ne_id_in_new    : '||pi_rec_tim.tim_ne_id_in_new,p_level);
   nm_debug.debug('tim_ne_id_of        : '||pi_rec_tim.tim_ne_id_of,p_level);
   nm_debug.debug('tim_type            : '||pi_rec_tim.tim_type,p_level);
   nm_debug.debug('tim_obj_type        : '||pi_rec_tim.tim_obj_type,p_level);
   nm_debug.debug('tim_start_date      : '||pi_rec_tim.tim_start_date,p_level);
   nm_debug.debug('tim_end_date        : '||pi_rec_tim.tim_end_date,p_level);
   nm_debug.debug('tim_slk             : '||pi_rec_tim.tim_slk,p_level);
   nm_debug.debug('tim_cardinality     : '||pi_rec_tim.tim_cardinality,p_level);
   nm_debug.debug('tim_admin_unit      : '||pi_rec_tim.tim_admin_unit,p_level);
   nm_debug.debug('tim_date_created    : '||pi_rec_tim.tim_date_created,p_level);
   nm_debug.debug('tim_date_modified   : '||pi_rec_tim.tim_date_modified,p_level);
   nm_debug.debug('tim_modified_by     : '||pi_rec_tim.tim_modified_by,p_level);
   nm_debug.debug('tim_created_by      : '||pi_rec_tim.tim_created_by,p_level);
   nm_debug.debug('tim_seq_no          : '||pi_rec_tim.tim_seq_no,p_level);
   nm_debug.debug('tim_seg_no          : '||pi_rec_tim.tim_seg_no,p_level);
   nm_debug.debug('tim_true            : '||pi_rec_tim.tim_true,p_level);
   nm_debug.debug('tim_extent_begin_mp : '||pi_rec_tim.tim_extent_begin_mp,p_level);
   nm_debug.debug('tim_extent_end_mp   : '||pi_rec_tim.tim_extent_end_mp,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_tim');
--
END debug_tim;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_timt (pi_rec_timt nm_temp_inv_members_temp%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_timt');
--
   nm_debug.debug('tim_njc_job_id      : '||pi_rec_timt.tim_njc_job_id,p_level);
   nm_debug.debug('tim_ne_id_in        : '||pi_rec_timt.tim_ne_id_in,p_level);
   nm_debug.debug('tim_ne_id_in_new    : '||pi_rec_timt.tim_ne_id_in_new,p_level);
   nm_debug.debug('tim_ne_id_of        : '||pi_rec_timt.tim_ne_id_of,p_level);
   nm_debug.debug('tim_type            : '||pi_rec_timt.tim_type,p_level);
   nm_debug.debug('tim_obj_type        : '||pi_rec_timt.tim_obj_type,p_level);
   nm_debug.debug('tim_start_date      : '||pi_rec_timt.tim_start_date,p_level);
   nm_debug.debug('tim_end_date        : '||pi_rec_timt.tim_end_date,p_level);
   nm_debug.debug('tim_slk             : '||pi_rec_timt.tim_slk,p_level);
   nm_debug.debug('tim_cardinality     : '||pi_rec_timt.tim_cardinality,p_level);
   nm_debug.debug('tim_admin_unit      : '||pi_rec_timt.tim_admin_unit,p_level);
   nm_debug.debug('tim_date_created    : '||pi_rec_timt.tim_date_created,p_level);
   nm_debug.debug('tim_date_modified   : '||pi_rec_timt.tim_date_modified,p_level);
   nm_debug.debug('tim_modified_by     : '||pi_rec_timt.tim_modified_by,p_level);
   nm_debug.debug('tim_created_by      : '||pi_rec_timt.tim_created_by,p_level);
   nm_debug.debug('tim_seq_no          : '||pi_rec_timt.tim_seq_no,p_level);
   nm_debug.debug('tim_seg_no          : '||pi_rec_timt.tim_seg_no,p_level);
   nm_debug.debug('tim_true            : '||pi_rec_timt.tim_true,p_level);
   nm_debug.debug('tim_extent_begin_mp : '||pi_rec_timt.tim_extent_begin_mp,p_level);
   nm_debug.debug('tim_extent_end_mp   : '||pi_rec_timt.tim_extent_end_mp,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_timt');
--
END debug_timt;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ntn (pi_rec_ntn nm_temp_nodes%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ntn');
--
   nm_debug.debug('ntn_route_id  : '||pi_rec_ntn.ntn_route_id,p_level);
   nm_debug.debug('ntn_node_id   : '||pi_rec_ntn.ntn_node_id,p_level);
   nm_debug.debug('ntn_int_road  : '||pi_rec_ntn.ntn_int_road,p_level);
   nm_debug.debug('ntn_node_type : '||pi_rec_ntn.ntn_node_type,p_level);
   nm_debug.debug('ntn_poe       : '||pi_rec_ntn.ntn_poe,p_level);
   nm_debug.debug('ntn_seq       : '||pi_rec_ntn.ntn_seq,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ntn');
--
END debug_ntn;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nth (pi_rec_nth nm_themes_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nth');
--
   nm_debug.debug('nth_theme_id             : '||pi_rec_nth.nth_theme_id,p_level);
   nm_debug.debug('nth_theme_name           : '||pi_rec_nth.nth_theme_name,p_level);
   nm_debug.debug('nth_table_name           : '||pi_rec_nth.nth_table_name,p_level);
   nm_debug.debug('nth_where                : '||pi_rec_nth.nth_where,p_level);
   nm_debug.debug('nth_pk_column            : '||pi_rec_nth.nth_pk_column,p_level);
   nm_debug.debug('nth_label_column         : '||pi_rec_nth.nth_label_column,p_level);
   nm_debug.debug('nth_rse_table_name       : '||pi_rec_nth.nth_rse_table_name,p_level);
   nm_debug.debug('nth_rse_fk_column        : '||pi_rec_nth.nth_rse_fk_column,p_level);
   nm_debug.debug('nth_st_chain_column      : '||pi_rec_nth.nth_st_chain_column,p_level);
   nm_debug.debug('nth_end_chain_column     : '||pi_rec_nth.nth_end_chain_column,p_level);
   nm_debug.debug('nth_x_column             : '||pi_rec_nth.nth_x_column,p_level);
   nm_debug.debug('nth_y_column             : '||pi_rec_nth.nth_y_column,p_level);
   nm_debug.debug('nth_offset_field         : '||pi_rec_nth.nth_offset_field,p_level);
   nm_debug.debug('nth_feature_table        : '||pi_rec_nth.nth_feature_table,p_level);
   nm_debug.debug('nth_feature_pk_column    : '||pi_rec_nth.nth_feature_pk_column,p_level);
   nm_debug.debug('nth_feature_fk_column    : '||pi_rec_nth.nth_feature_fk_column,p_level);
   nm_debug.debug('nth_xsp_column           : '||pi_rec_nth.nth_xsp_column,p_level);
   nm_debug.debug('nth_feature_shape_column : '||pi_rec_nth.nth_feature_shape_column,p_level);
   nm_debug.debug('nth_hpr_product          : '||pi_rec_nth.nth_hpr_product,p_level);
   nm_debug.debug('nth_location_updatable   : '||pi_rec_nth.nth_location_updatable,p_level);
   nm_debug.debug('nth_theme_type           : '||pi_rec_nth.nth_theme_type,p_level);
   nm_debug.debug('nth_dependency           : '||pi_rec_nth.nth_dependency,p_level);
   nm_debug.debug('nth_storage              : '||pi_rec_nth.nth_storage,p_level);
   nm_debug.debug('nth_update_on_edit       : '||pi_rec_nth.nth_update_on_edit,p_level);
   nm_debug.debug('nth_use_history          : '||pi_rec_nth.nth_use_history,p_level);
   nm_debug.debug('nth_start_date_column    : '||pi_rec_nth.nth_start_date_column,p_level);
   nm_debug.debug('nth_end_date_column      : '||pi_rec_nth.nth_end_date_column,p_level);
   nm_debug.debug('nth_base_table_theme     : '||pi_rec_nth.nth_base_table_theme,p_level);
   nm_debug.debug('nth_sequence_name        : '||pi_rec_nth.nth_sequence_name,p_level);
   nm_debug.debug('nth_snap_to_theme        : '||pi_rec_nth.nth_snap_to_theme,p_level);
   nm_debug.debug('nth_lref_mandatory       : '||pi_rec_nth.nth_lref_mandatory,p_level);
   nm_debug.debug('nth_tolerance            : '||pi_rec_nth.nth_tolerance,p_level);
   nm_debug.debug('nth_tol_units            : '||pi_rec_nth.nth_tol_units,p_level);
   nm_debug.debug('nth_dynamic_theme        : '||pi_rec_nth.nth_dynamic_theme,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nth');
--
END debug_nth;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ntg (pi_rec_ntg nm_theme_gtypes%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ntg');
--
   nm_debug.debug('ntg_theme_id : '||pi_rec_ntg.ntg_theme_id,p_level);
   nm_debug.debug('ntg_gtype    : '||pi_rec_ntg.ntg_gtype,p_level);
   nm_debug.debug('ntg_seq_no   : '||pi_rec_ntg.ntg_seq_no,p_level);
   nm_debug.debug('ntg_xml_url  : '||pi_rec_ntg.ntg_xml_url,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ntg');
--
END debug_ntg;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ntf (pi_rec_ntf nm_theme_functions_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ntf');
--
   nm_debug.debug('ntf_nth_theme_id : '||pi_rec_ntf.ntf_nth_theme_id,p_level);
   nm_debug.debug('ntf_hmo_module   : '||pi_rec_ntf.ntf_hmo_module,p_level);
   nm_debug.debug('ntf_parameter    : '||pi_rec_ntf.ntf_parameter,p_level);
   nm_debug.debug('ntf_menu_option  : '||pi_rec_ntf.ntf_menu_option,p_level);
   nm_debug.debug('ntf_seen_in_gis  : '||pi_rec_ntf.ntf_seen_in_gis,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ntf');
--
END debug_ntf;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nthr (pi_rec_nthr nm_theme_roles%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nthr');
--
   nm_debug.debug('nthr_theme_id : '||pi_rec_nthr.nthr_theme_id,p_level);
   nm_debug.debug('nthr_role     : '||pi_rec_nthr.nthr_role,p_level);
   nm_debug.debug('nthr_mode     : '||pi_rec_nthr.nthr_mode,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nthr');
--
END debug_nthr;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nts (pi_rec_nts nm_theme_snaps%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nts');
--
   nm_debug.debug('nts_theme_id : '||pi_rec_nts.nts_theme_id,p_level);
   nm_debug.debug('nts_snap_to  : '||pi_rec_nts.nts_snap_to,p_level);
   nm_debug.debug('nts_priority : '||pi_rec_nts.nts_priority,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nts');
--
END debug_nts;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nt (pi_rec_nt nm_types%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nt');
--
   nm_debug.debug('nt_type        : '||pi_rec_nt.nt_type,p_level);
   nm_debug.debug('nt_unique      : '||pi_rec_nt.nt_unique,p_level);
   nm_debug.debug('nt_linear      : '||pi_rec_nt.nt_linear,p_level);
   nm_debug.debug('nt_node_type   : '||pi_rec_nt.nt_node_type,p_level);
   nm_debug.debug('nt_descr       : '||pi_rec_nt.nt_descr,p_level);
   nm_debug.debug('nt_admin_type  : '||pi_rec_nt.nt_admin_type,p_level);
   nm_debug.debug('nt_length_unit : '||pi_rec_nt.nt_length_unit,p_level);
   nm_debug.debug('nt_datum       : '||pi_rec_nt.nt_datum,p_level);
   nm_debug.debug('nt_pop_unique  : '||pi_rec_nt.nt_pop_unique,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nt');
--
END debug_nt;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ntc (pi_rec_ntc nm_type_columns%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ntc');
--
   nm_debug.debug('ntc_nt_type       : '||pi_rec_ntc.ntc_nt_type,p_level);
   nm_debug.debug('ntc_column_name   : '||pi_rec_ntc.ntc_column_name,p_level);
   nm_debug.debug('ntc_column_type   : '||pi_rec_ntc.ntc_column_type,p_level);
   nm_debug.debug('ntc_seq_no        : '||pi_rec_ntc.ntc_seq_no,p_level);
   nm_debug.debug('ntc_displayed     : '||pi_rec_ntc.ntc_displayed,p_level);
   nm_debug.debug('ntc_str_length    : '||pi_rec_ntc.ntc_str_length,p_level);
   nm_debug.debug('ntc_mandatory     : '||pi_rec_ntc.ntc_mandatory,p_level);
   nm_debug.debug('ntc_domain        : '||pi_rec_ntc.ntc_domain,p_level);
   nm_debug.debug('ntc_query         : '||pi_rec_ntc.ntc_query,p_level);
   nm_debug.debug('ntc_inherit       : '||pi_rec_ntc.ntc_inherit,p_level);
   nm_debug.debug('ntc_string_start  : '||pi_rec_ntc.ntc_string_start,p_level);
   nm_debug.debug('ntc_string_end    : '||pi_rec_ntc.ntc_string_end,p_level);
   nm_debug.debug('ntc_seq_name      : '||pi_rec_ntc.ntc_seq_name,p_level);
   nm_debug.debug('ntc_format        : '||pi_rec_ntc.ntc_format,p_level);
   nm_debug.debug('ntc_prompt        : '||pi_rec_ntc.ntc_prompt,p_level);
   nm_debug.debug('ntc_default       : '||pi_rec_ntc.ntc_default,p_level);
   nm_debug.debug('ntc_default_type  : '||pi_rec_ntc.ntc_default_type,p_level);
   nm_debug.debug('ntc_separator     : '||pi_rec_ntc.ntc_separator,p_level);
   nm_debug.debug('ntc_unique_seq    : '||pi_rec_ntc.ntc_unique_seq,p_level);
   nm_debug.debug('ntc_unique_format : '||pi_rec_ntc.ntc_unique_format,p_level);
   nm_debug.debug('ntc_updatable     : '||pi_rec_ntc.ntc_updatable,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ntc');
--
END debug_ntc;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nti (pi_rec_nti nm_type_inclusion%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nti');
--
   nm_debug.debug('nti_nw_parent_type      : '||pi_rec_nti.nti_nw_parent_type,p_level);
   nm_debug.debug('nti_nw_child_type       : '||pi_rec_nti.nti_nw_child_type,p_level);
   nm_debug.debug('nti_parent_column       : '||pi_rec_nti.nti_parent_column,p_level);
   nm_debug.debug('nti_child_column        : '||pi_rec_nti.nti_child_column,p_level);
   nm_debug.debug('nti_auto_include        : '||pi_rec_nti.nti_auto_include,p_level);
   nm_debug.debug('nti_auto_create         : '||pi_rec_nti.nti_auto_create,p_level);
   nm_debug.debug('nti_reverse_allowed     : '||pi_rec_nti.nti_reverse_allowed,p_level);
   nm_debug.debug('nti_code_control_column : '||pi_rec_nti.nti_code_control_column,p_level);
   nm_debug.debug('nti_group_name          : '||pi_rec_nti.nti_group_name,p_level);
   nm_debug.debug('nti_search              : '||pi_rec_nti.nti_search,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nti');
--
END debug_nti;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ntl (pi_rec_ntl nm_type_layers%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ntl');
--
   nm_debug.debug('ntl_nt_type    : '||pi_rec_ntl.ntl_nt_type,p_level);
   nm_debug.debug('ntl_layer_id   : '||pi_rec_ntl.ntl_layer_id,p_level);
   nm_debug.debug('ntl_start_date : '||pi_rec_ntl.ntl_start_date,p_level);
   nm_debug.debug('ntl_end_date   : '||pi_rec_ntl.ntl_end_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ntl');
--
END debug_ntl;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ntl_all (pi_rec_ntl_all nm_type_layers_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ntl_all');
--
   nm_debug.debug('ntl_nt_type    : '||pi_rec_ntl_all.ntl_nt_type,p_level);
   nm_debug.debug('ntl_layer_id   : '||pi_rec_ntl_all.ntl_layer_id,p_level);
   nm_debug.debug('ntl_start_date : '||pi_rec_ntl_all.ntl_start_date,p_level);
   nm_debug.debug('ntl_end_date   : '||pi_rec_ntl_all.ntl_end_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ntl_all');
--
END debug_ntl_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nsc (pi_rec_nsc nm_type_subclass%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nsc');
--
   nm_debug.debug('nsc_nw_type   : '||pi_rec_nsc.nsc_nw_type,p_level);
   nm_debug.debug('nsc_sub_class : '||pi_rec_nsc.nsc_sub_class,p_level);
   nm_debug.debug('nsc_descr     : '||pi_rec_nsc.nsc_descr,p_level);
   nm_debug.debug('nsc_seq_no    : '||pi_rec_nsc.nsc_seq_no,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nsc');
--
END debug_nsc;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nsr (pi_rec_nsr nm_type_subclass_restrictions%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nsr');
--
   nm_debug.debug('nsr_nw_type            : '||pi_rec_nsr.nsr_nw_type,p_level);
   nm_debug.debug('nsr_sub_class_new      : '||pi_rec_nsr.nsr_sub_class_new,p_level);
   nm_debug.debug('nsr_sub_class_existing : '||pi_rec_nsr.nsr_sub_class_existing,p_level);
   nm_debug.debug('nsr_allowed            : '||pi_rec_nsr.nsr_allowed,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nsr');
--
END debug_nsr;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_un (pi_rec_un nm_units%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_un');
--
   nm_debug.debug('un_domain_id   : '||pi_rec_un.un_domain_id,p_level);
   nm_debug.debug('un_unit_id     : '||pi_rec_un.un_unit_id,p_level);
   nm_debug.debug('un_unit_name   : '||pi_rec_un.un_unit_name,p_level);
   nm_debug.debug('un_format_mask : '||pi_rec_un.un_format_mask,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_un');
--
END debug_un;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_uc (pi_rec_uc nm_unit_conversions%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_uc');
--
   nm_debug.debug('uc_unit_id_in        : '||pi_rec_uc.uc_unit_id_in,p_level);
   nm_debug.debug('uc_unit_id_out       : '||pi_rec_uc.uc_unit_id_out,p_level);
   nm_debug.debug('uc_function          : '||pi_rec_uc.uc_function,p_level);
   nm_debug.debug('uc_conversion        : '||pi_rec_uc.uc_conversion,p_level);
   nm_debug.debug('uc_conversion_factor : '||pi_rec_uc.uc_conversion_factor,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_uc');
--
END debug_uc;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ud (pi_rec_ud nm_unit_domains%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_ud');
--
   nm_debug.debug('ud_domain_id   : '||pi_rec_ud.ud_domain_id,p_level);
   nm_debug.debug('ud_domain_name : '||pi_rec_ud.ud_domain_name,p_level);
   nm_debug.debug('ud_text        : '||pi_rec_ud.ud_text,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_ud');
--
END debug_ud;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nuf (pi_rec_nuf nm_upload_files%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nuf');
--
   nm_debug.debug('name                   : '||pi_rec_nuf.name,p_level);
   nm_debug.debug('mime_type              : '||pi_rec_nuf.mime_type,p_level);
   nm_debug.debug('doc_size               : '||pi_rec_nuf.doc_size,p_level);
   nm_debug.debug('dad_charset            : '||pi_rec_nuf.dad_charset,p_level);
   nm_debug.debug('last_updated           : '||pi_rec_nuf.last_updated,p_level);
   nm_debug.debug('content_type           : '||pi_rec_nuf.content_type,p_level);
   nm_debug.debug('nuf_nufg_table_name    : '||pi_rec_nuf.nuf_nufg_table_name,p_level);
   nm_debug.debug('nuf_nufgc_column_val_1 : '||pi_rec_nuf.nuf_nufgc_column_val_1,p_level);
   nm_debug.debug('nuf_nufgc_column_val_2 : '||pi_rec_nuf.nuf_nufgc_column_val_2,p_level);
   nm_debug.debug('nuf_nufgc_column_val_3 : '||pi_rec_nuf.nuf_nufgc_column_val_3,p_level);
   nm_debug.debug('nuf_nufgc_column_val_4 : '||pi_rec_nuf.nuf_nufgc_column_val_4,p_level);
   nm_debug.debug('nuf_nufgc_column_val_5 : '||pi_rec_nuf.nuf_nufgc_column_val_5,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nuf');
--
END debug_nuf;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nufp (pi_rec_nufp nm_upload_filespart%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nufp');
--
   nm_debug.debug('document : '||pi_rec_nufp.document,p_level);
   nm_debug.debug('part     : '||pi_rec_nufp.part,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nufp');
--
END debug_nufp;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nua (pi_rec_nua nm_user_aus%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nua');
--
   nm_debug.debug('nua_user_id    : '||pi_rec_nua.nua_user_id,p_level);
   nm_debug.debug('nua_admin_unit : '||pi_rec_nua.nua_admin_unit,p_level);
   nm_debug.debug('nua_start_date : '||pi_rec_nua.nua_start_date,p_level);
   nm_debug.debug('nua_end_date   : '||pi_rec_nua.nua_end_date,p_level);
   nm_debug.debug('nua_mode       : '||pi_rec_nua.nua_mode,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nua');
--
END debug_nua;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nua_all (pi_rec_nua_all nm_user_aus_all%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nua_all');
--
   nm_debug.debug('nua_user_id    : '||pi_rec_nua_all.nua_user_id,p_level);
   nm_debug.debug('nua_admin_unit : '||pi_rec_nua_all.nua_admin_unit,p_level);
   nm_debug.debug('nua_start_date : '||pi_rec_nua_all.nua_start_date,p_level);
   nm_debug.debug('nua_end_date   : '||pi_rec_nua_all.nua_end_date,p_level);
   nm_debug.debug('nua_mode       : '||pi_rec_nua_all.nua_mode,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nua_all');
--
END debug_nua_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nva (pi_rec_nva nm_visual_attributes%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nva');
--
   nm_debug.debug('nva_id       : '||pi_rec_nva.nva_id,p_level);
   nm_debug.debug('nva_descr    : '||pi_rec_nva.nva_descr,p_level);
   nm_debug.debug('nva_fg_red   : '||pi_rec_nva.nva_fg_red,p_level);
   nm_debug.debug('nva_fg_green : '||pi_rec_nva.nva_fg_green,p_level);
   nm_debug.debug('nva_fg_blue  : '||pi_rec_nva.nva_fg_blue,p_level);
   nm_debug.debug('nva_bg_red   : '||pi_rec_nva.nva_bg_red,p_level);
   nm_debug.debug('nva_bg_green : '||pi_rec_nva.nva_bg_green,p_level);
   nm_debug.debug('nva_bg_blue  : '||pi_rec_nva.nva_bg_blue,p_level);
   nm_debug.debug('nva_nfp_id   : '||pi_rec_nva.nva_nfp_id,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nva');
--
END debug_nva;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nxf (pi_rec_nxf nm_xml_files%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nxf');
--
   nm_debug.debug('nxf_file_type     : '||pi_rec_nxf.nxf_file_type,p_level);
   nm_debug.debug('nxf_type          : '||pi_rec_nxf.nxf_type,p_level);
   nm_debug.debug('nxf_descr         : '||pi_rec_nxf.nxf_descr,p_level);
   nm_debug.debug('nxf_date_created  : '||pi_rec_nxf.nxf_date_created,p_level);
   nm_debug.debug('nxf_date_modified : '||pi_rec_nxf.nxf_date_modified,p_level);
   nm_debug.debug('nxf_modified_by   : '||pi_rec_nxf.nxf_modified_by,p_level);
   nm_debug.debug('nxf_created_by    : '||pi_rec_nxf.nxf_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nxf');
--
END debug_nxf;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nxb (pi_rec_nxb nm_xml_load_batches%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nxb');
--
   nm_debug.debug('nxb_batch_id      : '||pi_rec_nxb.nxb_batch_id,p_level);
   nm_debug.debug('nxb_type          : '||pi_rec_nxb.nxb_type,p_level);
   nm_debug.debug('nxb_file_type     : '||pi_rec_nxb.nxb_file_type,p_level);
   nm_debug.debug('nxb_date_created  : '||pi_rec_nxb.nxb_date_created,p_level);
   nm_debug.debug('nxb_date_modified : '||pi_rec_nxb.nxb_date_modified,p_level);
   nm_debug.debug('nxb_modified_by   : '||pi_rec_nxb.nxb_modified_by,p_level);
   nm_debug.debug('nxb_created_by    : '||pi_rec_nxb.nxb_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nxb');
--
END debug_nxb;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nxle (pi_rec_nxle nm_xml_load_errors%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nxle');
--
   nm_debug.debug('nxl_batch_id  : '||pi_rec_nxle.nxl_batch_id,p_level);
   nm_debug.debug('nxl_record_id : '||pi_rec_nxle.nxl_record_id,p_level);
   nm_debug.debug('nxl_error     : '||pi_rec_nxle.nxl_error,p_level);
   nm_debug.debug('nxl_processed : '||pi_rec_nxle.nxl_processed,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nxle');
--
END debug_nxle;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nwx (pi_rec_nwx nm_nw_xsp%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nwx');
--
   nm_debug.debug('nwx_nw_type       : '||pi_rec_nwx.nwx_nw_type,p_level);
   nm_debug.debug('nwx_x_sect        : '||pi_rec_nwx.nwx_x_sect,p_level);
   nm_debug.debug('nwx_nsc_sub_class : '||pi_rec_nwx.nwx_nsc_sub_class,p_level);
   nm_debug.debug('nwx_descr         : '||pi_rec_nwx.nwx_descr,p_level);
   nm_debug.debug('nwx_seq           : '||pi_rec_nwx.nwx_seq,p_level);
   nm_debug.debug('nwx_offset        : '||pi_rec_nwx.nwx_offset,p_level);
   nm_debug.debug('nwx_date_created  : '||pi_rec_nwx.nwx_date_created,p_level);
   nm_debug.debug('nwx_date_modified : '||pi_rec_nwx.nwx_date_modified,p_level);
   nm_debug.debug('nwx_modified_by   : '||pi_rec_nwx.nwx_modified_by,p_level);
   nm_debug.debug('nwx_created_by    : '||pi_rec_nwx.nwx_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nwx');
--
END debug_nwx;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nxd (pi_rec_nxd nm_x_driving_conditions%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nxd');
--
   nm_debug.debug('nxd_rule_id      : '||pi_rec_nxd.nxd_rule_id,p_level);
   nm_debug.debug('nxd_rule_seq_no  : '||pi_rec_nxd.nxd_rule_seq_no,p_level);
   nm_debug.debug('nxd_rule_type    : '||pi_rec_nxd.nxd_rule_type,p_level);
   nm_debug.debug('nxd_if_condition : '||pi_rec_nxd.nxd_if_condition,p_level);
   nm_debug.debug('nxd_and_or       : '||pi_rec_nxd.nxd_and_or,p_level);
   nm_debug.debug('nxd_st_char      : '||pi_rec_nxd.nxd_st_char,p_level);
   nm_debug.debug('nxd_end_char     : '||pi_rec_nxd.nxd_end_char,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nxd');
--
END debug_nxd;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nxe (pi_rec_nxe nm_x_errors%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nxe');
--
   nm_debug.debug('nxe_id          : '||pi_rec_nxe.nxe_id,p_level);
   nm_debug.debug('nxe_error_text  : '||pi_rec_nxe.nxe_error_text,p_level);
   nm_debug.debug('nxe_error_class : '||pi_rec_nxe.nxe_error_class,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nxe');
--
END debug_nxe;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nxic (pi_rec_nxic nm_x_inv_conditions%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nxic');
--
   nm_debug.debug('nxic_id          : '||pi_rec_nxic.nxic_id,p_level);
   nm_debug.debug('nxic_inv_type    : '||pi_rec_nxic.nxic_inv_type,p_level);
   nm_debug.debug('nxic_inv_attr    : '||pi_rec_nxic.nxic_inv_attr,p_level);
   nm_debug.debug('nxic_condition   : '||pi_rec_nxic.nxic_condition,p_level);
   nm_debug.debug('nxic_value_list  : '||pi_rec_nxic.nxic_value_list,p_level);
   nm_debug.debug('nxic_column_name : '||pi_rec_nxic.nxic_column_name,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nxic');
--
END debug_nxic;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nxl (pi_rec_nxl nm_x_location_rules%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nxl');
--
   nm_debug.debug('nxl_rule_id         : '||pi_rec_nxl.nxl_rule_id,p_level);
   nm_debug.debug('nxl_conditional     : '||pi_rec_nxl.nxl_conditional,p_level);
   nm_debug.debug('nxl_dep_type        : '||pi_rec_nxl.nxl_dep_type,p_level);
   nm_debug.debug('nxl_indep_type      : '||pi_rec_nxl.nxl_indep_type,p_level);
   nm_debug.debug('nxl_dep_condition   : '||pi_rec_nxl.nxl_dep_condition,p_level);
   nm_debug.debug('nxl_indep_condition : '||pi_rec_nxl.nxl_indep_condition,p_level);
   nm_debug.debug('nxl_existence_flag  : '||pi_rec_nxl.nxl_existence_flag,p_level);
   nm_debug.debug('nxl_xsp_match       : '||pi_rec_nxl.nxl_xsp_match,p_level);
   nm_debug.debug('nxl_indep_attr      : '||pi_rec_nxl.nxl_indep_attr,p_level);
   nm_debug.debug('nxl_dep_attr        : '||pi_rec_nxl.nxl_dep_attr,p_level);
   nm_debug.debug('nxl_operator        : '||pi_rec_nxl.nxl_operator,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nxl');
--
END debug_nxl;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nxn (pi_rec_nxn nm_x_nw_rules%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nxn');
--
   nm_debug.debug('nxn_rule_id         : '||pi_rec_nxn.nxn_rule_id,p_level);
   nm_debug.debug('nxn_conditional     : '||pi_rec_nxn.nxn_conditional,p_level);
   nm_debug.debug('nxn_dep_type        : '||pi_rec_nxn.nxn_dep_type,p_level);
   nm_debug.debug('nxn_dep_attr        : '||pi_rec_nxn.nxn_dep_attr,p_level);
   nm_debug.debug('nxn_indep_nw_type   : '||pi_rec_nxn.nxn_indep_nw_type,p_level);
   nm_debug.debug('nxn_dep_condition   : '||pi_rec_nxn.nxn_dep_condition,p_level);
   nm_debug.debug('nxn_indep_condition : '||pi_rec_nxn.nxn_indep_condition,p_level);
   nm_debug.debug('nxn_existence_flag  : '||pi_rec_nxn.nxn_existence_flag,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nxn');
--
END debug_nxn;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nxr (pi_rec_nxr nm_x_rules%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nxr');
--
   nm_debug.debug('nxr_rule_id  : '||pi_rec_nxr.nxr_rule_id,p_level);
   nm_debug.debug('nxr_type     : '||pi_rec_nxr.nxr_type,p_level);
   nm_debug.debug('nxr_error_id : '||pi_rec_nxr.nxr_error_id,p_level);
   nm_debug.debug('nxr_seq_no   : '||pi_rec_nxr.nxr_seq_no,p_level);
   nm_debug.debug('nxr_descr    : '||pi_rec_nxr.nxr_descr,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nxr');
--
END debug_nxr;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nxv (pi_rec_nxv nm_x_val_conditions%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nxv');
--
   nm_debug.debug('nxv_rule_id      : '||pi_rec_nxv.nxv_rule_id,p_level);
   nm_debug.debug('nxv_rule_seq_no  : '||pi_rec_nxv.nxv_rule_seq_no,p_level);
   nm_debug.debug('nxv_rule_type    : '||pi_rec_nxv.nxv_rule_type,p_level);
   nm_debug.debug('nxv_if_condition : '||pi_rec_nxv.nxv_if_condition,p_level);
   nm_debug.debug('nxv_and_or       : '||pi_rec_nxv.nxv_and_or,p_level);
   nm_debug.debug('nxv_st_char      : '||pi_rec_nxv.nxv_st_char,p_level);
   nm_debug.debug('nxv_end_char     : '||pi_rec_nxv.nxv_end_char,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nxv');
--
END debug_nxv;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_xsr (pi_rec_xsr nm_xsp_restraints%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_xsr');
--
   nm_debug.debug('xsr_nw_type       : '||pi_rec_xsr.xsr_nw_type,p_level);
   nm_debug.debug('xsr_ity_inv_code  : '||pi_rec_xsr.xsr_ity_inv_code,p_level);
   nm_debug.debug('xsr_scl_class     : '||pi_rec_xsr.xsr_scl_class,p_level);
   nm_debug.debug('xsr_x_sect_value  : '||pi_rec_xsr.xsr_x_sect_value,p_level);
   nm_debug.debug('xsr_descr         : '||pi_rec_xsr.xsr_descr,p_level);
   nm_debug.debug('xsr_date_created  : '||pi_rec_xsr.xsr_date_created,p_level);
   nm_debug.debug('xsr_date_modified : '||pi_rec_xsr.xsr_date_modified,p_level);
   nm_debug.debug('xsr_modified_by   : '||pi_rec_xsr.xsr_modified_by,p_level);
   nm_debug.debug('xsr_created_by    : '||pi_rec_xsr.xsr_created_by,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_xsr');
--
END debug_xsr;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_xrv (pi_rec_xrv nm_xsp_reversal%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_xrv');
--
   nm_debug.debug('xrv_nw_type         : '||pi_rec_xrv.xrv_nw_type,p_level);
   nm_debug.debug('xrv_old_sub_class   : '||pi_rec_xrv.xrv_old_sub_class,p_level);
   nm_debug.debug('xrv_old_xsp         : '||pi_rec_xrv.xrv_old_xsp,p_level);
   nm_debug.debug('xrv_new_sub_class   : '||pi_rec_xrv.xrv_new_sub_class,p_level);
   nm_debug.debug('xrv_new_xsp         : '||pi_rec_xrv.xrv_new_xsp,p_level);
   nm_debug.debug('xrv_manual_override : '||pi_rec_xrv.xrv_manual_override,p_level);
   nm_debug.debug('xrv_default_xsp     : '||pi_rec_xrv.xrv_default_xsp,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_xrv');
--
END debug_xrv;
--
-----------------------------------------------------------------------------
--
END nm3debug;
/
