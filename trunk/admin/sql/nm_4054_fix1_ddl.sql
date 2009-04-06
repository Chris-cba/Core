BEGIN
 EXECUTE IMMEDIATE ('CREATE TABLE hig_user_contacts_all '||
                    ' ( '||
                    ' huc_ID              NUMBER          ,     '||
                    ' huc_hus_user_id     Number Not Null ,     '||
                    ' huc_ADDRESS1       VARCHAR2(35),          '||
                    ' huc_ADDRESS2       VARCHAR2(35),          '||
                    ' huc_ADDRESS3       VARCHAR2(35),          '||
                    ' huc_ADDRESS4       VARCHAR2(35),          '||
                    ' huc_ADDRESS5       VARCHAR2(35),          '||
                    ' huc_tel_type_1     VARCHAR2(30),          '||
                    ' huc_TELEPHONE_1    VARCHAR2(30),          '||
                    ' huc_primary_tel_1  Varchar2(1),           '||
                    ' huc_tel_type_2     VARCHAR2(30),          '||
                    ' huc_TELEPHONE_2    VARCHAR2(30),          '||
                    ' huc_primary_tel_2  Varchar2(1),           '|| 
                    ' huc_tel_type_3     VARCHAR2(30),          '|| 
                    ' huc_TELEPHONE_3    VARCHAR2(30),          '||
                    ' huc_primary_tel_3  Varchar2(1),           '||
                    ' huc_tel_type_4     VARCHAR2(30),          '||
                    ' huc_TELEPHONE_4    VARCHAR2(30),          '||
                    ' huc_primary_tel_4  Varchar2(1),           '|| 
                    ' huc_POSTCODE       VARCHAR2(30),          '||
                    ' huc_DATE_CREATED   DATE  NOT NULL,        '||
                    ' huc_DATE_MODIFIED  DATE NOT NULL,         '||
                    ' huc_MODIFIED_BY    VARCHAR2(30) NOT NULL, '||
                    ' huc_CREATED_BY     VARCHAR2(30) NOT NULL  '||
                    ')');
EXCEPTION
  WHEN others THEN 
   Null;
END;
/

BEGIN
 EXECUTE IMMEDIATE ('Alter table hig_user_contacts_all Add (Constraint huc_pk Primary key (huc_id) ) ');
EXCEPTION
  WHEN others THEN 
   Null;
END;
/

BEGIN
 EXECUTE IMMEDIATE ('Alter table hig_user_contacts_all Add (Constraint huc_has_fk Foreign Key (huc_hus_user_id) References hig_users (hus_user_id) ON DELETE CASCADE) ');
EXCEPTION
  WHEN others THEN 
   Null;
END;
/

BEGIN
 EXECUTE IMMEDIATE ('Create Index huc_hus_fk_ind On hig_user_contacts_all (huc_hus_user_id) ');
EXCEPTION
  WHEN others THEN 
   Null;
END;
/

BEGIN
 EXECUTE IMMEDIATE ('Create sequence hig_hus_id_seq Increment by 1 Start With 1 Nocache ');
EXCEPTION
  WHEN others THEN 
   Null;
END;
/

