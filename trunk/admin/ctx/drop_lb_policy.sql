--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/ctx/drop_lb_policy.sql-arc   1.0   Dec 20 2018 13:37:58   Chris.Baugh  $
--       Module Name      : $Workfile:   drop_lb_policy.sql  $
--       Date into PVCS   : $Date:   Dec 20 2018 13:37:58  $
--       Date fetched Out : $Modtime:   Jan 15 2015 20:56:10  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : R.A. Coupe
--
--   Drop Policy Script Location Bridge FGAC security
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--
begin
  dbms_rls.drop_policy( object_schema => user
                         , object_name => 'NM_LOCATIONS_ALL'
                         , policy_name => 'LB_LOC_POLICY'
                         );
  dbms_rls.drop_policy( object_schema => user
                         , object_name => 'NM_ASSET_LOCATIONS_ALL'
                         , policy_name => 'LB_NAL_POLICY'
                         );
end;
