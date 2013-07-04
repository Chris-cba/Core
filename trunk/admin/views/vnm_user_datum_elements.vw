create or replace force view vnm_user_datum_elements
(NE_ID,
 NE_TYPE,
 NE_UNIQUE,
 NE_NT_TYPE,
 NE_DESCR,
 NE_LENGTH,
 NE_LENGTH_UNIT,
 NE_LENGTH_UNIT_NAME,
 NE_DATE_CREATED,
 NE_DATE_MODIFIED,
 NE_MODIFIED_BY,
 NE_CREATED_BY,
 NE_START_DATE,
 NE_END_DATE,
 NE_OWNER,
 NE_NAME_1,
 NE_NAME_2,
 NE_PREFIX,
 NE_NUMBER,
 NE_SUB_TYPE,
 NE_GROUP,
 NE_NO_START,
 NE_NO_END,
 NE_SUB_CLASS,
 NE_NSG_REF,
 NE_VERSION_NO,
 NE_ADMIN_UNIT )
as
select
 NE_ID,
 NE_TYPE,
 NE_UNIQUE,
 NE_NT_TYPE,
 NE_DESCR,
 nm3unit.convert_unit( nm3net.get_nt_units( ne_nt_type ),
        nm3user.get_user_length_units, NE_LENGTH) ,
 nm3user.get_user_length_units,
 nm3unit.get_unit_name( nm3user.get_user_length_units ),
 NE_DATE_CREATED,
 NE_DATE_MODIFIED,
 NE_MODIFIED_BY,
 NE_CREATED_BY,
 NE_START_DATE,
 NE_END_DATE,
 NE_OWNER,
 NE_NAME_1,
 NE_NAME_2,
 NE_PREFIX,
 NE_NUMBER,
 NE_SUB_TYPE,
 NE_GROUP,
 NE_NO_START,
 NE_NO_END,
 NE_SUB_CLASS,
 NE_NSG_REF,
 NE_VERSION_NO,
 NE_ADMIN_UNIT
from nm_elements
where ne_type = 'S'
and   ne_start_date <= nm3user.get_effective_date
and   nvl(ne_end_date, nm3user.get_effective_date + 1)   >  nm3user.get_effective_date
/

create or replace trigger insert_vnm_user_datum_elements
instead of insert on vnm_user_datum_elements
begin
  if nm3user.get_effective_date < trunc( sysdate ) then
    raise_application_error ( -20001, 'No historical inserts allowed');
  elsif :new.NE_END_DATE <= :new.NE_START_DATE then
    raise_application_error ( -20002, 'End date may not be before the start date');
  end if;

  insert into nm_elements (
  NE_ID,
  NE_UNIQUE,
  NE_TYPE,
  NE_NT_TYPE,
  NE_DESCR,
  NE_LENGTH,
  NE_START_DATE,
  NE_END_DATE,
  NE_OWNER,
  NE_NAME_1,
  NE_NAME_2,
  NE_PREFIX,
  NE_NUMBER,
  NE_SUB_TYPE,
  NE_GROUP,
  NE_NO_START,
  NE_NO_END,
  NE_SUB_CLASS,
  NE_NSG_REF,
  NE_VERSION_NO,
  NE_ADMIN_UNIT )
  values
  (
:new.ne_id,
:new.ne_unique,
'S',
:new.ne_nt_type,
:new.ne_descr,
nm3unit.convert_unit(  nm3user.get_user_length_units,
                       nm3net.get_nt_units( :new.ne_nt_type ),
                      :new.ne_length  ),
:new.ne_start_date,
:new.ne_end_date,
:new.ne_owner,
:new.ne_name_1,
:new.ne_name_2,
:new.ne_prefix,
:new.NE_NUMBER,
:new.NE_SUB_TYPE,
:new.NE_GROUP,
:new.NE_NO_START,
:new.NE_NO_END,
:new.NE_SUB_CLASS,
:new.NE_NSG_REF,
:new.NE_VERSION_NO,
:new.ne_admin_unit );

 nm3nwval.aft_trigger_validate_element ( :new.ne_id,
						 :new.NE_UNIQUE    ,
						 :new.NE_NT_TYPE   ,
						 :new.NE_OWNER     ,
						 :new.NE_NAME_1    ,
						 :new.NE_NAME_2    ,
						 :new.NE_PREFIX    ,
						 :new.NE_NUMBER    ,
						 :new.NE_SUB_TYPE  ,
						 :new.NE_NO_START  ,
						 :new.NE_NO_END    ,
						 :new.NE_SUB_CLASS ,
						 :new.NE_NSG_REF   ,
						 :new.NE_VERSION_NO,
						 :new.NE_GROUP     );


end;
/

create or replace trigger update_vnm_user_datum_elements
instead of update on vnm_user_datum_elements
begin
  if nm3user.get_effective_date < trunc( sysdate ) then
    raise_application_error ( -20001, 'No historical updates allowed');
  elsif :new.NE_END_DATE <= :new.NE_START_DATE then
    raise_application_error ( -20002, 'End date may not be before the start date');
  end if;

  update nm_elements
  set  NE_UNIQUE              = :new.NE_UNIQUE              ,
       NE_TYPE                = :new.NE_TYPE                ,
       NE_NT_TYPE             = :new.NE_NT_TYPE             ,
       NE_DESCR               = :new.NE_DESCR               ,
       NE_LENGTH              = :new.NE_LENGTH              ,
       NE_ADMIN_UNIT          = :new.NE_ADMIN_UNIT          ,
       NE_START_DATE          = :new.NE_START_DATE          ,
       NE_END_DATE            = :new.NE_END_DATE            ,
       NE_OWNER               = :new.NE_OWNER               ,
       NE_NAME_1              = :new.NE_NAME_1              ,
       NE_NAME_2              = :new.NE_NAME_2              ,
       NE_PREFIX              = :new.NE_PREFIX              ,
       NE_NUMBER              = :new.NE_NUMBER              ,
       NE_SUB_TYPE            = :new.NE_SUB_TYPE            ,
       NE_GROUP               = :new.NE_GROUP               ,
       NE_NO_START            = :new.NE_NO_START            ,
       NE_NO_END              = :new.NE_NO_END              ,
       NE_SUB_CLASS           = :new.NE_SUB_CLASS           ,
       NE_NSG_REF             = :new.NE_NSG_REF             ,
       NE_VERSION_NO          = :new.NE_VERSION_NO
  where NE_ID                  = :new.NE_ID                  ;
end;
/
