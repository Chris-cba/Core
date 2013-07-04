--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3_odh.sql	1.1 04/21/05
--       Module Name      : nm3_odh.sql
--       Date into SCCS   : 05/04/21 10:23:17
--       Date fetched Out : 07/06/13 13:57:32
--       SCCS Version     : 1.1
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF

Prompt Modelling Organisation/District Hierarchy
Prompt =========================================
--
-- "ODH" Admin Type/Sub Type/Top Level Admin Unit data
--
 INSERT INTO nm_au_types(nat_admin_type
                           ,nat_descr)
 SELECT 'ODH'
       ,'ORGANISATION/DISTRICT HIERARCHY'
 FROM dual
 WHERE NOT EXISTS (SELECT 'x'
                   FROM nm_au_types
                   WHERE nat_admin_type = 'ODH');
--
 INSERT INTO nm_au_sub_types(nsty_id
                            ,nsty_nat_admin_type
                            ,nsty_sub_type
                            ,nsty_descr
                            ,nsty_parent_sub_type
                            ,nsty_ngt_group_type)
 SELECT nsty_id_seq.NEXTVAL
       ,'ODH'
       ,'ORG'
       ,'ORGANISATION'
       ,Null
       ,Null
 FROM DUAL
 WHERE NOT EXISTS (SELECT 'X'
                   FROM   nm_au_sub_types
                   WHERE  nsty_nat_admin_type = 'ODH'
                   AND    nsty_sub_type = 'ORG');
--
INSERT INTO nm_au_sub_types(nsty_id
                            ,nsty_nat_admin_type
                            ,nsty_sub_type
                            ,nsty_descr
                            ,nsty_parent_sub_type
                            ,nsty_ngt_group_type)
 SELECT nsty_id_seq.NEXTVAL
       ,'ODH'
       ,'DIST'
       ,'DISTRICT'
       ,'ORG'
       ,Null
 FROM DUAL
 WHERE NOT EXISTS (SELECT 'X'
                   FROM   nm_au_sub_types
                   WHERE  nsty_nat_admin_type = 'ODH'
                   AND    nsty_sub_type = 'DIST');
--
--  Top level admin unit/admin group
--
BEGIN

  INSERT INTO nm_admin_units_all (NAU_ADMIN_UNIT 
                                 ,NAU_UNIT_CODE 
                                 ,NAU_LEVEL 
                                 ,NAU_NAME 
                                 ,NAU_START_DATE 
                                 ,NAU_ADMIN_TYPE)
  SELECT NAU_ADMIN_UNIT_SEQ.NEXTVAL
        ,'TOPODH'
        ,1
        ,'TOP LEVEL'
        ,TRUNC(sysdate)
        ,'ODH'
  FROM DUAL
  WHERE NOT EXISTS (SELECT 'x'
                    FROM nm_admin_units_all
                    WHERE nau_admin_type = 'ODH'
                    AND   nau_level = 1);
  
  IF SQL%ROWCOUNT = 1 THEN
     INSERT INTO nm_admin_groups(nag_parent_admin_unit
                                ,nag_child_admin_unit
                                ,nag_direct_link)
     VALUES (NAU_ADMIN_UNIT_SEQ.CURRVAL
            ,NAU_ADMIN_UNIT_SEQ.CURRVAL
            ,'N');
  END IF;

END;
/							  
--                                 

COMMIT
/
--
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************

