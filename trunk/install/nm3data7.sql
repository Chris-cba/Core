-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3data7.sql-arc   2.22   Mar 25 2011 09:35:34   Mike.Alexander  $
--       Module Name      : $Workfile:   nm3data7.sql  $
--       Date into PVCS   : $Date:   Mar 25 2011 09:35:34  $
--       Date fetched Out : $Modtime:   Mar 25 2011 09:31:52  $
--       Version          : $Revision:   2.22  $
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
--   NM_ERRORS
--
-----------------------------------------------------------------------------


set define off;
set feedback off;

---------------------------------
-- START OF GENERATED METADATA --
---------------------------------


----------------------------------------------------------------------------------------
-- NM_ERRORS
--
-- select * from nm3_metadata.nm_errors
-- order by ner_appl
--         ,ner_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_errors
SET TERM OFF

DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'DOC'
  AND  NER_ID = 1;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'DOC'
       ,1
       ,null
       ,'A Document Bundle of this name already exists'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 1;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 2;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 3;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 4;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 5;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 6;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 7;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 8;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 9;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 10;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 11;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 12;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 13;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 14;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 15;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 16;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 17;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 18;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 19;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 20;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 21;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 22;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 23;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 24;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 25;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 26;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 27;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 28;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 29;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 30;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 31;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 32;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 33;
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
       ,'Record locked by another user. Try again later.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 34;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 35;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 36;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 37;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 38;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 39;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 40;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 41;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 42;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 43;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 44;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 45;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 46;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 47;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 48;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 49;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 50;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 51;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 52;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 53;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 54;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 55;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 56;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 57;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 58;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 59;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 60;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 61;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 62;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 63;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 64;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 65;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 66;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 67;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 68;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 69;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 70;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 71;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 72;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 73;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 74;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 75;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 76;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 77;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 78;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 79;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 80;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 81;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 82;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 83;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 84;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 85;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 86;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 87;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 88;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 89;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 90;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 91;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 92;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 93;
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
       ,' items updated.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 94;
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
       ,'This operation involves a commit, are you sure you wish to continue?'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 95;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 96;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 97;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 98;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 99;
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
       ,'Unique not specified.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 100;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 101;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 102;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 103;
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
       ,'Invalid parameter data from GIS for session'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 104;
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
       ,'Cannot edit when called from GIS.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 105;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 106;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 107;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 108;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 109;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 110;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 111;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 112;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 113;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 114;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 115;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 116;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 117;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 118;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 119;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 120;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 121;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 122;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 123;
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
       ,'You cannot delete the favourites folder.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 124;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 125;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 126;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 127;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 128;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 129;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 130;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 131;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 132;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 133;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 134;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 135;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 136;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 137;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 139;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 140;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 141;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 142;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 143;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 144;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 145;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 146;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 147;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 148;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 149;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 150;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 151;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 152;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 153;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 154;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 155;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 156;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 157;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 158;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 159;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 160;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 161;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 162;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 163;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 164;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 165;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 166;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 167;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 168;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 169;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 170;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 171;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 172;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 173;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 174;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 175;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 176;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 177;
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
       ,'Invalid operator specified'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 178;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 179;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 180;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 181;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 182;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 183;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 184;
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
       ,'Account not valid'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 185;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 186;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 187;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 188;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 189;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 190;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 191;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 192;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 193;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 194;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 195;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 196;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 197;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 198;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 199;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 201;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 202;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 203;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 204;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 205;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 206;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 207;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 208;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 209;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 210;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 211;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 212;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 213;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 214;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 215;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 216;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 217;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 218;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 219;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 220;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 221;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 222;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 230;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 231;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 232;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 233;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 234;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 235;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 236;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 237;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 238;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 239;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 240;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 241;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 242;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 243;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 244;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 245;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 246;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 247;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 248;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 249;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 250;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 251;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 252;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 253;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 254;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 255;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 256;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 257;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 259;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 260;
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
       ,260
       ,null
       ,'Runtime Library missing from working directory/path'
       ,'A required file is missing from your working directory/path' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 261;
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
       ,261
       ,null
       ,'Gaps/Overlaps are not permitted'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 262;
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
       ,262
       ,null
       ,'Element cannot be linked to a record of the given type'
       ,'Associated Data rules are not in place to support linking this network element to this asset type' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 263;
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
       ,263
       ,null
       ,'Read Permission not granted on directory'
       ,'You are not permitted to read data from the specified directory' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 264;
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
       ,264
       ,null
       ,'Write Permission not granted on directory'
       ,'You are not permitted to write data to the specified directory' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 265;
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
       ,265
       ,null
       ,'Wildcards (%) are not permitted'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 266;
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
       ,266
       ,null
       ,'No base themes for this route type'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 267;
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
       ,267
       ,null
       ,'No themes for linear type'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 268;
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
       ,268
       ,null
       ,'Cannot derive Gtype from base theme'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 269;
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
       ,269
       ,null
       ,'Duplicate Theme or Theme Name Found'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 270;
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
       ,270
       ,null
       ,'Theme is already registered'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 271;
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
       ,271
       ,null
       ,'Error associating Geometry Type with Theme'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 272;
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
       ,272
       ,null
       ,'No themes for linear type '
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 273;
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
       ,273
       ,null
       ,'Error creating spatial sequence'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 274;
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
       ,274
       ,null
       ,'Theme is not a datum layer'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 275;
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
       ,275
       ,null
       ,'Table already exists - please specify another'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 276;
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
       ,276
       ,null
       ,'No subordinate users to process!'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 277;
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
       ,277
       ,null
       ,'Creation of view(s) not neccessary - no layers use SRIDS'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 278;
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
       ,278
       ,null
       ,'Error dropping private synonym'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 279;
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
       ,279
       ,null
       ,'No USGM data to process!'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 280;
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
       ,280
       ,null
       ,'Inconsistent base srids'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 281;
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
       ,281
       ,null
       ,'There are no known themes, populate the input array arguments'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 282;
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
       ,282
       ,null
       ,'Fatal error in dynamic segmentation on'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 283;
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
       ,283
       ,null
       ,'You may not project a geometry in a local cordinate system'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 284;
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
       ,284
       ,null
       ,'Mid point must apply to a line'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 285;
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
       ,285
       ,null
       ,'Invalid dimension for mid-point function'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 286;
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
       ,286
       ,null
       ,'No snaps at this position'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 287;
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
       ,287
       ,null
       ,'Unknown geometry type - must be a point, line or polygon'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 288;
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
       ,288
       ,null
       ,'Not a point geometry'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 289;
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
       ,289
       ,null
       ,'Use sdo_point'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 290;
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
       ,290
       ,null
       ,'Not a single part'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 291;
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
       ,291
       ,null
       ,'Theme is not a linear referencing layer - cannot return projections'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 292;
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
       ,292
       ,null
       ,'Cannot find position to project from'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 293;
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
       ,293
       ,null
       ,'No NT datums for ne_id'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 294;
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
       ,294
       ,null
       ,'No NT type for nlt id'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 295;
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
       ,295
       ,null
       ,'No geometry column on the table'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 296;
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
       ,296
       ,null
       ,'More than one geometry column, need to choose one'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 297;
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
       ,297
       ,null
       ,'Dyn seg error - mismatch in length of datum and shape'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 298;
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
       ,298
       ,null
       ,'Dyn seg error - measures are out of bounds of datum lengths'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 434;
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
       ,434
       ,null
       ,'NSG Node Theme is not present'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 435;
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
       ,435
       ,null
       ,'NSG ESU theme is not present'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 436;
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
       ,436
       ,null
       ,'User is not permitted to operate on the selected network element'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 437;
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
       ,437
       ,null
       ,'User is not permitted to operate on the selected asset'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 438;
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
       ,438
       ,null
       ,'Please Close Locator Before Using It As A Co-ordinate LOV.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 442;
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
       ,442
       ,null
       ,'No Interval Exists For Given Interval Code. Please Use HIG1220 To Enter An Iterval For Interval Code'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 443;
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
       ,443
       ,null
       ,'User Creation Failed!'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 444;
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
       ,444
       ,null
       ,'Invalid character(s) detected in string'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 445;
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
       ,445
       ,null
       ,'This username currently exists on this database, but within another schema.  Either enter an alternate username or contact your System Administrator.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 500;
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
       ,500
       ,null
       ,'This module is not available when the application is run on the web.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 501;
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
       ,501
       ,null
       ,'XML Read error'
       ,'Error suggests XML is not ''well formed''' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 502;
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
       ,502
       ,null
       ,'Cannot delete record as child records exist.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 503;
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
       ,503
       ,null
       ,'Link definition is invalid'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 504;
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
       ,504
       ,null
       ,'Link definition is invalid, wrong calling block parameter name'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 505;
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
       ,505
       ,null
       ,'Too many link definitions for same block combination'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 506;
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
       ,506
       ,null
       ,'Cannot create Point. Please select a single point from the map to create a Point.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 507;
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
       ,507
       ,null
       ,'Cannot create Line. Please select two or more points from the map to create a Line.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 508;
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
       ,508
       ,null
       ,'Cannot create Polygon. Please select three or more points from the map to create a Polygon.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 509;
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
       ,509
       ,null
       ,'User must be assigned HIG_USER role.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 510;
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
       ,510
       ,null
       ,'Process Created'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 511;
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
       ,511
       ,null
       ,'Process Complete'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 512;
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
       ,512
       ,null
       ,'Code is invalid and will not execute'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 513;
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
       ,513
       ,null
       ,'No changes are permitted'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 514;
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
       ,514
       ,null
       ,'Process could not be dropped'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 515;
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
       ,515
       ,null
       ,'Invalid calendar string'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 516;
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
       ,516
       ,null
       ,'Operation is not permitted on this process'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 517;
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
       ,517
       ,null
       ,'Process cannot be submitted because the limit for this process type has been reached'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 518;
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
       ,518
       ,null
       ,'Uploading ... Please Wait'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 519;
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
       ,519
       ,null
       ,'The maximum number of files of a given type has been exceeded.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 520;
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
       ,520
       ,null
       ,'The minimum number of files of a given type have not been submitted.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 521;
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
       ,521
       ,null
       ,'No additional information is available for this process execution'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 522;
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
       ,522
       ,null
       ,'Location is invalid.'||CHR(10)||'Where necessary, locations must end with a ''\'' or ''/'''
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 523;
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
       ,523
       ,null
       ,'Unable to create trigger.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 524;
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
       ,524
       ,null
       ,'Database trigger exists against this audit record, please drop the trigger before deleting this record.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 525;
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
       ,525
       ,null
       ,'Invalid Query.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 526;
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
       ,526
       ,null
       ,'Batch Email Interval is mandatory when Alert setup is not immediate.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 527;
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
       ,527
       ,null
       ,'The trigger has been dropped. Please use the Create Trigger button to reflect changes made to the definition.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 528;
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
       ,528
       ,null
       ,'Name is already in use.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 529;
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
       ,529
       ,null
       ,'Conditions and operators will be set to default values in Normal Query mode.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 530;
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
       ,530
       ,null
       ,'No log to view - Process execution has not yet started.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 531;
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
       ,531
       ,null
       ,'Process Started'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 532;
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
       ,532
       ,null
       ,'Extension contains invalid characters.'
       ,'%*. are not permitted.' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 533;
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
       ,533
       ,null
       ,'You are not permitted to submit a process.'||CHR(10)||'Review process types and process type roles using the ''Process Types'' module.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 534;
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
       ,534
       ,null
       ,'Process Type does not exist'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 535;
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
       ,535
       ,null
       ,'File Type for this Process Type does not exist'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 536;
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
       ,536
       ,null
       ,'Directory does not exist'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 537;
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
       ,537
       ,null
       ,'Cannot delete this query, it is linked with the Alert.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 538;
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
       ,538
       ,null
       ,'Warning:  Process log attachments are not available when sending batch emails. Do you want to continue?'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 539;
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
       ,539
       ,null
       ,'Archiving from an Application Server can only be done when defined as an Oracle Directory'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 540;
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
       ,540
       ,null
       ,'You can only lock files for editing if the Document Location is defined as a Table'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 541;
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
       ,541
       ,null
       ,'There has been an error transferring the file from its location. Please check the Java Console for more details.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 542;
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
       ,542
       ,null
       ,'This document has no corresponding record in its storage table'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 543;
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
       ,543
       ,null
       ,'Cannot read file from its location.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 544;
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
       ,544
       ,null
       ,'Unable to drop trigger.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 545;
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
       ,545
       ,null
       ,'The selected meta model has a Primary Key Column that is not defined as an Attribute. For Audit/Alert to work correctly it is mandatory to setup this Attribute.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 546;
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
       ,546
       ,null
       ,'Unzip failed'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 547;
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
       ,547
       ,null
       ,'Invalid geometry.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 548;
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
       ,548
       ,null
       ,'Application is not configured correctly.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 549;
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
       ,549
       ,null
       ,'It is not possible to create a document when enquiries product is at a version before 4.3.0.0'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 550;
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
       ,550
       ,null
       ,'Connection to the FTP server is not permitted without FTP_USER role'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 551;
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
       ,551
       ,null
       ,'Connection to the Email server is not permitted without EMAIL_USER role'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 552;
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
       ,552
       ,null
       ,'The ACL you are trying to create already exists'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 553;
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
       ,553
       ,null
       ,'The ACL privilege you are trying to grant already exists'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 554;
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
       ,554
       ,null
       ,'The ACL you are trying to reference does not exist'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 555;
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
       ,555
       ,null
       ,'The Process Framework is shutting down/shut down. This operation is not currently permitted'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 556;
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
       ,556
       ,null
       ,'Unable to execute this process'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'MRWA'
  AND  NER_ID = 1;
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 1;
--
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
       ,'ACTION: This is an internal error message and should not normally be'||CHR(10)||'issued. Contact your ORACLE Customer Support Representative.'||CHR(10)||'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 2;
--
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
       ,'ACTION: All associated records should be deleted before the record that'||CHR(10)||'you are trying to delete can be deleted.'||CHR(10)||'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 3;
--
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
       ,'ACTION: Records cannot be duplicated in this block.'||CHR(10)||'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 4;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 5;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 6;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 7;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 8;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 9;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 10;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 11;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 12;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 13;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 14;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 15;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 16;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 17;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 18;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 19;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 20;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 21;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 22;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 23;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 24;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 25;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 26;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 27;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 28;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 29;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 30;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 31;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 32;
--
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
       ,'Location invalid - asset must be located on a linear group of sections or a single section.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 33;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 34;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 35;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 36;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 37;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 38;
--
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
       ,'Cannot locate asset - there are future asset locations which would be affected.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 39;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 40;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 41;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 42;
--
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
       ,'Cannot locate asset - there is an old item of this type that overlaps the new item at both beginning and end.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 43;
--
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
       ,'Location of this asset type on this network type is invalid.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 44;
--
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
       ,'Location of this asset type on this XSP is invalid.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 45;
--
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
       ,'XSP must be specified for this asset type.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 46;
--
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
       ,'XSP is invalid for this asset type on this network type.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 47;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 48;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 49;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 50;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 51;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 52;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 53;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 54;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 55;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 56;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 57;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 58;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 59;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 60;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 61;
--
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
       ,'Attribute has already been used for this asset type.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 62;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 63;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 64;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 65;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 66;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 67;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 68;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 69;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 70;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 71;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 72;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 73;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 74;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 75;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 76;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 77;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 78;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 79;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 80;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 81;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 82;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 83;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 84;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 85;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 86;
--
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
       ,'Continuous asset cannot have start and end points that are the same.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 87;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 88;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 89;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 90;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 91;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 92;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 93;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 94;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 95;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 96;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 97;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 98;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 99;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 100;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 101;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 102;
--
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
       ,'Overlaps not allowed on asset types which are marked as contiguous.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 103;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 104;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 105;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 106;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 107;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 108;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 109;
--
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
       ,'Cannot reclassify element that has un-replaceable asset.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 110;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 111;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 112;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 113;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 114;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 115;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 116;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 117;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 118;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 119;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 120;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 121;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 122;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 123;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 124;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 125;
--
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
       ,'This asset item is of a contiguous type.'||CHR(10)||''||CHR(10)||'End-dating it may leave gaps.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 126;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 127;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 128;
--
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
       ,'Location invalid - asset must be located on a single route.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 129;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 130;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 131;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 132;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 133;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 134;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 135;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 136;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 137;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 138;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 139;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 140;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 141;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 142;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 143;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 144;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 145;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 146;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 147;
--
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
       ,'Conditions must all be on the same asset type.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 148;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 149;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 150;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 151;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 152;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 153;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 154;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 155;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 156;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 157;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 158;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 159;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 160;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 161;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 162;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 163;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 164;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 165;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 166;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 167;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 168;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 169;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 170;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 171;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 172;
--
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
       ,'User does not have access to all asset on the element'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 173;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 174;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 175;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 176;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 177;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 178;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 179;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 180;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 181;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 182;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 183;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 184;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 185;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 186;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 187;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 188;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 189;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 190;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 191;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 192;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 193;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 194;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 195;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 196;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 197;
--
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
       ,'Cannot delete items in asset type as they have child items.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 198;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 199;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 200;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 201;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 202;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 203;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 204;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 205;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 206;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 207;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 208;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 209;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 210;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 211;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 212;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 213;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 214;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 215;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 216;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 217;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 218;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 219;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 220;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 221;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 222;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 223;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 224;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 225;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 226;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 227;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 228;
--
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
       ,'Change to asset details would result in violation of exclusivity rules'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 229;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 230;
--
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
       ,'Can only create exclusive views for exclusive asset types'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 231;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 232;
--
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
       ,'Can only create exclusive views for exclusive asset types which are XSP allowed and/or have exclusive flexible attributes defined'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 233;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 234;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 235;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 236;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 237;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 238;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 239;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 240;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 241;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 242;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 243;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 244;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 245;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 246;
--
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
       ,'Cannot automatically delete existing asset type. Is of a different category'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 247;
--
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
       ,'Cannot create asset types of category "R". This is reserved for Structural Projects'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 248;
--
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
       ,'Can only have one asset type of category "R"'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 249;
--
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
       ,'Child asset type must have at least 1 matching allowable network type with each parent inv type'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 250;
--
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
       ,'Cannot update asset admin unit. There are future affected locations for this item which would be affected'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 251;
--
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
       ,'Cannot perform area admin unit update. There are asset items which are still left active which would have a duplicate IIT_PRIMARY_KEY'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 252;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 253;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 254;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 255;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 256;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 257;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 258;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 259;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 260;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 261;
--
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
       ,'Operation cannot be performed when there are child asset types with different admin types.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 262;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 263;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 264;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 265;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 266;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 267;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 268;
--
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
       ,'Cannot perform this operation on child hierarchical asset types'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 269;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 270;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 271;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 272;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 273;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 274;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 275;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 276;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 277;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 278;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 279;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 280;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 281;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 282;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 283;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 284;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 285;
--
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
       ,'Cannot perform this operation on foreign table based asset types'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 286;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 287;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 288;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 289;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 290;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 291;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 292;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 293;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 294;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 295;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 296;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 297;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 298;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 299;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 300;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 301;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 302;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 303;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 304;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 305;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 306;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 307;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 308;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 309;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 310;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 311;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 312;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 313;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 314;
--
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
       ,'Foreign Table asset types are not permitted in this query'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 315;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 316;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 317;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 318;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 319;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 320;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 321;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 322;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 323;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 324;
--
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
       ,'Assets on Route can only be run to calculate information for Asset Item Types'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 325;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 326;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 327;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 328;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 329;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 330;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 331;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 332;
--
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
       ,'Optional attributes may not be used as exclusive asset attributes'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 333;
--
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
       ,'Only NUMBER or domain-based VARCHAR2 fields may be used as exclusive asset attributes'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 334;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 335;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 336;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 337;
--
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
       ,'Asset of this type may not be updated'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 338;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 339;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 340;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 341;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 342;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 343;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 344;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 345;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 346;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 347;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 348;
--
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
       ,'Elements and asset items of these types cannot be linked'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 349;
--
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
       ,'This group type is not associated with an asset type'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 350;
--
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
       ,'This element has no associated asset item'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 351;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 352;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 353;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 354;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 355;
--
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
       ,'Cannot locate asset - the item has future locations which would be affected.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 356;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 357;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 358;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 359;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 360;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 361;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 362;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 363;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 364;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 365;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 366;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 367;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 368;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 369;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 370;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 371;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 372;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 373;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 374;
--
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
       ,'Cannot have multiple asset item links for a Primary AD Type'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 375;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 376;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 377;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 378;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 379;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 380;
--
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
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 381;
--
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
       ,'A parent sub-type has been defined that is not a sub-type within the same admin type.  Check sub-type rules.' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 382;
--
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
       ,'The following invalid scenario has occurred....'||CHR(10)||'Sub-Type X    Parent Y'||CHR(10)||'Sub-Type Y   Parent X' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 383;
--
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
       ,'The admin type for the specified group type must match the admin type for sub-type.' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 384;
--
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
       ,'The sub-type specified for the admin unit does not exist in the sub-type rules.' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 385;
--
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
       ,'A group type to police cannot be specified in the sub-type rules if elements of that group type already exist.' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 386;
--
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
       ,'Admin unit has been applied to an element which has a confling group type in the admin sub-type rules.' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 387;
--
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
       ,'Admin type has an admin type grouping of ''LOCKED'' which prevents insert/update/delete operations on admin units of this type.' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 388;
--
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
       ,'Flexible attribute query does not parse.  Check the query syntax.' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 389;
--
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
       ,'A specified value is invalid for an attribute.  If applicable, use a list of values to select a valid value. ' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 390;
--
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
       ,'Flexible attribute select statement must contain three columns.'||CHR(10)||'(1)ID - not shown in list of values but returned back to calling module'||CHR(10)||'(2)MEANING - shown in the list of values'||CHR(10)||'(3)CODE - shown in the list of values' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 391;
--
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
       ,'More than the permitted 1 bind variable has been specified.' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 392;
--
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
       ,'The bind variable specified in the flexible attribute query is not a network type column for this given network type.' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 393;
--
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
       ,'Bind variable must also be a attribute for this asset type'
       ,'The bind variable specified in the flexible attribute query is not a attribute for this given inventory type.' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 394;
--
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
       ,'''%'' has been specified against an attribute that is used to restrict the allowable values for the current attribute.' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 395;
--
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
       ,'The bind variable specified in the flexible attribute query appears after the current attribute, so cannot be used to restrict by.  Possibly re-sequence the flexible attributes.' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 396;
--
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
       ,'A domain and a query have both been specified.' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 397;
--
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
       ,'The filename specified is already loaded.' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 398;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,398
       ,null
       ,'Cannot map attributes'
       ,'There has been a problem mapping the attributes for display. Check the inventory metadata' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 399;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,399
       ,null
       ,'Out of Memory'
       ,'There is not sufficient memory available to display the results. Consider restricting the search' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 400;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,400
       ,null
       ,'Inventory Category not valid'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 401;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,401
       ,null
       ,'Derived Asset Type must be exclusive'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 402;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,402
       ,null
       ,'XSP is not allowed for derived asset types'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 403;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,403
       ,null
       ,'Merge Query results are not from query asociated with derived asset type'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 404;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,404
       ,null
       ,'Admin Type of derived asset type is different that the admin type of the asset type it is being derived from'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 405;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,405
       ,null
       ,'Admin Unit cannot be derived using this derivation'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 406;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,406
       ,null
       ,'Specified derived admin unit not found'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 407;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,407
       ,null
       ,'Specified derived admin unit is of an incorrect admin type'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 408;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,408
       ,null
       ,'Refresh is already underway for this type'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 409;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,409
       ,null
       ,'Table has outstanding locks. Cannot proceed.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 410;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,410
       ,null
       ,'Press Button once download has completed'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 411;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,411
       ,null
       ,'Asset table has records locked.'||CHR(10)||'Derived asset refresh cannot proceed because of the possibility of stale data.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 412;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,412
       ,null
       ,'Identical job already exists. Cannot create job'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 413;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,413
       ,null
       ,'Refresh Interval is greater than rebuild interval. Only rebuild will take place'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 421;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,421
       ,null
       ,'No path through distinct datums'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 422;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,422
       ,null
       ,'Inventory attribute query not applicable for inventory of this category.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 423;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,423
       ,null
       ,'Cross Reference is not permitted - please check the Cross Reference Rules'
       ,'Network/Group type of element 1 is not compatible with Network/Group type of element 2' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 424;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,424
       ,null
       ,'This will update the selected inventory items'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 425;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,425
       ,null
       ,'No items selected for update'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 426;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,426
       ,null
       ,'Please enter both Eastings and Northings'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 427;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,427
       ,null
       ,'Please enter search criteria'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 428;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,428
       ,null
       ,'Eastings are out of bounds'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 429;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,429
       ,null
       ,'Northings are out of bounds'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 430;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,430
       ,null
       ,'Cannot find linear parent for auto include'
       ,'Network/Group type does not have a linear parent' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 431;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,431
       ,null
       ,'No Reports Server Defined'
       ,'The procedure to call reports through an Application Server has been called and has no reports server defined' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 432;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,432
       ,null
       ,'Value already exists in the database - Query or re-enter'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 433;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,433
       ,null
       ,'Asset Type must be ''On Network'''
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 436;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,436
       ,null
       ,'Invalid character(s) detected in string'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 437;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,437
       ,null
       ,'Route flagged as a divided highway and no carriageway indicator available'
       ,'Suggest toggle group type reversable flag' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 438;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,438
       ,null
       ,'Query must be restricted by at least Asset Type or Primary Key or Use Advanced Query on Floating Toolbar'
       ,'More restrictive query criteria are required' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 439;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,439
       ,null
       ,'Rescale may not be called on a datum'
       ,'Please contact exor support' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 440;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,440
       ,null
       ,'You have selected a datum: assets on a route only supports using an entire datum'
       ,'Use a route with the datum in and then select the offset you require' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 441;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,441
       ,null
       ,'No items have been selected from the map'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 442;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,442
       ,null
       ,'Auto Inclusion Group Type Is Non Linear, Please Select A Prefered LRM'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 443;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,443
       ,null
       ,'References must be relative to a linear route'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 444;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,444
       ,null
       ,'Reference asset types must be point and allowed on the network for the asset location'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 445;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,445
       ,null
       ,'Asset item with this primary key/asset type/start date already exists'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 446;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,446
       ,null
       ,'Reference item has more than one location'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 447;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,447
       ,null
       ,'Asset is not located on the specified route'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 448;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,448
       ,null
       ,'Asset has more than one location'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 449;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,449
       ,null
       ,'Shift causes overhang at beginning of the section'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 450;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,450
       ,null
       ,'Shift causes overhang at end of the section'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 451;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,451
       ,null
       ,'Cannot locate asset on this network as its measures have been modified'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 452;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,452
       ,null
       ,'Cannot locate asset on this network as it has been edited.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 453;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,453
       ,null
       ,'Invalid module'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 454;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,454
       ,null
       ,'This item has no shape available'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 455;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,455
       ,null
       ,'The name you have chosen is a reserved word in Oracle - please choose a non-reserved word'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 456;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,456
       ,null
       ,'Mismatch between field length definition and unit type '
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 457;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,457
       ,null
       ,'Value larger than the precision allowed for this column'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 458;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,458
       ,null
       ,'Value is of invalid format'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 459;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,459
       ,null
       ,'Warning - Location of this item is mandatory'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 460;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,460
       ,null
       ,'This selected Group Type is Exclusive. The selected Network Elements will be End Dated from existing Groups of this type. Do you wish to continue?'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 461;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,461
       ,null
       ,'One or more of the selected Network Elements are already members of a Group of this type. Do you want to End Date existing Group Memberships for affected Elements?'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 462;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,462
       ,null
       ,'The type chosen is not a datum'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 463;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,463
       ,null
       ,'The type chosen is not allowed sub groups'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 464;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,464
       ,null
       ,'Update is not allowed. This is not the latest occurrence of the asset.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 465;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,465
       ,null
       ,'You cannot perform a network based query without at least the LR NE_ID column set on the asset metamodel.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 466;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,466
       ,null
       ,'Cannot find Document Gateway table or appropriate synonym.'
       ,'Add the relevant table and/or synonym using the Document Gateway form (DOC0130)' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 467;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,467
       ,null
       ,'The User has not been assigned the correct admin units to carry out this action.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 468;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,468
       ,null
       ,'Please ensure all datum networks are registered with 3D diminfo.'
       ,'Subscript beyond count' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 469;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,469
       ,null
       ,'The selected network and asset item do not exist at this effective date.'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 470;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,470
       ,null
       ,'No query has been provided by the calling form. Extended LOV cannot be opened'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 471;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,471
       ,null
       ,'Maximum permitted length of text string exceeded'
       ,'' FROM DUAL;
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 555;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,555
       ,null
       ,'The password you have entered is invalid.'
       ,'' FROM DUAL;
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
