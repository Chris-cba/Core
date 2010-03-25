CREATE OR REPLACE TRIGGER nm_inv_type_roles_ins
BEFORE INSERT 
ON nm_inv_type_roles
FOR EACH ROW
DECLARE
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_inv_type_roles_ins.trg-arc   3.0   Mar 25 2010 11:47:56   lsorathia  $
--       Module Name      : $Workfile:   nm_inv_type_roles_ins.trg  $
--       Date into SCCS   : $Date:   Mar 25 2010 11:47:56  $
--       Date fetched Out : $Modtime:   Mar 25 2010 09:54:08  $
--       SCCS Version     : $Revision:   3.0  $
--       Based on
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
   l_nit_rec nm_inv_types%ROWTYPE := nm3get.get_nit(:New.itr_inv_type);
BEGIN
--
   IF l_nit_rec.nit_category = 'A'      
   THEN
       Raise_Application_Error(-20001,'Roles cannot be assigned to Inventory of category type ''A''');
   END IF ;
--
END ;
/
