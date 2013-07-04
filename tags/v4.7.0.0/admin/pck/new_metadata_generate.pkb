CREATE OR REPLACE PACKAGE BODY new_metadata_generate IS
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/nm3/admin/pck/new_metadata_generate.pkb-arc   3.3   Jul 04 2013 15:07:20   James.Wadsworth  $
--       Module Name      : $Workfile:   new_metadata_generate.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:07:20  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:08  $
--       PVCS Version     : $Revision:   3.3  $
--       Based on SCCS version : 
--
--   Author : Graeme Johnson
--
--   Package to generate the metadata creation scripts
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT  varchar2(100) :='"$Revision:   3.3  $"';

--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'new_metadata_generate';
--
--- Package Global Variable Declarations -----------------------------------
--
   TYPE tab_varchar2 IS TABLE OF varchar2(4000)                  INDEX BY binary_integer;
   TYPE tab_varchar32767  IS TABLE OF varchar2(32767)            INDEX BY binary_integer;
   --
   --
   c_default_location   CONSTANT varchar2(100)  := get_mdo('DFLTDIR').mdo_option_value;
   c_default_linesize   CONSTANT binary_integer := 32767;
--
   c_read_mode        CONSTANT  varchar2(1)    := 'R';
   c_append_mode      CONSTANT  varchar2(1)    := 'A';
   c_write_mode       CONSTANT  varchar2(1)    := 'W';
   
   c_comment          CONSTANT  varchar2(5)    := '--   ';
   --
   c_nbsp CONSTANT varchar2(6) := CHR(38)||'nbsp;';
   
   
   g_tab_file_content  tab_varchar32767;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_file_content(pi_text  IN VARCHAR2) IS
 v_subscript PLS_INTEGER := g_tab_file_content.COUNT+1;
BEGIN
  g_tab_file_content(v_subscript) := pi_text;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION string (p_text IN varchar2) RETURN varchar2;
--
-----------------------------------------------------------------------------
--
PROCEDURE blank;
--
-----------------------------------------------------------------------------
--
PROCEDURE dummy_line;
--
-----------------------------------------------------------------------------
--
FUNCTION format (pi_column_name  IN varchar2
                ,pi_data_type    IN varchar2
                ) RETURN varchar2;
--
-----------------------------------------------------------------------------
--
PROCEDURE html_stylesheet;
--
-----------------------------------------------------------------------------
--
FUNCTION get_mdo (pi_mdo_option_id metadata_options.MDO_OPTION_ID%TYPE) RETURN metadata_options%ROWTYPE IS

  CURSOR c1 IS
  SELECT *
  FROM   metadata_options
  WHERE  mdo_option_id = pi_mdo_option_id;
  
  l_retval metadata_options%ROWTYPE; 

BEGIN

  OPEN c1;
  FETCH c1 INTO l_retval;
  CLOSE c1;
  
  RETURN(l_retval);
  
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_individual_script (pi_mds_script_output_file  IN metadata_scripts.mds_script_output_file%TYPE
                                    ,pi_location                IN VARCHAR2
									,pi_script_header           IN VARCHAR2
                                     );
--
-----------------------------------------------------------------------------
--
PROCEDURE process_metadata_script_table (pi_target_name  IN metadata_scripts.MDS_SCRIPT_OUTPUT_FILE%TYPE
                                        ,pi_target_owner IN metadata_scripts.MDS_SCHEMA_OWNER%TYPE
                                        ,pi_target_mode  IN metadata_scripts.MDS_ACTION%TYPE
                                        ,pi_table_name   IN metadata_script_tables.MDST_TABLE_NAME%TYPE
                           );
--
-----------------------------------------------------------------------------
--
FUNCTION fn_datatype(p_data_type      IN user_tab_columns.data_type%TYPE
                    ,p_data_length    IN user_tab_columns.data_length%TYPE
                    ,p_data_precision IN user_tab_columns.data_precision%TYPE
                    ,p_data_scale     IN user_tab_columns.data_scale%TYPE
                    ) RETURN varchar2;
--
-----------------------------------------------------------------------------
--
PROCEDURE internal_write_file (location     IN     varchar2
                              ,filename     IN     varchar2
                              ,max_linesize IN     binary_integer DEFAULT c_default_linesize
                              ,write_mode   IN     varchar2
                              ,all_lines    IN     tab_varchar32767
                              );
--
-----------------------------------------------------------------------------
--
FUNCTION is_open(FILE IN utl_file.file_type) RETURN boolean;
--
-----------------------------------------------------------------------------
--
PROCEDURE fclose(FILE IN OUT utl_file.file_type);
--
-----------------------------------------------------------------------------
--
PROCEDURE fclose_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_line(FILE      IN     utl_file.file_type
                  ,buffer       OUT varchar2
                  ,eof_found    OUT boolean
                  ,add_cr    IN boolean DEFAULT FALSE
                  );
--
-----------------------------------------------------------------------------
--
PROCEDURE put_line(FILE   IN utl_file.file_type
                  ,buffer IN varchar2
                  );
--
-----------------------------------------------------------------------------
--
PROCEDURE put     (FILE   IN utl_file.file_type
                  ,buffer IN varchar2
                  );
--
-----------------------------------------------------------------------------
--
PROCEDURE write_file (location     IN     varchar2       DEFAULT c_default_location
                     ,filename     IN     varchar2
                     ,max_linesize IN     binary_integer DEFAULT c_default_linesize
                     ,all_lines    IN     tab_varchar32767
                     );
--
-----------------------------------------------------------------------------
--
PROCEDURE append_file (location     IN     varchar2       DEFAULT c_default_location
                      ,filename     IN     varchar2
                      ,max_linesize IN     binary_integer DEFAULT c_default_linesize
                      ,all_lines    IN     tab_varchar32767
                      );
--
-----------------------------------------------------------------------------
--
PROCEDURE generate_resv_repl_scripts(filelist       IN owa_util.vc_arr
                                    ,file_location IN varchar2
                                    ,script_header  IN VARCHAR2) IS


BEGIN

  g_tab_file_content.DELETE;

  ------------
  -- RESV file
  ------------
  FOR i IN 1..filelist.COUNT LOOP

   append_file_content('resv '||filelist(i));
   append_file_content('chmod 777 '||filelist(i));     
  
  END LOOP;
  
  --
  --write file
  --
  write_file (location     => file_location
             ,filename     => get_mdo('RESVFILE').mdo_option_value
             ,max_linesize => 32767
             ,all_lines    => g_tab_file_content
              );   
  

  g_tab_file_content.DELETE;
  ------------
  -- REPL file
  ------------
  FOR i IN 1..filelist.COUNT LOOP

   append_file_content('dos2unix '||filelist(i)||' '||filelist(i));
   append_file_content('repl -y "Generated - '||script_header||'" '||filelist(i));
   append_file_content('fetch '||filelist(i));
   append_file_content('chmod 777 '||filelist(i));
       
  
  END LOOP;
  
  --
  --write file
  --
  write_file (location     => file_location
             ,filename     => get_mdo('REPLFILE').mdo_option_value
             ,max_linesize => 32767
             ,all_lines    => g_tab_file_content
              );   


END;


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
FUNCTION get_mds_details (pi_mds_script_output_file IN metadata_scripts.mds_script_output_file%TYPE) RETURN metadata_scripts%ROWTYPE IS

   CURSOR c1 IS
   SELECT *
   FROM   metadata_scripts mds
   WHERE  mds.MDS_SCRIPT_OUTPUT_FILE = pi_mds_script_output_file;
   
   l_retval metadata_scripts%ROWTYPE;
   
BEGIN

  OPEN c1;
  FETCH c1 INTO l_retval;
  RETURN(l_retval); 

END get_mds_details;    


PROCEDURE generate (filelist     IN owa_util.vc_arr
                   ,file_location IN varchar2
                   ,script_header IN varchar2) IS
--
   l_current_debug_status boolean := nm_debug.is_debug_on;

   l_mds_row metadata_scripts%ROWTYPE;
   l_sqlerrm nm3type.tab_varchar4000;
   l_unc     VARCHAR2(500);

  CURSOR get_unc_path IS
    SELECT mdo_option_value 
      FROM metadata_options
     WHERE mdo_option_id = 'UNCPATH';
--
BEGIN
--
  OPEN get_unc_path; 
  FETCH get_unc_path INTO l_unc;
  CLOSE get_unc_path;
--
--  nm_debug.debug_on;
--
--   IF NOT l_current_debug_status
--    THEN
--      nm_debug.delete_debug(TRUE);
----      nm_debug.debug_on;
--   END IF;
--

--
   nm_debug.proc_start(g_package_name,'generate');
--
   FOR l_count IN 1..filelist.COUNT
    LOOP
     -- nm_debug.debug('      processing '||filelist(l_count));
      BEGIN
        process_individual_script(filelist(l_count)
                                 ,file_location
                                 ,script_header);
        l_sqlerrm(l_count) := 'Success';
      EXCEPTION
        WHEN OTHERS
        THEN
          l_sqlerrm(l_count) := SQLERRM;
      END;
   END LOOP;
--

   commit;

--
/*
   generate_resv_repl_scripts(filelist       => filelist
                             ,file_location  => file_location
                             ,script_header  => script_header);
*/
--

--   IF NOT l_current_debug_status
--    THEN
--      nm_debug.debug_off;
--   END IF;

   htp.p('<HTML>');
   html_stylesheet;
   htp.p('<HEAD>');
   htp.p('<TITLE>Metadata Generation</TITLE>');
   htp.p('</HEAD>');
   htp.p('<BODY>');
   html_stylesheet;
   htp.p('  <TABLE WIDTH="50%" BORDER="1" CELLSPACING="0" CELLPADDING="5" ALIGN="TOP" BGCOLOR="#ffe1aa">');

   htp.p('<tr BGCOLOR="orange"> ');
   htp.p('   <td align="CENTER" colspan="1" CLASS="big_title">');
   htp.p('   <b> Generated Files </b>');
   htp.p('   </td>');
   htp.p('</tr>'); 

   htp.p('<tr BGCOLOR="orange"> ');
   htp.p('   <td align="CENTER" colspan="1" CLASS="big_title">');
--   htp.p('   <b> '||file_location||'</b>');
      htp.p('<a href="'||l_unc||'" TARGET="_BLANK">'||l_unc||'</a');
   htp.p('   </td>');
   htp.p('</tr>');   

-- 
   FOR l_count IN 1..filelist.COUNT
    LOOP
      htp.p('<tr> ');	
      htp.p('   <td align="LEFT" colspan="2" CLASS="table_val">');
        htp.p('<a href="'||l_unc||filelist(l_count)||'" TARGET="_BLANK">'||filelist(l_count)
            ||'</a');
        htp.p('<b> &nbsp &nbsp : &nbsp &nbsp '||l_sqlerrm(l_count)||' </b>');
      htp.p('   </td>');
      htp.p('</tr> ');
   END LOOP;

/*
      htp.p('<tr> ');	
      htp.p('   <td align="LEFT" colspan="1" CLASS="table_val">');
      htp.p(get_mdo('RESVFILE').mdo_option_value);
      htp.p('   </td>');
      htp.p('</tr> ');   
   
      htp.p('<tr> ');	
      htp.p('   <td align="LEFT" colspan="1" CLASS="table_val">');
      htp.p(get_mdo('REPLFILE').mdo_option_value);
      htp.p('   </td>');
      htp.p('</tr> ');   
  */ 
   htp.tableclose;

   htp.p('</BODY>');
   htp.p('</HTML>');

   nm_debug.proc_end(g_package_name,'generate');

--
END generate;
--
-----------------------------------------------------------------------------
--
FUNCTION string (p_text IN varchar2) RETURN varchar2 IS
BEGIN
   RETURN CHR(39)||p_text||CHR(39);
END string;
--
-----------------------------------------------------------------------------
--
PROCEDURE blank IS
BEGIN
   append_file_content('--');
END blank;
--
-----------------------------------------------------------------------------
--
PROCEDURE dummy_line IS
BEGIN
   append_file_content('');
END dummy_line;
--
-----------------------------------------------------------------------------
--
FUNCTION format (pi_column_name  IN varchar2
                ,pi_data_type    IN varchar2
                ) RETURN varchar2 IS
   l_retval      varchar2(2000);
   c_date_format varchar2(20)   := 'YYYYMMDDHH24MISS';
BEGIN
   -- nm_debug.debug('Format '||pi_column_name||'-'||pi_data_type);
   IF    pi_data_type = 'NUMBER'
    THEN
      l_retval := 'decode( '||pi_column_name||',null,''null'','|| 'to_char( '||pi_column_name||')'||')';
   ELSIF pi_data_type = 'DATE'
    THEN
      l_retval := 'decode( '||pi_column_name||',null,''null'','||'''to_date(''''''||'||'to_char( '||pi_column_name||',''YYYYMMDDHH24MISS'')'|| '||'''''',''''YYYYMMDDHH24MISS'''')'''||')';
--      l_retval := CHR(39)||'DECODE('||pi_column_name||',Null,'||CHR(39)||'||CHR(39)||'||string('Null')||CHR(39)||'||CHR(39)||'||',TO_DATE('||CHR(39)||'||to_char('||l_column||','||string(c_date_format)||')'||'||'||string(',')||'||CHR(39)||'||string(c_date_format)||'||CHR(39)'||'||'||string('))');
   ELSIF pi_data_type = 'CLOB' THEN
   
         l_retval := '''''''''||replace(dbms_lob.substr('||pi_column_name||',5000,1),'''''''','''''''''''')||''''''''';
      -- stuff for sorting out line feeds in char data
      --  replace CR (CHR(13)) with Null
      --  replace LF (CHR(10)) with CHR representation in string
      -- CRs can go to null, because a CR will only ever occur as part of a LF-CR pair, and
      --  the LF logic will sort it out
      l_retval := 'replace(replace('||l_retval||',CHR(10),'''''||CHR(39)||'||CHR(10)||'''''||CHR(39)||'),CHR(13),Null)';
   
   
   
   ELSE
      -- stuff for sorting out ' in char data
      l_retval := '''''''''||replace('||pi_column_name||','''''''','''''''''''')||''''''''';
      -- stuff for sorting out line feeds in char data
      --  replace CR (CHR(13)) with Null
      --  replace LF (CHR(10)) with CHR representation in string
      -- CRs can go to null, because a CR will only ever occur as part of a LF-CR pair, and
      --  the LF logic will sort it out
      l_retval := 'replace(replace('||l_retval||',CHR(10),'''''||CHR(39)||'||CHR(10)||'''''||CHR(39)||'),CHR(13),Null)';
   END IF;
   RETURN l_retval;
END format;
--
-----------------------------------------------------------------------------
--
FUNCTION get_script_tables(pi_mds_script_output_file  IN metadata_scripts.mds_script_output_file%TYPE) RETURN tab_varchar2 IS

 CURSOR c1 IS
 SELECT mdst.mdst_table_name
 FROM   metadata_script_tables mdst
 WHERE  mdst.mdst_mds_script_output_file = pi_mds_script_output_file
 ORDER BY mdst.mdst_table_sequence;

 l_tab_rec_tables      tab_varchar2;

BEGIN

 OPEN c1;
 FETCH c1 BULK COLLECT INTO   l_tab_rec_tables;
 CLOSE c1;
 
 RETURN(l_tab_rec_tables);

END get_script_tables;
--
--------------------------------------------------------------------------------------
--
PROCEDURE process_individual_script (pi_mds_script_output_file  IN metadata_scripts.mds_script_output_file%TYPE
                                    ,pi_location                IN VARCHAR2
									,pi_script_header           IN VARCHAR2
                                     ) IS
--
   l_tab_rec_tables      tab_varchar2;
   l_tab_rec_custom_sql  tab_varchar2;
   l_mds_row             metadata_scripts%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'process_individual_script');
   --nm_debug.debug('start process_individual_script');
--
--   nm_debug.debug ('pi_mds_script_output_file  : '||pi_mds_script_output_file,1);
--
--nm_debug.debug ('pi_mds_script_output_file  : '||pi_mds_script_output_file);

   g_tab_file_content.delete;
   --
   -- For this metadata script get the script details e.g. schema owner, mode etc etc
   --
   l_mds_row := get_mds_details(pi_mds_script_output_file);


  --
  -- Get all of the tables for this script
  --
  l_tab_rec_tables := get_script_tables(pi_mds_script_output_file);
   
--
--   nm_debug.debug('-- Output the rows from the parfile for this target',4);

   -- nm_debug.debug('Before SCCSID write');
   append_file_content('/***************************************************************************');
   dummy_line;   
   append_file_content('INFO');
   append_file_content('====');   
   append_file_content(pi_script_header);   

   dummy_line;
   append_file_content('GENERATION DATE');
   append_file_content('===============');   
   append_file_content(TO_CHAR(sysdate,'DD-MON-YYYY HH24:MI'));

   dummy_line;
   append_file_content('TABLES PROCESSED');
   append_file_content('================');         
   FOR l_count IN 1..l_tab_rec_tables.COUNT
    LOOP
	append_file_content(l_tab_rec_tables(l_count));
   END LOOP;
   
   dummy_line;
   append_file_content('TABLE OWNER');
   append_file_content('===========');
   append_file_content(l_mds_row.mds_schema_owner);

   dummy_line;
   append_file_content('MODE (A-Append R-Refresh)');
   append_file_content('========================');
   append_file_content(l_mds_row.mds_action);
   dummy_line;       
   append_file_content('***************************************************************************/');
   dummy_line;
           
   append_file_content('define sccsid = '||string(CHR(37)||'W'||CHR(37)||' '||CHR(37)||'G'||CHR(37)));
   append_file_content('set define off;');
   append_file_content('set feedback off;');

   IF l_mds_row.mds_custom_sql IS NOT NULL THEN  
     dummy_line;
     append_file_content('--------------------');
     append_file_content('-- PRE-PROCESSING --');
     append_file_content('--------------------');	 
     append_file_content(l_mds_row.mds_custom_sql);   
     dummy_line;
   END IF;	 
   
   dummy_line;
   
   append_file_content('---------------------------------');
   append_file_content('-- START OF GENERATED METADATA --');
   append_file_content('---------------------------------');   
   dummy_line;   
         
   FOR l_count IN 1..l_tab_rec_tables.COUNT
    LOOP
--      nm_debug.debug ('Table Name   - '||l_tab_rec_tables(l_count),4);
      
      process_metadata_script_table (pi_target_name  => pi_mds_script_output_file
                                    --,pi_target_owner => user --l_mds_row.mds_schema_owner
                                    ,pi_target_owner => l_mds_row.mds_schema_owner
                                    ,pi_target_mode  => l_mds_row.mds_action
                                    ,pi_table_name   => l_tab_rec_tables(l_count)
                                    );
   END LOOP;
--
   blank;
   append_file_content('COMMIT;');
   blank;
   append_file_content('set feedback on');
   append_file_content('set define on');
   blank;
   append_file_content('-------------------------------');	    
   append_file_content('-- END OF GENERATED METADATA --');
   append_file_content('-------------------------------');   
   blank;

--
--write file 
--
   write_file (location     => pi_location
              ,filename     => pi_mds_script_output_file
              ,max_linesize => 32767
              ,all_lines    => g_tab_file_content
              );   
   
--
--   nm_debug.debug('end process_individual_script');
   nm_debug.proc_end(g_package_name,'process_individual_script');
END process_individual_script;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_metadata_script_table (pi_target_name  IN metadata_scripts.MDS_SCRIPT_OUTPUT_FILE%TYPE
                                        ,pi_target_owner IN metadata_scripts.MDS_SCHEMA_OWNER%TYPE
                                        ,pi_target_mode  IN metadata_scripts.MDS_ACTION%TYPE
                                        ,pi_table_name   IN metadata_script_tables.MDST_TABLE_NAME%TYPE
                           ) IS
--
   TYPE rec_col IS RECORD
     (column_name     all_tab_columns.column_name%TYPE
     ,data_type       all_tab_columns.data_type%TYPE
     ,data_size       varchar2(10)
     ,not_null        varchar2(8)
     );
   TYPE rec_pk IS RECORD
     (column_name     all_tab_columns.column_name%TYPE
     ,data_type       all_tab_columns.data_type%TYPE
     );
--
   TYPE tab_rec_col IS TABLE OF rec_col INDEX BY binary_integer;
   TYPE tab_rec_pk  IS TABLE OF rec_pk  INDEX BY binary_integer;
--
   l_tab_rec_col tab_rec_col;
   l_tab_rec_pk  tab_rec_pk;
--
   l_tab_insert_statement tab_varchar2;
--
   l_start_of_insert_line varchar2(8) := LPAD('(',8,' ');
--
   l_sql_string        long;
   l_sql_string_output long;
--
   TYPE ref_cur IS REF CURSOR;
   cs_dyn_sql ref_cur;
--
   l_rowid varchar2(18);
--
BEGIN
--
--nm_debug.debug_on;
   nm_debug.proc_start(g_package_name,'process_metadata_script_table');
--
--nm_debug.debug('pi_table_name='||pi_table_name);
--nm_debug.debug('pi_target_owner='||pi_target_owner);
--nm_debug.debug('1');

   blank;
   append_file_content('--********** '||pi_table_name||' **********--');
   
   append_file_content('SET TERM ON');   
   append_file_content('PROMPT '||lower(pi_table_name));   
   append_file_content('SET TERM OFF');   
   blank;
--nm_debug.debug('2');   
--
   l_tab_insert_statement.DELETE;
--
   l_tab_insert_statement(l_tab_insert_statement.COUNT+1) := 'INSERT INTO '||pi_table_name;
--
nm_debug.debug('3 '||pi_target_owner||' '||pi_table_name);
   append_file_content('-- Columns');
   -- nm_debug.debug('   FOR cs_rec IN (SELECT atc.column_id');
   FOR cs_rec IN (SELECT atc.column_id
                        ,atc.column_name
                        ,atc.data_type
                        ,atc.data_length
                        ,atc.data_precision
                        ,atc.data_scale
                        ,DECODE(atc.nullable
                               ,'N','NOT NULL'
                               ,RPAD(' ',8)
                               ) not_null
                   FROM  all_tab_columns  atc
                  WHERE  atc.owner       = pi_target_owner
                   AND   atc.table_name  = pi_table_name
                  ORDER BY atc.column_id
                 )
    LOOP
      l_tab_insert_statement(l_tab_insert_statement.COUNT+1) := l_start_of_insert_line||cs_rec.column_name;
      l_start_of_insert_line := LPAD(',',8,' ');
      DECLARE
         l_output_line varchar2(4000);
      BEGIN
         l_tab_rec_col(cs_rec.column_id).column_name := cs_rec.column_name;
         l_tab_rec_col(cs_rec.column_id).data_type   := cs_rec.data_type;
         l_tab_rec_col(cs_rec.column_id).data_size   := fn_datatype(cs_rec.data_type
                                                                   ,cs_rec.data_length
                                                                   ,cs_rec.data_precision
                                                                   ,cs_rec.data_scale
                                                                   );
         l_tab_rec_col(cs_rec.column_id).not_null    := cs_rec.not_null;
   --
         -- Output this data for a comment
         l_output_line := '-- '||RPAD(cs_rec.column_name,31)||cs_rec.not_null||' '||cs_rec.data_type||l_tab_rec_col(cs_rec.column_id).data_size;
         append_file_content(l_output_line);
         --
         FOR cs_inner_rec IN (SELECT acc.constraint_name
                                    ,acc.position
                                    ,ac.constraint_type
                               FROM  all_cons_columns acc
                                    ,all_constraints  ac
                              WHERE  ac.owner      = pi_target_owner
                               AND   ac.table_name = pi_table_name
                               AND   ac.generated  = 'USER NAME'
                               AND   ac.owner      = acc.owner
                               AND   ac.constraint_name = acc.constraint_name
                               AND   ac.table_name      = acc.table_name
                               AND   acc.column_name    = cs_rec.column_name
                             )
          LOOP
            l_output_line := '--   '||cs_inner_rec.constraint_name;
            IF cs_inner_rec.position IS NOT NULL
             THEN
               l_output_line := l_output_line||' (Pos '||cs_inner_rec.position||')';
               IF cs_inner_rec.constraint_type = 'P'
                THEN
                  l_tab_rec_pk(cs_inner_rec.position).column_name     := cs_rec.column_name;
                  l_tab_rec_pk(cs_inner_rec.position).data_type       := cs_rec.data_type;
               END IF;
            END IF;
            append_file_content(l_output_line);
--
         END LOOP;
         --
      END;
--
   END LOOP;
   l_tab_insert_statement(l_tab_insert_statement.COUNT+1) := LPAD(')',8,' ');
   
 
--nm_debug.debug('4 ');   
--
   blank;
--   append_file_content('-- Constraints');
   -- nm_debug.debug('   FOR cs_rec IN (SELECT a.constraint_name');

   
/*   
   
   
   FOR cs_rec IN (SELECT a.constraint_name
                        ,DECODE(a.constraint_type
                               ,'C','Check'
                               ,'P','Primary Key'
                               ,'R','Referential Integrity'
                               ,'U','Unique Key'
                               ,a.constraint_type
                               ) constraint_type
                        ,REPLACE(a.search_condition,chr(10),Null) search_condition
                        ,a.r_constraint_name
                        ,a.delete_rule
                        ,b.table_name
                  FROM   all_constraints a
                        ,all_constraints b
                 WHERE   a.owner             = pi_target_owner
                  AND    a.table_name        = pi_table_name
                  AND    a.generated         = 'USER NAME'
                  AND    a.r_owner           = b.owner (+)
                  AND    a.r_constraint_name = b.constraint_name (+)
                )
    LOOP
--
--nm_debug.debug('5');
     append_file_content('-- '||cs_rec.constraint_name||' - '||cs_rec.constraint_type);
--
     IF    cs_rec.constraint_type = 'Check'
      THEN
        append_file_content('--  '||cs_rec.search_condition);
     ELSIF cs_rec.constraint_type = 'Referential Integrity'
      THEN
        append_file_content('--  References '||cs_rec.r_constraint_name||' on '||cs_rec.table_name||' (Delete Rule:'||cs_rec.delete_rule||')');
     ELSIF cs_rec.constraint_type = 'Primary Key'
      THEN
        NULL;
     END IF;
--
   END LOOP;
   
*/   
--
--nm_debug.debug('6');
   blank;
--
   l_sql_string := 'SELECT ROWIDTOCHAR(ROWID) FROM '||pi_target_owner||'.'||pi_table_name;
--
   OPEN  cs_dyn_sql FOR l_sql_string;
--
--nm_debug.debug('7');
   LOOP
--
      FETCH cs_dyn_sql INTO l_rowid;
      EXIT WHEN cs_dyn_sql%NOTFOUND;
   --
      IF pi_target_mode = 'R'
       THEN
         DECLARE
            l_line_start varchar2(7) := ' WHERE ';
         BEGIN
            l_sql_string :=            'SELECT '||string('DELETE FROM '||pi_table_name);
            FOR l_count IN 1..l_tab_rec_pk.COUNT
             LOOP
               l_sql_string := l_sql_string||'||CHR(10)||'||string(l_line_start
                                                                  ||l_tab_rec_pk(l_count).column_name
                                                                  ||' = '
                                                                  )
                                                 ||'||'
                                                 ||format(l_tab_rec_pk(l_count).column_name,l_tab_rec_pk(l_count).data_type);
               l_line_start := '  AND  ';
            END LOOP;
            l_sql_string := l_sql_string||'||'||string(';')||CHR(10)||' FROM '||pi_target_owner||'.'||pi_table_name||' WHERE ROWID = CHARTOROWID('||string(l_rowid)||')';
         END;
         NM_DEBUG.DEBUG('l_sql_string #1 '||l_sql_string);
         EXECUTE IMMEDIATE l_sql_string INTO l_sql_string_output;
         append_file_content(l_sql_string_output);
         blank;
      END IF;
--
  -- nm_debug.debug('      -- Output the INSERT statement');
      -- Output the INSERT statement
--
--      nm_debug.debug('   FOR l_count IN 1..l_tab_insert_statement.COUNT',4);
      FOR l_count IN 1..l_tab_insert_statement.COUNT
       LOOP
         append_file_content(l_tab_insert_statement(l_count));
      END LOOP;
--
  -- nm_debug.debug('      DECLARE');
      DECLARE
         l_line_start varchar2(8) := RPAD(' ',8);
      BEGIN
         l_sql_string := 'SELECT '||string('SELECT ');
--
         FOR l_count IN 1..l_tab_rec_col.COUNT
          LOOP
            l_sql_string := l_sql_string||'||CHR(10)||'||string(l_line_start)||'||'||format(l_tab_rec_col(l_count).column_name,l_tab_rec_col(l_count).data_type);
            l_line_start := RPAD(' ',7)||',';
         END LOOP;
         l_sql_string := l_sql_string||'||'||string(' FROM DUAL');
      END;
--
      IF pi_target_mode = 'A'
       THEN
         DECLARE
            l_line_start varchar2(30) := '                   WHERE ';
         BEGIN
            l_sql_string := l_sql_string||CHR(10)||'||CHR(10)||'||string(' WHERE NOT EXISTS (SELECT 1 FROM '||pi_table_name);
            FOR l_count IN 1..l_tab_rec_pk.COUNT
             LOOP
               l_sql_string := l_sql_string||'||CHR(10)||'||string(l_line_start
                                                                  ||l_tab_rec_pk(l_count).column_name
                                                                  ||' = '
                                                                  )
                                                 ||'||'
                                                 ||format(l_tab_rec_pk(l_count).column_name,l_tab_rec_pk(l_count).data_type);
               l_line_start := '                    AND  ';
            END LOOP;
            l_sql_string := l_sql_string||'||'||string(')');
         END;
      END IF;

      l_sql_string := l_sql_string||'||'||string(';')||CHR(10)||' FROM '||pi_target_owner||'.'||pi_table_name||' WHERE ROWID = CHARTOROWID('||string(l_rowid)||')';
--
--   nm_debug.debug(l_sql_string);
         NM_DEBUG.DEBUG('l_sql_string #2 '||l_sql_string);

      EXECUTE IMMEDIATE l_sql_string INTO l_sql_string_output;
--
      append_file_content(l_sql_string_output);
--
      blank;
--
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'pc_process_table');
--
END process_metadata_script_table;
--
-----------------------------------------------------------------------------
--
FUNCTION fn_datatype(p_data_type      IN user_tab_columns.data_type%TYPE
                    ,p_data_length    IN user_tab_columns.data_length%TYPE
                    ,p_data_precision IN user_tab_columns.data_precision%TYPE
                    ,p_data_scale     IN user_tab_columns.data_scale%TYPE
                    ) RETURN varchar2 IS
--
   l_datatype varchar2(40);
--
BEGIN
--
   IF p_data_length IS NOT NULL
    THEN
      IF (p_data_type IN ('CHAR'
                         ,'VARCHAR2'
                         ,'NUMBER'
                         )
         )
       THEN
         l_datatype := '(';
         IF p_data_precision IS NOT NULL
          THEN
            l_datatype := l_datatype||p_data_precision;
            IF NVL(p_data_scale,0) <> 0
             THEN
               l_datatype := l_datatype||','||p_data_scale;
            END IF;
         ELSE
            l_datatype := l_datatype||p_data_length;
         END IF;
         l_datatype := l_datatype||')';
      END IF;
   END IF;
--
   RETURN l_datatype;
--
END fn_datatype;
--
-----------------------------------------------------------------------------
--
--
-----------------------------------------------------------------------------
--
FUNCTION fopen(location     IN varchar2       DEFAULT c_default_location
              ,filename     IN varchar2
              ,open_mode    IN varchar2
              ,max_linesize IN binary_integer DEFAULT c_default_linesize
              ) RETURN utl_file.file_type IS
--
   l_full_filename varchar2(2000) := location||'\'||filename;
--
BEGIN
--
   IF  location IS NULL
    OR filename IS NULL
    THEN
      RAISE utl_file.invalid_path;
   END IF;
--
   IF UPPER(open_mode) NOT IN (c_read_mode,c_write_mode,c_append_mode)
    THEN
      -- Trap this one before it even gets as far at the FOPEN call
      RAISE utl_file.invalid_mode;
   END IF;
--
   RETURN utl_file.fopen(location, filename, open_mode, max_linesize);
--
EXCEPTION
   WHEN utl_file.invalid_path
    THEN
      Raise_Application_Error(-20001,'file location or name was invalid');
   WHEN utl_file.invalid_mode
    THEN
      Raise_Application_Error(-20001,'the open_mode string was invalid');
   WHEN utl_file.invalid_operation
    THEN
      Raise_Application_Error(-20001,'file "'||l_full_filename||'" could not be opened as requested');
   WHEN utl_file.invalid_maxlinesize
    THEN
      Raise_Application_Error(-20001,'specified max_linesize is too large or too small');
END fopen;
--
-----------------------------------------------------------------------------
--
FUNCTION is_open(FILE IN utl_file.file_type) RETURN boolean IS
BEGIN
   RETURN utl_file.is_open(FILE);
END is_open;
--
-----------------------------------------------------------------------------
--
PROCEDURE fclose(FILE IN OUT utl_file.file_type) IS
BEGIN
--
   utl_file.fclose(FILE);
--
EXCEPTION
   WHEN utl_file.invalid_filehandle
    THEN
      Raise_Application_Error(-20001,'not a valid file handle');
   WHEN utl_file.write_error
    THEN
      Raise_Application_Error(-20001,'OS error occured during write operation');
END fclose;
--
-----------------------------------------------------------------------------
--
PROCEDURE fclose_all IS
BEGIN
--
   utl_file.fclose_all;
--
EXCEPTION
   WHEN utl_file.write_error
    THEN
      Raise_Application_Error(-20001,'OS error occured during write operation');
END fclose_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_line(FILE      IN     utl_file.file_type
                  ,buffer       OUT varchar2
                  ,eof_found    OUT boolean
                  ,add_cr    IN boolean DEFAULT FALSE
                  ) IS
BEGIN
--
   eof_found := FALSE;
   buffer    := NULL;
--
   utl_file.get_line(FILE, buffer);
--
   IF add_cr THEN
      buffer := buffer || CHR(10);
   END IF;
--
EXCEPTION
   WHEN no_data_found
    THEN
      eof_found := TRUE;
   WHEN value_error
    THEN
      Raise_Application_Error(-20001,'line to long to store in buffer');
   WHEN utl_file.invalid_filehandle
    THEN
      Raise_Application_Error(-20001,'not a valid file handle');
   WHEN utl_file.invalid_operation
    THEN
      Raise_Application_Error(-20001,'file is not open for reading');
   WHEN utl_file.read_error
    THEN
      Raise_Application_Error(-20001,'OS error occurred during read');
END get_line;
--
-----------------------------------------------------------------------------
--
PROCEDURE put_line(FILE   IN utl_file.file_type
                  ,buffer IN varchar2
                  ) IS
BEGIN
--
   utl_file.put_line(FILE, buffer);
--
EXCEPTION
   WHEN utl_file.invalid_filehandle
    THEN
      Raise_Application_Error(-20001,'not a valid file handle');
   WHEN utl_file.invalid_operation
    THEN
      Raise_Application_Error(-20001,'file is not open for reading');
   WHEN utl_file.write_error
    THEN
      Raise_Application_Error(-20001,'OS error occured during write operation');
END put_line;
--
-----------------------------------------------------------------------------
--
PROCEDURE put     (FILE   IN utl_file.file_type
                  ,buffer IN varchar2
                  ) IS
BEGIN
--
   utl_file.put(FILE, buffer);
--
EXCEPTION
   WHEN utl_file.invalid_filehandle
    THEN
      Raise_Application_Error(-20001,'not a valid file handle');
   WHEN utl_file.invalid_operation
    THEN
      Raise_Application_Error(-20001,'file is not open for reading');
   WHEN utl_file.write_error
    THEN
      Raise_Application_Error(-20001,'OS error occured during write operation');
END put;
--
-----------------------------------------------------------------------------
--
/*
PROCEDURE get_file (location     IN     varchar2       DEFAULT c_default_location
                   ,filename     IN     varchar2
                   ,max_linesize IN     binary_integer DEFAULT c_default_linesize
                   ,all_lines       OUT tab_varchar32767
                   ,add_cr    IN boolean DEFAULT FALSE
                   ) IS
--
   l_file   utl_file.file_type;
   l_eof    boolean;
   l_buffer varchar2(32767);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_file');
--
   l_file := fopen (location,filename,c_read_mode,max_linesize);
--
   get_line(l_file,l_buffer,l_eof, add_cr);
   WHILE NOT l_eof
    LOOP
      all_lines(all_lines.COUNT+1) := l_buffer;
      get_line(l_file,l_buffer,l_eof, add_cr);
   END LOOP;
--
   fclose(l_file);
--
   nm_debug.proc_end(g_package_name,'get_file');
--
END get_file;
*/
--
-----------------------------------------------------------------------------
--
PROCEDURE write_file (location     IN     varchar2       DEFAULT c_default_location
                     ,filename     IN     varchar2
                     ,max_linesize IN     binary_integer DEFAULT c_default_linesize
                     ,all_lines    IN     tab_varchar32767
                     ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'write_file');
--
   internal_write_file (location     => location
                       ,filename     => filename
                       ,max_linesize => max_linesize
                       ,write_mode   => c_write_mode
                       ,all_lines    => all_lines
                       );
--
   nm_debug.proc_end(g_package_name,'write_file');
--
END write_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_file (location     IN     varchar2       DEFAULT c_default_location
                      ,filename     IN     varchar2
                      ,max_linesize IN     binary_integer DEFAULT c_default_linesize
                      ,all_lines    IN     tab_varchar32767
                      ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'append_file');
--
   internal_write_file (location     => location
                       ,filename     => filename
                       ,max_linesize => max_linesize
                       ,write_mode   => c_append_mode
                       ,all_lines    => all_lines
                       );
--
   nm_debug.proc_end(g_package_name,'append_file');
--
END append_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE internal_write_file (location     IN     varchar2
                              ,filename     IN     varchar2
                              ,max_linesize IN     binary_integer DEFAULT c_default_linesize
                              ,write_mode   IN     varchar2
                              ,all_lines    IN     tab_varchar32767
                              ) IS
--
   l_file   utl_file.file_type;
--
   l_count  binary_integer;
--
BEGIN
--
--   nm_debug.debug(location);
--   nm_debug.debug(filename);
--   nm_debug.debug(max_linesize);
--   nm_debug.debug(write_mode);
   l_file := fopen (location,filename,write_mode,max_linesize);
--
   l_count := all_lines.first;
--
   WHILE l_count IS NOT NULL
    LOOP
      put_line(l_file,all_lines(l_count));
      l_count := all_lines.NEXT(l_count);
   END LOOP;
--
   fclose(l_file);
--
END internal_write_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE file_location IS
   CURSOR cs_last_release IS
   SELECT last_release
    FROM  met_gen_last_release;
   l_last_release met_gen_last_release.last_release%TYPE;
BEGIN
   htp.p('<HTML>');
   htp.p('<HEAD>');
   htp.p('<TITLE>Metadata Generation</TITLE>');
   htp.p('</HEAD>');
   htp.p('<BODY>');
   htp.tableopen;
   htp.tablerowopen;
   htp.formopen(curl        => g_package_name||'.build_load_parfile'
               );
   htp.p('<TH>');
   htp.p('Enter base directory (server path)');
   htp.p('</TH>');
   htp.p('<TD>');
   htp.formtext(cname       => 'p_base_dir'
               ,cvalue      => 'e:\nm3'
               );
   htp.p('</TD>');
   htp.tablerowclose;
   htp.tablerowopen;
   htp.p('<TH>');
   htp.p('Enter Release name');
   htp.p('</TH>');
   htp.p('<TD>');
   OPEN  cs_last_release;
   FETCH cs_last_release INTO l_last_release;
   CLOSE cs_last_release;
   htp.formtext(cname       => 'p_release'
               ,cvalue      => NVL(l_last_release,'nm30xx_nm30xx')
               );
   htp.p('</TD>');
   htp.tablerowclose;
   htp.tablerowopen;
   htp.p('<TH>');
   htp.p('Enter Product');
   htp.p('</TH>');
   htp.p('<TD>');
   htp.formselectopen (cname => 'p_product');
   FOR cs_rec IN (SELECT DECODE(hpr_product
                               ,'ENQ','PEM'
							   ,'NET','NM3'
                               ,'HIG','NM3'
                               ,'TM' ,'TM3'
                               ,hpr_product
                               ) hpr_product
                        ,hpr_product_name
                   FROM  hig_products
                  ORDER BY hpr_sequence
                 )
    LOOP
      htp.p ('<OPTION VALUE="'||cs_rec.hpr_product||'">'||cs_rec.hpr_product_name||'('||cs_rec.hpr_product||')</OPTION>');
   END LOOP;
   htp.formselectclose;
   htp.p('</TD>');
   htp.tablerowclose;
   htp.tablerowopen;
   htp.p('<TD COLSPAN=2 ALIGN=CENTER>');
   htp.formsubmit (cvalue=>'Produce metadata files');
   htp.p('</TD>');
   htp.tablerowclose;
   htp.tablerowopen;
   htp.p('<TD COLSPAN=2 ALIGN=CENTER>');
   htp.small('Parfile should be in "$BASE_DIR\$RELEASE\$PRODUCT\install". Output files will be produced in same directory');
   htp.p('</TD>');
   htp.tablerowclose;
   htp.tableclose;
   htp.formclose;
   htp.p('</BODY>');
   htp.p('</HTML>');
END file_location;
--
-----------------------------------------------------------------------------
--
PROCEDURE html_stylesheet IS

BEGIN
   htp.p('<style>     body {');
   htp.p('font-family: Arial, Helvetica, sans-serif;');
   htp.p('font-size: 10pt;');
   htp.p('color: 000000;');
--   htp.p('     scrollbar-face-color: #ffe1aa; scrollbar-highlight-color: #000000;'); 
--   htp.p('     scrollbar-shadow-color: #000000; scrollbar-3dlight-color:'); 
--   htp.p('     #ffe1aa; scrollbar-arrow-color: #ffea93; ');
--   htp.p('     scrollbar-track-color: ##FFFFCC; scrollbar-darkshadow-color:'); 
--   htp.p('      }');
   htp.p('      table {');
   htp.p('      font-family: Arial, Helvetica, sans-serif;');
   htp.p('      font-size: 9pt;');
   htp.p('      color: 000000;');
   htp.p('      }');
   htp.p('      td {');
   htp.p('      font-family: Arial, Helvetica, sans-serif;');
   htp.p('      font-size: 8pt;');
   htp.p('      color: 000000;');
   htp.p('      }');
   htp.p('      select {');
   htp.p('      font-family: Arial, Helvetica, sans-serif;');
   htp.p('      font-size: 8pt;');
   htp.p('      color: 000000;');
   htp.p('      }');
   htp.p('      textarea {');
   htp.p('      font-family: Arial, Helvetica, sans-serif;');
   htp.p('      font-size: 8pt;');
   htp.p('      color: 000000;');
   htp.p('      }');
   htp.p('      input {');
   htp.p('      font-family: Arial, Helvetica, sans-serif;');
   htp.p('      font-size: 8pt;');
   htp.p('      color: 000000;');
   htp.p('      }');
   htp.p('      .ticker_head {');
   htp.p('      font-family: Arial, Helvetica, sans-serif;');
   htp.p('      font-size: 12pt;');
   htp.p('      color: White;');
   htp.p('      background: Red;');
   htp.p('      text-decoration : none;');
   htp.p('      }');
   htp.p('      .ticker {');
   htp.p('      font-family: Arial, Helvetica, sans-serif;');
   htp.p('      font-size: 12pt;');
   htp.p('      color: White;');
   htp.p('      text-decoration : none;');
   htp.p('      }');
   htp.p('      .small {');
   htp.p('      font-family: Arial, Helvetica, sans-serif;');
   htp.p('      font-size: 8pt;');
   htp.p('      color: 000000;');
   htp.p('      }');
   htp.p('      .tiny {');
   htp.p('      font-family: Arial, Helvetica, sans-serif;');
   htp.p('      font-size: 7pt;');
   htp.p('      color: 000000;');
   htp.p('      }');
   htp.p('      .title {');
   htp.p('     	font-family: Arial, Helvetica, sans-serif;');
   htp.p('     	font-size: 9pt;');
   htp.p('     	color: 000000;');
   htp.p('     	font : bold;');
   htp.p('     }');
   htp.p('      .col_header {');
   htp.p('     	font-family: Arial, Helvetica, sans-serif;');
   htp.p('     	font-size: 9pt;');
   htp.p('     	color: 000000;');
   htp.p('     	font : bold;');
   htp.p('     }');
   htp.p('      .bigger {');
   htp.p('      font-family: Comic Sans MS, Arial, Helvetica, sans-serif;');
   htp.p('      font-size: 9pt;');
   htp.p('      color: 000000;');
   htp.p('      }');
   htp.p('      .bigger2 {');
   htp.p('      font-family: Comic Sans MS, Arial, Helvetica, sans-serif;');
   htp.p('      font-size: 14pt;');
   htp.p('      color: 000000;');
   htp.p('      background: #cc0000;');
   htp.p('      }');
   htp.p('      .big {');
   htp.p('      font-family: Arial, Helvetica, sans-serif;');
   htp.p('      font-size: 18pt;');
   htp.p('      color: Blue;');
   htp.p('      }');
   htp.p('      .seminar {');
   htp.p('      font-family: Arial, Helvetica, sans-serif;');
   htp.p('      font-size: 13pt;');
   htp.p('      color: 000000;');
   htp.p('      }');
   htp.p('	   .blue{');
   htp.p('	  font-family: arial, Helvetica, sans-serif;');
   htp.p('	  font-size: 10pt;');
   htp.p('      color: 000033;');
   htp.p('	  }');
   htp.p(' 	  .blue2{');
   htp.p('	  font-family: arial, Helvetica, sans-serif;');
   htp.p('	  font-size: 8pt;');
   htp.p('	  color: 003399;');
   htp.p('	  }');
   htp.p('	  .lightblue{');
   htp.p('	  font-family: arial, Helvetica, sans-serif;');
   htp.p('	  font-size: 10pt;');
   htp.p('	  color: 336699;');
   htp.p('	  }');
   htp.p('        .ButtonOrange { background-color: #FF9900; color: #FFFFFF; cursor: hand; font-family:');
   htp.p('                        verdana, arial, helvetica; font-size: 100%; font-weight: bold;');
   htp.p('                        border-left: 2px solid #FFCC00; border-right: 2px solid #CC6600;');
   htp.p('                        border-top: 2px solid #FFCC00; border-bottom: 2px solid #CC6600'); 
   htp.p('                      }'); 
   htp.p(' </style>');
END;   
--
-----------------------------------------------------------------------------
--
PROCEDURE file_selection(pi_table_name IN VARCHAR2 DEFAULT NULL) IS

   CURSOR c1 IS
   SELECT DISTINCT mds_hpr_product hpr_product
                  ,hpr_product_name
   FROM   metadata_scripts
         ,hig_products
   WHERE  mds_hpr_product = hpr_product     
   ORDER BY decode(hpr_product,'NET',1
                              ,'NSG',2
                              ,'TMA',3
                              ,hpr_product_name,4); -- order by most 'popular' products first


   CURSOR c2 (pi_hpr_product metadata_scripts.mds_hpr_product%TYPE) IS
   SELECT *
   FROM   metadata_scripts mds
   WHERE  mds.MDS_HPR_PRODUCT = pi_hpr_product
   ORDER  by mds.MDS_HPR_PRODUCT;
   
   CURSOR c3(cp_file VARCHAR2) IS
   SELECT 'Y'
   FROM   metadata_script_tables mdst
   WHERE  mdst.MDST_MDS_SCRIPT_OUTPUT_FILE = cp_file
   AND    mdst.MDST_TABLE_NAME = pi_table_name;

   v_checked VARCHAR2(1);
   
   l_hostname   VARCHAR2(1000);
  
BEGIN
  
  -- Get the hostname
  SELECT host_name INTO l_hostname FROM v$instance;


   htp.p('<HTML>');
   html_stylesheet;     
   htp.p(' <script language="JavaScript">');
   htp.p(' function checkAll(theForm, cName, status) {');
   htp.p(' for (i=0,n=theForm.elements.length;i<n;i++)');
   htp.p('   if (theForm.elements[i].className.indexOf(cName) !=-1) {');
   htp.p('     theForm.elements[i].checked = status;');
   htp.p('   }');
   htp.p(' }');
   htp.p(' </script>');
   
   htp.p('<HEAD>');
   htp.p('<TITLE>Metadata Generation</TITLE>');
   htp.p('</HEAD>');
   htp.p('<BODY>');

   htp.tableopen(cborder => 'border=0');
   htp.formopen(curl        => g_package_name||'.file_selection'
               ,cattributes => 'id="searchForm"');
			   
--   htp.p(' Table Name');
   htp.tablerowopen(cvalign => 'CENTRE');      
   htp.tabledata('Table Search : ');
   htp.p('<TD>');
   htp.p('<SELECT NAME=pi_table_name>');
   FOR i IN (select distinct mdst_table_name from metadata_script_tables order by 1)  
    LOOP 
      htp.p('<OPTION VALUE="'||i.mdst_table_name||'">'
                             ||i.mdst_table_name
                             ||'</OPTION>');
   END LOOP;

   htp.formsubmit (cvalue=>'Find Scripts', cattributes => 'CLASS="ButtonOrange"');			   
   htp.formclose;

   htp.tablerowclose;
   htp.tableclose;   
   
   
   htp.formopen(curl        => g_package_name||'.generate'
               ,cattributes => 'id="selectForm"');
			   
   htp.p('  <TABLE WIDTH="100%" BORDER="1" CELLSPACING="0" CELLPADDING="2" ALIGN="CENTER" BGCOLOR="#ffe1aa">');

   htp.p('<tr VALIGN="TOP" bgcolor="orange"> ');
   FOR p IN c1 LOOP   
     htp.p('   <td valign="TOP" align="CENTER" colspan="1" CLASS="big_title">');
	 htp.p('   <b> '||p.hpr_product_name||' </b> <br> <input type="checkbox" onclick="checkAll(document.getElementById(''selectForm''), '''||p.hpr_product||''', this.checked);" />');
	 htp.p('   </td>');
   END LOOP;	 

   htp.p('</tr>'); 

   htp.tablerowopen;
   
   FOR p IN c1 LOOP


   htp.p('      <TD CLASS="table_val_small" valign="TOP"');
   htp.p('<br>');   
     FOR f IN c2(p.HPR_PRODUCT) LOOP

        v_checked := 'N'; 	 
	    OPEN c3(f.mds_script_output_file);
		FETCH c3 INTO v_checked;
		CLOSE c3;
		
		IF v_checked = 'Y' THEN
           htp.p('        <INPUT TYPE="CHECKBOX" NAME="filelist" checked VALUE="'||f.mds_script_output_file||'" CLASS="'||p.hpr_product||'">'||f.mds_script_output_file||'');
        ELSE
           htp.p('        <INPUT TYPE="CHECKBOX" NAME="filelist" unchecked VALUE="'||f.mds_script_output_file||'" CLASS="'||p.hpr_product||'">'||f.mds_script_output_file||'');
        END IF;
				   		   		   
     END LOOP;
   htp.p('      </TD>');
 
   END LOOP;
   htp.tablerowclose;   

   htp.tableclose;

   htp.p('<br>');
   htp.p('<br>');   
   
   htp.p('  <TABLE WIDTH="50%" BORDER="0" CELLSPACING="0" CELLPADDING="2" ALIGN="LEFT" VALIGN="TOP" BGCOLOR="#ffe1aa">');

   htp.tablerowopen;   
   htp.p('<TD CLASS="table_val_highlighted"> Generate Scripts Into ('||l_hostname||') </TD>');
   htp.p('<TD CLASS="table_val_highlighted"> Script Header Text</TD>');   
   htp.tablerowclose;

   htp.tablerowopen;
   htp.p('<TD CLASS="table_val_highlighted">');
   htp.formtext(cname       => 'file_location'
               ,csize       => 50
               ,cvalue      => get_mdo('DFLTDIR').mdo_option_value
               );
   htp.p('</TD>');

   htp.p('<TD CLASS="table_val_highlighted">');
   htp.formtext(cname       => 'script_header'
               ,csize       => 50
               ,cvalue      => get_mdo('DFLTHEADER').mdo_option_value
               );
   htp.p('</TD>');   
   
   
   htp.tablerowopen;
   htp.tablerowclose;

   
   htp.tablerowopen;
--   htp.p('</TD>');
   htp.p('<TD align="LEFT" CLASS="table_val">');
   htp.formsubmit (cvalue=>'Generate Metadata ' ,cattributes => 'CLASS="ButtonOrange" width="100" align="LEFT"');
   htp.formclose;
   htp.p('</TD>');
   htp.tablerowclose;


   
   htp.tablerowopen;
   htp.p('<TD align="LEFT" CLASS="table_val">');
   htp.formopen(curl        => g_package_name||'.refresh_hwch_for_all_products'
               ,cattributes => 'id="refresh_hwch"');   
   htp.formsubmit (cvalue=>'Read Robohelp Files' ,cattributes => 'CLASS="ButtonOrange" width="100" align="LEFT"');
   htp.formclose;   
   htp.p('</TD>');


   htp.tablerowopen;
   htp.p('<TD align="LEFT" CLASS="table_val">');
   htp.formopen(curl        => get_mdo('MAINTFORM').mdo_option_value
               ,cattributes => 'id="metadata_maint"');   
   htp.formsubmit (cvalue=>'Maintain Meta-Data' ,cattributes => 'CLASS="ButtonOrange" width="100" align="LEFT"');
   htp.formclose;   
   htp.p('</TD>');


   htp.tablerowclose;
/*   
   ------------------
   -- Maintenance URL
   ------------------
     htp.tablerowopen;
     htp.p('<TD CLASS="table_val_highlighted"> <a href='||get_mdo('MAINTFORM').mdo_option_value||' target="_blank"> Maintain Meta-Data </a> </TD>');
     htp.tablerowclose;
*/	 
   htp.p('</TABLE>');	 


   htp.p('</BODY>');
   htp.p('</HTML>');
END file_selection;
--
-----------------------------------------------------------------------------
--
--
-- ** BELOW ARE FUNCTIONS AND PROCEDURES USED TO SUPPORT READING IN 
-- ** ROBOHELP INDEX AND TOC FILES TO REFRESH HIG_WEB_CONTXT_HLP
--
  FUNCTION get_next_hwch_id RETURN hig_web_contxt_hlp.hwch_art_id%TYPE IS
  
  v_retval hig_web_contxt_hlp.hwch_art_id%TYPE;

  BEGIN
  
    SELECT MAX(HWCH_ART_ID) + 1
	INTO   v_retval
    FROM   hig_web_contxt_hlp;

	RETURN(NVL(v_retval,1));
	
  EXCEPTION
    WHEN no_data_found THEN RETURN(1);	
  END get_next_hwch_id; 					  
--
-----------------------------------------------------------------------------
--
  FUNCTION get_module_app (pi_module_name IN VARCHAR2) RETURN webhelp_hig_modules.hmo_application%TYPE IS
    CURSOR c1 IS
      SELECT hmo_application
      FROM   webhelp_hig_modules -- a view that concatenates all modules from all metadata accounts
      WHERE  hmo_module = UPPER(pi_module_name)
	  AND    UPPER(pi_module_name) != 'HIGHWAYS';
    --
    l_hmo_application webhelp_hig_modules.hmo_application%TYPE;
    --
  BEGIN
--      nm_debug.debug('get_module_app = '||pi_module_name);
	  OPEN c1;
	  FETCH c1
	  INTO l_hmo_application;
      CLOSE c1;

	  RETURN l_hmo_application;
  END get_module_app;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_help_url(pi_string            IN VARCHAR2
                       ,pi_product_directory IN VARCHAR2) RETURN hig_web_contxt_hlp.hwch_html_string%TYPE IS
  
     l_retval VARCHAR2(2000);
     c_url_tag  VARCHAR2(30)       := '<param name="Local" value="';
     c_url_tag_length NUMBER       := LENGTH(c_url_tag);
  
  BEGIN

--     nm_debug.debug('start get_help_url '||pi_string||' ** '||c_url_tag);

     IF  INSTR(pi_string,c_url_tag) != 0 THEN

       l_retval := SUBSTR(pi_string,INSTR(pi_string,c_url_tag)+c_url_tag_length,LENGTH(pi_string));
       l_retval := REPLACE(l_retval,'">',Null);

       RETURN('/'||LOWER(pi_product_directory)||'/WebHelp/'||LOWER(pi_product_directory)||'.htm#'||LOWER(l_retval));

     ELSE
	     RETURN(Null);
     END IF;
  
     --nm_debug.debug('end get_help_url');

  END get_help_url;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_words_from_string (pi_string IN VARCHAR2
                                 ,pi_start_from_position IN NUMBER DEFAULT 1) RETURN nm3type.tab_varchar2000 IS

    l_string VARCHAR2(2000) := SUBSTR(pi_string,pi_start_from_position,LENGTH(pi_string)); 
	l_string_length NUMBER; 
    l_index PLS_INTEGER := 1;
	c_space VARCHAR2(1) := ' ';
	l_tab_words nm3type.tab_varchar2000;
	l_word_string   VARCHAR2(2000);

  --
  BEGIN
  	--
	 l_tab_words.DELETE;

     -- strip out the crap	 
	 l_string := REPLACE(l_string,'"',Null);
	 l_string := REPLACE(l_string,'<',Null);
	 l_string := REPLACE(l_string,'>',Null);
	 l_string := RTRIM(LTRIM(l_string));
	 
     l_string_length := LENGTH(l_string);
	 
	 IF l_string_length > 0 THEN
 
       -- loop through all the letters in the string and if at a space and if there is
       -- currently a word in the string buffer then dump that word out and start again
	 
       FOR i IN 1..l_string_length LOOP

	     IF SUBSTR(l_string,i,1) = c_space THEN 
	         IF l_word_string IS NOT NULL THEN
		        l_tab_words(l_index) := l_word_string;
			    l_index := l_index+1;
			    l_word_string := Null;
  		     END IF;
  	     ELSE
	         l_word_string := l_word_string || SUBSTR(l_string,i,1);  
         END IF;
	   
       END LOOP;
	 
	   IF l_word_string IS NOT NULL THEN
     	   l_tab_words(l_index) := l_word_string;	 
  	   END IF;
	  
	  END IF;  
	  
     RETURN(l_tab_words);

  END get_words_from_string;
--
-----------------------------------------------------------------------------
--
PROCEDURE insert_hwch_rec(pi_product IN hig_web_contxt_hlp.hwch_product%TYPE
                         ,pi_module  IN hig_web_contxt_hlp.hwch_module%TYPE
						 ,pi_url     IN hig_web_contxt_hlp.hwch_html_string%TYPE
                         ,pi_block   IN hig_web_contxt_hlp.hwch_block%TYPE DEFAULT NULL
						 ,pi_item    IN hig_web_contxt_hlp.hwch_item%TYPE DEFAULT NULL) IS
						  

 l_next_id hig_web_contxt_hlp.hwch_art_id%TYPE;

BEGIN

  l_next_id := get_next_hwch_id;

  --nm_debug.debug('Inserting into hig_web_contxt_hlp: '||l_next_id||' '|| pi_module||' '||pi_url);

 INSERT INTO hig_web_contxt_hlp 
         (hwch_art_id            
         ,hwch_product           
         ,hwch_module            
         ,hwch_block             
         ,hwch_item              
         ,hwch_html_string)
  SELECT l_next_id
        ,UPPER(pi_product)
        ,pi_module
        ,pi_block
        ,pi_item
        ,pi_url
  FROM DUAL
  WHERE NOT EXISTS (SELECT 1 FROM hig_web_contxt_hlp
                     WHERE hwch_product = UPPER(pi_product)
                       AND hwch_module  = pi_module);

END insert_hwch_rec;
--
-----------------------------------------------------------------------------
--
PROCEDURE insert_default_product_url(pi_product IN  hig_web_contxt_hlp.hwch_product%TYPE
                                    ,pi_product_directory IN VARCHAR2) IS

 l_default_url hig_web_contxt_hlp.hwch_html_string%TYPE := '/'||LOWER(pi_product_directory)||'/WebHelp/'||LOWER(pi_product)||'.htm';

BEGIN

   --nm_debug.debug('call insert_hwch_rec #1'); 
   insert_hwch_rec(pi_product => pi_product
                  ,pi_module  => Null
                  ,pi_url     => l_default_url);


END; 
--
-----------------------------------------------------------------------------
--
PROCEDURE process_robohelp_file(pi_product IN hig_products.hpr_product%TYPE
 	                           ,pi_product_directory IN VARCHAR2
                               ,pi_location IN VARCHAR2
                               ,pi_filename IN VARCHAR2)  IS


  l_tab_contents  nm3type.tab_varchar32767;
  
  c_name_tag      VARCHAR2(30)  := '<param name="Name" value="';
  c_name_tag_length NUMBER      := LENGTH(c_name_tag);
  
  l_tab_words nm3type.tab_varchar2000;
  
  l_module_app hig_web_contxt_hlp.hwch_product%TYPE;
  l_module  hig_web_contxt_hlp.hwch_module%TYPE;
  l_url     hig_web_contxt_hlp.hwch_html_string%TYPE;

     				  
BEGIN

 --nm_debug.debug('start process_robohelp_file '||pi_product||' '||pi_filename);

 l_tab_contents.DELETE;

 BEGIN
 
  nm3file.get_file (LOCATION     => pi_location
                   ,filename     => pi_filename
                   ,all_lines    => l_tab_contents);

   htp.p('<tr VALIGN="TOP" bgcolor="#ffe1aa"> ');
     htp.p('   <td valign="TOP" width="50" align="LEFT" colspan="1" CLASS="big_title">'||pi_product||'</td>');
     htp.p('   <td valign="TOP" width="150" align="LEFT" colspan="1" CLASS="big_title">'||pi_filename||'</td>');	 
   htp.p('</tr>'); 

 EXCEPTION
   WHEN others THEN Null;
 END;				   
				    
 
  FOR i IN 1..l_tab_contents.COUNT LOOP
  
   l_module_app := Null;
   l_module := Null;
   l_url    := Null; 


--   nm_debug.debug('l_tab_contents contains '||l_tab_contents.count||' records - '||i);
   IF i != l_tab_contents.COUNT THEN  -- don't bother checking last entry of file cos can't get next line to read url

     
    --nm_debug.debug('l_tab_contents(i),c_name_tag = '||l_tab_contents(i)||' ** '||c_name_tag);
    
    IF INSTR(l_tab_contents(i),c_name_tag) != 0 THEN  -- if this is a line that could contain a name tag to a module then go further

	
       -- find all the words after the tag
       l_tab_words := get_words_from_string(pi_string                => l_tab_contents(i)
	                           ,pi_start_from_position   => INSTR(l_tab_contents(i),c_name_tag) + c_name_tag_length);

       --nm_debug.debug('l_tab_words = '||l_tab_words.count||' '||pi_product);							   
       FOR x IN 1..l_tab_words.COUNT LOOP

	     l_module_app := get_module_app(l_tab_words(x));
         
         --nm_debug.debug('l_module_app = '||l_module_app);

         IF l_module_app IS NOT NULL THEN  -- check to see if the word is a hig module 
		  
		    l_module := l_tab_words(x);
            --nm_debug.debug('l_module = '||l_module||' file name = '||pi_filename);
			l_url    := get_help_url(l_tab_contents(i+1),pi_product_directory);  -- read the possible URL from the next line 
            --nm_debug.debug('l_url = '||l_url);
		 
         END IF;				 
	         
	   END LOOP;

     END IF;

    END IF;

    --nm_debug.debug('l_module = '||l_module||' l_url = '||l_url||' l_module_app = '||l_module_app); 

	IF l_module IS NOT NULL AND l_url IS NOT NULL and l_module_app IS NOT NULL THEN
	
          --nm_debug.debug('call insert_hwch_rec #2 '||l_module_app||' '||l_module||' '||l_url); 
          insert_hwch_rec(pi_product => l_module_app
                         ,pi_module  => l_module
						 ,pi_url     => l_url);

	END IF;

    
   END LOOP;
    --nm_debug.debug('end process_robohelp_file');

END process_robohelp_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE refresh_hwch_for_all_products IS

 CURSOR c1 IS
 SELECT DECODE(hpr_product,'ENQ','PEM','CLM','SLM',hpr_product)      product_directory
      , hpr_product             hpr_product
      , LOWER(hpr_product_name) hpr_product_name
 FROM   hig_products
 ORDER BY 1;

 l_default_location VARCHAR2(100) :=get_mdo('DFLTDIR').mdo_option_value||'HTMLhelp\';

BEGIN
--   nm_debug.debug_on;
--   nm_debug.debug('start refresh_hwch_for_all_products');

   htp.p('<HTML>');
   html_stylesheet;     
   htp.p('<HEAD>');
   htp.p('<TITLE>Read ROBOHELP TOC/INDEX files</TITLE>');
   htp.p('</HEAD>');
   htp.p('<BODY>');
   htp.p('  <TABLE WIDTH="400" BORDER="1" CELLSPACING="0" CELLPADDING="2" ALIGN="LEFT" BGCOLOR="#ffe1aa">');
   htp.p('<tr VALIGN="TOP" bgcolor="#ffe1aa"> ');
     htp.p('   <td colspan="2" valign="TOP" width="400" align="LEFT"  CLASS="big_title"> Files Read From '||l_default_location||'</td>');
   htp.p('</tr>'); 
   

 DELETE FROM hig_web_contxt_hlp;

 FOR i IN c1 LOOP


  --  nm_debug.debug(i.hpr_product||' call insert_default_product_url - dir = '||i.product_directory);
    insert_default_product_url(pi_product           => i.hpr_product
	                          ,pi_product_directory => i.product_directory);
							  
 END LOOP;
 
 FOR i IN c1 LOOP 							  

--    nm_debug.debug(i.hpr_product||' call process_robohelp_file toc.hhc - dfl loc = '||l_default_location||i.product_directory);
    process_robohelp_file(pi_product           => i.hpr_product 
	                     ,pi_product_directory => i.product_directory
                         ,pi_location          => l_default_location||i.product_directory
                         ,pi_filename          => 'toc.hhc');
						 
--    nm_debug.debug(i.hpr_product||' call process_robohelp_file index.hhk - dfl loc = '||l_default_location||i.product_directory);

    process_robohelp_file(pi_product           => i.hpr_product 
	                     ,pi_product_directory => i.product_directory	
                         ,pi_location          => l_default_location||i.product_directory
                         ,pi_filename          => 'index.hhk');						 
 
 END LOOP;

  
 COMMIT;

 htp.p('</TABLE>');
 htp.p('Updated metadata scripts can be found in '||get_mdo('DFLTDIR').mdo_option_value); 
 
 FOR i IN (select mds_script_output_file 
           from metadata_scripts mds
		      , metadata_script_tables mdst 
		   where mdst.mdst_table_name = 'HIG_WEB_CONTXT_HLP'
		   and   mdst.mdst_mds_script_output_file = mds.mds_script_output_file) LOOP
		   
--     nm_debug.debug('call process_individual_script');
     process_individual_script (pi_mds_script_output_file  => i.mds_script_output_file
                               ,pi_location                => get_mdo('DFLTDIR').mdo_option_value
		  				       ,pi_script_header           => 'Re-generated to include updated HIG_WEB_CONTXT_HLP entries');

 END LOOP;							    		   

-- nm_debug.debug('end refresh_hwch_for_all_products');

END refresh_hwch_for_all_products;
--
-----------------------------------------------------------------------------
--
END new_metadata_generate;
/
