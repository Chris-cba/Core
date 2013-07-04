CREATE OR REPLACE PACKAGE BODY Nm3array AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3array.pkb-arc   2.2   Jul 04 2013 15:15:38   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3array.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:15:38  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:08  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.5
--
--   Author : Rob Coupe
--
--   NM3 Package for Oracle Spatial links
--
--   Package devoted to serving up initialised object types
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--  g_body_sccsid is the SCCS ID for the package body

  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.2  $';

   g_package_name    CONSTANT VARCHAR2 (30)   := 'NM3ARRAY';
   
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
-----------------------------------------------------------------------------
--

FUNCTION INIT_INT_ARRAY            RETURN INT_ARRAY IS
BEGIN
  RETURN INT_ARRAY( INT_ARRAY_TYPE( NULL ));
END;

------------------------------------------------------------------------------
--  
FUNCTION INIT_NM_GEOM_ARRAY        RETURN NM_GEOM_ARRAY IS
BEGIN
  RETURN NM_GEOM_ARRAY( NM_GEOM_ARRAY_TYPE(NM_GEOM(NULL, NULL)));
END;

------------------------------------------------------------------------------
--  
FUNCTION INIT_NM_LREF_ARRAY 	   RETURN NM_LREF_ARRAY IS
BEGIN
  RETURN NM_LREF_ARRAY( NM_LREF_ARRAY_TYPE( NM_LREF( NULL,NULL)));
END;

------------------------------------------------------------------------------
--  
FUNCTION INIT_NM_PLACEMENT_ARRAY   RETURN NM_PLACEMENT_ARRAY IS
BEGIN
  RETURN NM_PLACEMENT_ARRAY( NM_PLACEMENT_ARRAY_TYPE( NM_PLACEMENT(NULL,NULL,NULL,NULL)));
END;

------------------------------------------------------------------------------
--  
FUNCTION INIT_NM_THEME_ARRAY       RETURN NM_THEME_ARRAY IS
BEGIN
  RETURN NM_THEME_ARRAY( NM_THEME_ARRAY_TYPE( NM_THEME_ENTRY( NULL )));
END;

------------------------------------------------------------------------------
--  
FUNCTION INIT_NUM_ARRAY            RETURN NUM_ARRAY IS
BEGIN
  RETURN NUM_ARRAY( NUM_ARRAY_TYPE( NULL ));
END;

------------------------------------------------------------------------------
--  
FUNCTION INIT_PTR_ARRAY            RETURN PTR_ARRAY IS
BEGIN
  RETURN PTR_ARRAY( PTR_ARRAY_TYPE( PTR(NULL,NULL)));
END;

------------------------------------------------------------------------------
--  
FUNCTION INIT_PTR_NUM_ARRAY        RETURN PTR_NUM_ARRAY IS
BEGIN
  RETURN PTR_NUM_ARRAY( PTR_NUM_ARRAY_TYPE( PTR_NUM(NULL,NULL)));
END;

------------------------------------------------------------------------------
--  
FUNCTION INIT_PTR_VC_ARRAY         RETURN PTR_VC_ARRAY IS
BEGIN
  RETURN PTR_VC_ARRAY( PTR_VC_ARRAY_TYPE( PTR_VC(NULL,NULL)));
END;

------------------------------------------------------------------------------
--
FUNCTION INIT_NM_THEME_LIST         RETURN NM_THEME_LIST IS
BEGIN
  RETURN NM_THEME_LIST( NM_THEME_LIST_TYPE(NM_THEME_DETAIL( NULL, NULL, NULL, NULL, NULL, NULL, NULL)));
END;

------------------------------------------------------------------------------
--

FUNCTION INIT_INT_ARRAY( p_num_tab IN Nm3type.tab_number ) RETURN int_array IS
retval int_array := init_int_array;
lc     INTEGER;
BEGIN
  lc := p_num_tab.COUNT;
  IF lc > 0 THEN
    retval.ia.EXTEND( lc - 1 );
    FOR i IN 1..lc LOOP
      retval.ia(i) := p_num_tab(i);
    END LOOP;
  END IF;
  RETURN retval;
END;        

END;  
/
