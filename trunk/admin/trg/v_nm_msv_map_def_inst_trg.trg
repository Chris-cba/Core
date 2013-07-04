CREATE OR REPLACE TRIGGER v_nm_msv_map_def_inst_trg
   INSTEAD OF INSERT OR UPDATE OR DELETE
   ON v_nm_msv_map_def
   FOR EACH ROW
-----------------------------------------------------------------------------
--
--
-----------------------------------------------------------------------------
-- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
DECLARE
   /* cursor to get the definition for ONE map - my test one */
   CURSOR c1
   IS
      SELECT definition
        FROM user_sdo_maps
       WHERE NAME = :NEW.vnmd_name;
   
   cursor c2 is
      select name
    from user_sdo_maps
    where name = :NEW.vnmd_name;
   
   cursor c3 is
      select name
    from user_sdo_themes
    where name = :NEW.vnmd_theme_name;

   l_xml          VARCHAR2 (4000);
   l_update_field varchar2 (4000);
   L_UPDATE_DATA  VARCHAR2 (4000);
   v_c2       user_sdo_maps.NAME%type default null;
   v_c3       user_sdo_themes.NAME%type default null;
   
   
   e_ignore_nulls   EXCEPTION;
   PRAGMA EXCEPTION_INIT (e_ignore_nulls, -29532); 

BEGIN
   IF INSERTING THEN
      NULL;
   --
   ELSIF UPDATING THEN
      --
    /* test that map and theme exist */
    open c2;
    fetch c2 into v_c2;
    close c2;
    --
    open c3;
    fetch c3 into v_c3;
    close c3;
    --
    if v_c2 is not null and v_c3 is not null then 
    
    --

        if nvl(:new.VNMD_THEME_MIN_SCALE,-987876579) != nvl(:old.VNMD_THEME_MIN_SCALE,-987876579)
          or nvl(:new.VNMD_THEME_MAX_SCALE,-987876579) != nvl(:old.VNMD_THEME_MAX_SCALE,-987876579) 
        then
                            
           OPEN c1;
           /* fetch the existing XML data into a local varchar varible */
           FETCH c1 INTO l_xml;   
           CLOSE c1; 
           
           /* TEST TO SEE WHICH FIELD IS BEING UPDATED AND TRAP DATA FOR UPDATE */
           if nvl(:new.VNMD_THEME_MIN_SCALE,-987876579) != nvl(:old.VNMD_THEME_MIN_SCALE,-987876579) 
           then
               l_update_field := 'min_scale';
               l_update_data := :NEW.VNMD_THEME_MIN_SCALE;
               /* Pass the existing XML + the attributes you want changing into function */
               l_xml := nm3_msv_xml.update_def_xml(l_xml,'theme', 'name',:NEW.vnmd_theme_name,l_update_field,LOWER(l_update_data));
           END IF;
           IF nvl(:new.VNMD_THEME_MAX_SCALE,-987876579) != nvl(:old.VNMD_THEME_MAX_SCALE,-987876579)
           then
               l_update_field := 'max_scale';
               l_update_data := :NEW.VNMD_THEME_MAX_SCALE;  
               /* Pass the existing XML + the attributes you want changing into function */
               l_xml := nm3_msv_xml.update_def_xml(l_xml,'theme', 'name',:NEW.vnmd_theme_name,l_update_field,LOWER(l_update_data));
           END IF;
           
           --
           --
               
           --
           /* The update the definition with the new one */ 
           UPDATE user_sdo_maps
             SET definition = l_xml
           WHERE NAME = :NEW.vnmd_name;
        
         end if;
         
       end if;
      
   --   
   ELSIF DELETING THEN
      NULL;
   END IF;
   
EXCEPTION
   WHEN e_ignore_nulls
      THEN
      NULL;
   WHEN OTHERS
   THEN
      RAISE;
END v_nm_msv_map_def_inst_trg;
/
