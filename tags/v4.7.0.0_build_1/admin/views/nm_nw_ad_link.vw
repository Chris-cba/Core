CREATE OR REPLACE FORCE VIEW nm_nw_ad_link (nad_id,
                                            nad_iit_ne_id,
                                            nad_ne_id,
                                            nad_start_date,
                                            nad_end_date,
                                            nad_nt_type,
                                            nad_gty_type,
                                            nad_inv_type,
                                            nad_primary_ad,
                                            nad_whole_road,
                                            nad_member_id)
AS 
   SELECT
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/nm3/admin/views/nm_nw_ad_link.vw-arc   2.4   Jul 04 2013 11:20:34   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_nw_ad_link.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:34  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:33:42  $
--       PVCS Version     : $Revision:   2.4  $
--       Based on SCCS version : 1.6
--
-----------------------------------------------------------------------------
-- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
          "NAD_ID", "NAD_IIT_NE_ID", "NAD_NE_ID", "NAD_START_DATE",
          "NAD_END_DATE", nad_nt_type, nad_gty_type, nad_inv_type, nad_primary_ad, nad_whole_road, nad_member_id 
     FROM nm_nw_ad_link_all
    WHERE nad_start_date                                        <=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
      AND NVL (nad_end_date, TO_DATE ('99991231', 'YYYYMMDD'))  >   To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
/

