CREATE OR REPLACE PACKAGE BODY Nm3nwad AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3nwad.pkb-arc   2.14   Dec 15 2011 16:55:42   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3nwad.pkb  $
--       Date into PVCS   : $Date:   Dec 15 2011 16:55:42  $
--       Date fetched Out : $Modtime:   Dec 15 2011 16:54:58  $
--       PVCS Version     : $Revision:   2.14  $
--
--
-- Author : A Edwards/P Stanton/G Johnson
--
-- NM3NWAD - Additional Data link package
--
-- 12-MAY-2006      GJ   Date logic changed for Primary AD Types
--                       nm_nw_ad_link_all.nad_start_date and nm_inv_items_all.iit_start_date
--                       must equal the start date of the element that the AD relates to
--                       Also amended end_date_date_nadl to accept effective date parameter.
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--all global package variables here

  ------------
  --exceptions
  ------------
  e_generic_error          EXCEPTION;
  e_no_link_and_ignore     EXCEPTION;
  PRAGMA                   EXCEPTION_INIT(e_generic_error, -20000);

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT VARCHAR2(2000) := '"$Revision:   2.14  $"';

  g_package_name CONSTANT VARCHAR2(30) := 'nm3nwad';

  c_nl           CONSTANT VARCHAR2(1) := CHR(10);

  g_empty_iit_rec_do_not_modify NM_INV_ITEMS%ROWTYPE;
--
-----------------------------------------------------------------------------
--
FUNCTION get_version
  RETURN VARCHAR2
IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version
  RETURN VARCHAR2
IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_nad_id
   RETURN PLS_INTEGER
IS
   l_retval PLS_INTEGER;
BEGIN
   SELECT nad_id_seq.NEXTVAL
     INTO l_retval
     FROM dual;
   RETURN l_retval;
END get_next_nad_id;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_link_types
            ( pi_ne_id     IN NM_NW_AD_LINK.nad_ne_id%TYPE
            , pi_iit_ne_id IN NM_NW_AD_LINK.nad_iit_ne_id%TYPE
            ) IS

  l_dummy PLS_INTEGER;

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'check_link_types');
  SELECT 1
    INTO l_dummy
    FROM NM_ELEMENTS        ne
       , NM_INV_ITEMS       iit
       , NM_NW_AD_TYPES     nad
   WHERE ne.ne_id = pi_ne_id
     AND ne.ne_nt_type = nad.nad_nt_type
     AND NVL(ne.ne_gty_group_type,'#') = NVL(nad.nad_gty_type,'#')
     AND iit.iit_ne_id = pi_iit_ne_id
     AND iit.iit_inv_type = nad.nad_inv_type;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'check_link_types');

EXCEPTION
  WHEN NO_DATA_FOUND
  THEN
    --no link found for the types of the specified items
    Hig.raise_ner(pi_appl               => Nm3type.c_net
                 ,pi_id                 => 348
                 ,pi_supplementary_info =>    'Element ne_id: ' || pi_ne_id
                                           || ' Inventory ne_id: ' || pi_iit_ne_id);

  WHEN TOO_MANY_ROWS
  THEN
    Hig.raise_ner(pi_appl               => Nm3type.c_hig
                 ,pi_id                 => 105
                 ,pi_supplementary_info =>    g_package_name || '.check_link_types pi_ne_ne_id: ' || pi_ne_id
                                           || ' pi_iit_ne_id: ' || pi_iit_ne_id);

END check_link_types;
--
-----------------------------------------------------------------------------
-- Create a link between INV type and a Datum
-----------------------------------------------------------------------------
--
PROCEDURE set_link_for_datum
            ( pi_nt_type    IN NM_NW_AD_TYPES.nad_nt_type%TYPE
            , pi_inv_type   IN NM_NW_AD_TYPES.nad_inv_type%TYPE )
IS
  l_nadt_rec NM_NW_AD_TYPES%ROWTYPE;

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'set_link_for_datum');

   UPDATE NM_NW_AD_TYPES nadt
      SET nadt.nad_inv_type = pi_inv_type
        , nadt.nad_nt_type  = pi_nt_type
    WHERE nadt.nad_gty_type IS NULL
      AND nadt.nad_nt_type  = pi_nt_type
      AND nadt.nad_inv_type = pi_inv_type;

   IF SQL%rowcount < 1
   THEN
    --does not already exist, so insert
      l_nadt_rec.nad_id            := Nm3nwad.get_next_nad_id;
      l_nadt_rec.nad_inv_type      := pi_inv_type;
      l_nadt_rec.nad_nt_type       := pi_nt_type;
      l_nadt_rec.nad_gty_type      := NULL;
      l_nadt_rec.nad_descr         := pi_inv_type||'-'||pi_nt_type||' Link';
      l_nadt_rec.nad_start_date    := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
      l_nadt_rec.nad_end_date      := NULL;
      l_nadt_rec.nad_primary_ad    := 'Y';
      l_nadt_rec.nad_display_order := 1;
      l_nadt_rec.nad_single_row    := 'Y';
      l_nadt_rec.nad_mandatory     := 'Y';
      Nm3nwad.ins_nadt(l_nadt_rec);

   END IF;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'set_link_for_datum');

END set_link_for_datum;
--
-----------------------------------------------------------------------------
-- Create link between INV type and GROUP type
-----------------------------------------------------------------------------
--
PROCEDURE set_link_for_group
            ( pi_group_type IN NM_NW_AD_TYPES.nad_gty_type%TYPE
            , pi_inv_type   IN NM_NW_AD_TYPES.nad_inv_type%TYPE )
IS
  l_nadt_rec NM_NW_AD_TYPES%ROWTYPE;
  l_nt_type  NM_GROUP_TYPES.ngt_nt_type%TYPE;
BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'set_link_for_group');

   l_nt_type := Nm3get.get_ngt(pi_group_type).ngt_nt_type;

   UPDATE NM_NW_AD_TYPES nadt
      SET nadt.nad_inv_type = pi_inv_type
        , nadt.nad_gty_type = pi_group_type
        , nadt.nad_nt_type  = l_nt_type
    WHERE nadt.nad_gty_type = pi_group_type
      AND nadt.nad_nt_type  = l_nt_type
      AND nadt.nad_inv_type = pi_inv_type;

   IF SQL%rowcount < 1
   THEN
      -- doesn't exist so insert one
      l_nadt_rec.nad_id            := Nm3nwad.get_next_nad_id;
      l_nadt_rec.nad_inv_type      := pi_inv_type;
      l_nadt_rec.nad_nt_type       := l_nt_type;
      l_nadt_rec.nad_gty_type      := pi_group_type;
      l_nadt_rec.nad_descr         := pi_inv_type||'-'||pi_group_type||' Link';
      l_nadt_rec.nad_start_date    := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
      l_nadt_rec.nad_end_date      := NULL;
      l_nadt_rec.nad_primary_ad    := 'Y';
      l_nadt_rec.nad_display_order := 1;
      l_nadt_rec.nad_single_row    := 'Y';
      l_nadt_rec.nad_mandatory     := 'Y';
      Nm3nwad.ins_nadt(l_nadt_rec);

   END IF;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'set_link_for_group');

END set_link_for_group;
--
-----------------------------------------------------------------------------
-- get_inv_item_for_element
--
--   Should only be used for Primary AD types
-----------------------------------------------------------------------------
--
PROCEDURE get_inv_item_for_element
            ( pi_ne_id              IN     NM_NW_AD_LINK.nad_ne_id%TYPE
            , pi_raise_if_not_found IN      BOOLEAN DEFAULT TRUE
            , po_iit_ne_id             OUT NM_NW_AD_LINK.nad_iit_ne_id%TYPE
            , po_inv_type              OUT NM_NW_AD_TYPES.nad_inv_type%TYPE)
IS

  l_get_item BOOLEAN := TRUE;
  l_rec_ne   NM_ELEMENTS%ROWTYPE;
  v_nad_id   NM_NW_AD_TYPES.nad_id%TYPE;

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_inv_item_for_element');

   l_rec_ne := Nm3get.get_ne(pi_ne_id);

   IF l_rec_ne.ne_gty_group_type IS NOT NULL
    THEN
      po_inv_type := Nm3nwad.get_nadt
                      ( l_rec_ne.ne_nt_type
                      , l_rec_ne.ne_gty_group_type ).nad_inv_type;

      v_nad_id    := Nm3nwad.get_nadt
                      ( l_rec_ne.ne_nt_type
                      , l_rec_ne.ne_gty_group_type).nad_id;
   ELSE
      po_inv_type := Nm3nwad.get_nadt
                   ( l_rec_ne.ne_nt_type ).nad_inv_type;

      v_nad_id    := Nm3nwad.get_nadt
                      ( l_rec_ne.ne_nt_type).nad_id;

   END IF;

   po_iit_ne_id := Nm3nwad.get_nadl( pi_nad_id => v_nad_id
                                   , pi_ne_id  => pi_ne_id).nad_iit_ne_id;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_inv_item_for_element');

EXCEPTION
  WHEN e_generic_error
  THEN
    IF (Hig.check_last_ner(pi_appl => Nm3type.c_hig
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
-- get_prim_inv_item_for_element
--
--   return PRIMARY Inv Type for NE
-----------------------------------------------------------------------------
--
PROCEDURE get_prim_inv_item_for_element
            ( pi_ne_id              IN     NM_NW_AD_LINK.nad_ne_id%TYPE
            , pi_raise_if_not_found IN      BOOLEAN DEFAULT TRUE
            , po_iit_ne_id             OUT NM_NW_AD_LINK.nad_iit_ne_id%TYPE
            , po_inv_type              OUT NM_NW_AD_TYPES.nad_inv_type%TYPE
            , po_nad_id                OUT NM_NW_AD_TYPES.nad_id%TYPE)
IS

  l_get_item BOOLEAN := TRUE;
  l_rec_ne   NM_ELEMENTS%ROWTYPE;
  v_nad_id   NM_NW_AD_TYPES.nad_id%TYPE;

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_inv_item_for_element');

--   l_rec_ne := Nm3get.get_ne(pi_ne_id);  -- GJ 26-SEP-2005 we want to get prim attribs from end dated elements as well
   l_rec_ne := Nm3get.get_ne_all(pi_ne_id);

   IF l_rec_ne.ne_gty_group_type IS NOT NULL
    THEN
      po_inv_type := Nm3nwad.get_prim_nadt
                      ( l_rec_ne.ne_nt_type
                      , l_rec_ne.ne_gty_group_type ).nad_inv_type;

      v_nad_id    := Nm3nwad.get_prim_nadt
                      ( l_rec_ne.ne_nt_type
                      , l_rec_ne.ne_gty_group_type).nad_id;

      po_nad_id   := v_nad_id;

   ELSE
      po_inv_type := Nm3nwad.get_prim_nadt
                   ( l_rec_ne.ne_nt_type ).nad_inv_type;

      v_nad_id    := Nm3nwad.get_prim_nadt
                      ( l_rec_ne.ne_nt_type).nad_id;

      po_nad_id   := v_nad_id;

   END IF;

   po_iit_ne_id := Nm3nwad.get_nadl( pi_nad_id => v_nad_id
                                   , pi_ne_id  => pi_ne_id).nad_iit_ne_id;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_inv_item_for_element');

EXCEPTION
  WHEN e_generic_error
  THEN
    IF (Hig.check_last_ner(pi_appl => Nm3type.c_hig
                          ,pi_id   => 67))
       AND NOT pi_raise_if_not_found
    THEN
      --don't want an error raised when group or item not found
      po_iit_ne_id := NULL;
      po_inv_type  := NULL;
    ELSE
      RAISE;
    END IF;

END get_prim_inv_item_for_element;
--
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--
PROCEDURE create_grp_with_inv
            ( pi_rec_ne  IN NM_ELEMENTS%ROWTYPE
            , pi_rec_inv IN NM_INV_ITEMS%ROWTYPE)
IS
TYPE tab_nm IS TABLE OF NM_MEMBERS%ROWTYPE INDEX BY BINARY_INTEGER;

   l_tab_nm    tab_nm;
   l_rec_ne    NM_ELEMENTS%ROWTYPE  := pi_rec_ne;
   l_rec_inv   NM_INV_ITEMS%ROWTYPE := pi_rec_inv;
   l_rec_ity   NM_INV_TYPES%ROWTYPE;
   l_rec_nm    NM_MEMBERS%ROWTYPE;
--   l_rec_ngil  NM_GROUP_INV_LINK%ROWTYPE;
--   l_rec_ngit  NM_GROUP_INV_TYPES%ROWTYPE;
   l_rec_nadt  NM_NW_AD_TYPES%ROWTYPE;
   l_rec_nadl  NM_NW_AD_LINK_ALL%ROWTYPE;
   l_tmp_iit   NM_INV_ITEMS.iit_ne_id%TYPE;

   nodes_needed          CONSTANT BOOLEAN :=
                         Nm3get.get_nt(pi_nt_type => l_rec_ne.ne_nt_type).nt_node_type IS NOT NULL;

   nodes_not_provided    CONSTANT BOOLEAN := pi_rec_ne.ne_no_start IS NULL AND
                                             pi_rec_ne.ne_no_start IS NULL;

BEGIN

   Nm_Debug.proc_start(g_package_name,'create_grp_with_inv');

   --create group
   Nm3net.insert_any_element(l_rec_ne);

   -- Create associated inventory atts if present
   IF l_rec_inv.iit_admin_unit IS NOT NULL THEN

      -- Get inventory type columns for inv type associated with group type
      --nm_debug.debug('create_any_group - > get inv type assoc with gty');
      -- FOR A GROUP TYPE ONLY
      l_rec_nadt := Nm3nwad.get_prim_nadt
                         ( pi_nt_type =>  l_rec_ne.ne_nt_type
                         , pi_gty_type => l_rec_ne.ne_gty_group_type);

      -- Carry on if inv type found
      -- nm_debug.debug('create_any_group - > check for inv type');
      IF l_rec_nadt.nad_inv_type IS NOT NULL
       THEN

        l_rec_inv.iit_inv_type := l_rec_nadt.nad_inv_type;

     -- Initialise server
     -- nm_debug.debug('create_any_group - > > initialise server global');
        Nm3nwad.iit_rec_init( pi_inv_type   => l_rec_inv.iit_inv_type
                            , pi_admin_unit => l_rec_inv.iit_admin_unit );

        Nm3nwad.g_iit_rec := l_rec_inv;

        -- Server inserts inv item
        -- nm_debug.debug('create_any_group - > Insert Inv Item');
        l_tmp_iit := Nm3nwad.iit_rec_insert;

        -- Use a record type based on NM_NW_AD_LINK
        l_rec_nadl.nad_id          := l_rec_nadt.nad_id;
        l_rec_nadl.nad_start_date  := l_rec_ne.ne_start_date;
        l_rec_nadl.nad_ne_id       := l_rec_ne.ne_id;
        l_rec_nadl.nad_iit_ne_id   := l_tmp_iit;
        l_rec_nadl.nad_whole_road  := 1;

        CASE l_rec_inv.iit_inv_type
        WHEN 'TP21'
        THEN
          IF l_rec_inv.iit_chr_attrib30 = 0
          THEN
            l_rec_nadl.nad_whole_road := 0;
          END IF;
        WHEN 'TP22'
        THEN
          IF l_rec_inv.iit_chr_attrib28 = 0
          THEN
            l_rec_nadl.nad_whole_road := 0;
          END IF;
        WHEN 'TP23'
        THEN
          IF l_rec_inv.iit_chr_attrib34 = 0
          THEN
            l_rec_nadl.nad_whole_road := 0;
          END IF;
        WHEN 'TP51'
        THEN
          IF l_rec_inv.iit_chr_attrib30 = 0
          THEN
            l_rec_nadl.nad_whole_road := 0;
          END IF;
        WHEN 'TP52'
        THEN
          IF l_rec_inv.iit_chr_attrib28 = 0
          THEN
            l_rec_nadl.nad_whole_road := 0;
          END IF;
        WHEN 'TP53'
        THEN
          IF l_rec_inv.iit_chr_attrib34 = '0'
          THEN
            l_rec_nadl.nad_whole_road := 0;
          END IF;
        ELSE
          l_rec_nadl.nad_whole_road := 1;
        END CASE;

        -- Create group inv link
        -- nm_debug.debug('create_any_group - > Create inv-group link');
        Nm3nwad.ins_nadl(l_rec_nadl);

      ELSE
         --RAISE_APPLICATION_ERROR(2000,'No Inv Type associated with Group Type - nm_group_inv_types');
         Nm_Debug.DEBUG('Inv type invalid');
      END IF;

   END IF;

   Nm_Debug.proc_end(g_package_name,'create_grp_with_inv');

EXCEPTION
   WHEN OTHERS THEN RAISE;
END create_grp_with_inv;
--
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--
PROCEDURE create_grp_with_inv
            ( pi_rec_ne  IN NM_ELEMENTS%ROWTYPE
            , pi_rec_inv IN NM_INV_ITEMS%ROWTYPE
            , pi_tab_nm  IN Nm3type.tab_number )
IS
TYPE tab_nm IS TABLE OF NM_MEMBERS%ROWTYPE INDEX BY BINARY_INTEGER;

   l_tab_nm    tab_nm;
   l_rec_ne    NM_ELEMENTS%ROWTYPE  := pi_rec_ne;
   l_rec_inv   NM_INV_ITEMS%ROWTYPE := pi_rec_inv;
   l_rec_ity   NM_INV_TYPES%ROWTYPE;
   l_rec_nm    NM_MEMBERS%ROWTYPE;
--   l_rec_ngil  NM_GROUP_INV_LINK%ROWTYPE;
--   l_rec_ngit  NM_GROUP_INV_TYPES%ROWTYPE;
   l_rec_nadt  NM_NW_AD_TYPES%ROWTYPE;
   l_rec_nadl  NM_NW_AD_LINK_ALL%ROWTYPE;
   l_tmp_iit   NM_INV_ITEMS.iit_ne_id%TYPE;

   nodes_needed          CONSTANT BOOLEAN :=
                         Nm3get.get_nt(pi_nt_type => l_rec_ne.ne_nt_type).nt_node_type IS NOT NULL;

   nodes_not_provided    CONSTANT BOOLEAN := pi_rec_ne.ne_no_start IS NULL AND
                                             pi_rec_ne.ne_no_start IS NULL;

BEGIN

   Nm_Debug.proc_start(g_package_name,'create_grp_with_inv');

   -- See if group needs nodes, if so work out start and end nodes for element
   -- from membership if not provided
   IF nodes_needed
   AND nodes_not_provided
   AND pi_tab_nm.COUNT > 0
    THEN
      --nm_debug.debug('Assigning start node');
      l_rec_ne.ne_no_start := Nm3net.get_start_node(pi_tab_nm(pi_tab_nm.FIRST));

      --nm_debug.debug('Assigning end node');
      l_rec_ne.ne_no_end   := Nm3net.get_end_node(pi_tab_nm(pi_tab_nm.LAST));

   END IF;

  --create group
   Nm3net.insert_any_element(l_rec_ne);

   -- Create associated inventory atts if present
   IF l_rec_inv.iit_admin_unit IS NOT NULL THEN

      -- Get inventory type columns for inv type associated with group type
      --nm_debug.debug('create_any_group - > get inv type assoc with gty');
      -- FOR A GROUP TYPE ONLY
      l_rec_nadt := Nm3nwad.get_prim_nadt
                         ( pi_nt_type =>  l_rec_ne.ne_nt_type
                         , pi_gty_type => l_rec_ne.ne_gty_group_type);

      -- Carry on if inv type found
      -- nm_debug.debug('create_any_group - > check for inv type');
      IF l_rec_nadt.nad_inv_type IS NOT NULL
       THEN

        l_rec_inv.iit_inv_type := l_rec_nadt.nad_inv_type;

     -- Initialise server
     -- nm_debug.debug('create_any_group - > > initialise server global');
        Nm3nwad.iit_rec_init( pi_inv_type   => l_rec_inv.iit_inv_type
                            , pi_admin_unit => l_rec_inv.iit_admin_unit );

        Nm3nwad.g_iit_rec := l_rec_inv;

        -- Server inserts inv item
        -- nm_debug.debug('create_any_group - > Insert Inv Item');
        l_tmp_iit := Nm3nwad.iit_rec_insert;

        -- Use a record type based on NM_NW_AD_LINK
        l_rec_nadl.nad_id          := l_rec_nadt.nad_id;
        l_rec_nadl.nad_start_date  := l_rec_ne.ne_start_date;
        l_rec_nadl.nad_ne_id       := l_rec_ne.ne_id;
        l_rec_nadl.nad_iit_ne_id   := l_tmp_iit;

        CASE l_rec_inv.iit_inv_type
        WHEN 'TP21'
        THEN
          IF l_rec_inv.iit_chr_attrib30 = 0
          THEN
            l_rec_nadl.nad_whole_road := 0;
          END IF;
        WHEN 'TP22'
        THEN
          IF l_rec_inv.iit_chr_attrib28 = 0
          THEN
            l_rec_nadl.nad_whole_road := 0;
          END IF;
        WHEN 'TP23'
        THEN
          IF l_rec_inv.iit_chr_attrib34 = 0
          THEN
            l_rec_nadl.nad_whole_road := 0;
          END IF;
        WHEN 'TP51'
        THEN
          IF l_rec_inv.iit_chr_attrib30 = 0
          THEN
            l_rec_nadl.nad_whole_road := 0;
          END IF;
        WHEN 'TP52'
        THEN
          IF l_rec_inv.iit_chr_attrib28 = 0
          THEN
            l_rec_nadl.nad_whole_road := 0;
          END IF;
        WHEN 'TP53'
        THEN
          IF l_rec_inv.iit_chr_attrib34 = '0'
          THEN
            l_rec_nadl.nad_whole_road := 0;
          END IF;
        ELSE
          l_rec_nadl.nad_whole_road := 1;
        END CASE;

        -- Create group inv link
        -- nm_debug.debug('create_any_group - > Create inv-group link');
        Nm3nwad.ins_nadl(l_rec_nadl);

      ELSE
         --RAISE_APPLICATION_ERROR(2000,'No Inv Type associated with Group Type - nm_group_inv_types');
         Nm_Debug.DEBUG('Inv type invalid');
      END IF;

   END IF;

   ----------------------------------------------------------------------------
   -- Create the membership records
   ----------------------------------------------------------------------------

   IF pi_tab_nm.COUNT > 0 THEN
      FOR i IN 1..pi_tab_nm.COUNT LOOP

         declare
           l_rec_ne nm_elements%rowtype;
         begin

           l_rec_ne := nm3get.get_ne( pi_tab_nm(i) );

           --nm_debug.debug('Creating membership record : '||to_char(pi_members(i)));
           l_rec_nm.nm_ne_id_in      := pi_rec_ne.ne_id;
           l_rec_nm.nm_ne_id_of      := pi_tab_nm(i);
           l_rec_nm.nm_type          := 'G';
           l_rec_nm.nm_obj_type      := pi_rec_ne.ne_gty_group_type;
           l_rec_nm.nm_begin_mp      := 0;
           l_rec_nm.nm_start_date    := greatest(pi_rec_ne.ne_start_date, l_rec_ne.ne_start_date );
           l_rec_nm.nm_end_mp        := Nm3net.Get_Ne_Length(pi_tab_nm(i));
           l_rec_nm.nm_cardinality   := 1;
           l_rec_nm.nm_admin_unit    := Nm3get.get_ne(pi_ne_id => pi_tab_nm(i)).ne_admin_unit;

           Nm3ins.ins_nm ( l_rec_nm );

         end;

      END LOOP;
   END IF;

   -- resequence the route to set contectivity
   IF nodes_needed THEN
      Nm3rsc.reseq_route(l_rec_ne.ne_id);
   END IF;

   Nm_Debug.proc_end(g_package_name,'create_grp_with_inv');

EXCEPTION
   WHEN OTHERS THEN RAISE;
END create_grp_with_inv;
--
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--
PROCEDURE iit_rec_init
            ( pi_inv_type   IN NM_INV_ITEMS.iit_inv_type%TYPE DEFAULT NULL
            , pi_admin_unit IN NM_INV_ITEMS.iit_admin_unit%TYPE DEFAULT NULL)
IS
BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'iit_rec_init');

  --reset fields to NULL using empty record
  g_iit_rec := g_empty_iit_rec_do_not_modify;

  g_iit_rec.iit_inv_type   := pi_inv_type;
  g_iit_rec.iit_admin_unit := pi_admin_unit;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'iit_rec_init');

END iit_rec_init;
--
-----------------------------------------------------------------------------
--Overloaded for Varchars
-----------------------------------------------------------------------------
--
PROCEDURE iit_rec_update
            ( pi_column_name IN VARCHAR2
            , pi_value       IN VARCHAR2)
IS
  l_plsql Nm3type.max_varchar2;
BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'iit_rec_update');

  l_plsql :=            'BEGIN'
             || c_nl || '  nm3nwad.g_iit_rec. ' || pi_column_name || ' := :p_value;'
             || c_nl || 'END;';

  EXECUTE IMMEDIATE l_plsql USING pi_value;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'iit_rec_update');

END iit_rec_update;
--
-----------------------------------------------------------------------------
--Overloaded for Numbers
-----------------------------------------------------------------------------
--
PROCEDURE iit_rec_update
            ( pi_column_name IN VARCHAR2
            , pi_value       IN NUMBER)
IS
  l_plsql Nm3type.max_varchar2;
BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'iit_rec_update');

  l_plsql :=            'BEGIN'
             || c_nl || '  nm3nwad.g_iit_rec. ' || pi_column_name || ' := :p_value;'
             || c_nl || 'END;';

  EXECUTE IMMEDIATE l_plsql USING pi_value;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'iit_rec_update');
END iit_rec_update;
--
-----------------------------------------------------------------------------
-- Overloaded for Dates
-----------------------------------------------------------------------------
--
PROCEDURE iit_rec_update
            ( pi_column_name IN VARCHAR2
            , pi_value       IN DATE)
IS
  l_plsql Nm3type.max_varchar2;
BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'iit_rec_update');

  l_plsql :=            'BEGIN'
             || c_nl || '  nm3nwad.g_iit_rec. ' || pi_column_name || ' := :p_value;'
             || c_nl || 'END;';

  EXECUTE IMMEDIATE l_plsql USING pi_value;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'iit_rec_update');

END iit_rec_update;
--
-----------------------------------------------------------------------------
-- Create inventory record
-----------------------------------------------------------------------------
--
FUNCTION iit_rec_insert RETURN NM_INV_ITEMS.iit_ne_id%TYPE IS
BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'iit_rec_insert');

  IF g_iit_rec.iit_ne_id IS NULL
  THEN
    g_iit_rec.iit_ne_id := Nm3net.get_next_ne_id;
    Nm_Debug.DEBUG('new ne_id = ' || g_iit_rec.iit_ne_id);
  END IF;

  IF g_iit_rec.iit_primary_key IS NULL
  THEN
    --default primary key to be ne_id
    g_iit_rec.iit_primary_key := TO_CHAR(g_iit_rec.iit_ne_id);
  END IF;

  Nm3ins.ins_iit_all(p_rec_iit_all => g_iit_rec);

  RETURN g_iit_rec.iit_ne_id;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'iit_rec_insert');

END iit_rec_insert;
--
-----------------------------------------------------------------------------
--
FUNCTION iit_rec_insert_row
  RETURN nm_inv_items%ROWTYPE
IS
BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'iit_rec_insert');

  IF g_iit_rec.iit_ne_id IS NULL
  THEN
    g_iit_rec.iit_ne_id := Nm3net.get_next_ne_id;
    Nm_Debug.DEBUG('new ne_id = ' || g_iit_rec.iit_ne_id);
  END IF;

  IF g_iit_rec.iit_primary_key IS NULL
  THEN
    --default primary key to be ne_id
    g_iit_rec.iit_primary_key := TO_CHAR(g_iit_rec.iit_ne_id);
  END IF;


  Nm3ins.ins_iit_all(p_rec_iit_all => g_iit_rec);

  RETURN g_iit_rec;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'iit_rec_insert');

END iit_rec_insert_row;
--
-----------------------------------------------------------------------------
--
FUNCTION get_prim_inv_type_for_ne_id
           ( pi_ne_id IN NM_ELEMENTS_ALL.ne_id%TYPE)
  RETURN NM_NW_AD_TYPES.nad_inv_type%TYPE
IS
  v_nadt_rec  NM_NW_AD_TYPES%ROWTYPE;
  l_rec_ne    NM_ELEMENTS%ROWTYPE;
BEGIN
  ---------------------------------------------------------------------------
  -- For a given network element group type return a corresponding primary
  -- inventory type
  ---------------------------------------------------------------------------

  l_rec_ne := Nm3get.get_ne(pi_ne_id);

  IF l_rec_ne.ne_gty_group_type IS NOT NULL
   THEN
     v_nadt_rec := Nm3nwad.get_prim_nadt
                    ( pi_nt_type => l_rec_ne.ne_nt_type
                    , pi_gty_type => l_rec_ne.ne_gty_group_type );
  ELSE
     v_nadt_rec := Nm3nwad.get_prim_nadt
                    ( pi_nt_type => l_rec_ne.ne_nt_type );
  END IF;

  RETURN (v_nadt_rec.nad_inv_type);
END get_prim_inv_type_for_ne_id;
--
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--
FUNCTION get_nadl_from_ne_id
           ( pi_nadl_ne_id        NM_NW_AD_LINK.nad_ne_id%TYPE
           , pi_raise_not_found   BOOLEAN     DEFAULT TRUE
           , pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000)
  RETURN NM_NW_AD_LINK%ROWTYPE
IS
   CURSOR cs_nadl IS
   SELECT *
    FROM  NM_NW_AD_LINK
   WHERE  nad_ne_id = pi_nadl_ne_id;

   l_found  BOOLEAN;
   l_retval NM_NW_AD_LINK%ROWTYPE;

BEGIN

   Nm_Debug.proc_start(g_package_name,'get_nadl_from_iit_ne_id');

   OPEN  cs_nadl;
   FETCH cs_nadl INTO l_retval;
   l_found := cs_nadl%FOUND;
   CLOSE cs_nadl;

   IF pi_raise_not_found AND NOT l_found
    THEN
      Hig.raise_ner (pi_appl               => Nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_nw_ad_link'
                                              ||CHR(10)||'ne_id => '||pi_nadl_ne_id
                    );
   END IF;

   Nm_Debug.proc_end(g_package_name,'get_nadl_from_iit_ne_id');

   RETURN l_retval;

END get_nadl_from_ne_id;
--
-----------------------------------------------------------------------------
--
PROCEDURE end_date_linked_inv
            ( pi_ne_id            IN NM_ELEMENTS.ne_id%TYPE
            , pi_nt_type          IN NM_ELEMENTS.ne_nt_type%TYPE
            , pi_group_type       IN NM_ELEMENTS.ne_gty_group_type%TYPE
            , pi_end_date         IN NM_ELEMENTS.ne_end_date%TYPE
            , pi_raise_if_no_link IN BOOLEAN DEFAULT TRUE)
IS

  e_no_link_and_ignore  EXCEPTION;

  l_nadt_rec            NM_NW_AD_TYPES%ROWTYPE;
  l_iit_ne_id           NM_INV_ITEMS.iit_ne_id%TYPE;

  l_primary_iit_ne_id   NM_INV_ITEMS.iit_ne_id%TYPE;
  l_primary_inv_type    NM_INV_ITEMS.iit_inv_Type%TYPE;
  l_tab_non_prim_nadl   Nm3nwad.tab_nadl;
--
BEGIN
--
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'end_date_linked_inv');
--

 /* NET TYPE ONLY */
--    IF pi_nt_type IS NOT NULL AND pi_group_type IS NULL
--    THEN
--
--      --get primary AD type for Network type
--      BEGIN
--         l_nadt_rec := Nm3nwad.get_prim_nadt(pi_nt_type => pi_nt_type);
--
--      EXCEPTION
--        WHEN e_generic_error
--        THEN
--
--          IF Hig.check_last_ner(pi_appl => Nm3type.c_hig
--                               ,pi_id   => 67)
--            AND NOT pi_raise_if_no_link
--          THEN
--            RAISE e_no_link_and_ignore;
--          ELSE
--            RAISE;
--          END IF;
--
--      END;
-- --
--      --get item group is linked to
--      --l_iit_ne_id := Nm3get.get_ngil(pi_ngil_ne_ne_id => pi_ne_id).ngil_iit_ne_id;
--      Nm3nwad.get_prim_inv_item_for_element
--        ( pi_ne_id              => pi_ne_id
--        , pi_raise_if_not_found => FALSE
--        , po_iit_ne_id          => l_primary_iit_ne_id
--        , po_inv_type           => l_primary_inv_type);
--
--      IF l_primary_iit_ne_id IS NOT NULL
--      THEN
--      --end date item
--         UPDATE
--           NM_INV_ITEMS iit
--         SET
--           iit.iit_end_date = pi_end_date
--         WHERE
--           iit.iit_ne_id = l_primary_iit_ne_id;
--      END IF;
--
--      -- Get non-primary records for end-dating
--      l_tab_non_prim_nadl :=
--        Nm3nwad.get_non_prim_nadl_from_ne_id
--          ( pi_nadl_ne_id      => pi_ne_id
--          , pi_end_dated       => FALSE
--          , pi_raise_not_found => FALSE );
--
--      IF l_tab_non_prim_nadl.COUNT > 0
--       THEN
--         FOR i IN 1..l_tab_non_prim_nadl.COUNT
--          LOOP
--
--            UPDATE
--             NM_INV_ITEMS iit
--            SET
--             iit.iit_end_date = pi_end_date
--            WHERE
--             iit.iit_ne_id = l_primary_iit_ne_id;
--
--         END LOOP;
--      END IF;
--
--   END IF;
--
 /* GROUPS */
--   IF pi_nt_type IS NOT NULL AND pi_group_type IS NOT NULL
--   THEN
--     --check group type is linked to inv type
--     BEGIN
--        l_nadt_rec := Nm3nwad.get_nadt(pi_nt_type => pi_nt_type
--                                      ,pi_gty_type => pi_group_type);
--     EXCEPTION
--       WHEN e_generic_error
--      THEN
--         IF Hig.check_last_ner(pi_appl => Nm3type.c_hig
--                              ,pi_id   => 67)
--           AND NOT pi_raise_if_no_link
--         THEN
--           RAISE e_no_link_and_ignore;
--         ELSE
--           RAISE;
--         END IF;
--
--     END;
--
--     --get item group is linked to
--     l_iit_ne_id := nm3get.get_ngil(pi_ngil_ne_ne_id => pi_ne_id).ngil_iit_ne_id;
--
--     --end date item
--     UPDATE
--       nm_inv_items iit
--     SET
--       iit.iit_end_date = pi_end_date
--     WHERE
--       iit.iit_ne_id = l_iit_ne_id;
--   END IF;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'end_date_linked_inv');

EXCEPTION
  WHEN e_no_link_and_ignore
  THEN
    NULL;

END end_date_linked_inv;
--
-----------------------------------------------------------------------------
-- End of nm3group_inv procs
-----------------------------------------------------------------------------
--
FUNCTION get_non_prim_nadl_from_ne_id
           ( pi_nadl_ne_id        NM_NW_AD_LINK.nad_ne_id%TYPE
           , pi_end_dated         BOOLEAN     DEFAULT FALSE
           , pi_raise_not_found   BOOLEAN     DEFAULT TRUE
           , pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000)
  RETURN tab_nadl
IS

   l_found  BOOLEAN;
   l_retval tab_nadl;
   l_rec_nadl_temp NM_NW_AD_LINK%ROWTYPE;

BEGIN

   Nm_Debug.proc_start(g_package_name,'get_nadl_from_iit_ne_id');
   IF pi_end_dated
    THEN
      SELECT *
      BULK COLLECT INTO l_retval
      FROM NM_NW_AD_LINK_ALL nadl
      WHERE nad_ne_id = pi_nadl_ne_id
      AND EXISTS (SELECT 1
                    FROM NM_NW_AD_TYPES nadt
                   WHERE nadt.nad_id = nadl.nad_id AND nad_primary_ad = 'N');

   ELSE
      SELECT *
      BULK COLLECT INTO l_retval
      FROM NM_NW_AD_LINK nadl
      WHERE nad_ne_id = pi_nadl_ne_id
      AND EXISTS (SELECT 1
                    FROM NM_NW_AD_TYPES nadt
                   WHERE nadt.nad_id = nadl.nad_id AND nad_primary_ad = 'N');
   END IF;

   IF pi_raise_not_found AND l_retval.COUNT = 0
    THEN
      Hig.raise_ner (pi_appl               => Nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_nw_ad_link'
                                              ||CHR(10)||'ne_id => '||pi_nadl_ne_id
                    );
   END IF;

   Nm_Debug.proc_end(g_package_name,'get_nadl_from_iit_ne_id');

   RETURN l_retval;

END get_non_prim_nadl_from_ne_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_prim_nadl_from_ne_id
           ( pi_nadl_ne_id        NM_NW_AD_LINK.nad_ne_id%TYPE
           , pi_end_dated         BOOLEAN     DEFAULT FALSE
           , pi_raise_not_found   BOOLEAN     DEFAULT TRUE
           , pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
           )
  RETURN NM_NW_AD_LINK%ROWTYPE
IS
   CURSOR cs_nadl
   IS
   SELECT *
   FROM NM_NW_AD_LINK nadl
   WHERE nad_ne_id = pi_nadl_ne_id
   AND EXISTS (SELECT 1
               FROM NM_NW_AD_TYPES nadt
               WHERE nadl.nad_id = nadt.nad_id
               AND nadt.nad_primary_ad = 'Y');


   CURSOR cs_nadl_all
   IS
   SELECT *
   FROM NM_NW_AD_LINK_ALL nadl
   WHERE nad_ne_id = pi_nadl_ne_id
   AND EXISTS (SELECT 1
               FROM NM_NW_AD_TYPES nadt
               WHERE nadl.nad_id = nadt.nad_id
               AND nadt.nad_primary_ad = 'Y');

   l_found  BOOLEAN;
   l_retval NM_NW_AD_LINK%ROWTYPE;

BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_nadl_from_iit_ne_id');
--
   IF pi_end_dated THEN

      OPEN  cs_nadl_all;
      FETCH cs_nadl_all INTO l_retval;
      l_found := cs_nadl_all%FOUND;
      CLOSE cs_nadl_all;

   ELSE

      OPEN  cs_nadl;
      FETCH cs_nadl INTO l_retval;
      l_found := cs_nadl%FOUND;
      CLOSE cs_nadl;

   END IF;

   IF pi_raise_not_found AND NOT l_found
    THEN
      Hig.raise_ner (pi_appl               => Nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_nw_ad_link'
                                              ||CHR(10)||'ne_id => '||pi_nadl_ne_id
                    );
   END IF;
   RETURN l_retval;
--
   Nm_Debug.proc_end(g_package_name,'get_nadl_from_iit_ne_id');
--
END get_prim_nadl_from_ne_id;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_ad_split
   ( pi_old_ne_id  IN NM_ELEMENTS.ne_id%TYPE
   , pi_new_ne_id1 IN NM_ELEMENTS.ne_id%TYPE
   , pi_new_ne_id2 IN NM_ELEMENTS.ne_id%TYPE
   )
/*
   This procedure is called from nm3split
   The old NE ids AD data is replicated as two new Inv items and associated
   with the two New NE ids.
*/
IS
   l_rec_nadl_prim      NM_NW_AD_LINK%ROWTYPE;
   l_rec_iit_prim_1     NM_INV_ITEMS%ROWTYPE;
   l_rec_iit_prim_2     NM_INV_ITEMS%ROWTYPE;
   l_rec_iit_np_1       NM_INV_ITEMS%ROWTYPE;
   l_rec_iit_np_2       NM_INV_ITEMS%ROWTYPE;
   l_rec_nadl_non_prim  NM_NW_AD_LINK%ROWTYPE;
   l_tab_non_prim_nadl  Nm3nwad.tab_nadl;
   l_effective_date     DATE;

BEGIN
--
   Nm_Debug.proc_start(g_package_name,'do_ad_split');
--
   l_effective_date := nm3get.get_ne_all(pi_ne_id => pi_new_ne_id1).ne_start_date; -- end date to be start date of new element(s)

   l_rec_nadl_prim := Nm3nwad.get_prim_nadl_from_ne_id
                        ( pi_nadl_ne_id      => pi_old_ne_id
                        , pi_raise_not_found => FALSE);
--
   IF l_rec_nadl_prim.nad_id IS NOT NULL
    THEN
--
      -- Create a duplicate inv item for each new element
      l_rec_iit_prim_1    := Nm3get.get_iit (l_rec_nadl_prim.nad_iit_ne_id);
      l_rec_iit_prim_2    := Nm3get.get_iit (l_rec_nadl_prim.nad_iit_ne_id);
      l_rec_iit_prim_1.iit_ne_id := Nm3seq.next_ne_id_seq;
      l_rec_iit_prim_2.iit_ne_id := Nm3seq.next_ne_id_seq;
--
      IF l_rec_iit_prim_1.iit_primary_key IS NOT NULL
       THEN
         l_rec_iit_prim_1.iit_primary_key := l_rec_iit_prim_1.iit_ne_id;
      END IF;

      IF l_rec_iit_prim_2.iit_primary_key IS NOT NULL
       THEN
         l_rec_iit_prim_2.iit_primary_key := l_rec_iit_prim_2.iit_ne_id;
      END IF;

--
-- derive start date of the inventory records to be the start date of the new element
--
       l_rec_iit_prim_1.iit_start_date := primary_ad_link_start_date(pi_nad_ne_id => pi_new_ne_id2);

       l_rec_iit_prim_2.iit_start_date := l_rec_iit_prim_1.iit_start_date;
--
      -- Create new inventory
      Nm3ins.ins_iit (l_rec_iit_prim_1);
      Nm3ins.ins_iit (l_rec_iit_prim_2);
--
      -- End Date orginal element link record
      Nm3nwad.end_date_nadl (pi_rec_nadl       => l_rec_nadl_prim
	                          ,pi_effective_date => l_effective_date);

      --
      -- set start date of AD link record to be same as the inventory item which is same as element start date
      --
	  l_rec_nadl_prim.nad_start_date := l_rec_iit_prim_1.iit_start_date;


      -- Create Primary link for new element 1
      l_rec_nadl_prim.nad_ne_id     := pi_new_ne_id1;
      l_rec_nadl_prim.nad_iit_ne_id := l_rec_iit_prim_1.iit_ne_id;
      Nm3nwad.ins_nadl(l_rec_nadl_prim);
--
      -- Create Primary link for new element 2
      l_rec_nadl_prim.nad_ne_id     := pi_new_ne_id2;
      l_rec_nadl_prim.nad_iit_ne_id := l_rec_iit_prim_2.iit_ne_id;
      Nm3nwad.ins_nadl(l_rec_nadl_prim);
   END IF;
--

/* Create nonprimary links to two new datums */
   l_tab_non_prim_nadl := Nm3nwad.get_non_prim_nadl_from_ne_id ( pi_nadl_ne_id      => pi_old_ne_id
                                                               , pi_end_dated       => FALSE
                                                               , pi_raise_not_found => FALSE );

   IF l_tab_non_prim_nadl.COUNT > 0
    THEN
      FOR i IN 1..l_tab_non_prim_nadl.COUNT
       LOOP

         -- create a duplicate inv item and associate with new element 1
         l_rec_iit_np_1                := Nm3get.get_iit (l_tab_non_prim_nadl(i).nad_iit_ne_id);
         l_rec_iit_np_1.iit_ne_id      := Nm3seq.next_ne_id_seq;
         l_rec_iit_np_1.iit_start_date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');

         -- create a duplicate inv item and associate with new element 2
         l_rec_iit_np_2                := Nm3get.get_iit (l_tab_non_prim_nadl(i).nad_iit_ne_id);
         l_rec_iit_np_2.iit_ne_id      := Nm3seq.next_ne_id_seq;
         l_rec_iit_np_2.iit_start_date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');

         IF l_rec_iit_np_1.iit_primary_key IS NOT NULL
          THEN
            l_rec_iit_np_1.iit_primary_key := l_rec_iit_np_1.iit_ne_id;
         END IF;

         IF l_rec_iit_np_2.iit_primary_key IS NOT NULL
          THEN
            l_rec_iit_np_2.iit_primary_key := l_rec_iit_np_2.iit_ne_id;
         END IF;

         -- end date non primary link
         Nm3nwad.end_date_nadl (pi_rec_nadl       => l_tab_non_prim_nadl(i)
  	                            ,pi_effective_date => l_effective_date);

         -- Insert new inventory
         Nm3ins.ins_iit (l_rec_iit_np_1);
         Nm3ins.ins_iit (l_rec_iit_np_2);

         l_rec_nadl_non_prim := l_tab_non_prim_nadl(i);

         -- Build rowtype for link element 1 and insert
         l_rec_nadl_non_prim.nad_ne_id     := pi_new_ne_id1;
         l_rec_nadl_non_prim.nad_iit_ne_id := l_rec_iit_np_1.iit_ne_id;
         -- 0108841 CWS None Primary Start date change to be greatest of iit and ne start dates.
         -- Previously it was set to the previous records start date which resulted in trigger errors.
         l_rec_nadl_non_prim.nad_start_date:= GREATEST( NVL(l_effective_date,TO_DATE('01/JAN/1900', 'DD/MON/YYYY')) -- element start date
                                                      , NVL(l_rec_nadl_prim.nad_start_date,TO_DATE('01/JAN/1900', 'DD/MON/YYYY'))); -- iit start date
          Nm3nwad.ins_nadl(l_rec_nadl_non_prim);

         -- Build rowtype for link element 2 and insert
         l_rec_nadl_non_prim.nad_ne_id     := pi_new_ne_id2;
         l_rec_nadl_non_prim.nad_iit_ne_id := l_rec_iit_np_2.iit_ne_id;
         Nm3nwad.ins_nadl(l_rec_nadl_non_prim);

      END LOOP;
   END IF;
--
   Nm_Debug.proc_end(g_package_name,'do_ad_split');
--
END do_ad_split;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_ad_unsplit
            ( pi_new_ne_id1   IN   NM_ELEMENTS.ne_id%TYPE
            , pi_new_ne_id2   IN   NM_ELEMENTS.ne_id%TYPE
            , pi_old_ne_id    IN   NM_ELEMENTS.ne_id%TYPE)
/*
   This procedure is called from nm3undo.
   This restores the two original elements AD data from a Split.
*/
IS
   l_rec_nadl_prim_ne1        NM_NW_AD_LINK%ROWTYPE;
   l_rec_nadl_prim_ne2        NM_NW_AD_LINK%ROWTYPE;
   l_rec_nadl_prim_old        NM_NW_AD_LINK%ROWTYPE;
   l_rec_nadl_non_prim_1      NM_NW_AD_LINK%ROWTYPE;
   l_rec_nadl_non_prim_2      NM_NW_AD_LINK%ROWTYPE;
   l_tab_nadl_non_prim_1      Nm3nwad.tab_nadl;
   l_tab_nadl_non_prim_2      Nm3nwad.tab_nadl;
   l_tab_nadl_old             Nm3nwad.tab_nadl;
BEGIN

   -- Delete AD link records of two elements being undone
   l_rec_nadl_prim_ne1 := Nm3nwad.get_prim_nadl_from_ne_id ( pi_nadl_ne_id      => pi_new_ne_id1
                                                           , pi_raise_not_found => FALSE);
   l_rec_nadl_prim_ne2 := Nm3nwad.get_prim_nadl_from_ne_id ( pi_nadl_ne_id      => pi_new_ne_id2
                                                           , pi_raise_not_found => FALSE);
   l_rec_nadl_prim_old := Nm3nwad.get_prim_nadl_from_ne_id ( pi_nadl_ne_id      => pi_old_ne_id
                                                           , pi_end_dated       => TRUE
                                                           , pi_raise_not_found => FALSE);
   IF l_rec_nadl_prim_ne1.nad_id IS NOT NULL
   THEN
      Nm3nwad.del_nadl (l_rec_nadl_prim_ne1);
      Nm3del.del_iit (l_rec_nadl_prim_ne1.nad_iit_ne_id);
   END IF;

   IF l_rec_nadl_prim_ne2.nad_id IS NOT NULL
   THEN
      Nm3nwad.del_nadl (l_rec_nadl_prim_ne2);
      Nm3del.del_iit (l_rec_nadl_prim_ne2.nad_iit_ne_id);
   END IF;

   IF l_rec_nadl_prim_old.nad_id IS NOT NULL
   THEN
      -- Re-open old AD link
      UPDATE NM_INV_ITEMS_ALL
         SET iit_end_date = NULL
       WHERE iit_ne_id = l_rec_nadl_prim_old.nad_iit_ne_id;
      Nm3nwad.un_end_date (l_rec_nadl_prim_old);
   END IF;

   -- Non Primary records
   l_tab_nadl_non_prim_1 :=
         Nm3nwad.get_non_prim_nadl_from_ne_id (pi_nadl_ne_id      => l_rec_nadl_prim_ne1.nad_ne_id
                                              ,pi_end_dated       => FALSE
                                              ,pi_raise_not_found => FALSE);
   l_tab_nadl_non_prim_2 :=
         Nm3nwad.get_non_prim_nadl_from_ne_id (pi_nadl_ne_id      => l_rec_nadl_prim_ne2.nad_ne_id
                                              ,pi_end_dated       => FALSE
                                              ,pi_raise_not_found => FALSE);

   -- ADs for element 1
   IF l_tab_nadl_non_prim_1.COUNT > 0
   THEN
      FOR i IN 1 .. l_tab_nadl_non_prim_1.COUNT
      LOOP
         -- Delete link
         l_rec_nadl_non_prim_1 := l_tab_nadl_non_prim_1 (i);
         Nm3nwad.del_nadl (l_rec_nadl_non_prim_1);
         -- Delete inventory
         Nm3del.del_iit (l_rec_nadl_non_prim_1.nad_iit_ne_id);
      END LOOP;
   END IF;

   l_tab_nadl_old := Nm3nwad.get_non_prim_nadl_from_ne_id (pi_nadl_ne_id      => pi_old_ne_id
                                                          ,pi_end_dated       => TRUE
                                                          ,pi_raise_not_found => FALSE);

   -- Reopen old links for old ne_id
   IF l_tab_nadl_old.COUNT > 0
    THEN
      FOR i IN 1..l_tab_nadl_old.COUNT
       LOOP
         Nm3nwad.un_end_date (l_tab_nadl_old(i));
      END LOOP;
   END IF;


   -- ADs for element 2
   IF l_tab_nadl_non_prim_2.COUNT > 0
   THEN
      FOR i IN 1 .. l_tab_nadl_non_prim_2.COUNT
      LOOP
         -- Delete link
         l_rec_nadl_non_prim_2 := l_tab_nadl_non_prim_2 (i);
         Nm3nwad.del_nadl (l_rec_nadl_non_prim_2);
         -- Delete inventory
         Nm3del.del_iit (l_rec_nadl_non_prim_2.nad_iit_ne_id);
      END LOOP;
   END IF;
END do_ad_unsplit;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_ad_merge (pi_new_ne_id   IN NM_ELEMENTS.ne_id%TYPE
                      ,pi_old_ne_id1  IN NM_ELEMENTS.ne_id%TYPE
                      ,pi_old_ne_id2  IN NM_ELEMENTS.ne_id%TYPE
                      ,pi_effective_date IN DATE)
/*
   This procedure is called from nm3merge to deal with any AD data assocaited
   with the two old NE ids and copies the first NE ids details across to
   the New NE Id
*/
IS
   l_rec_nadl_prim     NM_NW_AD_LINK%ROWTYPE;
   l_rec_nadl_non_prim NM_NW_AD_LINK%ROWTYPE;

   l_tab_non_prim_nadl1 tab_nadl;
   l_tab_non_prim_nadl2 tab_nadl;

   l_effective_date     DATE;

   l_rec_iit_prim       NM_INV_ITEMS%ROWTYPE;
   l_rec_iit_non_prim   NM_INV_ITEMS%ROWTYPE;


BEGIN
--
   Nm_Debug.proc_start(g_package_name,'do_ad_merge');
--
   l_effective_date := nm3get.get_ne_all(pi_ne_id => pi_new_ne_id).ne_start_date; -- end date to be start date of new element(s)



/*
   create a new primary nadl records for the combined old items
   only needs to be one for the two records being merged
*/
   l_rec_nadl_prim := Nm3nwad.get_prim_nadl_from_ne_id
                        ( pi_nadl_ne_id      => pi_old_ne_id1
                        , pi_raise_not_found => FALSE);
--
   IF l_rec_nadl_prim.nad_id IS NOT NULL
    THEN

      -- create a copy of the primary ad link asset from ne 1
      l_rec_iit_prim    := Nm3get.get_iit (l_rec_nadl_prim.nad_iit_ne_id);
      l_rec_iit_prim.iit_ne_id := Nm3seq.next_ne_id_seq;
--
      IF l_rec_iit_prim.iit_primary_key IS NOT NULL
       THEN
         l_rec_iit_prim.iit_primary_key := l_rec_iit_prim.iit_ne_id;
      END IF;

      -- end date the old primary records

      end_date_nadl(pi_rec_nadl       => l_rec_nadl_prim
	               ,pi_effective_date => l_effective_date);

      -- create the new asset

      Nm3ins.ins_iit (l_rec_iit_prim);

      -- create a new primary record using the first onl ne_id

      l_rec_nadl_prim.nad_ne_id     := pi_new_ne_id;
      l_rec_nadl_prim.nad_iit_ne_id := l_rec_iit_prim.iit_ne_id;

      --
      -- derive start date of the AD Link record to be the start date of the new element
      --
      l_rec_nadl_prim.nad_start_date := primary_ad_link_start_date(pi_nad_ne_id => pi_new_ne_id);

      Nm3nwad.ins_nadl(l_rec_nadl_prim);

   END IF;
--
   -- now need to loop round on the child records for both old records
   -- making them link to the new record

   l_tab_non_prim_nadl1 := Nm3nwad.get_non_prim_nadl_from_ne_id
                             ( pi_nadl_ne_id      => pi_old_ne_id1
                             , pi_end_dated       => FALSE
                             , pi_raise_not_found => FALSE);

   l_rec_nadl_prim := Nm3nwad.get_prim_nadl_from_ne_id(pi_old_ne_id2, FALSE);

   end_date_nadl(pi_rec_nadl       => l_rec_nadl_prim
                ,pi_effective_date => l_effective_date);

   IF  l_tab_non_prim_nadl1.COUNT > 0
   AND l_rec_nadl_prim.nad_id     IS NOT NULL
   THEN

      FOR i IN 1..l_tab_non_prim_nadl1.COUNT
      LOOP
         l_rec_nadl_non_prim.nad_id         := l_tab_non_prim_nadl1(i).nad_id;
         l_rec_nadl_non_prim.nad_iit_ne_id  := l_tab_non_prim_nadl1(i).nad_iit_ne_id;
         l_rec_nadl_non_prim.nad_ne_id      := l_tab_non_prim_nadl1(i).nad_ne_id;
         l_rec_nadl_non_prim.nad_start_date := l_tab_non_prim_nadl1(i).nad_start_date;

      -- create a copy of the primary ad link asset from ne 1

         l_rec_iit_non_prim           := Nm3get.get_iit (l_rec_nadl_non_prim.nad_iit_ne_id);
         l_rec_iit_non_prim.iit_ne_id := Nm3seq.next_ne_id_seq;
--
         IF l_rec_iit_non_prim.iit_primary_key IS NOT NULL
         THEN
            l_rec_iit_non_prim.iit_primary_key := l_rec_iit_prim.iit_ne_id;
         END IF;

         end_date_nadl(pi_rec_nadl       => l_rec_nadl_non_prim
		              ,pi_effective_date => l_effective_date);

         end_date_nadl(pi_rec_nadl       => l_rec_nadl_prim
		              ,pi_effective_date => l_effective_date);

         Nm3ins.ins_iit (l_rec_iit_non_prim);

         l_rec_nadl_non_prim.nad_id         := l_tab_non_prim_nadl1(i).nad_id;
         l_rec_nadl_non_prim.nad_iit_ne_id  := l_rec_iit_non_prim.iit_ne_id; -- l_tab_non_prim_nadl1(i).nad_iit_ne_id;
         l_rec_nadl_non_prim.nad_ne_id      := pi_new_ne_id;
         l_rec_nadl_non_prim.nad_start_date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
         l_rec_nadl_non_prim.nad_end_date   := NULL;

         Nm3nwad.ins_nadl(l_rec_nadl_non_prim);

      END LOOP;

   END IF;

   l_tab_non_prim_nadl2 := Nm3nwad.get_non_prim_nadl_from_ne_id
                             ( pi_nadl_ne_id      => pi_old_ne_id2
                             , pi_end_dated       => FALSE
                             , pi_raise_not_found => FALSE );

   FOR i IN 1..l_tab_non_prim_nadl2.COUNT
   LOOP
      l_rec_nadl_non_prim.nad_id         := l_tab_non_prim_nadl2(i).nad_id;
      l_rec_nadl_non_prim.nad_iit_ne_id  := l_tab_non_prim_nadl2(i).nad_iit_ne_id;
      l_rec_nadl_non_prim.nad_ne_id      := l_tab_non_prim_nadl2(i).nad_ne_id;
      l_rec_nadl_non_prim.nad_start_date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
      l_rec_nadl_non_prim.nad_end_date   := NULL;

         end_date_nadl(pi_rec_nadl       => l_rec_nadl_non_prim
		              ,pi_effective_date => l_effective_date);


   END LOOP;
--
   Nm_Debug.proc_end(g_package_name,'do_ad_merge');
--
END do_ad_merge;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_ad_unmerge( pi_new_ne_id   IN NM_ELEMENTS.ne_id%TYPE
                       , pi_old_ne_id1   IN NM_ELEMENTS.ne_id%TYPE
                       , pi_old_ne_id2   IN NM_ELEMENTS.ne_id%TYPE)
IS
   l_rec_nadl_prim     NM_NW_AD_LINK%ROWTYPE;
   l_rec_nadl_non_prim NM_NW_AD_LINK%ROWTYPE;

   l_tab_non_prim_nadl1 tab_nadl;
   l_tab_non_prim_nadl2 tab_nadl;

BEGIN
--
   Nm_Debug.proc_start(g_package_name,'do_ad_unmerge');
--
   --
   --Delete the primary nadl record created in the merge
   --
   l_rec_nadl_prim := Nm3nwad.get_prim_nadl_from_ne_id
                        ( pi_nadl_ne_id      => pi_new_ne_id
                        , pi_raise_not_found => FALSE);

   IF l_rec_nadl_prim.nad_id IS NOT NULL
    THEN

      del_nadl(l_rec_nadl_prim);

      Nm3del.del_iit (l_rec_nadl_prim.nad_iit_ne_id);

      l_rec_nadl_prim := Nm3nwad.get_prim_nadl_from_ne_id(pi_old_ne_id1, TRUE);
      un_end_date(l_rec_nadl_prim);

      l_rec_nadl_prim := Nm3nwad.get_prim_nadl_from_ne_id(pi_old_ne_id2, TRUE);
      un_end_date(l_rec_nadl_prim);

   END IF;
   --
   --Delete the non-primary nadl records created in the merge
   --
   l_tab_non_prim_nadl1 := Nm3nwad.get_non_prim_nadl_from_ne_id(pi_nadl_ne_id      => pi_new_ne_id
                                                               ,pi_end_dated       => FALSE
                                                               ,pi_raise_not_found => FALSE);


  -- l_rec_nadl_prim := nm3nwad.get_prim_nadl_from_ne_id(pi_old_ne_id2);
   IF l_tab_non_prim_nadl1.COUNT > 0 THEN

      FOR i IN 1..l_tab_non_prim_nadl1.COUNT
      LOOP

         l_rec_nadl_non_prim.nad_id := l_tab_non_prim_nadl1(i).nad_id;
         l_rec_nadl_non_prim.nad_iit_ne_id := l_tab_non_prim_nadl1(i).nad_iit_ne_id;
         l_rec_nadl_non_prim.nad_ne_id := l_tab_non_prim_nadl1(i).nad_ne_id;
         l_rec_nadl_non_prim.nad_start_date := l_tab_non_prim_nadl1(i).nad_start_date;

         del_nadl(l_rec_nadl_non_prim);

         Nm3del.del_iit (l_rec_nadl_non_prim.nad_iit_ne_id);

      END LOOP;

   END IF;

   -- Need to un end date the original records
    l_tab_non_prim_nadl2 := Nm3nwad.get_non_prim_nadl_from_ne_id(pi_nadl_ne_id      => pi_old_ne_id2
                                                                ,pi_end_dated       => TRUE
                                                                ,pi_raise_not_found => FALSE);


   FOR i IN 1..l_tab_non_prim_nadl2.COUNT
   LOOP
      l_rec_nadl_non_prim.nad_id := l_tab_non_prim_nadl2(i).nad_id;
      l_rec_nadl_non_prim.nad_iit_ne_id := l_tab_non_prim_nadl2(i).nad_iit_ne_id;
      l_rec_nadl_non_prim.nad_ne_id := l_tab_non_prim_nadl2(i).nad_ne_id;
      l_rec_nadl_non_prim.nad_start_date := l_tab_non_prim_nadl2(i).nad_start_date;
      l_rec_nadl_non_prim.nad_end_date := l_tab_non_prim_nadl2(i).nad_end_date;

      -- Re-open old AD link
      UPDATE NM_INV_ITEMS_ALL
         SET iit_end_date = NULL
       WHERE iit_ne_id = l_rec_nadl_non_prim.nad_iit_ne_id;

      un_end_date(l_rec_nadl_non_prim);

   END LOOP;

   l_tab_non_prim_nadl2 := Nm3nwad.get_non_prim_nadl_from_ne_id(pi_nadl_ne_id      => pi_old_ne_id1
                                                                ,pi_end_dated       => TRUE
                                                                ,pi_raise_not_found => FALSE);

   FOR i IN 1..l_tab_non_prim_nadl2.COUNT
   LOOP
      l_rec_nadl_non_prim.nad_id := l_tab_non_prim_nadl2(i).nad_id;
      l_rec_nadl_non_prim.nad_iit_ne_id := l_tab_non_prim_nadl2(i).nad_iit_ne_id;
      l_rec_nadl_non_prim.nad_ne_id := l_tab_non_prim_nadl2(i).nad_ne_id;
      l_rec_nadl_non_prim.nad_start_date := l_tab_non_prim_nadl2(i).nad_start_date;
      l_rec_nadl_non_prim.nad_end_date := l_tab_non_prim_nadl2(i).nad_end_date;

      -- Re-open old AD link
      UPDATE NM_INV_ITEMS_ALL
         SET iit_end_date = NULL
       WHERE iit_ne_id = l_rec_nadl_non_prim.nad_iit_ne_id;

      un_end_date(l_rec_nadl_non_prim);

   END LOOP;
--
  Nm_Debug.proc_end(g_package_name,'do_ad_unmerge');
--
END do_ad_unmerge;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_ad_reclass
             ( pi_new_ne_id   IN NM_ELEMENTS.ne_id%TYPE
             , pi_old_ne_id   IN NM_ELEMENTS.ne_id%TYPE
			 , pi_new_ne_nt_type        IN nm_elements.ne_nt_type%TYPE
             , pi_new_ne_gty_group_type IN nm_elements.ne_gty_group_type%TYPE
			 ) IS

   l_rec_nadl_prim      NM_NW_AD_LINK%ROWTYPE;
   l_rec_iit_prim       NM_INV_ITEMS%ROWTYPE;
   l_rec_iit_np         NM_INV_ITEMS%ROWTYPE;
   l_rec_nadl_non_prim  NM_NW_AD_LINK%ROWTYPE;
   l_tab_non_prim_nadl  Nm3nwad.tab_nadl;
   l_new_nad_id         nm_nw_ad_link.nad_id%TYPE;
   l_effective_date     DATE;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'do_ad_reclass');
--
   l_effective_date := nm3get.get_ne_all(pi_ne_id => pi_new_ne_id).ne_start_date; -- end date to be start date of new element(s)

   l_rec_nadl_prim := Nm3nwad.get_prim_nadl_from_ne_id
                        ( pi_nadl_ne_id      => pi_old_ne_id
                        , pi_raise_not_found => FALSE);
--
   IF l_rec_nadl_prim.nad_id IS NOT NULL
    THEN
      -- Create a duplicate inv item for each new element
      l_rec_iit_prim  := Nm3get.get_iit_all (l_rec_nadl_prim.nad_iit_ne_id);
      l_rec_iit_prim.iit_ne_id := Nm3seq.next_ne_id_seq;
--
      IF l_rec_iit_prim.iit_primary_key IS NOT NULL
       THEN
         l_rec_iit_prim.iit_primary_key := l_rec_iit_prim.iit_ne_id;
      END IF;
--

      --
      -- derive start date of the inventory record to be the start date of the new element
      --
      l_rec_iit_prim.iit_start_date := primary_ad_link_start_date(pi_nad_ne_id => pi_new_ne_id);
--
      -- Create new inventory
      Nm3ins.ins_iit (l_rec_iit_prim);
--
      -- End Date orginal element link record
      Nm3nwad.end_date_nadl (pi_rec_nadl => l_rec_nadl_prim
	                        ,pi_effective_date => l_effective_date);
--
      -- Create Primary link for new element
      l_rec_nadl_prim.nad_ne_id     := pi_new_ne_id;
      l_rec_nadl_prim.nad_iit_ne_id := l_rec_iit_prim.iit_ne_id;
	  l_rec_nadl_prim.nad_start_date := l_rec_iit_prim.iit_start_date;
      Nm3nwad.ins_nadl(l_rec_nadl_prim);

   END IF;
--
/* Create nonprimary links to two new datums */

   l_tab_non_prim_nadl := Nm3nwad.get_non_prim_nadl_from_ne_id(pi_nadl_ne_id      => pi_old_ne_id
                                                              ,pi_end_dated       => TRUE
                                                              ,pi_raise_not_found => FALSE);


   IF l_tab_non_prim_nadl.COUNT > 0
    THEN
      FOR i IN 1..l_tab_non_prim_nadl.COUNT
       LOOP

	    IF ad_is_valid_on_new_ne(pi_old_nad_id          => l_tab_non_prim_nadl(i).nad_id
                                ,pi_new_ne_nt_type        => pi_new_ne_nt_type
                                ,pi_new_ne_gty_group_type => pi_new_ne_gty_group_type
      						    ,po_new_nad_id            => l_new_nad_id) THEN

             -- create a duplicate inv item and associate with new element 1
             l_rec_iit_np                := Nm3get.get_iit_all (l_tab_non_prim_nadl(i).nad_iit_ne_id);
             l_rec_iit_np.iit_ne_id      := Nm3seq.next_ne_id_seq;

             IF l_rec_iit_np.iit_primary_key IS NOT NULL
              THEN
                l_rec_iit_np.iit_primary_key := l_rec_iit_np.iit_ne_id;
             END IF;

            l_rec_nadl_non_prim := l_tab_non_prim_nadl(i);
            l_rec_nadl_non_prim.nad_id          := l_new_nad_id;
            l_rec_nadl_non_prim.nad_ne_id       := pi_new_ne_id;
            l_rec_nadl_non_prim.nad_iit_ne_id   := l_rec_iit_np.iit_ne_id;
            l_rec_nadl_non_prim.nad_start_date  := l_effective_date;

            --		 nm3debug.debug_iit(l_rec_iit_np);
            Nm3nwad.end_date_nadl (pi_rec_nadl => l_tab_non_prim_nadl(i)
			                      ,pi_effective_date => l_effective_date);
            Nm3ins.ins_iit_all (l_rec_iit_np);
            Nm3nwad.ins_nadl(l_rec_nadl_non_prim);

		 ELSE -- just end date the ad data
            Nm3nwad.end_date_nadl (pi_rec_nadl => l_tab_non_prim_nadl(i)
			                      ,pi_effective_date => l_effective_date);

         END IF;

      END LOOP;
   END IF;
--
   Nm_Debug.proc_end(g_package_name,'do_ad_reclass');
--
END do_ad_reclass;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_ad_replace
              ( pi_old_ne_id  IN NM_ELEMENTS.ne_id%TYPE
              , pi_new_ne_id  IN NM_ELEMENTS.ne_id%TYPE ) IS
/*
   The old NE ids AD data is replicated as new Inv item and associated
   with the New NE id.
*/

   l_rec_nadl_prim      NM_NW_AD_LINK%ROWTYPE;
   l_rec_iit_prim       NM_INV_ITEMS%ROWTYPE;

   l_rec_iit_np         NM_INV_ITEMS%ROWTYPE;

   l_rec_nadl_non_prim  NM_NW_AD_LINK%ROWTYPE;
   l_tab_non_prim_nadl  Nm3nwad.tab_nadl;

   l_effective_date     DATE;

BEGIN

   Nm_Debug.proc_start(g_package_name,'do_ad_replace');

   l_effective_date := nm3get.get_ne_all(pi_ne_id => pi_new_ne_id).ne_start_date; -- end date to be start date of new element(s)


   -- Get link record for primary AD from original element
   l_rec_nadl_prim := Nm3nwad.get_prim_nadl_from_ne_id
                        ( pi_nadl_ne_id      => pi_old_ne_id
                        , pi_raise_not_found => FALSE);

   -- get non-primary ad
   l_tab_non_prim_nadl := Nm3nwad.get_non_prim_nadl_from_ne_id(pi_nadl_ne_id      => pi_old_ne_id
                                                              ,pi_end_dated       => FALSE
                                                              ,pi_raise_not_found => FALSE);
--
   IF l_rec_nadl_prim.nad_id IS NOT NULL
    THEN
--
      -- Create a duplicate inv item for each new element

      l_rec_iit_prim   := Nm3get.get_iit(l_rec_nadl_prim.nad_iit_ne_id);
      l_rec_iit_prim.iit_ne_id := Nm3seq.next_ne_id_seq;
--
      IF l_rec_iit_prim.iit_primary_key IS NOT NULL
       THEN
         l_rec_iit_prim.iit_primary_key := l_rec_iit_prim.iit_ne_id;
      END IF;
--
      --
      -- derive start date of the inventory record to be the start date of the new element
      --
      l_rec_iit_prim.iit_start_date := primary_ad_link_start_date(pi_nad_ne_id => pi_new_ne_id);

--
      -- Create new inventory
      Nm3ins.ins_iit(l_rec_iit_prim);

--
      -- End Date orginal element link record
      Nm3nwad.end_date_nadl(pi_rec_nadl  => l_rec_nadl_prim
	                       ,pi_effective_date => l_effective_date);

      -- Create Primary link for new element
      l_rec_nadl_prim.nad_ne_id     := pi_new_ne_id;
      l_rec_nadl_prim.nad_iit_ne_id := l_rec_iit_prim.iit_ne_id;
	  l_rec_nadl_prim.nad_start_date := l_rec_iit_prim.iit_start_date;
      Nm3nwad.ins_nadl(l_rec_nadl_prim);
   END IF;



--
 /* Create nonprimary links  */
--   l_tab_non_prim_nadl := Nm3nwad.get_non_prim_nadl_from_ne_id
--                                     ( pi_old_ne_id, FALSE );


  IF l_tab_non_prim_nadl.COUNT > 0
    THEN
      FOR i IN l_tab_non_prim_nadl.FIRST..l_tab_non_prim_nadl.last
       LOOP

         -- create a duplicate inv item and associate with new element
         l_rec_iit_np                := Nm3get.get_iit (l_tab_non_prim_nadl(i).nad_iit_ne_id);
         l_rec_iit_np.iit_ne_id      := Nm3seq.next_ne_id_seq;
         l_rec_iit_np.iit_start_date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');

         -- end date non primary link
         Nm3nwad.end_date_nadl (pi_rec_nadl => l_tab_non_prim_nadl(i)
		                       ,pi_effective_date => l_effective_date);

         IF l_rec_iit_np.iit_primary_key IS NOT NULL
          THEN
            l_rec_iit_np.iit_primary_key := l_rec_iit_np.iit_ne_id;
         END IF;

         -- Insert new inventory
         Nm3ins.ins_iit (l_rec_iit_np);

         l_rec_nadl_non_prim := l_tab_non_prim_nadl(i);

         -- Build rowtype for link element and insert
         l_rec_nadl_non_prim.nad_ne_id     := pi_new_ne_id;
         l_rec_nadl_non_prim.nad_iit_ne_id := l_rec_iit_np.iit_ne_id;
          Nm3nwad.ins_nadl(l_rec_nadl_non_prim);


      END LOOP;
   END IF;

--
   Nm_Debug.proc_end(g_package_name,'do_ad_replace');

END do_ad_replace;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_ad_unreplace
              ( pi_old_ne_id  IN NM_ELEMENTS.ne_id%TYPE ) IS

   CURSOR get_old IS
   SELECT * FROM V_NM_ELEMENT_HISTORY vneh
   WHERE new_ne_id = pi_old_ne_id
   and   vneh.neh_operation = nm3net_history.c_neh_op_replace;

   l_rec_element_hist V_NM_ELEMENT_HISTORY%ROWTYPE;
   l_rec_nadl_non_prim   NM_NW_AD_LINK%ROWTYPE;
   l_rec_nadl_prim_old   NM_NW_AD_LINK%ROWTYPE;
   l_rec_nadl_prim_ne    NM_NW_AD_LINK%ROWTYPE;

   l_tab_nadl_non_prim   Nm3nwad.tab_nadl;
   l_tab_nadl_old        Nm3nwad.tab_nadl;

BEGIN

   Nm_Debug.proc_start(g_package_name,'do_ad_unreplace');
--
   -- use the old id to get the new id
   OPEN get_old;
   FETCH get_old INTO l_rec_element_hist;
   CLOSE get_old;

   -- delete the new record that was created
   -- Delete AD link record of the element being undone
   l_rec_nadl_prim_ne := Nm3nwad.get_prim_nadl_from_ne_id
                        ( pi_nadl_ne_id      => l_rec_element_hist.new_ne_id
                        , pi_raise_not_found => FALSE);

   IF l_rec_nadl_prim_ne.nad_id IS NOT NULL
    THEN
      Nm3nwad.del_nadl (l_rec_nadl_prim_ne);
   END IF;

   -- Re-open old AD link
   l_rec_nadl_prim_old := Nm3nwad.get_prim_nadl_from_ne_id
                        ( pi_nadl_ne_id      => l_rec_element_hist.old_ne_id
                        , pi_end_dated        => TRUE
                        , pi_raise_not_found => FALSE);

   IF l_rec_nadl_prim_old.nad_id IS NOT NULL
    THEN
      Nm3nwad.un_end_date (l_rec_nadl_prim_old);
   END IF;

   -- Remove inventory created for element as this was duplicated
   -- from the orginal in the replace - therefore we don't need them anymore
   IF l_rec_nadl_prim_ne.nad_id IS NOT NULL
    THEN
     Nm3del.del_iit (l_rec_nadl_prim_ne.nad_iit_ne_id);
   END IF;

   -- Non Primary records
   l_tab_nadl_non_prim :=
      Nm3nwad.get_non_prim_nadl_from_ne_id
           (pi_nadl_ne_id      => l_rec_nadl_prim_ne.nad_ne_id
           , pi_raise_not_found => FALSE);

   IF l_tab_nadl_non_prim.COUNT > 0
   THEN
      FOR i IN 1 .. l_tab_nadl_non_prim.COUNT
      LOOP
         -- Delete link
         l_rec_nadl_non_prim := l_tab_nadl_non_prim (i);

         Nm3nwad.del_nadl (l_rec_nadl_non_prim);
         -- Delete inventory
         Nm3del.del_iit (l_rec_nadl_non_prim.nad_iit_ne_id);
      END LOOP;
   END IF;

   l_tab_nadl_old := Nm3nwad.get_non_prim_nadl_from_ne_id
           ( pi_nadl_ne_id        => l_rec_element_hist.old_ne_id
             , pi_end_dated         => TRUE
             , pi_raise_not_found   => FALSE
             ) ;

   -- Reopen old links for old ne_id
   IF l_tab_nadl_old.COUNT > 0
    THEN
      FOR i IN 1..l_tab_nadl_old.COUNT
       LOOP
         Nm3nwad.un_end_date (l_tab_nadl_old(i));
      END LOOP;
   END IF;

--
   Nm_Debug.proc_end(g_package_name,'do_ad_unreplace');
--
END do_ad_unreplace;
--
-----------------------------------------------------------------------------
--
PROCEDURE un_end_date( pi_nm_nw_ad_link IN NM_NW_AD_LINK%ROWTYPE )
IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'un_end_date');
--
   UPDATE NM_INV_ITEMS_ALL
      SET iit_end_date = NULL
    WHERE iit_ne_id = pi_nm_nw_ad_link.nad_iit_ne_id;
--
   UPDATE NM_NW_AD_LINK_ALL
      SET nad_end_date = NULL
    WHERE nad_id       = pi_nm_nw_ad_link.nad_id
      AND nad_iit_ne_id  = pi_nm_nw_ad_link.nad_iit_ne_id
      AND nad_ne_id      = pi_nm_nw_ad_link.nad_ne_id
      AND nad_start_date = pi_nm_nw_ad_link.nad_start_date
      AND nad_end_date   = pi_nm_nw_ad_link.nad_end_date;
--
   Nm_Debug.proc_end(g_package_name,'un_end_date');
--
END un_end_date;
--
-----------------------------------------------------------------------------
--
PROCEDURE del_nadl( pi_nm_nw_ad_link IN NM_NW_AD_LINK%ROWTYPE )
IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'del_nadl');
--
   DELETE NM_NW_AD_LINK_ALL
   WHERE nad_id       = pi_nm_nw_ad_link.nad_id
   AND nad_iit_ne_id  = pi_nm_nw_ad_link.nad_iit_ne_id
   AND nad_ne_id      = pi_nm_nw_ad_link.nad_ne_id
   AND nad_start_date = pi_nm_nw_ad_link.nad_start_date;
--
   Nm_Debug.proc_start(g_package_name,'del_nadl');
--
END del_nadl;
--
-----------------------------------------------------------------------------
--
/* Return a rowtype of NM_NW_AD_TYPES for a given NAD_ID */
FUNCTION get_nadt
              ( pi_nad_id      IN NM_NW_AD_TYPES.nad_id%TYPE)
  RETURN NM_NW_AD_TYPES%ROWTYPE
IS
   l_rec_nadt NM_NW_AD_TYPES%ROWTYPE;
BEGIN

   SELECT *
     INTO l_rec_nadt
     FROM NM_NW_AD_TYPES
    WHERE nad_id = pi_nad_id;

   RETURN l_rec_nadt;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN NULL;
   WHEN OTHERS THEN
      RAISE;

END get_nadt;
--
-----------------------------------------------------------------------------
--
/* Return a rowtype of NM_NW_AD_TYPES for a group type */
FUNCTION get_nadt
              ( pi_nt_type          IN NM_NW_AD_TYPES.nad_nt_type%TYPE
              , pi_gty_type         IN NM_NW_AD_TYPES.nad_gty_type%TYPE)
  RETURN NM_NW_AD_TYPES%ROWTYPE
IS
   l_rec_nadt NM_NW_AD_TYPES%ROWTYPE;
BEGIN

   SELECT *
     INTO l_rec_nadt
     FROM NM_NW_AD_TYPES
    WHERE nad_nt_type = pi_nt_type
      AND nad_gty_type = pi_gty_type;

   RETURN l_rec_nadt;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN NULL;
   WHEN OTHERS THEN
      RAISE;

END get_nadt;
--
-----------------------------------------------------------------------------
--
/* Return a rowtype of Primary NM_NW_AD_TYPES for a Group type */
FUNCTION get_prim_nadt
              ( pi_nt_type          IN NM_NW_AD_TYPES.nad_nt_type%TYPE
              , pi_gty_type         IN NM_NW_AD_TYPES.nad_gty_type%TYPE)
  RETURN NM_NW_AD_TYPES%ROWTYPE
IS
   l_rec_nadt NM_NW_AD_TYPES%ROWTYPE;
BEGIN

   SELECT *
     INTO l_rec_nadt
     FROM NM_NW_AD_TYPES
    WHERE nad_nt_type = pi_nt_type
      AND nad_gty_type = pi_gty_type
      AND nad_primary_ad = 'Y';

   RETURN l_rec_nadt;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN NULL;
   WHEN OTHERS THEN
      RAISE;

END get_prim_nadt;
--
-----------------------------------------------------------------------------
--
/* Return a rowtype of NM_NW_AD_TYPES for a datum */
FUNCTION get_nadt
              ( pi_nt_type      IN NM_NW_AD_TYPES.nad_nt_type%TYPE)
  RETURN NM_NW_AD_TYPES%ROWTYPE
IS
   l_rec_nadt NM_NW_AD_TYPES%ROWTYPE;
BEGIN
   Nm_Debug.DEBUG('value  '||pi_nt_type);
   SELECT *
     INTO l_rec_nadt
     FROM NM_NW_AD_TYPES
    WHERE nad_nt_type = pi_nt_type
      AND nad_gty_type IS NULL;

   RETURN l_rec_nadt;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN NULL;
   WHEN OTHERS THEN
      RAISE;

END get_nadt;
--
-----------------------------------------------------------------------------
--
/* Return true if ad_data exists for the given ne_id */
FUNCTION ad_data_exist ( pi_ne_id IN NM_ELEMENTS.ne_id%TYPE
                       , pi_undo  IN BOOLEAN DEFAULT FALSE )
RETURN BOOLEAN
IS
   l_sql   Nm3type.max_varchar2;
   l_count NUMBER;
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'ad_data_exist');
--
   l_sql := 'SELECT COUNT(*) FROM NM_NW_AD_LINK_ALL'||CHR(10)||
            ' WHERE nad_ne_id = :p_ne_id AND nad_end_date IS NULL';

   IF pi_undo THEN
     l_sql := 'SELECT COUNT(*) FROM NM_NW_AD_LINK_ALL'||CHR(10)||
              ' WHERE nad_ne_id = :p_ne_id';
   END IF;
  --
   BEGIN
     EXECUTE IMMEDIATE l_sql
        INTO l_count USING pi_ne_id;
   EXCEPTION
     WHEN NO_DATA_FOUND
     THEN RETURN FALSE;
   END;
  --
   IF l_count > 0 THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
  --
--
   Nm_Debug.proc_end(g_package_name,'ad_data_exist');
--
END ad_data_exist;
--
-----------------------------------------------------------------------------
--
/* Return a rowtype of Primary NM_NW_AD_TYPES for a datum */
FUNCTION get_prim_nadt
              ( pi_nt_type      IN NM_NW_AD_TYPES.nad_nt_type%TYPE)
  RETURN NM_NW_AD_TYPES%ROWTYPE
IS
   l_rec_nadt NM_NW_AD_TYPES%ROWTYPE;
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_prim_nadt');
--
   SELECT *
     INTO l_rec_nadt
     FROM NM_NW_AD_TYPES
    WHERE nad_nt_type = pi_nt_type
      AND nad_gty_type IS NULL
      AND nad_primary_ad = 'Y';

   RETURN l_rec_nadt;
--
   Nm_Debug.proc_end(g_package_name,'get_prim_nadt');
--
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN NULL;
   WHEN OTHERS THEN
      RAISE;

END get_prim_nadt;
--
-----------------------------------------------------------------------------
--
/* Used to return a PLSQL Table of NM_NW_AD_TYPE values*/
PROCEDURE get_nadt_tab
              ( pi_nt_type          IN NM_NW_AD_TYPES.nad_nt_type%TYPE
              , pi_gty_type         IN NM_NW_AD_TYPES.nad_gty_type%TYPE
              , po_type_tab        OUT Nm3type.tab_varchar4
              , po_nad_id_tab      OUT Nm3type.tab_number)
IS
  CURSOR c1
  IS
   SELECT nad_inv_type
        , nad_id
     FROM NM_NW_AD_TYPES
    WHERE nad_nt_type = pi_nt_type
      AND nad_gty_type = pi_gty_type;
BEGIN

   OPEN c1;
   FETCH c1 BULK COLLECT INTO po_type_tab, po_nad_id_tab;
   CLOSE c1;

EXCEPTION
   WHEN OTHERS THEN
      RAISE;

END get_nadt_tab;
--
-----------------------------------------------------------------------------
--
/* Used to return a PLSQL Table of NM_NW_AD_TYPE values*/
PROCEDURE get_nadt_tab
              ( pi_nt_type          IN NM_NW_AD_TYPES.nad_nt_type%TYPE
              , po_type_tab        OUT Nm3type.tab_varchar4
              , po_nad_id_tab      OUT Nm3type.tab_number)
IS
  CURSOR c1
  IS
   SELECT nad_inv_type, nad_id
     FROM NM_NW_AD_TYPES
    WHERE nad_nt_type = pi_nt_type
      AND nad_gty_type IS NULL;
BEGIN

   OPEN c1;
   FETCH c1 BULK COLLECT INTO po_type_tab, po_nad_id_tab;
   CLOSE c1;

EXCEPTION
   WHEN OTHERS THEN
      RAISE;

END get_nadt_tab;
--
-----------------------------------------------------------------------------
--
/* Used to return a PLSQL Table of NM_NW_AD_TYPE values*/
PROCEDURE get_non_prim_nadt_tab
              ( pi_nt_type          IN NM_NW_AD_TYPES.nad_nt_type%TYPE
              , pi_gty_type         IN NM_NW_AD_TYPES.nad_gty_type%TYPE
              , po_type_tab        OUT Nm3type.tab_varchar4
              , po_nad_id_tab      OUT Nm3type.tab_number)
IS
  CURSOR c1
  IS
   SELECT nad_inv_type
        , nad_id
     FROM NM_NW_AD_TYPES
    WHERE nad_nt_type = pi_nt_type
      AND nad_gty_type = pi_gty_type
      AND nad_primary_ad = 'N'
    ORDER BY nad_display_order;
BEGIN

   OPEN c1;
   FETCH c1 BULK COLLECT INTO po_type_tab, po_nad_id_tab;
   CLOSE c1;

EXCEPTION
   WHEN OTHERS THEN
      RAISE;

END get_non_prim_nadt_tab;
--
-----------------------------------------------------------------------------
--
/* Used to return a PLSQL Table of NM_NW_AD_TYPE values*/
PROCEDURE get_non_prim_nadt_tab
              ( pi_nt_type          IN NM_NW_AD_TYPES.nad_nt_type%TYPE
              , po_type_tab        OUT Nm3type.tab_varchar4
              , po_nad_id_tab      OUT Nm3type.tab_number)
IS
  CURSOR c1
  IS
   SELECT nad_inv_type, nad_id
     FROM NM_NW_AD_TYPES
    WHERE nad_nt_type = pi_nt_type
      AND nad_gty_type IS NULL
      AND nad_primary_ad = 'N'
    ORDER BY nad_display_order;
BEGIN

   OPEN c1;
   FETCH c1 BULK COLLECT INTO po_type_tab, po_nad_id_tab;
   CLOSE c1;

EXCEPTION
   WHEN OTHERS THEN
      RAISE;

END get_non_prim_nadt_tab;
--
-----------------------------------------------------------------------------
--
/* Used to return a PLSQL Table of NM_NW_AD_TYPE values*/
FUNCTION get_non_prim_nadt_tab
              ( pi_nt_type          IN NM_NW_AD_TYPES.nad_nt_type%TYPE
              , pi_gty_type         IN NM_NW_AD_TYPES.nad_gty_type%TYPE)
  RETURN Nm3type.tab_varchar4
IS
  CURSOR c1
  IS
   SELECT nad_inv_type
     FROM NM_NW_AD_TYPES
    WHERE nad_nt_type = pi_nt_type
      AND nad_gty_type = pi_gty_type
      AND nad_primary_ad = 'N'
    ORDER BY nad_display_order;

  retval Nm3type.tab_varchar4;
BEGIN

   OPEN c1;
   FETCH c1 BULK COLLECT INTO retval;
   CLOSE c1;

   RETURN retval;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN retval;
   WHEN OTHERS THEN
      RAISE;

END get_non_prim_nadt_tab;
--
-----------------------------------------------------------------------------
--
/* Used to return a PLSQL Table of NM_NW_AD_TYPE values*/
FUNCTION get_non_prim_nadt_tab
              ( pi_nt_type          IN NM_NW_AD_TYPES.nad_nt_type%TYPE)
  RETURN Nm3type.tab_varchar4
IS
  CURSOR c1
  IS
   SELECT nad_inv_type
     FROM NM_NW_AD_TYPES
    WHERE nad_nt_type = pi_nt_type
      AND nad_gty_type IS NULL
      AND nad_primary_ad = 'N'
    ORDER BY nad_display_order;

  retval Nm3type.tab_varchar4;
BEGIN

   OPEN c1;
   FETCH c1 BULK COLLECT INTO retval;
   CLOSE c1;

   RETURN retval;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN retval;
   WHEN OTHERS THEN
      RAISE;

END get_non_prim_nadt_tab;
--
-----------------------------------------------------------------------------
--
/* Return SQL used for building LOVs */
FUNCTION get_nadt_sql
              ( pi_nt_type      IN NM_NW_AD_TYPES.nad_nt_type%TYPE)
  RETURN Nm3type.max_varchar2
IS
  retval Nm3type.max_varchar2;
BEGIN
  retval
    := 'SELECT nad_inv_type FROM nm_nw_ad_types '
     ||'FROM nm_nw_ad_types '
     ||'WHERE nad_nt_type = '||pi_nt_type
     ||' AND nad_gty_type IS NULL';

   RETURN retval;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN retval;
   WHEN OTHERS THEN
      RAISE;

END get_nadt_sql;
--
-----------------------------------------------------------------------------
--
/* Return SQL used for building LOVs */
FUNCTION get_nadt_sql
              ( pi_nt_type          IN NM_NW_AD_TYPES.nad_nt_type%TYPE
              , pi_gty_type         IN NM_NW_AD_TYPES.nad_gty_type%TYPE)
  RETURN Nm3type.max_varchar2
IS
  retval Nm3type.max_varchar2;
BEGIN
  retval := 'SELECT nad_inv_type FROM nm_nw_ad_types '
           ||'WHERE nad_nt_type = '||pi_nt_type
           ||'  AND nad_gty_type = '||pi_gty_type;

   RETURN retval;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN retval;
   WHEN OTHERS THEN
      RAISE;

END get_nadt_sql;
--
-----------------------------------------------------------------------------
--
/* Return SQL used for building LOVs */
FUNCTION get_non_prim_nadt_sql
              ( pi_nt_type      IN NM_NW_AD_TYPES.nad_nt_type%TYPE)
  RETURN Nm3type.max_varchar2
IS
  retval Nm3type.max_varchar2;
BEGIN
    retval := 'SELECT 1, nad_inv_type, nad_descr '
           ||'FROM nm_nw_ad_types '
           ||'WHERE nad_nt_type = '||pi_nt_type
           ||' AND nad_gty_type IS NULL'
           ||' AND nad_primary_ad = '||''''||'N'||'''';

   RETURN retval;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN retval;
   WHEN OTHERS THEN
      RAISE;

END get_non_prim_nadt_sql;
--
-----------------------------------------------------------------------------
--
/* Return SQL used for building LOVs */
FUNCTION get_non_prim_nadt_sql
              ( pi_nt_type      IN NM_NW_AD_TYPES.nad_nt_type%TYPE
              , pi_gty_type     IN NM_NW_AD_TYPES.nad_gty_type%TYPE)
  RETURN Nm3type.max_varchar2
IS
  retval Nm3type.max_varchar2;
BEGIN
    retval := 'SELECT 1, nad_inv_type, nad_descr '
           ||'FROM nm_nw_ad_types '
           ||'WHERE nad_nt_type = '||pi_nt_type
           ||' AND nad_gty_type IS NULL'
           ||' AND nad_primary_ad = '||''''||'N'||'''';
   RETURN retval;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN retval;
   WHEN OTHERS THEN
      RAISE;

END get_non_prim_nadt_sql;
--
-----------------------------------------------------------------------------
--
/* return a rowtype for nm_nw_ad_link based on nad_id, ne_id and iit_ne_id
  Will have to sit in this package until nm3get is changed */
FUNCTION get_nadl
              ( pi_nad_id           IN NM_NW_AD_LINK.nad_id%TYPE
              , pi_ne_id            IN NM_NW_AD_LINK.nad_ne_id%TYPE
              , pi_iit_ne_id        IN NM_NW_AD_LINK.nad_iit_ne_id%TYPE)
  RETURN NM_NW_AD_LINK%ROWTYPE
IS
   l_rec_nadl NM_NW_AD_LINK%ROWTYPE;
BEGIN

   SELECT *
     INTO l_rec_nadl
     FROM NM_NW_AD_LINK
    WHERE nad_id    = pi_nad_id
      AND nad_ne_id     = pi_ne_id
      AND nad_iit_ne_id = pi_iit_ne_id;

   RETURN l_rec_nadl;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN NULL;
   WHEN OTHERS THEN
      RAISE;
END get_nadl;
--
-----------------------------------------------------------------------------
--
/* Query rowtype for nm_nw_ad_link based on nad_id and ne_id */
FUNCTION get_nadl
              ( pi_nad_id      IN NM_NW_AD_LINK.nad_id%TYPE
              , pi_ne_id       IN NM_NW_AD_LINK.nad_ne_id%TYPE)
  RETURN NM_NW_AD_LINK%ROWTYPE
IS
   l_rec_nadl NM_NW_AD_LINK%ROWTYPE;
BEGIN

   SELECT *
     INTO l_rec_nadl
     FROM NM_NW_AD_LINK
    WHERE nad_id    = pi_nad_id
      AND nad_ne_id     = pi_ne_id;

   RETURN l_rec_nadl;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN NULL;
   WHEN OTHERS THEN
      RAISE;
END get_nadl;
--
-----------------------------------------------------------------------------
--
/* Insert a row for NM_NW_AD_TYPES */
PROCEDURE ins_nadt
              ( pi_nadt_rec    IN OUT NM_NW_AD_TYPES%ROWTYPE)
IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'ins_nadt');
--
--
   INSERT INTO NM_NW_AD_TYPES
     ( nad_id
     , nad_inv_type
     , nad_nt_type
     , nad_gty_type
     , nad_descr
     , nad_start_date
     , nad_end_date
     , nad_primary_ad
     , nad_display_order
     , nad_single_row
     , nad_mandatory )
    VALUES
     ( pi_nadt_rec.nad_id
     , pi_nadt_rec.nad_inv_type
     , pi_nadt_rec.nad_nt_type
     , pi_nadt_rec.nad_gty_type
     , pi_nadt_rec.nad_descr
     , pi_nadt_rec.nad_start_date
     , pi_nadt_rec.nad_end_date
     , pi_nadt_rec.nad_primary_ad
     , pi_nadt_rec.nad_display_order
     , pi_nadt_rec.nad_single_row
     , pi_nadt_rec.nad_mandatory )
    RETURNING
       nad_id
     , nad_inv_type
     , nad_nt_type
     , nad_gty_type
     , nad_descr
     , nad_start_date
     , nad_end_date
     , nad_primary_ad
     , nad_display_order
     , nad_single_row
     , nad_mandatory
    INTO
       pi_nadt_rec.nad_id
     , pi_nadt_rec.nad_inv_type
     , pi_nadt_rec.nad_nt_type
     , pi_nadt_rec.nad_gty_type
     , pi_nadt_rec.nad_descr
     , pi_nadt_rec.nad_start_date
     , pi_nadt_rec.nad_end_date
     , pi_nadt_rec.nad_primary_ad
     , pi_nadt_rec.nad_display_order
     , pi_nadt_rec.nad_single_row
     , pi_nadt_rec.nad_mandatory;
--
   Nm_Debug.proc_end(g_package_name,'ins_nadt');
--
END ins_nadt;
--
-----------------------------------------------------------------------------
--
/* Insert a row for nm_nw_ad_link */
PROCEDURE ins_nadl( pi_nadl_rec  IN OUT NM_NW_AD_LINK%ROWTYPE)
IS
BEGIN
-- nm_nw_ad_types
   Nm_Debug.proc_start(g_package_name,'ins_nadl');
--
  INSERT INTO NM_NW_AD_LINK
    ( nad_id
    , nad_iit_ne_id
    , nad_ne_id
    , nad_start_date
	, nad_end_date )
   VALUES
    ( pi_nadl_rec.nad_id
    , pi_nadl_rec.nad_iit_ne_id
    , pi_nadl_rec.nad_ne_id
    , pi_nadl_rec.nad_start_date
	, pi_nadl_rec.nad_end_date)
   RETURNING
      nad_id
    , nad_iit_ne_id
    , nad_ne_id
    , nad_start_date
	, nad_end_date
   INTO
      pi_nadl_rec.nad_id
    , pi_nadl_rec.nad_iit_ne_id
    , pi_nadl_rec.nad_ne_id
    , pi_nadl_rec.nad_start_date
	, pi_nadl_rec.nad_end_date;

--
   Nm_Debug.proc_end(g_package_name,'ins_nadl');
--
END ins_nadl;
--
-----------------------------------------------------------------------------
--
/* End date NM_NW_AD_LINK record */
PROCEDURE end_date_nadl( pi_rec_nadl IN NM_NW_AD_LINK%ROWTYPE
                        ,pi_effective_date IN DATE  DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY') )
IS
BEGIN
--
   UPDATE NM_NW_AD_LINK_ALL
      SET nad_end_date  = pi_effective_date
    WHERE nad_id        = pi_rec_nadl.nad_id
      AND nad_iit_ne_id = pi_rec_nadl.nad_iit_ne_id
      AND nad_ne_id     = pi_rec_nadl.nad_ne_id
	  AND nad_end_date IS NULL;

-- GJ 18-JUL-2006
-- New trigger on nm_nw_ad_link_all (nm_nw_ad_link_all_bu_trg)
-- will now cascade end date the related nm_inv_item_all record
--
--
--    UPDATE NM_INV_ITEMS_ALL
--       SET iit_end_date  = pi_effective_date
--     WHERE iit_ne_id = pi_rec_nadl.nad_iit_ne_id
-- 	   AND   iit_end_date IS NULL;

--
END end_date_nadl;
--
-----------------------------------------------------------------------------
--
PROCEDURE end_date_all_ad_for_element(pi_ne_id IN nm_elements_all.ne_id%TYPE
                                     ,pi_effective_date IN DATE  DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY') ) IS

BEGIN

   UPDATE NM_NW_AD_LINK_ALL
      SET nad_end_date  = pi_effective_date
    WHERE nad_ne_id     = pi_ne_id
	  AND nad_end_date IS NULL;

-- GJ 18-JUL-2006
-- Note: Trigger on nm_nw_ad_link_all (nm_nw_ad_link_all_bu_trg)
--       will cascade end date the related nm_inv_item_all record
--
END end_date_all_ad_for_element;
--
-----------------------------------------------------------------------------
--
/* NM_NW_AD_TYPES trigger validation code */
PROCEDURE process_table_nwad_types IS

   CURSOR cur_primary_dt IS                     -- Check that a Primary AD type exists
   SELECT * FROM NM_NW_AD_TYPES
   WHERE nad_nt_type = g_tab_nadt(1).nad_nt_type
   AND nad_primary_ad = 'Y'
   AND nad_id <> g_tab_nadt(1).nad_id;


   CURSOR cur_primary_gty IS                     -- Check that a Primary AD type exists
   SELECT * FROM NM_NW_AD_TYPES
   WHERE nad_nt_type = g_tab_nadt(1).nad_nt_type
   AND nad_gty_type =  g_tab_nadt(1).nad_gty_type
   AND nad_primary_ad = 'Y'
   AND nad_id <> g_tab_nadt(1).nad_id;


   CURSOR cur_chk_dt IS                         -- Check that the primary being created is not a duplicate
   SELECT * FROM NM_NW_AD_TYPES
   WHERE nad_nt_type = g_tab_nadt(1).nad_nt_type
   AND nad_inv_type =  g_tab_nadt(1).nad_inv_type
   AND nad_id <> g_tab_nadt(1).nad_id;


   CURSOR cur_chk_gty IS                         -- Check that the primary being created is not a duplicate
   SELECT * FROM NM_NW_AD_TYPES
   WHERE nad_nt_type = g_tab_nadt(1).nad_nt_type
   AND nad_inv_type =  g_tab_nadt(1).nad_inv_type
   AND NVL(nad_gty_type, '#') =  NVL(g_tab_nadt(1).nad_gty_type, '#')
   AND nad_id <> g_tab_nadt(1).nad_id;

   l_record NM_NW_AD_TYPES%ROWTYPE;

BEGIN

   IF g_tab_nadt(1).nad_gty_type IS NULL
      -- Inserting a datum AD combination
   THEN

      OPEN cur_primary_dt;
      FETCH cur_primary_dt INTO l_record;
      IF cur_primary_dt%NOTFOUND THEN

      CLOSE cur_primary_dt;

      IF  g_tab_nadt(1).nad_primary_ad = 'N' THEN

            -- Not a primary being inserted, and a primary does not exist so fail
--         g_tab_nadt.DELETE;
--         Hig.raise_ner(pi_appl     => Nm3type.c_net
--                      ,pi_id       => 368);
           NULL;

      END IF;

   ELSE

      CLOSE cur_primary_dt;

      -- Check that a Primary AD type exists
      IF g_tab_nadt(1).nad_primary_ad = 'Y'
      AND l_record.nad_primary_ad = 'Y' THEN

      -- we already have a primary so fail
         g_tab_nadt.DELETE;
         Hig.raise_ner(pi_appl     => Nm3type.c_net
                      ,pi_id       => 369 );

      END IF;

   END IF;

     -- Need to stop duplicates
      OPEN cur_chk_dt;
      FETCH cur_chk_dt INTO	l_record;
      IF cur_chk_dt%FOUND THEN

     -- we already have this combination of nad_nt_type and nad_inv_type
         g_tab_nadt.DELETE;
         Hig.raise_ner(pi_appl     => Nm3type.c_net
                      ,pi_id       => 370 );

      ELSE

         CLOSE cur_chk_dt;

      END IF;

   ELSE
     -- inserting a Group Type AD

      OPEN cur_primary_gty;
      FETCH cur_primary_gty INTO l_record;
      IF cur_primary_gty%NOTFOUND THEN

         CLOSE cur_primary_gty;

         IF  g_tab_nadt(1).nad_primary_ad = 'N' THEN

            -- Not a primary being inserted, and a primary does not exist so fail
--            g_tab_nadt.DELETE;
--            Hig.raise_ner(pi_appl    => Nm3type.c_net
--                         ,pi_id      => 371 );
              NULL;

         END IF;

      ELSE

         CLOSE cur_primary_gty;
         -- Check that a Primary AD type exists

         IF g_tab_nadt(1).nad_primary_ad = 'Y'
          AND l_record.nad_primary_ad = 'Y' THEN

             -- we already have a primary so fail
            g_tab_nadt.DELETE;
            Hig.raise_ner(pi_appl     => Nm3type.c_net
                         ,pi_id       => 372 );

         END IF;

      END IF;

     -- Need to stop duplicates
      OPEN cur_chk_gty;
      FETCH cur_chk_gty INTO	l_record;
      IF cur_chk_gty%FOUND THEN

      -- we already have this combination of nad_nt_type and nad_inv_type
         CLOSE cur_chk_gty;

         g_tab_nadt.DELETE;
         Hig.raise_ner(pi_appl    => Nm3type.c_net
                      ,pi_id      => 373 );

      ELSE

         CLOSE cur_chk_gty;

      END IF;

   END IF;

   g_tab_nadt.DELETE;

END process_table_nwad_types;
--
-----------------------------------------------------------------------------
--
/* NM_NW_AD_LINK validation trigger code */
PROCEDURE process_table_nwad_link
IS
   CURSOR cur_chk(p_nad_id NM_NW_AD_LINK.nad_id%TYPE,
                  p_nad_ne_id  NM_NW_AD_LINK.nad_ne_id%TYPE)
   IS
      SELECT COUNT ('*')
      FROM NM_NW_AD_LINK_ALL
      WHERE nad_id = p_nad_id
      AND nad_ne_id = p_nad_ne_id
      AND nad_end_date IS NULL
      AND nad_id = (SELECT nad_id
                    FROM NM_NW_AD_TYPES
                    WHERE nad_id = p_nad_id
                    AND nad_primary_ad = 'Y');

   CURSOR cur_chk2
   IS
      SELECT COUNT ('*')
      FROM NM_NW_AD_LINK_ALL
      WHERE nad_iit_ne_id = g_tab_nadl (1).nad_iit_ne_id
      AND nad_end_date IS NULL;

   ln_dummy   NUMBER;
   l_tab_nadl tab_nadl;
   l_rec_nadt NM_NW_AD_TYPES%ROWTYPE;

BEGIN
 IF g_tab_nadl.COUNT > 0
 THEN

   l_rec_nadt := Nm3nwad.get_nadt(pi_nad_id => g_tab_nadl(1).nad_id);

   -- Check to make sure INV type being passed in matches AD Type
   -- primarily to trap a bug from Forms.
   IF l_rec_nadt.nad_inv_type != Nm3get.get_iit_all(pi_iit_ne_id => g_tab_nadl(1).nad_iit_ne_id).iit_inv_type
   THEN
      Hig.raise_ner (pi_appl => Nm3type.c_net, pi_id => 379);
   END IF;

   l_tab_nadl := Nm3nwad.get_non_prim_nadl_from_ne_id
                   ( pi_nadl_ne_id      => g_tab_nadl(1).nad_ne_id
                   , pi_raise_not_found => FALSE);
--
-- Check for Single Row violation
   IF Nm3nwad.get_nadt(pi_nad_id => g_tab_nadl(1).nad_id).nad_single_row = 'Y'
    AND l_tab_nadl.COUNT > 0
    THEN
      FOR i IN l_tab_nadl.FIRST .. l_tab_nadl.LAST
       LOOP
         IF l_tab_nadl(i).nad_id = g_tab_nadl(1).nad_id
          AND  l_tab_nadl(i).nad_iit_ne_id != g_tab_nadl(1).nad_iit_ne_id
           THEN
             g_tab_nadl.DELETE;
             -- Single Row Violation on Non Primary Links
             Hig.raise_ner (pi_appl => Nm3type.c_net, pi_id => 376);
         END IF;
     END LOOP;
   END IF;
--
-- A.E.
-- Remove this check for primary item existing - not the case anymore.
--   OPEN cur_chk(g_tab_nadl(1).nad_id,
--                g_tab_nadl(1).nad_ne_id);
--   FETCH cur_chk INTO ln_dummy;
--   IF cur_chk%FOUND   THEN
--
--      CLOSE cur_chk;
--
--      IF ln_dummy > 1
--      THEN
--         g_tab_nadl.DELETE;
--         Hig.raise_ner (pi_appl => Nm3type.c_net, pi_id => 374);
--      END IF;
--
--   ELSE
--
--      CLOSE cur_chk;
--
--   END IF;
--
   OPEN cur_chk2;
   FETCH cur_chk2 INTO ln_dummy;

   IF cur_chk2%FOUND THEN

      CLOSE cur_chk2;

      IF ln_dummy > 1
      THEN
         g_tab_nadl.DELETE;
         Hig.raise_ner (pi_appl => Nm3type.c_net, pi_id => 375);
      END IF;

   ELSE

      CLOSE cur_chk2;

   END IF;

   g_tab_nadl.DELETE;
 END IF;
EXCEPTION
   WHEN g_tab_nadt_exception
   THEN
      g_tab_nadl.DELETE;
      RAISE_APPLICATION_ERROR (g_tab_nadt_exc_code, g_tab_nadt_exc_msg);
END process_table_nwad_link;
--
-----------------------------------------------------------------------------
--
/* Used to set global record from forms */
PROCEDURE set_rec_link (pi_rec_link IN rec_link)
IS
BEGIN
   g_rec_link.pi_inv_type := pi_rec_link.pi_inv_type;
   g_rec_link.pi_nad_id := pi_rec_link.pi_nad_id;
   g_rec_link.pi_ne_id := pi_rec_link.pi_ne_id;
END set_rec_link;
--
-----------------------------------------------------------------------------
--
/* Used for returning global inv type in forms */
FUNCTION return_global_inv_type
   RETURN NM_INV_TYPES.nit_inv_type%TYPE
IS
BEGIN
   RETURN g_rec_link.pi_inv_type;
END return_global_inv_type;
--
-----------------------------------------------------------------------------
--
/* Used for returning data from global record - in forms */
FUNCTION return_global_record
   RETURN NM_NW_AD_LINK%ROWTYPE
IS
   l_rec_nadl   NM_NW_AD_LINK%ROWTYPE;
BEGIN
   l_rec_nadl.nad_id := g_rec_link.pi_nad_id;
   l_rec_nadl.nad_ne_id := g_rec_link.pi_ne_id;
   l_rec_nadl.nad_iit_ne_id := NULL;
   RETURN l_rec_nadl;
END return_global_record;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_links_from_membs
   (pi_nad_id IN NM_NW_AD_TYPES.nad_id%TYPE)
IS
   CURSOR get_membs (cp_obj_type IN NM_MEMBERS.nm_obj_type%TYPE)
   IS
      SELECT *
        FROM NM_MEMBERS
       WHERE nm_obj_type = cp_obj_type
         AND nm_type = 'I';

   l_rec_nadt  NM_NW_AD_TYPES%ROWTYPE;
   l_rec_nadl  NM_NW_AD_LINK_ALL%ROWTYPE;
   l_tab_nm    Nm3type.tab_rec_nm;
   l_nad_id    NM_NW_AD_TYPES.nad_id%TYPE := pi_nad_id;

BEGIN
  l_rec_nadt :=  Nm3nwad.get_nadt(pi_nad_id => l_nad_id);

  OPEN get_membs (cp_obj_type => l_rec_nadt.nad_inv_type);
  FETCH get_membs BULK COLLECT INTO l_tab_nm;
  CLOSE get_membs;

  IF l_tab_nm.COUNT > 0 THEN
     FOR membs IN l_tab_nm.FIRST..l_tab_nm.LAST
     LOOP
        BEGIN
           l_rec_nadl.nad_id         := l_rec_nadt.nad_id;
           l_rec_nadl.nad_iit_ne_id  := l_tab_nm(membs).nm_ne_id_in;
           l_rec_nadl.nad_ne_id      := l_tab_nm(membs).nm_ne_id_of;
           l_rec_nadl.nad_start_date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');

          Nm3nwad.ins_nadl(l_rec_nadl);
        EXCEPTION
           WHEN OTHERS THEN
           Nm_Debug.DEBUG('Cannot create AD Link for '||l_rec_nadl.nad_id||'-'||l_rec_nadl.nad_iit_ne_id||'-'||l_rec_nadl.nad_ne_id||'-'||l_rec_nadl.nad_start_date);
        END;

    END LOOP;
  ELSE
      Hig.raise_ner(pi_appl               => Nm3type.c_net
                   ,pi_id                 => 378
                   ,pi_supplementary_info =>NVL(l_rec_nadt.nad_gty_type, l_rec_nadt.nad_nt_type)||' - '|| l_rec_nadt.nad_inv_type);

  END IF;
END;
--
-----------------------------------------------------------------------------
--  SM APIs
-----------------------------------------------------------------------------
--
PROCEDURE get_prim_nadt_rc
           ( pi_nt_type   IN NM_NW_AD_TYPES.nad_nt_type%TYPE
           , pi_gty_type  IN NM_NW_AD_TYPES.nad_gty_type%TYPE
           , po_results  OUT nadtcurtyp
           )
  IS
     retval nadtcurtyp;
  BEGIN
     IF pi_gty_type IS NULL
       THEN

       OPEN retval
            FOR
          SELECT *
            FROM NM_NW_AD_TYPES
           WHERE nad_nt_type = pi_nt_type
             AND nad_gty_type IS NULL
             AND nad_primary_ad = 'Y';

     ELSIF pi_gty_type IS NOT NULL
       THEN

       OPEN retval
             FOR
          SELECT *
            FROM NM_NW_AD_TYPES
           WHERE nad_nt_type = pi_nt_type
             AND nad_gty_type = pi_gty_type
             AND nad_primary_ad = 'Y';

     END IF;
   po_results := retval;

EXCEPTION
   WHEN NO_DATA_FOUND THEN po_results := retval;
   WHEN OTHERS THEN RAISE;
END get_prim_nadt_rc;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_prim_nadl_from_ne_id_rc
           ( pi_nadl_ne_id         IN NM_NW_AD_LINK.nad_ne_id%TYPE
           , pi_end_dated          IN BOOLEAN     DEFAULT FALSE
           , pi_raise_not_found    IN BOOLEAN     DEFAULT FALSE
           , pi_not_found_sqlcode  IN PLS_INTEGER DEFAULT -20000
           , po_results           OUT nadlcurtyp
           )
IS
   retval    nadlcurtyp;
BEGIN

   IF pi_end_dated THEN
      OPEN retval
      FOR
      SELECT *
        FROM NM_NW_AD_LINK_ALL nadl
       WHERE nad_ne_id = pi_nadl_ne_id
         AND EXISTS
            (SELECT 1
               FROM NM_NW_AD_TYPES nadt
              WHERE nadl.nad_id = nadt.nad_id
                AND nadt.nad_primary_ad = 'Y');

   ELSE
      OPEN retval
      FOR
      SELECT *
        FROM NM_NW_AD_LINK nadl
       WHERE nad_ne_id = pi_nadl_ne_id
         AND EXISTS
            (SELECT 1
               FROM NM_NW_AD_TYPES nadt
              WHERE nadl.nad_id = nadt.nad_id
                AND nadt.nad_primary_ad = 'Y');
   END IF;

   po_results := retval;

EXCEPTION
   WHEN NO_DATA_FOUND
     THEN
      IF pi_raise_not_found
      THEN
        Hig.raise_ner (pi_appl               => Nm3type.c_hig
                      ,pi_id                 => 67
                      ,pi_sqlcode            => pi_not_found_sqlcode
                      ,pi_supplementary_info => 'nm_nw_ad_link'
                         ||CHR(10)||'ne_id => '||pi_nadl_ne_id );
      END IF;
   WHEN OTHERS THEN RAISE;
END get_prim_nadl_from_ne_id_rc;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_non_prim_nadl_rc
           ( pi_nadl_ne_id        IN  NM_NW_AD_LINK.nad_ne_id%TYPE
           , pi_end_dated         IN  BOOLEAN     DEFAULT FALSE
           , pi_raise_not_found   IN  BOOLEAN     DEFAULT FALSE
           , pi_not_found_sqlcode IN  PLS_INTEGER DEFAULT -20000
           , po_results           OUT nadlcurtyp)
IS
   l_found  BOOLEAN;
   retval   nadlcurtyp;
   l_rec_nadl_temp NM_NW_AD_LINK%ROWTYPE;
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_nadl_from_iit_ne_id_rc');

   IF pi_end_dated
    THEN
      OPEN retval
      FOR
        SELECT *
          FROM NM_NW_AD_LINK_ALL nadl
         WHERE nad_ne_id = pi_nadl_ne_id
           AND EXISTS (SELECT 1
                         FROM NM_NW_AD_TYPES nadt
                        WHERE nadt.nad_id = nadl.nad_id
                          AND nad_primary_ad = 'N');

   ELSE
      OPEN retval
      FOR
        SELECT *
          FROM NM_NW_AD_LINK nadl
         WHERE nad_ne_id = pi_nadl_ne_id
           AND EXISTS (SELECT 1
                         FROM NM_NW_AD_TYPES nadt
                        WHERE nadt.nad_id = nadl.nad_id
                          AND nad_primary_ad = 'N');
   END IF;

   po_results := retval;

   Nm_Debug.proc_end(g_package_name,'get_nadl_from_iit_ne_id');

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
     IF pi_raise_not_found THEN
       Hig.raise_ner (pi_appl               => Nm3type.c_hig
                     ,pi_id                 => 67
                     ,pi_sqlcode            => pi_not_found_sqlcode
                     ,pi_supplementary_info => 'nm_nw_ad_link'
                     ||CHR(10)||'ne_id => '||pi_nadl_ne_id );
     ELSE
        po_results := retval;
     END IF;
   WHEN OTHERS THEN RAISE;
END get_non_prim_nadl_rc;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_non_prim_nadt_rc
              ( pi_nt_type          IN NM_NW_AD_TYPES.nad_nt_type%TYPE
              , pi_gty_type         IN NM_NW_AD_TYPES.nad_gty_type%TYPE
              , po_results         OUT nadtcurtyp)
IS
  retval nadtcurtyp;
BEGIN

  IF pi_gty_type IS NULL
  THEN

    OPEN retval
     FOR
     SELECT *
       FROM NM_NW_AD_TYPES
      WHERE nad_nt_type = pi_nt_type
        AND nad_gty_type IS NULL
        AND nad_primary_ad = 'N'
      ORDER BY nad_display_order;
  ELSIF pi_gty_type IS NOT NULL
  THEN
    OPEN retval
     FOR
      SELECT *
        FROM NM_NW_AD_TYPES
       WHERE nad_nt_type = pi_nt_type
         AND nad_gty_type = pi_gty_type
         AND nad_primary_ad = 'N'
       ORDER BY nad_display_order;
  END IF;

  po_results := retval;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      po_results := retval;
   WHEN OTHERS THEN
      RAISE;
END get_non_prim_nadt_rc;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_datum_with_prim_ad
            ( pi_rec_ne     IN nm_elements%ROWTYPE
            , pi_rec_iit    IN nm_inv_items%ROWTYPE )
IS

   l_rec_ne    NM_ELEMENTS%ROWTYPE  := pi_rec_ne;
   l_rec_iit   NM_INV_ITEMS%ROWTYPE := pi_rec_iit;
   l_rec_ity   NM_INV_TYPES%ROWTYPE;
   l_rec_nadt  NM_NW_AD_TYPES%ROWTYPE;
   l_rec_nadl  NM_NW_AD_LINK_ALL%ROWTYPE;
   l_tmp_iit   NM_INV_ITEMS.iit_ne_id%TYPE;

BEGIN
--
   Nm_Debug.proc_start(g_package_name,'create_datum_with_prim_ad');
--

  --create group
   Nm3net.insert_any_element(l_rec_ne);

   -- Create associated inventory atts if present
   IF l_rec_iit.iit_admin_unit IS NOT NULL THEN

      -- Get inventory type columns for inv type associated with group type
      --nm_debug.debug('create_any_group - > get inv type assoc with gty');
      -- FOR A DATUM ONLY
      l_rec_nadt := Nm3nwad.get_prim_nadt
                         ( pi_nt_type =>  l_rec_ne.ne_nt_type );

      -- Carry on if inv type found
      -- nm_debug.debug('create_any_group - > check for inv type');
      IF l_rec_nadt.nad_inv_type IS NOT NULL
       THEN
        l_rec_iit.iit_inv_type := l_rec_nadt.nad_inv_type;

     -- Initialise server
     -- nm_debug.debug('create_any_group - > > initialise server global');
        Nm3nwad.iit_rec_init( pi_inv_type   => l_rec_iit.iit_inv_type
                            , pi_admin_unit => l_rec_iit.iit_admin_unit );

        Nm3nwad.g_iit_rec := l_rec_iit;

        -- Server inserts inv item
        -- nm_debug.debug('create_any_group - > Insert Inv Item');
        l_tmp_iit := Nm3nwad.iit_rec_insert;

        -- Use a record type based on NM_NW_AD_LINK
        l_rec_nadl.nad_id          := l_rec_nadt.nad_id;
        l_rec_nadl.nad_start_date  := l_rec_ne.ne_start_date;
        l_rec_nadl.nad_ne_id       := l_rec_ne.ne_id;
        l_rec_nadl.nad_iit_ne_id   := l_tmp_iit;

        -- Create group inv link
        -- nm_debug.debug('create_any_group - > Create inv-group link');
        Nm3nwad.ins_nadl(l_rec_nadl);

      ELSE
        Nm_Debug.DEBUG('Inv type invalid');
        Hig.raise_ner
          ( pi_appl               => Nm3type.c_net
          , pi_id                 => 379
          , pi_supplementary_info => ' No Asset Type is defined as Primary AD for '
                                     ||l_rec_ne.ne_nt_type );

      END IF;

   END IF;
--
   Nm_Debug.proc_end(g_package_name,'create_datum_with_prim_ad');
--
EXCEPTION
  WHEN OTHERS
  THEN RAISE;
END create_datum_with_prim_ad;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_group_with_prim_ad
            ( pi_rec_ne     IN nm_elements%ROWTYPE
            , pi_rec_iit    IN nm_inv_items%ROWTYPE
            , pi_tab_nm     IN Nm3type.tab_number)
IS

TYPE tab_nm
  IS TABLE OF NM_MEMBERS%ROWTYPE
     INDEX BY BINARY_INTEGER;

   l_tab_nm    tab_nm;
   l_rec_ne    NM_ELEMENTS%ROWTYPE  := pi_rec_ne;
   l_rec_iit   NM_INV_ITEMS%ROWTYPE := pi_rec_iit;
   l_rec_ity   NM_INV_TYPES%ROWTYPE;
   l_rec_nm    NM_MEMBERS%ROWTYPE;
   l_rec_nadt  NM_NW_AD_TYPES%ROWTYPE;
   l_rec_nadl  NM_NW_AD_LINK_ALL%ROWTYPE;
   l_tmp_iit   NM_INV_ITEMS.iit_ne_id%TYPE;

   nodes_needed          CONSTANT BOOLEAN :=
                         Nm3get.get_nt(pi_nt_type => l_rec_ne.ne_nt_type).nt_node_type IS NOT NULL;

   nodes_not_provided    CONSTANT BOOLEAN := pi_rec_ne.ne_no_start IS NULL AND
                                             pi_rec_ne.ne_no_start IS NULL;

BEGIN

   Nm_Debug.proc_start(g_package_name,'create_group_with_prim_ad');

   -- See if group needs nodes, if so work out start and end nodes for element
   -- from membership if not provided
   IF nodes_needed
   AND nodes_not_provided
   AND pi_tab_nm.COUNT > 0
    THEN
      --nm_debug.debug('Assigning start node');
      l_rec_ne.ne_no_start := Nm3net.get_start_node(pi_tab_nm(pi_tab_nm.FIRST));

      --nm_debug.debug('Assigning end node');
      l_rec_ne.ne_no_end   := Nm3net.get_end_node(pi_tab_nm(pi_tab_nm.LAST));

   END IF;

  --create group
   Nm3net.insert_any_element(l_rec_ne);

   -- Create associated inventory atts if present
   IF l_rec_iit.iit_admin_unit IS NOT NULL THEN

      -- Get inventory type columns for inv type associated with group type
      --nm_debug.debug('create_any_group - > get inv type assoc with gty');
      -- FOR A GROUP TYPE ONLY
      l_rec_nadt := Nm3nwad.get_prim_nadt
                         ( pi_nt_type =>  l_rec_ne.ne_nt_type
                         , pi_gty_type => l_rec_ne.ne_gty_group_type);

      -- Carry on if inv type found
      -- nm_debug.debug('create_any_group - > check for inv type');
      IF l_rec_nadt.nad_inv_type IS NOT NULL
       THEN

        l_rec_iit.iit_inv_type := l_rec_nadt.nad_inv_type;

     -- Initialise server
     -- nm_debug.debug('create_any_group - > > initialise server global');
        Nm3nwad.iit_rec_init( pi_inv_type   => l_rec_iit.iit_inv_type
                            , pi_admin_unit => l_rec_iit.iit_admin_unit );

        Nm3nwad.g_iit_rec := l_rec_iit;

        -- Server inserts inv item
        -- nm_debug.debug('create_any_group - > Insert Inv Item');
        l_tmp_iit := Nm3nwad.iit_rec_insert;

        -- Use a record type based on NM_NW_AD_LINK
        l_rec_nadl.nad_id          := l_rec_nadt.nad_id;
        l_rec_nadl.nad_start_date  := l_rec_ne.ne_start_date;
        l_rec_nadl.nad_ne_id       := l_rec_ne.ne_id;
        l_rec_nadl.nad_iit_ne_id   := l_tmp_iit;

        -- Create group inv link
        -- nm_debug.debug('create_any_group - > Create inv-group link');
        Nm3nwad.ins_nadl(l_rec_nadl);

      ELSE
        Nm_Debug.DEBUG('Inv type invalid');
        Hig.raise_ner
          ( pi_appl               => Nm3type.c_net
          , pi_id                 => 379
          , pi_supplementary_info => ' No Asset Type is defined as Primary AD for '
                                     ||l_rec_ne.ne_nt_type );
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
         l_rec_nm.nm_end_mp        := Nm3net.Get_Ne_Length(pi_tab_nm(i));
         l_rec_nm.nm_cardinality   := 1;
         l_rec_nm.nm_admin_unit    := Nm3get.get_ne(pi_ne_id => pi_tab_nm(i)).ne_admin_unit;

         Nm3ins.ins_nm ( l_rec_nm );

      END LOOP;
   END IF;

   -- resequence the route to set contectivity
   IF nodes_needed THEN
      Nm3rsc.reseq_route(l_rec_ne.ne_id);
   END IF;

   Nm_Debug.proc_end(g_package_name,'create_group_with_prim_ad');

EXCEPTION
   WHEN OTHERS THEN RAISE;
END create_group_with_prim_ad;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_datum_with_non_prim_ad
            ( pi_rec_ne     IN nm_elements%ROWTYPE
            , pi_rec_iit    IN nm_inv_items%ROWTYPE)
IS
  l_tab_nadt  tab_nadt;
  l_rec_ne    nm_elements%ROWTYPE         := pi_rec_ne;
  l_rec_iit   nm_inv_items%ROWTYPE        := pi_rec_iit;
  l_found     BOOLEAN                     := FALSE;
  l_tmp_iit   nm_inv_items.iit_ne_id%TYPE;
  l_rec_nadl  NM_NW_AD_LINK_ALL%ROWTYPE;

BEGIN

-- Create associated inventory atts if present
  IF l_rec_iit.iit_admin_unit IS NULL
    THEN
    RAISE_APPLICATION_ERROR (-20502, 'Error with Non Primary AD Attribute values - Admin Unit must be set');
  ELSE
    -- Check to see if supplied Element has non-primary AD
    BEGIN
      SELECT *
        BULK COLLECT INTO l_tab_nadt
        FROM NM_NW_AD_TYPES
       WHERE nad_nt_type = l_rec_ne.ne_nt_type
         AND nad_gty_type IS NULL
         AND nad_primary_ad = 'N';
    EXCEPTION
      WHEN NO_DATA_FOUND
        THEN NULL;
      WHEN OTHERS
        THEN RAISE;
    END;

    IF l_tab_nadt.COUNT = 0
    THEN
      -- No non-primary ad set up - so raise error
      RAISE_APPLICATION_ERROR (-20500, 'No Non Primary AD defined for '
                                    ||l_rec_ne.ne_nt_type );
    ELSE

      FOR i IN 1..l_tab_nadt.COUNT
      LOOP
        IF l_rec_iit.iit_inv_type = l_tab_nadt(i).nad_inv_type
        THEN
           l_found                 := TRUE;
           l_rec_nadl.nad_id       := l_tab_nadt(i).nad_id;
        END IF;
      END LOOP;

      IF NOT l_found
          OR l_rec_nadl.nad_id IS NULL
        THEN
        RAISE_APPLICATION_ERROR (-20501, 'Error occurred while validating non primary AD');
      ELSE

        IF l_rec_iit.iit_start_date IS NULL
          THEN l_rec_iit.iit_start_date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
        END IF;

     -- Initialise server
        Nm3nwad.iit_rec_init( pi_inv_type   => l_rec_iit.iit_inv_type
                            , pi_admin_unit => l_rec_iit.iit_admin_unit );

        Nm3nwad.g_iit_rec := l_rec_iit;

        -- Server inserts inv item
        l_tmp_iit := Nm3nwad.iit_rec_insert;

        -- Use a record type based on NM_NW_AD_LINK

        --(Already set above it loop)
        --l_rec_nadl.nad_id          := l_rec_nadt.nad_id;

        l_rec_nadl.nad_start_date  := l_rec_ne.ne_start_date;
        l_rec_nadl.nad_ne_id       := l_rec_ne.ne_id;
        l_rec_nadl.nad_iit_ne_id   := l_tmp_iit;

        -- Create group inv link
        -- nm_debug.debug('Create NADL record');
        Nm3nwad.ins_nadl(l_rec_nadl);

      END IF;

    END IF;

  END IF;

EXCEPTION
  WHEN OTHERS
  THEN
    l_found  := FALSE;
    RAISE;
END append_datum_with_non_prim_ad;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_group_with_non_prim_ad
            ( pi_rec_ne     IN nm_elements%ROWTYPE
            , pi_rec_iit    IN nm_inv_items%ROWTYPE)
IS
--
  l_tab_nadt  tab_nadt;
  l_rec_ne    nm_elements%ROWTYPE         := pi_rec_ne;
  l_rec_iit   nm_inv_items%ROWTYPE        := pi_rec_iit;
  l_found     BOOLEAN                     := FALSE;
  l_tmp_iit   nm_inv_items.iit_ne_id%TYPE;
  l_rec_nadl  NM_NW_AD_LINK_ALL%ROWTYPE;
--
BEGIN
--

-- Create associated inventory atts if present
  IF l_rec_iit.iit_admin_unit IS NULL
    THEN
    RAISE_APPLICATION_ERROR (-20502, 'Error with Non Primary AD Attribute values - Admin Unit must be set');
  ELSE
    -- Check to see if supplied Element has non-primary AD
    BEGIN
      SELECT *
        BULK COLLECT INTO l_tab_nadt
        FROM NM_NW_AD_TYPES
       WHERE nad_nt_type  = l_rec_ne.ne_nt_type
         AND nad_gty_type = l_rec_ne.ne_gty_group_type
         AND nad_primary_ad = 'N';
    EXCEPTION
      WHEN NO_DATA_FOUND
        THEN NULL;
      WHEN OTHERS
        THEN RAISE;
    END;

    IF l_tab_nadt.COUNT = 0
    THEN
      -- No non-primary ad set up - so raise error
      RAISE_APPLICATION_ERROR (-20500, 'No Non Primary AD defined for '
                                    ||l_rec_ne.ne_nt_type||' - '||l_rec_ne.ne_gty_group_type);
    ELSE

      FOR i IN 1..l_tab_nadt.COUNT
      LOOP
        IF l_rec_iit.iit_inv_type = l_tab_nadt(i).nad_inv_type
        THEN
           l_found                 := TRUE;
           l_rec_nadl.nad_id       := l_tab_nadt(i).nad_id;
        END IF;
      END LOOP;

      IF NOT l_found
          OR l_rec_nadl.nad_id IS NULL
        THEN
        RAISE_APPLICATION_ERROR (-20501, 'Error occurred while validating non primary AD');
      ELSE

        IF l_rec_iit.iit_start_date IS NULL
          THEN l_rec_iit.iit_start_date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
        END IF;

     -- Initialise server
        Nm3nwad.iit_rec_init( pi_inv_type   => l_rec_iit.iit_inv_type
                            , pi_admin_unit => l_rec_iit.iit_admin_unit );

        Nm3nwad.g_iit_rec := l_rec_iit;

        -- Server inserts inv item
        l_tmp_iit := Nm3nwad.iit_rec_insert;

        -- Use a record type based on NM_NW_AD_LINK

        --(Already set above it loop)
        --l_rec_nadl.nad_id          := l_rec_nadt.nad_id;

        l_rec_nadl.nad_start_date  := l_rec_ne.ne_start_date;
        l_rec_nadl.nad_ne_id       := l_rec_ne.ne_id;
        l_rec_nadl.nad_iit_ne_id   := l_tmp_iit;

        -- Create group inv link
        -- nm_debug.debug('Create NADL record');
        Nm3nwad.ins_nadl(l_rec_nadl);

      END IF;

    END IF;

  END IF;

EXCEPTION
  WHEN OTHERS
  THEN
    l_found  := FALSE;
    RAISE;
END append_group_with_non_prim_ad;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_inv_ad_to_ne
            ( pi_ne_id   IN     nm_elements.ne_id%TYPE
            , pi_rec_iit IN OUT nm_inv_items%ROWTYPE )
IS
  l_ne_id                   nm_elements.ne_id%TYPE          := pi_ne_id;
  l_rec_ne                  nm_elements%ROWTYPE;
  l_rec_iit                 nm_inv_items%ROWTYPE            := pi_rec_iit;
  l_rec_nadl                NM_NW_AD_LINK_ALL%ROWTYPE;
  l_rec_nadt                NM_NW_AD_TYPES%ROWTYPE;
  l_tab_np_nadt             tab_nadt;
  l_tmp_iit_rec             nm_inv_items%ROWTYPE;
  b_is_gty                  BOOLEAN                         := FALSE;
  b_is_primary              BOOLEAN                         := FALSE;
  b_np_found                BOOLEAN                         := FALSE;
--
BEGIN
--
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'add_inv_ad_to_ne');
--
  l_rec_ne := Nm3get.get_ne (pi_ne_id => pi_ne_id);
--
  IF l_rec_ne.ne_id IS NULL
  THEN
    RAISE_APPLICATION_ERROR (-20602, 'Element does not exist '||pi_ne_id);
  END IF;

  b_is_gty    := l_rec_ne.ne_gty_group_type IS NOT NULL;

  IF NOT b_is_gty
  THEN
    -- Get primary AD type
    l_rec_nadt := get_prim_nadt
                    ( pi_nt_type  => l_rec_ne.ne_nt_type );

    -- Get non primary AD types
    BEGIN
      SELECT *
      BULK COLLECT INTO l_tab_np_nadt
      FROM NM_NW_AD_TYPES
      WHERE NAD_NT_TYPE = l_rec_ne.ne_nt_type
        AND NAD_GTY_TYPE IS NULL;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
      WHEN OTHERS        THEN RAISE;
    END;

  ELSE
    l_rec_nadt := get_prim_nadt
                    ( pi_nt_type  => l_rec_ne.ne_nt_type
                    , pi_gty_type => l_rec_ne.ne_gty_group_type);
    -- Get non primary AD types
    BEGIN
      SELECT *
      BULK COLLECT INTO l_tab_np_nadt
      FROM NM_NW_AD_TYPES
      WHERE NAD_NT_TYPE  = l_rec_ne.ne_nt_type
        AND NAD_GTY_TYPE = l_rec_ne.ne_gty_group_type;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
      WHEN OTHERS        THEN RAISE;
    END;
  END IF;

  IF l_rec_nadt.nad_inv_type = l_rec_iit.iit_inv_type
  THEN
    l_rec_nadl.nad_id := l_rec_nadt.nad_id;
    b_is_primary := TRUE;
  END IF;

  IF  NOT b_is_primary
  AND l_tab_np_nadt.COUNT > 0
  THEN
    FOR i IN 1..l_tab_np_nadt.COUNT
    LOOP
      IF l_rec_iit.iit_inv_type = l_tab_np_nadt(i).nad_inv_type
      THEN
         b_np_found         := TRUE;
         l_rec_nadl.nad_id  := l_tab_np_nadt(i).nad_id;
      END IF;
    END LOOP;
  ELSIF l_rec_nadl.nad_id IS NULL
  THEN
    RAISE_APPLICATION_ERROR (-20503,'Asset Type '||l_rec_iit.iit_inv_type
    ||' is invalid for both Primary and Non Primary AD');
  END IF;

  IF NOT b_np_found
      AND l_rec_nadl.nad_id IS NULL
  THEN
    RAISE_APPLICATION_ERROR (-20501, 'Error occurred while validating AD type');
  ELSE

    IF l_rec_iit.iit_start_date IS NULL
      THEN l_rec_iit.iit_start_date := l_rec_ne.ne_start_date; 
    END IF;

    IF l_rec_iit.iit_admin_unit IS NULL
    THEN
      RAISE_APPLICATION_ERROR (-20502
       , 'Error with Non Primary AD Attribute values - Admin Unit must be set');
    END IF;

  -- Initialise server
    Nm3nwad.iit_rec_init( pi_inv_type   => l_rec_iit.iit_inv_type
                        , pi_admin_unit => l_rec_iit.iit_admin_unit );

    Nm3nwad.g_iit_rec := l_rec_iit;

    -- Server inserts inv item
    l_tmp_iit_rec := Nm3nwad.iit_rec_insert_row;

  -- set nad id above
   -- l_rec_nadl.nad_id := l_rec_nadt.nad_id;
    l_rec_nadl.nad_ne_id := l_ne_id;
    l_rec_nadl.nad_iit_ne_id  := l_tmp_iit_rec.iit_ne_id;
    l_rec_nadl.nad_start_date := greatest(l_rec_ne.ne_start_date, l_rec_iit.iit_start_date);

    Nm3nwad.ins_nadl(l_rec_nadl);

    pi_rec_iit := l_tmp_iit_rec;

  END IF;
--
  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'add_inv_ad_to_ne');
--
END add_inv_ad_to_ne;
--
-----------------------------------------------------------------------------
--
PROCEDURE copy_ad_to_another_ne(pi_nad_inv_type       IN nm_nw_ad_types.nad_inv_type%TYPE
                               ,pi_ne_id_from         IN nm_elements_all.ne_id%TYPE
                               ,pi_ne_id_to           IN nm_elements_all.ne_id%TYPE
							   ,pi_end_date_copy      IN BOOLEAN DEFAULT FALSE) IS

 CURSOR c1 IS
 SELECT  nad_id              nad_id
        ,nad_start_date      nad_start_date
        ,nad_iit_ne_id       iit_ne_id
        ,iit_start_date      iit_start_date
 FROM   nm_nw_ad_link
       ,nm_inv_items
 WHERE  nad_ne_id    = pi_ne_id_from
 AND    iit_ne_id    = nad_iit_ne_id
 AND    iit_inv_type = pi_nad_inv_type;

 l_iit_ne_id_new nm_inv_items_all.iit_ne_id%TYPE;
 l_nadl_rec      nm_nw_ad_link%ROWTYPE;


BEGIN


--
-- For each linked inventory item of the given type
-- create a copy of the inventory item
-- create the ad link to tie it to the ne_id_to
--
 FOR i IN c1 LOOP

   nm3inv.copy_inv(pi_iit_ne_id      => i.iit_ne_id
                  ,pi_iit_start_date => i.iit_start_date
				  ,po_iit_ne_id      => l_iit_ne_id_new);

   l_nadl_rec.nad_id         := i.nad_id;
   l_nadl_rec.nad_iit_ne_id  := l_iit_ne_id_new;
   l_nadl_rec.nad_ne_id      := pi_ne_id_to;
   l_nadl_rec.nad_start_date := i.nad_start_date;

   IF pi_end_date_copy THEN
     l_nadl_rec.nad_end_date   :=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
   ELSE
     l_nadl_rec.nad_end_date   :=  Null;
   END IF;

   ins_nadl( pi_nadl_rec => l_nadl_rec);

   IF pi_end_date_copy THEN
      UPDATE nm_inv_items_all
	  SET    iit_end_date = To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
	  WHERE  iit_ne_id = l_iit_ne_id_new;
   END IF;



 END LOOP;

END copy_ad_to_another_ne;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nadt_for_ne(pi_ne_id         IN nm_elements_all.ne_id%TYPE
                        ,pi_nad_inv_type  IN nm_nw_ad_types.nad_inv_type%TYPE) RETURN nm_nw_ad_types%ROWTYPE IS

   l_rec_nadt NM_NW_AD_TYPES%ROWTYPE;

BEGIN

   SELECT typ.*
     INTO l_rec_nadt
     FROM nm_elements_all ne
         ,nm_nw_ad_types typ
    WHERE ne_id = pi_ne_id
 	  AND nad_nt_type  = ne_nt_type
      AND nad_gty_type = ne_gty_group_type
	  AND nad_inv_type = pi_nad_inv_type;

   RETURN l_rec_nadt;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN NULL;
   WHEN OTHERS THEN
      RAISE;

END get_nadt_for_ne;
--
-----------------------------------------------------------------------------
--
PROCEDURE lock_ad(pi_nad_iit_ne_id IN nm_nw_ad_link_all.nad_iit_ne_id%TYPE
                 ) IS

   CURSOR cs_iit IS
   SELECT /*+ INDEX (iit INV_ITEMS_ALL_PK) */ *
    FROM  nm_inv_items_all iit
   WHERE  iit.iit_ne_id = pi_nad_iit_ne_id
   FOR UPDATE NOWAIT;


--
   ex_update_not_permitted EXCEPTION;
   ex_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (ex_record_locked,-54);

--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_ad');
--
   FOR v_recs IN cs_iit LOOP
     IF v_recs.iit_end_date IS NOT NULL THEN
	    RAISE ex_update_not_permitted;
     END IF;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'lock_ad');
--
EXCEPTION
--
   WHEN ex_update_not_permitted
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 85);  -- update not allowed

   WHEN ex_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33); -- record is locked by another user


END lock_ad;
--
-----------------------------------------------------------------------------
--
FUNCTION ad_is_valid_on_new_ne(pi_old_nad_id            IN nm_nw_ad_types.nad_id%TYPE
                              ,pi_new_ne_nt_type        IN nm_elements.ne_nt_type%TYPE
                              ,pi_new_ne_gty_group_type IN nm_elements.ne_gty_group_type%TYPE
      						  ,po_new_nad_id            OUT nm_nw_ad_types.nad_id%TYPE) RETURN BOOLEAN IS
  CURSOR c1 IS
  select nadt2.nad_id
  from nm_nw_ad_types nadt1
      ,nm_nw_ad_types nadt2
  where nadt1.nad_id = pi_old_nad_id
  and  nadt2.nad_nt_type = pi_new_ne_nt_type
  and  NVL(nadt2.nad_gty_type,'-1') = NVL(pi_new_ne_gty_group_type,'-1')
  and  nadt2.nad_inv_type = nadt1.nad_inv_type;


BEGIN

 OPEN c1;
 FETCH c1 INTO po_new_nad_id;
 CLOSE c1;

 RETURN(po_new_nad_id IS NOT NULL);


END ad_is_valid_on_new_ne;
--
-----------------------------------------------------------------------------
--
FUNCTION primary_ad_link_start_date(pi_nad_ne_id      IN nm_nw_ad_link_all.nad_ne_id%TYPE) RETURN nm_nw_ad_link_all.nad_start_date%TYPE IS

BEGIN

 RETURN(nm3get.get_ne_all(pi_ne_id => pi_nad_ne_id).ne_start_date);

END primary_ad_link_start_date;
--
-----------------------------------------------------------------------------
--
-- MJA add 31-Aug-07
-- Speaks for itself.  If true then bypass triggers.
-- To be called in NM_NW_AD_LINK_AS, NM_NW_AD_LINK_BR triggers to see if
--  bypass required
--
FUNCTION bypass_nw_ad_link_all
  RETURN BOOLEAN
IS
  --
Begin
  --
  Return nvl(g_bypass_nw_ad_link_all, FALSE);
  --
End bypass_nw_ad_link_all;
--
----------------------------------------------------------------------------------
--
-- MJA add 31-Aug-07
-- Sets global g_bypass_nw_ad_link_all true or false.
--
PROCEDURE bypass_nw_ad_link_all ( pi_mode IN BOOLEAN )
IS
  --
Begin
  --
  g_bypass_nw_ad_link_all := pi_mode;
  --
End bypass_nw_ad_link_all;
--
-----------------------------------------------------------------------------
--
END Nm3nwad;
/
