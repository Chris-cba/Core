--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/register_aggr_theme.sql-arc   1.0   Jun 30 2016 11:31:58   Rob.Coupe  $
--       Module Name      : $Workfile:   register_aggr_theme.sql  $
--       Date into PVCS   : $Date:   Jun 30 2016 11:31:58  $
--       Date fetched Out : $Modtime:   Jun 30 2016 11:31:04  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
start register_aggr_theme.prc
--
begin
   nm3ddl.create_synonym_for_object( 'REGISTER_AGGR_THEME' );
end;
/
