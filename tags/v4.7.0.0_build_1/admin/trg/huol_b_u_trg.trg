CREATE OR REPLACE TRIGGER huol_b_u_trg
   BEFORE UPDATE
   ON hig_user_option_list
   FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)huol_b_u_trg.trg	1.1 10/26/05
--       Module Name      : huol_b_u_trg.trg
--       Date into SCCS   : 05/10/26 17:28:00
--       Date fetched Out : 07/06/13 17:02:35
--       SCCS Version     : 1.1
--
--
--   Author : Graeme Johnson
--
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
  l_huol_already_set BOOLEAN := hig.huol_already_set(pi_huol_id => :OLD.huol_id);
--
BEGIN
--
   --
   -- If updating prevent the update of HOP_ID
   --
   IF NVL(:OLD.huol_id,nm3type.c_nvl) != NVL(:NEW.huol_id,nm3type.c_nvl)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 158
                    ,pi_supplementary_info => 'HIG_USER_OPTION_LIST.HUOL_ID'
                    );
   END IF;
--
   IF   NVL(:OLD.huol_domain,nm3type.c_nvl) != NVL(:NEW.huol_domain,nm3type.c_nvl)
    AND l_huol_already_set
    THEN
      -- Value exists so update not allowed
      hig.raise_ner (pi_appl => nm3type.c_hig
                    ,pi_id   => 157  
                    );
   END IF;
--
   IF   :OLD.huol_datatype != :NEW.huol_datatype
    AND l_huol_already_set
    THEN
      -- Value exists so update not allowed
      hig.raise_ner (pi_appl => nm3type.c_hig
                    ,pi_id   => 160
                    );
   END IF;
--
   IF   :OLD.huol_mixed_case != :NEW.huol_mixed_case
    AND :NEW.huol_mixed_case  = 'N'
    THEN 
       UPDATE hig_user_options
	   SET    huo_value = UPPER(huo_value)
	   WHERE  huo_id = :NEW.HUOL_ID;					
   END IF;
--
END huol_b_u_trg;
/

