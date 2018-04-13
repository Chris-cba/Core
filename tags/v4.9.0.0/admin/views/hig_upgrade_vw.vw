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
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/hig_upgrade_vw.vw-arc   3.2   Apr 13 2018 11:47:16   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   hig_upgrade_vw.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:16  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:31:38  $
--       Version          : $Revision:   3.2  $
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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
