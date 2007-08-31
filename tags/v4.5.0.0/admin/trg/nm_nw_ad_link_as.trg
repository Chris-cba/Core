CREATE OR REPLACE TRIGGER NM_NW_AD_LINK_AS
AFTER INSERT OR UPDATE
ON NM_NW_AD_LINK_ALL
REFERENCING NEW AS NEW OLD AS OLD
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_nw_ad_link_as.trg-arc   2.1   Aug 31 2007 17:22:10   malexander  $
--       Module Name      : $Workfile:   nm_nw_ad_link_as.trg  $
--       Date into SCCS   : $Date:   Aug 31 2007 17:22:10  $
--       Date fetched Out : $Modtime:   Aug 31 2007 16:28:06  $
--       SCCS Version     : $Revision:   2.1  $
--       Based on 
--
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2004
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

