CREATE OR REPLACE PACKAGE BODY hig_flex_attribute
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/hig_flex_attribute.pkb-arc   3.0   Apr 14 2010 10:42:32   malexander  $
--       Module Name      : $Workfile:   hig_flex_attribute.pkb  $
--       Date into PVCS   : $Date:   Apr 14 2010 10:42:32  $
--       Date fetched Out : $Modtime:   Apr 14 2010 10:42:08  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   3.0  $';

  g_package_name CONSTANT varchar2(30) := 'hig_flex_attribute';
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
FUNCTION check_attrib_exists(pi_inv_type    IN nm_inv_types.nit_inv_type%TYPE 
                            ,pi_attrib_name IN nm_inv_type_attribs.ita_attrib_name%TYPE) RETURN Boolean
IS
--
   CURSOR c_check_attrib
   IS
   SELECT 'x'
   FROM   nm_inv_type_attribs
   WHERE  ita_inv_type = pi_inv_type
   AND    ita_attrib_name = pi_attrib_name;
   l_value Varchar2(1);
   l_found Boolean ;
--
BEGIN
--
   OPEN  c_check_attrib;
   FETCH c_check_attrib INTO l_value ;
   l_found :=  c_check_attrib%FOUND ;
   CLOSE c_check_attrib;
   
   Return l_found ;
--
END check_attrib_exists;
--
FUNCTION get_flex_attrib_seq (pi_table_name   IN Varchar2 
                             ,pi_attrib_name  IN nm_inv_type_attribs.ita_attrib_name%TYPE)
RETURN Number
IS
--
   l_hfa_id   hig_flex_attributes.hfa_id%TYPE;
   l_col_no   Number ;
   l_inv_type nm_inv_types.nit_inv_type%TYPE;
BEGIN
--
   FOR i IN 1..5
   LOOP
       BEGIN
          Execute Immediate 'SELECT hfa_id FROM hig_flex_attributes WHERE Upper(hfa_table_name) = :1 AND hfa_attribute'||i||' = :2 AND rownum = 1' INTO l_hfa_id Using pi_table_name,pi_attrib_name  ;     
       EXCEPTION
          WHEN no_data_found
          THEN
              Null; 
       END ;
       IF l_hfa_id IS NOT NULL
       THEN
           l_col_no := i;
           Exit;
       END IF ;
   END LOOP;
   Return l_col_no ;
END get_flex_attrib_seq ;
--
FUNCTION get_inv_for_attrib (pi_table_name   IN Varchar2 
                            ,pi_attrib_name  IN nm_inv_type_attribs.ita_attrib_name%TYPE
                            ,pi_attrib_value IN Varchar2) 
RETURN nm_inv_types%ROWTYPE
IS
--
   l_hfa_id   hig_flex_attributes.hfa_id%TYPE;
   l_col_no   Number ;
   l_inv_type nm_inv_types.nit_inv_type%TYPE;
--
BEGIN

   FOR i IN 1..5
   LOOP
       BEGIN
          Execute Immediate 'SELECT hfa_id FROM hig_flex_attributes WHERE Upper(hfa_table_name) = :1 AND hfa_attribute'||i||' = :2' INTO l_hfa_id Using pi_table_name,pi_attrib_name  ;     
       EXCEPTION
          WHEN no_data_found
          THEN
              Null; 
       END ;
       IF l_hfa_id IS NOT NULL
       THEN
           l_col_no := i;
           Exit;
       END IF ;
   END LOOP;
   IF l_hfa_id IS NOT NULL
   THEN
       BEGIN
          Execute Immediate 'SELECT hfam_nit_inv_type FROM hig_flex_attribute_inv_mapping WHERE hfam_hfa_id = :1 AND hfam_attribute_data'||l_col_no||' = :2' INTO l_inv_type Using l_hfa_id,pi_attrib_value  ;     
       EXCEPTION
          WHEN no_data_found
          THEN
              Null; 
       END ;
       IF l_inv_type IS NOT NULL
       THEN
            Return nm3get.get_nit(l_inv_type);
       ELSE
           Return Null;           
       END IF ;
   ELSE
       Return Null;
   END IF ;
--
END get_inv_for_attrib;
--
FUNCTION get_mapping_inv (pi_table_name     IN Varchar2 
                         ,pi_attrib_name1   IN nm_inv_type_attribs.ita_attrib_name%TYPE
                         ,pi_attrib_value1  IN Varchar2
                         ,pi_attrib_name2   IN nm_inv_type_attribs.ita_attrib_name%TYPE
                         ,pi_attrib_value2  IN Varchar2
                         ,pi_attrib_name3   IN nm_inv_type_attribs.ita_attrib_name%TYPE
                         ,pi_attrib_value3  IN Varchar2
                         ,pi_attrib_name4   IN nm_inv_type_attribs.ita_attrib_name%TYPE
                         ,pi_attrib_value4  IN Varchar2
                         ,pi_attrib_name5   IN nm_inv_type_attribs.ita_attrib_name%TYPE
                         ,pi_attrib_value5  IN Varchar2) 
RETURN nm_inv_types%ROWTYPE
IS
--
   l_hfa_id   hig_flex_attributes.hfa_id%TYPE;
   l_col_no   Number ;
   l_inv_type nm_inv_types.nit_inv_type%TYPE;
--
BEGIN
--
   BEGIN
      Execute Immediate 'SELECT hfa_id FROM hig_flex_attributes WHERE Upper(hfa_table_name) = :1 AND hfa_attribute1 = :2 '||
                        ' AND Nvl(hfa_attribute2,''$'') = Nvl(:3,''$'') AND  Nvl(hfa_attribute3,''$'') = Nvl(:4,''$'') '|| 
                        ' AND Nvl(hfa_attribute4,''$'') = Nvl(:5,''$'') AND Nvl(hfa_attribute5,''$'') = Nvl(:6,''$'') '
                        INTO l_hfa_id Using pi_table_name,pi_attrib_name1,pi_attrib_name2,pi_attrib_name3,pi_attrib_name4,pi_attrib_name5  ;     
   EXCEPTION
       WHEN no_data_found
       THEN
           Null; 
   END ;
dbms_output.put_line('l_hfa_id '||l_hfa_id);
   IF l_hfa_id IS NOT NULL
   THEN
       BEGIN
          Execute Immediate 'SELECT hfam_nit_inv_type FROM hig_flex_attribute_inv_mapping '||
                           ' WHERE hfam_hfa_id = :1 AND hfam_attribute_data1 = :2'|| 
                           ' AND Nvl(hfam_attribute_data2,''$'') = Nvl(:3,''$'') AND Nvl(hfam_attribute_data3,''$'') = Nvl(:4,''$'')'|| 
                           ' AND Nvl(hfam_attribute_data4,''$'') = Nvl(:5,''$'') AND Nvl(hfam_attribute_data5,''$'') = Nvl(:6,''$'') ' 
                           INTO l_inv_type Using l_hfa_id,pi_attrib_value1,pi_attrib_value2,pi_attrib_value3,pi_attrib_value4,pi_attrib_value5  ;     
       EXCEPTION
       WHEN no_data_found
       THEN
           Null; 
       END ;
       IF l_inv_type IS NOT NULL
       THEN
           Return nm3get.get_nit(l_inv_type);
       ELSE
           Return Null;           
       END IF ;
   ELSE
       Return Null; 
   END IF ;
--
END get_mapping_inv;
--
END hig_flex_attribute;
/

