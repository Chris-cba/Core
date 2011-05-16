CREATE OR REPLACE PACKAGE BODY nm3lock AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3lock.pkb-arc   2.4   May 16 2011 14:45:00   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3lock.pkb  $
--       Date into PVCS   : $Date:   May 16 2011 14:45:00  $
--       Date fetched Out : $Modtime:   Apr 01 2011 15:11:34  $
--       PVCS Version     : $Revision:   2.4  $
--       Based on         : 1.16
--
--
--   Author : Jonathan Mills
--
--   NM3 Locking Package body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.4  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3lock';
--
   l_tab_dummy       nm3type.tab_number;
   l_dummy           pls_integer;
   l_ele_rowid       ROWID;
   l_lock_flag_bol   BOOLEAN := g_lock_flag = nm3type.c_yes;
   
   g_updrdonly        hig_option_values.hov_value%TYPE;
--
-----------------------------------------------------------------------------
--
FUNCTION do_dynamic_lock_by_rowtype (p_record_name varchar2
                                    ,p_table_name  varchar2
                                    ,p_tab_cols    nm3type.tab_varchar30
                                    ) RETURN ROWID;
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
PROCEDURE lock_members_by_of (p_nm_ne_id_of IN nm_members.nm_ne_id_of%TYPE) IS
--
   CURSOR cs_mem (p_ne_id_of nm_members.nm_ne_id_of%TYPE) IS
   SELECT 1
    FROM  nm_members
   WHERE  nm_ne_id_of = p_ne_id_of
   FOR UPDATE OF nm_end_date NOWAIT;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_members_by_of');
--
   OPEN  cs_mem (p_nm_ne_id_of);
   FETCH cs_mem BULK COLLECT INTO l_tab_dummy;
   CLOSE cs_mem;
   l_tab_dummy.DELETE;
--
   nm_debug.proc_end(g_package_name,'lock_members_by_of');
--
END lock_members_by_of;
--
-----------------------------------------------------------------------------
--
PROCEDURE lock_members_by_in (p_nm_ne_id_in IN nm_members.nm_ne_id_in%TYPE) IS
--
   CURSOR cs_mem (p_ne_id_in nm_members.nm_ne_id_in%TYPE) IS
   SELECT 1
    FROM  nm_members
   WHERE  nm_ne_id_in = p_ne_id_in
   FOR UPDATE OF nm_end_date NOWAIT;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_members_by_in');
--
   OPEN  cs_mem (p_nm_ne_id_in);
   FETCH cs_mem BULK COLLECT INTO l_tab_dummy;
   CLOSE cs_mem;
   l_tab_dummy.DELETE;
--
   nm_debug.proc_end(g_package_name,'lock_members_by_in');
--
END lock_members_by_in;
--
-----------------------------------------------------------------------------
--
PROCEDURE lock_element (p_ne_id               IN nm_elements.ne_id%TYPE
                       ,p_lock_ele_for_update IN boolean DEFAULT FALSE
					   ,p_updrdonly           IN hig_option_values.hov_value%TYPE DEFAULT NULL
                       ) IS

   l_rowid ROWID;
   l_pk_id nm_elements.ne_id%TYPE;
   l_mode  VARCHAR2(10);
   l_sql   VARCHAR2(2000);
   c1      nm3type.ref_cursor; 

   
--
-- GJ 17-JUL-2006
--
-- Add an extra parameter to the locking procedures - call it UPDRDONLY - exactly as the system option.
-- This should default to NULL and should only be passed the value from the calling programs in the PEM and DEFECT APIs. 
-- If the flag is set to null the option should be ignored. 
-- This will cover-off all occurrences of the call to the locking procedures in existing code. The new code (amended from the patch and the additional triggers on the DAS) will pass in the value of the system option. 
--
   
   
   

BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_element');
--
  l_sql :=         'SELECT nua_mode'||chr(10); 
  l_sql := l_sql|| 'FROM nm_admin_groups'||chr(10);
  l_sql := l_sql|| ',nm_user_aus'||chr(10);
  l_sql := l_sql|| ',nm_elements'||chr(10);
  l_sql := l_sql|| 'WHERE ne_id = :c_ne_id'||chr(10);
  l_sql := l_sql|| 'AND ne_admin_unit = nag_child_admin_unit'||chr(10);
  l_sql := l_sql|| 'AND nag_parent_admin_unit = nua_admin_unit'||chr(10);
  l_sql := l_sql|| 'AND nua_user_id = :c_user_id'||chr(10);
  l_sql := l_sql|| 'ORDER BY nua_mode'||chr(10);

-- GJ 17-JUL-2006 lock for update regardless
-- 
--   IF p_lock_ele_for_update THEN
     l_sql := l_sql|| 'FOR UPDATE of ne_id'; --SM 03092006 710020 added 'of ne_id' so only the nm_elements table gets locked
--   END IF;	    

  OPEN c1 FOR l_sql USING p_ne_id, To_Number(Sys_Context('NM3CORE','USER_ID')) ; 
   
  FETCH c1 INTO l_mode;
  IF c1%NOTFOUND THEN
    CLOSE c1;
    Hig.raise_ner('NET',240);
  ELSIF l_mode = 'READONLY' THEN
-- GJ 17-JUL-2006     IF NVL(Hig.get_sysopt('UPDRDONLY'),'Y') = 'N' THEN
       IF p_updrdonly = 'N' THEN  
       CLOSE c1;
	   Hig.raise_ner('NET',240);
    END IF;
  END IF; 	
--
   nm_debug.proc_end(g_package_name,'lock_element');
--

END lock_element;
--
-----------------------------------------------------------------------------
--
PROCEDURE lock_element_and_members (p_ne_id               IN nm_elements.ne_id%TYPE
                                   ,p_lock_ele_for_update IN boolean DEFAULT FALSE
                                   ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_element_and_members');
--
   -- Set Global for Versioning
   IF l_lock_flag_bol THEN
   -- Lock the element record
      lock_element       (p_ne_id,p_lock_ele_for_update);
   END IF;   
   -- Lock any OF members (i.e. inv locations or route memberships)
   lock_members_by_of (p_ne_id);
   -- Lock any IN members (i.e. if this is a parent)
   lock_members_by_in (p_ne_id);
--
   nm_debug.proc_end(g_package_name,'lock_element_and_members');
--
END lock_element_and_members;
--
-----------------------------------------------------------------------------
--
PROCEDURE lock_parent (p_ne_id IN nm_elements.ne_id%TYPE) IS
--
   l_parent_ne_id nm_elements.ne_id%TYPE;
--
BEGIN
   l_parent_ne_id := lock_parent (p_ne_id);
END lock_parent;
--
-----------------------------------------------------------------------------
--
FUNCTION lock_parent (p_ne_id IN nm_elements.ne_id%TYPE) RETURN nm_elements.ne_id%TYPE IS
--
   l_parent_ne_id nm_elements.ne_id%TYPE;
--
   l_nt_type      nm_elements.ne_nt_type%TYPE;
--
BEGIN
--
   l_nt_type := nm3net.get_nt_type(p_ne_id);
--
   IF nm3net.is_nt_inclusion_child (l_nt_type)
    THEN
      l_parent_ne_id := nm3net.get_parent_ne_id (p_ne_id
                                                ,nm3net.get_parent_type(l_nt_type)
                                                );
      lock_element (l_parent_ne_id);
   ELSE
      -- If this is not an auto-inclusion child then return the passed ne_id as the parent
      l_parent_ne_id := p_ne_id;
   END IF;
--
   RETURN l_parent_ne_id;
--
END lock_parent;
--
-----------------------------------------------------------------------------
--
PROCEDURE lock_inv_item(pi_iit_ne_id      IN nm_inv_items.iit_ne_id%TYPE
                       ,p_lock_for_update IN boolean DEFAULT FALSE
                       ) IS
--
--
   l_rowid ROWID;
   l_pk_id nm_inv_items.iit_ne_id%TYPE;
--
BEGIN
--
--   Nm_Debug.proc_start (p_package_name   => g_package_name
--                       ,p_procedure_name => 'lock_inv_item'
--                       );
--
   l_rowid := Nm3lock_Gen.lock_iit (pi_iit_ne_id => pi_iit_ne_id);
--
   IF p_lock_for_update
    THEN -- "Touch" the inventory record to make sure we're allowed to update it
      UPDATE NM_INV_ITEMS_ALL
       SET   iit_date_modified = iit_date_modified
      WHERE  ROWID             = l_rowid
	  RETURNING iit_ne_id INTO l_pk_id;  -- RC added returning clause to cater with security predicates which result in no record being returned
      IF l_pk_id IS NULL THEN
	    Hig.raise_ner('NET',240);
	  END IF;
   END IF;
--
--   Nm_Debug.proc_end(p_package_name   => g_package_name
--                    ,p_procedure_name => 'lock_inv_item');
END lock_inv_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE lock_asset_item ( pi_nit_id          IN nm_inv_types.nit_inv_type%TYPE
                           ,pi_pk_id           IN NUMBER
                           ,pi_lock_for_update IN BOOLEAN DEFAULT FALSE 
    					   ,pi_updrdonly       IN hig_option_values.hov_value%TYPE DEFAULT NULL) IS
						   
  l_nit    nm_inv_types%ROWTYPE;
  l_mode   VARCHAR2(10);
  l_lock_string VARCHAR2(2000);

  no_priv  EXCEPTION;
  PRAGMA   EXCEPTION_INIT ( no_priv, -20000 );

  CURSOR c_inv_role ( c_nit_id IN nm_inv_types.nit_inv_type%TYPE ) IS
  SELECT itr_mode
  FROM hig_user_roles, nm_inv_type_roles
  WHERE hur_username = USER
  AND   hur_role = itr_hro_role
  AND   itr_inv_type = c_nit_id
  ORDER BY itr_mode;
  
--
-- GJ 17-JUL-2006
--
-- Add an extra parameter to the locking procedures - call it UPDRDONLY - exactly as the system option.
-- This should default to NULL and should only be passed the value from the calling programs in the PEM and DEFECT APIs. 
-- If the flag is set to null the option should be ignored. 
-- This will cover-off all occurrences of the call to the locking procedures in existing code. The new code (amended from the patch and the additional triggers on the DAS) will pass in the value of the system option. 
--  

BEGIN

  BEGIN
    l_nit := Nm3get.get_nit( pi_nit_id );
  EXCEPTION
    WHEN no_priv THEN 
      Hig.raise_ner( 'NET',240);
  END;
  
  IF l_nit.nit_table_name IS NOT NULL THEN  -- foreign table inventory
  
    OPEN c_inv_role ( pi_nit_id );
	FETCH c_inv_role INTO l_mode;
	IF c_inv_role%NOTFOUND THEN
      CLOSE c_inv_role;
	  Hig.raise_ner( 'NET',240);
    ELSIF l_mode = 'READONLY' THEN
--      IF NVL(Hig.get_sysopt('UPDRDONLY'),'Y') = 'N' THEN
       IF pi_updrdonly = 'N' THEN 
         CLOSE c_inv_role;
	     Hig.raise_ner('NET',240);
      END IF;
    ELSE
	  CLOSE c_inv_role; 
    END IF;

    l_lock_string := 'select '||l_nit.nit_foreign_pk_column||' from '||l_nit.nit_table_name||' where '||l_nit.nit_foreign_pk_column||' = '||
	                  TO_CHAR( pi_pk_id );
					  
	IF pi_lock_for_update THEN
	
      l_lock_string := l_lock_string||' for update ';  	 	   	    	

    END IF;
	
    EXECUTE IMMEDIATE l_lock_string; 					  

  ELSE  -- conventional inventory
  
    Lock_Inv_Item( pi_pk_id, pi_lock_for_update );
	
  END IF;

END lock_asset_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE lock_inv_item_and_members(pi_iit_ne_id      IN nm_inv_items.iit_ne_id%TYPE
                                   ,p_lock_for_update IN boolean DEFAULT FALSE
                                   ) IS
BEGIN

  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'lock_inv_item_and_members');

  lock_inv_item (pi_iit_ne_id      => pi_iit_ne_id
                ,p_lock_for_update => p_lock_for_update
                );

  -- Lock any IN members (i.e. if this is a parent)
  lock_members_by_in(p_nm_ne_id_in => pi_iit_ne_id);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'lock_inv_item_and_members');

END lock_inv_item_and_members;
--
----------------------------------------------------------------------------------------------
--
FUNCTION lock_inv_type (pi_inv_type nm_inv_types.nit_inv_type%TYPE) RETURN ROWID IS
BEGIN
   RETURN nm3lock_gen.lock_nit (pi_nit_inv_type => pi_inv_type);
END lock_inv_type;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE lock_inv_type (pi_inv_type nm_inv_types.nit_inv_type%TYPE) IS
BEGIN
   nm3lock_gen.lock_nit (pi_nit_inv_type => pi_inv_type);
END lock_inv_type;
--
-----------------------------------------------------------------------------
--
FUNCTION lock_ne_by_rowtype  (pi_rec_ne  IN nm_elements%ROWTYPE)  RETURN ROWID IS
--
   l_retval   ROWID;
   l_tab_cols nm3type.tab_varchar30;
--
   PROCEDURE add_col (p_col varchar2) IS
   BEGIN
      l_tab_cols (l_tab_cols.COUNT+1) := LOWER(p_col);
   END add_col;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ne_by_rowtype');
--
   g_rec_ne := pi_rec_ne;
--
   IF pi_rec_ne.ne_nt_type IS NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 329
                    ,pi_supplementary_info => 'NM_ELEMENTS.NE_NT_TYPE'
                    );
   END IF;
--
   add_col ('NE_ID');
   add_col ('NE_UNIQUE');
   add_col ('NE_NT_TYPE');
   add_col ('NE_START_DATE');
   FOR cs_rec IN (SELECT ntc_column_name
                   FROM  nm_type_columns
                  WHERE  ntc_nt_type = pi_rec_ne.ne_nt_type
                 )
    LOOP
      add_col (cs_rec.ntc_column_name);
   END LOOP;
--
   l_retval  := do_dynamic_lock_by_rowtype (p_record_name => g_package_name||'.g_rec_ne'
                                           ,p_table_name  => 'NM_ELEMENTS_ALL'
                                           ,p_tab_cols    => l_tab_cols
                                           );
--
   nm_debug.proc_end(g_package_name,'lock_ne_by_rowtype');
--
   RETURN l_retval;
--
END lock_ne_by_rowtype;
--
-----------------------------------------------------------------------------
--
FUNCTION lock_nm_by_rowtype(pi_nm_rec IN nm_members%ROWTYPE
                           ) RETURN ROWID IS

  l_retval   ROWID;
  
  l_tab_cols nm3type.tab_varchar30;

  PROCEDURE add_col(p_col varchar2) IS
  BEGIN
     l_tab_cols(l_tab_cols.COUNT + 1) := LOWER(p_col);
     
  END add_col;

BEGIN
  nm_debug.proc_start(g_package_name,'lock_ne_by_rowtype');

  g_rec_nm := pi_nm_rec;

  add_col('NM_NE_ID_IN');
  add_col('NM_NE_ID_OF');
  add_col('NM_TYPE');
  add_col('NM_OBJ_TYPE');
  add_col('NM_BEGIN_MP');
  add_col('NM_START_DATE');
  add_col('NM_END_DATE');
  add_col('NM_END_MP');
  add_col('NM_SLK');
  add_col('NM_CARDINALITY');
  add_col('NM_ADMIN_UNIT');
  add_col('NM_SEQ_NO');
  add_col('NM_SEG_NO');
  add_col('NM_TRUE');
  add_col('NM_END_SLK');
  add_col('NM_END_TRUE');
--
  l_retval  := do_dynamic_lock_by_rowtype (p_record_name => g_package_name||'.g_rec_nm'
                                          ,p_table_name  => 'NM_MEMBERS_ALL'
                                          ,p_tab_cols    => l_tab_cols
                                          );
--
  nm_debug.proc_end(g_package_name,'lock_ne_by_rowtype');
--
  RETURN l_retval;
--
END lock_nm_by_rowtype;
--
-----------------------------------------------------------------------------
--
FUNCTION lock_iit_by_rowtype (pi_rec_iit IN nm_inv_items%ROWTYPE) RETURN ROWID IS
   l_retval   ROWID;
   l_tab_cols nm3type.tab_varchar30;
--
   PROCEDURE add_col (p_col varchar2) IS
   BEGIN
      l_tab_cols (l_tab_cols.COUNT+1) := LOWER(p_col);
   END add_col;
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_iit_by_rowtype');
--
   g_rec_iit := pi_rec_iit;
   IF pi_rec_iit.iit_inv_type IS NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 329
                    ,pi_supplementary_info => 'NM_INV_ITEMS.IIT_INV_TYPE'
                    );
   END IF;
--
   add_col ('IIT_NE_ID');
   add_col ('IIT_INV_TYPE');
   add_col ('IIT_START_DATE');
--
   FOR cs_rec IN (SELECT ita_attrib_name
                   FROM  nm_inv_type_attribs
                  WHERE  ita_inv_type = pi_rec_iit.iit_inv_type
                 )
    LOOP
      add_col (cs_rec.ita_attrib_name);
   END LOOP;
--
   l_retval  := do_dynamic_lock_by_rowtype (p_record_name => g_package_name||'.g_rec_iit'
                                           ,p_table_name  => 'NM_INV_ITEMS_ALL'
                                           ,p_tab_cols    => l_tab_cols
                                           );
--
   nm_debug.proc_end(g_package_name,'lock_iit_by_rowtype');
--
   RETURN l_retval;
--
END lock_iit_by_rowtype;
--
-----------------------------------------------------------------------------
--
FUNCTION do_dynamic_lock_by_rowtype (p_record_name varchar2
                                    ,p_table_name  varchar2
                                    ,p_tab_cols    nm3type.tab_varchar30
                                    ) RETURN ROWID IS
--
   l_block nm3type.tab_varchar32767;
--
   l_start varchar2(5) := 'WHERE';
--
   l_locked  EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_locked,-54);
--
   PROCEDURE append (p_text varchar2, p_nl boolean DEFAULT TRUE) IS
   BEGIN
      nm3ddl.append_tab_varchar(l_block,p_text,p_nl);
   END append;
--
BEGIN
--
   append ('DECLARE',FALSE);
   append ('   l_cur   nm3type.ref_cursor;');
   append ('   l_sql   nm3type.max_varchar2;');
   append ('   l_start varchar2(7) := CHR(10)||'||nm3flx.string('WHERE ')||';');
   append ('   l_found BOOLEAN     := FALSE;');
   append ('BEGIN');
   append ('   l_sql := '||nm3flx.string('DECLARE CURSOR cs_match IS ')||'||'||nm3flx.string('SELECT ROWID FROM '||p_table_name)||';');
   FOR i IN 1..p_tab_cols.COUNT
    LOOP
      append ('   IF '||p_record_name||'.'||p_tab_cols(i)||' IS NOT NULL');
      append ('    THEN');
      append ('      l_sql   := l_sql||l_start||'||nm3flx.string(p_tab_cols(i)||' = '||p_record_name||'.'||p_tab_cols(i))||';');
      append ('   ELSE');
      append ('      l_sql   := l_sql||l_start||'||nm3flx.string('('||p_tab_cols(i)||' IS NULL AND  '||p_record_name||'.'||p_tab_cols(i)||' IS NULL)')||';');
      append ('   END IF;');
      IF i = 1
       THEN
         append ('   l_start := CHR(10)||'||nm3flx.string('  AND ')||';');
         append ('   l_found := TRUE;');
      END IF;
   END LOOP;
   append ('   l_sql := l_sql||CHR(10)||'||nm3flx.string('   FOR UPDATE NOWAIT;')||';');
   append ('   l_sql := l_sql||CHR(10)||'||nm3flx.string('BEGIN')||';');
   append ('   l_sql := l_sql||CHR(10)||'||nm3flx.string('    OPEN  cs_match;')||';');
   append ('   l_sql := l_sql||CHR(10)||'||nm3flx.string('    FETCH cs_match INTO '||g_package_name||'.g_rowid;')||';');
   append ('   l_sql := l_sql||CHR(10)||'||nm3flx.string('    '||g_package_name||'.g_found := cs_match%FOUND;')||';');
   append ('   l_sql := l_sql||CHR(10)||'||nm3flx.string('    CLOSE cs_match;')||';');
   append ('   l_sql := l_sql||CHR(10)||'||nm3flx.string('END;')||';');
   append ('   nm_debug.debug(l_sql);');
   append ('   IF NOT l_found');
   append ('    THEN');
   append ('      hig.raise_ner(nm3type.c_net,327);');
   append ('   END IF;');
   append ('   EXECUTE IMMEDIATE l_sql;');
   append ('END;');
--   nm_debug.debug(l_block);
   nm3ddl.execute_tab_varchar(l_block);
--
   IF NOT g_found
    THEN
      hig.raise_ner (nm3type.c_net,328);
   END IF;
--
   RETURN g_rowid;
--
EXCEPTION
--
   WHEN l_locked
    THEN
      hig.raise_ner (nm3type.c_hig,33);
--
END do_dynamic_lock_by_rowtype;
--
-----------------------------------------------------------------------------
--
FUNCTION build_rowtype_and_lock_record (pi_table_name IN user_tables.table_name%TYPE
                                       ,pi_tab_col    IN nm3type.tab_varchar30
                                       ,pi_tab_value  IN nm3type.tab_varchar4000
                                       ) RETURN ROWID IS
--
   l_block          nm3type.tab_varchar32767;
   l_value          nm3type.max_varchar2;
--
   l_procedure_name varchar2(30);
--
   l_tab_atc        nm3ddl.tab_atc;
   l_found          boolean;
--
   PROCEDURE append (p_text varchar2, p_nl boolean DEFAULT TRUE) IS
   BEGIN
      nm3ddl.append_tab_varchar(l_block,p_text,p_nl);
   END append;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'build_rowtype_and_lock_record');
--
   IF    UPPER(pi_table_name) IN ('NM_INV_ITEMS','NM_INV_ITEMS_ALL')
    THEN
      l_procedure_name := 'lock_iit_by_rowtype';
   ELSIF UPPER(pi_table_name) IN ('NM_ELEMENTS','NM_ELEMENTS_ALL')
    THEN
      l_procedure_name := 'lock_ne_by_rowtype';
   ELSE
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 330
                    ,pi_supplementary_info => pi_table_name
                    );
   END IF;
--
   l_tab_atc := nm3ddl.get_all_columns_for_table (p_table_name => pi_table_name);
--
   append ('DECLARE',FALSE);
   append ('   l_rec '||pi_table_name||'%ROWTYPE;');
   append ('BEGIN');
   append ('--');
   FOR i IN 1..l_tab_atc.COUNT
    LOOP
      l_value := 'Null';
      l_found := FALSE;
      FOR j IN 1..pi_tab_col.COUNT
       LOOP
         IF pi_tab_col(j) = l_tab_atc(i).column_name
          THEN
            l_found := TRUE;
            IF pi_tab_value(j) IS NULL
             THEN
               l_value := 'Null';
            ELSIF l_tab_atc(i).data_type = nm3type.c_date
             THEN
               l_value := 'hig.date_convert('||nm3flx.string(pi_tab_value(j))||')';
            ELSIF l_tab_atc(i).data_type = nm3type.c_number
             THEN
               l_value := pi_tab_value(j);
            ELSE
               l_value := nm3flx.string(pi_tab_value(j));
            END IF;
            EXIT;
         END IF;
      END LOOP;
      IF l_found
       THEN
         append ('   l_rec.'||RPAD(LOWER(l_tab_atc(i).column_name),30)||' := ');
         append (l_value||';',FALSE);
      END IF;
   END LOOP;
   append ('--');
   append ('   '||g_package_name||'.g_rowid := '||g_package_name||'.'||l_procedure_name||'(l_rec);');
   append ('--');
   append ('END;');
   nm3ddl.debug_tab_varchar(l_block);
--
   nm3ddl.execute_tab_varchar(l_block);
--
   nm_debug.proc_end(g_package_name,'build_rowtype_and_lock_record');
--
   RETURN g_rowid;
--
END build_rowtype_and_lock_record;
--
-----------------------------------------------------------------------------
--
FUNCTION get_updrdonly RETURN VARCHAR2 IS

BEGIN
 RETURN(g_updrdonly);
END get_updrdonly;

BEGIN
 g_updrdonly := hig.get_user_or_sys_opt(pi_option => 'UPDRDONLY');
 
END nm3lock;
/
