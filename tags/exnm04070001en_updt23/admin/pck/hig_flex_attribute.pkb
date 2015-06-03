CREATE OR REPLACE PACKAGE BODY hig_flex_attribute
AS
----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/pck/hig_flex_attribute.pkb-arc   3.7   Jun 03 2015 10:06:06   Upendra.Hukeri  $
--       Module Name      : $Workfile:   hig_flex_attribute.pkb  $
--       Date into PVCS   : $Date:   Jun 03 2015 10:06:06  $
--       Date fetched Out : $Modtime:   Jun 03 2015 09:44:10  $
--       Version          : $Revision:   3.7  $
--       Based on SCCS version : 
----------------------------------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
----------------------------------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   3.7  $';

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
                         ,pi_attrib_name2   IN nm_inv_type_attribs.ita_attrib_name%TYPE Default Null
                         ,pi_attrib_value2  IN Varchar2                                 Default Null
                         ,pi_attrib_name3   IN nm_inv_type_attribs.ita_attrib_name%TYPE Default Null
                         ,pi_attrib_value3  IN Varchar2                                 Default Null
                         ,pi_attrib_name4   IN nm_inv_type_attribs.ita_attrib_name%TYPE Default Null
                         ,pi_attrib_value4  IN Varchar2                                 Default Null
                         ,pi_attrib_name5   IN nm_inv_type_attribs.ita_attrib_name%TYPE Default Null
                         ,pi_attrib_value5  IN Varchar2                                 Default Null) 
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
----------------------------------------------------------------------------------------------------
PROCEDURE upd_attrib_data (pi_inv_type	IN nm_inv_types_all.nit_inv_type%TYPE
                          ,pi_pk_col	IN VARCHAR2
                          )
IS
	--
	l_nit_rec nm_inv_types%ROWTYPE;
	l_error   VARCHAR2(32767);
	--
BEGIN
	--
	l_nit_rec := nm3get.get_nit(pi_inv_type);
	--
	nm3clob.execute_immediate_clob(' UPDATE ' || l_nit_rec.nit_table_name || CHR(10) ||
                                   ' SET    ' || g_upd_col || CHR(10) ||
                                   ' WHERE  ' || l_nit_rec.nit_foreign_pk_column || ' = ' || nm3flx.string(pi_pk_col)
								  );
	--
	COMMIT;
	--
EXCEPTION
	WHEN OTHERS THEN
	--
		RAISE_APPLICATION_ERROR(-20000, 'Error while updating ' || l_nit_rec.nit_table_name || ': ' || SQLERRM);
	--
END upd_attrib_data;
----------------------------------------------------------------------------------------------------
FUNCTION get_attrib_value (pi_inv_type      IN nm_inv_types_all.nit_inv_type%TYPE
                          ,pi_pk_col        IN Varchar2
                          ,pi_attrib_name   IN nm_inv_type_attribs.ita_attrib_name%TYPE
                          ) RETURN Varchar2
IS 
--
   l_nit_rec nm_inv_types%ROWTYPE;
   l_value   Varchar2(1000);
   l_ita_rec nm_inv_type_attribs%ROWTYPE;
--
BEGIN
--
   l_nit_rec := nm3get.get_nit(pi_inv_type);
   l_ita_rec := nm3get.get_ita(pi_ita_inv_type    => pi_inv_type
                              ,pi_ita_attrib_name => pi_attrib_name);
   IF l_ita_rec.ita_format = 'DATE'
   THEN
       EXECUTE IMMEDIATE ' SELECT  To_Char('||pi_attrib_name ||',Nvl('||nm3flx.string(l_ita_rec.ita_format_mask)||',Sys_Context(''NM3CORE'',''USER_DATE_MASK'')))'||Chr(10)||
                         ' FROM    '||l_nit_rec.nit_table_name  ||Chr(10)||
                         ' WHERE  '||l_nit_rec.nit_foreign_pk_column||' = :1 ' INTO l_value USING pi_pk_col ;
   ELSE
       EXECUTE IMMEDIATE ' SELECT  '||pi_attrib_name ||Chr(10)||
                         ' FROM    '||l_nit_rec.nit_table_name  ||Chr(10)||
                         ' WHERE  '||l_nit_rec.nit_foreign_pk_column||' = :1 ' INTO l_value USING pi_pk_col ;
   END IF ; 
   Return l_value ;
--
EXCEPTION
WHEN OTHERS 
THEN
    Return Null;
END get_attrib_value;
--
PROCEDURE build_upd_statement (pi_inv_type      IN nm_inv_type_attribs.ita_inv_type%TYPE
                              ,pi_attrib_name   IN nm_inv_type_attribs.ita_attrib_name%TYPE
                              ,pi_attrib_data   IN Varchar2 )
IS
--
   l_ita_rec nm_inv_type_attribs%ROWTYPE;
   l_error   Varchar2(32767);
   l_num     Number ; 
   l_date    Date;
   l_format  Varchar2(50);
--
BEGIN
--
   l_ita_rec := nm3get.get_ita(pi_ita_inv_type    => pi_inv_type
                              ,pi_ita_attrib_name => pi_attrib_name);
   IF l_ita_rec.ita_format = 'NUMBER'
   THEN
       BEGIN
       --
          l_num := To_Number(pi_attrib_data);
       --  
       EXCEPTION
       WHEN OTHERS
       THEN
           l_error := 'Invalid Number';
           Raise;
       END ;
   ELSIF l_ita_rec.ita_format = 'DATE'
   THEN
       BEGIN 
       --
          l_format := Nvl(l_ita_rec.ita_format_mask,Sys_Context('NM3CORE','USER_DATE_MASK')) ;
          l_date   := To_Date(pi_attrib_data,l_format);
       --  
       EXCEPTION
       WHEN OTHERS
       THEN
           l_error := 'Invalid Date Format';
           Raise;
       END ;
   END IF ;
   IF g_upd_col IS NOT NULL
   THEN
       IF  l_ita_rec.ita_format = 'VARCHAR2'
       AND l_ita_rec.ita_case IN ('LOWER','UPPER')
       THEN
           g_upd_col := g_upd_col||Chr(10)||','||pi_attrib_name||' = '||l_ita_rec.ita_case||'('||nm3flx.string(pi_attrib_data)||')';
       ELSE           
           g_upd_col := g_upd_col||Chr(10)||','||pi_attrib_name||' = '||nm3flx.string(pi_attrib_data);
       END IF ;
   ELSE
       IF  l_ita_rec.ita_format = 'VARCHAR2'
       AND l_ita_rec.ita_case IN ('LOWER','UPPER')
       THEN
           g_upd_col := pi_attrib_name||' = '||l_ita_rec.ita_case||'('||nm3flx.string(pi_attrib_data)||')';
       ELSE
           g_upd_col := pi_attrib_name||' = '||nm3flx.string(pi_attrib_data);
       END IF ;
   END IF ;
EXCEPTION
WHEN others
THEN
    Raise_Application_Error(-20000,l_error);
END build_upd_statement;
--
PROCEDURE clear_gob_var
IS
BEGIN
--
   g_upd_col := Null;
--
END clear_gob_var ;
--
FUNCTION get_combi (pi_tab_name IN Varchar2
                   ,pi_value    IN Varchar2)   
RETURN hig_flex_attribute_inv_mapping.hfam_id%TYPE
IS
--
   l_sql       Varchar2(32767) ;
   l_pk_column Varchar2(100) ;     
   l_num       Number ;
   l_hfa_rec   hig_flex_attributes%ROWTYPE ;
   l_hfam_id   hig_flex_attribute_inv_mapping.hfam_id%TYPE ;
--
BEGIN
--
   SELECT nit_foreign_pk_column
   INTO   l_pk_column
   FROM   nm_inv_types_all
   WHERE  nit_table_name = pi_tab_name
   AND    rownum = 1;
   SELECT *
   INTO   l_hfa_rec
   FROM   hig_flex_attributes
   WHERE  hfa_table_name = pi_tab_name ;

   l_sql := 'SELECT  hfam_id '||Chr(10)||
            'FROM   hig_flex_attribute_inv_mapping,nm_inv_types '||Chr(10)||
            '      ,'||l_hfa_rec.hfa_table_name||' b'||Chr(10)||                
            'WHERE  '||l_pk_column||' = '||nm3flx.string(pi_value)||Chr(10)||
            'AND    hfam_nit_inv_type = nit_inv_type'||Chr(10)||
            'AND    hfam_hfa_id  = '||l_hfa_rec.hfa_id||Chr(10);  
   IF l_hfa_rec.hfa_attribute1 IS NOT NULL
   THEN
       l_sql := l_sql ||'AND hfam_attribute_data1 = b.'||l_hfa_rec.hfa_attribute1||Chr(10);
   END IF ;        
   IF l_hfa_rec.hfa_attribute2 IS NOT NULL
   THEN
       l_sql := l_sql ||'AND hfam_attribute_data2 = b.'||l_hfa_rec.hfa_attribute2||Chr(10);
   END IF ;
   IF l_hfa_rec.hfa_attribute3 IS NOT NULL
   THEN
       l_sql := l_sql ||'AND hfam_attribute_data3 = b.'||l_hfa_rec.hfa_attribute3||Chr(10);
   END IF ;                
   IF l_hfa_rec.hfa_attribute4 IS NOT NULL
   THEN
       l_sql := l_sql ||'AND hfam_attribute_data3 = b.'||l_hfa_rec.hfa_attribute4||Chr(10);
   END IF ;
   IF l_hfa_rec.hfa_attribute5 IS NOT NULL
   THEN
       l_sql := l_sql ||'AND hfam_attribute_data3 = b.'||l_hfa_rec.hfa_attribute5||Chr(10);
   END IF ;
   Execute Immediate l_sql INTO l_hfam_id ;
   RETURN l_hfam_id;
EXCEPTION
WHEN No_Data_Found
THEN
    RETURN Null ; 
END get_combi;
--
FUNCTION validate_combi(pi_hfam_hfa_id          IN hig_flex_attribute_inv_mapping.hfam_hfa_id%TYPE 
                       ,pi_hfam_attribute_data1 IN hig_flex_attribute_inv_mapping.hfam_attribute_data1%TYPE
                       ,pi_hfam_attribute_data2 IN hig_flex_attribute_inv_mapping.hfam_attribute_data2%TYPE
                       ,pi_hfam_attribute_data3 IN hig_flex_attribute_inv_mapping.hfam_attribute_data3%TYPE
                       ,pi_hfam_attribute_data4 IN hig_flex_attribute_inv_mapping.hfam_attribute_data4%TYPE
                       ,pi_hfam_attribute_data5 IN hig_flex_attribute_inv_mapping.hfam_attribute_data5%TYPE
)   
RETURN Boolean
IS
--
   CURSOR c_combi_exists
   IS
   SELECT 'x'
   FROM   hig_flex_attribute_inv_mapping
   WHERE  hfam_hfa_id          = pi_hfam_hfa_id
   AND    hfam_attribute_data1 = pi_hfam_attribute_data1
   AND    NVL(hfam_attribute_data2,'$') = NVL(pi_hfam_attribute_data2,'$')
   AND    NVL(hfam_attribute_data3,'$') = NVL(pi_hfam_attribute_data3,'$')
   AND    NVL(hfam_attribute_data4,'$') = NVL(pi_hfam_attribute_data4,'$')
   AND    NVL(hfam_attribute_data5,'$') = NVL(pi_hfam_attribute_data5,'$') ;
   l_value Varchar2(1);
--
BEGIN
--
   OPEN  c_combi_exists ;
   FETCH c_combi_exists INTO l_value ;
   CLOSE c_combi_exists;
   Return  Nvl(l_value,'$') = 'x' ;
--
END validate_combi;
--
PROCEDURE get_label(pi_hfa_id      IN  NUMBER
                   ,pi_hfam_id     IN  NUMBER
                   ,pi_block_label OUT Varchar2
                   ,pi_pk_label    OUT Varchar2
                   ,pi_label1      OUT Varchar2
                   ,pi_label2      OUT Varchar2
                   ,pi_label3      OUT Varchar2
                   ,pi_value1      OUT Varchar2
                   ,pi_value2      OUT Varchar2
                   ,pi_value3      OUT Varchar2
)   
IS
--
   CURSOR c_get_hfa
   IS
   SELECT *
   FROM   hig_flex_attributes
   WHERE  hfa_id = pi_hfa_id ;

   l_hfa_rec hig_flex_attributes%ROWTYPE;

   CURSOR c_get_hfam
   IS
   SELECT *
   FROM   hig_flex_attribute_inv_mapping
   WHERE  hfam_id = pi_hfam_id ;

   l_hfam_rec hig_flex_attribute_inv_mapping%ROWTYPE;
--
BEGIN
--
   OPEN  c_get_hfa;
   FETCH c_get_hfa INTO l_hfa_rec;
   CLOSE c_get_hfa;

   OPEN  c_get_hfam;
   FETCH c_get_hfam INTO l_hfam_rec;
   CLOSE c_get_hfam;
   
   IF l_hfa_rec.hfa_table_name = 'WORK_ORDERS'
   THEN
       pi_block_label := 'Works Order Details';
       pi_pk_label    := 'Works Order No';    
   ELSIF l_hfa_rec.hfa_table_name = 'DOCS'
   THEN
       pi_block_label := 'Enquiry Details';
       pi_pk_label    := 'Enquiry ID';
   END IF ;
   IF l_hfa_rec.hfa_attribute1 = 'WOR_SCHEME_TYPE'
   THEN
       pi_label1 := 'Scheme Type';
       BEGIN
       --
          SELECT hco_meaning 
          INTO   pi_value1
          FROM   hig_codes
          Where  hco_domain = 'SCHEME_TYPES'
          AND    hco_code = l_hfam_rec.hfam_attribute_data1 ;
       --
       EXCEPTION
       WHEN OTHERS THEN 
           Null;
       END ;
   END IF ;
   IF l_hfa_rec.hfa_attribute2 = 'WOR_FLAG'
   THEN
       pi_label2 := 'Work Order Type';
       BEGIN
       --
          SELECT hco_meaning 
          INTO   pi_value2
          FROM   hig_codes
          Where  hco_domain = 'WOR_FLAG'
          AND    hco_code   = l_hfam_rec.hfam_attribute_data2 ;
       --
       EXCEPTION
       WHEN OTHERS THEN 
           Null;
       END ;
   END IF ;
--
END get_label;
--
FUNCTION get_inv_type (pi_tab_name    IN Varchar2
                      ,pi_column_name IN Varchar2
                      ,pi_screen_text IN Varchar2)   
RETURN    hig_flex_attribute_inv_mapping.hfam_nit_inv_type%TYPE
IS
--
   l_inv_type nm_inv_types.nit_inv_type%TYPE;
--
BEGIN
--
   SELECT ita_inv_type 
   INTO   l_inv_type
   FROM   hig_flex_attributes
         ,hig_flex_attribute_inv_mapping
         ,nm_inv_type_attribs
   WHERE  hfa_table_name    = pi_tab_name
   AND    hfa_id            = hfam_hfa_id
   AND    hfam_nit_inv_type = ita_inv_type
   AND    ita_attrib_name   = pi_column_name
   AND    Rtrim(ita_scrn_text) = Rtrim(Replace(pi_screen_text,'- Flexible',' '))
   AND    rownum = 1;

   Return l_inv_type;
EXCEPTION
   WHEN OTHERS THEN
   Return Null ;   
--
END get_inv_type;
--
END hig_flex_attribute;
/

