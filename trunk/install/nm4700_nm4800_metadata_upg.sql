------------------------------------------------------------------
-- nm4700_nm4800_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm4700_nm4800_metadata_upg.sql-arc   1.2   Apr 24 2019 13:51:12   Chris.Baugh  $
--       Module Name      : $Workfile:   nm4700_nm4800_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Apr 24 2019 13:51:12  $
--       Date fetched Out : $Modtime:   Apr 24 2019 13:47:22  $
--       Version          : $Revision:   1.2  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2014

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
SET TERM ON
PROMPT WMS Themes
SET TERM OFF
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_WMS_THEMES'
       ,'NWT_ID'
       ,'NWT_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_WMS_THEMES'
                    AND  HSA_COLUMN_NAME = 'NWT_ID');

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
        'GIS0030'
       ,'GIS WMS Themes'
       ,'gis0030'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'GIS0030');

INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_GIS'
       ,'GIS0030'
       ,'GIS WMS Themes'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_GIS'
                    AND  HSTF_CHILD = 'GIS0030');

INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GIS0030'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GIS0030'
                    AND  HMR_ROLE = 'HIG_ADMIN');
------------------------------------------------------------------
SET TERM ON
PROMPT New Product Option NODETOL
SET TERM OFF
INSERT INTO HIG_OPTION_LIST 
           (HOL_ID,
            HOL_PRODUCT,
            HOL_NAME,
            HOL_REMARKS,
            HOL_DOMAIN,
            HOL_DATATYPE,
            HOL_MIXED_CASE,
            HOL_USER_OPTION,
            HOL_MAX_LENGTH
            )
SELECT 'NODETOL'
      ,'NET'
      ,'Node Tolerance Distance'
      ,'Defines the distance from a route Offset to search for nodes'
      ,NULL
      ,'NUMBER'
      ,'N'
      ,'N'
      ,2000
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'NODETOL'
                 )
/
--
INSERT INTO HIG_OPTION_VALUES
           (HOV_ID, 
            HOV_VALUE
           )  
SELECT 'NODETOL'
      ,'5'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'NODETOL'
                 )
/
------------------------------------------------------------------
SET TERM ON
PROMPT New Product Option SDOMINPROJ
SET TERM OFF
INSERT INTO HIG_OPTION_LIST 
           (HOL_ID,
            HOL_PRODUCT,
            HOL_NAME,
            HOL_REMARKS,
            HOL_DOMAIN,
            HOL_DATATYPE,
            HOL_MIXED_CASE,
            HOL_USER_OPTION,
            HOL_MAX_LENGTH
            )
SELECT 'SDOMINPROJ'
      ,'NET'
      ,'Minimum Projection Distance'
      ,'The minimum measured length of a datum which may result from a split at the projection of a node onto the element geometry'
      ,NULL
      ,'NUMBER'
      ,'N'
      ,'N'
      ,2000
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SDOMINPROJ'
                 )
/
--
INSERT INTO HIG_OPTION_VALUES
           (HOV_ID, 
            HOV_VALUE
           )  
SELECT 'SDOMINPROJ'
      ,'0.5'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'SDOMINPROJ'
                 )
/
------------------------------------------------------------------
SET TERM ON
PROMPT New Product Option SDOPROXTOL
SET TERM OFF
INSERT INTO HIG_OPTION_LIST 
           (HOL_ID,
            HOL_PRODUCT,
            HOL_NAME,
            HOL_REMARKS,
            HOL_DOMAIN,
            HOL_DATATYPE,
            HOL_MIXED_CASE,
            HOL_USER_OPTION,
            HOL_MAX_LENGTH
            )
SELECT 'SDOPROXTOL'
      ,'NET'
      ,'Proximity Buffer'
      ,'Defines distance buffer (in Metres) from a selected network element, to check for nodes that can be used for network split operations'
      ,NULL
      ,'NUMBER'
      ,'N'
      ,'N'
      ,2000
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SDOPROXTOL'
                 )
/
--
INSERT INTO HIG_OPTION_VALUES
           (HOV_ID, 
            HOV_VALUE
           )  
SELECT 'SDOPROXTOL'
      ,'50'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'SDOPROXTOL'
                 )
/
------------------------------------------------------------------
SET TERM ON
PROMPT Updated Error Messages
SET TERM OFF
UPDATE nm_errors
SET ner_descr = 'Position coincides with node(s). Do you wish to split at a node?'
WHERE ner_appl = 'NET'
AND ner_id = 360
/
UPDATE nm_errors
   SET ner_descr =
          'User does not have permission or access to all assets on the element'
 WHERE ner_id = 172 AND ner_appl = 'NET'
/
------------------------------------------------------------------
SET TERM ON
PROMPT New Java Shape Tool Product options
SET TERM OFF
INSERT INTO HIG_OPTION_LIST 
           (HOL_ID,
            HOL_PRODUCT,
            HOL_NAME,
            HOL_REMARKS,
            HOL_DOMAIN,
            HOL_DATATYPE,
            HOL_MIXED_CASE,
            HOL_USER_OPTION,
            HOL_MAX_LENGTH
            )
SELECT 'SHPJAVASRV'
      ,'HIG'
      ,'Java Shape Tool SDE Server'
      ,'Server on which SDE is running, used by the Java Shape Tool'
      ,NULL
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,2000
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SHPJAVASRV'
                 )
/
--
INSERT INTO HIG_OPTION_LIST 
           (HOL_ID,
            HOL_PRODUCT,
            HOL_NAME,
            HOL_REMARKS,
            HOL_DOMAIN,
            HOL_DATATYPE,
            HOL_MIXED_CASE,
            HOL_USER_OPTION,
            HOL_MAX_LENGTH
            )
SELECT 'SHPJAVADB'
      ,'HIG'
      ,'Java Shape Tool SID'
      ,'Database SID used by Java Shape Tool'
      ,NULL
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,2000
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SHPJAVADB'
                 )
/
--
INSERT INTO HIG_OPTION_LIST 
           (HOL_ID,
            HOL_PRODUCT,
            HOL_NAME,
            HOL_REMARKS,
            HOL_DOMAIN,
            HOL_DATATYPE,
            HOL_MIXED_CASE,
            HOL_USER_OPTION,
            HOL_MAX_LENGTH
            )
SELECT 'SHPJAVABIN'
      ,'HIG'
      ,'Java Shape Tool bin directory'
      ,'Directory where Java Shape Tool executables are located on the database server'
      ,NULL
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,2000
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SHPJAVABIN'
                 )
/
--
INSERT INTO HIG_OPTION_LIST 
           (HOL_ID,
            HOL_PRODUCT,
            HOL_NAME,
            HOL_REMARKS,
            HOL_DOMAIN,
            HOL_DATATYPE,
            HOL_MIXED_CASE,
            HOL_USER_OPTION,
            HOL_MAX_LENGTH
            )
SELECT 'SHPJAVAPRT'
      ,'HIG'
      ,'Java Shape Tool Port No.'
      ,'Port Number used by Java Shape Tool'
      ,NULL
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,2000
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SHPJAVAPRT'
                 )
/
--
INSERT INTO HIG_OPTION_LIST 
           (HOL_ID,
            HOL_PRODUCT,
            HOL_NAME,
            HOL_REMARKS,
            HOL_DOMAIN,
            HOL_DATATYPE,
            HOL_MIXED_CASE,
            HOL_USER_OPTION,
            HOL_MAX_LENGTH
            )
SELECT 'SHPJAVARTE'
      ,'HIG'
      ,'Route Type'
      ,'Route Type on which the Meterialized views used in shapefile production are based'
      ,NULL
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,2000
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SHPJAVARTE'
                 )
/
--
INSERT INTO HIG_OPTION_VALUES           (HOV_ID,            HOV_VALUE           )  SELECT 'SHPJAVARTE'      ,'SECT'FROM DUALWHERE NOT EXISTS (SELECT 1                    FROM HIG_OPTION_VALUES                   WHERE HOV_ID = 'SHPJAVARTE'                 )/

------------------------------------------------------------------
SET TERM ON
PROMPT New Process Type details for Materialized view refreshes
SET TERM OFF
INSERT INTO HIG_PROCESS_TYPES
       (HPT_PROCESS_TYPE_ID
       ,HPT_NAME
       ,HPT_DESCR
       ,HPT_WHAT_TO_CALL
       ,HPT_INITIATION_MODULE
       ,HPT_INTERNAL_MODULE
       ,HPT_INTERNAL_MODULE_PARAM
       ,HPT_PROCESS_LIMIT
       ,HPT_RESTARTABLE
       ,HPT_SEE_IN_HIG2510
       ,HPT_POLLING_ENABLED
       ,HPT_POLLING_FTP_TYPE_ID
       ,HPT_AREA_TYPE
       )
SELECT 
        -4
       ,'Route Materialized View Refresh'
       ,'Refreshes Materialized views used in the production of shapefiles'
       ,'lb_aggr.refresh_route_views;'
       ,''
       ,''
       ,''
       ,''
       ,'Y'
       ,'Y'
       ,'N'
       ,null
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PROCESS_TYPES
                   WHERE HPT_PROCESS_TYPE_ID = -4);
--
INSERT INTO HIG_PROCESS_TYPE_ROLES
       (HPTR_PROCESS_TYPE_ID
       ,HPTR_ROLE
       )
SELECT 
        -4
       ,'HIG_ADMIN' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PROCESS_TYPE_ROLES
                   WHERE HPTR_PROCESS_TYPE_ID = -4
                    AND  HPTR_ROLE = 'HIG_ADMIN');

------------------------------------------------------------------
SET TERM ON
PROMPT New Process Type details for Group of Group theme refresh
SET TERM OFF
INSERT INTO HIG_PROCESS_TYPES
       (HPT_PROCESS_TYPE_ID
       ,HPT_NAME
       ,HPT_DESCR
       ,HPT_WHAT_TO_CALL
       ,HPT_INITIATION_MODULE
       ,HPT_INTERNAL_MODULE
       ,HPT_INTERNAL_MODULE_PARAM
       ,HPT_PROCESS_LIMIT
       ,HPT_RESTARTABLE
       ,HPT_SEE_IN_HIG2510
       ,HPT_POLLING_ENABLED
       ,HPT_POLLING_FTP_TYPE_ID
       ,HPT_AREA_TYPE
       )
SELECT 
        -5
       ,'Group of Groups Theme Refresh'
       ,'Refreshes Materialized views used in the production of shapefiles'
       ,'nm3layer_tool.refresh_group_of_groups;'
       ,''
       ,''
       ,''
       ,''
       ,'Y'
       ,'Y'
       ,'N'
       ,null
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PROCESS_TYPES
                   WHERE HPT_PROCESS_TYPE_ID = -5);


INSERT INTO HIG_PROCESS_TYPE_ROLES
       (HPTR_PROCESS_TYPE_ID
       ,HPTR_ROLE
       )
SELECT 
        -5
       ,'HIG_ADMIN' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PROCESS_TYPE_ROLES
                   WHERE HPTR_PROCESS_TYPE_ID = -5
                    AND  HPTR_ROLE = 'HIG_ADMIN');

------------------------------------------------------------------
SET TERM ON
PROMPT Deletetion of HIG1815 Metadata
SET TERM OFF
DELETE FROM HIG_MODULE_ROLES WHERE HMR_MODULE = 'HIG1815'
                    AND  HMR_ROLE = 'HIG_ADMIN';
--
DELETE FROM HIG_MODULE_ROLES WHERE HMR_MODULE = 'HIG1815'
                    AND  HMR_ROLE = 'HIG_USER';
--
DELETE FROM HIG_MODULE_KEYWORDS WHERE HMK_HMO_MODULE = 'HIG1815'
                    AND  HMK_KEYWORD = 'CONTACTS'
                    AND  HMK_OWNER = 1;
--
DELETE FROM HIG_MODULES WHERE HMO_MODULE = 'HIG1815';
--
------------------------------------------------------------------
SET TERM ON
PROMPT HIG_ERRORS update
SET TERM OFF
UPDATE hig_errors
   SET her_descr = 'Invalid format for postcode'
 WHERE her_no = 184 
 AND HER_APPL = 'HWAYS';
------------------------------------------------------------------
SET TERM ON
PROMPT New Product Options NEWDOCMAN, eBAssoURL
SET TERM OFF
INSERT INTO hig_option_list
   (SELECT 'NEWDOCMAN',
           'HIG',
           'New Document Manager',
           'If this is "Y" the documents are stored in eB else documents are stored in exor.',
           'Y_OR_N',
           'VARCHAR2',
           'N',
           'N',
           1
      FROM DUAL
     WHERE NOT EXISTS
              (SELECT 1
                 FROM hig_option_list
                WHERE hol_id = 'NEWDOCMAN'))
/

INSERT INTO hig_option_values
   (SELECT 'NEWDOCMAN', 'N'
      FROM DUAL
     WHERE NOT EXISTS
              (SELECT 1
                 FROM hig_option_values
                WHERE hov_id = 'NEWDOCMAN'))
/

-- eB document assocation api url

INSERT INTO hig_option_list
   (SELECT 'eBAssoURL',
           'HIG',
           'eB document assocation api url',
           'eB document assocation api url',
           NULL,
           'VARCHAR2',
           'Y',
           'N',
           2000
      FROM DUAL
     WHERE NOT EXISTS
              (SELECT 1
                 FROM hig_option_list
                WHERE hol_id = 'eBAssoURL'))
/


INSERT INTO hig_option_values
   (SELECT 'eBAssoURL', '<AssetWise CONNECT Document Manager URL>'
      FROM DUAL
     WHERE NOT EXISTS
              (SELECT 1
                 FROM hig_option_values
                WHERE hov_id = 'eBAssoURL'))
/
------------------------------------------------------------------
SET TERM ON
PROMPT New Product Option NMGENPK
SET TERM OFF
INSERT INTO HIG_OPTION_LIST 
           (HOL_ID,
            HOL_PRODUCT,
            HOL_NAME,
            HOL_REMARKS,
            HOL_DOMAIN,
            HOL_DATATYPE,
            HOL_MIXED_CASE,
            HOL_USER_OPTION,
            HOL_MAX_LENGTH
            )
SELECT 'NMGENPK'
      ,'NET'
      ,'Generate asset Primary Key'
      ,'Defines whether the Primary Key value is automatically generated for an asset, where the Primary Key is defined as an asset attribute'
      ,'Y_OR_N'
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,1
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'NMGENPK'
                 )
/
--
INSERT INTO HIG_OPTION_VALUES
           (HOV_ID, 
            HOV_VALUE
           )  
SELECT 'NMGENPK'
      ,'N'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'NMGENPK'
                 )
/
------------------------------------------------------------------
SET TERM ON
PROMPT Update HIG_MODULES title
SET TERM OFF
UPDATE hig_modules
   SET hmo_title = 'My Standard Text Usage'
 WHERE hmo_module = 'HIG4025';
------------------------------------------------------------------
SET TERM ON
PROMPT WEBMAPDSRC and WEBMAPDSRC product option changes
SET TERM OFF
DELETE FROM hig_option_list 
WHERE hol_id = 'WEBMAPPRDS';
--
UPDATE hig_option_list 
SET hol_user_option = 'N' 
WHERE hol_id = 'WEBMAPDSRC';
--
DELETE FROM hig_user_options 
WHERE huo_id IN ('WEBMAPPRDS', 'WEBMAPDSRC');
------------------------------------------------------------------
SET TERM ON
PROMPT Addition of PS and MAS Products
SET TERM OFF
INSERT INTO HIG_PRODUCTS
       (HPR_PRODUCT
       ,HPR_PRODUCT_NAME
       ,HPR_VERSION
       ,HPR_PATH_NAME
       ,HPR_KEY
       ,HPR_SEQUENCE
       ,HPR_IMAGE
       ,HPR_USER_MENU
       ,HPR_LAUNCHPAD_ICON
       ,HPR_IMAGE_TYPE
       )
SELECT 
        'MAS'
       ,'Managed Service Changes'
       ,'4.0.2.0'
       ,''
       ,null
       ,null
       ,''
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PRODUCTS
                   WHERE HPR_PRODUCT = 'MAS');

INSERT INTO HIG_PRODUCTS
       (HPR_PRODUCT
       ,HPR_PRODUCT_NAME
       ,HPR_VERSION
       ,HPR_PATH_NAME
       ,HPR_KEY
       ,HPR_SEQUENCE
       ,HPR_IMAGE
       ,HPR_USER_MENU
       ,HPR_LAUNCHPAD_ICON
       ,HPR_IMAGE_TYPE
       )
SELECT 
        'PS'
       ,'Professional Services Changes'
       ,'4.0.2.0'
       ,''
       ,null
       ,null
       ,''
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PRODUCTS
                   WHERE HPR_PRODUCT IN ( 'PS', 'PS '));
------------------------------------------------------------------
SET TERM ON
PROMPT New product options NMGENPK, THMEROLOVR and AUTHMAIL
SET TERM OFF
INSERT INTO HIG_OPTION_LIST 
           (HOL_ID,
            HOL_PRODUCT,
            HOL_NAME,
            HOL_REMARKS,
            HOL_DOMAIN,
            HOL_DATATYPE,
            HOL_MIXED_CASE,
            HOL_USER_OPTION,
            HOL_MAX_LENGTH
            )
SELECT 'NMGENPK'
      ,'NET'
      ,'Generate asset Primary Key'
      ,'Defines whether the Primary Key is automatically generated for an asset, where the Primary Key is defined as an asset attribute.'
      ,'Y_OR_N'
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,1
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'NMGENPK'
                 )
/
--
INSERT INTO HIG_OPTION_VALUES
           (HOV_ID, 
            HOV_VALUE
           )  
SELECT 'NMGENPK'
      ,'N'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'NMGENPK'
                 )
/
--
INSERT INTO HIG_OPTION_LIST 
           (HOL_ID,
            HOL_PRODUCT,
            HOL_NAME,
            HOL_REMARKS,
            HOL_DOMAIN,
            HOL_DATATYPE,
            HOL_MIXED_CASE,
            HOL_USER_OPTION,
            HOL_MAX_LENGTH
            )
SELECT 'THMEROLOVR'
      ,'NET'
      ,'Override Theme Role'
      ,'Allow assets to be created when the asset Role is defined as NORMAL, but the associated theme Role is defined as READONLY'
      ,'Y_OR_N'
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,1
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'THMEROLOVR'
                 )
/
--
INSERT INTO HIG_OPTION_LIST
          (HOL_ID,
           HOL_PRODUCT,
           HOL_NAME,
           HOL_REMARKS,
           HOL_DOMAIN,
           HOL_DATATYPE,
           HOL_MIXED_CASE,
           HOL_USER_OPTION,
           HOL_MAX_LENGTH
          )
SELECT 'AUTHMAIL'
            ,'NET'
            ,'Email Authentication'
             ,'Defines whether SMTP Server requires Username/Password authentication.'
             ,'Y_OR_N'
             ,'VARCHAR2'
             ,'N'
             ,'N'
              ,1
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'AUTHMAIL'
                 )
/
--
INSERT INTO HIG_OPTION_VALUES
           (HOV_ID, 
            HOV_VALUE
           )  
SELECT 'THMEROLOVR'
      ,'N'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'THMEROLOVR'
                 )
/
--
INSERT INTO HIG_OPTION_VALUES
           (HOV_ID,
            HOV_VALUE
           )
SELECT  'AUTHMAIL'
      ,'N'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'AUTHMAIL'
                 )
/
------------------------------------------------------------------
SET TERM ON
PROMPT HIG_MODULES DOC0300 change
SET TERM OFF
UPDATE HIG_MODULES   SET HMO_FILENAME = 'HIG2510' WHERE HMO_MODULE = 'DOC0300' AND UPPER (HMO_FILENAME) <> 'HIG2510'/
------------------------------------------------------------------
SET TERM ON
PROMPT Document Manager remote server changes
SET TERM OFF
INSERT INTO HIG_OPTION_LIST (HOL_ID,                             HOL_PRODUCT,                             HOL_NAME,                             HOL_REMARKS,                             HOL_DOMAIN,                             HOL_DATATYPE,                             HOL_MIXED_CASE,                             HOL_USER_OPTION,                             HOL_MAX_LENGTH)   SELECT 'MSREMSVR',          'DOC',          'Flag for managed service',          'Set flag to Y for managed service installations',          'Y_OR_N',          'VARCHAR2',          'N',          'N',          1     FROM DUAL    WHERE NOT EXISTS             (SELECT 1                FROM HIG_OPTION_LIST               WHERE HOL_ID = 'MSREMSVR')/--INSERT INTO HIG_OPTION_VALUES (HOV_ID, HOV_VALUE)   SELECT 'MSREMSVR', 'N'     FROM DUAL    WHERE NOT EXISTS             (SELECT 1                FROM HIG_OPTION_VALUES               WHERE HOV_ID = 'MSREMSVR')/--INSERT INTO HIG_CODES (HCO_CODE,                       HCO_DOMAIN,                       HCO_END_DATE,                       HCO_MEANING,                       HCO_SEQ,                       HCO_START_DATE,                       HCO_SYSTEM)   SELECT 'REMOTE_SERVER',          'DOC_LOCATION_TYPES',          NULL,          'Remote File Server',          50,          NULL,          'Y'     FROM DUAL    WHERE NOT EXISTS             (SELECT 1                FROM HIG_CODES               WHERE     HCO_DOMAIN = 'DOC_LOCATION_TYPES'                     AND HCO_CODE = 'REMOTE_SERVER')/
------------------------------------------------------------------
SET TERM ON
PROMPT New NM_ERRORS
SET TERM OFF
INSERT INTO NM_ERRORS (NER_APPL,                       NER_ID,                       NER_HER_NO,                       NER_DESCR,                       NER_CAUSE)   SELECT 'HIG',          558,          NULL,          'Not all selections could be deleted',          ''     FROM DUAL    WHERE NOT EXISTS             (SELECT 1                FROM NM_ERRORS               WHERE NER_APPL = 'HIG' AND NER_ID = 558);--INSERT INTO NM_ERRORS (NER_APPL,                       NER_ID,                       NER_HER_NO,                       NER_DESCR,                       NER_CAUSE)   SELECT 'HIG',          559,          NULL,          'All selections deleted',          ''     FROM DUAL    WHERE NOT EXISTS             (SELECT 1                FROM NM_ERRORS               WHERE NER_APPL = 'HIG' AND NER_ID = 559);
------------------------------------------------------------------
SET TERM ON
PROMPT Hig User report metadata
SET TERM OFF
INSERT INTO GRI_PARAMS (GP_PARAM,                        GP_PARAM_TYPE,                        GP_TABLE,                        GP_COLUMN,                        GP_DESCR_COLUMN,                        GP_SHOWN_COLUMN,                        GP_SHOWN_TYPE,                        GP_DESCR_TYPE,                        GP_ORDER,                        GP_CASE,                        GP_GAZ_RESTRICTION)   SELECT 'HUS_STATUS',          'CHAR',          'GRI_PARAM_LOOKUP',          'GPL_VALUE',          'GPL_DESCR',          'GPL_VALUE',          'CHAR',          'CHAR',          NULL,          NULL,          NULL     FROM DUAL    WHERE NOT EXISTS             (SELECT 1                FROM GRI_PARAMS               WHERE GP_PARAM = 'HUS_STATUS');--INSERT INTO GRI_MODULE_PARAMS (GMP_MODULE,                               GMP_PARAM,                               GMP_SEQ,                               GMP_PARAM_DESCR,                               GMP_MANDATORY,                               GMP_NO_ALLOWED,                               GMP_WHERE,                               GMP_TAG_RESTRICTION,                               GMP_TAG_WHERE,                               GMP_DEFAULT_TABLE,                               GMP_DEFAULT_COLUMN,                               GMP_DEFAULT_WHERE,                               GMP_VISIBLE,                               GMP_GAZETTEER,                               GMP_LOV,                               GMP_VAL_GLOBAL,                               GMP_WILDCARD,                               GMP_HINT_TEXT,                               GMP_ALLOW_PARTIAL,                               GMP_BASE_TABLE,                               GMP_BASE_TABLE_COLUMN,                               GMP_OPERATOR)   SELECT 'HIG1864',          'HUS_STATUS',          3,          'Include End Dated?',          'N',          1,          'GPL_PARAM=''HUS_STATUS''',          'N',          NULL,          'GRI_PARAM_LOOKUP',          'GPL_VALUE',          'GPL_VALUE=''N'' AND GPL_PARAM=''HUS_STATUS''',          'Y',          'N',          'Y',          NULL,          'N',          'Include end dated users?',          'N',          NULL,          NULL,          NULL     FROM DUAL    WHERE NOT EXISTS             (SELECT 1                FROM GRI_MODULE_PARAMS               WHERE GMP_MODULE = 'HIG1864' AND GMP_PARAM = 'HUS_STATUS');--INSERT INTO GRI_PARAM_LOOKUP (GPL_PARAM, GPL_VALUE, GPL_DESCR)   SELECT 'HUS_STATUS', 'Y', 'Yes'     FROM DUAL    WHERE NOT EXISTS             (SELECT 1                FROM GRI_PARAM_LOOKUP               WHERE GPL_PARAM = 'HUS_STATUS' AND GPL_VALUE = 'Y');--INSERT INTO GRI_PARAM_LOOKUP (GPL_PARAM, GPL_VALUE, GPL_DESCR)   SELECT 'HUS_STATUS', 'N', 'No'     FROM DUAL    WHERE NOT EXISTS             (SELECT 1                FROM GRI_PARAM_LOOKUP               WHERE GPL_PARAM = 'HUS_STATUS' AND GPL_VALUE = 'N');
------------------------------------------------------------------
SET TERM ON
PROMPT Removal of USEORIGHU product option
SET TERM OFF
DELETE FROM hig_option_list
WHERE hol_id = 'USEORIGHU';
------------------------------------------------------------------
SET TERM ON
PROMPT nm_4700_fix58
SET TERM OFF
INSERT INTO HIG_PROCESS_TYPES
       (HPT_PROCESS_TYPE_ID
       ,HPT_NAME
       ,HPT_DESCR
       ,HPT_WHAT_TO_CALL
       ,HPT_INITIATION_MODULE
       ,HPT_INTERNAL_MODULE
       ,HPT_INTERNAL_MODULE_PARAM
       ,HPT_PROCESS_LIMIT
       ,HPT_RESTARTABLE
       ,HPT_SEE_IN_HIG2510
       ,HPT_POLLING_ENABLED
       ,HPT_POLLING_FTP_TYPE_ID
       ,HPT_AREA_TYPE
       )
SELECT 
        -6
       ,'Refresh Auto-generated Passwords'
       ,'Refreshes User passwords for users where the password is automatically generated'
       ,'hig_relationship_api.refresh_auto_passwords;'
       ,''
       ,''
       ,''
       ,''
       ,'Y'
       ,'Y'
       ,'N'
       ,null
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PROCESS_TYPES
                   WHERE HPT_PROCESS_TYPE_ID = -6);
--
INSERT INTO HIG_PROCESS_TYPE_ROLES
       (HPTR_PROCESS_TYPE_ID
       ,HPTR_ROLE
       )
SELECT 
        -6
       ,'HIG_ADMIN' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PROCESS_TYPE_ROLES
                   WHERE HPTR_PROCESS_TYPE_ID = -6
                    AND  HPTR_ROLE = 'HIG_ADMIN');
--
DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE PROXY_OWNER';
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/
--
INSERT INTO HIG_ROLES
      (HRO_ROLE
      ,HRO_PRODUCT
      ,HRO_DESCR
      ) 
SELECT  
       'PROXY_OWNER'
      ,'HIG'
      ,'Role which allows proxy connections for users, with this user as the Proxy Owner' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                    WHERE HRO_ROLE = 'PROXY_OWNER');
--
INSERT INTO hig_option_list
   (SELECT 'DEFSSO',
           'HIG',
           'User SSO Default',
           'This defines whether new users are defined as Single Sign-On users as default.',
           'Y_OR_N',
           'VARCHAR2',
           'N',
           'N',
           1
      FROM DUAL
     WHERE NOT EXISTS
              (SELECT 1
                 FROM hig_option_list
                WHERE hol_id = 'DEFSSO'))
/

INSERT INTO hig_option_values
   (SELECT 'DEFSSO', 'N'
      FROM DUAL
     WHERE NOT EXISTS
              (SELECT 1
                 FROM hig_option_values
                WHERE hov_id = 'DEFSSO'))
/
------------------------------------------------------------------
SET TERM ON
PROMPT nm_4700_fix59
SET TERM OFF
INSERT INTO HIG_ROLES
      (HRO_ROLE
      ,HRO_PRODUCT
      ,HRO_DESCR
      ) 
SELECT  
      'ALERT_ADMIN'
      ,'HIG'
      ,'Alert Administration' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                    WHERE HRO_ROLE = 'ALERT_ADMIN');


------------------------------------------------------------------
SET TERM ON
PROMPT Location Bridge Metadata changes
SET TERM OFF
update nm_units
set un_unit_name = 'Meter' where un_unit_id = 1;

update nm_units
set un_unit_name = 'Kilometer' where un_unit_id = 2;

update nm_units
set un_unit_name = 'Centimeter' where un_unit_id = 3;

update nm_units
set un_unit_name = 'Mile' where un_unit_id = 4;

INSERT INTO nm_unit_conversions
    SELECT un_unit_id,
           un_unit_id,
           'NULL_CONVERSION',
           'CREATE OR REPLACE FUNCTION NULL_CONVERSION ( UNITSIN IN NUMBER )RETURN NUMBER IS RETVAL NUMBER; BEGIN   RETVAL := UNITSIN;   RETURN RETVAL; END;',
           1
      FROM nm_units
     WHERE NOT EXISTS
               (SELECT 1
                  FROM nm_unit_conversions
                 WHERE     uc_unit_id_in = un_unit_id
                       AND uc_unit_id_out = un_unit_id)
/

INSERT INTO hig_option_list (hol_id,
                             hol_product,
                             hol_name,
                             hol_remarks,
                             hol_domain,
                             hol_datatype,
                             hol_mixed_case,
                             hol_user_option,
                             hol_max_length)
    SELECT 'LBNWBUFFER',
           'NET',
           'LB Graph Buffer',
           'The size of the buffer in meters around an object to from the spatial intersection for construction of a dynamic network property graph',
           NULL,
           'NUMBER',
           'N',
           'N',
           2000
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM hig_option_list
                 WHERE hol_id = 'LBNWBUFFER');

INSERT INTO hig_option_values (hov_id, hov_value)
    SELECT 'LBNWBUFFER', '200'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM hig_option_values
                 WHERE hov_id = 'LBNWBUFFER');

INSERT INTO nm_inv_categories (nic_category, nic_descr)
    SELECT 'L', 'Location Bridge'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM nm_inv_categories
                 WHERE nic_category = 'L')
/

INSERT INTO nm_au_types (nat_admin_type, nat_descr)
    SELECT 'NONE', 'No Admin-Unit Security'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM nm_au_types
                 WHERE nat_admin_type = 'NONE')
/
PROMPT Location Bridge Unit Translation Data

INSERT INTO LB_UNITS (EXTERNAL_UNIT_ID,
                      EXTERNAL_UNIT_NAME,
                      EXOR_UNIT_ID,
                      EXOR_UNIT_NAME)
    SELECT 50,
           'METRE',
           1,
           'Meter'
      FROM DUAL
     WHERE     NOT EXISTS
                   (SELECT 1
                      FROM lb_units
                     WHERE exor_unit_id = 1)
           AND EXISTS
                   (SELECT 1
                      FROM nm_units
                     WHERE un_unit_id = 1);

INSERT INTO LB_UNITS (EXTERNAL_UNIT_ID,
                      EXTERNAL_UNIT_NAME,
                      EXOR_UNIT_ID,
                      EXOR_UNIT_NAME)
    SELECT 236,
           'KILOMETRE',
           2,
           'Kilometer'
      FROM DUAL
     WHERE     NOT EXISTS
                   (SELECT 1
                      FROM lb_units
                     WHERE exor_unit_id = 2)
           AND EXISTS
                   (SELECT 1
                      FROM nm_units
                     WHERE un_unit_id = 2);

INSERT INTO LB_UNITS (EXTERNAL_UNIT_ID,
                      EXTERNAL_UNIT_NAME,
                      EXOR_UNIT_ID,
                      EXOR_UNIT_NAME)
    SELECT 51,
           'CENTIMETRE',
           3,
           'Centimetre'
      FROM DUAL
     WHERE     NOT EXISTS
                   (SELECT 1
                      FROM lb_units
                     WHERE exor_unit_id = 3)
           AND EXISTS
                   (SELECT 1
                      FROM nm_units
                     WHERE un_unit_id = 3);

INSERT INTO LB_UNITS (EXTERNAL_UNIT_ID,
                      EXTERNAL_UNIT_NAME,
                      EXOR_UNIT_ID,
                      EXOR_UNIT_NAME)
    SELECT 321,
           'MILE',
           4,
           'Mile'
      FROM DUAL
     WHERE     NOT EXISTS
                   (SELECT 1
                      FROM lb_units
                     WHERE exor_unit_id = 4)
           AND EXISTS
                   (SELECT 1
                      FROM nm_units
                     WHERE un_unit_id = 4);

INSERT INTO LB_UNITS (EXTERNAL_UNIT_ID,
                      EXTERNAL_UNIT_NAME,
                      EXOR_UNIT_ID,
                      EXOR_UNIT_NAME)
    SELECT 77,
           'DEGREE',
           5,
           'Degrees'
      FROM DUAL
     WHERE     NOT EXISTS
                   (SELECT 1
                      FROM lb_units
                     WHERE exor_unit_id = 5)
           AND EXISTS
                   (SELECT 1
                      FROM nm_units
                     WHERE un_unit_id = 5);

INSERT INTO LB_UNITS (EXTERNAL_UNIT_ID,
                      EXTERNAL_UNIT_NAME,
                      EXOR_UNIT_ID,
                      EXOR_UNIT_NAME)
    SELECT 13,
           'RADIAN',
           6,
           'Radians'
      FROM DUAL
     WHERE     NOT EXISTS
                   (SELECT 1
                      FROM lb_units
                     WHERE exor_unit_id = 6)
           AND EXISTS
                   (SELECT 1
                      FROM nm_units
                     WHERE un_unit_id = 6);

PROMPT create LB_NETWORK metadata

INSERT INTO user_sdo_network_metadata (network,
                                       network_id,
                                       network_category,
                                       no_of_hierarchy_levels,
                                       no_of_partitions,
                                       node_table_name,
                                       node_cost_column,
                                       link_table_name,
                                       link_direction,
                                       link_cost_column,
                                       path_table_name,
                                       path_link_table_name,
                                       subpath_table_name)
     VALUES ('LB_NETWORK',
             1,
             'LOGICAL',
             1,
             0,
             'LB_NETWORK_NO',
             'XNO_COST',
             'LB_NETWORK_LINK',
             'UNDIRECTED',
             'XNW_COST',
             'LB_NETWORK_PATH',
             'LB_NETWORK_PATH_LINK',
             'LB_NETWORK_SUB_PATH');

------------------------------------------------------------------
Commit;

------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

