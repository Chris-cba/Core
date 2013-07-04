--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/sql/nm_4054_fix1_synonyms.sql-arc   3.1   Jul 04 2013 09:32:52   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_4054_fix1_synonyms.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:32:52  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:30:22  $
--       PVCS Version     : $Revision:   3.1  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
BEGIN
  nm3ddl.create_synonym_for_object('HIG_USER_CONTACTS_ALL');
  nm3ddl.create_synonym_for_object('HIG_USER_DETAILS_VW');
  nm3ddl.create_synonym_for_object('HIG_USERS_UTILITY');
END;
/
