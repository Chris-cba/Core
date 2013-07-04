CREATE OR REPLACE FORCE VIEW v_doc_documents
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_doc_documents.vw-arc   2.1   Jul 04 2013 11:20:52   James.Wadsworth  $
--       Module Name      : $Workfile:   v_doc_documents.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:52  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:33:42  $
--       Version          : $Revision:   2.1  $
-------------------------------------------------------------------------
--
(
	doc_id
 ,doc_title
 ,doc_dcl_code
 ,doc_dtp_code
 ,doc_date_expires
 ,doc_date_issued
 ,doc_file
 ,doc_reference_code
 ,doc_issue_number
 ,doc_descr
 ,doc_compl_north
 ,doc_compl_east
 ,scr_initials
 ,scr_media
 ,scr_location
 ,dsp_doc_url
)
AS
	SELECT doc_id
				,doc_title
				,doc_dcl_code
				,doc_dtp_code
				,doc_date_expires
				,doc_date_issued
				,doc_file
				,doc_reference_code
				,doc_issue_number
				,doc_descr
				,doc_compl_north
				,doc_compl_east
				,hus_initials scr_initials
				,dmd_name scr_media
				,dlc_name scr_location
				,nvl2(doc_file
						 ,nvl2(dlc_url_pathname, dlc_url_pathname || doc_file, NULL)
						 ,NULL)
					 dsp_doc_url
		FROM docs
				,hig_users
				,doc_media
				,doc_locations
	 WHERE sysdate BETWEEN nvl(hus_start_date, sysdate)
										 AND nvl(hus_end_date, sysdate)
				 AND hus_user_id(+) = doc_user_id
				 AND dmd_id(+) = doc_dlc_dmd_id
				 AND dlc_id(+) = doc_dlc_id
				 AND EXISTS
							 (SELECT 1
									FROM doc_types
								 WHERE dtp_allow_comments = 'N'
											 AND dtp_allow_complaints = 'N'
											 AND sysdate BETWEEN nvl(dtp_start_date, sysdate)
																			 AND nvl(dtp_end_date, sysdate))
				 AND (doc_compl_east IS NOT NULL
							AND doc_compl_north IS NOT NULL);
