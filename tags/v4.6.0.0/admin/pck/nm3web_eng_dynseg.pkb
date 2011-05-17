CREATE OR REPLACE PACKAGE BODY nm3web_eng_dynseg AS
--
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.10  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3web_eng_dynseg';
--
   g_dynseg_pack_name CONSTANT varchar2(30)   := 'NM3ENG_DYNSEG';
--
   c_merge            CONSTANT varchar2(5)    := 'MERGE';
   --
   g_tab_funcs              nm3type.tab_varchar30;
   g_tab_funcs_ret_obj_type nm3type.tab_varchar30;
   g_tab_is_obj             nm3type.tab_varchar30;
--
   c_this_module  CONSTANT hig_modules.hmo_module%TYPE := 'NMWEB0020';
   c_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);
--
   c_nm_val_dist_arr CONSTANT VARCHAR2(30) := 'NM_VALUE_DISTRIBUTION_ARRAY';
   c_nm_val_dist     CONSTANT VARCHAR2(30) := 'NM_VALUE_DISTRIBUTION';
   
 --  g_css CONSTANT varchar2(2000) := NVL(hig.get_sysopt('NM3WEBCSS'),get_download_url('exor.css'));
   
   -- Error message constants
   c_func_no_vals    CONSTANT VARCHAR2(30) := 'Function has no values';
   c_route_too_big   CONSTANT VARCHAR2(60) := 'Route end entered is greater than routes actual end';
   c_route_too_small CONSTANT VARCHAR2(60) := 'Route start cannot be less than the routes actual beginning';
   c_route_start_end CONSTANT VARCHAR2(60) := 'Route start cannot be greater than route end';

FUNCTION get_download_url( pi_name varchar2 ) RETURN varchar2 IS
BEGIN
   RETURN nm3flx.i_t_e (hig.get_sysopt ('WEBDOCPATH') IS NOT NULL
                       ,hig.get_sysopt ('WEBDOCPATH')||'/'
                       ,g_package_name||'.process_download?pi_name='
                       )||nm3web.string_to_url(pi_name);
END get_download_url;


PROCEDURE do_css_link IS
BEGIN
   htp.p('<link rel="stylesheet" href="'||NVL(hig.get_sysopt('NM3WEBCSS'),get_download_url('exor.css'))||'">');
END do_css_link;
--
--------------------------------------------------------------------------------
--
PROCEDURE raise_error (p_error IN VARCHAR2)
IS
BEGIN

   do_css_link;
   htp.bodyopen (cattributes=>'onLoad="initialise_form()"');
--   nm3web.header;
   htp.P('<!--');
   htp.P('');
   htp.P('   Start of the main body of the page');
   htp.P('');
   htp.P('-->');
   htp.P('<DIV ALIGN="CENTER">');

  IF p_error IS NOT NULL
  THEN
    htp.formopen(g_package_name||'.dynseg_define', cattributes => 'NAME="dynseg"');--templine
    htp.tableheader(p_error);
  END IF;

  htp.p('<br><br>');
  htp.p('<b><u><a HREF="javascript:history.back();"> Back </a></u></b>');

end raise_error;
--
-----------------------------------------------------------------------------
--
PROCEDURE sccs_tags IS
BEGIN
   htp.p('<!--');
   htp.p('--');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--');
   htp.p('--   PVCS Identifiers :-');
   htp.p('--');
   htp.p('--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3web_eng_dynseg.pkb-arc   2.10   May 17 2011 08:26:28   Steve.Cooper  $');
   htp.p('--       Module Name      : $Workfile:   nm3web_eng_dynseg.pkb  $');
   htp.p('--       Date into PVCS   : $Date:   May 17 2011 08:26:28  $');
   htp.p('--       Date fetched Out : $Modtime:   May 05 2011 14:39:50  $');
   htp.p('--       PVCS Version     : $Revision:   2.10  $');
   htp.p('--       Based on SCCS Version     : 1.23');
   htp.p('--');
   htp.p('--');
   htp.p('--   Author : Jonathan Mills');
   htp.p('--');
   htp.p('--   NM3 Web Engineering DynSeg package body');
   htp.p('--');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--    Copyright (c) exor corporation ltd, 2002');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--');
   htp.p('-->');
END sccs_tags;
--
-----------------------------------------------------------------------------
--
FUNCTION get_function_desc (p_func varchar2) RETURN varchar2;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_function_array;
--
-----------------------------------------------------------------------------
--
FUNCTION internal_produce_html_table (i pls_integer) RETURN nm3type.tab_varchar32767;
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
procedure check_route_length (pi_route_length    number default null
                             ,p_source      IN VARCHAR2
                             ,p_route       IN VARCHAR2           DEFAULT NULL
                             ,p_slk_from    IN NUMBER             DEFAULT NULL
                             ,p_slk_to      IN NUMBER             DEFAULT NULL
                             ,p_saved_ne_id IN NUMBER             DEFAULT NULL
                             ,p_nmq_id      IN NUMBER             DEFAULT NULL
                             ,p_nqr_job_id  IN NUMBER             DEFAULT NULL
                             ,p_gdo_sess_id IN NUMBER             DEFAULT NULL
                             ,p_function    IN owa_util.ident_arr DEFAULT g_empty_tab
                             ,p_inv_type    IN owa_util.ident_arr DEFAULT g_empty_tab
                             ,p_attrib      IN owa_util.ident_arr DEFAULT g_empty_tab
                             ,p_xsp         IN owa_util.ident_arr DEFAULT g_empty_tab)
is

l_end number;
l_start number;
l_ne_id varchar2(20);
b_success BOOLEAN := TRUE;

begin

  -- Saved Extent - Source = SAVED 
  -- Route        - Source = ROUTE
  -- Merge        - Source = MERGE   

-- AE Only validate against a Route source

  IF p_source = nm3extent.c_route
  THEN

    select max(ne_id)
    into l_ne_id
    from nm_elements
    where upper(ne_unique) = upper(p_route);

     l_end:= trim(nm3unit.get_formatted_value(nm3net.get_max_slk(l_ne_id)
                                        ,NM3GET.GET_NT(PI_NT_TYPE => 
                                                        (NM3GET.GET_NE(pi_ne_id => l_ne_id).NE_NT_TYPE)
                                                      ).NT_LENGTH_UNIT));
      l_start:= nm3net.get_min_slk(l_ne_id);

    if p_slk_to > l_end then
      select_route_error (p_error => C_ROUTE_TOO_BIG
                         ,p_route_length => l_end);
      b_success := FALSE;
    elsif p_slk_from < l_start then
      select_route_error (p_error => C_ROUTE_TOO_SMALL
                         ,p_route_length => l_start);
      b_success := FALSE;
    elsif p_slk_from >= p_slk_to then
      select_route_error (p_error => C_ROUTE_START_END);
      b_success := FALSE;
    end if;
--
  END IF;
--
  IF b_success
  THEN
    run_dynseg (p_source      => p_source
               ,p_route       => p_route
               ,p_slk_from    => p_slk_from
               ,p_slk_to      => p_slk_to
               ,p_saved_ne_id => p_saved_ne_id
               ,p_nmq_id      => p_nmq_id
               ,p_nqr_job_id  => p_nqr_job_id
               ,p_gdo_sess_id => p_gdo_sess_id
               ,p_function    => p_function
               ,p_inv_type    => p_inv_type
               ,p_attrib      => p_attrib
               ,p_xsp         => p_xsp
                );
  END IF;

end check_route_length;
--
procedure select_route_error (p_route          varchar2 default null
                             ,p_error           varchar2 default null
                             ,p_route_length    number default null)
is
begin

   do_css_link;
   htp.bodyopen (cattributes=>'onLoad="initialise_form()"');
--   nm3web.header;
   htp.P('<!--');
   htp.P('');
   htp.P('   Start of the main body of the page');
   htp.P('');
   htp.P('-->');
   htp.P('<DIV ALIGN="CENTER">');

if p_error is null then
  htp.formopen(g_package_name||'.select_route_page');
  htp.tableheader('Invalid route ('||p_route||'), please go back to previous page and re-enter a valid route');
elsif p_error = C_ROUTE_TOO_BIG then
   
  htp.formopen(g_package_name||'.dynseg_define', cattributes => 'NAME="dynseg"');--templine
  htp.tableheader('Route end entered is greater than routes actual end ('||p_route_length||'), please go back to previous page and re-enter a valid route end');
elsif p_error = C_ROUTE_TOO_SMALL then
--
  htp.formopen(g_package_name||'.dynseg_define', cattributes => 'NAME="dynseg"');--templine
  htp.tableheader('Route start cannot be less than the routes actual beginning ('||p_route_length||'), please go back to previous page and re-enter a valid route start');
elsif p_error = C_ROUTE_START_END then
--
  htp.formopen(g_package_name||'.dynseg_define', cattributes => 'NAME="dynseg"');--templine
  htp.tableheader('Route start cannot be greater than route end, please go back to previous page and re-enter a valid route start');

elsif p_error = c_func_no_vals then

  htp.formopen(g_package_name||'.dynseg_define', cattributes => 'NAME="dynseg"');--templine
  htp.tableheader('None of your functions have values, please go back to previous page and enter a value for at least one function');
end if;

htp.p('<br><br>');
htp.p('<b><u><a HREF="javascript:history.back();"> Back </a></u></b>');

/*  htp.tablerowopen;
  htp.formsubmit (cvalue=>'Go Back');
  htp.formclose;*/
end select_route_error;
--
-----------------------------------------------------------------------------
--
procedure select_route_details (p_area_type     varchar2 DEFAULT nm3extent.c_route
                        ,p_gdo_sess_id    number   DEFAULT NULL
                        ,p_function_count NUMBER   DEFAULT c_default_func_count
                        ,p_route          varchar2 default null)
is
cursor c_route_length ( p_route_unique nm_elements.ne_unique%TYPE
                      ) is
  select ne_id     
        ,ne_descr
        ,nt_linear
  from nm_elements, nm_types 
  where upper(ne_unique) = upper(p_route_unique)
  and ne_nt_type = nt_type;

  l_route_length nm_elements.ne_length%TYPE;
  l_descr nm_elements.ne_descr%TYPE;
  l_start nm_members.nm_slk%type;
  l_end nm_members.nm_slk%type;
  l_ne_id nm_elements.ne_id%type;
  l_linear NM_TYPES.NT_LINEAR%type;
begin
  open c_route_length (p_route);
  fetch c_route_length into l_ne_id, l_descr, l_linear;
  if c_route_length%notfound then
      close c_route_length;
      select_route_error(p_route);
    else
      close c_route_length;

  IF l_linear = 'Y' then 
    l_route_length:= trim(nm3unit.get_formatted_value(nm3net.get_max_slk(l_ne_id)
                                      ,NM3GET.GET_NT(PI_NT_TYPE => 
                                                      (NM3GET.GET_NE(pi_ne_id => l_ne_id).NE_NT_TYPE)
                                                    ).NT_LENGTH_UNIT));
    l_start:= nm3net.get_min_slk(l_ne_id);
    l_end:= nm3net.get_max_slk(l_ne_id);                                          
  ELSIF l_linear = 'N' then
    l_route_length:= -99;
    l_start:= -99;
    l_end:= -99;
  END IF;
--   
    dynseg_define (p_area_type      => p_area_type
                  ,p_gdo_sess_id    => p_gdo_sess_id
                  ,p_function_count => p_function_count
                  ,p_route          => p_route
                  ,pi_route_length  => l_route_length
                  ,pi_descr         => l_descr
                  ,pi_route_min     => l_start
                  ,pi_route_max     => l_end);
  end if;
end;

procedure select_route_page (p_area_type      varchar2 DEFAULT nm3extent.c_route
                            ,p_gdo_sess_id    number   DEFAULT NULL
                            ,p_function_count NUMBER   DEFAULT c_default_func_count
                            ,p_route          varchar2 default null)
is

begin

 if p_area_type != 'ROUTE' then
 	-- SM 16122008
 	-- added this if statement otherwise each of the radio buttons would take the user to the route entry screen
 	-- when this isn't requried.
   
     dynseg_define (p_area_type      => p_area_type
                  ,p_gdo_sess_id    => p_gdo_sess_id
                  ,p_function_count => p_function_count
                  ,p_route          => p_route
                  /*,pi_route_length  => l_route_length
                  ,pi_descr         => l_descr*/);
 else
   htp.bodyopen (cattributes=>'onLoad="initialise_form()"');
   do_css_link;
--   nm3web.header;
   htp.P('<!--');
   htp.P('');
   htp.P('   Start of the main body of the page');
   htp.P('');
   htp.P('-->');
   htp.P('<DIV ALIGN="CENTER">');
   
  htp.formopen(g_package_name||'.select_route_details', cattributes => 'NAME="dynseg"');
  htp.tableheader('Route');
  htp.p('<TD>');
  htp.formtext   (cname       => 'p_route'
                 ,cattributes => 'MAXLENGTH=30 SIZE=30'
                 ,cvalue      => p_route
                 );              
  HTP.FORMHIDDEN (cname       => 'p_function_count'
                 ,cattributes => 'MAXLENGTH=30 SIZE=0'
                 ,cvalue      => p_function_count
                 );
  HTP.FORMHIDDEN (cname       => 'p_area_type'
                 ,cattributes => 'MAXLENGTH=30 SIZE=0'
                 ,cvalue      => p_area_type
                 );                                    
  htp.p('</TD>');
  htp.formsubmit (cvalue=>'Continue');
  htp.formclose;
  end if;
end select_route_page;

PROCEDURE dynseg_define (p_area_type      varchar2 DEFAULT nm3extent.c_route
                        ,p_gdo_sess_id    number   DEFAULT NULL
                        ,p_function_count NUMBER   DEFAULT c_default_func_count
                        ,p_route          varchar2 default null
                        ,pi_route_length  number default null
                        ,pi_descr         varchar2 default null
                        ,pi_route_min     number default null
                        ,pi_route_max     number default null
                        ) IS
   --
   CURSOR cs_inv_types IS
   SELECT nit_inv_type
         ,nit_inv_type||' - '||REPLACE(nit_descr,'"',CHR(39)) nit_descr
         ,nit_x_sect_allow_flag
    FROM  nm_inv_types
   WHERE  EXISTS (SELECT 1
                   FROM  nm_inv_type_attribs
                  WHERE  ita_inv_type = nit_inv_type
                 )
   ORDER BY 2;
   --
   CURSOR cs_xsr (c_inv_type varchar2) IS
   SELECT DISTINCT xsr_x_sect_value
                  ,REPLACE(xsr_descr,'"',CHR(39)) xsr_descr
              --    ,xsr_descr
    FROM  xsp_restraints
   WHERE  xsr_ity_inv_code = c_inv_type
   ORDER BY xsr_descr;
   l_ind number;
   --
   CURSOR cs_ita (c_inv_type varchar2) IS
   SELECT ita_view_col_name
         ,REPLACE(ita_scrn_text,'"',CHR(39)) ita_scrn_text
--         ,ita_scrn_text
         ,ita_format
    FROM  nm_inv_type_attribs
   WHERE  ita_inv_type = c_inv_type;
   --
   l_tab_funcs nm3type.tab_varchar30;
   --
   l_tab_inv_type      nm3type.tab_varchar4;
   l_tab_inv_type_desc nm3type.tab_varchar2000;
   l_tab_inv_type_xsp  nm3type.tab_varchar4;
   --
   allow_run boolean := p_area_type IN (nm3extent.c_route, nm3extent.c_saved, c_merge, nm3extent.c_gis);
   --
   l_tab_nmq_id    nm3type.tab_number;
   l_tab_nmq_unq   nm3type.tab_varchar30;
   l_tab_nmq_descr nm3type.tab_varchar32767;
   l_tab_nmq_id_values nm3type.tab_boolean;
   --
   l_tab_nse_id    nm3type.tab_number;
   l_tab_nse_name  nm3type.tab_varchar32767;
   l_tab_nse_descr nm3type.tab_varchar32767;
   --
   l_area_type     varchar2(30) := p_area_type;
   --
   is_route        CONSTANT boolean := p_area_type = nm3extent.c_route;
   is_saved        CONSTANT boolean := p_area_type = nm3extent.c_saved;
   is_gis          CONSTANT boolean := p_area_type = nm3extent.c_gis;
   is_merge        CONSTANT boolean := p_area_type = c_merge;
   l_route_length  number default null;
   p_user_length number default null;
   p_route_start number default null;
   p_route_length number default null;
   --
BEGIN
--
   nm3web.user_can_run_module_web (c_this_module);
   --
   l_tab_funcs    := g_tab_funcs;
   l_tab_funcs(0) := NULL;
   --
   OPEN  cs_inv_types ;
   FETCH cs_inv_types BULK COLLECT INTO l_tab_inv_type,l_tab_inv_type_desc,l_tab_inv_type_xsp;
   CLOSE cs_inv_types;
   l_tab_inv_type(0)      := NULL;
   l_tab_inv_type_desc(0) := NULL;
   --
   nm3web.head (p_close_head => FALSE
               ,p_title      => c_module_title
               );
   sccs_tags;
   nm3web.js_funcs;
   htp.p('');
   htp.p('var funcs='||l_tab_funcs.COUNT);
   htp.p('var group_funcs=new Array(funcs)');
   htp.p('for (i=0; i<funcs; i++)');
   htp.p('   group_funcs[i]=new Array()');
--
   FOR i IN l_tab_funcs.first..l_tab_funcs.last
    LOOP
      htp.p('   group_funcs['||i||']=new Option("'||get_function_desc(l_tab_funcs(i))||'","'||l_tab_funcs(i)||'");');
   END LOOP;
--
   htp.p('');
   htp.p('var groups='||l_tab_inv_type.COUNT);
   htp.p('var group_xsp=new Array(groups)');
   htp.p('var group_attr=new Array(groups)');
   htp.p('var group_inv=new Array(groups)');
   htp.p('');
   htp.p('for (i=0; i<groups; i++)');
   htp.p('   {');
   htp.p('   group_inv[i]=new Array()');
   htp.p('   group_xsp[i]=new Array()');
   htp.p('   group_attr[i]=new Array()');
   htp.p('   }');
   --
   htp.p('');
   htp.p('   var choose_txt="Choose Inv Type"');
   htp.p('   group_xsp[0][0] =new Option(choose_txt,"");');
   htp.p('   group_attr[0][0]=new Option(choose_txt,"");');
   FOR i IN 1..l_tab_inv_type.last
    LOOP
      htp.p('');
      htp.p('   group_inv['||i||']   =new Option("'||l_tab_inv_type_desc(i)||'","'||l_tab_inv_type(i)||'");');
      IF l_tab_inv_type_xsp(i) = 'Y'
       THEN
         l_ind := 0;
         FOR cs_rec IN cs_xsr (l_tab_inv_type(i))
          LOOP
            htp.p('   group_xsp['||i||']['||l_ind||']=new Option("'||cs_rec.xsr_descr||'","'||cs_rec.xsr_x_sect_value||'");');
            l_ind := l_ind + 1;
         END LOOP;
      ELSE
         htp.p('   group_xsp['||i||'][0] =new Option("None","");');
      END IF;
      l_ind := 0;
      FOR cs_rec IN cs_ita (l_tab_inv_type(i))
       LOOP
         htp.p('   group_attr['||i||']['||l_ind||']=new Option("'||cs_rec.ita_scrn_text||'","'||cs_rec.ita_view_col_name||'")');
         l_ind := l_ind + 1;
      END LOOP;
   END LOOP;
   --
   htp.p('');
  -- htp.p('var temp_inv');
--   htp.p('var temp_func');
   htp.p('function initialise_form()');
   htp.p('   {');
   htp.p('   for (init_counter=0; init_counter<'||p_function_count||'; init_counter++)');
   htp.p('      {');
--   htp.p('      alert(i)');
   htp.p('      populate_each_inv(init_counter)');
   htp.p('      populate_each_func(init_counter)');
   htp.p('      set_lists_for_inv_type(0,init_counter)');
   htp.p('      }');
   FOR i IN 1..p_function_count
    LOOP
--      htp.p('   populate_each_inv('||TO_CHAR(i-1)||')');
--      htp.p('   populate_each_func('||TO_CHAR(i-1)||')');
--      htp.p('   set_lists_for_inv_type(0,'||TO_CHAR(i-1)||')');
      Null;
   END LOOP;
   htp.p('   }');
   htp.p('function populate_each_inv(ind)');
   htp.p('   {');
   htp.p('   for (m=document.dynseg.p_inv_type(ind).options.length-1;m>0;m--)');
   htp.p('      {');
   htp.p('      document.dynseg.p_inv_type(ind).options[m]=null');
   htp.p('      }');
   htp.p('   for (i=0;i<group_inv.length;i++)');
   htp.p('      {');
   htp.p('      document.dynseg.p_inv_type(ind).options[i]=new Option(group_inv[i].text,group_inv[i].value)');
   htp.p('      }');
   htp.p('   document.dynseg.p_inv_type(ind).options[0].selected=true');
   htp.p('   }');
   htp.p('function populate_each_func(ind)');
   htp.p('   {');
   htp.p('   for (m=document.dynseg.p_function(ind).options.length-1;m>0;m--)');
   htp.p('      {');
   htp.p('      document.dynseg.p_function(ind).options[m]=null');
   htp.p('      }');
   htp.p('   for (i=0;i<group_funcs.length;i++)');
   htp.p('      {');
   htp.p('      document.dynseg.p_function(ind).options[i]=new Option(group_funcs[i].text,group_funcs[i].value)');
   htp.p('      }');
   htp.p('   document.dynseg.p_function(ind).options[0].selected=true');
   htp.p('   }');
   htp.p('   ');
   htp.p('function set_lists_for_inv_type(x, ind)');
   htp.p('   {');
   htp.p('   for (m=document.dynseg.p_xsp(ind).options.length-1;m>0;m--)');
   htp.p('      document.dynseg.p_xsp(ind).options[m]=null');
   htp.p('   for (i=0;i<group_xsp[x].length;i++)');
   htp.p('      {');
   htp.p('      document.dynseg.p_xsp(ind).options[i]=new Option(group_xsp[x][i].text,group_xsp[x][i].value)');
   htp.p('      }');
   htp.p('   document.dynseg.p_xsp(ind).options[0].selected=true');
   htp.p('');
   htp.p('   for (m=document.dynseg.p_attrib(ind).options.length-1;m>0;m--)');
   htp.p('      document.dynseg.p_attrib(ind).options[m]=null');
   htp.p('   for (i=0;i<group_attr[x].length;i++)');
   htp.p('      {');
   htp.p('      document.dynseg.p_attrib(ind).options[i]=new Option(group_attr[x][i].text,group_attr[x][i].value)');
   htp.p('      }');
   htp.p('   document.dynseg.p_attrib(ind).options[0].selected=true');
   htp.p('   }');
   htp.p('');
   --
   IF is_saved
    THEN
      DECLARE
         CURSOR cs_nse IS
         SELECT nse_id
               ,nse_name||DECODE(nse_owner,'PUBLIC',' ('||nse_owner||')',NULL) nse_name
               ,REPLACE(nse_descr,'"',CHR(39)) nse_descr
          FROM  nm_saved_extents
         WHERE  nse_owner IN (Sys_Context('NM3_SECURITY_CTX','USERNAME'),'PUBLIC')
         ORDER BY nse_name;
      BEGIN
         OPEN  cs_nse;
         FETCH cs_nse BULK COLLECT INTO l_tab_nse_id, l_tab_nse_name, l_tab_nse_descr;
         CLOSE cs_nse;
         l_tab_nse_id(0)    := NULL;
         l_tab_nse_name(0)  := 'Select Network Extent';
         l_tab_nse_descr(0) := nm3web.c_nbsp;
         --
         htp.p('var saveds='||l_tab_nmq_id.COUNT);
         htp.p('var saved_desc=new Array(saveds)');
         htp.p('');
         htp.p('for (i=0; i<saveds; i++)');
         htp.p('   {');
         htp.p('   saved_desc[i]=new Array()');
         htp.p('   }');
         htp.p('');
         FOR i IN l_tab_nse_id.first..l_tab_nse_id.last
          LOOP
            htp.p('   saved_desc['||i||']="'||l_tab_nse_descr(i)||'"');
         END LOOP;
         htp.p('');
         htp.p('function set_box_nse(y)');
         htp.p('   {');
         htp.p('   document.saved_dets.nse_descr.value=saved_desc[y]');
         htp.p('   }');
         htp.p('');
         --
      END;
   ELSIF is_merge
    THEN
      DECLARE
         CURSOR cs_merges IS
         SELECT nmq_id
               ,nmq_unique
               ,REPLACE(nmq_descr,'"',CHR(39)) nmq_descr
          FROM  nm_mrg_query
         WHERE EXISTS (SELECT 1
                        FROM  nm_mrg_query_results
                       WHERE  nmq_id = nqr_nmq_id
                        AND   nm3extent.get_unique_from_source(nqr_source_id, nqr_source,'Y') IS NOT NULL
                      )
         ORDER BY nmq_unique;
         CURSOR cs_nqr (c_nmq_id number) IS
         SELECT *
          FROM (SELECT nqr_mrg_job_id
                      ,REPLACE(nqr_description,'"',CHR(39)) nqr_description
                      ,nm3extent.get_unique_from_source(nqr_source_id, nqr_source,'Y') nqr_unique
                      ,nqr_date_created
                FROM  nm_mrg_query_results
               WHERE  nqr_nmq_id = c_nmq_id
              )
         WHERE  nqr_unique IS NOT NULL;
      BEGIN
         --
         OPEN  cs_merges;
         FETCH cs_merges BULK COLLECT INTO l_tab_nmq_id, l_tab_nmq_unq, l_tab_nmq_descr;
         CLOSE cs_merges;
         l_tab_nmq_id(0)    := NULL;
         l_tab_nmq_unq(0)   := 'Select Merge Query';
         l_tab_nmq_descr(0) := nm3web.c_nbsp;
         --
         htp.p('var merges='||l_tab_nmq_id.COUNT);
         htp.p('var merge_runs=new Array(merges)');
         htp.p('var merge_desc=new Array(merges)');
         htp.p('var merge_run_desc=new Array(merges)');
         htp.p('');
         htp.p('for (i=0; i<merges; i++)');
         htp.p('   {');
         htp.p('   merge_run_desc[i]=new Array()');
         htp.p('   merge_runs[i]=new Array()');
         htp.p('   }');
         htp.p('');
         FOR i IN 1..l_tab_nmq_id.last
          LOOP
            l_ind := 0;
            htp.p('   merge_desc['||i||']="'||l_tab_nmq_descr(i)||'";');
            FOR cs_rec IN cs_nqr (l_tab_nmq_id(i))
             LOOP
               htp.p('   merge_runs['||i||']['||l_ind||']=new Option("'||cs_rec.nqr_description||'","'||cs_rec.nqr_mrg_job_id||'");');
               htp.p('   merge_run_desc['||i||']['||l_ind||']="'||cs_rec.nqr_unique||' - '||TO_CHAR(cs_rec.nqr_date_created,'DD/MM/YYYY HH24:MI:SS')||'"');
               l_ind := l_ind + 1;
            END LOOP;
         END LOOP;
         --
         htp.p('function set_lists_nmq(x)');
         htp.p('   {');
         htp.p('   for (m=document.dynseg.p_nqr_job_id.options.length-1;m>0;m--)');
         htp.p('      document.dynseg.p_nqr_job_id.options[m]=null');
         htp.p('   for (i=0;i<merge_runs[x].length;i++)');
         htp.p('      {');
         htp.p('      document.dynseg.p_nqr_job_id.options[i]=new Option(merge_runs[x][i].text,merge_runs[x][i].value)');
         htp.p('      }');
         htp.p('   document.dynseg.p_nqr_job_id.options[0].selected=true');
         htp.p('   document.merge_dets.nmq_descr.value=merge_desc[x]');
--         htp.p('   document.merge_dets.nqr_dets.value=""');
         htp.p('   set_box_nqr(0)');
         htp.p('   }');
         htp.p('function set_box_nqr(y)');
         htp.p('   {');
         htp.p('   document.merge_dets.nqr_dets.value=""');
         htp.p('   var x=document.dynseg.p_nmq_id.options.selectedIndex');
         htp.p('   document.merge_dets.nqr_dets.value=merge_run_desc[x][y]');
         htp.p('   }');
      END;
   END IF;
   htp.p('//-->');
   htp.p('</SCRIPT>');
   htp.headclose;

   htp.bodyopen (cattributes=>'onLoad="initialise_form()"');
--   nm3web.header;
   htp.p('<!--');
   htp.p('');
   htp.p('   Start of the main body of the page');
   htp.p('');
   htp.p('-->');
   htp.p('<DIV ALIGN="CENTER">');
   --
   --
   --cws p_area_type check
 --  IF p_area_type = 'ROUTE' THEN
   htp.formopen(g_package_name||'.check_route_length', cattributes => 'NAME="dynseg"');
 --  END IF;
   
   htp.formopen(g_package_name||'.run_dynseg');--, cattributes => 'NAME="dynseg"');--templine

   htp.tableopen;
   htp.tablerowopen;
   htp.tableheader('Function');
   htp.tableheader(nm3web.c_nbsp);
   htp.tableheader('Inventory Type');
   htp.tableheader('XSP');
   htp.tableheader('Attribute');
   htp.tablerowclose;

   FOR i IN 1..p_function_count
    LOOP
      htp.p('<!-- '||TO_CHAR(i-1)||' -->');
      htp.tablerowopen;
      htp.p('<TD><SELECT NAME="p_function"></SELECT></TD>');
      htp.p('<TD>'||nm3web.c_nbsp||'</TD>');
      htp.p('<TD><SELECT NAME="p_inv_type" onChange="set_lists_for_inv_type(this.options.selectedIndex,'||TO_CHAR(i-1)||')"></SELECT></TD>');
      htp.p('<TD><SELECT NAME="p_xsp"></SELECT></TD>');
      htp.p('<TD><SELECT NAME="p_attrib"></SELECT></TD>');
      htp.tablerowclose;
   END LOOP;
   htp.tableclose;
   htp.hr (cattributes => 'WIDTH=75%');
   --
   htp.tableopen;
   htp.tablerowopen;
   IF is_route
    THEN
      htp.tableheader('Route:', cattributes => 'ALIGN="right"');
      htp.p('<TD>');
      htp.p(p_route);
      htp.tablerowopen;
      htp.tableheader('Route description:', cattributes => 'ALIGN="right"');
      htp.p('<TD>'||pi_descr||'</TD>');
      /*htp.formtext   (cname       => 'p_route'
                     ,cattributes => 'MAXLENGTH=30 SIZE=30'
                     ,cvalue      => p_route
                     );*/
      htp.p('</TD>');
      htp.tablerowopen;
      htp.tableheader('Route Measures (opt)', cattributes => 'ALIGN="right"');
      htp.tablerowopen;
      htp.p('<TD ALIGN="right">From</TD>');
      htp.p('<TD>');
      htp.formtext   (cname       => 'p_slk_from'
                     ,cattributes => 'SIZE=5'
                     ,cvalue      => pi_route_min
                     );
      htp.p('</TD>');
      htp.p('<TD ALIGN="right">To</TD>');
      htp.p('<TD>');
      htp.formtext   (cname       => 'p_slk_to'
                     ,cattributes => 'SIZE=5'
                     ,cvalue      => pi_route_max
                     );
      htp.p('</TD>');
      if pi_route_length is not null then
        htp.formhidden (cname  => 'pi_route_length'
                       ,cvalue => pi_route_length
                       );
      end if;

      if p_route is not null then
        htp.formhidden (cname  => 'p_route'
                       ,cvalue => p_route
                       );
      end if;
   ELSIF is_saved
    THEN
      htp.tableheader('Saved Network Extent');
      htp.p('<TD>');
      htp.p('<SELECT NAME="p_saved_ne_id" onChange="set_box_nse(this.options.selectedIndex)">');
      FOR i IN l_tab_nse_id.first..l_tab_nse_id.last
       LOOP
         htp.p('<OPTION VALUE="'||l_tab_nse_id(i)||'">'||l_tab_nse_name(i)||'</OPTION>');
      END LOOP;
      htp.p('</SELECT>');
      htp.p('</TD>');
   ELSIF is_merge
    THEN
      htp.tableheader('Merge Query');
      htp.p('<TD>');
      htp.p('<SELECT NAME="p_nmq_id" onChange="set_lists_nmq(this.options.selectedIndex)">');
      FOR i IN l_tab_nmq_id.first..l_tab_nmq_id.last
       LOOP
         htp.p('<OPTION VALUE="'||l_tab_nmq_id(i)||'">'||l_tab_nmq_unq(i)||'</OPTION>');
      END LOOP;
      htp.p('</SELECT>');
      htp.p('</TD>');
      htp.tableheader('Result Set');
      htp.p('<TD>');
      htp.p('<SELECT NAME="p_nqr_job_id" onChange="set_box_nqr(this.options.selectedIndex)">');
      htp.p('<OPTION VALUE="">'||l_tab_nmq_unq(0)||'</OPTION>');
      htp.p('</SELECT>');
      htp.p('</TD>');
   ELSIF is_gis
    THEN
      htp.formhidden (cname  => 'p_gdo_sess_id'
                     ,cvalue => p_gdo_sess_id
                     );
   END IF;
   htp.p('<TD>');
   htp.formhidden (cname =>'p_source'
                  ,cvalue=>l_area_type
                  );
   IF allow_run
    THEN
        htp.formsubmit (cvalue=>'Run');
   ELSE
      htp.p('Invalid Area Source "'||l_area_type||'"');
   END IF;
   htp.p('</TD>');
   htp.formclose;
   htp.tablerowclose;
   IF is_saved
    THEN
      htp.tablerowopen;
      htp.formopen(curl        => '#'
                  ,cattributes => 'NAME="saved_dets"'
                  );
      htp.p('<TD>');
      htp.p(nm3web.c_nbsp);
      htp.p('</TD>');
      htp.p('<TD COLSPAN="2">');
      htp.formtext(cname       => 'nse_descr'
                  ,cvalue      => nm3web.c_nbsp
                  ,cattributes => 'DISABLED'
                  ,csize       => '40'
                  );
      htp.p('</TD>');
      htp.formclose;
      htp.tablerowclose;
   ELSIF is_merge
    THEN
      htp.tablerowopen;
      htp.formopen(curl        => '#'
                  ,cattributes => 'NAME="merge_dets"'
                  );
      htp.p('<TD>');
      htp.p(nm3web.c_nbsp);
      htp.p('</TD>');
      htp.p('<TD COLSPAN="2">');
      htp.formtext(cname       => 'nmq_descr'
                  ,cvalue      => nm3web.c_nbsp
                  ,cattributes => 'DISABLED'
                  ,csize       => '40'
                  );
      htp.p('</TD>');
--      htp.p('<TD>');
--      htp.p(nm3web.c_nbsp);
--      htp.p('</TD>');
      htp.p('<TD COLSPAN="2">');
      htp.formtext(cname       => 'nqr_dets'
                  ,cvalue      => nm3web.c_nbsp
                  ,cattributes => 'DISABLED'
                  ,csize       => '40'
                  );
      htp.p('</TD>');
      htp.formclose;
      htp.tablerowclose;
   END IF;
   htp.tableclose;
   htp.p('</DIV>');
   --
   htp.p('<!--');
   htp.p('');
   htp.p('   End of the main body of the page');
   htp.p('');
   htp.p('-->');
--   nm3web.footer;
   htp.bodyclose;
   htp.htmlclose;
--
--EXCEPTION
----
--  WHEN nm3web.g_you_should_not_be_here THEN NULL;
----
--  WHEN others
--   THEN
----     htp.p('</SCRIPT>');
----     htp.p('<SCRIPT>');
----     htp.p('   alert("'||nm3flx.parse_error_message(SQLERRM)||'")');
----     htp.p('   history.go(-1);');
----     htp.p('</SCRIPT>');
----     htp.bodyclose;
----     htp.htmlclose;
--     nm3web.failure(SQLERRM);
   --
END dynseg_define;
--
-----------------------------------------------------------------------------
--
PROCEDURE main IS
   l_tab_value  nm3type.tab_varchar30;
   l_tab_prompt nm3type.tab_varchar30;
   l_checked    varchar2(8) := ' CHECKED';
BEGIN
--
   l_tab_value(1)  := nm3extent.c_route;
   l_tab_prompt(1) := 'Route';
   l_tab_value(2)  := nm3extent.c_saved;
   l_tab_prompt(2) := 'Saved Network Extent';
   l_tab_value(3)  := c_merge;
   l_tab_prompt(3) := 'Merge Results';
--
   nm3web.head (p_title      => c_module_title);
   sccs_tags;
   htp.bodyopen;

   nm3web.module_startup(pi_module => c_this_module);
   
--   nm3web.header;
   htp.p('<DIV ALIGN="CENTER">');
   htp.formopen(g_package_name||'.select_route_page', cattributes => 'NAME="source_def"');--templine
   htp.tableopen;
   htp.p('<TR>');
   htp.p('<TD COLSPAN=2>'||htf.hr||'</TD>');
   htp.p('</TR>');
   htp.p('<TR>');
   htp.p('<TD COLSPAN=2 ALIGN=CENTER>');
      htp.tableopen;
      htp.tablerowopen;
      htp.tableheader('Enter Area Source for Engineering DynSeg', cattributes=>'COLSPAN=2');
      htp.tablerowclose;
      --
      FOR i IN 1..l_tab_value.COUNT
       LOOP
         htp.tablerowopen(cattributes=>'ALIGN=CENTER');
         htp.tabledata(l_tab_prompt(i));
         htp.p('<TD><INPUT TYPE=RADIO NAME="p_area_type" VALUE="'||l_tab_value(i)||'"'||l_checked||'></TD>');
         l_checked := NULL;
         htp.tablerowclose;
      END LOOP;
      htp.tableclose;
   --
   htp.p('</TD>');
   htp.p('<TR>');
   htp.p('<TD COLSPAN=2>'||htf.hr||'</TD>');
   htp.p('</TR>');
   htp.p('<TR>');
   htp.tableheader('Select Number of Functions reqd.');
   htp.p('<TD>');
   htp.p('<SELECT NAME="p_function_count">');
   FOR i IN 2..c_poss_func_count
    LOOP
      DECLARE
         l_selected VARCHAR2(20);
      BEGIN
         IF i = c_default_func_count
          THEN
            l_selected := ' SELECTED';
         END IF;
         htp.p('<OPTION VALUE="'||i||'"'||l_selected||'>'||i||'</OPTION>');
      END;
   END LOOP;
   htp.p('</SELECT>');
   htp.p('</TD>');
   htp.p('<TR>');
   htp.p('<TD COLSPAN=2 ALIGN=RIGHT><FONT SIZE=-2><I>Note : You are allowed fewer function calls than this number</I></FONT></TD>');
   htp.p('</TR>');
   htp.p('</TR>');
   htp.p('<TR>');
   htp.p('<TD COLSPAN=2>'||htf.hr||'</TD>');
   htp.p('</TR>');
   --
   htp.tableclose;
   htp.formsubmit (cvalue=>'Continue');
   htp.formclose;
   --
   htp.p('</DIV>');
--   nm3web.footer;
   htp.bodyclose;
   htp.htmlclose;
--
EXCEPTION
--
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
--
  WHEN others
   THEN
     htp.p('<SCRIPT>');
     htp.p('   alert("'||nm3flx.parse_error_message(SQLERRM)||'")');
     htp.p('   history.go(-1);');
     htp.p('</SCRIPT>');
     htp.bodyclose;
     htp.htmlclose;
   --
--
END main;
--
-----------------------------------------------------------------------------
--
PROCEDURE run_dynseg (p_source      IN VARCHAR2
                     ,p_route       IN VARCHAR2           DEFAULT NULL
                     ,p_slk_from    IN NUMBER             DEFAULT NULL
                     ,p_slk_to      IN NUMBER             DEFAULT NULL
                     ,p_saved_ne_id IN NUMBER             DEFAULT NULL
                     ,p_nmq_id      IN NUMBER             DEFAULT NULL
                     ,p_nqr_job_id  IN NUMBER             DEFAULT NULL
                     ,p_gdo_sess_id IN NUMBER             DEFAULT NULL
                     ,p_function    IN owa_util.ident_arr DEFAULT g_empty_tab
                     ,p_inv_type    IN owa_util.ident_arr DEFAULT g_empty_tab
                     ,p_attrib      IN owa_util.ident_arr DEFAULT g_empty_tab
                     ,p_xsp         IN owa_util.ident_arr DEFAULT g_empty_tab
                     ) IS
--
   l_tab_function nm3type.tab_varchar30;
   l_tab_inv_type nm3type.tab_varchar4;
   l_tab_attrib   nm3type.tab_varchar30;
   l_tab_xsp      nm3type.tab_varchar4;
--
   l_count        pls_integer := 0;
--
   l_i            pls_integer;
--
   PROCEDURE add_it (p_func varchar2
                    ,p_inv  varchar2
                    ,p_attr varchar2
                    ,p_xsp  varchar2
                    ) IS
   BEGIN
      IF   p_func IS NOT NULL
       AND p_inv  IS NOT NULL
       AND p_attr IS NOT NULL
       THEN
         l_count := l_count + 1;
         l_tab_function(l_count) := p_func;
         l_tab_inv_type(l_count) := p_inv;
         l_tab_attrib(l_count)   := p_attr;
         l_tab_xsp(l_count)      := p_xsp;
--         nm_debug.debug(p_inv);
      END IF;
   END add_it;

--
BEGIN
--
   l_i := p_function.FIRST;
   WHILE l_i IS NOT NULL
    LOOP
      add_it (p_function(l_i),p_inv_type(l_i),p_attrib(l_i),p_xsp(l_i));
      l_i := p_function.next(l_i);
   END LOOP;
--
   IF l_count > 0 THEN
     run_dynseg_arr
              (p_source       => p_source
              ,p_route        => UPPER(p_route)
              ,p_slk_from     => p_slk_from
              ,p_slk_to       => p_slk_to
              ,p_saved_ne_id  => p_saved_ne_id
              ,p_nqr_job_id   => p_nqr_job_id
              ,p_gdo_sess_id  => p_gdo_sess_id
              ,p_tab_function => l_tab_function
              ,p_tab_inv_type => l_tab_inv_type
              ,p_tab_attrib   => l_tab_attrib
              ,p_tab_xsp      => l_tab_xsp
              );
   ELSE
     select_route_error (p_error => c_func_no_vals);
   END IF;
--
END run_dynseg;
--
-----------------------------------------------------------------------------
--
PROCEDURE run_dynseg_arr
                     (p_source       IN varchar2
                     ,p_route        IN varchar2 DEFAULT NULL
                     ,p_slk_from     IN number   DEFAULT NULL
                     ,p_slk_to       IN number   DEFAULT NULL
                     ,p_saved_ne_id  IN number   DEFAULT NULL
                     ,p_nqr_job_id   IN number   DEFAULT NULL
                     ,p_gdo_sess_id  IN number   DEFAULT NULL
                     ,p_tab_function IN nm3type.tab_varchar30
                     ,p_tab_inv_type IN nm3type.tab_varchar4
                     ,p_tab_attrib   IN nm3type.tab_varchar30
                     ,p_tab_xsp      IN nm3type.tab_varchar4
                     ) IS
   --
   PRAGMA autonomous_transaction;
   --
   l_job_id       number;
   l_source_ne_id number;
   --
   l_tab_description nm3type.tab_varchar2000;
   --
   l_start_time      pls_integer;
   l_intermed_time   pls_integer;
   l_stop_time       pls_integer;
   --
   dont_run EXCEPTION;

   l_default_route_as_parent BOOLEAN := FALSE;
   --
BEGIN
--
   nm3web.user_can_run_module_web (c_this_module);
   --
   nm3web.head(p_title => c_module_title);
   htp.bodyopen;
   --
   IF   p_tab_function.COUNT  = 0
    OR  p_tab_function.COUNT != p_tab_inv_type.COUNT
    OR (p_source = nm3extent.c_route AND p_route       IS NULL)
    OR (p_source = nm3extent.c_saved AND p_saved_ne_id IS NULL)
    OR (p_source = c_merge           AND p_nqr_job_id  IS NULL)
    OR (p_source = nm3extent.c_gis   AND p_gdo_sess_id IS NULL)
    THEN
   --   nm3web.failure(hig.raise_and_catch_ner(nm3type.c_net,310));
--      htp.p('<SCRIPT>');
--      htp.p('   alert("'||||'")');
--      htp.p('   history.go(-1);');
--      htp.p('</SCRIPT>');
--      htp.bodyclose;
--      htp.htmlclose;
      RAISE dont_run;
   END IF;
   --
--   nm3web.header;
   --
   IF p_source = nm3extent.c_route
    THEN
      l_source_ne_id := nm3net.get_ne_id (p_route);
   --
      IF  (p_slk_from IS NULL AND p_slk_to IS NOT NULL)
       OR (p_slk_from IS NOT NULL AND p_slk_to IS NULL)
       THEN
         Raise_Application_Error(-20001,'Either 0 or 2 route measures passed');
      END IF;
      --
      IF  NOT nm3flx.is_numeric(p_slk_from)
       OR NOT nm3flx.is_numeric(p_slk_to)
       THEN
         Raise_Application_Error(-20001,'Route measures passed must be numeric');
      END IF;
   ELSIF p_source = nm3extent.c_saved
    THEN
      l_source_ne_id := p_saved_ne_id;
   ELSIF p_source = nm3extent.c_gis
    THEN
      l_source_ne_id := p_gdo_sess_id;
   END IF;
   --
   l_start_time := dbms_utility.get_time;
   --
   g_tab_value.DELETE;
   l_tab_description.DELETE;
   --
   htp.p('<H3>Engineering DynSeg Results</H3>');
   --
   htp.hr (cattributes => 'WIDTH=75%');
   --
   g_tab_is_obj.DELETE;
--   nm_debug.delete_debug(TRUE);
--   nm_debug.set_level(3);
--   nm_debug.debug_on;
   FOR i IN 1..p_tab_function.COUNT
    LOOP
      FOR j IN 1..g_tab_funcs.COUNT
       LOOP
         IF p_tab_function(i) = g_tab_funcs(j)
          THEN
            IF g_tab_funcs_ret_obj_type.EXISTS(j)
             AND g_tab_funcs_ret_obj_type(j) IS NOT NULL
             THEN
               g_tab_is_obj(i) := g_tab_funcs_ret_obj_type(j);
--               nm_debug.debug(p_tab_function(i)||' is a object');
            ELSE
               g_tab_is_obj(i) := NULL;
--               nm_debug.debug(p_tab_function(i)||' is not a object');
            END IF;
            EXIT;
         END IF;
      END LOOP;
   END LOOP;
   --
   IF p_source IN (nm3extent.c_route,nm3extent.c_saved,nm3extent.c_gis)
    THEN
      if p_source = nm3extent.c_route then
        l_default_route_as_parent := TRUE;
      else
        l_default_route_as_parent := FALSE;
      end if;

      nm3extent.create_temp_ne (pi_source_id => l_source_ne_id
                               ,pi_source    => p_source
                               ,pi_begin_mp  => p_slk_from
                               ,pi_end_mp    => p_slk_to
                               ,po_job_id    => l_job_id
                               ,pi_default_source_as_parent => l_default_route_as_parent
                               );
   --
      l_intermed_time := dbms_utility.get_time;
      --
      nm3ddl.delete_tab_varchar;
      --
      nm3ddl.append_tab_varchar ('DECLARE');
      nm3ddl.append_tab_varchar ('   CURSOR cs_run (p_nte_job_id NUMBER) IS');
      nm3ddl.append_tab_varchar ('   SELECT p_nte_job_id');
      FOR i IN 1..p_tab_function.COUNT
       LOOP
         l_tab_description(i) := get_function_desc(p_tab_function(i))||' - '||nm3inv.get_inv_type(p_tab_inv_type(i)).nit_descr||' - ';
         IF p_tab_xsp(i) IS NOT NULL
          THEN
            l_tab_description(i) :=  l_tab_description(i)||p_tab_xsp(i)||' - ';
         END IF;
         l_tab_description(i) :=  l_tab_description(i)||nm3inv.get_ita_by_view_col(p_tab_inv_type(i),p_tab_attrib(i)).ita_scrn_text;
         nm3ddl.append_tab_varchar ('         ,'||g_dynseg_pack_name||'.'||p_tab_function(i)||'(p_nte_job_id,'||nm3flx.string(p_tab_inv_type(i)));
         IF p_tab_xsp(i) IS NOT NULL
          THEN
            nm3ddl.append_tab_varchar (','||nm3flx.string(p_tab_xsp(i)),FALSE);
         END IF;
         nm3ddl.append_tab_varchar (','||nm3flx.string(p_tab_attrib(i))||')',FALSE);
      END LOOP;
      nm3ddl.append_tab_varchar ('         ,sysdate');
      nm3ddl.append_tab_varchar ('   FROM dual;');
      nm3ddl.append_tab_varchar ('   l_dummy      NUMBER;');
      nm3ddl.append_tab_varchar ('   l_dummy_date DATE;');
      nm3ddl.append_tab_varchar ('BEGIN');
      nm3ddl.append_tab_varchar ('   OPEN  cs_run ('||l_job_id||');');
      nm3ddl.append_tab_varchar ('   FETCH cs_run INTO l_dummy');
      FOR i IN 1..p_tab_function.COUNT
       LOOP
         IF g_tab_is_obj(i) = c_nm_val_dist
          THEN
            nm3ddl.append_tab_varchar ('                       ,'||g_package_name||'.g_tab_val_obj('||i||')');
         ELSIF g_tab_is_obj(i) = c_nm_val_dist_arr
          THEN
            nm3ddl.append_tab_varchar ('                       ,'||g_package_name||'.g_tab_val_obj_arr_'||i);
         ELSE
            nm3ddl.append_tab_varchar ('                       ,'||g_package_name||'.g_tab_value('||i||')');
         END IF;
      END LOOP;
      nm3ddl.append_tab_varchar ('                    ,l_dummy_date;');
      nm3ddl.append_tab_varchar ('   CLOSE cs_run;');
      nm3ddl.append_tab_varchar ('END;');
   --
--      nm_debug.debug(nm3ddl.g_tab_varchar(1));
      nm3ddl.execute_tab_varchar;
      --
      l_stop_time := dbms_utility.get_time;
      --
      htp.tableopen(cborder => 'BORDER=1');
      FOR i IN 1..l_tab_description.COUNT
       LOOP
         htp.tablerowopen;
         htp.tableheader(l_tab_description(i));
         IF g_tab_is_obj(i) = c_nm_val_dist
          THEN
            htp.tabledata(g_tab_val_obj(i).return_string);
         ELSIF g_tab_is_obj(i) = c_nm_val_dist_arr
          THEN
            DECLARE
               l_tab_vc nm3type.tab_varchar32767;
            BEGIN
               l_tab_vc := internal_produce_html_table (i);
               FOR j IN 1..l_tab_vc.COUNT
                LOOP
                  htp.tabledata(l_tab_vc(j));
               END LOOP;
            END;
         ELSE
            IF g_tab_value(i) IS NOT NULL
             THEN
               htp.tabledata(round(g_tab_value(i),2));
            ELSE
               htp.tabledata(nm3web.c_nbsp);
            END IF;
         END IF;
         htp.tablerowclose;
      END LOOP;
      htp.tableclose;
      --
   ELSIF p_source = c_merge
    THEN
    --
      htp.tableopen(cborder => 'BORDER=1');
      htp.tablerowopen;
      htp.tableheader('Offsets',cattributes=> 'COLSPAN="4"');
      FOR i IN 1..p_tab_function.COUNT
       LOOP
         l_tab_description(i) := get_function_desc(p_tab_function(i))||' - '||nm3inv.get_inv_type(p_tab_inv_type(i)).nit_descr||' - ';
         IF p_tab_xsp(i) IS NOT NULL
          THEN
            l_tab_description(i) :=  l_tab_description(i)||p_tab_xsp(i)||' - ';
         END IF;
         l_tab_description(i) :=  l_tab_description(i)||nm3inv.get_ita_by_view_col(p_tab_inv_type(i),p_tab_attrib(i)).ita_scrn_text;
      END LOOP;
      FOR i IN 1..l_tab_description.COUNT
       LOOP
         htp.tableheader(l_tab_description(i));
      END LOOP;
      htp.tablerowclose;
      --
      nm3ddl.delete_tab_varchar;
      --
      nm3ddl.append_tab_varchar ('DECLARE');
      nm3ddl.append_tab_varchar ('   CURSOR cs_run (p_mrg_job_id NUMBER) IS');
      nm3ddl.append_tab_varchar ('   SELECT nms_mrg_section_id');
      nm3ddl.append_tab_varchar ('         ,nms_offset_ne_id');
      nm3ddl.append_tab_varchar ('         ,nms_begin_offset');
      nm3ddl.append_tab_varchar ('         ,nms_end_offset');
      nm3ddl.append_tab_varchar ('         ,nms_ne_id_first');
      nm3ddl.append_tab_varchar ('         ,nms_begin_mp_first');
      nm3ddl.append_tab_varchar ('         ,nms_ne_id_last');
      nm3ddl.append_tab_varchar ('         ,nms_end_mp_last');




      FOR i IN 1..p_tab_function.COUNT
       LOOP
         nm3ddl.append_tab_varchar ('         ,'||g_dynseg_pack_name||'.'||p_tab_function(i)||'(nms_mrg_job_id,nms_mrg_section_id,'||nm3flx.string(p_tab_inv_type(i)));
         IF p_tab_xsp(i) IS NOT NULL
          THEN
            nm3ddl.append_tab_varchar (','||nm3flx.string(p_tab_xsp(i)),FALSE);
         END IF;
         nm3ddl.append_tab_varchar (','||nm3flx.string(p_tab_attrib(i))||')',FALSE);
      END LOOP;
      nm3ddl.append_tab_varchar ('    FROM nm_mrg_sections');
      nm3ddl.append_tab_varchar ('   WHERE nms_mrg_job_id = p_mrg_job_id');
      nm3ddl.append_tab_varchar ('   ORDER BY nms_mrg_section_id;');
      nm3ddl.append_tab_varchar ('--');
      nm3ddl.append_tab_varchar ('BEGIN');
      nm3ddl.append_tab_varchar ('   OPEN  cs_run ('||p_nqr_job_id||');');
      nm3ddl.append_tab_varchar ('   LOOP');
      nm3ddl.append_tab_varchar ('      FETCH cs_run INTO '||g_package_name||'.g_nms_section');
      nm3ddl.append_tab_varchar ('                       ,'||g_package_name||'.g_offset_ne_id');
      nm3ddl.append_tab_varchar ('                       ,'||g_package_name||'.g_begin_offset');
      nm3ddl.append_tab_varchar ('                       ,'||g_package_name||'.g_end_offset');
      nm3ddl.append_tab_varchar ('                       ,'||g_package_name||'.g_nms_ne_id_first');
      nm3ddl.append_tab_varchar ('                       ,'||g_package_name||'.g_nms_begin_mp_first');
      nm3ddl.append_tab_varchar ('                       ,'||g_package_name||'.g_nms_ne_id_last');
      nm3ddl.append_tab_varchar ('                       ,'||g_package_name||'.g_nms_end_mp_last');
      FOR i IN 1..p_tab_function.COUNT
       LOOP
         IF g_tab_is_obj(i) = c_nm_val_dist
          THEN
            nm3ddl.append_tab_varchar ('                       ,'||g_package_name||'.g_tab_val_obj('||i||')');
         ELSIF g_tab_is_obj(i) = c_nm_val_dist_arr
          THEN
            nm3ddl.append_tab_varchar ('                       ,'||g_package_name||'.g_tab_val_obj_arr_'||i);
         ELSE
            nm3ddl.append_tab_varchar ('                       ,'||g_package_name||'.g_tab_value('||i||')');
         END IF;
      END LOOP;
      nm3ddl.append_tab_varchar (';',FALSE);
      nm3ddl.append_tab_varchar ('      EXIT WHEN cs_run%NOTFOUND;');
      nm3ddl.append_tab_varchar ('      '||g_package_name||'.write_merge_table_entry;');
      nm3ddl.append_tab_varchar ('   END LOOP;');
      nm3ddl.append_tab_varchar ('   CLOSE cs_run;');
      nm3ddl.append_tab_varchar ('END;');
   --
--      nm_debug.debug(nm3ddl.g_tab_varchar(1));
      nm3ddl.execute_tab_varchar;
      --
      l_stop_time := dbms_utility.get_time;
      --
      htp.tableclose;
      --
   END IF;
   htp.hr (cattributes => 'WIDTH=75%');
   --
   htp.br;
   htp.br;
   htp.br;
   htp.tableopen(cborder => 'BORDER=1');
   htp.tablerowopen;
   htp.tableheader('<SMALL>Total Run Time</SMALL>');
   htp.tabledata('<SMALL>'||nm3flx.convert_seconds_to_hh_mi_ss((l_stop_time-l_start_time)/100)||'</SMALL>');
   htp.tablerowclose;
   IF l_intermed_time IS NOT NULL
    THEN
      htp.tablerowopen;
      htp.tableheader('<SMALL>Temp NE Creation</SMALL>');
      htp.tabledata('<SMALL>'||nm3flx.convert_seconds_to_hh_mi_ss((l_intermed_time-l_start_time)/100)||'</SMALL>');
      htp.tablerowclose;
      htp.tablerowopen;
      htp.tableheader('<SMALL>Eng Dynseg Run</SMALL>');
      htp.tabledata('<SMALL>'||nm3flx.convert_seconds_to_hh_mi_ss((l_stop_time-l_intermed_time)/100)||'</SMALL>');
      htp.tablerowclose;
   END IF;
   htp.tableclose;
   --
--   nm3web.footer;
   htp.bodyclose;
   htp.htmlclose;
   --
   COMMIT;
   --
EXCEPTION
--
   WHEN dont_run
    OR  nm3web.g_you_should_not_be_here
    THEN
      ROLLBACK;
      raise_error(hig.raise_and_catch_ner(nm3type.c_net,310));
--
  WHEN others
   THEN
     ROLLBACK;
     raise_error(SQLERRM);

END run_dynseg_arr;
--
-----------------------------------------------------------------------------
--
FUNCTION get_function_desc (p_func varchar2) RETURN varchar2 IS
--
   l_func   varchar2(30) := p_func;
--
BEGIN
   IF SUBSTR(l_func,1,4) = 'GET_'
    THEN
      l_func := SUBSTR(l_func,5);
   END IF;
   RETURN INITCAP(REPLACE(l_func,'_',' '));
END get_function_desc;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_merge_table_entry IS
   i pls_integer;
   --
   l_ind number := 1;
   l_tab_varchar nm3type.tab_varchar32767;
   --
   l_rec_ne nm_elements%ROWTYPE;
   --
   l_units  nm_units.un_unit_id%TYPE;
   --
   l_st_ne_id  nm_elements.ne_id%TYPE;
   l_end_ne_id nm_elements.ne_id%TYPE;
   l_auto_incl BOOLEAN;
   --
   l_st_offset  NUMBER;
   l_end_offset NUMBER;
   --
   PROCEDURE append (p_text varchar2) IS
   BEGIN
      IF LENGTH (p_text) + LENGTH(l_tab_varchar(l_ind)) > 32767
       THEN
         l_ind                := l_ind + 1;
         l_tab_varchar(l_ind) := NULL;
      END IF;
      l_tab_varchar(l_ind) := l_tab_varchar(l_ind)||p_text;
   END append;
   --
BEGIN
--
   l_tab_varchar(1) := NULL;
--
   l_st_ne_id   := g_offset_ne_id;
   l_st_offset  := g_begin_offset;
   l_end_offset := g_end_offset;
--
   IF   g_offset_ne_id  = g_nms_ne_id_first
    AND g_offset_ne_id != g_nms_ne_id_last
    THEN
      l_auto_incl  := FALSE;
      l_end_ne_id  := g_nms_ne_id_last;
      l_st_offset  := g_nms_begin_mp_first;
      l_end_offset := g_nms_end_mp_last;
   ELSE
      l_auto_incl  := TRUE;
      l_end_ne_id  := g_offset_ne_id;
   END IF;
--
   append ('<TR><!-- '||g_nms_section||'-->');
   append('<TD>');
   IF g_offset_ne_id IS NOT NULL
    THEN
      l_rec_ne := nm3net.get_ne(l_st_ne_id);
      l_units  := nm3net.get_nt_units(l_rec_ne.ne_nt_type);
      append(l_rec_ne.ne_unique);
   ELSE
      append(nm3web.c_nbsp);
   END IF;
   append('</TD>');
   append('<TD>');
   IF l_st_offset IS NOT NULL
    THEN
      append(nm3unit.get_formatted_value(l_st_offset,l_units));
   ELSE
      append(nm3web.c_nbsp);
   END IF;
   append('</TD>');
   append('<TD>');
   IF l_end_ne_id != g_offset_ne_id
    THEN
      l_rec_ne := nm3net.get_ne(l_end_ne_id);
      l_units  := nm3net.get_nt_units(l_rec_ne.ne_nt_type);
      append(l_rec_ne.ne_unique);
   ELSE
      append(nm3web.c_nbsp);
   END IF;
   append('</TD>');
   append('<TD>');
   IF l_end_offset IS NOT NULL
    THEN
      append(nm3unit.get_formatted_value(l_end_offset,l_units));
   ELSE
      append(nm3web.c_nbsp);
   END IF;
   append('</TD>');
   i := g_tab_is_obj.first;
   WHILE i IS NOT NULL
    LOOP
      append('<TD>');
      IF g_tab_is_obj(i) = c_nm_val_dist
       THEN
         append(g_tab_val_obj(i).return_string);
      ELSIF g_tab_is_obj(i) = c_nm_val_dist_arr
       THEN
         DECLARE
            l_tab_vc nm3type.tab_varchar32767;
         BEGIN
            l_tab_vc := internal_produce_html_table (i);
            FOR j IN 1..l_tab_vc.COUNT
             LOOP
               append(l_tab_vc(j));
            END LOOP;
         END;
      ELSE
         IF g_tab_value(i) IS NOT NULL
          THEN
            append(g_tab_value(i));
         ELSE
            append(nm3web.c_nbsp);
         END IF;
      END IF;
      append('</TD>');
      i := g_tab_is_obj.NEXT(i);
   END LOOP;
   append('</TR>');
   FOR j IN 1..l_tab_varchar.COUNT
    LOOP
      htp.p(l_tab_varchar(j));
   END LOOP;
END write_merge_table_entry;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_function_array IS
   --
   CURSOR cs_available_funcs (p_pack varchar2) IS
   SELECT object_name, type_name
    FROM  all_arguments a1
   WHERE  owner        = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   package_name = p_pack
    AND   position     = 0
    AND   object_name LIKE 'GET%'
    AND   object_name NOT IN ('GET_VERSION','GET_BODY_VERSION')
    AND   NOT EXISTS (SELECT 1
                       FROM  all_arguments a2
                      WHERE  a1.owner         =  a2.owner
                       AND   a1.package_name  =  a2.package_name
                       AND   a1.object_name   =  a2.object_name
                       AND   a2.argument_name IN ('PI_VALUE')
                     )
   GROUP BY object_name, type_name
   ORDER BY object_name, type_name;

   --
BEGIN
   --
   g_tab_funcs.DELETE;
   g_tab_funcs_ret_obj_type.DELETE;
   --
   OPEN  cs_available_funcs (g_dynseg_pack_name);
   FETCH cs_available_funcs BULK COLLECT INTO g_tab_funcs, g_tab_funcs_ret_obj_type;
   CLOSE cs_available_funcs;
   --
END build_function_array;
--
-----------------------------------------------------------------------------
--
FUNCTION internal_produce_html_table (i pls_integer) RETURN nm3type.tab_varchar32767 IS
   l_block  VARCHAR2(32767);
BEGIN
--
   g_tab_varchar.DELETE;
--
   l_block :=  'BEGIN'
    ||CHR(10)||' '||g_package_name||'.g_tab_varchar := '||g_dynseg_pack_name||'.produce_html_table ('||g_package_name||'.g_tab_val_obj_arr_'||i||');'
    ||CHR(10)||'END;';
--
   EXECUTE IMMEDIATE l_block;
--
   RETURN g_tab_varchar;
--
END internal_produce_html_table;
--
-----------------------------------------------------------------------------
--
BEGIN
   build_function_array;
END nm3web_eng_dynseg;
/
