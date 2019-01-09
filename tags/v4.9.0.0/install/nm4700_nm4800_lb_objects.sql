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
DECLARE
   not_exists   EXCEPTION;
   PRAGMA EXCEPTION_INIT (not_exists, -4043);
BEGIN
   EXECUTE IMMEDIATE ('drop type lb_RPt_tab');
EXCEPTION
WHEN not_exists
   THEN
      NULL;
END;
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

------------------------------------------------------------------------------
-- Create LB_TRANSACTION_ID_SEQ Sequence

PROMPT Creating Sequence 'LB_TRANSACTION_ID_SEQ'
DECLARE
  already_exists EXCEPTION;
  PRAGMA exception_init (already_exists, -955 );
BEGIN
  EXECUTE IMMEDIATE 'create sequence LB_TRANSACTION_ID_SEQ start with 1';
EXCEPTION
  WHEN already_exists THEN NULL;
END;
/
--
--------------------------------------------------------------------------------
-- Function
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating Function get_lb_RPt_r_tab.fnw
SET TERM OFF
--
SET FEEDBACK ON
START get_lb_RPt_r_tab.fnw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Header
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating Package Header lb_aggr.pkh
SET TERM OFF
--
SET FEEDBACK ON
START lb_aggr.pkh
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Body
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating Package Body lb_aggr.pkw
SET TERM OFF
--
SET FEEDBACK ON
START lb_aggr.pkw
SET FEEDBACK OFF


