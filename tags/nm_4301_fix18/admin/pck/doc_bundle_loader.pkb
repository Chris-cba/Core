CREATE OR REPLACE PACKAGE BODY doc_bundle_loader
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/doc_bundle_loader.pkb-arc   3.6.1.0   Sep 10 2012 12:49:10   Rob.Coupe  $
--       Module Name      : $Workfile:   doc_bundle_loader.pkb  $
--       Date into PVCS   : $Date:   Sep 10 2012 12:49:10  $
--       Date fetched Out : $Modtime:   Sep 10 2012 12:39:40  $
--       Version          : $Revision:   3.6.1.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid CONSTANT VARCHAR2(2000) := '$Revision:   3.6.1.0  $';

  g_package_name CONSTANT varchar2(30) := 'doc_bundle_loader';
  
  c_process_type_name CONSTANT VARCHAR2(30)   := 'Load Document Bundles';
  c_file_type_name    CONSTANT VARCHAR2(30)   := 'DOC BUNDLE';
  c_unzip_subdir_prefix CONSTANT VARCHAR2(30) := 'doc_bundle_';
  c_driving_file_extension CONSTANT VARCHAR2(30) := 'DRIVING';  
  
  
    
  g_unzip_oracle_directory       hig_directories.hdir_name%TYPE;
  g_current_process              hig_processes%ROWTYPE;
  
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
PROCEDURE insert_doc_bundle(pi_dbun_rec IN OUT doc_bundles%ROWTYPE) IS


BEGIN

 IF pi_dbun_rec.dbun_bundle_id IS NULL THEN
   pi_dbun_rec.dbun_bundle_id      := nm3ddl.sequence_nextval('dbun_bundle_id_seq');
 END IF;
   
 pi_dbun_rec.dbun_date_created   := NVL(pi_dbun_rec.dbun_date_created,sysdate);
 pi_dbun_rec.dbun_date_modified  := NVL(pi_dbun_rec.dbun_date_modified,sysdate);
 pi_dbun_rec.dbun_modified_by    := NVL(pi_dbun_rec.dbun_modified_by,user); 
 pi_dbun_rec.dbun_created_by     := NVL(pi_dbun_rec.dbun_created_by,user);


 INSERT INTO doc_bundles(dbun_bundle_id
                       , dbun_filename
                       , dbun_location
                       , dbun_unzip_location
                       , dbun_unzip_log
                       , dbun_process_id
                       , dbun_date_created
                       , dbun_date_modified
                       , dbun_modified_by
                       , dbun_created_by)
 VALUES (
         pi_dbun_rec.dbun_bundle_id
       , pi_dbun_rec.dbun_filename
       , pi_dbun_rec.dbun_location
       , pi_dbun_rec.dbun_unzip_location
       , pi_dbun_rec.dbun_unzip_log
       , pi_dbun_rec.dbun_process_id
       , pi_dbun_rec.dbun_date_created
       , pi_dbun_rec.dbun_date_modified
       , pi_dbun_rec.dbun_modified_by
       , pi_dbun_rec.dbun_created_by
       )
 RETURNING     
            dbun_bundle_id
          , dbun_filename
          , dbun_location
          , dbun_unzip_location
          , dbun_unzip_log
          , dbun_process_id
          , dbun_date_created
          , dbun_date_modified
          , dbun_modified_by
          , dbun_created_by
 INTO    pi_dbun_rec.dbun_bundle_id
       , pi_dbun_rec.dbun_filename
       , pi_dbun_rec.dbun_location
       , pi_dbun_rec.dbun_unzip_location
       , pi_dbun_rec.dbun_unzip_log
       , pi_dbun_rec.dbun_process_id
       , pi_dbun_rec.dbun_date_created
       , pi_dbun_rec.dbun_date_modified
       , pi_dbun_rec.dbun_modified_by
       , pi_dbun_rec.dbun_created_by;                       

END insert_doc_bundle;
--
-----------------------------------------------------------------------------
--
FUNCTION get_driving_file_flag(pi_filename IN doc_bundle_files.dbf_filename%TYPE) RETURN VARCHAR2 IS

BEGIN

    IF UPPER(nm3flx.get_file_extenstion(pi_filename)) =  c_driving_file_extension THEN
      RETURN('Y');
    ELSE
      RETURN('N');
    END IF;
 
END get_driving_file_flag;
--
-----------------------------------------------------------------------------
--
PROCEDURE insert_doc_bundle_file(pi_dbf_rec IN OUT doc_bundle_files%ROWTYPE) IS


BEGIN

 IF pi_dbf_rec.dbf_file_id IS NULL THEN
   pi_dbf_rec.dbf_file_id        := nm3ddl.sequence_nextval('dbf_file_id_seq');
 END IF;
 
 IF pi_dbf_rec.dbf_driving_file_flag IS NULL THEN
 
    pi_dbf_rec.dbf_driving_file_flag := get_driving_file_flag(pi_filename => pi_dbf_rec.dbf_filename); 
 
 END IF;
 
 
  INSERT INTO doc_bundle_files(
                              dbf_bundle_id               
                             ,dbf_file_id               
                             ,dbf_filename
                             ,dbf_driving_file_flag
                             ,dbf_file_included_with_bundle   
                             ,dbf_blob                                             
                              )
 VALUES (
         pi_dbf_rec.dbf_bundle_id
        ,pi_dbf_rec.dbf_file_id
        ,pi_dbf_rec.dbf_filename
        ,pi_dbf_rec.dbf_driving_file_flag
        ,pi_dbf_rec.dbf_file_included_with_bundle
        ,pi_dbf_rec.dbf_blob
       )
 RETURNING     
            dbf_bundle_id               
           ,dbf_file_id               
           ,dbf_filename            
           ,dbf_driving_file_flag
           ,dbf_file_included_with_bundle
           ,dbf_blob
 INTO    pi_dbf_rec.dbf_bundle_id
        ,pi_dbf_rec.dbf_file_id
        ,pi_dbf_rec.dbf_filename
        ,pi_dbf_rec.dbf_driving_file_flag
        ,pi_dbf_rec.dbf_file_included_with_bundle
        ,pi_dbf_rec.dbf_blob;                       

END insert_doc_bundle_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE insert_doc_bundle_file_rel(pi_dbfr_rec IN OUT doc_bundle_file_relations%ROWTYPE) IS

 
BEGIN

 IF pi_dbfr_rec.dbfr_relationship_id IS NULL THEN
   pi_dbfr_rec.dbfr_relationship_id        := nm3ddl.sequence_nextval('dbfr_relationship_id_seq');
 END IF;

  INSERT INTO doc_bundle_file_relations(dbfr_relationship_id
                                      , dbfr_driving_file_id
                                      , dbfr_driving_file_recno   
                                      , dbfr_child_file_id
                                      , dbfr_doc_title
                                      , dbfr_doc_descr
                                      , dbfr_doc_type
                                      , dbfr_dlc_name
                                      , dbfr_gateway_table_name
                                      , dbfr_rec_id
                                      , dbfr_x_coordinate
                                      , dbfr_y_coordinate                                      
                                      , dbfr_doc_id
                                      , dbfr_doc_filename
                                      , dbfr_hftq_batch_no
                                      , dbfr_error_text                                                
                                      )
 VALUES (
        pi_dbfr_rec.dbfr_relationship_id
      , pi_dbfr_rec.dbfr_driving_file_id
      , pi_dbfr_rec.dbfr_driving_file_recno
      , pi_dbfr_rec.dbfr_child_file_id
      , pi_dbfr_rec.dbfr_doc_title
      , pi_dbfr_rec.dbfr_doc_descr
      , pi_dbfr_rec.dbfr_doc_type
      , pi_dbfr_rec.dbfr_dlc_name
      , pi_dbfr_rec.dbfr_gateway_table_name
      , pi_dbfr_rec.dbfr_rec_id
      , pi_dbfr_rec.dbfr_x_coordinate
      , pi_dbfr_rec.dbfr_y_coordinate                                      
      , pi_dbfr_rec.dbfr_doc_id
      , pi_dbfr_rec.dbfr_doc_filename
      , pi_dbfr_rec.dbfr_hftq_batch_no
      , pi_dbfr_rec.dbfr_error_text
       )
 RETURNING     
            dbfr_relationship_id
          , dbfr_driving_file_id
          , dbfr_driving_file_recno
          , dbfr_child_file_id
          , dbfr_doc_title          
          , dbfr_doc_descr
          , dbfr_doc_type
          , dbfr_dlc_name
          , dbfr_gateway_table_name
          , dbfr_rec_id
          , dbfr_x_coordinate
          , dbfr_y_coordinate                                      
          , dbfr_doc_id
          , dbfr_doc_filename
          , dbfr_hftq_batch_no
          , dbfr_error_text   
 INTO   pi_dbfr_rec.dbfr_relationship_id
      , pi_dbfr_rec.dbfr_driving_file_id
      , pi_dbfr_rec.dbfr_driving_file_recno 
      , pi_dbfr_rec.dbfr_child_file_id
      , pi_dbfr_rec.dbfr_doc_title
      , pi_dbfr_rec.dbfr_doc_descr
      , pi_dbfr_rec.dbfr_doc_type
      , pi_dbfr_rec.dbfr_dlc_name
      , pi_dbfr_rec.dbfr_gateway_table_name
      , pi_dbfr_rec.dbfr_rec_id
      , pi_dbfr_rec.dbfr_x_coordinate
      , pi_dbfr_rec.dbfr_y_coordinate                                      
      , pi_dbfr_rec.dbfr_doc_id
      , pi_dbfr_rec.dbfr_doc_filename
      , pi_dbfr_rec.dbfr_hftq_batch_no
      , pi_dbfr_rec.dbfr_error_text;                       

END insert_doc_bundle_file_rel;
--
-----------------------------------------------------------------------------
--
PROCEDURE unzip_document_bundle(pi_dbun_rec         IN OUT doc_bundles%ROWTYPE) IS

 l_tab_vc nm3type.tab_varchar32767;

BEGIN



 hig_process_api.log_it(pi_message         => '   Unzipping from '||pi_dbun_rec.dbun_location||' to '||pi_dbun_rec.dbun_unzip_location
                       ,pi_summary_flag    => 'N' );

 l_tab_vc := hig_svr_util.unzip_file(pi_location      => pi_dbun_rec.dbun_location
                                   , pi_filename      => pi_dbun_rec.dbun_filename
                                   , pi_dest_location => pi_dbun_rec.dbun_unzip_location);
                                                      
                                                      
  pi_dbun_rec.dbun_unzip_log := nm3clob.tab_varchar_to_clob(l_tab_vc);

  update doc_bundles
  set dbun_unzip_log = pi_dbun_rec.dbun_unzip_log
  where dbun_bundle_id = pi_dbun_rec.dbun_bundle_id;
  
  commit;
  
EXCEPTION

 WHEN others THEN 
 IF instr(pi_dbun_rec.dbun_filename,' ') > 0 THEN
    hig.raise_ner(pi_appl => 'HIG'
                 ,pi_id   => 546 -- Unzip Failed
                 ,pi_supplementary_info => 'Filename contains spaces');
 ELSE

    hig.raise_ner(pi_appl => 'HIG'
                 ,pi_id   => 546 -- Unzip Failed
                 ,pi_supplementary_info => nm3flx.parse_error_message(sqlerrm)); -- Task 0110193

 
 END IF;                 
                 
                 
END unzip_document_bundle;
--
-----------------------------------------------------------------------------
--
PROCEDURE list_files_in_unzip_location(pi_dbun_rec IN doc_bundles%ROWTYPE) IS 


 l_list nm3file.file_list;
 l_dbf_rec doc_bundle_files%ROWTYPE; 
 l_unzip_oracle_directory hig_directories.hdir_name%TYPE := UPPER(c_unzip_subdir_prefix||pi_dbun_rec.dbun_bundle_id);
 
 
  PROCEDURE create_dir_on_fly IS
     
  BEGIN
      
   hig_directories_api.mkdir(pi_replace        => TRUE        
                            ,pi_directory_name => l_unzip_oracle_directory
                            ,pi_directory_path => pi_dbun_rec.dbun_unzip_location);
  END;


  PROCEDURE drop_dir_on_fly IS
     
  BEGIN
     
     hig_directories_api.rmdir(pi_directory_name => l_unzip_oracle_directory);
     
   EXCEPTION
     WHEN others THEN
       Null;
  END;  


BEGIN


 hig_process_api.log_it(pi_message         => '   Building list of unzipped files' 
                       ,pi_summary_flag    => 'N' );

 create_dir_on_fly;

 l_list :=  nm3file.get_files_in_directory(pi_dir => pi_dbun_rec.dbun_unzip_location
                                          ,pi_extension => Null);
                                          
                                          
                                           
 FOR f in 1..l_list.COUNT LOOP
 
  l_dbf_rec := Null;
  l_dbf_rec.dbf_bundle_id := pi_dbun_rec.dbun_bundle_id;
  l_dbf_rec.dbf_filename  := l_list(f);
  l_dbf_rec.dbf_file_included_with_bundle := 'Y';
  l_dbf_rec.dbf_blob      := nm3file.file_to_blob(pi_source_dir   => l_unzip_oracle_directory
                                                 ,pi_source_file  => l_list(f));
         
  
  
                                              
  insert_doc_bundle_file(pi_dbf_rec => l_dbf_rec);
 
 END LOOP;

 drop_dir_on_fly;
 
 commit;
 
EXCEPTION
 WHEN others THEN   
   drop_dir_on_fly;
   RAISE;

END list_files_in_unzip_location;
--
-----------------------------------------------------------------------------
--
FUNCTION get_or_create_file(pi_bundle_id   IN doc_bundle_files.dbf_bundle_id%TYPE
                           ,pi_filename    IN doc_bundle_files.dbf_filename%TYPE) RETURN doc_bundle_files%ROWTYPE IS
                            

 CURSOR c1(cp_bundle_id IN doc_bundle_files.dbf_bundle_id%TYPE
          ,cp_filename  IN doc_bundle_files.dbf_filename%TYPE) IS
 SELECT *
 FROM   doc_bundle_files
 WHERE  dbf_bundle_id = cp_bundle_id
 AND    dbf_filename = pi_filename;
 
 l_retval doc_bundle_files%ROWTYPE := Null;

BEGIN

 OPEN c1(cp_bundle_id => pi_bundle_id
        ,cp_filename  => pi_filename);
 FETCH c1 INTO l_retval;
 CLOSE c1;
 
 
 IF l_retval.dbf_file_id IS NULL THEN
 
  l_retval.dbf_bundle_id := pi_bundle_id;
  l_retval.dbf_filename  := pi_filename;
  l_retval.dbf_file_included_with_bundle := 'N';
  
  insert_doc_bundle_file(pi_dbf_rec => l_retval);
  
 END IF;

 RETURN(l_retval);


END get_or_create_file;                          
--
-----------------------------------------------------------------------------
--
PROCEDURE read_driving_files_in_bundle(pi_dbun_rec IN doc_bundles%ROWTYPE) IS 

 l_file_content nm3type.tab_varchar32767;
 l_dbfr_rec doc_bundle_file_relations%ROWTYPE; 
 l_filename  doc_bundle_files.dbf_filename%TYPE;
 
 CURSOR c1 IS
 SELECT * 
 FROM doc_bundle_files 
 WHERE dbf_bundle_id = pi_dbun_rec.dbun_bundle_id 
 AND dbf_driving_file_flag = 'Y'
 ORDER BY dbf_filename ASC;
 
 TYPE t_tab_c1 IS TABLE OF c1%ROWTYPE INDEX BY BINARY_INTEGER;
 l_tab_c1 t_tab_c1;
 
 FUNCTION read_csv_value(pi_line   IN VARCHAR2
                        ,pi_seq    IN NUMBER
                        ,pi_length IN NUMBER) RETURN VARCHAR IS

  l_retval nm3type.max_varchar2;
  l_newline          varchar2(1) := chr(10);
  l_carriage_return  varchar2(1) := chr(13);
  l_double_quotes    varchar2(1) := chr(34);
  
 BEGIN
 
  l_retval := nm3load.get_csv_value_from_line(p_seq  => pi_seq
                                             ,p_line => pi_line);
                                             
  l_retval := REPLACE(l_retval,l_newline,null);
  l_retval := REPLACE(l_retval,l_carriage_return,null);
  l_retval := REPLACE(l_retval,l_double_quotes,null);
  
  RETURN(substr(l_retval,1,pi_length));                                                
 
 END read_csv_value;  

BEGIN

 OPEN c1;
 FETCH c1 BULK COLLECT INTO l_tab_c1;
 CLOSE c1;

     FOR d IN 1..l_tab_c1.COUNT LOOP
     
      hig_process_api.log_it(pi_message         => '   Reading '||l_tab_c1(d).dbf_filename 
                            ,pi_summary_flag    => 'N' ); 
     

      l_file_content := nm3clob.clob_to_tab_varchar(
                                                    pi_clob => nm3clob.blob_to_clob(
                                                                                   pi_blob => l_tab_c1(d).dbf_blob
                                                                                   )
                                                   );   

       FOR c IN 1..l_file_content.COUNT LOOP

         l_filename                           := read_csv_value(pi_line   => l_file_content(c)
                                                               ,pi_seq    => 1
                                                               ,pi_length => 240); 
         

         IF l_filename IS NOT NULL THEN -- i.e. if there was a blank line in the driving file we don't want to read null values and things to fall over

             l_dbfr_rec := Null;

             l_dbfr_rec.dbfr_driving_file_id      := l_tab_c1(d).dbf_file_id; 


             l_dbfr_rec.dbfr_driving_file_recno  := c;

             l_dbfr_rec.dbfr_child_file_id        := get_or_create_file(pi_bundle_id   => pi_dbun_rec.dbun_bundle_id
                                                                       ,pi_filename    => l_filename).dbf_file_id;      

             l_dbfr_rec.dbfr_doc_title            :=  read_csv_value(pi_line   => l_file_content(c)
                                                                    ,pi_seq    => 2
                                                                    ,pi_length => 60); 

             l_dbfr_rec.dbfr_doc_descr            :=  read_csv_value(pi_line   => l_file_content(c)
                                                                    ,pi_seq    => 3
                                                                    ,pi_length => 2000); 

             l_dbfr_rec.dbfr_doc_type             :=  read_csv_value(pi_line   => l_file_content(c)
                                                                    ,pi_seq    => 4
                                                                    ,pi_length => 4); 


             l_dbfr_rec.dbfr_dlc_name             :=  read_csv_value(pi_line   => l_file_content(c)
                                                                    ,pi_seq    => 5
                                                                    ,pi_length => 30);

             l_dbfr_rec.dbfr_gateway_table_name   :=  read_csv_value(pi_line   => l_file_content(c)
                                                                    ,pi_seq    => 6
                                                                    ,pi_length => 30);

             l_dbfr_rec.dbfr_rec_id               :=  read_csv_value(pi_line   => l_file_content(c)
                                                                    ,pi_seq    => 7
                                                                    ,pi_length => 30);

             l_dbfr_rec.dbfr_x_coordinate         :=  read_csv_value(pi_line   => l_file_content(c)
                                                                    ,pi_seq    => 8
                                                                    ,pi_length => 38);

             l_dbfr_rec.dbfr_y_coordinate         :=  read_csv_value(pi_line   => l_file_content(c)
                                                                    ,pi_seq    => 9
                                                                    ,pi_length => 38);


             insert_doc_bundle_file_rel(pi_dbfr_rec  => l_dbfr_rec);
             
          END IF; -- filename is not null                                                                                    

       END LOOP; -- contents of driving file                                  
     
     END LOOP; -- list of driving files
     

END read_driving_files_in_bundle;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_docs_etc(pi_dbun_rec IN doc_bundles%ROWTYPE) IS 


 CURSOR c1(cp_bundle_id IN doc_bundles.dbun_bundle_id%TYPE) IS
 SELECT a.rowid
       ,a.dbfr_doc_filename -- filename that we will be referencing in doc manager i.e. one made to be unique
       ,b.dbf_filename -- original filename
       ,a.dbfr_doc_title       
       ,a.dbfr_doc_descr
       ,a.dbfr_doc_type
       ,a.dbfr_dlc_name
       ,c.dlc_id
       ,a.dbfr_gateway_table_name
       ,a.dbfr_rec_id
       ,a.dbfr_x_coordinate
       ,a.dbfr_y_coordinate       
       ,a.dbfr_doc_id 
       ,a.dbfr_error_text
       ,CASE WHEN  
                 (a.dbfr_gateway_table_name IS NOT NULL AND a.dbfr_rec_id IS NOT NULL) THEN
                 'Y'
             WHEN   
                 (a.dbfr_x_coordinate IS NOT NULL AND a.dbfr_y_coordinate IS NOT NULL) THEN
                 'Y'
               ELSE
                 'N'
               end enough_attributes_supplied
 FROM   doc_bundle_file_relations a
       ,doc_bundle_files b
       ,doc_locations    c
 WHERE b.dbf_bundle_id = cp_bundle_id
 AND   b.dbf_file_id   = a.dbfr_child_file_id
 AND   b.dbf_file_included_with_bundle = 'Y' -- only create a doc etc if the file was actuall supplied (rather than just referenced in a driving file)
 AND   a.dbfr_doc_id IS NULL -- i.e. cater for re-submission by not processing records for which we already have created a doc
 AND   c.dlc_name(+) = a.dbfr_dlc_name
 ORDER BY dbfr_driving_file_id, dbfr_driving_file_recno;
 
 TYPE t_tab_c1 IS TABLE OF c1%ROWTYPE INDEX BY BINARY_INTEGER;
 l_tab_c1 t_tab_c1;
 
 l_error_no   pls_integer;
 l_error_text nm3type.max_varchar2;
 
BEGIN

 hig_process_api.log_it(pi_message         => '   Creating Documents and Document Associations' 
                       ,pi_summary_flag    => 'N' );

 OPEN c1(cp_bundle_id => pi_dbun_rec.dbun_bundle_id);
 FETCH c1 BULK COLLECT INTO l_tab_c1;
 CLOSE c1;
 
 FOR d IN 1..l_tab_c1.COUNT LOOP

      --
      -- this IF statement is the only bespoke validation we do i.e. the rest is handled inside doc_api package
      -- it's to make sure that we'll at least have enough info to try to create a doc_assoc record or to tag the docs
      -- record with an x/y coordinate
      -- 
      --
      IF l_tab_c1(d).enough_attributes_supplied = 'N' THEN  
         l_tab_c1(d).dbfr_error_text := 'Gateway Table and Record ID and/or Coordinates must be supplied';
      ELSE
      
              l_tab_c1(d).dbfr_doc_id       := nm3seq.next_doc_id_seq ;

              l_tab_c1(d).dbfr_doc_filename := l_tab_c1(d).dbfr_doc_id ||'_'||l_tab_c1(d).dbf_filename;

              doc_api.create_document(
                                      ce_reference_no => l_tab_c1(d).dbfr_doc_filename
                                    , ce_title        => l_tab_c1(d).dbfr_doc_title
                                    , ce_descr        => l_tab_c1(d).dbfr_doc_descr
                                    , ce_dlc_id       => l_tab_c1(d).dlc_id
                                    , ce_file_name    => l_tab_c1(d).dbfr_doc_filename
                                    , ce_doc_type     => l_tab_c1(d).dbfr_doc_type
                                    , ce_doc_class    => Null
                                    , ce_date_issued  => to_char(sysdate, 'DD-MON-YYYY')
                                    , ce_date_expired => Null
                                    , ce_issue_number => 1
                                    , ce_x_coordinate => l_tab_c1(d).dbfr_x_coordinate
                                    , ce_y_coordinate => l_tab_c1(d).dbfr_y_coordinate                            
                                    , ce_do_commit    => FALSE
                                    , ce_doc_id       => l_tab_c1(d).dbfr_doc_id
                                    , error_value     => l_error_no
                                    , error_text      => l_error_text
                                    );

              IF l_tab_c1(d).dbfr_doc_id IS NOT NULL AND l_error_no IS NULL AND (l_tab_c1(d).dbfr_gateway_table_name IS NOT NULL OR l_tab_c1(d).dbfr_rec_id IS NOT NULL) THEN
              
              
                doc_api.create_doc_assoc
                                       (
                                         ce_doc_id     => l_tab_c1(d).dbfr_doc_id  
                                       , ce_table_name => l_tab_c1(d).dbfr_gateway_table_name
                                       , ce_unique_id  => l_tab_c1(d).dbfr_rec_id
                                       , ce_do_commit  => FALSE
                                       , error_value   => l_error_no  
                                       , error_text    => l_error_text
                                       );
                                       
              END IF;

              l_tab_c1(d).dbfr_error_text :=  SUBSTR(nm3flx.parse_error_message(l_error_text),1,500);

      END IF;      
      
      --
      -- note that on error l_tab_c1(d).dbfr_doc_id is set back to null which is good co we don't
      -- want to give the impression that a doc was created if it wasn't 
      --
      UPDATE doc_bundle_file_relations
      SET    dbfr_error_text   = l_tab_c1(d).dbfr_error_text
            ,dbfr_doc_id       = case when l_tab_c1(d).dbfr_error_text is null then
                                        l_tab_c1(d).dbfr_doc_id
                                      else
                                        null
                                      end
            ,dbfr_doc_filename = l_tab_c1(d).dbfr_doc_filename
      WHERE  rowid             = l_tab_c1(d).rowid;



      COMMIT;                           
  
 END LOOP;
 
END create_docs_etc;
--
-----------------------------------------------------------------------------
--
PROCEDURE move_files_to_destination(pi_dbun_rec IN doc_bundles%ROWTYPE) IS

 l_tab_files      hig_file_transfer_api.g_tab_files;
 l_htfq_batch_no  hig_file_transfer_queue.hftq_batch_no%TYPE;

 CURSOR c1(cp_bundle_id IN doc_bundles.dbun_bundle_id%TYPE) IS
 SELECT c.dbun_unzip_location                 from_path
       ,c_unzip_subdir_prefix||dbun_bundle_id source 
       ,b.dbf_filename                        source_filename
       ,b.dbf_blob                            content
       ,a.dbfr_doc_filename                   destination_filename
       ,d.dlc_location_type                   destination_type
       ,d.dlc_location_name                   destination
       ,e.dlt_content_col                     destination_column
       ,case when e.dlt_doc_id_col is not null then
               dlt_doc_id_col||'='||a.dbfr_doc_id
             else
               null
             end              condition           
       ,a.dbfr_doc_id         doc_id
       ,a.rowid       
 FROM   doc_bundle_file_relations a
       ,doc_bundle_files b
       ,doc_bundles      c
       ,doc_locations    d
       ,doc_location_tables e       
 WHERE c.dbun_bundle_id = cp_bundle_id
 AND   b.dbf_bundle_id = c.dbun_bundle_id
 AND   b.dbf_file_id   = a.dbfr_child_file_id
 AND   d.dlc_name      = a.dbfr_dlc_name
 AND   a.dbfr_doc_id IS NOT NULL  
 AND   a.dbfr_error_text IS NULL
 AND   a.dbfr_hftq_batch_no IS NULL -- i.e. cater for re-submission by not processing records for which we already initiated a transfer
 AND   e.dlt_dlc_id(+) = d.dlc_id -- outer join cos not all doc_locations have a corresponding entry in doc_location_tables 
 ORDER BY dbfr_doc_filename;

 TYPE t_tab_c1 IS TABLE OF c1%ROWTYPE INDEX BY BINARY_INTEGER;
 l_tab_c1 t_tab_c1;



 PROCEDURE insert_file_record_for_doc(pi_filename IN docs.doc_file%TYPE
                                     ,pi_doc_id   IN docs.doc_id%TYPE) IS

      l_rec_file_record doc_locations_api.rec_file_record; 
 
 BEGIN

      l_rec_file_record.doc_id          := pi_doc_id;
      l_rec_file_record.start_date      := Null; 
      l_rec_file_record.full_path       := Null;
      l_rec_file_record.filename        := pi_filename;

      doc_locations_api.insert_file_record(pi_rec_df=>l_rec_file_record);

END insert_file_record_for_doc;
 
 
BEGIN

 hig_process_api.log_it(pi_message         => '   Submitting Files for Transfer to Document Location(s)' 
                       ,pi_summary_flag    => 'N' );


 OPEN c1(cp_bundle_id => pi_dbun_rec.dbun_bundle_id);
 FETCH c1 BULK COLLECT INTO l_tab_c1;
 CLOSE c1;

 FOR f IN 1..l_tab_c1.COUNT LOOP

    IF l_tab_c1(f).destination_type = 'TABLE' THEN

        insert_file_record_for_doc(pi_filename => l_tab_c1(f).destination_filename
                                  ,pi_doc_id   => l_tab_c1(f).doc_id);   
    
    END IF;

    l_tab_files(f).source                 := l_tab_c1(f).source;
    l_tab_files(f).source_type            := 'ORACLE_DIRECTORY';
    l_tab_files(f).source_filename        := l_tab_c1(f).source_filename;
    l_tab_files(f).destination            := l_tab_c1(f).destination; 
    l_tab_files(f).destination_type       := l_tab_c1(f).destination_type; -- 'TABLE','URL','ORACLE DIRECTORY'
    l_tab_files(f).destination_column     := l_tab_c1(f).destination_column; 
    l_tab_files(f).destination_filename   := l_tab_c1(f).destination_filename;
    l_tab_files(f).condition              := l_tab_c1(f).condition;
    l_tab_files(f).content                := l_tab_c1(f).content;
    l_tab_files(f).comments               := 'Initiated via '||c_process_type_name;
    l_tab_files(f).process_id             := hig_process_api.get_current_process_id;


 END LOOP;


 IF l_tab_files.COUNT > 0 THEN

      --
      -- set a flag on doc_bundle_file_relations to indicate whether file transfer requested
      --
      hig_file_transfer_api.add_files_to_queue ( pi_tab_files     => l_tab_files 
                                               , po_hftq_batch_no => l_htfq_batch_no);


      --
      --
      --                                       
      hig_file_transfer_api.process_file_queue(pi_hftq_batch_no => l_htfq_batch_no);

      --
      -- note that on error l_tab_c1(d).dbfr_doc_id is set back to null which is good co we don't
      -- want to give the impression that a doc was created if it wasn't 
      --
      FOR f IN 1..l_tab_c1.COUNT LOOP
          UPDATE doc_bundle_file_relations
          SET    dbfr_hftq_batch_no = l_htfq_batch_no
          WHERE  rowid             = l_tab_c1(f).rowid;
      END LOOP;    


 END IF;
 
 commit;                                         

END move_files_to_destination;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_doc_bundles(pi_process_id IN hig_processes.hp_process_id%TYPE DEFAULT hig_process_api.get_current_process_id) IS

 l_document_bundles hig_process_api.tab_process_files;

 l_success BOOLEAN;
 l_failure BOOLEAN;

BEGIN

 l_document_bundles := hig_process_api.get_current_process_in_files;
 
 hig_process_api.log_it(pi_message => l_document_bundles.count||' document bundles to process');

 FOR f IN 1..l_document_bundles.COUNT LOOP
 
  l_success := load_document_bundle(pi_filename         => l_document_bundles(f).hpf_filename
                                   ,pi_oracle_directory => l_document_bundles(f).hpf_destination
                                   ,pi_process_id       => pi_process_id );
                                   
  IF NOT l_success THEN
     l_failure := TRUE;
  END IF;                                   
 
 END LOOP;
 
 IF l_failure THEN
   hig_process_api.process_execution_end(pi_success_flag => 'N'
                                        ,pi_force        => TRUE);
 END IF;                                         

END load_doc_bundles;
--
-----------------------------------------------------------------------------
--
FUNCTION files_processed_successfully(pi_bundle_id IN doc_bundles.dbun_bundle_id%TYPE) RETURN BOOLEAN IS


 CURSOR c1(cp_bundle_id IN doc_bundles.dbun_bundle_id%TYPE) IS
 SELECT 1
 FROM   doc_bundle_files_v
 WHERE  dbf_bundle_id = cp_bundle_id
 AND    error_stage is not null;
 
 l_retval boolean;
 l_dummy  pls_integer;
 
BEGIN

 OPEN c1(cp_bundle_id => pi_bundle_id);
 FETCH c1 INTO l_dummy;
 l_retval := c1%NOTFOUND;
 CLOSE c1;
 
 RETURN l_retval;

END files_processed_successfully;
--
-----------------------------------------------------------------------------
--
FUNCTION bundle_filename_unique(pi_filename IN doc_bundles.dbun_filename%TYPE) RETURN BOOLEAN IS

 CURSOR c1 IS
 SELECT COUNT(dbun_bundle_id)
 FROM   doc_bundles
 WHERE  dbun_filename = pi_filename;
 
 l_count pls_integer;
 
BEGIN

 OPEN c1;
 FETCH c1 INTO l_count;
 CLOSE c1;

 RETURN l_count = 0;


END bundle_filename_unique;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_bundle_filename_unique(pi_filename IN doc_bundles.dbun_filename%TYPE) IS
 
 l_ner_rec nm_errors%ROWTYPE;

BEGIN

 l_ner_rec := nm3get.get_ner(pi_ner_appl => 'DOC'
                            ,pi_ner_id   => 1);  -- A Document Bundle of this name already exists

 IF NOT bundle_filename_unique(pi_filename => pi_filename) THEN
   RAISE_APPLICATION_ERROR(-20001,l_ner_rec.ner_descr);                                   
 END IF;

END check_bundle_filename_unique;
--
-----------------------------------------------------------------------------
--
FUNCTION load_document_bundle(pi_filename                   IN doc_bundles.dbun_filename%TYPE
                             ,pi_oracle_directory           IN doc_bundles.dbun_location%TYPE
                             ,pi_process_id                 IN hig_processes.hp_process_id%TYPE) RETURN BOOLEAN IS

 l_dbun_rec doc_bundles%ROWTYPE;
 
 l_retval BOOLEAN := FALSE;
 l_sqlerrm varchar2(500);  
 

 

 PROCEDURE bundle_success IS
 
 BEGIN
  
     UPDATE doc_bundles
     SET    dbun_success_flag = 'Y' 
           ,dbun_error_text   = Null
     WHERE  dbun_bundle_id    =  l_dbun_rec.dbun_bundle_id;
     
     COMMIT;          

 END;
 
 PROCEDURE bundle_failure(pi_error_text IN VARCHAR2) IS
 
 BEGIN
  
     MERGE INTO  doc_bundles a
     USING  ( SELECT   l_dbun_rec.dbun_bundle_id dbun_bundle_id
                     , l_dbun_rec.dbun_filename  dbun_filename
                     , l_dbun_rec.dbun_process_id dbun_process_id
                     , 'N'                       dbun_success_flag
                     , pi_error_text            dbun_error_text
              FROM dual) b
     ON (a.dbun_bundle_Id = b.dbun_bundle_id)
     WHEN MATCHED THEN
     UPDATE SET a.dbun_success_flag = b.dbun_success_flag
               ,a.dbun_error_text   = dbun_error_text 
     WHEN NOT MATCHED THEN
       INSERT (a.dbun_bundle_id, a.dbun_filename, a.dbun_process_id, a.dbun_success_flag, a.dbun_error_text)
       VALUES (b.dbun_bundle_id, b.dbun_filename, b.dbun_process_id, b.dbun_success_flag, b.dbun_error_text);       
     
     COMMIT;          

 END; 
 
 

BEGIN


 hig_process_api.log_it(pi_message => 'Processing '||pi_filename);

--
-- start to compose DOC_BUNDLE record type
--
  l_dbun_rec.dbun_filename   := pi_filename;
  l_dbun_rec.dbun_bundle_id  := nm3ddl.sequence_nextval('dbun_bundle_id_seq');
  l_dbun_rec.dbun_process_id := pi_process_id;


--
-- Check the integrity of the filename and if it's been submitted before then bomb out
-- 
  check_bundle_filename_unique(pi_filename => pi_filename); -- not trapped by unique constraint on the table cos we want to actually throw a record into the doc_bundles_table so we an have an error against it

    l_dbun_rec.dbun_location   := nm3file.get_true_dir_name
                                                             (
                                                              pi_loc       => pi_oracle_directory
                                                             ,pi_use_hig   => FALSE
                                                             );
                                                           
                                                                   

  l_dbun_rec.dbun_unzip_location   := l_dbun_rec.dbun_location||c_unzip_subdir_prefix||l_dbun_rec.dbun_bundle_id;
                                                           

--
-- insert DOC_BUNDLE record
--  
  insert_doc_bundle(pi_dbun_rec => l_dbun_rec);

  COMMIT; -- let's commit the records we've created up to this point before we start to process the actual data


 
--
-- unzip the physical file
--   
  unzip_document_bundle(pi_dbun_rec         => l_dbun_rec);


--
-- Read files in unzip location and write to DOC_BUNDLE_FILES
--
  list_files_in_unzip_location(pi_dbun_rec => l_dbun_rec);


--
-- Loop through all the driving files and extract the details
--
  read_driving_files_in_bundle(pi_dbun_rec => l_dbun_rec);


--
-- Create DOC and DOC_ASSOC records
--
  create_docs_etc(pi_dbun_rec => l_dbun_rec);



--
-- Initiate a transfer
--
  move_files_to_destination(pi_dbun_rec => l_dbun_rec);


--
-- Archive any files
--
 hig_process_api.log_it(pi_message         => '   Archiving Files' 
                       ,pi_summary_flag    => 'N' );

  doc_locations_api.archive_doc_bundle_files(pi_doc_bundle_id => l_dbun_rec.dbun_bundle_id);

--
-- remove the unzip location and the .zip 
--
  IF files_processed_successfully(pi_bundle_id => l_dbun_rec.dbun_bundle_id) THEN

     bundle_success;          
     l_retval := TRUE;
  ELSE
     bundle_failure(pi_error_text => 'See file(s)');
     l_retval := FALSE;
      
  END IF;
  
  RETURN l_retval;
  
  
EXCEPTION

 WHEN others THEN
     l_sqlerrm := substr(nm3flx.parse_error_message(sqlerrm),1,500);
     rollback;
     bundle_failure(pi_error_text => l_sqlerrm);
     RETURN(FALSE);
  

END load_document_bundle;
-- 
-----------------------------------------------------------------------------
--
FUNCTION discards_driving_file_as_clob(pi_bundle_id IN doc_bundles.dbun_bundle_id%TYPE) RETURN CLOB IS

   CURSOR c_log_text IS
    SELECT  chr(34)||b.dbf_filename||chr(34)
          ||chr(44)
          ||case when a.dbfr_doc_title IS NOT NULL THEN
                 chr(34)||a.dbfr_doc_title||chr(34)
            else
              null
            end
          ||chr(44)
          ||case when a.dbfr_doc_descr IS NOT NULL THEN
                 chr(34)||a.dbfr_doc_descr||chr(34)
            else
              null
            end
          ||chr(44)
          ||case when a.dbfr_doc_type IS NOT NULL THEN
                 chr(34)||a.dbfr_doc_type||chr(34)
            else
              null
            end
          ||chr(44)
          ||case when a.dbfr_dlc_name IS NOT NULL THEN
                 chr(34)||a.dbfr_dlc_name||chr(34)
            else
              null
            end
          ||chr(44)
          ||case when a.dbfr_gateway_table_name IS NOT NULL THEN
                 chr(34)||a.dbfr_gateway_table_name||chr(34)
            else
              null
            end
          ||chr(44)
          ||case when a.dbfr_rec_id IS NOT NULL THEN
                 chr(34)||a.dbfr_rec_id||chr(34)
            else
              null
            end
          ||chr(44)
          ||case when a.dbfr_x_coordinate IS NOT NULL THEN
                 chr(34)||a.dbfr_x_coordinate||chr(34)
            else
              null
            end
          ||chr(44)
          ||case when a.dbfr_y_coordinate IS NOT NULL THEN
                 chr(34)||a.dbfr_y_coordinate||chr(34)
            else
              null
            end
           ||chr(10)                                                
    from doc_bundle_file_relations a
        ,doc_bundle_files b
    where b.dbf_bundle_id = pi_bundle_id 
    and   a.dbfr_child_file_id(+) = b.dbf_file_id
    and   a.dbfr_doc_id is null
    and   b.dbf_driving_file_flag = 'N'
    order by a.dbfr_driving_file_id, b.dbf_filename;


   l_tab_c_text nm3type.tab_varchar32767;
      
BEGIN

  OPEN c_log_text;
  FETCH c_log_text BULK COLLECT INTO l_tab_c_text;
  CLOSE c_log_text;

  RETURN(nm3clob.tab_varchar_to_clob (pi_tab_vc => l_tab_c_text));


END discards_driving_file_as_clob;
--
-----------------------------------------------------------------------------
--
FUNCTION discards_driving_file_as_blob(pi_bundle_id IN doc_bundles.dbun_bundle_id%TYPE) RETURN BLOB IS

   l_tab_c_text nm3type.tab_varchar32767;
   
BEGIN

 RETURN(
         nm3clob.clob_to_blob(discards_driving_file_as_clob(pi_bundle_id => pi_bundle_id))
       );

END discards_driving_file_as_blob;
--
-----------------------------------------------------------------------------
--
PROCEDURE discards_to_temp_table(pi_bundle_id IN doc_bundles.dbun_bundle_id%TYPE) IS

 l_blob blob;
 
 CURSOR c_failed_files IS
 select rownum       id
       ,dbf_filename filename
       ,dbf_blob     the_blob
   from doc_bundle_files a
  where dbf_bundle_id = pi_bundle_id
    and exists (select 1
                from doc_bundle_files_v b
                where a.dbf_file_Id = b.dbf_file_id
                and   b.error_stage is not null)
    and dbf_blob is not null;            
    

    TYPE t_tab_dbf_filename IS TABLE OF doc_bundle_files.dbf_filename%TYPE;
    TYPE t_tab_dbf_blob     IS TABLE OF doc_bundle_files.dbf_blob%TYPE;

    l_tab_id       nm3type.tab_number;
    l_tab_filename t_tab_dbf_filename;
    l_tab_the_blob t_tab_dbf_blob;    
     
 
BEGIN

  delete from  doc_bundle_discard_blobs;


  l_blob := discards_driving_file_as_blob(pi_bundle_id => pi_bundle_id);
  
  IF l_blob IS NOT NULL THEN

    insert into doc_bundle_discard_blobs(id
                                        ,filename
                                        ,the_blob
                                        )
                                   values(-1
                                        ,'bundle_'||pi_bundle_id||'_discards.driving'
                                        ,l_blob
                                        );
                                                                                 
  END IF;
  
  OPEN c_failed_files;
  FETCH c_failed_files BULK COLLECT INTO l_tab_id, l_tab_filename, l_tab_the_blob;
  CLOSE c_failed_files;
  
  FORALL f IN 1..l_tab_filename.COUNT
    insert into doc_bundle_discard_blobs(
                                         id
                                        ,filename
                                        ,the_blob
                                        )
                                   values(
                                          l_tab_id(f)
                                         ,l_tab_filename(f)
                                         ,l_tab_the_blob(f)
                                         );   
--commit;

END discards_to_temp_table;
--
-----------------------------------------------------------------------------
--
PROCEDURE initialise IS

 l_ok_to_proceed BOOLEAN;

BEGIN

  hig_process_api.log_it(pi_message => LTRIM(g_package_name||' '||get_body_Version)
                        ,pi_summary_flag => 'N');

  l_ok_to_proceed :=  hig_process_api.do_polling_if_requested(pi_file_type_name          => c_file_type_name
                                                            , pi_file_mask               => 'ZIP'
                                                            , pi_binary                  => TRUE
                                                            , pi_archive_overwrite       => TRUE
                                                            , pi_remove_failed_arch      => TRUE);

  IF l_ok_to_proceed THEN

    load_doc_bundles;
   
  END IF;
  
     
END initialise;

END doc_bundle_loader;
/
