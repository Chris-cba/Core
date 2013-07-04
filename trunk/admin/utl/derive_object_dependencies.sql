-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)derive_object_dependencies.sql	1.1 07/19/06
--       Module Name      : derive_object_dependencies.sql
--       Date into SCCS   : 06/07/19 21:14:30
--       Date fetched Out : 07/06/13 17:07:19
--       SCCS Version     : 1.1
--
--
--   Author : Graeme Johnson
--   A script that creates a table/view showing object dependencies
--   Utilised initially for compile_schema.sql and for dropping of types in nm3typ.sql
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

set term off

DECLARE
 ex_not_exists exception;
 pragma exception_init (ex_not_exists,-942);

BEGIN
  execute immediate('drop table temp_depend');
EXCEPTION
  WHEN ex_not_exists THEN
    Null;
   WHEN others THEN
     RAISE;
END;
/
create table temp_depend as
select d.d_obj# object_id
      ,d.p_obj# referenced_object_id
 from  sys.dependency$ d
where  d.d_owner# in (select user#
                       From  sys.user$
                      where  name = USER
                     )
/
CREATE INDEX IX1 ON
  TEMP_DEPEND(OBJECT_ID)
/
CREATE INDEX IX2 ON
  TEMP_DEPEND(REFERENCED_OBJECT_ID)
/
create or replace force view ord_obj_by_depend as
select max(level) dlevel
      ,object_id
from temp_depend
connect by object_id = prior referenced_object_id
group by object_id
/
set term on




