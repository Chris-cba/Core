CREATE OR REPLACE PACKAGE BODY nm3mapcapture_ins_inv AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3mapcapture_ins_inv.pkb-arc   2.5.1.0   Feb 24 2012 10:09:24   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3mapcapture_ins_inv.pkb  $
--       Date into PVCS   : $Date:   Feb 24 2012 10:09:24  $
--       Date fetched Out : $Modtime:   Feb 24 2012 09:56:16  $
--       Version          : $Revision:   2.5.1.0  $
--       Based on SCCS version : 1.15
-------------------------------------------------------------------------
--   Author : Darren Cope
--
--   <<  description >>
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2003
-----------------------------------------------------------------------------
--
--all global package variables here
--
   --g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)nm3mapcapture_ins_inv.pkb	1.15 09/09/05"';
   g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.5.1.0  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3mapcapture_ins_inv';
   TYPE  l_iit_id_type IS TABLE OF NUMBER INDEX BY BINARY_INTEGER ;
   l_iit_id_tab1    l_iit_id_type ;
--  
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
procedure get_parent_info ( p_foreign_key in nm_inv_items.iit_foreign_key%type,
                            p_child_type  in nm_inv_items.iit_inv_type%type,
                            p_itg_row out nm_inv_type_groupings%rowtype,
                            p_parent_id out nm_inv_items.iit_ne_id%type ) is 
--
                            
begin
   select g.itg_inv_type,
          g.itg_parent_inv_type,
          g.itg_mandatory,
          g.itg_relation,
          g.itg_start_date,
          g.itg_end_date,
          g.itg_date_created,
          g.itg_date_modified,
          g.itg_modified_by,
          g.itg_created_by,
          i.iit_ne_id
   into p_itg_row.itg_inv_type,
        p_itg_row.itg_parent_inv_type,
        p_itg_row.itg_mandatory,
        p_itg_row.itg_relation,
        p_itg_row.itg_start_date,
        p_itg_row.itg_end_date,
        p_itg_row.itg_date_created,
        p_itg_row.itg_date_modified,
        p_itg_row.itg_modified_by,
        p_itg_row.itg_created_by,
        p_parent_id  
   from nm_inv_type_groupings g, nm_inv_items i
   where itg_inv_type = p_child_type
   and iit_primary_key = p_foreign_key
   and itg_parent_inv_type = iit_inv_type;
exception
  when no_data_found then
    p_parent_id := NULL;
  when others then
    raise_application_error( -20001, 'Hierarchy problem'); 
end;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_batch_error(p_batch_no  IN nm_ld_mc_all_inv_tmp.batch_no%TYPE
                         ,p_record_no IN nm_ld_mc_all_inv_tmp.record_no%TYPE
                         ,p_error_no  IN pls_integer) IS 
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'set_batch_error');
  
  UPDATE nm_ld_mc_all_inv_tmp
  SET    nlm_error_status = p_error_no
  WHERE  batch_no  = p_batch_no
  AND    record_no = p_record_no;
  
  COMMIT;
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'set_batch_error');
END set_batch_error;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_batch_error(p_batch_no  IN nm_ld_mc_all_inv_tmp.batch_no%TYPE
                           ,p_record_no IN nm_ld_mc_all_inv_tmp.record_no%TYPE) IS 
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'clear_batch_error');
  
  set_batch_error(p_batch_no
                 ,p_record_no
                 ,0);
                 
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'clear_batch_error');
END clear_batch_error;
--
-----------------------------------------------------------------------------
--
PROCEDURE conflict_batch_error(p_batch_no  IN nm_ld_mc_all_inv_tmp.batch_no%TYPE
                              ,p_record_no IN nm_ld_mc_all_inv_tmp.record_no%TYPE) IS 
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'conflict_batch_error');
  
  set_batch_error(p_batch_no
                 ,p_record_no
                 ,2);
                 
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'conflict_batch_error');
END conflict_batch_error;
--
-----------------------------------------------------------------------------
--
PROCEDURE general_batch_error(p_batch_no  IN nm_ld_mc_all_inv_tmp.batch_no%TYPE
                              ,p_record_no IN nm_ld_mc_all_inv_tmp.record_no%TYPE) IS 
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'general_batch_error');
  
  set_batch_error(p_batch_no
                 ,p_record_no
                 ,1);
                 
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'general_batch_error');
END general_batch_error;
--
-----------------------------------------------------------------------------
--
FUNCTION inventory_changed_since(p_inv_item nm_inv_items.iit_ne_id%TYPE
                                ,p_since    DATE) RETURN BOOLEAN IS
   --Log 719080:Linesh:18-Feb-2009:Start
   --The date format is now picked from nm_load_file_cols table
   CURSOR c_get_date_format
   IS
   SELECT nlfc_date_format_mask 
   FROM   nm_load_file_cols
   WHERE  nlfc_holding_col = 'IIT_DATE_MODIFIED' ;

   l_dt_format nm_load_file_cols.nlfc_date_format_mask%TYPE ; 
   --Log 719080:Linesh:18-Feb-2009:End  
   l_existing_inv nm_inv_items%ROWTYPE;
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'inventory_changed_since');
  
  -- if inventory items changed since date given the fail
  l_existing_inv := nm3get.get_iit(pi_iit_ne_id       => p_inv_item
                                  ,pi_raise_not_found => TRUE);
  
  --Log 719080:Linesh:18-Feb-2009:Start
  OPEN  c_get_date_format;
  FETCH c_get_date_format INTO l_dt_format ;
  CLOSE c_get_date_format ;
  
  --IF TO_DATE(TO_CHAR(l_existing_inv.iit_date_modified, nm3mapcapture_int.c_date_format), nm3mapcapture_int.c_date_format) 
  -- > TO_DATE(TO_CHAR(p_since, nm3mapcapture_int.c_date_format), nm3mapcapture_int.c_date_format) THEN
  IF TO_DATE(TO_CHAR(l_existing_inv.iit_date_modified, l_dt_format), l_dt_format)  > TO_DATE(TO_CHAR(p_since, l_dt_format), l_dt_format) 
  THEN
  --Log 719080:Linesh:18-Feb-2009:End 
     nm_debug.debug('Item changed'||l_existing_inv.iit_date_modified);
     RETURN TRUE;
  ELSE
     RETURN FALSE;
  END IF;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'inventory_changed_since');
END inventory_changed_since;
--
-----------------------------------------------------------------------------
--
--   Function to get using SYS_C0021089 constraint
--   Code cribbed directly from the 3.1.0.0 version of nm3get for this backport to 3.0.8.2
FUNCTION get_nlm (pi_batch_no          nm_ld_mc_all_inv_tmp.batch_no%TYPE
                 ,pi_record_no         nm_ld_mc_all_inv_tmp.record_no%TYPE
                 ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                 ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                 ) RETURN nm_ld_mc_all_inv_tmp%ROWTYPE IS
--
   CURSOR cs_nlm IS
   SELECT *
    FROM  nm_ld_mc_all_inv_tmp
   WHERE  batch_no  = pi_batch_no
    AND   record_no = pi_record_no;
--
   l_found  BOOLEAN;
   l_retval nm_ld_mc_all_inv_tmp%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_nlm');
--
   OPEN  cs_nlm;
   FETCH cs_nlm INTO l_retval;
   l_found := cs_nlm%FOUND;
   CLOSE cs_nlm;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_ld_mc_all_inv_tmp (SYS_C0021089)'
                                              ||CHR(10)||'batch_no  => '||pi_batch_no
                                              ||CHR(10)||'record_no => '||pi_record_no
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_nlm');
--
   RETURN l_retval;
--
END get_nlm;
--
-----------------------------------------------------------------------------
--
FUNCTION conflict_resolved(p_batch_no    IN nm_ld_mc_all_inv_tmp.batch_no%TYPE
                          ,p_record_no   IN nm_ld_mc_all_inv_tmp.record_no%TYPE) RETURN BOOLEAN IS
l_nlm_rec  nm_ld_mc_all_inv_tmp%ROWTYPE := get_nlm(pi_batch_no  => p_batch_no
                                                  ,pi_record_no => p_record_no); 
BEGIN
  IF l_nlm_rec.nlm_error_status = 3 THEN
     RETURN TRUE;
  ELSE
     RETURN FALSE;
  END IF;
END conflict_resolved;
--
-----------------------------------------------------------------------------
--
FUNCTION date_track_attributes (p_iit_id IN nm_inv_items_all.iit_ne_id%TYPE) RETURN BOOLEAN IS

CURSOR get_attribs (p_inv_type IN nm_inv_type_attribs_all.ita_inv_type%TYPE) IS
SELECT nia.ita_attrib_name
FROM   nm_inv_type_attribs_all nia
WHERE  nia.ita_inv_type  = p_inv_type
AND    nia.ita_keep_history_yn = 'Y';

l_found boolean DEFAULT FALSE;
l_sql   nm3type.tab_varchar32767;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'date_track_attributes');
  
  g_date_track_attr_changed := FALSE;
  
  nm3ddl.append_tab_varchar(l_sql, 'DECLARE');
  nm3ddl.append_tab_varchar(l_sql, 'l_existing_item nm_inv_items_all%ROWTYPE := nm3get.get_iit('||p_iit_id||');');
  nm3ddl.append_tab_varchar(l_sql, 'BEGIN');
  -- loop through checking each attribute
  FOR l_attr_rec IN get_attribs(nm3inv.get_inv_type(p_ne_id => p_iit_id)) LOOP
    l_found := TRUE;
    nm3ddl.append_tab_varchar(l_sql, 'IF l_existing_item.'||l_attr_rec.ita_attrib_name||' != nm3mapcapture_ins_inv.g_inv.'||l_attr_rec.ita_attrib_name||' THEN');
    nm3ddl.append_tab_varchar(l_sql, '  nm3mapcapture_ins_inv.g_date_track_attr_changed := TRUE;');
    nm3ddl.append_tab_varchar(l_sql, 'END IF;');
  END LOOP;
  nm3ddl.append_tab_varchar(l_sql, 'END;');
  
  IF l_found THEN
    -- only execute if we have date track attributes to check
    nm3ddl.execute_tab_varchar(l_sql);
  END IF;
  
  RETURN g_date_track_attr_changed;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'date_track_attributes');
END date_track_attributes;
--
PROCEDURE populate_child_items(pi_batch_no   nm_load_batch_status.nlbs_nlb_batch_no%TYPE
                              ,pi_iit_ne_id  nm_inv_items.iit_ne_id%TYPE)
IS
--
   CURSOR c_get_batch(qp_iit_ne_id nm_inv_items.iit_ne_id%TYPE)
   IS
   SELECT 'x'
   FROM   nm_ld_mc_all_inv_tmp 
   WHERE  batch_no = pi_batch_no
   AND    iit_ne_id =  qp_iit_ne_id ;
   l_get_batch c_get_batch%ROWTYPE; 
   l_iit_rec nm_inv_items%ROWTYPE;
   type l_iig_tab_type is table of NM_INV_ITEM_GROUPINGS%ROWTYPE ;
   l_iig_rec NM_INV_ITEM_GROUPINGS%ROWTYPE;
   l_iig_tab1    l_iig_tab_type;
   l_iit_id_tab  l_iit_id_type;   
   l_found Boolean ;
BEGIN             
--
   l_iit_id_tab1.delete ;
   SELECT iig.* 
          BULK COLLECT INTO l_iig_tab1 
   FROM   NM_INV_ITEM_GROUPINGS  iig
   CONNECT BY iig_parent_id = PRIOR iig_item_id
   START WITH iig_parent_id = pi_iit_ne_id
   ORDER BY level ;
   FOR i IN 1..l_iig_tab1.Count
   loop
       l_iig_rec :=l_iig_tab1(i) ; 
       IF nm3get.get_itg(nm3get.get_iit(l_iig_rec.iig_item_id).iit_inv_type,nm3get.get_iit(l_iig_rec.iig_parent_id).iit_inv_type).itg_mandatory = 'Y'
       THEN
           OPEN  c_get_batch (l_iig_rec.iig_item_id);
           FETCH c_get_batch INTO l_get_batch;
           IF c_get_batch%FOUND
           THEN
               CLOSE c_get_batch;
               l_iit_id_tab(l_iit_id_tab.count+1) := l_iig_rec.iig_item_id;
               FOR j in (SELECT  iig.*  
                         FROM   NM_INV_ITEM_GROUPINGS  iig
                         CONNECT BY iig_parent_id = PRIOR iig_item_id
                         START WITH iig_parent_id = l_iig_rec.iig_item_id
                         ORDER BY level )
               LOOP
                   IF nm3get.get_itg(nm3get.get_iit(j.iig_item_id).iit_inv_type,nm3get.get_iit(j.iig_parent_id).iit_inv_type).itg_mandatory = 'Y'
                   THEN           
                       OPEN  c_get_batch (j.iig_item_id);
                       FETCH c_get_batch INTO l_get_batch;
                       IF c_get_batch%NOTFOUND
                       THEN        
                            CLOSE c_get_batch;
                           l_iit_id_tab(l_iit_id_tab.count+1) := j.iig_item_id;
                       ELSE
                           CLOSE c_get_batch ;    
                       END IF ;
                   END if ;
               END LOOP;    
           ELSE
               CLOSE c_get_batch;    
           END IF ;                
      END IF ;     
   END LOOP;
   FOR i IN 1..l_iig_tab1.count
   LOOP
       l_iig_rec :=l_iig_tab1(i);
       IF nm3get.get_itg(nm3get.get_iit(l_iig_rec.iig_item_id).iit_inv_type,nm3get.get_iit(l_iig_rec.iig_parent_id).iit_inv_type).itg_mandatory = 'Y'
       THEN
           l_found := FALSE ;          
           FOR i IN 1..l_iit_id_tab.count
           LOOP
               IF l_iig_rec.iig_item_id = l_iit_id_tab(i)
               THEN 
                   l_found := TRUE ;
                   Exit;
               END If ;    
           END LOOP;
           IF NOT l_found
           THEN
                l_iit_id_tab1(l_iit_id_tab1.count+1) := l_iig_rec.iig_item_id;
           END IF;
      END If ;            
   END LOOP;
--
EXCEPTION
   WHEN OTHERS
   THEN
       Null;
END populate_child_items;
--
PROCEDURE populate_enddated_child_items(pi_batch_no   nm_load_batch_status.nlbs_nlb_batch_no%TYPE
                              ,pi_iit_ne_id  nm_inv_items.iit_ne_id%TYPE)
IS
--
   CURSOR c_get_batch(qp_iit_ne_id nm_inv_items.iit_ne_id%TYPE)
   IS
   SELECT 'x'
   FROM   nm_ld_mc_all_inv_tmp 
   WHERE  batch_no = pi_batch_no
   AND    iit_ne_id =  qp_iit_ne_id ;
   l_get_batch c_get_batch%ROWTYPE; 
   l_iit_rec nm_inv_items%ROWTYPE;
   type l_iig_tab_type is table of NM_INV_ITEM_GROUPINGS%ROWTYPE ;
   l_iig_rec NM_INV_ITEM_GROUPINGS%ROWTYPE;
   l_iig_tab1    l_iig_tab_type;
   l_iit_id_tab  l_iit_id_type;   
   l_found Boolean ;
   l_found_iit Boolean ;
BEGIN             
--
   l_iit_id_tab1.delete ;
   SELECT iig.* 
          BULK COLLECT INTO l_iig_tab1 
   FROM   NM_INV_ITEM_GROUPINGS_all  iig
   CONNECT BY iig_parent_id = PRIOR iig_item_id
   START WITH iig_parent_id = pi_iit_ne_id
   ORDER BY level ;
   FOR i IN 1..l_iig_tab1.Count
   loop
       l_iig_rec :=l_iig_tab1(i) ; 
       IF nm3get.get_itg(nm3get.get_iit_all(l_iig_rec.iig_item_id).iit_inv_type,nm3get.get_iit_all(l_iig_rec.iig_parent_id).iit_inv_type).itg_mandatory = 'Y'
       THEN
           OPEN  c_get_batch (l_iig_rec.iig_item_id);
           FETCH c_get_batch INTO l_get_batch;
           IF c_get_batch%FOUND
           THEN
               CLOSE c_get_batch;
               l_iit_id_tab(l_iit_id_tab.count+1) := l_iig_rec.iig_item_id;
               FOR j in (SELECT  iig.*  
                         FROM   NM_INV_ITEM_GROUPINGS_all  iig
                         CONNECT BY iig_parent_id = PRIOR iig_item_id
                         START WITH iig_parent_id = l_iig_rec.iig_item_id
                         ORDER BY level )
               LOOP
                   IF nm3get.get_itg(nm3get.get_iit_all(j.iig_item_id).iit_inv_type,nm3get.get_iit_all(j.iig_parent_id).iit_inv_type).itg_mandatory = 'Y'
                   THEN           
                       OPEN  c_get_batch (j.iig_item_id);
                       FETCH c_get_batch INTO l_get_batch;
                       IF c_get_batch%NOTFOUND
                       THEN        
                            CLOSE c_get_batch;
                           l_iit_id_tab(l_iit_id_tab.count+1) := j.iig_item_id;
                       ELSE
                           CLOSE c_get_batch ;    
                       END IF ;
                   END if ;
               END LOOP;    
           ELSE
               CLOSE c_get_batch;    
           END IF ;                
      END IF ;     
   END LOOP;
   FOR i IN 1..l_iig_tab1.count
   LOOP
       l_iig_rec :=l_iig_tab1(i);
       IF nm3get.get_itg(nm3get.get_iit_all(l_iig_rec.iig_item_id).iit_inv_type,nm3get.get_iit_all(l_iig_rec.iig_parent_id).iit_inv_type).itg_mandatory = 'Y'
       THEN
           l_found := FALSE ;          
           FOR i IN 1..l_iit_id_tab.count
           LOOP
               IF l_iig_rec.iig_item_id = l_iit_id_tab(i)
               THEN 
                   l_found := TRUE ;
                   Exit;
               END If ;    
           END LOOP;
           IF NOT l_found
           THEN
               FOR j IN 1..nm3mapcapture_ins_inv.l_iit_tab.Count
               LOOP
                   l_found_iit := FALSE;
                   l_iit_rec   :=  nm3mapcapture_ins_inv.l_iit_tab(j);
                   IF  l_iig_rec.iig_item_id = l_iit_rec.iit_ne_id
                   THEN
                       l_found_iit := TRUE;
                       EXIT;
                   END IF ;
               END LOOP;
               IF l_found_iit 
               THEN
                   l_iit_id_tab1(l_iit_id_tab1.count+1) := l_iig_rec.iig_item_id;
               END IF ;
           END IF;
      END If ;            
   END LOOP;
--
EXCEPTION
   WHEN OTHERS
   THEN
       Null;
END populate_enddated_child_items;
-------------------------
----------------------------------------------------
--
PROCEDURE update_changed_attributes IS

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'update_changed_attributes');

-- update columns which can be updated
  UPDATE nm_inv_items SET
   IIT_DESCR                 = g_inv.IIT_DESCR
  ,IIT_FOREIGN_KEY           = g_inv.IIT_FOREIGN_KEY
  ,IIT_LOCATED_BY            = g_inv.IIT_LOCATED_BY
  ,IIT_POSITION              = g_inv.IIT_POSITION
  ,IIT_X_COORD               = g_inv.IIT_X_COORD
  ,IIT_Y_COORD               = g_inv.IIT_Y_COORD
  ,IIT_NUM_ATTRIB16          = g_inv.IIT_NUM_ATTRIB16
  ,IIT_NUM_ATTRIB17          = g_inv.IIT_NUM_ATTRIB17
  ,IIT_NUM_ATTRIB18          = g_inv.IIT_NUM_ATTRIB18
  ,IIT_NUM_ATTRIB19          = g_inv.IIT_NUM_ATTRIB19
  ,IIT_NUM_ATTRIB20          = g_inv.IIT_NUM_ATTRIB20
  ,IIT_NUM_ATTRIB21          = g_inv.IIT_NUM_ATTRIB21
  ,IIT_NUM_ATTRIB22          = g_inv.IIT_NUM_ATTRIB22
  ,IIT_NUM_ATTRIB23          = g_inv.IIT_NUM_ATTRIB23
  ,IIT_NUM_ATTRIB24          = g_inv.IIT_NUM_ATTRIB24
  ,IIT_NUM_ATTRIB25          = g_inv.IIT_NUM_ATTRIB25
  ,IIT_CHR_ATTRIB26          = g_inv.IIT_CHR_ATTRIB26
  ,IIT_CHR_ATTRIB27          = g_inv.IIT_CHR_ATTRIB27
  ,IIT_CHR_ATTRIB28          = g_inv.IIT_CHR_ATTRIB28
  ,IIT_CHR_ATTRIB29          = g_inv.IIT_CHR_ATTRIB29
  ,IIT_CHR_ATTRIB30          = g_inv.IIT_CHR_ATTRIB30
  ,IIT_CHR_ATTRIB31          = g_inv.IIT_CHR_ATTRIB31
  ,IIT_CHR_ATTRIB32          = g_inv.IIT_CHR_ATTRIB32
  ,IIT_CHR_ATTRIB33          = g_inv.IIT_CHR_ATTRIB33
  ,IIT_CHR_ATTRIB34          = g_inv.IIT_CHR_ATTRIB34
  ,IIT_CHR_ATTRIB35          = g_inv.IIT_CHR_ATTRIB35
  ,IIT_CHR_ATTRIB36          = g_inv.IIT_CHR_ATTRIB36
  ,IIT_CHR_ATTRIB37          = g_inv.IIT_CHR_ATTRIB37
  ,IIT_CHR_ATTRIB38          = g_inv.IIT_CHR_ATTRIB38
  ,IIT_CHR_ATTRIB39          = g_inv.IIT_CHR_ATTRIB39
  ,IIT_CHR_ATTRIB40          = g_inv.IIT_CHR_ATTRIB40
  ,IIT_CHR_ATTRIB41          = g_inv.IIT_CHR_ATTRIB41
  ,IIT_CHR_ATTRIB42          = g_inv.IIT_CHR_ATTRIB42
  ,IIT_CHR_ATTRIB43          = g_inv.IIT_CHR_ATTRIB43
  ,IIT_CHR_ATTRIB44          = g_inv.IIT_CHR_ATTRIB44
  ,IIT_CHR_ATTRIB45          = g_inv.IIT_CHR_ATTRIB45
  ,IIT_CHR_ATTRIB46          = g_inv.IIT_CHR_ATTRIB46
  ,IIT_CHR_ATTRIB47          = g_inv.IIT_CHR_ATTRIB47
  ,IIT_CHR_ATTRIB48          = g_inv.IIT_CHR_ATTRIB48
  ,IIT_CHR_ATTRIB49          = g_inv.IIT_CHR_ATTRIB49
  ,IIT_CHR_ATTRIB50          = g_inv.IIT_CHR_ATTRIB50
  ,IIT_CHR_ATTRIB51          = g_inv.IIT_CHR_ATTRIB51
  ,IIT_CHR_ATTRIB52          = g_inv.IIT_CHR_ATTRIB52
  ,IIT_CHR_ATTRIB53          = g_inv.IIT_CHR_ATTRIB53
  ,IIT_CHR_ATTRIB54          = g_inv.IIT_CHR_ATTRIB54
  ,IIT_CHR_ATTRIB55          = g_inv.IIT_CHR_ATTRIB55
  ,IIT_CHR_ATTRIB56          = g_inv.IIT_CHR_ATTRIB56
  ,IIT_CHR_ATTRIB57          = g_inv.IIT_CHR_ATTRIB57
  ,IIT_CHR_ATTRIB58          = g_inv.IIT_CHR_ATTRIB58
  ,IIT_CHR_ATTRIB59          = g_inv.IIT_CHR_ATTRIB59
  ,IIT_CHR_ATTRIB60          = g_inv.IIT_CHR_ATTRIB60
  ,IIT_CHR_ATTRIB61          = g_inv.IIT_CHR_ATTRIB61
  ,IIT_CHR_ATTRIB62          = g_inv.IIT_CHR_ATTRIB62
  ,IIT_CHR_ATTRIB63          = g_inv.IIT_CHR_ATTRIB63
  ,IIT_CHR_ATTRIB64          = g_inv.IIT_CHR_ATTRIB64
  ,IIT_CHR_ATTRIB65          = g_inv.IIT_CHR_ATTRIB65
  ,IIT_CHR_ATTRIB66          = g_inv.IIT_CHR_ATTRIB66
  ,IIT_CHR_ATTRIB67          = g_inv.IIT_CHR_ATTRIB67
  ,IIT_CHR_ATTRIB68          = g_inv.IIT_CHR_ATTRIB68
  ,IIT_CHR_ATTRIB69          = g_inv.IIT_CHR_ATTRIB69
  ,IIT_CHR_ATTRIB70          = g_inv.IIT_CHR_ATTRIB70
  ,IIT_CHR_ATTRIB71          = g_inv.IIT_CHR_ATTRIB71
  ,IIT_CHR_ATTRIB72          = g_inv.IIT_CHR_ATTRIB72
  ,IIT_CHR_ATTRIB73          = g_inv.IIT_CHR_ATTRIB73
  ,IIT_CHR_ATTRIB74          = g_inv.IIT_CHR_ATTRIB74
  ,IIT_CHR_ATTRIB75          = g_inv.IIT_CHR_ATTRIB75
  ,IIT_NUM_ATTRIB76          = g_inv.IIT_NUM_ATTRIB76
  ,IIT_NUM_ATTRIB77          = g_inv.IIT_NUM_ATTRIB77
  ,IIT_NUM_ATTRIB78          = g_inv.IIT_NUM_ATTRIB78
  ,IIT_NUM_ATTRIB79          = g_inv.IIT_NUM_ATTRIB79
  ,IIT_NUM_ATTRIB80          = g_inv.IIT_NUM_ATTRIB80
  ,IIT_NUM_ATTRIB81          = g_inv.IIT_NUM_ATTRIB81
  ,IIT_NUM_ATTRIB82          = g_inv.IIT_NUM_ATTRIB82
  ,IIT_NUM_ATTRIB83          = g_inv.IIT_NUM_ATTRIB83
  ,IIT_NUM_ATTRIB84          = g_inv.IIT_NUM_ATTRIB84
  ,IIT_NUM_ATTRIB85          = g_inv.IIT_NUM_ATTRIB85
  ,IIT_DATE_ATTRIB86         = g_inv.IIT_DATE_ATTRIB86
  ,IIT_DATE_ATTRIB87         = g_inv.IIT_DATE_ATTRIB87
  ,IIT_DATE_ATTRIB88         = g_inv.IIT_DATE_ATTRIB88
  ,IIT_DATE_ATTRIB89         = g_inv.IIT_DATE_ATTRIB89
  ,IIT_DATE_ATTRIB90         = g_inv.IIT_DATE_ATTRIB90
  ,IIT_DATE_ATTRIB91         = g_inv.IIT_DATE_ATTRIB91
  ,IIT_DATE_ATTRIB92         = g_inv.IIT_DATE_ATTRIB92
  ,IIT_DATE_ATTRIB93         = g_inv.IIT_DATE_ATTRIB93
  ,IIT_DATE_ATTRIB94         = g_inv.IIT_DATE_ATTRIB94
  ,IIT_DATE_ATTRIB95         = g_inv.IIT_DATE_ATTRIB95
  ,IIT_ANGLE                 = g_inv.IIT_ANGLE
  ,IIT_ANGLE_TXT             = g_inv.IIT_ANGLE_TXT
  ,IIT_CLASS                 = g_inv.IIT_CLASS
  ,IIT_CLASS_TXT             = g_inv.IIT_CLASS_TXT
  ,IIT_COLOUR                = g_inv.IIT_COLOUR
  ,IIT_COLOUR_TXT            = g_inv.IIT_COLOUR_TXT
  ,IIT_COORD_FLAG            = g_inv.IIT_COORD_FLAG
  ,IIT_DESCRIPTION           = g_inv.IIT_DESCRIPTION
  ,IIT_DIAGRAM               = g_inv.IIT_DIAGRAM
  ,IIT_DISTANCE              = g_inv.IIT_DISTANCE
  ,IIT_END_CHAIN             = g_inv.IIT_END_CHAIN
  ,IIT_GAP                   = g_inv.IIT_GAP
  ,IIT_HEIGHT                = g_inv.IIT_HEIGHT
  ,IIT_HEIGHT_2              = g_inv.IIT_HEIGHT_2
  ,IIT_ID_CODE               = g_inv.IIT_ID_CODE
  ,IIT_INSTAL_DATE           = g_inv.IIT_INSTAL_DATE
  ,IIT_INVENT_DATE           = g_inv.IIT_INVENT_DATE
  ,IIT_INV_OWNERSHIP         = g_inv.IIT_INV_OWNERSHIP
  ,IIT_ITEMCODE              = g_inv.IIT_ITEMCODE
  ,IIT_LCO_LAMP_CONFIG_ID    = g_inv.IIT_LCO_LAMP_CONFIG_ID
  ,IIT_LENGTH                = g_inv.IIT_LENGTH
  ,IIT_MATERIAL              = g_inv.IIT_MATERIAL
  ,IIT_MATERIAL_TXT          = g_inv.IIT_MATERIAL_TXT
  ,IIT_METHOD                = g_inv.IIT_METHOD
  ,IIT_METHOD_TXT            = g_inv.IIT_METHOD_TXT
  ,IIT_NOTE                  = g_inv.IIT_NOTE
  ,IIT_NO_OF_UNITS           = g_inv.IIT_NO_OF_UNITS
  ,IIT_OPTIONS               = g_inv.IIT_OPTIONS
  ,IIT_OPTIONS_TXT           = g_inv.IIT_OPTIONS_TXT
  ,IIT_OUN_ORG_ID_ELEC_BOARD = g_inv.IIT_OUN_ORG_ID_ELEC_BOARD
  ,IIT_OWNER                 = g_inv.IIT_OWNER
  ,IIT_OWNER_TXT             = g_inv.IIT_OWNER_TXT
  ,IIT_PEO_INVENT_BY_ID      = g_inv.IIT_PEO_INVENT_BY_ID
  ,IIT_PHOTO                 = g_inv.IIT_PHOTO
  ,IIT_POWER                 = g_inv.IIT_POWER
  ,IIT_PROV_FLAG             = g_inv.IIT_PROV_FLAG
  ,IIT_REV_BY                = g_inv.IIT_REV_BY
  ,IIT_REV_DATE              = g_inv.IIT_REV_DATE
  ,IIT_TYPE                  = g_inv.IIT_TYPE
  ,IIT_TYPE_TXT              = g_inv.IIT_TYPE_TXT
  ,IIT_WIDTH                 = g_inv.IIT_WIDTH
  ,IIT_XTRA_CHAR_1           = g_inv.IIT_XTRA_CHAR_1
  ,IIT_XTRA_DATE_1           = g_inv.IIT_XTRA_DATE_1
  ,IIT_XTRA_DOMAIN_1         = g_inv.IIT_XTRA_DOMAIN_1
  ,IIT_XTRA_DOMAIN_TXT_1     = g_inv.IIT_XTRA_DOMAIN_TXT_1
  ,IIT_XTRA_NUMBER_1         = g_inv.IIT_XTRA_NUMBER_1
  ,IIT_X_SECT                = g_inv.IIT_X_SECT
  ,IIT_DET_XSP               = g_inv.IIT_DET_XSP
  ,IIT_OFFSET                = g_inv.IIT_OFFSET
  ,IIT_X                     = g_inv.IIT_X
  ,IIT_Y                     = g_inv.IIT_Y
  ,IIT_Z                     = g_inv.IIT_Z
  ,IIT_NUM_ATTRIB96          = g_inv.IIT_NUM_ATTRIB96
  ,IIT_NUM_ATTRIB97          = g_inv.IIT_NUM_ATTRIB97
  ,IIT_NUM_ATTRIB98          = g_inv.IIT_NUM_ATTRIB98
  ,IIT_NUM_ATTRIB99          = g_inv.IIT_NUM_ATTRIB99
  ,IIT_NUM_ATTRIB100         = g_inv.IIT_NUM_ATTRIB100
  ,IIT_NUM_ATTRIB101         = g_inv.IIT_NUM_ATTRIB101
  ,IIT_NUM_ATTRIB102         = g_inv.IIT_NUM_ATTRIB102
  ,IIT_NUM_ATTRIB103         = g_inv.IIT_NUM_ATTRIB103
  ,IIT_NUM_ATTRIB104         = g_inv.IIT_NUM_ATTRIB104
  ,IIT_NUM_ATTRIB105         = g_inv.IIT_NUM_ATTRIB105
  ,IIT_NUM_ATTRIB106         = g_inv.IIT_NUM_ATTRIB106
  ,IIT_NUM_ATTRIB107         = g_inv.IIT_NUM_ATTRIB107
  ,IIT_NUM_ATTRIB108         = g_inv.IIT_NUM_ATTRIB108
  ,IIT_NUM_ATTRIB109         = g_inv.IIT_NUM_ATTRIB109
  ,IIT_NUM_ATTRIB110         = g_inv.IIT_NUM_ATTRIB110
  ,IIT_NUM_ATTRIB111         = g_inv.IIT_NUM_ATTRIB111
  ,IIT_NUM_ATTRIB112         = g_inv.IIT_NUM_ATTRIB112
  ,IIT_NUM_ATTRIB113         = g_inv.IIT_NUM_ATTRIB113
  ,IIT_NUM_ATTRIB114         = g_inv.IIT_NUM_ATTRIB114
  ,IIT_NUM_ATTRIB115         = g_inv.IIT_NUM_ATTRIB115
  WHERE iit_ne_id = g_inv.iit_ne_id;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                     ,p_procedure_name => 'update_changed_attributes');
END update_changed_attributes;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_inv (p_inv_rec IN nm_ld_mc_all_inv_tmp%ROWTYPE) IS
   c_eff_date CONSTANT DATE := nm3user.get_effective_date;
--
   e_inventory_changed EXCEPTION;
   l_temp_ne_id        NUMBER;
   l_warning_code      VARCHAR2(80);
   l_warning_msg       nm3type.max_varchar2;
   l_effective_date    DATE    := TRUNC(p_inv_rec.NLM_INVENT_DATE);

   -- LS
   l_iit_tab nm3type.tab_rec_iit ;
   l_iit_rec nm_inv_items%ROWTYPE ;
   l_nit_rec nm_inv_types%rowtype;   
--
   l_itg_row    nm_inv_type_groupings%rowtype;
   l_parent_id  nm_inv_items.iit_ne_id%type;
   
   l_locate_flag Boolean := TRUE;
--
BEGIN
   nm_debug.proc_start(p_package_name   => g_package_name
                      ,p_procedure_name => 'ins_inv');   
  
  -- set the items survey date to be the effective date
  nm3user.set_effective_date(l_effective_date);
  
  g_inv.IIT_NE_ID                 := p_inv_rec.IIT_NE_ID;
  g_inv.IIT_INV_TYPE              := p_inv_rec.IIT_INV_TYPE;
  g_inv.IIT_PRIMARY_KEY           := NVL(p_inv_rec.NLM_PRIMARY_KEY, p_inv_rec.IIT_PRIMARY_KEY);  -- use the one populated by MapCapture
  g_inv.IIT_START_DATE            := p_inv_rec.IIT_START_DATE;
  g_inv.IIT_DATE_CREATED          := p_inv_rec.IIT_DATE_CREATED;
  g_inv.IIT_DATE_MODIFIED         := p_inv_rec.IIT_DATE_MODIFIED;
  g_inv.IIT_CREATED_BY            := p_inv_rec.IIT_CREATED_BY;
  g_inv.IIT_MODIFIED_BY           := p_inv_rec.IIT_MODIFIED_BY;
  g_inv.IIT_ADMIN_UNIT            := p_inv_rec.IIT_ADMIN_UNIT;
  g_inv.IIT_DESCR                 := p_inv_rec.IIT_DESCR;
  -- Dont set end date here as it messes up homo update
  -- end dating is dealt with after homo update
--  g_inv.IIT_END_DATE              := p_inv_rec.IIT_END_DATE;
  g_inv.IIT_FOREIGN_KEY           := p_inv_rec.IIT_FOREIGN_KEY;
  g_inv.IIT_LOCATED_BY            := p_inv_rec.IIT_LOCATED_BY;
  g_inv.IIT_POSITION              := p_inv_rec.IIT_POSITION;
  g_inv.IIT_X_COORD               := p_inv_rec.IIT_X_COORD;
  g_inv.IIT_Y_COORD               := p_inv_rec.IIT_Y_COORD;
  g_inv.IIT_NUM_ATTRIB16          := p_inv_rec.IIT_NUM_ATTRIB16;
  g_inv.IIT_NUM_ATTRIB17          := p_inv_rec.IIT_NUM_ATTRIB17;
  g_inv.IIT_NUM_ATTRIB18          := p_inv_rec.IIT_NUM_ATTRIB18;
  g_inv.IIT_NUM_ATTRIB19          := p_inv_rec.IIT_NUM_ATTRIB19;
  g_inv.IIT_NUM_ATTRIB20          := p_inv_rec.IIT_NUM_ATTRIB20;
  g_inv.IIT_NUM_ATTRIB21          := p_inv_rec.IIT_NUM_ATTRIB21;
  g_inv.IIT_NUM_ATTRIB22          := p_inv_rec.IIT_NUM_ATTRIB22;
  g_inv.IIT_NUM_ATTRIB23          := p_inv_rec.IIT_NUM_ATTRIB23;
  g_inv.IIT_NUM_ATTRIB24          := p_inv_rec.IIT_NUM_ATTRIB24;
  g_inv.IIT_NUM_ATTRIB25          := p_inv_rec.IIT_NUM_ATTRIB25;
  g_inv.IIT_CHR_ATTRIB26          := p_inv_rec.IIT_CHR_ATTRIB26;
  g_inv.IIT_CHR_ATTRIB27          := p_inv_rec.IIT_CHR_ATTRIB27;
  g_inv.IIT_CHR_ATTRIB28          := p_inv_rec.IIT_CHR_ATTRIB28;
  g_inv.IIT_CHR_ATTRIB29          := p_inv_rec.IIT_CHR_ATTRIB29;
  g_inv.IIT_CHR_ATTRIB30          := p_inv_rec.IIT_CHR_ATTRIB30;
  g_inv.IIT_CHR_ATTRIB31          := p_inv_rec.IIT_CHR_ATTRIB31;
  g_inv.IIT_CHR_ATTRIB32          := p_inv_rec.IIT_CHR_ATTRIB32;
  g_inv.IIT_CHR_ATTRIB33          := p_inv_rec.IIT_CHR_ATTRIB33;
  g_inv.IIT_CHR_ATTRIB34          := p_inv_rec.IIT_CHR_ATTRIB34;
  g_inv.IIT_CHR_ATTRIB35          := p_inv_rec.IIT_CHR_ATTRIB35;
  g_inv.IIT_CHR_ATTRIB36          := p_inv_rec.IIT_CHR_ATTRIB36;
  g_inv.IIT_CHR_ATTRIB37          := p_inv_rec.IIT_CHR_ATTRIB37;
  g_inv.IIT_CHR_ATTRIB38          := p_inv_rec.IIT_CHR_ATTRIB38;
  g_inv.IIT_CHR_ATTRIB39          := p_inv_rec.IIT_CHR_ATTRIB39;
  g_inv.IIT_CHR_ATTRIB40          := p_inv_rec.IIT_CHR_ATTRIB40;
  g_inv.IIT_CHR_ATTRIB41          := p_inv_rec.IIT_CHR_ATTRIB41;
  g_inv.IIT_CHR_ATTRIB42          := p_inv_rec.IIT_CHR_ATTRIB42;
  g_inv.IIT_CHR_ATTRIB43          := p_inv_rec.IIT_CHR_ATTRIB43;
  g_inv.IIT_CHR_ATTRIB44          := p_inv_rec.IIT_CHR_ATTRIB44;
  g_inv.IIT_CHR_ATTRIB45          := p_inv_rec.IIT_CHR_ATTRIB45;
  g_inv.IIT_CHR_ATTRIB46          := p_inv_rec.IIT_CHR_ATTRIB46;
  g_inv.IIT_CHR_ATTRIB47          := p_inv_rec.IIT_CHR_ATTRIB47;
  g_inv.IIT_CHR_ATTRIB48          := p_inv_rec.IIT_CHR_ATTRIB48;
  g_inv.IIT_CHR_ATTRIB49          := p_inv_rec.IIT_CHR_ATTRIB49;
  g_inv.IIT_CHR_ATTRIB50          := p_inv_rec.IIT_CHR_ATTRIB50;
  g_inv.IIT_CHR_ATTRIB51          := p_inv_rec.IIT_CHR_ATTRIB51;
  g_inv.IIT_CHR_ATTRIB52          := p_inv_rec.IIT_CHR_ATTRIB52;
  g_inv.IIT_CHR_ATTRIB53          := p_inv_rec.IIT_CHR_ATTRIB53;
  g_inv.IIT_CHR_ATTRIB54          := p_inv_rec.IIT_CHR_ATTRIB54;
  g_inv.IIT_CHR_ATTRIB55          := p_inv_rec.IIT_CHR_ATTRIB55;
  g_inv.IIT_CHR_ATTRIB56          := p_inv_rec.IIT_CHR_ATTRIB56;
  g_inv.IIT_CHR_ATTRIB57          := p_inv_rec.IIT_CHR_ATTRIB57;
  g_inv.IIT_CHR_ATTRIB58          := p_inv_rec.IIT_CHR_ATTRIB58;
  g_inv.IIT_CHR_ATTRIB59          := p_inv_rec.IIT_CHR_ATTRIB59;
  g_inv.IIT_CHR_ATTRIB60          := p_inv_rec.IIT_CHR_ATTRIB60;
  g_inv.IIT_CHR_ATTRIB61          := p_inv_rec.IIT_CHR_ATTRIB61;
  g_inv.IIT_CHR_ATTRIB62          := p_inv_rec.IIT_CHR_ATTRIB62;
  g_inv.IIT_CHR_ATTRIB63          := p_inv_rec.IIT_CHR_ATTRIB63;
  g_inv.IIT_CHR_ATTRIB64          := p_inv_rec.IIT_CHR_ATTRIB64;
  g_inv.IIT_CHR_ATTRIB65          := p_inv_rec.IIT_CHR_ATTRIB65;
  g_inv.IIT_CHR_ATTRIB66          := p_inv_rec.IIT_CHR_ATTRIB66;
  g_inv.IIT_CHR_ATTRIB67          := p_inv_rec.IIT_CHR_ATTRIB67;
  g_inv.IIT_CHR_ATTRIB68          := p_inv_rec.IIT_CHR_ATTRIB68;
  g_inv.IIT_CHR_ATTRIB69          := p_inv_rec.IIT_CHR_ATTRIB69;
  g_inv.IIT_CHR_ATTRIB70          := p_inv_rec.IIT_CHR_ATTRIB70;
  g_inv.IIT_CHR_ATTRIB71          := p_inv_rec.IIT_CHR_ATTRIB71;
  g_inv.IIT_CHR_ATTRIB72          := p_inv_rec.IIT_CHR_ATTRIB72;
  g_inv.IIT_CHR_ATTRIB73          := p_inv_rec.IIT_CHR_ATTRIB73;
  g_inv.IIT_CHR_ATTRIB74          := p_inv_rec.IIT_CHR_ATTRIB74;
  g_inv.IIT_CHR_ATTRIB75          := p_inv_rec.IIT_CHR_ATTRIB75;
  g_inv.IIT_NUM_ATTRIB76          := p_inv_rec.IIT_NUM_ATTRIB76;
  g_inv.IIT_NUM_ATTRIB77          := p_inv_rec.IIT_NUM_ATTRIB77;
  g_inv.IIT_NUM_ATTRIB78          := p_inv_rec.IIT_NUM_ATTRIB78;
  g_inv.IIT_NUM_ATTRIB79          := p_inv_rec.IIT_NUM_ATTRIB79;
  g_inv.IIT_NUM_ATTRIB80          := p_inv_rec.IIT_NUM_ATTRIB80;
  g_inv.IIT_NUM_ATTRIB81          := p_inv_rec.IIT_NUM_ATTRIB81;
  g_inv.IIT_NUM_ATTRIB82          := p_inv_rec.IIT_NUM_ATTRIB82;
  g_inv.IIT_NUM_ATTRIB83          := p_inv_rec.IIT_NUM_ATTRIB83;
  g_inv.IIT_NUM_ATTRIB84          := p_inv_rec.IIT_NUM_ATTRIB84;
  g_inv.IIT_NUM_ATTRIB85          := p_inv_rec.IIT_NUM_ATTRIB85;
  g_inv.IIT_DATE_ATTRIB86         := p_inv_rec.IIT_DATE_ATTRIB86;
  g_inv.IIT_DATE_ATTRIB87         := p_inv_rec.IIT_DATE_ATTRIB87;
  g_inv.IIT_DATE_ATTRIB88         := p_inv_rec.IIT_DATE_ATTRIB88;
  g_inv.IIT_DATE_ATTRIB89         := p_inv_rec.IIT_DATE_ATTRIB89;
  g_inv.IIT_DATE_ATTRIB90         := p_inv_rec.IIT_DATE_ATTRIB90;
  g_inv.IIT_DATE_ATTRIB91         := p_inv_rec.IIT_DATE_ATTRIB91;
  g_inv.IIT_DATE_ATTRIB92         := p_inv_rec.IIT_DATE_ATTRIB92;
  g_inv.IIT_DATE_ATTRIB93         := p_inv_rec.IIT_DATE_ATTRIB93;
  g_inv.IIT_DATE_ATTRIB94         := p_inv_rec.IIT_DATE_ATTRIB94;
  g_inv.IIT_DATE_ATTRIB95         := p_inv_rec.IIT_DATE_ATTRIB95;
  g_inv.IIT_ANGLE                 := p_inv_rec.IIT_ANGLE;
  g_inv.IIT_ANGLE_TXT             := p_inv_rec.IIT_ANGLE_TXT;
  g_inv.IIT_CLASS                 := p_inv_rec.IIT_CLASS;
  g_inv.IIT_CLASS_TXT             := p_inv_rec.IIT_CLASS_TXT;
  g_inv.IIT_COLOUR                := p_inv_rec.IIT_COLOUR;
  g_inv.IIT_COLOUR_TXT            := p_inv_rec.IIT_COLOUR_TXT;
  g_inv.IIT_COORD_FLAG            := p_inv_rec.IIT_COORD_FLAG;
  g_inv.IIT_DESCRIPTION           := p_inv_rec.IIT_DESCRIPTION;
  g_inv.IIT_DIAGRAM               := p_inv_rec.IIT_DIAGRAM;
  g_inv.IIT_DISTANCE              := p_inv_rec.IIT_DISTANCE;
  g_inv.IIT_END_CHAIN             := p_inv_rec.IIT_END_CHAIN;
  g_inv.IIT_GAP                   := p_inv_rec.IIT_GAP;
  g_inv.IIT_HEIGHT                := p_inv_rec.IIT_HEIGHT;
  g_inv.IIT_HEIGHT_2              := p_inv_rec.IIT_HEIGHT_2;
  g_inv.IIT_ID_CODE               := p_inv_rec.IIT_ID_CODE;
  g_inv.IIT_INSTAL_DATE           := p_inv_rec.IIT_INSTAL_DATE;
  g_inv.IIT_INVENT_DATE           := p_inv_rec.NLM_INVENT_DATE; -- use the one populated by MapCapture
  g_inv.IIT_INV_OWNERSHIP         := p_inv_rec.IIT_INV_OWNERSHIP;
  g_inv.IIT_ITEMCODE              := p_inv_rec.IIT_ITEMCODE;
  g_inv.IIT_LCO_LAMP_CONFIG_ID    := p_inv_rec.IIT_LCO_LAMP_CONFIG_ID;
  g_inv.IIT_LENGTH                := p_inv_rec.IIT_LENGTH;
  g_inv.IIT_MATERIAL              := p_inv_rec.IIT_MATERIAL;
  g_inv.IIT_MATERIAL_TXT          := p_inv_rec.IIT_MATERIAL_TXT;
  g_inv.IIT_METHOD                := p_inv_rec.IIT_METHOD;
  g_inv.IIT_METHOD_TXT            := p_inv_rec.IIT_METHOD_TXT;
  g_inv.IIT_NOTE                  := p_inv_rec.IIT_NOTE;
  g_inv.IIT_NO_OF_UNITS           := p_inv_rec.IIT_NO_OF_UNITS;
  g_inv.IIT_OPTIONS               := p_inv_rec.IIT_OPTIONS;
  g_inv.IIT_OPTIONS_TXT           := p_inv_rec.IIT_OPTIONS_TXT;
  g_inv.IIT_OUN_ORG_ID_ELEC_BOARD := p_inv_rec.IIT_OUN_ORG_ID_ELEC_BOARD;
  g_inv.IIT_OWNER                 := p_inv_rec.IIT_OWNER;
  g_inv.IIT_OWNER_TXT             := p_inv_rec.IIT_OWNER_TXT;
  g_inv.IIT_PEO_INVENT_BY_ID      := p_inv_rec.IIT_PEO_INVENT_BY_ID;
  g_inv.IIT_PHOTO                 := p_inv_rec.IIT_PHOTO;
  g_inv.IIT_POWER                 := p_inv_rec.IIT_POWER;
  g_inv.IIT_PROV_FLAG             := p_inv_rec.IIT_PROV_FLAG;
  g_inv.IIT_REV_BY                := p_inv_rec.IIT_REV_BY;
  g_inv.IIT_REV_DATE              := p_inv_rec.IIT_REV_DATE;
  g_inv.IIT_TYPE                  := p_inv_rec.IIT_TYPE;
  g_inv.IIT_TYPE_TXT              := p_inv_rec.IIT_TYPE_TXT;
  g_inv.IIT_WIDTH                 := p_inv_rec.IIT_WIDTH;
  g_inv.IIT_XTRA_CHAR_1           := p_inv_rec.IIT_XTRA_CHAR_1;
  g_inv.IIT_XTRA_DATE_1           := p_inv_rec.IIT_XTRA_DATE_1;
  g_inv.IIT_XTRA_DOMAIN_1         := p_inv_rec.IIT_XTRA_DOMAIN_1;
  g_inv.IIT_XTRA_DOMAIN_TXT_1     := p_inv_rec.IIT_XTRA_DOMAIN_TXT_1;
  g_inv.IIT_XTRA_NUMBER_1         := p_inv_rec.IIT_XTRA_NUMBER_1;
  g_inv.IIT_X_SECT                := p_inv_rec.NLM_X_SECT; -- use the one populated by MapCapture
  g_inv.IIT_DET_XSP               := p_inv_rec.IIT_DET_XSP;
  g_inv.IIT_OFFSET                := p_inv_rec.IIT_OFFSET;
  g_inv.IIT_X                     := p_inv_rec.IIT_X;
  g_inv.IIT_Y                     := p_inv_rec.IIT_Y;
  g_inv.IIT_Z                     := p_inv_rec.IIT_Z;
  g_inv.IIT_NUM_ATTRIB96          := p_inv_rec.IIT_NUM_ATTRIB96;
  g_inv.IIT_NUM_ATTRIB97          := p_inv_rec.IIT_NUM_ATTRIB97;
  g_inv.IIT_NUM_ATTRIB98          := p_inv_rec.IIT_NUM_ATTRIB98;
  g_inv.IIT_NUM_ATTRIB99          := p_inv_rec.IIT_NUM_ATTRIB99;
  g_inv.IIT_NUM_ATTRIB100         := p_inv_rec.IIT_NUM_ATTRIB100;
  g_inv.IIT_NUM_ATTRIB101         := p_inv_rec.IIT_NUM_ATTRIB101;
  g_inv.IIT_NUM_ATTRIB102         := p_inv_rec.IIT_NUM_ATTRIB102;
  g_inv.IIT_NUM_ATTRIB103         := p_inv_rec.IIT_NUM_ATTRIB103;
  g_inv.IIT_NUM_ATTRIB104         := p_inv_rec.IIT_NUM_ATTRIB104;
  g_inv.IIT_NUM_ATTRIB105         := p_inv_rec.IIT_NUM_ATTRIB105;
  g_inv.IIT_NUM_ATTRIB106         := p_inv_rec.IIT_NUM_ATTRIB106;
  g_inv.IIT_NUM_ATTRIB107         := p_inv_rec.IIT_NUM_ATTRIB107;
  g_inv.IIT_NUM_ATTRIB108         := p_inv_rec.IIT_NUM_ATTRIB108;
  g_inv.IIT_NUM_ATTRIB109         := p_inv_rec.IIT_NUM_ATTRIB109;
  g_inv.IIT_NUM_ATTRIB110         := p_inv_rec.IIT_NUM_ATTRIB110;
  g_inv.IIT_NUM_ATTRIB111         := p_inv_rec.IIT_NUM_ATTRIB111;
  g_inv.IIT_NUM_ATTRIB112         := p_inv_rec.IIT_NUM_ATTRIB112;
  g_inv.IIT_NUM_ATTRIB113         := p_inv_rec.IIT_NUM_ATTRIB113;
  g_inv.IIT_NUM_ATTRIB114         := p_inv_rec.IIT_NUM_ATTRIB114;
  g_inv.IIT_NUM_ATTRIB115         := p_inv_rec.IIT_NUM_ATTRIB115;

--
  DELETE FROM nm_nw_temp_extents;
--
  --
  -- LS Added this code to hanlde the child asset which have been added as a result of parent been replaced
  IF g_inv.iit_ne_id != -1 
  THEN
      DECLARE
      --
         l_iit_rec nm_inv_items%ROWTYPE ;   
      --
      BEGIN
      --
         l_iit_rec := nm3get.get_iit( g_inv.iit_ne_id);       
      --
      EXCEPTION
          WHEN OTHERS
          THEN
              BEGIN
              --
                 l_iit_rec := nm3get.get_iit_all( g_inv.iit_ne_id);
                 g_inv.iit_ne_id := -1 ;
                 populate_enddated_child_items(p_inv_rec.batch_no,p_inv_rec.iit_ne_id);
              --
              EXCEPTION
                  WHEN OTHERS
                  THEN
                      RAISE_APPLICATION_ERROR(-20000, hig.raise_and_catch_ner(pi_appl => nm3type.c_hig
                                                                             ,pi_id   => 67));
              END ;
      END ;
  --
  END IF ;

  l_nit_rec := nm3get.get_nit( p_inv_rec.iit_inv_type );

  l_parent_id := NULL;
  
  if p_inv_rec.iit_foreign_key is not null then 

    get_parent_info ( p_foreign_key => p_inv_rec.iit_foreign_key,
                      p_child_type  => p_inv_rec.iit_inv_type,
                      p_itg_row     => l_itg_row,
                      p_parent_id   => l_parent_id );
  end if;
  
  if p_inv_rec.ne_id is null then  -- no nw - can we get it from the hierarchy
  
    if l_parent_id is null and nm3inv.inv_location_is_mandatory(p_inv_rec.iit_inv_type) then
  
      raise_application_error( -20001, 'Failure - no hierarchy or location and location is mandatory');

    else
    
      l_locate_flag := FALSE;
      
    end if;

  else
--  we have a location - but it should be overridden by parent where it exists 

    if l_parent_id is not null and l_itg_row.itg_relation = 'AT' then
      
      l_locate_flag := FALSE;
      
    end if;
  end if;

  IF l_locate_flag THEN
 
    nm3extent.create_temp_ne
        (pi_source_id => p_inv_rec.ne_id
        ,pi_source    => nm3extent.c_route
        ,pi_begin_mp  => p_inv_rec.nm_start
        ,pi_end_mp    => p_inv_rec.nm_end
        ,po_job_id    => l_temp_ne_id
        );

  END IF;		
   
  IF g_inv.iit_ne_id = -1 THEN 
    nm_debug.debug('Insert Inv Item');

    g_inv.iit_start_date  := l_effective_date;
    g_inv.iit_ne_id       := nm3net.get_next_ne_id;
    
    IF g_inv.iit_primary_key = '-1' THEN
      g_inv.iit_primary_key := g_inv.iit_ne_id;
    END IF;
    
    nm3inv.insert_nm_inv_items (g_inv);
    --
    IF p_inv_rec.iit_ne_id != -1
    THEN
        FOR i IN 1..l_iit_id_tab1.Count
        LOOP                  
            IF l_iit_id_tab1(i) IS NOT NULL
            THEN
                l_iit_rec := nm3get.get_iit_all(l_iit_id_tab1(i));
                l_iit_rec.iit_ne_id  := nm3net.get_next_ne_id;
                l_iit_rec.iit_start_date := l_effective_date; 
                l_iit_rec.iit_end_date := Null; 
                BEGIN
                   nm3ins.ins_iit_all (l_iit_rec);
                EXCEPTION
                WHEN OTHERS 
                THEN
                    nm_debug.debug('Error While loading Mandatory Child records '||SQLERRM||' Primary Key - '||l_iit_rec.iit_primary_key||' Start Date '||l_iit_rec.iit_start_date) ;   
                    Raise ;        
                END ;
            END IF ;
       END LOOP;
       l_iit_id_tab1.delete;
    END IF ;
  ELSE
    
    -- has inventory item been changed since the item was output to MapCapture
    -- if the record has a status of conflict resolved then dont do the check 
    IF inventory_changed_since(p_inv_item => g_inv.iit_ne_id
                              ,p_since    => g_inv.iit_date_modified)
       AND NOT conflict_resolved(p_batch_no  => p_inv_rec.batch_no
                                ,p_record_no => p_inv_rec.record_no) 
    THEN
       RAISE e_inventory_changed;
    END IF;
  
    --
    -- only end date if the item needs it
    -- or if the action is a replace instead of update
    nm3lock.lock_inv_item(pi_iit_ne_id      => g_inv.iit_ne_id
                         ,p_lock_for_update => TRUE);

    IF p_inv_rec.nlm_action_code = 'R' OR
       date_track_attributes(p_iit_id => p_inv_rec.iit_ne_id) 
    THEN
        IF p_inv_rec.iit_end_date IS NULL
        THEN
            nm_debug.debug('End Dating');
            -- need new start date, start date should be the survey date
            g_inv.iit_ne_id       := NULL;
            g_inv.iit_start_date  := l_effective_date;            
            populate_child_items(p_inv_rec.batch_no,p_inv_rec.iit_ne_id);
            nm3inv_update.date_track_update_item(pi_iit_ne_id_old => p_inv_rec.iit_ne_id
                                                ,pio_rec_iit      => g_inv);
            BEGIN                   
            -- 
               FOR i IN 1..l_iit_id_tab1.Count
               LOOP                  
                   IF l_iit_id_tab1(i) IS NOT NULL
                   THEN
                       l_iit_rec := nm3get.get_iit_all(l_iit_id_tab1(i));
                       l_iit_rec.iit_ne_id  := nm3net.get_next_ne_id;
                       l_iit_rec.iit_start_date := l_effective_date; 
                       l_iit_rec.iit_end_date := Null; 
                       BEGIN
                          nm3ins.ins_iit_all (l_iit_rec);
                       EXCEPTION
                       WHEN OTHERS 
                       THEN
                           nm_debug.debug('Error While loading Mandatory Child records '||SQLERRM||' Primary Key - '||l_iit_rec.iit_primary_key||' Start Date '||l_iit_rec.iit_start_date) ;   
                           Raise ;        
                       END ;
                   END IF ;
               END LOOP;  
               l_iit_id_tab1.delete;       
            END ;
        ELSE
            update_changed_attributes;
        END IF ;
    ELSE
      -- just update the record
      update_changed_attributes;
    END IF;

--
  END IF;
--
  IF l_locate_flag THEN

    IF l_temp_ne_id = -1 THEN
      nm_debug.debug('ne_id is -1');
      nm3homo.end_inv_location( pi_iit_ne_id      => g_inv.iit_ne_id
                               ,pi_effective_date => l_effective_date
                               ,po_warning_code   => l_warning_code 
                               ,po_warning_msg    => l_warning_msg
                               ,pi_ignore_item_loc_mand => TRUE
                              );
    ELSE   
      nm_debug.debug('Ne_id is something, doing update');
      nm3homo.homo_update
        (p_temp_ne_id_in  => l_temp_ne_id
        ,p_iit_ne_id      => g_inv.iit_ne_id
        ,p_effective_date => l_effective_date
        ,p_warning_code   => l_warning_code
        ,p_warning_msg    => l_warning_msg);
    END IF;
  
  END IF;
  
  IF p_inv_rec.iit_end_date IS NOT NULL THEN
    nm3api_inv.end_date_item(p_iit_ne_id      => g_inv.iit_ne_id
                            ,p_effective_date => nm3user.get_effective_date);
  END IF;

-- no errors then clear the error flag
  clear_batch_error(p_batch_no  => p_inv_rec.batch_no
                   ,p_record_no => p_inv_rec.record_no);

  nm3user.set_effective_date(c_eff_date);
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'ins_inv');
--
EXCEPTION 
  WHEN e_inventory_changed THEN
    conflict_batch_error(p_batch_no  => p_inv_rec.batch_no
                        ,p_record_no => p_inv_rec.record_no);

    nm3user.set_effective_date(c_eff_date);
    RAISE_APPLICATION_ERROR(-20000, hig.raise_and_catch_ner(pi_appl => nm3type.c_hig
                                                           ,pi_id   => 208));
    
  WHEN OTHERS THEN
    general_batch_error(p_batch_no  => p_inv_rec.batch_no
                       ,p_record_no => p_inv_rec.record_no);

    nm3user.set_effective_date(c_eff_date);
    RAISE; 
END ins_inv;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_child_records (pi_iit_primary_key NM_LD_MC_ALL_INV_TMP.iit_primary_key%TYPE
                               ,pi_batch_no     NM_LD_MC_ALL_INV_TMP.batch_no%TYPE)
IS
   PRAGMA autonomous_transaction;
BEGIN
   UPDATE nm_load_batch_status
   SET    nlbs_status = 'E'
         ,nlbs_text = 'Parent failed'
   WHERE  nlbs_nlb_batch_no = pi_batch_no 
   AND    nlbs_record_no IN (SELECT record_no from NM_LD_MC_ALL_INV_TMP a
                             WHERE  iit_primary_key     != pi_iit_primary_key
                             AND batch_no                = pi_batch_no 
                             CONNECT BY iit_foreign_key  = prior  iit_primary_key
                             START WITH iit_primary_key  = pi_iit_primary_key);
   COMMIT;
END update_child_records ;
--
PROCEDURE run_batch(pi_batch_no nm_load_batch_status.nlbs_nlb_batch_no%TYPE)
IS
--
   l_cnt Number := 0 ;
--
BEGIN 
--
   nm3mapcapture_ins_inv.l_mapcap_run := 'Y' ;
   nm3mapcapture_ins_inv.l_iit_tab.Delete;
   For i IN (SELECT tab.*
             FROM  NM_LD_MC_ALL_INV_TMP tab
                  ,nm_load_batch_status nlbs
             WHERE  tab.batch_no           = pi_batch_no 
             AND   nlbs.nlbs_nlb_batch_no  = tab.batch_no
             AND   nlbs.nlbs_record_no     = tab.record_no
             AND   nlbs.nlbs_status       IN ('H','V')
             ORDER BY tab.batch_no, tab.record_no)
   LOOP
   --
      l_cnt := l_cnt + 1 ;
      SavePoint tmp1;
      DECLARE
      --
         CURSOR c_nlbs
         IS
         SELECT 'x' 
         FROM   nm_load_batch_status 
         WHERE  nlbs_nlb_batch_no = pi_batch_no
         AND    nlbs_record_no    = i.record_no 
         AND    nlbs_status       = 'E' ;
         l_nlbs c_nlbs%ROWTYPE ; 
      BEGIN
      --
         OPEN  c_nlbs;
         FETCH c_nlbs INTO l_nlbs ; 
         IF c_nlbs%NOTFOUND
         THEN
             NM3MAPCAPTURE_INS_INV.INS_INV(i);
             nm3load.update_status(pi_batch_no,i.record_no ,'I',Null);
             IF MOD (l_cnt,NVL(hig.get_sysopt('PCOMMIT'),100)) = 0
             THEN
                 COMMIT;
             END IF;
         End if; 
      EXCEPTION
      WHEN OTHERS THEN
          Rollback to tmp1; 
          nm3load.update_status(pi_batch_no,i.record_no ,'E',SUBSTR(SQLERRM,1,4000)); 
          update_child_records(i.iit_primary_key,pi_batch_no) ;          
      END  ;
   END LOOP ;
   COMMIT;
   nm3mapcapture_ins_inv.l_mapcap_run := 'N' ;   
   nm3mapcapture_ins_inv.l_iit_tab.Delete;
--
END run_batch ;
--
END nm3mapcapture_ins_inv;
/
