CREATE OR REPLACE PACKAGE BODY doc_api AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/doc_api.pkb-arc   2.3   Jul 17 2012 09:20:28   Rob.Coupe  $
--       Module Name      : $Workfile:   doc_api.pkb  $
--       Date into SCCS   : $Date:   Jul 17 2012 09:20:28  $
--       Date fetched Out : $Modtime:   Jul 17 2012 09:16:46  $
--       SCCS Version     : $Revision:   2.3  $
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
  g_body_sccsid   CONSTANT varchar2(2000) := '"$Revision:   2.3  $"';

  g_package_name  CONSTANT varchar2(30) := 'doc_api';
  
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
FUNCTION validate_document(ce_reference_no in  varchar2
                         , ce_title        in  varchar2
                         , ce_descr        in  varchar2
                         , ce_dlc_id       in  number  
                         , ce_file_name    in  varchar2
                         , ce_doc_type     in  varchar2
                         , ce_doc_class    in  varchar2 default null
                         , ce_date_issued  in  varchar2 default to_char(sysdate)
                         , ce_date_expired in  varchar2 default null
                         , ce_issue_number in  number   default 1
                         , ce_x_coordinate in  number   default null
                         , ce_y_coordinate in  number   default null                         
                         , error_value     out number  
                         , error_text      out varchar2) RETURN BOOLEAN IS


    
    l_count integer ;

BEGIN

  -- 1. Valid DLC/DMD?
  IF  nm3get.get_dlc(pi_dlc_id => ce_dlc_id
                    ,pi_raise_not_found => FALSE).dlc_id IS NULL THEN
  
    raise_application_error(-20001,'Could not find doc location for dlc id = ' || nvl(to_char(ce_dlc_id),'<null>'));

  END IF;
  
  
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

    Select count(*)--'valid'
    into  l_count    
    From doc_class
    Where dcl_code = upper(ce_doc_class)
    And exists (select 1 from doc_types
                where dtp_code = dcl_dtp_code
                and dtp_allow_complaints = 'N'
                and dtp_allow_comments = 'N' );


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

  
  -- 6 If one coord is specified then so must the other
  IF  (ce_x_coordinate IS NOT NULL AND ce_y_coordinate IS NULL)
   OR 
      (ce_x_coordinate IS NULL AND ce_y_coordinate IS NOT NULL) THEN
    raise_application_error(-20001,'Both coordinates must be supplied '||chr(10)||'X ['||ce_x_coordinate||']'||chr(10)||'Y ['||ce_y_coordinate||']');  
  END IF;
   



 RETURN(TRUE);

EXCEPTION
  WHEN OTHERS THEN
    error_value := SQLCODE ;
    error_text  := SQLERRM ;
    RETURN(FALSE);

END validate_document;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_doc(pi_doc_id               IN OUT docs.doc_id%TYPE
                , pi_doc_title            IN docs.doc_title%TYPE
                , pi_doc_dtp_code         IN docs.doc_dtp_code%TYPE
                , pi_doc_date_issued      IN docs.doc_date_issued%TYPE
                , pi_doc_file             IN docs.doc_file%TYPE
                , pi_doc_dlc_id           IN docs.doc_dlc_id%TYPE
                , pi_doc_reference_code   IN docs.doc_reference_code%TYPE
                , pi_doc_descr            IN docs.doc_descr%TYPE
                , pi_doc_dcl_code         IN docs.doc_dcl_code%TYPE 
                , pi_doc_date_expires     IN docs.doc_date_expires%TYPE 
                , pi_doc_issue_number     IN docs.doc_issue_number%TYPE
                , pi_doc_compl_east       IN docs.doc_compl_east%TYPE
                , pi_doc_compl_north      IN docs.doc_compl_north%TYPE                
                , pi_commit               IN BOOLEAN) IS  

 l_dlc_rec doc_locations%ROWTYPE; 


BEGIN


     l_dlc_rec := nm3get.get_dlc(pi_dlc_id          => pi_doc_dlc_id
                                ,pi_raise_not_found => TRUE);
                                
     IF pi_doc_id IS NULL THEN 
       pi_doc_id := nm3seq.next_doc_id_seq ;
     END IF;
     
     

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
  , doc_compl_east
  , doc_compl_north
  )
    VALUES
  ( pi_doc_id
  , pi_doc_title
  , UPPER(pi_doc_dtp_code)
  , pi_doc_date_issued
  , pi_doc_file
  , l_dlc_rec.dlc_dmd_id
  , pi_doc_dlc_id
  , UPPER(RTRIM(pi_doc_reference_code))
  , NVL(pi_doc_descr,'Not supplied')
  , UPPER(pi_doc_dcl_code)
  , pi_doc_date_expires
  , pi_doc_issue_number
  , pi_doc_compl_east
  , pi_doc_compl_north
  
  );
  
  IF pi_commit THEN
    commit;
  END IF;

END ins_doc;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_document
( ce_reference_no in  varchar2
, ce_title        in  varchar2
, ce_descr        in  varchar2
, ce_dlc_id       in  number  
, ce_file_name    in  varchar2
, ce_doc_type     in  varchar2
, ce_doc_class    in  varchar2 default null
, ce_date_issued  in  varchar2 default to_char(sysdate, 'DD-MON-YYYY')
, ce_date_expired in  varchar2 default null
, ce_issue_number in  number   default 1
, ce_x_coordinate in  number   default null
, ce_y_coordinate in  number   default null
, ce_doc_id       in out  number
, ce_do_commit    boolean default true  
, error_value     out number  
, error_text      out varchar2
) IS

 l_date_issued  date := nvl(to_date(ce_date_issued,'DD-MON-YYYY'),trunc(sysdate)) ;
 l_date_expired date := to_date(ce_date_expired,'DD-MON-YYYY') ;
 l_issue_number number := nvl(ce_issue_number,1) ;


begin
  nm_debug.proc_start(g_package_name,'create_document');


  IF validate_document(ce_reference_no => ce_reference_no 
                     , ce_title        => ce_title
                     , ce_descr        => ce_descr
                     , ce_dlc_id       => ce_dlc_id  
                     , ce_file_name    => ce_file_name
                     , ce_doc_type     => ce_doc_type
                     , ce_doc_class    => ce_doc_class
                     , ce_date_issued  => l_date_issued
                     , ce_date_expired => l_date_expired
                     , ce_issue_number => l_issue_number
                     , ce_x_coordinate => ce_x_coordinate
                     , ce_y_coordinate => ce_y_coordinate       
                     , error_value     => error_value  
                     , error_text      => error_text) THEN

             ins_doc(pi_doc_id               => ce_doc_id
                   , pi_doc_title            => ce_title
                   , pi_doc_dtp_code         => ce_doc_type
                   , pi_doc_date_issued      => l_date_issued
                   , pi_doc_file             => ce_file_name
                   , pi_doc_dlc_id           => ce_dlc_id
                   , pi_doc_reference_code   => ce_reference_no
                   , pi_doc_descr            => ce_descr
                   , pi_doc_dcl_code         => ce_doc_class 
                   , pi_doc_date_expires     => l_date_expired 
                   , pi_doc_issue_number     => l_issue_number
                   , pi_doc_compl_east       => ce_x_coordinate
                   , pi_doc_compl_north      => ce_y_coordinate                   
                   , pi_commit               => ce_do_commit);
  END IF;

  nm_debug.proc_end(g_package_name,'create_document');

EXCEPTION
  WHEN OTHERS THEN
    error_value := SQLCODE ;
    error_text  := SQLERRM ;
    ce_doc_id   := null ;
    
END create_document; 
--
-----------------------------------------------------------------------------
--
procedure create_doc_assoc
( ce_doc_id     in  number  
, ce_table_name in  varchar2
, ce_unique_id  in  varchar2
, ce_do_commit  in  boolean  default true
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

--nm_debug.debug('cursor string '||l_cursor_string);
--nm_debug.debug('unique '||ce_unique_id);


  BEGIN
      open c_gateway_cur for l_cursor_string using ce_unique_id ;
      fetch c_gateway_cur into l_return_value ;
      l_got_gateway := c_gateway_cur%found ;
      close c_gateway_cur ;
  EXCEPTION
   WHEN others THEN
   nm_debug.debug('when others='||sqlerrm);
     l_got_gateway := FALSE;
  END;     

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

  IF ce_do_commit THEN
    commit ;
  END IF; 
  
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
, ce_do_commit    in  boolean  default true
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

  IF ce_do_commit THEN
    commit ;
  END IF;
  
  
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
