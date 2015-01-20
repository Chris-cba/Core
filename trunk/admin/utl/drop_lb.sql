--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/utl/drop_lb.sql-arc   1.7   Jan 20 2015 16:17:48   Rob.Coupe  $
--       Module Name      : $Workfile:   drop_lb.sql  $
--       Date into PVCS   : $Date:   Jan 20 2015 16:17:48  $
--       Date fetched Out : $Modtime:   Jan 20 2015 16:17:10  $
--       PVCS Version     : $Revision:   1.7  $
--
--   Author : Rob Coupe
--
--   Location Bridge drop script.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

DECLARE
   not_exists   EXCEPTION;
   PRAGMA EXCEPTION_INIT (not_exists, -942);
BEGIN
   EXECUTE IMMEDIATE 'drop table lb_object_dependents';
EXCEPTION
   WHEN not_exists
   THEN
      NULL;
END;
/

/*

select d.d_obj# object_id
      ,d.p_obj# referenced_object_id, o1.name object_name, o2.name referenced_object_name, O1.TYPE#
 from  sys.dependency$ d, SYS.OBJ$ o1, sys.obj$ o2
where  d.p_obj# in 
       (select object_id
          From sys.dba_objects o, lb_objects l
             , sys.user$
         where name = USER
           and owner = name
           and o.object_name = l.object_name
           and o.object_type = l.object_type
       )
and p_obj# = o2.obj#
and d_obj# = o1.obj#
and not exists ( select 1 from lb_objects lo where lo.object_name = o1.name )
and not exists ( select case o1.type#
                        when 12 then (select 1 from user_triggers where trigger_name = o1.name )
                     end from dual )
                        
   select 

and case o1.type 
  when 'INDEX' 
  
and o1.name = 'VCSD'       


create table lb_object_dependents
as
select d.d_obj# object_id
      ,d.p_obj# referenced_object_id
 from  sys.dependency$ d
where  d.p_obj# in 
       (select object_id
          From sys.dba_objects o, lb_objects l
             , sys.user$
         where name = USER
           and owner = name
           and o.object_name = l.object_name
           and o.object_type = l.object_type
       )
/

select * from lb_object_dependents d, dba_objects o
where o.object_id = d.object_id
and not exists ( select 1 from lb_objects l where l.object_name = o.object_name )
 

create or replace view vcsd as select * from nm_locations

select * from lb_object_dependents l, sys.dba_objects o
where o.object_id = l.referenced_object_id
and not exists ( select 1 from lb_objects l2 where l2.object_name = o.object_name )
and owner = user

select l.object_id, l.referenced_object_id, d1.object_id, D1.OBJECT_NAME, D1.OBJECT_TYPE, d2.object_id, D2.OBJECT_NAME, D2.OBJECT_TYPE 
from lb_object_dependents l, sys.dba_objects d1, sys.dba_objects d2
where d1.object_id = l.referenced_object_id
and d2.object_id = l.object_id
and D1.OWNER = user
and D2.OWNER = user

group by object_name, object_type

select rownum rn, d.* from ( 
select max(level) dlevel
      ,object_id
from lb_object_dependents
connect by nocycle object_id = prior referenced_object_id
group by object_id
) d

select * from lb_object_dependents

select rn, dlevel, v.object_id, o.object_name, o.object_type from (
select rownum rn, d.* from ( 
select max(level) dlevel
      ,object_id
from lb_object_dependents
connect by nocycle object_id = prior referenced_object_id
group by object_id
) d
) v, lb_objects l, sys.dba_objects o
where o.object_name = l.object_name
and o.object_type = l.object_type
and o.object_id = v.object_id 
and l.object_type not like '%BODY'
union
select 0, 0, object_id, l.object_name, l.object_type
from lb_objects l, sys.dba_objects o
where o.object_name = l.object_name
and o.object_type = l.object_type
and l.object_type not like '%BODY'
order by rn desc

*/

declare
  cursor c1 is
    select nit_inv_type from nm_inv_types_all where nit_category = 'L';
begin
  for irec in c1 loop
    begin
       execute immediate 'begin lb_reg.drop_lb_asset_type ( pi_exor_type => '||''''||irec.nit_inv_type||''''||' ); end; ';
    exception
      when others then
        null;
    end;
  end loop;
end;
/



declare
  cursor c1 is
    select * from lb_objects;
begin
  for irec in c1 loop
    begin
      if irec.object_type = 'TABLE' then
         begin
		    execute immediate ' alter table '||irec.object_name||' drop primary key cascade ';
	     exception
		   when others then null;
		 end;
         execute immediate ' drop table '||irec.object_name||' cascade constraints ';
      elsif irec.object_type in ('VIEW', 'SEQUENCE', 'PACKAGE', 'PROCEDURE') then
         execute immediate ' drop '||irec.object_type||' '||irec.object_name;
      elsif irec.object_type in ('TYPE', 'TYPE BODY ') then
         execute immediate ' drop '||irec.object_type||' '||irec.object_name||' FORCE';
      end if;
    exception
      when others then NULL;
    end;
  end loop;
  exception
    when others then NULL;
end;
/

select object_name, object_type, 'Remains in existence' from
lb_objects lo 
where exists ( select 1 from user_objects o where lo.object_name = o.object_name )
/


DECLARE
   not_exists   EXCEPTION;
   PRAGMA EXCEPTION_INIT (not_exists, -942);
BEGIN
   EXECUTE IMMEDIATE 'drop table lb_objects';
EXCEPTION
   WHEN not_exists
   THEN
      NULL;
END;
/


/*  


ALTER TABLE LB_TYPES
   DROP PRIMARY KEY CASCADE
/

DROP TABLE LB_TYPES CASCADE CONSTRAINTS
/


DROP TABLE lb_inv_security CASCADE CONSTRAINTS
/


ALTER TABLE NM_ASSET_LOCATIONS_ALL
   DROP PRIMARY KEY CASCADE
/

DROP TABLE NM_ASSET_LOCATIONS_ALL CASCADE CONSTRAINTS
/

DROP SEQUENCE nal_id_seq
/

DROP SEQUENCE NM_loc_id_seq
/

ALTER TABLE NM_JUXTAPOSITION_TYPES
   DROP PRIMARY KEY CASCADE
/

DROP TABLE NM_JUXTAPOSITION_TYPES CASCADE CONSTRAINTS
/

ALTER TABLE NM_JUXTAPOSITIONS
   DROP PRIMARY KEY CASCADE
/

DROP TABLE NM_JUXTAPOSITIONS CASCADE CONSTRAINTS
/


ALTER TABLE NM_ASSET_TYPE_JUXTAPOSITIONS
   DROP PRIMARY KEY CASCADE
/

DROP TABLE NM_ASSET_TYPE_JUXTAPOSITIONS CASCADE CONSTRAINTS
/

DROP SEQUENCE NLG_ID_SEQ
/

ALTER TABLE NM_LOCATION_GEOMETRY
   DROP PRIMARY KEY CASCADE
/

DROP TABLE NM_LOCATION_GEOMETRY CASCADE CONSTRAINTS
/

ALTER TABLE NM_LOCATIONS_ALL
   DROP PRIMARY KEY CASCADE
/

DROP TABLE NM_LOCATIONS_ALL CASCADE CONSTRAINTS
/


drop view v_lb_nlt_geometry
/

drop procedure create_nlt_geometry_view
/

drop view v_nm_nlt_data
/

--drop view V_XSP_LIST
--/

drop view v_lb_xsp_list
/

drop view V_NM_NLT_MEASURES
/

drop view V_LB_NLT_REFNTS
/

drop view V_LB_NETWORKTYPES
/

drop view V_LB_INV_NLT_DATA
/

drop view NM_ASSET_LOCATIONS
/

drop view NM_LOCATIONS
/

drop view V_NM_NLT_UNIT_CONVERSIONS
/

drop view v_nm_nlt_refnts
/

*/

prompt Completed lb_drop script
/
