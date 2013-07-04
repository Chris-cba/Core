--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3housekeeping.sql	1.2 06/06/06
--       Module Name      : nm3housekeeping.sql
--       Date into SCCS   : 06/06/06 08:56:18
--       Date fetched Out : 07/06/13 17:07:24
--       SCCS Version     : 1.2
--
--   General housekeeping to be ran at any time - but usually called on upgrade
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
--
--
--
-- GJ 30-MAY-2006
-- clear out table populated by gaz query 
truncate table NM_GAZ_QUERY_ITEM_LIST
/


--
-- 
--
DECLARE
 PROCEDURE drop_tab(pi_table_name IN VARCHAR2) IS
 
 BEGIN
 
  FOR i IN (select hus_username from hig_users, all_tables where table_name = pi_table_name and owner = hus_username) LOOP
   BEGIN
     execute immediate ('drop table '||i.hus_username||'.'||pi_table_name||'  cascade constraints');
   END;			 
 END LOOP; 
 
 
 END drop_tab;

BEGIN

 --
 -- Drop tables used by SDE which will be re-created by SDE when users log into SDE
 -- Each user has these tables so drop them for each user
 --
 drop_tab('SDE_LOGFILES');
 drop_tab('SDE_LOGFILE_DATA');
 drop_tab('SDE_EXCEPTIONS');
    
END;
/

