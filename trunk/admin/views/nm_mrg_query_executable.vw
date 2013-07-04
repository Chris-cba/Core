CREATE OR REPLACE FORCE VIEW nm_mrg_query_executable AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_mrg_query_executable.vw	1.2 12/19/02
--       Module Name      : nm_mrg_query_executable.vw
--       Date into SCCS   : 02/12/19 11:09:01
--       Date fetched Out : 07/06/13 17:08:14
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
        nmq.*
 FROM   nm_mrg_query nmq
WHERE NOT EXISTS (SELECT /*+ INDEX (nqta nqt_pk) */ 1
                   FROM  nm_mrg_query_types_all nqta
                  WHERE  nqta.nqt_nmq_id = nmq.nmq_id
                   AND   NOT EXISTS (SELECT 1
                                      FROM  nm_mrg_query_types nqt
                                     WHERE  nqt.nqt_nmq_id = nqta.nqt_nmq_id
                                      AND   nqt.nqt_seq_no = nqta.nqt_seq_no
                                    )
                 )
WITH READ ONLY
/
