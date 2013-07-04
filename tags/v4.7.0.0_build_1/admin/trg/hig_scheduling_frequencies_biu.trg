CREATE OR REPLACE TRIGGER hig_scheduling_frequencies_biu
 BEFORE INSERT 
     OR UPDATE 
     OF hsfr_frequency,hsfr_interval_in_mins
     ON hig_scheduling_frequencies
    FOR each row
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/hig_scheduling_frequencies_biu.trg-arc   3.2   Jul 04 2013 09:53:16   James.Wadsworth  $
--       Module Name      : $Workfile:   hig_scheduling_frequencies_biu.trg  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:53:16  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:35:30  $
--       Version          : $Revision:   3.2  $
--
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN

 --
 -- validate and keep mins in step with frequency string if the frequency is not a shipped one
 --
 IF :NEW.hsfr_frequency_id > 0 THEN

      nm3jobs.validate_calendar_string(pi_calendar_string => :NEW.hsfr_frequency);

    --
    -- If changing the frequency then keep the minutes in step
    --
      IF NVL(:NEW.hsfr_frequency,nm3type.c_nvl)  != NVL(:OLD.hsfr_frequency,nm3type.c_nvl) THEN

        :NEW.hsfr_interval_in_mins := nm3jobs.calendar_string_in_mins(pi_calendar_string => :NEW.hsfr_frequency);

      ELSIF NVL(:NEW.hsfr_interval_in_mins,-99999)  != NVL(:OLD.hsfr_interval_in_mins,-99999) THEN
      
    --
    -- If changing the minutes then keep the frequency in step
    --  

        IF :NEW.hsfr_interval_in_mins IS NOT NULL THEN
         :NEW.hsfr_frequency := 'freq=minutely; interval='||:NEW.hsfr_interval_in_mins||';';
        ELSE
         :NEW.hsfr_frequency := Null;
        END IF;
        
      END IF;
      
 END IF;        

END;
/
