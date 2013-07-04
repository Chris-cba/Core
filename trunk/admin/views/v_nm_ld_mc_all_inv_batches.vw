CREATE OR REPLACE FORCE VIEW V_NM_LD_MC_ALL_INV_BATCHES(NLB_BATCH_NO
                                                      , NLB_DATE_CREATED
                                                      , NLB_CREATED_BY
                                                      , NLB_FILENAME
                                                      , NLB_NLF_ID
                                                      , NLF_UNIQUE
                                                      , NLF_DESCR
                                                      , NLB_RECORD_COUNT
                                                      , ERROR_COUNT) AS 
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_nm_ld_mc_all_inv_batches.vw	1.2 11/07/03
--       Module Name      : v_nm_ld_mc_all_inv_batches.vw
--       Date into SCCS   : 03/11/07 17:40:41
--       Date fetched Out : 07/06/13 17:08:34
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
SELECT nlb.NLB_BATCH_NO 
      ,nlb.NLB_DATE_CREATED 
      ,nlb.NLB_CREATED_BY 
      ,nlb.NLB_FILENAME 
      ,nlb.NLB_NLF_ID 
      ,nlf.NLF_UNIQUE 
      ,nlf.NLF_DESCR 
      ,nlb.NLB_RECORD_COUNT 
      ,(SELECT COUNT(nlbs1.nlbs_status) 
        FROM   nm_load_batch_status nlbs1 
        WHERE  nlb.nlb_batch_no = nlbs1.nlbs_nlb_batch_no 
        AND    nlbs_status IN ('E','X')
        ) ERROR_COUNT 
FROM nm_load_batches nlb 
    ,nm_load_files   nlf 
WHERE nlf.nlf_id = nlb.nlb_nlf_id 
AND   EXISTS (SELECT 'inventory batch' 
              FROM   nm_ld_mc_all_inv_tmp inv 
	      WHERE  inv.batch_no = nlb.nlb_batch_no)
AND EXISTS (SELECT 1
            FROM nm_load_batch_status nlbs2
            WHERE nlbs2.nlbs_nlb_batch_no = nlb.nlb_batch_no
            AND   nlbs2.nlbs_status IN ('E', 'X', 'H'))
/	      

COMMENT ON TABLE V_NM_LD_MC_ALL_INV_BATCHES IS 'Lists all map capture inventory batches with records in inventory holding table.'
/
