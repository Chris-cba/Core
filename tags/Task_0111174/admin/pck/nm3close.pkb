CREATE OR REPLACE PACKAGE BODY nm3close AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3close.pkb-arc   2.10   Jul 05 2011 14:42:48   Chris.Strettle  $
--       Module Name      : $Workfile:   nm3close.pkb  $
--       Date into PVCS   : $Date:   Jul 05 2011 14:42:48  $
--       Date fetched Out : $Modtime:   Jul 05 2011 14:38:46  $
--       PVCS Version     : $Revision:   2.10  $
--
--
--   Author : I Turnbull
--
--   nm3close body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2000
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '"$Revision:   2.10  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  VARCHAR2(30)   := 'nm3close';
--
   TYPE tab_char_1 IS TABLE OF VARCHAR2(1) INDEX BY BINARY_INTEGER;
   g_curr_hierarchy_index               PLS_INTEGER;
   g_last_child_index                   PLS_INTEGER;
   g_tab_rte_memb_depth                 nm3type.tab_number;
   g_tab_rte_memb_label                 nm3type.tab_varchar30;
   g_tab_rte_memb_child_ne_type         nm3type.tab_varchar4;
   g_tab_rte_memb_child_ne_id           nm3type.tab_number;
   g_tab_rte_memb_end_date_flag         nm3type.tab_varchar4;
--
-----------------------------------------------------------------------------
--
PROCEDURE gis_multi_element_close ( pi_gdo_session_id gis_data_objects.gdo_session_id%TYPE
                                   ,pi_effective_date DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY') );
--
-----------------------------------------------------------------------------
--
PROCEDURE route_close ( pi_route_id            NM_ELEMENTS.ne_id%TYPE
                       ,pi_effective_date      DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                       ,pi_end_date_all        VARCHAR2 DEFAULT 'N'
                       ,pi_end_date_datums     VARCHAR2 DEFAULT 'N'
                      );
--
-----------------------------------------------------------------------------
--
PROCEDURE close_temp_extent ( pi_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                             ,pi_effective_date DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                            );
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
PROCEDURE lock_parent(p_ne_id NM_ELEMENTS.ne_id%TYPE) IS
BEGIN
  nm_debug.proc_start(g_package_name , 'lock_parent');
  nm3lock.lock_element_and_members(p_ne_id );
  nm_debug.proc_end(g_package_name , 'lock_parent');
END lock_parent;
--
-----------------------------------------------------------------------------
--
PROCEDURE insert_nm_element_history ( p_ne_id          IN NM_ELEMENTS.ne_id%TYPE
                                    , p_effective_date IN DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                    , p_neh_descr      IN nm_element_history.neh_descr%TYPE DEFAULT NULL --CWS 0108990 12/03/2010
                                    )
IS
--
  l_rec_neh NM_ELEMENT_HISTORY%ROWTYPE;
--
BEGIN
  nm_debug.proc_start(g_package_name , 'insert_nm_element_history');
--
-- CWS 
-- Insert statement replaced with call to a procedure
--
  l_rec_neh.neh_id             := nm3seq.next_neh_id_seq;
  l_rec_neh.neh_ne_id_old      := p_ne_id;
  l_rec_neh.neh_ne_id_new      := p_ne_id;
  l_rec_neh.neh_operation      := 'C';
  l_rec_neh.neh_effective_date := p_effective_date;
  l_rec_neh.neh_actioned_date  := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
  l_rec_neh.neh_actioned_by    := Sys_Context('NM3_SECURITY_CTX','USERNAME');
  l_rec_neh.neh_descr          := p_neh_descr; --CWS 0108990 12/03/2010
--
  nm3nw_edit.ins_neh(l_rec_neh); --CWS 0108990 12/03/2010
--
  nm_debug.proc_end(g_package_name , 'insert_nm_element_history');
--
END insert_nm_element_history;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_contiguous_inv_type ( p_nm_ne_id_of NM_MEMBERS.nm_ne_id_of%TYPE )
IS
-- get ne_id of any inv that is contiguous on an element
CURSOR c1 ( c_nm_ne_id_of NM_MEMBERS.nm_ne_id_of%TYPE ) IS
   SELECT nm_ne_id_in
   FROM NM_MEMBERS
   WHERE nm_ne_id_of = c_nm_ne_id_of
   AND nm_type = 'I'
   AND nm_obj_type IN ( SELECT nit_inv_type
                        FROM NM_INV_TYPES
                        WHERE nit_contiguous = 'Y' );

-- get the other elements that inv is over
 CURSOR c2 ( c_nm_ne_id_in NM_MEMBERS.nm_ne_id_in%TYPE ) IS
   SELECT nm_ne_id_of
   FROM NM_MEMBERS
   WHERE nm_ne_id_in = c_nm_ne_id_in;

BEGIN
 nm_debug.proc_start(g_package_name , 'check_contiguous_inv_type');
 FOR c1rec IN c1( p_nm_ne_id_of ) LOOP
     FOR c2rec IN c2( c1rec.nm_ne_id_in ) LOOP
        IF c2rec.nm_ne_id_of != p_nm_ne_id_of THEN
           RAISE_APPLICATION_ERROR( -20100, 'Contiguous inv_item over more than current element');
        END IF;
     END LOOP;
 END LOOP;
 nm_debug.proc_end(g_package_name , 'check_contiguous_inv_type');
END check_contiguous_inv_type;
--
-----------------------------------------------------------------------------
--
PROCEDURE  check_replaceable_inv_type( p_nm_ne_id_of NM_MEMBERS.nm_ne_id_of%TYPE )

IS
   -- Are there any inv items on the element that have the replaceable flag set to 'N' ?
   CURSOR c1 IS
      SELECT 1
      FROM NM_INV_TYPES_ALL
      WHERE nit_inv_type IN (SELECT DISTINCT nm_obj_type
                             FROM NM_MEMBERS
                             WHERE nm_ne_id_of = p_nm_ne_id_of
                             AND nm_type = 'I')
      AND nit_replaceable = 'N';
   dummy NUMBER(1) := 0;

BEGIN
   nm_debug.proc_start(g_package_name , 'check_replaceable_inv_type');
   OPEN c1;
   FETCH c1 INTO dummy;
   IF c1%FOUND THEN
      RAISE_APPLICATION_ERROR( -20110, 'Unable to close Element it has un-replaceable inventory');
   END IF;
   nm_debug.proc_end(g_package_name , 'check_replaceable_inv_type');
END check_replaceable_inv_type;
--
-----------------------------------------------------------------------------
--
FUNCTION  inv_type_end_loc_only( p_nit_inv_type NM_INV_TYPES.nit_inv_type%TYPE)
RETURN BOOLEAN
IS
   -- Check if an inv_item on the element can onlt have its location
   -- closed, leaving the inv itemm open.
   CURSOR c1 IS SELECT 1
                FROM NM_INV_TYPES
                WHERE nit_inv_type = p_nit_inv_type
                  AND nit_end_loc_only = 'Y';

   dummy NUMBER(1) := 0;
   rtrn BOOLEAN := FALSE;
BEGIN
   nm_debug.proc_start(g_package_name , 'inv_type_end_loc_only');
   OPEN c1;
   FETCH c1 INTO dummy;
   rtrn := c1%FOUND;
   CLOSE c1;
   RETURN rtrn;
   nm_debug.proc_end(g_package_name , 'inv_type_end_loc_only');
END inv_type_end_loc_only;
----
-------------------------------------------------------------------------------
----
PROCEDURE close_groups ( p_ne_id NM_ELEMENTS.ne_id%TYPE
                        ,p_effective_date DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                       )
IS

  TYPE l_rec_nmh_tab IS TABLE OF nm_member_history%rowtype INDEX BY BINARY_INTEGER;
  l_rec_nmh       l_rec_nmh_tab;

BEGIN
    nm_debug.proc_start(g_package_name , 'close_groups');

    UPDATE NM_MEMBERS
    SET nm_end_date = TRUNC(p_effective_date)
    WHERE nm_type = 'G'
    AND nm_ne_id_of = p_ne_id
    AND nm_end_date IS NULL
    RETURNING
      NM_NE_ID_IN
    , NM_NE_ID_OF
    , NM_NE_ID_OF
    , NM_BEGIN_MP
    , NM_START_DATE
    , NM_TYPE
    , NM_OBJ_TYPE
    , NULL
    BULK COLLECT INTO
    l_rec_nmh;

    FOR i IN 1.. l_rec_nmh.count LOOP
      nm3ins.ins_nmh(p_rec_nmh => l_rec_nmh(i));
    END LOOP;

    nm_debug.proc_end(g_package_name , 'close_groups');

END close_groups;
--
-----------------------------------------------------------------------------
--
PROCEDURE close_other_products ( p_ne_id NM_ELEMENTS.ne_id%TYPE
                                ,p_effective_date NM_ELEMENTS.ne_start_date%TYPE
                                ,p_from_extent VARCHAR2 DEFAULT 'N'
                                )
IS
BEGIN
   nm_debug.proc_start(g_package_name , 'close_other_products');
   -- Check if accidents is installed and do replace accidents
   IF hig.is_product_licensed( nm3type.c_acc ) THEN
      IF p_from_extent = 'N'
       THEN
         EXECUTE IMMEDIATE 'BEGIN'
                ||CHR(10)||'   accclose.do_close (:p_ne_id'
                ||CHR(10)||'                     ,:p_effective_date'
                ||CHR(10)||'                     );'
                ||CHR(10)||'END;'
            USING IN p_ne_id
                    ,p_effective_date;
      ELSE
         EXECUTE IMMEDIATE 'BEGIN'
                ||CHR(10)||'   accclose.do_close_from_temp_extent (:p_ne_id'
                ||CHR(10)||'                                      ,:p_effective_date'
                ||CHR(10)||'                                      );'
                ||CHR(10)||'END;'
            USING IN p_ne_id
                    ,p_effective_date;
      END IF;
   END IF;
 -- Check if structures is installed and do replace structures
   IF hig.is_product_licensed( nm3type.c_str ) THEN
     -- do str replace
         EXECUTE IMMEDIATE 'BEGIN'
                ||CHR(10)||'   strclose.close_data (:p_ne_id'
                ||CHR(10)||'                       ,:p_effective_date'
                ||CHR(10)||'                       );'
                ||CHR(10)||'END;'
         USING IN  p_ne_id
                  ,p_effective_date;
   END IF;
   IF hig.is_product_licensed( nm3type.c_mai ) THEN
    -- do MAI replace
         EXECUTE IMMEDIATE 'BEGIN'
                ||CHR(10)||'   maiclose.close_data (p_id             => :p_ne_id'
                ||CHR(10)||'                       ,p_effective_date => :p_effective_date'
                ||CHR(10)||'                       );'
                ||CHR(10)||'END;'
         USING IN  p_ne_id
                  ,p_effective_date;
   END IF;
   
   IF hig.is_product_licensed( nm3type.c_stp ) THEN
     -- do str replace
         EXECUTE IMMEDIATE 'BEGIN'
                ||CHR(10)||'   stp_network_ops.do_close(pi_ne_id          => :pi_ne_id'
                ||CHR(10)||'                           ,pi_effective_date => :pi_effective_date'
                ||CHR(10)||'                           );'
                ||CHR(10)||'END;'
         USING IN  p_ne_id
                  ,p_effective_date;
   END IF;

   IF hig.is_product_licensed( nm3type.c_ukp ) THEN
     -- do ukp replace
         EXECUTE IMMEDIATE 'BEGIN'
                ||CHR(10)||'   ukpclose.close(p_rse     => :pi_ne_id'
                ||CHR(10)||'                 ,p_op_date => :pi_effective_date'
                ||CHR(10)||'                 );'
                ||CHR(10)||'END;'
         USING IN  p_ne_id
                  ,p_effective_date;
   END IF;
   
   nm_debug.proc_end(g_package_name , 'close_other_products');
END close_other_products;
--
-----------------------------------------------------------------------------
--
PROCEDURE close_other_products_route( p_ne_id NM_ELEMENTS.ne_id%TYPE
                                          ,p_effective_date NM_ELEMENTS.ne_start_date%TYPE) IS
BEGIN
  -- At present only schemes is affected by a close performed on a route
  -- but here is a procedure ready for when others are affected
  
  IF hig.is_product_licensed( nm3type.c_stp ) THEN
   -- do str replace
    EXECUTE IMMEDIATE 'BEGIN'
           ||CHR(10)||'   stp_network_ops.do_close(pi_ne_id          => :pi_ne_id'
           ||CHR(10)||'                           ,pi_effective_date => :pi_effective_date'
           ||CHR(10)||'                           );'
           ||CHR(10)||'END;'
    USING IN  p_ne_id
             ,p_effective_date;
  END IF;
END close_other_products_route;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE check_other_products 
                    (p_ne_id1            IN nm_elements.ne_id%TYPE
                    ,p_effective_date    IN DATE
                    ,p_errors           OUT NUMBER
                    ,p_err_text         OUT VARCHAR2
                    ) IS

   l_block    VARCHAR2(32767);
BEGIN
--
   nm_debug.proc_start(g_package_name,'check_other_products');
--
   IF hig.is_product_licensed(nm3type.c_str)
    THEN
--
      nm_debug.debug('Check STR before close');
--
      l_block :=            'BEGIN'
                 ||CHR(10)||'    strclose.check_data'
                 ||CHR(10)||'              (p_id             => :p_ne_id1'
                 ||CHR(10)||'              ,p_effective_date => :p_effective_date'
                 ||CHR(10)||'              ,p_errors         => :p_errors'
                 ||CHR(10)||'              ,p_error_string   => :p_error_text'
                 ||CHR(10)||'              );'
                 ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_block
       USING IN p_ne_id1
               ,p_effective_date
        ,IN OUT p_errors
        ,IN OUT p_err_text;
--
      nm_debug.debug('Check STR finished');
--
  END IF;

  -- Check if MM is installed and check for data
   IF hig.is_product_licensed(nm3type.c_mai)
    THEN
--
      nm_debug.debug('Check MAI before close');
--
      l_block :=            'BEGIN'
                 ||CHR(10)||'    maiclose.check_data'
                 ||CHR(10)||'              (p_id             => :p_ne_id1'
                 ||CHR(10)||'              ,p_effective_date => :p_effective_date'
                 ||CHR(10)||'              ,p_errors         => :p_errors'
                 ||CHR(10)||'              ,p_error_string   => :p_err_text'
                 ||CHR(10)||'              );'
                 ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_block
       USING IN p_ne_id1
               ,p_effective_date
        ,IN OUT p_errors
        ,IN OUT p_err_text;
--
    nm_debug.debug('Check MAI finished');
--
  END IF;
--
   nm_debug.proc_end(g_package_name,'check_other_products');
--
END check_other_products;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE do_close(p_ne_id          NM_ELEMENTS.ne_id%TYPE
                  ,p_effective_date DATE DEFAULT  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                  ,p_neh_descr      nm_element_history.neh_descr%TYPE DEFAULT NULL --CWS 0108990 12/03/2010
                  ) IS
   c_xattr_status BOOLEAN := nm3inv_xattr.g_xattr_active;
--
   v_errors                NUMBER;
   v_err_text              VARCHAR2(10000);
--   

--
   PROCEDURE set_for_return IS
   BEGIN
      nm3inv_xattr.g_xattr_active := c_xattr_status;
      nm3merge.set_nw_operation_in_progress(FALSE);
   END set_for_return;
--
BEGIN
   nm_debug.proc_start(g_package_name , 'do_close');
   nm3merge.set_nw_operation_in_progress;
      -- This effective date check stops future dates
      -- *********************
      -- ** Will be removed **
      -- *********************
      IF p_effective_date > TRUNC(SYSDATE) THEN
         RAISE_APPLICATION_ERROR( -20001, 'Future Effective DATE NOT allowed' );
      END IF;


-- NM - Add check here for other products
   check_other_products ( p_ne_id1         => p_ne_id
                         ,p_effective_date => p_effective_date
                         ,p_errors         => v_errors
                         ,p_err_text       => v_err_text
                        );
 
   IF v_err_text IS NOT NULL
    THEN
       hig.raise_ner(pi_appl               => nm3type.c_mai
                    ,pi_id                 => 4
                    ,pi_supplementary_info => v_err_text
                     );
   END IF;
--

      -- Clear out the NM_MEMBER_HISTORY variables
      nm3merge.clear_nmh_variables;
--
   -- Check if user is unrestricted
   -- Can only close elements if user is unrestricted.
   -- user needs access to all network and inv.
   nm3nwval.network_operations_check( nm3nwval.c_close
                                     ,p_ne_id
                                    );
--
      -- lock parent to avoid dual editing on route
      lock_parent( p_ne_id );
--
      -- check if element has any unreplaceable inv types on it
      check_replaceable_inv_type( p_ne_id  );
--
      -- check if element has any contiguous items on it
--
-- removed to allow element to close leaving gaps in inv
--      check_contiguous_inv_type( p_ne_id );
--
      -- close the inv location and inv items on the element
--      close_inv( p_ne_id
--                ,p_effective_date );
----
--      close_groups( p_ne_id
--                   ,p_effective_date );
--
      -- Close all membership records
      nm3inv_xattr.g_xattr_active := FALSE;
      nm3merge.end_date_members (p_nm_ne_id_of_old => p_ne_id
                                ,p_nm_ne_id_of_new => p_ne_id
                                ,p_effective_date  => p_effective_date
                                );
      nm3inv_xattr.g_xattr_active := c_xattr_status;

--
      -- End date any inventory which is not end location only which is left with no location
      DECLARE
         l_inv_to_check nm3type.tab_number;
         l_count        PLS_INTEGER := 0;
      BEGIN
         FOR i IN 1..nm3merge.g_tab_nmh_nm_ne_id_in.COUNT
          LOOP
            IF   nm3merge.g_tab_nmh_nm_type(i) = 'I'
             AND nm3inv.get_inv_type(nm3merge.g_tab_nmh_nm_obj_type(i)).nit_end_loc_only = 'N'
             THEN
               l_count                 := l_inv_to_check.COUNT + 1;
               l_inv_to_check(l_count) := nm3merge.g_tab_nmh_nm_ne_id_in(i);
            END IF;
         END LOOP;
         FORALL i IN 1..l_count
            UPDATE NM_INV_ITEMS
             SET   iit_end_date = p_effective_date
            WHERE  iit_ne_id    = l_inv_to_check(i)
             AND NOT EXISTS (SELECT 1
                              FROM  NM_MEMBERS_ALL
                             WHERE  nm_ne_id_in                         = iit_ne_id
                              AND   NVL(nm_end_date,nm3type.c_big_date) > p_effective_date
                            );
      END;
      --
--
      UPDATE NM_ELEMENTS
      SET ne_end_date = p_effective_date
      WHERE ne_id = p_ne_id;
--
      insert_nm_element_history( p_ne_id
                               , p_effective_date
                               , p_neh_descr --CWS 0108990 12/03/2010
                               );
     -- Insert the stored NM_MEMBER_HISTORY records
     nm3merge.ins_nmh;
      close_other_products ( p_ne_id
                            ,p_effective_date
                            );
     UPDATE nm_nw_ad_link_all
        SET nad_end_date = p_effective_date
      WHERE nad_ne_id = p_ne_id;

    set_for_return;
    nm_debug.proc_end(g_package_name , 'do_close');
--
--EXCEPTION
--
--   WHEN others
--    THEN
--      set_for_return;
--      RAISE;
--
END do_close;
--
-----------------------------------------------------------------------------
--
PROCEDURE gis_close_elements (p_gdo_session_id gis_data_objects.gdo_session_id%TYPE
                             ,p_effective_date DATE DEFAULT  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                             ) IS
--
   CURSOR cs_gdo (c_session_id gis_data_objects.gdo_session_id%TYPE) IS
   SELECT ne_id
         ,nm_seq_no
    FROM  gis_data_objects
         ,NM_ELEMENTS
         ,NM_MEMBERS
   WHERE  gdo_session_id = c_session_id
    AND   gdo_pk_id      = ne_id
    AND   ne_id          = nm_ne_id_of
   ORDER BY nm_seq_no;
--
   l_ne_id_done tab_char_1;
--
BEGIN
--
   nm_debug.proc_start(g_package_name , 'gis_close_elements');
--
   FOR cs_rec IN cs_gdo (p_gdo_session_id)
    LOOP
      IF l_ne_id_done.EXISTS(cs_rec.ne_id)
       THEN
         --  This ne_id has already been done (with a prior nm_seq_no)
         NULL;
      ELSE
         l_ne_id_done(cs_rec.ne_id) := 'Y';
         --
         do_close (cs_rec.ne_id, p_effective_date);
         --
      END IF;
   END LOOP;
--
   nm_debug.proc_end(g_package_name , 'gis_close_elements');
--
END gis_close_elements;
--
-----------------------------------------------------------------------------
--
PROCEDURE multi_element_close ( pi_type             VARCHAR2
                               ,pi_id               NUMBER
                               ,pi_effective_date   DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                               ,pi_close_all        VARCHAR2 DEFAULT 'N'
                               ,pi_end_date_datums  VARCHAR2 DEFAULT 'N'
                              )
IS
--
  v_ne_type nm_elements_all.ne_type%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'Multi_Element_Close');
--
   nm3nwval.network_operations_check( nm3nwval.c_close
                                     ,pi_id
                                    );
--
   -- call the relvant function for the type
   IF pi_type = nm3close.c_gis THEN
     gis_multi_element_close ( pi_id, pi_effective_date );
   ELSIF pi_type = nm3close.c_extent THEN
     close_temp_extent( pi_id, pi_effective_date);
   ELSIF pi_type = nm3close.c_route THEN  -- Group of Groups/Group of Sections
     route_close( pi_route_id        =>   pi_id
                , pi_effective_date  =>   pi_effective_date
                , pi_end_date_all    =>   pi_close_all
                , pi_end_date_datums =>   pi_end_date_datums );
   ELSE
     RAISE_APPLICATION_ERROR(-20001,'Invalid type "'||pi_type||'" passed to nm3close.Multi_Element_Close');
   END IF;
   
   close_other_products_route(pi_id, pi_effective_date);
--
   nm_debug.proc_end(g_package_name,'Multi_Element_Close');
--
END multi_element_close;
--
-----------------------------------------------------------------------------
--
PROCEDURE gis_multi_element_close ( pi_gdo_session_id gis_data_objects.gdo_session_id%TYPE
                                   ,pi_effective_date DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                  )
IS
--
   l_job_id NUMBER := NULL;
--
BEGIN
--
   nm_debug.proc_start(g_package_name , 'gis_multi_element_close');
--
   -- create a temp_extent for the gis_data_objects
    nm3extent.create_temp_ne( pi_source_id => pi_gdo_session_id
                             ,pi_source    => nm3extent.c_gis
                             ,po_job_id    => l_job_id
                            );
--
   -- call the close extent
   multi_element_close( nm3close.c_extent, l_job_id, pi_effective_date );
--
   nm_debug.proc_end(g_package_name , 'gis_multi_element_close');
--
END gis_multi_element_close ;
--
-----------------------------------------------------------------------------
--
FUNCTION is_group_to_be_closed(pi_parent_ne_type      IN nm_elements.ne_type%TYPE
                              ,pi_nti_nw_parent_type  IN nm_type_inclusion.nti_nw_parent_type%TYPE
                              ,pi_nti_nw_child_type   IN nm_type_inclusion.nti_nw_child_type%TYPE
                              ,pi_end_date_all        IN VARCHAR2 DEFAULT 'N') RETURN VARCHAR2 IS

   ex_not_found          EXCEPTION ;
   PRAGMA EXCEPTION_INIT(ex_not_found, -20020);

   l_inclusion     BOOLEAN;
   l_end_date_all  VARCHAR2(1) DEFAULT 'N';
   v_nti_record    nm_type_inclusion%ROWTYPE;

BEGIN

   nm_debug.proc_start(g_package_name,'is_group_to_be_closed');
--
--nm_debug.delete_debug(TRUE);
--nm_debug.debug_on;


    -----------------------------------------------------------
    -- See if the parent/child network types are autoincluded
    -----------------------------------------------------------
    BEGIN
       v_nti_record := nm3get.get_nti (pi_nti_nw_parent_type => pi_nti_nw_parent_type
                                      ,pi_nti_nw_child_type  => pi_nti_nw_child_type
                                      ,pi_raise_not_found    => TRUE
                                      ,pi_not_found_sqlcode  => -20020);
--
       -------------------------------------------------------------------------------------------------
       -- Assumption is that if a record was found we've got to here - so set autoinclusion flag to TRUE
       -------------------------------------------------------------------------------------------------
       l_inclusion := TRUE;
--
    EXCEPTION
      WHEN ex_not_found THEN
        l_inclusion := FALSE;
    END;


  ------------------------------------------------------------------------
  -- Work out whether to just shut down the membership of the given route
  -- or to cascade through and shut down the member elements as well
  -- if we set l_end_date_all to 'y' we'll cascade
  ------------------------------------------------------------------------
  IF   (l_inclusion) THEN
       l_end_date_all := 'Y';
  ELSE
        l_end_date_all := pi_end_date_all;
  END IF;

--nm_debug.debug_off;
  nm_debug.proc_end(g_package_name,'is_group_to_be_closed');

  RETURN(l_end_date_all);

END is_group_to_be_closed;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_membership_hierarchy(pi_route_id                      IN     NM_ELEMENTS.ne_id%TYPE
                                  ,pi_end_date_all                  IN     VARCHAR2 DEFAULT 'N'
--                                  ,pi_end_date_datums               IN     VARCHAR2 DEFAULT 'N'
                                  ,pi_include_non_closed_nodes      IN     BOOLEAN DEFAULT FALSE
                                  ) IS


 l_qry        nm3type.max_varchar2;
 l_ref_cursor nm3type.ref_cursor;
 v_counter    PLS_INTEGER :=0;


  PROCEDURE append(pi_text IN VARCHAR2
                  ,pi_nl   IN BOOLEAN DEFAULT TRUE) IS

  ------------------------------------------
  -- routine used to build up a query string
  ------------------------------------------
  BEGIN
    IF pi_nl THEN
      l_qry := l_qry || chr(10);
    END IF;

    l_qry := l_qry || pi_text;

  END;

BEGIN

--
   nm_debug.proc_start(g_package_name,'get_membership_hierarchy');
--
--
----------------------------------------------------------------------------------
-- This procedure will populate pl/sql tables with details of
-- sub-Groups of Groups/Groups of Sections of a given Group of Groups element
-- it DOES NOT go down to the datums that make up a Group of Sections - closure of
-- datums is explicitly handled in the 'close_element' routine
--
-- Note: the 'ORDER BY level DESC' is critical because the resulting pl/sql table
-- is looped through and each of the sub-groups closed in turn - we need to close
-- from the bottom of the tree upwards
--
-- IF pi_include_non_closed_nodes is set to FALSE then we will just get back the
-- sub-groups that need to be closed - otherwise we get all sub-groups
----------------------------------------------------------------------------------
   append('SELECT',false);
   append('        LEVEL                                                                 depth');
   append('       ,nm3net.get_ne_unique(nm_ne_id_of)                                     label');
   append('       ,nm3net.get_ne_type(nm_ne_id_of)                                       child_ne_type');
   append('       ,nm_ne_id_of                                                           child_ne_id');
   append('       ,nm3close.is_group_to_be_closed(nm3net.get_ne_type(nm_ne_id_in)');
   append('                                      ,nm3net.get_nt_type(nm_ne_id_in)');
   append('                                      ,nm3net.get_nt_type(nm_ne_id_of)');
   append('                                      ,:pi_end_date_all)               end_date_flag');
   append('    FROM');
   append('        nm_members');
   append('    WHERE');
   append('        nm3net.get_ne_gty( nm_ne_id_of ) IS NOT NULL');

   IF NOT pi_include_non_closed_nodes THEN
     append('    AND nm3close.is_group_to_be_closed(nm3net.get_ne_type(nm_ne_id_in)');
     append('                                        ,nm3net.get_nt_type(nm_ne_id_in)');
     append('                                        ,nm3net.get_nt_type(nm_ne_id_of)');
     append('                                        ,:pi_end_date_all) = ''Y''');
   END IF;

   append('    CONNECT BY');
   append('        PRIOR nm_ne_id_of = nm_ne_id_in');
   append('    AND');
   append('        nm3net.get_ne_gty( nm_ne_id_of ) IS NOT NULL');

   IF NOT pi_include_non_closed_nodes THEN
     append('    AND nm3close.is_group_to_be_closed(nm3net.get_ne_type(nm_ne_id_in)');
     append('                                        ,nm3net.get_nt_type(nm_ne_id_in)');
     append('                                        ,nm3net.get_nt_type(nm_ne_id_of)');
     append('                                        ,:pi_end_date_all) = ''Y''');
   END IF;

   append('    START WITH');
   append('        nm_ne_id_in = :pi_route_id');

   IF NOT pi_include_non_closed_nodes THEN
     append('  ORDER BY');
     append('    level DESC');
   END IF;

--   nm_debug.debug(l_qry);

   IF NOT pi_include_non_closed_nodes THEN
--   nm_debug.debug('Our query will return just the end dated nodes');
       OPEN l_ref_cursor FOR l_qry USING pi_end_date_all
                                        ,pi_end_date_all
                                        ,pi_end_date_all
                                        ,pi_route_id;
   ELSE
--      nm_debug.debug('Our query will return all of the nodes');
        OPEN l_ref_cursor FOR l_qry USING pi_end_date_all
                                         ,pi_route_id;
   END IF;

--   nm_debug.debug('Query parsed ok');

   LOOP

     v_counter := v_counter +1;

     FETCH l_ref_cursor INTO g_tab_rte_memb_depth(v_counter)
                            ,g_tab_rte_memb_label(v_counter)
                            ,g_tab_rte_memb_child_ne_type(v_counter)
                            ,g_tab_rte_memb_child_ne_id(v_counter)
                            ,g_tab_rte_memb_end_date_flag(v_counter);

     EXIT WHEN l_ref_cursor%NOTFOUND;

   END LOOP;

   CLOSE l_ref_cursor;
--
   nm_debug.proc_end(g_package_name,'get_membership_hierarchy');
--
END get_membership_hierarchy;
--
-----------------------------------------------------------------------------
--
FUNCTION datums_are_to_be_closed (pi_ne_id           IN   nm_elements.ne_id%TYPE
                                 ,pi_ne_type         IN   nm_elements.ne_type%TYPE
                                 ,pi_end_date_datums IN   VARCHAR2) RETURN BOOLEAN IS

 v_flag BOOLEAN := FALSE;

BEGIN
--
   nm_debug.proc_start(g_package_name,'datums_are_to_be_closed');
--
   --------------------------------------------------------------
   -- If the current group is a Group of Sections and user
   -- has expicitly opted to end date datums - OR - the network
   -- type of the Group of Sections is AutoIncluded - then we
   -- will end date datums
   --------------------------------------------------------------
   IF pi_ne_type = 'G'
       AND ( pi_end_date_datums = 'Y' OR nm3net.is_nt_inclusion(pi_nt => nm3net.get_nt_type(pi_ne_id) ))
       -- CWS 0110184 Chect to see if the group type is partial before allowing the end dating of datums
       -- Change reversed out as this has not been agreed by product for 4.3
       --AND nm3get.get_ngt(pi_ngt_group_type => nm3get.get_ne(pi_ne_id => pi_ne_id, pi_raise_not_found => FALSE).ne_nt_type).ngt_partial = 'N'
   THEN
      v_flag := TRUE;
   END IF;
--
   nm_debug.proc_end(g_package_name,'datums_are_to_be_closed');
--

   RETURN (v_flag);

END datums_are_to_be_closed;
--
-----------------------------------------------------------------------------
--
PROCEDURE close_element(pi_ne_id           IN   nm_elements.ne_id%TYPE
                       ,pi_ne_type         IN   nm_elements.ne_type%TYPE
                       ,pi_effective_date  IN   DATE
                       ,pi_end_date_datums IN   VARCHAR2) IS

  l_job_id        nm_nw_temp_extents.nte_job_id%TYPE;
  
  TYPE l_rec_nmh_tab IS TABLE OF nm_member_history%rowtype INDEX BY BINARY_INTEGER;
  l_rec_nmh       l_rec_nmh_tab;
  
BEGIN
--
   nm_debug.proc_start(g_package_name,'close_element');
--
-- when we have a group of sections and datums need closing then do so
--
   IF datums_are_to_be_closed (pi_ne_id           => pi_ne_id
                              ,pi_ne_type         => pi_ne_type
                              ,pi_end_date_datums => pi_end_date_datums) THEN
             DECLARE
                pla_exception EXCEPTION ;
                PRAGMA EXCEPTION_INIT(pla_exception, -20212);
             BEGIN
                nm3extent.create_temp_ne( pi_source_id => pi_ne_id
                                         ,pi_source    => nm3extent.c_route
                                         ,po_job_id    => l_job_id
                                         );
                multi_element_close( nm3close.c_extent, l_job_id, pi_effective_date );
             EXCEPTION
                WHEN pla_exception THEN
                  -- if the placement array is empty then do nothing
                  -- as the route has no elements;
                  NULL;
             END;

   END IF;

  ------------------------------------------------------------------
  -- end date the Group of Groups/Group of Sections route membership
  ------------------------------------------------------------------
  UPDATE NM_MEMBERS
  SET    nm_end_date = pi_effective_date
  WHERE  nm_ne_id_in = pi_ne_id
  AND nm_end_date IS NULL
  RETURNING
      NM_NE_ID_IN
    , NM_NE_ID_OF
    , NM_NE_ID_OF
    , NM_BEGIN_MP
    , NM_START_DATE
    , NM_TYPE
    , NM_OBJ_TYPE
    , NULL
    BULK COLLECT INTO
    l_rec_nmh;

    FOR i IN 1.. l_rec_nmh.count LOOP
      nm3ins.ins_nmh(p_rec_nmh => l_rec_nmh(i));
    END LOOP;
--


  --------------------------------------------------------------------
  -- end-date the membership of all data where this route is a member!
  --------------------------------------------------------------------
  close_groups(pi_ne_id, pi_effective_date);

  -------------------------------------
  -- end date the element route record
  -------------------------------------
  UPDATE nm_elements
  SET    ne_end_date = pi_effective_date
  WHERE  ne_id       = pi_ne_id;

  insert_nm_element_history ( p_ne_id          => pi_ne_id
                            , p_effective_date => pi_effective_date
                            , p_neh_descr      => null
                            );

  -----------------------------------------------------------------
  -- end date any Additional Data that is associated to this element
  ------------------------------------------------------------------
  nm3nwad.end_date_all_ad_for_element(pi_ne_id          => pi_ne_id
                                     ,pi_effective_date => pi_effective_date);
  
--
   nm_debug.proc_end(g_package_name,'close_element');
--
END close_element;
--
-----------------------------------------------------------------------------
PROCEDURE route_close ( pi_route_id             NM_ELEMENTS.ne_id%TYPE
                       ,pi_effective_date       DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                       ,pi_end_date_all         VARCHAR2 DEFAULT 'N'
                       ,pi_end_date_datums      VARCHAR2 DEFAULT 'N'
                      )
IS

  CURSOR is_route_id ( c_ne_id    NM_ELEMENTS.ne_id%TYPE)IS
  SELECT *
  FROM  NM_ELEMENTS
  WHERE ne_id = c_ne_id
  AND   ne_type IN ('P','G')
  FOR UPDATE OF ne_end_date NOWAIT;

  l_ne_rec        nm_elements%ROWTYPE;
  l_next_recno    PLS_INTEGER;
--
BEGIN
--
  nm_debug.proc_start(g_package_name,'route_close');
--
--
  -------------------------------------------------------
  -- check the top level element IS a Group of Groups OR
  -- a Group of Sections
  -------------------------------------------------------
  OPEN is_route_id ( pi_route_id);
  FETCH is_route_id INTO l_ne_rec;
     IF is_route_id%NOTFOUND THEN
        CLOSE is_route_id;
        RAISE_APPLICATION_ERROR( -20001, 'ID passed IS NOT a group');
     END IF;
  CLOSE is_route_id;
--
--
--
  ------------------------------------------------------------------------------------------------------------------------------
  -- poplulate the PL/SQL tables with the list of all members of the
  -- parent element and with the flag that denotes whether or not to
  -- end date individual members
  --
  -- pl/sql tables are as follows
  --  NAME                             CONTENTS
  --  ====                             ========
  --  g_tab_rte_memb_depth             level within the group hierarchy
  --  g_tab_rte_memb_label             ne_unique of child element
  --  g_tab_rte_memb_child_ne_type     network element type of child element e.g. G (Group of Sections) or P (Group of Groups)
  --  g_tab_rte_memb_child_ne_id       ne_id of child element
  --  g_tab_rte_memb_end_date_flag     flag to denote whether this element is end dated
  ------------------------------------------------------------------------------------------------------------------------------
  g_tab_rte_memb_depth.DELETE;
  g_tab_rte_memb_label.DELETE;
  g_tab_rte_memb_child_ne_type.DELETE;
  g_tab_rte_memb_child_ne_id.DELETE;
  g_tab_rte_memb_end_date_flag.DELETE;
  
  get_membership_hierarchy(pi_route_id                 => pi_route_id
                          ,pi_end_date_all             => pi_end_date_all
--                          ,pi_end_date_datums          => pi_end_date_datums
                          ,pi_include_non_closed_nodes => FALSE);

  --------------------------------------------------------------
  -- Add the actual parent record into the membership hierarchy
  -- because we add this record last we will process this last
  --------------------------------------------------------------
  l_next_recno := g_tab_rte_memb_depth.COUNT+1;

  g_tab_rte_memb_depth(l_next_recno)          := 0;
  g_tab_rte_memb_label(l_next_recno)          := 'TOP LEVEL';
  g_tab_rte_memb_child_ne_type(l_next_recno)  := nm3net.get_ne_type(pi_route_id);
  g_tab_rte_memb_child_ne_id (l_next_recno)   := pi_route_id;
  g_tab_rte_memb_end_date_flag (l_next_recno) := 'Y';


  ---------------------------------------------------------------------------------------
  -- Loop through the pl/sql table and close down each group of groups/group of sections
  -- in close_element we call datums_are_to_be_closed function to determine whether or not
  -- to go the whole hog and end date group of section datums as well
  ---------------------------------------------------------------------------------------
  FOR i IN 1..g_tab_rte_memb_depth.COUNT LOOP

    close_element(pi_ne_id           => g_tab_rte_memb_child_ne_id(i)
                 ,pi_ne_type         => g_tab_rte_memb_child_ne_type(i)
                 ,pi_effective_date  => pi_effective_date
                 ,pi_end_date_datums => pi_end_date_datums);

  END LOOP;
  
  --Log 716050:LS:15-apr-2009
  --This will end date the distance break element when the route is closed
  UPDATE  nm_elements
  SET     ne_end_date = pi_effective_date
  WHERE   ne_id IN  (SELECT nm_ne_id_of 
                     FROM   nm_members_all  
                     WHERE  nm_ne_id_in = pi_route_id)
  AND     ne_type= 'D' ;
  --
-- CWS 0111307 Add element history
  insert_nm_element_history ( p_ne_id          => pi_route_id
                            , p_effective_date => pi_effective_date
                            , p_neh_descr      => null
                            );
--
--  RAC - if the group is linear, it may have a shape - just reshape it
--
  nm3sdm.reshape_route(pi_route_id, pi_effective_date, 'Y');

  nm_debug.proc_end(g_package_name,'route_close');
--
END route_close;
--
-----------------------------------------------------------------------------
--
PROCEDURE close_temp_extent ( pi_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                             ,pi_effective_date DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                            )
IS
--
   CURSOR c1 ( c_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE ) IS
   SELECT nte_ne_id_of
   FROM NM_NW_TEMP_EXTENTS
   WHERE nte_job_id = c_job_id;
--
   l_tab_nte_ne_id_of nm3type.tab_number;
--
   CURSOR cs_members ( c_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE ) IS
   SELECT nm.nm_ne_id_in
         ,nm.nm_type
         ,nm.nm_obj_type
         ,nm.ROWID nm_rowid
    FROM  NM_MEMBERS         nm
         ,NM_NW_TEMP_EXTENTS nte
   WHERE  nte.nte_job_id = c_job_id
    AND   nm.nm_ne_id_of = nte.nte_ne_id_of
   FOR UPDATE OF nm.nm_end_date NOWAIT;
--
   l_tab_nm_ne_id_in nm3type.tab_number;
   l_tab_nm_type     nm3type.tab_varchar4;
   l_tab_nm_obj_type nm3type.tab_varchar4;
   l_tab_nm_rowid    nm3type.tab_rowid;
--
   CURSOR cs_elements ( c_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE ) IS
   SELECT ne.ROWID ne_rowid
    FROM  NM_ELEMENTS        ne
         ,NM_NW_TEMP_EXTENTS nte
   WHERE  nte.nte_job_id = c_job_id
    AND   ne.ne_id       = nte.nte_ne_id_of
   FOR UPDATE OF ne.ne_end_date NOWAIT;
--
   l_tab_ne_rowid     nm3type.tab_rowid;
--
   l_tab_inv_rowid    nm3type.tab_rowid;
   l_ind BINARY_INTEGER := 0;
--
   CURSOR cs_inv (c_iit_ne_id NUMBER) IS
   SELECT ROWID
    FROM  NM_INV_ITEMS
   WHERE  iit_ne_id = c_iit_ne_id
   FOR UPDATE OF iit_end_date NOWAIT;
--
  TYPE l_rec_nmh_tab IS TABLE OF nm_member_history%rowtype INDEX BY BINARY_INTEGER;
  l_rec_nmh       l_rec_nmh_tab;
BEGIN
--
   nm_debug.proc_start(g_package_name , 'close_temp_extent');
--
   -- Get all of the NTE_NE_ID_OFs so we dont need to use this cursor more than once
   OPEN  c1(pi_job_id);
   FETCH c1 BULK COLLECT INTO l_tab_nte_ne_id_of;
   CLOSE c1;
--
-- Check for any inv items that are not replaceable
   FOR l_count IN 1..l_tab_nte_ne_id_of.COUNT
    LOOP
      check_replaceable_inv_type( l_tab_nte_ne_id_of(l_count) );
   END LOOP;
--
-- Lock all the locations of groups and inv
   OPEN  cs_members (pi_job_id);
   FETCH cs_members BULK COLLECT INTO l_tab_nm_ne_id_in
                                     ,l_tab_nm_type
                                     ,l_tab_nm_obj_type
                                     ,l_tab_nm_rowid;
   CLOSE cs_members;
--
   -- Lock all the elements
   OPEN  cs_elements (pi_job_id);
   FETCH cs_elements BULK COLLECT INTO l_tab_ne_rowid;
   CLOSE cs_elements;
--
   -- CWS 0111307 Membership history record added.
   -- end date the locations of groups and inv
   FORALL i IN 1..l_tab_nm_rowid.COUNT
    UPDATE NM_MEMBERS
     SET   nm_end_date = pi_effective_date
    WHERE  ROWID       = l_tab_nm_rowid(i)
    AND NM_END_DATE IS NULL
    RETURNING
      NM_NE_ID_IN
    , NM_NE_ID_OF
    , NM_NE_ID_OF
    , NM_BEGIN_MP
    , NM_START_DATE
    , NM_TYPE
    , NM_OBJ_TYPE
    , NULL
    BULK COLLECT INTO
    l_rec_nmh;
--
    FOR i IN 1.. l_rec_nmh.count LOOP
      nm3ins.ins_nmh(p_rec_nmh => l_rec_nmh(i));
    END LOOP;

   -- end date the elements
   FORALL i IN 1..l_tab_ne_rowid.COUNT
    UPDATE NM_ELEMENTS
     SET   ne_end_date = pi_effective_date
    WHERE  ROWID       = l_tab_ne_rowid(i);
--
   FOR l_count IN 1..l_tab_nm_rowid.COUNT
    LOOP
      --
      -- Build up a PL/SQL table of the ROWIDs of all the members which we have updated
      -- which are Inventory
      --  and are NOT end_loc_only
      --  and have no locations left
      --
      IF   l_tab_nm_type(l_count) = 'I'
       AND nm3inv.get_inv_type(l_tab_nm_obj_type(l_count)).nit_end_loc_only = 'N'
       AND NOT nm3ausec.do_locations_exist(l_tab_nm_ne_id_in(l_count))
       THEN
         l_ind := l_ind + 1;
         OPEN  cs_inv (l_tab_nm_ne_id_in(l_count));
         FETCH cs_inv INTO l_tab_inv_rowid(l_ind);
         CLOSE cs_inv;
      END IF;
      --
   END LOOP;
   -- end date the inv items. inv must be fully located on all the elements to be closed;
   -- only if not end_date_location_only
   FORALL i IN 1..l_tab_inv_rowid.COUNT
    UPDATE NM_INV_ITEMS
     SET   iit_end_date = pi_effective_date
    WHERE  ROWID        = l_tab_inv_rowid(i);
--
   -- update element_history
   FOR l_count IN 1..l_tab_nte_ne_id_of.COUNT
    LOOP
      insert_nm_element_history (p_ne_id => l_tab_nte_ne_id_of(l_count)
                                ,p_effective_date => pi_effective_date
                                );
   END LOOP;
--
   close_other_products ( p_ne_id => pi_job_id
                         ,p_effective_date => pi_effective_date
                         ,p_from_extent => 'Y'
                        );
--


   nm_debug.proc_end(g_package_name , 'close_temp_extent');
--
END close_temp_extent ;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_gis RETURN VARCHAR2
IS
BEGIN
   RETURN c_gis;
END get_c_gis;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_extent RETURN VARCHAR2
IS
BEGIN
   RETURN c_extent;
END get_c_extent;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_route RETURN VARCHAR2
IS
BEGIN
   RETURN c_route;
END get_c_route;
--
-----------------------------------------------------------------------------
--
PROCEDURE close_node (pi_no_node_id     nm_nodes.no_node_id%TYPE
                     ,pi_effective_date DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                     ) IS
--
   c_initial_effective_date CONSTANT DATE := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
--
   l_no_rowid   ROWID;
--
   l_rec_no     nm_nodes%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'close_node');
--
   nm3user.set_effective_date (pi_effective_date);
--
   l_no_rowid := nm3lock_gen.lock_no (pi_no_node_id => pi_no_node_id);
--
-- We don't need to bother about the usage of the node, the date track trigger
--  will take care of this for us
--
   UPDATE nm_nodes_all
    SET   no_end_date = pi_effective_date
   WHERE  ROWID       = l_no_rowid;
--
   nm3user.set_effective_date (c_initial_effective_date);
--
   nm_debug.proc_end(g_package_name,'close_node');
--
EXCEPTION
--
   WHEN others
    THEN
      nm3user.set_effective_date (c_initial_effective_date);
      RAISE;
--
END close_node;
--
-----------------------------------------------------------------------------
--
END nm3close;
/
