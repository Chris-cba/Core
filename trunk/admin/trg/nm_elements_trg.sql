/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE TRIGGER a_ins_nm_elements
       AFTER  INSERT
       ON     nm_elements_all
       FOR    EACH ROW
DECLARE
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_elements_trg.sql-arc   2.5   Jul 04 2013 09:53:20   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_elements_trg.sql  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:53:20  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:35:32  $
--       SCCS Version     : $Revision:   2.5  $
--       Based on 
--       Based on 1.11
--
--      TRIGGER a_ins_nm_elements
--       AFTER  INSERT
--       ON     NM_ELEMENTS_ALL
--       FOR    EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_tab_nnu_no_node_id nm3type.tab_number;
   l_tab_nnu_ne_id      nm3type.tab_number;
   l_tab_nnu_node_type  nm3type.tab_varchar4;
   l_tab_nnu_chain      nm3type.tab_number;
   l_tab_nnu_leg_no     nm3type.tab_number;
   l_tab_nnu_start_date nm3type.tab_date;
   l_tab_nnu_end_date   nm3type.tab_date;
--
BEGIN
   IF   :NEW.ne_no_start IS NOT NULL
    AND :NEW.ne_length   IS NOT NULL
    THEN
--
      l_tab_nnu_no_node_id(1) := :NEW.ne_no_start;
      l_tab_nnu_ne_id(1)      := :NEW.ne_id;
      l_tab_nnu_node_type(1)  := 'S';
      l_tab_nnu_chain(1)      := 0;
      l_tab_nnu_leg_no(1)     := 9;
      l_tab_nnu_start_date(1) := :NEW.ne_start_date;
      l_tab_nnu_end_date(1)   := :NEW.ne_end_date;
--
      l_tab_nnu_no_node_id(2) := :NEW.ne_no_end;
      l_tab_nnu_ne_id(2)      := l_tab_nnu_ne_id(1);
      l_tab_nnu_node_type(2)  := 'E';
      l_tab_nnu_chain(2)      := :NEW.ne_length;
      l_tab_nnu_leg_no(2)     := l_tab_nnu_leg_no(1);
      l_tab_nnu_start_date(2) := l_tab_nnu_start_date(1);
      l_tab_nnu_end_date(2)   := l_tab_nnu_end_date(1);
--
      FORALL i IN 1..2
         INSERT INTO nm_node_usages
                  (nnu_no_node_id
                  ,nnu_ne_id
                  ,nnu_node_type
                  ,nnu_chain
                  ,nnu_leg_no
                  ,nnu_start_date
                  ,nnu_end_date
                  )
          VALUES  (l_tab_nnu_no_node_id(i)
                  ,l_tab_nnu_ne_id(i)
                  ,l_tab_nnu_node_type(i)
                  ,l_tab_nnu_chain(i)
                  ,l_tab_nnu_leg_no(i)
                  ,l_tab_nnu_start_date(i)
                  ,l_tab_nnu_end_date(i)
                  );

--
    END IF;
--
END a_ins_nm_elements;
/
/*<TOAD_FILE_CHUNK>*/


CREATE OR REPLACE TRIGGER b_upd_nm_elements
       BEFORE  UPDATE
       ON      nm_elements_all
       FOR     EACH ROW
DECLARE
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_elements_trg.sql-arc   2.5   Jul 04 2013 09:53:20   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_elements_trg.sql  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:53:20  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:35:32  $
--       SCCS Version     : $Revision:   2.5  $
--       Based on 
--       Based on 1.11
--
--     TRIGGER b_upd_nm_elements
--       BEFORE  UPDATE
--       ON      NM_ELEMENTS_ALL
--       FOR     EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   c_dummy_date CONSTANT date   := TO_DATE('01011801','DDMMYYYY');
   c_dummy_num  CONSTANT number := -1;

   l_old_ne_flex_cols_rec nm3nwval.t_ne_flex_cols_rec;
   l_new_ne_flex_cols_rec nm3nwval.t_ne_flex_cols_rec;
--
BEGIN
--
   IF :NEW.ne_no_start IS NOT NULL
    THEN -- If this has node usages
-- GJ 15-SEP-2006 706006 changed IF statement
--     IF :NEW.ne_no_start <> NVL(:NEW.ne_no_start,c_dummy_num)
      IF :NEW.ne_no_start <> NVL(:OLD.ne_no_start,c_dummy_num)
       THEN
         -- Update on change of NE_NO_START
         UPDATE nm_node_usages
          SET   nnu_no_node_id = :NEW.ne_no_start
         WHERE  nnu_ne_id      = :NEW.ne_id
          AND   nnu_node_type  = 'S';
      END IF;
   END IF;
   --
   IF :NEW.ne_no_end IS NOT NULL
    THEN
-- GJ 15-SEP-2006 706006 changed IF statement
--      IF :NEW.ne_no_end <> NVL(:NEW.ne_no_end,c_dummy_num)
      IF :NEW.ne_no_end <> NVL(:OLD.ne_no_end,c_dummy_num)
       THEN
         -- Update on change of NE_NO_END
         UPDATE nm_node_usages
          SET   nnu_no_node_id = :NEW.ne_no_end
               ,nnu_chain      = :NEW.ne_length
         WHERE  nnu_ne_id      = :NEW.ne_id
          AND   nnu_node_type  = 'E';
      END IF;
   END IF;
--
   IF NVL(:NEW.ne_end_date,c_dummy_date) <> NVL(:OLD.ne_end_date,c_dummy_date)
    THEN
      -- Update on change of NE_END_DATE
      UPDATE nm_node_usages_all
       SET   nnu_end_date = :NEW.ne_end_date
      WHERE  nnu_ne_id    = :NEW.ne_id;
   END IF;
--
   l_old_ne_flex_cols_rec.ne_owner      := :OLD.ne_owner;
   l_old_ne_flex_cols_rec.ne_name_1     := :OLD.ne_name_1;
   l_old_ne_flex_cols_rec.ne_name_2     := :OLD.ne_name_2;
   l_old_ne_flex_cols_rec.ne_prefix     := :OLD.ne_prefix;
   l_old_ne_flex_cols_rec.ne_number     := :OLD.ne_number;
   l_old_ne_flex_cols_rec.ne_sub_type   := :OLD.ne_sub_type;
   l_old_ne_flex_cols_rec.ne_sub_class  := :OLD.ne_sub_class;
   l_old_ne_flex_cols_rec.ne_nsg_ref    := :OLD.ne_nsg_ref;
   l_old_ne_flex_cols_rec.ne_version_no := :OLD.ne_version_no;
   l_old_ne_flex_cols_rec.ne_group      := :OLD.ne_group;

   l_new_ne_flex_cols_rec.ne_owner      := :NEW.ne_owner;
   l_new_ne_flex_cols_rec.ne_name_1     := :NEW.ne_name_1;
   l_new_ne_flex_cols_rec.ne_name_2     := :NEW.ne_name_2;
   l_new_ne_flex_cols_rec.ne_prefix     := :NEW.ne_prefix;
   l_new_ne_flex_cols_rec.ne_number     := :NEW.ne_number;
   l_new_ne_flex_cols_rec.ne_sub_type   := :NEW.ne_sub_type;
   l_new_ne_flex_cols_rec.ne_sub_class  := :NEW.ne_sub_class;
   l_new_ne_flex_cols_rec.ne_nsg_ref    := :NEW.ne_nsg_ref;
   l_new_ne_flex_cols_rec.ne_version_no := :NEW.ne_version_no;
   l_new_ne_flex_cols_rec.ne_group      := :NEW.ne_group;

   nm3nwval.check_ne_flex_cols_updatable(pi_ne_nt_type           => :NEW.ne_nt_type
                                        ,pi_old_ne_flex_cols_rec => l_old_ne_flex_cols_rec
                                        ,pi_new_ne_flex_cols_rec => l_new_ne_flex_cols_rec);

   nm3nwval.validate_element_for_update(p_ne_id                   => :NEW.ne_id
                                       ,p_ne_unique               => :NEW.ne_unique
                                       ,p_ne_type                 => :NEW.ne_type
                                       ,p_ne_nt_type              => :NEW.ne_nt_type
                                       ,p_ne_descr                => :NEW.ne_descr
                                       ,p_ne_length               => :NEW.ne_length
                                       ,p_ne_admin_unit           => :NEW.ne_admin_unit
                                       ,p_ne_start_date           => :NEW.ne_start_date
                                       ,p_ne_end_date             => :NEW.ne_end_date
                                       ,p_ne_gty_group_type       => :NEW.ne_gty_group_type
                                       ,p_ne_owner                => :NEW.ne_owner
                                       ,p_ne_name_1               => :NEW.ne_name_1
                                       ,p_ne_name_2               => :NEW.ne_name_2
                                       ,p_ne_prefix               => :NEW.ne_prefix
                                       ,p_ne_number               => :NEW.ne_number
                                       ,p_ne_sub_type             => :NEW.ne_sub_type
                                       ,p_ne_group                => :NEW.ne_group
                                       ,p_ne_no_start             => :NEW.ne_no_start
                                       ,p_ne_no_end               => :NEW.ne_no_end
                                       ,p_ne_sub_class            => :NEW.ne_sub_class
                                       ,p_ne_nsg_ref              => :NEW.ne_nsg_ref
                                       ,p_ne_version_no           => :NEW.ne_version_no
                                       );
--
END b_upd_nm_elements;
/
/*<TOAD_FILE_CHUNK>*/


CREATE OR REPLACE TRIGGER b_ins_nm_elements
       BEFORE  INSERT
       ON      nm_elements_all
       FOR     EACH ROW
BEGIN
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_elements_trg.sql-arc   2.5   Jul 04 2013 09:53:20   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_elements_trg.sql  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:53:20  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:35:32  $
--       SCCS Version     : $Revision:   2.5  $
--       Based on 
--       Based on 1.11
--
--   TRIGGER b_ins_nm_elements
--       BEFORE  INSERT
--       ON      NM_ELEMENTS_ALL
--       FOR     EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
  --MJA add 31-Aug-07
  --New functionality to allow override
  If Not nm3net.bypass_nm_elements_trgs
  Then 
    IF :NEW.ne_type != 'D' THEN
        nm3nwval.bfr_trigger_validate_element ( p_ne_id             =>:NEW.ne_id,
                                                p_ne_unique         =>:NEW.ne_unique,
                                                p_ne_type           =>:NEW.ne_type,
                                                p_ne_nt_type        =>:NEW.ne_nt_type,
                                                p_ne_descr          =>:NEW.ne_descr,
                                                p_ne_length         =>:NEW.ne_length,
                                                p_ne_admin_unit     =>:NEW.ne_admin_unit,
                                                p_ne_start_date     =>:NEW.ne_start_date,
                                                p_ne_end_date       =>:NEW.ne_end_date,
                                                p_ne_gty_group_type =>:NEW.ne_gty_group_type,
                                                p_ne_owner          =>:NEW.ne_owner,
                                                p_ne_name_1         =>:NEW.ne_name_1,
                                                p_ne_name_2         =>:NEW.ne_name_2,
                                                p_ne_prefix         =>:NEW.ne_prefix,
                                                p_ne_number         =>:NEW.ne_number,
                                                p_ne_sub_type       =>:NEW.ne_sub_type,
                                                p_ne_group          =>:NEW.ne_group,
                                                p_ne_no_start       =>:NEW.ne_no_start,
                                                p_ne_no_end         =>:NEW.ne_no_end,
                                                p_ne_sub_class      =>:NEW.ne_sub_class,
                                                p_ne_nsg_ref        =>:NEW.ne_nsg_ref,
                                                p_ne_version_no     =>:NEW.ne_version_no );
    END IF;
  End If;
END b_ins_nm_elements;
/
/*<TOAD_FILE_CHUNK>*/

CREATE OR REPLACE TRIGGER a_del_nm_elements
       AFTER   DELETE
       ON      nm_elements_all
       FOR     EACH ROW
DECLARE
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_elements_trg.sql-arc   2.5   Jul 04 2013 09:53:20   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_elements_trg.sql  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:53:20  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:35:32  $
--       SCCS Version     : $Revision:   2.5  $
--       Based on 
--
--     TRIGGER a_del_nm_elements
--       AFTER   DELETE
--       ON      NM_ELEMENTS_ALL
--       FOR     EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   no_spatial_exists EXCEPTION;
   PRAGMA EXCEPTION_INIT (no_spatial_exists,-20001);
--
   l_spatial_table  varchar2(30);
   l_spatial_pk_col varchar2(30);

   l_ref_table       varchar2(30);
   l_ref_column      varchar2(30);

   cursor get_theme ( c_nt_type in nm_elements_all.ne_nt_type%type,
                      c_gt_type in nm_elements_all.ne_gty_group_type%type ) is
     select nth_feature_table,
            nth_feature_pk_column
     from nm_themes_all, nm_nw_themes, nm_linear_types
     where nlt_nt_type = c_nt_type
     and   nvl(nlt_gty_type, nm3type.c_nvl ) = nvl( c_gt_type, nm3type.c_nvl )
     and nlt_g_i_d = 'D'
     and nnth_nlt_id = nlt_id
     and nnth_nth_theme_id = nth_theme_id
     and nth_base_table_theme IS NULL;

--
BEGIN


  IF NOT nm3net.bypass_nm_elements_trgs THEN

			   if :old.ne_type = 'S'  then
			
			     for irec in get_theme( :old.ne_nt_type, :old.ne_gty_group_type ) loop
			
			       begin
			
			         begin
			
			           select referenced_name, cc.column_name
			           into l_ref_table, l_ref_column
			           from user_dependencies, user_sdo_geom_metadata t, user_constraints c, user_cons_columns cc
			           where name = irec.nth_feature_table
			           and referenced_type = 'TABLE'
			           and t.table_name = referenced_name
			           and t.table_name = c.table_name
			           and c.constraint_type = 'P'
			           and cc.constraint_name = c.constraint_name
			           and cc.table_name = t.table_name;
			
			           l_spatial_table  := l_ref_table;
			           l_spatial_pk_col := l_ref_column;
			
			         exception
			           when no_data_found then
			             l_spatial_table  := irec.nth_feature_table;
			             l_spatial_pk_col := irec.nth_feature_pk_column;
			         end;
			--
			         EXECUTE IMMEDIATE 'DELETE FROM '||l_spatial_table||' WHERE '||l_spatial_pk_col||' = :ne_id' USING :OLD.ne_id;
			--
			       EXCEPTION
			       WHEN no_spatial_exists
			          THEN
			--
			--        If -20001 is raised, then we don't particularily care, because this means that there is no
			--        spatial table defined, hence we can't delete from it.
			--
			          NULL;
			
			       end;
			
			     end loop;
			   end if;
			   
  END IF;
  			   
end;
/

/*<TOAD_FILE_CHUNK>*/

CREATE OR REPLACE TRIGGER b_del_nm_elements
       BEFORE  DELETE
       ON      nm_elements_all
       FOR     EACH ROW
DECLARE
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_elements_trg.sql-arc   2.5   Jul 04 2013 09:53:20   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_elements_trg.sql  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:53:20  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:35:32  $
--       SCCS Version     : $Revision:   2.5  $
--       Based on 
--       Based on 1.11
--
--      TRIGGER  b_del_nm_elements
--       BEFORE  DELETE
--       ON      NM_ELEMENTS_ALL
--       FOR     EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   CURSOR cs_other_usages (p_ne_id    nm_node_usages_all.nnu_ne_id%TYPE
                          ,p_node_id  nm_node_usages_all.nnu_no_node_id%TYPE
                          ) IS
   SELECT COUNT(*)
    FROM  nm_node_usages_all
   WHERE  nnu_no_node_id =  p_node_id
    AND   nnu_ne_id      <> p_ne_id;
--
   l_count   binary_integer;
--
   l_node_id nm_nodes.no_node_id%TYPE := :OLD.ne_no_start;
   l_ne_id   nm_elements.ne_id%TYPE   := :OLD.ne_id;
--
   l_some_nodes boolean := FALSE;
--
BEGIN

  IF NOT nm3net.bypass_nm_elements_trgs THEN

			--
			   FOR l_dummy IN 1..2
			    LOOP -- Dummy loop so we don't duplicate the code
			--
			      IF l_node_id IS NOT NULL
			       THEN
			--
			         OPEN  cs_other_usages (l_ne_id, l_node_id);
			         FETCH cs_other_usages INTO l_count;
			         CLOSE cs_other_usages;
			--
			         IF l_count = 0
			          THEN
			            DELETE FROM nm_nodes_all
			            WHERE no_node_id = l_node_id;
			         END IF;
			--
			         l_some_nodes := TRUE;
			--
			      END IF;
			--
			      l_node_id := :OLD.ne_no_end;
			--
			   END LOOP;
			--
			   IF l_some_nodes
			    THEN
			      DELETE FROM nm_node_usages_all
			      WHERE nnu_ne_id = l_ne_id;
			   END IF;
			--
			
 END IF;			
END b_del_nm_elements;
/
/*<TOAD_FILE_CHUNK>*/
--
--ALTER TABLE nm_elements_all
--ADD CONSTRAINT ne_node_chk CHECK
--(DECODE(NE_NO_START,Null,0,1)+DECODE(NE_NO_END,Null,0,1) IN (0,2));
----
--ALTER TABLE nm_elements_all
--ADD CONSTRAINT ne_section_node_chk CHECK
--(DECODE(NE_TYPE,'S',1,'D',1,0)+DECODE(NE_NO_START,Null,0,1) IN (0,2));
--
