CREATE OR REPLACE PACKAGE BODY nm3api_admin_unit AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3api_admin_unit.pkb-arc   2.3   Jul 04 2013 15:15:38   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3api_admin_unit.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:15:38  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:08  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
  -----------
  --constants
  -----------
--g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.3  $';
  g_package_name     CONSTANT varchar2(30) := 'nm3api_admin_unit';
  g_natg_domain      CONSTANT hig_domains.hdo_domain%TYPE := 'ADMIN TYPE GROUPINGS';
  g_natg_locked      CONSTANT hig_codes.hco_code%TYPE := 'LOCKED';
  g_locking_in_use   BOOLEAN := TRUE;
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
PROCEDURE nau_check_sub_types(pi_nau_admin_type    IN nm_admin_units_all.nau_admin_type%TYPE
                             ,pi_parent_sub_type   IN nm_admin_units_all.nau_nsty_sub_type%TYPE
                             ,pi_sub_type          IN nm_admin_units_all.nau_nsty_sub_type%TYPE) IS

							 
 CURSOR c_chk IS
 SELECT 'Y'
 FROM   nm_au_sub_types nsty
 where  nsty.nsty_nat_admin_type = pi_nau_admin_type
 AND    (
          (    pi_parent_sub_type IS NOT NULL
		  and  nsty.nsty_parent_sub_type = pi_parent_sub_type
		  )
		OR
		  (    pi_parent_sub_type IS NULL
		  AND  nsty.nsty_parent_sub_type IS NULL
		  )
        )
 AND    nsty.nsty_sub_type = pi_sub_type;				      


 l_dummy VARCHAR2(1) := Null;
 

 ex_rules_broken EXCEPTION;
  		 
BEGIN

 --
 -- check that if the admin unit has a sub type that it's parent
 -- admin also has a sub type according to nsty data 
 --
 IF pi_sub_type IS NOT NULL THEN


   OPEN c_chk;
   FETCH c_chk INTO l_dummy;
   CLOSE c_chk;			  
			   
   IF l_dummy IS NULL THEN
      RAISE ex_rules_broken;
   END IF;
   
 END IF;   

EXCEPTION

  WHEN ex_rules_broken THEN
     hig.raise_ner(nm3type.c_net,384);	 

END nau_check_sub_types;
--
-----------------------------------------------------------------------------
--
PROCEDURE nau_check_top_level(pi_nau_admin_type nm_admin_units_all.nau_admin_type%TYPE
                             ,pi_nau_level      nm_admin_units_all.nau_level%TYPE) IS


 CURSOR c_chk IS
 SELECT COUNT(*)
 FROM   nm_admin_units_all
 WHERE  nau_admin_type =  pi_nau_admin_type
 AND    nau_level      =  1;

 l_count_level_1 NUMBER;
 
 ex_too_many_level_1      EXCEPTION;

BEGIN
 ---
 -- check that there is only 1 top level admin unit
 --
   IF pi_nau_level = 1 THEN

      OPEN c_chk;
  	  FETCH c_chk INTO l_count_level_1;
	  CLOSE c_chk;
	  
	  IF l_count_level_1 > 1 THEN
	    RAISE ex_too_many_level_1;
	  END IF;

   END IF;	  	  

EXCEPTION 

  WHEN ex_too_many_level_1 THEN
     hig.raise_ner(pi_appl               => nm3type.c_hig
	              ,pi_id                 => 35
				  ,pi_supplementary_info => 'Admin Unit, a top level Admin Unit already exists');


END nau_check_top_level;
--
-----------------------------------------------------------------------------
--
PROCEDURE nsty_check_parent_sub_type(pi_nsty_nat_admin_type    nm_au_sub_types.nsty_nat_admin_type%TYPE
                                    ,pi_nsty_parent_sub_type   nm_au_sub_types.nsty_parent_sub_type%TYPE) IS

 CURSOR c_chk IS
 SELECT 'Y'
 FROM   nm_au_sub_types
 WHERE  nsty_nat_admin_type =  pi_nsty_nat_admin_type
 AND    nsty_sub_type       =  pi_nsty_parent_sub_type;

 l_dummy VARCHAR2(1) := Null;
 ex_invalid_parent_sub_type EXCEPTION;
 
BEGIN

   IF pi_nsty_parent_sub_type IS NOT NULL THEN

      --
      -- check that the parent sub type is actually a sub type within the admin type  
      -- 
      OPEN c_chk;
  	  FETCH c_chk INTO l_dummy;
  	  IF c_chk%NOTFOUND THEN
	    CLOSE c_chk;
	    RAISE ex_invalid_parent_sub_type;
      END IF;
	  CLOSE c_chk;
   END IF;
   
EXCEPTION   

  WHEN ex_invalid_parent_sub_type THEN
     hig.raise_ner(nm3type.c_net,381);


END nsty_check_parent_sub_type;
--
-----------------------------------------------------------------------------
--
PROCEDURE nsty_check_cyclic_rel(pi_nsty_nat_admin_type  nm_au_sub_types.nsty_nat_admin_type%TYPE
                               ,pi_nsty_sub_type        nm_au_sub_types.nsty_sub_type%TYPE
                               ,pi_nsty_parent_sub_type nm_au_sub_types.nsty_parent_sub_type%TYPE) IS

 CURSOR c_chk IS
 SELECT 'Y'
 FROM   nm_au_sub_types
 WHERE  nsty_nat_admin_type  = pi_nsty_nat_admin_type
 AND    nsty_parent_sub_type = pi_nsty_sub_type
 AND    nsty_sub_type        = pi_nsty_parent_sub_type;

 l_dummy VARCHAR2(1) := Null;
 ex_cylic_relationship      EXCEPTION;

BEGIN

   IF pi_nsty_parent_sub_type IS NOT NULL THEN

    --	
    -- check that sub-type is not parent and parent is not a sub type i.e. cyclic relationship
    -- (should be policed by nsty_uk1)
    --
    OPEN c_chk;
	FETCH c_chk INTO l_dummy;
	IF c_chk%FOUND THEN
	  CLOSE c_chk;
	  RAISE ex_cylic_relationship;
    END IF;
	CLOSE c_chk;
	
   END IF;
   
EXCEPTION 

  WHEN ex_cylic_relationship THEN
     hig.raise_ner(nm3type.c_net,382);
   
END nsty_check_cyclic_rel; 
--
-----------------------------------------------------------------------------
--
PROCEDURE nsty_check_group_type(pi_nsty_ngt_group_type_old IN nm_au_sub_types.nsty_ngt_group_type%TYPE
	                           ,pi_nsty_ngt_group_type_new IN nm_au_sub_types.nsty_ngt_group_type%TYPE) IS						  

 CURSOR c_chk IS
 SELECT 'X'
 FROM   nm_elements
 WHERE  ne_gty_group_type = pi_nsty_ngt_group_type_new;

 l_dummy VARCHAR2(1) := Null;
 ex_cannot_set_group_type EXCEPTION;
 
 
BEGIN

--
-- when setting group type for the first time then make sure that there are no existing elements
-- that this could contravene what the au sub type is trying to police
--
 IF pi_nsty_ngt_group_type_old IS NULL AND pi_nsty_ngt_group_type_new IS NOT NULL THEN

   OPEN c_chk;
   FETCH c_chk INTO l_dummy;
   IF c_chk%FOUND THEN
      CLOSE c_chk;
	  RAISE ex_cannot_set_group_type;
   END IF;	  
   CLOSE c_chk;
   
 END IF; 							   

EXCEPTION

WHEN ex_cannot_set_group_type THEN
     hig.raise_ner(nm3type.c_net,385); 
 
END nsty_check_group_type;
--
-----------------------------------------------------------------------------
-- 
PROCEDURE nsty_check_compat_admin_type(pi_nsty_nat_admin_type  nm_au_sub_types.nsty_nat_admin_type%TYPE
                                      ,pi_nsty_ngt_group_type  nm_au_sub_types.nsty_ngt_group_type%TYPE) IS 

 CURSOR c_chk IS
 SELECT 'Y' 
 FROM   nm_group_types_all ngt
       ,nm_types nt
 WHERE  nt.nt_type = ngt.ngt_nt_type
 AND    ngt.ngt_group_type = pi_nsty_ngt_group_type
 AND    nt.nt_admin_type   = pi_nsty_nat_admin_type;
 

 l_dummy VARCHAR2(1) := Null;
 ex_incompatible_admin_type EXCEPTION; 

BEGIN

 IF pi_nsty_ngt_group_type IS NOT NULL THEN

  --	
  -- check that admin type for this sub-type matches the admin type 
  -- for the network type associated with the group type
  -- otherwise if a mistmatch was allowed then on creation of network elements
  -- you would get an error being raised regarding invalid admin units 
  --
   OPEN c_chk;
   FETCH c_chk INTO l_dummy;
   IF c_chk%NOTFOUND THEN
	  CLOSE c_chk;
	  RAISE ex_incompatible_admin_type;
   END IF;
   CLOSE c_chk;

 END IF;
 
EXCEPTION 

  WHEN ex_incompatible_admin_type THEN
     hig.raise_ner(nm3type.c_net,383); 
 
END nsty_check_compat_admin_type; 
--
-----------------------------------------------------------------------------
-- 
PROCEDURE process_g_tab_nsty IS

 
BEGIN


-- nsty_check_updated_attribs;

 FOR i IN 1..g_tab_nsty_new.COUNT LOOP

	nsty_check_parent_sub_type(pi_nsty_nat_admin_type   => g_tab_nsty_new(i).nsty_nat_admin_type
                              ,pi_nsty_parent_sub_type  => g_tab_nsty_new(i).nsty_parent_sub_type);
							  
							  
    nsty_check_cyclic_rel(pi_nsty_nat_admin_type  => g_tab_nsty_new(i).nsty_nat_admin_type
                         ,pi_nsty_sub_type        => g_tab_nsty_new(i).nsty_sub_type
                         ,pi_nsty_parent_sub_type => g_tab_nsty_new(i).nsty_parent_sub_type  );


    nsty_check_group_type(pi_nsty_ngt_group_type_old => g_tab_nsty_old(i).nsty_ngt_group_type
	                     ,pi_nsty_ngt_group_type_new => g_tab_nsty_new(i).nsty_ngt_group_type);						  
						 
    nsty_check_compat_admin_type(pi_nsty_nat_admin_type  => g_tab_nsty_new(i).nsty_nat_admin_type
                                ,pi_nsty_ngt_group_type  => g_tab_nsty_new(i).nsty_ngt_group_type);						 

 END LOOP; 
 
	  
END process_g_tab_nsty;
--
-----------------------------------------------------------------------------
--
PROCEDURE override_admin_type_locking IS

BEGIN
 g_locking_in_use := FALSE;
END override_admin_type_locking;
--
-----------------------------------------------------------------------------
--
PROCEDURE restore_admin_type_locking IS

BEGIN
 g_locking_in_use := TRUE; 
END restore_admin_type_locking;
--
-----------------------------------------------------------------------------
--
FUNCTION admin_type_is_locked(pi_nat_admin_type IN nm_au_types.nat_admin_type%TYPE) RETURN BOOLEAN IS

 CURSOR c1 IS
 SELECT 'Y'
 FROM   nm_au_types_groupings
 WHERE  natg_nat_admin_type = pi_nat_admin_type
 AND    natg_grouping = g_natg_locked;
 
 l_dummy VARCHAR2(1);
 
BEGIN
 
  OPEN c1;
  FETCH c1 INTO l_dummy;
  CLOSE c1;
  
  IF l_dummy IS NOT NULL THEN
    RETURN(TRUE);
  ELSE
    RETURN(FALSE);
  END IF;
  

END admin_type_is_locked;
--
-----------------------------------------------------------------------------
--
PROCEDURE nau_check_if_locked(pi_nat_admin_type IN nm_au_types.nat_admin_type%TYPE) IS

BEGIN
 
  IF g_locking_in_use  THEN 
  
   IF admin_type_is_locked(pi_nat_admin_type => pi_nat_admin_type) THEN
  
     hig.raise_ner(pi_appl               => nm3type.c_net
	              ,pi_id                 => 387);
                  
   END IF;                  
 
  END IF;

END;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_g_tab_nau IS 
 
BEGIN

 FOR i IN 1..g_tab_nau_new.COUNT LOOP


   nau_check_if_locked(pi_nat_admin_type => g_tab_nau_new(i).nau_admin_type);

   -- don't bother checking 4 top level admin unit if deleting record only  
    IF  nm3api_admin_unit.g_tab_nau_actions(i) != 'D' THEN
       nau_check_top_level(pi_nau_admin_type => g_tab_nau_new(i).nau_admin_type
                          ,pi_nau_level      => g_tab_nau_new(i).nau_level);
    END IF;						
                      
 END LOOP; 

--
-- Note: admin units for NSG ie. to model counties/towns/localities and orgs/districts
-- are processed NSG specific by after statement trigger on NM_ADMIN_UNITS_ALL
--

 
END process_g_tab_nau;
--
-----------------------------------------------------------------------------
--
PROCEDURE insert_admin_unit(pi_nau_rec               IN OUT   nm_admin_units%ROWTYPE
                           ,pi_nau_rec_parent        IN       nm_admin_units%ROWTYPE) IS
						   

 l_rec_nag nm_admin_groups%ROWTYPE;
 l_rec_parent nm_admin_units%ROWTYPE;

BEGIN

 IF pi_nau_rec_parent.nau_admin_unit IS NOT NULL THEN
  -- check that the parent au actually exists
   l_rec_parent := nm3get.get_nau(pi_nau_admin_unit => pi_nau_rec_parent.nau_admin_unit);
 END IF;   
  
-- set the primary key, if not already specified
 IF pi_nau_rec.nau_admin_unit IS NULL THEN
    pi_nau_rec.nau_admin_unit := nm3seq.next_nau_admin_unit_seq;
 END IF;

-- set the primary key, if not already specified
 IF pi_nau_rec.nau_unit_code IS NULL THEN
    pi_nau_rec.nau_unit_code := pi_nau_rec.nau_admin_unit;
 END IF;

-- set the name to be the admin unit id if not specified
 IF pi_nau_rec.nau_name IS NULL THEN
    pi_nau_rec.nau_name := pi_nau_rec.nau_admin_unit; 
 END IF;
  
-- set the level to be parent level + 1 
 IF pi_nau_rec.nau_level IS NULL THEN
 	pi_nau_rec.nau_level := NVL(pi_nau_rec_parent.nau_level+1,0);
 END IF;	

-- set start date, if not already specified
 IF pi_nau_rec.nau_start_date IS NULL THEN
    pi_nau_rec.nau_start_date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
 END IF; 


-- create nm_admin_units_all record
--  nm3ins.ins_nau(p_rec_nau => pi_nau_rec);
   nm3ins.ins_nau_all(p_rec_nau_all => pi_nau_rec);
  
-- create nm_admin_group record for new admin unit pointing at itself  
  l_rec_nag.nag_parent_admin_unit := pi_nau_rec.nau_admin_unit;
  l_rec_nag.nag_child_admin_unit  := pi_nau_rec.nau_admin_unit;
  l_rec_nag.nag_direct_link       := 'N';    
  nm3ins.ins_nag(p_rec_nag => l_rec_nag);
--  

-- insert admin_groups records for parent/grandparent/etc..
-- direct_link value only 'Y' for parent/child relationship
  FOR nag IN (SELECT nag_parent_admin_unit, pi_nau_rec.nau_admin_unit nag_child_admin_unit, DECODE(nag_parent_admin_unit, pi_nau_rec_parent.nau_admin_unit, 'Y', 'N') nag_direct_link FROM nm_admin_groups WHERE nag_child_admin_unit = pi_nau_rec_parent.nau_admin_unit) LOOP
   l_rec_nag.nag_parent_admin_unit := nag.nag_parent_admin_unit;
   l_rec_nag.nag_child_admin_unit  := nag.nag_child_admin_unit;
   l_rec_nag.nag_direct_link       := nag.nag_direct_link;    
   nm3ins.ins_nag(p_rec_nag => l_rec_nag);
  END LOOP;
  
  nau_check_sub_types(pi_nau_admin_type    =>  pi_nau_rec.nau_admin_type
                     ,pi_parent_sub_type   =>  pi_nau_rec_parent.nau_nsty_sub_type
                     ,pi_sub_type          =>  pi_nau_rec.nau_nsty_sub_type);


--
-- GJ 02-JAN-2007
-- Trigger NM_ADMIN_UNITS_ALL_NSG_AS fires when nm3ins.ins_nau is called
-- However, checks within those functions/procedures that the trigger calls
-- will also rely on data existing in NM_ADMIN_GROUPS - which it won't be until after nm3ins.ins_nau is called
--
-- Therefore, so that things do not slip through the net, we need 'touch' the nm_admin_units record again 
-- so that the trigger fires again
--
 update nm_admin_units_all
 set nau_admin_unit = nau_admin_unit
 where nau_admin_unit = pi_nau_rec.nau_admin_unit; 
 

--  
END	insert_admin_unit;					   
--
-----------------------------------------------------------------------------
--
FUNCTION get_natg_domain RETURN VARCHAR2 IS

BEGIN
  RETURN(g_natg_domain);
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE end_date_admin_unit(pi_admin_unit        IN nm_admin_units.nau_admin_unit%TYPE
                             ,pi_end_date          IN DATE     DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                             ,pi_end_date_children IN VARCHAR2 DEFAULT 'Y') IS
	 
BEGIN

 UPDATE nm_admin_units
 SET    nau_end_date = TRUNC(pi_end_date)
 WHERE  nau_admin_unit IN (select nag_child_admin_unit
                           from   nm_admin_groups
						   where  nag_parent_admin_unit = pi_admin_unit
						   and    nag_child_admin_unit = DECODE(UPPER(pi_end_date_children),'Y',nag_child_admin_unit,nag_parent_admin_unit));
END end_date_admin_unit;							 
--
-----------------------------------------------------------------------------
--
FUNCTION get_parent_admin_unit(pi_nau_admin_unit IN nm_admin_units_all.nau_admin_unit%TYPE) RETURN nm_admin_units_all%ROWTYPE IS  

 CURSOR c1 IS
 SELECT nau.*
 FROM   nm_admin_groups
       ,nm_admin_units_all nau
 WHERE  nag_child_admin_unit = pi_nau_admin_unit
 AND    nag_direct_link = 'Y';
 
 l_retval nm_admin_units_all%ROWTYPE;

BEGIN

 OPEN c1;
 FETCH c1 INTO l_retval;
 CLOSE c1;
 
 RETURN(l_retval);

END get_parent_admin_unit;
--
-----------------------------------------------------------------------------
--
FUNCTION make_unique_nat_admin_type(pi_nat_admin_type IN nm_au_types.nat_admin_type%TYPE) RETURN nm_au_types.nat_admin_type%TYPE IS
  
   l_look_for VARCHAR2(5) := pi_nat_admin_type;   
   l_rec_nat  nm_au_types%ROWTYPE;
   l_suffix   PLS_INTEGER :=0;   
  
  BEGIN

     LOOP
   
      l_rec_nat := nm3get.get_nat(pi_nat_admin_type => l_look_for
	                             ,pi_raise_not_found => FALSE);
						   
      IF l_rec_nat.nat_admin_type IS NULL THEN
	     EXIT;
      END IF;	   				

      l_suffix := l_suffix +1;
      l_look_for := pi_nat_admin_type||TO_CHAR(l_suffix);
   	
    END LOOP;

    RETURN(substr(l_look_for,1,4)); -- ensure we don't return a string that is greater than the length of the nat_admin_type attribute

END make_unique_nat_admin_type;
--
-----------------------------------------------------------------------------
--
-- no sooner is it added....it is taken away
-- this function no longer needed
-- but commented out cos it may make more combacks than the Quo
--
-- FUNCTION make_unique_nau_name(pi_nau_admin_type IN nm_admin_units.nau_admin_type%TYPE
--                              ,pi_nau_name       IN nm_admin_units.nau_name%TYPE) RETURN nm_admin_units.nau_name%TYPE IS
--                              
-- 
--  l_retval   nm_admin_units.nau_name%TYPE;
--  l_look_for VARCHAR2(50) := pi_nau_name;   
--  l_suffix   PLS_INTEGER :=0;
--  
--  FUNCTION nau_name_exists(pi_nau_admin_type IN nm_admin_units.nau_admin_type%TYPE
--                          ,pi_nau_name       IN nm_admin_units.nau_name%TYPE) RETURN BOOLEAN IS
--    
--    l_dummy PLS_INTEGER;
--                          
--  BEGIN
--  
--   SELECT count(*)
--   INTO   l_dummy
--   FROM   nm_admin_units_all
--   WHERE  nau_admin_type = pi_nau_admin_type
--   AND    UPPER(nau_name) = UPPER(pi_nau_name);
--   
--   RETURN(l_dummy =1); 
--  
--  END nau_name_exists;                        
--     
--   
-- BEGIN
-- 
--     LOOP
-- --   dbms_output.put_line('looking for '|| l_look_for);
--       IF NOT nau_name_exists(pi_nau_admin_type => pi_nau_admin_type
--                             ,pi_nau_name       => l_look_for) THEN
-- 	     exit;
--       END IF;	   				
--  
--       l_suffix := l_suffix +1;
--       l_look_for := pi_nau_name||TO_CHAR(l_suffix);
--    	
--     END LOOP;
-- --    dbms_output.put_line('returning '||l_look_for);
--     RETURN(substr(l_look_for,1,40)); -- ensure we don't return a string that is greater than the length of the nau_name attribute
--   
-- END make_unique_nau_name;
--
-----------------------------------------------------------------------------
--                              
END nm3api_admin_unit;
/
