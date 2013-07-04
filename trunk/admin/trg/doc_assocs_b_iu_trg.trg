CREATE OR REPLACE TRIGGER doc_assocs_b_iu_trg
   BEFORE INSERT OR UPDATE
   ON doc_assocs
   FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)doc_assocs_b_iu_trg.trg	1.1 07/18/06
--       Module Name      : doc_assocs_b_iu_trg.trg
--       Date into SCCS   : 06/07/18 10:36:50
--       Date fetched Out : 07/06/13 17:02:27
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
 l_flag         VARCHAR2(1);
 
 ex_security    EXCEPTION; 
 PRAGMA exception_init(ex_security,-20000);

--
BEGIN
--

      IF  doc.das_against_asset (pi_das_table_name => :NEW.das_table_name) THEN
	   l_flag := 'A';
       nm3lock.lock_asset_item(pi_nit_id          =>  nm3inv.get_inv_type(p_ne_id => :NEW.das_rec_id)
                              ,pi_pk_id           =>  :NEW.das_rec_id
                              ,pi_lock_for_update =>  TRUE
	 						  ,pi_updrdonly       =>  nm3lock.get_updrdonly);
 
      ELSIF doc.das_against_network (pi_das_table_name => :NEW.das_table_name) THEN
          l_flag := 'N';  
          nm3lock.lock_element(p_ne_id                => :NEW.das_rec_id
                              ,p_lock_ele_for_update  => TRUE
 	   					      ,p_updrdonly            =>  nm3lock.get_updrdonly);
 END IF;
 
EXCEPTION
 WHEN ex_security THEN
    IF l_flag = 'A' THEN
      hig.raise_ner(pi_appl => 'HIG'
	               ,pi_id  => 437);
    ELSIF l_flag = 'N' THEN
      hig.raise_ner(pi_appl => 'HIG'
	               ,pi_id  => 436);
    END IF;				 
				 
 WHEN others THEN
    RAISE;				 				 
	
--
END doc_assocs_b_iu_trg;
/
