CREATE OR REPLACE PACKAGE BODY NM3MRG_SDO AS
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3mrg_sdo.pkb-arc   2.3   Jul 04 2013 16:16:06   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3mrg_sdo.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:16:06  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:16  $
--       PVCS Version     : $Revision:   2.3  $ 
--       Based on SCCS Version     : 1.4
--
--   Author : Rob Coupe
--
--   Merge Query SDO package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
/* History
  04.06.09  PT in create_spatial_mrg_view() removed the RULE hint
*/

   g_body_sccsid     constant  varchar2(200) := '"$Revision:   2.3  $"';

-----------------------------------------------------------------------------


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

procedure generate_mrg_datum_sdo ( p_mrg_job in number ) is

cursor c1 ( c_job_id in number )is
  select nsm_mrg_section_id, nsm_ne_id, nsm_begin_mp, nsm_end_mp, nnth_nth_theme_id
  from nm_mrg_sections_all, nm_mrg_section_members, nm_elements_all, nm_linear_types, nm_nw_themes
  where nsm_mrg_job_id = c_job_id
  and nms_mrg_job_id = c_job_id
  and nms_mrg_section_id = nsm_mrg_section_id
  and nsm_ne_id = ne_id
  and ne_nt_type = nlt_nt_type
  and nlt_g_i_d = 'D'
  and nlt_id = nnth_nlt_id
  order by 1;

l_member_id	 nm3type.tab_number;
l_section_id nm3type.tab_number;
l_ne_id		 nm3type.tab_number;
l_begin_mp	 nm3type.tab_number;
l_end_mp	 nm3type.tab_number;
l_nth_id	 nm3type.tab_number;

l_geometry   mdsys.sdo_geometry;

l_diminfo    mdsys.sdo_dim_array := nm3sdo.get_table_diminfo( 'NM_MRG_GEOMETRY', 'NMG_GEOMETRY');

l_themes 	 nm3type.tab_number;
l_table  	 nm3type.tab_varchar30;

l_section_sav number := -1;

l_seq_id     integer;

l_empty      Boolean := TRUE;

begin

   delete from nm_mrg_geometry
   where nmg_job_id = p_mrg_job;

   nm_debug.debug_on;

   open c1( p_mrg_job );

   fetch c1 bulk collect into l_section_id, l_ne_id, l_begin_mp, l_end_mp, l_nth_id;

   close c1;

-- nm_debug.debug('fetched '||to_char(l_section_id.count));

   for i in 1..l_section_id.count loop

     begin

        if i > 1 and l_section_sav = l_section_id(i) then
--
          nm3sdo.add_segments( l_geometry, nm3sdo.get_layer_fragment_geometry( l_nth_id(i), l_ne_id(i), l_begin_mp(i), l_end_mp(i)), l_diminfo);

        else

--
		  if not l_empty then

            SELECT nms_id_seq.NEXTVAL INTO l_seq_id FROM dual;

            INSERT INTO NM_MRG_GEOMETRY (
              NMG_JOB_ID, NMG_SECTION_ID, NMG_GEOMETRY, NMG_ID)
            VALUES ( p_mrg_job, l_section_sav, l_geometry, l_seq_id );

			l_empty := TRUE;

		  end if;

          l_geometry := nm3sdo.get_layer_fragment_geometry( l_nth_id(i), l_ne_id(i), l_begin_mp(i), l_end_mp(i));

		  if l_geometry.sdo_gtype is not null then
		    l_empty := FALSE;
		  end if;

		  l_section_sav := l_section_id(i);

		end if;

     exception
	    when others then

		  nm_debug.debug( 'failed at member = '||to_char( l_member_id(i)));

     end;

   end loop;

   if not l_empty then

     SELECT nms_id_seq.NEXTVAL INTO l_seq_id FROM dual;

     INSERT INTO NM_MRG_GEOMETRY (
              NMG_JOB_ID, NMG_SECTION_ID, NMG_GEOMETRY, NMG_ID)
     VALUES ( p_mrg_job, l_section_sav, l_geometry, l_seq_id );

   end if;

end;

-----------------------------------------------------------------------------


procedure create_all_mrg_geometry is

  cursor c1 is
    select nsm_mrg_job_id, count(*) from nm_mrg_section_members
    group by nsm_mrg_job_id;

begin

  for irec in c1 loop

   	generate_mrg_datum_sdo( irec.nsm_mrg_job_id );

  end loop;

end;


-----------------------------------------------------------------------------



procedure create_spatial_mrg_view ( p_mrg_query_id in number ) is

curstr varchar2(20000);
vname  varchar2(30);

begin

  vname := nm3mrg_view.get_mrg_view_name_by_qry_id( p_mrg_query_id );

  curstr := 'CREATE or replace VIEW '||vname||'_SDO'||' as '||
             ' SELECT '||
       'g.nmg_id, b.* '||
	   ' ,g.nmg_geometry '||
       ' FROM  '||vname||'_VAL b, '||
  	   ' nm_mrg_geometry g '||
       ' WHERE b.nms_mrg_job_id     = g.nmg_job_id '||
       ' AND  b.nms_mrg_section_id = g.nmg_section_id ';

nm_debug.debug_on;
nm_debug.debug( curstr );


   nm3ddl.create_object_and_syns( vname||'_SDO', curstr );

end;


-----------------------------------------------------------------------------

procedure create_all_spatial_mrg_views is

cursor get_query_ids is
  select nmq_id
  from nm_mrg_query_all;

l_qry_tab nm3type.tab_number;

begin

  open get_query_ids;
  fetch get_query_ids bulk collect into l_qry_tab;
  close get_query_ids;

  for i in 1.. l_qry_tab.count loop

    create_spatial_mrg_view( l_qry_tab(i));

  end loop;

end;

-----------------------------------------------------------------------------

function get_mrg_dynamic_theme_query ( p_mrg_job_id in number, p_attrib_name in varchar2 default null ) return varchar2 is

curstr  nm3type.max_varchar2;

curlist nm3type.max_varchar2;

curtab  varchar2(30);

function get_list( p_table in varchar2, p_attribute in varchar2)  return varchar2 is

  cursor c1 ( c_table in varchar2, c_column in varchar2 ) is
    select column_name, data_type
    from user_tab_columns
    where table_name = c_table
    order by decode( data_type, 'SDO_GEOMETRY',1, 2), decode( column_name, nvl(c_column, nm3type.c_nvl), 1, 2), column_id;

col_tab   nm3type.tab_varchar30;
datyp_tab nm3type.tab_varchar30;

retlist nm3type.max_varchar2 := null;

begin

  open c1 ( p_table, p_attribute );
  fetch c1 bulk collect into col_tab, datyp_tab;
  close c1;


  nm_debug.debug(' data found - start with '||col_tab(1));

  retlist := col_tab(1);

  if p_attrib_name is not null then

      retlist := retlist||','||col_tab(2);

  else

	  retlist := retlist||','||'1';

  end if;

  return retlist;

end;

begin

  curtab :=  nm3mrg_view.get_mrg_view_name_by_job_id( p_mrg_job_id)||'_SDO';

  curlist := get_list( curtab, p_attrib_name);

  curstr := 'select '||curlist||' from '||curtab||' where '||
            ' nms_mrg_job_id = '||to_char( p_mrg_job_id);

  return curstr;

end;


procedure create_gdo_from_job ( p_session_id in number, p_job_id in number, p_attrib_name in varchar2 default null, p_theme_name in varchar2 default null ) is

l_theme_name gis_data_objects.gdo_theme_name%type := 'MRG_RESULTS';

begin

  if p_theme_name is not null then
    l_theme_name := p_theme_name;
  end if;

  insert into gis_data_objects
  ( gdo_session_id, gdo_pk_id, gdo_theme_name, gdo_dynamic_theme, gdo_string )
  select p_session_id, p_job_id, l_theme_name, 'Y', nm3mrg_sdo.get_mrg_dynamic_theme_query(p_job_id, p_attrib_name )
  from dual;

end;


function mrg_geometry_exists ( p_mrg_job_id in number ) return Boolean is
retval Boolean := FALSE;
cursor c1 ( c_mrg_job_id in number ) is
  select 1 from dual
  where exists ( select 1 from nm_mrg_geometry
                 where nmg_job_id = c_mrg_job_id );
l_dummy number;

begin

  open c1( p_mrg_job_id );
  fetch c1 into l_dummy;
  retval := c1%found;
  close c1;

  return retval;

end;

--
-------------------------------------------------------------------------------------------------------------------------------
--

procedure register_mrg_view_as_theme ( p_mrg_query_id in number ) is
v_name    varchar2(30) := nm3mrg_view.get_mrg_view_name_by_qry_id( p_mrg_query_id );
l_nth     nm_themes_all.nth_theme_id%type;
l_tol     number;
l_diminfo mdsys.sdo_dim_array;

begin

  l_nth := nm3sdm.get_theme_from_feature_table('NM_MRG_GEOMETRY');

  if l_nth is not null then

    l_diminfo := nm3sdo.get_theme_diminfo( l_nth );

	l_tol := l_diminfo(1).sdo_tolerance;

  else

    Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                   pi_id           => 194,
                   pi_sqlcode      => -20001
                  );
  end if;

  nm3sdo.register_sdo_table_as_theme(v_name||'_SDO', 'NMG_ID', NULL, 'NMG_GEOMETRY', l_tol );

end;

end;
/
