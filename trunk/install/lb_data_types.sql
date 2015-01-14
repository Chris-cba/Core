--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_data_types.sql-arc   1.0   Jan 14 2015 16:08:36   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_data_types.sql  $
--       Date into PVCS   : $Date:   Jan 14 2015 16:08:36  $
--       Date fetched Out : $Modtime:   Jan 14 2015 16:07:58  $
--       PVCS Version     : $Revision:   1.0  $
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

