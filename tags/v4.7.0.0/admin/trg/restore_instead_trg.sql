--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/restore_instead_trg.sql-arc   2.1   Jul 04 2013 09:58:54   James.Wadsworth  $
--       Module Name      : $Workfile:   restore_instead_trg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:58:54  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:57:52  $
--       Version          : $Revision:   2.1  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
---------------------------------------------------------------------------------------------------
--
--             **************** Restore any INSTEAD OF triggers *******************
--             "'@(#)restore_instead_trg.sql	1.1 05/07/02'"
---------------------------------------------------------------------------------------------------
--
DECLARE
   --
   CURSOR cs_trg IS
   SELECT nitt.*
         ,nitt.rowid nitt_rowid
    FROM  nm_install_trg_temp nitt;
   --
   CURSOR cs_ut (c_trigger_name VARCHAR2) IS
   SELECT 1
    FROM  user_triggers
   WHERE  trigger_name = c_trigger_name;
   --
   l_tab_varchar  nm3type.tab_varchar32767;
   l_tab_trg_text nm3type.tab_varchar32767;
   l_failure      BOOLEAN := FALSE;
   l_dummy        PLS_INTEGER;
   l_trig_exists  BOOLEAN;
   --
BEGIN
   FOR cs_rec IN cs_trg
    LOOP
      --
      l_tab_varchar.DELETE;
      --
      OPEN  cs_ut (cs_rec.trigger_name);
      FETCH cs_ut INTO l_dummy;
      l_trig_exists := cs_ut%FOUND;
      CLOSE cs_ut;
      --
      IF l_trig_exists
       THEN
         -- The trigger already exists at this point
         -- Therefore this upgrade must have created this trigger as part of
         --  it so do not restore the old trigger
         cs_rec.progress := 'Trigger already exists';
      ELSE
      --
         l_tab_varchar(1) := 'CREATE TRIGGER'||CHR(10);
         l_tab_varchar(2) := cs_rec.description;
         l_tab_trg_text   := nm3clob.clob_to_tab_varchar(cs_rec.trigger_body);
         --
         FOR i IN 1..l_tab_trg_text.COUNT
          LOOP
            l_tab_varchar(l_tab_varchar.COUNT+1) := l_tab_trg_text(i);
         END LOOP;
         --
         BEGIN
            nm3ddl.execute_tab_varchar(l_tab_varchar);
            cs_rec.progress := 'Trigger created';
         EXCEPTION
            WHEN others
             THEN
               cs_rec.progress := SUBSTR(SQLERRM,1,200);
               l_failure       := TRUE;
         END;
      --
      END IF;
      --
      UPDATE nm_install_trg_temp
       SET   progress = cs_rec.progress
      WHERE  ROWID    = cs_rec.nitt_rowid;
      --
      COMMIT;
      --
   END LOOP;
      --
   IF l_failure
    THEN
      RAISE_APPLICATION_ERROR(-20001,'Trigger(s) failed recreation. Review nm_install_trg_temp table');
   END IF;
      --
END;
/

---------------------------------------------------------------------------------------------------
