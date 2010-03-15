CREATE OR REPLACE FORCE VIEW V_NM_GAZ_QUERY_ATTRIBS_SAVED
(
  vngqas_ngqa_ngq_id,
  vngqas_ngqa_operator,
  vngqas_ngqa_attrib_name,
  vngqas_ngqa_pre_bracket,
  vngqas_ngqa_condition,
  vngqvs_ngqv_value,
  vngqas_post_bracket
)
AS
    SELECT
    -------------------------------------------------------------------------
    --   PVCS Identifiers :-
    --
    --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_gaz_query_attribs_saved.vw-arc   3.1   Mar 15 2010 11:50:16   cstrettle  $
    --       Module Name      : $Workfile:   v_nm_gaz_query_attribs_saved.vw  $
    --       Date into PVCS   : $Date:   Mar 15 2010 11:50:16  $
    --       Date fetched Out : $Modtime:   Mar 09 2010 17:28:44  $
    --       Version          : $Revision:   3.1  $
    --       Based on SCCS version : 
    -------------------------------------------------------------------------
             ngqas_ngq_id       vngqas_ngqa_ngq_id,
             ngqas_operator     vngqas_ngqa_operator,
             ngqas_attrib_name  vngqas_ngqa_attrib_name,
             ngqas_pre_bracket  vngqas_ngqa_pre_bracket,
             ngqas_condition    vngqas_ngqa_condition,
             ngqvs_value        vngqvs_ngqv_value,
             ngqas_post_bracket vngqas_ngqa_post_bracket
      FROM   nm_gaz_query_attribs_saved
           , nm_gaz_query_values_saved
           , v_nm_gaz_query_saved
     WHERE   ngqas_ngq_id = ngqvs_ngq_id(+) 
       AND   ngqas_ngqt_seq_no = ngqvs_ngqt_seq_no(+) 
       AND   ngqas_seq_no = ngqvs_ngqa_seq_no(+)
       AND   vngqs_ngqs_ngq_id = ngqas_ngq_id
  ORDER BY   ngqvs_ngq_id,
             ngqvs_ngqt_seq_no,
             ngqvs_ngqa_seq_no,
             ngqvs_sequence;
/