CREATE OR REPLACE PACKAGE BODY nm3_bulk_attrib_upd
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3_bulk_attrib_upd.pkb-arc   3.7   Sep 15 2009 16:18:18   lsorathia  $
--       Module Name      : $Workfile:   nm3_bulk_attrib_upd.pkb  $
--       Date into PVCS   : $Date:   Sep 15 2009 16:18:18  $
--       Date fetched Out : $Modtime:   Sep 15 2009 16:17:44  $
--       Version          : $Revision:   3.7  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   3.7  $';

  g_package_name CONSTANT varchar2(30) := 'nm3_bulk_attrib_upd';
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
FUNCTION get_ne_array (pi_ne_array nm_ne_id_array)
RETURN   nm_ne_id_array 
IS
BEGIN
--
   RETURN pi_ne_array ;
--
END get_ne_array ;
--
FUNCTION get_grp_ne_array (pi_grp_ne_array nm_ne_id_array)
RETURN   nm_ne_id_array 
IS
BEGIN
--
   RETURN pi_grp_ne_array ;
--
END get_grp_ne_array ;
--
PROCEDURE upd_attrib(pi_ne_id_array  IN nm_ne_id_array
                    ,pi_attrib_array IN l_attrib_array) 
IS 
--   
   TYPE l_ne_array    IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
   TYPE l_ne_old_tab_type IS TABLE OF VARCHAR(1000) INDEX BY BINARY_INTEGER ;
   TYPE l_nm_table    IS TABLE OF NM_MEMBERS%ROWTYPE INDEX BY BINARY_INTEGER;
   l_ne_tab           l_ne_array;
   l_sql_el_attrib    VARCHAR(32767);
   l_sql_inv_attrib   VARCHAR(32767);
   l_rec              l_attrib_rec ;
   l_nt_type          nm_nw_ad_types.nad_nt_type%TYPE ;
   l_gty_type         nm_nw_ad_types.nad_gty_type%TYPE ;
   l_par_inc          Varchar2(1);
   l_chi_inc          Varchar2(1);
   l_auto_inc         Varchar2(1);
   l_nm_tab           l_nm_table ;
   l_child_col_name   nm_type_inclusion.nti_child_column%TYPE ;
   l_parent_col_name  nm_type_inclusion.nti_child_column%TYPE ;
   l_child_col_value  Varchar2(4000) ;
   l_ne_old_tab       l_ne_old_tab_type ;  
   l_nti_rec          nm_type_inclusion%ROWTYPE ; 
   l_parent_rec       nm_elements%ROWTYPE ;  
   l_child_gty_type   nm_group_types.ngt_group_type%TYPE;
--
   CURSOR   c_nad (qp_nt_type  nm_nw_ad_types.nad_nt_type%TYPE
                  ,qp_qty_type nm_nw_ad_types.nad_gty_type%TYPE) IS
   SELECT  * 
   FROM    nm_nw_ad_types
   WHERE   nad_nt_type     = qp_nt_type
   AND     Nvl(nad_gty_type,'$$')  = NVl(qp_qty_type,Nvl(nad_gty_type,'$$'))
   AND     nad_primary_ad  = 'Y' ;
   l_nad_rec c_nad%ROWTYPE ; 
 
   CURSOR get_parent_gty (qp_nt_type    nm_types.nt_type%TYPE)
   IS
   SELECT g.*
   FROM   nm_group_types g, nm_group_relations 
   WHERE  ngt_nt_type           = qp_nt_type
   AND    ngr_parent_group_type = ngt_group_type
   AND    ngr_child_group_type  = l_child_gty_type;
   l_gty_rec get_parent_gty%ROWTYPE ;
--
BEGIN
--
   BEGIN
   --
      SELECT x.ne_id  BULK COLLECT 
             INTO l_ne_tab 
      FROM   table(cast(nm3_bulk_attrib_upd.get_ne_array(pi_ne_id_array) as nm_ne_id_array)) x ;   

      SELECT ne.ne_gty_group_type  
             INTO l_child_gty_type
      FROM   table(cast(nm3_bulk_attrib_upd.get_ne_array(pi_ne_id_array) as nm_ne_id_array)) x
             ,nm_elements ne
      WHERE  ne.ne_id = x.ne_id
      AND    Rownum   = 1 ;
   --
   EXCEPTION
       WHEN OTHERS THEN 
       Null;
   -- 
   END ;
   Forall i in 1..l_ne_tab.Count
   Execute Immediate 'Begin nm3lock.lock_element_and_members(:1,TRUE); End ; ' Using l_ne_tab(i);
   IF pi_attrib_array.Count > 0 
   THEN
       FOR i IN 1..pi_attrib_array.Count
       LOOP
           l_nt_type :=  l_rec.nav_nt_type ;
           l_gty_type :=  l_rec.nav_gty_type ;
           l_rec := pi_attrib_array(i) ;
           IF  l_rec.nav_disp_ord = 1
           AND l_rec.nav_col_updatable = 'Y'
           THEN
               IF l_rec.nav_parent_type_inc = 'Y'
               THEN
                   l_par_inc         := 'Y' ;
                   l_child_col_name  := l_rec.nav_child_col ;
                   l_child_col_value := l_rec.nav_value ;  
                   l_parent_col_name := l_rec.nav_col_name ;
               ELSIF l_rec.nav_child_type_inc = 'Y'
               THEN
                   l_chi_inc := 'Y';
                   l_child_col_name  := l_rec.nav_col_name ;
                   --l_parent_col_name := l_rec.nav_parent_col ;
                   l_child_col_value := l_rec.nav_value ;  
                   l_nti_rec := nm3get.get_nti(pi_nti_nw_child_type => l_rec.nav_nt_type,
                                               pi_nti_child_column  => l_rec.nav_col_name,
                                               pi_raise_not_found   => FALSE);
               END IF ;
               IF l_sql_el_attrib IS NULL
               THEN  
                   l_sql_el_attrib := 'SET '||l_rec.nav_col_name||'  = '''||l_rec.nav_value||'''';
               ELSE
                   l_sql_el_attrib := l_sql_el_attrib||CHR(10)||','||l_rec.nav_col_name||'  = '''||l_rec.nav_value||'''';
               END IF;
           ELSIF  l_rec.nav_disp_ord = 2
           AND l_rec.nav_col_updatable = 'Y'
           THEN
               IF l_sql_inv_attrib IS NULL
               THEN  
                   l_sql_inv_attrib := 'SET '||l_rec.nav_col_name||'  = '''||l_rec.nav_value||'''';
               ELSE
                   l_sql_inv_attrib := l_sql_inv_attrib||CHR(10)||','||l_rec.nav_col_name||'  = '''||l_rec.nav_value||'''';
               END IF;
           END IF ;
       END LOOP ;
       IF l_par_inc = 'Y'
       OR l_chi_inc = 'Y'
       THEN
           IF l_par_inc = 'Y'
           THEN
               -- Get parent inclusion value
               Execute Immediate ' SELECT '||l_parent_col_name||
                                 ' FROM   nm_elements ne,table(cast(nm3_bulk_attrib_upd.get_ne_array(:1) as nm_ne_id_array)) x  '||
                                 ' WHERE  ne.ne_id = x.ne_id ' BULK COLLECT INTO  l_ne_old_tab Using pi_ne_id_array ;
               -- Update parent attributes
               FORALL i in 1..l_ne_tab.Count
               Execute Immediate ' UPDATE  nm_elements '||
                                 l_sql_el_attrib|| 
                                 ' WHERE ne_id = :a ' Using l_ne_tab(i) ;
               IF l_child_col_name IS NOT NULL
               THEN
                   -- Update child inclusion value
                   FORALL i in 1..l_ne_old_tab.Count
                   Execute Immediate ' UPDATE nm_elements '||
                                     ' SET    '||l_child_col_name||' =  :1 '||  
                                     ' WHERE  '||l_child_col_name||' =  :2 ' Using l_child_col_value,l_ne_old_tab(i);
               END IF ;
               l_nti_rec := nm3get.get_nti(l_nt_type,FALSE);
               -- if the parent auto inclusde is Y then end date re-create membersship records 
               IF l_nti_rec.nti_auto_include = 'Y'
               THEN
                   SELECT nm_ne_id_in, nm_ne_id_of, nm_type, nm_obj_type, nm_begin_mp, 
                          Trunc(sysdate), nm_end_date, nm_end_mp, nm_slk, nm_cardinality, 
                          nm_admin_unit, nm_date_created, nm_date_modified, nm_modified_by, nm_created_by, 
                          nm_seq_no, nm_seg_no, nm_true, nm_end_slk, nm_end_true 
                          BULK COLLECT INTO l_nm_tab
                   FROM   nm_members nm,table(cast(get_ne_array(pi_ne_id_array) as nm_ne_id_array)) x  
                   WHERE  nm.nm_ne_id_in = x.ne_id ;
                   FORALL i in 1..l_ne_tab.Count
                   UPDATE  nm_members 
                   SET     nm_end_date = TRUNC(SYSDATE) 
                   WHERE   nm_ne_id_in = l_ne_tab(i) ;
                  
                   FORALL i in 1..l_nm_tab.Count
                   INSERT INTO nm_members values l_nm_tab(i) ;    
               ELSE 
                   FORALL i in 1..l_ne_tab.Count
                   UPDATE  nm_members 
                   SET     nm_end_date = TRUNC(SYSDATE) 
                   WHERE   nm_ne_id_in = l_ne_tab(i) ;                                            
               END IF;
           ELSIF l_chi_inc = 'Y'
           THEN
               IF l_child_col_value IS NOT NULL
               THEN
                   Execute Immediate ' SELECT * '||
                                     ' FROM   nm_elements ne      '|| 
                                     ' WHERE  ne.ne_nt_type = :1 '||
                                     ' AND    '||l_nti_rec.nti_parent_column||' = :2 '||
                                     ' AND    rownum = 1 ' INTO l_parent_rec Using l_nti_rec.nti_nw_parent_type,l_child_col_value ;                  
                   FORALL i in 1..l_ne_tab.Count
                   Execute Immediate ' UPDATE  nm_elements '||
                                     l_sql_el_attrib|| 
                                     ' WHERE ne_id = :a ' Using l_ne_tab(i) ;
                   -- Update child attributes                   
                   ---IF l_nti_rec.nti_auto_include = 'Y'
                   --THEN
                       SELECT l_parent_rec.ne_id, x.ne_id, 'G', l_parent_rec.ne_gty_group_type, 0, 
                              Trunc(sysdate), null, ne.ne_length, null, 1, 
                              l_parent_rec.ne_admin_unit, null,null,null,null, 
                              Null,Null,Null, 0, Null 
                              BULK COLLECT INTO l_nm_tab
                       FROM   (Select x.* FROM table(cast(get_ne_array(pi_ne_id_array) as nm_ne_id_array)) x) x,
                               nm_elements ne
                       WHERE   x.ne_id IS NOT NULL
                       AND     ne.ne_id = x.ne_id;
                      
                       FORALL i in 1..l_ne_tab.Count
                       UPDATE  nm_members 
                       SET     nm_end_date = TRUNC(SYSDATE) 
                       WHERE   nm_ne_id_of = l_ne_tab(i) 
                       AND     nm_obj_type = l_parent_rec.ne_gty_group_type ;
                              
                       FORALL i in 1..l_nm_tab.Count
                       INSERT INTO nm_members values l_nm_tab(i) ;
                   --ELSE
                   --    FORALL i in 1..l_ne_tab.Count
                   --    UPDATE  nm_members 
                   --    SET     nm_end_date = TRUNC(SYSDATE) 
                   --    WHERE   nm_ne_id_of = l_ne_tab(i) 
                   --    AND     nm_obj_type = l_parent_rec.ne_gty_group_type ;
                   --END IF ;
               ELSE
                   OPEN  get_parent_gty(l_nti_rec.nti_nw_parent_type);
                   FETCH get_parent_gty INTO l_gty_rec;
                   CLOSE get_parent_gty ;
                   
                   FORALL i in 1..l_ne_tab.Count
                   Execute Immediate ' UPDATE  nm_elements '||
                                     l_sql_el_attrib|| 
                                     ' WHERE ne_id = :a ' Using l_ne_tab(i) ;
                                         
                   FORALL i in 1..l_ne_tab.Count
                   UPDATE  nm_members 
                   SET     nm_end_date = TRUNC(SYSDATE) 
                   WHERE   nm_ne_id_of = l_ne_tab(i) 
                   AND     nm_obj_type = l_gty_rec.ngt_group_type ; 
               END IF ;
           END IF ;   
       ELSE
           IF  l_sql_el_attrib IS NOT NULL
           AND l_ne_tab.count > 0
           THEN
               FORALL i in 1..l_ne_tab.Count
               Execute Immediate ' UPDATE  nm_elements '||
                                 l_sql_el_attrib|| 
                                 ' WHERE ne_id = :a ' Using l_ne_tab(i) ;
           END IF ;
       END IF ;
       IF  l_sql_inv_attrib IS NOT NULL
       AND l_ne_tab.count > 0
       THEN
           OPEN  c_nad(l_nt_type,  l_gty_type);      
           FETCH c_nad INTO l_nad_rec ;
           CLOSE c_nad;
            
           FORALL j in 1..l_ne_tab.Count
           Execute Immediate ' UPDATE  nm_inv_items '||
                             l_sql_inv_attrib|| 
                             ' WHERE iit_ne_id  IN (SELECT nad_iit_ne_id '||
                             '                     FROM   nm_nw_ad_link '||
                             '                     WHERE  nad_id    = :1 '||
                             '                     AND    nad_ne_id = :2 )' Using l_nad_rec.nad_id,l_ne_tab(j) ;
       END IF ;
   END IF ;   
--   
EXCEPTION
--
   WHEN OTHERS THEN
   Raise_Application_Error(-20060,SQLERRM);   
--
END upd_attrib;
--
Procedure add_remove_ne_id(pi_ne_id   nm_elements.ne_id%TYPE
                          ,pi_index    NUMBER
                          ,pi_ope_flag Varchar2)
IS
--
   l_rec nm_ne_id_type;
--
BEGIN
--
   IF pi_ope_flag =  'A'
   THEN
       nm3_bulk_attrib_upd.l_ne_id_type.ne_id := pi_ne_id ;
       nm3_bulk_attrib_upd.l_ne_id_array(pi_index) := nm3_bulk_attrib_upd.l_ne_id_type;
       nm3_bulk_attrib_upd.l_ne_id_array.extend;
   ELSE
       IF pi_index IS NOT NULL
       THEN
           FOR i in 1..nm3_bulk_attrib_upd.l_ne_id_array.Count 
           LOOP
               BEGIN
                  l_rec := nm3_bulk_attrib_upd.l_ne_id_array(i);
                  IF l_rec.ne_id = pi_ne_id
                  THEN
                      nm3_bulk_attrib_upd.l_ne_id_array.delete(i) ;
                  END IF;
               EXCEPTION
                   WHEN no_data_found
                   THEN
                       Null;              
               END ;
           END LOOP;
       ELSE
           nm3_bulk_attrib_upd.l_ne_id_array.delete;    
           nm3_bulk_attrib_upd.l_ne_id_array := nm_ne_id_array(Null) ;
       END IF ;
   END IF ;
--   
END add_remove_ne_id;
--
Procedure build_att_array(pi_attrib_array   l_attrib_rec
                         ,pi_index    NUMBER)
IS
BEGIN
-- 
   nm3_bulk_attrib_upd.l_att_array(pi_index) := pi_attrib_array;
   nm3_bulk_attrib_upd.l_att_array.extend;
--
END build_att_array;
--
Procedure run_ddl
IS
BEGIN
   nm3_bulk_attrib_upd.l_allow_attrib_upd := 'Y' ;
   nm3_bulk_attrib_upd.upd_attrib(nm3_bulk_attrib_upd.l_ne_id_array,nm3_bulk_attrib_upd.l_att_array);
   delete_array ; 
   nm3_bulk_attrib_upd.l_allow_attrib_upd := 'N' ;
END run_ddl;
--
Procedure  delete_array 
IS
BEGIN
--
   nm3_bulk_attrib_upd.l_ne_id_array.Delete ;
   nm3_bulk_attrib_upd.l_ne_id_array := nm_ne_id_array(Null);
   nm3_bulk_attrib_upd.l_grp_ne_id_array.Delete ;
   nm3_bulk_attrib_upd.l_grp_ne_id_array := nm_ne_id_array(Null);
   nm3_bulk_attrib_upd.l_att_array.Delete ;
   nm3_bulk_attrib_upd.l_att_array := nm3_bulk_attrib_upd.l_attrib_array(Null);
END delete_array;
--
FUNCTION  check_col_upd(pi_col_name IN nm_type_columns.ntc_column_name%TYPE
                       ,pi_nt_type  IN nm_type_columns.ntc_nt_type%TYPE)
RETURN    Varchar2 
IS
--
   l_nti_rec   nm_type_inclusion%ROWTYPE ;
   l_ntc_rec   nm_type_columns%ROWTYPE   := nm3get.get_ntc(pi_nt_type,pi_col_name,false); 
   l_nti_child nm_type_inclusion%ROWTYPE := nm3get.get_nti(pi_nti_nw_child_type => pi_nt_type,
                                                           pi_nti_child_column  => pi_col_name,
                                                           pi_raise_not_found   => FALSE);
--
BEGIN
--
   IF nm3get.get_ntc(pi_nt_type,pi_col_name,FALSE).ntc_unique_seq IS NOT NULL
   THEN
       Return 'N';
   ELSE
       l_nti_rec := nm3get.get_nti(pi_nt_type,FALSE) ;    
       IF nm3get.get_ntc(l_nti_rec.nti_nw_child_type,l_nti_rec.nti_child_column,FALSE).ntc_unique_seq IS NOT NULL
       THEN
           Return 'N';
       ELSIF l_ntc_rec.ntc_updatable = 'N'
       THEN
           IF  l_nti_child.nti_child_column IS NOT NULL
           THEN 
               RETURN 'Y';  
           ELSE 
               RETURN l_ntc_rec.ntc_updatable;
           END IF;
       ELSE 
           RETURN 'Y';  
       END IF ;
   END IF ;   
--
END check_col_upd ;
--
FUNCTION  parent_inclusion_type(pi_col_name IN nm_type_columns.ntc_column_name%TYPE
                               ,pi_nt_type  IN nm_type_columns.ntc_nt_type%TYPE)
RETURN    Varchar2 
IS
BEGIN
--
   IF nm3get.get_nti(pi_nt_type,FALSE).nti_parent_column = pi_col_name
   THEN
   --
       RETURN 'Y' ; 
   ELSE
       RETURN 'N' ;
   --       
   END IF ;
--
END parent_inclusion_type;
--
FUNCTION  child_inclusion_type(pi_col_name IN nm_type_columns.ntc_column_name%TYPE
                              ,pi_nt_type  IN nm_type_columns.ntc_nt_type%TYPE)
RETURN    Varchar2 
IS
BEGIN
--
   IF nm3get.get_nti(pi_nti_nw_child_type => pi_nt_type,
                     pi_nti_child_column  => pi_col_name,
                     pi_raise_not_found   => FALSE).nti_child_column = pi_col_name
   THEN
   --
       RETURN 'Y' ; 
   ELSE
       RETURN 'N' ;
   --       
   END IF ;
--
END child_inclusion_type;
--
PROCEDURE add_remove_attrib(pi_nt_type     nm_type_columns.ntc_nt_type%TYPE
                           ,pi_col_name    nm_type_columns.ntc_column_name%TYPE
                           ,pi_column_type Number
                           ,pi_col_value   Varchar2
                           ,pi_index       Number 
                           ) 
IS
--
   l_rec nm3_bulk_attrib_upd.l_attrib_rec;
   CURSOR c_get_nav
   IS
   SELECT *   
   FROM   nm_attrib_view_vw
   WHERE  nav_nt_type = pi_nt_type
   AND    nav_col_name = pi_col_name
   AND    nav_disp_ord = pi_column_type;
   l_nav_rec c_get_nav%ROWTYPE ;   
--
BEGIN
--
   OPEN  c_get_nav;
   FETCH c_get_nav INTO l_nav_rec;
   CLOSE c_get_nav ;
  
   l_rec.nav_disp_ord        := l_nav_rec.nav_disp_ord;
   l_rec.nav_nt_type         := l_nav_rec.nav_nt_type;
   l_rec.nav_inv_type        := l_nav_rec.nav_inv_type;
   l_rec.nav_gty_type        := l_nav_rec.nav_gty_type;
   l_rec.nav_col_name        := l_nav_rec.nav_col_name;
   l_rec.nav_col_type        := l_nav_rec.nav_col_type;
   l_rec.nav_col_updatable   := l_nav_rec.nav_col_updatable;
   l_rec.nav_parent_type_inc := l_nav_rec.nav_parent_type_inc;
   l_rec.nav_child_type_inc  := l_nav_rec.nav_child_type_inc;
   l_rec.nav_child_col       := l_nav_rec.nav_child_col ;
   l_rec.nav_value           := pi_col_value;       
   nm3_bulk_attrib_upd.build_att_array(l_rec,pi_index);
END add_remove_attrib;
--
Procedure add_remove_grp_ne_id(pi_ne_id   nm_elements.ne_id%TYPE
                              ,pi_index    NUMBER
                              ,pi_ope_flag Varchar2)
IS
--
   l_rec nm_ne_id_type;
--
BEGIN
--
   IF pi_ope_flag =  'A'
   THEN
       nm3_bulk_attrib_upd.l_ne_id_type.ne_id := pi_ne_id ;
       nm3_bulk_attrib_upd.l_grp_ne_id_array(pi_index) := nm3_bulk_attrib_upd.l_ne_id_type;
       nm3_bulk_attrib_upd.l_grp_ne_id_array.extend;
   ELSE
       IF pi_index IS NOT NULL
       THEN
           FOR i in 1..nm3_bulk_attrib_upd.l_grp_ne_id_array.Count 
           LOOP
               BEGIN
                  l_rec := nm3_bulk_attrib_upd.l_grp_ne_id_array(i);
                  IF l_rec.ne_id = pi_ne_id
                  THEN
                      nm3_bulk_attrib_upd.l_grp_ne_id_array.delete(i) ;
                  END IF;
               EXCEPTION
                   WHEN no_data_found
                   THEN
                       Null;              
               END ;
           END LOOP;
       ELSE
           nm3_bulk_attrib_upd.l_grp_ne_id_array.delete;    
           nm3_bulk_attrib_upd.l_grp_ne_id_array := nm_ne_id_array(Null) ;
       END IF ;
   END IF ;
--   
END add_remove_grp_ne_id;
--
Procedure validate_data(pi_group_type       IN Varchar2)
IS
--
   l_number Number ;
--
BEGIN
--
   SELECT 1 into l_number 
   FROM   nm_members 
         ,table(cast(nm3_bulk_attrib_upd.get_ne_array(nm3_bulk_attrib_upd.l_ne_id_array) as nm_ne_id_array)) x         
         ,nm_elements ne
   WHERE nm_ne_id_of  = x.ne_id
   AND   nm_obj_type  = ne.ne_gty_group_type
   AND   ne.ne_id    IN (SELECT y.ne_id FROM (table(cast(nm3_bulk_attrib_upd.get_grp_ne_array(nm3_bulk_attrib_upd.l_grp_ne_id_array) as nm_ne_id_array)) y))
   AND   ROWNUM = 1;

   IF pi_group_type ='Y'
   THEN
       RAISE_APPLICATION_ERROR(-20600,'This selected Group Type is Exclusive. The selected Network Elements will be End Dated from existing Groups of this type. Do you wish to continue?');
   ELSE
       RAISE_APPLICATION_ERROR(-20601,'One or more of the selected Network Elements are already members of a Group of this type. Do you want to End Date existing Group Memberships for affected Elements?');    
   END IF;
EXCEPTION
    WHEN no_data_found 
    THEN
        Null;
--
END validate_data;
--
Procedure Update_groups_members(pi_group_type   IN Varchar2
                               ,pi_operation    IN Varchar2
                               )        
IS
--
   TYPE l_ne_id_type  IS TABLE OF Number INDEX BY BINARY_INTEGER;
   TYPE l_nm_rec_type  IS TABLE OF nm_members%ROWTYPE INDEX BY BINARY_INTEGER;
   l_ne_id l_ne_id_type;
   l_nm_rec l_nm_rec_type ;
   l_grp_ne_id  nm_elements.ne_id%TYPE ;
   l_group_type nm_members.nm_obj_type%TYPE ;
   l_admin_unit nm_elements.ne_admin_unit%TYPE ;
   l_cnt        Number := 0 ;
--
BEGIN
--
   BEGIN      
   --
      SELECT x.ne_id
             BULK COLLECT INTO l_ne_id 
      FROM   table(cast(nm3_bulk_attrib_upd.get_ne_array(nm3_bulk_attrib_upd.l_ne_id_array) as nm_ne_id_array)) x ;

      Forall i in 1..l_ne_id.Count
      Execute Immediate 'Begin nm3lock.lock_element_and_members(:1,TRUE); End ; ' Using l_ne_id(i);
   EXCEPTION
       WHEN No_Data_Found 
       THEN
           Null;
   END ;
   IF pi_group_type = 'Y' -- exclusive group
   THEN
       For j IN (SELECT y.ne_id,ne.ne_gty_group_type,ne_admin_unit
                 FROM   nm_elements ne ,(table(cast(nm3_bulk_attrib_upd.get_grp_ne_array(nm3_bulk_attrib_upd.l_grp_ne_id_array) as nm_ne_id_array)) y)
                 WHERE  ne.ne_id = y.ne_id)
       Loop
           l_grp_ne_id  := j.ne_id ;
           l_group_type := j.ne_gty_group_type ;
           l_admin_unit := j.ne_admin_unit ;
       End Loop;       

       IF l_ne_id.count > 0
       THEN
           FORALL i IN 1..l_ne_id.Count
           UPDATE nm_members
           SET    nm_end_date = Trunc(Sysdate)
           WHERE  nm_ne_id_of = l_ne_id(i)
           AND    nm_obj_type = l_group_type 
           AND    nm_type     = 'G' ;
       END IF ;
       SELECT l_grp_ne_id,
              x.ne_id, 
              'G', 
              l_group_type, 
              0, 
              Trunc(Sysdate), 
              Null, 
              ne_length, 
              Null, 
              1, 
              l_admin_unit, 
              Null, 
              Null, 
              Null, 
              Null, 
              Null, 
              Null, 
              Null, 
              Null, 
              Null    
              BULK COLLECT INTO l_nm_rec   
       FROM  (SELECT ne.* FROM nm_elements ne, (table(cast(nm3_bulk_attrib_upd.get_ne_array(nm3_bulk_attrib_upd.l_ne_id_array) as nm_ne_id_array)) ne1 )
              WHERE   ne.ne_id = ne1.ne_id ) x  ;        

       FORALL i IN 1..l_nm_rec.Count
       INSERT INTO NM_MEMBERS VALUES l_nm_rec(i);
   ELSE
       For j IN (SELECT y.ne_id,ne.ne_gty_group_type,ne_admin_unit
                 FROM   nm_elements ne ,(table(cast(nm3_bulk_attrib_upd.get_grp_ne_array(nm3_bulk_attrib_upd.l_grp_ne_id_array) as nm_ne_id_array)) y)
                 WHERE  ne.ne_id = y.ne_id)
       Loop
           l_grp_ne_id  := j.ne_id ;
           l_group_type := j.ne_gty_group_type ;
           l_admin_unit := j.ne_admin_unit ;
           l_cnt  := l_cnt + 1 ;

           IF pi_operation = 'Y'
           THEN 
               IF l_cnt = 1
               THEN
                   SELECT x.ne_id
                          BULK COLLECT INTO l_ne_id 
                   FROM   table(cast(nm3_bulk_attrib_upd.get_ne_array(nm3_bulk_attrib_upd.l_ne_id_array) as nm_ne_id_array)) x ;
                   IF l_ne_id.count > 0
                   THEN
                       FORALL i IN 1..l_ne_id.Count
                       UPDATE nm_members
                       SET    nm_end_date = Trunc(Sysdate)
                       WHERE  nm_ne_id_of = l_ne_id(i)
                       AND    nm_obj_type = l_group_type ;
                   END IF ;
               END IF ;
           END IF ;       
           SELECT l_grp_ne_id,
                  x.ne_id, 
                  'G', 
                  l_group_type, 
                  0, 
                  Trunc(Sysdate), 
                  Null, 
                  ne_length, 
                  Null, 
                  1, 
                  l_admin_unit, 
                  Null, 
                  Null, 
                  Null, 
                  Null, 
                  Null, 
                  Null, 
                  Null, 
                  Null, 
                  Null    
                 BULK  COLLECT INTO l_nm_rec   
           FROM  nm_members nm,
                 (SELECT ne.* FROM nm_elements ne,(table(cast(nm3_bulk_attrib_upd.get_ne_array(nm3_bulk_attrib_upd.l_ne_id_array) as nm_ne_id_array)) ne1 )
           WHERE   ne.ne_id = ne1.ne_id) x ;       
 
           FORALL i IN 1..l_nm_rec.Count
           INSERT INTO NM_MEMBERS VALUES l_nm_rec(i);
       END LOOP;
   END IF ;   
-- 
END Update_groups_members;
--
END nm3_bulk_attrib_upd;
/
