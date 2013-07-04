CREATE OR REPLACE FORCE VIEW NM_MRG_QUERY_TYPES AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_mrg_query_types.vw	1.3 02/28/03
--       Module Name      : nm_mrg_query_types.vw
--       Date into SCCS   : 03/02/28 09:47:20
--       Date fetched Out : 07/06/13 17:08:16
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
        /*+ INDEX (nit ity_pk, nmqt nmqt_pk) */ nmqt.*
 FROM   NM_MRG_QUERY_TYPES_ALL nmqt
WHERE EXISTS (SELECT 1 
              FROM  NM_INV_TYPES           nit
              WHERE   nmqt.nqt_inv_type = nit.nit_inv_type)                         
WITH CHECK OPTION
/
