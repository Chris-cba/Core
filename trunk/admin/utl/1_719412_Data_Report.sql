--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/1_719412_Data_Report.sql-arc   3.1   Jul 04 2013 10:29:54   James.Wadsworth  $
--       Module Name      : $Workfile:   1_719412_Data_Report.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:29:54  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:18:20  $
--       PVCS Version     : $Revision:   3.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

SET SERVEROUTPUT ON FORMAT WRAPPED 
SET PAGES 0
SET LINES 32767

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
