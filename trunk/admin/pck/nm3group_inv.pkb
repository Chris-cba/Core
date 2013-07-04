CREATE OR REPLACE PACKAGE BODY nm3group_inv AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3group_inv.pkb-arc   2.4   Jul 04 2013 16:04:12   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3group_inv.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:04:12  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:12  $
--       Version          : $Revision:   2.4  $
--       Based on SCCS version : 1.7
-------------------------------------------------------------------------
--   Author : Kevin Angus
--
--   nm3group_inv body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
  ------------
  --exceptions
  ------------
  e_generic_error EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_generic_error, -20000);
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
   g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.4  $';
   g_package_name CONSTANT varchar2(30) := 'nm3group_inv';
   c_nl           CONSTANT varchar2(1) := CHR(10);
  -----------
  --variables
  -----------
  g_empty_iit_rec_do_not_modify nm_inv_items%ROWTYPE;
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
PROCEDURE check_link_types(pi_ne_ne_id  IN nm_group_inv_link.ngil_ne_ne_id%TYPE
                          ,pi_iit_ne_id IN nm_group_inv_link.ngil_iit_ne_id%TYPE
                          ) IS

  l_dummy pls_integer;
                          
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'check_link_types');

  ---------------------------------------------------------------
  --check the types of the specified items are valid to be linked
  ---------------------------------------------------------------
  SELECT
    1
  INTO
    l_dummy
  FROM
    nm_elements        ne,
    nm_inv_items       iit,
    nm_group_inv_types ngit
  WHERE
    ne.ne_id = pi_ne_ne_id
  AND
    ne.ne_gty_group_type = ngit.ngit_ngt_group_type
  AND
    iit.iit_ne_id = pi_iit_ne_id
  AND
    iit.iit_inv_type = ngit.ngit_nit_inv_type;
              

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'check_link_types');

EXCEPTION
  WHEN no_data_found
  THEN
    --no link found for the types of the specified items
    hig.raise_ner(pi_appl               => nm3type.c_net
                 ,pi_id                 => 348
                 ,pi_supplementary_info =>    'Element ne_id: ' || pi_ne_ne_id
                                           || ' Inventory ne_id: ' || pi_iit_ne_id);
  
  WHEN too_many_rows
  THEN
    hig.raise_ner(pi_appl               => nm3type.c_hig
                 ,pi_id                 => 105
                 ,pi_supplementary_info =>    g_package_name || '.check_link_types pi_ne_ne_id: ' || pi_ne_ne_id 
                                           || ' pi_iit_ne_id: ' || pi_iit_ne_id);
    
END check_link_types;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_link_for_group(pi_group_type IN nm_group_inv_types.ngit_ngt_group_type%TYPE
                            ,pi_inv_type   IN nm_group_inv_types.ngit_nit_inv_type%TYPE
                            ) IS

  l_ngit_rec nm_group_inv_types%ROWTYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'set_link_for_group');

  --try updating
  UPDATE
    nm_group_inv_types ngit
  SET
    ngit.ngit_nit_inv_type = pi_inv_type
  WHERE
    ngit.ngit_ngt_group_type = pi_group_type;
    
  IF SQL%rowcount < 1
  THEN
    --does not already exist, so insert
    l_ngit_rec.ngit_ngt_group_type := pi_group_type;
    l_ngit_rec.ngit_nit_inv_type   := pi_inv_type;
    
    nm3ins.ins_ngit(p_rec_ngit => l_ngit_rec);
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'set_link_for_group');

END set_link_for_group;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_inv_item_for_element(pi_ne_id              IN     nm_group_inv_link.ngil_ne_ne_id%TYPE
                                  ,pi_group_type         IN     nm_group_inv_types.ngit_ngt_group_type%TYPE
                                  ,pi_raise_if_not_found IN      boolean DEFAULT TRUE
                                  ,po_iit_ne_id             OUT nm_group_inv_link.ngil_iit_ne_id%TYPE
                                  ,po_inv_type              OUT nm_group_inv_types.ngit_nit_inv_type%TYPE
                                  ) IS
                                  
  l_get_item boolean := TRUE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_item_for_element');

  --get inv type associated with supplied group type
  po_inv_type := nm3get.get_ngit(pi_ngit_ngt_group_type => pi_group_type).ngit_nit_inv_type;

  --get inv item associated with supplied group
  po_iit_ne_id := nm3get.get_ngil(pi_ngil_ne_ne_id => pi_ne_id).ngil_iit_ne_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_item_for_element');

EXCEPTION
  WHEN e_generic_error
  THEN
    IF (hig.check_last_ner(pi_appl => nm3type.c_hig
                          ,pi_id   => 67))
       AND NOT pi_raise_if_not_found
    THEN
      --don't want an error raised when group or item not found
      po_iit_ne_id := NULL;
      po_inv_type  := NULL;
    ELSE
      RAISE;
    END IF;
                   
END get_inv_item_for_element;
--
-----------------------------------------------------------------------------
--
PROCEDURE end_date_linked_inv(pi_ne_id            IN nm_elements.ne_id%TYPE
                             ,pi_group_type       IN nm_elements.ne_gty_group_type%TYPE
                             ,pi_end_date         IN nm_elements.ne_end_date%TYPE
                             ,pi_raise_if_no_link IN boolean DEFAULT TRUE
                             ) IS

  e_no_link_and_ignore EXCEPTION;
  
  l_ngit_rec nm_group_inv_types%ROWTYPE;
  
  l_iit_ne_id nm_inv_items.iit_ne_id%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'end_date_linked_inv');

  IF pi_group_type IS NOT NULL
  THEN
    --check group is linked to inv type
    BEGIN 
      l_ngit_rec := nm3get.get_ngit(pi_ngit_ngt_group_type => pi_group_type);
    EXCEPTION
      WHEN e_generic_error
      THEN
        IF hig.check_last_ner(pi_appl => nm3type.c_hig
                             ,pi_id   => 67)
          AND NOT pi_raise_if_no_link
        THEN
          RAISE e_no_link_and_ignore;
        ELSE
          RAISE;
        END IF;
    
    END;
    
    --get item group is linked to
    l_iit_ne_id := nm3get.get_ngil(pi_ngil_ne_ne_id => pi_ne_id).ngil_iit_ne_id;
    
    --end date item
    UPDATE
      nm_inv_items iit
    SET
      iit.iit_end_date = pi_end_date
    WHERE
      iit.iit_ne_id = l_iit_ne_id;
  END IF;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'end_date_linked_inv');

EXCEPTION
  WHEN e_no_link_and_ignore
  THEN
    NULL;

END end_date_linked_inv;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_grp_with_inv ( pi_rec_ne  IN nm_elements%ROWTYPE
			                  , pi_rec_inv IN nm_inv_items%ROWTYPE)  IS

TYPE tab_nm IS TABLE OF nm_members%ROWTYPE INDEX BY BINARY_INTEGER;

   l_tab_nm    tab_nm;
   l_rec_ne    nm_elements%ROWTYPE  := pi_rec_ne;
   l_rec_inv   nm_inv_items%ROWTYPE := pi_rec_inv;
   l_rec_ity   nm_inv_types%ROWTYPE;
   l_rec_nm    nm_members%ROWTYPE;
   l_rec_ngil  nm_group_inv_link%ROWTYPE;
   l_rec_ngit  nm_group_inv_types%ROWTYPE;
   l_tmp_iit   nm_inv_items.iit_ne_id%TYPE;

   nodes_needed          CONSTANT BOOLEAN :=
                         nm3get.get_nt(pi_nt_type => l_rec_ne.ne_nt_type).nt_node_type IS NOT NULL;

   nodes_not_provided    CONSTANT BOOLEAN := pi_rec_ne.ne_no_start IS NULL AND
                                             pi_rec_ne.ne_no_start IS NULL;

BEGIN

   nm_debug.proc_start(g_package_name,'create_any_group');

   --create group
   nm3net.insert_any_element(l_rec_ne);

   -- Create associated inventory atts if present
   IF l_rec_inv.iit_admin_unit IS NOT NULL THEN

      -- Get inventory type columns for inv type associated with group type
      --nm_debug.debug('create_any_group - > get inv type assoc with gty');
      l_rec_ngit := nm3get.get_ngit(l_rec_ne.ne_gty_group_type);

      -- Carry on if inv type found
      -- nm_debug.debug('create_any_group - > check for inv type');
      IF l_rec_ngit.ngit_nit_inv_type IS NOT NULL
       THEN

   	    l_rec_inv.iit_inv_type := l_rec_ngit.ngit_nit_inv_type;

   	 -- Initialise server
     -- nm_debug.debug('create_any_group - > > initialise server global');
        nm3group_inv.iit_rec_init( pi_inv_type   => l_rec_inv.iit_inv_type
                                 , pi_start_date => l_rec_inv.iit_start_date
                                 , pi_admin_unit => l_rec_inv.iit_admin_unit );

   	    nm3group_inv.g_iit_rec := l_rec_inv;

        -- Server inserts inv item
        -- nm_debug.debug('create_any_group - > Insert Inv Item');
        l_tmp_iit := nm3group_inv.iit_rec_insert;

        -- Use a record type based on NM_GROUP_LINK
        -- nm_debug.debug('create_any_group - > Build nm_group_link rowtype');
        l_rec_ngil.ngil_ne_ne_id   := l_rec_ne.ne_id;
        l_rec_ngil.ngil_start_date := l_rec_ne.ne_start_date;
        l_rec_ngil.ngil_iit_ne_id  := l_tmp_iit;

        -- Create group inv link
        -- nm_debug.debug('create_any_group - > Create inv-group link');
        nm3ins.ins_ngil(l_rec_ngil);

      ELSE
         --RAISE_APPLICATION_ERROR(2000,'No Inv Type associated with Group Type - nm_group_inv_types');
         nm_debug.debug('Inv type invalid');
      END IF;

	END IF;

   nm_debug.proc_end(g_package_name,'create_any_group');

EXCEPTION
   WHEN OTHERS THEN RAISE;
END create_grp_with_inv;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_grp_with_inv ( pi_rec_ne  IN nm_elements%ROWTYPE
			                  , pi_rec_inv IN nm_inv_items%ROWTYPE
							  , pi_tab_nm  IN nm3type.tab_number ) IS

TYPE tab_nm IS TABLE OF nm_members%ROWTYPE INDEX BY BINARY_INTEGER;

   l_tab_nm    tab_nm;
   l_rec_ne    nm_elements%ROWTYPE  := pi_rec_ne;
   l_rec_inv   nm_inv_items%ROWTYPE := pi_rec_inv;
   l_rec_ity   nm_inv_types%ROWTYPE;
   l_rec_nm    nm_members%ROWTYPE;
   l_rec_ngil  nm_group_inv_link%ROWTYPE;
   l_rec_ngit  nm_group_inv_types%ROWTYPE;
   l_tmp_iit   nm_inv_items.iit_ne_id%TYPE;

   nodes_needed          CONSTANT BOOLEAN :=
                         nm3get.get_nt(pi_nt_type => l_rec_ne.ne_nt_type).nt_node_type IS NOT NULL;

   nodes_not_provided    CONSTANT BOOLEAN := pi_rec_ne.ne_no_start IS NULL AND
                                             pi_rec_ne.ne_no_start IS NULL;

BEGIN

   nm_debug.proc_start(g_package_name,'create_any_group');

   -- See if group needs nodes, if so work out start and end nodes for element
   -- from membership if not provided
   IF nodes_needed
   AND nodes_not_provided
   AND pi_tab_nm.COUNT > 0
    THEN
      --nm_debug.debug('Assigning start node');
      l_rec_ne.ne_no_start := nm3net.get_start_node(pi_tab_nm(pi_tab_nm.FIRST));

      --nm_debug.debug('Assigning end node');
      l_rec_ne.ne_no_end   := nm3net.get_end_node(pi_tab_nm(pi_tab_nm.LAST));

   END IF;

   --create group
   nm3net.insert_any_element(l_rec_ne);

   -- Create associated inventory atts if present
   IF l_rec_inv.iit_admin_unit IS NOT NULL THEN

      -- Get inventory type columns for inv type associated with group type
      --nm_debug.debug('create_any_group - > get inv type assoc with gty');
      l_rec_ngit := nm3get.get_ngit(l_rec_ne.ne_gty_group_type);

      -- Carry on if inv type found
      -- nm_debug.debug('create_any_group - > check for inv type');
      IF l_rec_ngit.ngit_nit_inv_type IS NOT NULL
       THEN

   	    l_rec_inv.iit_inv_type := l_rec_ngit.ngit_nit_inv_type;

   	 -- Initialise server
     -- nm_debug.debug('create_any_group - > > initialise server global');
        nm3group_inv.iit_rec_init( pi_inv_type   => l_rec_inv.iit_inv_type
                                 , pi_start_date => l_rec_inv.iit_start_date
                                 , pi_admin_unit => l_rec_inv.iit_admin_unit );

   	    nm3group_inv.g_iit_rec := l_rec_inv;

        -- Server inserts inv item
        -- nm_debug.debug('create_any_group - > Insert Inv Item');
        l_tmp_iit := nm3group_inv.iit_rec_insert;

        -- Use a record type based on NM_GROUP_LINK
        -- nm_debug.debug('create_any_group - > Build nm_group_link rowtype');
        l_rec_ngil.ngil_ne_ne_id   := l_rec_ne.ne_id;
        l_rec_ngil.ngil_start_date := l_rec_ne.ne_start_date;
        l_rec_ngil.ngil_iit_ne_id  := l_tmp_iit;

        -- Create group inv link
        -- nm_debug.debug('create_any_group - > Create inv-group link');
        nm3ins.ins_ngil(l_rec_ngil);

      ELSE
         --RAISE_APPLICATION_ERROR(2000,'No Inv Type associated with Group Type - nm_group_inv_types');
         nm_debug.debug('Inv type invalid');
      END IF;

	END IF;

   ----------------------------------------------------------------------------
   -- Create the membership records
   ----------------------------------------------------------------------------

   IF pi_tab_nm.COUNT > 0 THEN
      FOR i IN 1..pi_tab_nm.COUNT LOOP

         --nm_debug.debug('Creating membership record : '||to_char(pi_members(i)));
         l_rec_nm.nm_ne_id_in      := l_rec_ne.ne_id;
         l_rec_nm.nm_ne_id_of      := pi_tab_nm(i);
         l_rec_nm.nm_type          := 'G';
         l_rec_nm.nm_obj_type      := l_rec_ne.ne_gty_group_type;
         l_rec_nm.nm_begin_mp      := 0;
         l_rec_nm.nm_start_date    := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
         l_rec_nm.nm_end_mp        := nm3net.get_ne_length(pi_tab_nm(i));
         l_rec_nm.nm_cardinality   := 1;
         l_rec_nm.nm_admin_unit    := nm3get.get_ne(pi_ne_id => pi_tab_nm(i)).ne_admin_unit;

         nm3ins.ins_nm ( l_rec_nm );

      END LOOP;
   END IF;

   -- resequence the route to set contectivity
   IF nodes_needed THEN
      nm3rsc.reseq_route(l_rec_ne.ne_id);
   END IF;

   nm_debug.proc_end(g_package_name,'create_any_group');

EXCEPTION
   WHEN OTHERS THEN RAISE;
END create_grp_with_inv;
--
-----------------------------------------------------------------------------
--
PROCEDURE iit_rec_init(pi_inv_type   IN nm_inv_items.iit_inv_type%TYPE DEFAULT NULL
                      ,pi_start_date IN nm_inv_items.iit_start_date%TYPE DEFAULT NULL
                      ,pi_admin_unit IN nm_inv_items.iit_admin_unit%TYPE DEFAULT NULL
                      ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'iit_rec_init');

  --reset fields to NULL using empty record
  g_iit_rec := g_empty_iit_rec_do_not_modify;
  
  g_iit_rec.iit_inv_type   := pi_inv_type;
  g_iit_rec.iit_start_date := pi_start_date;
  g_iit_rec.iit_admin_unit := pi_admin_unit;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'iit_rec_init');

END iit_rec_init;
--
-----------------------------------------------------------------------------
--
PROCEDURE iit_rec_update(pi_column_name IN varchar2
                        ,pi_value       IN varchar2
                        ) IS

  l_plsql nm3type.max_varchar2;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'iit_rec_update');

  l_plsql :=            'BEGIN'
             || c_nl || '  nm3group_inv.g_iit_rec. ' || pi_column_name || ' := :p_value;'
             || c_nl || 'END;';
  
  EXECUTE IMMEDIATE l_plsql USING pi_value;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'iit_rec_update');

END iit_rec_update;

PROCEDURE iit_rec_update(pi_column_name IN varchar2
                        ,pi_value       IN number
                        ) IS

  l_plsql nm3type.max_varchar2;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'iit_rec_update');

  l_plsql :=            'BEGIN'
             || c_nl || '  nm3group_inv.g_iit_rec. ' || pi_column_name || ' := :p_value;'
             || c_nl || 'END;';
  
  EXECUTE IMMEDIATE l_plsql USING pi_value;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'iit_rec_update');

END iit_rec_update;

PROCEDURE iit_rec_update(pi_column_name IN varchar2
                        ,pi_value       IN date
                        ) IS

  l_plsql nm3type.max_varchar2;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'iit_rec_update');

  l_plsql :=            'BEGIN'
             || c_nl || '  nm3group_inv.g_iit_rec. ' || pi_column_name || ' := :p_value;'
             || c_nl || 'END;';
  
  EXECUTE IMMEDIATE l_plsql USING pi_value;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'iit_rec_update');

END iit_rec_update;
--
-----------------------------------------------------------------------------
--
FUNCTION iit_rec_insert RETURN nm_inv_items.iit_ne_id%TYPE IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'iit_rec_insert');

  IF g_iit_rec.iit_ne_id IS NULL
  THEN
    g_iit_rec.iit_ne_id := nm3net.get_next_ne_id;
    nm_debug.DEBUG('new ne_id = ' || g_iit_rec.iit_ne_id);
  END IF;
  
  IF g_iit_rec.iit_primary_key IS NULL
  THEN
    --default primary key to be ne_id
    g_iit_rec.iit_primary_key := TO_CHAR(g_iit_rec.iit_ne_id);
  END IF;
  
  nm3ins.ins_iit_all(p_rec_iit_all => g_iit_rec);
  
  RETURN g_iit_rec.iit_ne_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'iit_rec_insert');

END iit_rec_insert;
--
-----------------------------------------------------------------------------
--
FUNCTION get_inv_type_for_gty_type(pi_ne_gty_group_type IN nm_elements_all.ne_gty_group_type%TYPE) RETURN nm_group_inv_types.ngit_nit_inv_type%TYPE IS

  v_ngit_rec  nm_group_inv_types%ROWTYPE;

BEGIN

  -------------------------------------------------------------------------------
  -- For a given network element group type return a corresponding inventory type
  -------------------------------------------------------------------------------
  v_ngit_rec :=  nm3get.get_ngit(pi_ngit_ngt_group_type => pi_ne_gty_group_type
                                ,pi_raise_not_found     => FALSE);

  RETURN (v_ngit_rec.ngit_nit_inv_type);

END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngil_from_iit_ne_id(pi_ngil_ne_ne_id     nm_group_inv_link.ngil_ne_ne_id%TYPE
                                ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                                ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                                ) RETURN nm_group_inv_link%ROWTYPE IS

   CURSOR cs_ngil IS
   SELECT *
    FROM  nm_group_inv_link
   WHERE  ngil_ne_ne_id = pi_ngil_ne_ne_id;  

   l_found  BOOLEAN;
   l_retval nm_group_inv_link%ROWTYPE;

BEGIN

   nm_debug.proc_start(g_package_name,'get_ngil_from_iit_ne_id');

   OPEN  cs_ngil;
   FETCH cs_ngil INTO l_retval;
   l_found := cs_ngil%FOUND;
   CLOSE cs_ngil;

   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_group_inv_link'
                                              ||CHR(10)||'ngil_ne_ne_id => '||pi_ngil_ne_ne_id
                    );
   END IF;

   nm_debug.proc_end(g_package_name,'get_ngil_from_iit_ne_id');

   RETURN l_retval;

END get_ngil_from_iit_ne_id;
--
-----------------------------------------------------------------------------
--


END nm3group_inv;
/
