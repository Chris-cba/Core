CREATE OR REPLACE PACKAGE BODY nm3inv_copy AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv_copy.pkb-arc   2.3   Jul 04 2013 16:04:32   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3inv_copy.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:04:32  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:14  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 1.2
-------------------------------------------------------------------------
--   Author : Jonathan Mills
--
--   Inventory Copy package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
--  g_body_sccsid is the SCCS ID for the package body
--
  g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.3  $';
  g_package_name    CONSTANT  varchar2(30)   := 'nm3inv_copy';
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
-----------------------------------------------------------------------------
--

PROCEDURE copy_item (pi_old_iit_ne_id  nm_inv_items.iit_ne_id%TYPE
                    ,pi_new_rec_iit    nm_inv_items%ROWTYPE
                    ,pi_nte_job_id     nm_nw_temp_extents.nte_job_id%TYPE
                    ,pi_effective_date DATE    DEFAULT NULL
                    ,pi_cascade_xsp    BOOLEAN DEFAULT FALSE
                    ,pi_cascade_excl   BOOLEAN DEFAULT FALSE
                    ,pi_cascade_au     BOOLEAN DEFAULT FALSE
                    ) IS
--
   TYPE old_new_link IS RECORD (
     old_item_id  nm_inv_items.iit_ne_id%TYPE
    ,new_item_id  nm_inv_items.iit_ne_id%TYPE);
   
   TYPE tab_old_new IS TABLE OF old_new_link INDEX BY BINARY_INTEGER;
   
--
   CURSOR cs_groupings (c_iit_ne_id nm_inv_items.iit_ne_id%TYPE
                       ) IS
   SELECT iit.iit_ne_id
         ,iig_parent_id
    FROM  NM_INV_ITEMS iit
         ,NM_INV_ITEMS iit_p
         ,NM_INV_TYPE_GROUPINGS
         ,NM_INV_ITEM_GROUPINGS
   WHERE  iit.iit_ne_id IN (SELECT iig_item_id
                            FROM   NM_INV_ITEM_GROUPINGS
                            START WITH iig_parent_id = c_iit_ne_id
                            CONNECT BY iig_parent_id = PRIOR iig_item_id
                           )
    AND   iig_parent_id      = iit_p.iit_ne_id
    AND   iig_item_id        = iit.iit_ne_id
    AND   iit.iit_inv_type   = itg_inv_type
    AND   iit_p.iit_inv_type = itg_parent_inv_type;
--
   CURSOR cs_is_child_item (c_iit_ne_id nm_inv_items.iit_ne_id%TYPE) IS
   SELECT 1
    FROM  nm_inv_item_groupings
   WHERE  iig_item_id = c_iit_ne_id;
--
   c_rec_iit_1    CONSTANT nm_inv_items%ROWTYPE := g_rec_iit_1;
   c_rec_iit_2    CONSTANT nm_inv_items%ROWTYPE := g_rec_iit_2;
--
   l_dummy        PLS_INTEGER;
   l_is_child     BOOLEAN;
   l_warning_code   varchar2(10);
   l_warning_msg    varchar2(2000);

--
   l_old_rec_iit  nm_inv_items%ROWTYPE;
   l_new_rec_iit  nm_inv_items%ROWTYPE;
--
   c_eff_date     CONSTANT DATE        := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
   l_eff_date     CONSTANT DATE        := NVL(pi_effective_date,pi_new_rec_iit.iit_start_date);
--
   l_block                 nm3type.tab_varchar32767;
   l_rec_nit               nm_inv_types%ROWTYPE;
   t_children              nm3type.tab_number;
   t_parents               nm3type.tab_number;
   t_old_new               tab_old_new;
--
   PROCEDURE reset_for_return IS
   BEGIN
      nm3user.set_effective_date (c_eff_date);
      g_rec_iit_1 := c_rec_iit_1;
      g_rec_iit_2 := c_rec_iit_2;
   END reset_for_return;
--
   PROCEDURE insert_inv(pi_new_rec IN nm_inv_items%ROWTYPE) IS
      l_rec_iit  nm_inv_items%ROWTYPE;
      
   BEGIN
     nm_debug.debug('Inserting item ('||pi_new_rec.iit_inv_type||') '||pi_new_rec.iit_ne_id ||' with pk of '||pi_new_rec.iit_primary_key ||' and fk of '||pi_new_rec.iit_foreign_key );

     nm3inv.insert_nm_inv_items (pi_new_rec);
  --
     -- Get the new rec_iit - Triggers may well have changed some details
     nm3user.set_effective_date (pi_new_rec.iit_start_date);
     l_rec_iit := nm3inv.get_inv_item (pi_new_rec.iit_ne_id);
     nm3user.set_effective_date (l_eff_date);
     IF l_rec_iit.iit_ne_id IS NULL
      THEN -- We may not be able to see it now we've created it
        hig.raise_ner(pi_appl                => nm3type.c_hig
                     ,pi_id                  => 67
                     ,pi_supplementary_info  => 'NM_INV_ITEMS - NEW : '||pi_new_rec.iit_ne_id
                     );
     END IF;
     nm_debug.debug('New IIT_PK : '||l_rec_iit.iit_primary_key);
  --
     IF pi_nte_job_id != -1
      THEN
       nm3homo.homo_update (p_temp_ne_id_in  => pi_nte_job_id
                           ,p_iit_ne_id      => l_rec_iit.iit_ne_id
                           ,p_effective_date => l_rec_iit.iit_start_date
                           );

     END IF;
   END insert_inv;
--
   PROCEDURE link_old_to_new(p_old_item IN nm_inv_items.iit_ne_id%TYPE
                            ,p_new_item IN nm_inv_items.iit_ne_id%TYPE) IS
     l_ind pls_integer;
   BEGIN
     nm_debug.debug('Storing link '||p_old_item || ' to '||p_new_item);
     l_ind := t_old_new.COUNT+1;
     t_old_new(l_ind).old_item_id := p_old_item;
     t_old_new(l_ind).new_item_id := p_new_item;
   END link_old_to_new;
--
   FUNCTION lookup_parent(p_old_ne_id IN nm_inv_items.iit_ne_id%TYPE) 
   RETURN nm_inv_items.iit_ne_id%TYPE IS
     l_retval nm_inv_items.iit_ne_id%TYPE;
   BEGIN
     nm_debug.debug('looking up '||p_old_ne_id);
     FOR i IN 1..t_old_new.COUNT LOOP
       IF t_old_new(i).old_item_id = p_old_ne_id THEN
         l_retval := t_old_new(i).new_item_id;
       END IF;
     END LOOP;
     nm_debug.debug('Returning '||l_retval);
     RETURN l_retval;
   END lookup_parent;
--
BEGIN
--
   nm_debug.debug('-------------------------------------------------');
   nm_debug.debug('pi_old_iit_ne_id               : '||pi_old_iit_ne_id);
   nm_debug.debug('pi_new_rec_iit.iit_ne_id       : '||pi_new_rec_iit.iit_ne_id);
   nm_debug.debug('pi_new_rec_iit.iit_inv_type    : '||pi_new_rec_iit.iit_inv_type);
   nm_debug.debug('pi_new_rec_iit.iit_primary_key : '||pi_new_rec_iit.iit_primary_key);
   nm_debug.debug('pi_new_rec_iit.iit_foreign_key : '||pi_new_rec_iit.iit_foreign_key);
   nm_debug.debug('pi_new_rec_iit.iit_start_date  : '||pi_new_rec_iit.iit_start_date);
   nm_debug.debug('pi_new_rec_iit.iit_end_date    : '||pi_new_rec_iit.iit_end_date);
   --
   nm_debug.proc_start(g_package_name,'copy_item');
--
   -- Set the effective_date
   nm3user.set_effective_date (l_eff_date);
--

   OPEN  cs_is_child_item (pi_old_iit_ne_id);
   FETCH cs_is_child_item INTO l_dummy;
   l_is_child := cs_is_child_item%FOUND;
   CLOSE cs_is_child_item;
   IF l_is_child
    THEN
      hig.raise_ner(pi_appl                => nm3type.c_net
                   ,pi_id                  => 258
                   );
   END IF;
--
   -- Get the old rec_iit
   l_old_rec_iit := nm3inv.get_inv_item (pi_old_iit_ne_id);
   IF l_old_rec_iit.iit_ne_id IS NULL
    THEN
      hig.raise_ner(pi_appl                => nm3type.c_hig
                   ,pi_id                  => 67
                   ,pi_supplementary_info  => 'NM_INV_ITEMS - OLD : '||pi_old_iit_ne_id
                   );
   END IF;
--
   -- checks over
   -- get the item hierarchy, store this as nm3homo may make alterations to this
   OPEN cs_groupings(pi_old_iit_ne_id);
   FETCH cs_groupings BULK COLLECT INTO t_children, t_parents;
   CLOSE cs_groupings;
   
   l_rec_nit := nm3inv.get_inv_type(pi_new_rec_iit.iit_inv_type);
   

   link_old_to_new(pi_old_iit_ne_id, pi_new_rec_iit.iit_ne_id);
   
   insert_inv(pi_new_rec_iit);

   UPDATE nm_inv_item_groupings
   SET    iig_end_date = pi_effective_date
   WHERE iig_parent_id = pi_old_iit_ne_id;
   
--
  -- now recreate the hierarchy as it was before
   FOR i IN 1..t_children.COUNT
    LOOP
      DECLARE
         l_child_rec_iit nm_inv_items%ROWTYPE;
         l_child_rec_nit nm_inv_types%ROWTYPE;
      BEGIN
         --
         nm_debug.debug('Processing parent '||t_parents(i) ||' with child '||t_children(i));
         nm_debug.debug('Parent pk is '||nm3get.get_iit_all(t_parents(i)).iit_primary_key);

         l_child_rec_iit := nm3inv.get_inv_item_all (t_children(i));
         IF l_child_rec_iit.iit_ne_id IS NULL
          THEN
            hig.raise_ner(pi_appl                => nm3type.c_hig
                         ,pi_id                  => 67
                         ,pi_supplementary_info  => 'NM_INV_ITEMS - CHILD : '||t_children(i)
                         );
         END IF;
         IF nm3inv.get_inv_type_attr(l_child_rec_iit.iit_inv_type,'IIT_PRIMARY_KEY').ita_inv_type IS NOT NULL
          AND (NOT nm3flx.is_numeric(l_child_rec_iit.iit_primary_key)
               OR l_child_rec_iit.iit_primary_key != l_child_rec_iit.iit_ne_id
              )
          THEN
            hig.raise_ner(pi_appl                => nm3type.c_net
                         ,pi_id                  => 259
                         );
         ELSE
            l_child_rec_iit.iit_primary_key := Null;
         END IF;
         l_child_rec_iit.iit_ne_id       := nm3net.get_next_ne_id;
         l_child_rec_iit.iit_primary_key := l_child_rec_iit.iit_ne_id;
         l_child_rec_iit.iit_foreign_key := nm3get.get_iit_all(lookup_parent(t_parents(i))).iit_primary_key;
         nm_debug.debug('Child item '||t_children(i)|| ' new start date set to '||pi_new_rec_iit.iit_start_date);
         nm_debug.debug('Child item '||t_children(i)|| ' new end date of '||nm3get.get_iit_all(t_children(i)).iit_end_date );
         l_child_rec_iit.iit_start_date  := pi_new_rec_iit.iit_start_date;
         l_child_rec_iit.iit_end_date    := NULL; -- clear this value
         --
         l_child_rec_nit := nm3inv.get_inv_type(l_child_rec_iit.iit_inv_type);
         --
         IF   pi_cascade_xsp
          AND l_child_rec_nit.nit_x_sect_allow_flag = 'Y'
          AND l_rec_nit.nit_x_sect_allow_flag       = 'Y'
          THEN
            l_child_rec_iit.iit_x_sect := pi_new_rec_iit.iit_x_sect;
         END IF;
         --
         IF   pi_cascade_excl
          AND l_child_rec_nit.nit_exclusive = 'Y'
          AND l_rec_nit.nit_exclusive       = 'Y'
          THEN
            g_rec_iit_1 := l_child_rec_iit;
            g_rec_iit_2 := pi_new_rec_iit;
            l_block.DELETE;
            nm3ddl.append_tab_varchar(l_block,'BEGIN',FALSE);
            FOR cs_excl IN (SELECT ita1.ita_attrib_name ita1_attrib_name
                                  ,ita2.ita_attrib_name ita2_attrib_name
                             FROM  nm_inv_type_attribs ita1
                                  ,nm_inv_type_attribs ita2
                            WHERE  ita1.ita_inv_type    = l_child_rec_iit.iit_inv_type
                             AND   ita2.ita_inv_type    = pi_new_rec_iit.iit_inv_type
                             AND   ita1.ita_attrib_name = ita2.ita_attrib_name
                             AND   ita1.ita_exclusive   = 'Y'
                             AND   ita2.ita_exclusive   = ita1.ita_exclusive
                           )
             LOOP
               nm3ddl.append_tab_varchar(l_block,'   '||g_package_name||'.g_rec_iit_1.'||cs_excl.ita1_attrib_name||' := '||g_package_name||'.g_rec_iit_2.'||cs_excl.ita2_attrib_name||';');
            END LOOP;
            nm3ddl.append_tab_varchar(l_block,'END;');
            nm3ddl.execute_tab_varchar(l_block);
            l_child_rec_iit := g_rec_iit_1;
            l_new_rec_iit   := g_rec_iit_2;
         END IF;
         --
         IF pi_cascade_au
          THEN
            IF l_child_rec_nit.nit_admin_type != l_rec_nit.nit_admin_type
             THEN
               hig.raise_ner(pi_appl                => nm3type.c_net
                            ,pi_id                  => 260
                            ,pi_supplementary_info  => l_child_rec_nit.nit_inv_type
                            );
            END IF;
            l_child_rec_iit.iit_admin_unit := pi_new_rec_iit.iit_admin_unit;
         END IF;
         --
         link_old_to_new(t_children(i), l_child_rec_iit.iit_ne_id);
         -- insert it
         nm_debug.debug('Inserting child type ('||l_child_rec_iit.iit_inv_type||') with fk of ' ||l_child_rec_iit.iit_foreign_key ||' parent item has end date of '|| nm3get.get_iit_all(l_child_rec_iit.iit_foreign_key).iit_end_date);
         insert_inv(l_child_rec_iit);

      END;
      --
   END LOOP;
--
   -- Set the values back to how they were when called
   reset_for_return;
--
   nm_debug.proc_end(g_package_name,'copy_item');
--
EXCEPTION
--
   WHEN others
    THEN
      -- Set the values back to how they were when called
      reset_for_return;
      RAISE;
--
END copy_item;
--
-----------------------------------------------------------------------------
--
END nm3inv_copy;
/
