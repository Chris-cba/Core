CREATE OR REPLACE PACKAGE BODY hig_audit
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/hig_audit.pkb-arc   3.5.1.0   Jun 20 2011 11:40:46   Linesh.Sorathia  $
--       Module Name      : $Workfile:   hig_audit.pkb  $
--       Date into PVCS   : $Date:   Jun 20 2011 11:40:46  $
--       Date fetched Out : $Modtime:   Jun 20 2011 10:05:04  $
--       Version          : $Revision:   3.5.1.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   3.5.1.0  $';

  g_package_name CONSTANT varchar2(30) := 'hig_audit';
  g_app_owner    CONSTANT  VARCHAR2(30) := hig.get_application_owner; 
  c_date_format  CONSTANT varchar2(30) := 'DD-Mon-YYYY HH24:MI:SS';
  g_trigger_text  Clob;
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
PROCEDURE append(pi_text     Varchar2
                ,pi_new_line Varchar2 Default 'Y' )
IS
BEGIN
--
   IF pi_new_line = 'Y'
   THEN
       g_trigger_text := g_trigger_text||CHR(10)||pi_text;
   ELSE
       g_trigger_text := g_trigger_text||' '||pi_text;
   END IF ;
--
END append;
--
PROCEDURE trg_body (pi_haut_descr  IN hig_audit_types.haut_description%TYPE
                   ,pi_operation   IN Varchar2
                   ,pi_inv_type    IN nm_inv_types.nit_inv_type%TYPE
                   ,pi_table_name  IN hig_audits.haud_table_name%TYPE
                   ,pi_attrib_name IN hig_audits.haud_attribute_name%TYPE
                   ,pi_pk_col      IN hig_audits.haud_attribute_name%TYPE
                   ,pi_date_format IN Varchar2 Default 'N')
IS
BEGIN
--
   IF pi_operation = 'Insert'
   THEN
       append ('INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )');
       append  ('Values (');
       append  ('haud_id_seq.NEXTVAL,');
       append  (''''||pi_inv_type||''',');
       append  (''''||pi_table_name||''',');
       append  (''''||pi_attrib_name||''',');
       append  (':NEW.'||pi_pk_col||',');
       append  ('Null,');
       append  ('Null,');
       append  ('Sysdate,');
       append  ('''I'',');
       append  ('nm3user.get_user_id,');
       append  ('sys_context(''USERENV'',''TERMINAL''),');
       append  ('sys_context(''USERENV'',''OS_USER''),');
       append  (''''||pi_haut_descr||''');');
   ELSIF pi_operation = 'Delete'
   THEN  
       append ('INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )');
       append  ('Values (');
       append  ('haud_id_seq.NEXTVAL,');
       append  (''''||pi_inv_type||''',');
       append  (''''||pi_table_name||''',');
       append  (''''||pi_attrib_name||''',');
       append  (':OLD.'||pi_pk_col||',');
       append  ('Null,');
       append  ('Null,');
       append  ('Sysdate,');
       append  ('''D'',');
       append  ('nm3user.get_user_id,');
       append  ('sys_context(''USERENV'',''TERMINAL''),');
       append  ('sys_context(''USERENV'',''OS_USER''),');
       append  (''''||pi_haut_descr||''');');
   ELSE
       append ('INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )');
       append  ('Values (');
       append  ('haud_id_seq.NEXTVAL,');
       append  (''''||pi_inv_type||''',');
       append  (''''||pi_table_name||''',');
       append  (''''||pi_attrib_name||''',');
       append  (':OLD.'||pi_pk_col||',');
       IF pi_date_format = 'Y'
       THEN
           append  ('To_Char(Trunc(:OLD.'||pi_attrib_name||'),''DD-MON-YYYY''),');        
           append  ('To_Char(Trunc(:NEW.'||pi_attrib_name||'),''DD-MON-YYYY''),');
       ELSE
           append  (':OLD.'||pi_attrib_name||',');        
           append  (':NEW.'||pi_attrib_name||',');         
       END IF ;
       append  ('Sysdate,');
       append  ('''U'',');
       append  ('nm3user.get_user_id,');
       append  ('sys_context(''USERENV'',''TERMINAL''),');
       append  ('sys_context(''USERENV'',''OS_USER''),');
       append  (''''||pi_haut_descr||''');');
   END IF;
--
END trg_body;
--
FUNCTION create_trigger(pi_haut_id     IN  hig_audit_types.haut_id%TYPE
                       ,po_error_text OUT Varchar2 ) RETURN Boolean
IS
--
   l_cnt            Number := 0 ;
    l_trigger_name   Varchar2(30) ; 
   l_tab_level      Boolean ;
   l_trg_cnt        Number ;
   l_old_new        Varchar2(10) ;
   l_nit_rec        nm_inv_types%ROWTYPE;
   l_when_condition Boolean ;
--
BEGIN
--
--nm_debug.debug_on;
   g_trigger_text :=  Null ;
   IF pi_haut_id IS NOT NULL
   THEN        
        FOR haua IN (SELECT * FROM hig_audit_types WHERE haut_id = pi_haut_id)
        LOOP           
            l_tab_level := True;
            l_when_condition := False;
            IF haua.haut_trigger_name IS NOT NULL
            THEN
                l_trigger_name := haua.haut_trigger_name;
            ELSE
                l_trigger_name := Substr(haua.haut_table_name,1,24); 
                l_trigger_name := l_trigger_name ||'_aud'; 
                -- derive the new sequence for the trigger
                FOR i in 1..99 
                LOOP 
                    BEGIN
                       SELECT 1
                       INTO   l_trg_cnt 
                       FROM   hig_audit_types
                       WHERE  haut_nit_inv_type  = haua.haut_nit_inv_type
                       AND    haut_table_name    = haua.haut_table_name 
                       AND    haut_trigger_name  = Upper(l_trigger_name||i) ;
                    EXCEPTION
                       WHEN OTHERS THEN
                           l_trigger_name := Upper(l_trigger_name||i) ;
                           Exit;
                    END ;
                END LOOP;
                UPDATE hig_audit_types
                SET    haut_trigger_name = l_trigger_name 
                WHERE  haut_id           = pi_haut_id ;
            END IF ;
            l_nit_rec := nm3get.get_nit(haua.haut_nit_inv_type);                          
            append('CREATE OR REPLACE TRIGGER '||g_app_owner||'.'||l_trigger_name,'N');
            append('AFTER') ;
            append(haua.haut_operation,'N');
            l_cnt := 0 ;
            FOR haat IN (SELECT * FROM hig_audit_attributes WHERE haat_haut_id = pi_haut_id)
            LOOP
                l_cnt := l_cnt + 1;
                IF l_cnt = 1
                THEN
                    append('OF '||haat.haat_attribute_name);
                ELSE
                    append(','||haat.haat_attribute_name,'N'); 
                END IF ; 
                l_tab_level := False;
            END LOOP;    
            append('ON '||haua.haut_table_name);
            append('For Each Row');
            l_cnt := 0 ;
            FOR hac IN (SELECT * FROM hig_audit_conditions WHERE hac_haut_id = pi_haut_id)
            LOOP
                l_when_condition := True;
                l_cnt := l_cnt + 1;
                IF l_cnt = 1
                THEN
                    append('WHEN');  
                    append('('); 
                ELSE
                    append('AND');
                END IF ;
                IF hac.hac_old_new_type = 'O'
                THEN
                    append (hac.hac_pre_bracket,'N');
                    IF hac.hac_condition IN ( 'IS NULL','IS NOT NULL')
                    THEN
                        append('(OLD.'||hac.hac_attribute_name||' '||hac.hac_condition||')' );
                    ELSE
                        append('(OLD.'||hac.hac_attribute_name||' '||hac.hac_condition||' '''||hac.hac_attribute_value||''')' );
                    END IF ;
                    append (hac.hac_post_bracket,'N');
                ELSIF hac.hac_old_new_type = 'N'
                THEN
                    append (hac.hac_pre_bracket,'N');
                    IF hac.hac_condition IN ( 'IS NULL','IS NOT NULL')
                    THEN
                        append('(NEW.'||hac.hac_attribute_name||' '||hac.hac_condition||')' );
                    ELSE
                        append('(NEW.'||hac.hac_attribute_name||' '||hac.hac_condition||' '''||hac.hac_attribute_value||''')' );
                    END IF ;                    
                    append (hac.hac_post_bracket,'N');
                ELSE
                    append (hac.hac_pre_bracket,'N');
                    IF hac.hac_condition IN ( 'IS NULL','IS NOT NULL')
                    THEN
                        append('(OLD.'||hac.hac_attribute_name||' '||hac.hac_condition||' OR ' );
                        append(' NEW.'||hac.hac_attribute_name||' '||hac.hac_condition||  ' )' );
                    ELSE
                        append('(OLD.'||hac.hac_attribute_name||' '||hac.hac_condition||' '''||hac.hac_attribute_value||''' OR ' );
                        append(' NEW.'||hac.hac_attribute_name||' '||hac.hac_condition||' '''||hac.hac_attribute_value||''')' );
                    END IF ;
                    append (hac.hac_post_bracket,'N'); 
                END IF ;
            END LOOP;          
            IF l_when_condition
            THEN
                append(')'); 
            END IF ;
            append('DECLARE');
            append ('--');
            append ('-- Auditing Trigger for '||haua.haut_table_name);
            append ('-- Generated '||TO_CHAR(SYSDATE,c_date_format));
            append ('-- automatically by '||g_package_name);
            append ('-- '||g_package_name||' version information');
            append ('-- Header : '||get_version);
            append ('-- Body   : '||get_body_version);
            append ('BEGIN');
            IF  haua.haut_operation = 'Update'             
            THEN
                IF l_tab_level
                THEN
                    FOR ita IN (SELECT * FROM nm_inv_type_attribs WHERE ita_inv_type = l_nit_rec.nit_inv_type)
                    LOOP
                        IF ita.ita_format = 'DATE'
                        THEN
                            append  ('IF Nvl(:OLD.'||ita.ita_attrib_name||',Trunc(Sysdate+9999)) != '); append  ('Nvl(:NEW.'||ita.ita_attrib_name||',Trunc(Sysdate+9999))','N');
                        ELSIF ita.ita_format = 'VARCHAR2'
                        THEN
                            append  ('IF Nvl(:OLD.'||ita.ita_attrib_name||',''$$$$$$$'') != '); append  ('Nvl(:NEW.'||ita.ita_attrib_name||',''$$$$$$$'')','N');
                        ELSIF ita.ita_format = 'NUMBER'
                        THEN
                            append  ('IF Nvl(:OLD.'||ita.ita_attrib_name||',-9999999999) != '); append  ('Nvl(:NEW.'||ita.ita_attrib_name||',-9999999999)','N');                        
                        END IF ;
                        append  ('THEN');
                        IF ita.ita_format = 'DATE'
                        THEN
                            trg_body(haua.haut_description,haua.haut_operation,l_nit_rec.nit_inv_type,haua.haut_table_name,ita.ita_attrib_name,l_nit_rec.nit_foreign_pk_column,'Y') ;
                        ELSE
                            trg_body(haua.haut_description,haua.haut_operation,l_nit_rec.nit_inv_type,haua.haut_table_name,ita.ita_attrib_name,l_nit_rec.nit_foreign_pk_column) ;   
                        END IF ;
                        append  ('END IF;'); 
                    END LOOP;
                ELSE             
                    FOR haat IN (SELECT * FROM hig_audit_attributes,nm_inv_type_attribs 
                                 WHERE  haat_haut_id = pi_haut_id
                                 AND    ita_inv_type = haua.haut_nit_inv_type
                                 AND    haat_attribute_name = ita_attrib_name)
                    LOOP
                        IF haat.ita_format = 'DATE'
                        THEN
                            append  ('IF Nvl(:OLD.'||haat.ita_attrib_name||',Trunc(Sysdate+9999)) != '); append  ('Nvl(:NEW.'||haat.ita_attrib_name||',Trunc(Sysdate+9999))','N');
                        ELSIF haat.ita_format = 'VARCHAR2'
                        THEN
                            append  ('IF Nvl(:OLD.'||haat.ita_attrib_name||',''$$$$$$$'') != '); append  ('Nvl(:NEW.'||haat.ita_attrib_name||',''$$$$$$$'')','N');
                        ELSIF haat.ita_format = 'NUMBER'
                        THEN
                            append  ('IF Nvl(:OLD.'||haat.ita_attrib_name||',-9999999999) != '); append  ('Nvl(:NEW.'||haat.ita_attrib_name||',-9999999999)','N');                        
                        END IF ;
                        append  ('THEN');
                        IF haat.ita_format = 'DATE'
                        THEN
                            trg_body(haua.haut_description,haua.haut_operation,l_nit_rec.nit_inv_type,haua.haut_table_name,haat.haat_attribute_name,l_nit_rec.nit_foreign_pk_column,'Y');
                        ELSE
                            trg_body(haua.haut_description,haua.haut_operation,l_nit_rec.nit_inv_type,haua.haut_table_name,haat.haat_attribute_name,l_nit_rec.nit_foreign_pk_column) ;
                        END IF ;
                        append  ('END IF;');
                    END LOOP;
                END IF ;
            ELSE
                trg_body(haua.haut_description,haua.haut_operation,l_nit_rec.nit_inv_type,haua.haut_table_name,l_nit_rec.nit_foreign_pk_column,l_nit_rec.nit_foreign_pk_column) ;
            END IF ;
            append ('END;');
        END LOOP;                
       g_trigger_text := Substr(g_trigger_text,2);
--nm_debug.debug(l_trigger_name);
--nm_debug.debug(g_trigger_text||g_trigger_text1);
--nm_debug.debug(Length(g_trigger_text));
       nm3clob.execute_immediate_clob(g_trigger_text); 
       Commit;
       g_trigger_text :=  Null ;
   END IF ; 
   Return True;
EXCEPTION
   WHEN OTHERS THEN
       po_error_text := sqlerrm;       
       BEGIN
       --
          UPDATE hig_audit_types
          SET    haut_trigger_name = Null
          WHERE  haut_id           = pi_haut_id ;
          Commit ;
          Execute Immediate 'Drop Trigger '||l_trigger_name;
       -- 
       EXCEPTION
           WHEN OTHERS THEN
                NULL;
       END ;
       Return False;
--
END create_trigger;
--
FUNCTION get_trigger_status(pi_trigger_name hig_audit_types.haut_trigger_name%TYPE) 
RETURN varchar2
IS
--
   CURSOR c_get_status
   IS
   SELECT Initcap(status)
   FROM   user_triggers
   WHERE  trigger_name = Upper(pi_trigger_name);
 
   l_status Varchar2(50);
--
BEGIN
--
   OPEN  c_get_status;
   FETCH c_get_status INTO l_status;
   CLOSE c_get_status;

   RETURN l_status ;
--
END get_trigger_status ;
--
FUNCTION drop_trigger(pi_haut_id       IN  hig_audit_types.haut_id%TYPE
                     ,pi_trigger_name IN  hig_audit_types.haut_trigger_name%TYPE
                     ,po_error_text   OUT Varchar2) 
RETURN Boolean
IS
BEGIN
--
   UPDATE hig_audit_types
   SET    haut_trigger_name = Null 
   WHERE  haut_id           = pi_haut_id ;

   Execute Immediate 'DROP TRIGGER '||pi_trigger_name;
 
   Commit ;
   
   Return True;
--
EXCEPTION
    WHEN OTHERS THEN
    po_error_text := sqlerrm;
    Return False; 
END ;
--
FUNCTION audit_available (pi_table_name IN Varchar2,pi_pk_id Varchar2)
Return Boolean
IS
--
   CURSOR c_check_audit
   IS
   SELECT 'x'
   FROM   hig_audits
   WHERE  haud_table_name = Upper(pi_table_name)
   AND    haud_pk_id      = pi_pk_id 
   AND    rownum = 1;

   l_rec Varchar2(1);
   l_found Boolean ;
--
BEGIN
--
   OPEN  c_check_audit;
   FETCH c_check_audit INTO l_rec;
   l_found := c_check_audit%FOUND;
   CLOSE c_check_audit;

   Return l_found ;
END audit_available ;
--
FUNCTION security_check(pi_category       IN Varchar2
                       ,pi_table_name     IN Varchar2
                       ,pi_pk_column_name IN Varchar2
                       ,pi_pk_id          IN Varchar2)  
RETURN Number
IS
--
   l_cnt Number := 0 ;  
--
BEGIN
   IF pi_category = 'I'
   THEN
       EXECUTE IMMEDIATE 'SELECT Count(0) FROM nm_inv_item_all WHERE iit_ne_id = :1 ' INTO l_cnt USING pi_pk_id;
   ELSIF pi_table_name IS NOT NULL AND pi_pk_column_name IS NOT NULL
   THEN
       EXECUTE IMMEDIATE 'SELECT Count(0) FROM '||pi_table_name||' WHERE '||pi_pk_column_name||' = :1 ' INTO l_cnt USING pi_pk_id;
   ELSE
       l_cnt := 0;
   END IF ;
   
   Return l_cnt ;
EXCEPTION
   WHEN OTHERS THEN
   Return 0;
END security_check;
--
END hig_audit;
/
