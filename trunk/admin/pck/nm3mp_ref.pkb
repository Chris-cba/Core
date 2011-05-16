CREATE OR REPLACE PACKAGE BODY nm3mp_ref AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3mp_ref.pkb-arc   2.3   May 16 2011 14:45:02   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3mp_ref.pkb  $
--       Date into PVCS   : $Date:   May 16 2011 14:45:02  $
--       Date fetched Out : $Modtime:   Apr 01 2011 13:52:38  $
--       PVCS Version     : $Revision:   2.3  $
--       Based on 1.1 of sccs --
--
--   Author : Kevin Angus
--
--   nm3mp_ref body
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
  g_body_sccsid  CONSTANT varchar2(2000) :='"$Revision:   2.3  $"';

  g_package_name CONSTANT varchar2(30) := 'nm3mp_ref';

  c_invalid_ref_type_err_appl constant nm_errors.ner_appl%type := nm3type.c_net;
  c_invalid_ref_type_err_id   constant nm_errors.ner_id%type := 444;
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
PROCEDURE validate_element(pi_ne_id in nm_elements.ne_id%type
                          ) IS

  l_ne_rec nm_elements%ROWTYPE;
  l_ngt_rec nm_group_types%ROWTYPE;

  l_item_valid boolean := FALSE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'validate_element');

	l_ne_rec := nm3net.get_ne(pi_ne_id => pi_ne_id);

	IF l_ne_rec.ne_type = 'G'
	THEN
	  l_ngt_rec := nm3get.get_ngt(pi_ngt_group_type => l_ne_rec.ne_gty_group_type);

	  IF l_ngt_rec.ngt_linear_flag = 'Y'
	  THEN
	    l_item_valid := TRUE;
	  END IF;
	END IF;

	IF NOT l_item_valid
	THEN
	  hig.raise_ner(pi_appl => nm3type.c_net
                 ,pi_id   => 443);
	END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'validate_element');

END validate_element;
--
-----------------------------------------------------------------------------
--
procedure validate_ref_type(pi_ref_type   in nm_inv_types.nit_inv_type%type
                           ,pi_group_type in nm_group_types.ngt_group_type%type
                           ) IS

  l_dummy pls_integer;

  l_type_valid boolean;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'validate_ref_type');

  begin
    select
      1
    into
      l_dummy
    from
      dual
    where
      exists (select
                nit.nit_inv_type,
                nit.nit_descr
              from
                nm_inv_types   nit,
                nm_inv_nw      nin,
                nm_nt_groupings nng
              where
                nit.nit_inv_type = pi_ref_type
              and
                nit.nit_pnt_or_cont = 'P'
              and
                nit.nit_category in ('I', 'F', 'D')
              and
                nng.nng_group_type = pi_group_type
              and
                nin.nin_nw_type = nng.nng_nt_type
              and
                nin.nin_nit_inv_code = nit.nit_inv_type);

    l_type_valid := true;

  exception
    when no_data_found
    then
      l_type_valid := false;

  end;

  if not l_type_valid
  then
    hig.raise_ner(pi_appl => c_invalid_ref_type_err_appl
                 ,pi_id   => c_invalid_ref_type_err_id);
  end if;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'validate_ref_type');

END validate_ref_type;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_ref_type(pi_ref_type in nm_inv_types.nit_inv_type%type
                           ,pi_route_id in nm_elements.ne_id%type
                           ) IS

  l_group_type nm_group_types.ngt_group_type%type;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'validate_ref_type');

  l_group_type := nm3net.get_gty_type(p_ne_id => pi_route_id);

  validate_ref_type(pi_ref_type   => pi_ref_type
                   ,pi_group_type => l_group_type);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'validate_ref_type');

END validate_ref_type;
--
-----------------------------------------------------------------------------
--
FUNCTION ref_type_is_valid(pi_ref_type   in nm_inv_types.nit_inv_type%type
                          ,pi_group_type in nm_group_types.ngt_group_type%type
                          ) RETURN boolean IS

  e_generic_error exception;
  pragma exception_init(e_generic_error, -20000);

  l_valid boolean;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'ref_type_is_valid');

  BEGIN
    validate_ref_type(pi_ref_type   => pi_ref_type
                     ,pi_group_type => pi_group_type);

    l_valid := TRUE;

  Exception
    when e_generic_error
    then
      if hig.check_last_ner(pi_appl => c_invalid_ref_type_err_appl
                           ,pi_id   => c_invalid_ref_type_err_id)
      then
        l_valid := FALSE;
      else
        raise;
      end if;

  end;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'ref_type_is_valid');

  RETURN l_valid;

END ref_type_is_valid;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_ref_item(pi_iit_ne_id in nm_inv_items.iit_ne_id%type
                           ,pi_route_id  in nm_elements.ne_id%type
                           ) IS

  l_iit_rec nm_inv_items%rowtype;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'validate_ref_item');

  if pi_iit_ne_id is not null
  then
    --get iit record, will also check item exists
    l_iit_rec := nm3get.get_iit(pi_iit_ne_id => pi_iit_ne_id);

    --check the type
--log number 710193- the code should pass in the ref type and not the ne_id
--    validate_ref_type(pi_ref_type => pi_iit_ne_id
--                     ,pi_route_id => pi_route_id);

    validate_ref_type(pi_ref_type => l_iit_rec.iit_inv_type
                     ,pi_route_id => pi_route_id);
  end if;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'validate_ref_item');

END validate_ref_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ref_item_location(pi_ref_item      in     nm_inv_items.iit_ne_id%type
                               ,po_location_lref    out nm_lref
                          ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_ref_item_location');

  select
    nm_lref(nm.nm_ne_id_of, nm.nm_begin_mp)
  into
    po_location_lref
  from
    nm_members nm
  where
    nm.nm_ne_id_in = pi_ref_item;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_ref_item_location');

EXCEPTION
  when no_data_found
  then
    hig.raise_ner(pi_appl => nm3type.c_hig
                 ,pi_id   => 177
                 ,pi_supplementary_info => 'IIT_NE_ID = ' || pi_ref_item);

  when too_many_rows
  then
    hig.raise_ner(pi_appl => nm3type.c_net
                 ,pi_id   => 445
                 ,pi_supplementary_info => 'IIT_NE_ID = ' || pi_ref_item);

END get_ref_item_location;
--
-----------------------------------------------------------------------------
--
FUNCTION get_route_offset_for_ref_item(pi_route_id in nm_elements.ne_id%type
                                      ,pi_ref_item in nm_inv_items.iit_ne_id%type
                                      ) RETURN number IS

  l_retval number;

  l_ref_item_location nm_lref;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_route_offset_for_ref_item');

  nm_debug.debug('get_route_offset_for_ref_item');

  get_ref_item_location(pi_ref_item      => pi_ref_item
                       ,po_location_lref => l_ref_item_location);

  nm_debug.debug('l_ref_item_location = ' || l_ref_item_location.lr_ne_id || ':' || l_ref_item_location.lr_offset);

  l_retval := nm3lrs.get_set_offset(p_ne_parent_id => pi_route_id
                                   ,p_ne_child_id  => l_ref_item_location.get_ne_id
                                   ,p_offset       => l_ref_item_location.get_offset);

  nm_debug.debug('route offset = ' ||l_retval );

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_route_offset_for_ref_item');

  RETURN l_retval;

END get_route_offset_for_ref_item;
--
-----------------------------------------------------------------------------
--
FUNCTION get_temp_ne_for_refs(pi_route_id         in nm_elements.ne_id%type
                             ,pi_start_ref_item   in nm_inv_items.iit_ne_id%type
                             ,pi_start_ref_offset in number
                             ,pi_end_ref_item     in nm_inv_items.iit_ne_id%type default null
                             ,pi_end_ref_offset   in number default null
                             ) RETURN nm_nw_temp_extents.nte_job_id%TYPE IS

  l_retval nm_nw_temp_extents.nte_job_id%TYPE;

  l_pl_arr nm_placement_array;

BEGIN
  --nm_debug.debug_on;

  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_temp_ne_for_refs');

  nm_debug.debug('getting pl');

  l_pl_arr := nm3mp_ref_o.get_pl_for_refs(pi_route_id         => pi_route_id
                                         ,pi_start_ref_item   => pi_start_ref_item
                                         ,pi_start_ref_offset => pi_start_ref_offset
                                         ,pi_end_ref_item     => pi_end_ref_item
                                         ,pi_end_ref_offset   => pi_end_ref_offset);

  nm_debug.debug('creating pl');

  nm3extent_o.create_temp_ne_from_pl(pi_pl_arr            => l_pl_arr
                                    ,po_job_id            => l_retval
                                    ,pi_default_parent_id => pi_route_id);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_temp_ne_for_refs');

  nm_debug.debug('returning job id');

  RETURN l_retval;

END get_temp_ne_for_refs;
--
-----------------------------------------------------------------------------
--
FUNCTION get_iit_by_type_and_label(pi_inv_type in nm_inv_types.nit_inv_type%TYPE
                                  ,pi_label    in varchar2
                                  ) RETURN nm_inv_items%rowtype IS

  l_retval nm_inv_items%rowtype;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_iit_by_type_and_label');

  select
    iit.*
  into
    l_retval
  from
    nm_inv_items iit
  where
    iit.iit_inv_type = pi_inv_type
  and
    iit.iit_descr = pi_label;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_iit_by_type_and_label');

  RETURN l_retval;

exception
  when no_data_found
  then
    hig.raise_ner(pi_appl => nm3type.c_hig
                 ,pi_id   => 67
                 ,pi_supplementary_info => 'NM_INV_ITEMS: iit_inv_type = ' || pi_inv_type
                                           || ', iit_descr = "' || pi_label || '"');

  when too_many_rows
  then
    hig.raise_ner(pi_appl => nm3type.c_hig
                 ,pi_id   => 6
                 ,pi_supplementary_info => 'NM_INV_ITEMS: iit_inv_type = ' || pi_inv_type
                                           || ', iit_descr = "' || pi_label || '"');

END get_iit_by_type_and_label;
--
-----------------------------------------------------------------------------
--
PROCEDURE locate_asset(pi_iit_ne_id        in nm_inv_items.iit_ne_id%type
                      ,pi_effective_date   IN DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                      ,pi_route_id         in nm_elements.ne_id%type
                      ,pi_start_ref_item   in nm_inv_items.iit_ne_id%type
                      ,pi_start_ref_offset in number
                      ,pi_end_ref_item     in nm_inv_items.iit_ne_id%type
                      ,pi_end_ref_offset   in number
                      ) is

  e_invalid_extent exception;

  e_no_permission  exception;

  l_inv_item_rec      nm_inv_items%ROWTYPE;
  l_inv_item_type_rec nm_inv_types%rowtype;

  l_temp_ne_job_id nm_nw_temp_extents.nte_job_id%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'locate_asset');

  nm3user.set_effective_date(p_date => pi_effective_date);

  l_inv_item_rec := nm3get.get_iit(pi_iit_ne_id => pi_iit_ne_id);

  l_inv_item_type_rec := nm3get.get_nit(pi_nit_inv_type => l_inv_item_rec.iit_inv_type);

  validate_element(pi_ne_id => pi_route_id);

  --check item updateable
  if not invsec.is_inv_item_updatable(p_iit_inv_type   => l_inv_item_rec.iit_inv_type
                                     ,p_iit_admin_unit => l_inv_item_rec.iit_admin_unit)
  then
    raise e_no_permission;
  end if;

  --get temp extent of desired location
  l_temp_ne_job_id := get_temp_ne_for_refs(pi_route_id         => pi_route_id
                                          ,pi_start_ref_item   => pi_start_ref_item
                                          ,pi_start_ref_offset => pi_start_ref_offset
                                          ,pi_end_ref_item     => pi_end_ref_item
                                          ,pi_end_ref_offset   => pi_end_ref_offset);

  --check temp ne valid for homo
  if not nm3extent.temp_ne_valid_for_homo(pi_job_id => l_temp_ne_job_id)
  then
    raise e_invalid_extent;
  end if;

  --do the location
  nm3homo.homo_update(p_temp_ne_id_in  => l_temp_ne_job_id
                     ,p_iit_ne_id      => pi_iit_ne_id
                     ,p_effective_date => pi_effective_date);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'locate_asset');

exception
  when e_no_permission
  THEN
    hig.raise_ner(pi_appl => nm3type.c_hig
                 ,pi_id   => 86);

  when e_invalid_extent
  then
    hig.raise_ner(pi_appl => nm3type.c_net
                 ,pi_id   => 128);

END locate_asset;
--
-----------------------------------------------------------------------------
--
PROCEDURE locate_asset(pi_iit_ne_id      in nm_inv_items.iit_ne_id%type
                      ,pi_effective_date IN DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                      ,pi_route_id       in nm_elements.ne_id%type
                      ,pi_ref_item       in nm_inv_items.iit_ne_id%type
                      ,pi_ref_offset     in number
                      ) is
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'locate_asset');

  locate_asset(pi_iit_ne_id        => pi_iit_ne_id
              ,pi_effective_date   => pi_effective_date
              ,pi_route_id         => pi_route_id
              ,pi_start_ref_item   => pi_ref_item
              ,pi_start_ref_offset => pi_ref_offset
              ,pi_end_ref_item     => NULL
              ,pi_end_ref_offset   => NULL);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'locate_asset');

END locate_asset;
--
-----------------------------------------------------------------------------
--
PROCEDURE locate_asset(pi_rec in v_load_locate_inv_by_ref%ROWTYPE
                      ) IS

  l_start_item_rec nm_inv_items%ROWTYPE;
  l_end_item_rec   nm_inv_items%ROWTYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'locate_asset');

  nm3user.set_effective_date(p_date => pi_rec.effective_date);

  --find the ref items by their type and label
  IF pi_rec.start_ref_type is not nuLL
  then
    l_start_item_rec := get_iit_by_type_and_label(pi_inv_type => pi_rec.start_ref_type
                                                 ,pi_label    => pi_rec.start_ref_label);
  END IF;

  IF pi_rec.end_ref_type is not nuLL
  THEN
    l_end_item_rec := get_iit_by_type_and_label(pi_inv_type => pi_rec.end_ref_type
                                               ,pi_label    => pi_rec.end_ref_label);
  END IF;

  locate_asset(pi_iit_ne_id        => pi_rec.iit_ne_id
              ,pi_effective_date   => pi_rec.effective_date
              ,pi_route_id         => pi_rec.route_id
              ,pi_start_ref_item   => l_start_item_rec.iit_ne_id
              ,pi_start_ref_offset => pi_rec.start_ref_offset
              ,pi_end_ref_item     => l_end_item_rec.iit_ne_id
              ,pi_end_ref_offset   => pi_rec.end_ref_offset);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'locate_asset');

END locate_asset;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_nearest_ref_for_offset(pi_route_id       in     nm_elements.ne_id%type
                                    ,pi_offset         in     number
                                    ,pi_ref_item_type  in     nm_inv_types.nit_inv_type%type
                                    ,po_ref_item          out nm_inv_items.iit_ne_id%type
                                    ,po_ref_label         out varchar2
                                    ,po_ref_offset        out number
                                    ) IS

  l_route_units nm_units.un_unit_id%TYPE;
  l_datum_units nm_units.un_unit_id%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_nearest_ref_for_offset');

  nm3net.get_group_units(pi_ne_id       => pi_route_id
                        ,po_group_units => l_route_units
                        ,po_child_units => l_datum_units);

  begin
    select
      ref_id,
      ref_descr,
      offset
    into
      po_ref_item,
      po_ref_label,
      po_ref_offset
    from
      (select
         ref_id,
         ref_descr,
         pi_offset - ref_route_measure offset
       from
         (select
            iit_ref.iit_ne_id     ref_id,
            iit_ref.iit_descr     ref_descr,
            nm_r.nm_slk + DECODE(nm_r.nm_cardinality
                                ,1 , nm3unit.convert_unit(l_datum_units, l_route_units, nm_ref.nm_begin_mp)
                                ,-1, nm3unit.convert_unit(l_datum_units, l_route_units, ne_i.ne_length - nm_ref.nm_begin_mp)) ref_route_measure
          from
            nm_members   nm_r,
            nm_members   nm_ref,
            nm_inv_items iit_ref,
            nm_elements  ne_i
          where
            nm_r.nm_ne_id_in = pi_route_id
          and
            nm_ref.nm_type = 'I'
          and
            nm_ref.nm_obj_type = pi_ref_item_type
          and
            nm_ref.nm_ne_id_of = nm_r.nm_ne_id_of
          and
            nm_r.nm_slk <= pi_offset
          and
            iit_ref.iit_ne_id = nm_ref.nm_ne_id_in
          and
            ne_i.ne_id = nm_r.nm_ne_id_of)
       where
         ref_route_measure <= pi_offset
       order by
         ref_route_measure desc)
    where
      rownum = 1;

  exception
    when no_data_found
    then
      --no preceeding ref item, so look for the first one along the route
      begin
        select
          ref_id,
          ref_descr,
          offset
        into
          po_ref_item,
          po_ref_label,
          po_ref_offset
        from
          (select
             ref_id,
             ref_descr,
             pi_offset - ref_route_measure offset
           from
             (select
                iit_ref.iit_ne_id     ref_id,
                iit_ref.iit_descr     ref_descr,
                nm_r.nm_slk + DECODE(nm_r.nm_cardinality
                                    ,1 , nm3unit.convert_unit(l_datum_units, l_route_units, nm_ref.nm_begin_mp)
                                    ,-1, nm3unit.convert_unit(l_datum_units, l_route_units, ne_i.ne_length - nm_ref.nm_begin_mp)) ref_route_measure
              from
                nm_members   nm_r,
                nm_members   nm_ref,
                nm_inv_items iit_ref,
                nm_elements  ne_i
              where
                nm_r.nm_ne_id_in = pi_route_id
              and
                nm_ref.nm_type = 'I'
              and
                nm_ref.nm_obj_type = pi_ref_item_type
              and
                nm_ref.nm_ne_id_of = nm_r.nm_ne_id_of
              and
                iit_ref.iit_ne_id = nm_ref.nm_ne_id_in
              and
                ne_i.ne_id = nm_r.nm_ne_id_of)
           order by
             ref_route_measure ASC)
        where
          rownum = 1;

      Exception
        when no_data_found
        then
          --there are no ref items just return the route offset
          po_ref_item   := NULL;
          po_ref_label  := NULL;
          po_ref_offset := pi_offset;

      END;
  end;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_nearest_ref_for_offset');

END get_nearest_ref_for_offset;
--
-----------------------------------------------------------------------------
--
FUNCTION get_item_location_on_route(pi_iit_ne_id in nm_inv_items.iit_ne_id%type
                                   ,pi_route_id  in nm_elements.ne_id%type
                                   ,pi_raise     in boolean default False
                                   ) RETURN nm_placement IS

  e_not_located_on_route exception;
  e_more_than_one_chunk  exception;

  l_item_location_arr nm_placement_array;

  l_empty_placement nm_placement;

  l_retval nm_placement;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_item_location_on_route');

  l_item_location_arr := nm3pla.get_connected_chunks(pi_ne_id    => pi_iit_ne_id
                                                    ,pi_route_id => pi_route_id);

  if l_item_location_arr.placement_count = 0
  then
    IF pi_raise
    THEN
      raise e_not_located_on_route;
    else
      l_retval := l_empty_placement;
    END IF;

  elsif l_item_location_arr.placement_count > 1
  then
    IF pi_raise
    THEN
      raise e_more_than_one_chunk;
    else
      l_retval := l_empty_placement;
    end if;
  else
    l_retval := l_item_location_arr.get_entry(pl_arr_pos => 1);
  end if;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_item_location_on_route');

  RETURN l_retval;

exception
  when e_not_located_on_route
  then
    hig.raise_ner(pi_appl               => nm3type.c_net
                 ,pi_id                 => 447
                 ,pi_supplementary_info => '(iit_ne_id = ' || to_char(pi_iit_ne_id) ||
                                           ' ne_id = ' || to_char(pi_route_id) || ')');

  when e_more_than_one_chunk
  then
    hig.raise_ner(pi_appl               => nm3type.c_net
                 ,pi_id                 => 448
                 ,pi_supplementary_info => '(iit_ne_id = ' || to_char(pi_iit_ne_id) ||
                                           ' ne_id = ' || to_char(pi_route_id) || ')');

END get_item_location_on_route;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_refs_for_item(pi_iit_ne_id        in     nm_inv_items.iit_ne_id%type
                           ,pi_route_id         in     nm_elements.ne_id%type
                           ,pi_ref_inv_type     in     nm_inv_types.nit_inv_type%type
                           ,po_start_ref_item      out nm_inv_items.iit_ne_id%type
                           ,po_start_ref_label     out varchar2
                           ,po_start_ref_offset    out number
                           ,po_end_ref_item        out nm_inv_items.iit_ne_id%type
                           ,po_end_ref_label       out varchar2
                           ,po_end_ref_offset      out number
                           ) IS

  l_item_location nm_placement;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_refs_for_item');

  l_item_location := get_item_location_on_route(pi_iit_ne_id => pi_iit_ne_id
                                               ,pi_route_id  => pi_route_id
                                               ,pi_raise     => TRUE);

  get_nearest_ref_for_offset(pi_route_id       => pi_route_id
                            ,pi_offset         => l_item_location.pl_start
                            ,pi_ref_item_type  => pi_ref_inv_type
                            ,po_ref_item       => po_start_ref_item
                            ,po_ref_label      => po_start_ref_label
                            ,po_ref_offset     => po_start_ref_offset);

  get_nearest_ref_for_offset(pi_route_id       => pi_route_id
                            ,pi_offset         => l_item_location.pl_end
                            ,pi_ref_item_type  => pi_ref_inv_type
                            ,po_ref_item       => po_end_ref_item
                            ,po_ref_label      => po_end_ref_label
                            ,po_ref_offset     => po_end_ref_offset);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_refs_for_item');

END get_refs_for_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_start_ref(pi_iit_ne_id        in     nm_inv_items.iit_ne_id%type
                       ,pi_route_id         in     nm_elements.ne_id%type
                       ,pi_ref_inv_type     in     nm_inv_types.nit_inv_type%type
                       ,po_start_ref_item      out nm_inv_items.iit_ne_id%type
                       ,po_start_ref_label     out varchar2
                       ,po_start_ref_offset    out number
                       ) IS

  l_item_location nm_placement;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_start_ref');

  l_item_location := get_item_location_on_route(pi_iit_ne_id => pi_iit_ne_id
                                               ,pi_route_id  => pi_route_id);

  get_nearest_ref_for_offset(pi_route_id       => pi_route_id
                            ,pi_offset         => l_item_location.pl_start
                            ,pi_ref_item_type  => pi_ref_inv_type
                            ,po_ref_item       => po_start_ref_item
                            ,po_ref_label      => po_start_ref_label
                            ,po_ref_offset     => po_start_ref_offset);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_start_ref');

END get_start_ref;
--
-----------------------------------------------------------------------------
--
FUNCTION get_start_ref_offset(pi_iit_ne_id    in nm_inv_items.iit_ne_id%type
                             ,pi_route_id     in nm_elements.ne_id%type
                             ,pi_ref_inv_type in nm_inv_types.nit_inv_type%type
                             ) RETURN number IS


  l_start_ref_item   nm_inv_items.iit_ne_id%type;
  l_start_ref_label  nm3type.max_varchar2;
  l_start_ref_offset number;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_start_ref_offset');

  get_start_ref(pi_iit_ne_id        => pi_iit_ne_id
               ,pi_route_id         => pi_route_id
               ,pi_ref_inv_type     => pi_ref_inv_type
               ,po_start_ref_item   => l_start_ref_item
               ,po_start_ref_label  => l_start_ref_label
               ,po_start_ref_offset => l_start_ref_offset);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_start_ref_offset');

  RETURN l_start_ref_offset;

END get_start_ref_offset;
--
-----------------------------------------------------------------------------
--
FUNCTION get_start_ref_item(pi_iit_ne_id    in nm_inv_items.iit_ne_id%type
                           ,pi_route_id     in nm_elements.ne_id%type
                           ,pi_ref_inv_type in nm_inv_types.nit_inv_type%type
                           ) RETURN nm_inv_items.iit_ne_id%type IS

  l_start_ref_item   nm_inv_items.iit_ne_id%type;
  l_start_ref_label  nm3type.max_varchar2;
  l_start_ref_offset number;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_start_ref_item');

  get_start_ref(pi_iit_ne_id        => pi_iit_ne_id
               ,pi_route_id         => pi_route_id
               ,pi_ref_inv_type     => pi_ref_inv_type
               ,po_start_ref_item   => l_start_ref_item
               ,po_start_ref_label  => l_start_ref_label
               ,po_start_ref_offset => l_start_ref_offset);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_start_ref_item');

  RETURN l_start_ref_item;

END get_start_ref_item;
--
-----------------------------------------------------------------------------
--
FUNCTION get_start_ref_label(pi_iit_ne_id    in nm_inv_items.iit_ne_id%type
                            ,pi_route_id     in nm_elements.ne_id%type
                            ,pi_ref_inv_type in nm_inv_types.nit_inv_type%type
                            ) RETURN varchar2 IS

  l_start_ref_item   nm_inv_items.iit_ne_id%type;
  l_start_ref_label  nm3type.max_varchar2;
  l_start_ref_offset number;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_start_ref_label');

  get_start_ref(pi_iit_ne_id        => pi_iit_ne_id
               ,pi_route_id         => pi_route_id
               ,pi_ref_inv_type     => pi_ref_inv_type
               ,po_start_ref_item   => l_start_ref_item
               ,po_start_ref_label  => l_start_ref_label
               ,po_start_ref_offset => l_start_ref_offset);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_start_ref_label');

  RETURN l_start_ref_label;

END get_start_ref_label;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_end_ref(pi_iit_ne_id      in     nm_inv_items.iit_ne_id%type
                     ,pi_route_id       in     nm_elements.ne_id%type
                     ,pi_ref_inv_type   in     nm_inv_types.nit_inv_type%type
                     ,po_end_ref_item      out nm_inv_items.iit_ne_id%type
                     ,po_end_ref_label     out varchar2
                     ,po_end_ref_offset    out number
                     ) IS

  l_item_location nm_placement;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_end_ref');

  l_item_location := get_item_location_on_route(pi_iit_ne_id => pi_iit_ne_id
                                               ,pi_route_id  => pi_route_id);

  get_nearest_ref_for_offset(pi_route_id       => pi_route_id
                            ,pi_offset         => l_item_location.pl_end
                            ,pi_ref_item_type  => pi_ref_inv_type
                            ,po_ref_item       => po_end_ref_item
                            ,po_ref_label      => po_end_ref_label
                            ,po_ref_offset     => po_end_ref_offset);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_end_ref');

END get_end_ref;
--
-----------------------------------------------------------------------------
--
FUNCTION get_end_ref_offset(pi_iit_ne_id    in nm_inv_items.iit_ne_id%type
                           ,pi_route_id     in nm_elements.ne_id%type
                           ,pi_ref_inv_type in nm_inv_types.nit_inv_type%type
                           ) RETURN number IS

  l_end_ref_item   nm_inv_items.iit_ne_id%type;
  l_end_ref_label  nm3type.max_varchar2;
  l_end_ref_offset number;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_end_ref_offset');

  get_end_ref(pi_iit_ne_id      => pi_iit_ne_id
             ,pi_route_id       => pi_route_id
             ,pi_ref_inv_type   => pi_ref_inv_type
             ,po_end_ref_item   => l_end_ref_item
             ,po_end_ref_label  => l_end_ref_label
             ,po_end_ref_offset => l_end_ref_offset);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_end_ref_offset');

  RETURN l_end_ref_offset;

END get_end_ref_offset;
--
-----------------------------------------------------------------------------
--
FUNCTION get_end_ref_item(pi_iit_ne_id    in nm_inv_items.iit_ne_id%type
                         ,pi_route_id     in nm_elements.ne_id%type
                         ,pi_ref_inv_type in nm_inv_types.nit_inv_type%type
                         ) RETURN nm_inv_items.iit_ne_id%type IS

  l_end_ref_item   nm_inv_items.iit_ne_id%type;
  l_end_ref_label  nm3type.max_varchar2;
  l_end_ref_offset number;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_end_ref_item');

  get_end_ref(pi_iit_ne_id      => pi_iit_ne_id
             ,pi_route_id       => pi_route_id
             ,pi_ref_inv_type   => pi_ref_inv_type
             ,po_end_ref_item   => l_end_ref_item
             ,po_end_ref_label  => l_end_ref_label
             ,po_end_ref_offset => l_end_ref_offset);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_end_ref_item');

  RETURN l_end_ref_item;

END get_end_ref_item;
--
-----------------------------------------------------------------------------
--
FUNCTION get_end_ref_label(pi_iit_ne_id    in nm_inv_items.iit_ne_id%type
                          ,pi_route_id     in nm_elements.ne_id%type
                          ,pi_ref_inv_type in nm_inv_types.nit_inv_type%type
                          ) return varchar2 IS

  l_end_ref_item   nm_inv_items.iit_ne_id%type;
  l_end_ref_label  nm3type.max_varchar2;
  l_end_ref_offset number;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_end_ref_label');

  get_end_ref(pi_iit_ne_id      => pi_iit_ne_id
             ,pi_route_id       => pi_route_id
             ,pi_ref_inv_type   => pi_ref_inv_type
             ,po_end_ref_item   => l_end_ref_item
             ,po_end_ref_label  => l_end_ref_label
             ,po_end_ref_offset => l_end_ref_offset);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_end_ref_label');

  RETURN l_end_ref_label;

END get_end_ref_label;
--
-----------------------------------------------------------------------------
--
FUNCTION get_default_ref_type(pi_inv_type in nm_inv_types.nit_inv_type%type default null
                             ,pi_nt_type  in nm_types.nt_type%type default null
                             ) RETURN nm_inv_types.nit_inv_type%TYPE IS

  c_default_ref_type_opt constant hig_option_list.hol_id%type := 'DEFITEMTYP';

  l_retval nm_inv_types.nit_inv_type%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_default_ref_type');

  --currently we just get the default type from a user/system option
  l_retval := hig.get_user_or_sys_opt(pi_option => c_default_ref_type_opt);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_default_ref_type');

  RETURN l_retval;

END get_default_ref_type;
--
-----------------------------------------------------------------------------
--
END nm3mp_ref;
/

