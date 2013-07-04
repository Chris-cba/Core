CREATE OR REPLACE FORCE VIEW hig_upgrades_vw
(
  hpr_product_name
 ,hpr_product
 ,hup_product
 ,date_upgraded
 ,from_version
 ,to_version
 ,upgrade_script
 ,executed_by
 ,remarks
)
AS
SELECT 
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_upgrade_vw.vw-arc   3.1   Jul 04 2013 11:20:06   James.Wadsworth  $
--       Module Name      : $Workfile:   hig_upgrade_vw.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:06  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:58:32  $
--       Version          : $Revision:   3.1  $
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
      initcap(p.hpr_product_name) hpr_product_name
     ,p.hpr_product
     ,u.HUP_PRODUCT
     ,u.DATE_UPGRADED
     ,u.FROM_VERSION
     ,u.TO_VERSION
     ,u.UPGRADE_SCRIPT
     ,u.EXECUTED_BY
     ,u.REMARKS
 FROM hig_upgrades u, hig_products p
WHERE hpr_product = hup_product;
