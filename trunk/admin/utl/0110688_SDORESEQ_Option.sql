--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/utl/0110688_SDORESEQ_Option.sql-arc   3.6   Apr 13 2018 12:53:20   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   0110688_SDORESEQ_Option.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 12:53:20  $
--       Date fetched Out : $Modtime:   Apr 13 2018 12:49:46  $
--       PVCS Version     : $Revision:   3.6  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

DELETE hig_option_values WHERE hov_id = 'SDORESEQ';
DELETE hig_option_list WHERE hol_id = 'SDORESEQ';
DELETE hig_codes WHERE hco_domain = 'SDORESEQ';
DELETE hig_domains WHERE hdo_domain = 'SDORESEQ';


INSERT INTO hig_domains
SELECT 'SDORESEQ','HIG','Resequence Shape Options',1 FROM DUAL;

INSERT INTO HIG_CODES
   (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ)
 VALUES
   ('SDORESEQ', 'H', 'Reshape - create new shape', 'Y', 10);
INSERT INTO HIG_CODES
   (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ)
 VALUES
   ('SDORESEQ', 'U', 'Reshape - update with no history', 'Y', 20);
INSERT INTO HIG_CODES
   (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ)
 VALUES
   ('SDORESEQ', 'N', 'Do nothing with the shape', 'Y', 30);

INSERT INTO hig_option_list (hol_id
                            ,hol_product      
                            ,hol_name         
                            ,hol_remarks
                            ,hol_domain
                            ,hol_datatype     
                            ,hol_mixed_case   
                            ,hol_user_option  )
                           -- ,hol_max_length)
SELECT 'SDORESEQ'
     , 'HIG'
     , 'Shape options on resequence'
     , 'When performing a route resequence "H" value (default) will maintain history on the route shapes, "U" value will update shape with no history, "N" value will do nothing with the shape'
     , 'SDORESEQ'
     , 'VARCHAR2'
     , 'N'
     , 'N'
--     , '1'
  FROM dual
  WHERE NOT EXISTS (SELECT 'X' 
                     FROM hig_option_list
                    WHERE HOL_ID = 'SDORESEQ')
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

