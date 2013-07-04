CREATE OR REPLACE PACKAGE BODY nm3api_net AS
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3api_net.pkb-arc   2.3   Jul 04 2013 15:15:38   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3api_net.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:15:38  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:08  $
--       PVCS Version     : $Revision:   2.3  $
--       Based on SCCS version : 1.2
--
--
--   Author : Rob Coupe
--
--   Network API package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

-- 03.06.08 PT added p_no_purpose parameter to create_node() func and proc
--
   g_body_sccsid     CONSTANT  varchar2(200) :='"$Revision:   2.3  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3api_net';
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
FUNCTION  create_node (p_no_node_name   IN     nm_nodes.no_node_name%TYPE   DEFAULT NULL
                      ,p_no_descr       IN     nm_nodes.no_descr%TYPE
                      ,p_no_node_type   IN     nm_nodes.no_node_type%TYPE
                      ,p_effective_date IN     nm_nodes.no_start_date%TYPE  DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                      ,p_np_grid_east   IN     nm_points.np_grid_east%TYPE  DEFAULT NULL
                      ,p_np_grid_north  IN     nm_points.np_grid_north%TYPE DEFAULT NULL
                      ,p_no_purpose     in     nm_nodes.no_purpose%type default null  -- PT 03.06.08
                      ) RETURN nm_nodes.no_node_id%TYPE IS
--
   l_no_node_id nm_nodes.no_node_id%TYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_node');
--
   l_no_node_id := nm3split.create_node (p_no_node_name   => p_no_node_name
                                        ,p_no_descr       => p_no_descr
                                        ,p_no_node_type   => p_no_node_type
                                        ,p_effective_date => p_effective_date
                                        ,p_np_grid_east   => p_np_grid_east
                                        ,p_np_grid_north  => p_np_grid_north
                                        ,p_no_purpose     => p_no_purpose     -- PT 03.06.08
                                        );
--
   nm_debug.proc_end (g_package_name,'create_node');
--
   RETURN l_no_node_id;
--
END create_node;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_node (p_no_node_name   IN     nm_nodes.no_node_name%TYPE   DEFAULT NULL
                      ,p_no_descr       IN     nm_nodes.no_descr%TYPE
                      ,p_no_node_type   IN     nm_nodes.no_node_type%TYPE
                      ,p_effective_date IN     nm_nodes.no_start_date%TYPE  DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                      ,p_np_grid_east   IN     nm_points.np_grid_east%TYPE  DEFAULT NULL
                      ,p_np_grid_north  IN     nm_points.np_grid_north%TYPE DEFAULT NULL
                      ,p_no_node_id        OUT nm_nodes.no_node_id%TYPE
                      ,p_no_purpose     in     nm_nodes.no_purpose%type default null  -- PT 03.06.08
                      ) IS
BEGIN
   p_no_node_id := create_node (p_no_node_name   => p_no_node_name
                               ,p_no_descr       => p_no_descr
                               ,p_no_node_type   => p_no_node_type
                               ,p_effective_date => p_effective_date
                               ,p_np_grid_east   => p_np_grid_east
                               ,p_np_grid_north  => p_np_grid_north
                               ,p_no_purpose     => p_no_purpose    -- PT 03.06.08
                               );
END create_node;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_element (p_rec_ne         IN OUT nm_elements%ROWTYPE
                         ,p_effective_date IN     nm_elements.ne_start_date%TYPE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                         ,p_nm_cardinality IN     nm_members.nm_cardinality%TYPE DEFAULT NULL
                         ) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_element');
--
   p_rec_ne.ne_id         := Null;
   p_rec_ne.ne_start_date := p_effective_date;
--
   IF   p_nm_cardinality IS NOT NULL
    AND ABS(p_nm_cardinality) != 1
    THEN -- If p_nm_cardinality is specified then it must be +/- 1
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 283
                    ,pi_supplementary_info => 'p_nm_cardinality'
                    );
   END IF;
--
   nm3net.insert_any_element (p_rec_ne         => p_rec_ne
                             ,p_nm_cardinality => p_nm_cardinality
                             ,p_auto_include   => TRUE
                             );
--
   nm_debug.proc_end (g_package_name,'create_element');
--
END create_element;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_distance_break (pi_route_ne_id      IN     nm_elements.ne_id%TYPE
                                ,pi_start_node_id    IN     nm_elements.ne_no_start%TYPE
                                ,pi_end_node_id      IN     nm_elements.ne_no_end%TYPE
                                ,pi_effective_date   IN     nm_elements.ne_start_date%TYPE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                ,pi_length           IN     nm_elements.ne_length%TYPE     DEFAULT 0
                                ,po_db_ne_id            OUT nm_elements.ne_id%TYPE
                                ,po_db_ne_unique        OUT nm_elements.ne_unique%TYPE
                                ) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_distance_break');
--
   nm3net.insert_distance_break (pi_route_ne_id     => pi_route_ne_id
                                ,pi_start_node_id   => pi_start_node_id
                                ,pi_end_node_id     => pi_end_node_id
                                ,pi_start_date      => pi_effective_date
                                ,pi_length          => pi_length
                                ,po_db_ne_id        => po_db_ne_id
                                ,po_db_ne_unique    => po_db_ne_unique
                                );
--
   nm_debug.proc_end (g_package_name,'create_distance_break');
--
END create_distance_break;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_distance_break (pi_route_ne_id      IN     nm_elements.ne_id%TYPE
                                ,pi_start_node_id    IN     nm_elements.ne_no_start%TYPE
                                ,pi_end_node_id      IN     nm_elements.ne_no_end%TYPE
                                ,pi_effective_date   IN     nm_elements.ne_start_date%TYPE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                ,pi_length           IN     nm_elements.ne_length%TYPE     DEFAULT 0
                                ) IS
--
   l_db_ne_id     nm_elements.ne_id%TYPE;
   l_db_ne_unique nm_elements.ne_unique%TYPE;
--
BEGIN
--
   create_distance_break (pi_route_ne_id     => pi_route_ne_id
                         ,pi_start_node_id   => pi_start_node_id
                         ,pi_end_node_id     => pi_end_node_id
                         ,pi_effective_date  => pi_effective_date
                         ,pi_length          => pi_length
                         ,po_db_ne_id        => l_db_ne_id
                         ,po_db_ne_unique    => l_db_ne_unique
                         );
--
END create_distance_break;
--
-----------------------------------------------------------------------------
--
FUNCTION  create_distance_break (pi_route_ne_id      IN     nm_elements.ne_id%TYPE
                                ,pi_start_node_id    IN     nm_elements.ne_no_start%TYPE
                                ,pi_end_node_id      IN     nm_elements.ne_no_end%TYPE
                                ,pi_effective_date   IN     nm_elements.ne_start_date%TYPE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                ,pi_length           IN     nm_elements.ne_length%TYPE     DEFAULT 0
                                ) RETURN nm_elements.ne_id%TYPE IS
--
   l_db_ne_id     nm_elements.ne_id%TYPE;
   l_db_ne_unique nm_elements.ne_unique%TYPE;
--
BEGIN
--
   create_distance_break (pi_route_ne_id     => pi_route_ne_id
                         ,pi_start_node_id   => pi_start_node_id
                         ,pi_end_node_id     => pi_end_node_id
                         ,pi_effective_date  => pi_effective_date
                         ,pi_length          => pi_length
                         ,po_db_ne_id        => l_db_ne_id
                         ,po_db_ne_unique    => l_db_ne_unique
                         );
--
   RETURN l_db_ne_id;
--
END create_distance_break;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_distance_break (pi_route_ne_unique  IN     nm_elements.ne_unique%TYPE
                                ,pi_route_ne_nt_type IN     nm_elements.ne_nt_type%TYPE    DEFAULT NULL
                                ,pi_start_node_id    IN     nm_elements.ne_no_start%TYPE
                                ,pi_end_node_id      IN     nm_elements.ne_no_end%TYPE
                                ,pi_effective_date   IN     nm_elements.ne_start_date%TYPE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                ,pi_length           IN     nm_elements.ne_length%TYPE     DEFAULT 0
                                ,po_db_ne_id            OUT nm_elements.ne_id%TYPE
                                ,po_db_ne_unique        OUT nm_elements.ne_unique%TYPE
                                ) IS
--
   l_route_ne_id     nm_elements.ne_id%TYPE;
--
BEGIN
--
   l_route_ne_id := nm3net.get_ne_id(pi_route_ne_unique, pi_route_ne_nt_type);
--
   create_distance_break (pi_route_ne_id     => l_route_ne_id
                         ,pi_start_node_id   => pi_start_node_id
                         ,pi_end_node_id     => pi_end_node_id
                         ,pi_effective_date  => pi_effective_date
                         ,pi_length          => pi_length
                         ,po_db_ne_id        => po_db_ne_id
                         ,po_db_ne_unique    => po_db_ne_unique
                         );
--
END create_distance_break;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_distance_break (pi_route_ne_unique  IN     nm_elements.ne_unique%TYPE
                                ,pi_route_ne_nt_type IN     nm_elements.ne_nt_type%TYPE    DEFAULT NULL
                                ,pi_start_node_id    IN     nm_elements.ne_no_start%TYPE
                                ,pi_end_node_id      IN     nm_elements.ne_no_end%TYPE
                                ,pi_effective_date   IN     nm_elements.ne_start_date%TYPE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                ,pi_length           IN     nm_elements.ne_length%TYPE     DEFAULT 0
                                ) IS
--
   l_db_ne_id     nm_elements.ne_id%TYPE;
   l_db_ne_unique nm_elements.ne_unique%TYPE;
--
BEGIN
--
   create_distance_break (pi_route_ne_unique  => pi_route_ne_unique
                         ,pi_route_ne_nt_type => pi_route_ne_nt_type
                         ,pi_start_node_id    => pi_start_node_id
                         ,pi_end_node_id      => pi_end_node_id
                         ,pi_effective_date   => pi_effective_date
                         ,pi_length           => pi_length
                         ,po_db_ne_id         => l_db_ne_id
                         ,po_db_ne_unique     => l_db_ne_unique
                         );
--
END create_distance_break;
--
-----------------------------------------------------------------------------
--
FUNCTION  create_distance_break (pi_route_ne_unique  IN     nm_elements.ne_unique%TYPE
                                ,pi_route_ne_nt_type IN     nm_elements.ne_nt_type%TYPE    DEFAULT NULL
                                ,pi_start_node_id    IN     nm_elements.ne_no_start%TYPE
                                ,pi_end_node_id      IN     nm_elements.ne_no_end%TYPE
                                ,pi_effective_date   IN     nm_elements.ne_start_date%TYPE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                ,pi_length           IN     nm_elements.ne_length%TYPE     DEFAULT 0
                                ) RETURN nm_elements.ne_id%TYPE IS
--
   l_db_ne_id     nm_elements.ne_id%TYPE;
   l_db_ne_unique nm_elements.ne_unique%TYPE;
--
BEGIN
--
   create_distance_break (pi_route_ne_unique  => pi_route_ne_unique
                         ,pi_route_ne_nt_type => pi_route_ne_nt_type
                         ,pi_start_node_id    => pi_start_node_id
                         ,pi_end_node_id      => pi_end_node_id
                         ,pi_effective_date   => pi_effective_date
                         ,pi_length           => pi_length
                         ,po_db_ne_id         => l_db_ne_id
                         ,po_db_ne_unique     => l_db_ne_unique
                         );
--
   RETURN l_db_ne_id;
--
END create_distance_break;
--
-----------------------------------------------------------------------------
--
PROCEDURE close_datum_element (pi_datum_ne_id     IN nm_elements.ne_id%TYPE
                              ,pi_close_date      IN DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                              ) IS
--
   c_init_eff_date CONSTANT DATE := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
--
BEGIN
--
   nm_debug.proc_start (g_package_name, 'close_datum_element');
--
   nm3user.set_effective_date (pi_close_date);
--
   IF nm3net.is_nt_datum (nm3get.get_ne (pi_ne_id  => pi_datum_ne_id).ne_nt_type) != 'Y'
    THEN
      hig.raise_ner (pi_appl => nm3type.c_net
                    ,pi_id   => 119
                    );
   END IF;
--
   nm3close.do_close (p_ne_id          => pi_datum_ne_id
                     ,p_effective_date => pi_close_date
                     );
--
   nm3user.set_effective_date (c_init_eff_date);
--
   nm_debug.proc_end (g_package_name, 'close_datum_element');
--
EXCEPTION
--
   WHEN others
    THEN
      nm3user.set_effective_date (c_init_eff_date);
      RAISE;
--
END close_datum_element;
--
-----------------------------------------------------------------------------
--
PROCEDURE close_group_of_elements (pi_route_ne_id     IN nm_elements.ne_id%TYPE
                                  ,pi_close_date      IN DATE     DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                  ,pi_close_all       IN VARCHAR2 DEFAULT 'N'
                                  ) IS
--
   c_init_eff_date CONSTANT DATE := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
--
BEGIN
--
   nm_debug.proc_start (g_package_name, 'close_group_of_elements');
--
   nm3user.set_effective_date (pi_close_date);
--
   IF nm3net.is_nt_datum (nm3get.get_ne (pi_ne_id  => pi_route_ne_id).ne_nt_type) != 'N'
    THEN
      hig.raise_ner (pi_appl => nm3type.c_net
                    ,pi_id   => 311
                    );
   END IF;
--
   nm3close.multi_element_close (pi_type           => nm3close.c_route
                                ,pi_id             => pi_route_ne_id
                                ,pi_effective_date => pi_close_date
                                ,pi_close_all      => pi_close_all
                                );
--
   nm3user.set_effective_date (c_init_eff_date);
--
   nm_debug.proc_end (g_package_name, 'close_group_of_elements');
--
EXCEPTION
--
   WHEN others
    THEN
      nm3user.set_effective_date (c_init_eff_date);
      RAISE;
--
END close_group_of_elements;
--
-----------------------------------------------------------------------------
--
END nm3api_net;
/
