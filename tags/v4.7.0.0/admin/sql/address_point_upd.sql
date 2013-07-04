REM **************************************************************************
REM	This script used to transfer address point data from hig_address_point
REM 	to hig_address. Now it just strips out the spaces in the POSTCODES.
REM **************************************************************************
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)address_point_upd.sql	1.1 04/26/06
--       Module Name      : address_point_upd.sql
--       Date into SCCS   : 06/04/26 12:57:37
--       Date fetched Out : 07/06/13 17:02:04
--       SCCS Version     : 1.1
--
--
--   Author : %USERNAME%
--
--    %YourObjectname%
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

update hig_address_point hap1
set hdp_postcode = 
  (select translate(hdp_postcode,'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ','ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')
  from hig_address_point hap2
  where hap1.hdp_osapr = hap2.hdp_osapr)
/

