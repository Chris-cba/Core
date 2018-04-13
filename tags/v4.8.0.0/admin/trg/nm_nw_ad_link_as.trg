CREATE OR REPLACE TRIGGER NM_NW_AD_LINK_AS
AFTER INSERT OR UPDATE
ON NM_NW_AD_LINK_ALL
REFERENCING NEW AS NEW OLD AS OLD
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_nw_ad_link_as.trg-arc   2.3   Apr 13 2018 11:06:36   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm_nw_ad_link_as.trg  $
--       Date into SCCS   : $Date:   Apr 13 2018 11:06:36  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:00:30  $
--       SCCS Version     : $Revision:   2.3  $
--       Based on 
--
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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

