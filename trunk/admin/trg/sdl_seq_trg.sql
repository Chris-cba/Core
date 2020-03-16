-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/sdl_seq_trg.sql-arc   1.0   Mar 16 2020 14:24:04   Vikas.Mhetre  $
--       Module Name      : $Workfile:   sdl_seq_trg.sql  $
--       Date into PVCS   : $Date:   Mar 16 2020 14:24:04  $
--       Date fetched Out : $Modtime:   Mar 14 2020 19:08:40  $
--       PVCS Version     : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--PROMPT Creating trigger on 'SDL_PROFILES'
CREATE OR REPLACE TRIGGER sdl_profiles_seq_trg
  BEFORE INSERT ON sdl_profiles
  FOR EACH ROW
BEGIN
  IF :NEW.sp_id IS NULL
  THEN
    :NEW.sp_id := sp_id_seq.NEXTVAL;
  END IF;
END sdl_profiles_seq_trg;
/
--PROMPT Creating trigger on 'SDL_USER_PROFILES'
CREATE OR REPLACE TRIGGER sdl_user_profiles_seq_trg
  BEFORE INSERT ON sdl_user_profiles
  FOR EACH ROW
BEGIN
  IF :NEW.sup_id IS NULL
  THEN
    :NEW.sup_id := sup_id_seq.NEXTVAL;
  END IF;
END sdl_user_profiles_seq_trg;
/
--PROMPT Creating trigger on 'SDL_ATTRIBUTE_MAPPING'
CREATE OR REPLACE TRIGGER sdl_attribute_mapping_seq_trg
  BEFORE INSERT ON sdl_attribute_mapping
  FOR EACH ROW
BEGIN
  IF :NEW.sam_id IS NULL
  THEN
    :NEW.sam_id := sam_id_seq.NEXTVAL;
  END IF;
END sdl_attribute_mapping_seq_trg;
/
--PROMPT Creating trigger on 'SDL_LOAD_DATA' 
CREATE OR REPLACE TRIGGER sdl_load_data_seq_trg
  BEFORE INSERT ON sdl_load_data
  FOR EACH ROW
BEGIN
  IF :NEW.sld_key IS NULL 
  THEN
    :NEW.sld_key:= sld_key_seq.NEXTVAL;
  END IF;
END sdl_load_data_seq_trg;
/
--PROMPT Creating trigger on 'SDL_ATTRIBUTE_ADJUSTMENT_RULES'
CREATE OR REPLACE TRIGGER sdl_attri_adjustment_r_seq_trg
  BEFORE INSERT ON sdl_attribute_adjustment_rules
  FOR EACH ROW
BEGIN
  IF :NEW.saar_id IS NULL 
  THEN
    :NEW.saar_id := saar_id_seq.NEXTVAL;
  END IF;
END sdl_attri_adjustment_r_seq_trg;
/
--PROMPT Creating trigger on 'SDL_SPATIAL_REVIEW_LEVELS'
CREATE OR REPLACE TRIGGER sdl_spatial_review_lev_seq_trg
  BEFORE INSERT ON sdl_spatial_review_levels
  FOR EACH ROW
BEGIN
  IF :NEW.ssrl_id IS NULL
  THEN
    :NEW.ssrl_id := ssrl_id_seq.NEXTVAL;
  END IF;
END sdl_spatial_review_lev_seq_trg;
/
--PROMPT Creating trigger on 'SDL_GEOM_ACCURACY'
CREATE OR REPLACE TRIGGER sdl_geom_accuracy_seq_trg 
  BEFORE INSERT ON sdl_geom_accuracy
  FOR EACH ROW
BEGIN
  IF :NEW.slga_id IS NULL 
  THEN
    :NEW.slga_id := slga_id_seq.NEXTVAL;
  END IF;
END sdl_geom_accuracy_seq_trg;
/
--PROMPT Creating trigger on 'SDL_WIP_DATUMS'
CREATE OR REPLACE TRIGGER sdl_wip_datums_seq_trg 
  BEFORE INSERT ON sdl_wip_datums
  FOR EACH ROW
BEGIN
  IF :NEW.swd_id IS NULL 
  THEN
    :NEW.swd_id := swd_id_seq.NEXTVAL;
  END IF;
END sdl_wip_datums_seq_trg;
/
--PROMPT Creating trigger on 'SDL_PLINE_STATISTICS' 
CREATE OR REPLACE TRIGGER sdl_pline_statistics_seq_trg 
  BEFORE INSERT ON sdl_pline_statistics
  FOR EACH ROW
BEGIN
  IF :NEW.slps_pline_id IS NULL THEN
    :NEW.slps_pline_id := slps_pline_id_seq.NEXTVAL;
  END IF;
END sdl_pline_statistics_seq_trg;
/
--PROMPT Creating trigger on 'SDL_WIP_NODES'
CREATE OR REPLACE TRIGGER sdl_wip_nodes_trg 
  BEFORE INSERT ON sdl_wip_nodes
  FOR EACH ROW
BEGIN
  IF :NEW.node_id IS NULL 
  THEN      
    :NEW.node_id := sdl_node_id_seq.NEXTVAL;
  END IF;
END sdl_wip_nodes_trg;
/
--PROMPT Creating trigger on 'SDL_VALIDATION_RESULTS'  
CREATE OR REPLACE TRIGGER sdl_validation_results_seq_trg
  BEFORE INSERT ON  sdl_validation_results
  FOR EACH ROW
BEGIN
  IF :NEW.svr_id IS NULL
  THEN
    :NEW.svr_id := svr_id_seq.NEXTVAL;
  END IF;
END sdl_validation_results_seq_trg;
/
--PROMPT Creating trigger on 'SDL_PROCESS_AUDIT' 
CREATE OR REPLACE TRIGGER sdl_process_audit_seq
  BEFORE INSERT ON sdl_process_audit
  FOR EACH ROW
BEGIN
  IF :NEW.spa_id IS NULL 
  THEN
    :NEW.spa_id := spa_id_seq.NEXTVAL;
  END IF;
END sdl_process_audit_seq;
/
--PROMPT Creating trigger on 'SDL_ATTRIBUTE_ADJUSTMENT_AUDIT' 
CREATE OR REPLACE TRIGGER sdl_attri_adjust_audit_seq_trg
  BEFORE INSERT ON  sdl_attribute_adjustment_audit
  FOR EACH ROW
BEGIN
  IF :NEW.saaa_id IS NULL
  THEN
    :NEW.saaa_id := saaa_id_seq.NEXTVAL;
  END IF;
END sdl_attri_adjust_audit_seq_trg;
/