CREATE OR REPLACE TRIGGER NM_MEMBERS_ALL_NM2_TAB_UPDATE
AFTER DELETE OR INSERT OR UPDATE
ON NM_MEMBERS_ALL 
REFERENCING NEW AS NEW OLD AS OLD
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_members_all_nm2_tab_update.trg	1.2 06/17/05
--       Module Name      : nm_members_all_nm2_tab_update.trg
--       Date into SCCS   : 05/06/17 17:22:25
--       Date fetched Out : 07/06/13 17:03:21
--       SCCS Version     : 1.2
--
--   Author : P. Stanton 
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
DECLARE

c_hov_value CONSTANT hig_option_values.hov_value%TYPE := nm3get.get_hov( pi_hov_id => 'MEMBLOGIN'
                                                                           ,pi_raise_not_found => FALSE
                                                                           ).hov_value;

BEGIN
   
   IF c_hov_value IS NOT NULL THEN 
    
      nm3_inv_locations.update_from_log;
       
   END IF;
 
END;
/
