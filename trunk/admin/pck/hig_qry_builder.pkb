CREATE OR REPLACE PACKAGE BODY hig_qry_builder
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/hig_qry_builder.pkb-arc   3.1   May 16 2011 14:42:20   Steve.Cooper  $
--       Module Name      : $Workfile:   hig_qry_builder.pkb  $
--       Date into PVCS   : $Date:   May 16 2011 14:42:20  $
--       Date fetched Out : $Modtime:   May 03 2011 10:59:56  $
--       Version          : $Revision:   3.1  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   3.1  $';

  g_package_name CONSTANT varchar2(30) := 'hig_qry_builder';
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
/*PROCEDURE save_query_attributes(pi_qat_rec IN OUT hig_query_type_attributes%ROWTYPE)
IS
BEGIN
--
   SELECT hqta_id_seq.NEXTVAL
   INTO   pi_qat_rec.hqta_id
   FROM   dual ;
   INSERT INTO hig_query_type_attributes VALUES pi_qat_rec ;
--
END save_query_attributes;
--
*/
FUNCTION get_attribute_value(pi_qat_qt_id     hig_query_type_attributes.hqta_hqt_id%TYPE
                            ,pi_atribute_name hig_query_type_attributes.hqta_attribute_name%TYPE) 
RETURN Varchar2
IS
--
   CURSOR c_get_attb_value
   IS
   SELECT hqta_data_value
   FROM   hig_query_type_attributes
   WHERE  hqta_hqt_id          = pi_qat_qt_id
   AND    hqta_attribute_name =  pi_atribute_name;
   l_value hig_query_type_attributes.hqta_data_value%TYPE;
--
BEGIN
--
   OPEN  c_get_attb_value;
   FETCH c_get_attb_value INTO l_value;
   CLOSe c_get_attb_value;
   
   RETURN l_value;
--
END get_attribute_value;
--
FUNCTION get_sql Return Varchar2
IS
--
BEGIN
--
   Return hig_qry_builder.g_return_sql ;
--
END get_sql;
--
PROCEDURE set_sql(pi_sql IN Varchar2,pi_hqt_id IN hig_query_types.hqt_id%TYPE )
IS
BEGIN
--
   hig_qry_builder.g_return_sql := pi_sql;
   hig_qry_builder.g_hqt_id     := pi_hqt_id ;
--
END set_sql;
--
PROCEDURE clear_sql
IS
BEGIN
--
   hig_qry_builder.g_return_sql := Null;
   hig_qry_builder.g_hqt_id := Null;
--
END clear_sql;
--
FUNCTION get_hqt_id Return Number
IS
--
BEGIN
--
   Return hig_qry_builder.g_hqt_id ;
--
END get_hqt_id;
--
FUNCTION get_hqt (pi_hqt_id IN hig_query_types.hqt_id%TYPE)
Return hig_query_types%ROWTYPE
IS
--
   CURSOR c_get_hqt 
   IS
   SELECT *
   FROM   hig_query_types
   WHERE  hqt_id = pi_hqt_id ;
   l_hqt_rec hig_query_types%ROWTYPE;   
--
BEGIN
--
   OPEN  c_get_hqt;
   FETCH c_get_hqt INTO l_hqt_rec ;
   CLOSE c_get_hqt;
   Return l_hqt_rec ;
--
END get_hqt;
--
FUNCTION duplicate_query_name(pi_query_name IN  hig_query_types.hqt_name%TYPE
                             ,pi_security   IN  hig_query_types.hqt_security%TYPE) RETURN Boolean

IS
--
   CURSOR check_public_name
   IS
   SELECT 'Y'
   FROM   hig_query_types
   WHERe  Upper(hqt_name) =  Upper(pi_query_name)
   AND    hqt_security = 'P' ;

   CURSOR check_private_name
   IS
   SELECT 'Y'
   FROM   hig_query_types
   WHERe  Upper(hqt_name) =  Upper(pi_query_name)
   AND    hqt_created_by = Sys_Context('NM3_SECURITY_CTX','USERNAME') ;

   l_rec Varchar2(1);
--
BEGIN
--
   IF pi_security = 'P'
   THEN
       OPEN  check_public_name;
       FETCH check_public_name INTO l_rec ;
       CLOSE check_public_name ;
  
       RETURN Nvl(l_rec,'N') = 'Y';

   ELSE
       OPEN  check_private_name;
       FETCH check_private_name INTO l_rec ;
       CLOSE check_private_name ;
  
       RETURN Nvl(l_rec,'N') = 'Y';

   END IF ; 
--
END duplicate_query_name;
--
END hig_qry_builder;
/
