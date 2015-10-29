--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_data_types.sql-arc   1.4   Oct 29 2015 07:42:38   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_data_types.sql  $
--       Date into PVCS   : $Date:   Oct 29 2015 07:42:38  $
--       Date fetched Out : $Modtime:   Oct 29 2015 07:42:58  $
--       PVCS Version     : $Revision:   1.4  $
--
--   Author : R.A. Coupe
--
--   Location bridge Data Types - an interim install script.
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--



-- first a procedure to work around any potential dependencies (bug since 10.2)


create or replace procedure drop_transient_types (p_type in varchar2 ) is
  cursor c1 is select name from user_dependencies
  where referenced_name = p_type
  and type = 'TYPE'
  and name like 'SYSTP%==';
begin
  for irec in c1 loop
    execute immediate 'drop type "'||irec.name||'"';
  end loop;
end;
/


--Location Bridge Stats object type

CREATE OR REPLACE TYPE lb_stats AS OBJECT (
  dummy INTEGER,
  
  STATIC FUNCTION ODCIGetInterfaces (
    p_interfaces OUT SYS.ODCIObjectList
  ) RETURN NUMBER,

  STATIC FUNCTION ODCIStatsTableFunction (
    p_function    IN  SYS.ODCIFuncInfo,
    p_stats       OUT SYS.ODCITabFuncStats,
    p_args        IN  SYS.ODCIArgDescList,
    p_cardinality IN INTEGER
  ) RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY lb_stats AS
  STATIC FUNCTION ODCIGetInterfaces (
    p_interfaces OUT SYS.ODCIObjectList
  ) RETURN NUMBER IS
  BEGIN
    p_interfaces := SYS.ODCIObjectList(
                      SYS.ODCIObject ('SYS', 'ODCISTATS2')
                    );
    RETURN ODCIConst.success;
  END ODCIGetInterfaces;

  STATIC FUNCTION ODCIStatsTableFunction (
                    p_function    IN  SYS.ODCIFuncInfo,
                    p_stats       OUT SYS.ODCITabFuncStats,
                    p_args        IN  SYS.ODCIArgDescList,
                    p_cardinality IN INTEGER
                  ) RETURN NUMBER IS
  BEGIN
    p_stats := SYS.ODCITabFuncStats(NULL);
    p_stats.num_rows := p_cardinality;
    RETURN ODCIConst.success;
  END ODCIStatsTableFunction;
END;
/


--Location Bridge location reference types
--Step 1 - the reference point basic obejct and table type
drop type lb_RPt_tab 
/

begin
  drop_transient_types('LB_RPT');
end;
/

create or replace type  lb_RPt as object ( refnt integer, 
                                           refnt_type integer, 
                                           obj_type varchar2(4), 
                                           obj_id integer, 
                                           seg_id integer, 
                                           seq_id integer, 
                                           dir_flag integer, 
                                           start_m number, 
                                           end_m number, 
                                           m_unit integer )
/

create or replace type lb_RPt_tab is table of lb_RPt
/

drop type lb_loc_error_tab
/

begin
  drop_transient_types('LB_LOC_ERROR');
end;
/


create or replace type lb_loc_error as object (refnt integer, error_code integer, error_msg varchar2(100) )
/

create or replace type lb_loc_error_tab as table of lb_loc_error
/


drop type lb_obj_id_tab
/

begin
  drop_transient_types('LB_OBJ_ID');
end;
/

create or replace type lb_obj_id as object ( obj_type varchar2(4), obj_id integer )
/

create or replace type lb_obj_id_tab as table of lb_obj_id
/

drop type lb_RPt_geom_tab
/

begin
  drop_transient_types('LB_RPT_GEOM');
end;
/


create or replace type  lb_RPt_Geom as object ( refnt integer, 
                                                refnt_type integer, 
                                                obj_type varchar2(4), 
                                                obj_id integer, 
                                                seg_id integer, 
                                                seq_id integer,  
                                                dir_flag integer, 
                                                start_m number, 
                                                end_m number, 
                                                m_unit integer, 
                                                geom mdsys.sdo_geometry )
/

create or replace type lb_RPt_geom_tab is table of lb_RPt_geom
/

create or replace type lb_obj_Geom as object ( obj_type varchar2(4), obj_id integer, geom mdsys.sdo_geometry )
/

create or replace type lb_obj_geom_tab is table of lb_obj_geom
/

CREATE OR REPLACE
TYPE LB_ASSET_TYPE_NETWORK AS OBJECT
(
   AssetType        INTEGER,
   NetworkTypeId    INTEGER,
   NetworkType      VARCHAR2 (4),
   NetworkTypeName  VARCHAR2 (30),
   NetworkFlag      VARCHAR2 (1),
   NetworkTypeDescr VARCHAR2 (80),
   UnitName         VARCHAR2 (40),
   UnitMask         VARCHAR2 (80)
);
/

CREATE OR REPLACE
type LB_ASSET_TYPE_NETWORK_TAB
as table of lb_asset_type_network
/

CREATE OR REPLACE
type LB_JXP as object (jxp_code integer, jxp_descr varchar2(80) );
/

CREATE OR REPLACE
type LB_JXP_TAB as table of lb_jxp;
/

CREATE OR REPLACE
TYPE LB_LINEAR_REFNT AS OBJECT(
   NetworkTypeId       NUMBER,        -- ID of the network type
   NetworkElementID    NUMBER(9),     -- Network element ID
   NetworkElementName  VARCHAR2(50),  -- Network element unique name
   NetworkElementDescr VARCHAR2(240), -- Optional network element description
   NetworkElementType  VARCHAR2(4),   -- Network element type code
   NetworkTypeDescr    VARCHAR2(80),  -- Optional description of the network type
   Unit                VARCHAR2(20)); -- Default length unit
/

CREATE OR REPLACE
TYPE LB_LINEAR_REFNT_TAB AS TABLE OF LB_LINEAR_REFNT;
/

CREATE OR REPLACE
TYPE LB_LINEAR_TYPE AS OBJECT(
   NetworkTypeId    NUMBER,        -- ID of the network type
   NetworkType      VARCHAR2(4),   -- Unique name of the network type
   NetworkFlag      CHAR(1),       -- Indicates datum (D), Group (G) etc.
   NetworkTypeDescr VARCHAR2(80),  -- Optional description of the network type
   Unit             VARCHAR2(20),  -- Default length unit
   UnitMask         VARCHAR2(80)); -- Format mask for displying lengths
/

CREATE OR REPLACE
type LB_LINEAR_TYPE_TAB as table of LB_LINEAR_TYPE
/

CREATE OR REPLACE
type LB_LOCATION_ID as object(
LocationId Integer, LocationDescription varchar2(240), JXP_CODE integer, JXP_DESCR varchar2(80))
/

CREATE OR REPLACE
type LB_LOCATION_ID_TAB
as table of lb_location_id;
/

CREATE OR REPLACE
TYPE LB_REFNT_MEASURE AS OBJECT(
   NetworkElementId   INTEGER,       -- Network element ID
   NetworkElementName VARCHAR2(30),  -- Network element unique name
   StartM             NUMBER,        -- Minimum absolute linear measure
   EndM               NUMBER,        -- Maximum absolute linear measure
   Unit               VARCHAR2(20)); -- Units of minimum and maximum measures
/

CREATE OR REPLACE
TYPE LB_REFNT_MEASURE_TAB AS TABLE OF LB_REFNT_MEASURE;
/

CREATE OR REPLACE
type LB_XSP as object ( XSP varchar2(4), XSP_DESCR varchar2(80) );
/

CREATE OR REPLACE
type LB_XSP_TAB as table of lb_xsp;
/--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_data_types.sql-arc   1.4   Oct 29 2015 07:42:38   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_data_types.sql  $
--       Date into PVCS   : $Date:   Oct 29 2015 07:42:38  $
--       Date fetched Out : $Modtime:   Oct 29 2015 07:42:58  $
--       PVCS Version     : $Revision:   1.4  $
--
--   Author : R.A. Coupe
--
--   Location bridge Data Types - an interim install script.
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--



-- first a procedure to work around any potential dependencies (bug since 10.2)


create or replace procedure drop_transient_types (p_type in varchar2 ) is
  cursor c1 is select name from user_dependencies
  where referenced_name = p_type
  and type = 'TYPE'
  and name like 'SYSTP%==';
begin
  for irec in c1 loop
    execute immediate 'drop type "'||irec.name||'"';
  end loop;
end;
/


--Location Bridge Stats object type

CREATE OR REPLACE TYPE lb_stats AS OBJECT (
  dummy INTEGER,
  
  STATIC FUNCTION ODCIGetInterfaces (
    p_interfaces OUT SYS.ODCIObjectList
  ) RETURN NUMBER,

  STATIC FUNCTION ODCIStatsTableFunction (
    p_function    IN  SYS.ODCIFuncInfo,
    p_stats       OUT SYS.ODCITabFuncStats,
    p_args        IN  SYS.ODCIArgDescList,
    p_cardinality IN INTEGER
  ) RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY lb_stats AS
  STATIC FUNCTION ODCIGetInterfaces (
    p_interfaces OUT SYS.ODCIObjectList
  ) RETURN NUMBER IS
  BEGIN
    p_interfaces := SYS.ODCIObjectList(
                      SYS.ODCIObject ('SYS', 'ODCISTATS2')
                    );
    RETURN ODCIConst.success;
  END ODCIGetInterfaces;

  STATIC FUNCTION ODCIStatsTableFunction (
                    p_function    IN  SYS.ODCIFuncInfo,
                    p_stats       OUT SYS.ODCITabFuncStats,
                    p_args        IN  SYS.ODCIArgDescList,
                    p_cardinality IN INTEGER
                  ) RETURN NUMBER IS
  BEGIN
    p_stats := SYS.ODCITabFuncStats(NULL);
    p_stats.num_rows := p_cardinality;
    RETURN ODCIConst.success;
  END ODCIStatsTableFunction;
END;
/


--Location Bridge location reference types
--Step 1 - the reference point basic obejct and table type
drop type lb_RPt_tab 
/

begin
  drop_transient_types('LB_RPT');
end;
/

create or replace type  lb_RPt as object ( refnt integer, 
                                           refnt_type integer, 
                                           obj_type varchar2(4), 
                                           obj_id integer, 
                                           seg_id integer, 
                                           seq_id integer, 
                                           dir_flag integer, 
                                           start_m number, 
                                           end_m number, 
                                           m_unit integer )
/

create or replace type lb_RPt_tab is table of lb_RPt
/

drop type lb_loc_error_tab
/

begin
  drop_transient_types('LB_LOC_ERROR');
end;
/


create or replace type lb_loc_error as object (refnt integer, error_code integer, error_msg varchar2(100) )
/

create or replace type lb_loc_error_tab as table of lb_loc_error
/


drop type lb_obj_id_tab
/

begin
  drop_transient_types('LB_OBJ_ID');
end;
/

create or replace type lb_obj_id as object ( obj_type varchar2(4), obj_id integer )
/

create or replace type lb_obj_id_tab as table of lb_obj_id
/

drop type lb_RPt_geom_tab
/

begin
  drop_transient_types('LB_RPT_GEOM_TAB');
  drop_transient_types('LB_RPT_GEOM');
  end;
/


create or replace type  lb_RPt_Geom as object ( refnt integer, 
                                                refnt_type integer, 
                                                obj_type varchar2(4), 
                                                obj_id integer, 
                                                seg_id integer, 
                                                seq_id integer,  
                                                dir_flag integer, 
                                                start_m number, 
                                                end_m number, 
                                                m_unit integer, 
                                                geom mdsys.sdo_geometry )
/

create or replace type lb_RPt_geom_tab is table of lb_RPt_geom
/

drop type lb_obj_geom_tab force;

drop type lb_obj_Geom  force;

create or replace type lb_obj_Geom as object ( obj_type varchar2(4), obj_id integer, geom mdsys.sdo_geometry )
/

create or replace type lb_obj_geom_tab is table of lb_obj_geom
/

drop type LB_ASSET_TYPE_NETWORK_TAB force;

drop type LB_ASSET_TYPE_NETWORK force;

CREATE OR REPLACE
TYPE LB_ASSET_TYPE_NETWORK AS OBJECT
(
   AssetType        INTEGER,
   NetworkTypeId    INTEGER,
   NetworkType      VARCHAR2 (4),
   NetworkTypeName  VARCHAR2 (30),
   NetworkFlag      VARCHAR2 (1),
   NetworkTypeDescr VARCHAR2 (80),
   UnitName         VARCHAR2 (40),
   UnitMask         VARCHAR2 (80)
);
/

CREATE OR REPLACE
type LB_ASSET_TYPE_NETWORK_TAB
as table of lb_asset_type_network
/

drop type LB_JXP_TAB force;

drop type LB_JXP force;

CREATE OR REPLACE
type LB_JXP as object (jxp_code integer, jxp_descr varchar2(80) );
/

CREATE OR REPLACE
type LB_JXP_TAB as table of lb_jxp;
/

drop type LB_LINEAR_REFNT_tab force;

drop type LB_LINEAR_REFNT force;


CREATE OR REPLACE
TYPE LB_LINEAR_REFNT AS OBJECT(
   NetworkTypeId       NUMBER,        -- ID of the network type
   NetworkElementID    NUMBER(9),     -- Network element ID
   NetworkElementName  VARCHAR2(50),  -- Network element unique name
   NetworkElementDescr VARCHAR2(240), -- Optional network element description
   NetworkElementType  VARCHAR2(4),   -- Network element type code
   NetworkTypeDescr    VARCHAR2(80),  -- Optional description of the network type
   Unit                VARCHAR2(20)); -- Default length unit
/

CREATE OR REPLACE
TYPE LB_LINEAR_REFNT_TAB AS TABLE OF LB_LINEAR_REFNT;
/

drop type LB_LINEAR_TYPE_TAB force;

drop type LB_LINEAR_TYPE force;

CREATE OR REPLACE
TYPE LB_LINEAR_TYPE AS OBJECT(
   NetworkTypeId    NUMBER,        -- ID of the network type
   NetworkType      VARCHAR2(4),   -- Unique name of the network type
   NetworkFlag      CHAR(1),       -- Indicates datum (D), Group (G) etc.
   NetworkTypeDescr VARCHAR2(80),  -- Optional description of the network type
   Unit             VARCHAR2(20),  -- Default length unit
   UnitMask         VARCHAR2(80)); -- Format mask for displying lengths
/

CREATE OR REPLACE
type LB_LINEAR_TYPE_TAB as table of LB_LINEAR_TYPE
/

drop type LB_LOCATION_ID_TAB force;

drop type LB_LOCATION_ID force;

CREATE OR REPLACE
type LB_LOCATION_ID as object(
LocationId Integer, LocationDescription varchar2(240), JXP_CODE integer, JXP_DESCR varchar2(80))
/

CREATE OR REPLACE
type LB_LOCATION_ID_TAB
as table of lb_location_id;
/

drop type LB_REFNT_MEASURE_TAB force;

drop type LB_REFNT_MEASURE force;

CREATE OR REPLACE
TYPE LB_REFNT_MEASURE AS OBJECT(
   NetworkElementId   INTEGER,       -- Network element ID
   NetworkElementName VARCHAR2(30),  -- Network element unique name
   StartM             NUMBER,        -- Minimum absolute linear measure
   EndM               NUMBER,        -- Maximum absolute linear measure
   Unit               VARCHAR2(20)); -- Units of minimum and maximum measures
/

CREATE OR REPLACE
TYPE LB_REFNT_MEASURE_TAB AS TABLE OF LB_REFNT_MEASURE;
/

drop type LB_XSP_TAB force;

drop type LB_XSP force;

CREATE OR REPLACE
type LB_XSP as object ( XSP varchar2(4), XSP_DESCR varchar2(80) );
/

CREATE OR REPLACE
type LB_XSP_TAB as table of lb_xsp;
/

drop type LINEAR_ELEMENT_TYPES force;

drop type LINEAR_ELEMENT_TYPE force;


CREATE OR REPLACE
TYPE LINEAR_ELEMENT_TYPE                                         AS OBJECT(
   linearlyLocatableType  NUMBER,        -- ID of a linearly locatable type
   linearElementTypeId    NUMBER,        -- ID of the linear element type
   linearElementTypeName  VARCHAR2(30),  -- Unique name of the linear element type
   linearElementTypeDescr VARCHAR2(80),  -- Optional description of the linear element type
   lengthUnit             VARCHAR2(20)); -- Default length unit
/

CREATE OR REPLACE
TYPE  LINEAR_ELEMENT_TYPES AS TABLE OF linear_element_type;
/

drop type LINEAR_LOCATIONS force;

drop type LINEAR_LOCATION force;

CREATE OR REPLACE
TYPE LINEAR_LOCATION AS OBJECT(
   AssetId             NUMBER(38),    -- ID of the linearly located asset
   AssetType           NUMBER(38),    -- Type of the asset
   LocationId          NUMBER(38),    -- ID of the linear location
   LocationDescription VARCHAR2(240), -- Linear location description
   NetworkTypeId       INTEGER,       -- Network element type
   NetworkElementId    INTEGER,       -- Network element ID
   StartM              NUMBER,        -- Absolute position of start of linear range
   EndM                NUMBER,        -- Optional absolute position of end of linear range
   Unit                INTEGER,       -- Exor ID of Units of start and end position
   NetworkElementName  VARCHAR2(30),  -- Network element unique name
   NetworkElementDescr VARCHAR2(240), -- Optional network element description
   JXP                 VARCHAR2(80)); -- Juxtaposition of owning linear location
/

CREATE OR REPLACE
TYPE LINEAR_LOCATIONS AS TABLE OF linear_location;
/




CREATE OR REPLACE
TYPE LINEAR_ELEMENT_TYPE                                         AS OBJECT(
   linearlyLocatableType  NUMBER,        -- ID of a linearly locatable type
   linearElementTypeId    NUMBER,        -- ID of the linear element type
   linearElementTypeName  VARCHAR2(30),  -- Unique name of the linear element type
   linearElementTypeDescr VARCHAR2(80),  -- Optional description of the linear element type
   lengthUnit             VARCHAR2(20)); -- Default length unit
/

CREATE OR REPLACE
TYPE  LINEAR_ELEMENT_TYPES AS TABLE OF linear_element_type;
/

CREATE OR REPLACE
TYPE LINEAR_LOCATION AS OBJECT(
   AssetId             NUMBER(38),    -- ID of the linearly located asset
   AssetType           NUMBER(38),    -- Type of the asset
   LocationId          NUMBER(38),    -- ID of the linear location
   LocationDescription VARCHAR2(240), -- Linear location description
   NetworkTypeId       INTEGER,       -- Network element type
   NetworkElementId    INTEGER,       -- Network element ID
   StartM              NUMBER,        -- Absolute position of start of linear range
   EndM                NUMBER,        -- Optional absolute position of end of linear range
   Unit                INTEGER,       -- Exor ID of Units of start and end position
   NetworkElementName  VARCHAR2(30),  -- Network element unique name
   NetworkElementDescr VARCHAR2(240), -- Optional network element description
   JXP                 VARCHAR2(80)); -- Juxtaposition of owning linear location
/

CREATE OR REPLACE
TYPE LINEAR_LOCATIONS AS TABLE OF linear_location;
/


