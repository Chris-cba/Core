--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm_4400_fix20_ddl.sql-arc   1.4   Jul 04 2013 13:47:14   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_4400_fix20_ddl.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:47:14  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:34:14  $
--       Version          : $Revision:   1.4  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
Create Table Nm_Admin_Extents
(
Nae_Admin_Unit    Number(9),        
Nae_Extent        Sdo_Geometry,
Constraint Nae_Pk Primary Key (Nae_Admin_Unit),
Constraint Nae_Nau_Fk Foreign Key (Nae_Admin_Unit) References Nm_Admin_Units_All(Nau_Admin_Unit) On Delete Cascade
)
Organization Index
/

Comment On Table Nm_Admin_Extents Is 'Used to hold the default extent per admin unit, for use with mapviewer.'
/

Comment On Column  Nm_Admin_Extents.Nae_Admin_Unit Is 'The admin unit for the extent.'
/

Comment On Column  Nm_Admin_Extents.Nae_Extent Is 'The default Extent for an admin unit.'
/

Begin
  Nm3Ddl.Refresh_All_Synonyms;
End;
/

