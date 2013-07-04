--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/create_usr_menu.sql-arc   2.1   Jul 04 2013 13:45:00   James.Wadsworth  $
--       Module Name      : $Workfile:   create_usr_menu.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:45:00  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:57:02  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
rem   SCCS Identifiers :-
rem
rem       sccsid          "'@(#)create_usr_menu.sql	1.1 05/23/02'"
rem
rem

/*
   The user configurable menu requires that a product record exists in HIG_PRODUCTS. The menu
   which can be created from this script is required to be under the product named 'USR'
   Note also that the role 'USER_ROLE' is explicitly defined inside the script and will be
   in existence both inside the DBMS and within HIG_ROLES

   This utility is intended to insert all the hig_modules for a set of user configurable
   menus and menu items.

   No attempt is made to set the hmo_filename to be meaningful. Once these modules have been
   inserted, the application USR will have many menus and menu items. In order to configure the
   items, the filename will be required to be updated by the users.

*/


declare
  itemno varchar2(10);
  menuno varchar2(10);
  menid  integer;
  itemid integer;
begin

  for menid  in 1..8 loop

    menuno := to_char( menid );

    insert into hig_modules
       ( HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS, HMO_FASTPATH_INVALID,
         HMO_USE_GRI, HMO_APPLICATION, HMO_MENU )
    values ( 'ITEM'||menuno, 'User Menu '||menuno, 'dummy', 'MMX',
             null, 'Y', 'N', 'USR', 'ITEM'||menuno );

    insert into hig_module_roles
       ( HMR_MODULE, HMR_ROLE, HMR_MODE )
    values ( 'ITEM'||menuno, 'USER_ROLE', 'NORMAL' );

    for itemid in 1..9 loop


      itemno := to_char( itemid );
      insert into hig_modules
      values ( 'ITEM'||menuno||itemno, 'User Item'||menuno||itemno, 'filename', 'FMX',
               null, 'N', 'N', 'USR', 'ITEM'||menuno );

      insert into hig_module_roles
         ( HMR_MODULE, HMR_ROLE, HMR_MODE )
      values ( 'ITEM'||menuno||itemno, 'USER_ROLE', 'NORMAL' );

    end loop;
  end loop;
end;
/


