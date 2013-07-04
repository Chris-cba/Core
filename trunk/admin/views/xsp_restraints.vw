CREATE OR REPLACE FORCE VIEW xsp_restraints
(xsr_nw_type
,xsr_ity_inv_code
,xsr_scl_class
,xsr_x_sect_value
,xsr_descr
,xsr_date_created
,xsr_date_modified
,xsr_modified_by
,xsr_created_by) AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xsp_restraints.vw	1.3 01/25/07
--       Module Name      : xsp_restraints.vw
--       Date into SCCS   : 07/01/25 15:48:11
--       Date fetched Out : 07/06/13 17:08:43
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       xsr_nw_type
      ,xsr_ity_inv_code
      ,xsr_scl_class
      ,xsr_x_sect_value
      ,xsr_descr
      ,xsr_date_created
      ,xsr_date_modified
      ,xsr_modified_by
      ,xsr_created_by
  FROM nm_xsp_restraints
UNION
SELECT nwx_nw_type
      ,'$$'
      ,nwx_nsc_sub_class
      ,nwx_x_sect
      ,nwx_descr
      ,NULL
      ,NULL
      ,NULL
      ,NULL
  FROM nm_xsp
     ;
