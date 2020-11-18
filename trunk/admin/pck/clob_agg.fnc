CREATE OR REPLACE FUNCTION clob_agg (p_input clob)
RETURN clob
    --
    -----------------------------------------------------------------------------
    --
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/clob_agg.fnc-arc   1.0   Nov 18 2020 16:04:10   Rob.Coupe  $
    --       Module Name      : $Workfile:   clob_agg.fnc  $
    --       Date into PVCS   : $Date:   Nov 18 2020 16:04:10  $
    --       Date fetched Out : $Modtime:   Nov 18 2020 16:02:54  $
    --       PVCS Version     : $Revision:   1.0  $
    --
    --   Author : Rob Coupe
    --
    --   Package responsible for bulk validation of inventory data inside the Spatial/Transportation data loader
    --
    -----------------------------------------------------------------------------
    --   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
    -----------------------------------------------------------------------------
    --
    --  g_body_sccsid   CONSTANT VARCHAR2 (2000) := '$Revision:   1.0  $';
PARALLEL_ENABLE AGGREGATE USING t_clob_agg;
/