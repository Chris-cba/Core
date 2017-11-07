CREATE OR REPLACE PROCEDURE make_nw_from_lrefs (pi_lrefs IN nm_lref_array)
IS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/make_nw_from_lrefs.prc-arc   1.0   Nov 07 2017 12:07:16   Rob.Coupe  $
   --       Module Name      : $Workfile:   make_nw_from_lrefs.prc  $
   --       Date into PVCS   : $Date:   Nov 07 2017 12:07:16  $
   --       Date fetched Out : $Modtime:   Nov 07 2017 12:05:52  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : R.A. Coupe
   --
   --   A temporary stand-alone procedure to generate a network graph from a series of linear references
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
BEGIN
    lb_path.make_nw_from_lrefs (pi_inv_type => NULL,  pi_lrefs => pi_lrefs ); 
END;
/
