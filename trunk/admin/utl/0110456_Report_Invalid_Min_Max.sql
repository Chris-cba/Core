SET SERVEROUTPUT ON
SET TIMING ON
SET LINES 200

--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/0110456_Report_Invalid_Min_Max.sql-arc   1.1   Jul 04 2013 10:29:54   James.Wadsworth  $
--       Module Name      : $Workfile:   0110456_Report_Invalid_Min_Max.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:29:54  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:19:04  $
--       PVCS Version     : $Revision:   1.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
DECLARE
  --
  l_tab_inv_type         nm3type.tab_varchar4;
  l_tab_inv_attrib_name  nm3type.tab_varchar30;
  l_tab_inv_scrn_text    nm3type.tab_varchar32767;
  l_tab_inv_view_attrib  nm3type.tab_varchar30;
  l_tab_inv_domain       nm3type.tab_varchar32767;
  l_tab_start_date       nm3type.tab_date;
  l_tab_end_date         nm3type.tab_date;
  l_tab_inv_min          nm3type.tab_number;
  l_tab_inv_max          nm3type.tab_number;
  l_sql                  nm3type.max_varchar2;
  l_count                NUMBER := 0;
--
-- ORA-00942: table or view does not exist
  ex_tab_not_exist       EXCEPTION;
  PRAGMA                 EXCEPTION_INIT(ex_tab_not_exist,-00942);
--
BEGIN
  --
  SELECT ita_inv_type
       , ita_attrib_name
       , ita_scrn_text
       , ita_view_attri
       , ita_id_domain
       , ita_min
       , ita_max
    BULK COLLECT INTO l_tab_inv_type
       , l_tab_inv_attrib_name
       , l_tab_inv_scrn_text
       , l_tab_inv_view_attrib
       , l_tab_inv_domain
       , l_tab_inv_min
       , l_tab_inv_max
    FROM nm_inv_type_attribs
   WHERE ita_min IS NOT NULL
     AND ita_max IS NOT NULL
     AND ita_format = 'NUMBER';
--
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE NM_INV_INVALID_MIN_MAX';
  EXCEPTION
    WHEN ex_tab_not_exist THEN NULL;
  END;
--
  EXECUTE IMMEDIATE 'CREATE TABLE NM_INV_INVALID_MIN_MAX (iit_ne_id       NUMBER NOT NULL '||
                                                        ', iit_inv_type   VARCHAR2(4) NOT NULL'||
                                                        ', iit_attribute  VARCHAR2(2000)'||
                                                        ', iit_scrn_text  VARCHAR2(2000)'||
                                                        ', iit_view_attri VARCHAR2(30)'||
                                                        ', iit_domain     VARCHAR2(2000)'||
                                                        ', iit_value      NUMBER '||
                                                        ', iit_start_date DATE '||
                                                        ', iit_end_date   DATE '||
                                                        ', iit_min        NUMBER '||
                                                        ', iit_max        NUMBER )';
--
  FOR i IN 1..l_tab_inv_attrib_name.COUNT
  LOOP
  --
    l_sql := 'INSERT INTO NM_INV_INVALID_MIN_MAX '||
             ' SELECT iit_ne_id, '
                    ||nm3flx.string(l_tab_inv_type(i))||', '
                    ||nm3flx.string(l_tab_inv_attrib_name(i))||' ,'
                    ||nm3flx.string(l_tab_inv_scrn_text(i))||' ,'
                    ||nm3flx.string(l_tab_inv_view_attrib(i))||', '
                    ||nm3flx.string(l_tab_inv_domain(i))||', '
                    ||l_tab_inv_attrib_name(i)||', '
                    ||'iit_start_date'||', '
                    ||'iit_end_date'||', '
                    ||l_tab_inv_min(i)||', '
                    ||l_tab_inv_max(i)||
               ' FROM nm_inv_items_all '||
              ' WHERE '||l_tab_inv_attrib_name(i)||' NOT BETWEEN '||l_tab_inv_min(i)||' AND '||l_tab_inv_max(i)||
              '   AND '||nm3flx.string(l_tab_inv_type(i))||' = iit_inv_type';

  --
    EXECUTE IMMEDIATE l_sql;
  --
  END LOOP;
--
  EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM NM_INV_INVALID_MIN_MAX' INTO l_count;
 --
  dbms_output.enable;
  dbms_output.put_line('==============================================================');
  dbms_output.put_line('Asset value checking - Min and Max values');
  dbms_output.put_line('==============================================================');
  dbms_output.put_line(CASE WHEN l_count > 0
                       THEN l_count||' invalid values have been identified '||chr(10)||' - please check table NM_INV_INVALID_MIN_MAX for more details.'
                       ELSE 'All asset values constrained by Min and Max are OK'
                       END);
  dbms_output.put_line('=============================================================='); 
--
  IF l_count = 0
  THEN 
    EXECUTE IMMEDIATE 'DROP TABLE NM_INV_INVALID_MIN_MAX';
  END IF;
--
  COMMIT;
--
END;
/




