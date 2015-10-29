--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/utl/drop_lb.sql-arc   1.9   Oct 29 2015 07:32:20   Rob.Coupe  $
--       Module Name      : $Workfile:   drop_lb.sql  $
--       Date into PVCS   : $Date:   Oct 29 2015 07:32:20  $
--       Date fetched Out : $Modtime:   Oct 29 2015 07:31:50  $
--       PVCS Version     : $Revision:   1.9  $
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
      elsif irec.object_type in ('VIEW', 'SEQUENCE', 'PACKAGE', 'PROCEDURE', 'FUNCTION') then
         execute immediate ' drop '||irec.object_type||' '||irec.object_name;
      elsif irec.object_type in ('TYPE', 'TYPE BODY ') then
         execute immediate ' drop '||irec.object_type||' '||irec.object_name||' FORCE';
      end if;
    NM3DDL.DROP_SYNONYM_FOR_OBJECT(irec.object_name);
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


prompt Completed lb_drop script
/
