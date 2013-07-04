CREATE OR REPLACE TRIGGER nm_inv_domains_all_b_u_trg
   BEFORE UPDATE
    ON    nm_inv_domains_all
    FOR   EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_domains_all_b_u_trg.trg	1.2 09/06/02
--       Module Name      : nm_inv_domains_all_b_u_trg.trg
--       Date into SCCS   : 02/09/06 15:19:33
--       Date fetched Out : 07/06/13 17:02:50
--       SCCS Version     : 1.2
--
--
--   Author : Jonathan Mills
--
--   TRIGGER nm_inv_domains_all_b_u_trg
--      BEFORE UPDATE
--       ON    nm_inv_domains_all
--       FOR   EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   CURSOR cs_ial (c_id_domain nm_inv_domains.id_domain%TYPE) IS
   SELECT ial_value
    FROM  nm_inv_attri_lookup_all
   WHERE  ial_domain = c_id_domain;
--
   c_new_id_datatype CONSTANT nm_inv_domains.id_datatype%TYPE := :NEW.id_datatype;
   c_is_varchar      CONSTANT BOOLEAN                         := c_new_id_datatype = nm3type.c_varchar;
   c_is_number       CONSTANT BOOLEAN                         := c_new_id_datatype = nm3type.c_number;
   c_is_date         CONSTANT BOOLEAN                         := c_new_id_datatype = nm3type.c_date;
--
   PROCEDURE check_usage (p_allowed_datatype_1 nm_inv_domains.id_datatype%TYPE DEFAULT NULL
                         ,p_allowed_datatype_2 nm_inv_domains.id_datatype%TYPE DEFAULT NULL
                         ) IS
      CURSOR cs_check_usage (c_id_domain          nm_inv_domains.id_domain%TYPE
                            ,c_allowed_datatype_1 nm_inv_domains.id_datatype%TYPE
                            ,c_allowed_datatype_2 nm_inv_domains.id_datatype%TYPE
                            ) IS
      SELECT 1
       FROM  dual
      WHERE  EXISTS (SELECT 1
                      FROM  nm_inv_type_attribs_all
                     WHERE  ita_id_domain = c_id_domain
                      AND   ita_format NOT IN (c_allowed_datatype_1,c_allowed_datatype_2)
                    );
      l_dummy PLS_INTEGER;
      l_found BOOLEAN;
   BEGIN
      OPEN  cs_check_usage (:NEW.id_domain
                           ,NVL(p_allowed_datatype_1, nm3type.c_nvl)
                           ,NVL(p_allowed_datatype_2, nm3type.c_nvl)
                           );
      FETCH cs_check_usage INTO l_dummy;
      l_found := cs_check_usage%FOUND;
      CLOSE cs_check_usage;
      IF l_found
       THEN
         hig.raise_ner (pi_appl => nm3type.c_net
                       ,pi_id   => 308
                       );
      END IF;
   END check_usage;
--
BEGIN
--
   IF c_new_id_datatype != :OLD.id_datatype
    THEN
    --
      IF    c_is_varchar
       THEN
         check_usage (nm3type.c_varchar);
      ELSIF c_is_number
       THEN
         check_usage (nm3type.c_varchar,nm3type.c_number);
      ELSIF c_is_date
       THEN
         check_usage (nm3type.c_varchar,nm3type.c_date);
      END IF;
    --
      FOR cs_ial_rec IN cs_ial (:NEW.id_domain)
       LOOP
         IF    c_is_varchar
          THEN
            Null;
         ELSIF c_is_number
          THEN
            IF  NOT nm3flx.is_numeric (cs_ial_rec.ial_value)
             OR cs_ial_rec.ial_value != LTRIM(TO_CHAR(TO_NUMBER(cs_ial_rec.ial_value)))
             THEN  -- Prevent entering of "01" for instance in a NUMBER domain
               hig.raise_ner (pi_appl               => nm3type.c_hig
                             ,pi_id                 => 111
                             ,pi_supplementary_info => cs_ial_rec.ial_value
                             );
            END IF;
         ELSIF c_is_date
          THEN
            IF hig.date_convert (cs_ial_rec.ial_value) IS NULL
             THEN
               hig.raise_ner (pi_appl               => nm3type.c_hig
                             ,pi_id                 => 148
                             ,pi_supplementary_info => cs_ial_rec.ial_value
                             );
            END IF;
         END IF;
      END LOOP;
    --
   END IF;
--
END nm_inv_domains_all_b_u_trg;
/
