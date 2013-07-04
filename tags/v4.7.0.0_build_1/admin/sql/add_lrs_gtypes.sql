-- Create Oracle LRS Gtype lookups
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/sql/add_lrs_gtypes.sql-arc   3.1   Jul 04 2013 09:32:42   James.Wadsworth  $
--       Module Name      : $Workfile:   add_lrs_gtypes.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:32:42  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:25:46  $
--       PVCS Version     : $Revision:   3.1  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--

PROMPT Create Oracle LRS Gtype Lookups

INSERT INTO hig_codes
SELECT 'GEOMETRY_TYPE',
       TO_NUMBER (hco_code) + 300,
       hco_meaning || ' LRS',
       hco_system,
       hco_seq + 7,
       NULL,
       NULL
  FROM hig_codes a
 WHERE hco_domain = 'GEOMETRY_TYPE' 
   AND hco_code LIKE '300%'
   AND NOT EXISTS
     (SELECT 1 FROM hig_codes b
       WHERE TO_NUMBER(b.hco_code) = TO_NUMBER (a.hco_code) + 300
         AND b.hco_domain = 'GEOMETRY_TYPE');

COMMIT;


