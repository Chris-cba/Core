/***************************************************************************

INFO
====
As at Release 3.2.1.0

GENERATION DATE
===============
23-JUN-2005 10:01

TABLES PROCESSED
================
NM_ERRORS
HIG_DOMAINS
HIG_OPTION_LIST
HIG_MODULES
HIG_SEQUENCE_ASSOCIATIONS
HIG_CHECK_CONSTRAINT_ASSOCS

TABLE OWNER
===========
NM3DATA

MODE (A-Append R-Refresh)
========================
A

***************************************************************************/

define sccsid = '@(#)nm3data_patch.sql	1.21 06/23/05'
set define off;
set feedback off;

---------------------------------
-- START OF GENERATED METADATA --
---------------------------------

--
--********** NM_ERRORS **********--
--
-- Columns
-- NER_APPL                       NOT NULL VARCHAR2(6)
--   NER_PK (Pos 1)
-- NER_ID                         NOT NULL NUMBER(4)
--   NER_PK (Pos 2)
-- NER_HER_NO                              NUMBER(4)
-- NER_DESCR                      NOT NULL VARCHAR2(200)
-- NER_CAUSE                               VARCHAR2(1000)
--
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,1
       ,1
       ,'Allowed values are Y or N'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 1);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,2
       ,2
       ,'Transaction complete.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 2);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,3
       ,5
       ,'At first block.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 3);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,4
       ,6
       ,'At last block.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 4);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,5
       ,14
       ,'End Date must not be earlier then Start Date'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 5);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,6
       ,72
       ,'More than one existing row with same key value'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 6);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,7
       ,73
       ,'No row in table SYS.DUAL'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 7);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,8
       ,74
       ,'only ONE value should be entered'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 8);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,9
       ,75
       ,'Insert not allowed in this block'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 9);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,10
       ,76
       ,'Delete not allowed in this block'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 10);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,11
       ,78
       ,'More than one primary key row for foreign key value'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 11);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,12
       ,81
       ,'Update not allowed in this block.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 12);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,13
       ,83
       ,'Sequence number cannot be generated. Contact your DBA.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 13);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,14
       ,88
       ,'You must query or enter a record before proceeding.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 14);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,15
       ,90
       ,'Cannot query if no master exists'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 15);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,16
       ,91
       ,'Cannot insert here if no master records exist'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 16);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,17
       ,102
       ,'Commit changes before proceeding.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 17);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,18
       ,103
       ,'Invalid combination of Condition and Attribute Data-Type.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 18);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,19
       ,109
       ,'Status Code already exists'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 19);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,20
       ,110
       ,'You cannot delete STATUS_DOMAINS records'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 20);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,21
       ,111
       ,'You cannot delete STATUS_CODES records'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 21);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,22
       ,117
       ,'Field must be entered'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 22);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,23
       ,120
       ,'At last record.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 23);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,24
       ,121
       ,'%s1 does not exist.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 24);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,25
       ,123
       ,'Cannot delete %s1, %s2 exist.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 25);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,26
       ,124
       ,'Use [Insert Record] to create a New Record.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 26);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,27
       ,125
       ,'Function not available here.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 27);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,28
       ,126
       ,'Cannot find %s1 %s2'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 28);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,29
       ,128
       ,'The value entered is not valid; use [List]'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 29);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,30
       ,129
       ,'The value entered is not valid'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 30);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,31
       ,135
       ,'Error in generating a job no.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 31);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,32
       ,136
       ,'Record changed by another user. Requery.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 32);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,33
       ,138
       ,'Location invalid - Asset must be located on a continuous section of network of a single sub-class.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 33);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,34
       ,143
       ,'Cannot delete %s1'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 34);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,35
       ,144
       ,'Cannot create %s1'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 35);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,36
       ,145
       ,'Cannot update %s1'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 36);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,37
       ,146
       ,'Failed to delete %s1'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 37);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,38
       ,147
       ,'Failed to create %s1'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 38);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,39
       ,148
       ,'Failed to update %s1'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 39);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,40
       ,149
       ,'%s1 already exists'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 40);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,41
       ,150
       ,'%s1 does not exist, cannot %s2'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 41);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,42
       ,151
       ,'%s1 has no parent %s2'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 42);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,43
       ,153
       ,'This %s1 is not accessible %s2'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 43);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,44
       ,154
       ,'The %s1 entered is not valid %s2'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 44);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,45
       ,159
       ,'%s1 must be less than or equal to %s2'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 45);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,46
       ,162
       ,'Invalid Attribute Condition , please check your syntax.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 46);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,47
       ,164
       ,'You must enter %s1'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 47);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,48
       ,166
       ,'The admin unit is inconsistent with this road segment'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 48);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,49
       ,169
       ,'You cannot drop the user which owns the highways tables'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 49);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,50
       ,182
       ,'Your site is not licensed to run this product'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 50);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,16
       ,null
       ,'Please select an item.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 16);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,17
       ,null
       ,'You have selected an item of the wrong type.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 17);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,18
       ,null
       ,'You cannot call the Gazetteer from here.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 18);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,19
       ,null
       ,'Adding an element with the same sub class as one that exists at this start node.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 19);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,20
       ,null
       ,'More that one element with this sub-class at this start node.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 20);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,21
       ,null
       ,'Adding an element with the same sub class as one that exists at this end node.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 21);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,22
       ,null
       ,'More that one element with this sub-class at this end node.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 22);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,23
       ,null
       ,'A Single and Left or Right element start at this node'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 23);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,24
       ,null
       ,'A Single and a Left element start at this node'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 24);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,25
       ,null
       ,'A Single and a Right element start at this node'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 25);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,26
       ,null
       ,'Parent element not found.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 26);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,27
       ,null
       ,'More than 1 parent element found.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 27);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,28
       ,null
       ,'Unexpected error occurred'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 28);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,29
       ,null
       ,'Value out of range.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 29);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,30
       ,null
       ,'Value is invalid. Please use only alphanumeric characters with no spaces. The underscore character "_" can be used for spaces.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 30);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,31
       ,null
       ,'The query has changed - all jobs associated with this query will be deleted.'||CHR(10)||''||CHR(10)||'Are you sure you wish to continue?'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 31);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,32
       ,null
       ,'Location invalid - inventory must be located on a linear group of sections or a single section.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 32);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,33
       ,null
       ,'Location invalid - Asset must be located on a continuous section of network of a single sub-class.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 33);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,34
       ,null
       ,'You cannot back date a group.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 34);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,35
       ,null
       ,'Some elements are not valid for this start date.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 35);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,36
       ,null
       ,'Cannot create group for an empty extent.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 36);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,37
       ,null
       ,'Enter extent details before creating group.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 37);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,38
       ,null
       ,'Cannot locate inventory - there are future inventory locations which would be affected.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 38);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,39
       ,null
       ,'Some elements are of a Network Type not allowed for this Group Type.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 39);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,40
       ,null
       ,'Some elements are partial which is not allowed for this Group Type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 40);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,41
       ,null
       ,'Group type is exclusive and at least one element already exists in another group of this type.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 41);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,42
       ,null
       ,'Cannot locate inventory - there is an old item of this type that overlaps the new item at both beginning and end.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 42);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,43
       ,null
       ,'Location of this inventory type on this network type is invalid.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 43);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,44
       ,null
       ,'Location of this inventory type on this XSP is invalid.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 44);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,45
       ,null
       ,'XSP must be specified for this inventory type.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 45);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,46
       ,null
       ,'XSP is invalid for this inventory type on this network type.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 46);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,47
       ,null
       ,'Column query does not return one and only one row.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 47);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,48
       ,null
       ,'Column query does not contain one and only one bind variable.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 48);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,49
       ,null
       ,'No Type Column entry exists for this record.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 49);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,50
       ,null
       ,'Mandatory attribute not entered.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 50);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,51
       ,null
       ,'Cannot perform this operation on a group of groups.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 51);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,52
       ,null
       ,'Some shapes are not available for the area you wish to display.'||CHR(10)||''||CHR(10)||'This may give misleading results in the GIS.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 52);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,53
       ,null
       ,'Group requires flexible attributes, please use the elements form to create a group of this type.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 53);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,54
       ,null
       ,'Group members require inherited flexible attributes, please use the elements form to create members for this group.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 54);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,55
       ,null
       ,'Element is of a network type not permitted for this group type.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 55);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,56
       ,null
       ,'Do you want to include the default merge splitting agents to the query'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 56);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,57
       ,null
       ,'Query not found'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 57);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,58
       ,null
       ,'Query already has defaults, use refresh.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 58);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,59
       ,null
       ,'Cannot update defaults. Use remove/refresh.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 59);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,60
       ,null
       ,'Requery to see defaults.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 60);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,61
       ,null
       ,'Attribute has already been used for this inventory type.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 61);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,62
       ,null
       ,'Some elements in this extent are not valid for the current effective date.'||CHR(10)||''||CHR(10)||'This may give unpredicted results. You may wish to change the effective date using preferences.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 62);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,63
       ,null
       ,'Cannot rescale and maintain history when group members have a start date of today or in the future.'||CHR(10)||''||CHR(10)||'Would you like to rescale without maintaining history?'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 63);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,64
       ,null
       ,'XSP reversal rules not found.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 64);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,65
       ,null
       ,'Cannot allocate segment number.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 65);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,66
       ,null
       ,'Cannot allocate sequence number.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 66);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,67
       ,null
       ,'Cannot calculate new true distance.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 67);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,68
       ,null
       ,'Cannot calculate new SLK.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 68);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,69
       ,null
       ,'Cannot find length of rescaled element.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 69);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,70
       ,null
       ,'Band has minimum value greater than maximum value.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 70);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,71
       ,null
       ,'Bands have overlapping values.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 71);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,72
       ,null
       ,'Banding has gaps.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 72);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,73
       ,null
       ,'Attribute format is not valid for banding.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 73);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,74
       ,null
       ,'Values are specified for bands to a greater precision than the attribute allows.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 74);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,75
       ,null
       ,'Banding is valid.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 75);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,76
       ,null
       ,'Banding to be copied is of a different format to this attribute.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 76);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,77
       ,null
       ,'Location of this item is mandatory and it is not currently located.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 77);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,78
       ,null
       ,'Could not calculate Distance Error between nodes for sub-class.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 78);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,79
       ,null
       ,'Please use the User Entered tab to edit this extent.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 79);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,80
       ,null
       ,'Start position is further along the route than the end.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 80);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,81
       ,null
       ,'Cannot establish connectivity between the start and end.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 81);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,82
       ,null
       ,'Please specify sub class.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 82);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,83
       ,null
       ,'Intersection is not on route.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 83);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,84
       ,null
       ,'Route must be resequenced.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 84);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,85
       ,null
       ,'There are no datums at the specified linear reference.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 85);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,86
       ,null
       ,'Continuous inventory cannot have start and end points that are the same.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 86);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,87
       ,null
       ,'Location already designated to another admin type.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 87);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,88
       ,null
       ,'Invalid overhang action specified.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 88);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,89
       ,null
       ,'Mandatory attribute cannot have a NULL new value.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 89);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,90
       ,null
       ,'Supplied new value is invalid.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 90);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,91
       ,null
       ,'Attribute specified more than once.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 91);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,92
       ,null
       ,'Element is of invalid sub class.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 92);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,93
       ,null
       ,'Asset has been located but the following warning occurred'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 93);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,94
       ,null
       ,'Asset has been located but an unknown warning occurred'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 94);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,95
       ,null
       ,'Type is contiguous and some elements aren''t wholly covered by this type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 95);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,96
       ,null
       ,'There is a discontinuity at the intersecting node.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 96);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,97
       ,null
       ,'Restricted users cannot delete results for queries for which they do not have direct normal access.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 97);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,98
       ,null
       ,'Another saved extent already exists with this name.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 98);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,99
       ,null
       ,'Asset types not marked as "multiple allowed" must only have a single location'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 99);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,100
       ,null
       ,'Node is not on route (on the specified sub class).'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 100);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,101
       ,null
       ,'Route needs to be resequenced.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 101);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,102
       ,null
       ,'Overlaps not allowed on inventory types which are marked as contiguous.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 102);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,103
       ,null
       ,'Asset Locations already exist for affected asset at this point with this start date.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 103);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,104
       ,null
       ,'Asset Locations already exist for this item at this point with this start date.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 104);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,105
       ,null
       ,'Point Asset Items can only be placed at point locations, not linear'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 105);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,106
       ,null
       ,'Cannot locate Asset records which are in a Child AT relationship'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 106);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,107
       ,null
       ,'Invalid type of node for network type.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 107);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,108
       ,null
       ,'Cannot reclassify a closed element.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 108);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,109
       ,null
       ,'Cannot reclassify element that has un-replaceable inventory.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 109);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,110
       ,null
       ,'Invalid code control column on network type.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 110);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,111
       ,null
       ,'Old and new lengths are different.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 111);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,112
       ,null
       ,'Section cannot have a group type.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 112);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,113
       ,null
       ,'Column supplied but not defined for network type.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 113);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,114
       ,null
       ,'Old element not found.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 114);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,115
       ,null
       ,'Only datum elements and groups of sections can be reclassified.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 115);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,116
       ,null
       ,'There are overlaps in the network you have specified.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 116);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,117
       ,null
       ,'Only whole road groups or datum sections can be selected here.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 117);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,118
       ,null
       ,'Sub Class of elements is different at merge point'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 118);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,119
       ,null
       ,'Operation can only be performed on a datum element.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 119);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,120
       ,null
       ,'No query types defined.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 120);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,121
       ,null
       ,'Query is invalid'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 121);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,122
       ,null
       ,'Parent element not specified.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 122);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,123
       ,null
       ,'Asset Type and XSP combination specified more than once.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 123);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,124
       ,null
       ,'Attributes not specified for all Query Types.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 124);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,125
       ,null
       ,'This inventory item is of a contiguous type.'||CHR(10)||''||CHR(10)||'End-dating it may leave gaps.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 125);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,126
       ,null
       ,'Start and end nodes cannot be the same.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 126);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,127
       ,null
       ,'The following types have no attributes defined:'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 127);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,128
       ,null
       ,'Location invalid - inventory must be located on a single route.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 128);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,129
       ,null
       ,'There are no datums in the network you have selected.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 129);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,130
       ,null
       ,'No value found for bind variable specified in pre-process procedure'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 130);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,131
       ,null
       ,'More than 1 value found for bind variable specified in pre-process procedure'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 131);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,132
       ,null
       ,'Elements are identical'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 132);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,133
       ,null
       ,'Left Starts without a right'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 133);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,134
       ,null
       ,'Right Starts without a Left'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 134);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,135
       ,null
       ,'Adding a Left without a right'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 135);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,136
       ,null
       ,'Adding a Right without a Left'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 136);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,137
       ,null
       ,'Left ends without a right'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 137);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,138
       ,null
       ,'Adding a Left without a right'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 138);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,139
       ,null
       ,'Adding a Right without a Left'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 139);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,140
       ,null
       ,'Adding a Right without a Left'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 140);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,141
       ,null
       ,'Group types of a parent inclusion network type must be exclusive.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 141);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,142
       ,null
       ,'Saved extent has overlaps, these will be removed in the new group.'||CHR(10)||''||CHR(10)||' Is this OK?'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 142);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,143
       ,null
       ,'Group has overlaps.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 143);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,144
       ,null
       ,'You must assign at least one role to this query.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 144);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,145
       ,null
       ,'The following errors occurred during trigger creation:'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 145);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,146
       ,null
       ,'Committing will recreate the trigger, OK to continue?'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 146);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,147
       ,null
       ,'Conditions must all be on the same inventory type.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 147);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,148
       ,null
       ,'Check Driving Conditions.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 148);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,149
       ,null
       ,'Check Validation Conditions.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 149);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,150
       ,null
       ,'Rule must have at least 1 Driving Condition.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 150);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,151
       ,null
       ,'Boolean connector cannot be present for first condition.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 151);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,152
       ,null
       ,'Boolean connector must be present for driving conditions other than the first.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 152);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,153
       ,null
       ,'Condition sequence numbers must be unique.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 153);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,154
       ,null
       ,'Route is ill-formed please check before committing the changes.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 154);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,155
       ,null
       ,'Distance break will overlap existing datums in the route.'||CHR(10)||''||CHR(10)||'Are you sure you wish to continue?'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 155);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,156
       ,null
       ,'Route structure is satisfactory.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 156);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,157
       ,null
       ,'Route has start of right with no compatible end.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 157);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,158
       ,null
       ,'Route has start of left with no compatible end.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 158);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,159
       ,null
       ,'Starts of route members are incompatible.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 159);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,160
       ,null
       ,'Ends of members are incompatible.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 160);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,161
       ,null
       ,'Route has too many start points.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 161);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,162
       ,null
       ,'Route has too many end points.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 162);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,163
       ,null
       ,'Invalid sub class combination at start of route.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 163);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,164
       ,null
       ,'Invalid sub class combination at end of route.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 164);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,165
       ,null
       ,'Future effective date not allowed'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 165);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,166
       ,null
       ,'There is a POE at the node'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 166);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,167
       ,null
       ,'Sub Class of elements are not the same'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 167);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,168
       ,null
       ,'Elements are not connected'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 168);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,169
       ,null
       ,'Not a datum element'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 169);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,170
       ,null
       ,'Elements must be of the same network type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 170);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,171
       ,null
       ,'Element is a distance break'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 171);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,172
       ,null
       ,'User does not have access to all inventory on the element'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 172);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,173
       ,null
       ,'Change violates the XSP Rules.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 173);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,174
       ,null
       ,'Cannot perform this process, user is restricted'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 174);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,175
       ,null
       ,'Cannot end location.'||CHR(10)||''||CHR(10)||'Location of the item or its children is mandatory.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 175);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,176
       ,null
       ,'Cannot end location.'||CHR(10)||''||CHR(10)||'Item is in a child AT or IN relationship.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 176);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,177
       ,null
       ,'Asset item not currently located.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 177);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,178
       ,null
       ,'Cannot end location.'||CHR(10)||''||CHR(10)||'Item has locations in the future.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 178);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,179
       ,null
       ,'Unexpected error occurred'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 179);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,180
       ,null
       ,'No parent elements found.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 180);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,181
       ,null
       ,'No child items found.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 181);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,182
       ,null
       ,'Partial extents not allowed.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 182);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,183
       ,null
       ,'Sub class is not valid for network type.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 183);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,184
       ,null
       ,'Asset has location has been ended and the following warning occurred'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 184);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,185
       ,null
       ,'This item has an existing location.'||CHR(10)||'How would you like to treat it?'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 185);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,186
       ,null
       ,'Merge will result in a loss of connectivity.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 186);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,187
       ,null
       ,'New Start SLK does not match the Existing Start SLK(s)'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 187);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,188
       ,null
       ,'New End SLK does not match the Existing End SLK(s)'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 188);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,189
       ,null
       ,'Elements are in different groups.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 189);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,190
       ,null
       ,'Query results and query file are for different merge queries.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 190);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,191
       ,null
       ,'Saved extent has members that have been updated since they were added and must be refreshed before it can be used.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 191);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,192
       ,null
       ,'Elements membership has been modified'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 192);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,193
       ,null
       ,'Other Network Operations performed on elements'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 193);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,194
       ,null
       ,'Value must be an NM_ELEMENTS column or something that can be selected from DUAL.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 194);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,195
       ,null
       ,'Network types are valid.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 195);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,196
       ,null
       ,'No XSP Restraints found Inv Type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 196);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,197
       ,null
       ,'Cannot delete items in inventory type as they have child items.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 197);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,198
       ,null
       ,'Cannot cascade delete when a where clause is specified.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 198);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,199
       ,null
       ,'A Parent which is to be auto-created must have a group type for its NT_TYPE'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 199);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,200
       ,null
       ,'A Parent which is to be auto-created may only have a single group type for its NT_TYPE'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 200);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,201
       ,null
       ,'Invalid ne_type supplied'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 201);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,202
       ,null
       ,'Network Type not supplied'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 202);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,203
       ,null
       ,'Invalid Network Type supplied'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 203);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,204
       ,null
       ,'Element Description not supplied'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 204);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,205
       ,null
       ,'Admin Unit must be supplied'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 205);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,206
       ,null
       ,'Start Date must be supplied'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 206);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,207
       ,null
       ,'Datum Network Types must have a node type associated'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 207);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,208
       ,null
       ,'Unique Seq used more than once'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 208);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,209
       ,null
       ,'Unique Seq specified when network type is not pop_unique'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 209);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,210
       ,null
       ,'Warning: No Unique Seq specified when network type is pop_unique. Element uniques will be defaulted to the ne_id'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 210);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,211
       ,null
       ,'Column is not a valid NM_ELEMENTS_ALL column'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 211);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,212
       ,null
       ,'Column is defined as a child type-inclusion column more than once'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 212);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,213
       ,null
       ,'Column is defined as a code control both as a child inclusion and as a parent inclusion'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 213);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,214
       ,null
       ,'Column is defined as a parent type-inclusion column more than once'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 214);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,215
       ,null
       ,'Column is defined as a code control column more than once'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 215);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,216
       ,null
       ,'Parent Type Inclusion Column Must be NE_UNIQUE when it is an auto-create parent which is not pop unique'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 216);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,217
       ,null
       ,'Column cannot be mandatory when an auto-create type inclusion parent'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 217);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,218
       ,null
       ,'Column forms part of unique sequence, but is not parent type inclusion column'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 218);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,219
       ,null
       ,'Cannot update NM_NE_ID_IN or NM_NE_ID_OF'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 219);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,220
       ,null
       ,'Unknown Member Type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 220);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,221
       ,null
       ,'Cannot update NM_OBJ_TYPE'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 221);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,222
       ,null
       ,'Format specified is not permitted in database field'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 222);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,223
       ,null
       ,'Column not found'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 223);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,224
       ,null
       ,'Subclass is invalid'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 224);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,225
       ,null
       ,'Asset Type Attributes cannot be flagged as exclusive when the Asset Type is not flagged as exclusive'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 225);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,226
       ,null
       ,'Asset Type cannot be made non-exclusive whilst Asset Type Attributes exist which are flagged as exclusive'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 226);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,227
       ,null
       ,'Membership measures out of range of parent element'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 227);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,228
       ,null
       ,'Change to inventory details would result in violation of exclusivity rules'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 228);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,229
       ,null
       ,'Unable to automatically create exclusive views as derived view name is too long'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 229);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,230
       ,null
       ,'Can only create exclusive views for exclusive inventory types'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 230);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,231
       ,null
       ,'Cannot create exclusive views. Details do not tally in variables. Re-run from beginning'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 231);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,232
       ,null
       ,'Can only create exclusive views for exclusive inventory types which are XSP allowed and/or have exclusive flexible attributes defined'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 232);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,233
       ,null
       ,'Unable to create exclusive views, no data exists of this type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 233);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,234
       ,null
       ,'Location has already been designated to another admin unit of this type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 234);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,235
       ,null
       ,'Location remains unassigned, you do not have the privileges to set the admin unit'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 235);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,236
       ,null
       ,'You do not have privileges to perform this action'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 236);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,237
       ,null
       ,'The admin type is not correct'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 237);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,238
       ,null
       ,'Invalid security status'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 238);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,239
       ,null
       ,'You may not update the admin unit'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 239);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,240
       ,null
       ,'You may not change this record'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 240);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,241
       ,null
       ,'You may not create data with this admin unit'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 241);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,242
       ,null
       ,'No admin unit found for this user of the correct Admin Type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 242);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,243
       ,null
       ,'Reclassification would violate Cross Item Validation rules'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 243);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,244
       ,null
       ,'Network Type not found'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 244);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,245
       ,null
       ,'Can only create for datum linear network types'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 245);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,246
       ,null
       ,'Cannot automatically delete existing inventory type. Is of a different category'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 246);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,247
       ,null
       ,'Cannot create inventory types of category "R". This is reserved for Structural Projects'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 247);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,248
       ,null
       ,'Can only have one inventory type of category "R"'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 248);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,51
       ,183
       ,'Unable to Bulk Update Contract. %s1 contract items would have been made negative.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 51);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,52
       ,184
       ,'Incode must be of format: X9, X99, XX9, XX99, X9X, XX9X (where X is a letter and 9 is a number)'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 52);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,53
       ,185
       ,'Outcode must be one number and two letters (9XX)'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 53);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,54
       ,186
       ,'This contact is not valid for this type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 54);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,55
       ,187
       ,'Cannot Delete record as associated %s1 records exist.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 55);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,56
       ,188
       ,'This contact is not current, check start and end dates.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 56);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,57
       ,189
       ,'A Surname must be entered.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 57);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,58
       ,190
       ,'An Organisation Name must be entered.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 58);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,59
       ,342
       ,'You cannot enter a date in the future'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 59);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,60
       ,639
       ,'A value for one of these fields MUST be entered'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 60);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,61
       ,9608
       ,'You must enter either %s1 or %s2'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 61);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,62
       ,null
       ,'A domain required for this screen is not present which may cause it to function incorrectly or not at all.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 62);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,63
       ,null
       ,'GIS is not available.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 63);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,64
       ,null
       ,'Value already exists.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 64);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,65
       ,null
       ,'GIS shape in place, network editing function not allowed.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 65);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,66
       ,null
       ,'Unable to find GIS route theme.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 66);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,67
       ,null
       ,'Record not found'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 67);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,68
       ,null
       ,'Cannot find GIS theme.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 68);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,69
       ,null
       ,'Value entered is too long.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 69);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,70
       ,null
       ,'Value is of invalid format.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 70);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,71
       ,null
       ,'Cannot delete another user''s record.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 71);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,72
       ,null
       ,'Public synonyms not available, you must create private synonyms for this user.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 72);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,73
       ,null
       ,'Some shapes are not available for the area you wish to display.'||CHR(10)||''||CHR(10)||'This may give misleading results in the GIS.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 73);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,74
       ,null
       ,'There are no shapes available for the object you wish to view in the GIS.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 74);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,75
       ,null
       ,'No GIS objects selected.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 75);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,76
       ,null
       ,'Value cannot be less than '
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 76);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,77
       ,null
       ,'Value cannot be greater than '
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 77);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,78
       ,null
       ,'Value cannot be greater than '
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 78);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,79
       ,null
       ,'Cannot create synonym - object does not exist in schema.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 79);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,80
       ,null
       ,'User does not exist in HIG_USERS.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 80);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,81
       ,null
       ,'User does not have permission to create synonym.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 81);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,82
       ,null
       ,'Application configured to run using PUBLIC synonyms - not creating PRIVATE synonyms.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 82);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,83
       ,null
       ,'Error occurred executing sql'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 83);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,84
       ,null
       ,'Function name not found in function text'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 84);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,85
       ,null
       ,'Update not allowed.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 85);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,86
       ,null
       ,'You do not have permission to perform this action.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 86);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,87
       ,null
       ,'Would you like to save changes?'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 87);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,88
       ,null
       ,'Invalid admin unit.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 88);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,89
       ,null
       ,'The passwords you have entered are different.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 89);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,90
       ,null
       ,'Password changed successfully.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 90);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,91
       ,null
       ,'Arrays supplied have different numbers of values.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 91);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,92
       ,null
       ,'All old and new values specified are the same.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 92);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,93
       ,null
       ,'Asset has been located but the following warning occurred'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 93);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,94
       ,null
       ,'Asset has been located but an unknown warning occurred'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 94);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,95
       ,null
       ,'Operation completed successfully.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 95);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,96
       ,null
       ,'Save Changes before continuing'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 96);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,97
       ,null
       ,'If you continue the results may be incorrect.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 97);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,98
       ,null
       ,'Open queries are not allowed in this block.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 98);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,99
       ,null
       ,'Asset types not marked as "multiple allowed" must only have a single location'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 99);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,100
       ,null
       ,'No length supplied.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 100);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,101
       ,null
       ,'Start date must be effective date.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 101);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,102
       ,null
       ,'No changes made.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 102);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,103
       ,null
       ,'Asset Locations already exist for affected asset at this point with this start date.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 103);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,104
       ,null
       ,'Asset Locations already exist for this item at this point with this start date.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 104);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,105
       ,null
       ,'Point Asset Items can only be placed at point locations, not linear'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 105);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,106
       ,null
       ,'Cannot locate Asset records which are in a Child AT relationship'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 106);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,107
       ,null
       ,'Mandatory column is NULL'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 107);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,108
       ,null
       ,'Column is too long'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 108);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,109
       ,null
       ,'Value is invalid for domain'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 109);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,110
       ,null
       ,'Invalid parameter'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 110);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,111
       ,null
       ,'Numeric value is invalid.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 111);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,112
       ,null
       ,'Invalid number of values specified.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 112);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,113
       ,null
       ,'Parse error in query'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 113);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,114
       ,null
       ,'You have selected an item of the wrong type.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 114);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,115
       ,null
       ,'Error number already exists.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 115);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,116
       ,null
       ,'You are creating a role as a  user that is not the highways owner.'||CHR(10)||''||CHR(10)||'The new role has been granted to the highways owner with admin privileges.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 116);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,117
       ,null
       ,'You must requery any currently displayed data to see unit changes.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 117);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,118
       ,null
       ,'Folder already exists.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 118);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,119
       ,null
       ,'You cannot rename the favourites folder.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 119);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,120
       ,null
       ,'Alert not found.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 120);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,121
       ,null
       ,'OK to delete folder and its contents?'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 121);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,122
       ,null
       ,'OK to delete module?'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 122);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,123
       ,null
       ,'Asset Type and XSP combination specified more than once.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 123);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,124
       ,null
       ,'You cannot create an item at this level.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 124);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,125
       ,null
       ,'Module already exists in this folder.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 125);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,126
       ,null
       ,'You do not have privileges to perform this action'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 126);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,127
       ,null
       ,'Discoverer run mode not defined in system options.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 127);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,128
       ,null
       ,'Client server Discoverer cannot be run from highways in web mode.'||CHR(10)||''||CHR(10)||'Check user and system options.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 128);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,129
       ,null
       ,'Discoverer web path not defined correctly in system options.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 129);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,130
       ,null
       ,'Discoverer executable not defined.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 130);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,131
       ,null
       ,'Append'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 131);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,132
       ,null
       ,'Replace'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 132);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,133
       ,null
       ,'The data you have chosen has been changed by another user, please reselect.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 133);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,134
       ,null
       ,'No themes available for current module.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 134);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,135
       ,null
       ,'Status transition not allowed'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 135);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,136
       ,null
       ,'No DBMS job processes defined - contact the system administrator.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 136);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,137
       ,null
       ,'Effective Date is format is invalid.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 137);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,139
       ,null
       ,'Message is enqueued and will be delivered in due course'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 139);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,140
       ,null
       ,'If you change your password you will be logged out of highways.'||CHR(10)||''||CHR(10)||'OK to continue?'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 140);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,141
       ,null
       ,'Error populating group'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 141);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,142
       ,null
       ,'Job not online'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 142);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,143
       ,null
       ,'More than one instance of this job exists'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 143);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,144
       ,null
       ,'Function cannot be performed here'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 144);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,145
       ,null
       ,'You have entered a duplicate primary key'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 145);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,146
       ,null
       ,'You do not have the required privileges to create a user'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 146);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,147
       ,null
       ,'Column, Table combination does not exist.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 147);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,148
       ,null
       ,'Date format is invalid'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 148);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,149
       ,null
       ,'GIS theme data contains invalid table name(s)'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 149);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,150
       ,null
       ,'GIS Theme data is invalid'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 150);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,151
       ,null
       ,'Item location cannot be modified from GIS'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 151);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,152
       ,null
       ,'Item location may not be modified from GIS for this product'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 152);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,153
       ,null
       ,'The password entered is incorrect for this user.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 153);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,154
       ,null
       ,'This will exit and lose the connection to the GIS'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 154);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,155
       ,null
       ,'Unit Converter'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 155);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,156
       ,null
       ,'Cannot add a value as it would exceed the maximum allowed for the condition'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 156);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,157
       ,null
       ,'Cannot update domain when values exist'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 157);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,158
       ,null
       ,'Field cannot be updated'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 158);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,159
       ,null
       ,'Mixed case values not permitted'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 159);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,160
       ,null
       ,'Datatype cannot be updated when values exist'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 160);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,161
       ,null
       ,'Case sensitivity cannot be updated - this would result in invalid data'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 161);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,162
       ,null
       ,'Standard visual attribute not found'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 162);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,163
       ,null
       ,'Product Option is not set'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 163);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,164
       ,null
       ,'Are you sure you wish to create/recreate the holding table? Any data will be lost'||CHR(10)||'This operation also involves a COMMIT.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 164);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,165
       ,null
       ,'Continue'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 165);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,166
       ,null
       ,'Name is not unique across NM_LOAD_FILES.NLF_UNIQUE and NM_LOAD_DESTINATIONS.NLD_TABLE_SHORT_NAME'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 166);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,167
       ,null
       ,'Form must be called in NORMAL mode'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 167);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,168
       ,null
       ,'Date cannot have a time associated'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 168);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,169
       ,null
       ,'Database constraint violated'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 169);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,170
       ,null
       ,'Allowable values are "NORMAL" and "READONLY"'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 170);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,171
       ,null
       ,'Allowable values are "VARCHAR2","NUMBER" and "DATE"'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 171);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,172
       ,null
       ,'Only whole numbers may be specified'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 172);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,173
       ,null
       ,'Only positive whole numbers may be specified'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 173);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,174
       ,null
       ,'Negative values are not permitted'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 174);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,175
       ,null
       ,'Definition of query bracketing is invalid'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 175);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,176
       ,null
       ,'Specified Job Status is invalid'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 176);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,177
       ,null
       ,'Asset item not currently located.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 177);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,178
       ,null
       ,'File uploaded successfully'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 178);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,179
       ,null
       ,'File upload failed'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 179);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,180
       ,null
       ,'File browser not available when running via the web'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 180);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,181
       ,null
       ,'INSERT not permitted into this view'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 181);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,182
       ,null
       ,'User not instantiated correctly.'||CHR(10)||'Probable missing INSTANTIATE_USER trigger.'||CHR(10)||'Contact exor support for assistance.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 182);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,183
       ,null
       ,'Date format mask only permitted for DATE fields'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 183);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,184
       ,null
       ,'Asset has location has been ended and the following warning occurred'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 184);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,185
       ,null
       ,'Generating report...'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 185);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,186
       ,null
       ,'Cannot load from server. No server file path specified'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 186);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,187
       ,null
       ,'Are you sure you wish to continue?'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 187);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,188
       ,null
       ,'User Created. Do you want to view this user?'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 188);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,189
       ,null
       ,'SDE data not present - cloning is not possible'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 189);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,190
       ,null
       ,'SDE Layer generator failure'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 190);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,191
       ,null
       ,'SDE Table registration id generator failure'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 191);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,192
       ,null
       ,'Theme is not related to a network'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 192);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,193
       ,null
       ,'Point location data not found - clone is not possible'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 193);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,194
       ,null
       ,'No base theme is available'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 194);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,195
       ,null
       ,'No datum theme found'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 195);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,196
       ,null
       ,'Layer table not found'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 196);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,197
       ,null
       ,'SDO Metadata for layer  not found'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 197);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,198
       ,null
       ,'Geometry not found - '
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 198);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,199
       ,null
       ,'Element shapes not connected'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 199);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,201
       ,null
       ,'Only one element has shape - merge prevented'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 201);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,202
       ,null
       ,'points are the same - no distance between them'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 202);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,203
       ,null
       ,'points are not on same network element'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 203);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,204
       ,null
       ,'Lengths of element and shape are inconsistent'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 204);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,205
       ,null
       ,'Single part asset shapes are not supported yet'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 205);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,206
       ,null
       ,'Load Aborted. Metadata changes have been made since the edif file was generated.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 206);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,207
       ,null
       ,'Load Aborted. Error found during MapCapture Load.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 207);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,208
       ,null
       ,'Asset Update conflict. Changes have been made to the asset in the database.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 208);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,209
       ,null
       ,'The file containing exor product version numbers could not be found.  Please check the ''EXOR_VERSION'' registry setting'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 209);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,210
       ,null
       ,'Switch Route Theme ?'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 210);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,211
       ,null
       ,'Switch Route Theme to Current Theme?'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 211);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,212
       ,null
       ,'Theme must be of type SDE/SDO to be Route Theme'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 212);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,213
       ,null
       ,'Assertion failed'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 213);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,214
       ,null
       ,'Value cannot be NULL'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 214);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,215
       ,null
       ,'XML does not allow lists of more than one column. '||CHR(10)||''||CHR(10)||'Either select one column or use a table alias.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 215);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,216
       ,null
       ,'Close'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 216);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,217
       ,null
       ,'Select All'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 217);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,218
       ,null
       ,'Inverse Selection'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 218);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,219
       ,null
       ,'Refresh'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 219);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,220
       ,null
       ,'You can only send email as your own user'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 220);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,221
       ,null
       ,'All mail messages should have at least 1 "TO" recipient'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 221);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,222
       ,null
       ,'Favourite cannot have the name as parent folder'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 222);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,230
       ,null
       ,'Inconsistency detected between licenced product versions on the database and in the Exor Product Version Numbers File.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 230);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,231
       ,null
       ,'Detail'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 231);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,232
       ,null
       ,'Points are not on same network element'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 232);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,233
       ,null
       ,'No theme data available to determine gtype'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 233);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,234
       ,null
       ,'No suitable PK column for SDE registration'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 234);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,235
       ,null
       ,'Theme must be consistent for the same session'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 235);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,236
       ,null
       ,'Unknown geometry'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 236);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,237
       ,null
       ,'Dimension not available'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 237);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,238
       ,null
       ,'Invalid dimension - must be between 2 and 4'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 238);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,239
       ,null
       ,'No data to base diminfo calculation'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 239);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,240
       ,null
       ,'The SRID does not match - please reset the current SRID or use the correct value'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 240);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,241
       ,null
       ,'No Index on the table and column'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 241);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,242
       ,null
       ,'Already registered in SDO Metadata'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 242);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,243
       ,null
       ,'Needs a Feature table'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 243);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,244
       ,null
       ,'Needs a Feature table spatial column'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 244);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,245
       ,null
       ,'Needs a base theme to dyn-seg from'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 245);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,246
       ,null
       ,'Not enough info on the theme'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 246);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,247
       ,null
       ,'Tolerance cannot be found from point data'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 247);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,248
       ,null
       ,'Dimension information is incomopatible with operation'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 248);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,249
       ,null
       ,'FT and theme do not match'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 249);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,250
       ,null
       ,'Asset type is not a foreign table'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 250);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,251
       ,null
       ,'SRID generator failure'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 251);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,252
       ,null
       ,'Table is not registered or SDE schema cannot see it'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 252);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,253
       ,null
       ,'No sde layer for theme'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 253);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,254
       ,null
       ,'Layer not found in SDE metadata'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 254);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,255
       ,null
       ,'Failure in SDE date conversion'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 255);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,256
       ,null
       ,'Failure in date conversion to SDE'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 256);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,257
       ,null
       ,'Object does not exist'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 257);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,259
       ,null
       ,'Invalid Geometry Type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 259);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'MRWA'
       ,1
       ,null
       ,'Current status of processing is invalid for this action'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'MRWA'
                    AND  NER_ID = 1);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,1
       ,7
       ,'Unable to create SECTION_CLASSES record.'
       ,'ACTION: This is an internal error message and should not normally be'||CHR(10)||'issued. Contact your ORACLE Customer Support Representative.'||CHR(10)||'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 1);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,2
       ,139
       ,'Cannot delete record as associated records exist.'
       ,'ACTION: All associated records should be deleted before the record that'||CHR(10)||'you are trying to delete can be deleted.'||CHR(10)||'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 2);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,3
       ,341
       ,'You cannot duplicate records in this block'
       ,'ACTION: Records cannot be duplicated in this block.'||CHR(10)||'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 3);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,4
       ,null
       ,'Use the tree to create hierarchical items.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 4);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,5
       ,null
       ,'Cannot change network type when groups exist with this group type.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 5);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,6
       ,null
       ,'You cannot insert or update data when the effective date is not today.'||CHR(10)||''||CHR(10)||'Use Preferences to set the effective date.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 6);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,7
       ,null
       ,'Network Type must have same admin unit type as parent.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 7);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,8
       ,null
       ,'Parent is exclusive and object is already a child of another parent of the same type.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 8);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,9
       ,null
       ,'Would you like to save changes before the effective date is changed?'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 9);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,10
       ,null
       ,'Start date cannot be updated.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 10);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,11
       ,null
       ,'Start date is out of range of parent.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 11);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,12
       ,null
       ,'End date is out of range of parent.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 12);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,13
       ,null
       ,'Record has children outside its date range.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 13);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,14
       ,null
       ,'End date cannot be before start date.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 14);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,15
       ,null
       ,'Linear reference cannot be less than zero.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 15);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,249
       ,null
       ,'Child inventory type must have at least 1 matching allowable network type with each parent inv type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 249);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,250
       ,null
       ,'Cannot update inventory admin unit. There are future affected locations for this item which would be affected'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 250);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,251
       ,null
       ,'Cannot perform area admin unit update. There are inventory items which are still left active which would have a duplicate IIT_PRIMARY_KEY'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 251);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,252
       ,null
       ,'SQL does not evaluate to any columns'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 252);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,253
       ,null
       ,'Invalid column name'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 253);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,254
       ,null
       ,'Column has invalid datatype'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 254);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,255
       ,null
       ,'Query Results are > 32K'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 255);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,256
       ,null
       ,'Table or View either does not exist or user has no privileges to access it'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 256);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,257
       ,null
       ,'Cannot auto-create parent where parent type has an associated Node Type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 257);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,258
       ,null
       ,'Cannot copy and locate a child item. You must perform this operation on the parent item'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 258);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,259
       ,null
       ,'Cannot perform this operation. IIT_PRIMARY_KEY is specified as a flexible attribute and is set to the non-default value'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 259);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,260
       ,null
       ,'Cannot cascade Admin Unit in copy operation. Item has child item(s) of different admin type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 260);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,261
       ,null
       ,'Operation cannot be performed when there are child inventory types with different admin types.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 261);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,262
       ,null
       ,'Fatal Error : Values in global variables do not tally'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 262);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,263
       ,null
       ,'Partial element means loss of connectivity'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 263);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,264
       ,null
       ,'Split measure is invalid'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 264);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,265
       ,null
       ,'Operation is invalid'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 265);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,266
       ,null
       ,'Operation Data and Job Operation Data Values do not tally'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 266);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,267
       ,null
       ,'You do not have NORMAL access to this item'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 267);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,268
       ,null
       ,'Cannot perform this operation on child hierarchical inventory types'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 268);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,269
       ,null
       ,'Asset Type has child item types which are not a mandatory AT relation'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 269);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,270
       ,null
       ,'Cannot perform operations before previous operation is completed'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 270);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,271
       ,null
       ,'Current status is not consistent with this operation'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 271);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,272
       ,null
       ,'Job is complete, there are no more operations to execute'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 272);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,273
       ,null
       ,'Running operation'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 273);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,274
       ,null
       ,'Running remaining operations...'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 274);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,275
       ,null
       ,'String length is invalid'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 275);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,276
       ,null
       ,'Begin MP must be less than End MP'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 276);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,277
       ,null
       ,'Begin MP is out of range of extent'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 277);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,278
       ,null
       ,'End MP is out of range of extent'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 278);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,279
       ,null
       ,'Node name cannot be specified when node type has a format mask associated'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 279);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,280
       ,null
       ,'This item is locked by a job that is currently in progress.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 280);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,281
       ,null
       ,'Both a begin mp and an end mp must be specified for continous items'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 281);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,282
       ,null
       ,'Parameter value is required'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 282);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,283
       ,null
       ,'Parameter value is invalid'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 283);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,284
       ,null
       ,'Specified NE_UNIQUE is not unique across all network types'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 284);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,285
       ,null
       ,'Cannot perform this operation on foreign table based inventory types'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 285);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,286
       ,null
       ,'There is no mail user defined for the highways owner'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 286);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,287
       ,null
       ,'There is no mail user defined for the current user'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 287);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,288
       ,null
       ,'Error trying to execute'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 288);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,289
       ,null
       ,'Unable to identify unique node purely by node name'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 289);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,290
       ,null
       ,'Gazeteer query can only be restricted by a single element-based set of conditions'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 290);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,291
       ,null
       ,'Unable to perform Gazeteer query. Query required for derivation is >32K in size'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 291);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,292
       ,null
       ,'First operator in a Gazeteer query must be AND'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 292);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,293
       ,null
       ,'Gazeteer query definition is invalid'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 293);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,294
       ,null
       ,'No attribute restrictions specified - will return data purely'||CHR(10)||' on the existence of an item of this type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 294);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,295
       ,null
       ,'You have selected a new item, would you like to reset the filter for this item?'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 295);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,296
       ,null
       ,'Invalid Gazeteer Query Type Type specified'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 296);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,297
       ,null
       ,'Too many matching values exist; use [List]'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 297);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,298
       ,null
       ,'Filtered Network'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 298);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,299
       ,null
       ,'GIS Selected Network'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 299);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,300
       ,null
       ,'Circular route - please rescale with no history'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 300);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,301
       ,null
       ,'You cannot add a distance break to an empty group'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 301);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,302
       ,null
       ,'You cannot add a distance break to a non-linear group'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 302);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,303
       ,null
       ,'Error creating parameter list'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 303);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,304
       ,null
       ,'Checking route structure...'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 304);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,305
       ,null
       ,'Invalid condition specified'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 305);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,306
       ,null
       ,'No network matches the filter criteria'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 306);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,307
       ,null
       ,'New Start Date may not be equal to old Start Date'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 307);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,308
       ,null
       ,'Cannot amend domain datatype. Current domain usage would conflict with new datatype'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 308);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,309
       ,null
       ,'Domain has invalid datatype for this attribute'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 309);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,310
       ,null
       ,'Invalid Run Parameters. Ensure that you define at least 1 function and inv type pair. And also specify the area of interest'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 310);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,311
       ,null
       ,'Cannot be run on datum elements'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 311);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,312
       ,null
       ,'Linear Reference is ambiguous'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 312);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,313
       ,null
       ,'Items of this type are not permitted in this query'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 313);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,314
       ,null
       ,'Foreign Table inventory types are not permitted in this query'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 314);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,315
       ,null
       ,'Internal Error : Record not found in placement array'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 315);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,316
       ,null
       ,'No Reference Items found in the selected area'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 316);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,317
       ,null
       ,'Route or Extent is incompatible with this operation'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 317);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,318
       ,null
       ,'No items found which match filter criteria'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 318);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,319
       ,null
       ,'Unable to run assets on route on dual-carriageway routes'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 319);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,320
       ,null
       ,'Region of interest must be linear'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 320);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,321
       ,null
       ,'Inconsistent Parameters'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 321);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,322
       ,null
       ,'Only a single gazeteer query may be saved as a PBI query at once'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 322);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,323
       ,null
       ,'Cannot perform operation on area which contains datum elements measured in different datum units'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 323);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,324
       ,null
       ,'Assets on Route can only be run to calculate information for Asset Types'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 324);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,325
       ,null
       ,'Not all items in current view can be shown.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 325);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,326
       ,null
       ,'Query retrieves no matching records'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 326);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,327
       ,null
       ,'Cannot lock record. No details passed to match record by'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 327);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,328
       ,null
       ,'Record has been updated by another user. Please re-query'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 328);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,329
       ,null
       ,'Cannot dynamically lock record. Required information missing from ROWTYPE parameter'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 329);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,330
       ,null
       ,'Table is not currently supported for dynamic record locking'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 330);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,331
       ,null
       ,'This process is not available on a network extent'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 331);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,332
       ,null
       ,'Optional attributes may not be used as exclusive inventory attributes'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 332);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,333
       ,null
       ,'Only NUMBER or domain-based VARCHAR2 fields may be used as exclusive inventory attributes'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 333);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,334
       ,null
       ,'Non-displayed attributes may not be flagged as mandatory'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 334);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,335
       ,null
       ,'Only VARCHAR2 network type columns may be specified as being domain based'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 335);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,336
       ,null
       ,'Cannot perform operation on non-linear network types'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 336);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,337
       ,null
       ,'Assets of this type may not be updated'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 337);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,338
       ,null
       ,'Attribute may not be updated'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 338);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,339
       ,null
       ,'You do not have permission to update this record'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 339);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,340
       ,null
       ,'Either Network Type of Group Type must be supplied'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 340);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,341
       ,null
       ,'Network Type and Group Type supplied are inconsistent'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 341);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,342
       ,null
       ,'Retrieving assets...'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 342);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,343
       ,null
       ,'Network Type is child in more than 1 auto-inclusion relationship'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 343);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,344
       ,null
       ,'Item must be located on the network'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 344);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,345
       ,null
       ,'A parent inclusion group type can only have one child network type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 345);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,346
       ,null
       ,'A column that is displayed and used to build the unique must be mandatory'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 346);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,347
       ,null
       ,'The unique for this element will be populated automatically'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 347);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,348
       ,null
       ,'Elements and inventory items of these types cannot be linked'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 348);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,349
       ,null
       ,'This group type is not associated with an inventory type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 349);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,350
       ,null
       ,'This element has no associated inventory item'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 350);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,351
       ,null
       ,'The value you have entered is not unique across all network types.'||CHR(10)||''||CHR(10)||'Please use the Gazetteer to select a specific item.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 351);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,352
       ,null
       ,'You cannot specify a Unique Format for a column with no Unique Sequence set'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 352);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,353
       ,null
       ,'Value must be an NM_ELEMENTS column, something that can be selected from DUAL or something that can be selected from NM_ELEMENTS (with column names as bind variables).'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 353);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,354
       ,null
       ,'All bind variables must be named after NM_ELEMENTS columns'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 354);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,355
       ,null
       ,'Cannot locate inventory - the item has future locations which would be affected.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 355);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,356
       ,null
       ,'Asset types used for group attributes must be continuous.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 356);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,357
       ,null
       ,'Operation can only be performed on datum elements and groups of sections.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 357);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,358
       ,null
       ,'Split position is invalid.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 358);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,359
       ,null
       ,'Group cannot be split at this node.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 359);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,360
       ,null
       ,'Position coincides with node(s).'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 360);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,361
       ,null
       ,'Element cannot be split.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 361);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,362
       ,null
       ,'You have chosen to re-use an existing node but no node has been specified.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 362);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,363
       ,null
       ,'Elements cannot be merged.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 363);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,364
       ,null
       ,'Elements are connected at more than one node.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 364);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,365
       ,null
       ,'Merge would result in reversal of route direction which is not permitted.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 365);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,366
       ,null
       ,'Group Start/End node(s) do not match Start/End node(s) of datum.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 366);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,367
       ,null
       ,'Group Offset does not coincide with Non-Ambiguous Offset.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 367);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,368
       ,null
       ,'A Primary does not exist for this Network Type. A Primary must be created first'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 368);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,369
       ,null
       ,'A Primary already exists for this Network Type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 369);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,370
       ,null
       ,'This combination of Network Type and Asset Type already exists'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 370);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,371
       ,null
       ,'A Primary does not exist for this Network Type/Group Type combination. A primary must be created first'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 371);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,372
       ,null
       ,'A Primary already exists for this Network Type/Group Type combination'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 372);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,373
       ,null
       ,'This combination of Network Type, Asset Type and Group Type already exists'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 373);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,374
       ,null
       ,'Cannot have multiple inventory item links for a Primary AD Type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 374);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,375
       ,null
       ,'An Asset item should only be associated with a single network element in the context of Associated Data'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 375);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,376
       ,null
       ,'This AD Type is flagged as Single Row - only one item allowed.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 376);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,377
       ,null
       ,'No Primary AD Type defined for Network Type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 377);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,378
       ,null
       ,'Element has memberships with a future start date'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 378);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,379
       ,null
       ,'Asset Type invalid for AD Type'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 379);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,380
       ,null
       ,'Invalid membership - '
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 380);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,381
       ,null
       ,'Parent Sub-Type must also be a sub-type within this Admin Type'
       ,'A parent sub-type has been defined that is not a sub-type within the same admin type.  Check sub-type rules.' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 381);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,382
       ,null
       ,'Cyclic relationship not permitted between Sub-Type and Parent Sub-Type'
       ,'The following invalid scenario has occurred....'||CHR(10)||'Sub-Type X    Parent Y'||CHR(10)||'Sub-Type Y   Parent X' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 382);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,383
       ,null
       ,'Admin Type for Group Type/Network Type does not match'
       ,'The admin type for the specified group type must match the admin type for sub-type.' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 383);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,384
       ,null
       ,'Admin Unit Sub-Type is invalid.  Check sub-type of both this admin unit and the parent admin unit'
       ,'The sub-type specified for the admin unit does not exist in the sub-type rules.' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 384);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,385
       ,null
       ,'Elements of the given group type already exist'
       ,'A group type to police cannot be specified in the sub-type rules if elements of that group type already exist.' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 385);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,386
       ,null
       ,'Element Group Type conflicts with Admin Unit Sub-Type rules'
       ,'Admin unit has been applied to an element which has a confling group type in the admin sub-type rules.' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 386);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,387
       ,null
       ,'Cannot perform action - Admin Type is locked'
       ,'Admin type has an admin type grouping of ''LOCKED'' which prevents insert/update/delete operations on admin units of this type.' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 387);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,388
       ,null
       ,'Invalid query defined for attribute'
       ,'Flexible attribute query does not parse.  Check the query syntax.' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 388);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,389
       ,null
       ,'Invalid value defined for attribute'
       ,'A specified value is invalid for an attribute.  If applicable, use a list of values to select a valid value. ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 389);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,390
       ,null
       ,'Query must return 3 columns'
       ,'Flexible attribute select statement must contain three columns.'||CHR(10)||'(1)ID - not shown in list of values but returned back to calling module'||CHR(10)||'(2)MEANING - shown in the list of values'||CHR(10)||'(3)CODE - shown in the list of values' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 390);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,391
       ,null
       ,'Query must contain a maximum of 1 bind variable'
       ,'More than the permitted 1 bind variable has been specified.' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 391);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,392
       ,null
       ,'Bind variable must also be a network type column for this network type'
       ,'The bind variable specified in the flexible attribute query is not a network type column for this given network type.' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 392);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,393
       ,null
       ,'Bind variable must also be a attribute for this inventory type'
       ,'The bind variable specified in the flexible attribute query is not a attribute for this given inventory type.' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 393);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,394
       ,null
       ,'Wilcard characters cannot be used to restrict the list of allowable values for an attribute'
       ,'''%'' has been specified against an attribute that is used to restrict the allowable values for the current attribute.' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 394);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,395
       ,null
       ,'Bind variable attribute must be of a lower sequence than the current flexible attribute'
       ,'The bind variable specified in the flexible attribute query appears after the current attribute, so cannot be used to restrict by.  Possibly re-sequence the flexible attributes.' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 395);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,396
       ,null
       ,'Specify either a domain or a query - not both'
       ,'A domain and a query have both been specified.' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 396);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,397
       ,null
       ,'Duplicate file name'
       ,'The filename specified is already loaded.' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 397);
--
--
--********** HIG_DOMAINS **********--
--
-- Columns
-- HDO_DOMAIN                     NOT NULL VARCHAR2(20)
--   HDO_PK (Pos 1)
-- HDO_PRODUCT                    NOT NULL VARCHAR2(6)
--   HDO_FK_HPR (Pos 1)
-- HDO_TITLE                      NOT NULL VARCHAR2(40)
-- HDO_CODE_LENGTH                NOT NULL NUMBER(3)
--
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'ADMIN TYPE GROUPINGS'
       ,'NET'
       ,'Admin Type Groupings'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'ADMIN TYPE GROUPINGS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'ADOPTION_STATUS'
       ,'HIG'
       ,'Adoption Status'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'ADOPTION_STATUS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'BOOLEAN'
       ,'HIG'
       ,'"TRUE" or "FALSE"'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'BOOLEAN');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'BOOLEAN_CONNECTORS'
       ,'HIG'
       ,'Boolean Connectors'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'BOOLEAN_CONNECTORS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'CARRIAGEWAY'
       ,'HIG'
       ,'Road Carriageway'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'CARRIAGEWAY');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'COMPLAINT_SOURCE'
       ,'HIG'
       ,'Enquiry Source Codes'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'COMPLAINT_SOURCE');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'CONTACT_ORG_TYPE'
       ,'HIG'
       ,'Organisation Contact Type'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'CONTACT_ORG_TYPE');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'CONTACT_PERSON_TYPE'
       ,'HIG'
       ,'Person Contact Type'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'CONTACT_PERSON_TYPE');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'CONTACT_TITLE'
       ,'HIG'
       ,'Title'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'CONTACT_TITLE');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'CONTACT_VIP'
       ,'HIG'
       ,'Complaints VIP flag'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'CONTACT_VIP');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'CSV_DELIMITERS'
       ,'HIG'
       ,'CSV Delimiting Characters'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'CSV_DELIMITERS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'CSV_LOAD_STATUSES'
       ,'HIG'
       ,'CSV File Load Statuses'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'CSV_LOAD_STATUSES');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'CSV_PROCESS_SUBTYPE'
       ,'HIG'
       ,'CSV File Load Process Sub-Types'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'CSV_PROCESS_SUBTYPE');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'CSV_PROCESS_TYPE'
       ,'HIG'
       ,'CSV File Load Process Types'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'CSV_PROCESS_TYPE');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'DATA_FORMAT'
       ,'HIG'
       ,'Valid Data Formats'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'DATA_FORMAT');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'DATE_FORMAT_MASK'
       ,'HIG'
       ,'Date Format Mask'
       ,15 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'DATE_FORMAT_MASK');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'DETERMINATION'
       ,'DOC'
       ,'Determination'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'DETERMINATION');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'DIRECTORY_SEPERATOR'
       ,'HIG'
       ,'Directory Seperator'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'DIRECTORY_SEPERATOR');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'DISCO_SUCK_TYPES'
       ,'HIG'
       ,'Discoverer "suck" types'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'DISCO_SUCK_TYPES');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'DISCO_VERSIONS'
       ,'HIG'
       ,'Discoverer Versions'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'DISCO_VERSIONS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'DOC_CATEGORIES'
       ,'HIG'
       ,'Document Categories'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'DOC_CATEGORIES');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'ELEC_DRAIN_CARR'
       ,'NET'
       ,'Elec/Drain/Carriageway'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'ELEC_DRAIN_CARR');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'EXTEND_ROUTE_ST_DATE'
       ,'NET'
       ,'Default Start Date when extending route'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'EXTEND_ROUTE_ST_DATE');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'FOOTWAY_CATEGORY'
       ,'HIG'
       ,'Footway Categories'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'FOOTWAY_CATEGORY');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'GAZMODE'
       ,'NET'
       ,'Default Gazetteer Mode'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'GAZMODE');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'GAZ_QRY_FIXED_COLS_E'
       ,'NET'
       ,'Fixed selectable cols for "E" gaz qry'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'GAZ_QRY_FIXED_COLS_E');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'GAZ_QRY_FIXED_COLS_I'
       ,'NET'
       ,'Fixed selectable cols for "I" gaz qry'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'GAZ_QRY_FIXED_COLS_I');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'GAZ_QRY_L_BRACKETS'
       ,'NET'
       ,'Opening Brackets for Gazeteer Queries'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'GAZ_QRY_L_BRACKETS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'GAZ_QRY_OPERATORS'
       ,'NET'
       ,'Allowable operators for Gazeteer Queries'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'GAZ_QRY_OPERATORS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'GAZ_QRY_R_BRACKETS'
       ,'NET'
       ,'Closing Brackets for Gazeteer Queries'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'GAZ_QRY_R_BRACKETS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'GAZ_QRY_TYPE_TYPES'
       ,'NET'
       ,'Item Type Types for Gazeteer Queries'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'GAZ_QRY_TYPE_TYPES');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'GEOMETRY_TYPE'
       ,'NET'
       ,'GIS Geometry Type'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'GEOMETRY_TYPE');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'GIS_TYPES'
       ,'HIG'
       ,'GIS Types'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'GIS_TYPES');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'GRI_GAZ_RESTRICTIONS'
       ,'HIG'
       ,'GRI Gazetteer Restrictions'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'GRI_GAZ_RESTRICTIONS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'HDN_JOIN_TYPES'
       ,'HIG'
       ,'HDN Join Types'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'HDN_JOIN_TYPES');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'HISTORY_OPERATION'
       ,'HIG'
       ,'Operations Recorded in History'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'HISTORY_OPERATION');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'IMAGE_TYPES'
       ,'HIG'
       ,'Image Types'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'IMAGE_TYPES');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'INV_CATEGORY'
       ,'NET'
       ,'Inventory Category'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'INV_CATEGORY');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'INV_RELATION'
       ,'HIG'
       ,'Inventory Groupings Relationships'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'INV_RELATION');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'JOB_STATUS'
       ,'HIG'
       ,'Job Status'
       ,11 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'JOB_STATUS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'LEG_NUMBERS'
       ,'NET'
       ,'Node Leg Numbers'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'LEG_NUMBERS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'LGAS'
       ,'NET'
       ,'Local Government Agancies'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'LGAS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'MAINTENANCE_CATEGORY'
       ,'HIG'
       ,'Road Maintenence Category'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'MAINTENANCE_CATEGORY');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'MC_INV_LD_ERR_STATUS'
       ,'HIG'
       ,'MapCapture Inventory Loader Error Status'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'MC_INV_LD_ERR_STATUS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'MODULE_TYPE'
       ,'HIG'
       ,'Module Types'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'MODULE_TYPE');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'MRG_OUTPUT_TYPE'
       ,'NET'
       ,'Merge Output Type'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'MRG_OUTPUT_TYPE');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'MRWA_OWNER'
       ,'NET'
       ,'MRWA OWNER CODE'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'MRWA_OWNER');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'NETWORK_DIRECTION'
       ,'HIG'
       ,'Network Direction'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'NETWORK_DIRECTION');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'NE_TYPE'
       ,'HIG'
       ,'Network Elements'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'NE_TYPE');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'NM_ELEMENTS_COLUMNS'
       ,'HIG'
       ,'NM Elements Table Columns'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'NM_ELEMENTS_COLUMNS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'NM_TYPES'
       ,'NET'
       ,'NM Types'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'NM_TYPES');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'PBI_CONDITION'
       ,'NET'
       ,'SQL Condition Types'
       ,11 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'PBI_CONDITION');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'PBI_SR_COND'
       ,'NET'
       ,'SQL Single Row Conditions'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'PBI_SR_COND');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'PEO_TITLE_CODE'
       ,'HIG'
       ,'Job Title Codes'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'PEO_TITLE_CODE');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'POE_TYPES'
       ,'NET'
       ,'POE Types'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'POE_TYPES');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'POP3_HEADER_FIELDS'
       ,'HIG'
       ,'Header Fields For POP3 Mail'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'POP3_HEADER_FIELDS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'PRIVILEGE_TYPE'
       ,'HIG'
       ,'Privilege Types'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'PRIVILEGE_TYPE');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'PROPERTY_TYPE'
       ,'HIG'
       ,'Property Type'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'PROPERTY_TYPE');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'ROAD_CARRIAGEWAY'
       ,'HIG'
       ,'Road Carriageway Types'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'ROAD_CARRIAGEWAY');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'ROAD_CLASS'
       ,'HIG'
       ,'Road Classes for Linkcode Prefix'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'ROAD_CLASS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'ROAD_ENVIRONMENT'
       ,'HIG'
       ,'Road Environment Types'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'ROAD_ENVIRONMENT');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'ROAD_TYPE'
       ,'HIG'
       ,'Road Types'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'ROAD_TYPE');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'RSE_NLA_TYPE'
       ,'HIG'
       ,'Non-Linear Area Types'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'RSE_NLA_TYPE');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'SAV_FORMAT'
       ,'NET'
       ,'Export Formats'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'SAV_FORMAT');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'SECTIONS'
       ,'HIG'
       ,'Road Section Classifications'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'SECTIONS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'SECTION_STATUS'
       ,'HIG'
       ,'Road Section Status'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'SECTION_STATUS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'SECT_LENGTH_STATUS'
       ,'NET'
       ,'Road Section length status'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'SECT_LENGTH_STATUS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'SECURITY_MODES'
       ,'HIG'
       ,'Security Access Modes'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'SECURITY_MODES');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'SURFACE_CONDITION'
       ,'HIG'
       ,'Road Surface Condition'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'SURFACE_CONDITION');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'THEME_TYPE'
       ,'NET'
       ,'GIS Theme Type'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'THEME_TYPE');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'USER_OPTIONS'
       ,'HIG'
       ,'Highways User Options'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'USER_OPTIONS');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'WEATHER_CONDITION'
       ,'HIG'
       ,'Weather Condition'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'WEATHER_CONDITION');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'XSP_VALUES'
       ,'MAI'
       ,'Valid Cross Sectional Positions'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'XSP_VALUES');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'X_ATTR_VAL_TYPES'
       ,'NET'
       ,'Cross Attribute Validation Types'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'X_ATTR_VAL_TYPES');
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'Y_OR_N'
       ,'HIG'
       ,'"Y"es or "N"o'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'Y_OR_N');
--
--
--********** HIG_OPTION_LIST **********--
--
-- Columns
-- HOL_ID                         NOT NULL VARCHAR2(10)
--   HOL_PK (Pos 1)
-- HOL_PRODUCT                    NOT NULL VARCHAR2(6)
--   HOL_HPR_FK (Pos 1)
-- HOL_NAME                       NOT NULL VARCHAR2(30)
-- HOL_REMARKS                    NOT NULL VARCHAR2(2000)
-- HOL_DOMAIN                              VARCHAR2(20)
--   HOL_DATATYPE_DOMAIN_CHK
--   HOL_HDO_FK (Pos 1)
-- HOL_DATATYPE                   NOT NULL VARCHAR2(8)
--   HOL_DATATYPE_CHK
--   HOL_DATATYPE_DOMAIN_CHK
--   HOL_MIXED_CASE_DATATYPE_CHK
-- HOL_MIXED_CASE                 NOT NULL VARCHAR2(1)
--   HOL_MIXED_CASE_CHK
--   HOL_MIXED_CASE_DATATYPE_CHK
--
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WEBMAINIMG'
       ,'HIG'
       ,'Image for main menu'
       ,'Image which is displayed in the main menu (NMWEB0000) on the HTML forms'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMAINIMG');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WEBMAINURL'
       ,'HIG'
       ,'URL for image in main menu'
       ,'URL which image (displayed in the main menu (NMWEB0000) on the HTML forms) takes you to'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMAINURL');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'NSGDATA'
       ,'HIG'
       ,'System uses NSG data'
       ,'This option is set to ''Y'' if the system is using an NSG network.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'NSGDATA');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DCDEXPATH'
       ,'NET'
       ,'DCD download directory'
       ,'Directory where DCD downloads are created'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DCDEXPATH');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SDESERVER'
       ,'HIG'
       ,'SDE Server'
       ,'Server on which SDE is running'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SDESERVER');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SDEINST'
       ,'HIG'
       ,'SDE instance name'
       ,'The name of the SDE instance'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SDEINST');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WEBMAPSERV'
       ,'NET'
       ,'Web Map Server'
       ,'The URL for the web map server'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMAPSERV');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DEBUGAUTON'
       ,'HIG'
       ,'Use Autonomous Debug'
       ,'If this is "Y", then whenever any debug output is written it will be written in an autonomous transaction, so the output is immediately visible and is not dependent on a commit in the calling session.'||CHR(10)||'This should normally be set to "Y" UNLESS you are running across a distributed database (DB Links) - exor Traffic Manager is one such example of this.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DEBUGAUTON');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DEFAORDPI'
       ,'NET'
       ,'Default AOR Dist Point Int'
       ,'Default Assets on a Route Distance Point Interval'
       ,''
       ,'NUMBER'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DEFAORDPI');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'AOREXTDINV'
       ,'NET'
       ,'AoR do not truncate inventory'
       ,'If this is "Y", then when running Assets on a Route on a part of a linear route any continuous inventory which was truncated by virtue of the beginning or end of the specified extent will be returned with the location of that item extended to the end of the current segment.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'AOREXTDINV');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'AORSTRMAP'
       ,'NET'
       ,'AoR strip map'
       ,'If this is "Y", then the strip map is switched on by default on the Assets On a Route results form.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'AORSTRMAP');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'REPOUTPATH'
       ,'HIG'
       ,'Reports Output Path'
       ,'Path for the output of reports'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'REPOUTPATH');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'UTL_URLDIR'
       ,'HIG'
       ,'Web Reports Output URL'
       ,'URL for Output via Spool and UTL_FILE'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'UTL_URLDIR');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'IDWINTITLE'
       ,'HIG'
       ,'Module ID on Window Titles'
       ,'When set, the module id will be displayed in client window titles.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'IDWINTITLE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'ATTRLSTSEP'
       ,'NET'
       ,'Inv Attribute List Separator'
       ,'The string that will separate attributes when they are viewed in a list.'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'ATTRLSTSEP');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WEBDOCPATH'
       ,'HIG'
       ,'Document Access Path'
       ,'Document Access Path as set in Document Access Information section of Database Access Descriptor (DAD) configuration'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBDOCPATH');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'EXTRTEDATE'
       ,'NET'
       ,'Ele Start Date on extend route'
       ,'Default Start Date when extending a route.  1 - Leave as Null, 2 - Inherit from previous Element, 3 - Effective Date, 4 - Previous Element membership'
       ,'EXTEND_ROUTE_ST_DATE'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'EXTRTEDATE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'RPRTSTYLE'
       ,'HIG'
       ,'Report Style'
       ,'Name of style to apply to report layouts'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'RPRTSTYLE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DISCEULUSR'
       ,'HIG'
       ,'Discoverer EUL User'
       ,'The Oracle user of the Discoverer EUL'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DISCEULUSR');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'LOGOIMAGE'
       ,'HIG'
       ,'Logo Image'
       ,'Name of image used for company logo'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'LOGOIMAGE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DISCO_VERS'
       ,'HIG'
       ,'Discoverer Version'
       ,'The version of Oracle Discoverer in use'
       ,'DISCO_VERSIONS'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DISCO_VERS');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'HIGWINTITL'
       ,'HIG'
       ,'Window title for Highways'
       ,'This is the window title for Highways by exor'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'HIGWINTITL');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SDOSINGSHP'
       ,'HIG'
       ,'Single Shape Inv'
       ,'If this is "Y", then inventory shapes will be constructed for each inventory record as multipart shapes. Otherwise they will be  constructed as single shapes for each location.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SDOSINGSHP');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SDODATEVW'
       ,'HIG'
       ,'Date Views as Themes'
       ,'If this is "Y", then inventory and route shapes will be registered as date-tracked views otherwise the date logic is performed by the client GIS'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SDODATEVW');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'REGSDELAY'
       ,'HIG'
       ,'Registration of SDE Layers'
       ,'Should the derived Spatial Layers be registered in the SDE schema'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'REGSDELAY');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'MAPCAP_DIR'
       ,'HIG'
       ,'The MapCapture Load directory'
       ,'The directory on the server where MapCapture survey files will be placed ready for loading into NM3.'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'MAPCAP_DIR');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'MAPCAP_INT'
       ,'HIG'
       ,'MapCapture load proces timeout'
       ,'The interval (in minutes) between MapCapture loads.'
       ,''
       ,'NUMBER'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'MAPCAP_INT');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'MAPCAP_EML'
       ,'HIG'
       ,'MapCapture email address'
       ,'The email group id the MapCapture loader will send emails to.'
       ,''
       ,'NUMBER'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'MAPCAP_EML');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WEBMENUMOD'
       ,'HIG'
       ,'HTML Main Menu Module'
       ,'Module to which the HTML forms "Main Menu" link takes you to'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMENUMOD');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WEBTOPIMG'
       ,'HIG'
       ,'Image for top frame'
       ,'Image which is displayed in the top frame on the HTML forms'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBTOPIMG');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SMTPDOMAIN'
       ,'HIG'
       ,'SMTP Domain'
       ,'This is the Domain which will be used by the NM3 Mailer for communicating with the SMTP server'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SMTPDOMAIN');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SMTPPORT'
       ,'HIG'
       ,'SMTP Port'
       ,'This is the port on which the SMTP server which will be used by the NM3 Mailer'||CHR(10)||'This is usually port 25'
       ,''
       ,'NUMBER'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SMTPPORT');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'NM3WEBHOST'
       ,'HIG'
       ,'NM3 Web Host'
       ,'This is the address of the apache server used by the NM3 components'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'NM3WEBHOST');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'NM3WEBPATH'
       ,'HIG'
       ,'NM3 Web Path'
       ,'This is the address Database Access Descriptor used by the NM3 components'||CHR(10)||'Note that the "pls" part of this IS case sensitive'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'NM3WEBPATH');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'MULTINVRTE'
       ,'NET'
       ,'Inventory On Multiple Routes'
       ,'When set to "Y" this flag allows inventory to be located across multiple routes'||CHR(10)||'If auto-inclusion is not being used then this MUST be set to "Y" if inventory is to be located across >1 datum element'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'MULTINVRTE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'XMLCRENODE'
       ,'NET'
       ,'Create node from XML Datums'
       ,'Should the system automaticall created nodes when datums are loaded via the XMl Datums loader.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'XMLCRENODE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'NM3WEBCSS'
       ,'HIG'
       ,'NM3 Path to CSS'
       ,'This is the address where the NM3WEB package looks for the cascading style sheet to be used in the NM3 HTML pages'||CHR(10)||'Note that this could be a full-blown web address'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'NM3WEBCSS');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'INVRTETAB'
       ,'NET'
       ,'Show Route Tab in Inv Form'
       ,'If set to Y the default tab in the Inventory form will be Route.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'INVRTETAB');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SQLLDR_ERR'
       ,'HIG'
       ,'SQL*Loader Allowed Errors'
       ,'The number of insert errors that will terminate the load. Default = 50, to stop on first error = 1'
       ,''
       ,'NUMBER'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SQLLDR_ERR');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SHOWINVPK'
       ,'NET'
       ,'Show Primary Key in Inv Form'
       ,'If set to Y the primary key will always be visible on the Inventory form, if N then the PK will only be visible if it is a flexible attribute.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SHOWINVPK');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'REVLEGNO'
       ,'NET'
       ,'Reverse Leg Nos on Route Rev'
       ,'Reverse Leg Nos on node usage records when reversing a route Reverse Leg Nos on node usage records when reversing a route. "Y" means that the Leg Number is reversed, otherwise it will be left as is'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'REVLEGNO');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'INVAPIPACK'
       ,'NET'
       ,'Create API pack. for inv type'
       ,'If this is "Y", then when the inventory views are recreated for a particular inventory type, then there will be a package called nm3api_inv_xxxx created which will have API calls in as wrappers to the nm3api_inv procedures'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'INVAPIPACK');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'INVROUTEVW'
       ,'NET'
       ,'Create inv on route views'
       ,'If this is "Y", then when the inventory views are recreated for a particular inventory type, then there will be a view created called v_nm_xxxx_on_route created which will show inventory relative to a temporary network extent'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'INVROUTEVW');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SDERUNLE'
       ,'NET'
       ,'Run Loadevents from server.'
       ,'If this is "Y", then when the create_sde_inv_shape_table and the process_membership_changes (nm3inv_sde) procedures are executed the SDE loadevents program will be run from the server. No batch files will be created'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SDERUNLE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'MRGAUTYPE'
       ,'NET'
       ,'AU Type for Merge Security'
       ,'This is the AU Type which is used for Merge Results Security'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'MRGAUTYPE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SDEBATDIR'
       ,'NET'
       ,'Create loadevents batch files.'
       ,'Indicates the directory in which to create  The loadevents batch files'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SDEBATDIR');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'BROWSERPTH'
       ,'HIG'
       ,'Path to Internet Explorer'
       ,'Path to IE'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'BROWSERPTH');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'PREFLRM'
       ,'NET'
       ,'Preferred LRM'
       ,'This is the group type of the preferred linear referencing method; this only takes effect if you have more than one LRM'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'PREFLRM');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DISPWDVIS'
       ,'NET'
       ,'Discoverer Password Visible'
       ,'If this is "Y", then the password will be visible when calling Discoverer on the web.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DISPWDVIS');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'ENQSTODEF'
       ,'DOC'
       ,'Raise Defects from Enquiries'
       ,'This option must be set to Y or N.'||CHR(10)||' In Public Enquries (DOC0150), if this option is set to Y then'||CHR(10)||' Defects (Repairs etc..) may be raised directly via the Raise'||CHR(10)||' Defects button.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'ENQSTODEF');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'PCOMMIT'
       ,'HIG'
       ,'Commit on count = set value'
       ,'This value to be used for performing large inserts or delete to avoid exceeding rollback segments'
       ,''
       ,'NUMBER'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'PCOMMIT');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'USEINVXSP'
       ,'NET'
       ,'Use Inventory XSP'
       ,'Y - YES N - NO'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'USEINVXSP');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'MRGPOE'
       ,'NET'
       ,'Split Merge Results at POE'
       ,'A value of "Y" means that merge query results will be split at any discontinuities (POEs) on the route'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'MRGPOE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'MRGROUTE'
       ,'NET'
       ,'Split Merge Results by route'
       ,'A value of "Y" means that merge query results will be split at any change of route'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'MRGROUTE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'CHECKROUTE'
       ,'NET'
       ,'Use route checks'
       ,'Check network connectivity when new elements are created.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'CHECKROUTE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SHAPE_TAB'
       ,'HIG'
       ,'SDM Shape Table Name'
       ,'This must hold the table name of the SDM Shapes table'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SHAPE_TAB');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SQLLDR_EXE'
       ,'HIG'
       ,'SQL*Loader Executable'
       ,'The name of the SQL*Loader executalbe.'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SQLLDR_EXE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'UTLFILEDIR'
       ,'NET'
       ,'UTL File Directory'
       ,'Directory where PL/SQL will read/write flat files'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'UTLFILEDIR');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DBWINTITLE'
       ,'HIG'
       ,'DB Info in Window Titles'
       ,'When set, connection and product information will be displayed in client window titles.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DBWINTITLE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'PBIPOE'
       ,'NET'
       ,'Split PBI Results at POE'
       ,'A value of "Y" means that PBI query results will be split at any discontinuities (POEs) on the route'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'PBIPOE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'INVVIEWSLK'
       ,'HIG'
       ,'Show SLK On Inventory Views'
       ,'Set to "Y" to include the parent inclusion route SLK details on the inventory view'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'INVVIEWSLK');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'MAPCAPTURE'
       ,'NET'
       ,'Is MapCapture Used'
       ,'Set this option to "Y" if this system uses MapCapture'||CHR(10)||'This will enable the inventory views required for MapCapture to be generated whenever the normal inventory views are created'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'MAPCAPTURE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DISWEBHOST'
       ,'HIG'
       ,'Discoverer Web Host'
       ,'The host for accessing Discoverer over the web.'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DISWEBHOST');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DISWEBPATH'
       ,'HIG'
       ,'Discoverer Web Path'
       ,'Path to Discoverer on the web host.'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DISWEBPATH');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DISBRNDIMG'
       ,'HIG'
       ,'Discoverer Web Brand Image'
       ,'URL for web Discoverer brand image.'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DISBRNDIMG');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DISCO_MODE'
       ,'HIG'
       ,'Discoverer Run Mode'
       ,'How highways will access Discoverer - via the web or client server.'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DISCO_MODE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DISFRMSTYL'
       ,'HIG'
       ,'Discoverer Web Frame Style'
       ,'Frame style for Discoverer over the web.'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DISFRMSTYL');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DISWINWDTH'
       ,'HIG'
       ,'Discoverer Web  Window Width'
       ,'Window width for Discoverer ocer the web.'
       ,''
       ,'NUMBER'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DISWINWDTH');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DISWINHGHT'
       ,'HIG'
       ,'Discoverer Web  Window Height'
       ,'Window height for Discoverer over the web.'
       ,''
       ,'NUMBER'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DISWINHGHT');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SHOWRTEDIR'
       ,'NET'
       ,'Show Route Direction'
       ,'Determines whether route direction is displayed.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SHOWRTEDIR');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DEFITEMTYP'
       ,'NET'
       ,'Default Reference Item Type'
       ,'Default reference item type for Assets on a Route.'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DEFITEMTYP');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'INH_PAR_AU'
       ,'NET'
       ,'Inherit AU in reclassify'
       ,'If this is set to "Y" then upon reclassification of a route, the admin unit of the datum elements in that route inherit the AU of the parent'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'INH_PAR_AU');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'GRIJOBPRM'
       ,'HIG'
       ,'Name of GRI job id param.'
       ,'Name of GRI job id param.'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'GRIJOBPRM');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SMTPSERVER'
       ,'HIG'
       ,'SMTP Server'
       ,'This is the SMTP server which will be used by the NM3 Mailer'||CHR(10)||'NOTE : Unless your SMTP server is set up to allow relaying (or it is configured to allow the DB server to send externally) you will only be able to send emails to internal email addresses'||CHR(10)||'One way around this is to have the DB server also acting as a SMTP server'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SMTPSERVER');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'HIGPUBSYN'
       ,'HIG'
       ,'Create Public Synonyms'
       ,'Enter a value of Y if public synonyms are employed to provide access to dynamically created objects such as Inventory views or accidents validation procedures etc.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'HIGPUBSYN');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'GISGRPTYPE'
       ,'NET'
       ,'GIS Road Group Type'
       ,'The type of road group created by the GIS'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'GISGRPTYPE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'HIGUSEIMAG'
       ,'HIG'
       ,'Launchpad Image Usage'
       ,'Use a value of TRUE to force the launchpad to use images'
       ,'BOOLEAN'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'HIGUSEIMAG');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'BATMAXPRN'
       ,'HIG'
       ,'Max Batch Print Warning Level'
       ,'This is the maximum number of items allowed to be batch printed, of the number of items goes above this limit a warning is given to the user'
       ,''
       ,'NUMBER'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'BATMAXPRN');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'NETINVCODE'
       ,'HIG'
       ,'Network Inventory Code'
       ,'This is the inventory code which is used to hold the road data flexible attributes'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'NETINVCODE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'NETUSELRS'
       ,'HIG'
       ,'Use of Linear Referencing'
       ,'This option allows the system to use different linear referencing methods. The module net1110 will allow chaining of sections in order to provide LRMs across routes/groups'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'NETUSELRS');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DEFUNITID'
       ,'HIG'
       ,'Default Unit Identifier'
       ,'This should be set to the ID of the unit of length which is the default unit of measurement and that which all road lengths are measured in.'
       ,''
       ,'NUMBER'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DEFUNITID');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'CLAIMANT'
       ,'DOC'
       ,'Code mapping for Complainant'
       ,'The Contact Type (ie. domain code value) that should be used for all complainants.'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'CLAIMANT');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'CLAIMROLE'
       ,'DOC'
       ,'Role for claims access'
       ,'The role a user must have to be able to access Public Enquiries marked as claims.'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'CLAIMROLE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DEFCMPDATE'
       ,'DOC'
       ,'Auto default completion date'
       ,'Y or N. Use Y to default enquiry completion date to today when it is marked as completed.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DEFCMPDATE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DEFCAT'
       ,'DOC'
       ,'Default value for Category'
       ,'The default value for category to be used on new enquiries.'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DEFCAT');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DEFCLASS'
       ,'DOC'
       ,'Default value for Class'
       ,'The default value for class to be used on new enquiries.'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DEFCLASS');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WOOLFCLASS'
       ,'DOC'
       ,'Class that implies WOOLF'
       ,'The class value to be used for WOOLF Enquiries.'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WOOLFCLASS');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WOOLFDAYS1'
       ,'DOC'
       ,'Days for first WOOLF date'
       ,'The number of days to be used when calculating the first WOOLF date.'
       ,''
       ,'NUMBER'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WOOLFDAYS1');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WOOLFDAYS2'
       ,'DOC'
       ,'Days for second WOOLF date'
       ,'The number of days to be used when calculating the second WOOLF date.'
       ,''
       ,'NUMBER'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WOOLFDAYS2');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WOOLFDAYS3'
       ,'DOC'
       ,'Days for third WOOLF date'
       ,'The number of days to be used when calculating the third WOOLF date.'
       ,''
       ,'NUMBER'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WOOLFDAYS3');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'AUTOACTION'
       ,'DOC'
       ,'Create Actions automatically'
       ,'Set to ''Y'' for Enquiry Actions to be created automatically, ''N'' for manual creation.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'AUTOACTION');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DEFSOURCE'
       ,'DOC'
       ,'Default value for Source'
       ,'The default value for Source to be used on new enquiries.'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DEFSOURCE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'USEACTIONS'
       ,'DOC'
       ,'Enquiry Actions available'
       ,'Should Enquiry Actions functionality be available.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'USEACTIONS');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'USEDAMAGE'
       ,'DOC'
       ,'Enquiry Damage available'
       ,'Should Enquiry Damage functionality be available.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'USEDAMAGE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'ENQATTOP'
       ,'DOC'
       ,'Enquires at top of screen'
       ,'In Public Enquiries module should the Enquires window appear above the Contacts window (''Y'' or ''N'')'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'ENQATTOP');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'ENQDATES'
       ,'DOC'
       ,'Use Enquiry follow up dates'
       ,'Should Acknowledgment/Follow Up/Woolf dates be available in the Public Enquiries module (''Y'' or ''N'')'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'ENQDATES');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'CLAIMCAT'
       ,'DOC'
       ,'Category using Claims data'
       ,'Should Cause, Injuries and Damage fields be displayed'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'CLAIMCAT');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'INTERNORG'
       ,'DOC'
       ,'Internal Organisation value'
       ,'The organisation a contact has to belong to if they are internal staff. Used in list of possible action assignees.'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'INTERNORG');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'USRTBLSPCE'
       ,'HIG'
       ,'Default User Tablespace'
       ,'This must be a valid tablespace name.'||CHR(10)||'In Maintain Users (HIG1832), this name appears as a default value for the users default tablespace whenever a new user is created.'||CHR(10)||'This option may be amended at any time.'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'USRTBLSPCE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'USRPROFILE'
       ,'HIG'
       ,'Default User Profile'
       ,'This option must be a valid Oracle7 user profile.'||CHR(10)||'In Maintain Users (HIG1832), this value appears as a default whenever a new user is created.'||CHR(10)||'This option may be amended at any time.'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'USRPROFILE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'USRQUOTA'
       ,'HIG'
       ,'Default User Quota'
       ,'This option must contain a valid disk quota in the format 999K or 999M.'||CHR(10)||'In Maintain Users (HIG1832), this value appears as a default quota for the user tablespace whenever a new user is created.'||CHR(10)||'This option may be amended at any time.'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'USRQUOTA');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WEEKEND'
       ,'HIG'
       ,'Weekend Day Numbers'
       ,'This option must contain a list of numeric values in the range 1 to 7.'||CHR(10)||'They define the days of the week which constitute the weekend in a particular country, for use in working day calculations.  The following convention must be adopted:'||CHR(10)||'1=Sunday 2=Monday ... 7=Saturday.'||CHR(10)||'Therefore in the UK this option will contain the value 1,7'||CHR(10)||'In the Inspection Loader (MAI2200), when repairs are loaded a repair due date calculation takes place. This may be based on working days or calendar days as indicated by the defect priority rules.'||CHR(10)||'In Maintain Defects (MAI3806) a similar calculation takes place when a repair is created.'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEEKEND');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'RMMSFLAG'
       ,'HIG'
       ,'RMMS Network Type Flag'
       ,'1=RMMS, 3=MMGR, 4=Welsh Office'||CHR(10)||'This flag identifies the type of road network.'||CHR(10)||'It affects the validation and display of certain road section attributes, such as linkcode and section number.'
       ,''
       ,'NUMBER'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'RMMSFLAG');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'HIGGISAVLB'
       ,'HIG'
       ,'GIS Availability Flag'
       ,'This option must be set to Y or N.  When set to Y, the GIS button is enabled on the launchpad'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'HIGGISAVLB');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DEFREPTYPE'
       ,'HIG'
       ,'Word Template Default Rep Type'
       ,'Default Document manager report type used inside the OLE generation of documents in MS Word'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DEFREPTYPE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DIRREPSTRN'
       ,'HIG'
       ,'Directory Separator'
       ,'Separator used in assembling file paths etc'
       ,'DIRECTORY_SEPERATOR'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DIRREPSTRN');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'GRILSTNAME'
       ,'HIG'
       ,'GRI Listener Name'
       ,'The pipe identifier string - A string which is used to uniquely identify all jobs associated with the particular highways schema.'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'GRILSTNAME');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'HIGGISTYPE'
       ,'HIG'
       ,'GIS Type'
       ,'A means of flagging the type of GIS which is interfaced to Highways - Either DDE, NONE or OTHER '
       ,'GIS_TYPES'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'HIGGISTYPE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'GRIDATE'
       ,'HIG'
       ,'GRI Format Mask'
       ,'Used in conjunction with the date property class to provide a flexible data format mask'
       ,'DATE_FORMAT_MASK'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'GRIDATE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'HTMLHLPST'
       ,'HIG'
       ,'WebHelp HTML Entry Point'
       ,'Entry Point for HTML help'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'HTMLHLPST');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'GAZMODE'
       ,'NET'
       ,'Gazetteer Mode'
       ,'This value is used to define which mode the gazetteer should open in, Standard or Advanced'
       ,'GAZMODE'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'GAZMODE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'GAZ_RGT'
       ,'NET'
       ,'Default Gazetteer Group Type'
       ,'This option is to set the prefered group type for the gazetteer'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'GAZ_RGT');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SDMREGULYR'
       ,'HIG'
       ,'Register user layers for SDM'
       ,'When set to Y the system will maintain a set of SDO/SDE metadata for all users'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SDMREGULYR');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SMTPAUDTIT'
       ,'HIG'
       ,'Audit info in mail titles'
       ,'If set to "Y" information about the sender will be included in the mail message title for any mails sent by the system'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SMTPAUDTIT');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WMSSERVER'
       ,'HIG'
       ,'WMS Server URL'
       ,'URL to specify the WMS Data Source'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WMSSERVER');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WMSLAYERS'
       ,'HIG'
       ,'WMS Layers'
       ,'Layers to be retrieved from WMS Data Source'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WMSLAYERS');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WMSLYRNAME'
       ,'HIG'
       ,'WMS Layer Name'
       ,'Display name for WMS Layer in Layer Control Tool'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WMSLYRNAME');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WMSSVCNAME'
       ,'HIG'
       ,'WMS Service Name'
       ,'Service Name to use for WMS Connector.'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WMSSVCNAME');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WMSIMGFMT'
       ,'HIG'
       ,'WMS Image Format'
       ,'Image format for WMS Connector'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WMSIMGFMT');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'HTML_BASE'
       ,'HIG'
       ,'WebHelp HTML Base'
       ,'Base URL for HTML help'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'HTML_BASE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SDOSURKEY'
       ,'HIG'
       ,'SDO Surrogate Key'
       ,'Register SDO layers with a surrogate primary key'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SDOSURKEY');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WEBMAPMSV'
       ,'HIG'
       ,'OMV Servlet URL'
       ,'URL to specify the Oracle Mapviewer Servlet'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMAPMSV');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WEBMAPNAME'
       ,'HIG'
       ,'Base Map'
       ,'Name of the Base Map as defined in Oracle metadata'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMAPNAME');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WEBMAPDSRC'
       ,'HIG'
       ,'Data Source'
       ,'Name of the JDBC Data Source connecting map server to RDBMS'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMAPDSRC');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WEBMAPDBUG'
       ,'HIG'
       ,'Map Debug'
       ,'Debug Level for Web Mapping. 0 is off - 1 is on'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMAPDBUG');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WEBMAPTITL'
       ,'HIG'
       ,'Map Banner'
       ,'Title Text for Web Mapping'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMAPTITL');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'OVRVWSTYLE'
       ,'HIG'
       ,'Overview Line Style'
       ,'Line style for overview map boundary indicator'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'OVRVWSTYLE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'LINESTYLE'
       ,'HIG'
       ,'Map Highlight Line Style'
       ,'Line style for Map Highlight'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'LINESTYLE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'POINTSTYLE'
       ,'HIG'
       ,'Map Highlight Point Style'
       ,'Point style for Map Highlight'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'POINTSTYLE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'JDBCHOST'
       ,'HIG'
       ,'JDBC Host'
       ,'JDBC Server Host Name'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'JDBCHOST');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'JDBCPORT'
       ,'HIG'
       ,'JDBC Port'
       ,'JDBC Port for Host Connection'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'JDBCPORT');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'JDBCSID'
       ,'HIG'
       ,'JDBC SID'
       ,'Oracle SID for JDBC Connection'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'JDBCSID');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'AUTOZOOM'
       ,'NET'
       ,'Map Synchronization'
       ,'Control of synchronisation of map with form contents. If set to Y then the mnap will be synchronized with the form.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'AUTOZOOM');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SAV_FORMAT'
       ,'NET'
       ,'Export Format'
       ,'Default export format'
       ,'SAV_FORMAT'
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SAV_FORMAT');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'DEFASSTYPE'
       ,'NET'
       ,'Default Asset Search'
       ,'Default asset type to search for'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'DEFASSTYPE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SDODEFNTH'
       ,'MAI'
       ,'SDO DEFECT Theme ID'
       ,'Theme ID of the DEFECT SDO layer'
       ,''
       ,'NUMBER'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SDODEFNTH');
--
--
--********** HIG_MODULES **********--
--
-- Columns
-- HMO_MODULE                     NOT NULL VARCHAR2(30)
--   HIG_MODULES_PK (Pos 1)
-- HMO_TITLE                      NOT NULL VARCHAR2(70)
-- HMO_FILENAME                   NOT NULL VARCHAR2(30)
-- HMO_MODULE_TYPE                NOT NULL VARCHAR2(3)
-- HMO_FASTPATH_OPTS                       VARCHAR2(30)
-- HMO_FASTPATH_INVALID           NOT NULL VARCHAR2(1)
-- HMO_USE_GRI                    NOT NULL VARCHAR2(1)
-- HMO_APPLICATION                         VARCHAR2(6)
-- HMO_MENU                                VARCHAR2(30)
--
--
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
        'ABOUT'
       ,'About Forms'
       ,'about'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'ABOUT');
--
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
        'ABOUT_SERVER'
       ,'About Server Objects'
       ,'about_server'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'ABOUT_SERVER');
--
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
        'AUDIT'
       ,'Audit Tables'
       ,'audit'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'AUDIT');
--
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
        'DOC0100'
       ,'Documents'
       ,'doc0100'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'DOC'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'DOC0100');
--
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
        'DOC0110'
       ,'Document Types'
       ,'doc0110'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'DOC'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'DOC0110');
--
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
        'DOC0112'
       ,'Document Classes'
       ,'doc0112'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'DOC'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'DOC0112');
--
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
        'DOC0114'
       ,'Circulation by Person'
       ,'doc0114'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'DOC'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'DOC0114');
--
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
        'DOC0115'
       ,'Circulation by Document'
       ,'doc0115'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'DOC'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'DOC0115');
--
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
        'DOC0116'
       ,'Keywords'
       ,'doc0116'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'DOC'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'DOC0116');
--
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
        'DOC0118'
       ,'Media/Locations'
       ,'doc0118'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'DOC'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'DOC0118');
--
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
        'DOC0120'
       ,'Associated Documents'
       ,'doc0120'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'DOC'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'DOC0120');
--
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
        'DOC0122'
       ,'Keyword Search'
       ,'doc0122'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'DOC'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'DOC0122');
--
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
        'DOC0130'
       ,'Document Gateways'
       ,'doc0130'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'DOC'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'DOC0130');
--
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
        'DOC0140'
       ,'List of Documents by Association'
       ,'doc0140'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'DOC'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'DOC0140');
--
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
        'DOC0200'
       ,'Select Template'
       ,'doc0200'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'DOC'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'DOC0200');
--
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
        'DOC0201'
       ,'Templates'
       ,'doc0201'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'DOC'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'DOC0201');
--
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
        'DOC0202'
       ,'Template Users'
       ,'doc0202'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'DOC'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'DOC0202');
--
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
        'DOCWEB0010'
       ,'Run Query'
       ,'dm3query.list_queries'
       ,'WEB'
       ,''
       ,'N'
       ,'N'
       ,'DOC'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'DOCWEB0010');
--
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
        'GIS'
       ,'GIS Availability (dummy module)'
       ,'GIS'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'HIG'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'GIS');
--
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
        'GIS0005'
       ,'GIS Projects'
       ,'gis0005'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'GIS0005');
--
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
        'GIS0010'
       ,'GIS Themes'
       ,'gis0010'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'GIS0010');
--
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
        'GISWEB0020'
       ,'Show items on web page'
       ,'nm3web_map.define_item_to_show'
       ,'WEB'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'GISWEB0020');
--
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
        'GISWEB0021'
       ,'Show item on web page'
       ,'nm3web_map.show_gdo'
       ,'WEB'
       ,''
       ,'Y'
       ,'N'
       ,'HIG'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'GISWEB0021');
--
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
        'GRI0200'
       ,'GRI Front End'
       ,'gri0200'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'GRI0200');
--
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
        'GRI0205'
       ,'Server based listener for running none forms based apps from clients'
       ,'gri0205'
       ,'SVR'
       ,''
       ,'Y'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'GRI0205');
--
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
        'GRI0210'
       ,'GRI Past Reports'
       ,'gri0210'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'GRI0210');
--
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
        'GRI0220'
       ,'GRI Modules'
       ,'gri0220'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'GRI0220');
--
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
        'GRI0230'
       ,'GRI Parameters'
       ,'gri0230'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'GRI0230');
--
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
        'GRI0240'
       ,'GRI Module Parameters'
       ,'gri0240'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'GRI0240');
--
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
        'GRI0250'
       ,'GRI Parameter Dependencies'
       ,'gri0250'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'GRI0250');
--
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
        'GRI9998'
       ,'GRI Server Test'
       ,'gri9998'
       ,'SVR'
       ,''
       ,'N'
       ,'Y'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'GRI9998');
--
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
        'GRI9999'
       ,'GRI Test Report'
       ,'gri9999'
       ,'R25'
       ,''
       ,'N'
       ,'Y'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'GRI9999');
--
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
        'HIG1220'
       ,'Intervals'
       ,'hig1220'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1220');
--
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
        'HIG1510'
       ,'Audited Data'
       ,'hig1510'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1510');
--
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
        'HIG1802'
       ,'Menu Options for a User'
       ,'hig1802'
       ,'R25'
       ,''
       ,'N'
       ,'Y'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1802');
--
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
        'HIG1804'
       ,'Menu Options for a Role'
       ,'hig1804'
       ,'R25'
       ,''
       ,'N'
       ,'Y'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1804');
--
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
        'HIG1806'
       ,'Fastpath'
       ,'hig1806'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1806');
--
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
        'HIG1807'
       ,'Favourites'
       ,'hig1807'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1807');
--
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
        'HIG1807A'
       ,'Favourites - Administer System Favs'
       ,'hig1807'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1807A');
--
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
        'HIG1808'
       ,'Search'
       ,'hig1808'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1808');
--
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
        'HIG1809'
       ,'Run Module'
       ,'hig1809'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1809');
--
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
        'HIG1810'
       ,'Colour Pallette'
       ,'hig1810'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1810');
--
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
        'HIG1815'
       ,'Contacts'
       ,'hig1815'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1815');
--
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
        'HIG1820'
       ,'Units and Conversions'
       ,'hig1820'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1820');
--
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
        'HIG1832'
       ,'Users'
       ,'hig1832'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1832');
--
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
        'HIG1833'
       ,'Change Password'
       ,'hig1833'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1833');
--
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
        'HIG1836'
       ,'Roles'
       ,'hig1836'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1836');
--
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
        'HIG1837'
       ,'User Option Administration'
       ,'hig1838'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1837');
--
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
        'HIG1838'
       ,'User Options'
       ,'hig1838'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1838');
--
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
        'HIG1839'
       ,'Module Keywords'
       ,'hig1839'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1839');
--
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
        'HIG1840'
       ,'User Preferences'
       ,'hig1840'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1840');
--
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
        'HIG1850'
       ,'Report Styles'
       ,'hig1850'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1850');
--
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
        'HIG1860'
       ,'Admin Units'
       ,'hig1860'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1860');
--
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
        'HIG1862'
       ,'Admin Units'
       ,'hig1862'
       ,'R25'
       ,''
       ,'N'
       ,'Y'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1862');
--
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
        'HIG1864'
       ,'Users Report'
       ,'hig1864'
       ,'R25'
       ,''
       ,'N'
       ,'Y'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1864');
--
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
        'HIG1866'
       ,'Users By Admin Unit'
       ,'hig1866'
       ,'R25'
       ,''
       ,'N'
       ,'Y'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1866');
--
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
        'HIG1868'
       ,'User Roles'
       ,'hig1868'
       ,'R25'
       ,''
       ,'N'
       ,'Y'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1868');
--
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
        'HIG1880'
       ,'Modules'
       ,'hig1880'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1880');
--
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
        'HIG1881'
       ,'Module Usages'
       ,'hig1881'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1881');
--
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
        'HIG1885'
       ,'Maintain URL Modules'
       ,'HIG1885'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1885');
--
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
        'HIG1890'
       ,'Products'
       ,'hig1890'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1890');
--
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
        'HIG1900'
       ,'Mail Users'
       ,'hig1900'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1900');
--
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
        'HIG1901'
       ,'Mail Groups'
       ,'hig1901'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1901');
--
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
        'HIG1903'
       ,'Mail Message Administration'
       ,'hig1903'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1903');
--
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
        'HIG1910'
       ,'POP3 Mail Server Definition'
       ,'hig1910'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1910');
--
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
        'HIG1911'
       ,'POP3 Mail Message View'
       ,'hig1911'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1911');
--
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
        'HIG1912'
       ,'POP3 Mail Processing Rules'
       ,'hig1912'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1912');
--
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
        'HIG1950'
       ,'Discoverer API Definition'
       ,'hig1950'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1950');
--
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
        'HIG2010'
       ,'CSV Loader Destination Tables'
       ,'hig2010'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG2010');
--
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
        'HIG2020'
       ,'CSV Loader File Definitions Tables'
       ,'hig2020'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG2020');
--
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
        'HIG2100'
       ,'Produce Database Healthcheck File'
       ,'HIG2100'
       ,'SQL'
       ,''
       ,'N'
       ,'Y'
       ,'HIG'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG2100');
--
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
        'HIG5000'
       ,'Maintain Entry Points'
       ,'HIG5000'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG5000');
--
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
        'HIG9110'
       ,'Status Codes'
       ,'hig9110'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG9110');
--
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
        'HIG9115'
       ,'List of Status Codes'
       ,'hig9115'
       ,'R25'
       ,''
       ,'N'
       ,'Y'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG9115');
--
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
        'HIG9120'
       ,'Domains'
       ,'hig9120'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG9120');
--
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
        'HIG9125'
       ,'List of Static Reference Data'
       ,'hig9125'
       ,'R25'
       ,''
       ,'N'
       ,'Y'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG9125');
--
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
        'HIG9130'
       ,'Product Options'
       ,'hig9130'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG9130');
--
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
        'HIG9135'
       ,'Product Option List'
       ,'hig9135'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG9135');
--
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
        'HIG9170'
       ,'Holidays'
       ,'hig9170'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG9170');
--
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
        'HIG9180'
       ,'v2 Errors'
       ,'hig9180'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG9180');
--
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
        'HIG9185'
       ,'v3 Errors'
       ,'hig9185'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG9185');
--
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
        'HIG9190'
       ,'TXT to PRN Conversion'
       ,'hig9190'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG9190');
--
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
        'HIGHWAYS'
       ,'Highways by exor Launchpad'
       ,'highways'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIGHWAYS');
--
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
        'HIGWEB1902'
       ,'Mail'
       ,'nm3web_mail.write_mail'
       ,'WEB'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIGWEB1902');
--
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
        'HIGWEB2030'
       ,'CSV File Upload'
       ,'nm3web_load.main'
       ,'WEB'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIGWEB2030');
--
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
        'NET1100'
       ,'Gazetteer'
       ,'net1100'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NET1100');
--
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
        'NM0001'
       ,'Node Types'
       ,'nm0001'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0001');
--
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
        'NM0002'
       ,'Network Types'
       ,'nm0002'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0002');
--
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
        'NM0004'
       ,'Group Types'
       ,'nm0004'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0004');
--
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
        'NM0101'
       ,'Nodes'
       ,'nm0101'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0101');
--
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
        'NM0105'
       ,'Elements'
       ,'nm0105'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0105');
--
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
        'NM0106'
       ,'Element Details'
       ,'nm0106'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0106');
--
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
        'NM0107'
       ,'Element Members'
       ,'nm0107'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0107');
--
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
        'NM0110'
       ,'Groups of Sections'
       ,'nm0110'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0110');
--
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
        'NM0111'
       ,'Circular Group Start Point'
       ,'nm0111'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0111');
--
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
        'NM0115'
       ,'Groups of Groups'
       ,'nm0115'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0115');
--
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
        'NM0120'
       ,'Create Network Extent'
       ,'nm0120'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0120');
--
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
        'NM0121'
       ,'Create Group'
       ,'nm0121'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0121');
--
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
        'NM0122'
       ,'Extent Limits'
       ,'nm0122'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0122');
--
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
        'NM0200'
       ,'Split Element'
       ,'nm0200'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0200');
--
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
        'NM0201'
       ,'Merge Elements'
       ,'nm0201'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0201');
--
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
        'NM0202'
       ,'Replace Element'
       ,'nm0202'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0202');
--
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
        'NM0203'
       ,'Undo Split'
       ,'nm0203'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0203');
--
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
        'NM0204'
       ,'Undo Merge'
       ,'nm0204'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0204');
--
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
        'NM0205'
       ,'Undo Replace'
       ,'nm0205'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0205');
--
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
        'NM0206'
       ,'Close Element'
       ,'nm0206'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0206');
--
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
        'NM0207'
       ,'Unclose Element'
       ,'nm0207'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0207');
--
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
        'NM0220'
       ,'Reclassify Element'
       ,'nm0220'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0220');
--
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
        'NM0301'
       ,'Asset Domains'
       ,'nm0301'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0301');
--
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
        'NM0305'
       ,'XSP and Reversal Rules'
       ,'nm0305'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0305');
--
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
        'NM0306'
       ,'Asset XSPs'
       ,'nm0306'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0306');
--
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
        'NM0410'
       ,'Inventory Metamodel'
       ,'nm0410'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0410');
--
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
        'NM0411'
       ,'Inventory Exclusive View Creation'
       ,'nm0411'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0411');
--
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
        'NM0415'
       ,'Inventory Attribute Sets'
       ,'nm0415'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0415');
--
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
        'NM0500'
       ,'Network Walker'
       ,'nm0500'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0500');
--
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
        'NM0510'
       ,'Asset Items'
       ,'nm0510'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0510');
--
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
        'NM0511'
       ,'Reconcile MapCapture Load Errors'
       ,'nm0511'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0511');
--
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
        'NM0515'
       ,'Locate Item'
       ,'nm0515'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0515');
--
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
        'NM0520'
       ,'Inventory Location History'
       ,'nm0520'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0520');
--
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
        'NM0530'
       ,'Global Asset Update'
       ,'nm0530'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0530');
--
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
        'NM0550'
       ,'Cross Attribute Validation Setup'
       ,'nm0550'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0550');
--
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
        'NM0551'
       ,'Cross Item Validation Setup'
       ,'nm0551'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0551');
--
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
        'NM0560'
       ,'Assets On A Route'
       ,'nm0560'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0560');
--
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
        'NM0561'
       ,'Assets on Route Results'
       ,'nm0560'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0561');
--
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
        'NM0562'
       ,'Assets On Route Report - By Offset'
       ,'nm0560'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0562');
--
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
        'NM0563'
       ,'Assets On Route Report- By Type and Offset'
       ,'nm0560'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0563');
--
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
        'NM0570'
       ,'Find Assets'
       ,'nm0570'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0570');
--
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
        'NM0571'
       ,'Matching Items'
       ,'nm0570'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0571');
--
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
        'NM0572'
       ,'Locator'
       ,'nm0572'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0572');
--
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
        'NM0580'
       ,'Create MapCapture Metadata File'
       ,'nm0580'
       ,'SQL'
       ,''
       ,'N'
       ,'Y'
       ,'NET'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0580');
--
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
        'NM0600'
       ,'Maintain Element XRefs'
       ,'nm0600'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0600');
--
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
        'NM0700'
       ,'Maintain Additional Data'
       ,'nm0700'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0700');
--
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
        'NM1100'
       ,'Gazetteer'
       ,'nm1100'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM1100');
--
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
        'NM1200'
       ,'SLK Calculator'
       ,'nm1200'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM1200');
--
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
        'NM1201'
       ,'Offset Calculator'
       ,'nm1201'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM1201');
--
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
        'NM1861'
       ,'Inventory Admin Unit Security Maintenance'
       ,'nm1861'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM1861');
--
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
        'NM2000'
       ,'Recalibrate Element'
       ,'nm2000'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM2000');
--
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
        'NM3010'
       ,'Job Operations'
       ,'nm3010'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM3010');
--
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
        'NM3020'
       ,'Job Types'
       ,'nm3020'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM3020');
--
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
        'NM3030'
       ,'Job Control'
       ,'nm3030'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM3030');
--
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
        'NM7040'
       ,'PBI Queries'
       ,'nm7040'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM7040');
--
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
        'NM7041'
       ,'PBI Query Results'
       ,'nm7041'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM7041');
--
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
        'NM7050'
       ,'Merge Queries'
       ,'nm7050'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM7050');
--
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
        'NM7051'
       ,'Merge Query Results'
       ,'nm7051'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM7051');
--
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
        'NM7052'
       ,'Merge Query'
       ,'nm7052'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM7052');
--
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
        'NM7053'
       ,'Merge Query Defaults'
       ,'nm7053'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM7053');
--
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
        'NM7055'
       ,'Merge File Definition'
       ,'nm7055'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM7055');
--
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
        'NM7057'
       ,'Merge Results Extract'
       ,'nm7057'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM7057');
--
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
        'NM7058'
       ,'Merge Query Roles'
       ,'nm7058'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM7058');
--
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
        'NM9999'
       ,'Extended LOV'
       ,'nm9999'
       ,'FMX'
       ,''
       ,'Y'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM9999');
--
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
        'NMWEB0000'
       ,'NM3 Web Main Menu'
       ,'nm3web.main_menu'
       ,'WEB'
       ,''
       ,'Y'
       ,'N'
       ,'NET'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NMWEB0000');
--
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
        'NMWEB0001'
       ,'About'
       ,'nm3web.about'
       ,'WEB'
       ,''
       ,'Y'
       ,'N'
       ,'HIG'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NMWEB0001');
--
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
        'NMWEB0002'
       ,'Help'
       ,'nm3web.help'
       ,'WEB'
       ,''
       ,'Y'
       ,'N'
       ,'HIG'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NMWEB0002');
--
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
        'NMWEB0003'
       ,'About Server Objects'
       ,'nm3web.about_server_objects'
       ,'WEB'
       ,''
       ,'Y'
       ,'N'
       ,'HIG'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NMWEB0003');
--
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
        'NMWEB0004'
       ,'Web Favourites'
       ,'nm3web_fav.show_favourites'
       ,'WEB'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NMWEB0004');
--
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
        'NMWEB0005'
       ,'NM3 Web APD'
       ,'nm3web_apd.launch_apd'
       ,'WEB'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NMWEB0005');
--
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
        'NMWEB0010'
       ,'XML Upload'
       ,'nm3upload.xml_upload'
       ,'WEB'
       ,''
       ,'Y'
       ,'N'
       ,'NET'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NMWEB0010');
--
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
        'NMWEB0020'
       ,'Engineering Dynamic Segmentation'
       ,'nm3web_eng_dynseg.main'
       ,'WEB'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NMWEB0020');
--
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
        'NMWEB0035'
       ,'Loaded Objects'
       ,'nm3upload.list_loaded'
       ,'WEB'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NMWEB0035');
--
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
        'NMWEB7057'
       ,'Submit Merge Query in batch'
       ,'nm3web_mrg.main'
       ,'WEB'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NMWEB7057');
--
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
        'NSG0020'
       ,'NSG Export'
       ,'nsg0020'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NSG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NSG0020');
--
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
        'NSG0021'
       ,'NSG Export Log'
       ,'nsg0021'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NSG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NSG0021');
--
--
--********** HIG_SEQUENCE_ASSOCIATIONS **********--
--
-- Columns
-- HSA_TABLE_NAME                 NOT NULL VARCHAR2(30)
--   HSA_PK (Pos 1)
--   HSA_UPPERCASE_CHK
-- HSA_COLUMN_NAME                NOT NULL VARCHAR2(30)
--   HSA_PK (Pos 2)
--   HSA_UPPERCASE_CHK
-- HSA_SEQUENCE_NAME              NOT NULL VARCHAR2(30)
--   HSA_UPPERCASE_CHK
-- HSA_LAST_REBUILD_DATE                   DATE
--
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'DOC_ACTIONS'
       ,'DAC_ID'
       ,'DAC_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'DOC_ACTIONS'
                    AND  HSA_COLUMN_NAME = 'DAC_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'DOC_DAMAGE_COSTS'
       ,'DDC_ID'
       ,'DDC_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'DOC_DAMAGE_COSTS'
                    AND  HSA_COLUMN_NAME = 'DDC_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'DOC_DAMAGE'
       ,'DDG_ID'
       ,'DDG_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'DOC_DAMAGE'
                    AND  HSA_COLUMN_NAME = 'DDG_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'DOC_LOCATIONS'
       ,'DLC_ID'
       ,'DLC_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'DOC_LOCATIONS'
                    AND  HSA_COLUMN_NAME = 'DLC_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'DOCS'
       ,'DOC_ID'
       ,'DOC_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'DOCS'
                    AND  HSA_COLUMN_NAME = 'DOC_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'DOC_QUERY'
       ,'DQ_ID'
       ,'DQ_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'DOC_QUERY'
                    AND  HSA_COLUMN_NAME = 'DQ_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'DOC_REDIR_PRIOR'
       ,'DRP_ID'
       ,'DRP_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'DOC_REDIR_PRIOR'
                    AND  HSA_COLUMN_NAME = 'DRP_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'HIG_ADDRESS'
       ,'HAD_ID'
       ,'HAD_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'HIG_ADDRESS'
                    AND  HSA_COLUMN_NAME = 'HAD_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'HIG_CONTACTS'
       ,'HCT_ID'
       ,'HCT_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'HIG_CONTACTS'
                    AND  HSA_COLUMN_NAME = 'HCT_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'HIG_USERS'
       ,'HUS_USER_ID'
       ,'HUS_USER_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'HIG_USERS'
                    AND  HSA_COLUMN_NAME = 'HUS_USER_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_INV_TYPE_ATTRIB_BANDINGS'
       ,'ITB_BANDING_ID'
       ,'ITB_BANDING_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_INV_TYPE_ATTRIB_BANDINGS'
                    AND  HSA_COLUMN_NAME = 'ITB_BANDING_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_INV_TYPE_ATTRIB_BAND_DETS'
       ,'ITD_BAND_SEQ'
       ,'ITD_BAND_SEQ_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_INV_TYPE_ATTRIB_BAND_DETS'
                    AND  HSA_COLUMN_NAME = 'ITD_BAND_SEQ');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_ADMIN_UNITS_ALL'
       ,'NAU_ADMIN_UNIT'
       ,'NAU_ADMIN_UNIT_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_ADMIN_UNITS_ALL'
                    AND  HSA_COLUMN_NAME = 'NAU_ADMIN_UNIT');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_DBUG'
       ,'ND_ID'
       ,'ND_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_DBUG'
                    AND  HSA_COLUMN_NAME = 'ND_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_EVENT_LOG'
       ,'NEL_ID'
       ,'NEL_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_EVENT_LOG'
                    AND  HSA_COLUMN_NAME = 'NEL_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_ELEMENTS_ALL'
       ,'NE_ID'
       ,'NE_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_ELEMENTS_ALL'
                    AND  HSA_COLUMN_NAME = 'NE_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_INV_ITEMS_ALL'
       ,'IIT_NE_ID'
       ,'NE_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_INV_ITEMS_ALL'
                    AND  HSA_COLUMN_NAME = 'IIT_NE_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_JOB_CONTROL'
       ,'NJC_JOB_ID'
       ,'NJC_JOB_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_JOB_CONTROL'
                    AND  HSA_COLUMN_NAME = 'NJC_JOB_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_JOB_OPERATIONS'
       ,'NJO_ID'
       ,'NJO_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_JOB_OPERATIONS'
                    AND  HSA_COLUMN_NAME = 'NJO_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_LOAD_DESTINATIONS'
       ,'NLD_ID'
       ,'NLD_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_LOAD_DESTINATIONS'
                    AND  HSA_COLUMN_NAME = 'NLD_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_LOAD_FILES'
       ,'NLF_ID'
       ,'NLF_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_LOAD_FILES'
                    AND  HSA_COLUMN_NAME = 'NLF_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_LAYER_SETS'
       ,'NLS_SET_ID'
       ,'NLS_SET_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_LAYER_SETS'
                    AND  HSA_COLUMN_NAME = 'NLS_SET_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_LAYERS'
       ,'NL_LAYER_ID'
       ,'NL_LAYER_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_LAYERS'
                    AND  HSA_COLUMN_NAME = 'NL_LAYER_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_MRG_OUTPUT_FILE'
       ,'NMF_ID'
       ,'NMF_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_MRG_OUTPUT_FILE'
                    AND  HSA_COLUMN_NAME = 'NMF_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_MAIL_GROUPS'
       ,'NMG_ID'
       ,'NMG_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_MAIL_GROUPS'
                    AND  HSA_COLUMN_NAME = 'NMG_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_MAIL_MESSAGE_TEXT'
       ,'NMMT_LINE_ID'
       ,'NMMT_LINE_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_MAIL_MESSAGE_TEXT'
                    AND  HSA_COLUMN_NAME = 'NMMT_LINE_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_MAIL_MESSAGE'
       ,'NMM_ID'
       ,'NMM_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_MAIL_MESSAGE'
                    AND  HSA_COLUMN_NAME = 'NMM_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_MRG_QUERY_ALL'
       ,'NMQ_ID'
       ,'NMQ_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_MRG_QUERY_ALL'
                    AND  HSA_COLUMN_NAME = 'NMQ_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_MAIL_USERS'
       ,'NMU_ID'
       ,'NMU_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_MAIL_USERS'
                    AND  HSA_COLUMN_NAME = 'NMU_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_NODES_ALL'
       ,'NO_NODE_ID'
       ,'NO_NODE_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_NODES_ALL'
                    AND  HSA_COLUMN_NAME = 'NO_NODE_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_PBI_QUERY'
       ,'NPQ_ID'
       ,'NPQ_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_PBI_QUERY'
                    AND  HSA_COLUMN_NAME = 'NPQ_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_POINTS'
       ,'NP_ID'
       ,'NP_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_POINTS'
                    AND  HSA_COLUMN_NAME = 'NP_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_MRG_CLASSES'
       ,'NQC_ID'
       ,'NQC_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_MRG_CLASSES'
                    AND  HSA_COLUMN_NAME = 'NQC_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_MRG_QUERY_TYPES_ALL'
       ,'NQT_SEQ_NO'
       ,'NQT_SEQ_NO_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_MRG_QUERY_TYPES_ALL'
                    AND  HSA_COLUMN_NAME = 'NQT_SEQ_NO');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_PBI_QUERY_TYPES'
       ,'NQT_SEQ_NO'
       ,'NQT_SEQ_NO_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_PBI_QUERY_TYPES'
                    AND  HSA_COLUMN_NAME = 'NQT_SEQ_NO');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_SAVED_EXTENTS'
       ,'NSE_ID'
       ,'NSE_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_SAVED_EXTENTS'
                    AND  HSA_COLUMN_NAME = 'NSE_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_SAVED_EXTENT_MEMBERS'
       ,'NSM_ID'
       ,'NSM_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_SAVED_EXTENT_MEMBERS'
                    AND  HSA_COLUMN_NAME = 'NSM_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_X_INV_CONDITIONS'
       ,'NXIC_ID'
       ,'NXIC_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_X_INV_CONDITIONS'
                    AND  HSA_COLUMN_NAME = 'NXIC_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_UNIT_DOMAINS'
       ,'UD_DOMAIN_ID'
       ,'UD_DOMAIN_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_UNIT_DOMAINS'
                    AND  HSA_COLUMN_NAME = 'UD_DOMAIN_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_UNITS'
       ,'UN_UNIT_ID'
       ,'UN_UNIT_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_UNITS'
                    AND  HSA_COLUMN_NAME = 'UN_UNIT_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_AREA_LOCK'
       ,'NAL_ID'
       ,'NAL_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_AREA_LOCK'
                    AND  HSA_COLUMN_NAME = 'NAL_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_NSG_EXPORT'
       ,'NXP_ID'
       ,'NXP_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_NSG_EXPORT'
                    AND  HSA_COLUMN_NAME = 'NXP_ID');
--
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_AU_SUB_TYPES'
       ,'NSTY_ID'
       ,'NSTY_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_AU_SUB_TYPES'
                    AND  HSA_COLUMN_NAME = 'NSTY_ID');
--
--
--********** HIG_CHECK_CONSTRAINT_ASSOCS **********--
--
-- Columns
-- HCCA_CONSTRAINT_NAME           NOT NULL VARCHAR2(30)
--   HCCA_PK (Pos 1)
--   HCCA_UPPERCASE_CHK
-- HCCA_TABLE_NAME                NOT NULL VARCHAR2(30)
--   HCCA_UPPERCASE_CHK
-- HCCA_NER_APPL                  NOT NULL VARCHAR2(6)
--   HCCA_NER_FK (Pos 1)
-- HCCA_NER_ID                    NOT NULL NUMBER(4)
--   HCCA_NER_FK (Pos 2)
--
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DCL_END_DATE_TCHK'
       ,'DOC_CLASS'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DCL_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DCL_START_DATE_TCHK'
       ,'DOC_CLASS'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DCL_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DGT_END_DATE_TCHK'
       ,'DOC_GATEWAYS'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DGT_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DGT_START_DATE_TCHK'
       ,'DOC_GATEWAYS'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DGT_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DLC_END_DATE_TCHK'
       ,'DOC_LOCATIONS'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DLC_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DLC_START_DATE_TCHK'
       ,'DOC_LOCATIONS'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DLC_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DMD_END_DATE_TCHK'
       ,'DOC_MEDIA'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DMD_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DMD_START_DATE_TCHK'
       ,'DOC_MEDIA'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DMD_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DTP_END_DATE_TCHK'
       ,'DOC_TYPES'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DTP_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DTP_START_DATE_TCHK'
       ,'DOC_TYPES'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DTP_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HCCA_UPPERCASE_CHK'
       ,'HIG_CHECK_CONSTRAINT_ASSOCS'
       ,'HIG'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HCCA_UPPERCASE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HCO_END_DATE_TCHK'
       ,'HIG_CODES'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HCO_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HCO_START_DATE_TCHK'
       ,'HIG_CODES'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HCO_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HCT_END_DATE_TCHK'
       ,'HIG_CONTACTS'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HCT_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HCT_START_DATE_TCHK'
       ,'HIG_CONTACTS'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HCT_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HSA_UPPERCASE_CHK'
       ,'HIG_SEQUENCE_ASSOCIATIONS'
       ,'HIG'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HSA_UPPERCASE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HSC_END_DATE_TCHK'
       ,'HIG_STATUS_CODES'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HSC_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HSC_START_DATE_TCHK'
       ,'HIG_STATUS_CODES'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HSC_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HUS_END_DATE_TCHK'
       ,'HIG_USERS'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HUS_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HUS_START_DATE_TCHK'
       ,'HIG_USERS'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HUS_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HUR_START_DATE_TCHK'
       ,'HIG_USER_ROLES'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HUR_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NAU_END_DATE_TCHK'
       ,'NM_ADMIN_UNITS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NAU_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NAU_START_DATE_TCHK'
       ,'NM_ADMIN_UNITS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NAU_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NE_END_DATE_TCHK'
       ,'NM_ELEMENTS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NE_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NE_START_DATE_TCHK'
       ,'NM_ELEMENTS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NE_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NE_UNIQUE_UPPER_CHK'
       ,'NM_ELEMENTS_ALL'
       ,'HIG'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NE_UNIQUE_UPPER_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NET_UNIQUE_CHK'
       ,'NM_EVENT_TYPES'
       ,'HIG'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NET_UNIQUE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NFP_ID_CHK'
       ,'NM_FILL_PATTERNS'
       ,'HIG'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NFP_ID_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NGR_END_DATE_TCHK'
       ,'NM_GROUP_RELATIONS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NGR_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NGR_START_DATE_TCHK'
       ,'NM_GROUP_RELATIONS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NGR_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NGT_END_DATE_TCHK'
       ,'NM_GROUP_TYPES_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NGT_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NGT_GROUP_TYPE_UPPER_CHK'
       ,'NM_GROUP_TYPES_ALL'
       ,'HIG'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NGT_GROUP_TYPE_UPPER_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NGT_START_DATE_TCHK'
       ,'NM_GROUP_TYPES_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NGT_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'IAL_END_DATE_TCHK'
       ,'NM_INV_ATTRI_LOOKUP_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'IAL_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'IAL_START_DATE_TCHK'
       ,'NM_INV_ATTRI_LOOKUP_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'IAL_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ID_END_DATE_TCHK'
       ,'NM_INV_DOMAINS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ID_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ID_START_DATE_TCHK'
       ,'NM_INV_DOMAINS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ID_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'IIT_END_DATE_TCHK'
       ,'NM_INV_ITEMS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'IIT_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'IIT_START_DATE_TCHK'
       ,'NM_INV_ITEMS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'IIT_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'IIG_END_DATE_TCHK'
       ,'NM_INV_ITEM_GROUPINGS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'IIG_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'IIG_START_DATE_TCHK'
       ,'NM_INV_ITEM_GROUPINGS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'IIG_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NIN_END_DATE_TCHK'
       ,'NM_INV_NW_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NIN_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NIN_START_DATE_TCHK'
       ,'NM_INV_NW_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NIN_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NIT_END_DATE_TCHK'
       ,'NM_INV_TYPES_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NIT_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NIT_INV_TYPE_UPPER_CHK'
       ,'NM_INV_TYPES_ALL'
       ,'HIG'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NIT_INV_TYPE_UPPER_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NIT_START_DATE_TCHK'
       ,'NM_INV_TYPES_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NIT_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ITA_END_DATE_TCHK'
       ,'NM_INV_TYPE_ATTRIBS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ITA_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ITA_START_DATE_TCHK'
       ,'NM_INV_TYPE_ATTRIBS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ITA_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ITG_END_DATE_TCHK'
       ,'NM_INV_TYPE_GROUPINGS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ITG_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ITG_START_DATE_TCHK'
       ,'NM_INV_TYPE_GROUPINGS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ITG_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NJC_UNIQUE_CHK'
       ,'NM_JOB_CONTROL'
       ,'HIG'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NJC_UNIQUE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLD_TABLE_NAME_CHK'
       ,'NM_LOAD_DESTINATIONS'
       ,'HIG'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLD_TABLE_NAME_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLD_TABLE_SHORT_NAME_CHK'
       ,'NM_LOAD_DESTINATIONS'
       ,'HIG'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLD_TABLE_SHORT_NAME_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLDD_COLUMN_NAME_CHK'
       ,'NM_LOAD_DESTINATION_DEFAULTS'
       ,'HIG'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLDD_COLUMN_NAME_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLF_UNIQUE_CHK'
       ,'NM_LOAD_FILES'
       ,'HIG'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLF_UNIQUE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLFC_HOLDING_COL_CHK'
       ,'NM_LOAD_FILE_COLS'
       ,'HIG'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLFC_HOLDING_COL_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NM_END_DATE_TCHK'
       ,'NM_MEMBERS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NM_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NM_START_DATE_TCHK'
       ,'NM_MEMBERS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NM_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMST_END_DATE_TCHK'
       ,'NM_MEMBERS_SDE_TEMP'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMST_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMST_START_DATE_TCHK'
       ,'NM_MEMBERS_SDE_TEMP'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMST_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMH_NM_END_DATE_TCHK'
       ,'NM_MEMBER_HISTORY'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMH_NM_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMH_NM_START_DATE_TCHK'
       ,'NM_MEMBER_HISTORY'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMH_NM_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NQC_NAME_CHK'
       ,'NM_MRG_CLASSES'
       ,'HIG'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NQC_NAME_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMC_VIEW_COL_NAME_CHK'
       ,'NM_MRG_OUTPUT_COLS'
       ,'HIG'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMC_VIEW_COL_NAME_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NO_END_DATE_TCHK'
       ,'NM_NODES_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NO_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NO_START_DATE_TCHK'
       ,'NM_NODES_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NO_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NNU_END_DATE_TCHK'
       ,'NM_NODE_USAGES_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NNU_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NNU_START_DATE_TCHK'
       ,'NM_NODE_USAGES_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NNU_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NNG_END_DATE_TCHK'
       ,'NM_NT_GROUPINGS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NNG_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NNG_START_DATE_TCHK'
       ,'NM_NT_GROUPINGS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NNG_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NS_END_DATE_TCHK'
       ,'NM_SHAPES_1'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NS_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NS_START_DATE_TCHK'
       ,'NM_SHAPES_1'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NS_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'TII_END_DATE_TCHK'
       ,'NM_TEMP_INV_ITEMS'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'TII_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'TII_START_DATE_TCHK'
       ,'NM_TEMP_INV_ITEMS'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'TII_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'TIM_END_DATE_TCHK'
       ,'NM_TEMP_INV_MEMBERS'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'TIM_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'TIM_START_DATE_TCHK'
       ,'NM_TEMP_INV_MEMBERS'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'TIM_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NT_TYPE_UPPER_CHK'
       ,'NM_TYPES'
       ,'HIG'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NT_TYPE_UPPER_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NTL_END_DATE_TCHK'
       ,'NM_TYPE_LAYERS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NTL_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NTL_START_DATE_TCHK'
       ,'NM_TYPE_LAYERS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NTL_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NSC_SUB_CLASS_UPPER_CHK'
       ,'NM_TYPE_SUBCLASS'
       ,'HIG'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NSC_SUB_CLASS_UPPER_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NUA_END_DATE_TCHK'
       ,'NM_USER_AUS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NUA_END_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NUA_START_DATE_TCHK'
       ,'NM_USER_AUS_ALL'
       ,'HIG'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NUA_START_DATE_TCHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NVA_ID_CHK'
       ,'NM_VISUAL_ATTRIBUTES'
       ,'HIG'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NVA_ID_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NWX_X_SECT_UPPER_CHK'
       ,'NM_XSP'
       ,'HIG'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NWX_X_SECT_UPPER_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMC_DISPLAY_SIGN_CHK'
       ,'NM_MRG_OUTPUT_COLS'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMC_DISPLAY_SIGN_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMF_YN_CHK'
       ,'NM_MRG_OUTPUT_FILE'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMF_YN_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMC_PAD_CHK'
       ,'NM_MRG_OUTPUT_COLS'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMC_PAD_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMC_DISP_DP_CHK'
       ,'NM_MRG_OUTPUT_COLS'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMC_DISP_DP_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HOL_MIXED_CASE_CHK'
       ,'HIG_OPTION_LIST'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HOL_MIXED_CASE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'GT_LOCATION_UPDATABLE_CHK'
       ,'GIS_THEMES_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'GT_LOCATION_UPDATABLE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ITA_EXCL_YN_CHK'
       ,'NM_INV_TYPE_ATTRIBS_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ITA_EXCL_YN_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NAT_UPDATE_CHK'
       ,'NM_AUDIT_TABLES'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NAT_UPDATE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NAT_DELETE_CHK'
       ,'NM_AUDIT_TABLES'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NAT_DELETE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NAT_INSERT_CHK'
       ,'NM_AUDIT_TABLES'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NAT_INSERT_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMM_HTML_CHK'
       ,'NM_MAIL_MESSAGE'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMM_HTML_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLFC_MANDATORY_CHK'
       ,'NM_LOAD_FILE_COLS'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLFC_MANDATORY_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NGQ_QUERY_ALL_ITEMS_CHK'
       ,'NM_GAZ_QUERY'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NGQ_QUERY_ALL_ITEMS_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_11049_GTF_S_000'
       ,'GIS_THEME_FUNCTIONS_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_11049_GTF_S_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_3268_HUS_I_000'
       ,'HIG_USERS'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_3268_HUS_I_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_3268_HUS_U_000'
       ,'HIG_USERS'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_3268_HUS_U_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_3268_HUS_U_001'
       ,'HIG_USERS'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_3268_HUS_U_001');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_3385_NGT_L_000'
       ,'NM_GROUP_TYPES_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_3385_NGT_L_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_3385_NGT_M_000'
       ,'NM_GROUP_TYPES_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_3385_NGT_M_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_3385_NGT_P_000'
       ,'NM_GROUP_TYPES_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_3385_NGT_P_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_3385_NGT_R_000'
       ,'NM_GROUP_TYPES_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_3385_NGT_R_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_3385_NGT_S_000'
       ,'NM_GROUP_TYPES_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_3385_NGT_S_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ICM_UPDATABLE_CHK'
       ,'NM_INV_CATEGORY_MODULES'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ICM_UPDATABLE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_3496_NIN_L_000'
       ,'NM_INV_NW_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_3496_NIN_L_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_2747_NIT_C_000'
       ,'NM_INV_TYPES_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_2747_NIT_C_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_2747_NIT_E_000'
       ,'NM_INV_TYPES_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_2747_NIT_E_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_2747_NIT_E_001'
       ,'NM_INV_TYPES_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_2747_NIT_E_001');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_2747_NIT_F_000'
       ,'NM_INV_TYPES_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_2747_NIT_F_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_2747_NIT_L_000'
       ,'NM_INV_TYPES_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_2747_NIT_L_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_2747_NIT_M_000'
       ,'NM_INV_TYPES_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_2747_NIT_M_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_2747_NIT_R_000'
       ,'NM_INV_TYPES_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_2747_NIT_R_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_2747_NIT_T_000'
       ,'NM_INV_TYPES_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_2747_NIT_T_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_2747_NIT_U_000'
       ,'NM_INV_TYPES_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_2747_NIT_U_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_2747_NIT_U_001'
       ,'NM_INV_TYPES_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_2747_NIT_U_001');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_2747_NIT_X_000'
       ,'NM_INV_TYPES_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_2747_NIT_X_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NOD_MANDATORY_CHK'
       ,'NM_OPERATION_DATA'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NOD_MANDATORY_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NJT_NW_LOCK_CHK'
       ,'NM_JOB_TYPES'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NJT_NW_LOCK_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_17932_NMQ_T_000'
       ,'NM_MRG_QUERY_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_17932_NMQ_T_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_2725_ITA_Q_000'
       ,'NM_INV_TYPE_ATTRIBS_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_2725_ITA_Q_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_3574_ITG_M_000'
       ,'NM_INV_TYPE_GROUPINGS_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_3574_ITG_M_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMS_IN_RESULTS_CHK'
       ,'NM_MRG_SECTIONS_ALL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMS_IN_RESULTS_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_2521_NT_DA_000'
       ,'NM_TYPES'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_2521_NT_DA_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_2521_NT_LI_000'
       ,'NM_TYPES'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_2521_NT_LI_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_2521_NT_PO_000'
       ,'NM_TYPES'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_2521_NT_PO_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_2590_NTC_D_000'
       ,'NM_TYPE_COLUMNS'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_2590_NTC_D_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_2590_NTC_I_000'
       ,'NM_TYPE_COLUMNS'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_2590_NTC_I_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_2590_NTC_M_000'
       ,'NM_TYPE_COLUMNS'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_2590_NTC_M_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_3481_NTI_A_000'
       ,'NM_TYPE_INCLUSION'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_3481_NTI_A_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_3481_NTI_A_001'
       ,'NM_TYPE_INCLUSION'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_3481_NTI_A_001');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_3481_NTI_R_000'
       ,'NM_TYPE_INCLUSION'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_3481_NTI_R_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_9208_NSR_A_000'
       ,'NM_TYPE_SUBCLASS_RESTRICTIONS'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_9208_NSR_A_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_45298_NXL_C_000'
       ,'NM_X_LOCATION_RULES'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_45298_NXL_C_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_45298_NXL_E_000'
       ,'NM_X_LOCATION_RULES'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_45298_NXL_E_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_45298_NXL_X_000'
       ,'NM_X_LOCATION_RULES'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_45298_NXL_X_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_16954_NXN_C_000'
       ,'NM_X_NW_RULES'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_16954_NXN_C_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_16954_NXN_E_000'
       ,'NM_X_NW_RULES'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_16954_NXN_E_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_2775_XRV_M_000'
       ,'XSP_REVERSAL'
       ,'HIG'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_2775_XRV_M_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_3631_ITR_M_000'
       ,'NM_INV_TYPE_ROLES'
       ,'HIG'
       ,170 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_3631_ITR_M_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'AVCON_3717_NUA_M_000'
       ,'NM_USER_AUS_ALL'
       ,'HIG'
       ,170 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'AVCON_3717_NUA_M_000');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HOL_DATATYPE_CHK'
       ,'HIG_OPTION_LIST'
       ,'HIG'
       ,171 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HOL_DATATYPE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ID_DATATYPE_CHK'
       ,'NM_INV_DOMAINS_ALL'
       ,'HIG'
       ,171 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ID_DATATYPE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ITA_FORMAT_CHK'
       ,'NM_INV_TYPE_ATTRIBS_ALL'
       ,'HIG'
       ,171 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ITA_FORMAT_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLFC_DATATYPE_CHK'
       ,'NM_LOAD_FILE_COLS'
       ,'HIG'
       ,171 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLFC_DATATYPE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMC_DATA_TYPE_CHK'
       ,'NM_MRG_OUTPUT_COLS'
       ,'HIG'
       ,171 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMC_DATA_TYPE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NOD_DATA_TYPE_CHK'
       ,'NM_OPERATION_DATA'
       ,'HIG'
       ,171 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NOD_DATA_TYPE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLFC_VARCHAR_SIZE_CHK2'
       ,'NM_LOAD_FILE_COLS'
       ,'NET'
       ,29 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLFC_VARCHAR_SIZE_CHK2');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NVA_BG_BLUE_CHK'
       ,'NM_VISUAL_ATTRIBUTES'
       ,'NET'
       ,29 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NVA_BG_BLUE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NVA_BG_GREEN_CHK'
       ,'NM_VISUAL_ATTRIBUTES'
       ,'NET'
       ,29 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NVA_BG_GREEN_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NVA_BG_RED_CHK'
       ,'NM_VISUAL_ATTRIBUTES'
       ,'NET'
       ,29 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NVA_BG_RED_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NVA_FG_BLUE_CHK'
       ,'NM_VISUAL_ATTRIBUTES'
       ,'NET'
       ,29 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NVA_FG_BLUE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NVA_FG_GREEN_CHK'
       ,'NM_VISUAL_ATTRIBUTES'
       ,'NET'
       ,29 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NVA_FG_GREEN_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NVA_FG_RED_CHK'
       ,'NM_VISUAL_ATTRIBUTES'
       ,'NET'
       ,29 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NVA_FG_RED_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NAC_COL_ID_INTEGER'
       ,'NM_AUDIT_COLUMNS'
       ,'HIG'
       ,172 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NAC_COL_ID_INTEGER');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NJO_SEQ_CHK'
       ,'NM_JOB_OPERATIONS'
       ,'HIG'
       ,172 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NJO_SEQ_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMC_DEC_PLACES_CHK4'
       ,'NM_MRG_OUTPUT_COLS'
       ,'HIG'
       ,172 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMC_DEC_PLACES_CHK4');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NOD_SEQ_CHK'
       ,'NM_OPERATION_DATA'
       ,'HIG'
       ,172 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NOD_SEQ_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMC_LENGTH_CHK'
       ,'NM_MRG_OUTPUT_COLS'
       ,'HIG'
       ,173 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMC_LENGTH_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMC_SEQ_NO_CHK'
       ,'NM_MRG_OUTPUT_COLS'
       ,'HIG'
       ,173 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMC_SEQ_NO_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NEA_SEVERITY_CHK'
       ,'NM_EVENT_ALERT_MAILS'
       ,'HIG'
       ,174 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NEA_SEVERITY_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NEL_SEVERITY_CHK'
       ,'NM_EVENT_LOG'
       ,'HIG'
       ,174 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NEL_SEVERITY_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NJO_BEGIN_MP_CHK'
       ,'NM_JOB_OPERATIONS'
       ,'HIG'
       ,174 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NJO_BEGIN_MP_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLFC_SEQ_NO_CHK'
       ,'NM_LOAD_FILE_COLS'
       ,'HIG'
       ,174 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLFC_SEQ_NO_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMC_DEC_PLACES_CHK3'
       ,'NM_MRG_OUTPUT_COLS'
       ,'HIG'
       ,174 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMC_DEC_PLACES_CHK3');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NGQA_BRACKET_CHK'
       ,'NM_GAZ_QUERY_ATTRIBS'
       ,'HIG'
       ,175 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NGQA_BRACKET_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NQA_BRACKET_CHK'
       ,'NM_PBI_QUERY_ATTRIBS'
       ,'HIG'
       ,175 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NQA_BRACKET_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NJC_NPE_JOB_ID_CHK'
       ,'NM_JOB_CONTROL'
       ,'HIG'
       ,176 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NJC_NPE_JOB_ID_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NJC_STATUS_CHK'
       ,'NM_JOB_CONTROL'
       ,'HIG'
       ,176 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NJC_STATUS_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NJO_STATUS_CHK'
       ,'NM_JOB_OPERATIONS'
       ,'HIG'
       ,176 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NJO_STATUS_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ITA_EXCL_MAND_CHECK'
       ,'NM_INV_TYPE_ATTRIBS_ALL'
       ,'NET'
       ,332 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ITA_EXCL_MAND_CHECK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ITA_EXCL_TYPE_CHK'
       ,'NM_INV_TYPE_ATTRIBS_ALL'
       ,'NET'
       ,333 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ITA_EXCL_TYPE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NGQA_OPERATOR_CHK'
       ,'NM_GAZ_QUERY_ATTRIBS'
       ,'HIG'
       ,177 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NGQA_OPERATOR_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NQA_OPERATOR_CHK'
       ,'NM_PBI_QUERY_ATTRIBS'
       ,'HIG'
       ,177 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NQA_OPERATOR_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NT_DATUM_NODE_CHK'
       ,'NM_TYPES'
       ,'NET'
       ,207 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NT_DATUM_NODE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NTC_DISPLAYED_MANDATORY_CHK'
       ,'NM_TYPE_COLUMNS'
       ,'NET'
       ,334 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NTC_DISPLAYED_MANDATORY_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NTC_DOMAIN_COL_TYPE_CHK'
       ,'NM_TYPE_COLUMNS'
       ,'NET'
       ,335 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NTC_DOMAIN_COL_TYPE_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLFC_DATE_FORMAT_MASK_CHK'
       ,'NM_LOAD_FILE_COLS'
       ,'HIG'
       ,183 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLFC_DATE_FORMAT_MASK_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NTC_UNIQUE_SEQ_MAND_CHK'
       ,'NM_TYPE_COLUMNS'
       ,'NET'
       ,346 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NTC_UNIQUE_SEQ_MAND_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ANALYSE_ALL_TABS_LOG_PK'
       ,'ANALYSE_ALL_TABS_LOG'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ANALYSE_ALL_TABS_LOG_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'COLOURS_PK'
       ,'COLOURS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'COLOURS_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'COL_UK'
       ,'COLOURS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'COL_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DOC_PK'
       ,'DOCS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DOC_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DAC_PK'
       ,'DOC_ACTIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DAC_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DAS_PK'
       ,'DOC_ASSOCS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DAS_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DCL_PK'
       ,'DOC_CLASS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DCL_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DCL_UK1'
       ,'DOC_CLASS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DCL_UK1');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DCP_PK'
       ,'DOC_COPIES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DCP_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DDG_PK'
       ,'DOC_DAMAGE'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DDG_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DDC_PK'
       ,'DOC_DAMAGE_COSTS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DDC_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DEC_PK'
       ,'DOC_ENQUIRY_CONTACTS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DEC_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DET_PK'
       ,'DOC_ENQUIRY_TYPES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DET_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DET_UNQ'
       ,'DOC_ENQUIRY_TYPES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DET_UNQ');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DGT_PK'
       ,'DOC_GATEWAYS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DGT_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DGT_UK1'
       ,'DOC_GATEWAYS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DGT_UK1');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DGS_PK'
       ,'DOC_GATE_SYNS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DGS_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DHI_PK'
       ,'DOC_HISTORY'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DHI_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DKY_PK'
       ,'DOC_KEYS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DKY_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DKW_PK'
       ,'DOC_KEYWORDS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DKW_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DLC_PK'
       ,'DOC_LOCATIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DLC_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DLC_UK'
       ,'DOC_LOCATIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DLC_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DMD_PK'
       ,'DOC_MEDIA'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DMD_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DMD_UK'
       ,'DOC_MEDIA'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DMD_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DQ_PK'
       ,'DOC_QUERY'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DQ_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DQ_UK'
       ,'DOC_QUERY'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DQ_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DQC_PK'
       ,'DOC_QUERY_COLS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DQC_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DRP_PK'
       ,'DOC_REDIR_PRIOR'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DRP_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DSC_PK'
       ,'DOC_STD_COSTS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DSC_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DSY_PK'
       ,'DOC_SYNONYMS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DSY_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DTC_PK'
       ,'DOC_TEMPLATE_COLUMNS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DTC_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DTG_PK'
       ,'DOC_TEMPLATE_GATEWAYS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DTG_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DTU_PK'
       ,'DOC_TEMPLATE_USERS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DTU_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DTP_PK'
       ,'DOC_TYPES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DTP_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'DTP_UK'
       ,'DOC_TYPES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'DTP_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'EXOR_VERSION_TAB_PK'
       ,'EXOR_VERSION_TAB'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'EXOR_VERSION_TAB_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'GDOBJ_PK'
       ,'GIS_DATA_OBJECTS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'GDOBJ_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'GIS_PROJECTS_PK'
       ,'GIS_PROJECTS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'GIS_PROJECTS_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'GT_PK'
       ,'GIS_THEMES_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'GT_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'GT_UK'
       ,'GIS_THEMES_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'GT_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'GTF_PK'
       ,'GIS_THEME_FUNCTIONS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'GTF_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'GTHR_PK'
       ,'GIS_THEME_ROLES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'GTHR_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'GL_PK'
       ,'GRI_LOV'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'GL_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'GRM_PK'
       ,'GRI_MODULES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'GRM_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'GMP_PK'
       ,'GRI_MODULE_PARAMS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'GMP_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'GP_PK'
       ,'GRI_PARAMS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'GP_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'GPD_PK'
       ,'GRI_PARAM_DEPENDENCIES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'GPD_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'GPL_PK'
       ,'GRI_PARAM_LOOKUP'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'GPL_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'GRR_PK'
       ,'GRI_REPORT_RUNS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'GRR_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'GRP_PK'
       ,'GRI_RUN_PARAMETERS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'GRP_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'GSP_PK'
       ,'GRI_SAVED_PARAMS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'GSP_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'GSS_PK'
       ,'GRI_SAVED_SETS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'GSS_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'GRS_PK'
       ,'GRI_SPOOL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'GRS_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'GTR_PK'
       ,'GROUP_TYPE_ROLES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'GTR_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HAD_PK'
       ,'HIG_ADDRESS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HAD_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HCCA_PK'
       ,'HIG_CHECK_CONSTRAINT_ASSOCS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HCCA_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HCO_PK'
       ,'HIG_CODES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HCO_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HCL_PK'
       ,'HIG_COLOURS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HCL_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HCT_PK'
       ,'HIG_CONTACTS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HCT_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HCA_PK'
       ,'HIG_CONTACT_ADDRESS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HCA_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HDBA_PK'
       ,'HIG_DISCO_BUSINESS_AREAS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HDBA_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HDBA_UK'
       ,'HIG_DISCO_BUSINESS_AREAS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HDBA_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HDCV_PK'
       ,'HIG_DISCO_COL_VALUES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HDCV_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HDCV_UK'
       ,'HIG_DISCO_COL_VALUES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HDCV_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HDFK_PK'
       ,'HIG_DISCO_FOREIGN_KEYS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HDFK_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HDFK_UK'
       ,'HIG_DISCO_FOREIGN_KEYS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HDFK_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HDKC_PK'
       ,'HIG_DISCO_FOREIGN_KEY_COLS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HDKC_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HDT_PK'
       ,'HIG_DISCO_TABLES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HDT_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HDT_UK1'
       ,'HIG_DISCO_TABLES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HDT_UK1');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HDT_UK2'
       ,'HIG_DISCO_TABLES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HDT_UK2');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HDTC_PK'
       ,'HIG_DISCO_TAB_COLUMNS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HDTC_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HDO_PK'
       ,'HIG_DOMAINS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HDO_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HER_PK'
       ,'HIG_ERRORS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HER_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HHO_PK'
       ,'HIG_HOLIDAYS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HHO_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HIG_MODULES_PK'
       ,'HIG_MODULES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HIG_MODULES_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HMH_PK'
       ,'HIG_MODULE_HISTORY'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HMH_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HMH_UK'
       ,'HIG_MODULE_HISTORY'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HMH_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HMK_PK'
       ,'HIG_MODULE_KEYWORDS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HMK_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HMR_PK'
       ,'HIG_MODULE_ROLES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HMR_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HMU_PK'
       ,'HIG_MODULE_USAGES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HMU_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HOL_PK'
       ,'HIG_OPTION_LIST'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HOL_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HOV_PK'
       ,'HIG_OPTION_VALUES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HOV_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HPR_PK'
       ,'HIG_PRODUCTS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HPR_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HPR_UK1'
       ,'HIG_PRODUCTS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HPR_UK1');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HRS_PK'
       ,'HIG_REPORT_STYLES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HRS_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HIG_ROLES_PK'
       ,'HIG_ROLES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HIG_ROLES_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HSA_PK'
       ,'HIG_SEQUENCE_ASSOCIATIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HSA_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HSC_PK'
       ,'HIG_STATUS_CODES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HSC_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HSC_UK1'
       ,'HIG_STATUS_CODES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HSC_UK1');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HSD_PK'
       ,'HIG_STATUS_DOMAINS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HSD_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HSF_PK'
       ,'HIG_SYSTEM_FAVOURITES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HSF_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HUP_PK'
       ,'HIG_UPGRADES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HUP_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HIG_USERS_PK'
       ,'HIG_USERS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HIG_USERS_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HUS_UK'
       ,'HIG_USERS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HUS_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HUF_PK'
       ,'HIG_USER_FAVOURITES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HUF_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HUH_PK'
       ,'HIG_USER_HISTORY'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HUH_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HUO_PK'
       ,'HIG_USER_OPTIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HUO_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HUR_PK'
       ,'HIG_USER_ROLES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HUR_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HWCH_PK'
       ,'HIG_WEB_CONTXT_HLP'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HWCH_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HAG_PK'
       ,'NM_ADMIN_GROUPS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HAG_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HAU_PK'
       ,'NM_ADMIN_UNITS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HAU_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HAU_UK1'
       ,'NM_ADMIN_UNITS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HAU_UK1');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HAU_UK2'
       ,'NM_ADMIN_UNITS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HAU_UK2');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NARH_PK'
       ,'NM_ASSETS_ON_ROUTE_HOLDING'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NARH_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NARS_PK'
       ,'NM_ASSETS_ON_ROUTE_STORE'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NARS_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NARSA_PK'
       ,'NM_ASSETS_ON_ROUTE_STORE_ATT'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NARSA_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NARSD_PK'
       ,'NM_ASSETS_ON_ROUTE_STORE_ATT_D'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NARSD_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NARSH_PK'
       ,'NM_ASSETS_ON_ROUTE_STORE_HEAD'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NARSH_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NARST_PK'
       ,'NM_ASSETS_ON_ROUTE_STORE_TOTAL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NARST_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NM_AUDIT_PK'
       ,'NM_AUDIT_ACTIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NM_AUDIT_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NACH_PK'
       ,'NM_AUDIT_CHANGES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NACH_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NM_AUDIT_COLUMNS_PK'
       ,'NM_AUDIT_COLUMNS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NM_AUDIT_COLUMNS_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NM_AUDIT_KEY_COLS_PK'
       ,'NM_AUDIT_KEY_COLS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NM_AUDIT_KEY_COLS_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NM_AUDIT_TABLES_PK'
       ,'NM_AUDIT_TABLES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NM_AUDIT_TABLES_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NM_AUDIT_TEMP_PK'
       ,'NM_AUDIT_TEMP'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NM_AUDIT_TEMP_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NAT_PK'
       ,'NM_AU_TYPES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NAT_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ND_PK'
       ,'NM_DBUG'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ND_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NE_PK'
       ,'NM_ELEMENTS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NE_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NE_UK'
       ,'NM_ELEMENTS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NE_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NEH_PK'
       ,'NM_ELEMENT_HISTORY'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NEH_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NER_PK'
       ,'NM_ERRORS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NER_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NEL_PK'
       ,'NM_EVENT_LOG'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NEL_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NET_PK'
       ,'NM_EVENT_TYPES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NET_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NET_UK'
       ,'NM_EVENT_TYPES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NET_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NFP_PK'
       ,'NM_FILL_PATTERNS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NFP_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NGQ_PK'
       ,'NM_GAZ_QUERY'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NGQ_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NGQA_PK'
       ,'NM_GAZ_QUERY_ATTRIBS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NGQA_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NGQI_PK'
       ,'NM_GAZ_QUERY_ITEM_LIST'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NGQI_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NGQT_PK'
       ,'NM_GAZ_QUERY_TYPES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NGQT_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NGQV_PK'
       ,'NM_GAZ_QUERY_VALUES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NGQV_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NGA_PK'
       ,'NM_GIS_AREA_OF_INTEREST'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NGA_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NGR_PK'
       ,'NM_GROUP_RELATIONS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NGR_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NGT_PK'
       ,'NM_GROUP_TYPES_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NGT_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NIAS_PK'
       ,'NM_INV_ATTRIBUTE_SETS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NIAS_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NSIA_PK'
       ,'NM_INV_ATTRIBUTE_SET_INV_ATTR'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NSIA_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NSIT_PK'
       ,'NM_INV_ATTRIBUTE_SET_INV_TYPES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NSIT_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'IAL_PK'
       ,'NM_INV_ATTRI_LOOKUP_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'IAL_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NIC_PK'
       ,'NM_INV_CATEGORIES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NIC_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ICM_PK'
       ,'NM_INV_CATEGORY_MODULES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ICM_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ID_PK'
       ,'NM_INV_DOMAINS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ID_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'INV_ITEMS_ALL_PK'
       ,'NM_INV_ITEMS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'INV_ITEMS_ALL_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'IIT_UK'
       ,'NM_INV_ITEMS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'IIT_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'IIG_PK'
       ,'NM_INV_ITEM_GROUPINGS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'IIG_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'IIG_UK'
       ,'NM_INV_ITEM_GROUPINGS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'IIG_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NIN_PK'
       ,'NM_INV_NW_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NIN_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ITY_PK'
       ,'NM_INV_TYPES_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ITY_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ITA_PK'
       ,'NM_INV_TYPE_ATTRIBS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ITA_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ITA_UK_VIEW_ATTRI'
       ,'NM_INV_TYPE_ATTRIBS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ITA_UK_VIEW_ATTRI');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ITA_UK_VIEW_COL'
       ,'NM_INV_TYPE_ATTRIBS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ITA_UK_VIEW_COL');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ITB_PK'
       ,'NM_INV_TYPE_ATTRIB_BANDINGS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ITB_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ITB_UK'
       ,'NM_INV_TYPE_ATTRIB_BANDINGS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ITB_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ITD_PK'
       ,'NM_INV_TYPE_ATTRIB_BAND_DETS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ITD_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NM_INV_TYPE_COLOURS_PK'
       ,'NM_INV_TYPE_COLOURS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NM_INV_TYPE_COLOURS_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ITG_PK'
       ,'NM_INV_TYPE_GROUPINGS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ITG_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'ITR_PK'
       ,'NM_INV_TYPE_ROLES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'ITR_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NJC_PK'
       ,'NM_JOB_CONTROL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NJC_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NM_JOB_CONTROL_UK'
       ,'NM_JOB_CONTROL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NM_JOB_CONTROL_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NJO_PK'
       ,'NM_JOB_OPERATIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NJO_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NJO_UK'
       ,'NM_JOB_OPERATIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NJO_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NJV_PK'
       ,'NM_JOB_OPERATION_DATA_VALUES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NJV_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NJT_PK'
       ,'NM_JOB_TYPES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NJT_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'JTO_PK'
       ,'NM_JOB_TYPES_OPERATIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'JTO_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NL_PK'
       ,'NM_LAYERS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NL_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLS_PK'
       ,'NM_LAYER_SETS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLS_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLB_PK'
       ,'NM_LOAD_BATCHES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLB_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLBS_PK'
       ,'NM_LOAD_BATCH_STATUS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLBS_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLD_PK'
       ,'NM_LOAD_DESTINATIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLD_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLD_UK1'
       ,'NM_LOAD_DESTINATIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLD_UK1');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLD_UK2'
       ,'NM_LOAD_DESTINATIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLD_UK2');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLDD_PK'
       ,'NM_LOAD_DESTINATION_DEFAULTS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLDD_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLF_PK'
       ,'NM_LOAD_FILES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLF_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLF_UK'
       ,'NM_LOAD_FILES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLF_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLFC_PK'
       ,'NM_LOAD_FILE_COLS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLFC_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLFC_UK'
       ,'NM_LOAD_FILE_COLS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLFC_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLCD_PK'
       ,'NM_LOAD_FILE_COL_DESTINATIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLCD_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLCD_UK'
       ,'NM_LOAD_FILE_COL_DESTINATIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLCD_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLFD_PK'
       ,'NM_LOAD_FILE_DESTINATIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLFD_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NLFD_UK'
       ,'NM_LOAD_FILE_DESTINATIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NLFD_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMG_PK'
       ,'NM_MAIL_GROUPS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMG_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMGM_PK'
       ,'NM_MAIL_GROUP_MEMBERSHIP'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMGM_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMM_PK'
       ,'NM_MAIL_MESSAGE'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMM_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMMR_PK'
       ,'NM_MAIL_MESSAGE_RECIPIENTS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMMR_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMMT_PK'
       ,'NM_MAIL_MESSAGE_TEXT'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMMT_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMU_PK'
       ,'NM_MAIL_USERS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMU_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NM_PK'
       ,'NM_MEMBERS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NM_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMST_PK'
       ,'NM_MEMBERS_SDE_TEMP'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMST_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMH_PK'
       ,'NM_MEMBER_HISTORY'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMH_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NDQA_PK'
       ,'NM_MRG_DEFAULT_QUERY_ATTRIBS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NDQA_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NDQT_PK'
       ,'NM_MRG_DEFAULT_QUERY_TYPES_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NDQT_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMID_PK'
       ,'NM_MRG_INV_DERIVATION'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMID_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMM2_UK'
       ,'NM_MRG_MEMBERS2'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMM2_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMC_PK'
       ,'NM_MRG_OUTPUT_COLS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMC_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMC_UK'
       ,'NM_MRG_OUTPUT_COLS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMC_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMCD_PK'
       ,'NM_MRG_OUTPUT_COL_DECODE'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMCD_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMF_PK'
       ,'NM_MRG_OUTPUT_FILE'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMF_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMF_UK'
       ,'NM_MRG_OUTPUT_FILE'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMF_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMQ_PK'
       ,'NM_MRG_QUERY_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMQ_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMQ_UK'
       ,'NM_MRG_QUERY_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMQ_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMQA_PK'
       ,'NM_MRG_QUERY_ATTRIBS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMQA_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMQR_PK'
       ,'NM_MRG_QUERY_RESULTS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMQR_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMQRT2_PK'
       ,'NM_MRG_QUERY_RESULTS_TEMP2'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMQRT2_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NQRO_PK'
       ,'NM_MRG_QUERY_ROLES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NQRO_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMQT_PK'
       ,'NM_MRG_QUERY_TYPES_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMQT_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NQU_PK'
       ,'NM_MRG_QUERY_USERS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NQU_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMQV_PK'
       ,'NM_MRG_QUERY_VALUES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMQV_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMS_PK'
       ,'NM_MRG_SECTIONS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMS_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMSIV_PK'
       ,'NM_MRG_SECTION_INV_VALUES_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMSIV_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMSM_PK'
       ,'NM_MRG_SECTION_MEMBERS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMSM_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NN_PK'
       ,'NM_NODES_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NN_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NN_UK'
       ,'NM_NODES_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NN_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NNT_PK'
       ,'NM_NODE_TYPES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NNT_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NNU_PK'
       ,'NM_NODE_USAGES_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NNU_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NNG_PK'
       ,'NM_NT_GROUPINGS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NNG_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NPE_PK'
       ,'NM_NW_PERSISTENT_EXTENTS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NPE_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMO_PK'
       ,'NM_OPERATIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMO_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NOD_PK'
       ,'NM_OPERATION_DATA'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NOD_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NOD_UK'
       ,'NM_OPERATION_DATA'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NOD_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NOD_SCRN_TEXT_UK'
       ,'NM_OPERATION_DATA'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NOD_SCRN_TEXT_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NPQ_PK'
       ,'NM_PBI_QUERY'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NPQ_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NPQ_UK'
       ,'NM_PBI_QUERY'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NPQ_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NQA_PK'
       ,'NM_PBI_QUERY_ATTRIBS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NQA_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NQR_PK'
       ,'NM_PBI_QUERY_RESULTS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NQR_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NQT_PK'
       ,'NM_PBI_QUERY_TYPES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NQT_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NQV_PK'
       ,'NM_PBI_QUERY_VALUES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NQV_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NPS_PK'
       ,'NM_PBI_SECTIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NPS_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NPM_PK'
       ,'NM_PBI_SECTION_MEMBERS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NPM_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NP_PK'
       ,'NM_POINTS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NP_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NRD_UK'
       ,'NM_RECLASS_DETAILS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NRD_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NRD_PK'
       ,'NM_RECLASS_DETAILS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NRD_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NRT_PK'
       ,'NM_RESCALE_SEG_TREE'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NRT_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NRT_UK'
       ,'NM_RESCALE_SEG_TREE'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NRT_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMR_PK'
       ,'NM_REVERSAL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMR_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NSE_PK'
       ,'NM_SAVED_EXTENTS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NSE_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NSE_UK'
       ,'NM_SAVED_EXTENTS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NSE_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NSM_PK'
       ,'NM_SAVED_EXTENT_MEMBERS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NSM_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NSD_PK'
       ,'NM_SAVED_EXTENT_MEMBER_DATUMS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NSD_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NMTR_PK'
       ,'NM_SDE_TEMP_RESCALE'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NMTR_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NS_PK'
       ,'NM_SHAPES_1'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NS_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'TII_PK'
       ,'NM_TEMP_INV_ITEMS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'TII_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'TIL_PK'
       ,'NM_TEMP_INV_ITEMS_LIST'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'TIL_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'TII_TEMP_PK'
       ,'NM_TEMP_INV_ITEMS_TEMP'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'TII_TEMP_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'TIM_PK'
       ,'NM_TEMP_INV_MEMBERS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'TIM_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'TIM_TEMP_PK'
       ,'NM_TEMP_INV_MEMBERS_TEMP'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'TIM_TEMP_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NM_TEMP_NODES_PK'
       ,'NM_TEMP_NODES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NM_TEMP_NODES_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NT_PK'
       ,'NM_TYPES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NT_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NT_UK'
       ,'NM_TYPES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NT_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NTC_PK'
       ,'NM_TYPE_COLUMNS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NTC_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NTI_PK'
       ,'NM_TYPE_INCLUSION'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NTI_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NTI_UK'
       ,'NM_TYPE_INCLUSION'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NTI_UK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NTL_PK'
       ,'NM_TYPE_LAYERS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NTL_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NSC_PK'
       ,'NM_TYPE_SUBCLASS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NSC_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NSR_PK'
       ,'NM_TYPE_SUBCLASS_RESTRICTIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NSR_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'UN_PK'
       ,'NM_UNITS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'UN_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'UC_PK'
       ,'NM_UNIT_CONVERSIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'UC_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'UK_PK'
       ,'NM_UNIT_DOMAINS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'UK_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NUF_PK'
       ,'NM_UPLOAD_FILES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NUF_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NUA_PK'
       ,'NM_USER_AUS_ALL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NUA_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NVA_PK'
       ,'NM_VISUAL_ATTRIBUTES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NVA_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NM_XML_FILES_PK'
       ,'NM_XML_FILES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NM_XML_FILES_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NM_XML_BATCHES_PK'
       ,'NM_XML_LOAD_BATCHES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NM_XML_BATCHES_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NM_XML_LOAD_ERRORS_PK'
       ,'NM_XML_LOAD_ERRORS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NM_XML_LOAD_ERRORS_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NWX_PK'
       ,'NM_XSP'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NWX_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NXD_PK'
       ,'NM_X_DRIVING_CONDITIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NXD_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NXE_PK'
       ,'NM_X_ERRORS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NXE_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NXIC_PK'
       ,'NM_X_INV_CONDITIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NXIC_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NXL_PK'
       ,'NM_X_LOCATION_RULES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NXL_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NXN_PK'
       ,'NM_X_NW_RULES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NXN_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'PK_NM_X_RULES'
       ,'NM_X_RULES'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'PK_NM_X_RULES');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NXV_PK'
       ,'NM_X_VAL_CONDITIONS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NXV_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'XSR_PK'
       ,'XSP_RESTRAINTS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'XSR_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'XRV_PK'
       ,'XSP_REVERSAL'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'XRV_PK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NTC_UNIQUE_FORMAT_CHK'
       ,'NM_TYPE_COLUMNS'
       ,'NET'
       ,352 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NTC_UNIQUE_FORMAT_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NIT_CAT_PNT_CONT_CHK'
       ,'NM_INV_TYPES_ALL'
       ,'NET'
       ,356 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NIT_CAT_PNT_CONT_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HSTF_CONNECT_LOOP_CHK'
       ,'HIG_STANDARD_FAVOURITES'
       ,'HIG'
       ,222 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HSTF_CONNECT_LOOP_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HSF_CONNECT_LOOP_CHK'
       ,'HIG_SYSTEM_FAVOURITES'
       ,'HIG'
       ,222 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HSF_CONNECT_LOOP_CHK');
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'HUF_CONNECT_LOOP_CHK'
       ,'HIG_USER_FAVOURITES'
       ,'HIG'
       ,222 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'HUF_CONNECT_LOOP_CHK');
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
