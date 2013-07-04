CREATE OR REPLACE TRIGGER nm_inv_items_all_xattr_b_row
 BEFORE UPDATE
 ON NM_INV_ITEMS_ALL
 FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_items_all_xattr_b_row.trg	1.5 10/02/02
--       Module Name      : nm_inv_items_all_xattr_b_row.trg
--       Date into SCCS   : 02/10/02 17:18:35
--       Date fetched Out : 07/06/13 17:02:59
--       SCCS Version     : 1.5
--
--   Author : Rob Coupe
--
--   Xattr Validation trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
  cur_string varchar2(2000);
  l_value    varchar2(2000);

BEGIN

  if nm3inv_xattr.g_xattr_active then

--
--  The end-date of an independent item could be checked here but it is not necessary since the end date of
--  the objects location must precede the enddate of the object. The trigger on the end-date of location will
--  fire and trap any errors before they could be trapped with virtually repeated code here.
--
--  If any other attributes have changed then the trigger must re-evaluate the dependencies.
--  This needs to be improved such that only those attributes which directly impact on the validity of
--  the dependents are trapped.
--
--
--  nm_debug.debug_on;

    if nm3inv_xattr.check_type( :new.iit_inv_type, 'I' ) then

--  If the item type is an independent one then add it to the list to be processed.

      nm3inv_xattr.g_tab_item_idx_xattr := nvl(nm3inv_xattr.g_tab_item_idx_xattr,0) + 1;

      nm3inv_xattr.g_tab_loc_item_xattr(nm3inv_xattr.g_tab_item_idx_xattr).iit_ne_id    := :NEW.iit_ne_id;
      nm3inv_xattr.g_tab_loc_item_xattr(nm3inv_xattr.g_tab_item_idx_xattr).iit_inv_type := :NEW.iit_inv_type;
           
      nm3inv_xattr.g_tab_loc_item_xattr(nm3inv_xattr.g_tab_item_idx_xattr).dep_class    := 'I';

      if :new.iit_end_date is not null then 
        nm3inv_xattr.g_tab_loc_item_xattr(nm3inv_xattr.g_tab_item_idx_xattr).op := 'C' ;
      else
        if inserting then
          nm3inv_xattr.g_tab_loc_item_xattr(nm3inv_xattr.g_tab_item_idx_xattr).op := 'I' ;
        else
          nm3inv_xattr.g_tab_loc_item_xattr(nm3inv_xattr.g_tab_item_idx_xattr).op := 'U' ;
        end if;
      end if;

    end if;

    if nm3inv_xattr.check_type( :new.iit_inv_type, 'D' ) then

--  If the item type is a dependent one then add it to the list to be processed.

--  nm_debug.debug( 'D type Item = '||to_char(:new.iit_ne_id)||' type = '||:new.iit_inv_type );
      nm3inv_xattr.g_tab_item_idx_xattr := nvl(nm3inv_xattr.g_tab_item_idx_xattr,0) + 1;

      nm3inv_xattr.g_tab_loc_item_xattr(nm3inv_xattr.g_tab_item_idx_xattr).iit_ne_id    := :NEW.iit_ne_id;
      nm3inv_xattr.g_tab_loc_item_xattr(nm3inv_xattr.g_tab_item_idx_xattr).iit_inv_type := :NEW.iit_inv_type;
      nm3inv_xattr.g_tab_loc_item_xattr(nm3inv_xattr.g_tab_item_idx_xattr).dep_class    := 'D';

      if :new.iit_end_date is not null then 
        nm3inv_xattr.g_tab_loc_item_xattr(nm3inv_xattr.g_tab_item_idx_xattr).op := 'C' ;
      else
        if inserting then
          nm3inv_xattr.g_tab_loc_item_xattr(nm3inv_xattr.g_tab_item_idx_xattr).op := 'I' ;
        else
          nm3inv_xattr.g_tab_loc_item_xattr(nm3inv_xattr.g_tab_item_idx_xattr).op := 'U' ;
        end if;
      end if;

    end if;

    if nm3inv_xattr.check_type( :new.iit_inv_type, 'N' ) then


--  If the item type is a dependent one then add it to the list to be processed.

      nm3inv_xattr.g_tab_item_idx_xattr := nvl(nm3inv_xattr.g_tab_item_idx_xattr,0) + 1;

      nm3inv_xattr.g_tab_loc_item_xattr(nm3inv_xattr.g_tab_item_idx_xattr).iit_ne_id    := :NEW.iit_ne_id;
      nm3inv_xattr.g_tab_loc_item_xattr(nm3inv_xattr.g_tab_item_idx_xattr).iit_inv_type := :NEW.iit_inv_type;
      nm3inv_xattr.g_tab_loc_item_xattr(nm3inv_xattr.g_tab_item_idx_xattr).dep_class    := 'N';

      if :new.iit_end_date is not null then 
        nm3inv_xattr.g_tab_loc_item_xattr(nm3inv_xattr.g_tab_item_idx_xattr).op := 'C' ;
      else
        if inserting then
          nm3inv_xattr.g_tab_loc_item_xattr(nm3inv_xattr.g_tab_item_idx_xattr).op := 'I' ;
        else
          nm3inv_xattr.g_tab_loc_item_xattr(nm3inv_xattr.g_tab_item_idx_xattr).op := 'U' ;
        end if;
      end if;
    end if;

  end if;

--
END nm_inv_items_all_xattr_b_row;
/
