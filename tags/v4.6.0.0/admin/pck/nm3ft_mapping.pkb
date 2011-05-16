CREATE OR REPLACE PACKAGE BODY nm3ft_mapping AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3ft_mapping.pkb-arc   2.2   May 16 2011 14:44:50   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3ft_mapping.pkb  $
--       Date into PVCS   : $Date:   May 16 2011 14:44:50  $
--       Date fetched Out : $Modtime:   Apr 04 2011 08:13:40  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.2
-------------------------------------------------------------------------
--   Author : M Huitson.
--
--   nm3ft_mapping body
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--all global package variables here
  --
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.2  $';
  g_package_name CONSTANT varchar2(30) := 'nm3ft_mapping';
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
  RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
  RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
PROCEDURE init_mapping_tabs IS
  --
  lt_cols ft_cols_tab;
  lv_numb_cnt PLS_INTEGER :=1;
  lv_char_cnt PLS_INTEGER :=1;
  lv_date_cnt PLS_INTEGER :=1;
  --
BEGIN
  /*
  || Get The Column Names For Table
  || NM_INV_ITEMS_ALL From ALL_TAB_COLS
  */
  SELECT column_name
	,data_length
    BULK COLLECT
    INTO lt_cols
    FROM all_tab_cols
   WHERE table_name = 'NM_INV_ITEMS_ALL'
     AND owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
   ORDER
      BY column_id
       ;
  /*
  || Add The Columns To The Relevent Tables.
  */
  FOR i IN 1 .. lt_cols.count LOOP
    --
    g_inv_type_cols(i).inv_col_name   := lt_cols(i).inv_col_name;
    g_inv_type_cols(i).inv_col_length := lt_cols(i).inv_col_length;
    g_inv_type_cols(i).assigned       := FALSE;
    g_inv_type_cols(i).ft_col_name    := NULL;
    --
    IF SUBSTR(lt_cols(i).inv_col_name,1,14) = 'IIT_NUM_ATTRIB'
     THEN
        g_inv_numb_attr_cols(lv_numb_cnt).inv_col_name   := lt_cols(i).inv_col_name;
        g_inv_numb_attr_cols(lv_numb_cnt).inv_col_length := lt_cols(i).inv_col_length;
        g_inv_numb_attr_cols(lv_numb_cnt).assigned       := FALSE;
        g_inv_numb_attr_cols(lv_numb_cnt).ft_col_name    := NULL;
        lv_numb_cnt := lv_numb_cnt+1;
    ELSIF SUBSTR(lt_cols(i).inv_col_name,1,14) = 'IIT_CHR_ATTRIB'
     THEN
        g_inv_char_attr_cols(lv_char_cnt).inv_col_name   := lt_cols(i).inv_col_name;
        g_inv_char_attr_cols(lv_char_cnt).inv_col_length := lt_cols(i).inv_col_length;
        g_inv_char_attr_cols(lv_char_cnt).assigned    := FALSE;
        g_inv_char_attr_cols(lv_char_cnt).ft_col_name := NULL;
        lv_char_cnt := lv_char_cnt+1;
    ELSIF SUBSTR(lt_cols(i).inv_col_name,1,15) = 'IIT_DATE_ATTRIB'
     THEN
        g_inv_date_attr_cols(lv_date_cnt).inv_col_name   := lt_cols(i).inv_col_name;
        g_inv_date_attr_cols(lv_date_cnt).inv_col_length := lt_cols(i).inv_col_length;
        g_inv_date_attr_cols(lv_date_cnt).assigned    := FALSE;
        g_inv_date_attr_cols(lv_date_cnt).ft_col_name := NULL;
        lv_date_cnt := lv_date_cnt+1;
    END IF;
    --
  END LOOP;
  --
--  nm_debug.debug('Number Attribs = '||lv_numb_cnt-1
--               ||'Char Attribs = '||lv_char_cnt-1
--               ||'Date Attribs = '||lv_date_cnt-1);
END init_mapping_tabs;
--
-----------------------------------------------------------------------------
--
FUNCTION get_iit_index(pi_inv_col all_tab_columns.column_name%TYPE)
  RETURN PLS_INTEGER IS
  --
  lv_retval PLS_INTEGER := 0;
  --
BEGIN
  --
  FOR i IN 1..g_inv_type_cols.count LOOP
    --
    IF g_inv_type_cols(i).inv_col_name = pi_inv_col
     THEN
        lv_retval := i;
        exit;
    END IF;
    --
  END LOOP;
  --
  RETURN lv_retval;
  --
END get_iit_index;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ft_index(pi_ft_col all_tab_columns.column_name%TYPE)
  RETURN PLS_INTEGER IS
  --
  lv_retval PLS_INTEGER := 0;
  --
BEGIN
  --
  FOR i IN 1..g_inv_type_cols.count LOOP
    --
    IF g_inv_type_cols(i).ft_col_name = pi_ft_col
     THEN
        lv_retval := i;
        exit;
    END IF;
    --
  END LOOP;
  --
  RETURN lv_retval;
  --
END get_ft_index;
--
-----------------------------------------------------------------------------
--
PROCEDURE map_ft_to_iit(pi_inv_type IN nm_inv_types_all.nit_inv_type%TYPE
                       ,pi_map_pk   IN BOOLEAN DEFAULT TRUE) IS
  --
  lr_nit nm_inv_types_all%ROWTYPE;
  --
  PROCEDURE map(pi_index  IN PLS_INTEGER
               ,pi_ft_col IN all_tab_columns.column_name%TYPE) IS
  BEGIN
    g_inv_type_cols(pi_index).assigned := TRUE;
    g_inv_type_cols(pi_index).ft_col_name := pi_ft_col;
  END;
  --
  PROCEDURE map_static_columns IS
    --
    lv_index PLS_INTEGER;
    --
  BEGIN
    --
    IF lr_nit.nit_foreign_pk_column IS NOT NULL
     THEN
        map(pi_index  => get_iit_index('IIT_NE_ID')
           ,pi_ft_col => lr_nit.nit_foreign_pk_column);
        --
        IF(pi_map_pk)
         THEN
            map(pi_index  => get_iit_index('IIT_PRIMARY_KEY')
               ,pi_ft_col => lr_nit.nit_foreign_pk_column);
        END IF;
    END IF;
    --
    IF lr_nit.nit_lr_ne_column_name IS NOT NULL
     THEN
        map(pi_index  => get_iit_index('IIT_FOREIGN_KEY')
           ,pi_ft_col => lr_nit.nit_lr_ne_column_name);
    END IF;
    --
    IF lr_nit.nit_lr_st_chain IS NOT NULL
     THEN
        map(pi_index  => get_iit_index('IIT_OFFSET')
           ,pi_ft_col => lr_nit.nit_lr_st_chain);
    END IF;
    --
    IF lr_nit.nit_lr_end_chain IS NOT NULL
     THEN
        map(pi_index  => get_iit_index('IIT_END_CHAIN')
           ,pi_ft_col => lr_nit.nit_lr_end_chain);
    END IF;
    --
  END map_static_columns;
  --
  PROCEDURE map_attribs(pi_inv_type nm_inv_types_all.nit_inv_type%TYPE) IS
    --
    TYPE attr_tab IS TABLE OF nm_inv_type_attribs_all%ROWTYPE;
    lt_attribs attr_tab;
    --
    PROCEDURE map_attrib_to_numb_col(pi_attrib_name all_tab_columns.column_name%TYPE) IS
      --
      lv_mapped BOOLEAN := FALSE;
      --
    BEGIN
      /*
      || Loop Through The Mapping Table Until The
      || Next Unassigned Column Is Found And Assign
      || The Given FT Column To It.
      */
      FOR i IN 1 .. g_inv_numb_attr_cols.count LOOP
        --
        IF NOT(g_inv_numb_attr_cols(i).assigned)
         THEN
            --
--            nm_debug.debug('Mapping '||pi_attrib_name
--                         ||' To '||g_inv_numb_attr_cols(i).inv_col_name);
            g_inv_numb_attr_cols(i).ft_col_name := pi_attrib_name;
            g_inv_numb_attr_cols(i).assigned    := TRUE;
            --
            lv_mapped := TRUE;
            exit;
            --
        END IF;
        --
      END LOOP;
      --
      IF NOT(lv_mapped)
       THEN
          RAISE_APPLICATION_ERROR(-20001,'Maximum Number Of Numeric Attributes Exceded');
      END IF;
      --
    END map_attrib_to_numb_col;
    --
    PROCEDURE map_attrib_to_char_col(pi_attrib_name   all_tab_columns.column_name%TYPE
                                    ,pi_attrib_length number) IS
      --
      lv_mapped BOOLEAN := FALSE;
      --
    BEGIN
      /*
      || Loop Through The Mapping Table Until The
      || Next Unassigned Column Is Found And Assign
      || The Given FT Column To It.
      */
      FOR i IN 1 .. g_inv_char_attr_cols.count LOOP
        --
        IF (NOT(g_inv_char_attr_cols(i).assigned))                                           --Not Already Assigned
         AND (pi_attrib_length <= g_inv_char_attr_cols(i).inv_col_length                     --Attrib Fits Column
              OR(g_inv_char_attr_cols(i).inv_col_length = 500 and pi_attrib_length > 500)) --Attrib Too Big, calling
                                                                                             --code will have to
                                                                                             --substr(x,1,500)
         THEN
            --
--            nm_debug.debug('Mapping '||pi_attrib_name
--                         ||' To '||g_inv_char_attr_cols(i).inv_col_name);
            g_inv_char_attr_cols(i).ft_col_name := pi_attrib_name;
            g_inv_char_attr_cols(i).assigned    := TRUE;
            --
            lv_mapped := TRUE;
            exit;
            --
        END IF;
        --
      END LOOP;
      --
      IF NOT(lv_mapped)
       THEN
          RAISE_APPLICATION_ERROR(-20002,'Maximum Number Of Character Attributes Exceded');
      END IF;
      --
    END map_attrib_to_char_col;
    --
    PROCEDURE map_attrib_to_date_col(pi_attrib_name all_tab_columns.column_name%TYPE) IS
      --
      lv_mapped BOOLEAN := FALSE;
      --
    BEGIN
      /*
      || Loop Through The Mapping Table Until The
      || Next Unassigned Column Is Found And Assign
      || The Given FT Column To It.
      */
      FOR i IN 1.. g_inv_date_attr_cols.count LOOP
        --
        IF NOT(g_inv_date_attr_cols(i).assigned)
         THEN
            --
--            nm_debug.debug('Mapping '||pi_attrib_name
--                         ||' To '||g_inv_date_attr_cols(i).inv_col_name);
            g_inv_date_attr_cols(i).ft_col_name := pi_attrib_name;
            g_inv_date_attr_cols(i).assigned    := TRUE;
            --
            lv_mapped := TRUE;
            exit;
            --
        END IF;
        --
      END LOOP;
      --
      IF NOT(lv_mapped)
       THEN
          RAISE_APPLICATION_ERROR(-20003,'Maximum Number Of Date Attributes Exceded');
      END IF;
      --
    END map_attrib_to_date_col;
    --
  BEGIN
    /*
    || Get The Attributes For The Asset Type.
    */
    SELECT *
      BULK COLLECT
      INTO lt_attribs
      FROM nm_inv_type_attribs_all
     WHERE ita_inv_type = pi_inv_type
     ORDER
        BY ita_disp_seq_no
         ;
    /*
    || Now Map The Attribs To IIT Attrib Columns.
    */
    FOR i IN 1 .. lt_attribs.count LOOP
      --
      IF lt_attribs(i).ita_format = 'NUMBER'
       THEN
          --
          map_attrib_to_numb_col(lt_attribs(i).ita_attrib_name);
          --
      ELSIF lt_attribs(i).ita_format = 'VARCHAR2'
       THEN
          --
          map_attrib_to_char_col(lt_attribs(i).ita_attrib_name
                                ,lt_attribs(i).ita_fld_length);
          --
      ELSIF lt_attribs(i).ita_format = 'DATE'
       THEN
          --
          map_attrib_to_date_col(lt_attribs(i).ita_attrib_name);
          --
      END IF;
      --
    END LOOP;
    --
  END map_attribs;
  --
  PROCEDURE set_attribs IS
  BEGIN
    --
    FOR i IN 1 .. g_inv_numb_attr_cols.count LOOP
      --
      IF (g_inv_numb_attr_cols(i).assigned)
       THEN
          --
          map(pi_index  => get_iit_index(g_inv_numb_attr_cols(i).inv_col_name)
             ,pi_ft_col => g_inv_numb_attr_cols(i).ft_col_name);
          --
      END IF;
      --
    END LOOP;
    --
    FOR i IN 1 .. g_inv_char_attr_cols.count LOOP
      --
      IF (g_inv_char_attr_cols(i).assigned)
       THEN
          --
          map(pi_index  => get_iit_index(g_inv_char_attr_cols(i).inv_col_name)
             ,pi_ft_col => g_inv_char_attr_cols(i).ft_col_name);
          --
      END IF;
      --
    END LOOP;
    --
    FOR i IN 1 .. g_inv_date_attr_cols.count LOOP
      --
      IF (g_inv_date_attr_cols(i).assigned)
       THEN
          --
          map(pi_index  => get_iit_index(g_inv_date_attr_cols(i).inv_col_name)
             ,pi_ft_col => g_inv_date_attr_cols(i).ft_col_name);
          --
      END IF;
      --
    END LOOP;
    --
  END;
  --
BEGIN
  --nm_debug.debug_on;
  /*
  || Get The Details Of The Asset Type Passed In.
  */
  lr_nit := nm3get.get_nit_all(pi_nit_inv_type => pi_inv_type);
  /*
  || If The Asset Type Is Not External Raise An Error.
  */
  IF lr_nit.nit_table_name IS NULL
   THEN
      RAISE_APPLICATION_ERROR(-20001,pi_inv_type||' Is Not An External Asset Type');
  END IF;
  /*
  || If The Asset Type Passed In Is The
  || Same As The Asset Type Currently Stored
  || In The Global PLSQL Tables Do Nothing,
  || Otherwise Map The Attributes For The
  || Asset Type Passed In.
  */
  IF pi_inv_type != NVL(g_inv_type,'$”%@')
   THEN
      /*
      || Initialise The Mapping Tables.
      */
      init_mapping_tabs;
      /*
      || Set The Static Columns.
      */
      map_static_columns;
      /*
      || Set The Attribute Columns.
      */
      map_attribs(pi_inv_type => pi_inv_type);
      /*
      || Copy The Attribute Mapping Into
      || The Inv Type Mapping.
      */
      set_attribs;
      /*
      || Set The Global Inv Type To Save Time
      || If The Next Call Is For The Same Type.
      */
      g_inv_type := pi_inv_type;
      --      
  END IF;
  --
  debug_map_table;
  --nm_debug.debug_off;
END map_ft_to_iit;
--
-----------------------------------------------------------------------------
--
FUNCTION get_iit_column(pi_ft_col IN nm_inv_type_attribs_all.ita_attrib_name%TYPE)
  RETURN all_tab_columns.column_name%TYPE IS
  --
BEGIN
  --
  RETURN g_inv_type_cols(get_ft_index(pi_ft_col => pi_ft_col)).inv_col_name;
  --
END get_iit_column;
--
-----------------------------------------------------------------------------
--
FUNCTION get_iit_attrib_column(pi_ft_col IN nm_inv_type_attribs_all.ita_attrib_name%TYPE
                              ,pi_format IN nm_inv_type_attribs_all.ita_format%TYPE)
  RETURN all_tab_columns.column_name%TYPE IS
  --
  lv_retval all_tab_columns.column_name%TYPE;
  --
BEGIN
  --
  IF pi_format = 'NUMBER'
   THEN
      FOR i IN 1..g_inv_numb_attr_cols.count LOOP
        --
        IF g_inv_numb_attr_cols(i).ft_col_name = pi_ft_col
         THEN
            lv_retval := g_inv_numb_attr_cols(i).inv_col_name;
            exit;
        END IF;
        --
      END LOOP;
  ELSIF pi_format = 'VARCHAR2'
   THEN
      FOR i IN 1..g_inv_char_attr_cols.count LOOP
        --
        IF g_inv_char_attr_cols(i).ft_col_name = pi_ft_col
         THEN
            lv_retval := g_inv_char_attr_cols(i).inv_col_name;
            exit;
        END IF;
        --
      END LOOP;
  ELSIF pi_format = 'DATE'
   THEN
      FOR i IN 1..g_inv_date_attr_cols.count LOOP
        --
        IF g_inv_date_attr_cols(i).ft_col_name = pi_ft_col
         THEN
            lv_retval := g_inv_date_attr_cols(i).inv_col_name;
            exit;
        END IF;
        --
      END LOOP;
  END IF;
  --
  RETURN lv_retval;
  --
END get_iit_attrib_column;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ft_column(pi_inv_col IN nm_inv_type_attribs_all.ita_attrib_name%TYPE)
  RETURN all_tab_columns.column_name%TYPE IS
  --
BEGIN
  /*
  || Return The FT Column That Has Been 
  || Mapped To The Given Inv Column.
  || NB. This May Return NULL If The
  || Given Column Has Not Been Mapped.
  */
  RETURN g_inv_type_cols(get_iit_index(pi_inv_col => pi_inv_col)).inv_col_name;
  --
END get_ft_column;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ft_to_iit_map_tab(pio_map_tab IN OUT tab_ft_table_mapping) IS
BEGIN
  IF g_inv_type IS NOT NULL
   THEN
      pio_map_tab := g_inv_type_cols;
  ELSE
      RAISE_APPLICATION_ERROR(-20004,'No Inv Type Mapped');
  END IF;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_map_table(p_only_assigned IN boolean DEFAULT FALSE) IS
BEGIN
  /*
  || Dump The Contents Of The Mapping
  || PLSQL Table To nm_dbug.
  */
  FOR i IN 1..g_inv_type_cols.count LOOP
    IF p_only_assigned THEN
      IF g_inv_type_cols(i).assigned THEN
        nm_debug.debug(rpad(g_inv_type_cols(i).inv_col_name, 30)||','||RPAD(nm3flx.boolean_to_char(g_inv_type_cols(i).assigned),8)||','||g_inv_type_cols(i).ft_col_name);
      END IF;
    ELSE
      nm_debug.debug(rpad(g_inv_type_cols(i).inv_col_name, 30)||','||RPAD(nm3flx.boolean_to_char(g_inv_type_cols(i).assigned),8)||','||g_inv_type_cols(i).ft_col_name);
    END IF;
  END LOOP;
END;
--
-----------------------------------------------------------------------------
--
END nm3ft_mapping;
/
