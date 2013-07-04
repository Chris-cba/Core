--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/mig/v2_synonym_removal.sql-arc   2.1   Jul 04 2013 16:49:10   James.Wadsworth  $
--       Module Name      : $Workfile:   v2_synonym_removal.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:49:10  $
--       Date fetched Out : $Modtime:   Jul 04 2013 16:48:52  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
define sccsid = '"@(#)v2_synonym_removal.sql	1.2 12/23/04"'
prompt
prompt Version 2 Highways Owner Synonym Remover Script
prompt Exor Corporation 2004
prompt

set feedback off
Set serverout on size 1000000

declare
cursor what_to_drop is
SELECT 'drop '||decode(owner, 'PUBLIC', 'PUBLIC ', NULL) ||'synonym '||decode(owner, 'PUBLIC', NULL, owner||'.')||synonym_name a
FROM   all_synonyms
WHERE  table_owner = USER
AND    synonym_name NOT LIKE 'V2_%';

l_dropped pls_integer := 0;
begin
  for irec IN what_to_drop LOOP
    execute immediate irec.a;
    l_dropped := l_dropped +1;
  end loop;
  dbms_output.put_line(l_dropped||' Synonyms dropped');
end;
/

Set serverout off
set feedback on
prompt
