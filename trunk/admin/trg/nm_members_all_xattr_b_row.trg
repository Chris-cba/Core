CREATE OR REPLACE TRIGGER nm_members_all_xattr_b_row
 BEFORE INSERT
  OR UPDATE
  OR DELETE
 ON NM_MEMBERS_ALL
 FOR EACH ROW
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_members_all_xattr_b_row.trg	1.8 10/03/02
--       Module Name      : nm_members_all_xattr_b_row.trg
--       Date into SCCS   : 02/10/03 12:27:24
--       Date fetched Out : 07/06/13 17:03:22
--       SCCS Version     : 1.8
--
--   Author : Rob Coupe
--
--   Xattr Validation trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
-- It is assumed that the object type (nm_obj_type) and the PK of the object itself (nm_ne_id_in) remain unchanged
--
st number;
en number;
--
BEGIN

-- nm_debug.debug_on;
-- if not nm3inv_xattr.g_xattr_active then
--   nm_debug.debug('Switched off!!!!');
-- end if;
   
   if nm3inv_xattr.g_xattr_active then

-- Only apply the checking if the fundamentals have been changed and the extent has increased over the original.
-- If increase in extent or creating a new record the dependent types need to be assessed - make sure that the
-- independent types are present to support the dependencies over the new extent

     if  nm3inv_xattr.location_rule('D', :new.nm_obj_type ) != 'NONE' then

       if (updating and :new.nm_type     =  'I'
  	   and ( :new.nm_begin_mp <  :old.nm_begin_mp OR
  	         :new.nm_end_mp   >  :old.nm_end_mp )) OR
  	   inserting and :new.nm_type = 'I' then

--       nm_debug.debug('Row trig - D element = '||to_char(:new.nm_ne_id_of));
         nm3inv_xattr.g_tab_loc_idx_xattr := nvl(nm3inv_xattr.g_tab_loc_idx_xattr,0) + 1;

         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_ne_id_in       := :NEW.nm_ne_id_in;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_obj_type       := :NEW.nm_obj_type;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_ne_id_of       := :NEW.nm_ne_id_of;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_begin_mp       := :NEW.nm_begin_mp;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_end_mp         := :NEW.nm_end_mp;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).dep_class         := 'D';

         if inserting then
           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).op              := 'I';
         elsif updating and :new.nm_end_date is not null then
           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).op              := 'C';
         elsif updating and :new.nm_end_date is null then
           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).op              := 'U';
         end if;
         
       end if;
     end if;

     if  nm3inv_xattr.check_type(:new.nm_obj_type, 'N' ) then

--     nm_debug.debug('Row trig - N element = '||to_char(:new.nm_ne_id_of));
       if (updating and :new.nm_type     =  'I'
  	   and ( :new.nm_begin_mp <  :old.nm_begin_mp OR
  	         :new.nm_end_mp   >  :old.nm_end_mp )) OR
  	   inserting and :new.nm_type = 'I' then

         nm3inv_xattr.g_tab_loc_idx_xattr := nvl(nm3inv_xattr.g_tab_loc_idx_xattr,0) + 1;

         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_ne_id_in       := :NEW.nm_ne_id_in;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_obj_type       := :NEW.nm_obj_type;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_ne_id_of       := :NEW.nm_ne_id_of;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_begin_mp       := :NEW.nm_begin_mp;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_end_mp         := :NEW.nm_end_mp;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).dep_class         := 'N';

         if inserting then
           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).op              := 'I';
         elsif updating and :new.nm_end_date is not null then
           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).op              := 'C';
         elsif updating and :new.nm_end_date is null then
           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).op              := 'U';
         end if;

       end if;
     end if;

--
--   Also check (for the same record if necessary) if the extent has been decreased in any direction and exposed
--   dependencies which are not allowed over the original extent.
--

     if nm3inv_xattr.location_rule('I', :new.nm_obj_type ) != 'NONE' then

       if ( updating and :new.nm_type     =  'I' and :new.nm_end_date is null and
        (:new.nm_begin_mp >  :old.nm_begin_mp OR
	     :new.nm_end_mp   <  :old.nm_end_mp ))    then
--       nm_debug.debug('Row trig - I element = '||to_char(:new.nm_ne_id_of));

         st := null;

         if :new.nm_end_mp < :old.nm_end_mp then
           if :old.nm_begin_mp > :new.nm_end_mp then
             st := :old.nm_begin_mp;
             en := :old.nm_end_mp;
           else
             st := :new.nm_end_mp;
             en := :old.nm_end_mp;
           end if;
         end if;

         if st is not null then

           nm3inv_xattr.g_tab_loc_idx_xattr := nvl(nm3inv_xattr.g_tab_loc_idx_xattr,0) + 1;

           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_ne_id_in       := :OLD.nm_ne_id_in;
           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_obj_type       := :OLD.nm_obj_type;
           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_ne_id_of       := :OLD.nm_ne_id_of;
           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_begin_mp       := st;
           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_end_mp         := en;
           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).dep_class         := 'I';

           if inserting then
             nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).op              := 'I';
           elsif updating and :new.nm_end_date is not null then
             nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).op              := 'C';
           elsif updating and :new.nm_end_date is null then
             nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).op              := 'U';
           end if;

         end if;

         st := null;

         if :new.nm_begin_mp > :old.nm_begin_mp then
           if :new.nm_begin_mp > :old.nm_end_mp then
             st := :old.nm_begin_mp;
             en := :old.nm_end_mp;
           else
             st := :old.nm_begin_mp;
             en := :new.nm_begin_mp;
           end if;
         end if;

         if st is not null then

           nm3inv_xattr.g_tab_loc_idx_xattr := nvl(nm3inv_xattr.g_tab_loc_idx_xattr,0) + 1;

           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_ne_id_in       := :OLD.nm_ne_id_in;
           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_obj_type       := :OLD.nm_obj_type;
           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_ne_id_of       := :OLD.nm_ne_id_of;
           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_begin_mp       := st;
           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_end_mp         := en;
           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).dep_class         := 'I';

           if inserting then
             nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).op              := 'I';
           elsif updating and :new.nm_end_date is not null then
             nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).op              := 'C';
           elsif updating and :new.nm_end_date is null then
             nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).op              := 'U';
           end if;

         end if;

       elsif updating and (( :new.nm_end_date is not null and :old.nm_end_date is null ) OR
          ( :new.nm_end_date is not null and :old.nm_end_date is not null and :new.nm_end_date < :old.nm_end_date )) OR
	      deleting and :old.nm_type = 'I'       then

         nm3inv_xattr.g_tab_loc_idx_xattr := nvl(nm3inv_xattr.g_tab_loc_idx_xattr,0) + 1;

         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_ne_id_in       := :OLD.nm_ne_id_in;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_obj_type       := :OLD.nm_obj_type;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_ne_id_of       := :OLD.nm_ne_id_of;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_begin_mp       := :OLD.nm_begin_mp;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_end_mp         := :OLD.nm_end_mp;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).dep_class         := 'I';

         if inserting then
           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).op              := 'I';
         elsif updating and :new.nm_end_date is not null then
           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).op              := 'C';
         elsif updating and :new.nm_end_date is null then
           nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).op              := 'U';
         end if;

       elsif inserting and :new.nm_type = 'I' then

--       nm_debug.debug('inserting a new independent');

         nm3inv_xattr.g_tab_loc_idx_xattr := nvl(nm3inv_xattr.g_tab_loc_idx_xattr,0) + 1;

         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_ne_id_in       := :NEW.nm_ne_id_in;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_obj_type       := :NEW.nm_obj_type;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_ne_id_of       := :NEW.nm_ne_id_of;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_begin_mp       := :NEW.nm_begin_mp;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_end_mp         := :NEW.nm_end_mp;
         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).dep_class         := 'I';

         nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).op                := 'I';

       end if;

     end if;
   end if;
--
END nm_members_all_xattr_b_row;
/
