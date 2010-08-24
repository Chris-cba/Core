--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4210_fix3_metadata_upg.sql-arc   3.0   Aug 24 2010 14:47:34   Mike.Alexander  $
--       Module Name      : $Workfile:   nm_4210_fix3_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Aug 24 2010 14:47:34  $
--       Date fetched Out : $Modtime:   Aug 24 2010 14:44:04  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--


DELETE FROM hig_navigator_modules WHERE HNM_MODULE_NAME IN  ('NM0510','NM0590') ;

INSERT INTO HIG_NAVIGATOR_MODULES
   (HNM_MODULE_NAME, HNM_MODULE_PARAM, HNM_PRIMARY_MODULE, HNM_SEQUENCE, HNM_TABLE_NAME, 
    HNM_FIELD_NAME, HNM_HIERARCHY_LABEL, HNM_DATE_CREATED, HNM_CREATED_BY, HNM_DATE_MODIFIED, 
    HNM_MODIFIED_BY)
 VALUES
   ('NM0510', 'query_inv_item', 'Y', 1, NULL, 
    NULL, 'Asset', To_Date('02/22/2010 16:53:43', 'MM/DD/YYYY HH24:MI:SS'), 'DORSET', To_Date('02/22/2010 16:53:43', 'MM/DD/YYYY HH24:MI:SS'), 
    'DORSET');
    
INSERT INTO HIG_NAVIGATOR_MODULES
   (HNM_MODULE_NAME, HNM_MODULE_PARAM, HNM_PRIMARY_MODULE, HNM_SEQUENCE, HNM_TABLE_NAME, 
    HNM_FIELD_NAME, HNM_HIERARCHY_LABEL, HNM_DATE_CREATED, HNM_CREATED_BY, HNM_DATE_MODIFIED, 
    HNM_MODIFIED_BY)
 VALUES
   ('NM0590', 'query_inv_item', 'N', 2, NULL, 
    NULL, 'Asset', To_Date('03/30/2010 17:43:05', 'MM/DD/YYYY HH24:MI:SS'), 'DORSET', To_Date('03/30/2010 17:43:05', 'MM/DD/YYYY HH24:MI:SS'), 
    'DORSET');

