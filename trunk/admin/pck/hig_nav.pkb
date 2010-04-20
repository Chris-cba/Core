CREATE OR REPLACE PACKAGE BODY hig_nav
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/hig_nav.pkb-arc   3.3   Apr 20 2010 09:12:18   lsorathia  $
--       Module Name      : $Workfile:   hig_nav.pkb  $
--       Date into PVCS   : $Date:   Apr 20 2010 09:12:18  $
--       Date fetched Out : $Modtime:   Apr 20 2010 09:09:48  $
--       Version          : $Revision:   3.3  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   3.3  $';

  g_package_name CONSTANT varchar2(30) := 'hig_nav';
  l_top_id       nav_id := nav_id(Null);

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
FUNCTION get_primary_hierarchy(pi_tab_name IN Varchar2)
RETURN Varchar2
IS
--
   CURSOR c_get_primary_hier
   IS
   SELECT hnv_hierarchy_type
   FROM   hig_navigator
   WHERE  substr(UPPER(hnv_child_table),1,decode(instr(hnv_child_table,' '),0,length(hnv_child_table),instr(hnv_child_table,' ')-1))  = Upper(pi_tab_name)
   AND    hnv_primary_hierarchy  = 'Y';
   l_hierarchy_type hig_navigator.hnv_hierarchy_type%TYPE ;
--
BEGIN
--
   OPEN  c_get_primary_hier;
   FETCH c_get_primary_hier INTO l_hierarchy_type;
   CLOSE c_get_primary_hier;
  
   RETURN l_hierarchy_type ;
--
END get_primary_hierarchy;
--
FUNCTION get_hierarchy_cnt(pi_tab_name IN Varchar2)
RETURN Number
IS
--
   CURSOR c_get_primary_hier
   IS
   SELECT Count(distinct HNV_HIERARCHY_TYPE)
   FROM   hig_navigator
   WHERE  substr(UPPER(hnv_child_table),1,decode(instr(hnv_child_table,' '),0,length(hnv_child_table),instr(hnv_child_table,' ')-1))  = Upper(pi_tab_name) ;
   l_count Number ;
--
BEGIN
--
   OPEN  c_get_primary_hier;
   FETCH c_get_primary_hier INTO l_count;
   CLOSE c_get_primary_hier;
  
   RETURN l_count ;
--
END get_hierarchy_cnt;
--
FUNCTION get_theme(pi_iit_id Varchar2,pi_tab_name Varchar2) RETURN BOOLEAN 
IS
--
   CURSOR c_get_theme
   IS
   SELECT '1' from nm_inv_themes nith,nm_inv_types
   WHERE  nit_table_name  = pi_tab_name
   AND    NITH_NIT_ID     = nit_inv_type;
   
   CURSOR c_get_theme_from_inv(qp_type Varchar2)
   IS
   SELECT '1' 
   FROM   nm_inv_themes nith
   WHERE  NITH_NIT_ID = qp_type ;
   l_found Varchar2(1);
BEGIN
--
   IF pi_tab_name != 'NM_INV_ITEMS'
   THEN
       OPEN  c_get_theme;
       FETCH c_get_theme INTO l_found;
       CLOSE c_get_theme;
   ELSE
       OPEN  c_get_theme_from_inv(nm3get.get_iit(pi_iit_id,False).iit_inv_type);
       FETCH c_get_theme_from_inv INTO l_found;
       CLOSE c_get_theme_from_inv;
   END IF ;
     
   RETURN l_found = '1';        
--
END get_theme;
--
PROCEDURE pop_plsql_tab(pi_gis_session_id NUMBER)
IS
BEGIN
--
   hig_nav.ini_id_tab;
   FOR i in (SELECT gdo_pk_id 
             FROM   gis_data_objects 
             WHERE  gdo_session_id = pi_gis_session_id )
   LOOP
       hig_nav.populate_id_in_tab(i.gdo_pk_id);
   END LOOp;
--
END pop_plsql_tab ;
--
FUNCTION  get_nav_tab_for_gis(pi_gis_session_id NUMBER) RETURN VARCHAR2
IS
   CURSOR c_tab_name
   IS
   SELECT distinct nit_table_name 
   FROM   hig_navigator,
          nm_inv_themes,
          nm_themes_all,
          gis_data_objects,
          nm_inv_types
   WHERE  gdo_theme_name = nth_theme_name
   AND    gdo_session_id = pi_gis_session_id
   AND    nith_nth_theme_id = nth_theme_id
   AND    nith_nit_id = nit_inv_type
   AND    nit_table_name = substr(UPPER(hnv_child_table),1,decode(instr(hnv_child_table,' '),0,length(hnv_child_table),instr(hnv_child_table,' ')-1)) ;
   l_tab_name Varchar2(50);
BEGIN
--
   OPEN  c_tab_name;
   FETCH c_tab_name INTO l_tab_name;
   CLOSE c_tab_name;
   RETURN l_tab_name;
--
END get_nav_tab_for_gis;
--
FUNCTION  get_module_param(pi_module Varchar2, pi_hierarchy_label hig_navigator_modules.hnm_hierarchy_label%TYPE) RETURN hig_navigator_modules%ROWTYPE
IS
   CURSOR get_pri_module
   IS
   SELECT *
   FROM   hig_navigator_modules
   WHERE  Upper(hnm_module_name)     = pi_module 
   AND    Upper(hnm_hierarchy_label) = pi_hierarchy_label;
   l_rec  hig_navigator_modules%ROWTYPE ;
--
BEGIN
--
   OPEN  get_pri_module;
   FETCH get_pri_module INTO l_rec;
   CLOSE get_pri_module;

   RETURN l_rec;
--
END get_module_param ;
--
FUNCTION  get_primary_module(pi_hierarchy_label hig_navigator_modules.hnm_hierarchy_label%TYPE) RETURN hig_navigator_modules%ROWTYPE 
IS
--
   CURSOR get_pri_module
   IS
   SELECT *
   FROM   hig_navigator_modules
   WHERE  Upper(hnm_hierarchy_label)  = Upper(pi_hierarchy_label)
   AND    hnm_primary_module   = 'Y';
   l_rec  hig_navigator_modules%ROWTYPE ;
--
BEGIN
--
   OPEN  get_pri_module;
   FETCH get_pri_module INTO l_rec;
   CLOSE get_pri_module;

   RETURN l_rec;
--
END get_primary_module;
--
FUNCTION  get_primary_module(pi_table_name hig_navigator_modules.hnm_table_name%TYPE) 
RETURN hig_navigator_modules%ROWTYPE 
IS
--
   CURSOR get_pri_module
   IS
   SELECT *
   FROM   hig_navigator_modules
   WHERE  Upper(hnm_table_name)  = Upper(pi_table_name)
   AND    hnm_primary_module   = 'Y';
   l_rec  hig_navigator_modules%ROWTYPE ;
--
BEGIN
--
   OPEN  get_pri_module;
   FETCH get_pri_module INTO l_rec;
   CLOSE get_pri_module;

   RETURN l_rec;
--
END get_primary_module;
--
PROCEDURE set_hierarchy_type (pi_type hig_navigator.hnv_hierarchy_type%TYPE)
IS
--
BEGIN
--
   l_hir_type := pi_type;
--
END set_hierarchy_type ;
--
FUNCTION get_hnv  (pi_label IN VARCHAR2)  
RETURN hig_navigator%ROWTYPE
IS
--
   CURSOR c_get_hie
   IS
   SELECT hnv.*
   FROM   hig_navigator hnv
   WHERE  upper(hnv_hierarchy_label) = Upper(pi_label); 
   l_rec  hig_navigator%ROWTYPE;
BEGIN
--
   OPEN  c_get_hie;
   FETCH c_get_hie INTO l_rec;
   CLOSE c_get_hie;
  
   RETURN l_rec;
--
END get_hnv;   
--
--
FUNCTION get_hnv (pi_label IN VARCHAR2,pi_hierarchy hig_navigator.hnv_hierarchy_type%TYPE)  
RETURN hig_navigator%ROWTYPE
IS
--
   CURSOR c_get_hie
   IS
   SELECT hnv.*
   FROM   hig_navigator hnv
   WHERE  upper(hnv_hierarchy_label) = Upper(pi_label)
   AND    hnv_hierarchy_type         = pi_hierarchy;
   l_rec  hig_navigator%ROWTYPE;
BEGIN
--
   OPEN  c_get_hie;
   FETCH c_get_hie INTO l_rec;
   CLOSE c_get_hie;
  
   RETURN l_rec;
--
END get_hnv;   
--
FUNCTION get_Id_tab 
RETURN nav_id
IS
--
BEGIN
--
   RETURN  hig_nav.id_tab;
--
END get_id_tab;
--
/*Function get_result_tab Return hig_navigator_tab
IS
BEGIN
--
   RETURN hig_nav.l_result_tab;
--
END get_result_tab;
--
*/
PROCEDURE ini_id_tab
IS
--
BEGIN
--
   id_tab.delete;
--
END ini_id_tab;
--
/*PROCEDURE ini_result_tab
IS
--
BEGIN
--
   l_result_tab.delete;
--
END ini_result_tab;
--
*/
PROCEDURE populate_id_in_tab (pi_id Varchar2)
IS
--
BEGIN
--
   id_tab.extend;
   id_tab(id_tab.count) := pi_id;
--
END populate_id_in_tab;
--
PROCEDURE populate_result_tab (pi_sql IN Varchar2)
IS
--
BEGIN
--
--nm_debug.debug_on;
--nm_debug.debug('test '||'BEGIN INSERT INTO hig_navigator_result_tab ('||pi_sql||'); END;');
   Execute Immediate 'Truncate Table hig_navigator_result_tab';
   Execute Immediate 'BEGIN INSERT INTO hig_navigator_result_tab ('||pi_sql||'); END;';
--
END populate_result_tab ;
--
FUNCTION get_ial (pi_ial_domain        nm_inv_attri_lookup.ial_domain%TYPE
                 ,pi_ial_value         nm_inv_attri_lookup.ial_value%TYPE
                 ) RETURN nm_inv_attri_lookup.ial_meaning%TYPE IS
--
   CURSOR cs_ial IS
   SELECT /*+ INDEX (ial IAL_PK) */ ial_meaning
    FROM  nm_inv_attri_lookup ial
   WHERE  ial.ial_domain = pi_ial_domain
    AND   ial.ial_value  = pi_ial_value;
--
   l_retval nm_inv_attri_lookup.ial_meaning%TYPE;
--
BEGIN
--
--   nm_debug.proc_start(g_package_name,'get_ial');
--
   OPEN  cs_ial;
   FETCH cs_ial INTO l_retval;
   CLOSE cs_ial;
   Return l_retval ;
--
END get_ial;
--
PROCEDURE get_column_displyed(pi_inv_type IN  nm_inv_types.nit_inv_type%TYPE
                             ,po_cols     OUT Varchar2
                             ,po_col_cnt  OUT Number)
IS
--
   l_dis_cnt    Number ;
   l_cnt        Number := 0 ;
   l_col_name   nm_inv_type_attribs.ita_attrib_name%TYPE ;
   l_seq_no     Number ;
   l_reduce_cnt Number := 0 ;
--
BEGIN
--
   SELECT Count(0)
   INTO   l_dis_cnt
   FROM   nm_inv_type_attribs
   WHERE  ita_inv_type = pi_inv_type 
   AND    ita_displayed = 'Y';
   
   IF l_dis_cnt > 0
   THEN       
       FOR i IN (SELECT *
                 FROM   nm_inv_type_attribs
                 WHERE  ita_inv_type = pi_inv_type 
                 AND    ita_displayed = 'Y'                 
                 ORDER BY ita_disp_seq_no)
       LOOP
           l_cnt := l_cnt + 1;
           IF i.ita_id_domain IS NOT NULL
           THEN
               po_cols := po_cols||',Substr(hig_nav.get_ial('''||i.ita_id_domain||''','||i.ita_attrib_name||'),1,500) ';
           --ELSIF i.ita_query IS NOT NULL
           --THEN
           --    po_cols := po_cols||',Substr(hig_nav.get_ita_meaning('''||i.ita_inv_type||''','''||i.ita_attrib_name||''','||i.ita_attrib_name||'),1,500) ';
           ELSE
               IF i.ita_format = 'DATE'
               THEN
                   --po_cols := po_cols||',To_Char('||i.ita_attrib_name||',''DD-Mon-YYYY'') COL_'||l_cnt;
                   po_cols := po_cols||',To_Char(Trunc('||i.ita_attrib_name||'),''DD-Mon-YYYY'') ';
               ELSE
                   po_cols := po_cols||',Substr(To_Char('||i.ita_attrib_name||'),1,500) ';
               END IF ;
           END IF;
       END LOOP; 
   END IF ;
   get_pk_column (pi_inv_type 
                 ,l_col_name 
                 ,l_seq_no );
   IF l_seq_no IS NULL
   THEN
       l_reduce_cnt := 1;
       po_cols := po_cols||','||l_col_name ;
   ELSE
       l_reduce_cnt := 0;
   END IF ;
   FOR i IN 1..168-(l_dis_cnt+l_reduce_cnt)
   LOOP
       po_cols := po_cols||',Null' ;
   END LOOP;  
   po_cols := Substr(po_cols,2);
   po_col_cnt  :=  l_dis_cnt ;
--
END get_column_displyed;
--
PROCEDURE get_pk_column(pi_inv_type IN  nm_inv_types.nit_inv_type%TYPE 
                       ,po_col_name OUT nm_inv_type_attribs.ita_attrib_name%TYPE
                       ,po_seq_no   OUT Number)
--
IS
   
   l_ita_rec  nm_inv_type_attribs%ROWTYPE;
   l_pk_col   nm_inv_types.nit_foreign_pk_column%TYPE := NVL(nm3get.get_nit(pi_inv_type).nit_foreign_pk_column,'IIT_NE_ID'); 
   l_seq_no   Number := 0 ;
   l_col_name Varchar2(50);
--
BEGIN
--
   FOR i IN (SELECT *
             FROM   nm_inv_type_attribs
             WHERE  --ita_attrib_name = (SELECT Nvl(nit_foreign_pk_column,'IIT_NE_ID') FROM nm_inv_types WHERE nit_inv_type = pi_inv_type)
             --AND    
                    ita_inv_type    = pi_inv_type
             ORDER  BY ita_disp_seq_no )
   LOOP
       IF i.ita_displayed = 'Y'
       THEN
           l_seq_no := l_seq_no + 1;
       END IF ;
       IF i.ita_attrib_name = l_pk_col        
       AND i.ita_displayed = 'Y'
       THEN
           l_col_name := i.ita_attrib_name ;
           po_seq_no   := l_seq_no ;
           Exit ;
       ELSE
           --l_col_name := i.ita_attrib_name ;
           l_col_name := l_pk_col ;
       --    Exit ;
       END IF ;
   END LOOP;
   IF l_col_name IS NOT NULL
   THEN 
       po_col_name := l_col_name  ;
   ELSE
       po_col_name := 'IIT_NE_ID';
   END IF ;
--
END get_pk_column;
--
FUNCTION get_ita_for_seq(pi_inv_type IN  nm_inv_types.nit_inv_type%TYPE
                        ,pi_seq_no   IN  Number) 
RETURN nm_inv_type_attribs%ROWTYPE
IS
--
   l_rec_cnt Number := 0 ;
   l_ita_rec  nm_inv_type_attribs%ROWTYPE;
BEGIN
--
   FOR i IN (SELECT *
             FROM   nm_inv_type_attribs
             WHERE  ita_inv_type = pi_inv_type
             AND    ita_displayed = 'Y'
             ORDER BY ita_disp_seq_no)
   LOOP
       l_rec_cnt := l_rec_cnt + 1;
       IF l_rec_cnt = pi_seq_no
       THEN
           l_ita_rec  := i;
           Exit;
       END IF ;
   END LOOP;
   Return l_ita_rec;
-- 
END get_ita_for_seq;
--
FUNCTION get_tab(pi_tab hig_navigator_tab) RETURN hig_navigator_tab
IS
BEGIN
   RETURN pi_tab;
END get_tab ;
--
PROCEDURE pop_up_child(pi_id IN VARCHAR2
                      ,pi_alias Varchar2)
IS
--
   l_sql       Varchar2(32767) ;
   l_tab_join  Varchar2(1000);
   l_col_join  Varchar2(1000);
   l_label     Varchar2(32767) ;
   cnt number := 0 ;
   col varchar2(100); 
   TYPE l_ref is REF CURSOR;
   tab_cnt Number := 0 ;
   l_r l_ref;
   l_type hig_navigator_type := hig_navigator_type(Null,Null,Null,null,Null,Null);
   l_top Varchar2(100) ;
   p_id Varchar2(100);
   where_col Varchar2(100);
   top_alias Varchar2(100);
   top_level Boolean := FALSE;
   out_cnt Number := 0 ;
   par_id  Varchar2(100) ;
   l_add_con Varchar2(4000) ;
   l_and_where Varchar2(20);
   l_select    Varchar2(1000);
BEGIN
--    
   SELECT UPPER(hnv_child_id),upper(hnv_child_alias) 
   INTO   where_col,top_alias                
   FROM   hig_navigator b 
   WHERE  hnv_child_alias = pi_alias
   AND    hnv_hierarchy_type = l_hir_type;
   nm3ctx.set_context('NAV_VAR2',pi_id);
   FOR j IN (SELECT hnv_parent_column,hnv_child_column,hnv_child_table,hnv_hierarchy_level ,hnv_hierarchy_label,hnv_child_id,hnv_parent_id,hnv_ADDITIONAL_COND,
                    hnv_icon_name,hnv_PARent_ALIAS,hnv_CHILD_ALIAS,
                    hnv_hier_label_1,hnv_hier_label_2,hnv_hier_label_3,hnv_hier_label_4,hnv_hier_label_5,hnv_hier_label_6,hnv_hier_label_7,hnv_hier_label_8,hnv_hier_label_9,hnv_hier_label_10,hnv_hierarchy_seq
             FROM         
                 (SELECT hnv_parent_column,hnv_child_column,hnv_child_table,hnv_hierarchy_level ,hnv_hierarchy_label,hnv_child_id,hnv_parent_table,
                         hnv_parent_id,hnv_ADDITIONAL_COND,hnv_icon_name,hnv_PARent_ALIAS,hnv_CHILD_ALIAS,
                         hnv_hier_label_1,hnv_hier_label_2,hnv_hier_label_3,hnv_hier_label_4,hnv_hier_label_5,hnv_hier_label_6,hnv_hier_label_7,hnv_hier_label_8,hnv_hier_label_9,hnv_hier_label_10,hnv_hierarchy_seq
                  FROM   hig_navigator b
                  WHERE  hnv_hierarchy_type = l_hir_type
                 )
             CONNECT BY PRIOR hnv_child_alias = hnv_parent_alias
             START WITH hnv_child_alias = pi_alias
             ORDER BY hnv_hierarchy_level asc,hnv_hierarchy_seq)
   LOOP
       l_sql := build_child_sql(j.hnv_CHILD_ALIAS,top_alias,sys_context('NM3SQL','NAV_VAR1'));        
--nm_debug.debug('child '||l_sql);
       OPEN l_r for l_sql;
       LOOP
           FETCH l_r into l_type.data,l_type.label,l_type.icon,l_type.tab_level,l_type.parent,l_type.child ;
           EXIT WHEN l_r%NOTFOUND;
           tab_cnt := tab_cnt + 1;
           IF substr(l_type.parent,1,2) = '-1'
           THEN
               l_type.parent := Null;
           END IF; 
           l_tab.extend ;
           l_tab(l_tab.count) :=  l_type;
       END LOOP;
   END loop;
END  pop_up_child;
--
PROCEDURE populate_tree(pi_id  IN  nav_id
                       ,pi_tab IN  Varchar2
                       ,po_tab OUT hig_navigator_tab)
IS
--
   l_sql       Varchar2(32767) ;
   l_tab_join  Varchar2(1000);
   l_col_join  Varchar2(1000);
   l_label     Varchar2(32767) ;
   l_cnt       NUMBER := 0 ;
   tab_cnt     NUMBER := 0 ;
   l_type      hig_navigator_type := hig_navigator_type(null,null,null,null,null,null);
   l_top       Varchar2(100) ;
   p_id        Varchar2(100);
   where_col   Varchar2(100);
   top_alias   Varchar2(100);
   top_level   Boolean := FALSE;
   l_found     Number ;
   l_add_con Varchar2(4000) ;
   l_chi_alias Varchar2(10);
   l_par       Number ;
   Type ast_ref IS REF CURSOR;
   ast ast_ref ;
   TYPE l_ref is REF CURSOR;
   l_r l_ref;
   l_select    Varchar2(1000);
   l_top_id_cnt Number ;
   ---------------------------------------
   FUNCTION has_parent(pi_id Number)
   RETURN  NUMBER
   IS
      l_rec Number := 0 ;
   BEGIN
   --
      SELECT iig_top_id
      INTO   l_rec 
      FROM (
            SELECT iig_top_id
            FROM   nm_inv_item_groupings
            CONNECT BY  iig_item_id =  PRIOR iig_parent_id
            START WITH iig_parent_id = pi_id 
            UNION         
            SELECT iig_top_id
            FROM   nm_inv_item_groupings
            CONNECT BY  iig_item_id =  PRIOR iig_parent_id
            START WITH iig_item_id =  pi_id )
            WHERE rownum = 1 ;
      RETURN l_rec;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
          Return Null;
   --
   END ;
BEGIN
--
   l_tab.delete ;
   L_TOP_ID.dELETE ;
--nm_debug.debug_on;
   FOR i in 1..pi_id.count 
   LOOP
       p_id := pi_id(i);
--nm_debug.debug('p_id '||p_id); 
       IF p_id IS NOT NULL 
       THEN
           IF pi_tab = 'NM_INV_ITEMS_ALL' 
           THEN
               l_par := has_parent(p_id);
               IF Nvl(l_par,0) != 0
               THEN
                   p_id := l_par;
               END IF ;
               SELECT hnv_child_alias 
               INTO   l_chi_alias
               FROM   (
                       SELECT hnv_child_alias 
                       FROM   hig_navigator
                       WHERE  hnv_hierarchy_type = l_hir_type
                       AND    hnv_hierarchy_label IN (
                       SELECT hnv_hierarchy_label
                       FROM   hig_navigator 
                       WHERE  substr(UPPER(hnv_child_table),1,decode(instr(hnv_child_table,' '),0,length(hnv_child_table),instr(hnv_child_table,' ')-1)) =  pi_tab) 
                       ORDER BY hnv_hierarchy_level,hnv_hierarchy_seq)
               WHERE ROWNUM = 1;  
--nm_debug.debug('par alias '||l_chi_alias);                
           ELSE
               For m IN (
               SELECT hnv_child_alias 
               --INTO   l_chi_alias
               FROM   hig_navigator
               WHERE  hnv_hierarchy_type = Nvl(l_hir_type,hnv_hierarchy_type)
               AND    hnv_hierarchy_label IN (
                       SELECT hnv_hierarchy_label
                       FROM   hig_navigator
                       WHERE   substr(UPPER(hnv_child_table),1,decode(instr(hnv_child_table,' '),0,length(hnv_child_table),instr(hnv_child_table,' ')-1)) =  pi_tab)
               Order BY hnv_hierarchy_level,hnv_hierarchy_seq ) 
               LOOP
                   l_chi_alias := m.hnv_child_alias ;
                   Exit;
               END LOOP;
           END IF ; -- HIE_TYPE          
           --get_top_level(p_id,l_chi_alias);
           get_top_par(p_id,l_chi_alias);
           BEGIN
              SELECT Count(Column_value)
              INTO   l_top_id_cnt 
              FROM   Table(Cast(l_top_id AS nav_id)) ;
           EXCEPTION
               WHEN OTHERS THEN
               l_top_id_cnt  :=  0;
           END ;
           IF l_top_id_cnt  = 0
           THEN
               pop_up_child(p_id,l_chi_alias);
           ELSE
               FOR top_id IN (SELECT *
                             FROM   Table(Cast(l_top_id AS nav_id)) a)  
               LOOP  
                   nm3ctx.set_context('NAV_VAR1',top_id.column_value);  
                   BEGIN
                     SELECT Count(1) INTO l_found
                     FROM   table(cast(get_tab(l_tab) as hig_navigator_tab)) x
                     WHERE  child LIKE top_id.column_value||'%'                     
                     AND    parent IS NULL ;
                  EXCEPTION
                      WHEN OTHERS 
                      THEN
                          l_found := 0;
                  END ;
                  IF l_found = 0
                  THEN 
                      SELECT upper(hnv_child_column),upper(hnv_child_alias) 
                      INTO   where_col,top_alias                
                      FROM (
                            SELECT hnv_child_column,hnv_child_table,hnv_parent_table ,hnv_parent_column,hnv_parent_alias,hnv_child_alias               
                            FROM   hig_navigator b                       
                            WHERE  hnv_hierarchy_type  = l_hir_type) 
                      WHERE hnv_parent_column IS NULL
                      CONNECT BY hnv_child_alias = PRIOR hnv_Parent_alias
                      START WITH hnv_child_alias = l_chi_alias ;  
                      FOR j IN (SELECT hnv_parent_column,hnv_child_column,hnv_child_table,hnv_hierarchy_level ,hnv_hierarchy_label,hnv_child_id,hnv_parent_id,hnv_ADDITIONAL_COND,
                                hnv_icon_name,hnv_PARent_ALIAS,hnv_CHILD_ALIAS,
                                hnv_hier_label_1,hnv_hier_label_2,hnv_hier_label_3,hnv_hier_label_4,hnv_hier_label_5,hnv_hier_label_6,hnv_hier_label_7,hnv_hier_label_8,hnv_hier_label_9,hnv_hier_label_10,hnv_hierarchy_seq
                                FROM         
                                    (SELECT hnv_parent_column,hnv_child_column,hnv_child_table,hnv_hierarchy_level ,hnv_hierarchy_label,hnv_child_id,hnv_parent_table,hnv_parent_id,hnv_ADDITIONAL_COND,
                                            hnv_icon_name,hnv_PARent_ALIAS,hnv_CHILD_ALIAS,
                                            hnv_hier_label_1,hnv_hier_label_2,hnv_hier_label_3,hnv_hier_label_4,hnv_hier_label_5,hnv_hier_label_6,hnv_hier_label_7,
                                            hnv_hier_label_8,hnv_hier_label_9,hnv_hier_label_10,hnv_hierarchy_seq
                                     FROM   hig_navigator b
                                     WHERE  hnv_hierarchy_type = l_hir_type
                                     )
                                CONNECT BY PRIOR hnv_child_alias =  hnv_Parent_alias
                                START WITH hnv_child_alias = top_alias
                                ORDER BY hnv_hierarchy_level asc,hnv_hierarchy_seq)
                      LOOP
--nm_debug.debug(j.hnv_CHILD_ALIAS||','||top_alias||','||sys_context('NM3SQL','NAV_VAR1'));
                          l_sql := build_child_sql(j.hnv_CHILD_ALIAS,top_alias,sys_context('NM3SQL','NAV_VAR1'));  
--nm_debug.debug(l_sql);
                          OPEN l_r for l_sql;
                          LOOP
                              FETCH l_r into l_type.data,l_type.label,l_type.icon,l_type.tab_level,l_type.parent,l_type.child ;
                              EXIT WHEN l_r%NOTFOUND;
                              tab_cnt := tab_cnt + 1;
                              IF Substr(l_type.parent,1,2) = '-1'
                              THEN
                                  l_type.parent := Null; 
                              END IF; 
                              l_tab.extend ;
                              l_tab(l_tab.count) :=  l_type;
                          END LOOP;
                      END LOOP;
                  END IF ;                   
               END LOOP;
           END IF ;
       END IF ; -- p_id not null
   END loop;
   l_cnt := 0 ;
   po_tab := hig_navigator_tab(hig_navigator_type(Null,Null,Null,Null,null,Null));  
   FOR i in (SELECT x.*,level
             FROM   table(cast(get_tab(l_tab) as hig_navigator_tab)) x
             CONNECT BY parent= prior child
             START WITH parent IS NULL )
   LOOP
       l_cnt := l_cnt+1;
       l_type.data := i.data ;
       l_type.label := i.label ;
       l_type.icon := i.icon ;
       l_type.tab_level:= i.level ;--i.tab_level ;
       l_type.parent:= i.parent ;
       l_type.child := i.child ;          
       po_tab(po_tab.Count) :=  l_type;
       po_tab.extend;
   END LOOP;  
END populate_tree;
--
PROCEDURE check_docs(pi_id         IN  Varchar2
                    ,pi_table_name IN  Varchar2
                    ,po_table_name Out Varchar2
                    ,po_doc_cnt    Out Number)
--
IS 
-- 
   l_table_name Varchar2(50);
   l_cnt        Number ;
--
BEGIN
--
   Execute Immediate 'SELECT Count(0)  '||
                     'FROM   doc_assocs '||
                     'WHERE  das_rec_id = :1 '||
                     'AND    hig_nav.check_enquiry(das_doc_id )!= 1 '||
                     'AND    das_table_name = :2 ' INTO l_cnt Using pi_id,pi_table_name ;

   IF l_cnt > 0
   THEN
       po_table_name := pi_table_name ;    
       po_doc_cnt    := l_cnt;
   ELSE
       BEGIN  
       --
          Execute Immediate ' SELECT DGS_DGT_TABLE_NAME '||
                            ' FROM   DOC_GATE_SYNS      '||
                            ' WHERE  DGS_TABLE_SYN = :1 ' INTO l_table_name Using pi_table_name;
       EXCEPTION
           WHEN  NO_DATA_FOUND
           THEN
               Null;
       END ;
       IF l_table_name IS NOT NULL
       THEN
           Execute Immediate 'SELECT Count(0)  '||
                             'FROM   doc_assocs '||
                             'WHERE  das_rec_id = :1 '||
                             'AND    hig_nav.check_enquiry(das_doc_id )!= 1 '||
                             'AND    das_table_name = :2 ' INTO l_cnt Using pi_id,l_table_name ;
           IF l_cnt > 0
           THEN
               po_table_name := l_table_name ;    
               po_doc_cnt    := l_cnt;
           END IF ;
       END IF ;
   END IF ;
--         
END check_docs;
--
FUNCTION get_hnm_rec(pi_module hig_navigator_modules.hnm_module_name%TYPE ) 
RETURN hig_navigator_modules%ROWTYPE
IS
--
   CURSOR c_get_hnm
   IS
   SELECT *
   FROM   hig_navigator_modules
   WHERE  Upper(hnm_module_name) = pi_module ;
   l_rec  hig_navigator_modules%ROWTYPE;
--
BEGIN
--
   OPEN  c_get_hnm;
   FETCH c_get_hnm INTO l_rec;
   CLOSE c_get_hnm;

   RETURN l_rec ;
--
END get_hnm_rec;
--
FUNCTION get_hnm_for_column(pi_module      IN hig_navigator_modules.hnm_module_name%TYPE 
                           ,pi_column_name IN Varchar2 ) 
RETURN hig_navigator_modules%ROWTYPE
IS
--
   CURSOR c_get_hnm
   IS
   SELECT *
   FROM   hig_navigator_modules
   WHERE  Upper(hnm_module_name) = pi_module 
   AND    Upper(hnm_field_name) = Upper(pi_column_name) ;
   l_rec  hig_navigator_modules%ROWTYPE;
--
BEGIN
--
   OPEN  c_get_hnm;
   FETCH c_get_hnm INTO l_rec;
   CLOSE c_get_hnm;

   RETURN l_rec ;
--
END get_hnm_for_column;
--
FUNCTION validate_sql(pi_sql IN Varchar2) 
RETURN varchar2
IS
--
   l_count Number ;
--
BEGIN
--
   Execute Immediate 'SELECT Count(0) FROM ('||pi_sql||')' INTO l_count ;   
   Return '0' ;
   
EXCEPTION
   WHEN OTHERS THEN
   Return Sqlerrm ;
--
END validate_sql;
--    
FUNCTION return_number(pi_das_rec_id IN Varchar2)  
RETURN Number
IS
--
   l_num Number ;
--
BEGIN
--
   l_num := pi_das_rec_id ;
   Return l_num;
--
EXCEPTION 
    WHEN OTHERS
    THEN
        Return -1;
END return_number;      
--
FUNCTION get_tma_works_ref(pi_works_id IN Number)  
RETURN Varchar2
IS
--
   l_value Varchar2(2000);
--
BEGIN
--
   IF pi_works_id IS NOT NULL
   THEN
       EXECUTE IMMEDIATE ' SELECT TWOR_WORKS_REF '||
                         ' FROM   tma_works '||
                         ' WHERE  twor_works_id = :1 ' INTO l_value  USING pi_works_id ;    
   END IF ;
   RETURN l_value ;
--
EXCEPTION
   WHEN OTHERS
   THEN 
       RETURN l_value ;
--
END get_tma_works_ref;
--
FUNCTION get_hig_code_meaning (pi_hco_domain IN hig_codes.hco_domain%TYPE
                              ,pi_hco_value  IN hig_codes.hco_code%TYPE)
Return Varchar2
IS
--
   l_meaning hig_codes.hco_meaning%TYPE;
--
BEGIN
--
   IF   pi_hco_domain IS NOT NULL
   AND  pi_hco_value IS NOT NULL
   THEN
       SELECT hco_meaning INTO l_meaning 
       FROM   hig_codes
       WHERE  hco_domain = pi_hco_domain
       AND    hco_code  = pi_hco_value ;   
   END IF ;
   Return l_meaning ;
--
EXCEPTION
   WHEN OTHERS
   THEN 
       RETURN l_meaning ;
--
END ;
--
FUNCTION check_enquiry(pi_doc_id Number)
Return Varchar2
IS
--
   l_value Number ;
   Type l_ref IS REF CURSOR;
   lref l_ref;
--
BEGIN
--
   IF pi_doc_ID IS NOT NULL
   THEN       
       /*EXECUTE IMMEDIATE ' SELECT count(0) '||
                         ' FROM   docs,doc_types '||
                         ' WHERE  doc_id = :1 '||
                         ' AND    doc_dtp_code = dtp_code '||
                         ' AND    dtp_allow_complaints = ''Y''' INTO l_value Using pi_doc_id;
       */
       OPEN lref FOR ' SELECT count(0) '||
                     ' FROM   docs '||
                     '       ,doc_types '||
                     ' WHERE  doc_id = :1 '||
                     ' AND    doc_dtp_code = dtp_code '||
                     ' AND    dtp_allow_complaints = ''Y''' Using pi_doc_id;

       FETCH lref INTO l_value;
       CLOSE lref;
       IF l_value > 0
       THEN
           Return 1;
       ELSE
           Return 0;
       END IF ;
   ELSE
       Return 0 ;
   END IF ;        
--
EXCEPTION
   WHEN OTHERS
   THEN 
       RETURN  0;
--
END check_enquiry;
--
FUNCTION is_enquiry(pi_doc_dtp_code Varchar2)
Return Varchar2
IS
--
   l_value Number ;
--
BEGIN
--
   IF pi_doc_dtp_code IS NOT NULL
   THEN  
       EXECUTE IMMEDIATE ' SELECT count(0) '||
                         ' FROM   doc_types '||
                         ' WHERE  dtp_code = :1 '||
                         ' AND    dtp_allow_complaints = ''Y''' INTO l_value  USING pi_doc_dtp_code;
   END IF ;
   IF l_value > 0 
   THEN
       Return 1;
   ELSE
       Return 0 ;
   END IF ;        
EXCEPTION
   WHEN OTHERS
   THEN 
       RETURN  0;
--
END is_enquiry;
--
FUNCTION get_budget_descr(pi_bud_sys_flag              Varchar2
                         ,pi_bud_icb_item_code         Varchar2
                         ,pi_bud_icb_sub_item_code     Varchar2
                         ,pi_bud_icb_sub_sub_item_code Varchar2
                         ,pi_bud_agency                Varchar2)
Return Varchar2
IS
--
   l_value Varchar2(2000);
--
BEGIN
-- 
   EXECUTE IMMEDIATE ' SELECT icb_work_category_name '||
                     ' FROM   item_code_breakdowns '||
                     ' WHERE  icb_dtp_flag = :1 '||
                     ' AND    icb_item_code = :2 '||
                     ' AND    icb_sub_item_code = :3 '||
                     ' AND    icb_sub_sub_item_code = :4 '||
                     ' AND    decode(hig.get_sysopt(''ICBFGAC''),''Y'',icb_agency_code,pi_bud_agency) = :5' INTO l_value USING pi_bud_sys_flag,pi_bud_icb_item_code,pi_bud_icb_sub_item_code,pi_bud_icb_sub_sub_item_code,pi_bud_agency ;
   Return l_value ;
EXCEPTION
   WHEN OTHERS
   THEN 
       RETURN l_value ;
--
END get_budget_descr;
--
FUNCTION get_doc_status_code(pi_doc_id Number)
Return Varchar2
IS
--
   l_value Varchar2(2000);
--
BEGIN
--
   IF pi_doc_id IS NOT NULL
   THEN
       Execute immediate ' SELECT doc_status_code '||       
                         ' FROM   docs '||
                         ' WHERE  doc_id  = :1 ' INTO l_value Using pi_doc_id ;    
   END IF ;
   Return l_value ;
--
EXCEPTION
   WHEN OTHERS
   THEN 
       RETURN l_value ;
--
END get_doc_status_code;
--
FUNCTION get_doc_dtp_code(pi_doc_id Number)
Return Varchar2
IS
--
   l_value Varchar2(2000);
--
BEGIN
--
   IF pi_doc_id IS NOT NULL
   THEN
       Execute IMMEDIATE ' SELECT doc_dtp_code  '||      
                         ' FROM   docs '||
                         ' WHERE  doc_id  = :1 ' INTO l_value Using pi_doc_id;    
   END IF ;
   Return l_value ;
--
EXCEPTION
   WHEN OTHERS
   THEN 
       RETURN l_value ;
--
END get_doc_dtp_code;
--
FUNCTION get_doc_dcl_code(pi_doc_id Number)
Return Varchar2
IS
l_value Varchar2(2000);
BEGIN
--
   IF pi_doc_id IS NOT NULL
   THEN
       Execute Immediate ' SELECT doc_dcl_code '||        
                         ' FROM   docs '||
                         ' WHERE  doc_id  = :1 ' INTO   l_value Using pi_doc_id;    
   END IF ;
   Return l_value ;
--
EXCEPTION
   WHEN OTHERS
   THEN 
       RETURN l_value ;
--
END get_doc_dcl_code;
--
Function get_asset_descr(pi_inv_type nm_inv_types.nit_inv_type%TYPE)
Return Varchar2
IS
BEGIN
--
   IF pi_inv_type IS NOT NULL
   THEN
       Return nm3get.get_nit(pi_inv_type).nit_descr ;
   ELSE
       Return Null; 
   END IF ;
--
END get_asset_descr ;
--
Function get_road_descr(pi_road_id nm_elements.ne_id%TYPE)
Return Varchar2
IS
BEGIN
--
   IF pi_road_id IS NOT NULL
   THEN
       Return nm3get.get_ne_all(pi_road_id,False).ne_descr;
   ELSE
       Return Null;
   END IF ;
--
END get_road_descr;
--
Function get_contract_det(pi_con_id Number)
Return Varchar2
IS
--
   l_value Varchar2(4000);
--
BEGIN
--
   IF pi_con_id IS NOT NULL
   THEN   
       Execute immediate ' SELECT con_code||'' ;''||con_name||'' ;''||oun_unit_code||'' ;''||oun_name '||        
                         ' FROM   contracts,org_units '||
                         ' WHERE  con_id = :1 '||
                         ' AND    con_contr_org_id    = oun_org_id' INTO   l_value Using pi_con_id ;
   END IF ;
   Return l_value ;
EXCEPTION
   WHEN OTHERS
   THEN 
       RETURN l_value ;
--
END get_contract_det;
--
FUNCTION get_doc_compl_type(pi_doc_id Number)
Return Varchar2
IS
--
   l_value Varchar2(2000);
--
BEGIN
--
   IF pi_doc_id IS NOT NULL
   THEN
       Execute Immediate ' SELECT doc_compl_type '||       
                         ' FROM   docs  '||
                         ' WHERE  doc_id  = :1' INTO   l_value Using pi_doc_id ;    
   END IF ;
   Return l_value ;
EXCEPTION
   WHEN OTHERS
   THEN 
       RETURN l_value ;
--
END get_doc_compl_type;
--
FUNCTION get_hig_user_initials(pi_user_id hig_users.hus_user_id%TYPE)
Return Varchar2
IS
BEGIN
--
   IF pi_user_id IS NOT NULL
   THEN
       RETURN nm3get.get_hus(pi_user_id,False).hus_initials;
   ELSE
       RETURN Null ;
   END IF ;
--
END get_hig_user_initials;
--
FUNCTION get_bud_balance(pi_value Number,pi_committed Number,pi_actual Number)
Return Varchar2
IS
--
   l_value Number ;
--
BEGIN
--
   IF pi_value = -1 
   THEN
       l_value := 0 - Nvl(pi_committed,0) - Nvl(pi_actual,0);
   ELSE
       l_value := Nvl(pi_value,0) - Nvl(pi_committed,0) - Nvl(pi_actual,0);
   END IF ;
   Return l_value ;
EXCEPTION
   WHEN OTHERS
   THEN 
       RETURN l_value ;
--
END get_bud_balance;
--
FUNCTION get_doc_descr(pi_doc_id Number)
Return Varchar2
IS
--
   l_value Varchar2(2000);
--
BEGIN
--
   IF pi_doc_id IS NOT NULL
   THEN
       Execute Immediate ' SELECT doc_descr  '||       
                         ' FROM   docs '||
                         ' WHERE  doc_id  = :1' INTO   l_value Using pi_doc_id;    
   END IF ;
   Return l_value ;
EXCEPTION
   WHEN OTHERS
   THEN 
       RETURN l_value ;
--
END get_doc_descr;
--
FUNCTION get_doc_compl_location(pi_doc_id Number)
Return Varchar2
IS
--
   l_value Varchar2(2000);
--
BEGIN
--
   IF pi_doc_id IS NOT NULL
   THEN
       Execute Immediate ' SELECT doc_compl_location  '||        
                         ' FROM   docs '||
                         ' WHERE  doc_id  = :1 'INTO   l_value Using pi_doc_id;    
   END IF ;
   Return l_value ;
EXCEPTION
   WHEN OTHERS
   THEN 
       RETURN l_value ;
--
END get_doc_compl_location;
--
FUNCTION concate_label(pi_value IN Varchar2)
Return Varchar2
IS
--
   l_value Varchar2(4000);
--
BEGIN
--
   IF pi_value IS NOT NULL 
   THEN
       l_value :=  ' ;'||pi_value;
   END IF ;
   Return l_value ;
EXCEPTION
   WHEN OTHERS
   THEN 
       RETURN l_value ;
--
END concate_label;
--
PROCEDURE remove_return_id(pi_value IN Varchar2)
IS
BEGIN
--
   FOR i IN 1..return_id_tab.count
   LOOP
       BEGIN
       --
          IF return_id_tab(i) = pi_value 
          THEN
              return_id_tab.Delete(i);
          END IF ; 
       --
       EXCEPTION
          WHEN OTHERS THEN
              Null ;       
       END ;
   END LOOP;
--
EXCEPTION
   WHEN OTHERS THEN
       Null ;
--
END remove_return_id;
--
FUNCTION get_return_Id_tab 
RETURN nav_id
IS
--
BEGIN
--
   RETURN hig_nav.return_id_tab;
--
END get_return_id_tab;
--
PROCEDURE populate_return_id_tab (pi_id Varchar2)
IS
--
BEGIN
--
   return_id_tab.extend;
   return_id_tab(return_id_tab.count) := pi_id;
--
END populate_return_id_tab;
--
PROCEDURE ini_return_id_tab
IS
--
BEGIN
--
   return_id_tab.delete;
--
END ini_return_id_tab;
--
FUNCTION get_ita_meaning(p_inv_type  IN  Varchar2
                        ,p_attribute IN  Varchar2
                        ,p_value     IN  Varchar2
                        ) 
Return Varchar2
IS
--
   e_match_col_not_in_query EXCEPTION;
   TYPE typ_cs_sql IS REF CURSOR; -- define weak REF CURSOR type
   cs_sql typ_cs_sql; -- declare cursor variable
   v_statement varchar2(4000) ;
   l_statement_b4_where_added varchar2(2000);	
   l_group_by_pos pls_integer;
   l_group_by     nm3type.max_varchar2;
   l_order_by_pos pls_integer;
   l_order_by     nm3type.max_varchar2;
   l_equal_test   nm3type.max_varchar2;
   v_value varchar2(2000);
   v_meaning varchar2(2000) ;
   v_id varchar2(2000) ;
   l_found_records boolean ;
   l_cols_tab nm3type.tab_varchar30;
   l_statement_has_where boolean ;
   g_flex_validation_exc_code number;
   g_flex_validation_exc_msg varchar2(2000);
   g_flex_validation_exception EXCEPTION;
   pi_match_col Number :=  3;
   l_ita_rec nm_inv_type_attribs%ROWTYPE;
--
BEGIN
   l_ita_rec := nm3get.get_ita(pi_ita_inv_type    => p_inv_type
                              ,pi_ita_attrib_name => p_attribute);   
   v_statement := l_ita_rec.ita_query ;
   IF  l_ita_rec.ita_query IS NOT NULL
   AND p_value IS NOT NULL
   THEN     
       -- TASK 0109336
       -- Added following code to avoid error column ambiguously defined when same column is repeated in the SQL statement 
	 DECLARE
	 --	
         l_sql Varchar2(4000) := Upper(l_ita_rec.ita_query);
         l_ori_sql Varchar2(4000) := l_sql ;
         TYPE col IS TABLE OF Varchar(100) INDEX BY BINARY_INTEGER;
         l_col_tab col;       
         l_cnt number := 0 ;
         l_alias Varchar2(500) ;
         l_pos Number;
         l_cols_tab nm3type.tab_varchar30; 
       --   
	 BEGIN
	 --	 
          l_sql := Substr(l_sql,8,Instr(l_sql,'FROM')-(1+8));
          LOOP
             l_cnt := l_cnt + 1;
             l_pos := Instr(l_sql,',');
             IF l_pos > 0 
             THEN        
                 l_alias  := Ltrim(substr(l_sql, 1,l_pos-1))||' ' ;
                 IF Nvl(Length(Replace(Substr(l_alias,(Instr(l_alias,' '))),' ')),0) > 0
                 THEN             
                     l_col_tab(l_cnt) :=  l_alias ; 
                 ELSE
                     IF l_cnt = 1 
                     THEN
                         l_col_tab(l_cnt) := Substr(l_sql, 1,l_pos-1)||' Identifier ';
                     ELSIF l_cnt = 2 
                     THEN 
                         l_col_tab(l_cnt) :=  Substr(l_sql, 1,l_pos-1)||' Description ';
                     ELSE
                         l_col_tab(l_cnt) :=  Substr(l_sql, 1,l_pos-1)||' Value ';
                     END IF ;
                 END IF ;    
                 l_sql := Substr(l_sql,l_pos+1);
             ELSE
                 l_alias  := Ltrim(l_sql);
                 IF Nvl(Length(Replace(Substr(l_alias,(Instr(l_alias,' '))),' ')),0) > 0
                 THEN             
                     l_col_tab(l_cnt) :=  l_alias ;--Substr(l_alias,(Instr(l_alias,' ')));
                 ELSE
                     IF l_cnt = 1 
                     THEN
                         l_col_tab(l_cnt) :=  l_sql||' Identifier ';
                     ELSIF l_cnt = 2 
                     THEN
                         l_col_tab(l_cnt) :=  l_sql||' Description ';
                     ELSE
                        l_col_tab(l_cnt) :=  l_sql||' Value ';
                     END IF ;               
                 END IF  ;
                 Exit;     
             END IF ;
          END LOOP ;
          l_sql:= 'SELECT ';
          FOR i in 1..l_col_tab.count 
          LOOP
              IF i = 1 
              THEN
                  l_sql := l_sql ||l_col_tab(i);
              ELSIF i = 2 
              THEN 
                  l_sql := l_sql ||' ,'||l_col_tab(i);
              ELSE
                  l_sql := l_sql ||' ,'||l_col_tab(i);
              END IF;
          END LOOP;
          v_statement := l_sql ||' '||Substr(l_ori_sql,Instr(Upper(l_ori_sql),'FROM'));
          l_sql := 'SELECT';
     	    --get and add columns to query
    	    l_cols_tab := nm3flx.get_cols_from_sql(p_sql => v_statement);
          FOR l_i IN 1..l_cols_tab.COUNT
	    LOOP
	        l_sql := l_sql 
	  	 	           || Chr(10) || '  ' || l_cols_tab(l_i) || ',';
	    END LOOP;
          v_statement := Substr(l_sql, 1, Length(l_sql) - 1)|| Chr(10) || ' FROM'
	 		         || Chr(10) || '  (' || v_statement  || ')' ;  
       END ;
       -- END TASK TASK 0109336
       l_cols_tab := nm3flx.get_cols_from_sql(p_sql => v_statement);
       IF NOT(l_cols_tab.EXISTS(pi_match_col))
       THEN
           RAISE e_match_col_not_in_query;
        END IF;
        --does statement contain a group by clause?
        l_group_by_pos := INSTR(UPPER(v_statement), 'GROUP BY');
        IF l_group_by_pos > 0
        THEN
            --strip group by
            l_group_by := SUBSTR(v_statement, l_group_by_pos);
            v_statement := SUBSTR(v_statement, 1, LENGTH(v_statement) - LENGTH(l_group_by));
        END IF;
        l_order_by_pos := INSTR(UPPER(v_statement), 'ORDER BY');
        IF l_order_by_pos > 0
        THEN
            l_order_by := SUBSTR(v_statement, l_order_by_pos);
            v_statement := SUBSTR(v_statement, 1, LENGTH(v_statement) - LENGTH(l_order_by));
        END IF;
        IF INSTR(v_statement,'1 =:x') > 0
        THEN
            v_statement := REPLACE(v_statement , '1 =:x', '1 =1');
        END IF;	  
        l_statement_b4_where_added := v_statement;
        l_statement_has_where := INSTR(UPPER(v_statement), 'WHERE') > 0 ;
        l_equal_test := l_cols_tab(pi_match_col) || ' = :1' ;
        IF l_statement_has_where
        THEN
            v_statement := v_statement || ' AND ' || l_equal_test ;
        ELSE
            v_statement := v_statement || ' WHERE ' || l_equal_test ;
        END IF;
        IF NOT nm3flx.is_select_statement_valid(v_statement) and l_statement_has_where THEN
            v_statement := l_statement_b4_where_added || ' WHERE ' || l_equal_test ;
        END IF;
        v_statement := v_statement|| ' ' || l_group_by;
        BEGIN
           -- Changed to use bind variable, less parsing hopefully
           OPEN cs_sql FOR v_statement USING p_value ; 
           FETCH cs_sql INTO v_value ,v_meaning,v_id ;
           l_found_records := cs_sql%found ;
        CLOSE cs_sql;
      EXCEPTION
        WHEN others
        THEN
            hig.raise_ner(pi_appl               => 'HIG'
                         ,pi_id                 => 83
                         ,pi_supplementary_info => chr(10)||v_statement);
      END;

      --IF not l_found_records
      --THEN
      --    g_flex_validation_exc_code := -20699;
      --    g_flex_validation_exc_msg := SQLERRM || ' - ' || v_statement;
      --    RAISE g_flex_validation_exception;
      --END IF;

      Return  v_meaning;
    ELSE
      Return NULL;
    END IF;
--
  EXCEPTION
    WHEN e_match_col_not_in_query
    THEN
      hig.raise_ner(pi_appl               => nm3type.c_net
                   ,pi_id                 => 28
                   ,pi_supplementary_info => 'match_col_not_in_query (' || pi_match_col || ')');

    WHEN g_flex_validation_exception
    THEN
      Raise_Application_Error(g_flex_validation_exc_code
                             ,g_flex_validation_exc_msg
                                     ||':'||l_ita_rec.ita_query
                                     ||':'||p_value);

END get_ita_meaning;
--
FUNCTION check_query_used(pi_hqt_id hig_query_types.hqt_id%TYPE)
Return Boolean
IS
--
   l_cnt Number ;
--
BEGIN
--
   SELECT Count(0)
   INTO   l_cnt 
   FROM   hig_alert_types
   WHERE  halt_hqt_id  = pi_hqt_id;

   Return Nvl(l_cnt,0) > 0;
--
END check_query_used;
--
Function tma_notice_details(pi_tma_works_id Number)
Return Varchar2
IS
--
   l_value Varchar2(4000);
--
BEGIN
--
   IF pi_tma_works_id IS NOT NULL
   THEN   
       Execute immediate ' SELECT descr FROM (SELECT tnot_works_ref||'' ;''||twca_description||'' ;''||hco_meaning||'' ;''||ne_descr||'' ;''||tphs_loc_description descr'|| 
                         ' FROM   tma_notices '||
                         '        ,tma_works '||
                         '        ,tma_phases '||
                         '        ,tma_works_categories '||
                         '        ,hig_codes '||
                         '        ,nm_elements  '||
                         ' WHERE  tnot_works_id       = twor_works_id '||
                         ' AND    tnot_works_id       = tphs_works_id '||
                         ' AND    tnot_phase_no       = tphs_phase_no '||
                         ' AND    tphs_works_category = twca_works_category '||
                         ' AND    hco_domain          = ''NOTICE_STATUS'' '||
                         ' AND    hco_code            = tnot_notice_status '||
                         ' AND    twor_str_ne_id      = ne_id '||
                         ' AND    tnot_works_id = :1 '||
                         ' ORDER BY tnot_notice_id desc) '||
                         ' WHERE Rownum = 1 ' INTO   l_value Using pi_tma_works_id ;
   END IF ;
   Return l_value ;
EXCEPTION
   WHEN OTHERS
   THEN 
       RETURN l_value ;
--
END tma_notice_details;
--
FUNCTION get_wor_flag(pi_label IN Varchar2
                     ,pi_value IN Varchar2)
Return Varchar2
--
IS
   l_value Varchar2(10);
BEGIN
--
   IF pi_label = 'WORK ORDER'
   THEN
       Execute Immediate ' SELECT wor_flag '||
	                   ' FROM   work_orders '||
	                   ' WHERE  wor_works_order_no = :1' INTO l_value Using pi_value ;
   ELSE
       Execute Immediate ' SELECT wor_flag	'||
	                   ' FROM   work_orders   '||
	                   ' WHERE  wor_works_order_no = (SELECT wol_works_order_no FROM work_order_lines WHERE wol_id = :1)' INTO l_value Using pi_value;
   END IF ;
   Return l_value ;
--
EXCEPTION When Others
THEN
    Return Null;
--
END get_wor_flag;
--
FUNCTION build_child_sql(pi_start_alias IN Varchar2
                        ,pi_end_alias   IN Varchar2
                        ,pi_id          IN VARCHAR2)
Return Varchar2
IS
--
   l_sql       Varchar2(32767) ;
   l_tab_join  Varchar2(1000);
   l_col_join  Varchar2(1000);
   l_label     Varchar2(32767) ;
   cnt         number := 0 ;
   TYPE l_ref  IS REF CURSOR;
   tab_cnt     Number := 0 ;
   l_r         l_ref;
   l_type      hig_navigator_type := hig_navigator_type(Null,Null,Null,null,Null,Null);
   l_top       Varchar2(100) ;
   p_id        Varchar2(100);
   where_col   Varchar2(100);
   top_alias   Varchar2(100);
   l_add_con   Varchar2(4000) ;
   l_and_where Varchar2(20);
   l_select    Varchar2(1000);
   l_nav_rec   nav%ROWTYPE;
--
BEGIN
--
   SELECT UPPER(hnv_child_id),upper(hnv_child_alias) 
   INTO   where_col,top_alias                
   FROM   hig_navigator b 
   WHERE  hnv_child_alias = pi_end_alias
   AND    hnv_hierarchy_type = l_hir_type;
   nm3ctx.set_context('NAV_VAR2',pi_id);
   FOR i IN (SELECT  *  
             FROM    hig_navigator
             CONNECT BY  hnv_child_alias = PRIOR hnv_parent_alias
             START WITH hnv_child_alias = pi_start_alias
             ORDER BY LEVEL)
   LOOP
       cnt := cnt + 1;
       IF cnt = 1
       THEN
           l_tab_join := i.hnv_child_table      ;
           l_nav_rec  := i ;
       ELSE      
           l_tab_join := l_tab_join||chr(10)||','||i.hnv_child_table      ;
       END IF ; 
       IF i.hnv_child_alias != pi_end_alias
       THEN
           IF i.hnv_parent_column is not null
           THEN
               IF l_col_join is null 
               THEN
                   l_col_join := 'WHERE '||i.hnv_parent_column ||' = '||i.hnv_child_column;
               ELSE
                   l_col_join := l_col_join||chr(10)||'AND '||i.hnv_parent_column ||' = '||i.hnv_child_column;
               END IF ;        
           END IF ;        
       END IF ; 
       IF i.hnv_additional_cond IS NOT NULL
       THEN
           l_add_con := 'AND '|| i.hnv_additional_cond; 
       END IF ;
       IF Nvl(l_col_join,'$')  != '$'
       THEN 
           l_and_where := ' AND ';
       ELSE  
           l_and_where := ' WHERE ';
       END IF ;         
       IF i.hnv_child_alias = pi_end_alias
       THEN
           Exit;
       END IF ;  
   END LOOP;   
   l_label := Chr(10)||Nvl(l_nav_rec.hnv_hier_label_1,'Null')||'||'||Nvl(l_nav_rec.hnv_hier_label_2,'Null')||'||'||Nvl(l_nav_rec.hnv_hier_label_3,'Null')||'||'||
              Nvl(l_nav_rec.hnv_hier_label_4,'Null')||'||'||Nvl(l_nav_rec.hnv_hier_label_5,'Null')||'||'||Nvl(l_nav_rec.hnv_hier_label_6,'Null')||'||'||
              Nvl(l_nav_rec.hnv_hier_label_7,'Null')||'||'||Nvl(l_nav_rec.hnv_hier_label_8,'Null')||'||'||Nvl(l_nav_rec.hnv_hier_label_9,'Null')||'||'||Nvl(l_nav_rec.hnv_hier_label_10,'Null');

   l_select := 'SELECT ' ;
   IF l_nav_rec.hnv_parent_id IS NULL
   THEN
       l_nav_rec.hnv_parent_id := -1;
   END IF ;
   l_sql := l_select||' '||l_nav_rec.hnv_child_id||','''||l_nav_rec.hnv_hierarchy_label||' -  ''||                                                                                 '||
            l_label||','||chr(39)||
            l_nav_rec.hnv_icon_name||chr(39) ||' col_icon'||','||l_nav_rec.hnv_hierarchy_level|| ' col_level, '||
            l_nav_rec.hnv_parent_id||'||'||chr(39)||l_nav_rec.hnv_parent_alias||chr(39)||' par,'||l_nav_rec.hnv_child_id||'||'||CHR(39)||l_nav_rec.hnv_child_alias||CHR(39)||' chi '||Chr(10)||
            'FROM '|| l_tab_join||' '||l_col_join||chr(10)||l_and_where||where_col||'= sys_context(''NM3SQL'',''NAV_VAR2'') '||l_nav_rec.hnv_additional_cond;
   RETURN l_sql ;  
--
END build_child_sql;
--
PROCEDURE get_top_par(pi_id    IN Varchar2
                     ,pi_alias IN Varchar2)
IS
--
   l_sql       Varchar2(32767) ;
   l_tab_join  Varchar2(1000);
   l_col_join  Varchar2(1000);
   cnt         number := 0 ;
   TYPE l_ref is REF CURSOR;
   l_r l_ref;
   l_type hig_navigator_type := hig_navigator_type(Null,Null,Null,null,Null,Null);
   where_col Varchar2(100);
   l_add_con Varchar2(4000) ;
   l_and_where Varchar2(20);
   l_select    Varchar2(1000);
   l_parent_col Varchar2(30);
--

BEGIN
--
   SELECT UPPER(hnv_child_id)
   INTO   where_col
   FROM   hig_navigator b 
   WHERE  hnv_child_alias = pi_alias
   AND    hnv_hierarchy_type = l_hir_type;
   nm3ctx.set_context('NAV_VAR2',pi_id);
   FOR i IN (SELECT  *  
             FROM    hig_navigator
             CONNECT BY  hnv_child_alias = PRIOR hnv_parent_alias
             START WITH hnv_child_alias = pi_alias
             ORDER BY LEVEL DESC)
   LOOP
       cnt := cnt + 1;
       IF cnt = 1
       THEN
           l_tab_join := i.hnv_child_table      ;
           l_parent_col := i.hnv_child_column  ;
       ELSE      
           l_tab_join := l_tab_join||chr(10)||','||i.hnv_child_table      ;
       END IF ; 
       IF i.hnv_parent_column is not null
       THEN
           IF l_col_join is null 
           THEN
               l_col_join := 'WHERE '||i.hnv_parent_column ||' = '||i.hnv_child_column;
           ELSE
               l_col_join := l_col_join||chr(10)||'AND '||i.hnv_parent_column ||' = '||i.hnv_child_column;
           END IF ;        
       END IF ;  
       IF i.hnv_additional_cond IS NOT NULL
       THEN
           l_add_con :=  i.hnv_additional_cond; 
       END IF ;
       IF Nvl(l_col_join,'$')  != '$'
       THEN 
           l_and_where := ' AND ';
       ELSE  
           l_and_where := ' WHERE ';
       END IF ;         
   END LOOP;   
   l_select := 'SELECT '|| l_parent_col ;
   l_sql := l_select||Chr(10)||'FROM '|| l_tab_join||' '||l_col_join||chr(10)||l_and_where||where_col||'= sys_context(''NM3SQL'',''NAV_VAR2'') '||l_add_con;
--nm_debug.debug(l_sql);
   OPEN l_r for l_sql;
   LOOP
       l_top_id.extend ;
       FETCH l_r into l_top_id(l_top_id.Count) ;
       EXIT WHEN l_r%NOTFOUND;
   END LOOP;
--
END get_top_par;     
--
END hig_nav;
/

