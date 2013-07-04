CREATE OR REPLACE TRIGGER nm_inv_type_roles_ins
BEFORE INSERT 
ON nm_inv_type_roles
FOR EACH ROW
DECLARE
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_inv_type_roles_ins.trg-arc   3.1   Jul 04 2013 09:53:28   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_inv_type_roles_ins.trg  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:53:28  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:35:32  $
--       SCCS Version     : $Revision:   3.1  $
--       Based on
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
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
