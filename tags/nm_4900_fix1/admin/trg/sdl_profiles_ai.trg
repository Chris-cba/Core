CREATE OR REPLACE TRIGGER sdl_profiles_ai
  AFTER INSERT ON sdl_profiles
  FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/sdl_profiles_ai.trg-arc   1.1   Jul 30 2020 08:19:34   Vikas.Mhetre  $
--       Module Name      : $Workfile:   sdl_profiles_ai.trg  $
--       Date into PVCS   : $Date:   Jul 30 2020 08:19:34  $
--       Date fetched Out : $Modtime:   Jul 30 2020 08:15:36  $
--       PVCS Version     : $Revision:   1.1  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
  -- Create by default fixed range data of review levels for the new SDL profile.
  INSERT INTO sdl_spatial_review_levels (ssrl_sp_id, ssrl_percent_from, ssrl_percent_to, ssrl_coverage_level, ssrl_default_action)
    VALUES(:NEW.sp_id , -999.999, -0.001, 'No Statistics', 'REVIEW');
  INSERT INTO sdl_spatial_review_levels (ssrl_sp_id, ssrl_percent_from, ssrl_percent_to, ssrl_coverage_level, ssrl_default_action)
    VALUES(:NEW.sp_id , 0.000, 19.999, 'Very Low', 'LOAD');
  INSERT INTO sdl_spatial_review_levels (ssrl_sp_id, ssrl_percent_from, ssrl_percent_to, ssrl_coverage_level, ssrl_default_action)
    VALUES(:NEW.sp_id , 20.000, 39.999, 'Low', 'REVIEW');
  INSERT INTO sdl_spatial_review_levels (ssrl_sp_id, ssrl_percent_from, ssrl_percent_to, ssrl_coverage_level, ssrl_default_action)
    VALUES(:NEW.sp_id , 40.000, 59.999, 'Medium', 'REVIEW');
  INSERT INTO sdl_spatial_review_levels (ssrl_sp_id, ssrl_percent_from, ssrl_percent_to, ssrl_coverage_level, ssrl_default_action)
    VALUES(:NEW.sp_id , 60.000, 79.999, 'Medium High', 'REVIEW');
  INSERT INTO sdl_spatial_review_levels (ssrl_sp_id, ssrl_percent_from, ssrl_percent_to, ssrl_coverage_level, ssrl_default_action)
    VALUES(:NEW.sp_id , 80.000, 99.999, 'High', 'REVIEW');
  INSERT INTO sdl_spatial_review_levels (ssrl_sp_id, ssrl_percent_from, ssrl_percent_to, ssrl_coverage_level, ssrl_default_action)
    VALUES(:NEW.sp_id , 100.000, 999.999, 'Very High', 'SKIP');
  --
END sdl_profiles_ai;
/