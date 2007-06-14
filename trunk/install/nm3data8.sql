/***************************************************************************

INFO
====
As at Release 4.0.1.0

GENERATION DATE
===============
04-APR-2007 11:15

TABLES PROCESSED
================
USER_SDO_STYLES
NM_LAYER_TREE

TABLE OWNER
===========
NM3DATA

MODE (A-Append R-Refresh)
========================
A

***************************************************************************/

define sccsid = '@(#)nm3data8.sql	1.12 04/04/07'
set define off;
set feedback off;

---------------------------------
-- START OF GENERATED METADATA --
---------------------------------

--
--********** USER_SDO_STYLES **********--
--
-- Columns
-- NAME                           NOT NULL VARCHAR2(32)
--   UNIQUE_STYLES (Pos 1)
-- TYPE                           NOT NULL VARCHAR2(32)
-- DESCRIPTION                             VARCHAR2(4000)
-- DEFINITION                     NOT NULL CLOB
--
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
--
--********** NM_LAYER_TREE **********--
--
-- Columns
-- NLTR_PARENT                    NOT NULL VARCHAR2(100)
--   NLTR_PARENT_CHILD_CHK
-- NLTR_CHILD                     NOT NULL VARCHAR2(100)
--   NLTR_PARENT_CHILD_CHK
--   NLTR_PK (Pos 1)
-- NLTR_DESCR                     NOT NULL VARCHAR2(250)
-- NLTR_TYPE                      NOT NULL VARCHAR2(1)
--   NLTR_TYPE_CHK
-- NLTR_ORDER                              NUMBER(22)
--
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
        'ROOT'
       ,'CUS'
       ,'Custom Layers'
       ,'F'
       ,120 FROM DUAL
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
        'STP'
       ,'SP1'
       ,'Schemes Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'SP1');
--
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
