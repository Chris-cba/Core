CREATE OR REPLACE TRIGGER hov_hol_length_trg
   BEFORE UPDATE
   ON hig_option_values
   FOR EACH ROW
DECLARE
--
CURSOR max_length_cur(p_hov_id IN VARCHAR2) IS
SELECT hol_max_length 
FROM hig_option_list
WHERE hol_id =  p_hov_id;
--
l_longest_value NUMBER(8);
--
BEGIN
    --
    OPEN max_length_cur (p_hov_id => :NEW.hov_id);
    FETCH max_length_cur INTO l_longest_value;
    CLOSE max_length_cur;
    --
    IF length(:new.hov_value) > l_longest_value THEN
          hig.raise_ner ( pi_appl               => nm3type.c_hig
                              , pi_id                 => 69
                              , pi_supplementary_info => ' You have exceeded the defined limit of ' || l_longest_value || ' characters for this option.'
                              );
    END IF;
--
END hov_hol_length_trg;
/