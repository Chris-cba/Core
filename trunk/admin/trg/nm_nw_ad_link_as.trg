CREATE OR REPLACE TRIGGER NM_NW_AD_LINK_AS
AFTER INSERT OR UPDATE
ON NM_NW_AD_LINK_ALL
REFERENCING NEW AS NEW OLD AS OLD
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_nw_ad_link_as.trg	1.3 12/22/04
--       Module Name      : nm_nw_ad_link_as.trg
--       Date into SCCS   : 04/12/22 14:34:49
--       Date fetched Out : 07/06/13 17:03:30
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
DECLARE
BEGIN
   nm3nwad.process_table_nwad_link;
END nm_nw_ad_link_as;
/

