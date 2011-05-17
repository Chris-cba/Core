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
--       pvcsid                 : $Header:   //vm_latest/archives/nm3/admin/views/nm_nw_ad_link.vw-arc   2.3   May 17 2011 08:32:44   Steve.Cooper  $
--       Module Name      : $Workfile:   nm_nw_ad_link.vw  $
--       Date into PVCS   : $Date:   May 17 2011 08:32:44  $
--       Date fetched Out : $Modtime:   Mar 31 2011 11:49:08  $
--       PVCS Version     : $Revision:   2.3  $
--       Based on SCCS version : 1.6
--
-----------------------------------------------------------------------------
-- Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
          "NAD_ID", "NAD_IIT_NE_ID", "NAD_NE_ID", "NAD_START_DATE",
          "NAD_END_DATE", nad_nt_type, nad_gty_type, nad_inv_type, nad_primary_ad, nad_whole_road, nad_member_id 
     FROM nm_nw_ad_link_all
    WHERE nad_start_date                                        <=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
      AND NVL (nad_end_date, TO_DATE ('99991231', 'YYYYMMDD'))  >   To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
/

