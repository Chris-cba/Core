CREATE OR REPLACE PACKAGE BODY nm0575
AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm0575.pkb	1.6 05/29/07
--       Module Name      : nm0575.pkb
--       Date into SCCS   : 07/05/29 11:19:07
--       Date fetched Out : 07/06/13 14:10:44
--       SCCS Version     : 1.6
--
--
--   Author : Graeme Johnson
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '"@(#)nm0575.pkb	1.6 05/29/07"';

  g_package_name CONSTANT varchar2(30) := 'NM0575';

  g_network_placement_array  nm_placement_array; -- referred to when processing assets to close/delete     
  g_tab_selected_categories  nm3type.tab_varchar4; -- populated by the form


  g_tab_selected_xsps        nm3type.tab_varchar4; -- populated by the form
          
  g_current_result_set_id    nm_gaz_query_item_list.NGQI_JOB_ID%TYPE;
  
  g_delete                   CONSTANT VARCHAR2(1) := 'D';
  g_close                    CONSTANT VARCHAR2(1) := 'C';
  
  g_success_message          CONSTANT nm_errors.ner_descr%TYPE :=   hig.get_ner(pi_appl => 'HIG'
                                                                               ,pi_id  => 95).ner_descr;    
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
PROCEDURE set_g_tab_selected_categories(pi_tab_selected_categories IN nm3type.tab_varchar4) IS

    PROCEDURE populate_nm0575_possible_xsps IS 

    --
    -- for our given list of asset categories
    -- insert into a global temp table a list of xsp_restraints
    -- that could be applied to asset types within those categories
    --
    -- This global temp table is used by for NM0575 as the basis of a block
    -- that the punters can select from

     l_sql         varchar2(2000);
     l_cat_restr   varchar2(100);

    BEGIN

    --
    -- add any records that are not already there for our given asset categories
    --
     IF g_tab_selected_categories.COUNT = 0 THEN
     
         delete from nm0575_possible_xsps;
         
     ELSE
     
         FOR i IN 1..g_tab_selected_categories.COUNT LOOP
           IF i = 1 THEN
             l_cat_restr := 'AND nit_category IN ('||nm3flx.string(g_tab_selected_categories(i));
           ELSE     
             l_cat_restr := l_cat_restr ||','||nm3flx.string(g_tab_selected_categories(i));
           END IF;
       
           IF i = g_tab_selected_categories.COUNT THEN
              l_cat_restr := l_cat_restr ||')'||chr(10);
           END IF;       
         END LOOP;
     
         l_sql :=                        'INSERT INTO nm0575_possible_xsps(xsp_value'||chr(10);
         l_sql := l_sql||   '                                ,xsp_restraint_count)'||chr(10);
         l_sql := l_sql||   'SELECT xsr_x_sect_value'||chr(10);
         l_sql := l_sql||   '     , count(*) '||chr(10);
         l_sql := l_sql||   'FROM   nm_xsp_restraints'||chr(10);
         l_sql := l_sql||   '       , nm_inv_types'||chr(10);
         l_sql := l_sql||   'WHERE xsr_ity_inv_code = nit_inv_type'||chr(10);

         l_sql := l_sql||   l_cat_restr; 

         l_sql := l_sql||   'AND NOT EXISTS (select 1'||chr(10);
         l_sql := l_sql||   '                from nm0575_possible_xsps'||chr(10);
         l_sql := l_sql||   '                where xsp_value = xsr_x_sect_value)'||chr(10);
         l_sql := l_sql||   'GROUP BY xsr_x_sect_value'||chr(10);

        --nm_debug.debug(l_sql);
         execute immediate(l_sql);

--
-- now that we have possible xsps we need
-- to throw something into the description field
-- if all of this were done as part of the initial
-- inserts we would potentially have had duplicate records xsp_value with different xsp descriptions
-- 
         update nm0575_possible_xsps
         set xsp_descr = (select min(nwx_descr)
                          from   nm_nw_xsp
                          where  nwx_x_sect = xsp_value);

        --
        -- remove any records that are there for previously selected asset categories
        --

         l_sql :=         'delete from nm0575_possible_xsps'||chr(10);
         l_sql := l_sql ||'where not exists (select 1'||chr(10);
         l_sql := l_sql ||'from nm_xsp_restraints, nm_inv_types_all'||chr(10);
    --     l_sql := l_sql ||'where xsr_x_sect_value = nwx_x_sect'||chr(10);
         l_sql := l_sql ||'where xsr_ity_inv_code = nit_inv_type'||chr(10);
         l_sql := l_sql||   l_cat_restr; 
         l_sql := l_sql ||'and xsr_x_sect_value = xsp_value)'||chr(10);

         nm_debug.debug(l_sql);
         execute immediate(l_sql); 

    END IF;


    END populate_nm0575_possible_xsps;

BEGIN
 g_tab_selected_categories := pi_tab_selected_categories;
 populate_nm0575_possible_xsps;
END set_g_tab_selected_categories;

FUNCTION setup_gaz_query(pi_source_ne_id       IN nm_gaz_query.ngq_source_id%TYPE
                        ,pi_begin_mp           IN nm_gaz_query.ngq_begin_mp%TYPE
                        ,pi_end_mp             IN nm_gaz_query.ngq_end_mp%TYPE
                        ,pi_ambig_sub_class    IN nm_gaz_query.ngq_ambig_sub_class%TYPE) RETURN nm_gaz_query.ngq_id%TYPE IS

   l_rec_ngq nm_gaz_query%ROWTYPE;
   l_seq     PLS_INTEGER;
   
   
   PROCEDURE add_xsp_restrictions(pi_ngq_id nm_gaz_query.ngq_id%TYPE) IS


     l_last_ngqt nm_gaz_query_types.ngqt_seq_no%TYPE := -1;
     l_operator  VARCHAR2(3);
     l_seq       pls_integer :=0;

   BEGIN

      --
      -- loop around all asset types for the gaz query and join to selected XSP types
      -- and create the necessary NM_GAZ_QUERY_ATTRIBS and NM_GAZ_QUERY_VALUES records
      --
      FOR t IN (select * 
                from  nm_gaz_query_types
                     ,nm0575_possible_xsps
                     ,nm_inv_types_all
                where ngqt_ngq_id = pi_ngq_id
                and   nit_inv_type = ngqt_item_type
                and   nit_x_sect_allow_flag = 'Y'  -- only add xsp restriction to those asset types that allow it
                and   xsp_selected = 'Y'
                order by ngqt_ngq_id, ngqt_seq_no) LOOP
               
           --
           -- if this is the first record for the asset type to be processed
           -- the treat different to if it is second, third, fourth etc
           --
           IF l_last_ngqt = t.ngqt_seq_no THEN     
                l_operator := 'OR';
           ELSE
                l_operator := 'AND';
                l_seq := 0;
           END IF;
                                                      
           l_last_ngqt := t.ngqt_seq_no;
           l_seq := l_seq +1;
                           
           insert into nm_gaz_query_attribs(ngqa_ngq_id
                                           ,ngqa_ngqt_seq_no
                                           ,ngqa_seq_no
                                           ,ngqa_attrib_name
                                           ,ngqa_operator
                                           ,ngqa_condition)
            values (t.ngqt_ngq_id
                   ,t.ngqt_seq_no
                   ,l_seq
                   ,'IIT_X_SECT'
                   ,l_operator
                   ,'=');
                   
            insert into nm_gaz_query_values(ngqv_ngq_id
                                           ,ngqv_ngqt_seq_no
                                           ,ngqv_ngqa_seq_no
                                           ,ngqv_sequence
                                           ,ngqv_value)
                        VALUES                                       
                               (t.ngqt_ngq_id
                               ,t.ngqt_seq_no
                               ,l_seq
                               ,1
                               ,t.xsp_value);
        
         END LOOP;        
        
        commit;
   exception
    when others then
     raise_application_error(-20001,sqlerrm);
   
   END add_xsp_restrictions;
 
BEGIN
  
   l_rec_ngq := Null;
   
   l_rec_ngq.ngq_id                  := nm3seq.next_ngq_id_seq;

   nm3gaz_qry.set_ngq_source_etc(pi_ne_id         => pi_source_ne_id
                                ,po_ngq_source_id => l_rec_ngq.ngq_source_id
                                ,po_ngq_source    => l_rec_ngq.ngq_source
                                ,po_ngq_query_all_items => l_rec_ngq.ngq_query_all_items); 
  
   l_rec_ngq.ngq_open_or_closed      := nm3gaz_qry.c_closed_query;
   l_rec_ngq.ngq_items_or_area       := nm3gaz_qry.c_items_query;
   l_rec_ngq.ngq_begin_mp            := pi_begin_mp;
   l_rec_ngq.ngq_begin_datum_ne_id   := Null;
   l_rec_ngq.ngq_begin_datum_offset  := Null;
   l_rec_ngq.ngq_end_mp              := pi_end_mp;
   l_rec_ngq.ngq_end_datum_ne_id     := Null;
   l_rec_ngq.ngq_end_datum_offset    := Null;
   l_rec_ngq.ngq_ambig_sub_class     := pi_ambig_sub_class;
   nm3ins.ins_ngq (l_rec_ngq);


--
-- set a global placement array that stores the network that the gaz
-- query was restricted on
-- this is used when processing assets in order to ascertain whether
-- a given asset is placed over just the network we restricted on
-- or it is only partially over this network
-- 
   IF l_rec_ngq.ngq_query_all_items = 'N' THEN
    g_network_placement_array := nm3pla.get_placement_from_ne(p_ne_id_in => l_rec_ngq.ngq_source_id);
   END IF;



--nm_debug.debug_on;
--nm3debug.debug_ngq(l_rec_ngq);
   
--
   nm3gaz_qry.add_inv_types_for_categories(pi_ngq_id              => l_rec_ngq.ngq_id
                                          ,pi_tab_categories      => g_tab_selected_categories
                                          ,pi_exclude_off_network => TRUE);


--
-- set up some restrictions on XSPs to our gaz query
--
 add_xsp_restrictions(pi_ngq_id => l_rec_ngq.ngq_id); 

   
   RETURN(l_rec_ngq.ngq_id);                                           

END setup_gaz_query;
--
-----------------------------------------------------------------------------
--
FUNCTION get_current_result_set_id RETURN nm_gaz_query_item_list.NGQI_JOB_ID%TYPE IS

BEGIN
  RETURN(g_current_result_set_id);
END get_current_result_set_id;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_query(pi_source_ne_id        IN nm_gaz_query.ngq_source_id%TYPE
                  ,pi_begin_mp            IN nm_gaz_query.ngq_begin_mp%TYPE
                  ,pi_end_mp              IN nm_gaz_query.ngq_end_mp%TYPE
                  ,pi_ambig_sub_class     IN nm_gaz_query.ngq_ambig_sub_class%TYPE) IS


 l_ngq_id nm_gaz_query.ngq_id%TYPE;  
 
BEGIN

 --
 -- a precursor to calling this procedure is that the
 -- set_g_tab_selected_categories has been called
 -- if it's not been set then we just won't bother doing anything cos
 -- there would be no results returned by gaz query
 --
 IF  g_tab_selected_categories.COUNT >0 THEN

   l_ngq_id :=  setup_gaz_query(pi_source_ne_id       => pi_source_ne_id
                               ,pi_begin_mp           => pi_begin_mp
                               ,pi_end_mp             => pi_end_mp
                               ,pi_ambig_sub_class    => pi_ambig_sub_class);
                                     
   g_current_result_set_id := nm3gaz_qry.perform_query (pi_ngq_id => l_ngq_id);
--   po_tab_summary_results := get_tab_summary_results;
 END IF;   

END do_query;
--
-----------------------------------------------------------------------------
--
FUNCTION asset_is_partial(pi_asset_pla IN nm_placement_array
                         ,pi_network_pla IN nm_placement_array) RETURN BOOLEAN IS

 l_difference_pla                 nm_placement_array;

BEGIN

 IF NOT g_network_placement_array.is_empty AND NOT pi_network_pla.is_empty THEN

   l_difference_pla := nm3pla.subtract_pl_from_pl(p_pl_main      => pi_asset_pla
                                                 ,p_pl_to_remove => pi_network_pla);   

   RETURN(NOT l_difference_pla.is_empty);

 ELSE
  RETURN(FALSE);
 END IF;   
      

EXCEPTION
  WHEN others THEN
    RETURN(FALSE);

END asset_is_partial;                                      
--
-----------------------------------------------------------------------------
--
PROCEDURE process_asset(pi_iit_ne_id IN nm_inv_items_all.iit_ne_id%TYPE
                       ,pi_action    IN VARCHAR2
                       ,pi_process_partial IN VARCHAR2
                       ,pi_end_location_only IN VARCHAR2
                       ,pi_effective_date IN DATE DEFAULT nm3user.get_effective_date) IS

--
-- This is a generic routine that will deal with hierachical and non-hierarchical asset 
-- end-dating or deletion 
--
   CURSOR cs_hierarchy (pi_item_id nm_inv_item_groupings.iig_item_id%TYPE) IS
   SELECT iig_item_id
    FROM  nm_inv_item_groupings
   START WITH iig_parent_id = pi_item_id
   CONNECT BY iig_parent_id = PRIOR iig_item_id;
--
   l_tab_child_ne_id  nm3type.tab_number;
   
   l_iit_rec nm_inv_items_all%ROWTYPE;
   l_log_message nm0575_event_log.log_message%TYPE;
   
   c_deleting CONSTANT BOOLEAN := UPPER(pi_action) = g_delete;
   c_end_location_only CONSTANT BOOLEAN := UPPER(pi_end_location_only) = 'Y';
   
   PROCEDURE process_itg IS
   
   BEGIN
           ---------------------------------------------------------------
           -- If we are trashing everything then
           -- Update all NM_INV_TYPE_GROUPINGS dealing with children first
           ---------------------------------------------------------------
           IF NOT c_end_location_only THEN
              IF c_deleting THEN

                FORALL l_count IN 1..l_tab_child_ne_id.COUNT
                DELETE nm_inv_item_groupings_all
                WHERE  iig_item_id  = l_tab_child_ne_id(l_count);
        
                DELETE nm_inv_item_groupings_all
                WHERE  iig_item_id  = l_iit_rec.iit_ne_id;
      
              ELSE

                FORALL l_count IN 1..l_tab_child_ne_id.COUNT
                UPDATE nm_inv_item_groupings
                 SET   iig_end_date = pi_effective_date
                WHERE  iig_item_id  = l_tab_child_ne_id(l_count)
                 AND   NVL(iig_end_date,pi_effective_date) >= pi_effective_date;

                UPDATE nm_inv_item_groupings
                 SET   iig_end_date = pi_effective_date
                WHERE  iig_item_id  = l_iit_rec.iit_ne_id
                 AND   NVL(iig_end_date,pi_effective_date) >= pi_effective_date;

         
              END IF;         
           
           END IF; -- NOT end location only
   
   
   END process_itg;
--
---------
--   
   PROCEDURE process_members IS
   
   BEGIN

         --
         -- NM_MEMBERS - done regardless
         --
          IF c_deleting THEN

           FORALL l_count IN 1..l_tab_child_ne_id.COUNT
             DELETE nm_members_all
             WHERE  nm_ne_id_in = l_tab_child_ne_id(l_count);

           DELETE nm_members_all
           WHERE  nm_ne_id_in = l_iit_rec.iit_ne_id;      


          ELSE

           FORALL l_count IN 1..l_tab_child_ne_id.COUNT
             UPDATE nm_members
              SET   nm_end_date = pi_effective_date
             WHERE  nm_ne_id_in = l_tab_child_ne_id(l_count)
              AND   NVL(nm_end_date,pi_effective_date) >= pi_effective_date;

           UPDATE nm_members
            SET   nm_end_date = pi_effective_date
           WHERE  nm_ne_id_in = l_iit_rec.iit_ne_id
            AND   NVL(nm_end_date,pi_effective_date) >= pi_effective_date;      
      
          END IF;     
   
   
   
   END process_members;   
--
---------
--   
   PROCEDURE process_inv_items IS
   
   BEGIN
   
           --
           -- If we are trashing everything then
           -- NM_INV_ITEMS records
           --
          IF NOT c_end_location_only THEN
           
           IF c_deleting THEN

              FORALL l_count IN 1..l_tab_child_ne_id.COUNT
                 DELETE nm_inv_items_all
                 WHERE  iit_ne_id    = l_tab_child_ne_id(l_count);
          
                 DELETE nm_inv_items_all
                 WHERE  iit_ne_id    = l_iit_rec.iit_ne_id;   
   
           ELSE 
   
              FORALL l_count IN 1..l_tab_child_ne_id.COUNT
                 UPDATE nm_inv_items
                  SET   iit_end_date = pi_effective_date
                 WHERE  iit_ne_id    = l_tab_child_ne_id(l_count)
                  AND   NVL(iit_end_date,pi_effective_date) >= pi_effective_date;
          
                 UPDATE nm_inv_items
                  SET   iit_end_date = pi_effective_date
                 WHERE  iit_ne_id    = l_iit_rec.iit_ne_id;

           END IF;
  
         END IF; -- NOT end location only    
   
   
   END process_inv_items;
--
---------
--   
  PROCEDURE process_doc_assocs IS

  BEGIN

           -- if we are trashing everything then
           -- DOC_ASSOCS
           --
           
          IF NOT c_end_location_only THEN           

           FORALL l_count IN 1..l_tab_child_ne_id.COUNT
           DELETE FROM doc_assocs
           WHERE  das_rec_id   = TO_CHAR(l_tab_child_ne_id(l_count))
           AND    das_table_name in ('NM_INV_ITEMS_ALL','NM_INV_ITEMS','INV_ITEMS_ALL','INV_ITEMS'); 

           DELETE FROM doc_assocs
           WHERE  das_rec_id   = TO_CHAR(l_iit_rec.iit_ne_id)
           AND    das_table_name in ('NM_INV_ITEMS_ALL','NM_INV_ITEMS','INV_ITEMS_ALL','INV_ITEMS'); 


         END IF; -- NOT end location only
  
  
  END process_doc_assocs;

   
   PROCEDURE log_event(pi_log_iit_inv_type      IN nm0575_event_log.LOG_IIT_INV_TYPE%TYPE
                      ,pi_log_action            IN nm0575_event_log.log_action%TYPE
                      ,pi_log_iit_ne_id         IN nm0575_event_log.log_iit_ne_id%TYPE
                      ,pi_log_iit_primary_key   IN nm0575_event_log.log_iit_primary_key%TYPE
                      ,pi_log_iit_descr         IN nm0575_event_log.log_iit_descr%TYPE
                      ,pi_log_message           IN nm0575_event_log.log_message%TYPE
                      ,pi_log_error_flag        IN nm0575_event_log.log_error_flag%TYPE) IS 
                      
   BEGIN    
   
     INSERT INTO NM0575_EVENT_LOG(log_iit_inv_type
                                 ,log_action
                                 ,log_iit_ne_id
                                 ,log_iit_primary_key
                                 ,log_iit_descr
                                 ,log_message
                                 ,log_error_flag)
     VALUES (pi_log_iit_inv_type                            
            ,pi_log_action
            ,pi_log_iit_ne_id
            ,pi_log_iit_primary_key
            ,pi_log_iit_descr
            ,pi_log_message
            ,pi_log_error_flag);


  END log_event;   
   
--
BEGIN
--
   l_iit_rec := nm3inv.GET_INV_ITEM_ALL(pi_ne_id => pi_iit_ne_id);

--
-- if we have to ignore partially located assets then we need to 
-- identify whether the asset is partially located in the first place and
-- act accordingly
--
   IF pi_process_partial = 'N' AND  asset_is_partial(pi_asset_pla   => nm3pla.get_placement_from_ne(p_ne_id_in => pi_iit_ne_id)
                                                   ,pi_network_pla => g_network_placement_array) THEN

                            
          log_event(pi_log_iit_inv_type     => l_iit_rec.iit_inv_type
                   ,pi_log_action           => pi_action
                   ,pi_log_iit_ne_id        => l_iit_rec.iit_ne_id
                   ,pi_log_iit_primary_key  => l_iit_rec.iit_primary_key
                   ,pi_log_iit_descr        => l_iit_rec.iit_descr
                   ,pi_log_message          => 'Partially located asset - not processed'
                   ,pi_log_error_flag       => 'N' );
                   
   ELSE                                                                  
   
           --  This procedure is for updating the end date of those NM_INV_ITEMS +
           --   NM_INV_ITEM_GROUPINGS records when an inventory item who is a parent is end-dated
           --
           --
           OPEN  cs_hierarchy (l_iit_rec.iit_ne_id);
           FETCH cs_hierarchy BULK COLLECT INTO l_tab_child_ne_id;
           CLOSE cs_hierarchy;

           process_itg;
           
           process_members;
           
           process_inv_items;

           process_doc_assocs;
           
           IF c_end_location_only THEN
             l_log_message := g_success_message||' [Location only]';
           ELSE
             l_log_message := g_success_message;
           END IF;                        
           
          log_event(pi_log_iit_inv_type     => l_iit_rec.iit_inv_type
                   ,pi_log_action           => pi_action
                   ,pi_log_iit_ne_id        => l_iit_rec.iit_ne_id
                   ,pi_log_iit_primary_key  => l_iit_rec.iit_primary_key
                   ,pi_log_iit_descr        => l_iit_rec.iit_descr
                   ,pi_log_message          => l_log_message
                   ,pi_log_error_flag       => 'N' );
                   
   END IF; -- partial or not                   

   COMMIT;
EXCEPTION
  WHEN OTHERS THEN 

   l_log_message := SUBSTR(sqlerrm,1,500);
     
  log_event(pi_log_iit_inv_type     => l_iit_rec.iit_inv_type
           ,pi_log_action           => pi_action
           ,pi_log_iit_ne_id        => l_iit_rec.iit_ne_id
           ,pi_log_iit_primary_key  => l_iit_rec.iit_primary_key
           ,pi_log_iit_descr        => l_iit_rec.iit_descr
           ,pi_log_message          => l_log_message
           ,pi_log_error_flag       => 'Y' );
--
END process_asset;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_event_log IS

BEGIN

delete from NM0575_EVENT_LOG;
commit;

END;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_tab_asset_types(pi_tab_asset_types  IN nm3type.tab_varchar4
                                 ,pi_action           IN VARCHAR2
                                 ,pi_process_partial  IN VARCHAR2) IS


 l_tab_ne_id nm3type.tab_number;
 
 CURSOR c_items(cp_iit_inv_type IN nm_inv_items_all.iit_inv_type%TYPE) IS
 select iit_ne_id
 from   nm_inv_items_all
       ,nm_gaz_query_item_list
 where ngqi_job_id =  g_current_result_set_id 
 and   ngqi_item_id = iit_ne_id
 and   iit_inv_type =  cp_iit_inv_type; 

 l_nit_rec nm_inv_types_all%ROWTYPE; 
  

BEGIN

--nm_debug.debug_on;
 
 FOR t IN 1..pi_tab_asset_types.COUNT LOOP

  --
  -- for the given asset type get the asset type details
  -- cos we need to take into account the NIT_END_LOC_ONLY
  -- ie do we trash everything OR just the location
  --
  l_nit_rec := nm3get.get_nit_all(pi_nit_inv_type => pi_tab_asset_types(t));
--
-- get all items of the given asset type
--
  OPEN c_items(pi_tab_asset_types(t));
  FETCH c_items BULK COLLECT INTO l_tab_ne_id;
  CLOSE c_items;
 
 
 
 FOR i IN 1..l_tab_ne_id.COUNT LOOP
  
    process_asset(pi_iit_ne_id       => l_tab_ne_id(i)
                 ,pi_action          => pi_action
                 ,pi_process_partial => pi_process_partial
                 ,pi_end_location_only => l_nit_rec.nit_end_loc_only);
          
 END LOOP;
 
 
END LOOP;           
--nm_debug.debug_off; 
  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'delete_inv_items');

END process_tab_asset_types;
--
-----------------------------------------------------------------------------
--
PROCEDURE tidy_up IS

BEGIN

 delete from nm_gaz_query_item_list
 where  ngqi_job_id = g_current_result_set_id;
 
 commit;

END tidy_up;

END nm0575;
/


