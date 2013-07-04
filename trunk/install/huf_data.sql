--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/huf_data.sql-arc   2.1   Jul 04 2013 13:45:32   James.Wadsworth  $
--       Module Name      : $Workfile:   huf_data.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:45:32  $
--       Date fetched Out : $Modtime:   Jul 04 2013 12:02:14  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
-- Extra Meta Data
-- SCCS ID
-- sccs_id = '@(#)huf_data.sql	1.2 09/24/01'
--
INSERT INTO HIG_USER_FAVOURITES ( HUF_USER_ID, HUF_PARENT, HUF_CHILD, HUF_DESCR,
HUF_TYPE ) SELECT
1, 'ROOT', 'FAVOURITES', 'System Administrators Favourite Modules', 'F'
FROM DUAL
where not exists (select 1
                 from HIG_USER_FAVOURITES
                 where HUF_USER_ID =1
                   and HUF_PARENT = 'ROOT'
                   and HUF_CHILD = 'FAVOURITES');
--
--extra nm_errors
--
INSERT INTO NM_ERRORS ( NER_APPL, NER_ID, NER_HER_NO, NER_DESCR ) SELECT
'HIG', 71, NULL, 'Cannot delete another user''s record.'
FROM DUAL
where not exists (select 1
                  from NM_ERRORS
                  where ner_appl = 'HIG'
                    and ner_id = 71);
INSERT INTO NM_ERRORS ( NER_APPL, NER_ID, NER_HER_NO, NER_DESCR ) SELECT
'HIG', 72, NULL, 'Public synonyms not available, you must create private synonyms for this user.'
FROM DUAL
where not exists (select 1
                  from NM_ERRORS
                  where ner_appl = 'HIG'
                    and ner_id = 72);
