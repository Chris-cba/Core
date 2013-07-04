CREATE OR REPLACE TRIGGER v_load_elements_trg instead OF
INSERT OR UPDATE ON V_LOAD_ELEMENTS
FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : %W% %G%
--       Module Name      : %M%
--       Date into SCCS   : %E% %U%
--       Date fetched Out : %D% %T%
--       SCCS Version     : %I%
--
--
--   Author : I Turnbull
--
--   v_load_elements_trg Trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   CURSOR cs_node_exists ( c_no_node_id NM_NODES.no_node_id%TYPE )
   IS
   SELECT 1 
   FROM NM_NODES
   WHERE no_node_id = c_no_node_id;

   l_ne_rec NM_ELEMENTS%ROWTYPE;
   
   l_dummy NUMBER(1);
--
   FUNCTION create_point_node ( pi_no_node_name NM_NODES.no_node_name%TYPE
                               ,pi_nt_type      NM_TYPES.nt_type%TYPE
                               ,pi_effective_date NM_NODES.no_start_date%TYPE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY') )
   RETURN NM_NODES.no_node_id%TYPE
   IS
      l_np_id      NM_POINTS.np_id%TYPE;
      l_no_node_id NM_NODES.no_node_id%TYPE;
      l_nt_rec     NM_TYPES%ROWTYPE;
   BEGIN
      l_nt_rec := nm3net.get_nt(pi_nt_type);
      
      l_np_id := nm3net.create_point( pi_np_grid_east  => NULL
                                     ,pi_np_grid_north => NULL
                                     ,pi_np_descr      => 'Auto Created by load datums on '||pi_effective_date
                                     );  
      
      -- insert the nodes
      l_no_node_id := nm3net.get_next_node_id;
      nm3net.create_node( pi_no_node_id => l_no_node_id
                         ,pi_np_id => l_np_id
                         ,pi_start_date => pi_effective_date
                         ,pi_no_descr => pi_no_node_name
                         ,pi_no_node_type => l_nt_rec.nt_node_type
                         ,pi_no_node_name => pi_no_node_name
                        );   
      RETURN l_no_node_id;                     
   END;

BEGIN

   l_ne_rec.ne_id  := :NEW.ne_id;
   l_ne_rec.ne_unique  := :NEW.ne_unique;
   l_ne_rec.ne_type  := :NEW.ne_type;
   l_ne_rec.ne_nt_type  := :NEW.ne_nt_type;
   l_ne_rec.ne_descr := :NEW.ne_descr;
   l_ne_rec.ne_length  := :NEW.ne_length;
   l_ne_rec.ne_admin_unit  := :NEW.ne_admin_unit;
   l_ne_rec.ne_start_date  := :NEW.ne_start_date;
   l_ne_rec.ne_end_date  := :NEW.ne_end_date;
   l_ne_rec.ne_gty_group_type  := :NEW.ne_gty_group_type;
   l_ne_rec.ne_owner  := :NEW.ne_owner;
   l_ne_rec.ne_name_1  := :NEW.ne_name_1;
   l_ne_rec.ne_name_2  := :NEW.ne_name_2;
   l_ne_rec.ne_prefix  := :NEW.ne_prefix;
   l_ne_rec.ne_number  := :NEW.ne_number;
   l_ne_rec.ne_sub_type  := :NEW.ne_sub_type;
   l_ne_rec.ne_group  := :NEW.ne_group;
   
   --
   -- the xml file will have the node name
   l_ne_rec.ne_no_start  := nm3net.get_node_id(:NEW.ne_no_start);
   l_ne_rec.ne_no_end  := nm3net.get_node_id(:NEW.ne_no_end);

   IF hig.get_sysopt('XMLCRENODE') = 'Y' THEN 
      OPEN cs_node_exists( l_ne_rec.ne_no_start );
      FETCH cs_node_exists INTO l_dummy;
      IF cs_node_exists%FOUND THEN 
         CLOSE cs_node_exists;
      ELSE
         CLOSE cs_node_exists;
         l_ne_rec.ne_no_start := create_point_node( pi_no_node_name   => :NEW.ne_no_start
                                                   ,pi_nt_type        => l_ne_rec.ne_nt_type
                                                   ,pi_effective_date => NVL(:NEW.ne_start_date,To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY'))
                                                  );      
      END IF;
   
      OPEN cs_node_exists( l_ne_rec.ne_no_end );
      FETCH cs_node_exists INTO l_dummy;
      IF cs_node_exists%FOUND THEN 
         CLOSE cs_node_exists;
      ELSE
         CLOSE cs_node_exists;
         l_ne_rec.ne_no_end := create_point_node( pi_no_node_name   => :NEW.ne_no_end
                                                   ,pi_nt_type        => l_ne_rec.ne_nt_type
                                                   ,pi_effective_date => NVL(:NEW.ne_start_date,To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY'))
                                                  );      
         
      END IF;
   END IF;
   
   l_ne_rec.ne_sub_class  := NVL(:NEW.ne_sub_class,'S');
   l_ne_rec.ne_nsg_ref  := :NEW.ne_nsg_ref;
   l_ne_rec.ne_version_no  := :NEW.ne_version_no;
   
   nm3net.insert_any_element(  p_rec_ne => l_ne_rec
                             , p_nm_cardinality => 1
                             , p_auto_include => TRUE
                            );

END;
/

