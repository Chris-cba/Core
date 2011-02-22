--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/2_719412_Data_Repair.sql-arc   3.1   Feb 22 2011 13:40:08   Ade.Edwards  $
--       Module Name      : $Workfile:   2_719412_Data_Repair.sql  $
--       Date into PVCS   : $Date:   Feb 22 2011 13:40:08  $
--       Date fetched Out : $Modtime:   Feb 22 2011 13:37:24  $
--       PVCS Version     : $Revision:   3.1  $
--
--------------------------------------------------------------------------------
--

Prompt Run Data Report .....

SET SERVEROUTPUT ON FORMAT WRAPPED 
SET PAGES 0
SET LINES 2000

DECLARE
--
  l_tab_issue       nm3type.tab_varchar32767;
  l_tab_nt_type     nm3type.tab_varchar32767;
  l_tab_gty_type    nm3type.tab_varchar32767;
  l_tab_asset_type  nm3type.tab_varchar32767;
  l_tab_total       nm3type.tab_number;
--
BEGIN
--
  dbms_output.enable(1000000);
--
  dbms_output.put_line ('=============================================');
  dbms_output.put_line (' ECDM Log 719412 - Invalid AD Start Dates ');
  dbms_output.put_line ('=============================================');
--
  SELECT * BULK COLLECT INTO l_tab_issue, l_tab_nt_type, l_tab_gty_type, l_tab_asset_type, l_tab_total
    FROM 
      (
    --
    -- Elements which do not match Asset start date
    --
      SELECT 'Elements which do not match Asset start date' AS "Issue",
             ne_nt_type                                     AS "Network Type",
             ne_gty_group_Type                              AS "Group Type",
             iit_inv_type                                   AS "Asset Type",
             COUNT (*)                                      AS "Total"
        FROM nm_elements_all, nm_inv_items_all, nm_nw_ad_link_all
       WHERE     iit_ne_id = nad_iit_ne_id
             AND nad_ne_id = ne_id
             AND ne_start_date != iit_start_date
             AND nad_end_date IS NULL
             AND nad_primary_ad = 'N'
             AND nad_inv_type NOT IN
                    ('TP21', 'TP22', 'TP23', 'TP51', 'TP52', 'TP53', 'TP64', 'TP65')
       GROUP BY ne_nt_type, ne_gty_group_Type, iit_inv_type
    UNION
      --
      -- Elements which do not match Link start date
      --
      SELECT 'Elements which do not match Link start date'  AS "Issue",
             ne_nt_type                                     AS "Network Type",
             ne_gty_group_Type                              AS "Group Type",
             iit_inv_type                                   AS "Asset Type",
             COUNT (*)                                      AS "Total"
        FROM nm_elements_all, nm_inv_items_all, nm_nw_ad_link_all
       WHERE iit_ne_id = nad_iit_ne_id
         AND nad_ne_id = ne_id
         AND ne_start_date != nad_start_date
         AND nad_end_date IS NULL
         AND nad_primary_ad = 'N'
         AND nad_inv_type NOT IN
                ('TP21', 'TP22', 'TP23', 'TP51', 'TP52', 'TP53', 'TP64', 'TP65')
       GROUP BY ne_nt_type, ne_gty_group_Type, iit_inv_type
    UNION
      --
      -- Assets which do not match the Link start date
      --
      SELECT 'Assets which do not match Link start date'    AS "Issue",
             ne_nt_type                                     AS "Network Type",
             ne_gty_group_Type                              AS "Group Type",
             iit_inv_type                                   AS "Asset Type",
             COUNT (*)                                      AS "Total"
        FROM nm_elements_all, nm_inv_items_all, nm_nw_ad_link_all
       WHERE iit_ne_id = nad_iit_ne_id
         AND nad_ne_id = ne_id
         AND nad_start_date != iit_start_date
         AND nad_end_date IS NULL
         AND nad_primary_ad = 'N'
         AND nad_inv_type NOT IN
                ('TP21', 'TP22', 'TP23', 'TP51', 'TP52', 'TP53', 'TP64', 'TP65')
       GROUP BY ne_nt_type, ne_gty_group_Type, iit_inv_type);
--
  IF l_tab_total.COUNT = 0
  THEN
    dbms_output.put_line ('Identified no invalid data');
  ELSE
    dbms_output.put_line ('Results');
    dbms_output.put_line ('=============================================');
    FOR i IN 1..l_tab_total.COUNT LOOP
      dbms_output.put_line (l_tab_total(i)||' '||l_tab_issue(i)||' [Network '||l_tab_nt_type(i)||'-'||l_tab_gty_type(i)
                                             ||'] [Asset '||l_tab_asset_type(i)||']');
    END LOOP;
  END IF;
--
END;
/

PROMPT Running data repair .....
-- 
-- Backup the links we are going to correct
--
CREATE TABLE nw_nw_ad_link_all_719412
AS SELECT * FROM (
WITH all_data
AS
  ( SELECT nm_nw_ad_link_all.*, ne_start_date, iit_start_date
      FROM nm_nw_ad_link_all, nm_inv_items_all, nm_elements_all
     WHERE iit_ne_id = nad_iit_ne_id
       AND ne_id = nad_ne_id
       AND iit_start_date != ne_start_date
       AND nad_primary_ad = 'N'
       AND nad_inv_type NOT IN
              ('TP21', 'TP22', 'TP23', 'TP51', 'TP52', 'TP53', 'TP64', 'TP65')
  )
  SELECT * FROM all_data);

--
-- Backup the assets we are going to correct
--
CREATE TABLE nm_inv_items_all_719412
AS SELECT * FROM (
     WITH all_data
     AS
     ( SELECT nm_inv_items_all.*
         FROM nm_nw_ad_link_all, nm_inv_items_all, nm_elements_all
        WHERE iit_ne_id = nad_iit_ne_id
          AND ne_id = nad_ne_id
          AND iit_start_date != ne_start_date
          AND nad_primary_ad = 'N'
          AND nad_inv_type NOT IN
                  ('TP21', 'TP22', 'TP23', 'TP51', 'TP52', 'TP53', 'TP64', 'TP65')
       )
       SELECT * FROM all_data);

--
-- No member records -- all whole road
--
select * from nm_members_all
where nm_ne_id_in in (select iit_ne_id from nm_inv_items_all_719412);

--
-- Update the start dates on the assets
--
alter table nm_inv_items_all disable all triggers;

UPDATE nm_inv_items_all
   SET iit_start_date = (SELECT a.ne_start_date FROM nm_elements_all a, nw_nw_ad_link_all_719412
                          WHERE nad_ne_id = ne_id
                            AND iit_ne_id = nad_iit_ne_id)
 WHERE iit_ne_id IN (SELECT nad_iit_ne_id FROM nw_nw_ad_link_all_719412);

alter table nm_inv_items_all enable all triggers;

--
-- Update the start dates on the links
--

alter table nm_nw_ad_link_all disable all triggers;

UPDATE nm_nw_ad_link_all z
   SET z.nad_start_date = (SELECT a.iit_start_date FROM nm_inv_items_all a
                            WHERE z.nad_iit_ne_id = a.iit_ne_id)
 WHERE EXISTS
   (SELECT 1 FROM nw_nw_ad_link_all_719412 b
     WHERE b.nad_iit_ne_id = z.nad_iit_ne_id
       AND b.nad_start_date = z.nad_start_Date );

alter table nm_nw_ad_link_all enable all triggers;

--
-- Drop temporary tables
--
drop table nm_inv_items_all_719412;
drop table nw_nw_ad_link_all_719412;

PROMPT Re-run report .....

SET SERVEROUTPUT ON FORMAT WRAPPED 
SET PAGES 0
SET LINES 2000

DECLARE
--
  l_tab_issue       nm3type.tab_varchar32767;
  l_tab_nt_type     nm3type.tab_varchar32767;
  l_tab_gty_type    nm3type.tab_varchar32767;
  l_tab_asset_type  nm3type.tab_varchar32767;
  l_tab_total       nm3type.tab_number;
--
BEGIN
--
  dbms_output.enable(1000000);
--
  dbms_output.put_line ('=============================================');
  dbms_output.put_line (' ECDM Log 719412 - Invalid AD Start Dates ');
  dbms_output.put_line ('=============================================');
--
  SELECT * BULK COLLECT INTO l_tab_issue, l_tab_nt_type, l_tab_gty_type, l_tab_asset_type, l_tab_total
    FROM 
      (
    --
    -- Elements which do not match Asset start date
    --
      SELECT 'Elements which do not match Asset start date' AS "Issue",
             ne_nt_type                                     AS "Network Type",
             ne_gty_group_Type                              AS "Group Type",
             iit_inv_type                                   AS "Asset Type",
             COUNT (*)                                      AS "Total"
        FROM nm_elements_all, nm_inv_items_all, nm_nw_ad_link_all
       WHERE     iit_ne_id = nad_iit_ne_id
             AND nad_ne_id = ne_id
             AND ne_start_date != iit_start_date
             AND nad_end_date IS NULL
             AND nad_primary_ad = 'N'
             AND nad_inv_type NOT IN
                    ('TP21', 'TP22', 'TP23', 'TP51', 'TP52', 'TP53', 'TP64', 'TP65')
       GROUP BY ne_nt_type, ne_gty_group_Type, iit_inv_type
    UNION
      --
      -- Elements which do not match Link start date
      --
      SELECT 'Elements which do not match Link start date'  AS "Issue",
             ne_nt_type                                     AS "Network Type",
             ne_gty_group_Type                              AS "Group Type",
             iit_inv_type                                   AS "Asset Type",
             COUNT (*)                                      AS "Total"
        FROM nm_elements_all, nm_inv_items_all, nm_nw_ad_link_all
       WHERE iit_ne_id = nad_iit_ne_id
         AND nad_ne_id = ne_id
         AND ne_start_date != nad_start_date
         AND nad_end_date IS NULL
         AND nad_primary_ad = 'N'
         AND nad_inv_type NOT IN
                ('TP21', 'TP22', 'TP23', 'TP51', 'TP52', 'TP53', 'TP64', 'TP65')
       GROUP BY ne_nt_type, ne_gty_group_Type, iit_inv_type
    UNION
      --
      -- Assets which do not match the Link start date
      --
      SELECT 'Assets which do not match Link start date'    AS "Issue",
             ne_nt_type                                     AS "Network Type",
             ne_gty_group_Type                              AS "Group Type",
             iit_inv_type                                   AS "Asset Type",
             COUNT (*)                                      AS "Total"
        FROM nm_elements_all, nm_inv_items_all, nm_nw_ad_link_all
       WHERE iit_ne_id = nad_iit_ne_id
         AND nad_ne_id = ne_id
         AND nad_start_date != iit_start_date
         AND nad_end_date IS NULL
         AND nad_primary_ad = 'N'
         AND nad_inv_type NOT IN
                ('TP21', 'TP22', 'TP23', 'TP51', 'TP52', 'TP53', 'TP64', 'TP65')
       GROUP BY ne_nt_type, ne_gty_group_Type, iit_inv_type);
--
  IF l_tab_total.COUNT = 0
  THEN
    dbms_output.put_line ('Identified no invalid data');
  ELSE
    dbms_output.put_line ('Results');
    dbms_output.put_line ('=============================================');
    FOR i IN 1..l_tab_total.COUNT LOOP
      dbms_output.put_line (l_tab_total(i)||' '||l_tab_issue(i)||' [Network '||l_tab_nt_type(i)||'-'||l_tab_gty_type(i)
                                             ||'] [Asset '||l_tab_asset_type(i)||']');
    END LOOP;
  END IF;
--
END;
/

