CREATE OR replace force view nm_xsp (nwx_nw_type,
                                     nwx_x_sect,
                                     nwx_nsc_sub_class,
                                     nwx_descr,
                                     nwx_seq,
                                     nwx_offset,
                                     nwx_date_created,
                                     nwx_date_modified,
                                     nwx_modified_by,
                                     nwx_created_by
                                     ) AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_xsp.vw	1.1 03/30/04
--       Module Name      : nm_xsp.vw
--       Date into SCCS   : 04/03/30 09:56:59
--       Date fetched Out : 07/06/13 17:08:22
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       nng.nng_nt_type,
       nwx.nwx_x_sect,
       nsc.nsc_sub_class,
       nwx.nwx_descr,
       nwx.nwx_seq,
       nwx.nwx_offset,
       nwx.nwx_date_created,
       nwx.nwx_date_modified,
       nwx.nwx_modified_by,
       nwx.nwx_created_by
FROM   nm_nw_xsp        nwx
      ,nm_nt_groupings  nng
      ,nm_linear_types  nlt
      ,nm_type_subclass nsc
WHERE  nwx.nwx_nw_type  = nlt.nlt_nt_type
AND    nlt.nlt_gty_type = nng.nng_group_type
AND    nng.nng_nt_type  = nsc.nsc_nw_type (+)
UNION
SELECT * 
FROM   nm_nw_xsp;
