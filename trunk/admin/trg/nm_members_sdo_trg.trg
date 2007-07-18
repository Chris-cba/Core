CREATE OR REPLACE TRIGGER nm_members_sdo_trg
   before UPDATE OR INSERT OR DELETE
   ON NM_MEMBERS_ALL
   FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_members_sdo_trg.trg	1.4 08/17/05
--       Module Name      : nm_members_sdo_trg.trg
--       Date into SCCS   : 05/08/17 15:32:05
--       Date fetched Out : 07/06/13 17:03:24
--       SCCS Version     : 1.4
--
--
--   Author : R.A. Coupe
--
--   Members trigger for SDO
--   BEFORE INSERT OR UPDATE OR DELETE
--   ON nm_members_all
--   FOR EACH ROW
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--

BEGIN
--
-- Do not perform if the api flag is set
  if not nm3sdo.g_api_used and nm3sdo.single_shape_inv = 'N'  then

    if (( updating or inserting) and nm3sdm.type_has_shape(:new.nm_obj_type )) OR
       (  deleting and  nm3sdm.type_has_shape(:old.nm_obj_type )) then

      if  ( updating and :old.nm_end_date is null and :new.nm_end_date is not null and :old.nm_begin_mp = :new.nm_begin_mp
                   and nvl(:old.nm_end_mp, -1) = nvl( :new.nm_end_mp, -1 )) 
          OR 
          ( updating and :old.nm_end_date is not null and :new.nm_end_date is null and :old.nm_begin_mp = :new.nm_begin_mp
                   and nvl(:old.nm_end_mp, -1) = nvl( :new.nm_end_mp, -1 ))          

         then

  --     change of end date only
         nm3sdm.end_member_shape( p_nm_ne_id_in => :old.nm_ne_id_in
                                 ,p_nm_ne_id_of => :old.nm_ne_id_of
                                 ,p_nm_obj_type => :old.nm_obj_type
                                 ,p_nm_begin_mp => :old.nm_begin_mp
                                 ,p_nm_end_mp   => :old.nm_end_mp
                                 ,p_nm_start_date => :old.nm_start_date
                                 ,p_nm_end_date   => :new.nm_end_date
                                 ,p_nm_type       => :old.nm_type );
         
      elsif updating then

  --    most columns on the member are not updatable, this is assumed an update of measure - reshape the member - the old start date is
  --    referenced because that it the key into the record - this should not be changed on an update
  --    However, the old start date and the old begin mp must be available as a means of hitting the correct
  --    record.
  
         nm3sdm.update_member_shape( p_nm_ne_id_in   => :old.nm_ne_id_in
                                    ,p_nm_ne_id_of   => :new.nm_ne_id_of
                                    ,p_nm_obj_type   => :new.nm_obj_type
                                    ,p_old_begin_mp  => :old.nm_begin_mp
                                    ,p_new_begin_mp  => :new.nm_begin_mp
                                    ,p_nm_end_mp     => :new.nm_end_mp
                                    ,p_old_start_date => :old.nm_start_date
                                    ,p_new_start_date => :new.nm_start_date
                                    ,p_nm_end_date   => :new.nm_end_date
                                    ,p_nm_type       => :old.nm_type );
                                   
                                    
      elsif deleting then
          nm3sdm.remove_member_shape( p_nm_ne_id_in => :old.nm_ne_id_in
                                 ,p_nm_ne_id_of => :old.nm_ne_id_of
                                 ,p_nm_obj_type => :old.nm_obj_type
                                 ,p_nm_begin_mp => :old.nm_begin_mp
                                 ,p_nm_end_mp   => :old.nm_end_mp
                                 ,p_nm_start_date => :old.nm_start_date
                                 ,p_nm_end_date   => :new.nm_end_date
                                 ,p_nm_type       => :old.nm_type );


      elsif inserting then
           nm3sdm.add_member_shape( p_nm_ne_id_in => :new.nm_ne_id_in
                                 ,p_nm_ne_id_of => :new.nm_ne_id_of
                                 ,p_nm_obj_type => :new.nm_obj_type
                                 ,p_nm_begin_mp => :new.nm_begin_mp
                                 ,p_nm_end_mp   => :new.nm_end_mp
                                 ,p_nm_start_date => :new.nm_start_date
                                 ,p_nm_end_date   => :new.nm_end_date
                                 ,p_nm_type       => :new.nm_type );
      end if;

  end if;

  end if;
end;
/
