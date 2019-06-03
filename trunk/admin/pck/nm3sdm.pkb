CREATE OR REPLACE PACKAGE BODY Nm3Sdm
AS
    --
    -----------------------------------------------------------------------------
    --
    --   PVCS Identifiers :-
    --
    --       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm3sdm.pkb-arc   2.82   Jun 03 2019 07:19:00   Steve.Cooper  $
    --       Module Name      : $Workfile:   nm3sdm.pkb  $
    --       Date into PVCS   : $Date:   Jun 03 2019 07:19:00  $
    --       Date fetched Out : $Modtime:   May 31 2019 13:36:46  $
    --       PVCS Version     : $Revision:   2.82  $
    --
    --   Author : R.A. Coupe
    --
    --   Spatial Data Manager specific package body
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
    -----------------------------------------------------------------------------
    --
    --all global package variables here
    --
    g_Body_Sccsid    CONSTANT VARCHAR2 (2000) := '"$Revision:   2.82  $"';
    --  g_body_sccsid is the SCCS ID for the package body
    --
    g_Package_Name   CONSTANT VARCHAR2 (30) := 'NM3SDM';
    --

    -- nw modules - use 1 for all, 2 for GoG and 3 for GoS

    g_Network_Modules         Ptr_Vc_Array
        := Ptr_Vc_Array (Ptr_Vc_Array_Type (Ptr_Vc (1, 'NM0105')   -- elements
                                                                ,
                                            Ptr_Vc (2, 'NM0115')        -- GOG
                                                                ,
                                            Ptr_Vc (3, 'NM0110')        -- GOS
                                                                ,
                                            Ptr_Vc (1, 'NM1100')  -- Gazetteer
                                                                ));

    -- inv modules - use 1 for all, 2 where not applicable to FT

    g_Asset_Modules           Ptr_Vc_Array
        := Ptr_Vc_Array (Ptr_Vc_Array_Type (Ptr_Vc (2, 'NM0510')     -- assets
                                                                ,
                                            Ptr_Vc (2, 'NM0570') -- find asset
                                                                ,
                                            Ptr_Vc (2, 'NM0572')    -- Locator
                                                                ,
                                            Ptr_Vc (2, 'NM0535')        -- BAU
                                                                ,
                                            Ptr_Vc (2, 'NM0590') -- Asset Maintenance
                                                                ,
                                            Ptr_Vc (2, 'NM0560') -- Assets on a Route -- AE 4053
                                                                ,
                                            Ptr_Vc (2, 'NM0573') -- Asset Grid - AE 4100
                                                                ));
    e_Not_Unrestricted        EXCEPTION;
    e_No_Analyse_Privs        EXCEPTION;

    TYPE t_View_Rec IS RECORD
    (
        View_Name        User_Views.View_Name%TYPE,
        View_Text        VARCHAR2 (4000),
        View_Comments    User_Tab_Comments.Comments%TYPE
    );

    TYPE t_View_Tab IS TABLE OF t_View_Rec
        INDEX BY BINARY_INTEGER;

    -----------------------------------------------------------------------------
    FUNCTION Get_Nat_Feature_Table_Name (
        p_Nt_Type    IN Nm_Types.Nt_Type%TYPE,
        p_Gty_Type   IN Nm_Group_Types.Ngt_Group_Type%TYPE)
        RETURN VARCHAR2;

    PROCEDURE Create_G_of_G_Group_Layer (
        p_Nt_Type    IN Nm_Types.Nt_Type%TYPE,
        p_Gty_Type   IN Nm_Group_Types.Ngt_Group_Type%TYPE,
        p_Job_Id     IN NUMBER DEFAULT NULL);

    --
    FUNCTION Get_Nat_Feature_Table_Name (
        p_Nt_Type    IN Nm_Types.Nt_Type%TYPE,
        p_Gty_Type   IN Nm_Group_Types.Ngt_Group_Type%TYPE)
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN 'NM_NAT_' || p_Nt_Type || '_' || p_Gty_Type || '_SDO';
    END Get_Nat_Feature_Table_Name;

    -----------------------------------------------------------------------------------------------------------------

    FUNCTION Check_Sub_Sde_Exempt (pi_obj_name IN VARCHAR2)
        RETURN BOOLEAN
    IS
        retval    BOOLEAN := FALSE;
        l_dummy   INTEGER;
    BEGIN
        SELECT 1
          INTO l_dummy
          FROM all_objects, nm_sde_sub_layer_exempt
         WHERE     object_name LIKE nssl_object_name
               AND object_type = nssl_object_type
               AND owner = SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
               AND object_name = pi_obj_name
               AND ROWNUM = 1;

        retval := SQL%FOUND;
        RETURN retval;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            RETURN FALSE;
    END;

    -----------------------------------------------------------------------------
    --
    FUNCTION test_theme_for_update (
        p_Theme   IN NM_THEMES_ALL.NTH_THEME_ID%TYPE)
        RETURN BOOLEAN
    IS
        retval     BOOLEAN := FALSE;
        l_normal   INTEGER := 0;
    BEGIN
        IF p_Theme IS NULL
        THEN
            RETURN TRUE;
        END IF;

        --
        SELECT 1
          INTO l_normal
          FROM DUAL
         WHERE EXISTS
                   (SELECT 1
                      FROM (SELECT nth_theme_id
                              FROM nm_themes_all
                             WHERE nth_base_table_theme IN
                                       (SELECT NVL (nth_base_table_theme,
                                                    nth_theme_id)
                                          FROM nm_themes_all
                                         WHERE nth_theme_id = p_Theme)),
                           nm_theme_roles,
                           hig_user_roles
                     WHERE     nthr_theme_id = nth_theme_id
                           AND nthr_role = hur_role
                           AND hur_username =
                               SYS_CONTEXT ('NM3_SECURITY_CTX', 'USERNAME')
                           AND nthr_mode = 'NORMAL');

        --
        IF l_normal = 1
        THEN
            retval := TRUE;
        ELSE
            retval := FALSE;
        END IF;

        RETURN retval;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            RETURN FALSE;
    END;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION User_Is_Unrestricted
        RETURN BOOLEAN
    IS
    BEGIN
        RETURN SYS_CONTEXT ('NM3CORE', 'UNRESTRICTED_INVENTORY') = 'TRUE';
    END User_Is_Unrestricted;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION Get_Asset_Modules
        RETURN Ptr_Vc_Array
    IS
    BEGIN
        RETURN G_Asset_Modules;
    END Get_Asset_Modules;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Create_Theme_Functions (p_Theme     IN NUMBER,
                                      p_Pa        IN Ptr_Vc_Array,
                                      p_Exclude   IN NUMBER)
    IS
        CURSOR C1 (c_Theme IN NUMBER, c_Pa IN Ptr_Vc_Array, c_Excl IN NUMBER)
        IS
            SELECT f.Ptr_Value Module, hm.Hmo_Title
              FROM Hig_Modules hm, TABLE (c_Pa.Pa) f
             WHERE     f.Ptr_Value = hm.Hmo_Module
                   AND NVL (C_Excl, -999) !=
                       DECODE (c_Excl, NULL, 0, f.Ptr_Id);
    BEGIN
        --  failure of 9i to perform insert in an efficient way using ptrs - needs simple loop

        FOR Ntf IN C1 (p_Theme, p_Pa, p_Exclude)
        LOOP
            INSERT INTO Nm_Theme_Functions_All (Ntf_Nth_Theme_Id,
                                                Ntf_Hmo_Module,
                                                Ntf_Parameter,
                                                Ntf_Menu_Option,
                                                Ntf_Seen_In_Gis)
                 VALUES (p_Theme,
                         Ntf.Module,
                         'GIS_SESSION_ID',
                         Ntf.Hmo_Title,
                         DECODE (Ntf.Module, 'NM0572', 'N', 'Y'));
        END LOOP;
    END Create_Theme_Functions;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION Get_Version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN G_Sccsid;
    END Get_Version;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION Get_Body_Version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN G_Body_Sccsid;
    END Get_Body_Version;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION Get_Base_Themes (p_Theme_Id IN Nm_Themes_All.Nth_Theme_Id%TYPE)
        RETURN Nm_Theme_Array
    IS
        Retval   Nm_Theme_Array := Nm3Array.Init_Nm_Theme_Array;
    BEGIN
        SELECT Nm_Theme_Entry (nbt.Nbth_Base_Theme)
          BULK COLLECT INTO Retval.Nta_Theme_Array
          FROM Nm_Base_Themes nbt
         WHERE nbt.Nbth_Theme_Id = p_Theme_Id;

        RETURN Retval;
    END Get_Base_Themes;

    --
    -------------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Process_View_DDL (p_View_Rec IN t_View_Rec)
    IS
    BEGIN
        Nm_Debug.Debug ('Nm3Sdm.Process_View_DDL - Called');

        Nm_Debug.Debug ('Processing :' || p_View_Rec.View_Name);
        Nm_Debug.Debug (SUBSTR ('DDL:' || p_View_Rec.View_Text, 1, 4000));

        BEGIN
            Nm3Ddl.Create_Object_And_Syns (p_View_Rec.View_Name,
                                           p_View_Rec.View_Text);

            Nm_Debug.Debug ('View Comments:' || p_View_Rec.View_Comments);

            EXECUTE IMMEDIATE (p_View_Rec.View_Comments);
        EXCEPTION
            WHEN OTHERS
            THEN
                Nm_Debug.Debug (
                    'EXCEPTION - When Others:' || SQLCODE || ':' || SQLERRM);
                Raise_Application_Error (
                    -20001,
                       'Unable to create view '
                    || p_View_Rec.View_Name
                    || ':'
                    || CHR (10)
                    || p_View_Rec.View_Text
                    || CHR (10)
                    || SQLCODE
                    || ':'
                    || SQLERRM);
        END;

        Nm_Debug.Debug ('Nm3Sdm.Process_View_DDL - Finished');
    END Process_View_DDL;

    --
    ------------------------------------------------------------------------------
    --
    FUNCTION Build_Nat_Sdo_Join_View
        RETURN User_Views.View_Name%TYPE
    IS
        l_View_Tab            t_View_Tab;
        View_Creation_Error   EXCEPTION;
        PRAGMA EXCEPTION_INIT (View_Creation_Error, -20001);
    BEGIN
        Nm_Debug.Debug ('Nm3Sdm.Build_Nat_Sdo_Join_View - Called');

        SELECT View_Name, View_Text, View_Comments
          BULK COLLECT INTO l_View_Tab
          FROM V_Nm_Rebuild_All_Nat_Sdo_Join;

        FOR x IN 1 .. l_View_Tab.COUNT
        LOOP
            BEGIN
                Process_View_DDL (p_View_Rec => l_View_Tab (x));
            EXCEPTION
                WHEN View_Creation_Error
                THEN
                    NULL;
            END;
        END LOOP;

        Nm_Debug.Debug ('Nm3Sdm.Build_Nat_Sdo_Join_View - Finished');

        --Only return a view name if we only processed one view.
        RETURN ((CASE
                     WHEN l_View_Tab.COUNT = 1 THEN l_View_Tab (1).View_Name
                     ELSE NULL
                 END));
    END Build_Nat_Sdo_Join_View;

    --
    ------------------------------------------------------------------------------
    --
    FUNCTION Create_Nat_Sdo_Join_View (p_Feature_Table_Name IN VARCHAR2)
        RETURN User_Views.View_Name%TYPE
    IS
        l_View_Name   User_Views.View_Name%TYPE;
    BEGIN
        Nm_Debug.Debug ('Nm3Sdm.Create_Nat_Sdo_Join_View - Called');
        Nm_Debug.Debug (
            'Parameter - p_Feature_Table_Name:' || p_Feature_Table_Name);

        Nm3Ctx.Set_Context ('THEME_API_FEATURE_TAB', p_Feature_Table_Name);

        l_View_Name := Build_Nat_Sdo_Join_View;

        Nm3Ctx.Set_Context ('THEME_API_FEATURE_TAB', NULL);

        Nm_Debug.Debug (
            'Nm3Sdm.Create_Nat_Sdo_Join_View - Finished - Returning:');

        RETURN l_View_Name;
    END Create_Nat_Sdo_Join_View;

    --
    ------------------------------------------------------------------------------
    --
    PROCEDURE Rebuild_All_NAT_Sdo_Join_View
    IS
        l_View_Name   User_Views.View_Name%TYPE;
    BEGIN
        Nm_Debug.Debug ('nm3sdm.Rebuild_All_NAT_Sdo_Join_View - Called');

        --This limits the rows returned by the V_Nm_Rebuild_All_Nat_Sdo_Join view, which is used by Build_Nat_Sdo_Join_View.
        Nm3Ctx.Set_Context ('THEME_API_FEATURE_TAB', 'NM_%_SDO');

        l_View_Name := Build_Nat_Sdo_Join_View;

        Nm3Ctx.Set_Context ('THEME_API_FEATURE_TAB', NULL);

        Nm_Debug.Debug ('nm3sdm.Rebuild_All_NAT_Sdo_Join_View - Finished');
    END Rebuild_All_NAT_Sdo_Join_View;

    --
    -------------------------------------------------------------------------------------------------------------------------------------
    --
    FUNCTION Build_Nlt_Sdo_Join_View
        RETURN User_Views.View_Name%TYPE
    IS
        l_View_Tab            t_View_Tab;
        View_Creation_Error   EXCEPTION;
        PRAGMA EXCEPTION_INIT (View_Creation_Error, -20001);
    BEGIN
        Nm_Debug.Debug ('Nm3Sdm.Build_Nlt_Sdo_Join_View - Called');

        SELECT View_Name, View_Text, View_Comments
          BULK COLLECT INTO l_View_Tab
          FROM V_Nm_Rebuild_All_Nlt_Sdo_Join;

        FOR x IN 1 .. l_View_Tab.COUNT
        LOOP
            BEGIN
                Process_View_DDL (p_View_Rec => l_View_Tab (x));
            EXCEPTION
                WHEN View_Creation_Error
                THEN
                    NULL;
            END;
        END LOOP;

        Nm_Debug.Debug ('Nm3Sdm.Build_Nlt_Sdo_Join_View - Finished');

        --Only return a view name if we only processed one view.
        RETURN ((CASE
                     WHEN l_View_Tab.COUNT = 1 THEN l_View_Tab (1).View_Name
                     ELSE NULL
                 END));
    END Build_Nlt_Sdo_Join_View;

    --
    -------------------------------------------------------------------------------------------------------------------------------------
    --
    FUNCTION Create_Nlt_Sdo_Join_View (p_Feature_Table_Name IN VARCHAR2)
        RETURN User_Views.View_Name%TYPE
    IS
        l_View_Name   User_Views.View_Name%TYPE;
    BEGIN
        Nm_Debug.Debug ('Nm3Sdm.Create_Nlt_Sdo_Join_View - Called');
        Nm_Debug.Debug (
            'Parameter - p_Feature_Table_Name:' || p_Feature_Table_Name);

        Nm3Ctx.Set_Context ('THEME_API_FEATURE_TAB', p_Feature_Table_Name);

        l_View_Name := Build_Nlt_Sdo_Join_View;

        Nm3Ctx.Set_Context ('THEME_API_FEATURE_TAB', NULL);

        Nm_Debug.Debug (
            'Nm3Sdm.Create_Nlt_Sdo_Join_View - Finished - Returning:');

        RETURN l_View_Name;
    END Create_Nlt_Sdo_Join_View;

    --
    ------------------------------------------------------------------------------
    --
    PROCEDURE Rebuild_All_NLT_Sdo_Join_Views
    IS
        l_View_Name   User_Views.View_Name%TYPE;
    BEGIN
        Nm_Debug.Debug ('nm3sdm.Rebuild_All_NLT_Sdo_Join_Views - Called');

        --This limits the rows returned by the V_Nm_Rebuild_All_Nlt_Sdo_Join view, which is used by Build_nlt_Sdo_Join_View.
        Nm3Ctx.Set_Context ('THEME_API_FEATURE_TAB', 'NM_%_SDO');

        l_View_Name := Build_Nlt_Sdo_Join_View;

        Nm3Ctx.Set_Context ('THEME_API_FEATURE_TAB', NULL);

        Nm_Debug.Debug ('nm3sdm.Rebuild_All_NLT_Sdo_Join_Views - Finished');
    END Rebuild_All_NLT_Sdo_Join_Views;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION Get_Theme_Nt (p_Theme_Id IN Nm_Themes_All.Nth_Theme_Id%TYPE)
        RETURN Nm_Linear_Types.Nlt_Nt_Type%TYPE
    IS
        Retval   Nm_Linear_Types.Nlt_Nt_Type%TYPE;
    BEGIN
        BEGIN
            SELECT nlt.Nlt_Nt_Type
              INTO Retval
              FROM Nm_Themes_All nta, Nm_Nw_Themes nnt, Nm_Linear_Types nlt
             WHERE     nlt.Nlt_Id = Nnth_Nlt_Id
                   AND nnt.Nnth_Nth_Theme_Id = nta.Nth_Theme_Id
                   AND nta.Nth_Theme_Id = p_Theme_Id
                   AND nta.Nth_Theme_Type = 'SDO'
                   AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                Hig.Raise_Ner (pi_Appl      => Nm3Type.C_Hig,
                               pi_Id        => 192,
                               pi_Sqlcode   => -20001);
        END;

        RETURN Retval;
    END Get_Theme_Nt;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION Get_Node_Table (p_Node_Type IN Nm_Node_Types.Nnt_Type%TYPE)
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN 'V_NM_NO_' || p_Node_Type || '_SDO';
    END Get_Node_Table;

    --
    ---------------------------------------------------------------------------------------------------
    --
    PROCEDURE Register_Npl_Theme
    IS
        l_Rec_Nth   Nm_Themes_All%ROWTYPE;
        l_Rec_Ntg   Nm_Theme_Gtypes%ROWTYPE;
    BEGIN
        l_Rec_Nth.Nth_Theme_Id := Nm3Seq.Next_Nth_Theme_Id_Seq;
        l_Rec_Nth.Nth_Theme_Name := 'POINT_LOCATIONS';
        l_Rec_Nth.Nth_Table_Name := 'NM_POINT_LOCATIONS';
        l_Rec_Nth.Nth_Pk_Column := 'NPL_ID';
        l_Rec_Nth.Nth_Label_Column := 'NPL_ID';
        l_Rec_Nth.Nth_Feature_Table := 'NM_POINT_LOCATIONS';
        l_Rec_Nth.Nth_Feature_Shape_Column := 'NPL_LOCATION';
        l_Rec_Nth.Nth_Feature_Pk_Column := 'NPL_ID';
        l_Rec_Nth.Nth_Use_History := 'N';
        l_Rec_Nth.Nth_Hpr_Product := 'NET';
        l_Rec_Nth.Nth_Theme_Type := 'SDO';
        l_Rec_Nth.Nth_Location_Updatable := 'N';
        l_Rec_Nth.Nth_Dependency := 'I';
        l_Rec_Nth.Nth_Storage := 'S';
        l_Rec_Nth.Nth_Update_On_Edit := 'N';
        l_Rec_Nth.Nth_Use_History := 'N';
        l_Rec_Nth.Nth_Snap_To_Theme := 'N';
        l_Rec_Nth.Nth_Lref_Mandatory := 'N';
        l_Rec_Nth.Nth_Tolerance := 10;
        l_Rec_Nth.Nth_Tol_Units := 1;
        l_Rec_Nth.Nth_Dynamic_Theme := 'N';

        Nm3Ins.Ins_Nth (l_Rec_Nth);
        --
        l_Rec_Ntg.Ntg_Theme_Id := l_Rec_Nth.Nth_Theme_Id;
        l_Rec_Ntg.Ntg_Seq_No := 1;
        l_Rec_Ntg.Ntg_Xml_Url := NULL;
        l_Rec_Ntg.Ntg_Gtype := '2001';

        Nm3Ins.Ins_Ntg (p_Rec_Ntg => l_Rec_Ntg);

        --
        IF Hig.Get_Sysopt ('REGSDELAY') = 'Y'
        THEN
            EXECUTE IMMEDIATE(   ' begin  '
                              || '    nm3sde.register_sde_layer( p_theme_id => '
                              || TO_CHAR (l_Rec_Nth.Nth_Theme_Id)
                              || ')'
                              || '; end;');
        END IF;
    END Register_Npl_Theme;

    --
    ----------------------------------------------------------------------------------------
    --
    -- The registration of a node theme depends on the existence of the nm_point_locations registry entry
    -- If it is not present, then register this first.
    -- RAC December 2005
    FUNCTION Register_Node_Theme (p_Node_Type     IN VARCHAR2,
                                  p_Table_Name    IN VARCHAR2,
                                  p_Column_Name   IN VARCHAR2)
        RETURN NUMBER
    IS
        Retval      NUMBER;
        l_Nth       Nm_Themes_All%ROWTYPE;
        l_Rec_Ntg   Nm_Theme_Gtypes%ROWTYPE;
    BEGIN
        Retval := Higgis.Next_Theme_Id;

        l_Nth.Nth_Base_Table_Theme :=
            Get_Theme_From_Feature_Table ('NM_POINT_LOCATIONS',
                                          'NM_POINT_LOCATIONS');

        IF l_Nth.Nth_Base_Table_Theme IS NULL
        THEN
            --
            Register_Npl_Theme;
        END IF;

        l_Nth.Nth_Theme_Id := Retval;
        l_Nth.Nth_Theme_Name := 'NODE_' || p_Node_Type;
        l_Nth.Nth_Table_Name := p_Table_Name;
        l_Nth.Nth_Where := NULL;
        l_Nth.Nth_Pk_Column := 'NO_NODE_ID';
        l_Nth.Nth_Label_Column := 'NO_NODE_NAME';
        l_Nth.Nth_Rse_Table_Name := 'NM_ELEMENTS';
        l_Nth.Nth_Rse_Fk_Column := NULL;
        l_Nth.Nth_St_Chain_Column := NULL;
        l_Nth.Nth_End_Chain_Column := NULL;
        l_Nth.Nth_Offset_Field := NULL;
        l_Nth.Nth_Feature_Table := 'V_NM_NO_' || p_Node_Type || '_SDO';
        l_Nth.Nth_Feature_Pk_Column := 'NPL_ID';
        l_Nth.Nth_Feature_Fk_Column := NULL;
        l_Nth.Nth_Xsp_Column := NULL;
        l_Nth.Nth_Feature_Shape_Column := 'GEOLOC';
        l_Nth.Nth_Hpr_Product := 'NET';
        l_Nth.Nth_Location_Updatable := 'N';
        l_Nth.Nth_Theme_Type := 'SDO';
        l_Nth.Nth_Dependency := 'I';
        l_Nth.Nth_Storage := 'S';
        l_Nth.Nth_Update_On_Edit := 'N';
        l_Nth.Nth_Use_History := 'N';
        l_Nth.Nth_Lref_Mandatory := 'N';
        l_Nth.Nth_Tolerance := 10;
        l_Nth.Nth_Tol_Units := 1;

        Nm3Ins.Ins_Nth (L_Nth);
        --
        --  Build theme gtype rowtype
        l_Rec_Ntg.Ntg_Theme_Id := L_Nth.Nth_Theme_Id;
        l_Rec_Ntg.Ntg_Seq_No := 1;
        l_Rec_Ntg.Ntg_Xml_Url := NULL;
        l_Rec_Ntg.Ntg_Gtype := '2001';

        Nm3Ins.Ins_Ntg (p_Rec_Ntg => l_Rec_Ntg);

        COMMIT;

        IF Hig.Get_Sysopt ('REGSDELAY') = 'Y'
        THEN
            EXECUTE IMMEDIATE(   ' begin  '
                              || '    nm3sde.register_sde_layer( p_theme_id => '
                              || TO_CHAR (L_Nth.Nth_Theme_Id)
                              || ')'
                              || '; end;');
        --  place exception into dynamic sql ananymous block. This is dynamic sql to avoid compilation probs
        END IF;

        RETURN Retval;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            Hig.Raise_Ner (pi_Appl      => Nm3Type.C_Hig,
                           pi_Id        => 193,
                           pi_Sqlcode   => -20003);
    END Register_Node_Theme;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION Create_Node_Metadata (
        p_Node_Type   IN Nm_Node_Types.Nnt_Type%TYPE)
        RETURN NUMBER
    IS
        Cur_String    VARCHAR2 (4000);
        l_Node_View   VARCHAR2 (30);
        Retval        NUMBER;
    BEGIN
        -- AE check to make sure user is unrestricted
        IF NOT User_Is_Unrestricted
        THEN
            RAISE E_Not_Unrestricted;
        END IF;

        --create node view based on points - this assumes that the points are either
        --held as a geo-enabled column this work on 8i by cloning the point-locations table
        --
        l_Node_View := Get_Node_Table (p_Node_Type);
        Cur_String :=
               'create or replace view '
            || l_Node_View
            || ' as select /*+INDEX( NM_NODES_ALL,NN_NP_FK_IND)*/ p.npl_id, n.*, p.npl_location geoloc '
            || 'from nm_nodes n, nm_point_locations p '
            || 'where n.NO_NP_ID = p.NPL_ID '
            || 'and   n.no_node_type = '
            || ''''
            || p_Node_Type
            || '''';

        Nm3Ddl.Create_Object_And_Syns (l_Node_View, Cur_String);

        INSERT INTO Mdsys.Sdo_Geom_Metadata_Table (Sdo_Table_Name,
                                                   Sdo_Column_Name,
                                                   Sdo_Diminfo,
                                                   Sdo_Srid,
                                                   Sdo_Owner)
            SELECT l_Node_View,
                   'GEOLOC',
                   Sdo_Diminfo,
                   Sdo_Srid,
                   SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
              FROM Mdsys.Sdo_Geom_Metadata_Table
             WHERE     Sdo_Table_Name = 'NM_POINT_LOCATIONS'
                   AND Sdo_Column_Name = 'NPL_LOCATION'
                   AND Sdo_Owner =
                       SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER');

        Retval := Register_Node_Theme (p_Node_Type, l_Node_View, 'GEOLOC');

        RETURN Retval;
    END Create_Node_Metadata;

    --
    -------------------------------------------------------------------------------------------------------------------------------------
    --
    FUNCTION Get_Nlt_Spatial_Table (p_Nlt IN Nm_Linear_Types%ROWTYPE)
        RETURN VARCHAR2
    IS
        Retval   VARCHAR2 (30);
    BEGIN
        Retval := 'NM_NLT_' || p_Nlt.Nlt_Nt_Type;

        IF p_Nlt.Nlt_Gty_Type IS NOT NULL
        THEN
            Retval := Retval || '_' || p_Nlt.Nlt_Gty_Type;
        END IF;

        Retval := Retval || '_SDO';

        RETURN Retval;
    END Get_Nlt_Spatial_Table;

    --
    ---------------------------------------------------------------------------------------------------
    --
    FUNCTION Get_Nlt_Base_Themes (p_Nlt_Id IN Nm_Linear_Types.Nlt_Id%TYPE)
        RETURN Nm_Theme_Array
    IS
        Retval   Nm_Theme_Array := Nm3Array.Init_Nm_Theme_Array;
    BEGIN
        SELECT Nm_Theme_Entry (Nnth_Nth_Theme_Id)
          BULK COLLECT INTO Retval.Nta_Theme_Array
          FROM Nm_Nw_Themes     nnt,
               Nm_Linear_Types  nlt1,
               Nm_Nt_Groupings  nng,
               Nm_Linear_Types  nlt2,
               Nm_Themes_All    nta
         WHERE     nlt2.Nlt_Id = p_Nlt_Id
               AND nlt1.Nlt_Id = nnt.Nnth_Nlt_Id
               AND nng.Nng_Group_Type = nlt2.Nlt_Gty_Type
               AND nng.Nng_Nt_Type = nlt1.Nlt_Nt_Type
               AND nta.Nth_Theme_Id = nnt.Nnth_Nth_Theme_Id
               AND nta.Nth_Base_Table_Theme IS NULL
               AND nlt1.Nlt_G_I_D = 'D';

        IF Retval.Nta_Theme_Array.LAST IS NULL
        THEN
            Hig.Raise_Ner (pi_Appl                 => Nm3Type.C_Hig,
                           pi_Id                   => 267,
                           pi_Sqlcode              => -20003,
                           pi_Supplementary_Info   => TO_CHAR (P_Nlt_Id));
        END IF;

        RETURN Retval;
    END Get_Nlt_Base_Themes;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Create_Spatial_Table (
        p_Table               IN VARCHAR2,
        p_Mp_Flag             IN BOOLEAN DEFAULT FALSE,
        p_Start_Date_Column   IN VARCHAR2 DEFAULT NULL,
        p_End_Date_Column     IN VARCHAR2 DEFAULT NULL)
    IS
        Cur_String               VARCHAR2 (2000);
        Con_String               VARCHAR2 (2000);
        Uk_String                VARCHAR2 (2000);
        b_Use_History   CONSTANT BOOLEAN
            :=     p_Start_Date_Column IS NOT NULL
               AND p_End_Date_Column IS NOT NULL ;
    BEGIN
        --

        IF p_Mp_Flag
        THEN
            IF Nm3Sdo.Use_Surrogate_Key = 'N'
            THEN
                IF b_Use_History
                THEN
                    Cur_String :=
                           'create table '
                        || p_Table
                        || ' ( ne_id number(38) not null, '
                        || '   geoloc mdsys.sdo_geometry not null,'
                        || '   '
                        || p_Start_Date_Column
                        || ' date, '
                        || p_End_Date_Column
                        || ' date, '
                        || 'date_created date, date_modified date,'
                        || '   modified_by varchar2(30), created_by varchar2(30) )';
                    Con_String :=
                           'alter table '
                        || p_Table
                        || ' ADD CONSTRAINT '
                        || p_Table
                        || '_PK PRIMARY KEY '
                        || ' ( ne_id, '
                        || p_Start_Date_Column
                        || ' start_date )';
                ELSE
                    Cur_String :=
                           'create table '
                        || p_Table
                        || ' ( ne_id number(38) not null, '
                        || '   geoloc mdsys.sdo_geometry not null,'
                        || '   date_created date, date_modified date,'
                        || '   modified_by varchar2(30), created_by varchar2(30) )';
                    Con_String :=
                           'alter table '
                        || p_Table
                        || ' ADD CONSTRAINT '
                        || p_Table
                        || '_PK PRIMARY KEY '
                        || ' ( ne_id )';
                END IF;

                EXECUTE IMMEDIATE Cur_String;

                EXECUTE IMMEDIATE Con_String;
            ELSE                                          -- surrogate key = Y
                IF b_Use_History
                THEN
                    Cur_String :=
                           'create table '
                        || p_Table
                        || ' ( objectid number(38) not null, '
                        || '   ne_id number(38) not null, '
                        || '   geoloc mdsys.sdo_geometry not null,'
                        || '   '
                        || p_Start_Date_Column
                        || ' date, '
                        || '   '
                        || p_End_Date_Column
                        || ' date, date_created date, date_modified date,'
                        || '   modified_by varchar2(30), created_by varchar2(30) )';
                    Con_String :=
                           'alter table '
                        || p_Table
                        || ' ADD CONSTRAINT '
                        || p_Table
                        || '_PK PRIMARY KEY '
                        || ' ( ne_id, '
                        || p_Start_Date_Column
                        || ' )';
                ELSE                                             -- no history
                    Cur_String :=
                           'create table '
                        || p_Table
                        || ' ( objectid number(38) not null, '
                        || '   ne_id number(38) not null, '
                        || '   geoloc mdsys.sdo_geometry not null,'
                        || '   date_created date, date_modified date,'
                        || '   modified_by varchar2(30), created_by varchar2(30) )';
                    Con_String :=
                           'alter table '
                        || p_Table
                        || ' ADD CONSTRAINT '
                        || p_Table
                        || '_PK PRIMARY KEY '
                        || ' ( ne_id )';
                END IF;                                             -- history

                Uk_String :=
                       'alter table '
                    || p_Table
                    || ' ADD ( CONSTRAINT '
                    || p_Table
                    || '_UK UNIQUE '
                    || ' (objectid))';

                EXECUTE IMMEDIATE Cur_String;

                EXECUTE IMMEDIATE Con_String;

                EXECUTE IMMEDIATE Uk_String;
            END IF;
        ELSE                                 --single part - assumed multi-row
            IF Nm3Sdo.Use_Surrogate_Key = 'N'
            THEN
                IF B_Use_History
                THEN
                    Cur_String :=
                           'create table '
                        || p_Table
                        || ' ( ne_id number(38) not null, '
                        || '   ne_id_of number(9) not null, '
                        || '   nm_begin_mp number not null, '
                        || '   nm_end_mp number not null, '
                        || '   geoloc mdsys.sdo_geometry not null,'
                        || '   '
                        || p_Start_Date_Column
                        || ' date, '
                        || p_End_Date_Column
                        || ' date, date_created date, date_modified date,'
                        || '   modified_by varchar2(30), created_by varchar2(30) )';
                ELSE                                             -- no history
                    Cur_String :=
                           'create table '
                        || p_Table
                        || ' ( ne_id number(38) not null, '
                        || '   ne_id_of number(9) not null, '
                        || '   nm_begin_mp number not null, '
                        || '   nm_end_mp number not null, '
                        || '   geoloc mdsys.sdo_geometry not null,'
                        || '   date_created date, date_modified date,'
                        || '   modified_by varchar2(30), created_by varchar2(30) )';
                END IF;                                              --history

                EXECUTE IMMEDIATE Cur_String;
            ELSE                                          -- surrogate key = Y
                IF b_Use_History
                THEN
                    Cur_String :=
                           'create table '
                        || p_Table
                        || ' ( objectid number(38) not null, '
                        || '   ne_id number(38) not null, '
                        || '   ne_id_of number(9) not null, '
                        || '   nm_begin_mp number not null, '
                        || '   nm_end_mp number not null, '
                        || '   geoloc mdsys.sdo_geometry not null,'
                        || '   '
                        || p_Start_Date_Column
                        || ' date, '
                        || p_End_Date_Column
                        || ' date, date_created date, date_modified date,'
                        || '   modified_by varchar2(30), created_by varchar2(30) )';
                ELSE                                              --no history
                    Cur_String :=
                           'create table '
                        || p_Table
                        || ' ( objectid number(38) not null, '
                        || '   ne_id number(38) not null, '
                        || '   ne_id_of number(9) not null, '
                        || '   nm_begin_mp number not null, '
                        || '   nm_end_mp number not null, '
                        || '   geoloc mdsys.sdo_geometry not null,'
                        || '   date_created date, date_modified date,'
                        || '   modified_by varchar2(30), created_by varchar2(30) )';
                END IF;                                              --history

                EXECUTE IMMEDIATE Cur_String;
            END IF;                                           -- surrogate key

            IF b_Use_History
            THEN
                Cur_String :=
                       'alter table '
                    || p_Table
                    || ' ADD CONSTRAINT '
                    || p_Table
                    || '_PK PRIMARY KEY '
                    || ' ( ne_id, ne_id_of, nm_begin_mp, '
                    || p_Start_Date_Column
                    || ' )';
            ELSE
                Cur_String :=
                       'alter table '
                    || p_Table
                    || ' ADD CONSTRAINT '
                    || p_Table
                    || '_PK PRIMARY KEY '
                    || ' ( ne_id, ne_id_of, nm_begin_mp )';
            END IF;

            EXECUTE IMMEDIATE Cur_String;

            IF Nm3Sdo.Use_Surrogate_Key = 'Y'
            THEN
                Cur_String :=
                       'alter table '
                    || p_Table
                    || ' ADD ( CONSTRAINT '
                    || p_Table
                    || '_UK UNIQUE '
                    || ' ( objectid ))';

                EXECUTE IMMEDIATE Cur_String;
            END IF;                                           -- surrogate key

            Cur_String :=
                   'create index '
                || p_Table
                || '_NW_IDX'
                || ' on '
                || p_Table
                || ' ( ne_id_of, nm_begin_mp )';

            EXECUTE IMMEDIATE Cur_String;
        END IF;                                    --single-part or multi-part

        nm3ddl.create_synonym_for_object (p_object_name => p_Table);
    END Create_Spatial_Table;

    --
    -------------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Create_Spatial_Date_View (
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
    END Create_Spatial_Date_View;

    --
    -------------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Create_Nlt_Spatial_Idx (p_Nlt     IN Nm_Linear_Types%ROWTYPE,
                                      p_Table   IN VARCHAR2)
    IS
        --bug in oracle 8 - spatial index name can only be 18 chars
        --best kept to a quadtree in Oracle 8, Rtree in 9i
        Cur_String   VARCHAR2 (2000);
    BEGIN
        Cur_String :=
               'create index NLT_'
            || p_Nlt.Nlt_Nt_Type
            || '_'
            || p_Nlt.Nlt_Gty_Type
            || '_spidx on '
            || p_Table
            || ' ( geoloc ) indextype is mdsys.spatial_index';

        EXECUTE IMMEDIATE Cur_String;
    END Create_Nlt_Spatial_Idx;

    --
    -----------------------------------------------------------------------------
    --
    --temp function until the DB design is finished and the gets can be
    --generated

    FUNCTION Get_Nlt (pi_Nlt_Id IN Nm_Linear_Types.Nlt_Id%TYPE)
        RETURN Nm_Linear_Types%ROWTYPE
    IS
        Retval   Nm_Linear_Types%ROWTYPE;
    BEGIN
        BEGIN
            SELECT *
              INTO Retval
              FROM Nm_Linear_Types nlt
             WHERE nlt.Nlt_Id = pi_Nlt_Id;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        RETURN Retval;
    END Get_Nlt;

    --
    ---------------------------------------------------------------------------------------------------
    --
    PROCEDURE Create_Base_Themes (p_Theme_Id   IN NUMBER,
                                  p_Base       IN Nm_Theme_Array)
    IS
    BEGIN
        IF P_Base.Nta_Theme_Array (1).Nthe_Id IS NULL
        THEN
            NULL;
        ELSE
            FOR i IN 1 .. p_Base.Nta_Theme_Array.LAST
            LOOP
                INSERT INTO Nm_Base_Themes (Nbth_Theme_Id, Nbth_Base_Theme)
                     VALUES (p_Theme_Id, p_Base.Nta_Theme_Array (i).Nthe_Id);
            END LOOP;
        END IF;
    END Create_Base_Themes;

    --
    ---------------------------------------------------------------------------------------------------
    --
    FUNCTION Register_Lrm_Theme (
        p_Nlt_Id           IN NUMBER,
        p_Base             IN Nm_Theme_Array,
        p_Table_Name       IN VARCHAR2,
        p_Column_Name      IN VARCHAR2,
        p_Name             IN VARCHAR2 DEFAULT NULL,
        p_View_Flag        IN VARCHAR2 DEFAULT 'N',
        p_Base_Table_Nth   IN Nm_Themes_All.Nth_Theme_Id%TYPE DEFAULT NULL)
        RETURN NUMBER
    IS
        Retval        NUMBER;
        l_D_Or_S      VARCHAR2 (1);
        l_View_Name   VARCHAR2 (30);
        l_Pk_Col      VARCHAR2 (30) := 'NE_ID';
        l_Nth         Nm_Themes_All%ROWTYPE;
        l_Nlt         Nm_Linear_Types%ROWTYPE;
        l_Name        Nm_Themes_All.Nth_Theme_Name%TYPE := UPPER (p_Name);
        l_Rec_Nnth    Nm_Nw_Themes%ROWTYPE;
        l_Rec_Ntg     Nm_Theme_Gtypes%ROWTYPE;
        l_Mp_Gtype    NUMBER
            := TO_NUMBER (NVL (Hig.Get_Sysopt ('SDOMPGTYPE'), '3302'));
    BEGIN
        l_Nlt := Get_Nlt (p_Nlt_Id);
        g_Units := Nm3Net.Get_Nt_Units (l_Nlt.Nlt_Nt_Type);

        IF g_Units = 1
        THEN
            g_Unit_Conv := 1;
        ELSE
            g_Unit_Conv := Nm3Get.Get_Uc (g_Units, 1).Uc_Conversion_Factor;
        END IF;

        IF l_Name IS NULL
        THEN
            l_Name := UPPER (SUBSTR (l_Nlt.Nlt_Descr, 1, 30));
        END IF;

        IF Nm3Sdo.Use_Surrogate_Key = 'Y'
        THEN
            l_Pk_Col := 'OBJECTID';
            --  to make sm work we need to use NE_ID
            l_Pk_Col := 'NE_ID';
        END IF;

        Retval := Higgis.Next_Theme_Id;
        l_Nth.Nth_Theme_Id := Retval;
        l_Nth.Nth_Theme_Name := l_Name;
        l_Nth.Nth_Table_Name := p_Table_Name;
        l_Nth.Nth_Where := NULL;
        l_Nth.Nth_Pk_Column := 'NE_ID';

        --
        -- Task ID 0107889 - Set Label Column to NE_ID for Group layer base table themes
        -- 05/10/09 AE Further restrict on the non DT theme
        --
        IF p_Base_Table_Nth IS NULL OR l_Nth.Nth_Theme_Name NOT LIKE '%DT'
        THEN
            l_Nth.Nth_Label_Column := 'NE_ID';
        ELSE
            l_Nth.Nth_Label_Column := 'NE_UNIQUE';
        END IF;

        --
        l_Nth.Nth_Rse_Table_Name := 'NM_ELEMENTS';
        l_Nth.Nth_Rse_Fk_Column := 'NE_ID';
        l_Nth.Nth_St_Chain_Column := NULL;
        l_Nth.Nth_End_Chain_Column := NULL;
        l_Nth.Nth_X_Column := NULL;
        l_Nth.Nth_Y_Column := NULL;
        l_Nth.Nth_Offset_Field := NULL;
        l_Nth.Nth_Feature_Table := p_Table_Name;
        l_Nth.Nth_Feature_Pk_Column := l_Pk_Col;
        l_Nth.Nth_Feature_Fk_Column := 'NE_ID';
        l_Nth.Nth_Xsp_Column := NULL;
        l_Nth.Nth_Feature_Shape_Column := 'GEOLOC';
        l_Nth.Nth_Hpr_Product := 'NET';
        l_Nth.Nth_Location_Updatable := 'N';
        l_Nth.Nth_Theme_Type := 'SDO';
        l_Nth.Nth_Dependency := 'D';
        l_Nth.Nth_Storage := 'S';
        l_Nth.Nth_Update_On_Edit := 'D';
        l_Nth.Nth_Use_History := 'Y';
        l_Nth.Nth_Start_Date_Column := 'START_DATE';
        l_Nth.Nth_End_Date_Column := 'END_DATE';
        l_Nth.Nth_Base_Table_Theme := p_Base_Table_Nth;
        l_Nth.Nth_Sequence_Name :=
            'NTH_' || NVL (p_Base_Table_Nth, Retval) || '_SEQ';
        l_Nth.Nth_Snap_To_Theme := 'N';
        l_Nth.Nth_Lref_Mandatory := 'N';
        l_Nth.Nth_Tolerance := 10;
        l_Nth.Nth_Tol_Units := 1;

        Nm3Ins.Ins_Nth (l_Nth);

        l_Rec_Nnth.Nnth_Nlt_Id := p_Nlt_Id;
        l_Rec_Nnth.Nnth_Nth_Theme_Id := Retval;

        Nm3Ins.Ins_Nnth (l_Rec_Nnth);
        --
        --  Build theme gtype rowtype

        l_Rec_Ntg.Ntg_Theme_Id := Retval;
        l_Rec_Ntg.Ntg_Seq_No := 1;
        l_Rec_Ntg.Ntg_Xml_Url := NULL;
        l_Rec_Ntg.Ntg_Gtype := l_Mp_Gtype;

        Nm3Ins.Ins_Ntg (p_Rec_Ntg => l_Rec_Ntg);

        --  Build the base themes

        Create_Base_Themes (Retval, p_Base);

        --
        IF Hig.Get_Sysopt ('REGSDELAY') = 'Y'
        THEN
            EXECUTE IMMEDIATE(   ' begin  '
                              || '    nm3sde.register_sde_layer( p_theme_id => '
                              || TO_CHAR (L_Nth.Nth_Theme_Id)
                              || ');'
                              || ' end;');
        END IF;

        IF P_View_Flag = 'Y'
        THEN
            DECLARE
                l_Role   VARCHAR2 (30);
            BEGIN
                l_Role := Hig.Get_Sysopt ('SDONETROLE');

                IF l_Role IS NOT NULL
                THEN
                    INSERT INTO Nm_Theme_Roles (Nthr_Theme_Id,
                                                Nthr_Role,
                                                Nthr_Mode)
                         VALUES (Retval, l_Role, 'NORMAL');
                END IF;
            END;
        END IF;

        --
        -- create the theme functions - exclude gog
        --
        Create_Theme_Functions (p_Theme     => l_Nth.Nth_Theme_Id,
                                p_Pa        => g_Network_Modules,
                                p_Exclude   => 2);

        RETURN Retval;
    END Register_Lrm_Theme;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Make_Nt_Spatial_Layer (
        pi_Nlt_Id   IN Nm_Linear_Types.Nlt_Id%TYPE,
        p_Gen_Pt    IN NUMBER DEFAULT 0,
        p_Gen_Tol   IN NUMBER DEFAULT 0,
        p_Job_Id    IN NUMBER DEFAULT NULL)
    IS
        /*
        ** not expected to be used for datum layers
        */
        l_Nlt                Nm_Linear_Types%ROWTYPE := Nm3Get.Get_Nlt (Pi_Nlt_Id);
        l_Nlt_Seq            VARCHAR2 (30);
        l_Base_Themes        Nm_Theme_Array;
        l_Theme_Id           Nm_Themes_All.Nth_Theme_Id%TYPE;
        l_Theme_Name         Nm_Themes_All.Nth_Theme_Name%TYPE;
        l_Base_Table_Theme   Nm_Themes_All.Nth_Theme_Id%TYPE;
        l_Tab                VARCHAR2 (30);
        l_View               VARCHAR2 (30);
        l_Usgm               User_Sdo_Geom_Metadata%ROWTYPE;
        l_Diminfo            MDSYS.Sdo_Dim_Array;
        l_Srid               NUMBER;
    --
    BEGIN
        -- AE check to make sure user is unrestricted
        IF NOT User_Is_Unrestricted
        THEN
            RAISE E_Not_Unrestricted;
        END IF;

        --
        -----------------------------------------------------------------------
        -- Table name is the is derived based on nt/gty
        -----------------------------------------------------------------------

        l_Tab := Get_Nlt_Spatial_Table (l_Nlt);

        -----------------------------------------------------------------------
        -- Will always be a group according to Linear types..
        -----------------------------------------------------------------------
        IF l_Nlt.Nlt_G_I_D = 'G'
        THEN
            l_Base_Themes := Get_Nlt_Base_Themes (pi_Nlt_Id);
        END IF;

        IF L_Base_Themes.Nta_Theme_Array (1).Nthe_Id IS NULL
        THEN
            Hig.Raise_Ner (pi_Appl      => Nm3Type.C_Hig,
                           pi_Id        => 266,
                           pi_Sqlcode   => -20001);
        END IF;

        -----------------------------------------------------------------------
        -- Create the nt view if not already there
        -----------------------------------------------------------------------

        IF NOT Nm3Ddl.Does_Object_Exist (l_View, 'VIEW')
        THEN
            Nm3Inv_View.Create_View_For_Nt_Type (l_Nlt.Nlt_Nt_Type);
        END IF;

        -----------------------------------------------------------------------
        -- Create spatial data in table + create date tracked view
        -----------------------------------------------------------------------
        Create_Spatial_Table (l_Tab,
                              TRUE,
                              'START_DATE',
                              'END_DATE');

        Create_Spatial_Date_View (l_Tab);

        -----------------------------------------------------------------------
        -- Clone SDO metadata from it's base layer
        -----------------------------------------------------------------------

        Nm3Sdo.Set_Diminfo_And_Srid (l_Base_Themes, l_Diminfo, l_Srid);

        l_Diminfo (3).Sdo_Tolerance :=
            Nm3Unit.Get_Tol_From_Unit_Mask (
                Nm3Net.Get_Nt_Units (l_Nlt.Nlt_Nt_Type));
        l_Usgm.Table_Name := l_Tab;
        l_Usgm.Column_Name := 'GEOLOC';
        l_Usgm.Diminfo := l_Diminfo;
        l_Usgm.Srid := l_Srid;

        Nm3Sdo.Ins_Usgm (l_Usgm);

        l_Usgm.Table_Name := 'V_' || l_Tab;

        Nm3Sdo.Ins_Usgm (l_Usgm);

        -----------------------------------------------------------------------
        -- Register Theme for table
        -----------------------------------------------------------------------

        l_Theme_Name := SUBSTR (l_Nlt.Nlt_Descr, 1, 26);


        l_Theme_Id :=
            Register_Lrm_Theme (p_Nlt_Id        => pi_Nlt_Id,
                                p_Base          => l_Base_Themes,
                                p_Table_Name    => l_Tab,
                                p_Column_Name   => 'GEOLOC',
                                p_Name          => l_Theme_Name || '_TAB');
        l_Base_Table_Theme := l_Theme_Id;

        l_Nlt_Seq := Nm3Sdo.Create_Spatial_Seq (l_Theme_Id);

        -----------------------------------------------------------------------
        -- Register Theme for date view
        -----------------------------------------------------------------------

        l_Theme_Id :=
            Register_Lrm_Theme (p_Nlt_Id           => pi_Nlt_Id,
                                p_Base             => l_Base_Themes,
                                p_Table_Name       => 'V_' || l_Tab,
                                p_Column_Name      => 'GEOLOC',
                                p_Name             => l_Theme_Name,
                                p_View_Flag        => 'Y',
                                p_Base_Table_Nth   => l_Base_Table_Theme);

        -----------------------------------------------------------------------
        -- Need a join view between spatial table and NT view
        -----------------------------------------------------------------------

        l_View := Create_Nlt_Sdo_Join_View (p_Feature_Table_Name => l_Tab);

        -----------------------------------------------------------------------
        -- Create the spatial data
        -----------------------------------------------------------------------

        Nm3Sdo.Create_Nt_Data (Nm3Get.Get_Nth (l_Base_Table_Theme),
                               pi_Nlt_Id,
                               l_Base_Themes,
                               p_Job_Id);

        -----------------------------------------------------------------------
        -- Table needs a spatial index
        -----------------------------------------------------------------------

        Create_Nlt_Spatial_Idx (l_Nlt, l_Tab);

        -----------------------------------------------------------------------
        -- Register theme for _DT attribute view
        -----------------------------------------------------------------------

        IF G_Date_Views = 'Y'
        THEN
            l_Usgm.Table_Name := l_View;

            Nm3Sdo.Ins_Usgm (l_Usgm);

            l_Theme_Name := SUBSTR (l_Nlt.Nlt_Descr, 1, 27) || '_DT';
            l_Theme_Id :=
                Register_Lrm_Theme (p_Nlt_Id           => pi_Nlt_Id,
                                    p_Base             => l_Base_Themes,
                                    p_Table_Name       => l_View,
                                    p_Column_Name      => 'GEOLOC',
                                    p_Name             => l_Theme_Name,
                                    p_View_Flag        => 'Y',
                                    p_Base_Table_Nth   => l_Base_Table_Theme);
        END IF;

        -----------------------------------------------------------------------
        -- Analyse table
        -----------------------------------------------------------------------
        BEGIN
            Nm3Ddl.Analyse_Table (
                pi_Table_Name            => l_Tab,
                pi_Schema                =>
                    SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER'),
                pi_Estimate_Percentage   => NULL,
                pi_Auto_Sample_Size      => FALSE);
        EXCEPTION
            WHEN OTHERS
            THEN
                RAISE E_No_Analyse_Privs;
        END;

        --
        Nm_Debug.Proc_End (G_Package_Name, 'make_nt_spatial_layer');
    --
    EXCEPTION
        WHEN E_Not_Unrestricted
        THEN
            Raise_Application_Error (
                -20777,
                'Restricted users are not permitted to create SDO layers');
        WHEN E_No_Analyse_Privs
        THEN
            Raise_Application_Error (
                -20778,
                   'Layer created - but user does not have ANALYZE ANY granted. '
                || 'Please ensure the correct role/privs are applied to the user');
    END Make_Nt_Spatial_Layer;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION Get_Nth (pi_Nth_Theme_Id IN Nm_Themes_All.Nth_Theme_Id%TYPE)
        RETURN Nm_Themes_All%ROWTYPE
    IS
        Retval   Nm_Themes_All%ROWTYPE;
    BEGIN
        BEGIN
            SELECT *
              INTO Retval
              FROM Nm_Themes_All
             WHERE Nth_Theme_Id = pi_Nth_Theme_Id;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        RETURN Retval;
    END Get_Nth;

    --
    -----------------------------------------------------------------------------
    --Note that this is temporary - theoretically, the function needs to be
    --able to return all themes for a NT - its a many to many when you include
    --schematics etc.
    --Also, for now it assumes it is a base datum for use in the split/merge routines
    --
    -- The p_Gt Parameter is not used and is included just to keep the header signature the same.
    FUNCTION Get_Nt_Theme (
        p_Nt   IN Nm_Types.Nt_Type%TYPE,
        p_Gt   IN Nm_Group_Types.Ngt_Group_Type%TYPE DEFAULT NULL)
        RETURN Nm_Themes_All.Nth_Theme_Id%TYPE
    IS
        Retval   Nm_Themes_All.Nth_Theme_Id%TYPE;
    BEGIN
        BEGIN
            SELECT Nth_Theme_Id
              INTO Retval
              FROM Nm_Themes_All nta, Nm_Nw_Themes nnt, Nm_Linear_Types nlt
             WHERE     nlt.Nlt_Id = nnt.Nnth_Nlt_Id
                   AND nnt.Nnth_Nth_Theme_Id = nta.Nth_Theme_Id
                   AND nlt.Nlt_Nt_Type = p_Nt
                   AND nta.Nth_Theme_Type = 'SDO'
                   AND nta.Nth_Base_Table_Theme IS NULL
                   AND NOT EXISTS
                           (SELECT NULL
                              FROM Nm_Base_Themes nbt
                             WHERE nbt.Nbth_Theme_Id = nta.Nth_Theme_Id);
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        RETURN Retval;
    END Get_Nt_Theme;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Split_Element_At_Xy (p_Layer     IN     NUMBER,
                                   p_Ne_Id     IN     NUMBER,
                                   p_Measure   IN     NUMBER,
                                   p_X         IN     NUMBER,
                                   p_Y         IN     NUMBER,
                                   p_Ne_Id_1   IN     NUMBER,
                                   p_Ne_Id_2   IN     NUMBER,
                                   p_Geom_1       OUT MDSYS.Sdo_Geometry,
                                   p_Geom_2       OUT MDSYS.Sdo_Geometry)
    IS
        l_Geom       MDSYS.Sdo_Geometry
                         := Nm3Sdo.Get_Layer_Element_Geometry (p_Layer, p_Ne_Id);
        l_Usgm       user_sdo_geom_metadata%ROWTYPE;

        l_Measure    NUMBER;
        l_Distance   NUMBER;
        l_end        NUMBER;
    BEGIN
        IF Nm3Sdo.Element_Has_Shape (p_Layer, p_Ne_Id) = 'TRUE'
        THEN
            l_Distance :=
                SDO_GEOM.sdo_distance (l_geom,
                                       nm3sdo.get_2d_pt (p_x, p_y),
                                       0.005);
            l_Measure :=
                Nm3Sdo.Get_Measure (p_Layer,
                                    p_Ne_Id,
                                    p_X,
                                    p_Y).Lr_Offset;

            l_Usgm := Nm3Sdo.Get_Theme_Metadata (p_Layer);

            SDO_LRS.Split_Geom_Segment (l_Geom,
                                        l_Usgm.Diminfo,
                                        l_Measure,
                                        p_Geom_1,
                                        p_Geom_2);

            IF p_Measure IS NOT NULL
            THEN
                l_Measure := p_Measure;
            END IF;


            p_Geom_1 :=
                SDO_LRS.Scale_Geom_Segment (Geom_Segment    => p_Geom_1,
                                            Dim_Array       => l_Usgm.Diminfo,
                                            Start_Measure   => 0,
                                            End_Measure     => l_Measure,
                                            Shift_Measure   => 0);

            l_End := Nm3Net.Get_Datum_Element_Length (p_Ne_Id) - l_Measure;

            p_Geom_2 :=
                SDO_LRS.Scale_Geom_Segment (Geom_Segment    => p_Geom_2,
                                            Dim_Array       => l_Usgm.Diminfo,
                                            Start_Measure   => 0,
                                            End_Measure     => l_End,
                                            Shift_Measure   => 0);
        ELSE
            p_Geom_1 := NULL;
            p_Geom_2 := NULL;
        END IF;
    END Split_Element_At_Xy;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Split_Element_Shapes (p_Ne_Id     IN Nm_Elements.Ne_Id%TYPE,
                                    p_Measure   IN NUMBER,
                                    p_Ne_Id_1   IN Nm_Elements.Ne_Id%TYPE,
                                    p_Ne_Id_2   IN Nm_Elements.Ne_Id%TYPE,
                                    p_X         IN NUMBER DEFAULT NULL,
                                    p_Y         IN NUMBER DEFAULT NULL)
    IS
        l_Layer      NUMBER;
        l_geom       MDSYS.Sdo_Geometry;
        l_Geom1      MDSYS.Sdo_Geometry;
        l_Geom2      MDSYS.Sdo_Geometry;
        l_Usgm       user_sdo_geom_metadata%ROWTYPE;
        l_tol        NUMBER;
        l_End        NUMBER;
        l_distance   NUMBER;
    BEGIN
        l_Layer := Get_Nt_Theme (Nm3Get.Get_Ne (p_Ne_Id).Ne_Nt_Type);

        IF NOT test_theme_for_update (l_layer)
        THEN
            HIG.RAISE_NER ('NET', 339);
        END IF;

        IF Nm3Sdo.Element_Has_Shape (L_Layer, P_Ne_Id) = 'TRUE'
        THEN
            l_geom := Nm3Sdo.Get_Layer_Element_Geometry (l_Layer, p_Ne_Id);

            l_Usgm := Nm3Sdo.Get_Theme_Metadata (l_Layer);

            SELECT GREATEST (
                       NM3SDO.GET_TOL_FROM_UNIT_MASK (nt_length_unit),
                       TO_NUMBER (NVL (hig.get_sysopt ('SDOMINPROJ'), '0')))
              INTO l_tol
              FROM nm_elements, nm_types
             WHERE ne_id = p_Ne_Id AND ne_nt_type = nt_type;

            l_End := Nm3Net.Get_Datum_Element_Length (p_Ne_Id);

            IF p_X IS NULL AND p_Y IS NULL
            THEN
                IF p_measure < l_tol OR ABS (l_End - p_measure) < l_tol
                THEN
                    raise_application_error (
                        -20001,
                        'Split position cannot be at the start or end of an element');
                END IF;

                Nm3Sdo.Split_Element_At_Measure (p_Layer     => l_Layer,
                                                 p_Ne_Id     => p_Ne_Id,
                                                 p_Measure   => p_Measure,
                                                 p_Ne_Id_1   => p_Ne_Id_1,
                                                 p_Ne_Id_2   => p_Ne_Id_2,
                                                 p_Geom1     => l_Geom1,
                                                 p_Geom2     => l_Geom2);
            ELSIF p_X IS NOT NULL AND p_Y IS NOT NULL
            THEN
                l_Distance :=
                    SDO_GEOM.sdo_distance (l_geom,
                                           nm3sdo.get_2d_pt (p_x, p_y),
                                           0.005);

                IF l_Distance >
                   TO_NUMBER (NVL (hig.get_sysopt ('SDOPROXTOL'), 2))
                THEN
                    raise_application_error (
                        -20001,
                        'Split position is not in close proximity to element geometry');
                END IF;

                IF p_measure < l_tol OR ABS (l_End - p_measure) < l_tol
                THEN
                    raise_application_error (
                        -20001,
                        'Split position cannot be at the start or end of an element');
                END IF;

                Split_Element_At_Xy (p_Layer     => l_Layer,
                                     p_Ne_Id     => p_Ne_Id,
                                     p_Measure   => p_Measure,
                                     p_X         => p_X,
                                     p_Y         => p_Y,
                                     p_Ne_Id_1   => p_Ne_Id_1,
                                     p_Ne_Id_2   => p_Ne_Id_2,
                                     p_Geom_1    => l_Geom1,
                                     p_Geom_2    => l_Geom2);
            ELSE
                Raise_Application_Error (-20001, 'Incompatible values');
            END IF;

            Nm3Sdo.Insert_Element_Shape (p_Layer   => l_Layer,
                                         p_Ne_Id   => p_Ne_Id_1,
                                         p_Geom    => l_Geom1);

            Nm3Sdo.Insert_Element_Shape (p_Layer   => l_Layer,
                                         p_Ne_Id   => p_Ne_Id_2,
                                         p_Geom    => l_Geom2);
        END IF;
    END Split_Element_Shapes;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Ins_Usgm (Pi_Rec_Usgm IN OUT User_Sdo_Geom_Metadata%ROWTYPE)
    IS
    BEGIN
        Nm_Debug.Proc_Start (G_Package_Name, 'ins_usgm');

        INSERT INTO Mdsys.Sdo_Geom_Metadata_Table (Sdo_Table_Name,
                                                   Sdo_Column_Name,
                                                   Sdo_Diminfo,
                                                   Sdo_Srid,
                                                   Sdo_Owner)
             VALUES (pi_Rec_Usgm.Table_Name,
                     pi_Rec_Usgm.Column_Name,
                     pi_Rec_Usgm.Diminfo,
                     pi_Rec_Usgm.Srid,
                     SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER'))
          RETURNING Sdo_Table_Name,
                    Sdo_Column_Name,
                    Sdo_Diminfo,
                    Sdo_Srid
               INTO pi_Rec_Usgm.Table_Name,
                    pi_Rec_Usgm.Column_Name,
                    pi_Rec_Usgm.Diminfo,
                    pi_Rec_Usgm.Srid;

        Nm_Debug.Proc_End (G_Package_Name, 'ins_usgm');
    END Ins_Usgm;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Merge_Element_Shapes (
        p_Ne_Id           IN Nm_Elements.Ne_Id%TYPE,
        p_Ne_Id_1         IN Nm_Elements.Ne_Id%TYPE,
        p_Ne_Id_2         IN Nm_Elements.Ne_Id%TYPE,
        p_Ne_Id_To_Flip   IN Nm_Elements.Ne_Id%TYPE)
    IS
        l_Layer   NUMBER;
        l_Geom    MDSYS.Sdo_Geometry;
    BEGIN
        l_Layer := Get_Nt_Theme (Nm3Get.Get_Ne (P_Ne_Id).Ne_Nt_Type);

        IF NOT test_theme_for_update (l_Layer)
        THEN
            HIG.RAISE_NER ('NET', 339);
        END IF;


        IF     Nm3Sdo.Element_Has_Shape (L_Layer, P_Ne_Id_1) = 'TRUE'
           AND Nm3Sdo.Element_Has_Shape (L_Layer, P_Ne_Id_2) = 'TRUE'
        THEN
            Nm3Sdo.Merge_Element_Shapes (p_Layer           => l_Layer,
                                         p_Ne_Id_1         => p_Ne_Id_1,
                                         p_Ne_Id_2         => p_Ne_Id_2,
                                         p_Ne_Id_To_Flip   => p_Ne_Id_To_Flip,
                                         p_Geom            => l_Geom);

            IF L_Geom IS NOT NULL
            THEN
                Nm3Sdo.Insert_Element_Shape (p_Layer   => l_Layer,
                                             p_Ne_Id   => p_Ne_Id,
                                             p_Geom    => l_Geom);
            END IF;
        END IF;
    END Merge_Element_Shapes;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Replace_Element_Shape (p_Ne_Id_Old   IN Nm_Elements.Ne_Id%TYPE,
                                     p_Ne_Id_New   IN Nm_Elements.Ne_Id%TYPE)
    IS
        l_Layer_Old   NUMBER;
        l_Layer_New   NUMBER;
        l_Geom        MDSYS.Sdo_Geometry;
    BEGIN
        l_Layer_Old :=
            Get_Nt_Theme (Nm3Get.Get_Ne_All (p_Ne_Id_Old).Ne_Nt_Type);
        l_Layer_New := Get_Nt_Theme (Nm3Get.Get_Ne (p_Ne_Id_New).Ne_Nt_Type);

        IF NOT test_theme_for_update (l_Layer_Old)
        THEN
            HIG.RAISE_NER ('NET', 339);
        END IF;

        IF     Nm3Sdo.Element_Has_Shape (l_Layer_Old, p_Ne_Id_Old) = 'TRUE'
           AND l_Layer_New IS NOT NULL
        THEN
            l_Geom :=
                Nm3Sdo.Get_Layer_Element_Geometry (l_Layer_Old, p_Ne_Id_Old);
            --  The old element shape must be end-dated
            --  The new one must be created
            --  All affected shapes inside asset layers must be regenerated
            Nm3Sdo.Insert_Element_Shape (p_Layer   => l_Layer_New,
                                         p_Ne_Id   => p_Ne_Id_New,
                                         p_Geom    => l_Geom);
        END IF;
    END Replace_Element_Shape;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Reverse_Element_Shape (p_Ne_Id_Old   IN Nm_Elements.Ne_Id%TYPE,
                                     p_Ne_Id_New   IN Nm_Elements.Ne_Id%TYPE)
    IS
        l_Layer   NUMBER;
        l_Geom    MDSYS.Sdo_Geometry;
    BEGIN
        l_Layer := Get_Nt_Theme (Nm3Get.Get_Ne_All (p_Ne_Id_Old).Ne_Nt_Type);

        IF NOT test_theme_for_update (l_Layer)
        THEN
            HIG.RAISE_NER ('NET', 339);
        END IF;

        IF Nm3Sdo.Element_Has_Shape (l_Layer, p_Ne_Id_Old) = 'TRUE'
        THEN
            l_Geom :=
                Nm3Sdo.Get_Layer_Element_Geometry (l_Layer, p_Ne_Id_Old);

            l_Geom := Nm3Sdo.Reverse_Geometry (p_Geom => l_Geom);

            Nm3Sdo.Insert_Element_Shape (p_Layer   => l_Layer,
                                         p_Ne_Id   => p_Ne_Id_New,
                                         p_Geom    => l_Geom);
        END IF;
    END Reverse_Element_Shape;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Recalibrate_Element_Shape (
        p_Ne_Id               IN Nm_Elements.Ne_Id%TYPE,
        p_Measure             IN NUMBER,
        p_New_Length_To_End   IN Nm_Elements.Ne_Length%TYPE)
    IS
        l_Layer     NUMBER;
        l_Pt_Geom   MDSYS.Sdo_Geometry;
        l_Geom      MDSYS.Sdo_Geometry;
    BEGIN
        l_Layer := Get_Nt_Theme (Nm3Get.Get_Ne (p_Ne_Id).Ne_Nt_Type);

        IF NOT test_theme_for_update (l_Layer)
        THEN
            HIG.RAISE_NER ('NET', 339);
        END IF;


        IF Nm3Sdo.Element_Has_Shape (l_Layer, p_Ne_Id) = 'TRUE'
        THEN
            l_Geom := Nm3Sdo.Get_Layer_Element_Geometry (l_Layer, p_Ne_Id);

            l_Geom :=
                Nm3Sdo.Recalibrate_Geometry (
                    p_Layer           => l_Layer,
                    p_Ne_Id           => p_Ne_Id,
                    p_Geom            => l_Geom,
                    p_Measure         => p_Measure,
                    p_Length_To_End   => p_New_Length_To_End);
            Nm3Sdo.Delete_Layer_Shape (p_Layer => l_Layer, p_Ne_Id => p_Ne_Id);

            Nm3Sdo.Insert_Element_Shape (p_Layer   => l_Layer,
                                         p_Ne_Id   => p_Ne_Id,
                                         p_Geom    => l_Geom);
        --  The measures on the routes will be affected
        --  However, the nm_true will be out of step - this should be done on a resequence

        --  The other layers are also affected, but since the calling process will affect the members, best left to
        --  the trigger to deal with it.
        END IF;
    END Recalibrate_Element_Shape;

    --
    -------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Shift_Asset_Shapes (
        p_Ne_Id               IN Nm_Elements.Ne_Id%TYPE,
        p_Measure             IN NUMBER,
        p_New_Length_To_End   IN Nm_Elements.Ne_Length%TYPE)
    IS
        l_Layer     NUMBER;
        l_Pt_Geom   MDSYS.Sdo_Geometry;
        l_Geom      MDSYS.Sdo_Geometry;
    BEGIN
        l_Layer := Get_Nt_Theme (Nm3Get.Get_Ne (p_Ne_Id).Ne_Nt_Type);

        IF Nm3Sdo.Element_Has_Shape (l_Layer, p_Ne_Id) = 'TRUE'
        THEN
            --  remove all existing shapes - they will move with the shift
            Nm3Sdo.Add_New_Inv_Shapes (p_Layer   => l_Layer,
                                       p_Ne_Id   => p_Ne_Id,
                                       p_Geom    => l_Geom);
        END IF;
    END Shift_Asset_Shapes;

    --
    ---------------------------------------------------------------------------------------------------
    --
    FUNCTION Get_Inv_Base_Themes (
        p_Inv_Type   IN Nm_Inv_Nw.Nin_Nit_Inv_Code%TYPE)
        RETURN Nm_Theme_Array
    IS
        Retval   Nm_Theme_Array := Nm3Array.Init_Nm_Theme_Array;
    BEGIN
        SELECT Nm_Theme_Entry (nta.Nth_Theme_Id)
          BULK COLLECT INTO Retval.Nta_Theme_Array
          FROM Nm_Nw_Themes     nnt,
               Nm_Themes_All    nta,
               Nm_Linear_Types  nlt,
               Nm_Inv_Nw        nin
         WHERE     nin.Nin_Nit_Inv_Code = p_Inv_Type
               AND nin.Nin_Nw_Type = nlt.Nlt_Nt_Type
               AND nlt.Nlt_Id = nnt.Nnth_Nlt_Id
               AND nta.Nth_Base_Table_Theme IS NULL
               AND nnt.Nnth_Nth_Theme_Id = nta.Nth_Theme_Id;

        --And     Not Exists            (   Select  Null
        --                                  From    Nm_Base_Themes  nbt
        --                                  Where   nta.Nth_Theme_Id = nbt.Nbth_Theme_Id
        --                              );

        IF Retval.Nta_Theme_Array.LAST IS NULL
        THEN
            -- no base theme availible
            Hig.Raise_Ner (Pi_Appl      => Nm3Type.C_Hig,
                           Pi_Id        => 194,
                           Pi_Sqlcode   => -20001);
        END IF;

        RETURN Retval;
    END Get_Inv_Base_Themes;

    --
    ---------------------------------------------------------------------------------------------------
    --
    FUNCTION Register_Inv_Theme (
        pi_Nit             IN Nm_Inv_Types%ROWTYPE,
        p_Base_Themes      IN Nm_Theme_Array,
        p_Table_Name       IN VARCHAR2,
        p_Spatial_Column   IN VARCHAR2 DEFAULT 'GEOLOC',
        p_Fk_Column        IN VARCHAR2 DEFAULT 'NE_ID',
        p_Name             IN VARCHAR2 DEFAULT NULL,
        p_View_Flag        IN VARCHAR2 DEFAULT 'N',
        p_Pk_Column        IN VARCHAR2 DEFAULT 'NE_ID',
        p_Base_Table_Nth   IN Nm_Themes_All.Nth_Theme_Id%TYPE DEFAULT NULL)
        RETURN NUMBER
    IS
        l_Immediate_Or_Deferred   VARCHAR2 (1) := 'I';
        l_F_Fk_Column             VARCHAR2 (30) := 'NE_ID';
        l_Pk_Column               VARCHAR2 (30);
        l_Name                    VARCHAR2 (30);
        l_T_Pk_Column             VARCHAR2 (30);
        l_T_Fk_Column             VARCHAR2 (30);
        l_T_Uk_Column             VARCHAR2 (30);
        l_T_Begin_Col             VARCHAR2 (30);
        l_Tab                     VARCHAR2 (30);
        l_End_Mp                  VARCHAR2 (30) := NULL;
        Retval                    NUMBER;
        l_Nth                     Nm_Themes_All%ROWTYPE;
        l_Rec_Nith                Nm_Inv_Themes%ROWTYPE;
        l_Rec_Ntg                 Nm_Theme_Gtypes%ROWTYPE;
    BEGIN
        l_Name := UPPER (p_Name);

        IF l_Name IS NULL
        THEN
            l_Name :=
                UPPER (
                    NVL (
                        pi_Nit.Nit_Short_Descr,
                        SUBSTR (
                            Pi_Nit.Nit_Inv_Type || '-' || pi_Nit.Nit_Descr,
                            1,
                            30)));
        END IF;

        IF p_View_Flag = 'Y'
        THEN
            l_Immediate_Or_Deferred := 'N';
            l_F_Fk_Column := NULL;
        END IF;

        l_Pk_Column := p_Fk_Column;

        IF Nm3Sdo.Use_Surrogate_Key = 'Y'
        THEN
            IF p_Pk_Column IS NOT NULL
            THEN
                l_Pk_Column := p_Pk_Column;
            ELSE
                --  to make SM work for now we have to put the NE_ID in!
                l_Pk_Column := 'NE_ID';
            END IF;
        END IF;

        Retval := Higgis.Next_Theme_Id;

        IF Pi_Nit.Nit_Pnt_Or_Cont = 'C'
        THEN
            l_End_Mp := 'NM_END_MP';
        END IF;

        IF Pi_Nit.Nit_Table_Name IS NOT NULL
        THEN
            --  Foreign table
            l_Tab := pi_Nit.Nit_Table_Name;
            l_T_Pk_Column := pi_Nit.Nit_Foreign_Pk_Column;
            l_T_Fk_Column := pi_Nit.Nit_Lr_Ne_Column_Name;
            l_T_Uk_Column := pi_Nit.Nit_Foreign_Pk_Column;
            l_T_Begin_Col := pi_Nit.Nit_Lr_St_Chain;

            l_immediate_or_deferred := 'N';

            IF pi_Nit.Nit_Pnt_Or_Cont = 'C'
            THEN
                l_End_Mp := pi_Nit.Nit_Lr_End_Chain;
            END IF;
        ELSE
            l_Tab :=
                Nm3Inv_View.Work_Out_Inv_Type_View_Name (pi_Nit.Nit_Inv_Type);
            l_T_Pk_Column := 'IIT_NE_ID';
            l_T_Fk_Column := 'NE_ID_OF';
            l_T_Uk_Column := 'IIT_PRIMARY_KEY';
            l_T_Begin_Col := 'NM_BEGIN_MP';

            IF pi_Nit.Nit_Pnt_Or_Cont = 'C'
            THEN
                l_End_Mp := 'NM_END_MP';
            END IF;
        END IF;

        --  Build theme rowtype
        l_Nth.Nth_Theme_Id := Retval;
        l_Nth.Nth_Theme_Name := l_Name;
        l_Nth.Nth_Table_Name := l_Tab;
        l_Nth.Nth_Where := NULL;
        l_Nth.Nth_Pk_Column := l_T_Pk_Column;
        l_Nth.Nth_Label_Column := l_T_Uk_Column;
        l_Nth.Nth_Rse_Table_Name := 'NM_ELEMENTS';
        l_Nth.Nth_Rse_Fk_Column := l_T_Fk_Column;
        l_Nth.Nth_St_Chain_Column := l_T_Begin_Col;
        l_Nth.Nth_End_Chain_Column := l_End_Mp;
        l_Nth.Nth_X_Column := NULL;
        l_Nth.Nth_Y_Column := NULL;
        l_Nth.Nth_Offset_Field := NULL;
        l_Nth.Nth_Feature_Table := p_Table_Name;
        l_Nth.Nth_Feature_Pk_Column := l_Pk_Column;
        l_Nth.Nth_Feature_Fk_Column := l_F_Fk_Column;
        l_Nth.Nth_Xsp_Column := NULL;
        l_Nth.Nth_Feature_Shape_Column := p_Spatial_Column;
        l_Nth.Nth_Hpr_Product := 'NET';
        l_Nth.Nth_Location_Updatable := 'N';
        l_Nth.Nth_Theme_Type := 'SDO';
        l_Nth.Nth_Dependency := 'D';
        l_Nth.Nth_Storage := 'S';
        l_Nth.Nth_Update_On_Edit := l_Immediate_Or_Deferred;
        l_Nth.Nth_Use_History := 'Y';
        l_Nth.Nth_Start_Date_Column := 'START_DATE';
        l_Nth.Nth_End_Date_Column := 'END_DATE';
        l_Nth.Nth_Base_Table_Theme := p_Base_Table_Nth;
        l_Nth.Nth_Sequence_Name :=
            'NTH_' || NVL (p_Base_Table_Nth, Retval) || '_SEQ';
        l_Nth.Nth_Snap_To_Theme := 'N';
        l_Nth.Nth_Lref_Mandatory := 'N';
        l_Nth.Nth_Tolerance := 10;
        l_Nth.Nth_Tol_Units := 1;
        --
        Nm3Ins.Ins_Nth (L_Nth);
        --  Build inv theme link
        l_Rec_Nith.Nith_Nit_Id := pi_Nit.Nit_Inv_Type;
        l_Rec_Nith.Nith_Nth_Theme_Id := Retval;
        --
        Nm3Ins.Ins_Nith (L_Rec_Nith);
        --  Build theme gtype rowtype
        l_Rec_Ntg.Ntg_Theme_Id := l_Nth.Nth_Theme_Id;
        l_Rec_Ntg.Ntg_Seq_No := 1;
        l_Rec_Ntg.Ntg_Xml_Url := NULL;

        IF pi_Nit.Nit_Pnt_Or_Cont = 'P'
        THEN
            l_Rec_Ntg.Ntg_Gtype := '2001';
        ELSIF pi_Nit.Nit_Pnt_Or_Cont = 'C'
        THEN
            l_Rec_Ntg.Ntg_Gtype := 3302;
        END IF;

        Nm3Ins.Ins_Ntg (p_Rec_Ntg => l_Rec_Ntg);

        Create_Base_Themes (Retval, p_Base_Themes);

        --
        IF Hig.Get_Sysopt ('REGSDELAY') = 'Y'
        THEN
            EXECUTE IMMEDIATE(   'begin '
                              || '    nm3sde.register_sde_layer( p_theme_id => '
                              || TO_CHAR (l_Nth.Nth_Theme_Id)
                              || ')'
                              || '; end;');
        END IF;

        IF p_View_Flag = 'Y'
        THEN
            INSERT INTO Nm_Theme_Roles (Nthr_Theme_Id, Nthr_Role, Nthr_Mode)
                SELECT Retval, nitr.Itr_Hro_Role, nitr.Itr_Mode
                  FROM Nm_Inv_Type_Roles nitr
                 WHERE Itr_Inv_Type = pi_Nit.Nit_Inv_Type;
        END IF;

        --
        -- register the theme functions
        --

        IF pi_Nit.Nit_Table_Name IS NULL
        THEN
            Create_Theme_Functions (p_Theme     => l_Nth.Nth_Theme_Id,
                                    p_Pa        => g_Asset_Modules,
                                    p_Exclude   => NULL);
        ELSE
            -- FT exclude data with a 2
            Create_Theme_Functions (p_Theme     => l_Nth.Nth_Theme_Id,
                                    p_Pa        => g_Asset_Modules,
                                    p_Exclude   => 2);
        END IF;

        RETURN Retval;
    END Register_Inv_Theme;

    --
    ---------------------------------------------------------------------------------------------------
    --
    FUNCTION Register_Ona_Theme (
        pi_Nit             IN Nm_Inv_Types%ROWTYPE,
        p_Table_Name       IN VARCHAR2,
        p_Spatial_Column   IN VARCHAR2 DEFAULT 'GEOLOC',
        p_Fk_Column        IN VARCHAR2 DEFAULT 'NE_ID',
        p_Name             IN VARCHAR2 DEFAULT NULL,
        p_View_Flag        IN VARCHAR2 DEFAULT 'N',
        p_Pk_Column        IN VARCHAR2 DEFAULT 'NE_ID',
        p_Base_Table_Nth   IN Nm_Themes_All.Nth_Theme_Id%TYPE DEFAULT NULL)
        RETURN NUMBER
    IS
        l_Immediate_Or_Deferred   VARCHAR2 (1) := 'N';
        l_Pk_Column               VARCHAR2 (30);
        l_Name                    VARCHAR2 (30);
        l_T_Pk_Column             VARCHAR2 (30);
        l_T_Fk_Column             VARCHAR2 (30);
        l_T_Uk_Column             VARCHAR2 (30);
        l_T_Begin_Col             VARCHAR2 (30);
        l_T_End_Col               VARCHAR2 (30);
        l_T_X_Col                 VARCHAR2 (30);
        l_T_Y_Col                 VARCHAR2 (30);
        --
        l_Tab                     VARCHAR2 (30);
        l_End_Mp                  VARCHAR2 (10) := NULL;
        Retval                    NUMBER;
        l_Nth                     Nm_Themes_All%ROWTYPE;
        l_Rec_Base_Nth            Nm_Themes_All%ROWTYPE;
        l_Rec_Nith                Nm_Inv_Themes%ROWTYPE;
        l_Rec_Ntg                 Nm_Theme_Gtypes%ROWTYPE;
        l_Nth_Start_Date_Column   Nm_Themes_All.Nth_Start_Date_Column%TYPE;
        l_Nth_End_Date_Column     Nm_Themes_All.Nth_End_Date_Column%TYPE;
        l_Nth_Base_Table_Theme    Nm_Themes_All.Nth_Base_Table_Theme%TYPE;
        l_Nth_Sequence_Name       Nm_Themes_All.Nth_Sequence_Name%TYPE;
        l_Nth_Snap_To_Theme       Nm_Themes_All.Nth_Snap_To_Theme%TYPE;
        l_Nth_Lref_Mandatory      Nm_Themes_All.Nth_Lref_Mandatory%TYPE;
        l_Nth_Tolerance           Nm_Themes_All.Nth_Tolerance%TYPE;
        l_Nth_Tol_Units           Nm_Themes_All.Nth_Tol_Units%TYPE;
        e_Dup_Nth                 EXCEPTION;
        e_Dup_Nith                EXCEPTION;
        e_Dup_Ntg                 EXCEPTION;

        --
        FUNCTION Get_Base_Gtype (Cp_Theme_Id IN NUMBER)
            RETURN NUMBER
        IS
            Retval   NUMBER;
        BEGIN
            SELECT MAX (Ntg_Gtype)
              INTO Retval
              FROM Nm_Theme_Gtypes
             WHERE Ntg_Theme_Id = Cp_Theme_Id;

            RETURN Retval;
        EXCEPTION
            WHEN OTHERS
            THEN
                Hig.Raise_Ner (Pi_Appl      => Nm3Type.C_Hig,
                               Pi_Id        => 268,
                               Pi_Sqlcode   => -20001);
        END Get_Base_Gtype;
    ------------
    --
    ------------
    BEGIN
        --
        Nm_Debug.Proc_Start (G_Package_Name, 'register_ona_theme');
        --
        l_Name := UPPER (p_Name);

        IF l_Name IS NULL
        THEN
            l_Name :=
                UPPER (
                    NVL (
                        pi_Nit.Nit_Short_Descr,
                        SUBSTR (
                            pi_Nit.Nit_Inv_Type || '-' || pi_Nit.Nit_Descr,
                            1,
                            30)));
        END IF;

        IF pi_Nit.Nit_Table_Name IS NOT NULL
        THEN
            l_Pk_Column := pi_Nit.Nit_Foreign_Pk_Column;
        ELSE
            L_Pk_Column := 'IIT_NE_ID';
        END IF;

        --
        IF Nm3Sdo.Use_Surrogate_Key = 'Y'
        THEN
            l_Pk_Column := 'IIT_NE_ID';
        END IF;

        --
        Retval := Higgis.Next_Theme_Id;

        IF pi_Nit.Nit_Table_Name IS NOT NULL
        THEN
            --  Foreign table
            l_Tab := pi_Nit.Nit_Table_Name;
            l_T_Pk_Column := pi_Nit.Nit_Foreign_Pk_Column;
            l_T_Uk_Column := pi_Nit.Nit_Foreign_Pk_Column;
        ELSE
            l_Tab :=
                Nm3Inv_View.Work_Out_Inv_Type_View_Name (pi_Nit.Nit_Inv_Type);
            l_T_Pk_Column := 'IIT_NE_ID';
            l_T_Uk_Column := 'IIT_PRIMARY_KEY';

            IF Pi_Nit.Nit_Use_Xy = 'Y'
            THEN
                L_T_X_Col := 'IIT_X';
                L_T_Y_Col := 'IIT_Y';
            END IF;
        END IF;

        --
        IF p_Base_Table_Nth IS NOT NULL
        THEN
            l_Rec_Base_Nth :=
                Nm3Get.Get_Nth (pi_Nth_Theme_Id => p_Base_Table_Nth);
        END IF;

        --
        l_Nth.Nth_Theme_Id := Retval;
        l_Nth.Nth_Theme_Name := l_Name;
        l_Nth.Nth_Table_Name := l_Tab;
        l_Nth.Nth_Where := NULL;
        l_Nth.Nth_Pk_Column := l_T_Pk_Column;
        l_Nth.Nth_Label_Column := l_T_Uk_Column;
        l_Nth.Nth_X_Column := l_T_X_Col;
        l_Nth.Nth_Y_Column := l_T_Y_Col;
        l_Nth.Nth_Feature_Table := p_Table_Name;
        l_Nth.Nth_Feature_Pk_Column :=
            NVL (p_Pk_Column, l_Rec_Base_Nth.Nth_Feature_Pk_Column);
        l_Nth.Nth_Feature_Shape_Column := p_Spatial_Column;
        l_Nth.Nth_Hpr_Product := 'NET';
        l_Nth.Nth_Location_Updatable :=
            NVL (l_Rec_Base_Nth.Nth_Location_Updatable, 'N');
        l_Nth.Nth_Theme_Type := 'SDO';
        l_Nth.Nth_Dependency := 'I';
        l_Nth.Nth_Storage := 'S';
        l_Nth.Nth_Update_On_Edit := l_Immediate_Or_Deferred;
        l_Nth.Nth_Use_History := 'Y';
        l_Nth.Nth_Start_Date_Column :=
            NVL (l_Rec_Base_Nth.Nth_Start_Date_Column, 'START_DATE');
        l_Nth.Nth_End_Date_Column :=
            NVL (l_Rec_Base_Nth.Nth_End_Date_Column, 'END_DATE');
        l_Nth.Nth_Base_Table_Theme := p_Base_Table_Nth;
        l_Nth.Nth_Sequence_Name :=
            NVL (l_Rec_Base_Nth.Nth_Sequence_Name,
                 'NTH_' || Retval || '_SEQ');
        l_Nth.Nth_Snap_To_Theme :=
            NVL (l_Rec_Base_Nth.Nth_Snap_To_Theme, 'N');
        l_Nth.Nth_Lref_Mandatory :=
            NVL (l_Rec_Base_Nth.Nth_Lref_Mandatory, 'N');
        l_Nth.Nth_Tolerance := NVL (l_Rec_Base_Nth.Nth_Tolerance, 10);
        l_Nth.Nth_Tol_Units := 1;

        --
        BEGIN
            Nm3Ins.Ins_Nth (l_Nth);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
                RAISE E_Dup_Nth;
        END;

        --
        l_Rec_Nith.Nith_Nit_Id := pi_Nit.Nit_Inv_Type;
        l_Rec_Nith.Nith_Nth_Theme_Id := Retval;

        BEGIN
            Nm3Ins.Ins_Nith (l_Rec_Nith);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
                RAISE E_Dup_Nith;
        END;

        -- Create GTYPE record
        l_Rec_Ntg.Ntg_Gtype := Get_Base_Gtype (l_Rec_Base_Nth.Nth_Theme_Id);

        IF l_Rec_Ntg.Ntg_Gtype IS NOT NULL
        THEN
            l_Rec_Ntg.Ntg_Theme_Id := l_Nth.Nth_Theme_Id;
            l_Rec_Ntg.Ntg_Seq_No := 1;
        END IF;

        BEGIN
            Nm3Ins.Ins_Ntg (P_Rec_Ntg => L_Rec_Ntg);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
                RAISE E_Dup_Ntg;
        END;

        IF p_View_Flag = 'Y'
        THEN
            INSERT INTO Nm_Theme_Roles (Nthr_Theme_Id, Nthr_Role, Nthr_Mode)
                SELECT Retval, nitr.Itr_Hro_Role, nitr.Itr_Mode
                  FROM Nm_Inv_Type_Roles nitr
                 WHERE nitr.Itr_Inv_Type = pi_Nit.Nit_Inv_Type;
        END IF;

        --
        -- create the theme functions
        --
        IF Pi_Nit.Nit_Table_Name IS NULL
        THEN
            Create_Theme_Functions (p_Theme     => l_Nth.Nth_Theme_Id,
                                    p_Pa        => g_Asset_Modules,
                                    p_Exclude   => NULL);
        ELSE
            Create_Theme_Functions (p_Theme     => l_Nth.Nth_Theme_Id,
                                    p_Pa        => g_Asset_Modules,
                                    p_Exclude   => 2);
        END IF;

        --
        RETURN Retval;
        --
        Nm_Debug.Proc_End (G_Package_Name, 'register_ona_theme');
    --
    EXCEPTION
        WHEN E_Dup_Nth
        THEN
            Hig.Raise_Ner (pi_Appl      => Nm3Type.C_Hig,
                           pi_Id        => 269,
                           pi_Sqlcode   => -20001);
        WHEN E_Dup_Nith
        THEN
            Hig.Raise_Ner (pi_Appl      => Nm3Type.C_Hig,
                           pi_Id        => 270,
                           pi_Sqlcode   => -20001);
        WHEN E_Dup_Ntg
        THEN
            Hig.Raise_Ner (pi_Appl      => Nm3Type.C_Hig,
                           pi_Id        => 271,
                           pi_Sqlcode   => -20001);
    END Register_Ona_Theme;

    --
    ---------------------------------------------------------------------------------------------------
    --
    FUNCTION Get_Nat_Base_Themes (
        p_Gty_Type   IN Nm_Area_Types.Nat_Gty_Group_Type%TYPE)
        RETURN Nm_Theme_Array
    IS
        Retval   Nm_Theme_Array := Nm3Array.Init_Nm_Theme_Array;
    BEGIN
        SELECT Nm_Theme_Entry (nta.Nth_Theme_Id)
          BULK COLLECT INTO Retval.Nta_Theme_Array
          FROM Nm_Nw_Themes     nnt,
               Nm_Linear_Types  nlt,
               Nm_Themes_All    nta,
               Nm_Nt_Groupings  nng
         WHERE     nng.Nng_Group_Type = p_Gty_Type
               AND nng.Nng_Nt_Type = nlt.Nlt_Nt_Type
               AND nlt.Nlt_G_I_D = 'D'
               AND nta.Nth_Base_Table_Theme IS NULL
               AND nlt.Nlt_Gty_Type IS NULL
               AND nlt.Nlt_Id = nnt.Nnth_Nlt_Id
               AND nnt.Nnth_Nth_Theme_Id = nta.Nth_Theme_Id
               AND NOT EXISTS
                       (SELECT NULL
                          FROM Nm_Base_Themes nbt
                         WHERE nta.Nth_Theme_Id = nbt.Nbth_Theme_Id);

        IF Retval.Nta_Theme_Array.LAST IS NULL
        THEN
            Hig.Raise_Ner (pi_Appl                 => Nm3Type.C_Hig,
                           pi_Id                   => 272,
                           pi_Sqlcode              => -20001,
                           pi_Supplementary_Info   => p_Gty_Type);
        END IF;

        RETURN Retval;
    END Get_Nat_Base_Themes;

    --
    ---------------------------------------------------------------------------------------------------
    --
    FUNCTION Register_Nat_Theme (
        p_Nt_Type          IN Nm_Types.Nt_Type%TYPE,
        p_Gty_Type         IN Nm_Group_Types.Ngt_Group_Type%TYPE,
        p_Base_Themes      IN Nm_Theme_Array,
        p_Table_Name       IN VARCHAR2,
        p_Spatial_Column   IN VARCHAR2 DEFAULT 'GEOLOC',
        p_Fk_Column        IN VARCHAR2 DEFAULT 'NE_ID',
        p_Name             IN VARCHAR2 DEFAULT NULL,
        p_View_Flag        IN VARCHAR2 DEFAULT 'N',
        p_Base_Table_Nth   IN Nm_Themes_All.Nth_Theme_Id%TYPE DEFAULT NULL)
        RETURN NUMBER
    IS
        Retval                    NUMBER;
        l_Nat_Id                  NUMBER;
        l_Name                    VARCHAR2 (30) := NVL (p_Name, p_Table_Name);
        l_Immediate_Or_Deferred   VARCHAR2 (1)
            := CASE NM3NET.GET_GTY_SUB_GROUP_ALLOWED (p_Gty_Type)
                   WHEN 'Y' THEN 'D'
                   ELSE 'I'
               END;
        l_Nat                     Nm_Area_Types%ROWTYPE;
        l_Nth_Id                  Nm_Themes_All.Nth_Theme_Id%TYPE;
        l_Nth                     Nm_Themes_All%ROWTYPE;
        l_Rec_Ntg                 Nm_Theme_Gtypes%ROWTYPE;
    BEGIN
        IF p_View_Flag = 'Y'
        THEN
            l_Immediate_Or_Deferred := 'N';              --no update for views
        END IF;

        SELECT Nat_Id_Seq.NEXTVAL INTO l_Nat_Id FROM DUAL;

        l_Nat.Nat_Id := l_Nat_Id;
        l_Nat.Nat_Nt_Type := p_Nt_Type;
        l_Nat.Nat_Gty_Group_Type := p_Gty_Type;
        l_Nat.Nat_Descr :=
            'Spatial Representation of ' || p_Gty_Type || ' Groups';
        l_Nat.Nat_Seq_No := 1;
        l_Nat.Nat_Start_Date :=
            TO_DATE (SYS_CONTEXT ('NM3CORE', 'EFFECTIVE_DATE'),
                     'DD-MON-YYYY');
        l_Nat.Nat_End_Date := NULL;
        l_Nat.Nat_Shape_Type := 'TRACED';

        BEGIN
            INSERT INTO Nm_Area_Types (Nat_Id,
                                       Nat_Nt_Type,
                                       Nat_Gty_Group_Type,
                                       Nat_Descr,
                                       Nat_Seq_No,
                                       Nat_Start_Date,
                                       Nat_End_Date,
                                       Nat_Shape_Type)
                 VALUES (l_Nat.Nat_Id,
                         l_Nat.Nat_Nt_Type,
                         l_Nat.Nat_Gty_Group_Type,
                         l_Nat.Nat_Descr,
                         l_Nat.Nat_Seq_No,
                         l_Nat.Nat_Start_Date,
                         l_Nat.Nat_End_Date,
                         l_Nat.Nat_Shape_Type);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
                SELECT nat.Nat_Id
                  INTO l_Nat_Id
                  FROM Nm_Area_Types nat
                 WHERE     nat.Nat_Nt_Type = p_Nt_Type
                       AND nat.Nat_Gty_Group_Type = p_Gty_Type;
        END;

        Retval := Nm3Seq.Next_Nth_Theme_Id_Seq;

        -- generate the theme
        l_Nth_Id := Retval;
        l_Nth.Nth_Theme_Id := l_Nth_Id;
        l_Nth.Nth_Theme_Name := l_Name;
        l_Nth.Nth_Table_Name := p_Table_Name;
        l_Nth.Nth_Where := NULL;
        l_Nth.Nth_Pk_Column := 'NE_ID';

        --
        -- Task ID 0107889 - Set Label Column to NE_ID for Group layer base table themes
        -- 05/10/09 AE Further restrict on the non DT theme
        --

        IF p_Base_Table_Nth IS NULL OR l_Nth.Nth_Theme_Name NOT LIKE '%DT'
        THEN
            l_Nth.Nth_Label_Column := 'NE_ID';
        ELSE
            l_Nth.Nth_Label_Column := 'NE_UNIQUE';
        END IF;

        --

        l_Nth.Nth_Rse_Table_Name := 'NM_ELEMENTS';
        l_Nth.Nth_Rse_Fk_Column := NULL;
        l_Nth.Nth_St_Chain_Column := NULL;
        l_Nth.Nth_End_Chain_Column := NULL;
        l_Nth.Nth_X_Column := NULL;
        l_Nth.Nth_Y_Column := NULL;
        l_Nth.Nth_Offset_Field := NULL;
        l_Nth.Nth_Feature_Table := p_Table_Name;
        l_Nth.Nth_Feature_Pk_Column := 'NE_ID';
        l_Nth.Nth_Feature_Fk_Column := P_Fk_Column;
        l_Nth.Nth_Xsp_Column := NULL;
        l_Nth.Nth_Feature_Shape_Column := p_Spatial_Column;
        l_Nth.Nth_Hpr_Product := 'NET';
        l_Nth.Nth_Location_Updatable := 'N';
        l_Nth.Nth_Theme_Type := 'SDO';
        l_Nth.Nth_Dependency := 'D';
        l_Nth.Nth_Storage := 'S';
        l_Nth.Nth_Update_On_Edit := l_Immediate_Or_Deferred;
        l_Nth.Nth_Use_History := 'Y';
        l_Nth.Nth_Start_Date_Column := 'START_DATE';
        l_Nth.Nth_End_Date_Column := 'END_DATE';
        l_Nth.Nth_Base_Table_Theme := p_Base_Table_Nth;
        l_Nth.Nth_Sequence_Name :=
            'NTH_' || NVL (p_Base_Table_Nth, Retval) || '_SEQ';
        l_Nth.Nth_Snap_To_Theme := 'N';
        l_Nth.Nth_Lref_Mandatory := 'N';
        l_Nth.Nth_Tolerance := 10;
        l_Nth.Nth_Tol_Units := 1;
        Nm3Ins.Ins_Nth (l_Nth);
        --
        --  Build theme gtype rowtype
        l_Rec_Ntg.Ntg_Theme_Id := l_Nth_Id;
        l_Rec_Ntg.Ntg_Seq_No := 1;
        l_Rec_Ntg.Ntg_Xml_Url := NULL;
        l_Rec_Ntg.Ntg_Gtype := '2002';
        Nm3Ins.Ins_Ntg (p_Rec_Ntg => l_Rec_Ntg);

        -- generate the link
        INSERT INTO Nm_Area_Themes (Nath_Nat_Id, Nath_Nth_Theme_Id)
             VALUES (l_Nat_Id, l_Nth_Id);

        Create_Base_Themes (l_Nth_Id, p_Base_Themes);

        IF Hig.Get_Sysopt ('REGSDELAY') = 'Y'
        THEN
            EXECUTE IMMEDIATE(   'begin '
                              || '    nm3sde.register_sde_layer( p_theme_id => '
                              || TO_CHAR (l_Nth.Nth_Theme_Id)
                              || ');'
                              || 'end;');
        END IF;

        IF p_View_Flag = 'N'
        THEN
            DECLARE
                l_Role   VARCHAR2 (30);
            BEGIN
                l_Role := Hig.Get_Sysopt ('SDONETROLE');

                IF l_Role IS NOT NULL
                THEN
                    INSERT INTO Nm_Theme_Roles (Nthr_Theme_Id,
                                                Nthr_Role,
                                                Nthr_Mode)
                         VALUES (l_Nth_Id, l_Role, 'NORMAL');
                END IF;
            END;
        END IF;

        DECLARE
            l_Type   NUMBER;
        BEGIN
            IF Nm3Net.Get_Gty_Sub_Group_Allowed (p_Gty_Type) = 'Y'
            THEN
                l_Type := 3;
            ELSE
                l_Type := 2;
            END IF;

            Create_Theme_Functions (p_Theme     => l_Nth.Nth_Theme_Id,
                                    p_Pa        => g_Network_Modules,
                                    p_Exclude   => l_Type);
        END;

        RETURN l_Nth_Id;
    END Register_Nat_Theme;

    --
    ---------------------------------------------------------------------------------------------------
    --
    FUNCTION Get_Nlt_Descr (p_Nlt_Id IN NUMBER)
        RETURN VARCHAR2
    IS
        Retval   Nm_Linear_Types.Nlt_Descr%TYPE;
    BEGIN
        BEGIN
            SELECT Nlt_Descr
              INTO Retval
              FROM Nm_Linear_Types
             WHERE Nlt_Id = p_Nlt_Id;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        RETURN Retval;
    END Get_Nlt_Descr;

    --
    -----------------------------------------------------------------------------
    --
    -- Task 0108731
    --
    FUNCTION Register_Ona_Base_Theme (
        pi_Asset_Type   IN Nm_Inv_Types.Nit_Inv_Type%TYPE,
        pi_Gtype        IN Nm_Theme_Gtypes.Ntg_Gtype%TYPE,
        pi_S_Date_Col   IN User_Tab_Columns.Column_Name%TYPE DEFAULT NULL,
        pi_E_Date_Col   IN User_Tab_Columns.Column_Name%TYPE DEFAULT NULL)
        RETURN Nm_Themes_All%ROWTYPE
    IS
        l_Rec_Nit    Nm_Inv_Types%ROWTYPE;
        l_Rec_Nth    Nm_Themes_All%ROWTYPE;
        l_Rec_Nthr   Nm_Theme_Roles%ROWTYPE;
        l_Rec_Ntg    Nm_Theme_Gtypes%ROWTYPE;

        --
        FUNCTION Derive_Shape_Col (
            pi_Table_Name   IN User_Tab_Cols.Table_Name%TYPE)
            RETURN User_Tab_Cols.Column_Name%TYPE
        IS
            l_Retval   User_Tab_Cols.Column_Name%TYPE;
        BEGIN
            BEGIN
                SELECT utc.Column_Name
                  INTO l_Retval
                  FROM User_Tab_Cols utc
                 WHERE     utc.Table_Name = pi_Table_Name
                       AND utc.Data_Type = 'SDO_GEOMETRY';
            EXCEPTION
                WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
                THEN
                    l_Retval := 'UNKNOWN';
            END;

            RETURN l_Retval;
        END Derive_Shape_Col;
    --
    BEGIN
        --
        l_Rec_Nit := Nm3Get.Get_Nit (pi_Nit_Inv_Type => pi_Asset_Type);
        --
        l_Rec_Nth.Nth_Theme_Id := Nm3Seq.Next_Nth_Theme_Id_Seq;
        l_Rec_Nth.Nth_Theme_Name :=
            UPPER (
                   SUBSTR (
                       l_Rec_Nit.Nit_Inv_Type || '-' || l_Rec_Nit.Nit_Descr,
                       1,
                       26)
                || '_TAB');

        --
        IF l_Rec_Nit.Nit_Category = 'F'
        THEN
            -- foreign table asset type
            l_Rec_Nth.Nth_Table_Name := l_Rec_Nit.Nit_Table_Name;
            l_Rec_Nth.Nth_Pk_Column := l_Rec_Nit.Nit_Foreign_Pk_Column;
            l_Rec_Nth.Nth_Label_Column := l_Rec_Nit.Nit_Foreign_Pk_Column;
            l_Rec_Nth.Nth_Feature_Table := l_Rec_Nit.Nit_Table_Name;
            l_Rec_Nth.Nth_Feature_Pk_Column :=
                l_Rec_Nit.Nit_Foreign_Pk_Column;
            l_Rec_Nth.Nth_Feature_Shape_Column :=
                Derive_Shape_Col (l_Rec_Nit.Nit_Table_Name);
        ELSE
            -- nm_inv_items_all asset type
            l_Rec_Nth.Nth_Table_Name := l_Rec_Nit.Nit_View_Name;
            l_Rec_Nth.Nth_Pk_Column := 'IIT_NE_ID';
            l_Rec_Nth.Nth_Label_Column := 'IIT_NE_ID';
            l_Rec_Nth.Nth_Feature_Table :=
                Nm3Sdm.Get_Ona_Spatial_Table (l_Rec_Nit.Nit_Inv_Type);
            l_Rec_Nth.Nth_Feature_Pk_Column := 'NE_ID';
            l_Rec_Nth.Nth_Feature_Shape_Column := 'GEOLOC';
        END IF;

        --
        l_Rec_Nth.Nth_Dependency := 'I';
        l_Rec_Nth.Nth_Update_On_Edit := 'N';

        --
        IF l_Rec_Nit.Nit_Use_Xy = 'Y'
        THEN
            l_Rec_Nth.Nth_X_Column := 'IIT_X';
            l_Rec_Nth.Nth_Y_Column := 'IIT_Y';
        END IF;

        --
        l_Rec_Nth.Nth_Hpr_Product := 'NET';
        l_Rec_Nth.Nth_Storage := 'S';
        l_Rec_Nth.Nth_Location_Updatable := 'Y';
        l_Rec_Nth.Nth_Tolerance := 10;
        l_Rec_Nth.Nth_Tol_Units := 1;
        l_Rec_Nth.Nth_Snap_To_Theme := 'N';
        l_Rec_Nth.Nth_Lref_Mandatory := 'N';
        l_Rec_Nth.Nth_Theme_Type := 'SDO';

        --
        IF L_Rec_Nit.Nit_Table_Name IS NULL
        THEN
            l_Rec_Nth.Nth_Use_History := 'Y';
            l_Rec_Nth.Nth_Start_Date_Column :=
                NVL (pi_S_Date_Col, 'START_DATE');
            l_Rec_Nth.Nth_End_Date_Column := NVL (pi_E_Date_Col, 'END_DATE');
        ELSE
            IF (pi_S_Date_Col IS NOT NULL AND pi_E_Date_Col IS NOT NULL)
            THEN
                l_Rec_Nth.Nth_Use_History := 'Y';
                l_Rec_Nth.Nth_Start_Date_Column := pi_S_Date_Col;
                l_Rec_Nth.Nth_End_Date_Column := pi_E_Date_Col;
            ELSE
                l_Rec_Nth.Nth_Use_History := 'N';
                l_Rec_Nth.Nth_Start_Date_Column := NULL;
                l_Rec_Nth.Nth_End_Date_Column := NULL;
            END IF;
        END IF;

        -- Insert new theme
        Nm3Ins.Ins_Nth (L_Rec_Nth);
        -- Insert theme gtype
        l_Rec_Ntg.Ntg_Theme_Id := l_Rec_Nth.Nth_Theme_Id;
        l_Rec_Ntg.Ntg_Gtype := pi_Gtype;
        l_Rec_Ntg.Ntg_Seq_No := 1;
        Nm3Ins.Ins_Ntg (l_Rec_Ntg);
        --
        RETURN L_Rec_Nth;
    --
    END Register_Ona_Base_Theme;

    --
    ---------------------------------------------------------------------------------------------------
    --
    -- Task 0108731
    --
    PROCEDURE Make_Ona_Inv_Spatial_Layer (
        pi_Nit_Inv_Type   IN Nm_Inv_Types.Nit_Inv_Type%TYPE,
        pi_Nth_Gtype      IN Nm_Theme_Gtypes.Ntg_Gtype%TYPE DEFAULT NULL,
        pi_S_Date_Col     IN User_Tab_Columns.Column_Name%TYPE DEFAULT NULL,
        pi_E_Date_Col     IN User_Tab_Columns.Column_Name%TYPE DEFAULT NULL)
    IS
    BEGIN
        --
        Make_Ona_Inv_Spatial_Layer (
            pi_Nit_Inv_Type   => pi_Nit_Inv_Type,
            pi_Nth_Theme_Id   =>
                Register_Ona_Base_Theme (pi_Nit_Inv_Type,
                                         pi_Nth_Gtype,
                                         pi_S_Date_Col,
                                         pi_E_Date_Col).Nth_Theme_Id,
            pi_Nth_Gtype      => pi_Nth_Gtype);
    --
    END Make_Ona_Inv_Spatial_Layer;

    --
    -------------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Create_Ona_Spatial_Idx (
        p_Nit     IN Nm_Inv_Types.Nit_Inv_Type%TYPE,
        p_Table   IN VARCHAR2)
    IS
        --bug in oracle 8 - spatial index name can only be 18 chars
        Cur_String   VARCHAR2 (2000);
    BEGIN
        Cur_String :=
               'create index ONA_'
            || P_Nit
            || '_spidx on '
            || P_Table
            || ' ( geoloc ) indextype is mdsys.spatial_index'
            || ' parameters ('
            || ''''
            || 'sdo_indx_dims=2'
            || ''''
            || ')';

        EXECUTE IMMEDIATE Cur_String;
    END Create_Ona_Spatial_Idx;

    --
    ---------------------------------------------------------------------------------------------------
    --
    PROCEDURE Make_Ona_Inv_Spatial_Layer (
        pi_Nit_Inv_Type   IN Nm_Inv_Types.Nit_Inv_Type%TYPE,
        pi_Nth_Theme_Id   IN Nm_Themes_All.Nth_Theme_Id%TYPE DEFAULT NULL,
        pi_Create_Flag    IN VARCHAR2 DEFAULT 'TRUE',
        pi_Nth_Gtype      IN Nm_Theme_Gtypes.Ntg_Gtype%TYPE DEFAULT NULL)
    /*
   Create a non-dynsegged SDO Spatial Layer for a given
   pi_nit_inv_type   => Asset Type
   pi_create_flag    => Create Asset SDO feature table
   */
    IS
        l_Nit              Nm_Inv_Types%ROWTYPE;
        l_Rec_Nith         Nm_Inv_Themes%ROWTYPE;
        l_Rec_Nth          Nm_Themes_All%ROWTYPE;
        l_Tab              VARCHAR2 (30);
        b_Create_Tab       BOOLEAN := Pi_Create_Flag = 'TRUE';
        l_Theme_Id         Nm_Themes_All.Nth_Theme_Id%TYPE;
        l_Theme_Name       Nm_Themes_All.Nth_Theme_Name%TYPE;
        l_Inv_Seq          VARCHAR2 (30);
        l_Dummy            NUMBER;
        l_Base_Table_Nth   Nm_Themes_All.Nth_Theme_Id%TYPE;
        l_Rec_Nth_Base     Nm_Themes_All%ROWTYPE;
        l_Start_Date_Col   VARCHAR2 (30);
        l_End_Date_Col     VARCHAR2 (30);
        l_View             VARCHAR2 (30);
        l_Dt_View_Pk_Col   VARCHAR2 (30);
        l_Base_Themes      Nm_Theme_Array;
        Has_Network        BOOLEAN;

        --
        FUNCTION Has_Nin
            RETURN BOOLEAN
        IS
            l_Retval   BOOLEAN;
            l_Dummy    VARCHAR2 (10);
        BEGIN
            BEGIN
                SELECT 'exists'
                  INTO l_Dummy
                  FROM Nm_Inv_Nw
                 WHERE Nin_Nit_Inv_Code = Pi_Nit_Inv_Type AND ROWNUM = 1;

                l_Retval := TRUE;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    l_Retval := FALSE;
            END;

            RETURN (l_Retval);
        END Has_Nin;

        --
        PROCEDURE Create_Objectid_Trigger (
            p_Table_Name   IN Nm_Themes_All.Nth_Feature_Table%TYPE,
            p_Theme_Id     IN Nm_Themes_All.Nth_Theme_Id%TYPE)
        IS
            l_Temp                    VARCHAR2 (1);
            l_Trigger_Name   CONSTANT User_Triggers.Trigger_Name%TYPE
                                          := p_Table_Name || '_BI_TRG' ;
        --
        BEGIN
            BEGIN
                SELECT NULL
                  INTO l_Temp
                  FROM User_Tab_Cols utc
                 WHERE     utc.Table_Name = p_Table_Name
                       AND utc.Column_Name = 'OBJECTID';

                EXECUTE IMMEDIATE   'Create Or Replace Trigger '
                                 || l_Trigger_Name
                                 || CHR (10)
                                 || 'Before Insert On '
                                 || p_Table_Name
                                 || CHR (10)
                                 || 'For Each Row '
                                 || CHR (10)
                                 || 'Begin'
                                 || CHR (10)
                                 || '  --Created By :nm3sdm.Create_Objectid_Trigger '
                                 || CHR (10)
                                 || '  --Created On :'
                                 || TO_CHAR (SYSDATE,
                                             'dd-mm-yyyy hh24:mi.ss')
                                 || CHR (10)
                                 || '  --Version    :'
                                 || g_Body_Sccsid
                                 || CHR (10)
                                 || '  Select   NTH_'
                                 || p_Theme_Id
                                 || '_SEQ.Nextval '
                                 || CHR (10)
                                 || '  Into     :NEW.Objectid'
                                 || CHR (10)
                                 || '  From     Dual;'
                                 || CHR (10)
                                 || 'End '
                                 || l_Trigger_Name
                                 || ';';
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    NULL;
            END;
        END Create_Objectid_Trigger;

        --
        PROCEDURE Populate_Xy_Sdo_Data (
            p_Asset_Type   IN Nm_Inv_Types.Nit_Inv_Type%TYPE)
        IS
        BEGIN
            -- Task 0108731
            -- Populate the XY data using the Asset type rather than
            -- row by row
            Nm3Sdo_Edit.Process_Inv_Xy_Update (pi_Inv_Type => p_Asset_Type);
        END Populate_Xy_Sdo_Data;

        --
        PROCEDURE Populate_Nm_Base_Themes (
            p_Nth_Theme_Id   IN Nm_Themes_All.Nth_Theme_Id%TYPE)
        IS
        BEGIN
            FOR i IN 1 .. l_Base_Themes.Nta_Theme_Array.LAST
            LOOP
                INSERT INTO Nm_Base_Themes (Nbth_Theme_Id, Nbth_Base_Theme)
                         VALUES (p_Nth_Theme_Id,
                                 l_Base_Themes.Nta_Theme_Array (i).Nthe_Id);
            END LOOP;
        END Populate_Nm_Base_Themes;
    --
    --

    BEGIN
        -- AE check to make sure user is unrestricted
        IF NOT User_Is_Unrestricted
        THEN
            RAISE E_Not_Unrestricted;
        END IF;

        --
        Nm_Debug.Proc_Start (G_Package_Name, 'make_ona_inv_spatial_layer');
        --
        l_Rec_Nth := Nm3Get.Get_Nth (Pi_Nth_Theme_Id => Pi_Nth_Theme_Id);
        --
        -- Task 0108890 - GIS0020 - Error when creating ONA layer
        -- Ensure the Asset views are in place
        -- RAC - correction to the task - off network assets need the asset view and not the one linking the asset to the NW.
        -- RAC - further correction - don't create an asste view when a FT asset
        ---------------------------------------------------------------
        -- Validate asset type
        ---------------------------------------------------------------
        l_Nit := Nm3Get.Get_Nit (pi_Nit_Inv_Type => pi_Nit_Inv_Type);

        IF l_Nit.Nit_Table_Name IS NULL
        THEN
            DECLARE
                View_Name   User_Views.View_Name%TYPE;
            BEGIN
                Nm3Inv_View.Create_Inv_View (Pi_Nit_Inv_Type,
                                             FALSE,
                                             View_Name);
            END;
        END IF;

        --
        --  Nm_Debug.debug_on;
        ---------------------------------------------------------------
        -- Set has network associated flag
        ---------------------------------------------------------------
        Has_Network := Has_Nin;

        IF Has_Network
        THEN
            l_Base_Themes := Get_Inv_Base_Themes (Pi_Nit_Inv_Type);
        END IF;

        ---------------------------------------------------------------
        -- Derive SDO table name
        ---------------------------------------------------------------
        IF B_Create_Tab
        THEN
            --  Nm_Debug.DEBUG ('create table for ' || l_nit.nit_inv_type);
            l_Tab := Get_Ona_Spatial_Table (l_Nit.Nit_Inv_Type);

            --
            IF     l_Rec_Nth.Nth_Use_History = 'Y'
               AND l_Rec_Nth.Nth_Start_Date_Column IS NOT NULL
               AND l_Rec_Nth.Nth_End_Date_Column IS NOT NULL
            THEN
                l_Start_Date_Col := l_Rec_Nth.Nth_Start_Date_Column;
                l_End_Date_Col := l_Rec_Nth.Nth_End_Date_Column;
            END IF;

            --
            -- mp flag set
            Create_Spatial_Table (L_Tab,
                                  TRUE,
                                  l_Start_Date_Col,
                                  l_End_Date_Col);

            -- if gtype is provided, then use it to register SDO metadata
            -- TOLERANCE???
            IF Pi_Nth_Gtype IS NOT NULL
            THEN
                l_Dummy :=
                    Nm3Sdo.Create_Sdo_Layer (Pi_Table_Name    => l_Tab,
                                             Pi_Column_Name   => 'GEOLOC',
                                             Pi_Gtype         => Pi_Nth_Gtype);
            END IF;

            ---------------------------------------------------------------
            -- Table needs a spatial index
            ---------------------------------------------------------------
            Create_Ona_Spatial_Idx (Pi_Nit_Inv_Type, L_Tab);
        -- Table already exists - check to see if it's registered
        ELSE
            IF Pi_Nth_Theme_Id IS NOT NULL AND Pi_Nth_Gtype IS NOT NULL
            THEN
                IF NOT Nm3Sdo.Is_Table_Regd (
                           P_Feature_Table   => L_Rec_Nth.Nth_Feature_Table,
                           P_Col             =>
                               L_Rec_Nth.Nth_Feature_Shape_Column)
                THEN
                    l_Dummy :=
                        Nm3Sdo.Create_Sdo_Layer (
                            Pi_Table_Name    => l_Rec_Nth.Nth_Feature_Table,
                            Pi_Column_Name   =>
                                l_Rec_Nth.Nth_Feature_Shape_Column,
                            Pi_Gtype         => Pi_Nth_Gtype);
                END IF;
            END IF;
        END IF;

        --
        IF Hig.Get_Sysopt ('REGSDELAY') = 'Y'
        THEN
            BEGIN
                EXECUTE IMMEDIATE(   'begin '
                                  || '    nm3sde.register_sde_layer( p_theme_id => '
                                  || TO_CHAR (Pi_Nth_Theme_Id)
                                  || ');'
                                  || 'end;');
            EXCEPTION
                WHEN OTHERS
                THEN
                    NULL;
            END;
        END IF;

        --
        ---------------------------------------------------------------
        -- Populate base themes for current theme
        ---------------------------------------------------------------
        IF Has_Network
        THEN
            Populate_Nm_Base_Themes (p_Nth_Theme_Id => Pi_Nth_Theme_Id);
        END IF;

        --
        IF Pi_Nth_Theme_Id IS NULL
        THEN
            ---------------------------------------------------------------
            -- Derive theme name
            ---------------------------------------------------------------
            l_Theme_Name :=
                NVL (
                    l_Nit.Nit_Short_Descr,
                       SUBSTR (l_Nit.Nit_Inv_Type || '-' || L_Nit.Nit_Descr,
                               1,
                               30)
                    || '_TAB');
            ---------------------------------------------------------------
            -- Create the theme for table
            -- ( NM_NIT_<ASSET_TYPE>_SDO )
            ---------------------------------------------------------------
            l_Theme_Id :=
                Register_Ona_Theme (l_Nit,
                                    l_Tab,
                                    'GEOLOC',
                                    NULL,
                                    SUBSTR (l_Theme_Name, 1, 26) || '_TAB');

            BEGIN
                IF Nm3Sdo.Use_Surrogate_Key = 'Y'
                THEN
                    l_Inv_Seq := Nm3Sdo.Create_Spatial_Seq (Pi_Nth_Theme_Id);
                    Create_Objectid_Trigger (
                        p_Table_Name   => l_Tab,
                        p_Theme_Id     => pi_Nth_Theme_Id);
                END IF;
            EXCEPTION
                WHEN OTHERS
                THEN
                    Hig.Raise_Ner (
                        pi_Appl      => Nm3Type.C_Hig,
                        pi_Id        => 273,
                        pi_Sqlcode   => -20001,
                        pi_Supplementary_Info   =>
                            'NTH_' || TO_CHAR (L_Theme_Id) || '_SEQ');
            END;
        ELSE
            -- Just link the theme to the inv type
            l_Rec_Nith.Nith_Nit_Id := l_Nit.Nit_Inv_Type;
            l_Rec_Nith.Nith_Nth_Theme_Id := pi_Nth_Theme_Id;
            Nm3Ins.Ins_Nith (L_Rec_Nith);

            ---------------------------------------------------------------
            -- Create surrogate key sequence if needed
            ---------------------------------------------------------------
            BEGIN
                IF Nm3Sdo.Use_Surrogate_Key = 'Y'
                THEN
                    l_Inv_Seq := Nm3Sdo.Create_Spatial_Seq (pi_Nth_Theme_Id);
                    Create_Objectid_Trigger (
                        p_Table_Name   => l_Tab,
                        p_Theme_Id     => pi_Nth_Theme_Id);
                END IF;
            EXCEPTION
                WHEN OTHERS
                THEN
                    Hig.Raise_Ner (pi_Appl      => Nm3Type.C_Hig,
                                   pi_Id        => 273,
                                   pi_Sqlcode   => -20001);
            END;
        END IF;

        --
        IF     l_Rec_Nth.Nth_Use_History = 'Y'
           AND l_Rec_Nth.Nth_Start_Date_Column IS NOT NULL
           AND l_Rec_Nth.Nth_End_Date_Column IS NOT NULL
        THEN
            ---------------------------------------------------------------
            -- Create spatial date view
            ---------------------------------------------------------------
            Create_Spatial_Date_View (l_Rec_Nth.Nth_Feature_Table,
                                      l_Rec_Nth.Nth_Start_Date_Column,
                                      l_Rec_Nth.Nth_End_Date_Column);
            ---------------------------------------------------------------
            -- Get rowtype of the base theme
            ---------------------------------------------------------------
            l_Rec_Nth_Base :=
                Nm3Get.Get_Nth (pi_Nth_Theme_Id => pi_Nth_Theme_Id);
            ---------------------------------------------------------------
            -- Create theme for View
            -- ( V_NM_ONA_<ASSET_TYPE>_SDO )
            ---------------------------------------------------------------
            l_Theme_Id :=
                Register_Ona_Theme (
                    pi_Nit             => l_Nit,
                    p_Table_Name       => 'V_' || L_Rec_Nth_Base.Nth_Feature_Table,
                    p_Spatial_Column   =>
                        l_Rec_Nth_Base.Nth_Feature_Shape_Column,
                    p_Fk_Column        => l_Rec_Nth_Base.Nth_Feature_Pk_Column,
                    p_View_Flag        => 'Y',
                    p_Pk_Column        => l_Rec_Nth_Base.Nth_Feature_Pk_Column,
                    p_Base_Table_Nth   => l_Rec_Nth_Base.Nth_Theme_Id);

            IF NOT Nm3Sdo.Is_Table_Regd (
                       p_Feature_Table   =>
                           'V_' || L_Rec_Nth_Base.Nth_Feature_Table,
                       p_Col   => l_Rec_Nth_Base.Nth_Feature_Shape_Column)
            THEN
                l_Dummy :=
                    Nm3Sdo.Create_Sdo_Layer (
                        pi_Table_Name   =>
                            'V_' || L_Rec_Nth_Base.Nth_Feature_Table,
                        pi_Column_Name   =>
                            l_Rec_Nth_Base.Nth_Feature_Shape_Column,
                        pi_Gtype   => pi_Nth_Gtype);
            END IF;

            --
            IF Hig.Get_Sysopt ('REGSDELAY') = 'Y'
            THEN
                BEGIN
                    EXECUTE IMMEDIATE(   ' begin  '
                                      || '    nm3sde.register_sde_layer( p_theme_id => '
                                      || TO_CHAR (L_Theme_Id)
                                      || ')'
                                      || '; end;');
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        NULL;
                END;
            END IF;
        --
        END IF;

        ---------------------------------------------------------------
        -- Populate base themes for current theme
        ---------------------------------------------------------------

        IF     g_Date_Views = 'Y'
           AND l_Rec_Nth.Nth_Use_History = 'Y'
           AND l_Rec_Nth.Nth_Start_Date_Column IS NOT NULL
           AND l_Rec_Nth.Nth_End_Date_Column IS NOT NULL
        THEN
            ---------------------------------------------------------------
            -- Create _DT view for attributes for Asset type
            ---------------------------------------------------------------

            l_View :=
                Create_Inv_Sdo_Join_View (
                    p_Feature_Table_Name   => l_Rec_Nth_Base.Nth_Feature_Table);

            IF L_Nit.Nit_Table_Name IS NULL
            THEN
                l_Dt_View_Pk_Col := 'IIT_NE_ID';
            ELSE
                l_Dt_View_Pk_Col := l_Rec_Nth_Base.Nth_Feature_Pk_Column;
            END IF;

            l_Theme_Id :=
                Register_Ona_Theme (
                    pi_Nit             => l_Nit,
                    p_Table_Name       => l_View,
                    p_Spatial_Column   =>
                        l_Rec_Nth_Base.Nth_Feature_Shape_Column,
                    p_Fk_Column        => l_Rec_Nth_Base.Nth_Feature_Fk_Column,
                    p_Name             =>
                           RTRIM (L_Rec_Nth_Base.Nth_Theme_Name, '_TAB')
                        || '_DT',
                    p_View_Flag        => 'Y',
                    p_Pk_Column        => l_Dt_View_Pk_Col,
                    p_Base_Table_Nth   => l_Rec_Nth_Base.Nth_Theme_Id);

            IF NOT Nm3Sdo.Is_Table_Regd (
                       p_Feature_Table   => l_View,
                       p_Col             =>
                           l_Rec_Nth_Base.Nth_Feature_Shape_Column)
            THEN
                l_Dummy :=
                    Nm3Sdo.Create_Sdo_Layer (
                        pi_Table_Name    => l_View,
                        pi_Column_Name   =>
                            l_Rec_Nth_Base.Nth_Feature_Shape_Column,
                        pi_Gtype         => pi_Nth_Gtype);
            END IF;

            --
            IF Hig.Get_Sysopt ('REGSDELAY') = 'Y'
            THEN
                BEGIN
                    EXECUTE IMMEDIATE(   ' begin  '
                                      || '    nm3sde.register_sde_layer( p_theme_id => '
                                      || TO_CHAR (L_Theme_Id)
                                      || ');'
                                      || ' end;');
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        NULL;
                END;
            END IF;

            ---------------------------------------------------------------
            -- Populate base themes for current theme
            ---------------------------------------------------------------
            IF Has_Network
            THEN
                Populate_Nm_Base_Themes (p_Nth_Theme_Id => l_Theme_Id);
            END IF;
        --
        END IF;

        --
        ---------------------------------------------------------------
        -- Populate Layer table (if any data availible)
        ---------------------------------------------------------------
        IF l_Nit.Nit_Use_Xy = 'Y'
        THEN
            -- Task 0108731
            -- Populate the XY data using the Asset type rather than
            -- row by row
            Populate_Xy_Sdo_Data (p_Asset_Type => l_Nit.Nit_Inv_Type);
        END IF;

        ---------------------------------------------------------------
        -- Analyze spatial table
        ---------------------------------------------------------------
        BEGIN
            Nm3Ddl.Analyse_Table (
                pi_Table_Name            => l_Rec_Nth.Nth_Feature_Table,
                pi_Schema                =>
                    SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER'),
                pi_Estimate_Percentage   => NULL,
                pi_Auto_Sample_Size      => FALSE);
        EXCEPTION
            WHEN OTHERS
            THEN
                RAISE E_No_Analyse_Privs;
        END;

        --
        Nm_Debug.Proc_End (G_Package_Name, 'make_ona_inv_spatial_layer');
    --
    EXCEPTION
        WHEN E_Not_Unrestricted
        THEN
            Raise_Application_Error (
                -20777,
                'Restricted users are not permitted to create SDO layers');
        WHEN E_No_Analyse_Privs
        THEN
            Raise_Application_Error (
                -20778,
                   'Layer created - but user does not have ANALYZE ANY granted. '
                || 'Please ensure the correct role/privs are applied to the user');
    --
    END Make_Ona_Inv_Spatial_Layer;

    --
    -------------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Create_Inv_Spatial_Idx (
        p_Nit     IN Nm_Inv_Types.Nit_Inv_Type%TYPE,
        p_Table   IN VARCHAR2)
    IS
        --bug in oracle 8 - spatial index name can only be 18 chars
        Cur_String   VARCHAR2 (2000);
    BEGIN
        Cur_String :=
               'create index NIT_'
            || p_Nit
            || '_spidx on '
            || p_Table
            || ' ( geoloc ) indextype is mdsys.spatial_index'
            || ' parameters ('
            || ''''
            || 'sdo_indx_dims=2'
            || ''''
            || ')';

        EXECUTE IMMEDIATE Cur_String;
    END Create_Inv_Spatial_Idx;

    --
    ---------------------------------------------------------------------------------------------------
    --

    --  Create a dynsegged SDO Spatial layer for a given
    --  pi_nit_inv_type  => Asset type
    --  pi_create_flag   => Create Asset SDO feature table flag
    --  pi_base_layer    => Layer to dynseg to

    PROCEDURE Make_Inv_Spatial_Layer (
        pi_Nit_Inv_Type   IN Nm_Inv_Types.Nit_Inv_Type%TYPE,
        pi_Create_Flag    IN VARCHAR2 DEFAULT 'TRUE',
        p_Job_Id          IN NUMBER DEFAULT NULL)
    IS
        l_Nit                Nm_Inv_Types%ROWTYPE;
        lcur                 Nm3Type.Ref_Cursor;
        l_Base               Nm_Themes_All.Nth_Theme_Id%TYPE;
        l_Tab                VARCHAR2 (30);
        l_Base_Table         VARCHAR2 (30);
        l_View               VARCHAR2 (30);
        l_Inv_Seq            VARCHAR2 (30);
        l_Base_Table_Theme   Nm_Themes_All.Nth_Theme_Id%TYPE;
        l_Geom               MDSYS.Sdo_Geometry;
        l_Ne                 Nm_Elements.Ne_Id%TYPE;
        l_Theme_Id           Nm_Themes_All.Nth_Theme_Id%TYPE;
        l_Base_Themes        Nm_Theme_Array;
        l_Theme_Name         Nm_Themes_All.Nth_Theme_Name%TYPE;
        l_Diminfo            MDSYS.Sdo_Dim_Array;
        l_Srid               NUMBER;
        l_Usgm               User_Sdo_Geom_Metadata%ROWTYPE;
        l_Themes             Int_Array := Nm3Array.Init_Int_Array;
        l_Inv_View_Name      VARCHAR2 (30);
    BEGIN
        -- AE check to make sure user is unrestricted
        IF NOT User_Is_Unrestricted
        THEN
            RAISE E_Not_Unrestricted;
        END IF;

        ---------------------------------------------------------------
        -- Validate asset type
        ---------------------------------------------------------------
        l_Nit := Nm3Get.Get_Nit (pi_Nit_Inv_Type => pi_Nit_Inv_Type);
        ---------------------------------------------------------------
        -- Derive SDO table name
        ---------------------------------------------------------------
        l_Tab := Get_Inv_Spatial_Table (l_Nit.Nit_Inv_Type);

        ---------------------------------------------------------------
        -- Derive base layers to dynseg and Validate base layer
        ---------------------------------------------------------------

        l_Base_Themes := Get_Inv_Base_Themes (pi_Nit_Inv_Type);

        Nm3Sdo.Set_Diminfo_And_Srid (l_Base_Themes, l_Diminfo, l_Srid);

        IF l_Nit.Nit_Pnt_Or_Cont = 'P'
        THEN
            l_Diminfo := SDO_LRS.Convert_To_Std_Dim_Array (l_Diminfo);
        END IF;

        --RAC - only create inv views for FT asset type
        IF     l_Nit.Nit_Table_Name IS NULL
           AND NOT Nm3Ddl.Does_Object_Exist (
                       Nm3Inv_View.Derive_Inv_Type_View_Name (
                           Pi_Nit_Inv_Type),
                       'VIEW',
                       SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER'))
        THEN
            Nm3Inv_View.Create_Inv_View (Pi_Nit_Inv_Type,
                                         FALSE,
                                         L_Inv_View_Name);
        END IF;

        ---------------------------------------------------------------
        -- Create the table and history view
        ---------------------------------------------------------------
        IF pi_Create_Flag = 'TRUE'
        THEN
            IF l_Nit.Nit_Table_Name IS NOT NULL
            THEN
                Create_Spatial_Table (l_Tab,
                                      FALSE,
                                      'START_DATE',
                                      'END_DATE');
            ELSE
                Create_Spatial_Table (l_Tab,
                                      FALSE,
                                      'START_DATE',
                                      'END_DATE');
            END IF;
        END IF;

        ---------------------------------------------------------------
        -- Create spatial date view
        ---------------------------------------------------------------
        Create_Spatial_Date_View (l_Tab);
        ---------------------------------------------------------------
        -- Derive theme name
        ---------------------------------------------------------------
        l_Theme_Name :=
            NVL (
                l_Nit.Nit_Short_Descr,
                SUBSTR (l_Nit.Nit_Inv_Type || '-' || l_Nit.Nit_Descr, 1, 30));

        ---------------------------------------------------------------
        -- Set the registration of metadata
        ---------------------------------------------------------------
        l_Usgm.Table_Name := l_Tab;
        l_Usgm.Column_Name := 'GEOLOC';
        l_Usgm.Diminfo := l_Diminfo;
        l_Usgm.Srid := l_Srid;

        Nm3Sdo.Ins_Usgm (l_Usgm);
        ---------------------------------------------------------------
        -- Create the theme for table
        -- ( NM_NIT_<ASSET_TYPE>_SDO )
        ---------------------------------------------------------------
        l_Theme_Id :=
            Register_Inv_Theme (
                pi_Nit             => l_Nit,
                p_Base_Themes      => l_Base_Themes,
                p_Table_Name       => l_Tab,
                p_Spatial_Column   => 'GEOLOC',
                p_Fk_Column        => 'NE_ID',
                p_Name             => SUBSTR (l_Theme_Name, 1, 26) || '_TAB');
        l_Base_Table_Theme := l_Theme_Id;

        l_Themes.Ia (1) := l_Theme_Id;

        ---------------------------------------------------------------
        -- Create surrogate key sequence if needed
        ---------------------------------------------------------------
        IF Nm3Sdo.Use_Surrogate_Key = 'Y'
        THEN
            l_Inv_Seq := Nm3Sdo.Create_Spatial_Seq (l_Theme_Id);
        END IF;

        ---------------------------------------------------------------
        -- Create theme for View
        -- ( V_NM_NIT_<ASSET_TYPE>_SDO )
        ---------------------------------------------------------------
        l_Theme_Id :=
            Nm3Sdo.Clone_Layer (l_Base_Table_Theme, 'V_' || l_Tab, 'GEOLOC');

        l_Theme_Id :=
            Register_Inv_Theme (pi_Nit             => l_Nit,
                                p_Base_Themes      => l_Base_Themes,
                                p_Table_Name       => 'V_' || l_Tab,
                                p_Spatial_Column   => 'GEOLOC',
                                p_Fk_Column        => 'NE_ID',
                                p_Name             => l_Theme_Name,
                                p_View_Flag        => 'Y',
                                p_Base_Table_Nth   => l_Base_Table_Theme);

        l_Themes := l_Themes.Add_Element (l_Theme_Id);

        ---------------------------------------------------------------
        -- Need a join view between spatial table history view and Inv view
        ---------------------------------------------------------------
        l_View := Create_Inv_Sdo_Join_View (l_Tab);

        ---------------------------------------------------------------
        -- Create SDO metadata for the attribute joined view
        --  ( V_NM_NIT_<ASSET_TYPE>_SDO_DT )
        ---------------------------------------------------------------
        l_Theme_Id :=
            Nm3Sdo.Clone_Layer (l_Base_Table_Theme, l_View, 'GEOLOC');
        ---------------------------------------------------------------
        -- For now, register both the join view and the base layer
        ---------------------------------------------------------------
        l_Theme_Name :=
               SUBSTR (
                   NVL (l_Nit.Nit_Short_Descr,
                        l_Nit.Nit_Inv_Type || '-' || L_Nit.Nit_Descr),
                   1,
                   27)
            || '_DT';

        ---------------------------------------------------------------
        -- Make the view layer dependent on the parent asset shape
        ---------------------------------------------------------------
        IF g_Date_Views = 'Y'
        THEN
            l_Theme_Id :=
                Register_Inv_Theme (pi_Nit             => l_Nit,
                                    p_Base_Themes      => l_Base_Themes,
                                    p_Table_Name       => l_View,
                                    p_Spatial_Column   => 'GEOLOC',
                                    p_Fk_Column        => 'IIT_NE_ID',
                                    p_Name             => l_Theme_Name,
                                    p_View_Flag        => 'Y',
                                    p_Pk_Column        => 'IIT_NE_ID',
                                    p_Base_Table_Nth   => l_Base_Table_Theme);

            l_Themes := l_Themes.Add_Element (l_Theme_Id);
        END IF;

        ---------------------------------------------------------------
        -- Populate the SDO table and create (clone) the SDO metadata
        -- for table and date tracked view
        --   (   NM_NIT_<ASSET_TYPE>_SDO )
        --   ( V_NM_NIT_<ASSET_TYPE>_SDO )
        ---------------------------------------------------------------

        IF pi_Create_Flag = 'TRUE'
        THEN
            Nm3Sdo.Create_Inv_Data (p_Table_Name    => l_Tab,
                                    p_Inv_Type      => pi_Nit_Inv_Type,
                                    p_Seq_Name      => l_Inv_Seq,
                                    p_Pnt_Or_Cont   => l_Nit.Nit_Pnt_Or_Cont,
                                    p_Job_Id        => p_Job_Id);
        END IF;

        ---------------------------------------------------------------
        -- Table needs a spatial index
        ---------------------------------------------------------------
        Create_Inv_Spatial_Idx (pi_Nit_Inv_Type, l_Tab);

        ---------------------------------------------------------------
        -- Analyze spatial table
        ---------------------------------------------------------------

        BEGIN
            Nm3Ddl.Analyse_Table (
                pi_Table_Name            => l_Tab,
                pi_Schema                =>
                    SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER'),
                pi_Estimate_Percentage   => NULL,
                pi_Auto_Sample_Size      => FALSE);
        EXCEPTION
            WHEN OTHERS
            THEN
                RAISE E_No_Analyse_Privs;
        END;

        --
        Nm_Debug.Proc_End (G_Package_Name, 'make_ona_inv_spatial_layer');
    --
    EXCEPTION
        WHEN E_Not_Unrestricted
        THEN
            Raise_Application_Error (
                -20777,
                'Restricted users are not permitted to create SDO layers');
        WHEN E_No_Analyse_Privs
        THEN
            Raise_Application_Error (
                -20778,
                   'Layer created - but user does not have ANALYZE ANY granted. '
                || 'Please ensure the correct role/privs are applied to the user');
    END Make_Inv_Spatial_Layer;

    --
    ---------------------------------------------------------------------------------------------------
    --
    FUNCTION Get_Datum_Layer_From_Gty (
        p_Gty   IN Nm_Linear_Types.Nlt_Gty_Type%TYPE)
        RETURN Nm_Theme_Array
    IS
        Retval   Nm_Theme_Array := Nm3Array.Init_Nm_Theme_Array;
    BEGIN
        SELECT Nm_Theme_Entry (Nnth_Nth_Theme_Id)
          BULK COLLECT INTO Retval.Nta_Theme_Array
          FROM Nm_Nw_Themes Nnt, Nm_Linear_Types Nlt, Nm_Nt_Groupings_All Nng
         WHERE     Nlt.Nlt_Id = Nnt.Nnth_Nlt_Id
               AND Nlt.Nlt_Nt_Type = Nng.Nng_Nt_Type
               AND Nng.Nng_Group_Type = p_Gty;

        IF Retval.Nta_Theme_Array (1).Nthe_Id IS NULL
        THEN
            Hig.Raise_Ner (Pi_Appl      => Nm3Type.C_Hig,
                           Pi_Id        => 195,
                           Pi_Sqlcode   => -20001);
        END IF;

        RETURN Retval;
    END Get_Datum_Layer_From_Gty;

    --
    ---------------------------------------------------------------------------------------------------
    --
    PROCEDURE Make_Datum_Layer_Dt (
        pi_Nth_Theme_Id        IN Nm_Themes_All.Nth_Theme_Id%TYPE,
        pi_New_Feature_Table   IN Nm_Themes_All.Nth_Feature_Table%TYPE DEFAULT NULL)
    IS
        ---------------------------------------------------------------------------
        -- This procedure is designed to create a date tracked view of a given Datum
        --SDO layer.
        --It creates the view, metadata, theme. Renames base table to _TABLE.
        --This is required so that MSV can display current shapes, as it is unable
        --to perform a join back to nm_elements
        ---------------------------------------------------------------------------
        --
        e_Not_Datum_Layer      EXCEPTION;
        e_New_Ft_Exists        EXCEPTION;
        e_Already_Base_Theme   EXCEPTION;
        e_Used_As_Base_Theme   EXCEPTION;
        --
        lf                     VARCHAR2 (5) := CHR (10);
        l_New_Table_Name       Nm_Themes_All.Nth_Feature_Table%TYPE;
        l_View_Sql             Nm3Type.Max_Varchar2;
        l_Rec_Nth              Nm_Themes_All%ROWTYPE;
        l_Rec_New_Nth          Nm_Themes_All%ROWTYPE;
        l_Rec_Nthr             Nm_Theme_Roles%ROWTYPE;

        --
        FUNCTION Is_Datum_Layer (
            pi_Nth_Theme_Id   IN Nm_Themes_All.Nth_Theme_Id%TYPE)
            RETURN BOOLEAN
        IS
            l_Dummy    PLS_INTEGER;
            l_Retval   BOOLEAN := TRUE;
        BEGIN
            BEGIN
                --
                SELECT nta.Nth_Theme_Id
                  INTO l_Dummy
                  FROM Nm_Themes_All nta
                 WHERE     EXISTS
                               (SELECT NULL
                                  FROM Nm_Nw_Themes nnt
                                 WHERE     nta.Nth_Theme_Id =
                                           nnt.Nnth_Nth_Theme_Id
                                       AND EXISTS
                                               (SELECT NULL
                                                  FROM Nm_Linear_Types
                                                 WHERE     Nlt_Id =
                                                           Nnth_Nlt_Id
                                                       AND Nlt_G_I_D = 'D'))
                       AND Nth_Theme_Id = pi_Nth_Theme_Id;
            --
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    l_Retval := FALSE;
            END;

            RETURN (l_Retval);
        END Is_Datum_Layer;

        --
        FUNCTION Used_As_A_Base_Theme (
            pi_Theme_Id   IN Nm_Themes_All.Nth_Theme_Id%TYPE)
            RETURN BOOLEAN
        IS
            l_Dummy    VARCHAR2 (1);
            l_Retval   BOOLEAN := TRUE;
        BEGIN
            BEGIN
                SELECT NULL
                  INTO l_Dummy
                  FROM Nm_Themes_All
                 WHERE Nth_Base_Table_Theme = pi_Theme_Id;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    l_Retval := FALSE;
            END;

            RETURN (l_Retval);
        END Used_As_A_Base_Theme;
    --
    BEGIN
        ---------------------------------------------------------------------------
        -- Check to make sure user is unrestricted
        ---------------------------------------------------------------------------
        IF NOT User_Is_Unrestricted
        THEN
            RAISE e_Not_Unrestricted;
        END IF;

        ---------------------------------------------------------------------------
        -- Make sure theme passed in is a datum layer
        ---------------------------------------------------------------------------
        l_Rec_Nth := Nm3Get.Get_Nth (pi_Nth_Theme_Id => pi_Nth_Theme_Id);

        IF NOT Is_Datum_Layer (pi_Nth_Theme_Id)
        THEN
            RAISE e_Not_Datum_Layer;
        END IF;

        ---------------------------------------------------------------------------
        -- Check to make sure the Theme passed in a view based theme!
        ---------------------------------------------------------------------------
        IF l_Rec_Nth.Nth_Base_Table_Theme IS NOT NULL
        THEN
            RAISE e_Already_Base_Theme;
        END IF;

        IF Used_As_A_Base_Theme (pi_Nth_Theme_Id)
        THEN
            RAISE e_Used_As_Base_Theme;
        END IF;

        --
        ---------------------------------------------------------------------------
        -- Rename datum table
        ---------------------------------------------------------------------------
        l_New_Table_Name :=
            NVL (pi_New_Feature_Table,
                 UPPER (l_Rec_Nth.Nth_Feature_Table) || '_TABLE');

        IF Nm3Ddl.Does_Object_Exist (l_New_Table_Name)
        THEN
            RAISE e_New_Ft_Exists;
        END IF;

        EXECUTE IMMEDIATE   'RENAME '
                         || l_Rec_Nth.Nth_Feature_Table
                         || ' TO '
                         || l_New_Table_Name;

        ---------------------------------------------------------------------------
        --Create SDO metadata for renamed feature table
        ---------------------------------------------------------------------------
        EXECUTE IMMEDIATE   'INSERT INTO user_sdo_geom_metadata'
                         || Lf
                         || ' (SELECT '
                         || Nm3Flx.String (l_New_Table_Name)
                         || Lf
                         || '       , column_name, diminfo, srid '
                         || Lf
                         || '    FROM user_sdo_geom_metadata '
                         || Lf
                         || '   WHERE table_name  = '
                         || Nm3Flx.String (l_Rec_Nth.Nth_Feature_Table)
                         || Lf
                         || '     AND column_name = '
                         || Nm3Flx.String (
                                l_Rec_Nth.Nth_Feature_Shape_Column)
                         || ')';

        ---------------------------------------------------------------------------
        -- Create date based view
        ---------------------------------------------------------------------------
        l_View_Sql :=
               'CREATE OR REPLACE FORCE VIEW '
            || l_Rec_Nth.Nth_Feature_Table
            || Lf
            || 'AS'
            || Lf
            || 'SELECT sdo.*'
            || Lf
            || '  FROM '
            || l_New_Table_Name
            || ' sdo '
            || Lf
            || ' WHERE EXISTS ( SELECT 1 FROM nm_elements ne '
            || Lf
            || ' WHERE ne.ne_id = sdo.'
            || l_Rec_Nth.Nth_Feature_Pk_Column
            || ')';

        EXECUTE IMMEDIATE L_View_Sql;

        ---------------------------------------------------------------------------
        -- Create new theme - but to maintain foreign keys, we need to update the old one
        -- so that it points to the new feature table using base theme
        ---------------------------------------------------------------------------

        l_Rec_New_Nth := l_Rec_Nth;
        l_Rec_New_Nth.Nth_Theme_Id := Nm3Seq.Next_Nth_Theme_Id_Seq;
        l_Rec_New_Nth.Nth_Theme_Name :=
            l_Rec_New_Nth.Nth_Theme_Name || '_TAB';
        l_Rec_New_Nth.Nth_Feature_Table := l_New_Table_Name;

        Nm3Ins.Ins_Nth (l_Rec_New_Nth);

        INSERT INTO Nm_Nw_Themes (Nnth_Nlt_Id, Nnth_Nth_Theme_Id)
            SELECT Nnth_Nlt_Id, l_Rec_New_Nth.Nth_Theme_Id
              FROM Nm_Nw_Themes
             WHERE Nnth_Nth_Theme_Id = l_Rec_Nth.Nth_Theme_Id;

        ---------------------------------------------------------------------------
        -- Update (now the) view theme to point to new table
        ---------------------------------------------------------------------------
        BEGIN
            UPDATE Nm_Themes_All
               SET Nth_Base_Table_Theme = l_Rec_New_Nth.Nth_Theme_Id
             WHERE Nth_Theme_Id = pi_Nth_Theme_Id;
        END;

        ---------------------------------------------------------------------------
        --  Update the NM_BASE_THEME record to point at the base table theme
        --  where the base theme is incorrectly set to a view based theme
        ---------------------------------------------------------------------------
        UPDATE Nm_Base_Themes
           SET Nbth_Base_Theme =
                   (SELECT Nth_Base_Table_Theme
                      FROM Nm_Themes_All
                     WHERE Nth_Theme_Id = Nbth_Base_Theme)
         WHERE EXISTS
                   (SELECT 1
                      FROM Nm_Themes_All
                     WHERE     Nth_Theme_Id = Nbth_Base_Theme
                           AND Nth_Base_Table_Theme IS NOT NULL);

        ---------------------------------------------------------------------------
        -- Create SDE layer if needed
        ---------------------------------------------------------------------------
        IF Hig.Get_User_Or_Sys_Opt ('REGSDELAY') = 'Y'
        THEN
            EXECUTE IMMEDIATE(   ' begin  '
                              || '    nm3sde.register_sde_layer( p_theme_id => '
                              || TO_CHAR (l_Rec_New_Nth.Nth_Theme_Id)
                              || ')'
                              || '; end;');
        END IF;

        ---------------------------------------------------------------------------
        -- Touch the nm_theme_roles to action creation of subuser views + metadata
        ---------------------------------------------------------------------------
        UPDATE Nm_Theme_Roles
           SET Nthr_Role = Nthr_Role
         WHERE Nthr_Theme_Id = pi_Nth_Theme_Id;
    --
    EXCEPTION
        WHEN E_Not_Datum_Layer
        THEN
            Hig.Raise_Ner (
                pi_Appl                 => Nm3Type.C_Hig,
                pi_Id                   => 274,
                pi_Sqlcode              => -20001,
                pi_Supplementary_Info   => l_Rec_Nth.Nth_Theme_Name);
        WHEN E_New_Ft_Exists
        THEN
            Hig.Raise_Ner (pi_Appl                 => Nm3Type.C_Hig,
                           pi_Id                   => 275,
                           pi_Sqlcode              => -20001,
                           pi_Supplementary_Info   => l_New_Table_Name);
        WHEN E_Already_Base_Theme
        THEN
            Raise_Application_Error (
                -20101,
                l_Rec_Nth.Nth_Theme_Name || ' is not a base table theme');
        WHEN E_Used_As_Base_Theme
        THEN
            Raise_Application_Error (
                -20102,
                pi_Nth_Theme_Id || ' is already setup as a base table theme');
        WHEN OTHERS
        THEN
            BEGIN
                EXECUTE IMMEDIATE   'RENAME '
                                 || l_New_Table_Name
                                 || ' to '
                                 || l_Rec_Nth.Nth_Feature_Table;
            EXCEPTION
                WHEN OTHERS
                THEN
                    NULL;
            END;

            --
            BEGIN
                EXECUTE IMMEDIATE 'DROP VIEW ' || l_Rec_Nth.Nth_Feature_Table;
            EXCEPTION
                WHEN OTHERS
                THEN
                    NULL;
            END;

            --
            BEGIN
                DELETE FROM User_Sdo_Geom_Metadata
                      WHERE     Table_Name = l_New_Table_Name
                            AND Column_Name =
                                l_Rec_Nth.Nth_Feature_Shape_Column;
            EXCEPTION
                WHEN OTHERS
                THEN
                    NULL;
            END;

            --
            RAISE;
    --
    END Make_Datum_Layer_Dt;

    --
    ---------------------------------------------------------------------------------------------------
    --
    PROCEDURE Make_All_Datum_Layers_Dt
    IS
    BEGIN
        FOR i
            IN (SELECT *
                  FROM Nm_Themes_All nta
                 WHERE     EXISTS
                               (SELECT NULL
                                  FROM Nm_Nw_Themes nnt
                                 WHERE     nta.Nth_Theme_Id =
                                           nnt.Nnth_Nth_Theme_Id
                                       AND EXISTS
                                               (SELECT NULL
                                                  FROM Nm_Linear_Types nlt
                                                 WHERE     nlt.Nlt_Id =
                                                           nnt.Nnth_Nlt_Id
                                                       AND nlt.Nlt_G_I_D =
                                                           'D'))
                       AND nta.Nth_Base_Table_Theme IS NULL
                       -- AE
                       -- Make sure we don't pick up themes that are already
                       -- used as base table themes - i.e. they don't need this
                       -- running again !
                       AND NOT EXISTS
                               (SELECT NULL
                                  FROM Nm_Themes_All nta2
                                 WHERE nta.Nth_Theme_Id =
                                       nta2.Nth_Base_Table_Theme))
        LOOP
            Make_Datum_Layer_Dt (pi_Nth_Theme_Id => i.Nth_Theme_Id);
        END LOOP;
    END Make_All_Datum_Layers_Dt;

    --
    ---------------------------------------------------------------------------------------------------
    --
    FUNCTION Get_Datum_Layer_From_Route (p_Ne_Id IN Nm_Elements.Ne_Id%TYPE)
        RETURN Nm_Theme_Array
    IS
    BEGIN
        RETURN Get_Datum_Layer_From_Gty (
                   Nm3Get.Get_Ne (p_Ne_Id).Ne_Gty_Group_Type);
    END Get_Datum_Layer_From_Route;

    --
    ---------------------------------------------------------------------------------------------------
    --
    FUNCTION Get_Datum_Layer_From_Nlt (
        p_Nlt_Id   IN Nm_Linear_Types.Nlt_Id%TYPE)
        RETURN Nm_Theme_Array
    IS
        Nltrow   Nm_Linear_Types%ROWTYPE := Nm3Get.Get_Nlt (p_Nlt_Id);
    BEGIN
        RETURN Get_Datum_Layer_From_Gty (Nltrow.Nlt_Gty_Type);
    END Get_Datum_Layer_From_Nlt;

    --
    ---------------------------------------------------------------------------------------------------
    --
    FUNCTION Element_Exists_In_Theme (p_Ne_Id               IN Nm_Elements.Ne_Id%TYPE,
                                      p_Feature_Table       IN VARCHAR2,
                                      p_Feature_Fk_Column   IN VARCHAR2)
        RETURN BOOLEAN
    IS
        TYPE Curtyp IS REF CURSOR;

        In_Theme     Curtyp;
        Cur_String   VARCHAR2 (2000)
            :=    'select 1 from '
               || P_Feature_Table
               || ' where '
               || P_Feature_Fk_Column
               || ' = :c_ne_id';
        l_Dummy      NUMBER;
        Retval       BOOLEAN;
    BEGIN
        OPEN In_Theme FOR Cur_String USING p_Ne_Id;

        FETCH In_Theme INTO l_Dummy;

        Retval := In_Theme%FOUND;

        CLOSE In_Theme;

        RETURN Retval;
    END Element_Exists_In_Theme;

    --
    -------------------------------------------------------------------------------------------------------------------------------------
    --
    FUNCTION Prevent_Operation (p_Ne_Id IN Nm_Elements.Ne_Id%TYPE)
        RETURN BOOLEAN
    IS
        Retval   BOOLEAN := FALSE;
    --
    BEGIN
        -- look for an independent SDE theme for this network type
        FOR Irec
            IN (SELECT Nth.Nth_Theme_Id,
                       Nth.Nth_Feature_Table,
                       Nth.Nth_Feature_Fk_Column
                  FROM Nm_Nw_Themes     Nwt,
                       Nm_Elements_All  Ne,
                       Nm_Themes_All    Nth,
                       Nm_Linear_Types  Nlt
                 WHERE     Ne.Ne_Id = p_Ne_Id
                       AND Nwt.Nnth_Nlt_Id = Nlt.Nlt_Id
                       AND Nwt.Nnth_Nth_Theme_Id = Nth.Nth_Theme_Id
                       AND Nlt.Nlt_Nt_Type = Ne.Ne_Nt_Type
                       AND DECODE (Nlt.Nlt_G_I_D,
                                   'D', 'NOT_USED',
                                   'G', Ne.Ne_Gty_Group_Type) =
                           DECODE (Nlt.Nlt_G_I_D,
                                   'D', 'NOT_USED',
                                   'G', Nlt.Nlt_Gty_Type)
                       AND Nth.Nth_Theme_Type = 'SDE'
                       AND Nth.Nth_Storage = 'S'
                       AND Nth.Nth_Dependency = 'I')
        LOOP
            IF Element_Exists_In_Theme (
                   p_Ne_Id               => p_Ne_Id,
                   p_Feature_Table       => Irec.Nth_Feature_Table,
                   p_Feature_Fk_Column   => Irec.Nth_Feature_Fk_Column)
            THEN
                Retval := TRUE;
                EXIT;
            END IF;
        END LOOP;

        RETURN Retval;
    END Prevent_Operation;

    --
    -------------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Remove_Element_Shapes (p_Ne_Id IN Nm_Elements.Ne_Id%TYPE)
    IS
    --
    BEGIN
        --
        FOR Irec
            IN (SELECT nta.Nth_Theme_Id,
                       nta.Nth_Feature_Table,
                       nta.Nth_Feature_Pk_Column
                  FROM Nm_Themes_All    nta,
                       Nm_Nw_Themes     nnt,
                       Nm_Linear_Types  nlt,
                       Nm_Elements      ne
                 WHERE     nlt.Nlt_Id = nnt.Nnth_Nlt_Id
                       AND nta.Nth_Theme_Id = nnt.Nnth_Nth_Theme_Id
                       AND nlt.Nlt_Nt_Type = ne.Ne_Nt_Type
                       AND NVL (nlt.Nlt_Gty_Type, Nm3Type.Get_Nvl) =
                           NVL (ne.Ne_Gty_Group_Type, Nm3Type.Get_Nvl)
                       AND ne.Ne_Id = p_Ne_Id)
        LOOP
            --
            EXECUTE IMMEDIATE   'DELETE FROM '
                             || Irec.Nth_Feature_Table
                             || ' WHERE '
                             || Irec.Nth_Feature_Pk_Column
                             || ' = :ne_id'
                USING p_Ne_Id;
        END LOOP;
    --
    END Remove_Element_Shapes;

    --
    -------------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Regenerate_Affected_Shapes (
        p_Nm_Type       IN Nm_Members.Nm_Type%TYPE,
        p_Nm_Obj_Type   IN Nm_Members.Nm_Obj_Type%TYPE,
        p_Ne_Id         IN Nm_Elements.Ne_Id%TYPE)
    IS
        Inv_Upd   VARCHAR2 (2000)
            :=    'update :table_name '
               || 'set :shape_col = nm3sdm.get_shape_from_ne( :ne_id ) '
               || 'where :ne_col = :ne_id';
        Nw_Upd    VARCHAR2 (2000)
            :=    'update :table_name '
               || 'set :shape_col = nm3sdm.get_route_shape( :ne_id ) '
               || 'where :ne_col = :ne_id';
    BEGIN
        IF P_Nm_Type = 'I'
        THEN
            FOR Irec
                IN (SELECT nta.Nth_Theme_Id,
                           nta.Nth_Feature_Table,
                           nta.Nth_Feature_Shape_Column,
                           nta.Nth_Feature_Fk_Column
                      FROM Nm_Inv_Themes nit, Nm_Themes_All nta
                     WHERE     nit.Nith_Nth_Theme_Id = nta.Nth_Theme_Id
                           AND nit.Nith_Nit_Id = p_Nm_Obj_Type)
            LOOP
                EXECUTE IMMEDIATE Inv_Upd
                    USING Irec.Nth_Feature_Table,
                          Irec.Nth_Feature_Shape_Column,
                          p_Ne_Id,
                          Irec.Nth_Feature_Fk_Column,
                          p_Ne_Id;
            END LOOP;
        ELSE
            FOR Irec
                IN (SELECT nta.Nth_Theme_Id,
                           nta.Nth_Feature_Table,
                           nta.Nth_Feature_Shape_Column,
                           nta.Nth_Feature_Fk_Column
                      FROM Nm_Nw_Themes     nnt,
                           Nm_Themes_All    nta,
                           Nm_Linear_Types  nlt
                     WHERE     nnt.Nnth_Nth_Theme_Id = nta.Nth_Theme_Id
                           AND nlt.Nlt_Id = nnt.Nnth_Nlt_Id
                           AND nlt.Nlt_Gty_Type = p_Nm_Obj_Type)
            LOOP
                EXECUTE IMMEDIATE Nw_Upd
                    USING Irec.Nth_Feature_Table,
                          Irec.Nth_Feature_Shape_Column,
                          p_Ne_Id,
                          Irec.Nth_Feature_Fk_Column,
                          p_Ne_Id;
            END LOOP;
        END IF;
    END Regenerate_Affected_Shapes;

    --
    -------------------------------------------------------------------------------------------------------------------------------------
    --
    FUNCTION Get_Ona_Spatial_Table (p_Nit IN Nm_Inv_Types.Nit_Inv_Type%TYPE)
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN 'NM_ONA_' || p_Nit || '_SDO';
    END Get_Ona_Spatial_Table;

    --
    -------------------------------------------------------------------------------------------------------
    --
    FUNCTION Get_Inv_Spatial_Table (p_Nit IN Nm_Inv_Types.Nit_Inv_Type%TYPE)
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN 'NM_NIT_' || P_Nit || '_SDO';
    END Get_Inv_Spatial_Table;

    --
    -------------------------------------------------------------------------------------------------------------------------------------
    --
    FUNCTION Get_Nt_Spatial_Table (
        p_Nt_Type    IN Nm_Types.Nt_Type%TYPE,
        p_Gty_Type   IN Nm_Group_Types.Ngt_Group_Type%TYPE DEFAULT NULL)
        RETURN VARCHAR2
    IS
        Retval   VARCHAR2 (30) := 'NM_NLT_' || p_Nt_Type;
    BEGIN
        IF p_Gty_Type IS NOT NULL
        THEN
            Retval := Retval || '_' || p_Gty_Type;
        END IF;

        Retval := Retval || '_SDO';

        RETURN Retval;
    END Get_Nt_Spatial_Table;

    --
    -------------------------------------------------------------------------------------------------------------------------------------
    --
    FUNCTION Get_Nt_View_Name (
        p_Nt_Type    IN Nm_Types.Nt_Type%TYPE,
        p_Gty_Type   IN Nm_Group_Types.Ngt_Group_Type%TYPE)
        RETURN VARCHAR2
    IS
        l_Retval   VARCHAR2 (30);
    BEGIN
        IF p_Gty_Type IS NOT NULL
        THEN
            l_Retval := 'V_NM_' || p_Nt_Type || '_' || p_Gty_Type || '_NT';
        ELSE
            l_Retval := 'V_NM_' || p_Nt_Type || '_NT';
        END IF;

        RETURN (l_Retval);
    END Get_Nt_View_Name;

    --
    ---------------------------------------------------------------------------------------------------
    --
    FUNCTION Inv_Has_Shape (p_Ne_Id      IN Nm_Elements.Ne_Id%TYPE,
                            p_Obj_Type   IN Nm_Members.Nm_Obj_Type%TYPE)
        RETURN BOOLEAN
    IS
        Nthrec       Nm_Themes_All%ROWTYPE;
        Rcur         Nm3Type.Ref_Cursor;
        Cur_String   VARCHAR2 (2000);
        Dummy        INTEGER;
        Retval       BOOLEAN := FALSE;
    BEGIN
        FOR Irec IN (SELECT nit.Nith_Nth_Theme_Id     Nth_Theme_Id
                       FROM Nm_Inv_Themes nit
                      WHERE nit.Nith_Nit_Id = p_Obj_Type)
        LOOP
            Nthrec := Get_Nth (Irec.Nth_Theme_Id);

            IF Nm3Ddl.Does_Object_Exist (
                   p_Object_Name   => Nthrec.Nth_Feature_Table)
            THEN
                Cur_String :=
                       'select 1 from '
                    || Nthrec.Nth_Feature_Table
                    || ' where '
                    || Nthrec.Nth_Feature_Pk_Column
                    || ' = :ne_val';

                OPEN Rcur FOR Cur_String USING p_Ne_Id;

                FETCH Rcur INTO Dummy;

                IF Rcur%FOUND
                THEN
                    Retval := TRUE;
                    EXIT;
                END IF;
            END IF;
        END LOOP;

        RETURN Retval;
    END Inv_Has_Shape;

    --
    ---------------------------------------------------------------------------------------------------
    --
    FUNCTION Nlt_Has_Shape (p_Ne_Id    IN Nm_Elements.Ne_Id%TYPE,
                            p_Nlt_Id   IN Nm_Linear_Types.Nlt_Id%TYPE)
        RETURN BOOLEAN
    IS
        Nthrec       Nm_Themes_All%ROWTYPE;
        Rcur         Nm3Type.Ref_Cursor;
        Cur_String   VARCHAR2 (2000);
        Dummy        INTEGER;
        Retval       BOOLEAN := FALSE;
    BEGIN
        FOR Irec IN (SELECT nnt.Nnth_Nth_Theme_Id     Nth_Theme_Id
                       FROM Nm_Nw_Themes nnt
                      WHERE nnt.Nnth_Nlt_Id = p_Nlt_Id)
        LOOP
            Nthrec := Get_Nth (Irec.Nth_Theme_Id);

            IF Nm3Ddl.Does_Object_Exist (
                   p_Object_Name   => Nthrec.Nth_Feature_Table)
            THEN
                Cur_String :=
                       'select 1 from '
                    || Nthrec.Nth_Feature_Table
                    || ' where '
                    || Nthrec.Nth_Feature_Pk_Column
                    || ' = :ne_val';

                OPEN Rcur FOR Cur_String USING p_Ne_Id;

                FETCH Rcur INTO Dummy;

                IF Rcur%FOUND
                THEN
                    Retval := TRUE;
                    EXIT;
                END IF;
            END IF;
        END LOOP;

        RETURN Retval;
    END Nlt_Has_Shape;

    --
    ---------------------------------------------------------------------------------------------------
    --
    FUNCTION Area_Has_Shape (p_Ne_Id    IN Nm_Elements.Ne_Id%TYPE,
                             p_Nat_Id   IN Nm_Area_Types.Nat_Id%TYPE)
        RETURN BOOLEAN
    IS
        Nthrec       Nm_Themes_All%ROWTYPE;
        Rcur         Nm3Type.Ref_Cursor;
        Cur_String   VARCHAR2 (2000);
        Dummy        INTEGER;
        Retval       BOOLEAN := FALSE;
    BEGIN
        FOR Irec IN (SELECT nat.Nath_Nth_Theme_Id     Nth_Theme_Id
                       FROM Nm_Area_Themes nat
                      WHERE nat.Nath_Nat_Id = p_Nat_Id)
        LOOP
            Nthrec := Get_Nth (Irec.Nth_Theme_Id);

            IF Nm3Ddl.Does_Object_Exist (
                   p_Object_Name   => Nthrec.Nth_Feature_Table)
            THEN
                Cur_String :=
                       'select 1 from '
                    || Nthrec.Nth_Feature_Table
                    || ' where '
                    || Nthrec.Nth_Feature_Pk_Column
                    || ' = :ne_val';

                OPEN Rcur FOR Cur_String USING P_Ne_Id;

                FETCH Rcur INTO Dummy;

                IF Rcur%FOUND
                THEN
                    Retval := TRUE;
                    EXIT;
                END IF;
            END IF;
        END LOOP;

        RETURN Retval;
    END Area_Has_Shape;

    --
    ---------------------------------------------------------------------------------------------------
    --
    FUNCTION Datum_Has_Shape (p_Ne_Id IN Nm_Elements.Ne_Id%TYPE)
        RETURN BOOLEAN
    IS
        Lnerec       Nm_Elements%ROWTYPE := Nm3Get.Get_Ne (p_Ne_Id);

        Nthrec       Nm_Themes_All%ROWTYPE;
        Rcur         Nm3Type.Ref_Cursor;
        Cur_String   VARCHAR2 (2000);
        Dummy        INTEGER;
        Retval       BOOLEAN := FALSE;
    BEGIN
        FOR Irec
            IN (SELECT nnt.Nnth_Nth_Theme_Id     Nth_Theme_Id
                  FROM Nm_Nw_Themes nnt, Nm_Linear_Types nlt
                 WHERE     nnt.Nnth_Nlt_Id = nlt.Nlt_Id
                       AND nlt.Nlt_Nt_Type = Lnerec.Ne_Nt_Type)
        LOOP
            Nthrec := Get_Nth (Irec.Nth_Theme_Id);

            IF Nm3Ddl.Does_Object_Exist (
                   p_Object_Name   => Nthrec.Nth_Feature_Table)
            THEN
                Cur_String :=
                       'select 1 from '
                    || Nthrec.Nth_Feature_Table
                    || ' where '
                    || Nthrec.Nth_Feature_Pk_Column
                    || ' = :ne_val';

                OPEN Rcur FOR Cur_String USING P_Ne_Id;

                FETCH Rcur INTO Dummy;

                IF Rcur%FOUND
                THEN
                    Retval := TRUE;
                    EXIT;
                END IF;
            END IF;
        END LOOP;

        RETURN Retval;
    END Datum_Has_Shape;

    --
    ---------------------------------------------------------------------------------------------------
    --
    FUNCTION Get_Nlt_Id_From_Gty (
        pi_Gty   IN Nm_Group_Types.Ngt_Group_Type%TYPE)
        RETURN Nm_Linear_Types.Nlt_Id%TYPE
    IS
        Retval   Nm_Linear_Types.Nlt_Id%TYPE;
    BEGIN
        BEGIN
            SELECT Nlt_Id
              INTO Retval
              FROM Nm_Linear_Types nlt
             WHERE nlt.Nlt_Gty_Type = pi_Gty AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        RETURN Retval;
    END Get_Nlt_Id_From_Gty;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION Get_Nat_Id_From_Gty (
        pi_Gty   IN Nm_Group_Types.Ngt_Group_Type%TYPE)
        RETURN Nm_Area_Types.Nat_Id%TYPE
    IS
        Retval   Nm_Area_Types.Nat_Id%TYPE;
    BEGIN
        BEGIN
            SELECT nat.Nat_Id
              INTO Retval
              FROM Nm_Area_Types nat
             WHERE nat.Nat_Gty_Group_Type = pi_Gty;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        RETURN Retval;
    END Get_Nat_Id_From_Gty;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION Has_Shape (p_Ne_Id      IN Nm_Elements.Ne_Id%TYPE,
                        p_Obj_Type   IN Nm_Members.Nm_Obj_Type%TYPE,
                        p_Type       IN Nm_Members.Nm_Type%TYPE DEFAULT 'I')
        RETURN BOOLEAN
    IS
        l_Nlt_Id   Nm_Linear_Types.Nlt_Id%TYPE;
        l_Nat_Id   Nm_Area_Types.Nat_Id%TYPE;
        Retval     BOOLEAN := FALSE;
    BEGIN
        IF p_Type = 'I'
        THEN
            Retval := Inv_Has_Shape (p_Ne_Id, p_Obj_Type);
        ELSIF p_Type = 'G'
        THEN
            l_Nlt_Id := Get_Nlt_Id_From_Gty (p_Obj_Type);

            IF l_Nlt_Id IS NOT NULL
            THEN
                Retval := Nlt_Has_Shape (p_Ne_Id, l_Nlt_Id);
            ELSE
                l_Nat_Id := Get_Nat_Id_From_Gty (p_Obj_Type);

                IF L_Nat_Id IS NOT NULL
                THEN
                    Retval := Area_Has_Shape (p_Ne_Id, l_Nat_Id);
                END IF;
            END IF;
        ELSIF p_Type = 'D'
        THEN
            -- datum
            Retval := Datum_Has_Shape (p_Ne_Id);
        END IF;

        RETURN Retval;
    END Has_Shape;

    --
    ---------------------------------------------------------------------------------------------------
    --
    PROCEDURE Set_Obj_Shape_End_Date (
        p_Obj_Type   IN Nm_Members.Nm_Obj_Type%TYPE,
        p_Ne_Id      IN Nm_Members.Nm_Ne_Id_In%TYPE,
        p_End_Date   IN Nm_Members.Nm_Start_Date%TYPE)
    IS
        Cur_String   VARCHAR2 (2000);
    BEGIN
        Cur_String :=
               'update '
            || Get_Inv_Spatial_Table (p_Obj_Type)
            || ' set end_date = :p_end_date '
            || ' where ne_id = :ne ';

        EXECUTE IMMEDIATE Cur_String
            USING p_End_Date, p_Ne_Id;
    END Set_Obj_Shape_End_Date;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Insert_Obj_Shape (
        p_Obj_Type     IN Nm_Members.Nm_Obj_Type%TYPE,
        p_Ne_Id        IN Nm_Members.Nm_Ne_Id_In%TYPE,
        p_Start_Date   IN Nm_Members.Nm_Start_Date%TYPE,
        p_End_Date     IN Nm_Members.Nm_Start_Date%TYPE DEFAULT NULL,
        p_Geom         IN MDSYS.Sdo_Geometry)
    IS
        Cur_String   VARCHAR2 (2000);
    BEGIN
        Cur_String :=
               'insert into '
            || Get_Inv_Spatial_Table (p_Obj_Type)
            || ' ( ne_id, geoloc, start_date, end_date )'
            || ' values ( :p_ne_id, :p_geom, :p_start_date, :p_end_date )';

        EXECUTE IMMEDIATE Cur_String
            USING p_Ne_Id,
                  p_Geom,
                  p_Start_Date,
                  p_End_Date;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
            Cur_String :=
                   'delete from '
                || Get_Inv_Spatial_Table (P_Obj_Type)
                || ' where ne_id = :p_ne_id and start_date = :p_start_date';

            EXECUTE IMMEDIATE Cur_String
                USING P_Ne_Id, P_Start_Date;

            Cur_String :=
                   'insert into '
                || Get_Inv_Spatial_Table (P_Obj_Type)
                || ' ( ne_id, geoloc, start_date, end_date )'
                || ' values ( :p_ne_id, :p_geom, :p_start_date, :p_end_date )';

            EXECUTE IMMEDIATE Cur_String
                USING P_Ne_Id,
                      P_Geom,
                      P_Start_Date,
                      P_End_Date;
    END Insert_Obj_Shape;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Update_Member_Shape (
        p_Nm_Ne_Id_In      IN Nm_Members.Nm_Ne_Id_In%TYPE,
        p_Nm_Ne_Id_Of      IN Nm_Members.Nm_Ne_Id_Of%TYPE,
        p_Nm_Obj_Type      IN Nm_Members.Nm_Obj_Type%TYPE,
        p_Old_Begin_Mp     IN Nm_Members.Nm_Begin_Mp%TYPE,
        p_New_Begin_Mp     IN Nm_Members.Nm_Begin_Mp%TYPE,
        p_Nm_End_Mp        IN Nm_Members.Nm_End_Mp%TYPE,
        p_Old_Start_Date   IN Nm_Members.Nm_Start_Date%TYPE,
        p_New_Start_Date   IN Nm_Members.Nm_Start_Date%TYPE,
        p_Nm_End_Date      IN Nm_Members.Nm_End_Date%TYPE,
        p_Nm_Type          IN Nm_Members.Nm_Type%TYPE)
    IS
    BEGIN
        IF p_Nm_Type = 'I'
        THEN
            Update_Inv_Shape (p_Nm_Ne_Id_In      => p_Nm_Ne_Id_In,
                              p_Nm_Ne_Id_Of      => p_Nm_Ne_Id_Of,
                              p_Nm_Obj_Type      => p_Nm_Obj_Type,
                              p_Old_Begin_Mp     => p_Old_Begin_Mp,
                              p_New_Begin_Mp     => p_New_Begin_Mp,
                              p_Nm_End_Mp        => p_Nm_End_Mp,
                              p_Old_Start_Date   => p_Old_Start_Date,
                              p_New_Start_Date   => p_New_Start_Date,
                              p_Nm_End_Date      => p_Nm_End_Date);
        ELSIF p_Nm_Type = 'G'
        THEN
            Update_Gty_Shape (p_Nm_Ne_Id_In      => p_Nm_Ne_Id_In,
                              p_Nm_Ne_Id_Of      => p_Nm_Ne_Id_Of,
                              p_Nm_Obj_Type      => p_Nm_Obj_Type,
                              p_Old_Begin_Mp     => p_Old_Begin_Mp,
                              p_New_Begin_Mp     => p_New_Begin_Mp,
                              p_Nm_End_Mp        => p_Nm_End_Mp,
                              p_Old_Start_Date   => p_Old_Start_Date,
                              p_New_Start_Date   => p_New_Start_Date,
                              p_Nm_End_Date      => p_Nm_End_Date);
        END IF;
    END Update_Member_Shape;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Update_Inv_Shape (
        p_Nm_Ne_Id_In      IN Nm_Members.Nm_Ne_Id_In%TYPE,
        p_Nm_Ne_Id_Of      IN Nm_Members.Nm_Ne_Id_Of%TYPE,
        p_Nm_Obj_Type      IN Nm_Members.Nm_Obj_Type%TYPE,
        p_Old_Begin_Mp     IN Nm_Members.Nm_Begin_Mp%TYPE,
        p_New_Begin_Mp     IN Nm_Members.Nm_Begin_Mp%TYPE,
        p_Nm_End_Mp        IN Nm_Members.Nm_End_Mp%TYPE,
        p_Old_Start_Date   IN Nm_Members.Nm_Start_Date%TYPE,
        p_New_Start_Date   IN Nm_Members.Nm_Start_Date%TYPE,
        p_Nm_End_Date      IN Nm_Members.Nm_End_Date%TYPE)
    IS
        Upd_String   VARCHAR2 (2000);
        l_Geom       MDSYS.Sdo_Geometry;
        l_Nit        Nm_Inv_Types%ROWTYPE := Nm3Get.Get_Nit (P_Nm_Obj_Type);
    BEGIN
        --  allow for many layers of the same asset type
        FOR Irec
            IN (SELECT nta.Nth_Feature_Table,
                       nta.Nth_Feature_Pk_Column,
                       nta.Nth_Feature_Fk_Column,
                       nbt.Nbth_Base_Theme,
                       nta.Nth_Xsp_Column
                  FROM Nm_Themes_All    nta,
                       Nm_Inv_Themes    nit,
                       Nm_Base_Themes   nbt,
                       Nm_Nw_Themes     nnt,
                       Nm_Elements      ne,
                       Nm_Linear_Types  nlt
                 WHERE     nta.Nth_Theme_Id = nit.Nith_Nth_Theme_Id
                       AND nta.Nth_Theme_Id = nbt.Nbth_Theme_Id
                       AND nit.Nith_Nit_Id = p_Nm_Obj_Type
                       AND nta.Nth_Update_On_Edit = 'I'
                       AND ne.Ne_Id = p_Nm_Ne_Id_Of
                       AND ne.Ne_Nt_Type = nlt.Nlt_Nt_Type
                       AND nnt.Nnth_Nth_Theme_Id = nbt.Nbth_Base_Theme
                       AND nlt.Nlt_Id = nnt.Nnth_Nlt_Id)
        LOOP
            Upd_String :=
                   'update '
                || Irec.Nth_Feature_Table
                || ' set geoloc = :newshape, '
                || '     nm_begin_mp = :new_begin_mp,'
                || '     nm_end_mp   = :new_end_mp, '
                || '     start_date = :new_start_date, '
                || '     end_date   = :new_end_date '
                || '  where ne_id = :ne_id'
                || ' and ne_id_of = :ne_id_of '
                || ' and nm_begin_mp = :nm_begin_mp '
                || ' and start_date  = :old_start_date ';

            IF l_Nit.Nit_Pnt_Or_Cont = 'P'
            THEN
                l_Geom :=
                    Nm3Sdo.Get_Pt_Shape_From_Ne (Irec.Nbth_Base_Theme,
                                                 p_Nm_Ne_Id_Of,
                                                 p_New_Begin_Mp);
            ELSE
                l_Geom :=
                    Nm3Sdo.Get_Shape_From_Nm (Irec.Nbth_Base_Theme,
                                              p_Nm_Ne_Id_In,
                                              p_Nm_Ne_Id_Of,
                                              p_New_Begin_Mp,
                                              p_Nm_End_Mp);
            END IF;

            -- CWS Lateral Offset change.
            IF     Irec.Nth_Xsp_Column IS NOT NULL
               AND NVL (Hig.Get_Sysopt ('XSPOFFSET'), 'N') = 'Y'
            THEN
                IF l_nit.nit_pnt_or_cont = 'P'
                THEN
                    l_Geom :=
                        SDO_LRS.convert_to_std_geom (Nm3Sdo_Dynseg.Get_Shape (
                                                         Irec.Nbth_Base_Theme,
                                                         p_Nm_Ne_Id_In,
                                                         p_Nm_Ne_Id_Of,
                                                         p_New_Begin_Mp,
                                                         p_Nm_End_Mp));
                ELSE
                    l_Geom :=
                        Nm3Sdo_Dynseg.Get_Shape (Irec.Nbth_Base_Theme,
                                                 p_Nm_Ne_Id_In,
                                                 p_Nm_Ne_Id_Of,
                                                 p_New_Begin_Mp,
                                                 p_Nm_End_Mp);
                END IF;
            END IF;

            EXECUTE IMMEDIATE Upd_String
                USING l_Geom,
                      p_New_Begin_Mp,
                      p_Nm_End_Mp,
                      p_New_Start_Date,
                      p_Nm_End_Date,
                      p_Nm_Ne_Id_In,
                      p_Nm_Ne_Id_Of,
                      p_Old_Begin_Mp,
                      p_Old_Start_Date;
        END LOOP;
    END Update_Inv_Shape;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Update_Gty_Shape (
        p_Nm_Ne_Id_In      IN Nm_Members.Nm_Ne_Id_In%TYPE,
        p_Nm_Ne_Id_Of      IN Nm_Members.Nm_Ne_Id_Of%TYPE,
        p_Nm_Obj_Type      IN Nm_Members.Nm_Obj_Type%TYPE,
        p_Old_Begin_Mp     IN Nm_Members.Nm_Begin_Mp%TYPE,
        p_New_Begin_Mp     IN Nm_Members.Nm_Begin_Mp%TYPE,
        p_Nm_End_Mp        IN Nm_Members.Nm_End_Mp%TYPE,
        p_Old_Start_Date   IN Nm_Members.Nm_Start_Date%TYPE,
        p_New_Start_Date   IN Nm_Members.Nm_Start_Date%TYPE,
        p_Nm_End_Date      IN Nm_Members.Nm_End_Date%TYPE)
    IS
        Upd_String   VARCHAR2 (2000);
        l_Geom       MDSYS.Sdo_Geometry;
    BEGIN
        --allow for many layers of the same gty type
        FOR Irec
            IN (SELECT Nth_Feature_Table,
                       Nth_Feature_Pk_Column,
                       Nth_Feature_Fk_Column,
                       Nbth_Base_Theme,
                       'G'               I_Or_G,
                       p_Nm_Obj_Type     Obj_Type
                  FROM Nm_Themes_All    nta,
                       Nm_Area_Types    nat,
                       Nm_Area_Themes   nath,
                       Nm_Base_Themes   nbt,
                       Nm_Nw_Themes     nnt,
                       Nm_Elements      ne,
                       Nm_Linear_Types  nlt
                 WHERE     nta.Nth_Theme_Id = nath.Nath_Nth_Theme_Id
                       AND nta.Nth_Theme_Id = nbt.Nbth_Theme_Id
                       AND nath.Nath_Nat_Id = nat.Nat_Id
                       AND nat.Nat_Gty_Group_Type = p_Nm_Obj_Type
                       AND nta.Nth_Theme_Type = 'SDO'
                       AND ne.Ne_Id = p_Nm_Ne_Id_Of
                       AND ne.Ne_Nt_Type = nlt.Nlt_Nt_Type
                       AND nnt.Nnth_Nth_Theme_Id = nbt.Nbth_Base_Theme
                       AND nlt.Nlt_Id = nnt.Nnth_Nlt_Id
                       AND nta.Nth_Update_On_Edit = 'I'
                UNION
                SELECT Nth_Feature_Table,
                       Nth_Feature_Pk_Column,
                       Nth_Feature_Fk_Column,
                       Nbth_Base_Theme,
                       'I',
                       Nad_Inv_Type
                  FROM Nm_Themes_All    nta,
                       Nm_Inv_Themes    nit,
                       Nm_Base_Themes   nbt,
                       Nm_Nw_Themes     nnt,
                       Nm_Elements      ne,
                       Nm_Linear_Types  nlt,
                       Nm_Nw_Ad_Types   nnat
                 WHERE     nta.Nth_Theme_Id = nit.Nith_Nth_Theme_Id
                       AND nta.Nth_Theme_Id = nbt.Nbth_Theme_Id
                       AND nnat.Nad_Gty_Type = p_Nm_Obj_Type
                       AND nnat.Nad_Inv_Type = nit.Nith_Nit_Id
                       AND nta.Nth_Theme_Type = 'SDO'
                       AND ne.Ne_Id = p_Nm_Ne_Id_Of
                       AND ne.Ne_Nt_Type = nlt.Nlt_Nt_Type
                       AND nnt.Nnth_Nth_Theme_Id = nbt.Nbth_Base_Theme
                       AND nlt.Nlt_Id = nnt.Nnth_Nlt_Id
                       AND nta.Nth_Update_On_Edit = 'I')
        LOOP
            IF Irec.I_Or_G = 'G'
            THEN
                Upd_String :=
                       'update '
                    || Irec.Nth_Feature_Table
                    || ' set geoloc = :newshape, '
                    || '     nm_begin_mp = :new_begin_mp,'
                    || '     nm_end_mp   = :new_end_mp '
                    || '  where ne_id = :ne_id'
                    || ' and ne_id_of = :ne_id_of '
                    || ' and nm_begin_mp = :nm_begin_mp '
                    || ' and end_date is null';
                l_Geom :=
                    SDO_LRS.Convert_To_Std_Geom (Nm3Sdo.Get_Shape_From_Nm (
                                                     Irec.Nbth_Base_Theme,
                                                     p_Nm_Ne_Id_In,
                                                     p_Nm_Ne_Id_Of,
                                                     p_New_Begin_Mp,
                                                     p_Nm_End_Mp));

                EXECUTE IMMEDIATE Upd_String
                    USING l_Geom,
                          p_New_Begin_Mp,
                          p_Nm_End_Mp,
                          p_Nm_Ne_Id_In,
                          p_Nm_Ne_Id_Of,
                          p_Old_Begin_Mp;
            ELSE
                Upd_String :=
                       'update '
                    || Irec.Nth_Feature_Table
                    || ' set geoloc = :newshape, '
                    || '     nm_begin_mp = :new_begin_mp,'
                    || '     nm_end_mp   = :new_end_mp '
                    || '  where ne_id in ( select nad_iit_ne_id '
                    || ' from nm_nw_ad_link '
                    || ' where nad_ne_id = :ne_id'
                    || ' and nad_gty_type =  :gty_type '
                    || ' and nad_inv_type =  :obj_type '
                    || ' and nad_whole_road = :whole_road  ) '
                    || ' and ne_id_of = :ne_id_of '
                    || ' and nm_begin_mp = :nm_begin_mp '
                    || ' and end_date is null';
                l_Geom :=
                    Nm3Sdo.Get_Shape_From_Nm (Irec.Nbth_Base_Theme,
                                              p_Nm_Ne_Id_In,
                                              p_Nm_Ne_Id_Of,
                                              p_New_Begin_Mp,
                                              p_Nm_End_Mp);

                EXECUTE IMMEDIATE Upd_String
                    USING l_Geom,
                          p_New_Begin_Mp,
                          p_Nm_End_Mp,
                          p_Nm_Ne_Id_In,
                          p_Nm_Obj_Type,
                          Irec.Obj_Type,
                          '1',
                          p_Nm_Ne_Id_Of,
                          p_Old_Begin_Mp;
            END IF;
        END LOOP;
    END Update_Gty_Shape;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE End_Member_Shape (
        p_Nm_Ne_Id_In     IN Nm_Members.Nm_Ne_Id_In%TYPE,
        p_Nm_Ne_Id_Of     IN Nm_Members.Nm_Ne_Id_Of%TYPE,
        p_Nm_Obj_Type     IN Nm_Members.Nm_Obj_Type%TYPE,
        p_Nm_Begin_Mp     IN Nm_Members.Nm_Begin_Mp%TYPE,
        p_Nm_End_Mp       IN Nm_Members.Nm_End_Mp%TYPE,
        p_Nm_Start_Date   IN Nm_Members.Nm_Start_Date%TYPE,
        p_Nm_End_Date     IN Nm_Members.Nm_End_Date%TYPE,
        p_Nm_Type         IN Nm_Members.Nm_Type%TYPE)
    IS
    BEGIN
        IF p_Nm_Type = 'I'
        THEN
            End_Inv_Shape (p_Nm_Ne_Id_In     => p_Nm_Ne_Id_In,
                           p_Nm_Ne_Id_Of     => p_Nm_Ne_Id_Of,
                           p_Nm_Obj_Type     => p_Nm_Obj_Type,
                           p_Nm_Begin_Mp     => p_Nm_Begin_Mp,
                           p_Nm_End_Mp       => p_Nm_End_Mp,
                           p_Nm_Start_Date   => p_Nm_Start_Date,
                           p_Nm_End_Date     => p_Nm_End_Date);
        ELSIF p_Nm_Type = 'G'
        THEN
            End_Gty_Shape (p_Nm_Ne_Id_In     => p_Nm_Ne_Id_In,
                           p_Nm_Ne_Id_Of     => p_Nm_Ne_Id_Of,
                           p_Nm_Obj_Type     => p_Nm_Obj_Type,
                           p_Nm_Begin_Mp     => p_Nm_Begin_Mp,
                           p_Nm_End_Mp       => p_Nm_End_Mp,
                           p_Nm_Start_Date   => p_Nm_Start_Date,
                           p_Nm_End_Date     => p_Nm_End_Date);
        END IF;
    END End_Member_Shape;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE End_Inv_Shape (
        p_Nm_Ne_Id_In     IN Nm_Members.Nm_Ne_Id_In%TYPE,
        p_Nm_Ne_Id_Of     IN Nm_Members.Nm_Ne_Id_Of%TYPE,
        p_Nm_Obj_Type     IN Nm_Members.Nm_Obj_Type%TYPE,
        p_Nm_Begin_Mp     IN Nm_Members.Nm_Begin_Mp%TYPE,
        p_Nm_End_Mp       IN Nm_Members.Nm_End_Mp%TYPE,
        p_Nm_Start_Date   IN Nm_Members.Nm_Start_Date%TYPE,
        p_Nm_End_Date     IN Nm_Members.Nm_End_Date%TYPE)
    IS
        Upd_String   VARCHAR2 (2000);
        l_Geom       MDSYS.Sdo_Geometry;
    BEGIN
        --allow for many layers of the same asset type
        FOR Irec
            IN (SELECT Nth_Feature_Table,
                       Nth_Feature_Pk_Column,
                       Nth_Feature_Fk_Column
                  FROM Nm_Themes_All nta, Nm_Inv_Themes nit
                 WHERE     nta.Nth_Theme_Id = nit.Nith_Nth_Theme_Id
                       AND nit.Nith_Nit_Id = p_Nm_Obj_Type
                       AND nta.Nth_Update_On_Edit = 'I')
        LOOP
            -- AE - 718333
            -- Include begin_mp and only operate on open shapes
            --
            -- Later change (30-MAR-09) remove the end_date check because this procedure
            -- is used for un-endating too
            Upd_String :=
                   'update '
                || Irec.Nth_Feature_Table
                || '  set end_date    = :end_date '
                || 'where ne_id       = :ne_id '
                || '  and ne_id_of    = :ne_id_of '
                || '  and nm_begin_mp = :nm_begin_mp ';

            -- AE - 718333
            -- Include begin_mp and only operate on open shapes
            -- End of changes
            --
            --RAC - Task 0111157 - the update string must update the shape end date on the basis
            --      of the actual start-date for the specific mamber that is targetted.
            --      Without this, the end-date of an asset  (hence members) will update the end-date on
            --      all shape records that have the same begin-mp - including those that are already ended.

            IF p_Nm_End_Date IS NOT NULL
            THEN
                Upd_String :=
                       Upd_String
                    || ' and end_date is null and start_date = :start_date';
            ELSE
                Upd_String := Upd_String || ' and start_date = :start_date';
            END IF;

            EXECUTE IMMEDIATE Upd_String
                USING p_Nm_End_Date,
                      p_Nm_Ne_Id_In,
                      p_Nm_Ne_Id_Of,
                      p_Nm_Begin_Mp,
                      p_Nm_Start_Date;
        END LOOP;
    END End_Inv_Shape;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE End_Gty_Shape (
        p_Nm_Ne_Id_In     IN Nm_Members.Nm_Ne_Id_In%TYPE,
        p_Nm_Ne_Id_Of     IN Nm_Members.Nm_Ne_Id_Of%TYPE,
        p_Nm_Obj_Type     IN Nm_Members.Nm_Obj_Type%TYPE,
        p_Nm_Begin_Mp     IN Nm_Members.Nm_Begin_Mp%TYPE,
        p_Nm_End_Mp       IN Nm_Members.Nm_End_Mp%TYPE,
        p_Nm_Start_Date   IN Nm_Members.Nm_Start_Date%TYPE,
        p_Nm_End_Date     IN Nm_Members.Nm_End_Date%TYPE)
    IS
        Upd_String   VARCHAR2 (2000);
        l_Geom       MDSYS.Sdo_Geometry;
        l_Ne_Id      NUMBER;
    BEGIN
        --allow for many layers of the same asset type
        FOR Irec
            IN (SELECT nta.Nth_Feature_Table,
                       nta.Nth_Feature_Pk_Column,
                       nta.Nth_Feature_Fk_Column,
                       'G'               G_Or_I,
                       p_Nm_Obj_Type     Obj_Type
                  FROM Nm_Themes_All   nta,
                       Nm_Area_Types   nat,
                       Nm_Area_Themes  nath
                 WHERE     nta.Nth_Theme_Id = nath.Nath_Nth_Theme_Id
                       AND nath.Nath_Nat_Id = nat.Nat_Id
                       AND nat.Nat_Gty_Group_Type = p_Nm_Obj_Type
                       AND nta.Nth_Theme_Type = 'SDO'
                       AND nta.Nth_Update_On_Edit = 'I'
                UNION
                SELECT nta.Nth_Feature_Table,
                       nta.Nth_Feature_Pk_Column,
                       nta.Nth_Feature_Fk_Column,
                       'I'     G_Or_I,
                       nit.Nith_Nit_Id
                  FROM Nm_Themes_All   nta,
                       Nm_Nw_Ad_Types  nat,
                       Nm_Inv_Themes   nit
                 WHERE     nta.Nth_Theme_Id = nit.Nith_Nth_Theme_Id
                       AND nit.Nith_Nit_Id = nat.Nad_Inv_Type
                       AND nat.Nad_Gty_Type = p_Nm_Obj_Type
                       AND nta.Nth_Update_On_Edit = 'I')
        LOOP
            IF Irec.G_Or_I = 'G'
            THEN
                --
                -- AE - 718333
                -- Include begin_mp and only operate on open shapes
                --
                -- Later change (30-MAR-09) remove the end_date check because this procedure
                -- is used for un-endating too
                --
                Upd_String :=
                       'update '
                    || Irec.Nth_Feature_Table
                    || '  set end_date    = :end_date '
                    || 'where ne_id       = :ne_id '
                    || '  and ne_id_of    = :ne_id_of '
                    || '  and nm_begin_mp = :nm_begin_mp ';

                -- AE - 718333
                -- Include begin_mp and only operate on open shapes
                -- End of changes

                --RAC - Task 0111157 - the update string must update the shape end date on the basis
                --      of the actual start-date for the specific mamber that is targetted.
                --      Without this, the end-date of an asset  (hence members) will update the end-date on
                --      all shape records that have the same begin-mp - including those that are already ended.

                IF P_Nm_End_Date IS NOT NULL
                THEN
                    Upd_String :=
                           Upd_String
                        || ' and end_date is null and start_date = :start_date';
                ELSE
                    Upd_String :=
                        Upd_String || ' and start_date = :start_date';
                END IF;

                EXECUTE IMMEDIATE Upd_String
                    USING p_Nm_End_Date,
                          p_Nm_Ne_Id_In,
                          p_Nm_Ne_Id_Of,
                          p_Nm_Begin_Mp,
                          p_Nm_Start_Date;
            ELSE
                --
                -- Later change (30-MAR-09) remove the end_date check because this procedure
                -- is used for un-endating too

                Upd_String :=
                       'update '
                    || Irec.Nth_Feature_Table
                    || '   set end_date = :end_date '
                    || ' where ne_id_of = :ne_id_of '
                    || ' and nm_begin_mp = :nm_begin_mp '
                    || ' and ne_id in ( select nad_iit_ne_id '
                    || ' from nm_nw_ad_link '
                    || ' where nad_gty_type   = :p_gty_type '
                    || ' and nad_inv_type   = :obj_type '
                    || ' and nad_ne_id      = :nm_ne_id_in '
                    || ' and nad_whole_road = :whole_road )';

                --
                -- AE 27-MAR-2009
                -- Pass in nm_begin_mp !!
                --

                --RAC - Task 0111157 - the update string must update the shape end date on the basis
                --      of the actual start-date for the specific mamber that is targetted.
                --      Without this, the end-date of an asset  (hence members) will update the end-date on
                --      all shape records that have the same begin-mp - including those that are already ended.

                IF P_Nm_End_Date IS NOT NULL
                THEN
                    Upd_String :=
                           Upd_String
                        || ' and end_date is null and start_date = :start_date';
                ELSE
                    Upd_String :=
                        Upd_String || ' and start_date = :start_date';
                END IF;

                EXECUTE IMMEDIATE Upd_String
                    USING p_Nm_End_Date,
                          p_Nm_Ne_Id_Of,
                          p_Nm_Begin_Mp,
                          p_Nm_Obj_Type,
                          Irec.Obj_Type,
                          p_Nm_Ne_Id_In,
                          '1',
                          p_Nm_Start_Date;
            END IF;
        END LOOP;
    END End_Gty_Shape;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Add_Member_Shape (
        p_Nm_Ne_Id_In     IN Nm_Members.Nm_Ne_Id_In%TYPE,
        p_Nm_Ne_Id_Of     IN Nm_Members.Nm_Ne_Id_Of%TYPE,
        p_Nm_Obj_Type     IN Nm_Members.Nm_Obj_Type%TYPE,
        p_Nm_Begin_Mp     IN Nm_Members.Nm_Begin_Mp%TYPE,
        p_Nm_End_Mp       IN Nm_Members.Nm_End_Mp%TYPE,
        p_Nm_Start_Date   IN Nm_Members.Nm_Start_Date%TYPE,
        p_Nm_End_Date     IN Nm_Members.Nm_End_Date%TYPE,
        p_Nm_Type         IN Nm_Members.Nm_Type%TYPE)
    IS
    BEGIN
        IF P_Nm_Type = 'I'
        THEN
            Add_Inv_Shape (p_Nm_Ne_Id_In     => p_Nm_Ne_Id_In,
                           p_Nm_Ne_Id_Of     => p_Nm_Ne_Id_Of,
                           p_Nm_Obj_Type     => p_Nm_Obj_Type,
                           p_Nm_Begin_Mp     => p_Nm_Begin_Mp,
                           p_Nm_End_Mp       => p_Nm_End_Mp,
                           p_Nm_Start_Date   => p_Nm_Start_Date,
                           p_Nm_End_Date     => p_Nm_End_Date);
        ELSIF P_Nm_Type = 'G'
        THEN
            Add_Gty_Shape (p_Nm_Ne_Id_In     => p_Nm_Ne_Id_In,
                           p_Nm_Ne_Id_Of     => p_Nm_Ne_Id_Of,
                           p_Nm_Obj_Type     => p_Nm_Obj_Type,
                           p_Nm_Begin_Mp     => p_Nm_Begin_Mp,
                           p_Nm_End_Mp       => p_Nm_End_Mp,
                           p_Nm_Start_Date   => p_Nm_Start_Date,
                           p_Nm_End_Date     => p_Nm_End_Date);
        END IF;
    END Add_Member_Shape;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Remove_Member_Shape (
        p_Nm_Ne_Id_In     IN Nm_Members.Nm_Ne_Id_In%TYPE,
        p_Nm_Ne_Id_Of     IN Nm_Members.Nm_Ne_Id_Of%TYPE,
        p_Nm_Obj_Type     IN Nm_Members.Nm_Obj_Type%TYPE,
        p_Nm_Begin_Mp     IN Nm_Members.Nm_Begin_Mp%TYPE,
        p_Nm_End_Mp       IN Nm_Members.Nm_End_Mp%TYPE,
        p_Nm_Start_Date   IN Nm_Members.Nm_Start_Date%TYPE,
        p_Nm_End_Date     IN Nm_Members.Nm_End_Date%TYPE,
        p_Nm_Type         IN Nm_Members.Nm_Type%TYPE)
    IS
    BEGIN
        IF P_Nm_Type = 'I'
        THEN
            Remove_Inv_Shape (p_Nm_Ne_Id_In     => p_Nm_Ne_Id_In,
                              p_Nm_Ne_Id_Of     => p_Nm_Ne_Id_Of,
                              p_Nm_Obj_Type     => p_Nm_Obj_Type,
                              p_Nm_Begin_Mp     => p_Nm_Begin_Mp,
                              p_Nm_End_Mp       => p_Nm_End_Mp,
                              p_Nm_Start_Date   => p_Nm_Start_Date,
                              p_Nm_End_Date     => p_Nm_End_Date);
        ELSIF P_Nm_Type = 'G'
        THEN
            Remove_Gty_Shape (p_Nm_Ne_Id_In     => p_Nm_Ne_Id_In,
                              p_Nm_Ne_Id_Of     => p_Nm_Ne_Id_Of,
                              p_Nm_Obj_Type     => p_Nm_Obj_Type,
                              p_Nm_Begin_Mp     => p_Nm_Begin_Mp,
                              p_Nm_End_Mp       => p_Nm_End_Mp,
                              p_Nm_Start_Date   => p_Nm_Start_Date,
                              p_Nm_End_Date     => p_Nm_End_Date);
        END IF;
    END Remove_Member_Shape;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Add_Inv_Shape (
        p_Nm_Ne_Id_In     IN Nm_Members.Nm_Ne_Id_In%TYPE,
        p_Nm_Ne_Id_Of     IN Nm_Members.Nm_Ne_Id_Of%TYPE,
        p_Nm_Obj_Type     IN Nm_Members.Nm_Obj_Type%TYPE,
        p_Nm_Begin_Mp     IN Nm_Members.Nm_Begin_Mp%TYPE,
        p_Nm_End_Mp       IN Nm_Members.Nm_End_Mp%TYPE,
        p_Nm_Start_Date   IN Nm_Members.Nm_Start_Date%TYPE,
        p_Nm_End_Date     IN Nm_Members.Nm_End_Date%TYPE)
    IS
        Ins_String   VARCHAR2 (2000);
        l_Geom       MDSYS.Sdo_Geometry;
        l_Nit        Nm_Inv_Types%ROWTYPE := Nm3Get.Get_Nit (p_Nm_Obj_Type);
        l_Objid      NUMBER;
    BEGIN
        --allow for many layers of the same asset type, only deal with immediate themes
        FOR Irec
            IN (SELECT nta.Nth_Theme_Id,
                       nta.Nth_Feature_Table,
                       nta.Nth_Feature_Pk_Column,
                       nta.Nth_Feature_Fk_Column,
                       nbt.Nbth_Base_Theme,
                       nta.Nth_Xsp_Column
                  FROM Nm_Themes_All    nta,
                       Nm_Inv_Themes    nit,
                       Nm_Base_Themes   nbt,
                       Nm_Nw_Themes     nnt,
                       Nm_Elements      ne,
                       Nm_Linear_Types  nlt
                 WHERE     nta.Nth_Theme_Id = nit.Nith_Nth_Theme_Id
                       AND nta.Nth_Theme_Id = nbt.Nbth_Theme_Id
                       AND nit.Nith_Nit_Id = p_Nm_Obj_Type
                       AND nta.Nth_Update_On_Edit = 'I'
                       AND ne.Ne_Id = p_Nm_Ne_Id_Of
                       AND ne.Ne_Nt_Type = nlt.Nlt_Nt_Type
                       AND nnt.Nnth_Nth_Theme_Id = nbt.Nbth_Base_Theme
                       AND nlt.Nlt_Id = nnt.Nnth_Nlt_Id)
        LOOP
            IF Nm3Sdo.Use_Surrogate_Key = 'N'
            THEN
                Ins_String :=
                       'insert into '
                    || Irec.Nth_Feature_Table
                    || ' ( ne_id, ne_id_of, nm_begin_mp, nm_end_mp, geoloc, start_date, end_date )'
                    || ' values (:ne_id, :ne_id_of, :nm_begin_mp, :nm_end_mp, :geoloc, :start_date, :end_date )';

                IF L_Nit.Nit_Pnt_Or_Cont = 'P'
                THEN
                    l_Geom :=
                        Nm3Sdo.Get_Pt_Shape_From_Ne (Irec.Nbth_Base_Theme,
                                                     p_Nm_Ne_Id_Of,
                                                     p_Nm_Begin_Mp);
                ELSE
                    l_Geom :=
                        Nm3Sdo.Get_Shape_From_Nm (Irec.Nbth_Base_Theme,
                                                  p_Nm_Ne_Id_In,
                                                  p_Nm_Ne_Id_Of,
                                                  p_Nm_Begin_Mp,
                                                  p_Nm_End_Mp);
                END IF;

                IF     Irec.Nth_Xsp_Column IS NOT NULL
                   AND NVL (Hig.Get_Sysopt ('XSPOFFSET'), 'N') = 'Y'
                THEN
                    l_Geom :=
                        Nm3Sdo_Dynseg.Get_Shape (Irec.Nbth_Base_Theme,
                                                 P_Nm_Ne_Id_In,
                                                 P_Nm_Ne_Id_Of,
                                                 P_Nm_Begin_Mp,
                                                 P_Nm_End_Mp);
                END IF;

                IF l_Geom IS NOT NULL
                THEN
                    EXECUTE IMMEDIATE Ins_String
                        USING p_Nm_Ne_Id_In,
                              p_Nm_Ne_Id_Of,
                              p_Nm_Begin_Mp,
                              p_Nm_End_Mp,
                              l_Geom,
                              p_Nm_Start_Date,
                              p_Nm_End_Date;
                END IF;
            ELSE
                EXECUTE IMMEDIATE   'select '
                                 || Nm3Sdo.Get_Spatial_Seq (
                                        Irec.Nth_Theme_Id)
                                 || '.nextval from dual'
                    INTO l_Objid;

                Ins_String :=
                       'insert into '
                    || Irec.Nth_Feature_Table
                    || ' ( objectid, ne_id, ne_id_of, nm_begin_mp, nm_end_mp, geoloc, start_date, end_date )'
                    || ' values (:objectid, :ne_id, :ne_id_of, :nm_begin_mp, :nm_end_mp, :geoloc, :start_date, :end_date )';

                IF l_Nit.Nit_Pnt_Or_Cont = 'P'
                THEN
                    l_Geom :=
                        Nm3Sdo.Get_Pt_Shape_From_Ne (Irec.Nbth_Base_Theme,
                                                     p_Nm_Ne_Id_Of,
                                                     p_Nm_Begin_Mp);
                ELSE
                    l_Geom :=
                        Nm3Sdo.Get_Shape_From_Nm (Irec.Nbth_Base_Theme,
                                                  p_Nm_Ne_Id_In,
                                                  p_Nm_Ne_Id_Of,
                                                  p_Nm_Begin_Mp,
                                                  p_Nm_End_Mp);
                END IF;

                IF     Irec.Nth_Xsp_Column IS NOT NULL
                   AND NVL (Hig.Get_Sysopt ('XSPOFFSET'), 'N') = 'Y'
                THEN
                    IF l_Nit.Nit_Pnt_Or_Cont = 'P'
                    THEN
                        l_Geom :=
                            SDO_LRS.Convert_To_Std_Geom (Nm3Sdo_Dynseg.Get_Shape (
                                                             Irec.Nbth_Base_Theme,
                                                             p_Nm_Ne_Id_In,
                                                             p_Nm_Ne_Id_Of,
                                                             p_Nm_Begin_Mp,
                                                             P_Nm_End_Mp));
                    ELSE
                        l_Geom :=
                            Nm3Sdo_Dynseg.Get_Shape (Irec.Nbth_Base_Theme,
                                                     p_Nm_Ne_Id_In,
                                                     p_Nm_Ne_Id_Of,
                                                     p_Nm_Begin_Mp,
                                                     p_Nm_End_Mp);
                    END IF;
                END IF;

                IF l_Geom IS NOT NULL
                THEN
                    EXECUTE IMMEDIATE Ins_String
                        USING l_Objid,
                              p_Nm_Ne_Id_In,
                              p_Nm_Ne_Id_Of,
                              p_Nm_Begin_Mp,
                              p_Nm_End_Mp,
                              l_Geom,
                              p_Nm_Start_Date,
                              p_Nm_End_Date;
                END IF;
            END IF;
        END LOOP;
    END Add_Inv_Shape;

    --
    ---------------------------------------------------------------------------------------------------
    --
    PROCEDURE Remove_Inv_Shape (
        p_Nm_Ne_Id_In     IN Nm_Members.Nm_Ne_Id_In%TYPE,
        p_Nm_Ne_Id_Of     IN Nm_Members.Nm_Ne_Id_Of%TYPE,
        p_Nm_Obj_Type     IN Nm_Members.Nm_Obj_Type%TYPE,
        p_Nm_Begin_Mp     IN Nm_Members.Nm_Begin_Mp%TYPE,
        p_Nm_End_Mp       IN Nm_Members.Nm_End_Mp%TYPE,
        p_Nm_Start_Date   IN Nm_Members.Nm_Start_Date%TYPE,
        p_Nm_End_Date     IN Nm_Members.Nm_End_Date%TYPE)
    IS
        Del_String   VARCHAR2 (2000);
        l_Geom       MDSYS.Sdo_Geometry;
        l_Nit        Nm_Inv_Types%ROWTYPE := Nm3Get.Get_Nit (p_Nm_Obj_Type);
    BEGIN
        --allow for many layers of the same asset type, only address immediate themes
        FOR Irec
            IN (SELECT nta.Nth_Feature_Table,
                       nta.Nth_Feature_Pk_Column,
                       nta.Nth_Feature_Fk_Column
                  FROM Nm_Themes_All nta, Nm_Inv_Themes nit
                 WHERE     nta.Nth_Theme_Id = nit.Nith_Nth_Theme_Id
                       AND nit.Nith_Nit_Id = p_Nm_Obj_Type
                       AND nta.Nth_Update_On_Edit = 'I')
        LOOP
            Del_String :=
                   'delete from '
                || Irec.Nth_Feature_Table
                || ' where ne_id = :ne_id'
                || ' and ne_id_of = :ne_id_of '
                || ' and nm_begin_mp = :ne_begin_mp '
                || ' and start_date = :start_date';

            EXECUTE IMMEDIATE Del_String
                USING p_Nm_Ne_Id_In,
                      p_Nm_Ne_Id_Of,
                      p_Nm_Begin_Mp,
                      p_Nm_Start_Date;
        END LOOP;
    END Remove_Inv_Shape;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Add_Gty_Shape (
        p_Nm_Ne_Id_In     IN Nm_Members.Nm_Ne_Id_In%TYPE,
        p_Nm_Ne_Id_Of     IN Nm_Members.Nm_Ne_Id_Of%TYPE,
        p_Nm_Obj_Type     IN Nm_Members.Nm_Obj_Type%TYPE,
        p_Nm_Begin_Mp     IN Nm_Members.Nm_Begin_Mp%TYPE,
        p_Nm_End_Mp       IN Nm_Members.Nm_End_Mp%TYPE,
        p_Nm_Start_Date   IN Nm_Members.Nm_Start_Date%TYPE,
        p_Nm_End_Date     IN Nm_Members.Nm_End_Date%TYPE)
    IS
        Ins_String   VARCHAR2 (2000);
        l_Geom       MDSYS.Sdo_Geometry;
        l_Objid      NUMBER;
        l_Seq_Name   VARCHAR2 (30);
    BEGIN
        --allow for many layers of the same group type, only deal with immediate themes
        FOR Irec
            IN (SELECT nta.Nth_Theme_Id,
                       nta.Nth_Feature_Table,
                       nta.Nth_Feature_Pk_Column,
                       nta.Nth_Feature_Shape_Column,
                       nta.Nth_Feature_Fk_Column,
                       nbt.Nbth_Base_Theme,
                       'G'               G_Or_I,
                       p_Nm_Obj_Type     Obj_Type
                  FROM Nm_Themes_All    nta,
                       Nm_Area_Themes   nat,
                       Nm_Area_Types    naty,
                       Nm_Base_Themes   nbt,
                       Nm_Nw_Themes     nnt,
                       Nm_Elements      ne,
                       Nm_Linear_Types  nlt
                 WHERE     nta.Nth_Theme_Id = nat.Nath_Nth_Theme_Id
                       AND nta.Nth_Theme_Id = nbt.Nbth_Theme_Id
                       AND nat.Nath_Nat_Id = naty.Nat_Id
                       AND naty.Nat_Gty_Group_Type = p_Nm_Obj_Type
                       AND nta.Nth_Update_On_Edit = 'I'
                       AND ne.Ne_Id = p_Nm_Ne_Id_Of
                       AND ne.Ne_Nt_Type = nlt.Nlt_Nt_Type
                       AND nnt.Nnth_Nth_Theme_Id = nbt.Nbth_Base_Theme
                       AND nlt.Nlt_Id = nnt.Nnth_Nlt_Id
                UNION
                SELECT nta.Nth_Theme_Id,
                       nta.Nth_Feature_Table,
                       nta.Nth_Feature_Pk_Column,
                       nta.Nth_Feature_Shape_Column,
                       nta.Nth_Feature_Fk_Column,
                       nbt.Nbth_Base_Theme,
                       'I',
                       nal.Nad_Inv_Type
                  FROM Nm_Themes_All    nta,
                       Nm_Inv_Themes    nit,
                       Nm_Base_Themes   nbt,
                       Nm_Nw_Themes     nnt,
                       Nm_Elements      ne,
                       Nm_Linear_Types  nlt,
                       Nm_Nw_Ad_Link    nal
                 WHERE     nta.Nth_Theme_Id = nit.Nith_Nth_Theme_Id
                       AND nta.Nth_Theme_Id = nbt.Nbth_Theme_Id
                       AND nal.Nad_Inv_Type = nit.Nith_Nit_Id
                       AND nal.Nad_Gty_Type = p_Nm_Obj_Type
                       AND nta.Nth_Update_On_Edit = 'I'
                       AND ne.Ne_Id = p_Nm_Ne_Id_Of
                       AND ne.Ne_Nt_Type = nlt.Nlt_Nt_Type
                       AND nnt.Nnth_Nth_Theme_Id = nbt.Nbth_Base_Theme
                       AND nlt.Nlt_Id = nnt.Nnth_Nlt_Id
                       AND nal.Nad_Ne_Id = p_Nm_Ne_Id_In)
        LOOP
            IF Irec.G_Or_I = 'G'
            THEN
                EXECUTE IMMEDIATE   'select '
                                 || Nm3Sdo.Get_Spatial_Seq (
                                        Irec.Nth_Theme_Id)
                                 || '.nextval FROM DUAL'
                    INTO l_Objid;

                Ins_String :=
                       'insert into '
                    || Irec.Nth_Feature_Table
                    || ' ( objectid, ne_id, ne_id_of, nm_begin_mp, nm_end_mp, geoloc, start_date, end_date )'
                    || ' values (:objectid, :ne_id, :ne_id_of, :nm_begin_mp, :nm_end_mp, :geoloc, :start_date, :end_date )';

                l_Geom :=
                    SDO_LRS.Convert_To_Std_Geom (Nm3Sdo.Get_Shape_From_Nm (
                                                     Irec.Nbth_Base_Theme,
                                                     p_Nm_Ne_Id_In,
                                                     p_Nm_Ne_Id_Of,
                                                     p_Nm_Begin_Mp,
                                                     p_Nm_End_Mp));

                --
                -- Task 0108237
                -- AE don't process this insert if the shape is null
                --
                IF l_Geom IS NOT NULL
                THEN
                    EXECUTE IMMEDIATE Ins_String
                        USING l_Objid,
                              p_Nm_Ne_Id_In,
                              p_Nm_Ne_Id_Of,
                              p_Nm_Begin_Mp,
                              p_Nm_End_Mp,
                              l_Geom,
                              p_Nm_Start_Date,
                              p_Nm_End_Date;
                END IF;
            ELSE
                l_Seq_Name := Nm3Sdo.Get_Spatial_Seq (Irec.Nth_Theme_Id);

                Ins_String :=
                       'insert into '
                    || Irec.Nth_Feature_Table
                    || ' ( objectid, ne_id, ne_id_of, nm_begin_mp, nm_end_mp, geoloc, start_date, end_date )'
                    || ' select '
                    || L_Seq_Name
                    || '.nextval, nad_iit_ne_id, :ne_id_of, :nm_begin_mp, :nm_end_mp, '
                    || ' Nm3sdo.get_shape_from_nm ('
                    || TO_CHAR (Irec.Nbth_Base_Theme)
                    || ', '
                    || ' :group_ne_id, '
                    || ' :ne_id_of, '
                    || ' :nm_begin_mp, '
                    || ' :nm_end_mp ), :start_date, :end_date '
                    || ' from nm_nw_ad_link where nad_ne_id = :group_ne_id '
                    || ' and nad_inv_type = :obj_type '
                    || ' and nad_whole_road = '
                    || ''''
                    || '1'
                    || '''';

                EXECUTE IMMEDIATE Ins_String
                    USING p_Nm_Ne_Id_Of,
                          p_Nm_Begin_Mp,
                          p_Nm_End_Mp,
                          p_Nm_Ne_Id_In,
                          p_Nm_Ne_Id_Of,
                          p_Nm_Begin_Mp,
                          p_Nm_End_Mp,
                          p_Nm_Start_Date,
                          p_Nm_End_Date,
                          p_Nm_Ne_Id_In,
                          Irec.Obj_Type;
            END IF;
        END LOOP;
    END Add_Gty_Shape;

    --
    ---------------------------------------------------------------------------------------------------
    --
    PROCEDURE Remove_Gty_Shape (
        p_Nm_Ne_Id_In     IN Nm_Members.Nm_Ne_Id_In%TYPE,
        p_Nm_Ne_Id_Of     IN Nm_Members.Nm_Ne_Id_Of%TYPE,
        p_Nm_Obj_Type     IN Nm_Members.Nm_Obj_Type%TYPE,
        p_Nm_Begin_Mp     IN Nm_Members.Nm_Begin_Mp%TYPE,
        p_Nm_End_Mp       IN Nm_Members.Nm_End_Mp%TYPE,
        p_Nm_Start_Date   IN Nm_Members.Nm_Start_Date%TYPE,
        p_Nm_End_Date     IN Nm_Members.Nm_End_Date%TYPE)
    IS
        Del_String   VARCHAR2 (2000);
        l_Geom       MDSYS.Sdo_Geometry;
    BEGIN
        FOR Irec
            IN (SELECT nta.Nth_Theme_Id,
                       nta.Nth_Feature_Table,
                       nta.Nth_Feature_Pk_Column,
                       nta.Nth_Feature_Fk_Column,
                       'G'     Ad_Flag
                  FROM Nm_Themes_All   nta,
                       Nm_Area_Themes  nat,
                       Nm_Area_Types   naty
                 WHERE     nta.Nth_Theme_Id = nat.Nath_Nth_Theme_Id
                       AND nat.Nath_Nat_Id = naty.Nat_Id
                       AND naty.Nat_Gty_Group_Type = p_Nm_Obj_Type
                       AND nta.Nth_Update_On_Edit = 'I'
                UNION
                SELECT nta.Nth_Theme_Id,
                       nta.Nth_Feature_Table,
                       Nth_Feature_Pk_Column,
                       nta.Nth_Feature_Fk_Column,
                       'I'
                  FROM Nm_Themes_All   nta,
                       Nm_Nw_Ad_Types  nat,
                       Nm_Inv_Themes   nit
                 WHERE     nta.Nth_Theme_Id = nit.Nith_Nth_Theme_Id
                       AND nit.Nith_Nit_Id = nat.Nad_Inv_Type
                       AND nat.Nad_Gty_Type = p_Nm_Obj_Type
                       AND nta.Nth_Update_On_Edit = 'I')
        LOOP
            IF Irec.Ad_Flag = 'G'
            THEN
                Del_String :=
                       'delete from '
                    || Irec.Nth_Feature_Table
                    || ' where ne_id = :ne_id'
                    || ' and ne_id_of = :ne_id_of '
                    || ' and nm_begin_mp = :ne_begin_mp '
                    || ' and start_date = :start_date';
            ELSE
                Del_String :=
                       'delete from '
                    || Irec.Nth_Feature_Table
                    || ' where ne_id in ( select nad_iit_ne_id from nm_nw_ad_link where nad_ne_id =  :ne_id )'
                    || ' and ne_id_of = :ne_id_of '
                    || ' and nm_begin_mp = :ne_begin_mp '
                    || ' and start_date = :start_date';
            END IF;

            EXECUTE IMMEDIATE Del_String
                USING p_Nm_Ne_Id_In,
                      p_Nm_Ne_Id_Of,
                      p_Nm_Begin_Mp,
                      p_Nm_Start_Date;
        END LOOP;
    END Remove_Gty_Shape;

    --
    --
    -- A procedure to re-set the route shapes for a specific route from and including a specific date
    --
    PROCEDURE reset_route_shapes (p_ne_id IN nm_elements.ne_id%TYPE)
    AS                                                  --, p_date in date) as
        CURSOR c1 (c_ne_id IN nm_elements.ne_id%TYPE)
        IS
              SELECT *
                FROM (SELECT ne_id,
                             start_date,
                             LEAD (start_date, 1) OVER (ORDER BY start_date)    end_date
                        FROM (WITH
                                  membs
                                  AS
                                      (SELECT nm_ne_id_in,
                                              nm_start_date,
                                              nm_end_date
                                         FROM nm_members_all
                                        WHERE nm_ne_id_in = c_ne_id) -- and nm_start_date >= c_date )
                                SELECT DISTINCT ne_id, start_date
                                  FROM (SELECT DISTINCT
                                               nm_ne_id_in       ne_id,
                                               nm_start_date     start_date
                                          FROM membs
                                        UNION
                                        SELECT DISTINCT nm_ne_id_in, nm_end_date
                                          FROM membs)
                              ORDER BY start_date DESC))
               WHERE NVL (start_date, TO_DATE ('05-NOV-1605')) !=
                     NVL (end_date, TO_DATE ('05-NOV-1605'))
            ORDER BY start_date DESC;

        --
        l_geom   MDSYS.sdo_geometry;
    --
    BEGIN
        --nm_debug.debug_on;
        FOR Irec
            IN (SELECT nta.Nth_Theme_Id,
                       nta.Nth_Feature_Table,
                       nta.Nth_Feature_Pk_Column,
                       nta.Nth_Feature_Fk_Column,
                       nta.Nth_Feature_Shape_Column,
                       nta.Nth_Sequence_Name
                  FROM Nm_Themes_All    nta,
                       Nm_Nw_Themes     nnt,
                       User_Tables      ut,
                       Nm_Linear_Types  nlt,
                       Nm_Elements_All  nea
                 WHERE     nta.Nth_Theme_Id = nnt.Nnth_Nth_Theme_Id
                       AND ut.Table_Name = nta.Nth_Feature_Table
                       AND nnt.Nnth_Nlt_Id = nlt.Nlt_Id
                       AND nlt.Nlt_Gty_Type = nea.Ne_Gty_Group_Type
                       AND nlt.Nlt_Nt_Type = nea.Ne_Nt_Type
                       AND nea.Ne_Id = p_Ne_Id)
        LOOP
            --
            BEGIN
                EXECUTE IMMEDIATE   'delete from '
                                 || irec.Nth_Feature_Table
                                 || ' where '
                                 || irec.Nth_Feature_Pk_Column
                                 || ' = :p_ne_id '
                    USING p_ne_id;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    NULL;
            END;

            --
            nm_debug.debug ('go into loop?');

            FOR idates IN c1 (p_ne_id)
            LOOP
                nm_debug.debug ('In loop ' || idates.start_date);

                BEGIN
                    nm3user.set_effective_date (idates.start_date);
                    l_geom := nm3sdo.get_route_shape (p_ne_id);

                    IF l_geom IS NOT NULL
                    THEN
                        BEGIN
                            EXECUTE IMMEDIATE   'insert into '
                                             || irec.Nth_Feature_Table
                                             || '( objectid, ne_id, geoloc, start_date, end_date ) '
                                             || ' select '
                                             || irec.Nth_Sequence_Name
                                             || '.nextval, :p_ne_id, :l_geom, :start_date, :end_date from dual '
                                USING p_ne_id,
                                      l_geom,
                                      idates.start_date,
                                      idates.end_date;
                        EXCEPTION
                            WHEN OTHERS
                            THEN
                                NULL;
                        END;
                    END IF;
                END;
            END LOOP;
        END LOOP;

        nm3user.set_effective_date (TRUNC (SYSDATE));
    EXCEPTION
        WHEN OTHERS
        THEN
            nm3user.set_effective_date (TRUNC (SYSDATE));
            RAISE;
    END;

    --
    ---------------------------------------------------------------------------------------------------
    --
    PROCEDURE Reshape_Route (pi_Ne_Id            IN Nm_Elements.Ne_Id%TYPE,
                             pi_Effective_Date   IN DATE,
                             pi_Use_History      IN VARCHAR2)
    IS
        l_Nlt_Id     Nm_Linear_Types.Nlt_Id%TYPE;
        l_Nlt        Nm_Linear_Types%ROWTYPE;
        Cur_String   VARCHAR2 (2000);
        l_Base_Nth   Nm_Themes_All%ROWTYPE;
        l_Count      NUMBER;
        l_Shape      MDSYS.Sdo_Geometry;
        l_Next       NUMBER;
        l_Date       DATE;

        --------------------
        FUNCTION Get_Shape_Start_Date (p_Table    IN VARCHAR2,
                                       p_Column   IN VARCHAR2,
                                       p_Value    IN NUMBER)
            RETURN DATE
        IS
            Retval   DATE;
        BEGIN
            BEGIN
                EXECUTE IMMEDIATE   'select start_date from '
                                 || p_Table
                                 || ' where '
                                 || p_Column
                                 || ' = :ne_id '
                                 || ' and end_date is null'
                    INTO Retval
                    USING p_Value;

                RETURN Retval;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    Retval := NULL;
            END;

            RETURN (Retval);
        END Get_Shape_Start_Date;

        --------------------
        PROCEDURE End_Shape (p_Table       IN     VARCHAR2,
                             p_Column      IN     VARCHAR2,
                             p_Value       IN     NUMBER,
                             p_Effective   IN     DATE,
                             p_Count          OUT NUMBER)
        IS
        BEGIN
            EXECUTE IMMEDIATE   'update '
                             || p_Table
                             || ' set end_date = :effective '
                             || ' where '
                             || p_Column
                             || ' = :ne_id'
                             || ' and end_date is null'
                USING p_Effective, p_Value;

            p_Count := SQL%ROWCOUNT;
        END End_Shape;

        --------------------
        FUNCTION Get_Next_Theme_Seq (p_Theme IN NUMBER)
            RETURN NUMBER
        IS
            Retval    NUMBER;
            curstr    VARCHAR2 (200);
            seqname   VARCHAR2 (30) := Nm3Sdo.Get_Spatial_Seq (p_Theme);
        BEGIN
            EXECUTE IMMEDIATE   'select '
                             || Nm3Sdo.Get_Spatial_Seq (p_Theme)
                             || '.nextval from dual'
                INTO Retval;

            RETURN Retval;
        END Get_Next_Theme_Seq;

        --------------------
        PROCEDURE Update_Shape (p_Table          IN     VARCHAR2,
                                p_Column         IN     VARCHAR2,
                                p_Value          IN     NUMBER,
                                p_Shape_Column   IN     VARCHAR2,
                                p_Shape          IN     MDSYS.Sdo_Geometry,
                                p_Count             OUT NUMBER)
        IS
        BEGIN
            EXECUTE IMMEDIATE   'update '
                             || p_Table
                             || ' set '
                             || p_Shape_Column
                             || ' = :shape '
                             || ' where '
                             || p_Column
                             || ' = :ne_id'
                             || ' and end_date is null'
                USING p_Shape, p_Value;

            p_Count := SQL%ROWCOUNT;
        END Update_Shape;

        --------------------
        PROCEDURE Update_Shape_and_Date (
            p_Table          IN     VARCHAR2,
            p_Column         IN     VARCHAR2,
            p_Value          IN     NUMBER,
            p_Effective      IN     DATE,
            p_Shape_Column   IN     VARCHAR2,
            p_Shape          IN     MDSYS.Sdo_Geometry,
            p_Count             OUT NUMBER)
        IS
            l_date   DATE;
        BEGIN
            p_Count := 0;

            BEGIN
                EXECUTE IMMEDIATE   'select last_start from ( select first_value (start_date) over (order by start_date desc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) last_start '
                                 || ' from '
                                 || p_Table
                                 || ' where ne_id = :ne ) where rownum = 1 '
                    INTO l_date
                    USING p_Value;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    l_date := NULL; -- if no data then no update can be performed
            END;

            IF l_date IS NOT NULL
            THEN
                EXECUTE IMMEDIATE   'update '
                                 || p_Table
                                 || ' set '
                                 || p_Shape_Column
                                 || ' = :shape ,'
                                 || 'start_date = :effective,'
                                 || 'end_date   =  NULL '
                                 || ' where '
                                 || p_Column
                                 || ' = :ne_id'
                                 || ' and start_date = :st_date'
                    USING p_Shape,
                          p_Effective,
                          p_Value,
                          l_date;


                p_Count := SQL%ROWCOUNT;
            END IF;
        END Update_Shape_and_Date;

        PROCEDURE Update_End_Date (
            p_Table          IN     VARCHAR2,
            p_Column         IN     VARCHAR2,
            p_Value          IN     NUMBER,
            p_Effective      IN     DATE,
            p_Shape_Column   IN     VARCHAR2,
            p_Shape          IN     MDSYS.Sdo_Geometry,
            p_Count             OUT NUMBER)
        IS
            l_date   DATE;
        BEGIN
            p_Count := 0;

            BEGIN
                EXECUTE IMMEDIATE   'select last_start from ( select first_value (start_date) over (order by start_date desc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) last_start '
                                 || ' from '
                                 || p_Table
                                 || ' where ne_id = :ne ) where rownum = 1 '
                    INTO l_date
                    USING p_Value;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    l_date := NULL; -- if no data then no update can be performed
            END;

            IF l_date IS NOT NULL
            THEN
                EXECUTE IMMEDIATE   'update '
                                 || p_Table
                                 || ' set end_date = :effective '
                                 || ' where '
                                 || p_Column
                                 || ' = :ne_id'
                                 || ' and start_date = :st_date'
                    USING p_Effective, p_Value, l_date;


                p_Count := SQL%ROWCOUNT;
            END IF;
        END Update_End_Date;

        PROCEDURE Delete_Shape (p_Table    IN     VARCHAR2,
                                p_Column   IN     VARCHAR2,
                                p_Value    IN     NUMBER,
                                p_Count       OUT NUMBER)
        IS
        BEGIN
            EXECUTE IMMEDIATE   'delete from '
                             || p_Table
                             || ' where '
                             || p_Column
                             || ' = :ne_id'
                             || ' and end_date is null'
                USING p_Value;

            p_Count := SQL%ROWCOUNT;
        END Delete_Shape;

        --------------------
        PROCEDURE Delete_Extraneous_Shapes (p_Table    IN     VARCHAR2,
                                            p_Column   IN     VARCHAR2,
                                            p_Value    IN     NUMBER,
                                            p_Date     IN     DATE,
                                            p_Count       OUT NUMBER)
        IS
        BEGIN
            EXECUTE IMMEDIATE   'delete from '
                             || p_Table
                             || ' where '
                             || p_Column
                             || ' = :ne_id'
                             || ' and start_date > :st_date '
                USING p_Value, p_Date;

            p_Count := SQL%ROWCOUNT;
        END Delete_Extraneous_Shapes;

        --------------------

        PROCEDURE Insert_Shape (p_Table          IN     VARCHAR2,
                                p_Column         IN     VARCHAR2,
                                p_Value          IN     NUMBER,
                                p_Shape_Column   IN     VARCHAR2,
                                p_Shape          IN     MDSYS.Sdo_Geometry,
                                p_Seq_No         IN     NUMBER,
                                p_Effective      IN     DATE,
                                p_Count             OUT NUMBER)
        IS
        BEGIN
            IF Nm3Sdo.Use_Surrogate_Key = 'N'
            THEN
                EXECUTE IMMEDIATE   'insert into '
                                 || p_Table
                                 || '( '
                                 || p_Column
                                 || ','
                                 || p_Shape_Column
                                 || ','
                                 || 'start_date )'
                                 || ' values (:ne_id, :shape, :start_date) '
                    USING p_Value, p_Shape, p_Effective;

                p_Count := SQL%ROWCOUNT;
            ELSE
                EXECUTE IMMEDIATE   'insert into '
                                 || p_Table
                                 || '( objectid, '
                                 || p_Column
                                 || ','
                                 || p_Shape_Column
                                 || ','
                                 || 'start_date )'
                                 || ' values (:objectid, :ne_id, :shape, :start_date) '
                    USING p_Seq_No,
                          p_Value,
                          p_Shape,
                          p_Effective;

                p_Count := SQL%ROWCOUNT;
            END IF;
        END Insert_Shape;
    ---------------------
    BEGIN
        reset_route_shapes (p_ne_id => pi_Ne_Id); --, p_date => pi_Effective_Date );
    /*
      For Irec In (
                  Select  nta.Nth_Theme_Id,
                          nta.Nth_Feature_Table,
                          nta.Nth_Feature_Pk_Column,
                          nta.Nth_Feature_Fk_Column,
                          nta.Nth_Feature_Shape_Column
                  From    Nm_Themes_All     nta,
                          Nm_Nw_Themes      nnt,
                          User_Tables       ut,
                          Nm_Linear_Types   nlt,
                          Nm_Elements_All   nea
                  Where   nta.Nth_Theme_Id  =   nnt.Nnth_Nth_Theme_Id
                  And     ut.Table_Name     =   nta.Nth_Feature_Table
                  And     nnt.Nnth_Nlt_Id   =   nlt.Nlt_Id
                  And     nlt.Nlt_Gty_Type  =   nea.Ne_Gty_Group_Type
                  And     nlt.Nlt_Nt_Type   =   nea.Ne_Nt_Type
                  And     nea.Ne_Id         =   pi_Ne_Id
                  )
      Loop

        --only operate on base table data

        l_Shape := Nm3Sdo.Get_Route_Shape (pi_Ne_Id);

          -- first check the start date of the current shape if one exists.
        l_Date := Get_Shape_Start_Date (
                                        Irec.Nth_Feature_Table,
                                        Irec.Nth_Feature_Pk_Column,
                                        pi_Ne_Id
                                        );

        if l_shape is not null and l_date is not null then

          If L_Date = Pi_Effective_Date Then

            Update_Shape (Irec.Nth_Feature_Table,
                          Irec.Nth_Feature_Pk_Column,
                          pi_Ne_Id,
                          Irec.Nth_Feature_Shape_Column,
                          l_Shape,
                          l_Count
                        );

          Elsif L_Date > Pi_Effective_Date Then
    --
    --     Test to see if these shapes are valid - if they are just frm some useless resequence from SM then we can trash them
    --
            declare
              l_last_date date;
            begin
              select max(greatest(nm_start_date, nvl(nm_end_date, to_date('01-jan-1000', 'DD-MON-YYYY'))))
              into l_last_date
              from nm_members_all
              where nm_ne_id_in =  pi_Ne_Id;

    --        nm_debug.debug('Max date of all members is '||l_last_date );

              if l_last_date >= l_date then

    --          nm_debug.debug('update shape and date');

                Update_shape_and_Date(
                           Irec.Nth_Feature_Table,
                           Irec.Nth_Feature_Pk_Column,
                           pi_Ne_Id,
                           l_last_date,
                           Irec.Nth_Feature_Shape_Column,
                           l_Shape,
                           l_count );
              Else

    --          nm_debug.debug('deleting extraneous shapes' );

                Delete_Extraneous_Shapes (
                           Irec.Nth_Feature_Table,
                           Irec.Nth_Feature_Pk_Column,
                           pi_Ne_Id,
                           l_last_date,
                           l_count );

    --          nm_debug.debug('update shape and date 2');

                Update_End_Date(
                           Irec.Nth_Feature_Table,
                           Irec.Nth_Feature_Pk_Column,
                           pi_Ne_Id,
                           l_last_date,
                           Irec.Nth_Feature_Shape_Column,
                           l_Shape,
                           l_count );

                If Nm3Sdo.Use_Surrogate_Key = 'Y' Then
                  l_Next := Get_Next_Theme_Seq (Irec.Nth_Theme_Id);
                End If;

    --          nm_debug.debug('Inserting new shape');

                Insert_Shape  (
                          Irec.Nth_Feature_Table,
                          Irec.Nth_Feature_Pk_Column,
                          pi_Ne_Id,
                          Irec.Nth_Feature_Shape_Column,
                          l_Shape,
                          l_Next,
                          pi_Effective_Date,
                          l_Count
                          );
              End If;
            End;

          Else

            -- existing date is less than effective date - check history flags

            If pi_Use_History = 'Y' Then

      --      nm_debug.debug('Ending existing shape');
              End_Shape (
                        Irec.Nth_Feature_Table,
                        Irec.Nth_Feature_Pk_Column,
                        pi_Ne_Id,
                        pi_Effective_Date,
                        l_Count
                        );
              If Nm3Sdo.Use_Surrogate_Key = 'Y' Then
                l_Next := Get_Next_Theme_Seq (Irec.Nth_Theme_Id);
              End If;

    --        nm_debug.debug('Inserting new shape');
              Insert_Shape  (
                            Irec.Nth_Feature_Table,
                            Irec.Nth_Feature_Pk_Column,
                            pi_Ne_Id,
                            Irec.Nth_Feature_Shape_Column,
                            l_Shape,
                            l_Next,
                            pi_Effective_Date,
                            l_Count
                            );
    --        nm_debug.debug('Inserted - count = '||l_count );
            Else

    --        nm_debug.debug('No history');

              -- Not using history but there is an existing shape to be swapped - just update

              Update_Shape (Irec.Nth_Feature_Table,
                            Irec.Nth_Feature_Pk_Column,
                            pi_Ne_Id,
                            Irec.Nth_Feature_Shape_Column,
                            l_Shape,
                            l_Count
                           );

            End If;-- history
          End If; -- dates

        Else  -- either existing date is null or new shape is null

    --    nm_debug.debug('either existing date is null or new shape is null');

          If l_Shape Is Not Null  Then
               Update_Shape (
                            Irec.Nth_Feature_Table,
                            Irec.Nth_Feature_Pk_Column,
                            pi_Ne_Id,
                            Irec.Nth_Feature_Shape_Column,
                            l_Shape,
                            l_Count
                            );

            If l_Count = 0  Then
              If Nm3Sdo.Use_Surrogate_Key = 'Y' Then
                l_Next := Get_Next_Theme_Seq (Irec.Nth_Theme_Id);
              End If;

    --        nm_debug.debug('Inserting new shape');
              Insert_Shape  (
                            Irec.Nth_Feature_Table,
                            Irec.Nth_Feature_Pk_Column,
                            pi_Ne_Id,
                            Irec.Nth_Feature_Shape_Column,
                            l_Shape,
                            l_Next,
                            pi_Effective_Date,
                            l_Count
                            );
            End If;
          Else  -- existing date is not null but new shape is null
    --      nm_debug.debug(' existing date is not null but new shape is null');

            If pi_Use_History = 'Y' then
              End_Shape (
                        Irec.Nth_Feature_Table,
                        Irec.Nth_Feature_Pk_Column,
                        pi_Ne_Id,
                        pi_Effective_Date,
                        l_Count
                        );
            Else
              Delete_Shape (
                          Irec.Nth_Feature_Table,
                          Irec.Nth_Feature_Pk_Column,
                          pi_Ne_Id,
                          l_Count
                          );
            End If; -- new shape is null and existing shape exists
          End If;
        End If;
      End Loop;
      nm_debug.debug_off;
    */
    END Reshape_Route;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Delete_Route_Shape (p_Ne_Id IN NUMBER)
    IS
    BEGIN
        FOR Irec
            IN (SELECT nta.Nth_Theme_Id,
                       nta.Nth_Feature_Table,
                       nta.Nth_Feature_Pk_Column,
                       nta.Nth_Feature_Fk_Column,
                       nta.Nth_Feature_Shape_Column
                  FROM Nm_Themes_All    nta,
                       Nm_Nw_Themes     nnt,
                       User_Tables      ut,
                       Nm_Linear_Types  nlt,
                       Nm_Elements      ne
                 WHERE     nta.Nth_Theme_Id = nnt.Nnth_Nth_Theme_Id
                       AND ut.Table_Name = nta.Nth_Feature_Table
                       AND nnt.Nnth_Nlt_Id = nlt.Nlt_Id
                       AND nlt.Nlt_Gty_Type = ne.Ne_Gty_Group_Type
                       AND nlt.Nlt_Nt_Type = ne.Ne_Nt_Type
                       AND ne.Ne_Id = p_Ne_Id)
        LOOP
            EXECUTE IMMEDIATE   'delete from '
                             || Irec.Nth_Feature_Table
                             || ' where '
                             || Irec.Nth_Feature_Pk_Column
                             || ' = :ne_id'
                USING p_Ne_Id;
        END LOOP;
    END Delete_Route_Shape;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Restore_Route_Shape (P_Ne_Id IN NUMBER, P_Date IN DATE)
    IS
        C_Str   VARCHAR2 (2000);
    BEGIN
        FOR Irec
            IN (SELECT nta.Nth_Theme_Id,
                       nta.Nth_Feature_Table,
                       nta.Nth_Feature_Pk_Column,
                       nta.Nth_Feature_Fk_Column,
                       nta.Nth_Feature_Shape_Column
                  FROM Nm_Themes_All    nta,
                       Nm_Nw_Themes     nnt,
                       User_Tables      ut,
                       Nm_Linear_Types  nlt,
                       Nm_Elements      ne
                 WHERE     nta.Nth_Theme_Id = nnt.Nnth_Nth_Theme_Id
                       AND ut.Table_Name = nta.Nth_Feature_Table
                       AND nnt.Nnth_Nlt_Id = nlt.Nlt_Id
                       AND nlt.Nlt_Gty_Type = ne.Ne_Gty_Group_Type
                       AND nlt.Nlt_Nt_Type = ne.Ne_Nt_Type
                       AND ne.Ne_Id = p_Ne_Id)
        LOOP
            C_Str :=
                   'update '
                || Irec.Nth_Feature_Table
                || ' set end_date = null where '
                || Irec.Nth_Feature_Pk_Column
                || ' = :ne_id and end_date = :end_date '
                || ' and start_date = ( select max (start_date) '
                || '  from '
                || Irec.Nth_Feature_Table
                || ' where ne_id = :ne_id '
                || '  and end_date = :end_date ) ';

            EXECUTE IMMEDIATE C_Str
                USING p_Ne_Id,
                      p_Date,
                      p_Ne_Id,
                      p_Date;
        END LOOP;
    END Restore_Route_Shape;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Refresh_Nt_Views
    IS
    BEGIN
        FOR Irec IN (SELECT nt.Nt_Type
                       FROM Nm_Types nt)
        LOOP
            Nm3Inv_View.Create_View_For_Nt_Type (pi_Nt_Type => Irec.Nt_Type);
        END LOOP;
    END Refresh_Nt_Views;

    --
    -----------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Make_Group_Layer (
        p_Nt_Type              IN Nm_Types.Nt_Type%TYPE,
        p_Gty_Type             IN Nm_Group_Types.Ngt_Group_Type%TYPE,
        Linear_Flag_Override   IN VARCHAR2 DEFAULT 'N',
        p_Job_Id               IN NUMBER DEFAULT NULL)
    AS
        l_Nlt    Nm_Linear_Types.Nlt_Id%TYPE;
        l_View   VARCHAR2 (30) := Get_Nt_View_Name (p_Nt_Type, p_Gty_Type);
    BEGIN
        IF NOT User_Is_Unrestricted
        THEN
            RAISE E_Not_Unrestricted;
        END IF;

        IF NOT Nm3Ddl.Does_Object_Exist (l_View, 'VIEW')
        THEN
            Nm3Inv_View.Create_View_For_Nt_Type (p_Nt_Type);

            IF NM3NET.GET_GTY_SUB_GROUP_ALLOWED (p_Gty_Type) = 'N'
            THEN
                Nm3Inv_View.Create_Ft_Inv_For_Nt_Type (
                    pi_Nt_Type                    => p_Gty_Type,
                    pi_Inv_Type                   => NULL,
                    pi_Delete_Existing_Inv_Type   => TRUE);
            END IF;
        END IF;

        IF     Nm3Net.Is_Gty_Linear (p_Gty_Type) = 'Y'
           AND Linear_Flag_Override = 'N'
        THEN
            l_Nlt := Get_Nlt_Id_From_Gty (p_Gty_Type);
            Make_Nt_Spatial_Layer (pi_Nlt_Id => l_Nlt, p_Job_Id => p_Job_Id);
        ELSIF NM3NET.get_gty_sub_group_allowed (p_Gty_Type) = 'N'
        THEN
            Create_Non_Linear_Group_Layer (p_Nt_Type    => p_Nt_Type,
                                           p_Gty_Type   => p_Gty_Type,
                                           p_Job_Id     => p_Job_Id);
        ELSE
            Create_G_of_G_Group_Layer (p_Nt_TYpe    => p_Nt_Type,
                                       p_Gty_Type   => p_Gty_Type,
                                       p_Job_Id     => p_Job_Id);
        END IF;
    EXCEPTION
        WHEN E_Not_Unrestricted
        THEN
            Raise_Application_Error (
                -20777,
                'Restricted users are not permitted to create SDO layers');
    END Make_Group_Layer;

    --
    -----------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Create_G_of_G_Group_Layer (
        p_Nt_Type    IN Nm_Types.Nt_Type%TYPE,
        p_Gty_Type   IN Nm_Group_Types.Ngt_Group_Type%TYPE,
        p_Job_Id     IN NUMBER DEFAULT NULL)
    AS
        l_Tab           Nm_Themes_All.Nth_Feature_Table%TYPE;
        l_View          Nm_Themes_All.Nth_Table_Name%TYPE;
        l_Seq           VARCHAR2 (30);

        l_Base_Themes   Nm_Theme_Array;
        l_Diminfo       MDSYS.Sdo_Dim_Array;
        l_Srid          NUMBER;

        l_Usgm          User_Sdo_Geom_Metadata%ROWTYPE;

        l_Theme_Id      Nm_Themes_All.Nth_Theme_Id%TYPE;
        l_V_Theme_Id    Nm_Themes_All.Nth_Theme_Id%TYPE;

        --

        FUNCTION get_base_themes
            RETURN nm_theme_array
        IS
            retval   nm_theme_array := NM3ARRAY.INIT_NM_THEME_ARRAY;
        BEGIN
              SELECT CAST (
                         COLLECT (nm_theme_entry (nth_theme_id))
                             AS nm_theme_array_type)
                INTO retval.nta_theme_array
                FROM (SELECT *
                        FROM v_nm_sub_group_structure g, v_nm_network_themes t
                       WHERE     g.child_nt_type = t.nt_type(+)
                             AND NVL (g.child_group_type, '£$%^') =
                                 NVL (t.gty_type, '£$%^')
                             --        and g.parent_group_type = 'GR20'
                             AND nth_base_table_theme IS NULL
                             AND nth_feature_table NOT LIKE 'SECT_SS%') t2
               WHERE ROWNUM = 1
            ORDER BY levl;

            RETURN retval;
        END;
    -----------------------------------------------------------------------------------------------------------------
    BEGIN
        --  nm_debug.delete_debug(true);
        --  nm_debug.debug_on;
        NM_DEBUG.DEBUG (l_tab);

        nm3ctx.set_context ('PARENT_GROUP_TYPE', p_Gty_Type);

        l_Tab := Get_Nat_Feature_Table_Name (p_Nt_Type, p_Gty_Type);

        nm_debug.debug ('Table name = ' || l_tab);

        --l_View  := Get_Nt_View_Name (p_Nt_Type, p_Gty_Type);

        l_Base_Themes := Get_Base_Themes;

        nm_debug.debug (TO_CHAR (l_base_themes.nta_theme_array (1).nthe_id));

        Nm3Sdo.Set_Diminfo_And_Srid (l_Base_Themes, l_Diminfo, l_Srid);

        IF l_diminfo.COUNT > 2
        THEN
            l_Diminfo := SDO_LRS.Convert_To_Std_Dim_Array (l_Diminfo);
        END IF;

        --check tha the effective date is today - otherwise the layer will be out of step already!
        --generate the area type
        --
        nm_debug.debug ('Creating spatial table ');

        Create_Spatial_Table (l_Tab,
                              TRUE,
                              'START_DATE',
                              'END_DATE');

        nm_debug.debug ('Created Table ' || l_Tab);
        ---------------------------------------------------------------
        -- Set the registration of metadata
        ---------------------------------------------------------------
        l_Usgm.Table_Name := l_Tab;
        l_Usgm.Column_Name := 'GEOLOC';
        l_Usgm.Diminfo := l_Diminfo;
        l_Usgm.Srid := l_Srid;

        Nm3Sdo.Ins_Usgm (l_Usgm);

        l_Theme_Id :=
            Register_Nat_Theme (p_Nt_Type,
                                p_Gty_Type,
                                l_Base_Themes,
                                l_Tab,
                                'GEOLOC',
                                'NE_ID',
                                NULL,
                                'N');
        l_Seq := Nm3Sdo.Create_Spatial_Seq (l_Theme_Id);

        IF NOT Nm3Ddl.Does_Object_Exist (l_View, 'VIEW')
        THEN
            Nm3Inv_View.Create_View_For_Nt_Type (p_Nt_Type, p_Gty_Type);
        END IF;

        /*
          Create_Spatial_Date_View (l_Tab);

          l_Usgm.Table_Name  := 'V_' || l_Tab;
          Nm3Sdo.Ins_Usgm ( l_Usgm );

          l_V_Theme_Id := Register_Nat_Theme  (
                                              p_Nt_Type,
                                              p_Gty_Type,
                                              l_Base_Themes,
                                              'V_' || L_Tab,
                                              'GEOLOC',
                                              'NE_ID',
                                              'V_'|| L_Tab,
                                              'Y',
                                              l_Theme_Id
                                              );
        */

        nm_debug.debug_on;
        nm_debug.debug ('Creating data');

        nm3sdo.create_gofg_Data (p_Table_Name   => l_Tab,
                                 p_Gty_Type     => p_Gty_Type,
                                 p_Seq_Name     => l_Seq,
                                 p_Job_Id       => p_Job_Id);
        --table needs a spatial index

        Nm3Sdo.Create_Spatial_Idx (l_Tab);


        --need a join view between spatial table and NT view


        l_View :=
            nm3sdm.Create_Nat_Sdo_Join_View (p_Feature_Table_Name => l_Tab);
        l_Usgm.Table_Name := l_View;

        Nm3Sdo.Ins_Usgm (l_Usgm);

        IF G_Date_Views = 'Y'
        THEN
            L_V_Theme_Id :=
                Register_Nat_Theme (p_Nt_Type,
                                    p_Gty_Type,
                                    l_Base_Themes,
                                    l_View,
                                    'GEOLOC',
                                    'NE_ID',
                                    NULL,
                                    'Y',
                                    l_Theme_Id);
        END IF;

        BEGIN
            Nm3Ddl.Analyse_Table (
                pi_Table_Name            => l_Tab,
                pi_Schema                =>
                    SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER'),
                pi_Estimate_Percentage   => NULL,
                pi_Auto_Sample_Size      => FALSE);
        --  Exception
        --    When Others Then
        --      Raise E_No_Analyse_Privs;
        END;
    --
    --  Nm_Debug.Proc_End (G_Package_Name, 'make_ona_inv_spatial_layer');
    --
    --Exception
    --  When E_Not_Unrestricted Then
    --    Raise_Application_Error (-20777,'Restricted users are not permitted to create SDO layers');
    --
    --  When E_No_Analyse_Privs Then
    --    Raise_Application_Error (-20778,'Layer created - but user does not have ANALYZE ANY granted. '||
    --                                    'Please ensure the correct role/privs are applied to the user');

    END Create_G_of_G_Group_Layer;

    --
    ------------------------------------
    --


    PROCEDURE Create_Non_Linear_Group_Layer (
        p_Nt_Type    IN Nm_Types.Nt_Type%TYPE,
        p_Gty_Type   IN Nm_Group_Types.Ngt_Group_Type%TYPE,
        p_Job_Id     IN NUMBER DEFAULT NULL)
    AS
        l_Tab           Nm_Themes_All.Nth_Feature_Table%TYPE;
        l_View          Nm_Themes_All.Nth_Table_Name%TYPE;
        l_Seq           VARCHAR2 (30);

        l_Base_Themes   Nm_Theme_Array;
        l_Diminfo       MDSYS.Sdo_Dim_Array;
        l_Srid          NUMBER;

        l_Usgm          User_Sdo_Geom_Metadata%ROWTYPE;

        l_Theme_Id      Nm_Themes_All.Nth_Theme_Id%TYPE;
        l_V_Theme_Id    Nm_Themes_All.Nth_Theme_Id%TYPE;
    -----------------------------------------------------------------------------------------------------------------
    BEGIN
        l_Tab := Get_Nat_Feature_Table_Name (p_Nt_Type, p_Gty_Type);
        l_View := Get_Nt_View_Name (p_Nt_Type, p_Gty_Type);

        l_Base_Themes := Get_Nat_Base_Themes (p_Gty_Type);

        Nm3Sdo.Set_Diminfo_And_Srid (l_Base_Themes, l_Diminfo, l_Srid);

        l_Diminfo := SDO_LRS.Convert_To_Std_Dim_Array (l_Diminfo);

        --check tha the effective date is today - otherwise the layer will be out of step already!
        --generate the area type
        --
        Create_Spatial_Table (l_Tab,
                              FALSE,
                              'START_DATE',
                              'END_DATE');

        ---------------------------------------------------------------
        -- Set the registration of metadata
        ---------------------------------------------------------------
        l_Usgm.Table_Name := l_Tab;
        l_Usgm.Column_Name := 'GEOLOC';
        l_Usgm.Diminfo := l_Diminfo;
        l_Usgm.Srid := l_Srid;

        Nm3Sdo.Ins_Usgm (l_Usgm);

        l_Theme_Id :=
            Register_Nat_Theme (p_Nt_Type,
                                p_Gty_Type,
                                l_Base_Themes,
                                l_Tab,
                                'GEOLOC',
                                'NE_ID',
                                NULL,
                                'N');
        l_Seq := Nm3Sdo.Create_Spatial_Seq (l_Theme_Id);

        IF NOT Nm3Ddl.Does_Object_Exist (l_View, 'VIEW')
        THEN
            Nm3Inv_View.Create_View_For_Nt_Type (p_Nt_Type, p_Gty_Type);
        END IF;

        Create_Spatial_Date_View (l_Tab);

        l_Usgm.Table_Name := 'V_' || l_Tab;
        Nm3Sdo.Ins_Usgm (l_Usgm);

        l_V_Theme_Id :=
            Register_Nat_Theme (p_Nt_Type,
                                p_Gty_Type,
                                l_Base_Themes,
                                'V_' || L_Tab,
                                'GEOLOC',
                                'NE_ID',
                                NULL,
                                'Y',
                                l_Theme_Id);
        Nm3Sdo.Create_Non_Linear_Data (p_Table_Name   => l_Tab,
                                       p_Gty_Type     => p_Gty_Type,
                                       p_Seq_Name     => l_Seq,
                                       p_Job_Id       => p_Job_Id);
        --table needs a spatial index

        Nm3Sdo.Create_Spatial_Idx (l_Tab);

        --need a join view between spatial table and NT view

        l_View := Create_Nat_Sdo_Join_View (p_Feature_Table_Name => l_Tab);
        l_Usgm.Table_Name := l_View;

        Nm3Sdo.Ins_Usgm (l_Usgm);

        IF G_Date_Views = 'Y'
        THEN
            L_V_Theme_Id :=
                Register_Nat_Theme (p_Nt_Type,
                                    p_Gty_Type,
                                    l_Base_Themes,
                                    l_View,
                                    'GEOLOC',
                                    'NE_ID',
                                    NULL,
                                    'Y',
                                    l_Theme_Id);
        END IF;

        BEGIN
            Nm3Ddl.Analyse_Table (
                pi_Table_Name            => l_Tab,
                pi_Schema                =>
                    SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER'),
                pi_Estimate_Percentage   => NULL,
                pi_Auto_Sample_Size      => FALSE);
        EXCEPTION
            WHEN OTHERS
            THEN
                RAISE E_No_Analyse_Privs;
        END;

        --
        Nm_Debug.Proc_End (G_Package_Name, 'make_ona_inv_spatial_layer');
    --
    EXCEPTION
        WHEN E_Not_Unrestricted
        THEN
            Raise_Application_Error (
                -20777,
                'Restricted users are not permitted to create SDO layers');
        WHEN E_No_Analyse_Privs
        THEN
            Raise_Application_Error (
                -20778,
                   'Layer created - but user does not have ANALYZE ANY granted. '
                || 'Please ensure the correct role/privs are applied to the user');
    END Create_Non_Linear_Group_Layer;

    --
    ----------------------------------------------------------------------------------------------------------------------------------
    --
    FUNCTION Get_Theme_From_Feature_Table (
        p_Table   IN Nm_Themes_All.Nth_Feature_Table%TYPE)
        RETURN NUMBER
    IS
        Retval   NUMBER;
    BEGIN
        BEGIN
            SELECT nta.Nth_Theme_Id
              INTO Retval
              FROM Nm_Themes_All nta
             WHERE nta.Nth_Feature_Table = p_Table AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                Retval := NULL;
        END;

        RETURN Retval;
    END Get_Theme_From_Feature_Table;

    ------------------------------------------------------------------------
    FUNCTION Get_Theme_From_Feature_Table (
        p_Table         IN Nm_Themes_All.Nth_Feature_Table%TYPE,
        p_Theme_Table   IN Nm_Themes_All.Nth_Table_Name%TYPE)
        RETURN NUMBER
    IS
        Retval   NUMBER;
    BEGIN
        BEGIN
            SELECT nta.Nth_Theme_Id
              INTO Retval
              FROM Nm_Themes_All nta
             WHERE     nta.Nth_Feature_Table = p_Table
                   AND nta.Nth_Table_Name = p_Theme_Table;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                Retval := NULL;
        END;

        RETURN Retval;
    END Get_Theme_From_Feature_Table;

    --
    ----------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Drop_Unused_Sequences
    IS
    BEGIN
        FOR Irec
            IN (SELECT usq.Sequence_Name
                  FROM User_Sequences usq
                 WHERE     usq.Sequence_Name LIKE 'NTH%'
                       AND NOT EXISTS
                               (SELECT NULL
                                  FROM Nm_Themes_All nta
                                 WHERE TO_CHAR (nta.Nth_Theme_Id) =
                                       SUBSTR (
                                           usq.Sequence_Name,
                                           5,
                                             INSTR (
                                                 SUBSTR (usq.Sequence_Name,
                                                         5),
                                                 '_')
                                           - 1))
                       AND usq.Sequence_Name != 'NTH_THEME_ID_SEQ')
        LOOP
            Nm3Ddl.Drop_Synonym_For_Object (Irec.Sequence_Name);

            EXECUTE IMMEDIATE 'drop sequence ' || Irec.Sequence_Name;
        END LOOP;
    END Drop_Unused_Sequences;

    --
    ----------------------------------------------------------------------------------------------------------------------------------
    --
    -- When updating members, test to see if a theme is immediate - not appropriate to linear layers
    --
    FUNCTION Get_Update_Flag (p_Type          IN VARCHAR2,
                              p_Obj_Type      IN VARCHAR2,
                              p_Update_Flag   IN VARCHAR2 DEFAULT NULL)
        RETURN VARCHAR2
    IS
        Retval   Nm_Themes_All.Nth_Update_On_Edit%TYPE := 'N';
    BEGIN
        IF p_Type = 'I'
        THEN
            BEGIN
                SELECT nta.Nth_Update_On_Edit
                  INTO Retval
                  FROM Nm_Themes_All nta, Nm_Inv_Themes nit
                 WHERE     nta.Nth_Theme_Id = nit.Nith_Nth_Theme_Id
                       AND nit.Nith_Nit_Id = p_Obj_Type
                       AND nta.Nth_Update_On_Edit =
                           DECODE (p_Update_Flag,
                                   NULL, nta.Nth_Update_On_Edit,
                                   p_Update_Flag)
                       AND ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    Retval := 'N';
            END;
        ELSIF p_Type = 'G'
        THEN
            BEGIN
                SELECT nta.Nth_Update_On_Edit
                  INTO Retval
                  FROM Nm_Themes_All   nta,
                       Nm_Area_Themes  nat,
                       Nm_Area_Types   naty
                 WHERE     nta.Nth_Theme_Id = nat.Nath_Nth_Theme_Id
                       AND nat.Nath_Nat_Id = naty.Nat_Id
                       AND naty.Nat_Gty_Group_Type = p_Obj_Type
                       AND nta.Nth_Update_On_Edit =
                           DECODE (p_Update_Flag,
                                   NULL, nta.Nth_Update_On_Edit,
                                   p_Update_Flag)
                       AND ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    Retval := 'N';
            END;
        END IF;

        RETURN Retval;
    END Get_Update_Flag;

    --
    -------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Attach_Theme_To_Ft (p_Nth_Id IN NUMBER, p_Ft_Nit IN VARCHAR2)
    IS
        l_Nth   Nm_Themes_All%ROWTYPE;
        l_Nit   Nm_Inv_Types%ROWTYPE;
    BEGIN
        l_Nth := Nm3Get.Get_Nth (p_Nth_Id);
        l_Nit := Nm3Get.Get_Nit (p_Ft_Nit);

        IF l_Nth.Nth_Table_Name != l_Nit.Nit_Table_Name
        THEN
            Hig.Raise_Ner (pi_Appl      => Nm3Type.C_Hig,
                           pi_Id        => 249,
                           pi_Sqlcode   => -20001);
        --  raise_application_error(-20001,'FT and theme do not match');
        ELSE
            INSERT INTO Nm_Inv_Themes (Nith_Nit_Id, Nith_Nth_Theme_Id)
                 VALUES (l_Nit.Nit_Inv_Type, l_Nth.Nth_Theme_Id);
        END IF;
    END Attach_Theme_To_Ft;

    --
    -------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Register_Sdo_Table_As_Ft_Theme (
        p_Nit_Type           IN Nm_Inv_Types.Nit_Inv_Type%TYPE,
        p_Shape_Col          IN VARCHAR2,
        p_Tol                IN NUMBER DEFAULT 0.005,
        p_Cre_Idx            IN VARCHAR2 DEFAULT 'N',
        p_Estimate_New_Tol   IN VARCHAR2 DEFAULT 'N')
    IS
        l_Nit      Nm_Inv_Types%ROWTYPE;
        l_Nth_Id   NUMBER;
    BEGIN
        l_Nit := Nm3Get.Get_Nit (p_Nit_Type);

        IF L_Nit.Nit_Table_Name IS NULL
        THEN
            Hig.Raise_Ner (pi_Appl      => Nm3Type.C_Hig,
                           pi_Id        => 250,
                           pi_Sqlcode   => -20001);
        --  raise_application_error( -20001, 'Inventory type is not a foreign table');
        END IF;

        Nm3Sdo.Register_Sdo_Table_As_Theme (l_Nit.Nit_Table_Name,
                                            l_Nit.Nit_Foreign_Pk_Column,
                                            l_Nit.Nit_Foreign_Pk_Column,
                                            p_Shape_Col,
                                            p_Tol,
                                            p_Cre_Idx,
                                            p_Estimate_New_Tol);
        l_Nth_Id := Get_Theme_From_Feature_Table (l_Nit.Nit_Table_Name);
        Attach_Theme_To_Ft (l_Nth_Id, l_Nit.Nit_Inv_Type);
    END Register_Sdo_Table_As_Ft_Theme;

    --
    ---------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Drop_Trigger_By_Theme_Id (
        p_Nth_Id   IN Nm_Themes_All.Nth_Theme_Id%TYPE)
    IS
    -- CWS 0110345 Trigger changed to ignore nm_themes_all. Table nm_themes_all
    -- is no longer referenced in cursor and any exception raised by dynamic sql
    -- will be caught.
    --
    BEGIN
        FOR Irec
            IN (SELECT ut.Trigger_Name
                  FROM User_Triggers ut
                 WHERE ut.Trigger_Name LIKE
                           'NM_NTH_' || TO_CHAR (p_Nth_Id) || '_SDO%')
        LOOP
            BEGIN
                EXECUTE IMMEDIATE 'DROP TRIGGER ' || Irec.Trigger_Name;
            EXCEPTION
                WHEN OTHERS
                THEN
                    NULL;
            END;
        END LOOP;
    END Drop_Trigger_By_Theme_Id;

    --
    ---------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Drop_Layer (p_Nth_Id               IN Nm_Themes_All.Nth_Theme_Id%TYPE,
                          p_Keep_Theme_Data      IN VARCHAR2 DEFAULT 'N',
                          p_Keep_Feature_Table   IN VARCHAR2 DEFAULT 'N')
    IS
        l_Nth   Nm_Themes_All%ROWTYPE;
        l_Seq   VARCHAR2 (30);
    --
    BEGIN
        l_Nth := Nm3Get.Get_Nth (p_Nth_Id);

        Drop_Trigger_By_Theme_Id (p_Nth_Id);

        IF l_Nth.Nth_Feature_Table IS NOT NULL
        THEN
            IF Hig.Get_Sysopt ('REGSDELAY') = 'Y'
            THEN
                DECLARE
                    Not_There   EXCEPTION;
                    PRAGMA EXCEPTION_INIT (Not_There, -20001);
                BEGIN
                    EXECUTE IMMEDIATE(   'begin '
                                      || '   nm3sde.drop_layer_by_theme( p_theme_id => '
                                      || TO_CHAR (L_Nth.Nth_Theme_Id)
                                      || ');'
                                      || 'end;');
                EXCEPTION
                    WHEN Not_There
                    THEN
                        NULL;
                END;
            END IF;

            IF p_Keep_Feature_Table = 'N'
            THEN
                BEGIN
                    -- AE 23-SEP-2008
                    -- Drop views instead of synonyms
                    Nm3Ddl.Drop_Views_For_Object (l_Nth.Nth_Feature_Table);
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        NULL;
                --    problem in privileges on the development schema - dropping synonyms failed - needs further investigation.
                END;

                BEGIN
                    --cws
                    Nm3Ddl.Drop_Synonym_For_Object (l_Nth.Nth_Feature_Table);
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        NULL;
                --    problem in privileges on the development schema - dropping synonyms failed - needs further investigation.
                END;

                Drop_Object (l_Nth.Nth_Feature_Table);
                Nm3Sdo.Drop_Metadata (l_Nth.Nth_Feature_Table);

                IF Nm3Sdo.Use_Surrogate_Key = 'Y'
                THEN
                    l_Seq := Nm3Sdo.Get_Spatial_Seq (p_Nth_Id);

                    IF Nm3Ddl.Does_Object_Exist (l_Seq)
                    THEN
                        BEGIN
                            Nm3Ddl.Drop_Synonym_For_Object (l_Seq);
                        EXCEPTION
                            WHEN OTHERS
                            THEN
                                NULL;
                        END;

                        Drop_Object (l_Seq);
                    END IF;
                END IF;
            END IF;                               -- keep feature table end if
        END IF;

        --
        IF p_Keep_Theme_Data = 'N'
        THEN
            DELETE FROM Nm_Themes_All nta
                  WHERE nta.Nth_Theme_Id = p_Nth_Id;
        END IF;
    --
    END Drop_Layer;

    --
    ---------------------------------------------------------------------------------------------------------------------------------
    --
    FUNCTION Get_Object_Type (p_Object IN VARCHAR2)
        RETURN VARCHAR2
    IS
        Retval   VARCHAR2 (30);
    BEGIN
        BEGIN
            SELECT ao.Object_Type
              INTO Retval
              FROM All_Objects ao
             WHERE     ao.Owner =
                       SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                   AND ao.Object_Name = p_Object
                   AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                Hig.Raise_Ner (pi_Appl      => Nm3Type.C_Hig,
                               pi_Id        => 257,
                               pi_Sqlcode   => -20001);
        END;

        RETURN Retval;
    END Get_Object_Type;

    --
    ---------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Drop_Object (p_Object_Name IN VARCHAR2)
    IS
        l_Obj_Type   VARCHAR2 (30);
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        IF Nm3Ddl.Does_Object_Exist (p_Object_Name)
        THEN
            l_Obj_Type := Get_Object_Type (p_Object_Name);

            EXECUTE IMMEDIATE 'drop ' || l_Obj_Type || ' ' || p_Object_Name;
        END IF;
    END Drop_Object;

    --
    ---------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Drop_Layers_By_Inv_Type (
        p_Nit_Id       IN Nm_Inv_Types.Nit_Inv_Type%TYPE,
        p_Keep_Table   IN BOOLEAN DEFAULT FALSE)
    IS
        l_Tab_Nth_Id   Nm3Type.Tab_Number;
        l_Keep_Table   VARCHAR2 (1);
    BEGIN
        IF p_Keep_Table
        THEN
            l_Keep_Table := 'Y';
        ELSE
            l_Keep_Table := 'N';
        END IF;

          SELECT nit.Nith_Nth_Theme_Id
            BULK COLLECT INTO l_Tab_Nth_Id
            FROM Nm_Inv_Themes nit, Nm_Themes_All nta
           WHERE     nit.Nith_Nit_Id = p_Nit_Id
                 AND nta.Nth_Theme_Id = nit.Nith_Nth_Theme_Id
        ORDER BY DECODE (Nth_Base_Table_Theme, NULL, 'B', 'A');

        FOR i IN 1 .. l_Tab_Nth_Id.COUNT
        LOOP
            Nm3Sdm.Drop_Layer (p_Nth_Id               => l_Tab_Nth_Id (i),
                               p_Keep_Feature_Table   => l_Keep_Table);
        END LOOP;
    END Drop_Layers_By_Inv_Type;

    --
    ---------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Drop_Layers_By_Gty_Type (
        p_Gty   IN Nm_Group_Types.Ngt_Group_Type%TYPE)
    IS
        --
        l_Tab_Nth_Id   Nm3Type.Tab_Number;
        l_Tab_Order    Nm3Type.Tab_Varchar1;
    --
    BEGIN
        SELECT nnt.Nnth_Nth_Theme_Id,
               DECODE (nta.Nth_Base_Table_Theme, NULL, 'A', 'B')
          BULK COLLECT INTO l_Tab_Nth_Id, l_Tab_Order
          FROM Nm_Nw_Themes nnt, Nm_Linear_Types nlt, Nm_Themes_All nta
         WHERE     nnt.Nnth_Nlt_Id = nlt.Nlt_Id
               AND nlt.Nlt_Gty_Type = p_Gty
               AND nnt.Nnth_Nth_Theme_Id = nta.Nth_Theme_Id
        UNION
        SELECT Nath_Nth_Theme_Id,
               DECODE (Nth_Base_Table_Theme, NULL, 'A', 'B')
          FROM Nm_Area_Themes nat, Nm_Area_Types naty, Nm_Themes_All nta
         WHERE     nat.Nath_Nat_Id = naty.Nat_Id
               AND naty.Nat_Gty_Group_Type = p_Gty
               AND nat.Nath_Nth_Theme_Id = nta.Nth_Theme_Id
        ORDER BY 2 DESC;

        FOR i IN 1 .. l_Tab_Nth_Id.COUNT
        LOOP
            Drop_Layer (p_Nth_Id => l_Tab_Nth_Id (i));
        END LOOP;
    END Drop_Layers_By_Gty_Type;

    --
    ---------------------------------------------------------------------------------------------------------------------------------
    --
    FUNCTION Type_Has_Shape (p_Type IN VARCHAR2)
        RETURN BOOLEAN
    IS
        Retval   BOOLEAN;
        Dummy    VARCHAR2 (1);
    BEGIN
        BEGIN
            SELECT NULL
              INTO Dummy
              FROM DUAL
             WHERE EXISTS
                       (SELECT NULL
                          FROM Nm_Area_Types
                         WHERE Nat_Gty_Group_Type = p_Type
                        UNION
                        SELECT NULL
                          FROM Nm_Inv_Themes
                         WHERE Nith_Nit_Id = p_Type);

            Retval := TRUE;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                Retval := FALSE;
        END;

        RETURN Retval;
    END Type_Has_Shape;

    --
    ---------------------------------------------------------------------------------------------------------------------------------
    --
    FUNCTION Theme_Is_Ft (P_Nth_Theme_Id IN Nm_Themes_All.Nth_Theme_Id%TYPE)
        RETURN BOOLEAN
    IS
        Retval    BOOLEAN := FALSE;
        l_Dummy   NUMBER;
    BEGIN
        BEGIN
            SELECT NULL
              INTO l_Dummy
              FROM Nm_Themes_All nta, Nm_Inv_Themes nith, Nm_Inv_Types nit
             WHERE     nta.Nth_Theme_Id = nith.Nith_Nth_Theme_Id
                   AND nith.Nith_Nit_Id = Nit_Inv_Type
                   AND nit.Nit_Table_Name IS NOT NULL
                   AND ROWNUM = 1;

            Retval := TRUE;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                Retval := FALSE;
        END;

        RETURN Retval;
    END Theme_Is_Ft;

    --
    ---------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Set_Subuser_Globals_Nthr (
        pi_Role       IN Nm_Theme_Roles.Nthr_Role%TYPE,
        pi_Theme_Id   IN Nm_Theme_Roles.Nthr_Theme_Id%TYPE,
        pi_Mode       IN VARCHAR2)
    IS
    BEGIN
        g_Role_Array (g_Role_Idx) := pi_Role;
        g_Theme_Role (g_Role_Idx) := pi_Theme_Id;
        g_Role_Op (g_Role_Idx) := pi_Mode;
    END Set_Subuser_Globals_Nthr;

    --
    ---------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Set_Subuser_Globals_Hur (
        pi_Role       IN Nm_Theme_Roles.Nthr_Role%TYPE,
        pi_Username   IN Hig_User_Roles.Hur_Username%TYPE,
        pi_Mode       IN VARCHAR2)
    IS
    BEGIN
        g_Role_Array (g_Role_Idx) := pi_Role;
        g_Username_Array (g_Role_Idx) := pi_Username;
        g_Role_Op (g_Role_Idx) := pi_Mode;
    END Set_Subuser_Globals_Hur;

    --
    ---------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Drop_Feature_View (pi_Owner       IN VARCHAR2,
                                 pi_View_Name   IN VARCHAR2)
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        BEGIN
            EXECUTE IMMEDIATE 'DROP VIEW ' || pi_Owner || '.' || pi_View_Name;
        EXCEPTION
            WHEN OTHERS
            THEN
                NULL;
        END;

        BEGIN
            EXECUTE IMMEDIATE   'DROP SYNONYM '
                             || pi_Owner
                             || '.'
                             || pi_View_Name;
        EXCEPTION
            WHEN OTHERS
            THEN
                NULL;
        END;
    END Drop_Feature_View;

    --
    ---------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Create_Feature_View (pi_Owner       IN VARCHAR2,
                                   pi_View_Name   IN VARCHAR2)
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        BEGIN
            -- CWS
            EXECUTE IMMEDIATE 'DROP VIEW ' || pi_Owner || '.' || pi_View_Name;
        EXCEPTION
            WHEN OTHERS
            THEN
                NULL;
        END;

        BEGIN
            -- CWS
            EXECUTE IMMEDIATE(   'CREATE OR REPLACE SYNONYM '
                              || pi_Owner
                              || '.'
                              || pi_View_Name
                              || ' FOR '
                              || SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                              || '.'
                              || pi_View_Name);
        EXCEPTION
            WHEN OTHERS
            THEN
                NULL;
        END;
    END Create_Feature_View;

    --
    ---------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Process_Subuser_Nthr
    /* Procedure to deal with creating subordinate user metadata triggered on
     nm_theme_roles data */
    IS
        --
        PROCEDURE Create_Sub_Sdo_Layer (
            pi_Theme_Id   IN Nm_Themes_All.Nth_Theme_Id%TYPE,
            pi_Role       IN Nm_Theme_Roles.Nthr_Role%TYPE)
        IS
        BEGIN
            --
            -- Insert the USGM based on current theme and role
            --
            nm_debug.debug_on;
            nm_debug.debug (
                   'Running Create_Sub_Sdo_Layer from Process_Subuser_Nthr for '
                || pi_theme_id
                || ' - '
                || pi_role);

            INSERT INTO Mdsys.Sdo_Geom_Metadata_Table G (Sdo_Owner,
                                                         Sdo_Table_Name,
                                                         Sdo_Column_Name,
                                                         Sdo_Diminfo,
                                                         Sdo_Srid)
                SELECT x.Hus_Username,
                       x.Nth_Feature_Table,
                       x.Nth_Feature_Shape_Column,
                       u.Sdo_Diminfo,
                       u.Sdo_Srid
                  FROM Mdsys.Sdo_Geom_Metadata_Table  u,
                       (  SELECT y.Hus_Username,
                                 y.Nth_Feature_Table,
                                 y.Nth_Feature_Shape_Column
                            FROM -- Layers based on role - more than likely views
                                 (SELECT hu.Hus_Username,
                                         nta.Nth_Feature_Table,
                                         nta.Nth_Feature_Shape_Column
                                    FROM Nm_Themes_All nta,
                                         Nm_Theme_Roles ntr,
                                         Hig_User_Roles hur,
                                         Hig_Users     hu,
                                         All_Users     au
                                   WHERE     Nthr_Theme_Id = nta.Nth_Theme_Id
                                         AND nta.Nth_Theme_Id = pi_Theme_Id
                                         AND ntr.Nthr_Role = hur.Hur_Role
                                         AND hur.Hur_Role = pi_Role
                                         AND hur.Hur_Username = hu.Hus_Username
                                         AND hu.Hus_Username = au.Username
                                         AND hu.Hus_Username !=
                                             SYS_CONTEXT ('NM3CORE',
                                                          'APPLICATION_OWNER')
                                         AND NOT EXISTS
                                                 (SELECT NULL
                                                    FROM Mdsys.Sdo_Geom_Metadata_Table
                                                         g1
                                                   WHERE     g1.Sdo_Owner =
                                                             hu.Hus_Username
                                                         AND g1.Sdo_Table_Name =
                                                             nta.Nth_Feature_Table
                                                         AND g1.Sdo_Column_Name =
                                                             nta.Nth_Feature_Shape_Column)
                                  UNION ALL
                                  -- Base table themes
                                  SELECT hu.Hus_Username,
                                         nta2.Nth_Feature_Table,
                                         nta2.Nth_Feature_Shape_Column
                                    FROM Nm_Themes_All nta,
                                         Hig_Users    hu,
                                         All_Users    au,
                                         Nm_Themes_All nta2
                                   WHERE     nta2.Nth_Theme_Id =
                                             nta.Nth_Base_Table_Theme
                                         AND nta.Nth_Theme_Id = Pi_Theme_Id
                                         AND hu.Hus_Username = au.Username
                                         AND hu.Hus_Username !=
                                             SYS_CONTEXT ('NM3CORE',
                                                          'APPLICATION_OWNER')
                                         AND NOT EXISTS
                                                 (SELECT NULL
                                                    FROM Mdsys.Sdo_Geom_Metadata_Table
                                                         G1
                                                   WHERE     g1.Sdo_Owner =
                                                             hu.Hus_Username
                                                         AND g1.Sdo_Table_Name =
                                                             nta2.Nth_Feature_Table
                                                         AND g1.Sdo_Column_Name =
                                                             nta2.Nth_Feature_Shape_Column))
                                 y
                        GROUP BY y.Hus_Username,
                                 y.Nth_Feature_Table,
                                 y.Nth_Feature_Shape_Column) x
                 WHERE     u.Sdo_Table_Name = x.Nth_Feature_Table
                       AND u.Sdo_Column_Name = x.Nth_Feature_Shape_Column
                       AND u.Sdo_Owner =
                           SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER');

            FOR i
                IN (  SELECT x.Hus_Username,
                             x.Nth_Feature_Table,
                             x.Nth_Feature_Shape_Column
                        FROM  -- Layers based on role - more than likely views
                             (SELECT hu.Hus_Username,
                                     nta.Nth_Feature_Table,
                                     nta.Nth_Feature_Shape_Column
                                FROM Nm_Themes_All nta,
                                     Nm_Theme_Roles ntr,
                                     Hig_User_Roles hur,
                                     Hig_Users     hu,
                                     All_Users     au
                               WHERE     ntr.Nthr_Theme_Id = nta.Nth_Theme_Id
                                     AND nta.Nth_Theme_Id = pi_Theme_Id
                                     AND ntr.Nthr_Role = hur.Hur_Role
                                     AND hur.Hur_Role = pi_Role
                                     AND hur.Hur_Username = hu.Hus_Username
                                     AND hu.Hus_Username = au.Username
                                     AND hu.Hus_Username !=
                                         SYS_CONTEXT ('NM3CORE',
                                                      'APPLICATION_OWNER')
                              UNION ALL
                              -- Base table themes
                              SELECT Hus_Username,
                                     nta2.Nth_Feature_Table,
                                     nta2.Nth_Feature_Shape_Column
                                FROM Nm_Themes_All nta,
                                     Hig_Users    hu,
                                     All_Users    au,
                                     Nm_Themes_All nta2
                               WHERE     nta2.Nth_Theme_Id =
                                         nta.Nth_Base_Table_Theme
                                     AND nta.Nth_Theme_Id = Pi_Theme_Id
                                     AND hu.Hus_Username = au.Username
                                     AND hu.Hus_Username !=
                                         SYS_CONTEXT ('NM3CORE',
                                                      'APPLICATION_OWNER')) x
                    GROUP BY x.Hus_Username,
                             x.Nth_Feature_Table,
                             x.Nth_Feature_Shape_Column)
            LOOP
                --
                -- No longer required.
                --Create_Feature_View (I.Hus_Username, I.Nth_Feature_Table);

                IF Hig.Get_User_Or_Sys_Opt ('REGSDELAY') = 'Y'
                THEN
                    IF NOT check_sub_sde_exempt (i.nth_feature_table)
                    THEN
                        BEGIN
                            EXECUTE IMMEDIATE(   ' begin '
                                              || 'nm3sde.create_sub_sde_layer ( p_theme_id => '
                                              || pi_Theme_Id
                                              || ',p_username => '''
                                              || i.Hus_Username
                                              || ''');'
                                              || ' end;');
                        EXCEPTION
                            WHEN OTHERS
                            THEN
                                NULL;
                        END;
                    END IF;
                END IF;
            END LOOP;
        END Create_Sub_Sdo_Layer;

        --
        --------------------------------------------------------------------------
        --
        PROCEDURE Delete_Sub_Sdo_Layer (
            pi_Theme_Id   IN Nm_Themes_All.Nth_Theme_Id%TYPE,
            pi_Role       IN Nm_Theme_Roles.Nthr_Role%TYPE)
        IS
            l_Tab_Owner         Nm3Type.Tab_Varchar30;
            l_Tab_Table_Name    Nm3Type.Tab_Varchar30;
            l_Tab_Column_Name   Nm3Type.Tab_Varchar30;
        --
        BEGIN
            --
            SELECT Hus_Username, Nth_Feature_Table, Nth_Feature_Shape_Column
              BULK COLLECT INTO l_Tab_Owner,
                                l_Tab_Table_Name,
                                l_Tab_Column_Name
              FROM (SELECT Hus_Username,
                           Nth_Feature_Table,
                           Nth_Feature_Shape_Column
                      FROM (  SELECT hu.Hus_Username,
                                     nta.Nth_Feature_Table,
                                     nta.Nth_Feature_Shape_Column
                                FROM Nm_Themes_All nta,
                                     Hig_User_Roles hur,
                                     Hig_Users     hu,
                                     All_Users     au
                               WHERE     nta.Nth_Theme_Id = pi_Theme_Id
                                     AND hur.Hur_Role = pi_Role
                                     AND hur.Hur_Username = hu.Hus_Username
                                     AND hu.Hus_Username = au.Username
                                     AND hu.Hus_Username !=
                                         SYS_CONTEXT ('NM3CORE',
                                                      'APPLICATION_OWNER')
                                     AND NOT EXISTS
                                             (SELECT NULL
                                                FROM Hig_User_Roles hur2,
                                                     Nm_Theme_Roles ntr
                                               WHERE     hur2.Hur_Username =
                                                         hu.Hus_Username
                                                     AND hur2.Hur_Role =
                                                         ntr.Nthr_Role
                                                     AND ntr.Nthr_Theme_Id =
                                                         nta.Nth_Theme_Id
                                                     AND hur2.Hur_Role !=
                                                         Pi_Role)
                            GROUP BY hu.Hus_Username,
                                     nta.Nth_Feature_Table,
                                     nta.Nth_Feature_Shape_Column)) Layers;

            --
            IF l_Tab_Owner.COUNT > 0
            THEN
                FORALL i IN 1 .. l_Tab_Owner.COUNT
                    DELETE Mdsys.Sdo_Geom_Metadata_Table
                     WHERE     Sdo_Owner = l_Tab_Owner (i)
                           AND Sdo_Table_Name = l_Tab_Table_Name (i)
                           AND Sdo_Column_Name = l_Tab_Column_Name (i);

                -----------------------------------
                -- Drop subordinate feature views
                -----------------------------------

                FOR i IN 1 .. l_Tab_Owner.COUNT
                LOOP
                    Drop_Feature_View (l_Tab_Owner (i), l_Tab_Table_Name (i));

                    -----------------------------------------
                    -- Drop SDE layers for subordinate users
                    -----------------------------------------

                    IF Hig.Get_User_Or_Sys_Opt ('REGSDELAY') = 'Y'
                    THEN
                        BEGIN
                            EXECUTE IMMEDIATE   'begin '
                                             || 'nm3sde.drop_sub_layer_by_table( '
                                             || Nm3Flx.String (
                                                    l_Tab_Table_Name (i))
                                             || ','
                                             || Nm3Flx.String (
                                                    l_Tab_Column_Name (i))
                                             || ','
                                             || Nm3Flx.String (
                                                    l_Tab_Owner (i))
                                             || ');'
                                             || ' end;';
                        EXCEPTION
                            WHEN OTHERS
                            THEN
                                NULL;
                        END;
                    END IF;
                END LOOP;
            END IF;
        END Delete_Sub_Sdo_Layer;
    --
    BEGIN
        --
        --------------------------------------------------------------
        -- Loop through the rows being processed from nm_theme_roles
        --------------------------------------------------------------

        -----------
        -- INSERTS
        -----------

        FOR i IN 1 .. G_Role_Idx
        LOOP
            BEGIN
                IF g_Role_Op (i) = 'I'
                THEN
                    Create_Sub_Sdo_Layer (pi_Theme_Id   => g_Theme_Role (i),
                                          pi_Role       => g_Role_Array (i));
                ----------
                -- DELETES
                ----------
                ELSIF g_Role_Op (i) = 'D'
                THEN
                    Delete_Sub_Sdo_Layer (pi_Theme_Id   => g_Theme_Role (i),
                                          pi_Role       => g_Role_Array (i));
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    NULL;
            END;
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            NULL;
    END Process_Subuser_Nthr;

    --
    ---------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Process_Subuser_Hur
    /* Procedure to deal with creating subordinate user metadata triggered on
     nm_theme_roles data */
    IS
        --
        PROCEDURE Create_Sub_Sdo_Layers (
            pi_Username   IN Hig_Users.Hus_Username%TYPE,
            pi_Role       IN Nm_Theme_Roles.Nthr_Role%TYPE)
        IS
            l_User   Hig_Users.Hus_Username%TYPE := pi_Username;
        BEGIN
            --
            nm_debug.debug_on;
            nm_debug.debug (
                   'Running Create_Sub_Sdo_Layer from Process_Subuser_Hur for '
                || pi_Username
                || ' - '
                || pi_role);

            INSERT INTO Mdsys.Sdo_Geom_Metadata_Table g (Sdo_Owner,
                                                         Sdo_Table_Name,
                                                         Sdo_Column_Name,
                                                         Sdo_Diminfo,
                                                         Sdo_Srid)
                SELECT l_User,
                       y.Nth_Feature_Table,
                       y.Nth_Feature_Shape_Column,
                       u.Sdo_Diminfo,
                       u.Sdo_Srid
                  FROM Mdsys.Sdo_Geom_Metadata_Table  u,
                       (  SELECT x.Nth_Feature_Table,
                                 x.Nth_Feature_Shape_Column
                            FROM -- Layers based on role - more than likely views
                                 (SELECT nta.Nth_Feature_Table,
                                         nta.Nth_Feature_Shape_Column
                                    FROM Nm_Themes_All nta, Nm_Theme_Roles ntr
                                   WHERE     ntr.Nthr_Theme_Id =
                                             nta.Nth_Theme_Id
                                         AND ntr.Nthr_Role = pi_Role
                                         AND NOT EXISTS
                                                 (SELECT NULL
                                                    FROM Mdsys.Sdo_Geom_Metadata_Table
                                                         g1
                                                   WHERE     g1.Sdo_Owner =
                                                             l_User
                                                         AND g1.Sdo_Table_Name =
                                                             nta.Nth_Feature_Table
                                                         AND g1.Sdo_Column_Name =
                                                             nta.Nth_Feature_Shape_Column)
                                  UNION ALL
                                  -- Base table themes
                                  SELECT nta2.Nth_Feature_Table,
                                         nta2.Nth_Feature_Shape_Column
                                    FROM Nm_Themes_All nta,
                                         Nm_Theme_Roles ntr,
                                         Nm_Themes_All nta2
                                   WHERE     nta2.Nth_Theme_Id =
                                             nta.Nth_Base_Table_Theme
                                         AND Nthr_Theme_Id = nta.Nth_Theme_Id
                                         AND Nthr_Role = pi_Role
                                         AND NOT EXISTS
                                                 (SELECT NULL
                                                    FROM Mdsys.Sdo_Geom_Metadata_Table
                                                         g1
                                                   WHERE     g1.Sdo_Owner =
                                                             l_User
                                                         AND g1.Sdo_Table_Name =
                                                             nta2.Nth_Feature_Table
                                                         AND g1.Sdo_Column_Name =
                                                             nta2.Nth_Feature_Shape_Column))
                                 x
                        GROUP BY Nth_Feature_Table, Nth_Feature_Shape_Column)
                       y
                 WHERE     u.Sdo_Table_Name = y.Nth_Feature_Table
                       AND u.Sdo_Column_Name = y.Nth_Feature_Shape_Column
                       AND u.Sdo_Owner =
                           SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER');

            FOR i
                IN (SELECT y.Nth_Theme_Id,
                           y.Nth_Feature_Table,
                           y.Nth_Feature_Shape_Column
                      FROM (  SELECT x.Nth_Theme_Id,
                                     x.Nth_Feature_Table,
                                     x.Nth_Feature_Shape_Column
                                FROM -- Layers based on role - more than likely views
                                     (SELECT nta.Nth_Theme_Id,
                                             nta.Nth_Feature_Table,
                                             nta.Nth_Feature_Shape_Column
                                        FROM Nm_Themes_All nta,
                                             Nm_Theme_Roles ntr
                                       WHERE     ntr.Nthr_Theme_Id =
                                                 nta.Nth_Theme_Id
                                             AND ntr.Nthr_Role = pi_Role
                                      UNION ALL
                                      -- Base table themes
                                      SELECT nta2.Nth_Theme_Id,
                                             nta2.Nth_Feature_Table,
                                             nta2.Nth_Feature_Shape_Column
                                        FROM Nm_Themes_All nta,
                                             Nm_Theme_Roles ntr,
                                             Nm_Themes_All nta2
                                       WHERE     nta2.Nth_Theme_Id =
                                                 nta.Nth_Base_Table_Theme
                                             AND ntr.Nthr_Theme_Id =
                                                 nta.Nth_Theme_Id
                                             AND ntr.Nthr_Role = pi_Role) x
                            GROUP BY x.Nth_Theme_Id,
                                     x.Nth_Feature_Table,
                                     x.Nth_Feature_Shape_Column) y)
            LOOP
                --
                -- No longer required
                -- Create_Feature_View (Pi_Username, I.Nth_Feature_Table);
                --
                IF Hig.Get_User_Or_Sys_Opt ('REGSDELAY') = 'Y'
                THEN
                    IF NOT check_sub_sde_exempt (i.nth_feature_table)
                    THEN
                        BEGIN
                            EXECUTE IMMEDIATE(   ' begin '
                                              || 'nm3sde.create_sub_sde_layer ( p_theme_id => '
                                              || TO_CHAR (I.Nth_Theme_Id)
                                              || ',p_username => '''
                                              || Pi_Username
                                              || ''');'
                                              || ' end;');
                        EXCEPTION
                            WHEN OTHERS
                            THEN
                                NULL;
                        END;
                    END IF;
                END IF;
            END LOOP;
        EXCEPTION
            WHEN OTHERS
            THEN
                NULL;
        END Create_Sub_Sdo_Layers;

        --
        PROCEDURE Delete_Sdo_Layers_By_Role (
            pi_Username   IN Hig_Users.Hus_Username%TYPE,
            pi_Role       IN Nm_Theme_Roles.Nthr_Role%TYPE)
        IS
            l_Tab_Owner         Nm3Type.Tab_Varchar30;
            l_Tab_Table_Name    Nm3Type.Tab_Varchar30;
            l_Tab_Column_Name   Nm3Type.Tab_Varchar30;
        BEGIN
            SELECT Layers.Hus_Username,
                   Layers.Nth_Feature_Table,
                   Layers.Nth_Feature_Shape_Column
              BULK COLLECT INTO l_Tab_Owner,
                                l_Tab_Table_Name,
                                l_Tab_Column_Name
              FROM (SELECT x.Hus_Username,
                           x.Nth_Feature_Table,
                           x.Nth_Feature_Shape_Column
                      FROM (  SELECT hu.Hus_Username,
                                     nta.Nth_Feature_Table,
                                     nta.Nth_Feature_Shape_Column
                                FROM Nm_Themes_All nta,
                                     Nm_Theme_Roles ntr,
                                     Hig_Users     hu,
                                     All_Users     au
                               WHERE     ntr.Nthr_Theme_Id = nta.Nth_Theme_Id
                                     AND ntr.Nthr_Role = pi_Role
                                     AND hu.Hus_Username = au.Username
                                     AND au.Username = pi_Username
                                     AND hu.Hus_Username !=
                                         SYS_CONTEXT ('NM3CORE',
                                                      'APPLICATION_OWNER')
                                     AND NOT EXISTS
                                             (SELECT NULL
                                                FROM Hig_User_Roles hur,
                                                     Nm_Theme_Roles ntr2
                                               WHERE     hur.Hur_Username =
                                                         pi_Username
                                                     AND hur.Hur_Role =
                                                         ntr2.Nthr_Role
                                                     AND ntr2.Nthr_Theme_Id =
                                                         nta.Nth_Theme_Id
                                                     AND hur.Hur_Role !=
                                                         pi_Role)
                            GROUP BY hu.Hus_Username,
                                     nta.Nth_Feature_Table,
                                     nta.Nth_Feature_Shape_Column) x) Layers;

            IF l_Tab_Owner.COUNT > 0
            THEN
                FORALL i IN 1 .. l_Tab_Owner.COUNT
                    DELETE Mdsys.Sdo_Geom_Metadata_Table
                     WHERE     Sdo_Owner = l_Tab_Owner (i)
                           AND Sdo_Table_Name = l_Tab_Table_Name (i)
                           AND Sdo_Column_Name = l_Tab_Column_Name (i);

                -----------------------------------
                -- Drop subordinate feature views
                -----------------------------------

                FOR i IN 1 .. l_Tab_Owner.COUNT
                LOOP
                    Drop_Feature_View (l_Tab_Owner (i), l_Tab_Table_Name (i));

                    -----------------------------------------
                    -- Drop SDE layers for subordinate users
                    -----------------------------------------

                    IF Hig.Get_User_Or_Sys_Opt ('REGSDELAY') = 'Y'
                    THEN
                        BEGIN
                            EXECUTE IMMEDIATE   'begin '
                                             || 'nm3sde.drop_sub_layer_by_table( '
                                             || Nm3Flx.String (
                                                    L_Tab_Table_Name (I))
                                             || ','
                                             || Nm3Flx.String (
                                                    L_Tab_Column_Name (I))
                                             || ','
                                             || Nm3Flx.String (
                                                    L_Tab_Owner (I))
                                             || ');'
                                             || ' end;';
                        --
                        EXCEPTION
                            WHEN OTHERS
                            THEN
                                NULL;
                        END;
                    END IF;
                END LOOP;
            END IF;
        --
        END Delete_Sdo_Layers_By_Role;
    --
    BEGIN
        FOR i IN 1 .. g_Role_Idx
        LOOP
            BEGIN
                --
                -- INSERTS
                --
                IF g_Role_Op (g_Role_Idx) = 'I'
                THEN
                    Create_Sub_Sdo_Layers (
                        pi_Username   => g_Username_Array (i),
                        pi_Role       => g_Role_Array (i));
                --
                --
                -- DELETES
                --
                ELSIF g_Role_Op (g_Role_Idx) = 'D'
                THEN
                    Delete_Sdo_Layers_By_Role (
                        pi_Username   => g_Username_Array (i),
                        pi_Role       => g_Role_Array (i));
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    NULL;
            END;
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            NULL;
    END Process_Subuser_Hur;

    --
    ---------------------------------------------------------------------------------------------------------------------------------
    --
    PROCEDURE Create_Nth_Sdo_Trigger (
        p_Nth_Theme_Id   IN Nm_Themes_All.Nth_Theme_Id%TYPE,
        p_Restrict       IN VARCHAR2 DEFAULT NULL)
    IS
        lf                    VARCHAR2 (1) := CHR (10);
        lq                    VARCHAR2 (1) := CHR (39);
        l_Update_Str          VARCHAR2 (2000);
        l_Comma               VARCHAR2 (1) := NULL;
        l_Trg_Name            VARCHAR2 (30);
        l_Tab_Or_View         VARCHAR2 (5);
        l_Date                VARCHAR2 (100);
        l_Nth                 Nm_Themes_All%ROWTYPE;
        l_Base_Table_Nth      Nm_Themes_All%ROWTYPE;
        l_Tab_Vc              Nm3Type.Tab_Varchar32767;

        CURSOR C1 (Objname IN VARCHAR2)
        IS
            SELECT uo.Object_Type
              FROM User_Objects uo
             WHERE uo.Object_Name = Objname;

        Ex_Invalid_Sequence   EXCEPTION;

        --
        --
        -- Function eventually needs to go into nm3sdo package
        --
        FUNCTION Get_Sdo_Trg_Name_A (
            p_Nth_Id   IN Nm_Themes_All.Nth_Theme_Id%TYPE)
            RETURN VARCHAR2
        IS
        BEGIN
            RETURN ('NM_NTH_' || TO_CHAR (p_Nth_Id) || '_SDO_A_ROW_TRG');
        END Get_Sdo_Trg_Name_A;

        --
        --
        -- Function eventually needs to go into nm3sdo package
        --
        FUNCTION Get_Sdo_Trg_Name_B (
            p_Nth_Id   IN Nm_Themes_All.Nth_Theme_Id%TYPE)
            RETURN VARCHAR2
        IS
        BEGIN
            RETURN ('NM_NTH_' || TO_CHAR (p_Nth_Id) || '_SDO_B_ROW_TRG');
        END Get_Sdo_Trg_Name_B;

        PROCEDURE Append (Pi_Text IN Nm3Type.Max_Varchar2)
        IS
        BEGIN
            Nm3Ddl.Append_Tab_Varchar (l_Tab_Vc, pi_Text);
        END Append;
    --
    BEGIN
        --
        --
        -- Driving Theme
        --
        l_Nth := Nm3Get.Get_Nth (pi_Nth_Theme_Id => p_Nth_Theme_Id);

        --
        -- Base Table Theme
        --

        IF l_Nth.Nth_Base_Table_Theme IS NULL
        THEN
            l_Base_Table_Nth := l_Nth;      -- base theme is the driving theme
        ELSE
            l_Base_Table_Nth :=
                Nm3Get.Get_Nth (pi_Nth_Theme_Id => l_Nth.Nth_Base_Table_Theme);
        END IF;


        OPEN C1 (L_Base_Table_Nth.Nth_Table_Name);

        FETCH C1 INTO L_Tab_Or_View;

        CLOSE C1;

        -- If the theme has an associated sequence then ensure that the sequence
        -- actually exists - cos we are about to reference it in our generated trigger
        --
        IF l_Base_Table_Nth.Nth_Sequence_Name IS NOT NULL
        THEN
            IF NOT Nm3Ddl.Does_Object_Exist (
                       p_Object_Name   => l_Base_Table_Nth.Nth_Sequence_Name,
                       p_Object_Type   => 'SEQUENCE')
            THEN
                RAISE Ex_Invalid_Sequence;
            END IF;
        END IF;

        --    we need to differentiate between join FT data and single table FT data. The first needs an after trigger the second should not be using this
        --    approach - it just needs a theme trigger to set the column, no insert/update/delete.

        l_Trg_Name := Get_Sdo_Trg_Name_A (l_Base_Table_Nth.Nth_Theme_Id);

        IF l_Base_Table_Nth.Nth_Rse_Fk_Column IS NOT NULL
        THEN
            l_Update_Str := l_Base_Table_Nth.Nth_Rse_Fk_Column;
            l_Comma := ',';
        END IF;

        IF L_Base_Table_Nth.Nth_St_Chain_Column IS NOT NULL
        THEN
            l_Update_Str :=
                   l_Update_Str
                || l_Comma
                || l_Base_Table_Nth.Nth_St_Chain_Column;
            l_Comma := ',';
        END IF;

        IF l_Base_Table_Nth.Nth_End_Chain_Column IS NOT NULL
        THEN
            l_Update_Str :=
                   l_Update_Str
                || l_Comma
                || l_Base_Table_Nth.Nth_End_Chain_Column;
            l_Comma := ',';
        END IF;

        -- if the x and y column are used as drivers, there should be no triggering
        -- when the element FK or offsets are changed.
        IF l_Base_Table_Nth.Nth_X_Column IS NOT NULL
        THEN
            l_Update_Str := l_Base_Table_Nth.Nth_X_Column;
            l_Comma := ',';
        END IF;

        IF l_Base_Table_Nth.Nth_Y_Column IS NOT NULL
        THEN
            l_Update_Str :=
                l_Update_Str || l_Comma || l_Base_Table_Nth.Nth_Y_Column;
        END IF;

        --
        l_Tab_Vc.Delete;
        -- This is the more common trigger - a theme by pure XY or by LRef.
        -- The trigger is an after row trigger and will fire on either update
        -- of XY or on update of LRef columns.
        Append ('CREATE OR REPLACE TRIGGER ' || LOWER (l_Trg_Name));
        l_Date := TO_CHAR (SYSDATE, 'DD-MON-YYYY HH:MI');
        Append ('--');
        Append (
            '--------------------------------------------------------------------------');
        Append ('--');
        Append ('--   PVCS Identifiers :-');
        Append ('--');
        Append (
            '--       PVCS id          : $Header::c   ' || Get_Body_Version);
        Append ('--       Module Name      : $Workfile:   nm3sdm.pkb  $');
        Append ('--       Version          : ' || G_Body_Sccsid);
        Append ('--');
        Append (
            '-----------------------------------------------------------------------------');
        Append (
            '--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.');
        Append (
            '-----------------------------------------------------------------------------');
        Append ('-- Author : R Coupe');
        Append ('--          G Johnson / A Edwards');
        Append ('--');
        Append ('--  #################');
        Append ('--  # DO NOT MODIFY #');
        Append ('--  #################');
        Append ('--');
        Append (
               '-- Trigger is built dynamically from the theme '
            || l_Nth.Nth_Theme_Id
            || ' on '
            || l_Nth.Nth_Theme_Name);
        Append ('--');
        Append ('-- Generated on ' || l_Date);
        Append ('--');
        Append (' ');

        -- Need to cater for views or tables
        -- difficulty with views is that the update seldom occurs on the view!
        IF l_Tab_Or_View = 'TABLE'
        THEN
            Append ('AFTER');
        ELSE
            Append ('INSTEAD OF ');
        END IF;

        Append ('DELETE OR INSERT OR UPDATE of ' || LOWER (l_Update_Str));
        Append ('ON ' || l_Base_Table_Nth.Nth_Table_Name);
        Append ('FOR EACH ROW');
        Append ('DECLARE' || Lf);
        Append (' l_geom mdsys.sdo_geometry;');
        Append (' l_lref nm_lref;' || Lf);
        Append ('--');
        Append (
            '--------------------------------------------------------------------------');
        Append ('--');
        --
        -- DELETE PROCEDURE
        --
        Append (' PROCEDURE del IS ');
        Append (' BEGIN');
        Append ('');
        Append (
               '    -- Delete from feature table '
            || LOWER (l_Base_Table_Nth.Nth_Feature_Table));
        Append (
            '    DELETE FROM ' || LOWER (l_Base_Table_Nth.Nth_Feature_Table));
        Append (
               '          WHERE '
            || LOWER (
                   NVL (l_Base_Table_Nth.Nth_Feature_Fk_Column,
                        l_Base_Table_Nth.Nth_Feature_Pk_Column))
            || ' = :OLD.'
            || LOWER (l_Base_Table_Nth.Nth_Pk_Column)
            || ';');
        Append (' ');
        Append (
            ' EXCEPTION -- when others to cater for attempted delete where no geom values supplied e.g. no x/y');
        Append ('     WHEN others THEN');
        Append ('       Null;');
        Append (' END del;');
        Append ('--');
        Append (
            '--------------------------------------------------------------------------');
        Append ('--');
        --
        -- INSERT PROCEDURE
        --
        Append (' PROCEDURE ins IS ');
        Append (' BEGIN');
        Append ('');
        Append (
               '   -- Insert into feature table '
            || LOWER (l_Base_Table_Nth.Nth_Feature_Table));
        Append (
            '    INSERT INTO ' || LOWER (l_Base_Table_Nth.Nth_Feature_Table));
        Append ('    ( ' || LOWER (l_Base_Table_Nth.Nth_Feature_Pk_Column));
        Append (
            '    , ' || LOWER (l_Base_Table_Nth.Nth_Feature_Shape_Column));

        IF l_Base_Table_Nth.Nth_Sequence_Name IS NOT NULL
        THEN
            Append ('    , objectid');
        END IF;

        Append ('    )');
        Append ('    VALUES ');
        Append ('    ( :NEW.' || LOWER (l_Base_Table_Nth.Nth_Pk_Column));

        --------------------------------------------------------------------------------------
        -- POINT X,Y ITEM
        --------------------------------------------------------------------------------------
        IF     l_Base_Table_Nth.Nth_X_Column IS NOT NULL
           AND l_Base_Table_Nth.Nth_Y_Column IS NOT NULL
        THEN
            Append ('    , mdsys.sdo_geometry');
            Append ('       ( 2001');
            Append (
                   '       , sys_context(''NM3CORE'',''THEME'
                || l_Base_Table_Nth.Nth_Theme_Id
                || 'SRID'')');
            Append ('       , mdsys.sdo_point_type');
            Append (
                '          ( :NEW.' || LOWER (l_Base_Table_Nth.Nth_X_Column));
            Append (
                '           ,:NEW.' || LOWER (l_Base_Table_Nth.Nth_Y_Column));
            Append ('           , NULL)');
            Append ('       , NULL');
            Append ('       , NULL) -- geometry derived from X,Y values');
        --------------------------------------------------------------------------------------
        -- POINT Linear Reference ITEM
        --------------------------------------------------------------------------------------
        ELSIF     l_Base_Table_Nth.Nth_St_Chain_Column IS NOT NULL
              AND l_Base_Table_Nth.Nth_End_Chain_Column IS NULL
        THEN
            Append (',nm3sdo.get_pt_shape_from_ne ( ');
            Append (
                   '                                 :NEW.'
                || LOWER (l_Base_Table_Nth.Nth_Rse_Fk_Column));
            Append (
                   '                                 ,:NEW.'
                || LOWER (l_Base_Table_Nth.Nth_St_Chain_Column)
                || ') -- geometry derived from start chainage reference');
        --------------------------------------------------------------------------------------
        -- CONTINUOUS Linear Reference ITEM
        --------------------------------------------------------------------------------------
        ELSIF     l_Base_Table_Nth.Nth_St_Chain_Column IS NOT NULL
              AND l_Base_Table_Nth.Nth_End_Chain_Column IS NOT NULL
        THEN
            -- Assume that the XY are not populated and that the theme table is linearly referenced.
            Append ('    , nm3sdo.get_placement_geometry');
            Append ('              ( ');
            Append ('                 nm_placement ');
            Append (
                   '                   ( :NEW.'
                || LOWER (l_Base_Table_Nth.Nth_Rse_Fk_Column));
            Append (
                   '                   , :NEW.'
                || LOWER (l_Base_Table_Nth.Nth_St_Chain_Column));
            Append (
                   '                   , :NEW.'
                || LOWER (l_Base_Table_Nth.Nth_End_Chain_Column));
            Append (
                '              , 0))  -- geometry derived from linear reference');
        END IF;

        IF l_Base_Table_Nth.Nth_Sequence_Name IS NOT NULL
        THEN
            Append (
                   '    , '
                || LOWER (L_Base_Table_Nth.Nth_Sequence_Name)
                || '.NEXTVAL');
        END IF;

        Append ('    );');

        -----------------------------------------------------------------------------------
        -- If Start Chain and LR columns are defined too, then re-project xy onto
        -- Road to work out LR NE ID and Offset values
        -----------------------------------------------------------------------------------
        IF     l_Base_Table_Nth.Nth_X_Column IS NOT NULL
           AND l_Base_Table_Nth.Nth_Y_Column IS NOT NULL
           AND l_Base_Table_Nth.Nth_St_Chain_Column IS NOT NULL
           AND l_Base_Table_Nth.Nth_Rse_Fk_Column IS NOT NULL
           AND l_Base_Table_Nth.Nth_End_Chain_Column IS NULL
        THEN
            Append (
                   Lf
                || Lf
                || '    -- Network and Chainage supplied - so derive LR from XY values and update'
                || Lf
                || '    l_lref := nm3sdo.nm3sdo.get_nw_snaps_at_xy ');
            Append (
                   '               ( '
                || TO_CHAR (L_Base_Table_Nth.Nth_Theme_Id));
            Append (
                   '               , :NEW.'
                || LOWER (L_Base_Table_Nth.Nth_X_Column));
            Append (
                   '               , :NEW.'
                || LOWER (L_Base_Table_Nth.Nth_Y_Column)
                || ');');
            Append (
                   Lf
                || '    :NEW.'
                || LOWER (L_Base_Table_Nth.Nth_Rse_Fk_Column)
                || ' := l_lref.lr_ne_id;'
                || Lf);
            Append (
                   '    :NEW.'
                || LOWER (L_Base_Table_Nth.Nth_St_Chain_Column)
                || ' := nm3unit.get_formatted_value ');
            Append ('               ( l_lref.lr_offset');
            Append (
                '               , nm3net.get_nt_units_from_ne(l_lref.lr_ne_id)');
            Append ('               );');
        END IF;

        Append (' ');
        Append (
            ' EXCEPTION -- when others to cater for attempted insert where no geom values supplied e.g. no x/y');
        Append ('    WHEN others THEN');
        Append ('       Null;');
        Append (' END ins;');
        Append ('--');
        Append (
            '--------------------------------------------------------------------------');
        Append ('--');
        --
        -- UPDATE PROCEDURE
        --
        Append (' PROCEDURE upd IS ');
        Append (' BEGIN');
        Append ('');
        Append (
               '    -- Update feature table '
            || LOWER (l_Base_Table_Nth.Nth_Feature_Table));

        --
        --
        -- 04-FEB-2009
        -- AE Make sure the X and Y columns are not null before updating.. otherwise we'll delete
        --
        IF     l_Base_Table_Nth.Nth_X_Column IS NOT NULL
           AND l_Base_Table_Nth.Nth_Y_Column IS NOT NULL
        THEN
            Append ('--');
            Append (
                   ' IF :NEW.'
                || LOWER (l_Base_Table_Nth.Nth_X_Column)
                || ' IS NOT NULL');
            Append (
                   '    AND :NEW.'
                || LOWER (l_Base_Table_Nth.Nth_Y_Column)
                || ' IS NOT NULL');
            Append (' THEN ');
        END IF;

        Append ('--');
        Append ('    UPDATE ' || LOWER (l_Base_Table_Nth.Nth_Feature_Table));
        Append (
               '       SET '
            || LOWER (l_Base_Table_Nth.Nth_Feature_Pk_Column)
            || ' = :NEW.'
            || LOWER (l_Base_Table_Nth.Nth_Pk_Column));

        --------------------------------------------------------------------------------------
        -- POINT X,Y ITEM
        --------------------------------------------------------------------------------------
        IF     l_Base_Table_Nth.Nth_X_Column IS NOT NULL
           AND l_Base_Table_Nth.Nth_Y_Column IS NOT NULL
        THEN
            Append (
                   '         , '
                || LOWER (l_Base_Table_Nth.Nth_Feature_Shape_Column)
                || ' = mdsys.sdo_geometry');
            Append ('                          ( 2001 ');
            Append (
                   '                          , sys_context(''NM3CORE'',''THEME'
                || l_Base_Table_Nth.Nth_Theme_Id
                || 'SRID'')');
            Append ('                          , mdsys.sdo_point_type');
            Append (
                   '                             ( :NEW.'
                || LOWER (l_Base_Table_Nth.Nth_X_Column));
            Append (
                   '                             , :NEW.'
                || LOWER (l_Base_Table_Nth.Nth_Y_Column));
            Append ('                             ,  NULL)');
            Append ('                          , NULL ');
            Append (
                '                          , NULL)  -- geometry derived from X,Y values');
        --------------------------------------------------------------------------------------
        -- POINT Linear Reference ITEM
        --------------------------------------------------------------------------------------
        ELSIF     l_Base_Table_Nth.Nth_St_Chain_Column IS NOT NULL
              AND l_Base_Table_Nth.Nth_End_Chain_Column IS NULL
        THEN
            Append (
                   '              ,'
                || l_Base_Table_Nth.Nth_Feature_Shape_Column
                || '=nm3sdo.get_pt_shape_from_ne('
                || ':new.'
                || l_Base_Table_Nth.Nth_Rse_Fk_Column
                || ',:new.'
                || l_Base_Table_Nth.Nth_St_Chain_Column
                || ')');
        --------------------------------------------------------------------------------------
        -- CONTINUOUS Linear Reference ITEM
        --------------------------------------------------------------------------------------
        ELSIF     l_Base_Table_Nth.Nth_St_Chain_Column IS NOT NULL
              AND l_Base_Table_Nth.Nth_End_Chain_Column IS NOT NULL
        THEN
            -- Assume that the XY are not populated and that the theme table is linearly referenced.
            Append (
                   '         , '
                || (   LOWER (l_Base_Table_Nth.Nth_Feature_Shape_Column)
                    || ' = nm3sdo.get_placement_geometry ('));
            Append ('                               ' || 'nm_placement');
            Append (
                   '                                 ( :NEW.'
                || LOWER (l_Base_Table_Nth.Nth_Rse_Fk_Column));
            Append (
                   '                                 , :NEW.'
                || LOWER (l_Base_Table_Nth.Nth_St_Chain_Column));
            Append (
                   '                                 , :NEW.'
                || LOWER (l_Base_Table_Nth.Nth_End_Chain_Column));
            Append (
                '                             , 0)) -- geometry derived from linear reference');
        END IF;

        Append (
               '     WHERE '
            || LOWER (l_Base_Table_Nth.Nth_Feature_Pk_Column)
            || ' = :OLD.'
            || l_Base_Table_Nth.Nth_Pk_Column
            || ';'
            || Lf);
        Append ('    IF SQL%ROWCOUNT=0 THEN');
        Append ('       ins;');

        -----------------------------------------------------------------------------------
        -- If Start Chain and LR columns are defined too, then re-project xy onto
        -- Road to work out LR NE ID and Offset values
        -----------------------------------------------------------------------------------
        IF     l_Base_Table_Nth.Nth_X_Column IS NOT NULL
           AND l_Base_Table_Nth.Nth_Y_Column IS NOT NULL
           AND l_Base_Table_Nth.Nth_St_Chain_Column IS NOT NULL
           AND l_Base_Table_Nth.Nth_Rse_Fk_Column IS NOT NULL
           AND l_Base_Table_Nth.Nth_End_Chain_Column IS NULL
        THEN
            Append ('    ELSE');
            Append (
                   '    -- Network and Chainage supplied - so derive LR from XY values and update'
                || Lf
                || '       l_lref := nm3sdo.get_nw_snaps_at_xy ');
            Append (
                   '                  '
                || TO_CHAR (l_Base_Table_Nth.Nth_Theme_Id));
            Append (
                   '                  , :NEW.'
                || LOWER (l_Base_Table_Nth.Nth_X_Column));
            Append (
                   '                  , :NEW.'
                || LOWER (l_Base_Table_Nth.Nth_Y_Column)
                || ');');
            Append (
                   Lf
                || '       :NEW.'
                || LOWER (l_Base_Table_Nth.Nth_Rse_Fk_Column)
                || ' := l_lref.lr_ne_id;'
                || Lf);
            Append (
                   '       :NEW.'
                || LOWER (l_Base_Table_Nth.Nth_St_Chain_Column)
                || ' := nm3unit.get_formatted_value ');
            Append ('                  ( l_lref.lr_offset');
            Append (
                '                  , nm3net.get_nt_units_from_ne(l_lref.lr_ne_id)');
            Append ('                  );');
            Append ('    END IF;' || Lf);
        ELSE
            Append ('    END IF;' || Lf);
        END IF;

        -- 04-FEB-2009
        -- AE Make sure the X and Y columns are not null before updating.. otherwise we'll delete
        --
        IF     l_Base_Table_Nth.Nth_X_Column IS NOT NULL
           AND l_Base_Table_Nth.Nth_Y_Column IS NOT NULL
        THEN
            Append ('--');
            Append (' ELSE');
            Append ('--');
            Append ('    del; ');
            Append ('--');
            Append (' END IF; ');
        END IF;

        Append (' ');
        Append (
            ' EXCEPTION -- when others to cater for attempted update where no geom values supplied e.g. no x/y');
        Append ('     WHEN others THEN');
        Append ('       Null;');
        Append (' END upd;');
        Append ('--');
        Append (
            '--------------------------------------------------------------------------');
        Append ('--');
        Append ('BEGIN');
        Append ('--');

        IF p_Restrict IS NOT NULL
        THEN
            Append ('IF ' || p_Restrict || ' THEN');
        END IF;

        Append (
               '   nm3sdm.set_theme_srid_ctx( pi_theme_id => '
            || l_Base_Table_Nth.Nth_Theme_Id
            || ');');
        Append ('--');
        Append ('   IF DELETING THEN');
        Append ('        del;');
        Append ('   ELSIF INSERTING THEN');
        Append ('        ins;');
        Append ('   ELSIF UPDATING THEN');
        Append ('        upd;');
        Append ('   END IF;');

        IF p_Restrict IS NOT NULL
        THEN
            Append ('END IF;');
        END IF;

        Append ('EXCEPTION');
        Append ('   WHEN NO_DATA_FOUND THEN');
        Append ('     NULL; -- no data in spatial table to update or delete');
        Append ('   WHEN OTHERS THEN');
        Append ('     RAISE;');
        Append ('END ' || LOWER (l_Trg_Name) || ';');
        Append ('--');
        Append (
            '--------------------------------------------------------------------------');
        Append ('--');
        Nm3Ddl.Execute_Tab_Varchar (L_Tab_Vc);
    EXCEPTION
        WHEN Ex_Invalid_Sequence
        THEN
            Hig.Raise_Ner (
                pi_Appl      => Nm3Type.C_Hig,
                pi_Id        => 257,
                pi_Sqlcode   => -20001,
                pi_Supplementary_Info   =>
                       l_Base_Table_Nth.Nth_Sequence_Name
                    || CHR (10)
                    || 'Please check your theme.');
    END Create_Nth_Sdo_Trigger;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Get_Dynseg_Nt_Types (
        Pi_Asset_Type   IN     Nm_Inv_Types.Nit_Inv_Type%TYPE,
        Po_Locations    IN OUT Tab_Nin_Sdo)
    IS
        l_Tab_Layer      Nm3Type.Tab_Number;
        l_Tab_Location   Nm3Type.Tab_Varchar4;
        l_Retval         Tab_Nin_Sdo;
    BEGIN
        Nm_Debug.Proc_Start (G_Package_Name, 'get_dynseg_nt_type');

        SELECT nlt.Nlt_Nt_Type, nta.Nth_Theme_Id Base_Theme
          BULK COLLECT INTO l_Tab_Location, l_Tab_Layer
          FROM Nm_Inv_Nw        nin,
               Nm_Themes_All    nta,
               Nm_Nw_Themes     nnt,
               Nm_Linear_Types  nlt
         WHERE     nlt.Nlt_Id = nnt.Nnth_Nlt_Id
               AND nnt.Nnth_Nth_Theme_Id = nta.Nth_Theme_Id
               AND nlt.Nlt_Nt_Type = nin.Nin_Nw_Type
               AND nta.Nth_Theme_Type = 'SDO'
               AND nin.Nin_Nit_Inv_Code = pi_Asset_Type;

        FOR i IN 1 .. l_Tab_Layer.COUNT
        LOOP
            l_Retval (i).p_Layer_Id := l_Tab_Layer (i);
            l_Retval (i).p_Location := l_Tab_Location (i);
        END LOOP;

        po_Locations := l_Retval;
        Nm_Debug.Proc_End (G_Package_Name, 'get_dynseg_nt_type');
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            po_Locations := l_Retval;
    END Get_Dynseg_Nt_Types;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Get_Existing_Themes_For_Table (
        pi_Theme_Table   IN     Nm_Themes_All.Nth_Theme_Name%TYPE,
        po_Themes        IN OUT Tab_Nth)
    IS
        l_Retval   Tab_Nth;
    BEGIN
        Nm_Debug.Proc_End (G_Package_Name, 'get_existing_themes_for_table');

        SELECT *
          BULK COLLECT INTO l_Retval
          FROM Nm_Themes_All nta
         WHERE     nta.Nth_Table_Name = pi_Theme_Table
               AND nta.Nth_Theme_Type = 'SDO';

        po_Themes := l_Retval;
        --
        Nm_Debug.Proc_End (G_Package_Name, 'get_existing_themes_for_table');
    --
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            po_Themes := l_Retval;
    END Get_Existing_Themes_For_Table;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Get_Nlt_Block (
        pi_Theme_Id   IN     Nm_Themes_All.Nth_Theme_Id%TYPE,
        po_Results    IN OUT Tab_Nlt_Block)
    IS
        TYPE Tab_Nlt IS TABLE OF Nm_Linear_Types%ROWTYPE
            INDEX BY BINARY_INTEGER;

        l_Tab_Nlt      Tab_Nlt;
        l_Retval       Tab_Nlt_Block;
        l_Unit_Descr   Nm_Units.Un_Unit_Name%TYPE;
    BEGIN
        SELECT *
          BULK COLLECT INTO l_Tab_Nlt
          FROM Nm_Linear_Types nlt
         WHERE nlt.Nlt_Id IN (SELECT nnt.Nnth_Nlt_Id
                                FROM Nm_Nw_Themes nnt
                               WHERE nnt.Nnth_Nth_Theme_Id = pi_Theme_Id);

        FOR i IN 1 .. l_Tab_Nlt.COUNT
        LOOP
            l_Unit_Descr :=
                Nm3Get.Get_Un (pi_Un_Unit_Id        => l_Tab_Nlt (i).Nlt_Units,
                               pi_Raise_Not_Found   => FALSE).Un_Unit_Name;

            l_Retval (i).Nlt_Nth_Theme_Id := pi_Theme_Id;
            l_Retval (i).Nlt_Id := l_Tab_Nlt (i).Nlt_Id;
            l_Retval (i).Nlt_Seq_No := l_Tab_Nlt (i).Nlt_Seq_No;
            l_Retval (i).Nlt_Descr := l_Tab_Nlt (i).Nlt_Descr;
            l_Retval (i).Nlt_Nt_Type := l_Tab_Nlt (i).Nlt_Nt_Type;
            l_Retval (i).Nlt_Gty_Type := l_Tab_Nlt (i).Nlt_Gty_Type;
            l_Retval (i).Nlt_Admin_Type := l_Tab_Nlt (i).Nlt_Admin_Type;
            l_Retval (i).Nlt_Start_Date := l_Tab_Nlt (i).Nlt_Start_Date;
            l_Retval (i).Nlt_End_Date := l_Tab_Nlt (i).Nlt_End_Date;
            l_Retval (i).Nlt_Units := l_Tab_Nlt (i).Nlt_Units;
            l_Retval (i).Nlt_Units_Descr := l_Unit_Descr;
        END LOOP;

        po_Results := l_Retval;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            po_Results := l_Retval;
    END Get_Nlt_Block;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Get_Nat_Block (
        pi_Theme_Id   IN     Nm_Themes_All.Nth_Theme_Id%TYPE,
        po_Results    IN OUT Tab_Nat_Block)
    IS
        TYPE Tab_Nat IS TABLE OF Nm_Area_Types%ROWTYPE
            INDEX BY BINARY_INTEGER;

        l_Tab_Nat   Tab_Nat;
        l_Retval    Tab_Nat_Block;
    BEGIN
        SELECT naty.*
          BULK COLLECT INTO l_Tab_Nat
          FROM Nm_Area_Types naty
         WHERE naty.Nat_Id IN (SELECT nat.Nath_Nat_Id
                                 FROM Nm_Area_Themes nat
                                WHERE nat.Nath_Nth_Theme_Id = pi_Theme_Id);

        FOR i IN 1 .. l_Tab_Nat.COUNT
        LOOP
            l_Retval (i).Nat_Nth_Theme_Id := pi_Theme_Id;
            l_Retval (i).Nat_Seq_No := l_Tab_Nat (i).Nat_Seq_No;
            l_Retval (i).Nat_Descr := l_Tab_Nat (i).Nat_Descr;
            l_Retval (i).Nat_Nt_Type := l_Tab_Nat (i).Nat_Nt_Type;
            l_Retval (i).Nat_Gty_Group_Type :=
                l_Tab_Nat (i).Nat_Gty_Group_Type;
            l_Retval (i).Nat_Start_Date := l_Tab_Nat (i).Nat_Start_Date;
            l_Retval (i).Nat_End_Date := l_Tab_Nat (i).Nat_End_Date;
            l_Retval (i).Nat_Shape_Type := l_Tab_Nat (i).Nat_Shape_Type;
        END LOOP;

        po_Results := l_Retval;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            po_Results := l_Retval;
    END Get_Nat_Block;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Get_Nit_Block (
        pi_Theme_Id   IN     Nm_Themes_All.Nth_Theme_Id%TYPE,
        po_Results    IN OUT Tab_Nit_Block)
    IS
        TYPE Tab_Nit IS TABLE OF Nm_Inv_Types%ROWTYPE
            INDEX BY BINARY_INTEGER;

        l_Tab_Nit   Tab_Nit;
        l_Retval    Tab_Nit_Block;
    BEGIN
        SELECT nity.*
          BULK COLLECT INTO l_Tab_Nit
          FROM Nm_Inv_Types nity, Nm_Inv_Themes nith
         WHERE     nity.Nit_Inv_Type = nith.Nith_Nit_Id
               AND nith.Nith_Nth_Theme_Id = pi_Theme_Id;

        FOR i IN 1 .. l_Tab_Nit.COUNT
        LOOP
            l_Retval (i).Nit_Nth_Theme_Id := pi_Theme_Id;
            l_Retval (i).Nit_Inv_Type := l_Tab_Nit (i).Nit_Inv_Type;
            l_Retval (i).Nit_Descr := l_Tab_Nit (i).Nit_Descr;
            l_Retval (i).Nit_View_Name := l_Tab_Nit (i).Nit_View_Name;
            l_Retval (i).Nit_Use_Xy := l_Tab_Nit (i).Nit_Use_Xy;
            l_Retval (i).Nit_Pnt_Or_Cont := l_Tab_Nit (i).Nit_Pnt_Or_Cont;
            l_Retval (i).Nit_Linear := l_Tab_Nit (i).Nit_Linear;
            l_Retval (i).Nit_Table_Name := l_Tab_Nit (i).Nit_Table_Name;
            l_Retval (i).Nit_Lr_St_Chain := l_Tab_Nit (i).Nit_Lr_St_Chain;
            l_Retval (i).Nit_Lr_End_Chain := l_Tab_Nit (i).Nit_Lr_End_Chain;
            l_Retval (i).Nit_Lr_Ne_Column_Name :=
                l_Tab_Nit (i).Nit_Lr_Ne_Column_Name;
        END LOOP;

        po_Results := l_Retval;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            po_Results := l_Retval;
    END Get_Nit_Block;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Create_Msv_Themes
    AS
        l_Rec_Nth    Nm_Themes_All%ROWTYPE;
        l_Rec_Nthr   Nm_Theme_Roles%ROWTYPE;

        FUNCTION Get_Pk_Column (pi_Table_Name IN VARCHAR2)
            RETURN VARCHAR2
        IS
            l_Col   VARCHAR2 (30);
        BEGIN
            BEGIN
                SELECT Ucc.Column_Name
                  INTO L_Col
                  FROM User_Constraints Uco, User_Cons_Columns Ucc
                 WHERE     Uco.Owner = USER
                       AND Ucc.Owner = USER
                       AND Uco.Table_Name = pi_Table_Name
                       AND Uco.Constraint_Type = 'P'
                       AND Uco.Constraint_Name = Ucc.Constraint_Name
                       AND Uco.Table_Name = Ucc.Table_Name;
            EXCEPTION
                WHEN OTHERS
                THEN
                    l_Col := 'UNKNOWN';
            END;

            RETURN (l_Col);
        END Get_Pk_Column;
    --
    BEGIN
        FOR i
            IN (SELECT ust.*
                  FROM User_Sdo_Themes ust
                 WHERE NOT EXISTS
                           (SELECT NULL
                              FROM Nm_Themes_All nta
                             WHERE     nta.Nth_Theme_Name = ust.Name
                                   AND nta.Nth_Theme_Type = 'SDO'))
        LOOP
            BEGIN
                l_Rec_Nth.Nth_Theme_Id := Nm3Seq.Next_Nth_Theme_Id_Seq;
                l_Rec_Nth.Nth_Theme_Name := i.Name;
                l_Rec_Nth.Nth_Table_Name := i.Base_Table;
                l_Rec_Nth.Nth_Pk_Column := Get_Pk_Column (i.Base_Table);
                l_Rec_Nth.Nth_Label_Column := l_Rec_Nth.Nth_Pk_Column;
                l_Rec_Nth.Nth_Hpr_Product := Nm3Type.C_Net;
                l_Rec_Nth.Nth_Location_Updatable := 'N';
                l_Rec_Nth.Nth_Dependency := 'I';
                l_Rec_Nth.Nth_Storage := 'S';
                l_Rec_Nth.Nth_Update_On_Edit := 'N';
                l_Rec_Nth.Nth_Use_History := 'N';
                l_Rec_Nth.Nth_Snap_To_Theme := 'N';
                l_Rec_Nth.Nth_Lref_Mandatory := 'N';
                l_Rec_Nth.Nth_Tolerance := 10;
                l_Rec_Nth.Nth_Tol_Units := 1;
                l_Rec_Nth.Nth_Theme_Type := 'SDO';
                l_Rec_Nth.Nth_Feature_Table := i.Base_Table;
                l_Rec_Nth.Nth_Feature_Shape_Column := i.Geometry_Column;
                l_Rec_Nth.Nth_Feature_Pk_Column := l_Rec_Nth.Nth_Pk_Column;
                Nm3Ins.Ins_Nth (l_Rec_Nth);

                l_Rec_Nthr.Nthr_Theme_Id := l_Rec_Nth.Nth_Theme_Id;
                l_Rec_Nthr.Nthr_Role := 'HIG_USER';
                l_Rec_Nthr.Nthr_Mode := 'NORMAL';
                Nm3Ins.Ins_Nthr (l_Rec_Nthr);
            EXCEPTION
                WHEN OTHERS
                THEN
                    Nm_Debug.Debug (
                           'Unable to create theme for '
                        || I.Name
                        || ' - '
                        || SQLERRM);
            END;
        END LOOP;
    END Create_Msv_Themes;

    --
    ------------------------------------------------------------------------------
    --
    PROCEDURE Create_Msv_Feature_Views (
        pi_Username   IN Hig_Users.Hus_Username%TYPE DEFAULT NULL)
    --
    -- View created for subordinate users that need access to the Highways owner
    -- SDO layers when using Mapviewer
    --
    -- This is due to Mapviewer requiring the object to exist as a view, rather
    -- than access it via via synonyms
    --
    -- USER_SDO_GEOM_METADATA still needs to exist for each subordinate user
    --
    AS
        l_Higowner       VARCHAR2 (30)
                             := SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER');
        l_Tab_Username   Nm3Type.Tab_Varchar30;
        l_Tab_Ftabs      Nm3Type.Tab_Varchar30;
        l_Nl             VARCHAR2 (10) := CHR (10);

        --
        FUNCTION Is_Priv_View (pi_View_Name   IN Dba_Views.View_Name%TYPE,
                               pi_Owner       IN Dba_Views.Owner%TYPE)
            RETURN BOOLEAN
        IS
            l_Var      VARCHAR2 (10);
            l_Retval   BOOLEAN;
        BEGIN
            BEGIN
                SELECT NULL
                  INTO l_Var
                  FROM Dba_Views dv
                 WHERE dv.View_Name = pi_View_Name AND dv.Owner = pi_Owner;

                l_Retval := TRUE;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    l_Retval := FALSE;
            END;

            RETURN (l_Retval);
        END Is_Priv_View;
    BEGIN
        -- Collect subordinate users (that actually exist)
        BEGIN
            SELECT hu.Hus_Username
              BULK COLLECT INTO l_Tab_Username
              FROM Hig_Users hu
             WHERE     hu.Hus_Is_Hig_Owner_Flag = 'N'
                   AND EXISTS
                           (SELECT NULL
                              FROM Dba_Users du
                             WHERE     du.Username = hu.Hus_Username
                                   AND NVL (pi_Username, '^$^') =
                                       NVL (hu.Hus_Username, '^$^'));
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        --
        -- Find which feature tables we need to create views for
        -- We only need views for feature tables that contain SRIDS

        -- not longer the case - will create views for all feature tables
        --
        BEGIN
            SELECT nta.Nth_Feature_Table
              BULK COLLECT INTO l_Tab_Ftabs
              FROM Nm_Themes_All nta
             WHERE     nta.Nth_Theme_Type = 'SDO'
                   AND EXISTS
                           (SELECT NULL
                              FROM User_Sdo_Geom_Metadata usgm
                             WHERE usgm.Table_Name = nta.Nth_Feature_Table);
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        IF l_Tab_Username.COUNT > 0 AND l_Tab_Ftabs.COUNT > 0
        THEN
            -- Create views for subordiate user(s)

            FOR i IN 1 .. l_Tab_Username.COUNT
            LOOP
                FOR t IN 1 .. l_Tab_Ftabs.COUNT
                LOOP
                    IF Is_Priv_View (l_Tab_Ftabs (t), l_Tab_Username (i))
                    THEN
                        BEGIN
                            EXECUTE IMMEDIATE   'DROP VIEW '
                                             || l_Tab_Username (i)
                                             || '.'
                                             || l_Tab_Ftabs (t);
                        EXCEPTION
                            WHEN OTHERS
                            THEN
                                NULL;
                        END;
                    END IF;

                    BEGIN
                        EXECUTE IMMEDIATE(   'CREATE OR REPLACE SYNONYM '
                                          || l_Tab_Username (i)
                                          || '.'
                                          || l_Tab_Ftabs (t)
                                          || ' FOR '
                                          || SYS_CONTEXT (
                                                 'NM3CORE',
                                                 'APPLICATION_OWNER')
                                          || '.'
                                          || l_Tab_Ftabs (t));
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            NULL;
                    END;
                END LOOP;
            END LOOP;
        END IF;
    --
    EXCEPTION
        WHEN OTHERS
        THEN
            NULL;
    END Create_Msv_Feature_Views;

    --
    -----------------------------------------------------------------------------
    --
    -- Refreshes user_sdo_geom_metadata for a given subordinate user
    --
    PROCEDURE Refresh_Usgm (pi_Sub_Username    IN Hig_Users.Hus_Username%TYPE,
                            pi_Role_Restrict   IN BOOLEAN DEFAULT TRUE)
    IS
        TYPE Tab_Usgm IS TABLE OF User_Sdo_Geom_Metadata%ROWTYPE
            INDEX BY BINARY_INTEGER;

        l_Tab_Usgm   Tab_Usgm;
        l_Sql        Nm3Type.Max_Varchar2;
        Nl           VARCHAR2 (10) := CHR (10);
    BEGIN
        l_Sql :=
               'INSERT INTO mdsys.sdo_geom_metadata_table '
            || Nl
            || '(sdo_owner, sdo_table_name, '
            || Nl
            || ' sdo_column_name, sdo_diminfo, '
            || Nl
            || ' sdo_srid ) '
            || Nl
            || 'SELECT '''
            || Pi_Sub_Username
            || ''', sdo_table_name, sdo_column_name, sdo_diminfo, sdo_srid '
            || Nl
            || '  FROM mdsys.sdo_geom_metadata_table a'
            || Nl
            || ' WHERE sdo_owner = Sys_Context(''NM3CORE'',''APPLICATION_OWNER'') '
            || Nl
            || '   AND NOT EXISTS '
            || Nl
            || '     (SELECT 1 FROM mdsys.sdo_geom_metadata_table b '
            || Nl
            || '       WHERE '''
            || Pi_Sub_Username
            || '''  = b.sdo_owner '
            || Nl
            || '         AND a.sdo_table_name  = b.sdo_table_name '
            || Nl
            || '         AND a.sdo_column_name = b.sdo_column_name ) ';

        IF Pi_Role_Restrict
        THEN
            l_Sql :=
                   l_Sql
                || Nl
                || 'AND EXISTS '
                || Nl
                || ' (SELECT 1 '
                || Nl
                || '    FROM gis_themes '
                || Nl
                || '   WHERE gt_feature_table = sdo_table_name)';
        END IF;

        EXECUTE IMMEDIATE l_Sql;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            Hig.Raise_Ner (Pi_Appl      => Nm3Type.C_Hig,
                           Pi_Id        => 279,
                           Pi_Sqlcode   => -20001);
    END Refresh_Usgm;

    --
    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Get_Datum_Xy_From_Measure (p_Ne_Id     IN     NUMBER,
                                         p_Measure   IN     NUMBER,
                                         p_X            OUT NUMBER,
                                         p_Y            OUT NUMBER)
    IS
    BEGIN
        Nm3Sdo.Get_Datum_Xy_From_Measure (p_Ne_Id,
                                          p_Measure,
                                          p_X,
                                          p_Y);
    END Get_Datum_Xy_From_Measure;

    -----------------------------------------------------------------------------
    --
    PROCEDURE Create_Theme_Xy_View (p_Theme_Id IN NUMBER)
    IS
        l_Th         Nm_Themes_All%ROWTYPE;
        l_Vw         VARCHAR2 (34);
        l_Ddl_Text   VARCHAR2 (2000);
    BEGIN
        l_Th := Nm3Get.Get_Nth (p_Theme_Id);

        IF SUBSTR (l_Th.Nth_Feature_Table, 1) = 'V'
        THEN
            l_Vw := l_Th.Nth_Feature_Table || '_XY';
        ELSE
            l_Vw := 'V_NM_' || l_Th.Nth_Feature_Table || '_XY';
        END IF;

        l_Vw := SUBSTR (l_Vw, 1, 30);

        l_Ddl_Text :=
               'create or replace view '
            || l_Vw
            || ' as select t.*, v.x, v.y, v.z '
            || ' from '
            || l_Th.Nth_Feature_Table
            || ' t, table ( sdo_util.getvertices( t.'
            || l_Th.Nth_Feature_Shape_Column
            || ' ) ) v ';

        Nm3Ddl.Create_Object_And_Syns (l_Vw, l_Ddl_Text);
    END Create_Theme_Xy_View;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Drop_Layers_By_Node_Type (
        pi_Node_Type   IN Nm_Node_Types.Nnt_Type%TYPE)
    IS
        l_View_Name      User_Views.View_Name%TYPE;
        l_Nth_Theme_Id   Nm_Themes_All.Nth_Theme_Id%TYPE;
        l_Column_Name    User_Tab_Columns.Column_Name%TYPE := 'GEOLOC';
        l_Rec_Nth        Nm_Themes_All%ROWTYPE;
        l_Sql            Nm3Type.Max_Varchar2;
        lf               VARCHAR2 (4) := CHR (10);
    BEGIN
        Nm_Debug.Proc_Start (G_Package_Name, 'drop_layers_by_node_type');

        l_View_Name := Get_Node_Table (pi_Node_Type);
        l_Nth_Theme_Id := Get_Theme_From_Feature_Table (l_View_Name);

        IF l_Nth_Theme_Id IS NULL
        THEN
            -- If no theme exists by feature table (i.e. V_NM_NO_ROAD_<>) then
            -- try and derive by theme name.
            -- These might be old node layers (pre 3211) where feature table
            -- was set to nm_point_locations.
            l_Nth_Theme_Id :=
                Nm3Get.Get_Nth (
                    pi_Nth_Theme_Name    => 'NODE_' || pi_Node_Type,
                    pi_Raise_Not_Found   => FALSE).Nth_Theme_Id;
        END IF;

        IF l_Nth_Theme_Id IS NOT NULL
        THEN
            -- Theme exists, so use it
            l_Rec_Nth := Nm3Get.Get_Nth (l_Nth_Theme_Id);

            IF L_Rec_Nth.Nth_Feature_Table = 'NM_POINT_LOCATIONS'
            THEN
                Drop_Layer (p_Nth_Id               => l_Rec_Nth.Nth_Theme_Id,
                            p_Keep_Theme_Data      => 'N',
                            p_Keep_Feature_Table   => 'Y');
            ELSE
                Drop_Layer (p_Nth_Id => l_Nth_Theme_Id);
            END IF;
        ELSE
            -- No theme, so attempt to clear up
            Nm3Sdo.Drop_Metadata (l_View_Name);

            BEGIN
                Nm3Sdo.Drop_Sub_Layer_By_Table (l_View_Name, 'GEOLOC');
            EXCEPTION
                WHEN OTHERS
                THEN
                    NULL;
            END;

            Drop_Object (l_View_Name);

            DECLARE
                No_Public_Syn_Exists    EXCEPTION;
                PRAGMA EXCEPTION_INIT (No_Public_Syn_Exists, -20304);

                No_Private_Syn_Exists   EXCEPTION;
                PRAGMA EXCEPTION_INIT (No_Private_Syn_Exists, -1434);
            BEGIN
                -- AE 23-SEP-2008
                -- Drop views instead of synonyms
                Nm3Ddl.Drop_Views_For_Object (l_View_Name);
            EXCEPTION
                WHEN No_Public_Syn_Exists
                THEN
                    NULL; -- we don't care - as long as it does not exist now.
                WHEN No_Private_Syn_Exists
                THEN
                    NULL; -- we don't care - as long as it does not exist now.
            END;

            BEGIN
                EXECUTE IMMEDIATE   'BEGIN '
                                 || CHR (10)
                                 || '  Nm3sde.drop_layer_by_table(l_view_name, '
                                 || Nm3Flx.String ('GEOLOC')
                                 || ');'
                                 || CHR (10)
                                 || 'END';
            EXCEPTION
                WHEN OTHERS
                THEN
                    NULL;
            END;
        END IF;

        Nm_Debug.Proc_End (G_Package_Name, 'drop_layers_by_node_type');
    --
    END Drop_Layers_By_Node_Type;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE Refresh_Node_Layers
    IS
        l_Int           INTEGER;
        l_Rec_Nth       Nm_Themes_All%ROWTYPE;
        l_Rec_Npl_Nth   Nm_Themes_All%ROWTYPE;
        l_Theme_Id      Nm_Themes_All.Nth_Theme_Id%TYPE;
    BEGIN
        -- Test for nm_point_locations theme
        l_Theme_Id :=
            Get_Theme_From_Feature_Table ('NM_POINT_LOCATIONS',
                                          'NM_POINT_LOCATIONS');

        IF l_Theme_Id IS NULL
        THEN
            Register_Npl_Theme;
        END IF;

        FOR i IN (SELECT * FROM Nm_Node_Types)
        LOOP
            Drop_Layers_By_Node_Type (i.Nnt_Type);
            l_Int := Create_Node_Metadata (i.Nnt_Type);
        END LOOP;
    --
    END Refresh_Node_Layers;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION Get_Global_Unit_Factor
        RETURN NUMBER
    IS
    BEGIN
        RETURN G_Unit_Conv;
    END Get_Global_Unit_Factor;

    --
    ------------------------------------------------------------------------------
    -- AE Added new procedure to maintain visable themes
    -- very basic version to start with, it doesn't deal with it on a user basis,
    -- so changes affect all users
    --
    PROCEDURE Maintain_Ntv (pi_Theme_Id   IN Nm_Themes_All.Nth_Theme_Id%TYPE,
                            pi_Mode       IN VARCHAR2)
    IS
        l_Default_Vis   VARCHAR2 (1)
            := NVL (Hig.Get_User_Or_Sys_Opt ('DEFVISNTH'), 'N');
    BEGIN
        IF pi_Mode = 'INSERTING'
        THEN
            INSERT INTO Nm_Themes_Visible (Ntv_Nth_Theme_Id, Ntv_Visible)
                 VALUES (pi_Theme_Id, l_Default_Vis);
        END IF;
    END Maintain_Ntv;

    --
    ------------------------------------------------------------------------------
    --
    PROCEDURE Set_Theme_Srid_Ctx (
        pi_Theme_Id   IN Nm_Themes_All.Nth_Theme_Id%TYPE)
    IS
        l_Srid   VARCHAR2 (10);
        l_Sdo    User_Sdo_Geom_Metadata%ROWTYPE;
    --
    BEGIN
        IF SYS_CONTEXT ('NM3CORE', 'THEME' || pi_Theme_Id || 'SRID') IS NULL
        THEN
            l_Sdo := Nm3Sdo.Get_Theme_Metadata (pi_Theme_Id);
            --    l_Srid :=  Nvl (To_Char (l_Sdo.Srid), 'NULL');
            l_Srid := TO_CHAR (l_Sdo.Srid);

            Nm3Ctx.Set_Core_Context (
                p_Attribute   => 'THEME' || pi_Theme_Id || 'SRID',
                p_Value       => l_Srid);
        END IF;
    END Set_Theme_Srid_Ctx;

    --
    ------------------------------------------------------------------------------
    --
    FUNCTION Build_Inv_Sdo_Join_View
        RETURN User_Views.View_Name%TYPE
    IS
        l_View_Tab            t_View_Tab;
        View_Creation_Error   EXCEPTION;
        PRAGMA EXCEPTION_INIT (View_Creation_Error, -20001);
    BEGIN
        Nm_Debug.Debug ('Nm3Sdm.Build_Inv_Sdo_Join_View - Called');

        SELECT View_Name, View_Text, View_Comments
          BULK COLLECT INTO l_View_Tab
          FROM V_Nm_Rebuild_All_Inv_Sdo_Join;

        FOR x IN 1 .. l_View_Tab.COUNT
        LOOP
            BEGIN
                Process_View_DDL (p_View_Rec => l_View_Tab (x));
            EXCEPTION
                WHEN View_Creation_Error
                THEN
                    NULL;
            END;
        END LOOP;

        Nm_Debug.Debug ('Nm3Sdm.Build_Inv_Sdo_Join_View - Finished');

        --Only return a view name if we only processed one view.
        RETURN ((CASE
                     WHEN l_View_Tab.COUNT = 1 THEN l_View_Tab (1).View_Name
                     ELSE NULL
                 END));
    END Build_Inv_Sdo_Join_View;

    --
    -------------------------------------------------------------------------------------------------------------------------------------
    --
    FUNCTION Create_Inv_Sdo_Join_View (p_Feature_Table_Name IN VARCHAR2)
        RETURN User_Views.View_Name%TYPE
    IS
        l_View_Name   User_Views.View_Name%TYPE;
    BEGIN
        Nm_Debug.Debug ('Nm3Sdm.Create_Inv_Sdo_Join_View - Called');
        Nm_Debug.Debug (
            'Parameter - p_Feature_Table_Name:' || p_Feature_Table_Name);

        Nm3Ctx.Set_Context ('THEME_API_FEATURE_TAB', p_Feature_Table_Name);

        l_View_Name := Build_Inv_Sdo_Join_View;

        Nm3Ctx.Set_Context ('THEME_API_FEATURE_TAB', NULL);

        Nm_Debug.Debug (
            'Nm3Sdm.Create_Inv_Sdo_Join_View - Finished - Returning:');

        RETURN l_View_Name;
    END Create_Inv_Sdo_Join_View;

    --
    ------------------------------------------------------------------------------
    --
    PROCEDURE Rebuild_All_Inv_Sdo_Join_View
    IS
        l_View_Name   User_Views.View_Name%TYPE;
    BEGIN
        Nm_Debug.Debug ('nm3sdm.Rebuild_All_Inv_Sdo_Join_View - Called');

        --This limits the rows returned by the V_Nm_Rebuild_All_Inv_Sdo_Join view, which is used by Build_Inv_Sdo_Join_View.
        Nm3Ctx.Set_Context ('THEME_API_FEATURE_TAB', 'NM_%_SDO');

        l_View_Name := Build_Inv_Sdo_Join_View;

        Nm3Ctx.Set_Context ('THEME_API_FEATURE_TAB', NULL);

        Nm_Debug.Debug ('nm3sdm.Rebuild_All_Inv_Sdo_Join_View - Finished');
    END Rebuild_All_Inv_Sdo_Join_View;

    --
    -----------------------------------------------------------------------------
    --Added these functions / procedure back in due to SM, impact.
    -----------------------------------------------------------------------------
    --

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION get_node_type (p_nt_type IN NM_TYPES.nt_type%TYPE)
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN Nm3get.get_nt (pi_nt_type => p_nt_type).nt_node_type;
    END get_node_type;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION get_node_type (p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE)
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN get_node_type (
                   p_nt_type   => get_theme_nt (p_theme_id => p_theme_id));
    END get_node_type;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION get_details (p_theme_id   IN NM_THEMES_ALL.nth_theme_id%TYPE,
                          p_ne_id      IN NUMBER)
        RETURN CLOB
    IS
    BEGIN
        RETURN Nm3xmlqry.get_theme_details_as_xml_clob (p_theme_id, p_ne_id);
    END get_details;

    -----------------------------------------------------------------------------
    --
    FUNCTION get_details (p_ne_id IN NUMBER)
        RETURN CLOB
    IS
    BEGIN
        RETURN Nm3xmlqry.get_obj_details_as_xml_clob (p_ne_id);
    END get_details;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE create_element_shape_from_xml (
        p_layer   IN NUMBER,
        p_ne_id   IN nm_elements.ne_id%TYPE,
        p_xml     IN CLOB)
    IS
        l_geom   MDSYS.SDO_GEOMETRY;
    BEGIN
        ----   nm_debug.debug_on;
        ----   nm_debug.delete_debug(TRUE);

        ----   nm_debug.DEBUG_CLOB( P_CLOB => p_xml );
        l_geom :=
            Nm3sdo_Xml.load_shape (p_xml => p_xml, p_file_type => 'datum');
        Nm3sdo.insert_element_shape (p_layer   => p_layer,
                                     p_ne_id   => p_ne_id,
                                     p_geom    => l_geom);
    END;

    --
    -----------------------------------------------------------------------------
    --
    --
    Procedure Reshape_Other_Product (
                                    p_Ne_Id   In    Nm_Elements.Ne_Id%Type,
                                    p_Geom    In    Mdsys.Sdo_Geometry
                                    )
    Is

    Begin
      Nm_Debug.Debug('Nm3sdm.Reshape_Other_Product - Called');
      Nm_Debug.Debug('Parameter - p_Ne_Id: ' || To_Char(p_Ne_Id));

      --NSG
      If Hig.Is_Product_Licensed( Nm3type.c_Nsg )  Then   

        Execute Immediate 'Begin'                                                 || Chr(10) ||
                          '  Nsg_Reshape.Reshape_Esu    ('                        || Chr(10) ||
                          '                             p_Ne_Id   =>  :p_Ne_Id,'  || Chr(10) ||
                          '                             p_Geom    =>  :p_Geom'    || Chr(10) ||
                          '                             );'                       || Chr(10) ||
                          'End;'                                                  || Chr(10)
        Using   p_Ne_Id,
                p_Geom;
      End If;

      Nm_Debug.Debug('Nm3sdm.Reshape_Other_Product - Finished');
    End Reshape_Other_Product;

    --
    -----------------------------------------------------------------------------
    --
    --
    PROCEDURE reshape_element (p_ne_id   IN nm_elements.ne_id%TYPE,
                               p_geom    IN MDSYS.SDO_GEOMETRY)
    IS
        l_layer      NUMBER;
        l_old_geom   MDSYS.sdo_geometry;
        l_new_geom   MDSYS.sdo_geometry;
        l_length     NUMBER;
        l_usgm       user_sdo_geom_metadata%ROWTYPE;
        l_rec_nth    nm_themes_all%ROWTYPE;
    BEGIN
        --nm_debug.debug_on;
        --nm_debug.debug('changing shapes');
        l_layer := get_nt_theme (Nm3get.get_ne (p_ne_id).ne_nt_type);
        l_rec_nth := nm3get.get_nth (l_layer);

        IF Nm3sdo.element_has_shape (l_layer, p_ne_id) = 'TRUE'
        THEN
            -- AE 09-FEB-2009
            -- Brought across the code from 2.10.1.1 branch into the mainstream
            -- version so that the SRID is set on the reshape

            l_old_geom :=
                nm3sdo.get_layer_element_geometry (l_layer, p_ne_id);

            l_new_geom := p_geom;

            IF NVL (l_old_geom.sdo_srid, -9999) !=
               NVL (l_new_geom.sdo_srid, -9999)
            THEN
                l_new_geom.sdo_srid := l_old_geom.sdo_srid;
            END IF;

            --
            -- Task 0110101
            -- Bring code across from NM3SDO insert_element_shape to validate the
            -- length of the geometry being passed into this procedure
            --
            l_usgm :=
                nm3sdo.get_usgm (
                    pi_table_name    => l_rec_nth.nth_feature_table,
                    pi_column_name   => l_rec_nth.nth_feature_shape_column);
            --
            l_length := nm3net.get_ne_length (p_ne_id);

            --
            IF NVL (
                   SDO_LRS.geom_segment_end_measure (l_new_geom,
                                                     l_usgm.diminfo),
                   -9999) !=
               l_length
            THEN
                SDO_LRS.redefine_geom_segment (l_new_geom,
                                               l_usgm.diminfo,
                                               0,
                                               l_length);
            END IF;

            --
            IF SDO_LRS.geom_segment_end_measure (l_new_geom, l_usgm.diminfo) !=
               l_length
            THEN
                hig.raise_ner (pi_appl      => nm3type.c_hig,
                               pi_id        => 204,
                               pi_sqlcode   => -20001);
            END IF;

            --
            -- Task 0110101 Done
            --
            nm3sdo_edit.reshape (l_layer, p_ne_id, l_new_geom);
            --
            nm3sdo.change_affected_shapes (p_layer   => l_layer,
                                           p_ne_id   => p_ne_id);
            --
            nm_inv_sdo_aggr.reshape_aggregated_geometry (p_ne_id);
        ELSE
            nm3sdo.insert_element_shape (p_layer   => l_layer,
                                         p_ne_id   => p_ne_id,
                                         p_geom    => p_geom);
            nm3sdo.change_affected_shapes (p_layer   => l_layer,
                                           p_ne_id   => p_ne_id);

            --
            nm_inv_sdo_aggr.reshape_aggregated_geometry (p_ne_id);
        END IF;

        UPDATE nm_elements
           SET ne_date_modified = SYSDATE
         WHERE ne_id = p_ne_id;            -- trigger will handled modified-by

      Reshape_Other_Product (
                            p_Ne_Id   =>  p_Ne_Id,
                            p_Geom    =>  p_Geom
                            );

    END reshape_element;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE move_node (p_no_node_id   IN nm_nodes.no_node_id%TYPE,
                         p_x            IN NUMBER,
                         p_y            IN NUMBER)
    IS
        l_np_id   NM_POINTS.np_id%TYPE;
    BEGIN
        l_np_id := Nm3get.get_no (pi_no_node_id => p_no_node_id).no_np_id;

        UPDATE NM_POINTS np
           SET np.np_grid_east = p_x, np.np_grid_north = p_y
         WHERE np.np_id = l_np_id;
    END;
--
------------------------------------------------------------------------------
--
END Nm3Sdm;
/
