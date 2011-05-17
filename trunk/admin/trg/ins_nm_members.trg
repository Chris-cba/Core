CREATE OR REPLACE TRIGGER ins_nm_members
       BEFORE  INSERT OR UPDATE
       ON      NM_MEMBERS_ALL
       FOR     EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/trg/ins_nm_members.trg-arc   2.1   May 17 2011 16:52:22   Chris.Strettle  $
--       Module Name      : $Workfile:   ins_nm_members.trg  $
--       Date into PVCS   : $Date:   May 17 2011 16:52:22  $
--       Date fetched Out : $Modtime:   May 17 2011 16:46:42  $
--       PVCS Version     : $Revision:   2.1  $
--       Norfolk Specific Based on Main Branch revision : 2.0
--
--   Author : Chris Strettle
--
-- TRIGGER ins_nm_members
--       BEFORE  INSERT OR UPDATE
--       ON      NM_MEMBERS_ALL
--       FOR     EACH ROW
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
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
--ensure the herm_xsp table is consistet with thehermis memberships  
--
IF :new.nm_obj_type = 'SECT' 
AND NVL(hig.get_sysopt('XSPOFFSET'),'N') = 'Y'
THEN

  IF UPDATING and :old.nm_cardinality != :new.nm_cardinality 
  THEN
  --
    EXECUTE IMMEDIATE 
    'begin ' ||
    
    'update herm_xsp ' ||
    'set hxo_herm_dir_flag = decode( hxo_herm_dir_flag, :NEW_CARDINALITY, hxo_herm_dir_flag, hxo_herm_dir_flag * (-1)), ' ||
        'hxo_offset = decode( hxo_herm_dir_flag, :NEW_CARDINALITY, hxo_offset, hxo_offset * (-1) ) ' ||
    'where hxo_ne_id_of = :NEW_NE_ID_OF; ' ||
    
    'insert into xncc_herm_xsp_temp ' ||
    'values ( :NEW_NE_ID_OF ); ' ||
    
    'end;' USING :NEW.nm_cardinality, :NEW.nm_ne_id_of;
  --
    
  --
  elsif INSERTING then
  NM_DEBUG.DEBUG_ON;
  NM_DEBUG.DEBUG('INSERT MEM');
  NM_DEBUG.DEBUG_OFF;
    begin
    --
    EXECUTE IMMEDIATE
    'begin ' ||
    'xncc_herm_xsp.populate_herm_xsp( p_ne_id_in       => :new_nm_ne_id_in ' ||
                                   ', p_ne_id_of       => :new_nm_ne_id_of ' ||
                                   ', p_nm_cardinality => :new_nm_cardinality ' ||
                                   ', p_effective_date => :new_nm_start_date ); ' ||

    'insert into xncc_herm_xsp_temp ' ||
    'values ( :new_nm_ne_id_of ); ' ||
    
    'end; ' USING :new.nm_ne_id_in, :new.nm_ne_id_of, :new.nm_cardinality, :new.nm_start_date;
    --
    --  
    exception
      when others then 
        nm_debug.debug(sqlerrm);
    end;
  END IF;
  --
  IF UPDATING
  THEN
    IF :NEW.nm_end_date IS NOT NULL 
    AND :OLD.nm_end_date IS NULL
    THEN
      EXECUTE IMMEDIATE 'begin xncc_herm_xsp.close_herm_xsp(:NEW_nm_ne_id_of, :NEW_nm_end_date); end;' USING :NEW.nm_ne_id_of, :NEW.nm_end_date;
    ELSIF :NEW.nm_end_date IS NULL 
    AND   :OLD.nm_end_date IS NOT NULL
    THEN
      EXECUTE IMMEDIATE 'begin xncc_herm_xsp.unclose_herm_xsp(:NEW_nm_ne_id_of, :OLD_nm_end_date); end;' USING :NEW.nm_ne_id_of, :OLD.nm_end_date;
    END IF;
  END IF;
  --
END IF;
--
END ins_nm_members;
/