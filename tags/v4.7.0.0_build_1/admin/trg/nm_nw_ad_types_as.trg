CREATE OR REPLACE TRIGGER NM_NW_AD_TYPES_AS
AFTER INSERT OR UPDATE
ON NM_NW_AD_TYPES
REFERENCING NEW AS NEW OLD AS OLD
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_nw_ad_types_as.trg	1.2 01/10/05
--       Module Name      : nm_nw_ad_types_as.trg
--       Date into SCCS   : 05/01/10 15:16:21
--       Date fetched Out : 07/06/13 17:03:31
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
DECLARE

BEGIN

nm3nwad.process_table_nwad_types;

END nm_nw_ad_types_as;
/
