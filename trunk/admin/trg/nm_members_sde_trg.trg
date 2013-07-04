CREATE OR REPLACE TRIGGER nm_members_sde_trg
   BEFORE INSERT OR UPDATE OR DELETE
   ON NM_MEMBERS_ALL
   FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_members_sde_trg.trg-arc   2.2   Jul 04 2013 09:53:32   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_members_sde_trg.trg  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:53:32  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:35:32  $
--       SCCS Version     : $Revision:   2.2  $
--       Based on 
--
--   Author : Jonathan Mills
--
--   Members trigger for SDE
--   BEFORE INSERT OR UPDATE OR DELETE
--   ON nm_members_all
--   FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_nm_type CONSTANT NM_MEMBERS_ALL.nm_type%TYPE := NVL(:NEW.nm_type,:OLD.nm_type);
   l_nm_obj_type CONSTANT NM_MEMBERS_ALL.nm_obj_type%TYPE := NVL(:NEW.nm_obj_type,:OLD.nm_obj_type);
--
   PROCEDURE create_nmst (p_rec_nm nm_members_all%ROWTYPE
                         ,p_action nm_members_sde_temp.nmst_action%TYPE
                         ) IS
   BEGIN
      INSERT INTO NM_MEMBERS_SDE_TEMP
             (nmst_id
             ,nmst_ne_id_in
             ,nmst_ne_id_of
             ,nmst_begin_mp
             ,nmst_end_mp
             ,nmst_obj_type
             ,nmst_start_date
             ,nmst_end_date
             ,nmst_action
             )
      VALUES (nm_audit_temp_seq.NEXTVAL
             ,p_rec_nm.nm_ne_id_in
             ,p_rec_nm.nm_ne_id_of
             ,p_rec_nm.nm_begin_mp
             ,p_rec_nm.nm_end_mp
             ,p_rec_nm.nm_obj_type
             ,p_rec_nm.nm_start_date
             ,p_rec_nm.nm_end_date
             ,p_action
             );
   END create_nmst;
--
BEGIN
  -- MJA add 31-Aug-07
  -- New functionality to allow override of triggers
  If Not nm3net.bypass_nm_members_trgs
  Then
    --
     IF higgis.has_shape( NVL(:OLD.nm_ne_id_of,:NEW.nm_ne_id_of) )
      AND
        nm3ddl.does_object_exist( p_object_name => nm3inv_sde.get_inv_sde_table_name(l_nm_obj_type)
                                , p_object_type => 'TABLE')
      THEN
        IF l_nm_type = 'I'
         THEN
     --
           DECLARE
              l_rec_nm          NM_MEMBERS_ALL%ROWTYPE;
              l_action          NM_MEMBERS_SDE_TEMP.nmst_action%TYPE;
           BEGIN
     --
              l_rec_nm.nm_begin_mp       := :OLD.nm_begin_mp;
              l_rec_nm.nm_end_mp         := :OLD.nm_end_mp;
     --
              IF DELETING AND higgis.has_shape( NVL(:OLD.nm_ne_id_of,:NEW.nm_ne_id_of) )
               THEN
     --
                 l_rec_nm.nm_ne_id_in    := :OLD.nm_ne_id_in;
                 l_rec_nm.nm_ne_id_of    := :OLD.nm_ne_id_of;
                 l_rec_nm.nm_obj_type    := :OLD.nm_obj_type;
                 l_rec_nm.nm_start_date  := :OLD.nm_start_date;
                 l_rec_nm.nm_end_date    := :OLD.nm_end_date;
                 l_action                := 'D';
     --
              ELSE
     --
                 l_rec_nm.nm_ne_id_in    := :NEW.nm_ne_id_in;
                 l_rec_nm.nm_ne_id_of    := :NEW.nm_ne_id_of;
                 l_rec_nm.nm_obj_type    := :NEW.nm_obj_type;
                 l_rec_nm.nm_start_date  := :NEW.nm_start_date;
                 l_rec_nm.nm_begin_mp    := :NEW.nm_begin_mp;
                 l_rec_nm.nm_end_mp      := :NEW.nm_end_mp;
     --
                 IF NVL(:OLD.nm_end_date,nm3type.c_big_date) != NVL(:NEW.nm_end_date,nm3type.c_big_date)
                  THEN
                    l_rec_nm.nm_end_date := :NEW.nm_end_date;
                 ELSE
                    l_rec_nm.nm_end_date := NULL;
                 END IF;
     --
                 IF UPDATING
                  THEN
                    l_action             := 'U';
                 ELSIF INSERTING
                  AND  :NEW.nm_end_date IS NOT NULL
                  THEN
                    -- if we are creating a record with an end-date
                    --  then create a pair - one for the INSERT and one for the End Date
                    create_nmst (l_rec_nm,'I');
                    l_action             := 'U';
                 ELSE
                    l_action             := 'I';
                 END IF;
     --
              END IF;
     --
              create_nmst (l_rec_nm,l_action);
  
     --
           END;
     --
        ELSE
           IF hig.get_sysopt('INVVIEWSLK') = 'Y'  AND
              nm3net.is_nt_inclusion( nm3net.get_nt_type( :NEW.nm_ne_id_in )) AND
             ( (  UPDATING AND :NEW.nm_slk <> :OLD.nm_slk ) OR
  		        INSERTING )
             THEN
               BEGIN
                 INSERT INTO nm_sde_temp_rescale
                        ( nmtr_id
                         ,nmtr_ne_id_of )
                 VALUES ( nm_audit_temp_seq.NEXTVAL
                         ,:NEW.nm_ne_id_of
                        );
               EXCEPTION
                  WHEN DUP_VAL_ON_INDEX THEN NULL;
               END;
           END IF;
        END IF;					 -- group/inv
  	END IF;  					 -- shape
  --
  End If;
END nm_members_sde_trg;
/
