CREATE OR REPLACE PACKAGE BODY nm3clob AS
--
-----------------------------------------------------------------------------
--
-- PVCS Identifiers :-
--
-- pvcsid : $Header:   //vm_latest/archives/nm3/admin/pck/nm3clob.pkb-arc   2.5   Jul 04 2013 15:23:06   James.Wadsworth  $
-- Module Name : $Workfile:   nm3clob.pkb  $
-- Date into PVCS : $Date:   Jul 04 2013 15:23:06  $
-- Date fetched Out : $Modtime:   Jul 04 2013 14:25:10  $
-- PVCS Version : $Revision:   2.5  $
-- Based on SCCS version : 1.9
--
--
--   Author : Jonathan Mills
--
--   NM3 CLOB handling package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.5  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3clob';
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
PROCEDURE execute_immediate_clob (p_clob IN clob) IS
--
   l_string             varchar2(32767);
   l_row_count          pls_integer;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'execute_immediate_clob');
--
   g_tab_vc    := clob_to_tab_varchar(p_clob);
   l_row_count := g_tab_vc.COUNT;
--
   IF    l_row_count = 0
    THEN
      NULL;
   ELSIF l_row_count = 1
    THEN
      EXECUTE IMMEDIATE g_tab_vc(l_row_count);
   ELSE
      l_string :=            'BEGIN'
                  ||CHR(10)||'   EXECUTE IMMEDIATE Null';
      FOR i IN 1..l_row_count
       LOOP
         l_string := l_string||'||nm3clob.g_tab_vc('||i||')';
      END LOOP;
      l_string :=  l_string||';'
                  ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_string;
   END IF;
--
   g_tab_vc.DELETE;
--
   nm_debug.proc_end(g_package_name,'execute_immediate_clob');
--
END execute_immediate_clob;
--
-----------------------------------------------------------------------------
--
PROCEDURE append (p_clob   IN OUT NOCOPY clob
                 ,p_append IN            varchar2
                 ) IS
BEGIN
   IF p_append IS NOT NULL
    THEN
      IF NVL(nm3clob.len(p_clob),0) = 0
       THEN
         nm3clob.create_clob(p_clob);
         dbms_lob.WRITE (lob_loc => p_clob
                        ,amount  => LENGTH(p_append)
                        ,offset  => 1
                        ,buffer  => p_append
                        );
      ELSE
         dbms_lob.writeappend(lob_loc => p_clob
                             ,amount  => LENGTH(p_append)
                             ,buffer  => p_append
                             );
      END IF;
   END IF;
END append;
--
-----------------------------------------------------------------------------
--
FUNCTION lob_substr (p_clob      IN clob
                    ,p_offset    IN number
                    ,p_num_chars IN number
                    ) RETURN varchar2 IS
BEGIN
--
   IF p_num_chars > 32767
    THEN
      RAISE_APPLICATION_ERROR(-20001,'Cannot return more than 32K of a CLOB at a time');
   END IF;
--
   RETURN dbms_lob.SUBSTR(p_clob,p_num_chars,p_offset);
--
END lob_substr;
--
-----------------------------------------------------------------------------
--
FUNCTION len (p_clob IN clob) RETURN binary_integer IS
BEGIN
   RETURN dbms_lob.getlength(p_clob);
END len;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_clob (p_clob IN OUT NOCOPY clob) IS
BEGIN
   dbms_lob.createtemporary(lob_loc => p_clob
                           ,CACHE   => FALSE
                           );
END create_clob;
--
-----------------------------------------------------------------------------
--
PROCEDURE writeclobout(result        IN clob
                      ,file_location IN varchar2 DEFAULT nm3file.c_default_location
                      ,file_name     IN varchar2
                      ) IS
--
   lob_chunk varchar2(32767);
   line      varchar2(32767);
--
   c_len CONSTANT number := len(result);
--
   l_count number := 1;
   c_chunk CONSTANT number := 32767;
--
   l_lines nm3type.tab_varchar32767;
--
   PROCEDURE write_chunk (p_chunk IN OUT NOCOPY varchar2) IS
      l_instr_pos number;
   BEGIN
--
      WHILE p_chunk IS NOT NULL
       LOOP
--
        l_instr_pos := INSTR(p_chunk,CHR(10));
--
        IF l_instr_pos = 0
         THEN -- This is the last line
           l_lines(l_lines.COUNT+1) := p_chunk;
           EXIT;
        END IF;
--
        line    := SUBSTR(p_chunk,1,l_instr_pos-1);
        l_lines(l_lines.COUNT+1) := line;
        p_chunk := SUBSTR(p_chunk,LENGTH(line)+2);
--
      END LOOP;
--
   END write_chunk;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'WriteClobOut');
--
   WHILE l_count <= c_len
    LOOP
      lob_chunk  := lob_substr(result,l_count,c_chunk);
      write_chunk(lob_chunk);
      l_count    := l_count + c_chunk;
   END LOOP;
--
   nm3file.write_file (LOCATION     => file_location
                      ,filename     => file_name
                      ,max_linesize => c_chunk
                      ,all_lines    => l_lines
                      );
--
   nm_debug.proc_end(g_package_name,'WriteClobOut');
--
END writeclobout;
--
-----------------------------------------------------------------------------
--
PROCEDURE readclobin (file_location IN     varchar2 DEFAULT nm3file.c_default_location
                     ,file_name     IN     varchar2
                     ,result           OUT NOCOPY clob
                     ,add_cr    IN boolean DEFAULT TRUE
                     ) IS
--
   c_chunk CONSTANT number := 32767;
   l_lines nm3type.tab_varchar32767;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'ReadClobIn');
--
   nm3file.get_file (LOCATION     => file_location
                    ,filename     => file_name
                    ,max_linesize => c_chunk
                    ,all_lines    => l_lines
                    ,add_cr       => add_cr
                    );
--
   FOR i IN 1..l_lines.COUNT
    LOOP
      append (result,l_lines(i));
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'ReadClobIn');
--
END readclobin;
--
-----------------------------------------------------------------------------
--
PROCEDURE trim_clob (p_clob    IN OUT NOCOPY clob
                    ,p_new_len IN            integer
                    ) IS
BEGIN
--
   IF NVL(nm3clob.len(p_clob),0) = 0
    THEN
      nm3clob.create_clob(p_clob);
   ELSE
      dbms_lob.trim(p_clob,p_new_len);
   END IF;
--
END trim_clob;
--
-----------------------------------------------------------------------------
--
PROCEDURE nullify_clob (p_clob IN OUT NOCOPY clob) IS
BEGIN
   trim_clob (p_clob,0);
END nullify_clob;
--
-----------------------------------------------------------------------------
--
FUNCTION lob_instr (lob_loc    IN   clob
                   ,pattern    IN   varchar2
                   ,offset     IN   integer DEFAULT 1
                   ,nth        IN   integer DEFAULT 1
                   ) RETURN integer IS
BEGIN
--
   RETURN dbms_lob.INSTR (lob_loc => lob_loc
                         ,pattern => pattern
                         ,offset  => offset
                         ,nth     => nth
                         );
--
END lob_instr;
--
-----------------------------------------------------------------------------
--
FUNCTION blob_to_clob(pi_blob IN blob
                     ) RETURN clob IS

  l_blob_chunk raw(32000);

  c_len CONSTANT pls_integer := dbms_lob.getlength(pi_blob);

  l_count pls_integer := 1;
  c_chunk_size CONSTANT pls_integer := 32000;

  l_retval clob;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'blob_to_clob');

  WHILE l_count <= c_len
  LOOP
    l_blob_chunk := dbms_lob.SUBSTR(lob_loc => pi_blob
                                   ,offset => l_count
                                   ,amount => c_chunk_size);

    append(p_clob   => l_retval
          ,p_append => utl_raw.cast_to_varchar2(l_blob_chunk));

    l_count := l_count + c_chunk_size;
  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'blob_to_clob');

  RETURN l_retval;

END blob_to_clob;
--
-----------------------------------------------------------------------------
--
PROCEDURE append (p_blob   IN OUT NOCOPY blob
                 ,p_append IN            varchar2
                 ) IS
BEGIN
   IF NVL(dbms_lob.getlength(p_blob),0) = 0
    THEN
      dbms_lob.createtemporary(lob_loc => p_blob
                           ,CACHE   => FALSE
                           );

      dbms_lob.WRITE (lob_loc => p_blob
                     ,amount  => LENGTH(p_append)
                     ,offset  => 1
                     ,buffer  => utl_raw.cast_to_raw(p_append)
                     );
   ELSE
      dbms_lob.writeappend(lob_loc => p_blob
                          ,amount  => LENGTH(p_append)
                          ,buffer  => utl_raw.cast_to_raw(p_append)
                          );
   END IF;
END append;
--
-----------------------------------------------------------------------------
--
FUNCTION clob_to_blob(pi_clob IN clob
                     ) RETURN blob IS

  l_clob_chunk varchar2(32767);

  c_len CONSTANT pls_integer := dbms_lob.getlength(pi_clob);

  l_count pls_integer := 1;
  c_chunk_size CONSTANT pls_integer := 32000;

  l_retval blob;


BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'blob_to_clob');

  WHILE l_count <= c_len
  LOOP
    l_clob_chunk := dbms_lob.SUBSTR(lob_loc => pi_clob
                                   ,offset => l_count
                                   ,amount => c_chunk_size);

    append(p_blob   => l_retval
          ,p_append => l_clob_chunk);

    l_count := l_count + c_chunk_size;
  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'blob_to_clob');

  RETURN l_retval;

END clob_to_blob;
--
-----------------------------------------------------------------------------
--
FUNCTION clob_to_tab_varchar (pi_clob           IN clob) RETURN nm3type.tab_varchar32767 IS
--
   l_varchar            varchar2(32767);
   c_vc_length CONSTANT pls_integer := 32767;
   l_offset             pls_integer := 1;
   c_clob_len  CONSTANT pls_integer := nm3clob.len(pi_clob);
   l_row_count          pls_integer := 0;
   l_retval             nm3type.tab_varchar32767;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'clob_to_tab_varchar');
--
   WHILE l_offset <= c_clob_len
    LOOP
      --
      l_varchar   := nm3clob.lob_substr(pi_clob,l_offset,c_vc_length);
      --
      l_row_count := l_row_count + 1;
      l_offset    := l_offset    + c_vc_length;
      --
      l_retval(l_row_count) := l_varchar;
      --
   END LOOP;
--
   l_retval := nm3tab_varchar.split_rough_chunked_tab_vc_lf (l_retval);
   
   l_retval := nm3tab_varchar.compress_tab_vc_by_lf(l_retval);
--
   nm_debug.proc_end(g_package_name,'clob_to_tab_varchar');
--
   RETURN l_retval;
--
END clob_to_tab_varchar;
--
-----------------------------------------------------------------------------
--
FUNCTION tab_varchar_to_clob (pi_tab_vc IN nm3type.tab_varchar32767) RETURN clob IS
   l_clob clob;
BEGIN
--
   FOR i IN 1..pi_tab_vc.COUNT
    LOOP
      append (p_clob   => l_clob
             ,p_append => pi_tab_vc(i)
             );
   END LOOP;
--
   RETURN l_clob;
--
END tab_varchar_to_clob;
--
-----------------------------------------------------------------------------
--
END nm3clob;
/
