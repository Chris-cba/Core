--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/0110688_SDORESEQ_Option.sql-arc   3.0   Feb 09 2011 10:01:06   Ade.Edwards  $
--       Module Name      : $Workfile:   0110688_SDORESEQ_Option.sql  $
--       Date into PVCS   : $Date:   Feb 09 2011 10:01:06  $
--       Date fetched Out : $Modtime:   Feb 09 2011 09:44:46  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--

INSERT INTO hig_option_list (hol_id
                            ,hol_product      
                            ,hol_name         
                            ,hol_remarks
                            ,hol_datatype     
                            ,hol_mixed_case   
                            ,hol_user_option  
                            ,hol_max_length)
SELECT 'SDORESEQ'
     , 'HIG'
     , 'Shape options on resequence'
     , 'When performing a route resequence "H" value (default) will maintain history on the route shapes, "U" value will update shape with no history, "N" value will do nothing with the shape'
     , 'VARCHAR2'
     , 'N'
     , 'N'
     , '1'
  FROM dual
  WHERE NOT EXISTS (SELECT 'X' 
                     FROM hig_option_list
                    WHERE HOL_ID = 'USEHISTRSQ')
/

INSERT INTO hig_option_values ( hov_id
                              , hov_value)
SELECT 'SDORESEQ'
     , 'H'
  FROM dual
WHERE NOT EXISTS (SELECT 'X' 
                     FROM hig_option_values
                    WHERE hov_id = 'Y')
/

