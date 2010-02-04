CREATE OR REPLACE TRIGGER huol_huo_length_trg
   BEFORE UPDATE
   ON hig_user_option_list
   FOR EACH ROW
DECLARE
--
CURSOR max_length_cur(p_huol_id IN VARCHAR2) IS
SELECT MAX(LENGTH(huo_value)) huol_value 
FROM hig_user_options 
WHERE huo_id = p_huol_id;
--
l_longest_value NUMBER(8);
--
BEGIN
    --
    OPEN max_length_cur (p_huol_id => :NEW.huol_id);
    FETCH max_length_cur INTO l_longest_value;
    CLOSE max_length_cur;
    --
    IF :new.HUOL_MAX_LENGTH < l_longest_value THEN
      hig.raise_ner ( pi_appl               => nm3type.c_hig
                          , pi_id                 => 76
                          , pi_supplementary_info => l_longest_value || '. An option value exists that is longer than the specified length.'
                          );
    END IF;
--
END huol_huo_length_trg;
/