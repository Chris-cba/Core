CREATE OR REPLACE PACKAGE BODY doc_api AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/doc_api.pkb-arc   2.0   Jun 14 2007 14:59:48   smarshall  $
--       Module Name      : $Workfile:   doc_api.pkb  $
--       Date into SCCS   : $Date:   Jun 14 2007 14:59:48  $
--       Date fetched Out : $Modtime:   Jun 14 2007 14:59:00  $
--       SCCS Version     : $Revision:   2.0  $
--       Based on SCCS Version     : 1.1
--
--
--   Author : Francis Fish
--
--   doc_api body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid   CONSTANT varchar2(2000) := '"$Revision:   2.0  $"';

  g_package_name  CONSTANT varchar2(30) := 'doc_api';
  
  --global variables
  ------------------
  --
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
procedure create_document
( ce_reference_no in  varchar2
, ce_title        in  varchar2
, ce_descr        in  varchar2
, ce_dlc_id       in  number  
, ce_file_name    in  varchar2
, ce_doc_type     in  varchar2
, ce_doc_class    in  varchar2 default null
, ce_date_issued  in  varchar2 default to_char(sysdate)
, ce_date_expired in  varchar2 default null
, ce_issue_number in  number   default 1
, ce_doc_id       out number  
, error_value     out number  
, error_text      out varchar2
) is
l_doc_id docs.doc_id%type ;
cursor get_dmd_id 
( cp_dlc_id in doc_locations.dlc_id%type
) is
select dlc_dmd_id
from   doc_locations
where  dlc_id = cp_dlc_id
;
l_dmd_id doc_locations.dlc_dmd_id%type ;
l_got_dmd boolean ;
l_count integer ;
l_date_issued  date := nvl(to_date(ce_date_issued,'DD-MON-YYYY'),trunc(sysdate)) ;
l_date_expired date := to_date(ce_date_expired,'DD-MON-YYYY') ;
l_issue_number number := nvl(ce_issue_number,1) ;
begin
  nm_debug.proc_start(g_package_name,'create_document');
  -- Validation pass
  -- 1. Valid DLC/DMD?
  open get_dmd_id
    ( ce_dlc_id
    ) ;
  fetch get_dmd_id
  into  l_dmd_id ;
  l_got_dmd := get_dmd_id%found ;
  close get_dmd_id ;
  if not l_got_dmd
  then
    raise_application_error(-20001,'Could not find DMD ID in the locations for dlc id = ' || nvl(to_char(ce_dlc_id),'<null>'));
  end if;
  -- 2. Non-null reference number, title, file name etc.
  if ce_reference_no is null
  then
    raise_application_error(-20001,'Null reference number supplied');
  end if;
  if ce_title is null
  then
    raise_application_error(-20001,'Null title supplied');
  end if;
  if ce_file_name is null
  then
    raise_application_error(-20001,'Null file name supplied');
  end if;
  -- 3. Doc types
  select count(*)
  into  l_count
  from  doc_types
  where dtp_allow_comments   = 'N' 
  and   dtp_allow_complaints = 'N'
  and   dtp_code = upper(ce_doc_type)
  ;
  if l_count = 0
  then
    raise_application_error(-20001,'Document type does not exist');
  end if;
  -- 4. Doc class
  if ce_doc_class is not null
  then
    select count(*)
    into  l_count
    from  doc_class
    where dcl_dtp_code = 'REPT'
    and   dcl_code     = upper(ce_doc_class)
    ;
    if l_count = 0
    then
      raise_application_error(-20001,'Document class does not exist');
    end if;
  end if;
  -- 5. Reference number already exists
  select count(*)
  into   l_count
  from   docs
  where  upper(rtrim(doc_reference_code)) = upper(rtrim(ce_reference_no))
  ;
  if l_count > 0
  then
    raise_application_error(-20001,'Document reference ' || ce_reference_no || ' already exists' );
  end if;
  -- Hurrah! Now we can create our document
  l_doc_id := nm3seq.next_doc_id_seq ;
  ce_doc_id := l_doc_id ;
	INSERT INTO docs 
  ( doc_id
  , doc_title
  , doc_dtp_code
  , doc_date_issued
  , doc_file
  , doc_dlc_dmd_id
  , doc_dlc_id
  , doc_reference_code
  , doc_descr
  , doc_dcl_code
  , doc_date_expires
  , doc_issue_number
  )
	VALUES
  ( l_doc_id
  , ce_title
  , upper(ce_doc_type)
  , l_date_issued
  , ce_file_name
  , l_dmd_id
  , ce_dlc_id
  , upper(rtrim(ce_reference_no))
  , nvl(ce_descr,'Not supplied')
  , upper(ce_doc_class)
  , l_date_expired
  , l_issue_number
  );

  commit ;

  nm_debug.proc_end(g_package_name,'create_document');

exception
  when others then
    error_value := SQLCODE ;
    error_text  := SQLERRM ;
    ce_doc_id   := null ;
end create_document; 
--
-----------------------------------------------------------------------------
--
procedure create_doc_assoc
( ce_doc_id     in  number  
, ce_table_name in  varchar2
, ce_unique_id  in  varchar2
, error_value   out number  
, error_text    out varchar2
) is
  l_count integer ;
  cursor c_get_gateway
    ( b_gateway_table in doc_gateways.dgt_table_name%type
    ) is
  select 'select 1 from ' || dgt_table_name || ' where ' || dgt_pk_col_name || ' = :x '
  from   doc_gateways
  where  dgt_table_name = b_gateway_table
  ;
  l_cursor_string varchar2(2000) ;
  l_return_value integer ;
  l_got_gateway boolean ;
  c_gateway_cur sys_refcursor ;
begin
  nm_debug.proc_start(g_package_name,'create_doc_assoc');
  select count(*)
  into   l_count
  from   docs
  where  doc_id = ce_doc_id
  ;
  if l_count = 0
  then
    raise_application_error(-20001,'Cannot find document with id ' || to_char( ce_doc_id ) );
  end if;
  select count(*)
  into   l_count
  from   doc_gateways
  where  dgt_table_name = upper( ce_table_name )
  and    trunc(sysdate) between nvl(dgt_start_date,trunc(sysdate)) and nvl( dgt_end_date, trunc(sysdate) )
  ;
  if l_count = 0
  then
    raise_application_error(-20001,'Cannot find table ' || ce_table_name || ' in gateway, may be outside valid date range');
  end if;
  open c_get_gateway( upper( ce_table_name ) ) ;
  fetch c_get_gateway
  into  l_cursor_string ;
  l_got_gateway := c_get_gateway%found ;
  close c_get_gateway ;
  if not l_got_gateway
  then
    raise_application_error(-20001, 'Could not find document gateway for table ' || ce_table_name ) ;
  end if;
  open c_gateway_cur for l_cursor_string using ce_unique_id ;
  fetch c_gateway_cur into l_return_value ;
  l_got_gateway := c_gateway_cur%found ;
  close c_gateway_cur ;
  if not l_got_gateway
  then
    raise_application_error(-20001, 'Could not find associated row in table ' || ce_table_name || ' for id ' || ce_unique_id ) ;
  end if;
  insert into doc_assocs
  ( das_table_name
  , das_doc_id
  , das_rec_id
  ) values
  ( ce_table_name
  , ce_doc_id
  , ce_unique_id
  ) ;
  commit ;
  nm_debug.proc_end(g_package_name,'create_doc_assoc');
exception
  when others then
    error_value := SQLCODE ;
    error_text  := SQLERRM ;
end create_doc_assoc; 
--
-----------------------------------------------------------------------------
--
procedure delete_document
( ce_reference_no in  varchar2
, ce_delete_doc   in  varchar2
, error_value     out number  
, error_text      out varchar2
) is
l_doc_id docs.doc_id%type ;
l_action_flag varchar2(50) := upper( ce_delete_doc ) ;
cursor c_get_doc_id
( cp_reference_no in docs.doc_reference_code%type 
) is
select doc_id
from   docs
where  upper(rtrim(doc_reference_code)) = upper(rtrim(cp_reference_no))
;
l_got_doc boolean ;
begin
  nm_debug.proc_start(g_package_name,'delete_document');
  if ce_reference_no is null
  then
    raise_application_error(-20001,'Null reference number supplied');
  end if;
  if ce_delete_doc is null
  then
    raise_application_error(-20001,'Null delete document flag supplied');
  end if;
  if l_action_flag not in ( 'Y', 'N' )
  then
    raise_application_error(-20001,'The delete document flag must be ''Y'' or ''N''');
  end if;
  open c_get_doc_id ( ce_reference_no ) ;
  fetch c_get_doc_id into l_doc_id ;
  l_got_doc := c_get_doc_id%found ;
  close c_get_doc_id ;
  if not l_got_doc
  then
    raise_application_error(-20001,'Could not identify document with reference code of ' || ce_reference_no );
  end if;
  -- We are not going to do any validation - don't care whether it's there or not
  delete from doc_assocs
  where  das_doc_id = l_doc_id
  ;
  if l_action_flag = 'Y'
  then
    delete from docs 
    where doc_id = l_doc_id 
    ;
  end if;
  commit ;
  nm_debug.proc_end(g_package_name,'delete_document');
exception
  when others then
    error_value := SQLCODE ;
    error_text  := SQLERRM ;
end delete_document;  
--
-----------------------------------------------------------------------------
--
END doc_api;
/
