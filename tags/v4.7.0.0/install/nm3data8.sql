-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3data8.sql-arc   2.21   Jul 11 2013 10:59:54   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3data8.sql  $
--       Date into PVCS   : $Date:   Jul 11 2013 10:59:54  $
--       Date fetched Out : $Modtime:   Jul 11 2013 10:52:50  $
--       Version          : $Revision:   2.21  $
--       Table Owner      : NM3_METADATA
--       Generation Date  : 25-MAR-2011 09:31
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--   Product metadata script
--   As at Release 4.4.0.0
--
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
--
--   TABLES PROCESSED
--   ================
--   USER_SDO_STYLES
--   NM_LAYER_TREE
--   NM_INV_TYPES_ALL
--   NM_INV_TYPE_ATTRIBS_ALL
--   NM_INV_TYPE_ROLES
--   NM_SDE_SUB_LAYER_EXEMPT
--
-----------------------------------------------------------------------------


set define off;
set feedback off;

---------------------------------
-- START OF GENERATED METADATA --
---------------------------------


----------------------------------------------------------------------------------------
-- USER_SDO_STYLES
--
-- select * from nm3_metadata.user_sdo_styles
-- order by name
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT user_sdo_styles
SET TERM OFF

INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'C.BLACK'
       ,'COLOR'
       ,'Black'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="color" style="fill:#000000">'||CHR(10)||'<rect width="50" height="50"/></g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'C.BLACK');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'C.BLUE'
       ,'COLOR'
       ,'Blue'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="color" style="fill:#0000ff">'||CHR(10)||'<rect width="50" height="50"/></g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'C.BLUE');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'C.CHARCOAL W/ ROSY BROWN BORDER'
       ,'COLOR'
       ,'Charcoal (gray-black) with rosy brown border'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="color" style="stroke:#bc8f8f;fill:#808080">'||CHR(10)||'<rect width="50" height="50"/></g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'C.CHARCOAL W/ ROSY BROWN BORDER');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'C.COUNTIES'
       ,'COLOR'
       ,''
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="color" style="stroke:#003333;fill:#ffffcc">'||CHR(10)||'<rect width="50" height="50"/></g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'C.COUNTIES');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'C.LIGHT YELLOW W/ GRAY BORDER'
       ,'COLOR'
       ,'Light yellow (for map background) with gray border'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="color" style="stroke:#aaaaaa;fill:#ffffce">'||CHR(10)||'<rect width="50" height="50"/></g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'C.LIGHT YELLOW W/ GRAY BORDER');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'C.PARK FOREST'
       ,'COLOR'
       ,'Green for park or forest'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="color" style="fill:#adcda3">'||CHR(10)||'<rect width="50" height="50"/></g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'C.PARK FOREST');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'C.RED'
       ,'COLOR'
       ,'Red'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="color" style="fill:#ff1100">'||CHR(10)||'<rect width="50" height="50"/></g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'C.RED');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'C.RED W/ BLACK BORDER'
       ,'COLOR'
       ,'Red (slight orange) with black border'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="color" style="stroke:#000000;fill:#ee1100">'||CHR(10)||'<rect width="50" height="50"/></g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'C.RED W/ BLACK BORDER');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'C.ROSY BROWN'
       ,'COLOR'
       ,'Rosy brown'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="color" style="fill:#bc8f8f">'||CHR(10)||'<rect width="50" height="50"/></g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'C.ROSY BROWN');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'C.ROSY BROWN STROKE'
       ,'COLOR'
       ,'Rosy brown stroke'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="color" style="stroke:#bc8f8f">'||CHR(10)||'<rect width="50" height="50"/></g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'C.ROSY BROWN STROKE');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'C.SANDY BROWN'
       ,'COLOR'
       ,'Sandy (yellowish) brown'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="color" style="fill:#f4a460">'||CHR(10)||'<rect width="50" height="50"/></g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'C.SANDY BROWN');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'C.US MAP YELLOW'
       ,'COLOR'
       ,'Yellow main color for US maps'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="color" style="stroke:#bb99bb;fill:#ffffcc">'||CHR(10)||'<rect width="50" height="50"/></g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'C.US MAP YELLOW');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'C.WATER'
       ,'COLOR'
       ,'Aqua blue (color for rendering water)'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="color" style="fill:#a6caf0">'||CHR(10)||'<rect width="50" height="50"/></g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'C.WATER');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'C.WHEAT'
       ,'COLOR'
       ,'Wheat'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="color" style="fill:#f5deb3">'||CHR(10)||'<rect width="50" height="50"/></g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'C.WHEAT');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'C.WHITE'
       ,'COLOR'
       ,'White'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="color" style="stroke:#ffffff">'||CHR(10)||'<rect width="50" height="50"/></g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'C.WHITE');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'C.YELLOW'
       ,'COLOR'
       ,'Yellow'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="color" style="fill:#ffff00">'||CHR(10)||'<rect width="50" height="50"/></g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'C.YELLOW');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'L.DPH'
       ,'LINE'
       ,'Divided primary highway'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="line" style="fill:#ffff00;stroke-width:5">'||CHR(10)||'<line class="parallel" style="fill:#ff0000;stroke-width:1.0" />'||CHR(10)||'<line class="base" style="fill:black;stroke-width:1.0" dash="10.0,4.0" />'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'L.DPH');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'L.FERRY'
       ,'LINE'
       ,'Ferry line'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="line" style="stroke-width:1">'||CHR(10)||'<line class="base" style="fill:#000066;stroke-width:1.0" dash="5.0,3.0" />'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'L.FERRY');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'L.LIGHT DUTY'
       ,'LINE'
       ,'Light duty road'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="line" style="fill:#404040;stroke-width:2">'||CHR(10)||'<line class="base" /></g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'L.LIGHT DUTY');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'L.MAJOR STREET'
       ,'LINE'
       ,'Major street'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="line" style="fill:#ff4040;stroke-width:2">'||CHR(10)||'<line class="base" /></g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'L.MAJOR STREET');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'L.MAJOR TOLL ROAD'
       ,'LINE'
       ,'Major toll road'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="line" style="fill:#006600;stroke-width:4;stroke-linecap:SQUARE">'||CHR(10)||'<line class="parallel" style="fill:#99ffff;stroke-width:1.0" />'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'L.MAJOR TOLL ROAD');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'L.PH'
       ,'LINE'
       ,'Primary highway'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="line" style="fill:#33a9ff;stroke-width:4">'||CHR(10)||'<line class="parallel" style="fill:#aa55cc;stroke-width:1.0" />'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'L.PH');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'L.RAILROAD'
       ,'LINE'
       ,'Railroad'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="line" style="fill:#003333;stroke-width:1">'||CHR(10)||'<line class="hashmark" style="fill:#003333"  dash="8.5,3.0" />'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'L.RAILROAD');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'L.RAMP'
       ,'LINE'
       ,'Ramp (highway entrance or exit)'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="line" style="fill:#ffc800;stroke-width:2">'||CHR(10)||'<line class="base" style="fill:#998899;stroke-width:2.0" />'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'L.RAMP');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'L.SH'
       ,'LINE'
       ,'Secondary highway'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="line" style="fill:#ffc800;stroke-width:2">'||CHR(10)||'<line class="base" style="fill:#998899;stroke-width:2.0" />'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'L.SH');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'L.STATE BOUNDARY'
       ,'LINE'
       ,'State boundary'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="line" style="fill:#bb99bb;stroke-width:5">'||CHR(10)||'<line class="base" style="fill:#0000ff;stroke-width:1.0" dash="8.0,4.0" />'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'L.STATE BOUNDARY');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'L.STREET'
       ,'LINE'
       ,'Street'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="line" style="fill:#a0a0a0;stroke-width:1">'||CHR(10)||'<line class="base" /></g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'L.STREET');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'L.TOLL'
       ,'LINE'
       ,'Primary toll highway'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="line" style="fill:#66ff66;stroke-width:4">'||CHR(10)||'<line class="parallel" style="fill:#66ff33;stroke-width:1.0" />'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'L.TOLL');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'M.CIRCLE'
       ,'MARKER'
       ,'Circle (red with blue border)'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="marker"  style="stroke:#0000ff;fill:#ff0000">'||CHR(10)||'<circle cx="0" cy="0" r="40.0" />'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'M.CIRCLE');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'M.HEXAGON'
       ,'MARKER'
       ,'Hexagon (red with black border)'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="marker"  style="stroke:#000000;fill:#ff0000">'||CHR(10)||'<polygon points="50.0,199.0, 0.0,100.0, 50.0,1.0, 149.0,1.0, 199.0,100.0, 149.0,199.0" />'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'M.HEXAGON');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'M.HOUSE'
       ,'MARKER'
       ,'Simple house'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="marker"  style="stroke:#000000;fill:#666666;width:19;height:15">'||CHR(10)||'<polygon points="20.0,10.0, 25.0,10.0, 30.0,6.0, 36.0,10.0, 40.0,10.0,'||CHR(10)||'40.0,19.0, 20.0,19.0, 20.0,10.0" />'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'M.HOUSE');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'M.PENTAGON'
       ,'MARKER'
       ,'Pentagon (yellow with blue border)'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="marker"  style="stroke:#0000ff;fill:#ffff00">'||CHR(10)||'<polygon points="38.0,199.0, 0.0,77.0, 100.0,1.0, 200.0,77.0, 162.0,199.0" />'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'M.PENTAGON');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'M.REDSQ'
       ,'MARKER'
       ,'Square (red wih black border)'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="marker"  style="stroke:#000000;fill:#ff0000">'||CHR(10)||'<polygon points="0.0,0.0, 0.0,100.0, 100.0,100.0, 100.0,0.0, 0.0,0.0" />'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'M.REDSQ');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'M.STAR'
       ,'MARKER'
       ,'Star (red with black border)'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="marker"  style="stroke:#000000;fill:#ff0000;width:15;height:15">'||CHR(10)||'<polygon points="138.0,123.0, 161.0,198.0, 100.0,152.0, 38.0,198.0, 61.0,123.0,'||CHR(10)||'0.0,76.0, 76.0,76.0, 100.0,0.0, 123.0,76.0, 199.0,76.0" />'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'M.STAR');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'M.TRIANGLE'
       ,'MARKER'
       ,'Triangle (medium blue with blue border'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="marker"  style="stroke:#0000ff;fill:#6666ff">'||CHR(10)||'<polygon points="201.0,200.0, 0.0,200.0, 101.0,0.0" />'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'M.TRIANGLE');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'T.CITY NAME'
       ,'TEXT'
       ,'City name'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="text" style="font-style:plain;font-family:Dialog;font-size:12pt;font-weight:bold;fill:#000000">'||CHR(10)||' Hello World!'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'T.CITY NAME');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'T.ROAD NAME'
       ,'TEXT'
       ,'Road name'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="text" style="font-style:plain;font-family:Serif;font-size:11pt;font-weight:bold;fill:#000000">'||CHR(10)||' Hello World!'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'T.ROAD NAME');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'T.STATE NAME'
       ,'TEXT'
       ,'State name'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="text" style="font-style:plain;font-family:Dialog;font-size:14pt;font-weight:bold;fill:#0000ff">'||CHR(10)||' Hello World!'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'T.STATE NAME');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'T.STREET NAME'
       ,'TEXT'
       ,'Street name'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="text" style="font-style:plain;font-family:Dialog;font-size:10pt;fill:#0000ff">'||CHR(10)||' Hello World!'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'T.STREET NAME');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'T.TITLE'
       ,'TEXT'
       ,'Map title'
       ,'<?xml version="1.0" standalone="yes"?>'||CHR(10)||'<svg width="1in" height="1in">'||CHR(10)||'<desc></desc>'||CHR(10)||'<g class="text" style="font-style:plain;font-family:SansSerif;font-size:18pt;font-weight:bold;fill:#0000ff">'||CHR(10)||' Hello World!'||CHR(10)||'</g>'||CHR(10)||'</svg>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'T.TITLE');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'V.CIRCLES'
       ,'ADVANCED'
       ,'A sample circle series.'
       ,'<?xml version="1.0" ?>'||CHR(10)||'<AdvancedStyle>'||CHR(10)||'  <VariableMarkerStyle basemarker="MDSYS:M.CIRCLE" startsize="7" increment="4" >'||CHR(10)||'    <Buckets>'||CHR(10)||'      <RangedBucket seq="0" label="less than 4" high="4.0" />'||CHR(10)||'      <RangedBucket seq="1" label="4 - 5" low="4.0" high="5.0" />'||CHR(10)||'      <RangedBucket seq="2" label="5 - 6" low="5.0" high="6.0" />'||CHR(10)||'      <RangedBucket seq="3" label="6 - 7" low="6.0" high="7.0" />'||CHR(10)||'      <RangedBucket seq="4" label="7 and up" low="7.0" />'||CHR(10)||'    </Buckets>'||CHR(10)||'  </VariableMarkerStyle>'||CHR(10)||'</AdvancedStyle>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'V.CIRCLES');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'V.COLOR SERIES 1'
       ,'ADVANCED'
       ,'A sample color scheme'
       ,'<?xml version="1.0" ?>'||CHR(10)||'<AdvancedStyle>'||CHR(10)||'  <ColorSchemeStyle basecolor="#ffff00" strokecolor="#00aaaa">'||CHR(10)||'     <Buckets low="0.0" high="20000.0" nbuckets="10" />'||CHR(10)||'  </ColorSchemeStyle>'||CHR(10)||'</AdvancedStyle>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'V.COLOR SERIES 1');
--
INSERT INTO USER_SDO_STYLES
       (NAME
       ,TYPE
       ,DESCRIPTION
       ,DEFINITION
       )
SELECT 
        'V.COLOR SERIES 2'
       ,'ADVANCED'
       ,'A sample color scheme.'
       ,'<?xml version="1.0" ?>'||CHR(10)||'<AdvancedStyle>'||CHR(10)||'  <ColorSchemeStyle basecolor="#ff0000" strokecolor="#000000">'||CHR(10)||'     <Buckets low="0.0" high="100.0" nbuckets="6" />'||CHR(10)||'  </ColorSchemeStyle>'||CHR(10)||'</AdvancedStyle>' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM USER_SDO_STYLES
                   WHERE NAME = 'V.COLOR SERIES 2');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_LAYER_TREE
--
-- select * from nm3_metadata.nm_layer_tree
-- order by nltr_child
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_layer_tree
SET TERM OFF

INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ACC'
       ,'AC1'
       ,'Accidents Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'AC1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'ACC'
       ,'Accidents Manager'
       ,'F'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'ACC');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'AST'
       ,'AS1'
       ,'Asset Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'AS1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'AST'
       ,'Asset Manager'
       ,'F'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'AST');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'CLM'
       ,'CL1'
       ,'Street Lights Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'CL1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'CLM'
       ,'Street Lighting Manager'
       ,'F'
       ,40 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'CLM');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'CUS'
       ,'CU1'
       ,'Custom'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'CU1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'CUS'
       ,'Custom Layers'
       ,'F'
       ,10000 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'CUS');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'DOC'
       ,'DC1'
       ,'Document Theme'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'DC1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'DOC'
       ,'Documents Manager'
       ,'F'
       ,35 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'DOC');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ENQ'
       ,'EN1'
       ,'Enquiry Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'EN1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'ENQ'
       ,'Enquiry Manager'
       ,'F'
       ,50 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'ENQ');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'MAI'
       ,'MA1'
       ,'Defects Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'MA1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'MAI'
       ,'Maintenance Manager'
       ,'F'
       ,60 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'MAI');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'NET'
       ,'NE1'
       ,'Datum Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'NE1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'NET'
       ,'NE2'
       ,'Route Layer'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'NE2');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'NET'
       ,'NE3'
       ,'Node Layer'
       ,'M'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'NE3');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'NET'
       ,'Network Manager'
       ,'F'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'NET');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'NSG'
       ,'NS1'
       ,'NSG Layers'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'NS1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'NSG'
       ,'Street Gazetteer Manager'
       ,'F'
       ,90 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'NSG');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'CUS'
       ,'RG1'
       ,'Register Table As Theme'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'RG1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'TOP'
       ,'ROOT'
       ,'SDO Layers'
       ,'F'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'ROOT');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'STP'
       ,'SP1'
       ,'Schemes Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'SP1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'STR'
       ,'ST1'
       ,'Structure Items'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'ST1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'STP'
       ,'Schemes Manager'
       ,'F'
       ,100 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'STP');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'STR'
       ,'Structures Manager'
       ,'F'
       ,70 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'STR');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'SWR'
       ,'SW1'
       ,'Sites Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'SW1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'SWR'
       ,'Streetworks Manager'
       ,'F'
       ,80 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'SWR');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'TMA'
       ,'TM1'
       ,'TMA Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'TM1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'TMA'
       ,'Traffic Management Act'
       ,'F'
       ,130 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'TMA');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'MAI'
       ,'WOL'
       ,'Work Order Lines Layer'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'WOL');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_INV_TYPES_ALL
--
-- select * from nm3_metadata.nm_inv_types_all
-- order by nit_inv_type
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_inv_types_all
SET TERM OFF

INSERT INTO NM_INV_TYPES_ALL
       (NIT_INV_TYPE
       ,NIT_PNT_OR_CONT
       ,NIT_X_SECT_ALLOW_FLAG
       ,NIT_ELEC_DRAIN_CARR
       ,NIT_CONTIGUOUS
       ,NIT_REPLACEABLE
       ,NIT_EXCLUSIVE
       ,NIT_CATEGORY
       ,NIT_DESCR
       ,NIT_LINEAR
       ,NIT_USE_XY
       ,NIT_MULTIPLE_ALLOWED
       ,NIT_END_LOC_ONLY
       ,NIT_SCREEN_SEQ
       ,NIT_VIEW_NAME
       ,NIT_START_DATE
       ,NIT_END_DATE
       ,NIT_SHORT_DESCR
       ,NIT_FLEX_ITEM_FLAG
       ,NIT_TABLE_NAME
       ,NIT_LR_NE_COLUMN_NAME
       ,NIT_LR_ST_CHAIN
       ,NIT_LR_END_CHAIN
       ,NIT_ADMIN_TYPE
       ,NIT_ICON_NAME
       ,NIT_TOP
       ,NIT_FOREIGN_PK_COLUMN
       ,NIT_UPDATE_ALLOWED
       ,NIT_DATE_CREATED
       ,NIT_DATE_MODIFIED
       ,NIT_MODIFIED_BY
       ,NIT_CREATED_BY
       ,NIT_NOTES
       )
SELECT 
        'PRO$'
       ,'P'
       ,'N'
       ,'C'
       ,'N'
       ,'N'
       ,'N'
       ,'A'
       ,'Process Alerts'
       ,'N'
       ,'N'
       ,'N'
       ,'N'
       ,null
       ,'V_NM_PRO$'
       ,to_date('19010101000000','YYYYMMDDHH24MISS')
       ,null
       ,''
       ,'N'
       ,'HIG_PROCESS_ALERT_LOG'
       ,''
       ,''
       ,''
       ,'EXT$'
       ,''
       ,'N'
       ,'HPAL_ID'
       ,'Y'
       ,to_date('20101014141424','YYYYMMDDHH24MISS')
       ,to_date('20101014141424','YYYYMMDDHH24MISS')
       ,'NM3_METADATA'
       ,'NM3_METADATA'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPES_ALL
                   WHERE NIT_INV_TYPE = 'PRO$');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_INV_TYPE_ATTRIBS_ALL
--
-- select * from nm3_metadata.nm_inv_type_attribs_all
-- order by ita_inv_type
--         ,ita_attrib_name
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_inv_type_attribs_all
SET TERM OFF

INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       ,ITA_DISP_WIDTH
       ,ITA_INSPECTABLE
       ,ITA_CASE
       )
SELECT 
        'PRO$'
       ,'HPAL_ADMIN_UNIT'
       ,'N'
       ,2
       ,'N'
       ,'NUMBER'
       ,9
       ,null
       ,'Admin Unit ID'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'ADMIN_UNIT'
       ,'ADMIN_UNIT'
       ,to_date('20100505000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20100505173452','YYYYMMDDHH24MISS')
       ,to_date('20100505173452','YYYYMMDDHH24MISS')
       ,'DORSET'
       ,'DORSET'
       ,'select nau_unit_code,nau_name,nau_admin_unit'||CHR(10)||'  from nm_admin_units'
       ,'N'
       ,null
       ,'N'
       ,'UPPER' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'PRO$'
                    AND  ITA_ATTRIB_NAME = 'HPAL_ADMIN_UNIT');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       ,ITA_DISP_WIDTH
       ,ITA_INSPECTABLE
       ,ITA_CASE
       )
SELECT 
        'PRO$'
       ,'HPAL_CONTRACT_ID'
       ,'N'
       ,3
       ,'N'
       ,'VARCHAR2'
       ,10
       ,null
       ,'Contract ID'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'CON_ID'
       ,'CON_ID'
       ,to_date('20100505000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20100505173539','YYYYMMDDHH24MISS')
       ,to_date('20100505173539','YYYYMMDDHH24MISS')
       ,'DORSET'
       ,'DORSET'
       ,''
       ,'N'
       ,null
       ,'N'
       ,'MIXED' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'PRO$'
                    AND  ITA_ATTRIB_NAME = 'HPAL_CONTRACT_ID');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       ,ITA_DISP_WIDTH
       ,ITA_INSPECTABLE
       ,ITA_CASE
       )
SELECT 
        'PRO$'
       ,'HPAL_CON_CODE'
       ,'N'
       ,4
       ,'N'
       ,'VARCHAR2'
       ,10
       ,null
       ,'Contract Code'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'CON_CODE'
       ,'CON_CODE'
       ,to_date('20100505000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20100505173539','YYYYMMDDHH24MISS')
       ,to_date('20100505173539','YYYYMMDDHH24MISS')
       ,'DORSET'
       ,'DORSET'
       ,''
       ,'N'
       ,null
       ,'N'
       ,'MIXED' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'PRO$'
                    AND  ITA_ATTRIB_NAME = 'HPAL_CON_CODE');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       ,ITA_DISP_WIDTH
       ,ITA_INSPECTABLE
       ,ITA_CASE
       )
SELECT 
        'PRO$'
       ,'HPAL_CON_NAME'
       ,'N'
       ,5
       ,'N'
       ,'VARCHAR2'
       ,40
       ,null
       ,'Contractor Name'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'CON_NAME'
       ,'CON_NAME'
       ,to_date('20100505000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20100505173600','YYYYMMDDHH24MISS')
       ,to_date('20100505173600','YYYYMMDDHH24MISS')
       ,'DORSET'
       ,'DORSET'
       ,''
       ,'N'
       ,null
       ,'N'
       ,'MIXED' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'PRO$'
                    AND  ITA_ATTRIB_NAME = 'HPAL_CON_NAME');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       ,ITA_DISP_WIDTH
       ,ITA_INSPECTABLE
       ,ITA_CASE
       )
SELECT 
        'PRO$'
       ,'HPAL_EMAIL_BODY'
       ,'N'
       ,6
       ,'N'
       ,'VARCHAR2'
       ,500
       ,null
       ,'Text 2'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'TEXT_2'
       ,'TEXT_2'
       ,to_date('20100505000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20100505173636','YYYYMMDDHH24MISS')
       ,to_date('20100505173636','YYYYMMDDHH24MISS')
       ,'DORSET'
       ,'DORSET'
       ,''
       ,'N'
       ,null
       ,'N'
       ,'MIXED' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'PRO$'
                    AND  ITA_ATTRIB_NAME = 'HPAL_EMAIL_BODY');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       ,ITA_DISP_WIDTH
       ,ITA_INSPECTABLE
       ,ITA_CASE
       )
SELECT 
        'PRO$'
       ,'HPAL_EMAIL_SUBJECT'
       ,'N'
       ,7
       ,'N'
       ,'VARCHAR2'
       ,100
       ,null
       ,'Text 1'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'TEXT_1'
       ,'TEXT_1'
       ,to_date('20100505000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20100505173702','YYYYMMDDHH24MISS')
       ,to_date('20100505173702','YYYYMMDDHH24MISS')
       ,'DORSET'
       ,'DORSET'
       ,''
       ,'N'
       ,null
       ,'N'
       ,'MIXED' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'PRO$'
                    AND  ITA_ATTRIB_NAME = 'HPAL_EMAIL_SUBJECT');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       ,ITA_DISP_WIDTH
       ,ITA_INSPECTABLE
       ,ITA_CASE
       )
SELECT 
        'PRO$'
       ,'HPAL_ID'
       ,'N'
       ,1
       ,'N'
       ,'NUMBER'
       ,38
       ,null
       ,'Primary Key'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'ID'
       ,'ID'
       ,to_date('20100505000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20100505173432','YYYYMMDDHH24MISS')
       ,to_date('20100505173432','YYYYMMDDHH24MISS')
       ,'DORSET'
       ,'DORSET'
       ,''
       ,'N'
       ,null
       ,'N'
       ,'UPPER' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'PRO$'
                    AND  ITA_ATTRIB_NAME = 'HPAL_ID');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       ,ITA_DISP_WIDTH
       ,ITA_INSPECTABLE
       ,ITA_CASE
       )
SELECT 
        'PRO$'
       ,'HPAL_INITIATED_USER'
       ,'N'
       ,8
       ,'N'
       ,'VARCHAR2'
       ,30
       ,null
       ,'Initiator'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'INITIATOR'
       ,'INITIATOR'
       ,to_date('20100505000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20100505173800','YYYYMMDDHH24MISS')
       ,to_date('20100505173800','YYYYMMDDHH24MISS')
       ,'DORSET'
       ,'DORSET'
       ,'SELECT hus_initials,hus_name,hus_username'||CHR(10)||'    FROM hig_users'||CHR(10)||'    WHERE hus_end_date is null'
       ,'N'
       ,null
       ,'N'
       ,'MIXED' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'PRO$'
                    AND  ITA_ATTRIB_NAME = 'HPAL_INITIATED_USER');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       ,ITA_DISP_WIDTH
       ,ITA_INSPECTABLE
       ,ITA_CASE
       )
SELECT 
        'PRO$'
       ,'HPAL_JOB_RUN_SEQ'
       ,'N'
       ,13
       ,'N'
       ,'NUMBER'
       ,38
       ,null
       ,'Job Run Seq'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'JOB_RUN_SEQ'
       ,'JOB_RUN_SEQ'
       ,to_date('20100510000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20100510140714','YYYYMMDDHH24MISS')
       ,to_date('20100510140714','YYYYMMDDHH24MISS')
       ,'HIGHWAYS'
       ,'HIGHWAYS'
       ,''
       ,'N'
       ,null
       ,'N'
       ,'UPPER' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'PRO$'
                    AND  ITA_ATTRIB_NAME = 'HPAL_JOB_RUN_SEQ');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       ,ITA_DISP_WIDTH
       ,ITA_INSPECTABLE
       ,ITA_CASE
       )
SELECT 
        'PRO$'
       ,'HPAL_PROCESS_ID'
       ,'N'
       ,12
       ,'N'
       ,'NUMBER'
       ,38
       ,null
       ,'Process ID'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'Process_ID'
       ,'Process_ID'
       ,to_date('20100505000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20100505174040','YYYYMMDDHH24MISS')
       ,to_date('20100505174040','YYYYMMDDHH24MISS')
       ,'DORSET'
       ,'DORSET'
       ,''
       ,'N'
       ,null
       ,'N'
       ,'MIXED' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'PRO$'
                    AND  ITA_ATTRIB_NAME = 'HPAL_PROCESS_ID');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       ,ITA_DISP_WIDTH
       ,ITA_INSPECTABLE
       ,ITA_CASE
       )
SELECT 
        'PRO$'
       ,'HPAL_PROCESS_TYPE_ID'
       ,'N'
       ,9
       ,'N'
       ,'NUMBER'
       ,38
       ,null
       ,'Process Type ID'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'PROCESS_TYPE'
       ,'PROCESS_TYPE'
       ,to_date('20100505000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20100505173829','YYYYMMDDHH24MISS')
       ,to_date('20100505173947','YYYYMMDDHH24MISS')
       ,'DORSET'
       ,'DORSET'
       ,'SELECT HPT_NAME,HPT_DESCR,HPT_PROCESS_TYPE_ID FROM HIG_PROCESS_TYPES'||CHR(10)||'ORDER BY HPT_NAME'
       ,'N'
       ,null
       ,'N'
       ,'UPPER' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'PRO$'
                    AND  ITA_ATTRIB_NAME = 'HPAL_PROCESS_TYPE_ID');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       ,ITA_DISP_WIDTH
       ,ITA_INSPECTABLE
       ,ITA_CASE
       )
SELECT 
        'PRO$'
       ,'HPAL_SUCCESS_FLAG'
       ,'N'
       ,14
       ,'N'
       ,'VARCHAR2'
       ,1
       ,null
       ,'Outcome'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'OUTCOME'
       ,'OUTCOME'
       ,to_date('20100510000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20100510140805','YYYYMMDDHH24MISS')
       ,to_date('20100510141118','YYYYMMDDHH24MISS')
       ,'HIGHWAYS'
       ,'HIGHWAYS'
       ,'SELECT HCO_CODE,HCO_MEANING,HCO_CODE CODE FROM HIG_CODES WHERE'||CHR(10)||'HCO_DOMAIN = ''PROCESS_SUCCESS_FLAG'' AND HCO_CODE != ''TBD'''||CHR(10)||'ORDER BY HCO_SEQ'
       ,'N'
       ,null
       ,'N'
       ,'MIXED' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'PRO$'
                    AND  ITA_ATTRIB_NAME = 'HPAL_SUCCESS_FLAG');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       ,ITA_DISP_WIDTH
       ,ITA_INSPECTABLE
       ,ITA_CASE
       )
SELECT 
        'PRO$'
       ,'HPAL_UNIT_CODE'
       ,'N'
       ,10
       ,'N'
       ,'VARCHAR2'
       ,10
       ,null
       ,'Admin Unit Code'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'UNIT_CODE'
       ,'UNIT_CODE'
       ,to_date('20100505000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20100505174040','YYYYMMDDHH24MISS')
       ,to_date('20100505174040','YYYYMMDDHH24MISS')
       ,'DORSET'
       ,'DORSET'
       ,'SELECT nau_unit_code,nau_name,nau_unit_code'||CHR(10)||'    FROM   nm_admin_units'
       ,'N'
       ,null
       ,'N'
       ,'MIXED' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'PRO$'
                    AND  ITA_ATTRIB_NAME = 'HPAL_UNIT_CODE');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       ,ITA_DISP_WIDTH
       ,ITA_INSPECTABLE
       ,ITA_CASE
       )
SELECT 
        'PRO$'
       ,'HPAL_UNIT_NAME'
       ,'N'
       ,11
       ,'N'
       ,'VARCHAR2'
       ,40
       ,null
       ,'Admin Unit Name'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'UNIT_NAME'
       ,'UNIT_NAME'
       ,to_date('20100505000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20100505174040','YYYYMMDDHH24MISS')
       ,to_date('20100505174040','YYYYMMDDHH24MISS')
       ,'DORSET'
       ,'DORSET'
       ,'SELECT nau_unit_code,nau_name,nau_name'||CHR(10)||'    FROM   nm_admin_units'
       ,'N'
       ,null
       ,'N'
       ,'MIXED' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'PRO$'
                    AND  ITA_ATTRIB_NAME = 'HPAL_UNIT_NAME');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_INV_TYPE_ROLES
--
-- select * from nm3_metadata.nm_inv_type_roles
-- order by itr_inv_type
--         ,itr_hro_role
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_inv_type_roles
SET TERM OFF

INSERT INTO NM_INV_TYPE_ROLES
       (ITR_INV_TYPE
       ,ITR_HRO_ROLE
       ,ITR_MODE
       )
SELECT 
        'PRO$'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ROLES
                   WHERE ITR_INV_TYPE = 'PRO$'
                    AND  ITR_HRO_ROLE = 'HIG_USER');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_SDE_SUB_LAYER_EXEMPT
--
-- select * from nm3_metadata.nm_sde_sub_layer_exempt
-- order by nssl_object_name
--         ,nssl_object_type
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_sde_sub_layer_exempt
SET TERM OFF

INSERT INTO NM_SDE_SUB_LAYER_EXEMPT
       (NSSL_OBJECT_NAME
       ,NSSL_OBJECT_TYPE
       )
SELECT 
        'V_MCP_EXTRACT%'
       ,'VIEW' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_SDE_SUB_LAYER_EXEMPT
                   WHERE NSSL_OBJECT_NAME = 'V_MCP_EXTRACT%'
                    AND  NSSL_OBJECT_TYPE = 'VIEW');
--
INSERT INTO NM_SDE_SUB_LAYER_EXEMPT
       (NSSL_OBJECT_NAME
       ,NSSL_OBJECT_TYPE
       )
SELECT 
        'V_MCP_UPLOAD%'
       ,'VIEW' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_SDE_SUB_LAYER_EXEMPT
                   WHERE NSSL_OBJECT_NAME = 'V_MCP_UPLOAD%'
                    AND  NSSL_OBJECT_TYPE = 'VIEW');
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
