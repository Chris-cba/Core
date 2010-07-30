--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4210_fix2_metadata_upg.sql-arc   1.0   Jul 30 2010 10:30:20   aedwards  $
--       Module Name      : $Workfile:   nm_4210_fix2_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 30 2010 10:30:20  $
--       Date fetched Out : $Modtime:   Jul 30 2010 10:29:32  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--

INSERT INTO NM_ERRORS ( NER_APPL
                      , NER_ID
                      , NER_DESCR)
SELECT 'NET'
     , 464
     , 'Update is not allowed. This is not the latest occurrence of the asset.'
     FROM DUAL
     WHERE NOT EXISTS (SELECT 'X' 
                       FROM NM_ERRORS
                       WHERE NER_APPL = 'NET'
                       AND NER_ID = 464)
/


