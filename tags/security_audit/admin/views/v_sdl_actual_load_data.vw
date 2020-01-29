CREATE OR REPLACE VIEW v_sdl_actual_load_data
(saaa_sfs_id
,saaa_sld_key
,saaa_col_1
,saaa_col_2
,saaa_col_3
,saaa_col_4
,saaa_col_5
,saaa_col_6
,saaa_col_7
,saaa_col_8
,saaa_col_9
,saaa_col_10
,saaa_col_11
,saaa_col_12
,saaa_col_13
,saaa_col_14
,saaa_col_15
,saaa_col_16
,saaa_col_17
,saaa_col_18
,saaa_col_19
,saaa_col_20
,saaa_col_21
,saaa_col_22
,saaa_col_23
,saaa_col_24
,saaa_col_25
,saaa_col_26
,saaa_col_27
,saaa_col_28
,saaa_col_29
,saaa_col_30
,saaa_col_31
,saaa_col_32
,saaa_col_33
,saaa_col_34
,saaa_col_35
,saaa_col_36
,saaa_col_37
,saaa_col_38
,saaa_col_39
,saaa_col_40
)
AS 
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_actual_load_data.vw-arc   1.0   Jan 29 2020 08:51:54   Vikas.Mhetre  $
--       Module Name      : $Workfile:   v_sdl_actual_load_data.vw  $
--       Date into PVCS   : $Date:   Jan 29 2020 08:51:54  $
--       Date fetched Out : $Modtime:   Jan 29 2020 08:47:56  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : Vikas Mhetre
--
--   A view to get actual file data in the load table through the adjustment audit table. It retrives the load 
--   attribute values before execution of attribute validation and execution of the adjustment rules on the attributes.
--
-----------------------------------------------------------------------------
-- Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
-- 
SELECT "SAAA_SFS_ID"
       ,"SAAA_SLD_KEY"
       ,"SAAA_COL_1"
       ,"SAAA_COL_2"
       ,"SAAA_COL_3"
       ,"SAAA_COL_4"
       ,"SAAA_COL_5"
       ,"SAAA_COL_6"
       ,"SAAA_COL_7"
       ,"SAAA_COL_8"
       ,"SAAA_COL_9"
       ,"SAAA_COL_10"
       ,"SAAA_COL_11"
       ,"SAAA_COL_12"
       ,"SAAA_COL_13"
       ,"SAAA_COL_14"
       ,"SAAA_COL_15"
       ,"SAAA_COL_16"
       ,"SAAA_COL_17"
       ,"SAAA_COL_18"
       ,"SAAA_COL_19"
       ,"SAAA_COL_20"
       ,"SAAA_COL_21"
       ,"SAAA_COL_22"
       ,"SAAA_COL_23"
       ,"SAAA_COL_24"
       ,"SAAA_COL_25"
       ,"SAAA_COL_26"
       ,"SAAA_COL_27"
       ,"SAAA_COL_28"
       ,"SAAA_COL_29"
       ,"SAAA_COL_30"
       ,"SAAA_COL_31"
       ,"SAAA_COL_32"
       ,"SAAA_COL_33"
       ,"SAAA_COL_34"
       ,"SAAA_COL_35"
       ,"SAAA_COL_36"
       ,"SAAA_COL_37"
       ,"SAAA_COL_38"
       ,"SAAA_COL_39"
       ,"SAAA_COL_40"
  FROM ( SELECT saaa_sfs_id
               ,saaa_sld_key
               ,load_column_name
               ,saaa_original_value
          FROM (SELECT saaa_id
                      ,saaa_sfs_id
                      ,saaa_sld_key
                      ,saaa_saar_id
                      ,saaa_sam_id
                      ,'SLD_COL_' || saaa_sam_id load_column_name
                      ,saaa_original_value
                      ,saaa_adjusted_value
                  FROM sdl_attribute_adjustment_audit saaa
                 WHERE saaa.saaa_id IN (SELECT MIN(sa.saaa_id)
                                          FROM sdl_attribute_adjustment_audit sa
                                         WHERE sa.saaa_sfs_id = saaa.saaa_sfs_id
                                           AND sa.saaa_saar_id = saaa.saaa_saar_id
                                           AND sa.saaa_sam_id = saaa.saaa_sam_id
                                           AND sa.saaa_sld_key = saaa.saaa_sld_key)
                )
        )
  PIVOT (MIN(saaa_original_value) FOR (load_column_name) IN ('SLD_COL_1' AS SAAA_COL_1
                                                            ,'SLD_COL_2' AS SAAA_COL_2
                                                            ,'SLD_COL_3' AS SAAA_COL_3
                                                            ,'SLD_COL_4' AS SAAA_COL_4
                                                            ,'SLD_COL_5' AS SAAA_COL_5
                                                            ,'SLD_COL_6' AS SAAA_COL_6
                                                            ,'SLD_COL_7' AS SAAA_COL_7
                                                            ,'SLD_COL_8' AS SAAA_COL_8
                                                            ,'SLD_COL_9' AS SAAA_COL_9
                                                            ,'SLD_COL_10' AS SAAA_COL_10
                                                            ,'SLD_COL_11' AS SAAA_COL_11
                                                            ,'SLD_COL_12' AS SAAA_COL_12
                                                            ,'SLD_COL_13' AS SAAA_COL_13
                                                            ,'SLD_COL_14' AS SAAA_COL_14
                                                            ,'SLD_COL_15' AS SAAA_COL_15
                                                            ,'SLD_COL_16' AS SAAA_COL_16
                                                            ,'SLD_COL_17' AS SAAA_COL_17
                                                            ,'SLD_COL_18' AS SAAA_COL_18
                                                            ,'SLD_COL_19' AS SAAA_COL_19
                                                            ,'SLD_COL_20' AS SAAA_COL_20
                                                            ,'SLD_COL_21' AS SAAA_COL_21
                                                            ,'SLD_COL_22' AS SAAA_COL_22
                                                            ,'SLD_COL_23' AS SAAA_COL_23
                                                            ,'SLD_COL_24' AS SAAA_COL_24
                                                            ,'SLD_COL_25' AS SAAA_COL_25
                                                            ,'SLD_COL_26' AS SAAA_COL_26
                                                            ,'SLD_COL_27' AS SAAA_COL_27
                                                            ,'SLD_COL_28' AS SAAA_COL_28
                                                            ,'SLD_COL_29' AS SAAA_COL_29
                                                            ,'SLD_COL_30' AS SAAA_COL_30
                                                            ,'SLD_COL_31' AS SAAA_COL_31
                                                            ,'SLD_COL_32' AS SAAA_COL_32
                                                            ,'SLD_COL_33' AS SAAA_COL_33
                                                            ,'SLD_COL_34' AS SAAA_COL_34
                                                            ,'SLD_COL_35' AS SAAA_COL_35
                                                            ,'SLD_COL_36' AS SAAA_COL_36
                                                            ,'SLD_COL_37' AS SAAA_COL_37
                                                            ,'SLD_COL_38' AS SAAA_COL_38
                                                            ,'SLD_COL_39' AS SAAA_COL_39
                                                            ,'SLD_COL_40' AS SAAA_COL_40)
        )
ORDER BY saaa_sfs_id
        ,saaa_sld_key
/