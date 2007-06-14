CREATE OR REPLACE FORCE VIEW nm_nw_ad_link (nad_id,
                                      nad_iit_ne_id,
                                      nad_ne_id,
                                      nad_start_date,
                                      nad_end_date,
									  nad_nt_type,
									  nad_gty_type,
									  nad_inv_type,
									  nad_primary_ad									  								  
                                     )
AS 
   SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_nw_ad_link.vw	1.6 05/15/06
--       Module Name      : nm_nw_ad_link.vw
--       Date into SCCS   : 06/05/15 11:46:00
--       Date fetched Out : 07/06/13 17:08:20
--       SCCS Version     : 1.6
--
-----------------------------------------------------------------------------
-- Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
          "NAD_ID", "NAD_IIT_NE_ID", "NAD_NE_ID", "NAD_START_DATE",
          "NAD_END_DATE", nad_nt_type, nad_gty_type, nad_inv_type, nad_primary_ad
     FROM nm_nw_ad_link_all
    WHERE nad_start_date <= (select nm3context.get_effective_date from dual)
      AND NVL (nad_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >
                                                 (select nm3context.get_effective_date from dual);
