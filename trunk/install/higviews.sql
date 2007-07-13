REM **************************************************************************
rem	this script creates ALL VIEWS FOR highways core software.
REM 	Currently it is maintained manually and cannot be generated from CASE.
REM **************************************************************************

REM SCCS ID Keyword, do no remove

--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/higviews.sql-arc   2.2   Jul 13 2007 16:29:46   jwadsworth  $
--       Module Name      : $Workfile:   higviews.sql  $
--       Date into SCCS   : $Date:   Jul 13 2007 16:29:46  $
--       Date fetched Out : $Modtime:   Jul 13 2007 15:40:22  $
--       SCCS Version     : $Revision:   2.2  $
--       Based on 
--
rem   ------------------------------------------------------------------------------
rem   Create the road_segments_all view first, to satisfy subsequent references.
rem
rem   This view allows a user to select all road segments owned by their admin unit
rem   (or its subsidiaries) together with road segments owned by the TOP admin unit.
SET doc OFF

REM View needed for new document manager word interface
prompt creating VIEW v_doc_template_users;

CREATE OR REPLACE FORCE VIEW v_doc_template_users AS
SELECT dtu.*,dgt_table_name
FROM
	doc_template_users dtu,
	doc_gateways,
	doc_template_gateways
WHERE
dtu_template_name = dtg_template_name
AND dtg_table_name = dgt_table_name
;

CREATE OR REPLACE FORCE VIEW doc_contact ( dec_hct_id,
dec_doc_id, dec_type, dec_ref, dec_complainant,
dec_contact, hct_id, hct_org_or_person_flag, hct_vip,
hct_title, hct_salutation, hct_first_name, hct_middle_initial,
hct_surname, hct_organisation, hct_home_phone, hct_work_phone,
hct_mobile_phone, hct_fax, hct_pager, hct_email,
hct_occupation, hct_employer, hct_date_of_birth, hct_start_date,
hct_end_date, hct_notes, hca_hct_id, hca_had_id,
had_id, had_department, had_po_box, had_organisation,
had_sub_building_name_no, had_building_name, had_building_no, had_dependent_thoroughfare,
had_thoroughfare, had_double_dep_locality_name, had_dependent_locality_name, had_post_town,
had_county, had_postcode, had_notes, had_xco,
had_yco, had_osapr, had_property_type ) AS SELECT
dec_hct_id
,dec_doc_id
,dec_type
,dec_ref
,dec_complainant
,dec_contact
,hct_id
,hct_org_or_person_flag
,hct_vip
,hct_title
,hct_salutation
,hct_first_name
,hct_middle_initial
,hct_surname
,hct_organisation
,hct_home_phone
,hct_work_phone
,hct_mobile_phone
,hct_fax
,hct_pager
,hct_email
,hct_occupation
,hct_employer
,hct_date_of_birth
,hct_start_date
,hct_end_date
,hct_notes
,hca_hct_id
,hca_had_id
,had_id
,had_department
,had_po_box
,had_organisation
,had_sub_building_name_no
,had_building_name
,had_building_no
,had_dependent_thoroughfare
,had_thoroughfare
,had_double_dep_locality_name
,had_dependent_locality_name
,had_post_town
,had_county
,had_postcode
,had_notes
,had_xco
,had_yco
,had_osapr
,had_property_type
FROM   doc_enquiry_contacts, hig_contacts, hig_contact_address, hig_address
WHERE  dec_hct_id = hct_id
AND    hct_id = hca_hct_id(+)
AND    hca_had_id = had_id(+)
/


CREATE OR REPLACE FORCE VIEW doc_contact_address ( hct_id,
hct_org_or_person_flag, hct_vip, hct_title, hct_salutation,
hct_first_name, hct_middle_initial, hct_surname, hct_organisation,
hct_home_phone, hct_work_phone, hct_mobile_phone, hct_fax,
hct_pager, hct_email, hct_occupation, hct_employer,
hct_date_of_birth, hct_start_date, hct_end_date, hct_notes,
hca_hct_id, hca_had_id, had_id, had_department,
had_po_box, had_organisation, had_sub_building_name_no, had_building_name,
had_building_no, had_dependent_thoroughfare, had_thoroughfare, had_double_dep_locality_name,
had_dependent_locality_name, had_post_town, had_county, had_postcode,
had_notes, had_xco, had_yco, had_osapr, had_property_type
 ) AS SELECT
hct_id
,hct_org_or_person_flag
,hct_vip
,hct_title
,hct_salutation
,hct_first_name
,hct_middle_initial
,hct_surname
,hct_organisation
,hct_home_phone
,hct_work_phone
,hct_mobile_phone
,hct_fax
,hct_pager
,hct_email
,hct_occupation
,hct_employer
,hct_date_of_birth
,hct_start_date
,hct_end_date
,hct_notes
,hca_hct_id
,hca_had_id
,had_id
,had_department
,had_po_box
,had_organisation
,had_sub_building_name_no
,had_building_name
,had_building_no
,had_dependent_thoroughfare
,had_thoroughfare
,had_double_dep_locality_name
,had_dependent_locality_name
,had_post_town
,had_county
,had_postcode
,had_notes
,had_xco
,had_yco
,had_osapr
,had_property_type
FROM   hig_contacts, hig_contact_address, hig_address
WHERE  hct_id = hca_hct_id (+)
AND    hca_had_id = had_id (+)
/

prompt creating VIEW docs2view

CREATE OR REPLACE FORCE VIEW docs2view ( doc_id, doc_title,
doc_dcl_code, doc_dtp_code, doc_date_expires,
doc_date_issued, doc_file, doc_reference_code,
doc_issue_number, doc_dlc_id, doc_dlc_dmd_id,
doc_descr, doc_user_id, doc_category, doc_admin_unit,
doc_status_code, doc_status_date, doc_reason,
doc_compl_type, doc_compl_source, doc_compl_ack_flag,
doc_compl_ack_date, doc_compl_flag, doc_compl_cpr_id,
doc_compl_user_id, doc_compl_peo_date, doc_compl_target,
doc_compl_referred_to, doc_compl_location, doc_compl_name,
doc_compl_address1, doc_compl_address2, doc_compl_address3,
doc_compl_address4, doc_compl_address5, doc_compl_phone,
doc_compl_remarks, doc_compl_action, doc_compl_complete, doc_compl_title,
doc_compl_postcode, doc_compl_phone2, doc_compl_phone3,
doc_compl_from, doc_compl_to, doc_compl_claim,
doc_compl_east, doc_compl_north )
AS SELECT DISTINCT doc_id
,doc_title
,doc_dcl_code
,doc_dtp_code
,doc_date_expires
,doc_date_issued
,doc_file
,doc_reference_code
,doc_issue_number
,doc_dlc_id
,doc_dlc_dmd_id
,doc_descr
,doc_user_id
,doc_category
,doc_admin_unit
,doc_status_code
,doc_status_date
,doc_reason
,doc_compl_type
,doc_compl_source
,doc_compl_ack_flag
,doc_compl_ack_date
,doc_compl_flag
,doc_compl_cpr_id
,doc_compl_user_id
,doc_compl_peo_date
,doc_compl_target
,doc_compl_referred_to
,doc_compl_location
,RTRIM(hct_first_name)||' '||hct_surname
,had_thoroughfare
,had_dependent_locality_name
,had_double_dep_locality_name
,had_post_town
,had_county
,hct_home_phone
,doc_compl_remarks
,doc_compl_action
,doc_compl_complete
,hct_title
,had_postcode
,hct_work_phone
,hct_mobile_phone
,doc_compl_from
,doc_compl_to
,doc_compl_claim
,doc_compl_east
,doc_compl_north
from   HIG_ADDRESS, HIG_CONTACT_ADDRESS, HIG_CONTACTS,DOC_ENQUIRY_CONTACTS, DOCS, DOC_TYPES
WHERE hca_had_id = had_id (+)
and    hct_id = hca_hct_id (+)
and    dec_hct_id = hct_id (+)
and    dec_contact (+) = 'Y'
and    doc_id = dec_doc_id (+)
and    doc_dtp_code = dtp_code
and    dtp_allow_complaints = 'Y'
/

prompt creating VIEW network_node
CREATE OR REPLACE FORCE VIEW network_node
(
     rse_he_id
    ,rse_unique
    ,rse_descr
    ,rse_admin_unit
    ,rse_sys_flag
    ,rse_length
    ,st_chain
    ,end_chain
)
AS SELECT
     /*+ FIRST_ROWS STAR */
       rse_he_id
     , rse_unique
     , rse_descr
     , rse_admin_unit
     , rse_sys_flag
     , rse_length
     , nou1.nou_chainage st_chain
     , nou2.nou_chainage end_chain
   FROM road_sections,
        node_usages nou1,
        node_usages nou2
  WHERE rse_he_id = nou1.nou_rse_he_id (+)
    AND rse_he_id = nou2.nou_rse_he_id (+)
    AND rse_pus_node_id_st = nou1.nou_pus_node_id (+)
    AND rse_pus_node_id_end = nou2.nou_pus_node_id (+)
    AND nou1.nou_node_type (+) = 'S' AND nou2.nou_node_type (+) = 'E'
/
--
COMMENT ON TABLE network_node
    IS ' - Retrofitted';


rem
REM End of command file
rem
