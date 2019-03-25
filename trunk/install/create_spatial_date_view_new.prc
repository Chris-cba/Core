----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/create_spatial_date_view_new.prc-arc   1.0   Mar 25 2019 13:54:08   Chris.Baugh  $
--       Module Name      : $Workfile:   create_spatial_date_view_new.prc  $ 
--       Date into PVCS   : $Date:   Mar 25 2019 13:54:08  $
--       Date fetched Out : $Modtime:   Mar 25 2019 13:52:56  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2017 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
CREATE OR REPLACE PROCEDURE Create_Spatial_Date_View_New (
    p_Table            IN VARCHAR2,
    p_Start_Date_Col   IN VARCHAR2 DEFAULT NULL,
    p_End_Date_Col     IN VARCHAR2 DEFAULT NULL)
IS
    Cur_String         VARCHAR2 (2000);
    l_Start_Date_Col   VARCHAR2 (30) := 'start_date';
    l_End_Date_Col     VARCHAR2 (30) := 'end_date';
BEGIN
    --
    IF p_Start_Date_Col IS NOT NULL
    THEN
        l_Start_Date_Col := p_Start_Date_Col;
    END IF;

    IF p_End_Date_Col IS NOT NULL
    THEN
        l_End_Date_Col := p_End_Date_Col;
    END IF;

    --
    Cur_String :=
           'create or replace force view v_'
        || p_Table
        || ' as select * from '
        || p_Table
        || ' where  '
        || l_Start_Date_Col
        || ' <= to_date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''), ''DD-MON-YYYY'') '
        || ' and  NVL('
        || l_End_Date_Col
        || ',TO_DATE(''99991231'',''YYYYMMDD'')) > to_date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''), ''DD-MON-YYYY'') ';
    --
    -- AE 23-SEP-2008
    -- We will now use views instead of synonyms to provide subordinate user access
    -- to spatial objects
    -- CWS 0108742 Change back to using synonyms
    Nm3Ddl.Create_Object_And_Syns ('V_' || P_Table, Cur_String);
END Create_Spatial_Date_View_New;