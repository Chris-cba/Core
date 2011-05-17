CREATE OR REPLACE PACKAGE BODY nm3replace IS
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3replace.pkb-arc   2.4   May 17 2011 15:12:48   Chris.Strettle  $
--       Module Name      : $Workfile:   nm3replace.pkb  $
--       Date into PVCS   : $Date:   May 17 2011 15:12:48  $
--       Date fetched Out : $Modtime:   May 17 2011 15:07:12  $
--       PVCS Version     : $Revision:   2.4  $
--       Norfolk Specific Based on Main Branch revision : 2.3
--
--
--   Author : ITurnbull
--
--     nm3replace package.
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2000
-----------------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := 'Norfolk Specific: ' || '"$Revision:   2.4  $"';
--  g_body_sccsid is the SCCS ID for the package body
   g_package_name    CONSTANT  VARCHAR2(30)   := 'nm3replace';
------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------
--
   PROCEDURE end_date_element ( p_ne_id nm_elements.ne_id%TYPE
                               ,p_effective_date nm_elements.ne_start_date%TYPE
                              )
   IS
   BEGIN
         -- end date the original element 
      UPDATE nm_elements
      SET ne_end_date = p_effective_date
      WHERE ne_id IN ( p_ne_id );
   END;

   PROCEDURE create_new_element ( p_ne_id nm_elements.ne_id%TYPE
                                 ,p_ne_id_new IN OUT nm_elements.ne_id%TYPE
                                 ,p_effective_date DATE DEFAULT TRUNC(SYSDATE)
                                 ,p_ne_unique nm_elements.ne_unique%TYPE DEFAULT NULL
                                 ,p_ne_type nm_elements.ne_type%TYPE DEFAULT NULL
                                 ,p_ne_nt_type nm_elements.ne_nt_type%TYPE DEFAULT NULL
                                 ,p_ne_descr nm_elements.ne_descr%TYPE DEFAULT NULL
                                 ,p_ne_length nm_elements.ne_length%TYPE DEFAULT NULL
                                 ,p_ne_admin_unit nm_elements.ne_admin_unit%TYPE DEFAULT NULL
                                 ,p_ne_gty_group_type nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                                 ,p_ne_owner nm_elements.ne_owner%TYPE DEFAULT NULL
                                 ,p_ne_name_1 nm_elements.ne_name_1%TYPE DEFAULT NULL
                                 ,p_ne_name_2 nm_elements.ne_name_2%TYPE DEFAULT NULL
                                 ,p_ne_prefix nm_elements.ne_prefix%TYPE DEFAULT NULL
                                 ,p_ne_number nm_elements.ne_number%TYPE DEFAULT NULL
                                 ,p_ne_sub_type nm_elements.ne_sub_type%TYPE DEFAULT NULL
                                 ,p_ne_group nm_elements.ne_group%TYPE DEFAULT NULL
                                 ,p_ne_no_start nm_elements.ne_no_start%TYPE DEFAULT NULL
                                 ,p_ne_no_end nm_elements.ne_no_end%TYPE DEFAULT NULL
                                 ,p_ne_sub_class nm_elements.ne_sub_class%TYPE DEFAULT NULL
                                 ,p_ne_nsg_ref nm_elements.ne_nsg_ref%TYPE DEFAULT NULL
                                 ,p_ne_version_no nm_elements.ne_version_no%TYPE DEFAULT NULL
                                 ,p_neh_descr nm_element_history.neh_descr%TYPE DEFAULT NULL --CWS 0108990 12/03/2010
                               )
   IS
   CURSOR c1 (c_ne_id nm_elements.ne_id%TYPE) IS
      SELECT ne_id,
             ne_unique,
             ne_type,
             ne_nt_type,
             ne_descr,
             ne_length,
             ne_admin_unit,
             ne_start_date,
             ne_end_date,
             ne_gty_group_type,
             ne_owner,
             ne_name_1,
             ne_name_2,
             ne_prefix,
             ne_number,
             ne_sub_type,
             ne_group,
             ne_no_start,
             ne_no_end,
             ne_sub_class,
             ne_nsg_ref,
             ne_version_no
      FROM nm_elements
      WHERE ne_id = c_ne_id;

   -- flexiable attributes (columns) to inherit
   CURSOR c2 (c_nt_type nm_type_columns.ntc_nt_type%TYPE) IS
   SELECT ntc_column_name
   FROM nm_type_columns a
   WHERE ntc_nt_type = c_nt_type
     AND ntc_inherit = 'Y'
   ;


   v_ne_unique nm_elements.ne_unique%TYPE := p_ne_unique;
   v_ne_type nm_elements.ne_type%TYPE := p_ne_type;
   v_ne_nt_type nm_elements.ne_nt_type%TYPE := p_ne_nt_type;
   v_ne_descr nm_elements.ne_descr%TYPE := p_ne_descr;
   v_ne_length nm_elements.ne_length%TYPE := p_ne_length;
   v_ne_admin_unit nm_elements.ne_admin_unit%TYPE := p_ne_admin_unit;
   v_ne_gty_group_type nm_elements.ne_gty_group_type%TYPE := p_ne_gty_group_type;
   v_ne_owner nm_elements.ne_owner%TYPE := p_ne_owner;
   v_ne_name_1 nm_elements.ne_name_1%TYPE := p_ne_name_1;
   v_ne_name_2 nm_elements.ne_name_2%TYPE := p_ne_name_2;
   v_ne_prefix nm_elements.ne_prefix%TYPE := p_ne_prefix;
   v_ne_number nm_elements.ne_number%TYPE := p_ne_number;
   v_ne_sub_type nm_elements.ne_sub_type%TYPE := p_ne_sub_type;
   v_ne_group nm_elements.ne_group%TYPE := p_ne_group;
   v_ne_no_start nm_elements.ne_no_start%TYPE := p_ne_no_start;
   v_ne_no_end nm_elements.ne_no_end%TYPE := p_ne_no_end;
   v_ne_sub_class nm_elements.ne_sub_class%TYPE := p_ne_sub_class;
   v_ne_nsg_ref nm_elements.ne_nsg_ref%TYPE := p_ne_nsg_ref;
   v_ne_version_no nm_elements.ne_version_no%TYPE := p_ne_version_no;
   
   l_orig_ne_length nm_elements.ne_length%type;

   BEGIN
      IF p_ne_id_new IS NULL THEN
         p_ne_id_new := nm3net.get_next_ne_id;
      END IF;

      -- use the values from the 1st element as defaults for the new element
      FOR c1rec IN  c1(p_ne_id) LOOP
        -- get the inherited flex attrib columns
        FOR c2rec IN c2(c1rec.ne_nt_type) LOOP
            IF c2rec.ntc_column_name = 'NE_OWNER' THEN
               v_ne_owner := c1rec.ne_owner;
            END IF;
            IF c2rec.ntc_column_name = 'NE_NAME_1' THEN
               v_ne_name_1 := c1rec.ne_name_1;
            END IF;
            IF c2rec.ntc_column_name = 'NE_NAME_2' THEN
               v_ne_name_2 := c1rec.ne_name_2;
            END IF;
            IF c2rec.ntc_column_name = 'NE_PREFIX' THEN
               v_ne_prefix := c1rec.ne_prefix;
            END IF;
            IF c2rec.ntc_column_name = 'NE_NUMBER' THEN
               v_ne_number := c1rec.ne_number;
            END IF;
            IF c2rec.ntc_column_name = 'NE_SUB_TYPE' THEN
               v_ne_sub_type := c1rec.ne_sub_type;
            END IF;
            IF c2rec.ntc_column_name = 'NE_GROUP' THEN
               v_ne_group := c1rec.ne_group;
            END IF;
            IF c2rec.ntc_column_name = 'NE_SUB_CLASS' THEN
               v_ne_sub_class := c1rec.ne_sub_class;
            END IF;
            IF c2rec.ntc_column_name = 'NE_NSG_REF' THEN
               v_ne_nsg_ref := c1rec.ne_nsg_ref;
            END IF;
            IF c2rec.ntc_column_name = 'NE_VERSION_NO' THEN
               v_ne_version_no := c1rec.ne_version_no;
            END IF;
        END LOOP;

        l_orig_ne_length := c1rec.ne_length;
        
        IF v_ne_length IS NULL THEN
           v_ne_length := l_orig_ne_length;
        END IF;
        IF v_ne_no_start IS NULL THEN
           v_ne_no_start := c1rec.ne_no_start;
        END IF;
        IF v_ne_no_end IS NULL THEN
           v_ne_no_end := c1rec.ne_no_end;
        END IF;
        IF v_ne_type IS NULL THEN
           v_ne_type := c1rec.ne_type;
        END IF;
        IF v_ne_nt_type IS NULL THEN
           v_ne_nt_type := c1rec.ne_nt_type;
        END IF;
        IF v_ne_descr IS NULL THEN
           v_ne_descr := c1rec.ne_descr;
        END IF;
        IF v_ne_admin_unit IS NULL THEN
           v_ne_admin_unit := c1rec.ne_admin_unit;
        END IF;
        IF v_ne_gty_group_type IS NULL THEN
           v_ne_gty_group_type := c1rec.ne_gty_group_type;
        END IF;


        -- create the new element
        nm3net.insert_element( p_ne_id => p_ne_id_new,
                               p_ne_unique => v_ne_unique,
                               p_ne_length => v_ne_length,
                               p_ne_start_date => p_effective_date,
                               p_ne_no_start => v_ne_no_start,
                               p_ne_no_end => v_ne_no_end,
                               p_ne_type => v_ne_type,
                               p_ne_nt_type => v_ne_nt_type,
                               p_ne_descr => v_ne_descr,
                               p_ne_admin_unit => v_ne_admin_unit,
                               p_ne_gty_group_type => v_ne_gty_group_type,
                               p_ne_owner => v_ne_owner,
                               p_ne_name_1 => v_ne_name_1,
                               p_ne_name_2 => v_ne_name_2,
                               p_ne_prefix => v_ne_prefix,
                               p_ne_number => v_ne_number,
                               p_ne_sub_type => v_ne_sub_type,
                               p_ne_group => v_ne_group,
                               p_ne_sub_class => v_ne_sub_class,
                               p_ne_nsg_ref => v_ne_nsg_ref,
                               p_ne_version_no => v_ne_version_no,
                               p_auto_include => 'N'
                             );
      END LOOP;
--
      DECLARE
         l_rec_neh nm_element_history%ROWTYPE;
      BEGIN
         l_rec_neh.neh_ne_id_old      := p_ne_id;
         l_rec_neh.neh_ne_id_new      := p_ne_id_new;
         l_rec_neh.neh_operation      := 'R';
         l_rec_neh.neh_effective_date := p_effective_date;
         l_rec_neh.neh_old_ne_length  := l_orig_ne_length;
         l_rec_neh.neh_new_ne_length  := v_ne_length;
         l_rec_neh.neh_descr          := p_neh_descr; --CWS 0108990 12/03/2010
         
         nm3nw_edit.ins_neh(l_rec_neh); --CWS 0108990 12/03/2010
      END;
   END;
--
------------------------------------------------------------------------------------------------
--
   PROCEDURE replace_group_members( p_ne_id     nm_elements.ne_id%TYPE
                                   ,p_ne_id_new nm_elements.ne_id%TYPE
                                   ,p_effective_date DATE DEFAULT SYSDATE
                                  )
   IS
   BEGIN
      -- replace the existing nm_members on the new element
      INSERT INTO nm_members ( nm_ne_id_in
                              ,nm_ne_id_of
                              ,nm_begin_mp
                              ,nm_start_date
                              ,nm_end_date
                              ,nm_end_mp
                              ,nm_slk
                              ,nm_cardinality
                              ,nm_admin_unit
                              ,nm_seq_no
                              ,nm_type
                              ,nm_obj_type
                              ,nm_seg_no
                              ,nm_true
                               )
                       SELECT  nm_ne_id_in
                              ,p_ne_id_new
                              ,nm_begin_mp
                              ,p_effective_date
                              ,NULL
                              ,nm_end_mp
                              ,nm_slk
                              ,nm_cardinality
                              ,nm_admin_unit
                              ,nm_seq_no
                              ,nm_type
                              ,nm_obj_type
                              ,nm_seg_no
                              ,nm_true
                       FROM nm_members
                       WHERE nm_ne_id_of = p_ne_id
                         AND nm_type = 'G';

      -- set the end date on the old members
      nm3merge.end_date_members (p_nm_ne_id_of_old => p_ne_id
                                ,p_nm_ne_id_of_new => p_ne_id_new
                                ,p_effective_date  => p_effective_date
                                ,p_nm_type         => 'G'
                                );
--      UPDATE nm_members
--      SET nm_end_date = p_effective_date
--      WHERE nm_ne_id_of = p_ne_id
--        AND nm_type = 'G';

   END;
--
------------------------------------------------------------------------------------------------
--
   FUNCTION check_inv_items_replaceable( p_ne_id nm_elements.ne_id%TYPE )
   RETURN BOOLEAN
   IS

   CURSOR c1 (c_ne_id nm_elements.ne_id%TYPE) IS
      SELECT 1
      FROM  nm_inv_types
           ,nm_inv_items
      WHERE nit_inv_type = iit_inv_type
        AND nit_replaceable = 'N'
        AND iit_ne_id IN (SELECT nm_ne_id_in
                          FROM  nm_members
                          WHERE nm_ne_id_of = c_ne_id
                            AND nm_type != 'G');

   dummy  NUMBER := 0;
   retval BOOLEAN := FALSE;
   BEGIN
      OPEN c1(p_ne_id);
      FETCH c1 INTO dummy;
      IF c1%NOTFOUND THEN
         -- no inv types found with replaceable set to N
         retval := TRUE ;
      ELSE
         -- at least one inv type found that has replaceable set to N
         RAISE_APPLICATION_ERROR(-20800,'Element has inv items that are not replaceable');
      END IF;
      CLOSE c1;
      RETURN retval;
   END;
--
------------------------------------------------------------------------------------------------
--
   PROCEDURE replace_inv_members ( p_ne_id     nm_elements.ne_id%TYPE
                                  ,p_ne_id_new nm_elements.ne_id%TYPE
                                  ,p_effective_date DATE DEFAULT SYSDATE
                                 )
   IS
   BEGIN
      -- replace the existing nm_members on the new element
      INSERT INTO nm_members ( nm_ne_id_in
                              ,nm_ne_id_of
                              ,nm_begin_mp
                              ,nm_start_date
                              ,nm_end_date
                              ,nm_end_mp
                              ,nm_slk
                              ,nm_cardinality
                              ,nm_admin_unit
                              ,nm_seq_no
                              ,nm_type
                              ,nm_obj_type
                              ,nm_seg_no
                              ,nm_true )
                       SELECT  nm_ne_id_in
                              ,p_ne_id_new
                              ,nm_begin_mp
                              ,p_effective_date
                              ,nm_end_date
                              ,nm_end_mp
                              ,nm_slk
                              ,nm_cardinality
                              ,nm_admin_unit
                              ,nm_seq_no
                              ,nm_type
                              ,nm_obj_type
                              ,nm_seg_no
                              ,nm_true
                       FROM nm_members
                       WHERE nm_ne_id_of = p_ne_id
                         AND nm_type = 'I';

      -- set the end date on the old members
      nm3merge.end_date_members (p_nm_ne_id_of_old => p_ne_id
                                ,p_nm_ne_id_of_new => p_ne_id_new
                                ,p_effective_date  => p_effective_date
                                ,p_nm_type         => 'I'
                                );
--      UPDATE nm_members
--      SET nm_end_date = p_effective_date
--      WHERE nm_ne_id_of = p_ne_id
--        AND nm_type = 'I';


   END;
--
------------------------------------------------------------------------------------------------
--
   PROCEDURE replace_other_products ( p_ne_id nm_elements.ne_id%TYPE
                                     ,p_ne_id_new nm_elements.ne_id%TYPE
	        					     ,p_effective_date nm_elements.ne_start_date%TYPE
								     )
   IS
    cr constant varchar2(1) := chr(10);
   BEGIN


	  -- Check if structures is installed and do replace structures
      IF hig.is_product_licensed( 'STR' ) THEN
	     -- do str replace
		 EXECUTE IMMEDIATE
		    'BEGIN' || CHR(10) ||
        	'	 Strrepl.replace_data( :p_ne_id_new' || CHR(10) ||
			'				          ,:p_ne_id' || CHR(10) ||
		    '    					  ,:p_effective_date' || CHR(10) ||
			'	        		     );' || CHR(10) ||
            ' END;'
			 USING IN p_ne_id_new
					 ,p_ne_id
                     ,p_effective_date
					 ;
	  END IF;



	  -- Check if accidents is installed and do replace accidents
      IF hig.is_product_licensed( 'ACC' ) THEN
		 EXECUTE IMMEDIATE
		    'BEGIN' || CHR(10) ||
        	'	 accreplace.do_replace( :p_ne_id_new' || CHR(10) ||
			'				           ,:p_ne_id' || CHR(10) ||
		    '    					   ,:p_effective_date' || CHR(10) ||
			'	        		      );' || CHR(10) ||
            ' END;'
			 USING IN p_ne_id_new
					 ,p_ne_id
                     ,p_effective_date
					 ;
	  END IF;

	  
	  -- Check if MAI is installed and do replace 
      IF hig.is_product_licensed( 'MAI' ) THEN
	     -- do str replace
		 EXECUTE IMMEDIATE
		    'BEGIN' || CHR(10) ||
        	'	 mairepl.replace_data( :p_ne_id_new' || CHR(10) ||
			'				          ,:p_ne_id' || CHR(10) ||
		    '    					  ,:p_effective_date' || CHR(10) ||
			'	        		     );' || CHR(10) ||
            ' END;'
			 USING IN p_ne_id_new
					 ,p_ne_id
                     ,p_effective_date
					 ;
	  END IF;
    
    
    -- Schemes
    if hig.is_product_licensed(nm3type.c_stp) then
      execute immediate
            'begin'
      ||cr||'  stp_network_ops.do_replace('
      ||cr||'     pi_ne_id_new => :p_ne_id_new'
      ||cr||'    ,pi_ne_id_old => :p_ne_id'
      ||cr||'    ,pi_effective_date => :p_effective_date'
      ||cr||'  );'
      ||cr||'end;'
      using p_ne_id_new, p_ne_id, p_effective_date;
      
    end if;    
    
      -- Check if UKPMS is installed and do replace 
      IF hig.is_product_licensed(nm3type.c_ukp) THEN
      
         -- do ukpms replace
         EXECUTE IMMEDIATE
            'BEGIN' || CHR(10) ||
            '     ukprepl.replace( p_original_rse => :p_ne_id' || CHR(10) ||
            '                     ,p_new_rse      => :p_ne_id_new' || CHR(10) ||
            '                    );' || CHR(10) ||
            ' END;'
             USING IN p_ne_id
                     ,p_ne_id_new;

      END IF;
	  
   END replace_other_products;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE check_other_products 
                    (p_ne_id_1           IN nm_elements.ne_id%TYPE
					,p_ne_id_2           IN nm_elements.ne_id%TYPE
					,p_sect_no			 IN VARCHAR2 DEFAULT NULL
					,p_effective    	 IN DATE
					,p_errors           OUT NUMBER
                    ,p_err_text         OUT VARCHAR2
					) IS
					
   l_block    VARCHAR2(32767);
   
BEGIN
--
  
   nm_debug.proc_start(g_package_name,'check_other_products');
--
  -- Check if MM is installed and check for data
   IF hig.is_product_licensed(nm3type.c_mai)
    THEN
--	
      
--	
      l_block :=            'BEGIN'
                 ||CHR(10)||'    mairepl.check_data'
                 ||CHR(10)||'              (p_rse_he_id_1    => :p_ne_id_1'
                 ||CHR(10)||'              ,p_rse_he_id_2    => :p_ne_id_2'
                 ||CHR(10)||'              ,p_sect_no        => :p_sect_no'				 
                 ||CHR(10)||'              ,p_effective_date => :p_effective'
				 ||CHR(10)||'              ,p_errors         => :p_errors'
				 ||CHR(10)||'              ,p_error_string   => :p_err_text'
                 ||CHR(10)||'              );'
                 ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_block
       USING IN p_ne_id_1
	   		   ,p_ne_id_2
               ,p_sect_no
               ,p_effective
	    ,IN OUT p_errors
		,IN OUT p_err_text;			   
--		   
	 
--
  END IF;
--
   nm_debug.proc_end(g_package_name,'check_other_products');
  
--
END check_other_products;
--
------------------------------------------------------------------------------------------------
--
   -- Do the replace
   PROCEDURE do_replace( p_ne_id nm_elements.ne_id%TYPE
                        ,p_ne_id_new IN OUT nm_elements.ne_id%TYPE
                        ,p_effective_date DATE DEFAULT SYSDATE
                        ,p_ne_unique nm_elements.ne_unique%TYPE DEFAULT NULL
                        ,p_ne_type nm_elements.ne_type%TYPE DEFAULT NULL
                        ,p_ne_nt_type nm_elements.ne_nt_type%TYPE DEFAULT NULL
                        ,p_ne_descr nm_elements.ne_descr%TYPE DEFAULT NULL
                        ,p_ne_length nm_elements.ne_length%TYPE DEFAULT NULL
                        ,p_ne_admin_unit nm_elements.ne_admin_unit%TYPE DEFAULT NULL
                        ,p_ne_gty_group_type nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                        ,p_ne_owner nm_elements.ne_owner%TYPE DEFAULT NULL
                        ,p_ne_name_1 nm_elements.ne_name_1%TYPE DEFAULT NULL
                        ,p_ne_name_2 nm_elements.ne_name_2%TYPE DEFAULT NULL
                        ,p_ne_prefix nm_elements.ne_prefix%TYPE DEFAULT NULL
                        ,p_ne_number nm_elements.ne_number%TYPE DEFAULT NULL
                        ,p_ne_sub_type nm_elements.ne_sub_type%TYPE DEFAULT NULL
                        ,p_ne_group nm_elements.ne_group%TYPE DEFAULT NULL
                        ,p_ne_no_start nm_elements.ne_no_start%TYPE DEFAULT NULL
                        ,p_ne_no_end nm_elements.ne_no_end%TYPE DEFAULT NULL
                        ,p_ne_sub_class nm_elements.ne_sub_class%TYPE DEFAULT NULL
                        ,p_ne_nsg_ref nm_elements.ne_nsg_ref%TYPE DEFAULT NULL
                        ,p_ne_version_no nm_elements.ne_version_no%TYPE DEFAULT NULL
                        ,p_neh_descr nm_element_history.neh_descr%TYPE DEFAULT NULL --CWS 0108990 12/03/2010
                       )
   IS
      c_ausec_status CONSTANT VARCHAR2(3) := nm3ausec.get_status;

   --
   v_errors                NUMBER;
   v_err_text              VARCHAR2(10000);
   --

   --
      PROCEDURE set_for_return IS
      BEGIN
         nm3ausec.set_status(c_ausec_status);
         nm3merge.set_nw_operation_in_progress(FALSE);
      END set_for_return;
   BEGIN
--
      nm_debug.proc_start(g_package_name , 'do_replace');
     
      nm3ausec.set_status(nm3type.c_off);
      nm3merge.set_nw_operation_in_progress;
--
      -- Clear out the NM_MEMBER_HISTORY variables
      nm3merge.clear_nmh_variables;
--
      nm3lock.lock_element_and_members( p_ne_id );
--
      nm3nwval.network_operations_check( nm3nwval.c_replace
                                        ,p_ne_id_1 => p_ne_id
                                        ,p_ne_id_2 => p_ne_id_new
                                        ,p_effective_date => p_effective_date
                                       );
--

   -- NM - Add check here for other products
   check_other_products ( p_ne_id_1        => p_ne_id
                         ,p_ne_id_2        => null
                         ,p_sect_no        => null
				 ,p_effective      => p_effective_date
                         ,p_errors         => v_errors
     				 ,p_err_text       => v_err_text
    				    );
 
   IF v_err_text IS NOT NULL
    THEN
       hig.raise_ner(pi_appl               => nm3type.c_mai
                    ,pi_id                 => 3
                    ,pi_supplementary_info => v_err_text
                     );
   END IF;
--
--      if check_inv_items_replaceable( p_ne_id ) then
         create_new_element( p_ne_id
                            ,p_ne_id_new
                            ,p_effective_date
                            ,p_ne_unique
                            ,p_ne_type
                            ,p_ne_nt_type
                            ,p_ne_descr
                            ,p_ne_length
                            ,p_ne_admin_unit
                            ,p_ne_gty_group_type
                            ,p_ne_owner
                            ,p_ne_name_1
                            ,p_ne_name_2
                            ,p_ne_prefix
                            ,p_ne_number
                            ,p_ne_sub_type
                            ,p_ne_group
                            ,p_ne_no_start
                            ,p_ne_no_end
                            ,p_ne_sub_class
                            ,p_ne_nsg_ref
                            ,p_ne_version_no
                            ,p_neh_descr --CWS 0108990 12/03/2010
                           );
       -- CWS 0111024 lateral offset changes.
      IF NVL(hig.get_sysopt('XSPOFFSET'),'N') = 'Y'
      THEN
           EXECUTE IMMEDIATE 'BEGIN ' ||
                             'xncc_herm_xsp.populate_herm_xsp( p_ne_id          => :p_ne_id ' || 
                                                            ', p_ne_id_new      => :p_ne_id_new ' ||
                                                            ', p_effective_date => :p_effective_date ' ||
                                                            '); ' || 
                             'END;' USING p_ne_id, p_ne_id_new, p_effective_date;
      END IF;
   /* nm3sdo.change_affected_shapes (p_layer      => g_nth.nth_theme_id,
                                   p_ne_id      => p_ne_id_new);*/
       /*IF HIG.GET_SYSOPT(
       EXECUTE IMMEDIATE 'xncc_herm_xsp.populate_herm_xsp( p_ne_id => p_ne_id 
                                                         , p_ne_id_new => p_ne_id_new
                                                         , p_effective_date => p_effective_date
                                                         );'*/

       --RAC - Replicate the shape of the original element.
       --AE - added code
         nm3sdm.replace_element_shape
                              (p_ne_id_old => p_ne_id
                             , p_ne_id_new => p_ne_id_new);

         replace_group_members( p_ne_id
                               ,p_ne_id_new
                               ,p_effective_date
                              );

         replace_inv_members( p_ne_id
                             ,p_ne_id_new
                             ,p_effective_date
                            );
 
	     replace_other_products ( p_ne_id
                                 ,p_ne_id_new
	        					 ,p_effective_date
							    );
                                
         IF nm3nwad.ad_data_exist(p_ne_id) THEN
     
            nm3nwad.do_ad_replace( p_ne_id
                                 , p_ne_id_new
                                 );
            
         END IF;                         
  
         end_date_element ( p_ne_id
                           ,p_effective_date
                          );
        
        
     -- end if;
     -- Insert the stored NM_MEMBER_HISTORY records   
        nm3merge.ins_nmh;
--
      set_for_return;
      nm_debug.proc_end(g_package_name , 'do_replace');

     EXCEPTION
        WHEN OTHERS THEN
           set_for_return;
           RAISE;
   END;
--
------------------------------------------------------------------------------------------------
--
   PROCEDURE do_geo_replace( p_ne_id nm_elements.ne_id%TYPE
                        ,p_ne_id_new IN nm_elements.ne_id%TYPE
                        ,p_effective_date DATE DEFAULT SYSDATE
                        ,p_ne_unique nm_elements.ne_unique%TYPE DEFAULT NULL
                        ,p_ne_type nm_elements.ne_type%TYPE DEFAULT NULL
                        ,p_ne_nt_type nm_elements.ne_nt_type%TYPE DEFAULT NULL
                        ,p_ne_descr nm_elements.ne_descr%TYPE DEFAULT NULL
                        ,p_ne_length nm_elements.ne_length%TYPE DEFAULT NULL
                        ,p_ne_admin_unit nm_elements.ne_admin_unit%TYPE DEFAULT NULL
                        ,p_ne_gty_group_type nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                        ,p_ne_owner nm_elements.ne_owner%TYPE DEFAULT NULL
                        ,p_ne_name_1 nm_elements.ne_name_1%TYPE DEFAULT NULL
                        ,p_ne_name_2 nm_elements.ne_name_2%TYPE DEFAULT NULL
                        ,p_ne_prefix nm_elements.ne_prefix%TYPE DEFAULT NULL
                        ,p_ne_number nm_elements.ne_number%TYPE DEFAULT NULL
                        ,p_ne_sub_type nm_elements.ne_sub_type%TYPE DEFAULT NULL
                        ,p_ne_group nm_elements.ne_group%TYPE DEFAULT NULL
                        ,p_ne_no_start nm_elements.ne_no_start%TYPE DEFAULT NULL
                        ,p_ne_no_end nm_elements.ne_no_end%TYPE DEFAULT NULL
                        ,p_ne_sub_class nm_elements.ne_sub_class%TYPE DEFAULT NULL
                        ,p_ne_nsg_ref nm_elements.ne_nsg_ref%TYPE DEFAULT NULL
                        ,p_ne_version_no nm_elements.ne_version_no%TYPE DEFAULT NULL
                       )
   IS
      v_ne_id_new  nm_elements.ne_id%TYPE := p_ne_id_new;
   BEGIN
             do_replace( p_ne_id
                        ,v_ne_id_new
                        ,p_effective_date
                        ,p_ne_unique
                        ,p_ne_type
                        ,p_ne_nt_type
                        ,p_ne_descr
                        ,p_ne_length
                        ,p_ne_admin_unit
                        ,p_ne_gty_group_type
                        ,p_ne_owner
                        ,p_ne_name_1
                        ,p_ne_name_2
                        ,p_ne_prefix
                        ,p_ne_number
                        ,p_ne_sub_type
                        ,p_ne_group
                        ,p_ne_no_start
                        ,p_ne_no_end
                        ,p_ne_sub_class
                        ,p_ne_nsg_ref
                        ,p_ne_version_no
                       );

   END;
--
------------------------------------------------------------------------------------------------
--

END nm3replace;
/
