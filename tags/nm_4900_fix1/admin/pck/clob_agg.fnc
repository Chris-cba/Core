CREATE OR REPLACE FUNCTION clob_agg (p_input clob)
RETURN clob
    --
    -----------------------------------------------------------------------------
    --
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/clob_agg.fnc-arc   1.1   Nov 18 2020 16:06:58   Rob.Coupe  $
    --       Module Name      : $Workfile:   clob_agg.fnc  $
    --       Date into PVCS   : $Date:   Nov 18 2020 16:06:58  $
    --       Date fetched Out : $Modtime:   Nov 18 2020 16:06:36  $
    --       PVCS Version     : $Revision:   1.1  $
    --
    --   Author : Rob Coupe
    --
    --   Simple aggregation of varchars/clobs used to work around restrictions in code such as LISTAGG
    --
    -----------------------------------------------------------------------------
    --   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
    -----------------------------------------------------------------------------
    --
    --  g_body_sccsid   CONSTANT VARCHAR2 (2000) := '$Revision:   1.1  $';
PARALLEL_ENABLE AGGREGATE USING t_clob_agg;
/