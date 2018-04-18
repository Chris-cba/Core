--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/create_unit_functions.sql-arc   2.2   Apr 18 2018 15:33:36   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   create_unit_functions.sql  $
--       Date into PVCS   : $Date:   Apr 18 2018 15:33:36  $
--       Date fetched Out : $Modtime:   Apr 18 2018 15:32:06  $
--       Version          : $Revision:   2.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
REM SCCS ID Keyword, do no remove
define sccsid = '@(#)create_unit_functions.sql	1.1 03/02/01';

-- create_unit_functions.sql
--
-- This script creates functions to perform unit conversions.
--
-- It uses data from the NM_UNIT_CONVERSIONS table and should therefore only be
-- run after creation of the Highways meta data.

SET heading OFF
SET feedback OFF
set termout off
set lin 10000
set trimspool on

spool t.sql

SELECT
  'prompt Creating function ' || uc_function || '...' || Chr(10) ||
  uc_conversion || Chr(10) || '.' || Chr(10) || '/' || Chr(10)
FROM
  nm_unit_conversions
/

spool OFF

SET heading ON
SET feedback ON
set termout on

prompt

@t

host del t.sql
