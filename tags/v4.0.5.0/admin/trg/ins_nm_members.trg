CREATE OR REPLACE TRIGGER ins_nm_members
       BEFORE  INSERT OR UPDATE
       ON      NM_MEMBERS_ALL
       FOR     EACH ROW
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)ins_nm_members.trg	1.6 03/18/02
--       Module Name      : ins_nm_members.trg
--       Date into SCCS   : 02/03/18 14:16:41
--       Date fetched Out : 07/06/13 17:02:35
--       SCCS Version     : 1.6
--
-- TRIGGER ins_nm_members
--       BEFORE  INSERT OR UPDATE
--       ON      NM_MEMBERS_ALL
--       FOR     EACH ROW
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
   --
   -- checks that the parent record exists
   -- if it doesn't exist raise
   --      -20001, 'Parent not found''
   -- If not of type G Group or I Inventory then raise
   --      -20001 'Unknown member type''
   -- Checks that the start/end date of the child are
   -- between the start/end dates of the parent
   -- only checks end date if it is not null
   -- raises the following
   --      -20981, 'Member start date out of range'
   --      -20982, 'Member end date out of range'
   --      -20983, 'End date must be greater than start date'
   --
   l_mode VARCHAR2(9);
--
BEGIN
--
   IF    UPDATING
    THEN
      l_mode := nm3type.c_updating;
   ELSE
      l_mode := nm3type.c_inserting;
   END IF;
--
   nm3nwval.check_members (p_old_nm_ne_id_in   => :old.nm_ne_id_in
                          ,p_old_nm_ne_id_of   => :old.nm_ne_id_of
                          ,p_old_nm_start_date => :old.nm_start_date
                          ,p_old_nm_obj_type   => :old.nm_obj_type
                          ,p_new_nm_ne_id_in   => :new.nm_ne_id_in
                          ,p_new_nm_ne_id_of   => :new.nm_ne_id_of
                          ,p_new_nm_type       => :new.nm_type
                          ,p_new_nm_obj_type   => :new.nm_obj_type
                          ,p_new_nm_start_date => :new.nm_start_date
                          ,p_new_nm_end_date   => :new.nm_end_date
                          ,p_new_nm_begin_mp   => :new.nm_begin_mp
                          ,p_new_nm_end_mp     => :new.nm_end_mp
                          ,p_mode              => l_mode
                          );
--
END ins_nm_members;
/
