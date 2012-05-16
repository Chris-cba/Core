Create Table Nm_Admin_Extents
(
Nae_Admin_Unit    Number(9),        
Nae_Extent        Mdsys.Sdo_Geometry,
Constraint Nae_Pk Primary Key (Nae_Admin_Unit)
)
Organization Index
/

Comment On Table Nm_Admin_Extents Is 'Used to hold the default extent per admin unit, for use with mapviewer.'
/

Comment On Column  Nm_Admin_Extents.Nae_Admin_Unit Is 'The admin unit for the extent.'
/

Comment On Column  Nm_Admin_Extents.Nae_Extent Is 'The default Extent for an admin unit.'
/
