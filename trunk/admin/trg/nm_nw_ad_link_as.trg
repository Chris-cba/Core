CREATE OR REPLACE TRIGGER NM_NW_AD_LINK_AS
AFTER INSERT OR UPDATE
ON NM_NW_AD_LINK_ALL
REFERENCING NEW AS NEW OLD AS OLD
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_nw_ad_link_as.trg-arc   2.2   Jul 04 2013 09:54:08   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_nw_ad_link_as.trg  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:54:08  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:35:32  $
--       SCCS Version     : $Revision:   2.2  $
--       Based on 
--
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
DECLARE
BEGIN
  --MJA add 31-Aug-07
  --New functionality to allow override
  If Not nm3nwad.bypass_nw_ad_link_all
  Then 
    nm3nwad.process_table_nwad_link;
  End If;
END nm_nw_ad_link_as;
/

