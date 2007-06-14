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
