CREATE OR REPLACE FORCE VIEW V_NM_ELEMENT_XSP_RVRS
(
   XSP_ELEMENT_ID,
   ELEMENT_SUB_CLASS,
   ELEMENT_XSP,
   XSP_DIRECTION_FLAG,
   RVRS_SUB_CLASS,
   RVRS_XSP
)
AS
   SELECT --
          -----------------------------------------------------------------------------
          --
          --   PVCS Identifiers :-
          --
          --       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/views/v_nm_element_xsp_rvrs.vw-arc   1.0   Mar 02 2018 16:48:12   Rob.Coupe  $
          --       Module Name      : $Workfile:   v_nm_element_xsp_rvrs.vw  $
          --       Date into PVCS   : $Date:   Mar 02 2018 16:48:12  $
          --       Date fetched Out : $Modtime:   Mar 02 2018 16:48:24  $
          --       PVCS Version     : $Revision:   1.0  $
          --
          --   Author : Rob Coupe
          --
          --   Location Bridge data script.
          --
          -----------------------------------------------------------------------------
          --   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
          -----------------------------------------------------------------------------
          --
          /*
                         A View to express the XSPs available on a specified network element. A direction flag and reversal is
                         computed based on the direction of the element relative to the element on which the XSP data is recorded.
                         For example, where an XSP domain is configured against a road group but asset locations are persisted
                         against a datum, then the direction of XSP against a datum is based on the direction (nm_cardinality) flag
                         of the datum relative to the group. Similarly, if XSP rules are expressed relative to a datum type, then the
                         direction of the XSP as expressed relative to the route may also be reversed depending on the direction flag.
                         In the aggregation of asset locations relative to a route system, it is quite conceivable that the route type
                         used may not be the same type as that used in the XSP configuration.
                     */
          x.element_id xsp_element_id,
          x.nwx_nsc_sub_class element_sub_class,
          x.nwx_x_sect element_xsp,
          xsp_direction_flag,
          R.XRV_NEW_SUB_CLASS rvrs_sub_class,
          R.XRV_NEW_XSP rvrs_xsp
     FROM v_nm_element_xsp x, nm_xsp_reversal r
    WHERE     R.XRV_NW_TYPE = x.xsp_ne_nt_type
          AND R.XRV_OLD_SUB_CLASS = x.nwx_nsc_sub_class
          AND R.XRV_OLD_XSP = x.nwx_x_sect;