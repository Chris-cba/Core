CREATE OR REPLACE FORCE VIEW SLEQ_AO_ENERGY_PROCUREMENT_V AS
SELECT
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)sleq_ao_energy_procurement_v.vw	1.1 07/04/05
--       Module Name      : sleq_ao_energy_procurement_v.vw
--       Date into SCCS   : 05/07/04 11:47:28
--       Date fetched Out : 07/06/13 17:07:29
--       SCCS Version     : 1.1
--
--
--   Author : Graeme Johnson
--   View to support Atkins Odlin energy procurement statement
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
                                                          iit_primary_key               v_identifier
                                                         ,v_agents_record_number
                                                         ,v_lamp_equivalent_number
                                                         ,v_item_class_code
                                                         ,v_no_of_lamps
                                                         ,v_no_of_pecus
                                                         ,v_pecu_type
                                                         ,v_pecu_lux_on
                                                         ,v_pecu_lux_off
                                                         ,v_switch_type
                                                         ,v_time_on
                                                         ,v_time_off
                                                         ,v_lamp_type
                                                         ,v_lamp_max_wattage
                                                         ,v_gear_type
                                                         ,v_location
                                                         ,v_road_name
                                                         ,v_parish
                                                         ,v_postal_town_county
                                                         ,v_grid_ref_letters
                                                         ,v_grid_ref_eastings
                                                         ,v_grid_ref_northings
                                                         ,v_grid_supply_point
                                                         ,v_feeder_pillar_id
                                                         ,v_individual_or_group_control
                                                         ,v_operating_percent_per_day
                                                         ,v_is_item_an_exit_point
                                                         ,v_grid_ref_of_exit_point
                                                         ,v_exit_point_capacity_3kva
                                                         ,v_metered_or_unmetered
                                                         ,v_rec_name
                                                         ,v_equipment_commission_date
                                                         ,v_installation_capital_cost
                                                         ,v_column_manufacturer
                                                         ,v_mounting_height
                                                         ,v_column_material
                                                         ,v_protective_coating
                                                         ,v_paint_colour
                                                         ,v_column_fixing
                                                         ,v_column_cross_section
                                                         ,v_number_of_brackets
                                                         ,v_bracket_projection
                                                         ,v_lantern_manufacturer
                                                         ,v_lantern_model_reference
                                                         ,v_lantern_distribution
                                                         ,v_lantern_setting
                                                         ,v_lantern_protection
                                                         ,v_last_lamp_change_date
                                                         ,v_last_electrical_test
                                                         ,v_last_detailed_inspection
                                                         ,v_sign_size
                                                         ,v_sign_diagram_no
                                                         ,v_column_root_protection
                                                         ,v_flange_base
                                                         ,v_column_location
                                                         ,v_road_environment
                                                         ,v_ground_conditions
                                                         ,v_wind_exposure
                                                         ,v_environment_situation
                                                         ,v_designed_for_fatigue
                                                         ,v_attachments
                                                         ,v_external_influences
FROM v_nm_sleq
WHERE iit_end_date IS NULL
/

