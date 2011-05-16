CREATE OR REPLACE PACKAGE BODY NM3LOAD_INV_FAILED AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3load_inv_failed.pkb-arc   2.4   May 16 2011 14:45:00   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3load_inv_failed.pkb  $
--       Date into PVCS   : $Date:   May 16 2011 14:45:00  $
--       Date fetched Out : $Modtime:   Apr 01 2011 14:46:24  $
--       Version          : $Revision:   2.4  $
--       Based on SCCS version : 1.9
-------------------------------------------------------------------------
--   Author : Graeme Johnson
--
--   NM3LOAD_INV_FAILED body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.4  $';
  g_package_name CONSTANT varchar2(30) := 'NM3LOAD_INV_FAILED';
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
FUNCTION get_all_attrib_values(p_batch_no   IN nm_ld_mc_all_inv_tmp.batch_no%TYPE
                              ,p_record_no  IN nm_ld_mc_all_inv_tmp.record_no%TYPE)
         RETURN attrib_table IS
--
   CURSOR c1 IS
     SELECT ita_attrib_name
     FROM   nm_inv_type_attribs   ita
           ,nm_ld_mc_all_inv_tmp  inv
     WHERE  inv.batch_no  = p_batch_no
     AND    inv.record_no = p_record_no
     AND    inv.iit_inv_type = ita.ita_inv_type
     ORDER BY ita_disp_seq_no;
--
   l_attrib_name nm_inv_type_attribs.ita_attrib_name%TYPE;
   l_attrib_list attrib_table;
   l_attrib_count number := 0;
--
BEGIN
--
   OPEN c1;
   LOOP
     l_attrib_count := l_attrib_count+1;
     FETCH c1 INTO l_attrib_name;
     EXIT WHEN c1%NOTFOUND;
     l_attrib_list(l_attrib_count).attrib_name := l_attrib_name;
     l_attrib_list(l_attrib_count).attrib_value := get_attrib_value(p_batch_no    => p_batch_no
                                                                   ,p_record_no   => p_record_no
                                                                   ,p_attrib_name => l_attrib_name);
   END LOOP;
   CLOSE c1;
--
   RETURN l_attrib_list;
   
--
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_attrib_value(p_batch_no    IN nm_ld_mc_all_inv_tmp.batch_no%TYPE
                         ,p_record_no   IN nm_ld_mc_all_inv_tmp.record_no%TYPE
                         ,p_attrib_name IN nm_inv_type_attribs.ita_attrib_name%TYPE
                         ) RETURN varchar2 IS
--
   CURSOR c1 (p_batch_no    nm_ld_mc_all_inv_tmp.batch_no%TYPE
             ,p_record_no   nm_ld_mc_all_inv_tmp.record_no%TYPE
             ,p_attrib_name nm_inv_type_attribs.ita_attrib_name%TYPE
             ) IS
     SELECT ita_format
           ,ita_format_mask
     FROM   nm_inv_type_attribs   ita
           ,nm_ld_mc_all_inv_tmp  inv
     WHERE  inv.batch_no        = p_batch_no
     AND    inv.record_no       = p_record_no
     AND    inv.iit_inv_type    = ita.ita_inv_type 
     AND    ita.ita_attrib_name = p_attrib_name; 
--
   l_format nm_inv_type_attribs.ita_format%TYPE;
   l_mask   nm_inv_type_attribs.ita_format_mask%TYPE;
   l_retval varchar2(500);
--
   l_sql_string varchar2(2000);
--
BEGIN
--
   OPEN  c1 (p_batch_no
           , p_record_no
           , p_attrib_name);
   FETCH c1 INTO l_format, l_mask;
   CLOSE c1;
--
   IF l_format = nm3type.c_date
    AND INSTR(p_attrib_name,l_format,1,1) != 0
    THEN
      l_sql_string := 'select to_char('
                      ||p_attrib_name
                      ||', '
                      ||nm3flx.string(NVL(l_mask,Sys_Context('NM3CORE','USER_DATE_MASK')))
                      ||') from nm_ld_mc_all_inv_tmp'
                      ||'  where batch_no = :p_batch_no'
                      ||'  and record_no = :p_record_no';
   ELSIF l_format = nm3type.c_number
    AND  l_mask IS NOT NULL
    THEN
      l_sql_string := 'select to_char('
                      ||p_attrib_name
                      ||', '
                      ||nm3flx.string(l_mask)
                      ||') from nm_ld_mc_all_inv_tmp'
                      ||'  where batch_no = :p_batch_no'
                      ||'  and record_no = :p_record_no';
   ELSE
      l_sql_string := 'select '
                      ||p_attrib_name
                      ||'  from nm_ld_mc_all_inv_tmp'
                      ||'  where batch_no = :p_batch_no'
                      ||'  and record_no = :p_record_no';
    END IF;
--
   EXECUTE IMMEDIATE l_sql_string INTO l_retval USING p_batch_no, p_record_no;
--
   RETURN l_retval;
   
END get_attrib_value;
--
-----------------------------------------------------------------------------
--
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
PROCEDURE get_conflict(p_batch_no        IN     nm_ld_mc_all_inv_tmp.batch_no%TYPE
                      ,p_record_no       IN     nm_ld_mc_all_inv_tmp.record_no%TYPE 
                      ,po_conflict_table IN OUT conflict_table) IS


  l_live_rec      nm_inv_items_all%ROWTYPE;
  l_holding_rec   nm_ld_mc_all_inv_tmp%ROWTYPE;
  v_counter       PLS_INTEGER;
  
  

  TYPE t_flex_attrib_name          IS TABLE OF nm_inv_type_attribs.ita_attrib_name%TYPE INDEX BY binary_integer;
  TYPE t_flex_attrib_scrn_text     IS TABLE OF nm_inv_type_attribs.ita_scrn_text%TYPE INDEX BY binary_integer;
  TYPE t_flex_attrib_format        IS TABLE OF nm_inv_type_attribs.ita_format%TYPE INDEX BY binary_integer;
  TYPE t_flex_attrib_format_mask   IS TABLE OF nm_inv_type_attribs.ita_format_mask%TYPE INDEX BY binary_integer;
  
  l_flex_attrib_name            t_flex_attrib_name; 
  l_flex_attrib_scrn_text       t_flex_attrib_scrn_text; 
  l_flex_attrib_format          t_flex_attrib_format;  
  l_flex_attrib_format_mask     t_flex_attrib_format_mask;   
--
  l_flex_attrib_holding         VARCHAR2(500);
  l_flex_attrib_meaning_holding nm3type.max_varchar2;
  l_flex_attrib_live            VARCHAR2(500);  
  l_flex_attrib_meaning_live    nm3type.max_varchar2;
  
  l_nau_rec_holding nm_admin_units%ROWTYPE;
  l_nau_rec_live    nm_admin_units%ROWTYPE;
  
  l_dummy           nm3type.max_varchar2;  
    
--
  PROCEDURE add_conflict(p_attrib_name            IN nm_inv_type_attribs.ita_attrib_name%TYPE
                        ,p_attrib_screen_text     IN nm_inv_type_attribs.ita_scrn_text%TYPE
                        ,p_attrib_format          IN nm_inv_type_attribs.ita_format%TYPE
                        ,p_attrib_format_mask     IN nm_inv_type_attribs.ita_format_mask%TYPE
                        ,p_attrib_value_holding   IN VARCHAR2
                        ,p_attrib_meaning_holding IN VARCHAR2
                        ,p_attrib_value_live      IN VARCHAR2
                        ,p_attrib_meaning_live    IN VARCHAR2) IS

     v_rec NUMBER := po_conflict_table.COUNT +1;

  BEGIN
  
      po_conflict_table(v_rec).attrib_name            := p_attrib_name;
      po_conflict_table(v_rec).attrib_screen_text     := p_attrib_screen_text;
      po_conflict_table(v_rec).attrib_format          := p_attrib_format;
      po_conflict_table(v_rec).attrib_format_mask     := p_attrib_format_mask;  
      po_conflict_table(v_rec).attrib_value_holding   := p_attrib_value_holding;
      po_conflict_table(v_rec).attrib_meaning_holding := p_attrib_meaning_holding;  
      po_conflict_table(v_rec).attrib_value_live      := p_attrib_value_live;
      po_conflict_table(v_rec).attrib_meaning_live    := p_attrib_meaning_live;  
  
  END add_conflict;

BEGIN

      ------------------------------------
      -- Retrieve HOLDING inventory record
      ------------------------------------
      l_holding_rec := get_nlm (pi_batch_no          => p_batch_no
                               ,pi_record_no         => p_record_no);

      ---------------------------------
      -- Retrieve LIVE inventory record
      ---------------------------------
      l_live_rec    := nm3get.get_iit_all (pi_iit_ne_id         => l_holding_rec.iit_ne_id); 


      -----------------
      -- IIT_ADMIN_UNIT
      -----------------
      --
      -- get values
      l_flex_attrib_holding := l_holding_rec.iit_admin_unit;  
      l_flex_attrib_live    := l_live_rec.iit_admin_unit;
      --   
      -- get meanings
      l_nau_rec_holding := nm3get.get_nau(pi_nau_admin_unit    => l_holding_rec.iit_admin_unit
                                         ,pi_raise_not_found   => FALSE);

      l_nau_rec_live    := nm3get.get_nau(pi_nau_admin_unit    => l_live_rec.iit_admin_unit
                                         ,pi_raise_not_found   => FALSE);

      l_flex_attrib_meaning_holding := l_nau_rec_holding.nau_name;
      l_flex_attrib_meaning_live    := l_nau_rec_live.nau_name; 

      add_conflict(p_attrib_name            => 'IIT_ADMIN_UNIT'
                  ,p_attrib_screen_text     => 'Admin Unit'
                  ,p_attrib_format          => 'NUMBER'
                  ,p_attrib_format_mask     => Null
                  ,p_attrib_value_holding   => l_flex_attrib_holding
                  ,p_attrib_meaning_holding => l_flex_attrib_meaning_holding 
                  ,p_attrib_value_live      => l_flex_attrib_live
                  ,p_attrib_meaning_live    => l_flex_attrib_meaning_live);
       
      ------------
      -- IIT_DESCR
      ------------
      --
      -- get values
      l_flex_attrib_holding := l_holding_rec.iit_descr;  
      l_flex_attrib_live    := l_live_rec.iit_descr;
      --   
      -- get meanings
      l_flex_attrib_meaning_holding := Null;
      l_flex_attrib_meaning_live    := Null; 
 
      add_conflict(p_attrib_name            => 'IIT_DESCR'
                  ,p_attrib_screen_text     => 'Description'
                  ,p_attrib_format          => 'VARCHAR2'
                  ,p_attrib_format_mask     => Null  
                  ,p_attrib_value_holding   => l_flex_attrib_holding
                  ,p_attrib_meaning_holding => l_flex_attrib_meaning_holding  
                  ,p_attrib_value_live      => l_flex_attrib_live
                  ,p_attrib_meaning_live    => l_flex_attrib_meaning_live);
 

      -------------
      -- IIT_X_SECT
      -------------
      --
      -- get values
      l_flex_attrib_holding := l_holding_rec.iit_x_sect;  
      l_flex_attrib_live    := l_live_rec.iit_x_sect;
      --   
      -- get meanings
      IF l_holding_rec.iit_inv_type IS NOT NULL AND l_holding_rec.iit_x_sect IS NOT NULL THEN
          l_flex_attrib_meaning_holding := nm3inv.get_xsp_descr(p_inv_type   => l_holding_rec.iit_inv_type
                                                               ,p_x_sect_val => l_holding_rec.iit_x_sect
                                                               ,p_nw_type    => NULL
                                                               ,p_scl_class  => NULL);
      ELSE
         l_flex_attrib_meaning_holding := Null;
      END IF;


      IF l_live_rec.iit_inv_type IS NOT NULL AND l_live_rec.iit_x_sect IS NOT NULL THEN
         l_flex_attrib_meaning_live := nm3inv.get_xsp_descr(p_inv_type   => l_live_rec.iit_inv_type
                                                           ,p_x_sect_val => l_live_rec.iit_x_sect
                                                           ,p_nw_type    => NULL
                                                           ,p_scl_class  => NULL);
      ELSE
         l_flex_attrib_meaning_live := Null;
      END IF;
   
      add_conflict(p_attrib_name            => 'IIT_X_SECT'
                  ,p_attrib_screen_text     => 'XSP'
                  ,p_attrib_format          => 'VARCHAR2'
                  ,p_attrib_format_mask     => Null  
                  ,p_attrib_value_holding   => l_flex_attrib_holding
                  ,p_attrib_meaning_holding => l_flex_attrib_meaning_holding  
                  ,p_attrib_value_live      => l_flex_attrib_live
                  ,p_attrib_meaning_live    => l_flex_attrib_meaning_live);


      --------------
      -- IIT_DET_XSP
      --------------
      --
      -- get values
      l_flex_attrib_holding := l_holding_rec.iit_det_xsp;  
      l_flex_attrib_live    := l_live_rec.iit_det_xsp;
      --   
      -- get meanings
      l_flex_attrib_meaning_holding := Null;
      l_flex_attrib_meaning_live    := Null; 

      add_conflict(p_attrib_name            => 'IIT_DET_XSP'
                  ,p_attrib_screen_text     => 'Detailed XSP'
                  ,p_attrib_format          => 'VARCHAR2'
                  ,p_attrib_format_mask     => Null
                  ,p_attrib_value_holding   => l_flex_attrib_holding
                  ,p_attrib_meaning_holding => l_flex_attrib_meaning_holding
                  ,p_attrib_value_live      => l_flex_attrib_live
                  ,p_attrib_meaning_live    => l_flex_attrib_meaning_live);



      -----------------
      -- IIT_START_DATE
      -----------------
      --
      -- get values
      l_flex_attrib_holding := TO_CHAR(l_holding_rec.iit_start_date,Sys_Context('NM3CORE','USER_DATE_MASK'));  
      l_flex_attrib_live    := TO_CHAR(l_live_rec.iit_start_date,Sys_Context('NM3CORE','USER_DATE_MASK'));
      --
      -- get meanings
      l_flex_attrib_meaning_holding := Null;
      l_flex_attrib_meaning_live    := Null;
  
      add_conflict(p_attrib_name            => 'IIT_START_DATE'
                  ,p_attrib_screen_text     => 'Start Date'
                  ,p_attrib_format          => 'DATE'
                  ,p_attrib_format_mask     => Sys_Context('NM3CORE','USER_DATE_MASK')
                  ,p_attrib_value_holding   => l_flex_attrib_holding
                  ,p_attrib_meaning_holding => l_flex_attrib_meaning_holding
                  ,p_attrib_value_live      => l_flex_attrib_live
                  ,p_attrib_meaning_live    => l_flex_attrib_meaning_live);
 
      -----------------
      -- IIT_END_DATE
      -----------------
      --
      -- get values
      l_flex_attrib_holding := TO_CHAR(l_holding_rec.iit_end_date,Sys_Context('NM3CORE','USER_DATE_MASK'));  
      l_flex_attrib_live    := TO_CHAR(l_live_rec.iit_end_date,Sys_Context('NM3CORE','USER_DATE_MASK'));
      --   
      -- get meanings
      l_flex_attrib_meaning_holding := Null;
      l_flex_attrib_meaning_live    := Null;

      add_conflict(p_attrib_name            => 'IIT_END_DATE'
                  ,p_attrib_screen_text     => 'End Date'
                  ,p_attrib_format          => 'DATE'
                  ,p_attrib_format_mask     => Sys_Context('NM3CORE','USER_DATE_MASK')
                  ,p_attrib_value_holding   => l_flex_attrib_holding
                  ,p_attrib_meaning_holding => l_flex_attrib_meaning_holding
                  ,p_attrib_value_live      => l_flex_attrib_live
                  ,p_attrib_meaning_live    => l_flex_attrib_meaning_live);
  
  
  
      -------------------------------------------------
      -- GET FLEXIBLE ATTRIBUTE LIST FOR INVENTORY TYPE
      -------------------------------------------------
      SELECT ita_attrib_name
            ,ita_scrn_text
            ,ita_format
            ,ita_format_mask
      BULK COLLECT INTO
             l_flex_attrib_name
            ,l_flex_attrib_scrn_text
            ,l_flex_attrib_format
            ,l_flex_attrib_format_mask
      FROM   nm_inv_type_attribs
      WHERE  ita_inv_type = l_live_rec.iit_inv_type
      ORDER BY ita_disp_seq_no;

  -------------------------------------------------------------------------------------------------------------
  -- Loop through these flexible attributes and return the formatted value from the holding and the live tables
  ------------------------------------------------------------------------------------------------------------- 
      FOR v_counter IN 1..l_flex_attrib_name.COUNT LOOP

            --
            -- get values
            l_flex_attrib_holding := nm3load_inv_failed.get_attrib_value(p_batch_no    => p_batch_no
                                                                        ,p_record_no   => p_record_no
                                                                        ,p_attrib_name => l_flex_attrib_name(v_counter));

            l_flex_attrib_live    := nm3inv.get_attrib_value(p_ne_id       => l_live_rec.iit_ne_id
                                                            ,p_attrib_name => l_flex_attrib_name(v_counter));

            --
            -- get meanings
            nm3inv.validate_flex_inv (p_inv_type               => l_holding_rec.iit_inv_type
                                     ,p_attrib_name            => l_flex_attrib_name(v_counter)
                                     ,pi_value                 => l_flex_attrib_holding
                                     ,po_value                 => l_dummy
                                     ,po_meaning               => l_flex_attrib_meaning_holding
                                     ,pi_validate_domain_dates => TRUE );
 
            nm3inv.validate_flex_inv (p_inv_type               => l_live_rec.iit_inv_type
                                     ,p_attrib_name            => l_flex_attrib_name(v_counter)
                                     ,pi_value                 => l_flex_attrib_live
                                     ,po_value                 => l_dummy
                                     ,po_meaning               => l_flex_attrib_meaning_live
                                     ,pi_validate_domain_dates => TRUE );

            add_conflict(p_attrib_name            => l_flex_attrib_name(v_counter)
                        ,p_attrib_screen_text     => l_flex_attrib_scrn_text(v_counter)
                        ,p_attrib_format          => l_flex_attrib_format(v_counter)
                        ,p_attrib_format_mask     => l_flex_attrib_format_mask(v_counter)
                        ,p_attrib_value_holding   => l_flex_attrib_holding
                        ,p_attrib_meaning_holding => l_flex_attrib_meaning_holding
                        ,p_attrib_value_live      => l_flex_attrib_live
                        ,p_attrib_meaning_live    => l_flex_attrib_meaning_holding);

  END LOOP;

END get_conflict;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_holding_record_attrib(pi_batch_no             IN     nm_ld_mc_all_inv_tmp.batch_no%TYPE
                                      ,pi_record_no            IN     nm_ld_mc_all_inv_tmp.record_no%TYPE 
                                      ,pi_attrib_name          IN     nm_inv_type_attribs.ita_attrib_name%TYPE
                                      ,pi_attrib_value         IN     VARCHAR2
                                      ,pi_attrib_format        IN     nm_inv_type_attribs.ita_format%TYPE
                                      ,pi_attrib_format_mask   IN     nm_inv_type_attribs.ita_format_mask%TYPE
                                      ) IS

 v_sql nm3type.max_varchar2;

BEGIN

  IF pi_attrib_value IS NULL THEN

    v_sql := 'UPDATE nm_ld_mc_all_inv_tmp SET '||pi_attrib_name||' = Null';
 
  ELSIF pi_attrib_format = 'DATE' THEN
    
    v_sql := 'UPDATE nm_ld_mc_all_inv_tmp SET '||pi_attrib_name||' = TO_DATE('''||pi_attrib_value||''''
              ||chr(10)||','''||NVL(pi_attrib_format_mask,Sys_Context('NM3CORE','USER_DATE_MASK'))||''')';

  ELSIF pi_attrib_format = 'NUMBER' THEN

    v_sql := 'UPDATE nm_ld_mc_all_inv_tmp SET '||pi_attrib_name||' = '||pi_attrib_value;

  ELSE 

    v_sql := 'UPDATE nm_ld_mc_all_inv_tmp SET '||pi_attrib_name||' = '''||pi_attrib_value||''''; 			   

  END IF;
 
 v_sql := v_sql ||chr(10)||' WHERE batch_no = '||to_char(pi_batch_no)||' AND record_no = '||to_char(pi_record_no);

--raise too_many_rows;
 EXECUTE IMMEDIATE(v_sql);
 COMMIT; 
--EXCEPTION
--when others then raise_application_error(-20001,v_sql);
 
END update_holding_record_attrib;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_conflict_resolved(pi_batch_no             IN     nm_ld_mc_all_inv_tmp.batch_no%TYPE
                               ,pi_record_no            IN     nm_ld_mc_all_inv_tmp.record_no%TYPE
                               ) IS

  v_sql nm3type.max_varchar2;

BEGIN

  v_sql :=     ' UPDATE nm_ld_mc_all_inv_tmp SET nlm_error_status = 3'
    ||chr(10)||' WHERE  batch_no = '||to_char(pi_batch_no)||' AND record_no = '||to_char(pi_record_no);

  EXECUTE IMMEDIATE(v_sql);
  
  nm3load.update_status(p_batch_no  => pi_batch_no
                       ,p_record_no => pi_record_no
                       ,p_status    => 'H'
                       ,p_text      => NULL);
  
  COMMIT; 

END set_conflict_resolved;
--
-----------------------------------------------------------------------------
--
PROCEDURE resubmit_batch(pi_batch_no             IN     nm_ld_mc_all_inv_tmp.batch_no%TYPE) IS

CURSOR get_batch (p_batch_no IN nm_load_batch_status.nlbs_nlb_batch_no%TYPE) IS
SELECT nlbs_record_no
FROM   nm_load_batch_status
WHERE  nlbs_nlb_batch_no = p_batch_no
AND    nlbs_status      != 'I';

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'resubmit_batch');
   
  -- first lock the batch for loading
  IF nm3mapcapture_int.lock_the_batch_for_loading(pi_batch => pi_batch_no) THEN
  
  -- reset the error status of the batch table
   
    FOR i IN get_batch(pi_batch_no) LOOP
      
      nm3load.update_status(p_batch_no  => pi_batch_no
                           ,p_record_no => i.nlbs_record_no
                           ,p_status    => 'H'
                           ,p_text      => NULL);
    END LOOP;
    
    -- now redo the load
    IF Nvl(nm3mapcapture_ins_inv.l_mapcap_run,'N') = 'N'  
    THEN
        nm3load.load_batch(p_batch_no => pi_batch_no);
    ELSE
        nm3mapcapture_ins_inv.run_batch(pi_batch_no);
    END IF ;
    -- and tell us of the results
    nm3load.produce_log_email(p_nlb_batch_no   => pi_batch_no
                             ,p_produce_as_htp => FALSE
                             ,p_send_to        => nm3mapcapture_int.get_mapcap_email_recipients);
    -- clear the lock
    nm3mapcapture_int.clear_lock(pi_batch => pi_batch_no);

  ELSE
    -- cannot obtain lock
    hig.raise_ner(pi_appl               => nm3type.c_hig
                 ,pi_id                 => 207
                 ,pi_supplementary_info => 'Batch cannot be locked for loading');
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'resubmit_batch');
END resubmit_batch;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_batch_record (pi_batch_no             IN     nm_ld_mc_all_inv_tmp.batch_no%TYPE
                              ,pi_record_no            IN     nm_ld_mc_all_inv_tmp.record_no%TYPE) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'delete_batch_record');
  
  -- delete the record from the holding table
  DELETE FROM nm_ld_mc_all_inv_tmp
  WHERE batch_no  = pi_batch_no
  AND   record_no = pi_record_no;
  
  -- delete the batch status record
  
  DELETE FROM nm_load_batch_status
  WHERE nlbs_nlb_batch_no = pi_batch_no
  AND   nlbs_record_no    = pi_record_no;
  
  -- update the record count on the batch record
  
  UPDATE nm_load_batches
  SET    nlb_record_count = nlb_record_count - 1
  WHERE  nlb_batch_no     = pi_batch_no;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'delete_batch_record');

END delete_batch_record;
--
-----------------------------------------------------------------------------
--
END NM3LOAD_INV_FAILED;
/
