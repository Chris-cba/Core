BEGIN
    FOR cs_rec IN (SELECT view_name
                    FROM  user_views
                   WHERE  view_name = 'NM_MEMBERS'
                  )
     LOOP
       EXECUTE IMMEDIATE 'DROP VIEW '||cs_rec.view_name;
    END LOOP;
END;
/

CREATE OR replace force view nm_members AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_members.vw	1.5 03/24/05
--       Module Name      : nm_members.vw
--       Date into SCCS   : 05/03/24 16:23:21
--       Date fetched Out : 07/06/13 17:08:12
--       SCCS Version     : 1.5
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
       *
 FROM  nm_members_all
WHERE  nm_start_date                                    <=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
 AND   NVL(nm_end_date,TO_DATE('99991231','YYYYMMDD'))  >   To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
/
