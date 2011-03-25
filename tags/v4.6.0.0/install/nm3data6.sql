-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3data6.sql-arc   2.14   Mar 25 2011 09:35:32   Mike.Alexander  $
--       Module Name      : $Workfile:   nm3data6.sql  $
--       Date into PVCS   : $Date:   Mar 25 2011 09:35:32  $
--       Date fetched Out : $Modtime:   Mar 25 2011 09:31:52  $
--       Version          : $Revision:   2.14  $
--       Table Owner      : NM3_METADATA
--       Generation Date  : 25-MAR-2011 09:31
--
--   Product metadata script
--   As at Release 4.4.0.0
--
--   Copyright (c) exor corporation ltd, 2011
--
--   TABLES PROCESSED
--   ================
--   NM_UNIT_DOMAINS
--   NM_UNITS
--   NM_UNIT_CONVERSIONS
--   COLOURS
--   NM_ADMIN_GROUPS
--   NM_NODE_TYPES
--   NM_MAIL_GROUPS
--   NM_MAIL_USERS
--   NM_EVENT_TYPES
--   NM_INV_CATEGORIES
--   NM_INV_CATEGORY_MODULES
--   NM_FILL_PATTERNS
--   NM_VISUAL_ATTRIBUTES
--   NM_AU_TYPES
--
-----------------------------------------------------------------------------


set define off;
set feedback off;

--------------------
-- PRE-PROCESSING --
--------------------
delete from hig_web_contxt_hlp;
commit;


---------------------------------
-- START OF GENERATED METADATA --
---------------------------------


----------------------------------------------------------------------------------------
-- NM_UNIT_DOMAINS
--
-- select * from nm3_metadata.nm_unit_domains
-- order by ud_domain_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_unit_domains
SET TERM OFF

INSERT INTO NM_UNIT_DOMAINS
       (UD_DOMAIN_ID
       ,UD_DOMAIN_NAME
       ,UD_TEXT
       )
SELECT 
        1
       ,'LENGTH'
       ,'LENGTH' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNIT_DOMAINS
                   WHERE UD_DOMAIN_ID = 1);
--
INSERT INTO NM_UNIT_DOMAINS
       (UD_DOMAIN_ID
       ,UD_DOMAIN_NAME
       ,UD_TEXT
       )
SELECT 
        2
       ,'ANGLES'
       ,'UNITS OF MEASURE OF ANGLES' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNIT_DOMAINS
                   WHERE UD_DOMAIN_ID = 2);
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_UNITS
--
-- select * from nm3_metadata.nm_units
-- order by un_unit_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_units
SET TERM OFF

INSERT INTO NM_UNITS
       (UN_DOMAIN_ID
       ,UN_UNIT_ID
       ,UN_UNIT_NAME
       ,UN_FORMAT_MASK
       )
SELECT 
        1
       ,1
       ,'Metres'
       ,'999999999990.000' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNITS
                   WHERE UN_UNIT_ID = 1);
--
INSERT INTO NM_UNITS
       (UN_DOMAIN_ID
       ,UN_UNIT_ID
       ,UN_UNIT_NAME
       ,UN_FORMAT_MASK
       )
SELECT 
        1
       ,2
       ,'Kilometers'
       ,'99999990.000' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNITS
                   WHERE UN_UNIT_ID = 2);
--
INSERT INTO NM_UNITS
       (UN_DOMAIN_ID
       ,UN_UNIT_ID
       ,UN_UNIT_NAME
       ,UN_FORMAT_MASK
       )
SELECT 
        1
       ,3
       ,'Centimetres'
       ,'99999999999999990' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNITS
                   WHERE UN_UNIT_ID = 3);
--
INSERT INTO NM_UNITS
       (UN_DOMAIN_ID
       ,UN_UNIT_ID
       ,UN_UNIT_NAME
       ,UN_FORMAT_MASK
       )
SELECT 
        1
       ,4
       ,'Miles'
       ,'9990.00' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNITS
                   WHERE UN_UNIT_ID = 4);
--
INSERT INTO NM_UNITS
       (UN_DOMAIN_ID
       ,UN_UNIT_ID
       ,UN_UNIT_NAME
       ,UN_FORMAT_MASK
       )
SELECT 
        2
       ,5
       ,'Degrees'
       ,'990.00' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNITS
                   WHERE UN_UNIT_ID = 5);
--
INSERT INTO NM_UNITS
       (UN_DOMAIN_ID
       ,UN_UNIT_ID
       ,UN_UNIT_NAME
       ,UN_FORMAT_MASK
       )
SELECT 
        2
       ,6
       ,'Radians'
       ,'90.000000' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNITS
                   WHERE UN_UNIT_ID = 6);
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_UNIT_CONVERSIONS
--
-- select * from nm3_metadata.nm_unit_conversions
-- order by uc_unit_id_in
--         ,uc_unit_id_out
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_unit_conversions
SET TERM OFF

INSERT INTO NM_UNIT_CONVERSIONS
       (UC_UNIT_ID_IN
       ,UC_UNIT_ID_OUT
       ,UC_FUNCTION
       ,UC_CONVERSION
       ,UC_CONVERSION_FACTOR
       )
SELECT 
        1
       ,2
       ,'M_TO_KM'
       ,'CREATE OR REPLACE FUNCTION M_TO_KM ( UNITSIN IN NUMBER )RETURN NUMBER IS RETVAL NUMBER; BEGIN   RETVAL := UNITSIN / 1000;   RETURN RETVAL; END;'
       ,.001 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNIT_CONVERSIONS
                   WHERE UC_UNIT_ID_IN = 1
                    AND  UC_UNIT_ID_OUT = 2);
--
INSERT INTO NM_UNIT_CONVERSIONS
       (UC_UNIT_ID_IN
       ,UC_UNIT_ID_OUT
       ,UC_FUNCTION
       ,UC_CONVERSION
       ,UC_CONVERSION_FACTOR
       )
SELECT 
        1
       ,3
       ,'M_TO_CM'
       ,'CREATE OR REPLACE FUNCTION M_TO_CM ( UNITSIN IN NUMBER )RETURN NUMBER IS RETVAL NUMBER; BEGIN   RETVAL := UNITSIN * 100;   RETURN RETVAL; END;'
       ,100 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNIT_CONVERSIONS
                   WHERE UC_UNIT_ID_IN = 1
                    AND  UC_UNIT_ID_OUT = 3);
--
INSERT INTO NM_UNIT_CONVERSIONS
       (UC_UNIT_ID_IN
       ,UC_UNIT_ID_OUT
       ,UC_FUNCTION
       ,UC_CONVERSION
       ,UC_CONVERSION_FACTOR
       )
SELECT 
        1
       ,4
       ,'M_TO_MILES'
       ,'CREATE OR REPLACE FUNCTION M_TO_MILES'||CHR(10)||'        (UNITSIN IN NUMBER) RETURN NUMBER IS'||CHR(10)||'BEGIN'||CHR(10)||'   RETURN UNITSIN*0.000621371192237334;'||CHR(10)||'END M_TO_MILES;'
       ,.000621371192237334 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNIT_CONVERSIONS
                   WHERE UC_UNIT_ID_IN = 1
                    AND  UC_UNIT_ID_OUT = 4);
--
INSERT INTO NM_UNIT_CONVERSIONS
       (UC_UNIT_ID_IN
       ,UC_UNIT_ID_OUT
       ,UC_FUNCTION
       ,UC_CONVERSION
       ,UC_CONVERSION_FACTOR
       )
SELECT 
        2
       ,1
       ,'KM_TO_M'
       ,'CREATE OR REPLACE FUNCTION KM_TO_M ( UNITSIN IN NUMBER )RETURN NUMBER IS RETVAL NUMBER; BEGIN   RETVAL := UNITSIN * 1000;   RETURN RETVAL; END;'
       ,1000 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNIT_CONVERSIONS
                   WHERE UC_UNIT_ID_IN = 2
                    AND  UC_UNIT_ID_OUT = 1);
--
INSERT INTO NM_UNIT_CONVERSIONS
       (UC_UNIT_ID_IN
       ,UC_UNIT_ID_OUT
       ,UC_FUNCTION
       ,UC_CONVERSION
       ,UC_CONVERSION_FACTOR
       )
SELECT 
        2
       ,3
       ,'KM_TO_CM'
       ,'CREATE OR REPLACE FUNCTION KM_TO_CM'||CHR(10)||'        (UNITSIN IN NUMBER) RETURN NUMBER IS'||CHR(10)||'BEGIN'||CHR(10)||'   RETURN UNITSIN*100000;'||CHR(10)||'END KM_TO_CM;'
       ,100000 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNIT_CONVERSIONS
                   WHERE UC_UNIT_ID_IN = 2
                    AND  UC_UNIT_ID_OUT = 3);
--
INSERT INTO NM_UNIT_CONVERSIONS
       (UC_UNIT_ID_IN
       ,UC_UNIT_ID_OUT
       ,UC_FUNCTION
       ,UC_CONVERSION
       ,UC_CONVERSION_FACTOR
       )
SELECT 
        2
       ,4
       ,'KM_TO_MILES'
       ,'CREATE OR REPLACE FUNCTION KM_TO_MILES'||CHR(10)||'        (UNITSIN IN NUMBER) RETURN NUMBER IS'||CHR(10)||'BEGIN'||CHR(10)||'   RETURN UNITSIN*0.621371192237334;'||CHR(10)||'END KM_TO_MILES;'
       ,.621371192237334 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNIT_CONVERSIONS
                   WHERE UC_UNIT_ID_IN = 2
                    AND  UC_UNIT_ID_OUT = 4);
--
INSERT INTO NM_UNIT_CONVERSIONS
       (UC_UNIT_ID_IN
       ,UC_UNIT_ID_OUT
       ,UC_FUNCTION
       ,UC_CONVERSION
       ,UC_CONVERSION_FACTOR
       )
SELECT 
        3
       ,1
       ,'CM_TO_M'
       ,'CREATE OR REPLACE FUNCTION CM_TO_M ( UNITSIN IN NUMBER )RETURN NUMBER IS RETVAL NUMBER; BEGIN   RETVAL := UNITSIN / 100;   RETURN RETVAL; END;'
       ,.01 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNIT_CONVERSIONS
                   WHERE UC_UNIT_ID_IN = 3
                    AND  UC_UNIT_ID_OUT = 1);
--
INSERT INTO NM_UNIT_CONVERSIONS
       (UC_UNIT_ID_IN
       ,UC_UNIT_ID_OUT
       ,UC_FUNCTION
       ,UC_CONVERSION
       ,UC_CONVERSION_FACTOR
       )
SELECT 
        3
       ,2
       ,'CM_TO_KM'
       ,'CREATE OR REPLACE FUNCTION CM_TO_KM'||CHR(10)||'        (UNITSIN IN NUMBER) RETURN NUMBER IS'||CHR(10)||'BEGIN'||CHR(10)||'   RETURN UNITSIN*.00001;'||CHR(10)||'END CM_TO_KM;'
       ,.00001 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNIT_CONVERSIONS
                   WHERE UC_UNIT_ID_IN = 3
                    AND  UC_UNIT_ID_OUT = 2);
--
INSERT INTO NM_UNIT_CONVERSIONS
       (UC_UNIT_ID_IN
       ,UC_UNIT_ID_OUT
       ,UC_FUNCTION
       ,UC_CONVERSION
       ,UC_CONVERSION_FACTOR
       )
SELECT 
        3
       ,4
       ,'CM_TO_MILES'
       ,'CREATE OR REPLACE FUNCTION CM_TO_MILES'||CHR(10)||'        (UNITSIN IN NUMBER) RETURN NUMBER IS'||CHR(10)||'BEGIN'||CHR(10)||'   RETURN UNITSIN*0.000621371192237334;'||CHR(10)||'END CM_TO_MILES;'
       ,.00000621371192237334 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNIT_CONVERSIONS
                   WHERE UC_UNIT_ID_IN = 3
                    AND  UC_UNIT_ID_OUT = 4);
--
INSERT INTO NM_UNIT_CONVERSIONS
       (UC_UNIT_ID_IN
       ,UC_UNIT_ID_OUT
       ,UC_FUNCTION
       ,UC_CONVERSION
       ,UC_CONVERSION_FACTOR
       )
SELECT 
        4
       ,1
       ,'MILES_TO_M'
       ,'CREATE OR REPLACE FUNCTION MILES_TO_M'||CHR(10)||'        (UNITSIN IN NUMBER) RETURN NUMBER IS'||CHR(10)||'BEGIN'||CHR(10)||'   RETURN UNITSIN*1609.344;'||CHR(10)||'END MILES_TO_M;'
       ,1609.344 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNIT_CONVERSIONS
                   WHERE UC_UNIT_ID_IN = 4
                    AND  UC_UNIT_ID_OUT = 1);
--
INSERT INTO NM_UNIT_CONVERSIONS
       (UC_UNIT_ID_IN
       ,UC_UNIT_ID_OUT
       ,UC_FUNCTION
       ,UC_CONVERSION
       ,UC_CONVERSION_FACTOR
       )
SELECT 
        4
       ,2
       ,'MILES_TO_KM'
       ,'CREATE OR REPLACE FUNCTION MILES_TO_KM'||CHR(10)||'        (UNITSIN IN NUMBER) RETURN NUMBER IS'||CHR(10)||'BEGIN'||CHR(10)||'   RETURN UNITSIN*1.609344;'||CHR(10)||'END MILES_TO_KM;'
       ,1.609344 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNIT_CONVERSIONS
                   WHERE UC_UNIT_ID_IN = 4
                    AND  UC_UNIT_ID_OUT = 2);
--
INSERT INTO NM_UNIT_CONVERSIONS
       (UC_UNIT_ID_IN
       ,UC_UNIT_ID_OUT
       ,UC_FUNCTION
       ,UC_CONVERSION
       ,UC_CONVERSION_FACTOR
       )
SELECT 
        4
       ,3
       ,'MILES_TO_CM'
       ,'CREATE OR REPLACE FUNCTION MILES_TO_CM'||CHR(10)||'        (UNITSIN IN NUMBER) RETURN NUMBER IS'||CHR(10)||'BEGIN'||CHR(10)||'   RETURN UNITSIN*160934.4;'||CHR(10)||'END MILES_TO_CM;'
       ,160934.4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNIT_CONVERSIONS
                   WHERE UC_UNIT_ID_IN = 4
                    AND  UC_UNIT_ID_OUT = 3);
--
INSERT INTO NM_UNIT_CONVERSIONS
       (UC_UNIT_ID_IN
       ,UC_UNIT_ID_OUT
       ,UC_FUNCTION
       ,UC_CONVERSION
       ,UC_CONVERSION_FACTOR
       )
SELECT 
        5
       ,6
       ,'DEG_TO_RADS'
       ,'CREATE OR REPLACE FUNCTION DEG_TO_RADS ( UNITSIN IN NUMBER ) RETURN NUMBER IS RETVAL NUMBER; BEGIN RETVAL := UNITSIN * 3.141592/ 180; RETURN RETVAL; END;'
       ,.017453288888888888888888888888888888889 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNIT_CONVERSIONS
                   WHERE UC_UNIT_ID_IN = 5
                    AND  UC_UNIT_ID_OUT = 6);
--
INSERT INTO NM_UNIT_CONVERSIONS
       (UC_UNIT_ID_IN
       ,UC_UNIT_ID_OUT
       ,UC_FUNCTION
       ,UC_CONVERSION
       ,UC_CONVERSION_FACTOR
       )
SELECT 
        6
       ,5
       ,'RADS_TO_DEGS'
       ,'CREATE OR REPLACE FUNCTION RADS_TO_DEGS ( UNITSIN IN NUMBER ) RETURN NUMBER IS RETVAL NUMBER; BEGIN RETVAL := UNITSIN * 180 / 3.141592; RETURN RETVAL; END;'
       ,57.2957914331332649179142294734644091276 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UNIT_CONVERSIONS
                   WHERE UC_UNIT_ID_IN = 6
                    AND  UC_UNIT_ID_OUT = 5);
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- COLOURS
--
-- select * from nm3_metadata.colours
-- order by col_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT colours
SET TERM OFF

INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G0B88'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 1);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G100B0'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 2);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G100B100'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 3);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G100B50'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 4);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G100B75'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 5);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G100B88'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 6);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G25B0'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 7);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G25B100'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 8);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G25B50'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 9);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G25B75'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 10);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G25B88'
       ,11 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 11);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G50B0'
       ,12 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 12);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G50B100'
       ,13 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 13);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G0B0'
       ,14 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 14);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G0B100'
       ,15 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 15);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G0B50'
       ,16 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 16);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G0B75'
       ,17 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 17);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G0B88'
       ,18 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 18);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G100B0'
       ,19 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 19);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G100B100'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 20);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G100B50'
       ,21 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 21);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G100B75'
       ,22 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 22);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G100B88'
       ,23 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 23);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G25B0'
       ,24 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 24);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G25B100'
       ,25 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 25);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G25B50'
       ,26 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 26);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G25B75'
       ,27 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 27);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G25B88'
       ,28 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 28);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G50B0'
       ,29 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 29);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G50B100'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 30);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G50B50'
       ,31 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 31);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G50B75'
       ,32 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 32);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G50B88'
       ,33 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 33);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G75B0'
       ,34 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 34);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G75B100'
       ,35 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 35);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G75B50'
       ,36 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 36);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G75B75'
       ,37 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 37);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G75B88'
       ,38 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 38);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G88B0'
       ,39 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 39);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G88B100'
       ,40 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 40);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G88B50'
       ,41 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 41);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G88B75'
       ,42 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 42);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R0G88B88'
       ,43 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 43);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G0B0'
       ,44 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 44);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G0B100'
       ,45 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 45);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G0B50'
       ,46 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 46);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G0B75'
       ,47 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 47);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G0B88'
       ,48 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 48);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G100B0'
       ,49 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 49);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G100B100'
       ,50 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 50);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G100B50'
       ,51 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 51);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G100B75'
       ,52 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 52);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G100B88'
       ,53 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 53);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G25B0'
       ,54 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 54);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G25B100'
       ,55 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 55);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G25B50'
       ,56 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 56);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G25B75'
       ,57 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 57);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G25B88'
       ,58 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 58);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G50B0'
       ,59 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 59);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G50B100'
       ,60 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 60);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G50B50'
       ,61 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 61);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G50B75'
       ,62 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 62);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G50B88'
       ,63 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 63);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G75B0'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 64);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G75B100'
       ,65 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 65);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G75B50'
       ,66 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 66);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G75B75'
       ,67 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 67);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G75B88'
       ,68 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 68);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G88B0'
       ,69 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 69);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G88B100'
       ,70 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 70);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G88B50'
       ,71 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 71);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G88B75'
       ,72 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 72);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R100G88B88'
       ,73 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 73);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G0B0'
       ,74 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 74);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G0B100'
       ,75 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 75);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G0B50'
       ,76 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 76);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G0B75'
       ,77 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 77);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G0B88'
       ,78 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 78);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G100B0'
       ,79 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 79);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G100B100'
       ,80 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 80);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G100B50'
       ,81 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 81);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G100B75'
       ,82 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 82);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G100B88'
       ,83 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 83);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G25B0'
       ,84 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 84);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G25B100'
       ,85 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 85);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G25B50'
       ,86 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 86);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G25B75'
       ,87 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 87);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G25B88'
       ,88 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 88);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G50B0'
       ,89 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 89);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G50B100'
       ,90 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 90);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G50B50'
       ,91 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 91);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G50B75'
       ,92 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 92);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G50B88'
       ,93 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 93);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G75B0'
       ,94 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 94);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G75B100'
       ,95 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 95);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G75B50'
       ,96 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 96);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G75B75'
       ,97 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 97);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G75B88'
       ,98 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 98);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G88B0'
       ,99 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 99);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G88B100'
       ,100 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 100);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G88B50'
       ,101 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 101);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G88B75'
       ,102 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 102);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R25G88B88'
       ,103 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 103);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G0B0'
       ,104 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 104);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G0B100'
       ,105 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 105);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G0B50'
       ,106 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 106);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G0B75'
       ,107 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 107);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G50B50'
       ,108 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 108);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G50B75'
       ,109 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 109);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G50B88'
       ,110 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 110);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G75B0'
       ,111 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 111);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G75B100'
       ,112 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 112);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G75B50'
       ,113 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 113);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G75B75'
       ,114 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 114);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G75B88'
       ,115 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 115);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G88B0'
       ,116 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 116);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G88B100'
       ,117 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 117);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G88B50'
       ,118 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 118);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G88B75'
       ,119 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 119);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R50G88B88'
       ,120 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 120);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G0B0'
       ,121 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 121);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G0B100'
       ,122 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 122);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G0B50'
       ,123 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 123);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G0B75'
       ,124 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 124);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G0B88'
       ,125 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 125);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G100B0'
       ,126 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 126);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G100B100'
       ,127 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 127);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G100B50'
       ,128 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 128);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G100B75'
       ,129 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 129);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G100B88'
       ,130 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 130);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G25B0'
       ,131 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 131);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G25B100'
       ,132 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 132);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G25B50'
       ,133 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 133);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G25B75'
       ,134 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 134);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G25B88'
       ,135 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 135);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G50B0'
       ,136 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 136);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G50B100'
       ,137 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 137);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G50B50'
       ,138 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 138);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G50B75'
       ,139 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 139);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G50B88'
       ,140 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 140);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G75B0'
       ,141 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 141);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G75B100'
       ,142 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 142);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G75B50'
       ,143 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 143);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G75B75'
       ,144 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 144);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G75B88'
       ,145 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 145);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G88B0'
       ,146 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 146);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G88B100'
       ,147 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 147);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G88B50'
       ,148 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 148);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G88B75'
       ,149 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 149);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R75G88B88'
       ,150 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 150);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G0B0'
       ,151 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 151);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G0B100'
       ,152 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 152);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G0B50'
       ,153 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 153);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G0B75'
       ,154 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 154);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G0B88'
       ,155 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 155);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G100B0'
       ,156 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 156);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G100B100'
       ,157 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 157);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G100B50'
       ,158 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 158);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G100B75'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 159);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G100B88'
       ,160 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 160);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G25B0'
       ,161 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 161);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G25B100'
       ,162 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 162);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G25B50'
       ,163 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 163);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G25B75'
       ,164 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 164);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G25B88'
       ,165 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 165);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G50B0'
       ,166 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 166);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G50B100'
       ,167 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 167);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G50B50'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 168);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G50B75'
       ,169 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 169);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G50B88'
       ,170 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 170);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G75B0'
       ,171 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 171);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G75B100'
       ,172 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 172);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G75B50'
       ,173 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 173);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G75B75'
       ,174 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 174);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G75B88'
       ,175 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 175);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G88B0'
       ,176 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 176);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G88B100'
       ,177 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 177);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G88B50'
       ,178 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 178);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G88B75'
       ,179 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 179);
--
INSERT INTO COLOURS
       (COLOUR
       ,COL_ID
       )
SELECT 
        'R88G88B88'
       ,180 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM COLOURS
                   WHERE COL_ID = 180);
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_ADMIN_GROUPS
--
-- select * from nm3_metadata.nm_admin_groups
-- order by nag_parent_admin_unit
--         ,nag_child_admin_unit
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_admin_groups
SET TERM OFF

INSERT INTO NM_ADMIN_GROUPS
       (NAG_PARENT_ADMIN_UNIT
       ,NAG_CHILD_ADMIN_UNIT
       ,NAG_DIRECT_LINK
       )
SELECT 
        1
       ,1
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ADMIN_GROUPS
                   WHERE NAG_PARENT_ADMIN_UNIT = 1
                    AND  NAG_CHILD_ADMIN_UNIT = 1);
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_NODE_TYPES
--
-- select * from nm3_metadata.nm_node_types
-- order by nnt_type
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_node_types
SET TERM OFF

INSERT INTO NM_NODE_TYPES
       (NNT_TYPE
       ,NNT_NAME
       ,NNT_DESCR
       ,NNT_NO_NAME_FORMAT
       )
SELECT 
        'ROAD'
       ,'ROAD NODES'
       ,'Local And Classified Road Nodes'
       ,'000000000' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_NODE_TYPES
                   WHERE NNT_TYPE = 'ROAD');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_MAIL_GROUPS
--
-- select * from nm3_metadata.nm_mail_groups
-- order by nmg_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_mail_groups
SET TERM OFF

INSERT INTO NM_MAIL_GROUPS
       (NMG_ID
       ,NMG_NAME
       )
SELECT 
        0
       ,'All Mail Users' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_MAIL_GROUPS
                   WHERE NMG_ID = 0);
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_MAIL_USERS
--
-- select * from nm3_metadata.nm_mail_users
-- order by nmu_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_mail_users
SET TERM OFF

INSERT INTO NM_MAIL_USERS
       (NMU_ID
       ,NMU_NAME
       ,NMU_EMAIL_ADDRESS
       ,NMU_HUS_USER_ID
       )
SELECT 
        1
       ,'Network Manager 3'
       ,'nm3@yourdomain.com'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_MAIL_USERS
                   WHERE NMU_ID = 1);
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_EVENT_TYPES
--
-- select * from nm3_metadata.nm_event_types
-- order by net_type
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_event_types
SET TERM OFF

INSERT INTO NM_EVENT_TYPES
       (NET_TYPE
       ,NET_UNIQUE
       ,NET_DESCR
       )
SELECT 
        'ERRR'
       ,'ERROR'
       ,'Error' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_EVENT_TYPES
                   WHERE NET_TYPE = 'ERRR');
--
INSERT INTO NM_EVENT_TYPES
       (NET_TYPE
       ,NET_UNIQUE
       ,NET_DESCR
       )
SELECT 
        'GENR'
       ,'GENERIC'
       ,'NM3 Event' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_EVENT_TYPES
                   WHERE NET_TYPE = 'GENR');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_INV_CATEGORIES
--
-- select * from nm3_metadata.nm_inv_categories
-- order by nic_category
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_inv_categories
SET TERM OFF

INSERT INTO NM_INV_CATEGORIES
       (NIC_CATEGORY
       ,NIC_DESCR
       )
SELECT 
        'A'
       ,'Alert and Audit Metamodels' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORIES
                   WHERE NIC_CATEGORY = 'A');
--
INSERT INTO NM_INV_CATEGORIES
       (NIC_CATEGORY
       ,NIC_DESCR
       )
SELECT 
        'C'
       ,'Condition' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORIES
                   WHERE NIC_CATEGORY = 'C');
--
INSERT INTO NM_INV_CATEGORIES
       (NIC_CATEGORY
       ,NIC_DESCR
       )
SELECT 
        'D'
       ,'Derived (composite) Asset' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORIES
                   WHERE NIC_CATEGORY = 'D');
--
INSERT INTO NM_INV_CATEGORIES
       (NIC_CATEGORY
       ,NIC_DESCR
       )
SELECT 
        'F'
       ,'Foreign Table' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORIES
                   WHERE NIC_CATEGORY = 'F');
--
INSERT INTO NM_INV_CATEGORIES
       (NIC_CATEGORY
       ,NIC_DESCR
       )
SELECT 
        'G'
       ,'Additional Data Inventory' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORIES
                   WHERE NIC_CATEGORY = 'G');
--
INSERT INTO NM_INV_CATEGORIES
       (NIC_CATEGORY
       ,NIC_DESCR
       )
SELECT 
        'I'
       ,'General Inventory' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORIES
                   WHERE NIC_CATEGORY = 'I');
--
INSERT INTO NM_INV_CATEGORIES
       (NIC_CATEGORY
       ,NIC_DESCR
       )
SELECT 
        'X'
       ,'Generated Exclusive Inventory Type' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORIES
                   WHERE NIC_CATEGORY = 'X');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_INV_CATEGORY_MODULES
--
-- select * from nm3_metadata.nm_inv_category_modules
-- order by icm_nic_category
--         ,icm_hmo_module
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_inv_category_modules
SET TERM OFF

INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'C'
       ,'NM0510'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'C'
                    AND  ICM_HMO_MODULE = 'NM0510');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'C'
       ,'NM0560'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'C'
                    AND  ICM_HMO_MODULE = 'NM0560');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'C'
       ,'NM0570'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'C'
                    AND  ICM_HMO_MODULE = 'NM0570');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'C'
       ,'NM0575'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'C'
                    AND  ICM_HMO_MODULE = 'NM0575');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'C'
       ,'NM0590'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'C'
                    AND  ICM_HMO_MODULE = 'NM0590');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'D'
       ,'NM0510'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'D'
                    AND  ICM_HMO_MODULE = 'NM0510');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'D'
       ,'NM0560'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'D'
                    AND  ICM_HMO_MODULE = 'NM0560');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'D'
       ,'NM0570'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'D'
                    AND  ICM_HMO_MODULE = 'NM0570');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'D'
       ,'NM0575'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'D'
                    AND  ICM_HMO_MODULE = 'NM0575');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'D'
       ,'NM0590'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'D'
                    AND  ICM_HMO_MODULE = 'NM0590');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'F'
       ,'NM0510'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'F'
                    AND  ICM_HMO_MODULE = 'NM0510');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'F'
       ,'NM0560'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'F'
                    AND  ICM_HMO_MODULE = 'NM0560');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'F'
       ,'NM0570'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'F'
                    AND  ICM_HMO_MODULE = 'NM0570');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'F'
       ,'NM0590'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'F'
                    AND  ICM_HMO_MODULE = 'NM0590');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'G'
       ,'NM0105'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'G'
                    AND  ICM_HMO_MODULE = 'NM0105');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'G'
       ,'NM0110'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'G'
                    AND  ICM_HMO_MODULE = 'NM0110');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'G'
       ,'NM0115'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'G'
                    AND  ICM_HMO_MODULE = 'NM0115');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'G'
       ,'NM0510'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'G'
                    AND  ICM_HMO_MODULE = 'NM0510');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'G'
       ,'NM0560'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'G'
                    AND  ICM_HMO_MODULE = 'NM0560');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'G'
       ,'NM0570'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'G'
                    AND  ICM_HMO_MODULE = 'NM0570');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'G'
       ,'NM0590'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'G'
                    AND  ICM_HMO_MODULE = 'NM0590');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'I'
       ,'NM0510'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'I'
                    AND  ICM_HMO_MODULE = 'NM0510');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'I'
       ,'NM0560'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'I'
                    AND  ICM_HMO_MODULE = 'NM0560');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'I'
       ,'NM0570'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'I'
                    AND  ICM_HMO_MODULE = 'NM0570');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'I'
       ,'NM0575'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'I'
                    AND  ICM_HMO_MODULE = 'NM0575');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'I'
       ,'NM0590'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'I'
                    AND  ICM_HMO_MODULE = 'NM0590');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'X'
       ,'NM0510'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'X'
                    AND  ICM_HMO_MODULE = 'NM0510');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'X'
       ,'NM0560'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'X'
                    AND  ICM_HMO_MODULE = 'NM0560');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'X'
       ,'NM0570'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'X'
                    AND  ICM_HMO_MODULE = 'NM0570');
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT 
        'X'
       ,'NM0590'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'X'
                    AND  ICM_HMO_MODULE = 'NM0590');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_FILL_PATTERNS
--
-- select * from nm3_metadata.nm_fill_patterns
-- order by nfp_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_fill_patterns
SET TERM OFF

INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'ARROWS'
       ,'Arrows' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'ARROWS');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'BALLS'
       ,'Balls' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'BALLS');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'BAMBOO'
       ,'Bamboo' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'BAMBOO');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'BRICK'
       ,'Brick' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'BRICK');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'BRICKREV'
       ,'Brickrev' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'BRICKREV');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'BRICKSIDE'
       ,'Brickside' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'BRICKSIDE');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'BRICKSIDE2'
       ,'Brickside2' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'BRICKSIDE2');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'BRICKSIDEWAYS'
       ,'Bricksideways' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'BRICKSIDEWAYS');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'BUMPS'
       ,'Bumps' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'BUMPS');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'CARROT'
       ,'Carrot' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'CARROT');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'CARROT2'
       ,'Carrot2' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'CARROT2');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'CHAIR'
       ,'Chair' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'CHAIR');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'CHECKER'
       ,'Checker' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'CHECKER');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'CHECKER2'
       ,'Checker2' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'CHECKER2');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'CORN'
       ,'Corn' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'CORN');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'CRISSCROSS'
       ,'Crisscross' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'CRISSCROSS');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'CRISSCROSSTHIN'
       ,'Crisscrossthin' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'CRISSCROSSTHIN');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'CURVES1'
       ,'Curves1' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'CURVES1');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'DASHLINE'
       ,'Dashline' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'DASHLINE');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'DIAMOND'
       ,'Diamond' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'DIAMOND');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'DIAMONDDARK'
       ,'Diamonddark' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'DIAMONDDARK');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'DIAMONDS'
       ,'Diamonds' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'DIAMONDS');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'FANS'
       ,'Fans' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'FANS');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'FENCE'
       ,'Fence' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'FENCE');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'FLOWERS'
       ,'Flowers' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'FLOWERS');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'FLOWERS2'
       ,'Flowers2' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'FLOWERS2');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'GOLDCHAIN'
       ,'Goldchain' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'GOLDCHAIN');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'GRID'
       ,'Grid' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'GRID');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'GRIDTHIN'
       ,'Gridthin' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'GRIDTHIN');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'HLINES1'
       ,'Hlines1' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'HLINES1');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'HLINES2'
       ,'Hlines2' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'HLINES2');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'HLINES3'
       ,'Hlines3' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'HLINES3');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'HLINES4'
       ,'Hlines4' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'HLINES4');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'HLINES5'
       ,'Hlines5' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'HLINES5');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'HLINES6'
       ,'Hlines6' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'HLINES6');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'HLINES7'
       ,'Hlines7' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'HLINES7');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'HOPI'
       ,'Hopi' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'HOPI');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'KANGAROO'
       ,'Kangaroo' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'KANGAROO');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'LINOLEUM1'
       ,'Linoleum1' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'LINOLEUM1');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'LINOLEUM2'
       ,'Linoleum2' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'LINOLEUM2');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'LINOLEUM3'
       ,'Linoleum3' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'LINOLEUM3');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'LOOPS'
       ,'Loops' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'LOOPS');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'MEDBOX'
       ,'Medbox' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'MEDBOX');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'MEDLINE135'
       ,'Medline135' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'MEDLINE135');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'MEDLINE45'
       ,'Medline45' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'MEDLINE45');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'MULTIMED45'
       ,'Multimed45' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'MULTIMED45');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'MULTITHIN45'
       ,'Multithin45' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'MULTITHIN45');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'PAGODAS'
       ,'Pagodas' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'PAGODAS');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'PLAID'
       ,'Plaid' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'PLAID');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'POWDER'
       ,'Powder' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'POWDER');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'REVCRISSTHICK'
       ,'Revcrissthick' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'REVCRISSTHICK');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'REVCRISSTHIN'
       ,'Revcrissthin' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'REVCRISSTHIN');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'REVGRID'
       ,'Revgrid' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'REVGRID');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'REVSQUARES'
       ,'Revsquares' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'REVSQUARES');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'SANDPAPER'
       ,'Sandpaper' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'SANDPAPER');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'SHINGLES'
       ,'Shingles' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'SHINGLES');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'SPECS'
       ,'Specs' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'SPECS');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'SPIKES'
       ,'Spikes' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'SPIKES');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'SQUARES'
       ,'Squares' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'SQUARES');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'STITCHING'
       ,'Stitching' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'STITCHING');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'SWEATERPATTERN'
       ,'Sweaterpattern' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'SWEATERPATTERN');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'THICKBOX'
       ,'Thickbox' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'THICKBOX');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'THICKLINE45'
       ,'Thickline45' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'THICKLINE45');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'THINBOX'
       ,'Thinbox' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'THINBOX');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'THINLINE135'
       ,'Thinline135' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'THINLINE135');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'TILE1'
       ,'Tile1' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'TILE1');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'TRANSPARENT'
       ,'Transparent' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'TRANSPARENT');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'V45WAVES'
       ,'V45waves' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'V45WAVES');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'VDASHLINE'
       ,'Vdashline' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'VDASHLINE');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'VLINES1'
       ,'Vlines1' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'VLINES1');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'VLINES2'
       ,'Vlines2' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'VLINES2');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'VLINES3'
       ,'Vlines3' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'VLINES3');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'VLINES4'
       ,'Vlines4' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'VLINES4');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'VLINES5'
       ,'Vlines5' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'VLINES5');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'VLINES6'
       ,'Vlines6' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'VLINES6');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'VLINES7'
       ,'Vlines7' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'VLINES7');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'WALKER'
       ,'Walker' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'WALKER');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'WAVE45'
       ,'Wave45' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'WAVE45');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'WAVES'
       ,'Waves' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'WAVES');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'WAVY'
       ,'Wavy' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'WAVY');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'WAVY2'
       ,'Wavy2' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'WAVY2');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'WEAVE1'
       ,'Weaves1' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'WEAVE1');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'WEAVE2'
       ,'Weaves2' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'WEAVE2');
--
INSERT INTO NM_FILL_PATTERNS
       (NFP_ID
       ,NFP_DESCR
       )
SELECT 
        'WEAVE3'
       ,'Weaves3' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_FILL_PATTERNS
                   WHERE NFP_ID = 'WEAVE3');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_VISUAL_ATTRIBUTES
--
-- select * from nm3_metadata.nm_visual_attributes
-- order by nva_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_visual_attributes
SET TERM OFF

INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_1'
       ,'R0G100B0'
       ,100
       ,100
       ,100
       ,0
       ,100
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_1');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_10'
       ,'R50G25B75'
       ,0
       ,0
       ,0
       ,50
       ,25
       ,75
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_10');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_100'
       ,'R25G88B100'
       ,0
       ,0
       ,0
       ,25
       ,88
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_100');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_11'
       ,'R50G25B88'
       ,0
       ,0
       ,0
       ,50
       ,25
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_11');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_12'
       ,'R50G50B0'
       ,100
       ,100
       ,100
       ,50
       ,50
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_12');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_13'
       ,'R50G50B100'
       ,0
       ,0
       ,0
       ,50
       ,50
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_13');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_14'
       ,'R0G0B0'
       ,100
       ,100
       ,100
       ,0
       ,0
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_14');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_15'
       ,'R0G0B100'
       ,100
       ,100
       ,100
       ,0
       ,0
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_15');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_16'
       ,'R0G0B50'
       ,100
       ,100
       ,100
       ,0
       ,0
       ,50
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_16');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_17'
       ,'R0G0B75'
       ,100
       ,100
       ,100
       ,0
       ,0
       ,75
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_17');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_18'
       ,'R0G0B88'
       ,100
       ,100
       ,100
       ,0
       ,0
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_18');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_19'
       ,'R50G25B0'
       ,100
       ,100
       ,100
       ,50
       ,25
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_19');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_2'
       ,'R0G100B50'
       ,0
       ,0
       ,0
       ,0
       ,100
       ,50
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_2');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_20'
       ,'R50G25B100'
       ,0
       ,0
       ,0
       ,50
       ,25
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_20');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_21'
       ,'R50G25B50'
       ,100
       ,100
       ,100
       ,50
       ,25
       ,50
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_21');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_22'
       ,'R0G100B75'
       ,0
       ,0
       ,0
       ,0
       ,100
       ,75
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_22');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_23'
       ,'R0G100B88'
       ,0
       ,0
       ,0
       ,0
       ,100
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_23');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_24'
       ,'R0G25B0'
       ,100
       ,100
       ,100
       ,0
       ,25
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_24');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_25'
       ,'R0G25B100'
       ,100
       ,100
       ,100
       ,0
       ,25
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_25');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_26'
       ,'R0G25B50'
       ,100
       ,100
       ,100
       ,0
       ,25
       ,50
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_26');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_27'
       ,'R0G25B75'
       ,100
       ,100
       ,100
       ,0
       ,25
       ,75
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_27');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_28'
       ,'R0G25B88'
       ,100
       ,100
       ,100
       ,0
       ,25
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_28');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_29'
       ,'R0G50B0'
       ,100
       ,100
       ,100
       ,0
       ,50
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_29');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_3'
       ,'R0G100B100'
       ,0
       ,0
       ,0
       ,0
       ,100
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_3');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_30'
       ,'R0G50B100'
       ,0
       ,0
       ,0
       ,0
       ,50
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_30');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_31'
       ,'R0G50B50'
       ,100
       ,100
       ,100
       ,0
       ,50
       ,50
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_31');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_32'
       ,'R0G50B75'
       ,100
       ,100
       ,100
       ,0
       ,50
       ,75
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_32');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_33'
       ,'R0G50B88'
       ,100
       ,100
       ,100
       ,0
       ,50
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_33');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_34'
       ,'R0G75B0'
       ,100
       ,100
       ,100
       ,0
       ,75
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_34');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_35'
       ,'R0G75B100'
       ,0
       ,0
       ,0
       ,0
       ,75
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_35');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_36'
       ,'R0G75B50'
       ,100
       ,100
       ,100
       ,0
       ,75
       ,50
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_36');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_37'
       ,'R0G75B75'
       ,0
       ,0
       ,0
       ,0
       ,75
       ,75
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_37');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_38'
       ,'R0G75B88'
       ,0
       ,0
       ,0
       ,0
       ,75
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_38');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_39'
       ,'R0G88B0'
       ,100
       ,100
       ,100
       ,0
       ,88
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_39');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_4'
       ,'R50G100B0'
       ,0
       ,0
       ,0
       ,50
       ,100
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_4');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_40'
       ,'R0G88B100'
       ,0
       ,0
       ,0
       ,0
       ,88
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_40');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_41'
       ,'R0G88B50'
       ,100
       ,100
       ,100
       ,0
       ,88
       ,50
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_41');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_42'
       ,'R0G88B75'
       ,0
       ,0
       ,0
       ,0
       ,88
       ,75
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_42');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_43'
       ,'R0G88B88'
       ,0
       ,0
       ,0
       ,0
       ,88
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_43');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_44'
       ,'R100G0B0'
       ,100
       ,100
       ,100
       ,100
       ,0
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_44');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_45'
       ,'R100G0B100'
       ,0
       ,0
       ,0
       ,100
       ,0
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_45');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_46'
       ,'R100G0B50'
       ,0
       ,0
       ,0
       ,100
       ,0
       ,50
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_46');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_47'
       ,'R100G0B75'
       ,0
       ,0
       ,0
       ,100
       ,0
       ,75
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_47');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_48'
       ,'R100G0B88'
       ,0
       ,0
       ,0
       ,100
       ,0
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_48');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_49'
       ,'R100G100B0'
       ,0
       ,0
       ,0
       ,100
       ,100
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_49');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_5'
       ,'R50G100B50'
       ,0
       ,0
       ,0
       ,50
       ,100
       ,50
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_5');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_50'
       ,'R100G100B100'
       ,0
       ,0
       ,0
       ,100
       ,100
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_50');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_51'
       ,'R100G100B50'
       ,0
       ,0
       ,0
       ,100
       ,100
       ,50
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_51');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_52'
       ,'R100G100B75'
       ,0
       ,0
       ,0
       ,100
       ,100
       ,75
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_52');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_53'
       ,'R100G100B88'
       ,0
       ,0
       ,0
       ,100
       ,100
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_53');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_54'
       ,'R100G25B0'
       ,100
       ,100
       ,100
       ,100
       ,25
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_54');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_55'
       ,'R100G25B100'
       ,0
       ,0
       ,0
       ,100
       ,25
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_55');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_56'
       ,'R100G25B50'
       ,0
       ,0
       ,0
       ,100
       ,25
       ,50
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_56');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_57'
       ,'R100G25B75'
       ,0
       ,0
       ,0
       ,100
       ,25
       ,75
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_57');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_58'
       ,'R100G25B88'
       ,0
       ,0
       ,0
       ,100
       ,25
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_58');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_59'
       ,'R100G50B0'
       ,0
       ,0
       ,0
       ,100
       ,50
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_59');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_6'
       ,'R50G100B75'
       ,0
       ,0
       ,0
       ,50
       ,100
       ,75
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_6');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_60'
       ,'R100G50B100'
       ,0
       ,0
       ,0
       ,100
       ,50
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_60');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_61'
       ,'R100G50B50'
       ,0
       ,0
       ,0
       ,100
       ,50
       ,50
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_61');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_62'
       ,'R100G50B75'
       ,0
       ,0
       ,0
       ,100
       ,50
       ,75
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_62');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_63'
       ,'R100G50B88'
       ,0
       ,0
       ,0
       ,100
       ,50
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_63');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_64'
       ,'R100G75B0'
       ,0
       ,0
       ,0
       ,100
       ,75
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_64');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_65'
       ,'R100G75B100'
       ,0
       ,0
       ,0
       ,100
       ,75
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_65');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_66'
       ,'R100G75B50'
       ,0
       ,0
       ,0
       ,100
       ,75
       ,50
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_66');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_67'
       ,'R100G75B75'
       ,0
       ,0
       ,0
       ,100
       ,75
       ,75
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_67');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_68'
       ,'R100G75B88'
       ,0
       ,0
       ,0
       ,100
       ,75
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_68');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_69'
       ,'R100G88B0'
       ,0
       ,0
       ,0
       ,100
       ,88
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_69');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_7'
       ,'R50G100B88'
       ,0
       ,0
       ,0
       ,50
       ,100
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_7');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_70'
       ,'R100G88B100'
       ,0
       ,0
       ,0
       ,100
       ,88
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_70');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_71'
       ,'R100G88B50'
       ,0
       ,0
       ,0
       ,100
       ,88
       ,50
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_71');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_72'
       ,'R100G88B75'
       ,0
       ,0
       ,0
       ,100
       ,88
       ,75
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_72');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_73'
       ,'R100G88B88'
       ,0
       ,0
       ,0
       ,100
       ,88
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_73');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_74'
       ,'R25G0B0'
       ,100
       ,100
       ,100
       ,25
       ,0
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_74');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_75'
       ,'R25G0B100'
       ,100
       ,100
       ,100
       ,25
       ,0
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_75');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_76'
       ,'R25G0B50'
       ,100
       ,100
       ,100
       ,25
       ,0
       ,50
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_76');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_77'
       ,'R25G0B75'
       ,100
       ,100
       ,100
       ,25
       ,0
       ,75
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_77');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_78'
       ,'R25G0B88'
       ,100
       ,100
       ,100
       ,25
       ,0
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_78');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_79'
       ,'R25G100B0'
       ,100
       ,100
       ,100
       ,25
       ,100
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_79');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_8'
       ,'R50G100B100'
       ,0
       ,0
       ,0
       ,50
       ,100
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_8');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_80'
       ,'R25G100B100'
       ,0
       ,0
       ,0
       ,25
       ,100
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_80');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_81'
       ,'R25G100B50'
       ,0
       ,0
       ,0
       ,25
       ,100
       ,50
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_81');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_82'
       ,'R25G100B75'
       ,0
       ,0
       ,0
       ,25
       ,100
       ,75
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_82');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_83'
       ,'R25G100B88'
       ,0
       ,0
       ,0
       ,25
       ,100
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_83');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_84'
       ,'R25G25B0'
       ,100
       ,100
       ,100
       ,25
       ,25
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_84');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_85'
       ,'R25G25B100'
       ,0
       ,0
       ,0
       ,25
       ,25
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_85');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_86'
       ,'R25G25B50'
       ,100
       ,100
       ,100
       ,25
       ,25
       ,50
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_86');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_87'
       ,'R25G25B75'
       ,100
       ,100
       ,100
       ,25
       ,25
       ,75
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_87');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_88'
       ,'R25G25B88'
       ,100
       ,100
       ,100
       ,25
       ,25
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_88');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_89'
       ,'R25G50B0'
       ,100
       ,100
       ,100
       ,25
       ,50
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_89');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_9'
       ,'R50G0B88'
       ,100
       ,100
       ,100
       ,50
       ,0
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_9');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_90'
       ,'R25G50B100'
       ,0
       ,0
       ,0
       ,25
       ,50
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_90');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_91'
       ,'R25G50B50'
       ,100
       ,100
       ,100
       ,25
       ,50
       ,50
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_91');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_92'
       ,'R25G50B75'
       ,0
       ,0
       ,0
       ,25
       ,50
       ,75
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_92');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_93'
       ,'R25G50B88'
       ,0
       ,0
       ,0
       ,25
       ,50
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_93');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_94'
       ,'R25G75B0'
       ,100
       ,100
       ,100
       ,25
       ,75
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_94');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_95'
       ,'R25G75B100'
       ,0
       ,0
       ,0
       ,25
       ,75
       ,100
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_95');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_96'
       ,'R25G75B50'
       ,0
       ,0
       ,0
       ,25
       ,75
       ,50
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_96');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_97'
       ,'R25G75B75'
       ,0
       ,0
       ,0
       ,25
       ,75
       ,75
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_97');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_98'
       ,'R25G75B88'
       ,0
       ,0
       ,0
       ,25
       ,75
       ,88
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_98');
--
INSERT INTO NM_VISUAL_ATTRIBUTES
       (NVA_ID
       ,NVA_DESCR
       ,NVA_FG_RED
       ,NVA_FG_GREEN
       ,NVA_FG_BLUE
       ,NVA_BG_RED
       ,NVA_BG_GREEN
       ,NVA_BG_BLUE
       ,NVA_NFP_ID
       )
SELECT 
        'VA_99'
       ,'R25G88B0'
       ,100
       ,100
       ,100
       ,25
       ,88
       ,0
       ,'TRANSPARENT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_VISUAL_ATTRIBUTES
                   WHERE NVA_ID = 'VA_99');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_AU_TYPES
--
-- select * from nm3_metadata.nm_au_types
-- order by nat_admin_type
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_au_types
SET TERM OFF

INSERT INTO NM_AU_TYPES
       (NAT_ADMIN_TYPE
       ,NAT_DESCR
       ,NAT_DATE_CREATED
       ,NAT_DATE_MODIFIED
       ,NAT_MODIFIED_BY
       ,NAT_CREATED_BY
       )
SELECT 
        'EXT$'
       ,'Admin Type for Navigator, Audit and Alert Meta Models'
       ,to_date('20100525100858','YYYYMMDDHH24MISS')
       ,to_date('20100525100858','YYYYMMDDHH24MISS')
       ,'NM3_METADATA'
       ,'NM3_METADATA' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_AU_TYPES
                   WHERE NAT_ADMIN_TYPE = 'EXT$');
--
INSERT INTO NM_AU_TYPES
       (NAT_ADMIN_TYPE
       ,NAT_DESCR
       ,NAT_DATE_CREATED
       ,NAT_DATE_MODIFIED
       ,NAT_MODIFIED_BY
       ,NAT_CREATED_BY
       )
SELECT 
        'NETW'
       ,'Network Default AU Type'
       ,to_date('20000815000000','YYYYMMDDHH24MISS')
       ,to_date('20000815000000','YYYYMMDDHH24MISS')
       ,'NM31'
       ,'NM31' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_AU_TYPES
                   WHERE NAT_ADMIN_TYPE = 'NETW');
--
--
--
----------------------------------------------------------------------------------------

--
COMMIT;
--
set feedback on
set define on
--
-------------------------------
-- END OF GENERATED METADATA --
-------------------------------
--
