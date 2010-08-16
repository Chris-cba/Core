--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4210_fix2_metadata_upg.sql-arc   1.1   Aug 16 2010 16:13:42   Chris.Strettle  $
--       Module Name      : $Workfile:   nm_4210_fix2_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Aug 16 2010 16:13:42  $
--       Date fetched Out : $Modtime:   Aug 16 2010 16:10:52  $
--       PVCS Version     : $Revision:   1.1  $
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

INSERT INTO hig_option_list (hol_id
                            ,hol_product      
                            ,hol_name         
                            ,hol_remarks      
                            ,hol_datatype     
                            ,hol_domain
                            ,hol_mixed_case   
                            ,hol_user_option  
                            ,hol_max_length)
SELECT 'EDITENDDAT'
     , 'NET'
     , 'Allow Latest Asset Edit'
     , 'If set to Y the user will be allowed to edit the latest asset even if the effective date is not today. When it is set to N then the effective date will need to be set to today for edits to take place.'
     , 'VARCHAR2'
     , 'Y_OR_N'
     , 'N'
     , 'N'
     , '1'
  FROM dual
  WHERE NOT EXISTS (SELECT 'X' 
                     FROM hig_option_list
                    WHERE HOL_ID = 'EDITENDDAT')
/

INSERT INTO hig_option_values ( hov_id
                              , hov_value)
SELECT 'EDITENDDAT'
     , 'Y'
  FROM dual
 WHERE NOT EXISTS (SELECT 'X' 
                     FROM hig_option_values
                    WHERE hov_id = 'EDITENDDAT')
/
