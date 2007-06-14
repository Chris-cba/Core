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
