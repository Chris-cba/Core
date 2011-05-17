CREATE OR REPLACE TRIGGER NM_INV_TYPES_ALL_DT_TRG
 BEFORE INSERT
  OR UPDATE OF NIT_START_DATE
             , NIT_END_DATE
             , NIT_FOREIGN_PK_COLUMN
             , NIT_LR_NE_COLUMN_NAME
             , NIT_LR_ST_CHAIN
             , NIT_LR_END_CHAIN
             , NIT_CATEGORY
             , NIT_TABLE_NAME
 ON NM_INV_TYPES_ALL  
 FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/nm_inv_types_all_dt_trg.trg-arc   2.4   May 17 2011 08:32:02   Steve.Cooper  $
--       Module Name      : $Workfile:   nm_inv_types_all_dt_trg.trg  $
--       Date into PVCS   : $Date:   May 17 2011 08:32:02  $
--       Date fetched Out : $Modtime:   Apr 01 2011 10:16:32  $
--       Version          : $Revision:   2.4  $
--
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2008
-----------------------------------------------------------------------------
--
   l_start_date DATE := :NEW.NIT_START_DATE;
   l_end_date   DATE := :NEW.NIT_END_DATE;
--
   l_old_start_date DATE := :OLD.NIT_START_DATE;
   l_old_end_date   DATE := :OLD.NIT_END_DATE;
--
   l_start_date_out_of_range  EXCEPTION;
   l_end_date_out_of_range    EXCEPTION;
   l_cannot_update_start_date EXCEPTION;
   l_start_date_gt_end_date   EXCEPTION;
   l_has_children             EXCEPTION;
--
   CURSOR cs_children (c_nit_inv_type  nm_inv_types_all.nit_inv_type%TYPE
                      ,c_start_date    DATE -- NM_ELEMENTS.NE_START_DATE
                      ,c_end_date      DATE -- NM_ELEMENTS.NE_END_DATE
                      ) IS -- IIT_NIT_FK + NIN_NIT_FK + ITA_NIT_FK + ITG_NIT_FK_PARENT + ITG_NIT_FK
   SELECT 1
    FROM  DUAL
   WHERE  EXISTS (SELECT 1
                   FROM  NM_INV_ITEMS_ALL
                  WHERE  IIT_INV_TYPE = c_nit_inv_type
                   AND  (IIT_START_DATE < c_start_date
                          OR (   (IIT_END_DATE IS     NULL AND c_end_date IS NOT NULL)
                              OR (IIT_END_DATE IS NOT NULL AND c_end_date IS NOT NULL AND IIT_END_DATE > c_end_date)
                             )
                        )
                 )
    OR    EXISTS (SELECT 1
                   FROM  NM_INV_NW_ALL
                  WHERE  NIN_NIT_INV_CODE = c_nit_inv_type
                   AND  (NIN_START_DATE < c_start_date
                          OR (   (NIN_END_DATE IS     NULL AND c_end_date IS NOT NULL)
                              OR (NIN_END_DATE IS NOT NULL AND c_end_date IS NOT NULL AND NIN_END_DATE > c_end_date)
                             )
                        )
                 )
    OR    EXISTS (SELECT 1
                   FROM  NM_INV_TYPE_ATTRIBS_ALL
                  WHERE  ITA_INV_TYPE = c_nit_inv_type
                   AND  (ITA_START_DATE < c_start_date
                          OR (   (ITA_END_DATE IS     NULL AND c_end_date IS NOT NULL)
                              OR (ITA_END_DATE IS NOT NULL AND c_end_date IS NOT NULL AND ITA_END_DATE > c_end_date)
                             )
                        )
                 )
    OR    EXISTS (SELECT 1
                   FROM  NM_INV_TYPE_GROUPINGS_ALL
                  WHERE  ITG_PARENT_INV_TYPE = c_nit_inv_type
                   AND  (ITG_START_DATE < c_start_date
                          OR (   (ITG_END_DATE IS     NULL AND c_end_date IS NOT NULL)
                              OR (ITG_END_DATE IS NOT NULL AND c_end_date IS NOT NULL AND ITG_END_DATE > c_end_date)
                             )
                        )
                 )
    OR    EXISTS (SELECT 1
                   FROM  NM_INV_TYPE_GROUPINGS_ALL
                  WHERE  ITG_INV_TYPE = c_nit_inv_type
                   AND  (ITG_START_DATE < c_start_date
                          OR (   (ITG_END_DATE IS     NULL AND c_end_date IS NOT NULL)
                              OR (ITG_END_DATE IS NOT NULL AND c_end_date IS NOT NULL AND ITG_END_DATE > c_end_date)
                             )
                        )
                 );
--
   CURSOR cs_query (c_nit_inv_type  nm_inv_types_all.nit_inv_type%TYPE) IS
   SELECT 1
    FROM  DUAL
   WHERE  EXISTS (SELECT 1
                   FROM  nm_mrg_query_types_all
                  WHERE  nqt_inv_type = c_nit_inv_type
                 )
    OR    EXISTS (SELECT 1
                   FROM  nm_pbi_query_types
                  WHERE  nqt_item_type_type  = nm3gaz_qry.c_ngqt_item_type_type_inv
                   AND   nqt_item_type       = c_nit_inv_type
                 )
    OR    EXISTS (SELECT 1
                   FROM  nm_x_inv_conditions
                  WHERE  nxic_inv_type    = c_nit_inv_type
                 );
--
   l_dummy BINARY_INTEGER;
--
BEGIN
--
   IF   UPDATING
    AND l_old_start_date <> l_start_date
    THEN
      RAISE l_cannot_update_start_date;
   END IF;
--
   IF   l_start_date > l_end_date
    AND l_end_date IS NOT NULL
    THEN
      RAISE l_start_date_gt_end_date;
   END IF;
--
   IF :NEW.nit_table_name IS NOT NULL
    THEN
      -- If this is a foreign table
      DECLARE
      --
         FUNCTION check_table_exists (p_table_name VARCHAR2)
         RETURN BOOLEAN
         IS
         l_dummy        VARCHAR2(1);
         l_return_val   BOOLEAN;
         --
            CURSOR cs_ft_tab_check(c_table_name VARCHAR2) IS
            SELECT 'X'
              FROM all_tables
             WHERE table_name  = c_table_name
               AND owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
             UNION
            SELECT 'X'
              FROM all_views
             WHERE view_name  = c_table_name
               AND owner = Sys_Context('NM3CORE','APPLICATION_OWNER');
         BEGIN
         --
           OPEN  cs_ft_tab_check (p_table_name);
           FETCH cs_ft_tab_check INTO l_dummy;
           l_return_val:= cs_ft_tab_check%FOUND;
           CLOSE cs_ft_tab_check;
         --
         RETURN l_return_val;
         END;
         --
         PROCEDURE check_exists (p_table_name VARCHAR2
                                ,p_col_name   VARCHAR2
                                ) IS
          -- Checks do not take into account
          /*  l_current_user VARCHAR2(100) := nm3get.get_hus(pi_hus_user_id => 
                                            nm3context.get_context(nm3context.get_namespace,'USER_ID')).hus_username;*/
            --
            CURSOR cs_ft_col_check (c_table_name VARCHAR2
                                   ,c_col_name   VARCHAR2
                                   ) IS
            SELECT data_type
              FROM all_tab_columns
             WHERE table_name  = c_table_name
               AND column_name = c_col_name
               AND owner = Sys_Context('NM3CORE','APPLICATION_OWNER');
            l_data_type all_tab_columns.data_type%TYPE;
         BEGIN
         
            IF p_table_name IS NOT NULL AND p_col_name IS NOT NULL THEN

              OPEN  cs_ft_col_check (p_table_name, p_col_name);
              FETCH cs_ft_col_check INTO l_data_type;
              IF cs_ft_col_check%NOTFOUND
               THEN
                 CLOSE cs_ft_col_check;
                 RAISE_APPLICATION_ERROR(-20001,'Column '||p_table_name||'.'||p_col_name||' not found');
              END IF;
              CLOSE cs_ft_col_check;
              IF l_data_type != 'NUMBER'
              AND :New.nit_category != 'A' -- Ignore Audit/Alert Assets from this validation
               THEN
                 RAISE_APPLICATION_ERROR(-20001,'Column '||p_table_name||'.'||p_col_name||' is not a NUMBER column');
              END IF;

            END IF;              
         END check_exists;
      --
      BEGIN
      --
        IF check_table_exists (p_table_name => :NEW.nit_table_name) THEN
        --
           check_exists (:NEW.nit_table_name, :NEW.nit_lr_ne_column_name);
           check_exists (:NEW.nit_table_name, :NEW.nit_lr_st_chain);
           check_exists (:NEW.nit_table_name, :NEW.nit_lr_end_chain);
           check_exists (:NEW.nit_table_name, :NEW.nit_foreign_pk_column);
        --
        END IF;
      --
      END;
   END IF;
--
   -- IIT_NIT_FK
   -- NIN_NIT_FK
   -- ITA_NIT_FK
   -- ITG_NIT_FK_PARENT
   -- ITG_NIT_FK
   OPEN  cs_children (:NEW.nit_inv_type, l_start_date, l_end_date);
   FETCH cs_children INTO l_dummy;
   IF cs_children%FOUND
    THEN
      CLOSE cs_children;
      RAISE l_has_children;
   END IF;
   CLOSE cs_children;
--
   IF   l_end_date     IS NOT NULL
    AND l_old_end_date IS     NULL
    THEN
      -- If we're setting the end-date make user there are no merge or pbi queries which use this attribute
      OPEN  cs_query (:NEW.nit_inv_type);
      FETCH cs_query INTO l_dummy;
      IF cs_query%FOUND
       THEN
         CLOSE cs_query;
         RAISE l_has_children;
      END IF;
      CLOSE cs_query;
   END IF;
--
EXCEPTION
--
   WHEN l_cannot_update_start_date
    THEN
      RAISE_APPLICATION_ERROR(-20980,'NIT_START_DATE cannot be updated');
   WHEN l_start_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20981,'NIT_START_DATE out of range');
   WHEN l_end_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20982,'NIT_END_DATE out of range');
   WHEN l_start_date_gt_end_date
    THEN
      RAISE_APPLICATION_ERROR(-20984,'NIT_END_DATE cannot be before NIT_START_DATE');
   WHEN l_has_children
    THEN
      RAISE_APPLICATION_ERROR(-20983,'Record has children outside date range');
--
END NM_INV_TYPES_ALL_DT_TRG;
/
