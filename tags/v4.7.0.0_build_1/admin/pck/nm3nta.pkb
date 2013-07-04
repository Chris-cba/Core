CREATE OR REPLACE PACKAGE BODY nm3nta AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3nta.pkb-arc   2.2   Jul 04 2013 16:21:08   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3nta.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:21:08  $
--       Date fetched Out : $Modtime:   Jul 04 2013 15:48:54  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.1
---------------------------------------------------------------------------
--   Author : R.A. Coupe
--
--   NM_THEME_ARRAY related code package body
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '$Revision:   2.2  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  VARCHAR2(30)   := 'NM3NTA';


--  function  union_theme_array( p_theme_array1 in nm_theme_array, p_theme_array2 in nm_theme_array ) return nm_theme_array;
--  function  intersection_theme_array( p_theme_array1 in nm_theme_array, p_theme_array2 in nm_theme_array ) return nm_theme_array ;

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
---------------------------------------------------------------------------------------------
--
  PROCEDURE add_to_theme_array( p_theme_id in nm_themes_all.nth_theme_id%type ) is
  begin
    if not g_theme_array_flag then
	  g_theme_array := nm_theme_array( nm_theme_array_type( nm_theme_entry( p_theme_id )));
	  g_theme_array_flag := TRUE;
    else
      g_theme_array := g_theme_array.add_theme( p_theme_id );
	end if;
  end;  
--
---------------------------------------------------------------------------------------------
--

  FUNCTION get_theme_array return nm_theme_array is
  begin
    return g_theme_array;
  end;
  
--
---------------------------------------------------------------------------------------------
--

  PROCEDURE remove_from_theme_array( p_theme_id in nm_themes_all.nth_theme_id%type ) is

  cursor c1 (c_theme_id in nm_themes_all.nth_theme_id%type) is
    select v.nthe_id nthe_id
	from table( nm3nta.get_theme_array().nta_theme_array) v
    where v.nthe_id != c_theme_id;

  l_themes nm3type.tab_number;
  	
  begin
  
    open c1( p_theme_id );
	fetch c1  bulk collect into l_themes;
	close c1;
	
    g_theme_array := nm_theme_array(nm_theme_array_type( nm_theme_entry( null)));

	g_theme_array_flag := FALSE;
	 
    for i in 1..l_themes.count loop

      if i > 1 then
	  
	    g_theme_array.nta_theme_array.extend;
		
	  end if;

      g_theme_array.nta_theme_array( g_theme_array.nta_theme_array.last ) := nm_theme_entry( l_themes(i) );
	  
  	  g_theme_array_flag := TRUE;
	  
    end loop;
  end;	      
--
--
---------------------------------------------------------------------------------------------
--
  FUNCTION  theme_in_array( p_theme_id in nm_themes_all.nth_theme_id%type, p_theme_array in nm_theme_array ) return BOOLEAN is
  cursor c1 ( c_theme_id in nm_themes_all.nth_theme_id%type, c_theme_array in nm_theme_array ) is
    select v1.nthe_id
	from table ( c_theme_array.nta_theme_array ) v1 
	where v1.nthe_id = c_theme_id;

  l_dummy integer;
  	
  retval BOOLEAN;
  
  begin
  
    open c1( p_theme_id, p_theme_array );
	fetch c1 into l_dummy;
	retval := c1%found;
	close c1;
	
	return retval;

  end;	
  
--
---------------------------------------------------------------------------------------------
--
/*
  function  union_theme_array( p_theme_array1 in nm_theme_array, p_theme_array2 in nm_theme_array ) return nm_theme_array is
  cursor c1 (c_theme_array1 in nm_theme_array, c_theme_array2 in nm_theme_array ) is
    select v1.nthe_id nthe_id
	from table( c_theme_array1.nta_theme_array) v1;
--	union
--    select v2.nthe_id nthe_id
--	from table( c_theme_array2.nta_theme_array) v2;
  retval nm_theme_array;
  begin
  	
    retval := nm_theme_array(nm_theme_array_type( nm_theme_entry( null)));
	
	for irec in c1( p_theme_array1, p_theme_array2) loop
	
      if c1%rowcount > 1 then
	  
	    retval.nta_theme_array.extend;
		
	  end if;

      retval.nta_theme_array( retval.nta_theme_array.last ) := nm_theme_entry( irec.nthe_id );
	  
	  
    end loop;
	
	return retval;
  end;
  	
--
---------------------------------------------------------------------------------------------
--
	
  
  function  intersection_theme_array( p_theme_array1 in nm_theme_array, p_theme_array2 in nm_theme_array ) return nm_theme_array is
  cursor c1 (c_theme_array1 in nm_theme_array, c_theme_array2 in nm_theme_array ) is
    select v1.nthe_id nthe_id
	from table( c_theme_array1.nta_theme_array) v1;
--	intersect
--    select v2.nthe_id nthe_id
--	from table( c_theme_array2.nta_theme_array) v2;
  retval nm_theme_array;
  begin
  	
    retval := nm_theme_array(nm_theme_array_type( nm_theme_entry( null)));
	
	for irec in c1( p_theme_array1, p_theme_array2) loop
	
      if c1%rowcount > 1 then
	  
	    retval.nta_theme_array.extend;
		
	  end if;

      retval.nta_theme_array( retval.nta_theme_array.last ) := nm_theme_entry( irec.nthe_id ); 
	  
	  
    end loop;
	
	return retval;
  end;
*/	


  end nm3nta;
/
