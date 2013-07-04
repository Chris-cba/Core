CREATE OR REPLACE PACKAGE BODY x_ky_bulk_csv
AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)x_ky_bulk_csv.pkb	1.3 11/07/05
--       Module Name      : x_ky_bulk_csv.pkb
--       Date into SCCS   : 05/11/07 14:44:36
--       Date fetched Out : 07/06/13 14:14:04
--       SCCS Version     : 1.3
--
--
--   Author : Ian Bate
--
--   x_ky_bulk_csv
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here

   g_record_pos 		   	   	   PLS_INTEGER := 0;
   g_ins_called	   		   	   	   BOOLEAN := FALSE;
   
   g_holding_table_name		   nm_load_files.nlf_holding_table%TYPE;
   g_nlf_unique	   	  		   nm_load_files.nlf_unique%TYPE;
   g_nlf_id		   	  		   nm_load_files.nlf_id%TYPE;
   g_nld_id		   	  		   nm_load_destinations.nld_id%TYPE;

   TYPE t_tab_triggers IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
   g_tab_triggers  t_tab_triggers;	  
   
   TYPE t_tab_rec_nldd IS TABLE OF nm_load_destination_defaults%ROWTYPE  INDEX BY BINARY_INTEGER;

   TYPE t_tab_rec_nlcd IS TABLE OF nm_load_file_col_destinations%ROWTYPE INDEX BY BINARY_INTEGER; 
   g_tab_rec_nlcd 	  t_tab_rec_nlcd;
   g_tab_rec_nlcd_all t_tab_rec_nlcd;   

   TYPE t_tab_rec_nlbs IS TABLE OF nm_load_batch_status%ROWTYPE INDEX BY BINARY_INTEGER;
   g_tab_rec_nlbs t_tab_rec_nlbs;
   
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '"@(#)x_ky_bulk_csv.pkb	1.3 11/07/05"';

  c_table_short_name_prefix        VARCHAR2(2) := 'l_';
  
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
FUNCTION valid_identifier_char (p_test_char IN VARCHAR2) RETURN BOOLEAN IS
BEGIN

   -- 'An identifier consists of a letter optionally followed by more letters,numerals,dollar signs,underscores and number signs' 
   RETURN INSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789$_#',UPPER(p_test_char)) > 0 ;

END valid_identifier_char;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_batch_statuses IS

TYPE t_ref_cursor IS REF CURSOR;
c_ref_nlbs t_ref_cursor;

l_dml_string  VARCHAR2(500);

BEGIN

   l_dml_string := ' SELECT nlbs.*'
   				|| ' FROM   '||g_holding_table_name||' tab,'
	      		|| '        nm_load_batch_status nlbs'
   				|| ' WHERE  tab.batch_no           = '||TO_CHAR(nm3load.g_batch_no)
   				|| ' AND    nlbs.nlbs_nlb_batch_no = tab.batch_no'
   				|| ' AND    nlbs.nlbs_record_no    = tab.record_no'
   				|| ' AND    nlbs.nlbs_status       IN (''H'',''V'')'
				|| ' ORDER BY tab.batch_no, tab.record_no';

-- nm_debug.debug(l_dml_string);

   OPEN c_ref_nlbs FOR l_dml_string;				   				
   FETCH c_ref_nlbs BULK COLLECT INTO g_tab_rec_nlbs; 
   CLOSE c_ref_nlbs;
   
END get_batch_statuses;
--
-----------------------------------------------------------------------------
--
PROCEDURE initialise_globals (p_batch_no IN NUMBER) IS

   CURSOR cs_nlf (p_nlb_batch_no nm_load_batches.nlb_batch_no%TYPE) IS
      SELECT f.nlf_id, 
  		 	 NVL(f.nlf_holding_table, 'NM_LD_'||f.nlf_unique||'_TMP'),
		 	 f.nlf_unique
      FROM	 nm_load_batches b,   
    	 	 nm_load_files f
      WHERE  b.nlb_batch_no = p_nlb_batch_no 
      AND	 b.nlb_nlf_id = f.nlf_id ;

   CURSOR cs_nld ( p_nlf_id nm_load_files.nlf_id%TYPE ) IS
      SELECT f.nlfd_nld_id 
      FROM	 nm_load_destinations d,
  		 	 nm_load_file_destinations f  
      WHERE  d.nld_table_name='NM_INV_ITEMS' 
      AND	 d.nld_id = f.nlfd_nld_id
      AND	 f.nlfd_nlf_id = p_nlf_id ;

   CURSOR cs_nlcd (p_nlf_id nm_load_files.nlf_id%TYPE
	   			  ,p_nld_id nm_load_destinations.nld_id%TYPE ) IS
      SELECT *
  	  FROM	 nm_load_file_col_destinations
  	  WHERE	 nlcd_nlf_id = p_nlf_id
  	  AND	 nlcd_nld_id = p_nld_id
  	  AND	 nlcd_source_col IS NOT NULL
  	  ORDER BY nlcd_seq_no ;

   CURSOR cs_nlcd_all (p_nlf_id nm_load_files.nlf_id%TYPE
	   			      ,p_nld_id nm_load_destinations.nld_id%TYPE ) IS
      SELECT *
  	  FROM	 nm_load_file_col_destinations
  	  WHERE	 nlcd_nlf_id = p_nlf_id
  	  AND	 nlcd_nld_id = p_nld_id
  	  ORDER BY nlcd_seq_no ;

BEGIN

   -- get nlf_id, holding_table_name and nlf_unique for the batch
   OPEN  cs_nlf (p_batch_no);
   FETCH cs_nlf INTO g_nlf_id, g_holding_table_name, g_nlf_unique;
   CLOSE cs_nlf;

   -- get nld_id for the destination table/batch combination
   OPEN  cs_nld (g_nlf_id);
   FETCH cs_nld INTO g_nld_id;
   CLOSE cs_nld;

   -- get file_col_destinations where source is not blank  
   OPEN cs_nlcd (g_nlf_id, g_nld_id);
   FETCH cs_nlcd BULK COLLECT INTO g_tab_rec_nlcd;
   CLOSE cs_nlcd;

   -- get all file_col_destinations  
   OPEN cs_nlcd_all (g_nlf_id, g_nld_id);
   FETCH cs_nlcd_all BULK COLLECT INTO g_tab_rec_nlcd_all;
   CLOSE cs_nlcd_all;

END initialise_globals;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_triggers (p_state  IN VARCHAR2) IS

   l_dml_string VARCHAR2(100);
   l_schema		VARCHAR2(100);
   
BEGIN

   SELECT hus_username
   INTO   l_schema
   FROM	  hig_users
   WHERE  hus_is_hig_owner_flag = 'Y';	 

   FOR i IN 1..g_tab_triggers.COUNT
   LOOP

      l_dml_string := 'ALTER TRIGGER '||l_schema||'.'||g_tab_triggers(i)||' '||p_state;
 	  EXECUTE IMMEDIATE l_dml_string;

   END LOOP;
 
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_tab_rec_nlbs (p_record_no IN NUMBER   
                        	  ,p_status    IN VARCHAR2
                        	  ,p_text      IN VARCHAR2)
							  IS

l_start PLS_INTEGER := p_record_no;

BEGIN

   IF l_start > g_tab_rec_nlbs.COUNT
   THEN
      l_start := g_tab_rec_nlbs.COUNT;
   END IF; 	 

   FOR i IN REVERSE 1..l_start
   LOOP

      IF g_tab_rec_nlbs(i).nlbs_record_no = p_record_no
	  THEN
	     g_tab_rec_nlbs(i).nlbs_status := p_status;
         g_tab_rec_nlbs(i).nlbs_text := p_text;
		 EXIT;
	  END IF;
	  
   END LOOP;	  

END;							  
--
-----------------------------------------------------------------------------
--
PROCEDURE update_batch_status (p_nlb_batch_no IN nm_load_batches.nlb_batch_no%TYPE
		  					  ,p_holding_table_name IN VARCHAR2
							  ,p_inv_name 			IN VARCHAR2
							  ,p_inv_type 			IN VARCHAR2 
		  					  ,p_col_name 			IN VARCHAR2
							  ,p_value 				IN VARCHAR2 
							  ,p_text 				IN VARCHAR2
							  ,p_status				IN VARCHAR2)
IS

TYPE t_ref_cursor IS REF CURSOR;
c_ref_holding_table t_ref_cursor;

l_record_no   NUMBER;
l_dml_string  VARCHAR2(1000);

BEGIN

   l_dml_string := ' SELECT h.record_no'
   				|| ' FROM nm_load_batch_status s,'
				|| p_holding_table_name || ' h'
				|| ' WHERE s.nlbs_nlb_batch_no = ' || p_nlb_batch_no
				|| ' AND s.nlbs_status IN (''H'',''V'')'
				|| ' AND s.nlbs_nlb_batch_no = h.batch_no'
				|| ' AND s.nlbs_nlb_record_no = h.record_no'
				|| ' AND h.' || p_inv_name || ' = ''' || p_inv_type || ''''
				|| ' AND h.' || SUBSTR(p_col_name,INSTR(p_col_name,'.')+1); 
				
   IF p_value IS NULL
   THEN
      l_dml_string := l_dml_string || ' IS NULL';
   ELSE
      l_dml_string := l_dml_string || ' = ''' || p_value ||'''';   
   END IF;				
				
   nm_debug.debug ('ATT UBS >>> '||l_dml_string);				
				
   OPEN c_ref_holding_table FOR l_dml_string;
 
   LOOP
  
      FETCH c_ref_holding_table INTO l_record_no;
      EXIT WHEN c_ref_holding_table%NOTFOUND;
   
   	  nm3load.update_status (p_batch_no  => p_nlb_batch_no 
                        	,p_record_no => l_record_no   
                        	,p_status    => p_status
                        	,p_text      => p_text
                        	); 	     	  
--nm_debug.debug ('update_tab_rec_nlbs for :' || l_record_no);      

	  update_tab_rec_nlbs (p_record_no => l_record_no    
                          ,p_status	   => p_status
                          ,p_text	   => p_text);
   
   END LOOP;

   
   CLOSE c_ref_holding_table;
   
END update_batch_status;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_batch_status (p_nlb_batch_no IN nm_load_batches.nlb_batch_no%TYPE
		  					  ,p_holding_table_name IN VARCHAR2
							  ,p_ne_unique			IN VARCHAR2 
							  ,p_text 				IN VARCHAR2
							  ,p_status				IN VARCHAR2)
IS

TYPE t_ref_cursor IS REF CURSOR;
c_ref_holding_table t_ref_cursor;

l_record_no   NUMBER;
l_dml_string  VARCHAR2(1000);

BEGIN

   l_dml_string := ' SELECT h.record_no'
   				|| ' FROM nm_load_batch_status s,'
				|| p_holding_table_name || ' h'
				|| ' WHERE s.nlbs_nlb_batch_no = ' || p_nlb_batch_no
				|| ' AND s.nlbs_status IN (''V'',''H'')'
				|| ' AND s.nlbs_nlb_batch_no=h.batch_no'
				|| ' AND s.nlbs_record_no=h.record_no'
				|| ' AND h.rt_id = ''' || p_ne_unique || '''';

   nm_debug.debug ('ROUTE UBS >>> '||l_dml_string);				
				
   OPEN c_ref_holding_table FOR l_dml_string;
   
   LOOP
   
      FETCH c_ref_holding_table INTO l_record_no;
      EXIT WHEN c_ref_holding_table%NOTFOUND;
   
   	  nm3load.update_status (p_batch_no  => p_nlb_batch_no 
                        	,p_record_no => l_record_no   
                        	,p_status    => p_status
                        	,p_text      => p_text
                        	); 	     	  

	  update_tab_rec_nlbs (p_record_no => l_record_no    
                          ,p_status	   => p_status
                          ,p_text	   => p_text);

   END LOOP;
   
   CLOSE c_ref_holding_table;
   
END update_batch_status;
--
-----------------------------------------------------------------------------
--
FUNCTION get_source_col (p_nlf_id IN nm_load_file_col_destinations.nlcd_nlf_id%TYPE
						,p_dest_col IN VARCHAR2) RETURN VARCHAR2 IS

l_source_col VARCHAR2(100);						
						
BEGIN

   SELECT nlcd_source_col
   INTO	  l_source_col
   FROM	  nm_load_file_col_destinations 
   WHERE  nlcd_nlf_id = p_nlf_id
   AND    nlcd_dest_col = p_dest_col;
  
   RETURN l_source_col;

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
   	   RETURN NULL;   
   WHEN OTHERS
   THEN
   	   RAISE; 
   
END get_source_col;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nlb (p_nlb_batch_no nm_load_batches.nlb_batch_no%TYPE) RETURN NM_LOAD_BATCHES%ROWTYPE IS
--
   CURSOR cs_nlb (c_nlb_batch_no nm_load_batches.nlb_batch_no%TYPE) IS
   SELECT *
   FROM   nm_load_batches
   WHERE  nlb_batch_no = c_nlb_batch_no;
--
   l_found   BOOLEAN;
   l_rec_nlb nm_load_batches%ROWTYPE;
--
BEGIN
--
   OPEN  cs_nlb (p_nlb_batch_no);
   FETCH cs_nlb INTO l_rec_nlb;
   l_found := cs_nlb%FOUND;
   CLOSE cs_nlb;
--
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'nm_load_batches.nlb_batch_no = '||p_nlb_batch_no
                    );
   END IF;
--
   RETURN l_rec_nlb;
--
END get_nlb;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_cols_to_move (pi_nlf_id          IN     NM_LOAD_FILES.nlf_id%TYPE
                           ,pi_nld_id          IN     NM_LOAD_DESTINATIONS.nld_id%TYPE
                           ,po_tab_holding_col    OUT nm3type.tab_varchar2000
                           ,po_tab_dest_col       OUT nm3type.tab_varchar30
                           ) IS
--
   CURSOR cs_cols (c_nlf_id NM_LOAD_FILES.nlf_id%TYPE
                  ,c_nld_id NM_LOAD_DESTINATIONS.nld_id%TYPE
                  ) IS
   SELECT nlcd_dest_col,
          NVL(nlcd_source_col,'Null'),
          UPPER(SUBSTR(nlcd_source_col,1,INSTR(nlcd_source_col,'.')-1))
   FROM   nm_load_file_col_destinations
   WHERE  nlcd_nlf_id = c_nlf_id
   AND    nlcd_nld_id = c_nld_id
   AND    nlcd_source_col IS NOT NULL
   ORDER BY nlcd_seq_no;
--
   v_tab_holding_col_prefix nm3type.tab_varchar30;
--
   CURSOR c_check (cp_holding_col_prefix  nm_load_file_col_destinations.nlcd_source_col%TYPE) IS
   SELECT 'x'
   FROM   nm_load_file_destinations  nlfd,
          nm_load_destinations       nld
   WHERE  nlfd_nlf_id = pi_nlf_id
   AND    nld_id      = nlfd_nld_id
   AND    nld_table_short_name = cp_holding_col_prefix;
--
   v_dummy  VARCHAR2(1);
--
--
BEGIN
--
   OPEN  cs_cols(pi_nlf_id,pi_nld_id);
   FETCH cs_cols BULK COLLECT INTO po_tab_dest_col,po_tab_holding_col,v_tab_holding_col_prefix;
   CLOSE cs_cols;
--
   FOR v_recs IN 1..v_tab_holding_col_prefix.COUNT LOOP
--
       v_dummy := NULL;
       OPEN c_check(v_tab_holding_col_prefix(v_recs));
       FETCH c_check INTO v_dummy;
       CLOSE c_check;
--
       IF v_dummy IS NOT NULL THEN
          po_tab_holding_col(v_recs) := c_table_short_name_prefix ||po_tab_holding_col(v_recs);
       END IF;
--
   END LOOP;
--
--
END get_cols_to_move;
--
-----------------------------------------------------------------------------
--
PROCEDURE kick_nlb (p_nlb_batch_no nm_load_batches.nlb_batch_no%TYPE) IS
  PRAGMA autonomous_transaction;
BEGIN
   UPDATE nm_load_batches
   SET    nlb_date_modified = nlb_date_modified
   WHERE  nlb_batch_no      = p_nlb_batch_no;
   COMMIT;
END kick_nlb;
--
-----------------------------------------------------------------------------
--
function get_inv_location ( p_ne_id in number, p_start in number, p_end in number )
  return nm_placement_array is

CURSOR c1 ( c_ne_id IN NUMBER, c_start IN NUMBER, c_end IN NUMBER ) IS
  SELECT nm_ne_id_of, nm_slk, nm_end_slk, nm_cardinality, ne_length
  FROM nm_members, nm_elements
  WHERE nm_ne_id_in = c_ne_id
  AND nm_ne_id_of = ne_id
  AND nm_slk <= c_end
  AND nm_end_slk >= c_start
  AND ne_type='S';
  
retval nm_placement_array := nm_placement_array( nm_placement_array_type( nm_placement( null, null, null, null)));

l_ne_id nm3type.tab_number;
l_start nm3type.tab_number;
l_end   nm3type.tab_number;

l_s_slk nm3type.tab_number;
l_e_slk nm3type.tab_number;
l_card  nm3type.tab_number;

l_length nm3type.tab_number;

begin

  open c1 ( p_ne_id, p_start, p_end );
  fetch c1 bulk collect into l_ne_id, l_s_slk, l_e_slk, l_card, l_length;
  close c1;

  for i in 1..l_ne_id.count loop

    nm_debug.debug('Loop '||to_char(i)||' S_SLK = '||to_char( l_s_slk(i) )||' E_SLK = '||to_char( l_s_slk(i) )||' Dir = '||to_char(l_card(i)));

    if l_s_slk(i) >= p_start and
       l_e_slk(i) <= p_end then

       retval := retval.add_element( l_ne_id(i), 0, l_length(i), 0, FALSE);

    elsif l_s_slk(i) < p_start and
          l_e_slk(i) < p_end then

       if l_card(i) > 0 then

         retval := retval.add_element( l_ne_id(i), p_start - l_s_slk(i), l_length(i), 0, FALSE);

       else

         retval := retval.add_element( l_ne_id(i), 0, l_e_slk(i) - p_start, 0, FALSE);

       end if;

    elsif l_e_slk(i) > p_end and
          l_s_slk(i) > p_start then

       if l_card(i) > 0 then

         retval := retval.add_element( l_ne_id(i), 0, l_length(i) - (l_e_slk(i) - p_end), 0, FALSE);

       else

         retval := retval.add_element( l_ne_id(i), l_e_slk(i) - p_end , l_length(i), 0,  FALSE);

       end if;

    else

       if l_card(i) > 0 then

         retval := retval.add_element( l_ne_id(i), p_start - l_s_slk(i), l_length(i) - (l_e_slk(i) - p_end), 0, FALSE);

       else

         retval := retval.add_element( l_ne_id(i), l_e_slk(i) - p_end , l_e_slk(i) - p_start, 0, FALSE);

       end if;

    end if;

  end loop;

  return retval;
end;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_batch (p_batch_no IN NUMBER) IS

   CURSOR cs_nld (p_nlf_id nm_load_files.NLF_ID%TYPE
    		  	 ,p_table_name VARCHAR2
				 ) IS
       SELECT d.*
       FROM   nm_load_file_destinations f,
              nm_load_destinations d
       WHERE  f.nlfd_nlf_id = p_nlf_id
       AND    f.nlfd_nld_id = d.nld_id
       AND 	  UPPER(d.nld_table_name) = UPPER(p_table_name);
--
   CURSOR cs_triggers (p_table_name VARCHAR2) IS
	  SELECT t.trigger_name
	  FROM   hig_users h,
		     sys.all_triggers t	   
	  WHERE  h.hus_is_hig_owner_flag = 'Y'
	  AND	 h.hus_username = t.table_owner
	  AND    t.table_name   = UPPER(p_table_name)
	  AND    t.status		= 'ENABLED';
-- 
   l_block        nm3type.tab_varchar32767;
   l_tab_holding  nm3type.tab_varchar2000;
   l_tab_dest     nm3type.tab_varchar30;
--
   l_rec_nld_inv  nm_load_destinations%ROWTYPE;
   l_rec_nld_mem  nm_load_destinations%ROWTYPE;
   l_rec_nlb      nm_load_batches%ROWTYPE;
--
   l_rec_name_inv VARCHAR2(30);
   l_rec_name_mem VARCHAR2(30);
--
   FUNCTION get_record_name (p_nld_table_short_name VARCHAR2) RETURN VARCHAR2 IS
   BEGIN
       RETURN c_table_short_name_prefix||SUBSTR(p_nld_table_short_name,1,28);
   END get_record_name;
--
   PROCEDURE append (p_text VARCHAR2
                    ,p_nl   BOOLEAN DEFAULT TRUE
                    ) IS
   BEGIN
      nm3ddl.append_tab_varchar(l_block,p_text,p_nl);
   END append;
--
BEGIN

--   nm_debug.delete_debug(true);

   -- populate list of triggers
   OPEN cs_triggers('nm_members_all');
   FETCH cs_triggers BULK COLLECT INTO g_tab_triggers;
   CLOSE cs_triggers;  
   
   -- disable triggers
   set_triggers('DISABLE');
--   
   initialise_globals (p_batch_no);
--
   l_rec_nlb := get_nlb (p_batch_no);

   OPEN cs_nld (g_nlf_id,'nm_inv_items');
   FETCH cs_nld INTO l_rec_nld_inv;
   CLOSE cs_nld;
 
   OPEN cs_nld (g_nlf_id,'v_load_inv_mem_on_element');
   FETCH cs_nld INTO l_rec_nld_mem;
   CLOSE cs_nld;
--
   append ('DECLARE', FALSE);
   append ('--');
   append ('   CURSOR cs_rowid (c_batch_no NUMBER) IS');
   append ('      SELECT tab.ROWID  tab_rowid');
   append ('            ,nlbs.ROWID nlbs_rowid');
   append ('      FROM  '||g_holding_table_name||' tab,');
   append ('            nm_load_batch_status nlbs');
   append ('      WHERE tab.batch_no           = c_batch_no');
   append ('      AND   nlbs.nlbs_nlb_batch_no = tab.batch_no');
   append ('      AND   nlbs.nlbs_record_no    = tab.record_no');
   append ('      AND   nlbs.nlbs_status       IN ('||nm3flx.string('H')||','||nm3flx.string('V')||')');
   append ('      ORDER BY tab.batch_no, tab.record_no;');
   append ('--');
   append ('   CURSOR cs_load (c_tab_rowid ROWID, c_nlbs_rowid ROWID) IS');
   append ('     SELECT tab.*,');
   append ('            nlbs_status,');
   append ('            nlbs_text');
   append ('      FROM  '||g_holding_table_name||' tab,');
   append ('            nm_load_batch_status nlbs');
   append ('      WHERE  tab.ROWID  = c_tab_rowid');
   append ('      AND   nlbs.ROWID = c_nlbs_rowid;');
   append ('--');
   append ('   CURSOR cs_pla (p_ne_unique VARCHAR2');
   append ('                 ,p_inv_type VARCHAR2');
   append ('                 ,p_begin_mp NUMBER');
   append ('                 ,p_end_mp NUMBER) IS');   
   append ('      SELECT pl_ne_id,');
   append ('             pl_start,');
   append ('             pl_end');      
   append ('      FROM TABLE (get_inv_location (nm3net.get_ne_id(p_ne_unique,p_inv_type)');
   append ('	    	   	 				   ,p_begin_mp');
   append ('		   					       ,p_end_mp ).npa_placement_array ) a;');
   append ('--');
   append ('   l_tab_rowid        nm3type.tab_rowid;');
   append ('   l_tab_nlbs_rowid   nm3type.tab_rowid;');
   append ('   l_iit_ne_id        nm_inv_items_all.iit_ne_id%TYPE;'); 
   append ('   l_iit_admin_unit   nm_inv_items_all.iit_admin_unit%TYPE;');
   append ('   l_rec_nma 		  nm_members_all%ROWTYPE;');
   append ('   '||g_nlf_unique||'    cs_load%ROWTYPE;');
   append ('--');
   append ('   c_commit_threshold CONSTANT NUMBER := '||NVL(hig.get_sysopt('PCOMMIT'),100)||';');
   append ('--');
   append ('   PROCEDURE commit_and_lock IS');
   append ('   BEGIN');
   append ('      COMMIT;');
   append ('      nm3lock_gen.lock_nlb ('||p_batch_no||');');
   append ('   END commit_and_lock;');
   append ('--');
   append ('BEGIN');
   append ('--');
   append ('   commit_and_lock;');
   append ('--');
   append ('   OPEN  cs_rowid ('||p_batch_no||');');
   append ('   FETCH cs_rowid');
   append ('    BULK COLLECT');
   append ('    INTO l_tab_rowid');
   append ('        ,l_tab_nlbs_rowid;');
   append ('   CLOSE cs_rowid;');
   append ('--');
   append ('   FOR i IN 1..l_tab_rowid.COUNT');
   append ('    LOOP');
   append ('      OPEN  cs_load (l_tab_rowid(i),l_tab_nlbs_rowid(i));');
   append ('      FETCH cs_load INTO '||g_nlf_unique||';');
   append ('      CLOSE cs_load;');
   append ('      DECLARE');

   -- declare variable for inventory   		  
   l_rec_name_inv := get_record_name(l_rec_nld_inv.nld_table_short_name);
   append ('         '||l_rec_name_inv||' nm_inv_items%ROWTYPE;');

   -- declare variable for members
   l_rec_name_mem := get_record_name(l_rec_nld_mem.nld_table_short_name);
   append ('         '||l_rec_name_mem||' v_load_inv_mem_on_element%ROWTYPE;');

   append ('         l_sqlerrm nm3type.max_varchar2;');
   append ('      BEGIN');
   append ('         '||g_nlf_unique||'.nlbs_text   := Null;');
   append ('         SAVEPOINT top_of_loop;');
   append ('--');

   -- inventory source/destinations
   get_cols_to_move (pi_nlf_id          => l_rec_nlb.nlb_nlf_id
                    ,pi_nld_id          => l_rec_nld_inv.nld_id
                    ,po_tab_holding_col => l_tab_holding
                    ,po_tab_dest_col    => l_tab_dest
                    );

   FOR j IN 1..l_tab_holding.COUNT
    LOOP
      append ('         '||l_rec_name_inv||'.'||l_tab_dest(j)||' := '||l_tab_holding(j)||';');
   END LOOP;

   -- do the inventory item insert
   append ('--');
--   append ('         nm_debug.debug(''inserting l_rec_name_inv'');');
   append ('         nm3inv.insert_nm_inv_items('||l_rec_name_inv||');');
--   append ('         nm_debug.debug(''inserted l_rec_name_inv'');');
   append ('--');
   
   -- route source/destinations	  
   get_cols_to_move (pi_nlf_id          => l_rec_nlb.nlb_nlf_id
                    ,pi_nld_id          => l_rec_nld_mem.nld_id
                    ,po_tab_holding_col => l_tab_holding
                    ,po_tab_dest_col    => l_tab_dest
                    );

   FOR j IN 1..l_tab_holding.COUNT
   LOOP
      append ('         '||l_rec_name_mem||'.'||l_tab_dest(j)||' := '||l_tab_holding(j)||';');
   END LOOP;

   append ('--');  
   append ('         FOR r_pla IN cs_pla('||l_rec_name_mem||'.ne_unique,'||l_rec_name_mem||'.ne_nt_type,'||l_rec_name_mem||'.begin_mp,'||l_rec_name_mem||'.end_mp)');
   append ('         LOOP');
   append ('	        l_rec_nma.nm_ne_id_in      := '||l_rec_name_mem||'.iit_ne_id;');
   append ('	        l_rec_nma.nm_ne_id_of      := r_pla.pl_ne_id;');
   append ('	        l_rec_nma.nm_type 	       := ''I'';');
   append ('	        l_rec_nma.nm_obj_type      := '||l_rec_name_mem||'.iit_inv_type;');
   append ('	        l_rec_nma.nm_begin_mp      := r_pla.pl_start;');
   append ('	        l_rec_nma.nm_start_date    := NVL('||l_rec_name_mem||'.nm_start_date,TRUNC(SYSDATE));'); 
   append ('	        l_rec_nma.nm_end_date 	   := NULL;'); 
   append ('	        l_rec_nma.nm_end_mp 	   := r_pla.pl_end;');
   append ('	        l_rec_nma.nm_slk		   := 0;');
   append ('	        l_rec_nma.nm_cardinality   := 1;');
   append ('	        l_rec_nma.nm_admin_unit	   := '||l_rec_name_inv||'.iit_admin_unit;');
   append ('	        l_rec_nma.nm_date_created  := NULL;');
   append ('	        l_rec_nma.nm_date_modified := NULL;');
   append ('	        l_rec_nma.nm_modified_by   := NULL;');
   append ('	        l_rec_nma.nm_created_by	   := NULL;');
   append ('	        l_rec_nma.nm_seq_no		   := NULL;');
   append ('	        l_rec_nma.nm_seg_no		   := NULL;');
   append ('	        l_rec_nma.nm_true		   := NULL;');
   append ('	        l_rec_nma.nm_end_slk	   := NULL;');
   append ('	        l_rec_nma.nm_end_true	   := NULL;');
   append ('            nm_debug.debug(''inserting l_rec_nma'');');
   append ('         	nm3ins.ins_nm_all(l_rec_nma);');
   append ('            nm_debug.debug(''inserted l_rec_nma'');');
   append ('         END LOOP;');  
   append ('--');
   append ('         '||g_nlf_unique||'.nlbs_status := ''I'';');
   append ('--');
   append ('         IF MOD (i,c_commit_threshold) = 0');
   append ('          THEN');
   append ('            nm_debug.debug(''committing ''||i);');
   append ('            commit_and_lock;');
   append ('            nm_debug.debug(''committed'');');
   append ('            SAVEPOINT top_of_loop;');
   append ('         END IF;');
   append ('--');
   append ('      EXCEPTION');
   append ('         WHEN others');
   append ('          THEN');
   append ('            '||g_nlf_unique||'.nlbs_status := '||nm3flx.string('E')||';');
   append ('            '||g_nlf_unique||'.nlbs_text   := SUBSTR(SQLERRM,1,4000);');
   append ('            ROLLBACK TO top_of_loop;');
   append ('      END;');
   append ('--');
   append ('      nm3load.update_status ('||p_batch_no||','||g_nlf_unique||'.record_no'||','||g_nlf_unique||'.nlbs_status,'||g_nlf_unique||'.nlbs_text);'); 	     	  
   append ('--');
   append ('   END LOOP;');
   append ('--');
--   append ('   nm_debug.debug(''final commit'');');
   append ('   COMMIT;');
--   append ('   nm_debug.debug(''end'');');
   append ('--');
   append ('END;');

--   nm3ddl.debug_tab_varchar(l_block);

   -- execute the PL/SQL block
   nm3ddl.execute_tab_varchar(l_block);
--
   kick_nlb (p_batch_no);
--
   set_triggers('ENABLE');
--   
--   nm_debug.debug_on;

EXCEPTION
   WHEN OTHERS
   THEN
      set_triggers('ENABLE');
      RAISE;
   
END load_batch;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_inv_attributes (p_nlb_batch_no IN nm_load_batches.nlb_batch_no%TYPE) IS

   CURSOR cs_itaa (p_inv_type    nm_inv_type_attribs_all.ita_inv_type%TYPE
   		  		  ,p_attrib_name nm_inv_type_attribs_all.ita_attrib_name%TYPE ) IS 
      SELECT COUNT(rowid)
      FROM   nm_inv_type_attribs_all
      WHERE  ita_inv_type = p_inv_type
      AND	 ita_attrib_name = p_attrib_name ;
 
   TYPE t_ref_cursor IS REF CURSOR;
   c_ref_holding_table t_ref_cursor;
   c_ref_func_vals 	   t_ref_cursor;

   TYPE t_holding_table_rec IS RECORD (
     inv_type       nm_inv_type_attribs_all.ita_inv_type%TYPE,
     source_col_val VARCHAR2(255)  
   );

   TYPE t_holding_table IS TABLE OF t_holding_table_rec INDEX BY BINARY_INTEGER;
   l_tab_rec_holding_table t_holding_table;
   l_tab_func_vals 		   t_holding_table;

   l_dml_string	   	  VARCHAR2(1000);
   l_func_string	  VARCHAR2(255);
   l_col_string	   	  VARCHAR2(255);
   l_tmp			  VARCHAR2(255);
   l_value			  VARCHAR2(100);
   l_meaning		  VARCHAR2(100);
   l_count			  PLS_INTEGER;

BEGIN

   -- for each file_col_destination record
   FOR i IN 1..g_tab_rec_nlcd.COUNT
   LOOP

      -- dynamic sql to get distinct values from holding_table, excluding those that are not going to be validated anyway
      l_dml_string := ' SELECT DISTINCT inv_type,'
   				   || g_tab_rec_nlcd(i).nlcd_source_col || ' AS ' || g_tab_rec_nlcd(i).nlcd_dest_col
				   || ' FROM  nm_load_batch_status s,' 
				   || g_holding_table_name || ' ' || g_nlf_unique || ','
				   || ' nm_inv_type_attribs_all a'
				   || ' WHERE s.nlbs_nlb_batch_no = ' || p_nlb_batch_no 
				   || ' AND   s.nlbs_status IN (''H'',''V'')'
				   || ' AND   s.nlbs_nlb_batch_no = ' || g_nlf_unique || '.batch_no'
				   || ' AND   s.nlbs_record_no = ' || g_nlf_unique || '.record_no'
				   || ' AND   ' || g_nlf_unique || '.inv_type = a.ita_inv_type'
				   || ' AND   a.ita_attrib_name = ''' || g_tab_rec_nlcd(i).nlcd_dest_col || '''';

      nm_debug.debug ('l_dml_string:' || l_dml_string);

      BEGIN

         -- open ref cursor using the dynamic sql, collect into a table of records
         OPEN c_ref_holding_table FOR l_dml_string;
   	     FETCH c_ref_holding_table BULK COLLECT INTO l_tab_rec_holding_table;
   	     CLOSE c_ref_holding_table;   

      EXCEPTION
         WHEN OTHERS
	     THEN
	  	    IF SUBSTR(SQLERRM,1,9) = 'ORA-00907' 
		    THEN -- l_dml_string contains a function which cannot be called from SQL

   			   -- extract column name from function
			   l_tmp := SUBSTR(g_tab_rec_nlcd(i).nlcd_source_col
			 		 	      ,INSTR(g_tab_rec_nlcd(i).nlcd_source_col,g_nlf_unique) + LENGTH(g_nlf_unique) + 1);
			 
			   FOR j IN 1..LENGTH(l_tmp)
			   LOOP 
		 	      EXIT WHEN NOT valid_identifier_char (SUBSTR(l_tmp,j,1));
		   	      l_col_string := l_col_string || SUBSTR(l_tmp,j,1);
			   
			   END LOOP; 

			   -- create a cursor to return all values needed for the function 
		       l_dml_string := ' SELECT DISTINCT inv_type,' 
			 			    || l_col_string
						    || ' FROM ' || g_holding_table_name || ' ' || g_nlf_unique
						    || ' WHERE batch_no = ' || p_nlb_batch_no ;	

			   -- nm_debug.debug('exception l_dml_string:' || l_dml_string);							
							
		       OPEN c_ref_func_vals FOR l_dml_string;
		   	   FETCH c_ref_func_vals BULK COLLECT INTO l_tab_func_vals;
		   	   CLOSE c_ref_func_vals;   

			   FOR j IN 1..l_tab_func_vals.COUNT
			   LOOP -- for each value, call the function and populate l_tab_rec_holding_table ...
			 	    -- ... as it would have been had the exception not been raised

				  l_func_string := 'BEGIN '
				 			    || ':sc := '|| REPLACE(g_tab_rec_nlcd(i).nlcd_source_col
				         			      	          ,g_nlf_unique||'.'||l_col_string
			         				  			      ,''''||l_tab_func_vals(j).source_col_val||'''')||';' 
							    || 'END;' ; 
																													   
                  --nm_debug.debug('exception l_func_string:' || l_func_string);
				  
			 	  EXECUTE IMMEDIATE l_func_string USING OUT l_tab_rec_holding_table(j).source_col_val;
				 
				  l_tab_rec_holding_table(j).inv_type := l_tab_func_vals(j).inv_type;

			   END LOOP;		  						  

		    ELSE -- propogate the error
		 	    RAISE;

		    END IF;
      END;
  
      -- validate each holding table attribute/value combination 
      FOR j IN 1..l_tab_rec_holding_table.COUNT
      LOOP

   	     -- check if attribute validation rules are held 
	     OPEN cs_itaa ( l_tab_rec_holding_table(j).inv_type,g_tab_rec_nlcd(i).nlcd_dest_col );
	     FETCH cs_itaa INTO l_count;
	     CLOSE cs_itaa;

	     IF l_count > 0 
	     THEN  
	 
		 	BEGIN

-- 	           nm_debug.debug('validate_flex_inv inputs');
-- 	           nm_debug.debug('p_inv_type => ' || l_tab_rec_holding_table(j).inv_type);
-- 	           nm_debug.debug('p_attrib_name => ' || g_tab_rec_nlcd(i).nlcd_dest_col);
-- 	           nm_debug.debug('pi_value => ' || l_tab_rec_holding_table(j).source_col_val);

		       nm3inv.validate_flex_inv (p_inv_type               => l_tab_rec_holding_table(j).inv_type
		 						        ,p_attrib_name 		   	  => g_tab_rec_nlcd(i).nlcd_dest_col
				                        ,pi_value 				  => l_tab_rec_holding_table(j).source_col_val
				                        ,po_value 				  => l_value
				                        ,po_meaning 	   		  => l_meaning
				                        ,pi_validate_domain_dates => false) ; 

-- 	           nm_debug.debug('validate_flex_inv outputs');
-- 	           nm_debug.debug('po_value =>' || l_value);
-- 	           nm_debug.debug('po_meaning =>' || l_meaning);

			   update_batch_status (p_nlb_batch_no 		 => p_nlb_batch_no 
	  					  		   ,p_holding_table_name => g_holding_table_name
						  		   ,p_inv_name 			 => 'inv_type'
						  		   ,p_inv_type 			 => l_tab_rec_holding_table(j).inv_type
	  					  		   ,p_col_name 			 => g_tab_rec_nlcd(i).nlcd_source_col
						  		   ,p_value 			 => l_tab_rec_holding_table(j).source_col_val
						  		   ,p_text 				 => NULL
								   ,p_status			 => 'V');

			EXCEPTION
			   WHEN OTHERS
			   THEN 

                   nm_debug.debug (SQLERRM);

				   update_batch_status (p_nlb_batch_no 		 => p_nlb_batch_no 
		  					  		   ,p_holding_table_name => g_holding_table_name
							  		   ,p_inv_name 			 => 'inv_type'
							  		   ,p_inv_type 			 => l_tab_rec_holding_table(j).inv_type
		  					  		   ,p_col_name 			 => g_tab_rec_nlcd(i).nlcd_source_col
							  		   ,p_value 			 => l_tab_rec_holding_table(j).source_col_val
							  		   ,p_text 				 => SQLERRM
								   	   ,p_status			 => 'E');
--			       nm_debug.debug ('g_tab_rec_nlcd(i).nlcd_source_col:' || g_tab_rec_nlcd(i).nlcd_source_col);
--				   nm_debug.debug ('l_tab_rec_holding_table(j).inv_type:' || l_tab_rec_holding_table(j).inv_type);
--				   nm_debug.debug ('l_holding_table:' || l_holding_table);
--				   nm_debug.debug ('p_nlb_batch_no:' || p_nlb_batch_no);			      
			   
			END;
								  
         END IF;			 
  
      END LOOP;
	
   END LOOP;
  
EXCEPTION
   WHEN OTHERS
   THEN
	  nm_debug.debug(SQLERRM);

END validate_inv_attributes;
--
-----------------------------------------------------------------------------
--
-- validate the routes in the holding table
PROCEDURE validate_route_connectivity (p_nlb_batch_no IN nm_load_batches.nlb_batch_no%TYPE) IS

     CURSOR cs_nlf (p_nlb_batch_no nm_load_batches.nlb_batch_no%TYPE) IS
        SELECT f.nlf_id, 
    		 	 NVL(f.nlf_holding_table, 'NM_LD_'||f.nlf_unique||'_TMP'),
  		 	 f.nlf_unique
        FROM	 nm_load_batches b,   
      	 	 nm_load_files f
        WHERE  b.nlb_batch_no = p_nlb_batch_no 
        AND	 b.nlb_nlf_id = f.nlf_id ;
 
   CURSOR cs_nld ( p_nlf_id nm_load_files.nlf_id%TYPE ) IS
      SELECT f.nlfd_nld_id 
      FROM	 nm_load_destinations d,
  		 	 nm_load_file_destinations f  
      WHERE  d.nld_table_name='NM_INV_ITEMS' 
      AND	 d.nld_id = f.nlfd_nld_id
      AND	 f.nlfd_nlf_id = p_nlf_id ;

    TYPE t_routes IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
    l_tab_rec_routes t_routes;
 	   			  
    TYPE t_ref_cursor IS REF CURSOR;
    c_ref_routes t_ref_cursor;
 
  	l_tab_offending_datums	  nm3type.tab_varchar30;
 
	l_ne_id			  NUMBER(9);
    l_dml_string	  VARCHAR2(1000);
    l_src_ne_unique	  VARCHAR2(100);
    l_src_begin_mp	  VARCHAR2(100);
    l_src_end_mp	  VARCHAR2(100);      
  	l_route_status	  PLS_INTEGER;
  	l_error_text	  VARCHAR2(1000);
  
BEGIN

   -- get source columns names for destination columns
   l_src_ne_unique := get_source_col (g_nlf_id,'NE_UNIQUE');
   l_src_ne_unique := REPLACE (l_src_ne_unique,g_nlf_unique,'');									 
   l_src_ne_unique := REPLACE (l_src_ne_unique,'.','');

   -- loop thru the holding table
   l_dml_string := ' SELECT DISTINCT ' || l_src_ne_unique 
 				|| ' FROM  nm_load_batch_status s,' 
 				|| g_holding_table_name || ' h'
 				|| ' WHERE s.nlbs_nlb_batch_no = ' || p_nlb_batch_no
 				|| ' AND   s.nlbs_status IN (''H'',''V'')'
 				|| ' AND   s.nlbs_nlb_batch_no = h.batch_no'
 				|| ' AND   s.nlbs_record_no = h.record_no';
  			 											   											     
   nm_debug.debug (l_dml_string);
				
   OPEN c_ref_routes FOR l_dml_string;
   FETCH c_ref_routes BULK COLLECT INTO l_tab_rec_routes;	

   FOR i IN 1..l_tab_rec_routes.COUNT
   LOOP

   	  --nm_debug.debug ('l_tab_rec_routes(i): ' || l_tab_rec_routes(i));

	  BEGIN   
	  
         l_route_status := 0;	  		  
         nm3route_check.route_check (pi_ne_id 		      => nm3net.get_ne_id(l_tab_rec_routes(i),'RT')
	  			  				    ,po_route_status 	  => l_route_status
				  				    ,po_offending_datums  => l_tab_offending_datums);
									
      EXCEPTION						
	     WHEN OTHERS 
		 THEN

			update_batch_status (p_nlb_batch_no 	  => p_nlb_batch_no
		  					  	,p_holding_table_name => g_holding_table_name
							  	,p_ne_unique		  => l_tab_rec_routes(i) 
							  	,p_text 			  => 'Unable to validate route ' || l_tab_rec_routes(i) || ' - ' || SQLERRM			
								,p_status			  => 'E');
								
            nm_debug.debug ('Unable to validate route ' || l_tab_rec_routes(i) || ' - ' || SQLERRM);			
	  END;
	  
	  IF l_route_status <> 0 
	  THEN -- invalid route, flag all batch records for this route

	  	 --nm_debug.debug ('route: ' || l_tab_rec_routes(i));
   	     --nm_debug.debug ('route status: ' || l_route_status);

		 l_error_text := 'Invalid route ' || l_tab_rec_routes(i) || ' - offending datum(s): ';
		 FOR j IN 1..l_tab_offending_datums.COUNT
		 LOOP
		    --nm_debug.debug ('offending datum(s):' || l_tab_offending_datums(j));
			l_error_text := l_error_text || l_tab_offending_datums(j) || '/';
		 END LOOP;

		 nm_debug.debug (l_error_text);
		 update_batch_status (p_nlb_batch_no 	   => p_nlb_batch_no
		  					 ,p_holding_table_name => g_holding_table_name
							 ,p_ne_unique		   => l_tab_rec_routes(i) 
							 ,p_text 			   => l_error_text 			
							 ,p_status			   => 'E');
   	  	    
	  ELSE

		 update_batch_status (p_nlb_batch_no 	   => p_nlb_batch_no
	  					  	 ,p_holding_table_name => g_holding_table_name
						  	 ,p_ne_unique		   => l_tab_rec_routes(i) 
						  	 ,p_text 			   => NULL
							 ,p_status			   => 'V');			
							
	  END IF;   	  
	  				   
   END LOOP; 				
   
   CLOSE c_ref_routes;

--   nm_debug.debug_off;
   
END validate_route_connectivity;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_iit (p_rec_inv_items IN nm_inv_items%ROWTYPE) IS
BEGIN
  
--   nm_debug.debug_on;
   g_record_pos := g_record_pos + 1;   

   nm_debug.debug ('validate_iit:'||g_record_pos);
   
   IF g_record_pos = 1 
   THEN

  	  initialise_globals (nm3load.g_batch_no);
 
   	  get_batch_statuses; 

	  nm_debug.debug('g_tab_rec_nlbs.COUNT: '||g_tab_rec_nlbs.COUNT);
  
   	  validate_inv_attributes (nm3load.g_batch_no);

   	  validate_route_connectivity (nm3load.g_batch_no);

   END IF;   

   nm_debug.debug ('status for '||g_record_pos||'('||g_tab_rec_nlbs(g_record_pos).nlbs_record_no||') is '||g_tab_rec_nlbs(g_record_pos).nlbs_status);
   
   IF g_tab_rec_nlbs(g_record_pos).nlbs_status = 'E'
   THEN -- this record was not successfully validated

      nm_debug.debug ('raise_application_error');
	  raise_application_error(-20001,g_tab_rec_nlbs(g_record_pos).nlbs_text);
	   
   END IF;   	   	  	  

nm_debug.debug_sql_string('select nlbs_status,count(rowid) from nm_load_batch_status where nlbs_nlb_batch_no='||nm3load.g_batch_no||' group by nlbs_status');   
EXCEPTION
WHEN OTHERS
THEN

nm_debug.debug_sql_string('select nlbs_status,count(rowid) from nm_load_batch_status where nlbs_nlb_batch_no='||nm3load.g_batch_no||' group by nlbs_status');

   RAISE;
	  
END validate_iit;	  
--
-----------------------------------------------------------------------------
--
PROCEDURE insert_iit (p_rec_inv_items IN nm_inv_items%ROWTYPE) IS
BEGIN

   nm_debug.debug ('insert_iit:'||g_record_pos);

   IF NOT g_ins_called  
   THEN
   	  
	  g_ins_called := TRUE;
   
  	  initialise_globals (nm3load.g_batch_no);

  	  load_batch (nm3load.g_batch_no);   

   END IF;	  

   nm_debug.debug ('raise_application_error?????');
   nm_debug.debug ('g_tab_rec_nlbs(g_record_pos).nlbs_status'||g_tab_rec_nlbs(g_record_pos).nlbs_status);
		   
   IF g_tab_rec_nlbs(g_record_pos).nlbs_status = 'E'
   THEN -- this record was not successfully inserted

      nm_debug.debug ('raise_application_error');
	     
   	  raise_application_error(-20001,g_tab_rec_nlbs(g_record_pos).nlbs_text);
   	   
   END IF;   

EXCEPTION
WHEN OTHERS
THEN
   RAISE;
     
END insert_iit;	  
--
-----------------------------------------------------------------------------
--
PROCEDURE insert_mem (p_rec_mem IN v_load_inv_mem_on_element%ROWTYPE) IS

BEGIN

   nm_debug.debug ('insert_mem:'||g_record_pos);

   nm_debug.debug ('raise_application_error?????');
   nm_debug.debug ('g_tab_rec_nlbs(g_record_pos).nlbs_status'||g_tab_rec_nlbs(g_record_pos).nlbs_status);
	
   IF g_tab_rec_nlbs(g_record_pos).nlbs_status = 'E'
   THEN -- this record was not successfully inserted

      nm_debug.debug ('raise_application_error');   

   	  raise_application_error(-20001,g_tab_rec_nlbs(g_record_pos).nlbs_text);

   END IF;   	   	  	  

EXCEPTION
WHEN OTHERS
THEN	  
   RAISE;

END insert_mem;	  
	  
END x_ky_bulk_csv;
/
