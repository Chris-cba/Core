CREATE OR REPLACE PACKAGE BODY nm3ft_mapping AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm3ft_mapping.pkb-arc   2.4   Jan 26 2016 09:14:10   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3ft_mapping.pkb  $
--       Date into PVCS   : $Date:   Jan 26 2016 09:14:10  $
--       Date fetched Out : $Modtime:   Jan 26 2016 09:13:54  $
--       Version          : $Revision:   2.4  $
--       Based on SCCS version : 1.2
-------------------------------------------------------------------------
--   Author : M Huitson.
--
--   nm3ft_mapping body
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
--all global package variables here
  --
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.4  $';
  g_package_name CONSTANT varchar2(30) := 'nm3ft_mapping';
--
  g_attr_list ptr_vc_array_type;
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
function set_attr_list return ptr_vc_array_type is
retval ptr_vc_array := nm3array.init_ptr_vc_array;
retval2 ptr_vc_array := nm3array.init_ptr_vc_array;
begin
--RC - a list of usable attributes and those attributes used internally within the mapping functionality
   retval.pa.extend(154);
   retval.pa(1) := ptr_vc(1,'IIT_NE_ID');
   retval.pa(2) := ptr_vc(2,'IIT_NUM_ATTRIB102');
   retval.pa(3) := ptr_vc(3,'IIT_NUM_ATTRIB103');
   retval.pa(4) := ptr_vc(4,'IIT_NUM_ATTRIB104');
   retval.pa(5) := ptr_vc(5,'IIT_NUM_ATTRIB105');
   retval.pa(6) := ptr_vc(6,'IIT_NUM_ATTRIB106');
   retval.pa(7) := ptr_vc(7,'IIT_NUM_ATTRIB107');
   retval.pa(8) := ptr_vc(8,'IIT_NUM_ATTRIB108');
   retval.pa(9) := ptr_vc(9,'IIT_NUM_ATTRIB109');
   retval.pa(10) := ptr_vc(10,'IIT_NUM_ATTRIB110');
   retval.pa(11) := ptr_vc(11,'IIT_NUM_ATTRIB111');
   retval.pa(12) := ptr_vc(12,'IIT_NUM_ATTRIB112');
   retval.pa(13) := ptr_vc(13,'IIT_NUM_ATTRIB113');
   retval.pa(14) := ptr_vc(14,'IIT_NUM_ATTRIB114');
   retval.pa(15) := ptr_vc(15,'IIT_NUM_ATTRIB115');
   retval.pa(16) := ptr_vc(16,'IIT_CHR_ATTRIB37');
   retval.pa(17) := ptr_vc(17,'IIT_CHR_ATTRIB38');
   retval.pa(18) := ptr_vc(18,'IIT_CHR_ATTRIB39');
   retval.pa(19) := ptr_vc(19,'IIT_CHR_ATTRIB40');
   retval.pa(20) := ptr_vc(20,'IIT_CHR_ATTRIB41');
   retval.pa(21) := ptr_vc(21,'IIT_CHR_ATTRIB42');
   retval.pa(22) := ptr_vc(22,'IIT_CHR_ATTRIB43');
   retval.pa(23) := ptr_vc(23,'IIT_CHR_ATTRIB44');
   retval.pa(24) := ptr_vc(24,'IIT_CHR_ATTRIB45');
   retval.pa(25) := ptr_vc(25,'IIT_CHR_ATTRIB46');
   retval.pa(26) := ptr_vc(26,'IIT_CHR_ATTRIB47');
   retval.pa(27) := ptr_vc(27,'IIT_CHR_ATTRIB48');
   retval.pa(28) := ptr_vc(28,'IIT_CHR_ATTRIB49');
   retval.pa(29) := ptr_vc(29,'IIT_CHR_ATTRIB50');
   retval.pa(30) := ptr_vc(30,'IIT_CHR_ATTRIB51');
   retval.pa(31) := ptr_vc(31,'IIT_CHR_ATTRIB52');
   retval.pa(32) := ptr_vc(32,'IIT_CHR_ATTRIB53');
   retval.pa(33) := ptr_vc(33,'IIT_CHR_ATTRIB54');
   retval.pa(34) := ptr_vc(34,'IIT_CHR_ATTRIB55');
   retval.pa(35) := ptr_vc(35,'IIT_CHR_ATTRIB56');
   retval.pa(36) := ptr_vc(36,'IIT_CHR_ATTRIB57');
   retval.pa(37) := ptr_vc(37,'IIT_CHR_ATTRIB58');
   retval.pa(38) := ptr_vc(38,'IIT_CHR_ATTRIB59');
   retval.pa(39) := ptr_vc(39,'IIT_CHR_ATTRIB60');
   retval.pa(40) := ptr_vc(40,'IIT_CHR_ATTRIB61');
   retval.pa(41) := ptr_vc(41,'IIT_CHR_ATTRIB62');
   retval.pa(42) := ptr_vc(42,'IIT_CHR_ATTRIB63');
   retval.pa(43) := ptr_vc(43,'IIT_CHR_ATTRIB64');
   retval.pa(44) := ptr_vc(44,'IIT_CHR_ATTRIB65');
   retval.pa(45) := ptr_vc(45,'IIT_CHR_ATTRIB66');
   retval.pa(46) := ptr_vc(46,'IIT_CHR_ATTRIB67');
   retval.pa(47) := ptr_vc(47,'IIT_CHR_ATTRIB68');
   retval.pa(48) := ptr_vc(48,'IIT_CHR_ATTRIB69');
   retval.pa(49) := ptr_vc(49,'IIT_CHR_ATTRIB70');
   retval.pa(50) := ptr_vc(50,'IIT_CHR_ATTRIB71');
   retval.pa(51) := ptr_vc(51,'IIT_CHR_ATTRIB72');
   retval.pa(52) := ptr_vc(52,'IIT_CHR_ATTRIB73');
   retval.pa(53) := ptr_vc(53,'IIT_CHR_ATTRIB74');
   retval.pa(54) := ptr_vc(54,'IIT_CHR_ATTRIB75');
   retval.pa(55) := ptr_vc(55,'IIT_NUM_ATTRIB76');
   retval.pa(56) := ptr_vc(56,'IIT_NUM_ATTRIB77');
   retval.pa(57) := ptr_vc(57,'IIT_NUM_ATTRIB78');
   retval.pa(58) := ptr_vc(58,'IIT_NUM_ATTRIB79');
   retval.pa(59) := ptr_vc(59,'IIT_NUM_ATTRIB80');
   retval.pa(60) := ptr_vc(60,'IIT_NUM_ATTRIB81');
   retval.pa(61) := ptr_vc(61,'IIT_NUM_ATTRIB82');
   retval.pa(62) := ptr_vc(62,'IIT_NUM_ATTRIB83');
   retval.pa(63) := ptr_vc(63,'IIT_NUM_ATTRIB84');
   retval.pa(64) := ptr_vc(64,'IIT_NUM_ATTRIB85');
   retval.pa(65) := ptr_vc(65,'IIT_DATE_ATTRIB86');
   retval.pa(66) := ptr_vc(66,'IIT_DATE_ATTRIB87');
   retval.pa(67) := ptr_vc(67,'IIT_DATE_ATTRIB88');
   retval.pa(68) := ptr_vc(68,'IIT_DATE_ATTRIB89');
   retval.pa(69) := ptr_vc(69,'IIT_DATE_ATTRIB90');
   retval.pa(70) := ptr_vc(70,'IIT_DATE_ATTRIB91');
   retval.pa(71) := ptr_vc(71,'IIT_DATE_ATTRIB92');
   retval.pa(72) := ptr_vc(72,'IIT_DATE_ATTRIB93');
   retval.pa(73) := ptr_vc(73,'IIT_DATE_ATTRIB94');
   retval.pa(74) := ptr_vc(74,'IIT_DATE_ATTRIB95');
   retval.pa(75) := ptr_vc(75,'IIT_ANGLE');
   retval.pa(76) := ptr_vc(76,'IIT_ANGLE_TXT');
   retval.pa(77) := ptr_vc(77,'IIT_CLASS');
   retval.pa(78) := ptr_vc(78,'IIT_CLASS_TXT');
   retval.pa(79) := ptr_vc(79,'IIT_COLOUR');
   retval.pa(80) := ptr_vc(80,'IIT_COLOUR_TXT');
   retval.pa(81) := ptr_vc(81,'IIT_COORD_FLAG');
   retval.pa(82) := ptr_vc(82,'IIT_DESCRIPTION');
   retval.pa(83) := ptr_vc(83,'IIT_DIAGRAM');
   retval.pa(84) := ptr_vc(84,'IIT_DISTANCE');
   retval.pa(85) := ptr_vc(85,'IIT_END_CHAIN');
   retval.pa(86) := ptr_vc(86,'IIT_GAP');
   retval.pa(87) := ptr_vc(87,'IIT_HEIGHT');
   retval.pa(88) := ptr_vc(88,'IIT_HEIGHT_2');
   retval.pa(89) := ptr_vc(89,'IIT_ID_CODE');
   retval.pa(90) := ptr_vc(90,'IIT_INSTAL_DATE');
   retval.pa(91) := ptr_vc(91,'IIT_INVENT_DATE');
   retval.pa(92) := ptr_vc(92,'IIT_INV_OWNERSHIP');
   retval.pa(93) := ptr_vc(93,'IIT_ITEMCODE');
   retval.pa(94) := ptr_vc(94,'IIT_LCO_LAMP_CONFIG_ID');
   retval.pa(95) := ptr_vc(95,'IIT_LENGTH');
   retval.pa(96) := ptr_vc(96,'IIT_MATERIAL');
   retval.pa(97) := ptr_vc(97,'IIT_MATERIAL_TXT');
   retval.pa(98) := ptr_vc(98,'IIT_METHOD');
   retval.pa(99) := ptr_vc(99,'IIT_METHOD_TXT');
   retval.pa(100) := ptr_vc(100,'IIT_NO_OF_UNITS');
   retval.pa(101) := ptr_vc(101,'IIT_OPTIONS');
   retval.pa(102) := ptr_vc(102,'IIT_OPTIONS_TXT');
   retval.pa(103) := ptr_vc(103,'IIT_OUN_ORG_ID_ELEC_BOARD');
   retval.pa(104) := ptr_vc(104,'IIT_OWNER');
   retval.pa(105) := ptr_vc(105,'IIT_OWNER_TXT');
   retval.pa(106) := ptr_vc(106,'IIT_PEO_INVENT_BY_ID');
   retval.pa(107) := ptr_vc(107,'IIT_PHOTO');
   retval.pa(108) := ptr_vc(108,'IIT_POWER');
   retval.pa(109) := ptr_vc(109,'IIT_PROV_FLAG');
   retval.pa(110) := ptr_vc(110,'IIT_REV_BY');
   retval.pa(111) := ptr_vc(111,'IIT_REV_DATE');
   retval.pa(112) := ptr_vc(112,'IIT_TYPE');
   retval.pa(113) := ptr_vc(113,'IIT_TYPE_TXT');
   retval.pa(114) := ptr_vc(114,'IIT_WIDTH');
   retval.pa(115) := ptr_vc(115,'IIT_XTRA_CHAR_1');
   retval.pa(116) := ptr_vc(116,'IIT_XTRA_DATE_1');
   retval.pa(117) := ptr_vc(117,'IIT_XTRA_DOMAIN_1');
   retval.pa(118) := ptr_vc(118,'IIT_XTRA_DOMAIN_TXT_1');
   retval.pa(119) := ptr_vc(119,'IIT_XTRA_NUMBER_1');
   retval.pa(120) := ptr_vc(120,'IIT_OFFSET');
   retval.pa(121) := ptr_vc(121,'IIT_X');
   retval.pa(122) := ptr_vc(122,'IIT_Y');
   retval.pa(123) := ptr_vc(123,'IIT_Z');
   retval.pa(124) := ptr_vc(124,'IIT_NUM_ATTRIB96');
   retval.pa(125) := ptr_vc(125,'IIT_NUM_ATTRIB97');
   retval.pa(126) := ptr_vc(126,'IIT_NUM_ATTRIB98');
   retval.pa(127) := ptr_vc(127,'IIT_NUM_ATTRIB99');
   retval.pa(128) := ptr_vc(128,'IIT_NUM_ATTRIB100');
   retval.pa(129) := ptr_vc(129,'IIT_PRIMARY_KEY');
   retval.pa(130) := ptr_vc(130,'IIT_FOREIGN_KEY');
   retval.pa(131) := ptr_vc(131,'IIT_POSITION');
   retval.pa(132) := ptr_vc(132,'IIT_X_COORD');
   retval.pa(133) := ptr_vc(133,'IIT_Y_COORD');
   retval.pa(134) := ptr_vc(134,'IIT_NUM_ATTRIB16');
   retval.pa(135) := ptr_vc(135,'IIT_NUM_ATTRIB17');
   retval.pa(136) := ptr_vc(136,'IIT_NUM_ATTRIB18');
   retval.pa(137) := ptr_vc(137,'IIT_NUM_ATTRIB19');
   retval.pa(138) := ptr_vc(138,'IIT_NUM_ATTRIB20');
   retval.pa(139) := ptr_vc(139,'IIT_NUM_ATTRIB21');
   retval.pa(140) := ptr_vc(140,'IIT_NUM_ATTRIB22');
   retval.pa(141) := ptr_vc(141,'IIT_NUM_ATTRIB23');
   retval.pa(142) := ptr_vc(142,'IIT_NUM_ATTRIB24');
   retval.pa(143) := ptr_vc(143,'IIT_NUM_ATTRIB25');
   retval.pa(144) := ptr_vc(144,'IIT_CHR_ATTRIB26');
   retval.pa(145) := ptr_vc(145,'IIT_CHR_ATTRIB27');
   retval.pa(146) := ptr_vc(146,'IIT_CHR_ATTRIB28');
   retval.pa(147) := ptr_vc(147,'IIT_CHR_ATTRIB29');
   retval.pa(148) := ptr_vc(148,'IIT_CHR_ATTRIB30');
   retval.pa(149) := ptr_vc(149,'IIT_CHR_ATTRIB31');
   retval.pa(150) := ptr_vc(150,'IIT_CHR_ATTRIB32');
   retval.pa(151) := ptr_vc(151,'IIT_CHR_ATTRIB33');
   retval.pa(152) := ptr_vc(152,'IIT_CHR_ATTRIB34');
   retval.pa(153) := ptr_vc(153,'IIT_CHR_ATTRIB35');
   retval.pa(154) := ptr_vc(154,'IIT_CHR_ATTRIB36');
   retval.pa(155) := ptr_vc(155,'IIT_NUM_ATTRIB101');
-- RC - rationalis the data in case any array elements need to be removed.   
   select ptr_vc(ptr_id, ptr_value)
   bulk collect into retval2.pa
   from table( retval.pa )
   where ptr_value is not null;
   return retval2.pa;
end;
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

--  g_attr_list := set_attr_list;

  SELECT column_name
    ,data_length, data_type
    BULK COLLECT
    INTO lt_cols
    FROM all_tab_cols, table(g_attr_list)
   WHERE table_name = 'NM_INV_ITEMS_ALL'
     AND owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
     AND column_name = ptr_value
--     AND column_name != 'IIT_PRIMARY_KEY'     
   ORDER
      BY column_id
       ;
  /*
  || Add The Columns To The Relevent Tables.
  */
  
--nm_debug.debug('col_count '||lt_cols.count );
  
  FOR i IN 1 .. lt_cols.count LOOP
    --
    g_inv_type_cols(i).inv_col_name   := lt_cols(i).inv_col_name;
    g_inv_type_cols(i).inv_col_length := lt_cols(i).inv_col_length;
    g_inv_type_cols(i).assigned       := FALSE;
    g_inv_type_cols(i).ft_col_name    := NULL;
    --
--  nm_debug.debug('g_col = '||lt_cols(i).inv_col_name );
--  IF SUBSTR(lt_cols(i).inv_col_name,1,14) = 'IIT_NUM_ATTRIB'
    IF lt_cols(i).inv_col_data_type = 'NUMBER'
     THEN
        g_inv_numb_attr_cols(lv_numb_cnt).inv_col_name   := lt_cols(i).inv_col_name;
        g_inv_numb_attr_cols(lv_numb_cnt).inv_col_length := lt_cols(i).inv_col_length;
        g_inv_numb_attr_cols(lv_numb_cnt).assigned       := FALSE;
        g_inv_numb_attr_cols(lv_numb_cnt).ft_col_name    := NULL;
        lv_numb_cnt := lv_numb_cnt+1;
--  ELSIF SUBSTR(lt_cols(i).inv_col_name,1,14) = 'IIT_CHR_ATTRIB'
    ELSIF lt_cols(i).inv_col_data_type = 'VARCHAR2'
     THEN
        g_inv_char_attr_cols(lv_char_cnt).inv_col_name   := lt_cols(i).inv_col_name;
        g_inv_char_attr_cols(lv_char_cnt).inv_col_length := lt_cols(i).inv_col_length;
        g_inv_char_attr_cols(lv_char_cnt).assigned    := FALSE;
        g_inv_char_attr_cols(lv_char_cnt).ft_col_name := NULL;
        lv_char_cnt := lv_char_cnt+1;
--  ELSIF SUBSTR(lt_cols(i).inv_col_name,1,15) = 'IIT_DATE_ATTRIB'
    ELSIF lt_cols(i).inv_col_data_type = 'DATE'     THEN
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
--nm_debug.debug('get_iit_index - count = '||g_inv_type_cols.count);
  FOR i IN 1..g_inv_type_cols.count LOOP
--  nm_debug.debug('in loop i = '||i );
    --     
    IF g_inv_type_cols(i).inv_col_name = pi_inv_col
     THEN
        lv_retval := i;
        exit;
    END IF;
    --
  END LOOP;
  --
--nm_debug.debug('Loop index '||lv_retval||', col-name = '||pi_inv_col );
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
--  nm_debug.debug('Map - index = '||pi_index||', col = '||pi_ft_col );
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
--      nm_debug.debug('statics - IIT_NE_ID');
        map(pi_index  => get_iit_index('IIT_NE_ID')
           ,pi_ft_col => lr_nit.nit_foreign_pk_column);
        --
        IF(pi_map_pk)
         THEN
--        nm_debug.debug('statics - IIT_PRIMARY_KEY');
            map(pi_index  => get_iit_index('IIT_PRIMARY_KEY')
               ,pi_ft_col => lr_nit.nit_foreign_pk_column);
--        nm_debug.debug('IIT_PK is mapped');
        END IF;
    END IF;
    --
    IF lr_nit.nit_lr_ne_column_name IS NOT NULL
     THEN
--      nm_debug.debug('Statics - IIT_FOREIGN_KEY');
        map(pi_index  => get_iit_index('IIT_FOREIGN_KEY')
           ,pi_ft_col => lr_nit.nit_lr_ne_column_name);
    END IF;
    --
    IF lr_nit.nit_lr_st_chain IS NOT NULL
     THEN
--      nm_debug.debug('Statics - IIT_OFFSET');
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

-- Actual start of map_ft_to_iit
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
--      nm_debug.debug('Init_mapping_tabs');
      init_mapping_tabs;
      /*
      || Set The Static Columns.
      */
--      nm_debug.debug('Statics');
      map_static_columns;
      /*
      || Set The Attribute Columns.
      */
--      nm_debug.debug('Map Attribs');
      map_attribs(pi_inv_type => pi_inv_type);
      /*
      || Copy The Attribute Mapping Into
      || The Inv Type Mapping.
      */
--      nm_debug.debug('Set_attribs');
      set_attribs;
      /*
      || Set The Global Inv Type To Save Time
      || If The Next Call Is For The Same Type.
      */
      g_inv_type := pi_inv_type;
      --      
  END IF;
  --
--    debug_map_table;
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
  nm_debug.debug('Debug map table - count = '||g_inv_type_cols.count );
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
begin
  g_attr_list := set_attr_list;
--nm_debug.debug_on;
END nm3ft_mapping;
/
