CREATE OR REPLACE TRIGGER NM_MEMBERS_ALL_LOG_CHANGE
AFTER DELETE OR INSERT OR UPDATE
ON NM_MEMBERS_ALL 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_members_all_log_change.trg	1.2 06/17/05
--       Module Name      : nm_members_all_log_change.trg
--       Date into SCCS   : 05/06/17 17:21:16
--       Date fetched Out : 07/06/13 17:03:20
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
   
      IF INSERTING AND :new.nm_type = 'I' 
                   OR :new.nm_type = 'G' AND :new.nm_obj_type = c_hov_value THEN 
   
         nm3_inv_locations.add_to_log_table(:new.nm_ne_id_in,
                                            :new.nm_ne_id_of,
                                            :new.nm_type
                                           );

     
      
      ELSIF UPDATING AND :new.nm_type = 'I' OR :old.nm_type = 'I' 
                     OR :new.nm_type = 'G' AND :new.nm_obj_type = c_hov_value
                     OR :old.nm_type = 'G' AND :old.nm_obj_type = c_hov_value THEN
   
         nm3_inv_locations.add_to_log_table(:new.nm_ne_id_in,
                                            :new.nm_ne_id_of,
                                            :new.nm_type
                                           );
   
      ELSIF DELETING AND :old.nm_type = 'I' 
                     OR :old.nm_type = 'G' AND :old.nm_obj_type = c_hov_value THEN
   
         nm3_inv_locations.add_to_log_table(:old.nm_ne_id_in,
                                            :old.nm_ne_id_of,
                                            :old.nm_type
                                           );
   
      END IF;
      
   END IF;

END nm_members_all_log_change;
/
