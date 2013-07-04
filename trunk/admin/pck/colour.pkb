
PROMPT Create the Package Body Colour
CREATE OR REPLACE PACKAGE BODY colour AS
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/colour.pkb-arc   2.1   Jul 04 2013 14:28:16   James.Wadsworth  $
--       Module Name      : $Workfile:   colour.pkb  $
--       Date into SCCS   : $Date:   Jul 04 2013 14:28:16  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:06  $
--       SCCS Version     : $Revision:   2.1  $
--       Based on SCCS Version     : 1.1
--
--
--   Author :
--
--  Colour package
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '"$Revision:   2.1  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
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
  function get_colour ( p_col_id in number ) return varchar2 is
  cursor c1 is
    select colour from colours where col_id = p_col_id;
  retval varchar2(12);
  begin
    open c1;
    fetch c1 into retval;
    if c1%notfound then
      null;
    end if;
    close c1;
    return retval;
  end;
--
-----------------------------------------------------------------------------
--
  function get_col_id ( p_colour in varchar2 ) return number is
  cursor c1 is
    select col_id from colours where colour = p_colour;
  retval number;
  begin
    open c1;
    fetch c1 into retval;
    if c1%notfound then
      null;
    end if;
    close c1;
    return retval;
  end;
--
-----------------------------------------------------------------------------
--
  function return_vattr return varchar2 is
  begin
    return g_vattr;
  end;
--
-----------------------------------------------------------------------------
--
  function return_vattr_id return number is
  begin
    return get_col_id( g_vattr );
  end;
--
-----------------------------------------------------------------------------
--
  procedure set_vattr( p_attr in varchar2 ) is
  begin
    g_vattr := p_attr;
  end;
--
-----------------------------------------------------------------------------
--
END colour;
/
