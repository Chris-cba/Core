create or replace package body hig_contact as
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)higct.pkb	1.1 03/01/01  -- @(#)higct.pck	1.1 09/06/00
--       Module Name      : higct.pkb      -- higct.pck
--       Date into SCCS   : 01/03/01 16:22:47  -- 00/09/06 16:13:22
--       Date fetched Out : 07/06/13 14:10:29  -- 00/11/23 20:16:00
--       SCCS Version     : 1.1      -- 1.1
--
--
--   Author :
--
--	This package contains procedures and functions used when dealing
--    with contacts
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--package variables
g_hct_id hig_contacts.hct_id%type;
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '"@(#)higct.pkb	1.1 03/01/01"';
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
function get_hct_id return number is
begin
--
  return g_hct_id;
--
end get_hct_id;
--
-----------------------------------------------------------------------------
--
procedure set_hct_id(p_hct_id in hig_contacts.hct_id%type) is
begin
--
  g_hct_id := p_hct_id;
--
end set_hct_id;
--
-----------------------------------------------------------------------------
--
  procedure address_from_postcode
        (p_postcode     in     hig_address.had_postcode%type
        ,p_thoroughfare in out hig_address.had_thoroughfare%type
        ,p_dep_loc_name in out hig_address.had_dependent_locality_name%type
        ,p_post_town    in out hig_address.had_post_town%type
        ,p_county       in out hig_address.had_county%type
        ) is
--
  cursor c1 is
    select had_thoroughfare
	    ,had_dependent_locality_name
	    ,had_post_town
	    ,had_county
    from   hig_address
    where  had_postcode = p_postcode;
--
begin
--
  open c1;
  fetch c1 into p_thoroughfare
		   ,p_dep_loc_name
		   ,p_post_town
		   ,p_county;
    close c1;
--
end address_from_postcode;
--
-----------------------------------------------------------------------------
--
function next_hct_id return number is
--
  cursor c1 is
    select hct_id_seq.nextval
    from dual;
--
  l_retval hig_contacts.hct_id%type;
--
begin
--
  open c1;
  fetch c1 into l_retval;
  close c1;
--
  return l_retval;
--
end next_hct_id;
--
-----------------------------------------------------------------------------
--
function delete_ok(p_hct_id in hig_contacts.hct_id%type) return varchar2 is
--
-- As contacts are associated with more tables this code should grow without
-- the need for modules using it to be revisited. Problems will occur when tables
-- are added that are not shipped with the core product - depending on the products
-- installed this package may fail to compile unless, for example, dynamic sql is
-- used
--
  cursor c1 is
    select 'Enquiries'
    from   doc_enquiry_contacts
    where  dec_hct_id = p_hct_id;
--
--
-- enter further cursors here as contacts are associated with more tables
--
--
  l_association varchar2(30);
--
begin
--
  open c1;
  fetch c1 into l_association;
  if c1%found then
    close c1;
    return l_association;
  end if;
  close c1;
--
--
-- enter further cursors here as contacts are associated with more tables
--
--
-- no associated records founs so...
  return 'ok to delete';
--
end delete_ok;
--
-----------------------------------------------------------------------------
--
end hig_contact;
/
