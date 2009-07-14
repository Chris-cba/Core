------------------------------------------------------------------
-- nm4054_nm4100_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4054_nm4100_metadata_upg.sql-arc   3.0   Jul 14 2009 10:27:18   aedwards  $
--       Module Name      : $Workfile:   nm4054_nm4100_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 14 2009 10:27:18  $
--       Date fetched Out : $Modtime:   Jul 14 2009 09:32:42  $
--       Version          : $Revision:   3.0  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF

DECLARE
  l_temp nm3type.max_varchar2;
BEGIN
  -- Dummy call to HIG to instantiate it
  l_temp := hig.get_version;
  l_temp := nm_debug.get_version;
EXCEPTION
  WHEN others
   THEN
 Null;
END;
/

BEGIN
  nm_debug.debug_off;
END;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT GAZAUTOQRY Product Option
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED PROBLEM MANAGER LOG#
-- 719701  Main Roads Western Australia
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- This Product option allows you to choose if you want form nm1100 to automatically query back its results
-- 
------------------------------------------------------------------
INSERT INTO hig_option_list
(
   hol_id, hol_product, hol_name, hol_remarks, hol_domain, hol_datatype, hol_mixed_case, hol_user_option
)
  SELECT 'GAZAUTOQRY',
         'HIG',
         'Gazetteer Results Auto Query',
         'This must be a Y or N. If the option is set to Y the data will automatically populate the results block in the Gazetteer when you click/tab into it.',
         'Y_OR_N',
         'VARCHAR2',
         'N',
         'Y'
  FROM DUAL
  WHERE NOT EXISTS (SELECT 'X'
                    FROM hig_option_list
                    WHERE hol_id = 'GAZAUTOQRY');

INSERT INTO hig_option_values
(
   hov_id, hov_value
)
  SELECT 'GAZAUTOQRY', 'Y'
  FROM DUAL
  WHERE NOT EXISTS (SELECT 'X'
                    FROM hig_option_values
                    WHERE hov_id = 'GAZAUTOQRY');
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Hig Options for Exclusive Group Type
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- New Hig Options added to allows user to override exclusive group type
-- 
------------------------------------------------------------------
--
INSERT into HIG_OPTIONS (
HOP_PRODUCT
,HOP_ID
,HOP_NAME
,HOP_VALUE
,HOP_REMARKS
) select
'NET'
,'GRPXCLOVWR'
,'Exclusive Group type Override'
,'N'
,'When value is set to ''Y'' this will allow user to override the Exclusive Group Type.'
from dual
where not exists (
 select 'not exists'
 from HIG_OPTIONS
where HOP_ID = 'GRPXCLOVWR'
and HOP_PRODUCT = 'NET'
);
--

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Bulk Attribute Update
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- New Error messages for bulk attribute update
-- 
------------------------------------------------------------------
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

                    
     


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Metadata update for WEEKEND product option
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED PROBLEM MANAGER LOG#
-- 711146  Gloucestershire County Council
-- 
-- 
-- DEVELOPMENT COMMENTS (STUART MARSHALL)
-- **** COMMENTS TO BE ADDED BY STUART MARSHALL ****
-- 
------------------------------------------------------------------
update hig_option_list
set hol_remarks = 'This option must contain a list of numeric values in the range 1 to 7.
They define the days of the week which constitute the weekend in a particular country, for use in working day calculations.  The following convention must be adopted:
7=Sunday 2=Monday ... 6=Saturday.
Therefore in the UK this option will contain the value 6,7
In the Inspection Loader (MAI2200), when repairs are loaded a repair due date calculation takes place. This may be based on working days or calendar days as indicated by the defect priority rules.
In Maintain Defects (MAI3806) a similar calculation takes place when a repair is created.'
where HOL_ID = 'WEEKEND'
and HOL_PRODUCT = 'HIG';

update hig_option_values
set hov_value = '6, 7'
where hov_id = 'WEEKEND';

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Grant Create Job to highways owner
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Add privs to create a scheduled job to Highways owner
-- 
------------------------------------------------------------------
grant create job to user;
grant execute on DBMS_SCHEDULER to user;
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Create maintenance jobs
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- **** COMMENTS TO BE ADDED BY ADRIAN EDWARDS ****
-- 
------------------------------------------------------------------
--
BEGIN
  nm3jobs.create_job
              ( pi_job_name   => 'CLEAROUT_GDO_DATA'
              , pi_job_action => 'BEGIN nm3data.cleardown_gdo; END;'
              , pi_comments   => 'Created by nm3jobs at '||SYSDATE );
--
  nm3jobs.create_job
              ( pi_job_name   => 'CLEAROUT_NGQI_DATA'
              , pi_job_action => 'BEGIN nm3data.cleardown_ngqi; END;'
              , pi_comments   => 'Created by nm3jobs at '||SYSDATE );
--
  nm3jobs.create_job
              ( pi_job_name   => 'CLEAROUT_ND_DATA'
              , pi_job_action => 'BEGIN nm3data.cleardown_nd; END;'
              , pi_comments   => 'Created by nm3jobs at '||SYSDATE );
END;
/
------------------------------------------------------------------


------------------------------------------------------------------

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

