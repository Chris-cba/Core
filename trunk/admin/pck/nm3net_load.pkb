CREATE OR REPLACE PACKAGE BODY nm3net_load AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3net_load.pkb-arc   2.2   Jul 04 2013 16:19:16   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3net_load.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:19:16  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:18  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.5
---------------------------------------------------------------------------
--   Author : Jonathan Mills
--
--   NM3 Loader Network Related package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '$Revision:   2.2  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3net_load';
--
   g_route_ne_id     nm_elements.ne_id%TYPE;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_element_attributes (p_ne_id         in nm_elements.ne_id%TYPE
                                   ,p_check_partial in boolean default false
                                   );
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
PROCEDURE rescale_route (p_rec v_load_rescale_route%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'rescale_route');
--
   validate_rescale_route (p_rec);
--
   nm3rsc.rescale_route (pi_ne_id               => g_route_ne_id
                        ,pi_effective_date      => p_rec.effective_date
                        ,pi_offset_st           => p_rec.start_offset
                        ,pi_st_element_id       => p_rec.st_element_id
                        ,pi_use_history         => p_rec.use_history
                        ,pi_ne_start            => p_rec.ne_id_start
                        );
--
   nm_debug.proc_end(g_package_name,'rescale_route');
--
END rescale_route;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_rescale_route (p_rec v_load_rescale_route%ROWTYPE) IS
--
   l_route_ne_id nm_elements.ne_id%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'rescale_route');
--
   l_route_ne_id := nm3net.get_ne_id(p_rec.ne_unique, p_rec.ne_nt_type);
   check_element_attributes (l_route_ne_id);
--
   g_route_ne_id := l_route_ne_id;
--
   nm_debug.proc_end(g_package_name,'rescale_route');
--
END validate_rescale_route;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_resize_route(pi_rec v_load_resize_route%rowtype
                               ) IS

  l_route_ne_id nm_elements.ne_id%type;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'validate_resize_route');

  l_route_ne_id := nm3net.get_ne_id(p_ne_unique  => pi_rec.ne_unique
                                   ,p_ne_nt_type => pi_rec.ne_nt_type);

  check_element_attributes(p_ne_id         => l_route_ne_id
                          ,p_check_partial => true);

  g_route_ne_id := l_route_ne_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'validate_resize_route');

END validate_resize_route;
--
-----------------------------------------------------------------------------
--
PROCEDURE resize_route(pi_rec v_load_resize_route%rowtype
                      ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'resize_route');

  validate_resize_route(pi_rec => pi_rec);
  
  nm3rsc.resize_route(pi_ne_id    => g_route_ne_id
                     ,pi_new_size => pi_rec.new_length
                     ,pi_ne_start => pi_rec.ne_id_start);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'resize_route');

END resize_route;
--
-----------------------------------------------------------------------------
--
PROCEDURE reseq_route (p_rec v_load_reseq_route%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'reseq_route');
--
   validate_reseq_route (p_rec);
--
   nm3rsc.reseq_route (pi_ne_id    => g_route_ne_id
                      ,pi_ne_start => p_rec.ne_id_start
                      );
--
   nm_debug.proc_end(g_package_name,'reseq_route');
--
END reseq_route;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_reseq_route (p_rec v_load_reseq_route%ROWTYPE) IS
--
   l_route_ne_id nm_elements.ne_id%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'validate_reseq_route');
--
   l_route_ne_id := nm3net.get_ne_id(p_rec.ne_unique, p_rec.ne_nt_type);
   check_element_attributes (l_route_ne_id);
--
   g_route_ne_id := l_route_ne_id;
--
   nm_debug.proc_end(g_package_name,'validate_reseq_route');
--
END validate_reseq_route;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_element_attributes (p_ne_id         in nm_elements.ne_id%TYPE
                                   ,p_check_partial in boolean default false
                                   ) IS
--
   l_rec_ne      nm_elements%ROWTYPE;
   l_rec_nt      nm_types%ROWTYPE;
   l_rec_ngt     nm_group_types%rowtype;
--
BEGIN
--
   l_rec_ne      := nm3get.get_ne (pi_ne_id   => p_ne_id);
   l_rec_nt      := nm3get.get_nt (pi_nt_type => l_rec_ne.ne_nt_type);
--
   IF l_rec_nt.nt_datum = 'Y'
    THEN
      hig.raise_ner (pi_appl => nm3type.c_net
                    ,pi_id   => 311
                    );
   END IF;
--
   IF l_rec_nt.nt_linear != 'Y'
    THEN
      hig.raise_ner (pi_appl => nm3type.c_net
                    ,pi_id   => 336
                    );
   END IF;
   
   if p_check_partial
   then
     l_rec_ngt := nm3get.get_ngt(pi_ngt_group_type => l_rec_ne.ne_gty_group_type);
     
     if l_rec_ngt.ngt_partial = 'Y'
     then
       hig.raise_ner(pi_appl => nm3type.c_net
                    ,pi_id   => 182);
     end if;
   end if;
--
END check_element_attributes;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_distance_break (p_rec v_load_distance_break%ROWTYPE) IS
--
   l_db_ne_id     nm_members.nm_ne_id_in%TYPE;
   l_db_ne_unique nm_elements.ne_unique%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_distance_break');
--
   validate_distance_break (p_rec);
--
   nm3net.insert_distance_break (pi_route_ne_id     => g_route_ne_id
                                ,pi_start_node_id   => p_rec.ne_no_start
                                ,pi_end_node_id     => p_rec.ne_no_end
                                ,pi_start_date      => p_rec.ne_start_date
                                ,pi_length          => NVL(p_rec.ne_length,0)
                                ,po_db_ne_id        => l_db_ne_id
                                ,po_db_ne_unique    => l_db_ne_unique
                                );
--
   nm_debug.proc_end(g_package_name,'create_distance_break');
--
END create_distance_break;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_distance_break (p_rec v_load_distance_break%ROWTYPE) IS
--
   l_route_ne_id  nm_elements.ne_id%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'validate_distance_break');
--
   l_route_ne_id := nm3net.get_ne_id(p_rec.ne_unique, p_rec.ne_nt_type);
   g_route_ne_id := l_route_ne_id;
--
   nm_debug.proc_end(g_package_name,'validate_distance_break');
--
END validate_distance_break;
--
-----------------------------------------------------------------------------
--
END nm3net_load;
/
