CREATE OR REPLACE TRIGGER hol_b_u_trg
   BEFORE UPDATE
   ON hig_option_list
   FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hol_b_u_trg.trg	1.3 09/27/02
--       Module Name      : hol_b_u_trg.trg
--       Date into SCCS   : 02/09/27 16:39:00
--       Date fetched Out : 07/06/13 17:02:33
--       SCCS Version     : 1.3
--
--
--   Author : Jonathan Mills
--
--   TRIGGER hol_b_u_trg
--      BEFORE UPDATE
--      ON hig_option_list
--      FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   c_hov_value CONSTANT hig_option_values.hov_value%TYPE := nm3get.get_hov (pi_hov_id          => :NEW.hol_id
                                                                           ,pi_raise_not_found => FALSE
                                                                           ).hov_value;
--
BEGIN
--
   --
   -- If updating prevent the update of HOP_ID
   --
   IF NVL(:OLD.hol_id,nm3type.c_nvl) != NVL(:NEW.hol_id,nm3type.c_nvl)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 158
                    ,pi_supplementary_info => 'HIG_OPTIONS.HOP_ID'
                    );
   END IF;
--
   IF   NVL(:OLD.hol_domain,nm3type.c_nvl) != NVL(:NEW.hol_domain,nm3type.c_nvl)
    AND c_hov_value IS NOT NULL
    THEN
      -- Value exists so update not allowed
      hig.raise_ner (pi_appl => nm3type.c_hig
                    ,pi_id   => 157
                    );
   END IF;
--
   IF   :OLD.hol_datatype != :NEW.hol_datatype
    AND c_hov_value IS NOT NULL
    THEN
      -- Value exists so update not allowed
      hig.raise_ner (pi_appl => nm3type.c_hig
                    ,pi_id   => 160
                    );
   END IF;
--
   IF   :OLD.hol_mixed_case != :NEW.hol_mixed_case
    AND :NEW.hol_mixed_case  = 'N'
    AND c_hov_value         != UPPER(c_hov_value)
    THEN
      -- We are changing this so that it is not mixed case
      --  but the value which exists is mixed case
      hig.raise_ner (pi_appl => nm3type.c_hig
                    ,pi_id   => 161
                    );
   END IF;
--
END hol_b_u_trg;
/
