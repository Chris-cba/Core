CREATE OR replace force view nm_admin_units AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_admin_units.vw	1.5 10/06/06
--       Module Name      : nm_admin_units.vw
--       Date into SCCS   : 06/10/06 11:43:30
--       Date fetched Out : 07/06/13 17:08:04
--       SCCS Version     : 1.5
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
    nau_admin_unit
   ,nau_unit_code
   ,nau_level
   ,nau_authority_code
   ,nau_name
   ,nau_address1
   ,nau_address2
   ,nau_address3
   ,nau_address4
   ,nau_address5
   ,nau_phone
   ,nau_fax
   ,nau_comments
   ,nau_last_wor_no
   ,nau_start_date
   ,nau_end_date
   ,nau_admin_type
   ,nau_nsty_sub_type
   ,nau_prefix
   ,nau_postcode
   ,nau_minor_undertaker
   ,nau_tcpip
   ,nau_domain
   ,nau_directory
   ,nau_external_name
 FROM  nm_admin_units_all
WHERE  nau_start_date                                   <= To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
 AND   NVL(nau_end_date,TO_DATE('99991231','YYYYMMDD')) >  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
/

