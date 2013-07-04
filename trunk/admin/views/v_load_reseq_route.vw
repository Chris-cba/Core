CREATE OR REPLACE FORCE VIEW v_load_reseq_route AS
SELECT
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_load_reseq_route.vw	1.1 12/10/02
--       Module Name      : v_load_reseq_route.vw
--       Date into SCCS   : 02/12/10 13:58:01
--       Date fetched Out : 07/06/13 17:08:31
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Dummy view used to resequence routes from the CSV loader
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
        ne_unique
       ,ne_nt_type
       ,ne_id         ne_id_start
 FROM   nm_elements_all
WHERE   1 = 2
/
