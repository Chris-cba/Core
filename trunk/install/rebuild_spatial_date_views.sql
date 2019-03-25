----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/rebuild_spatial_date_views.sql-arc   1.0   Mar 25 2019 13:54:10   Chris.Baugh  $
--       Module Name      : $Workfile:   rebuild_spatial_date_views.sql  $ 
--       Date into PVCS   : $Date:   Mar 25 2019 13:54:10  $
--       Date fetched Out : $Modtime:   Mar 25 2019 13:53:08  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2017 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
DECLARE
    CURSOR c1 IS
        SELECT nit_inv_type, view_name
          FROM nm_inv_types, user_views
         WHERE view_name = 'V_NM_NIT_' || nit_inv_type || '_SDO';
BEGIN
    FOR irec IN c1
    LOOP
        create_spatial_date_view_new (
            'NM_NIT_' || irec.nit_inv_type || '_SDO');
    END LOOP;
END;