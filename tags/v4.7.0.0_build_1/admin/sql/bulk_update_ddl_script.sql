CREATE OR REPLACE TYPE nm_ne_id_type AS OBJECT(ne_id NUMBER)
/
 
CREATE OR REPLACE TYPE nm_ne_id_array IS TABLE OF nm_ne_id_type 
/


CREATE OR REPLACE FORCE VIEW nm_elements_view_vw (
nev_ne_id,
nev_ne_unique ,
nev_ne_descr,
nev_ne_type,
nev_ne_nt_type ,
nev_admin_unit_descr ,
nev_ne_start_date ,
nev_ne_gty_group_type,
nev_ne_admin_unit
)
AS
SELECT 
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/sql/bulk_update_ddl_script.sql-arc   3.4   Jul 04 2013 09:32:42   James.Wadsworth  $
--       Module Name      : $Workfile:   bulk_update_ddl_script.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:32:42  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:27:20  $
--       Version          : $Revision:   3.4  $
--       Based on SCCS version : 
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
ne_id
      ,ne_unique 
      ,ne_descr
      ,ne_type
      ,ne_nt_type 
      ,nau_unit_code ||' - '||nau_name
      ,ne_start_date 
      ,ne_gty_group_type
      ,ne_admin_unit
FROM   nm_elements ne
      ,nm_admin_units nau
WHERE  ne.ne_admin_unit = nau.nau_admin_unit
/

DECLARE
--
   l_sql VARCHAR2(4000);
--
BEGIN
--
   l_sql := 'CREATE OR REPLACE FORCE VIEW nm_attrib_view_vw ( '||
            ' nav_disp_ord, '||
            ' nav_nt_type , '|| 
            ' nav_inv_type, '||
            ' nav_col_name, '||
            ' nav_col_type , '||
            ' nav_col_length , '||
            ' nav_col_mandatory , '||
            ' nav_col_domain, '||
            ' nav_col_updatable, '||
            ' nav_col_prompt, '||
            ' nav_col_format, '||
            ' nav_col_seq_no, '||
            ' nav_gty_type , '||
            ' nav_parent_type_inc, '||
            ' nav_child_type_inc '||
            ' ) '||
            ' AS '||
            ' SELECT '||
            ' -- '||Chr(10)||
            ' -- '||Chr(10)||
            ' ------------------------------------------------------------------------- '||Chr(10)||
            ' --   PVCS Identifiers :- '||Chr(10)||
            ' -- '||Chr(10)||
            ' --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/sql/bulk_update_ddl_script.sql-arc   3.4   Jul 04 2013 09:32:42   James.Wadsworth  $ '||Chr(10)||
            ' --       Module Name      : $Workfile:   bulk_update_ddl_script.sql  $ '||Chr(10)||
            ' --       Date into PVCS   : $Date:   Jul 04 2013 09:32:42  $ '||Chr(10)||
            ' --       Date fetched Out : $Modtime:   Jul 04 2013 09:27:20  $ '||Chr(10)||
            ' --       Version          : $Revision:   3.4  $ '||Chr(10)||
            ' --       Based on SCCS version :  '||Chr(10)||
            ' ------------------------------------------------------------------------- '||Chr(10)||
            ' --  '||Chr(10)||
            '        1 disp_ord, '||
            '        ntc_nt_type , '||
            '        Null , '||
            '        ntc_column_name , '||
            '        ntc_column_type , '||
            '        ntc_str_length , '||
            '        ntc_mandatory , '||
            '        ntc_domain, '||
            '        nm3_bulk_attrib_upd.check_col_upd(ntc_column_name,ntc_nt_type), '||
            '        ntc_prompt, '||
            '        ntc_format, '||
            '        ntc_seq_no, '||
            '        Null, '||
            '        nm3_bulk_attrib_upd.parent_inclusion_type(ntc_column_name,ntc_nt_type) parent_type_inc, '||
            '        nm3_bulk_attrib_upd.child_inclusion_type(ntc_column_name,ntc_nt_type)  child_type_inc '||
            ' FROM   nm_type_columns ntc '||
            ' union '||
            ' select 2 disp_ord, '||
            '        ita_inv_type, '||
            '        nad_nt_type , '||
            '        ita_attrib_name, '||
            '        ita_format, '||
            '        ita_fld_length, '||
            '        ita_mandatory_yn, '||
            '        ita_id_domain,''Y'' , '||
            '        ita_scrn_text, '||
            '        ita_format, '||
            '        ita_disp_seq_no  , '||
            '        nad_gty_type   , '||
            '        Null , '||
            '        Null '||
            ' FROM   nm_inv_type_attribs ita,nm_nw_ad_types nad '||
            ' WHERE  ita.ita_inv_type =  nad.nad_inv_type '||
            ' AND    nad_primary_ad   = ''Y'' ' ;
   Execute Immediate l_sql;
EXCEPTION
   When Others THEN
   NUll;
END ;
/

INSERT INTO nm_errors
SELECT 'NET'
      , 460
      , NULL
      , 'This selected Group Type is Exclusive. The selected Network Elements will be End Dated from existing Groups of this type. Do you wish to continue?'
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'NET'
       AND ner_id = 460);

       
INSERT INTO nm_errors
SELECT 'NET'
      , 461
      , NULL
      , 'One or more of the selected Network Elements are already members of a Group of this type. Do you want to End Date existing Group Memberships for affected Elements?'
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'NET'
       AND ner_id = 461);       

INSERT INTO HIG_MODULES
       (HMO_MODULE
       ,HMO_TITLE
       ,HMO_FILENAME
       ,HMO_MODULE_TYPE
       ,HMO_FASTPATH_OPTS
       ,HMO_FASTPATH_INVALID
       ,HMO_USE_GRI
       ,HMO_APPLICATION
       ,HMO_MENU
       )
SELECT 
        'NM0116'
       ,'Bulk Network Update'
       ,'nm0116'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0116');
                   
--

INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NET_MANAGEMENT'
       ,'NM0116'
       ,'Bulk Network Update'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NET_MANAGEMENT'
                    AND  HSTF_CHILD  = 'NM0116');
                    
--

INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE,HMR_MODE
       )
SELECT 
        'NM0116'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0116'
                    AND  HMR_ROLE = 'NET_ADMIN');

                    
--
