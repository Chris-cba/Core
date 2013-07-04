CREATE OR REPLACE FORCE VIEW nm_mrg_output_file_v AS
SELECT /*+ INDEX (nmf nmf_nmq_fk_ind) */
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_mrg_output_file_v.vw	1.2 12/03/03
--       Module Name      : nm_mrg_output_file_v.vw
--       Date into SCCS   : 03/12/03 10:02:28
--       Date fetched Out : 07/06/13 17:08:13
--       SCCS Version     : 1.2
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       nmf.*
      ,nmq.nmq_unique
      ,nmq.nmq_descr
 FROM  nm_mrg_query       nmq
      ,nm_mrg_output_file nmf
WHERE  nmf.nmf_nmq_id = nmq.nmq_id
/
