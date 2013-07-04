-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)refresh_subordinates_sdo_metadata.sql	1.1 08/11/05
--       Module Name      : refresh_subordinates_sdo_metadata.sql
--       Date into SCCS   : 05/08/11 09:09:29
--       Date fetched Out : 07/06/13 17:07:27
--       SCCS Version     : 1.1
--
--
--   Author : A Edwards
--
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

/* Create Subordinate User SDO Metadata */
BEGIN
  FOR i IN 
    (SELECT hus_username
       FROM hig_users
      WHERE HUS_IS_HIG_OWNER_FLAG = 'N'
        AND EXISTS
        (SELECT 1 
           FROM all_users
          WHERE username = hus_username))
  LOOP
    nm3sdm.refresh_usgm(i.hus_username);
  END LOOP;
EXCEPTION
  WHEN OTHERS
  THEN NULL;
END;
/

