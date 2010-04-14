CREATE OR REPLACE TRIGGER huo_huol_length_trg
   BEFORE UPDATE
   ON hig_user_options
   FOR EACH ROW
DECLARE
--
CURSOR max_length_cur(p_huol_id IN VARCHAR2) IS
SELECT huol_max_length 
FROM hig_user_option_list
WHERE huol_id =  p_huol_id;
--
l_longest_value NUMBER(8);
--
BEGIN
    --
    OPEN max_length_cur (p_huol_id => :NEW.huo_id);
    FETCH max_length_cur INTO l_longest_value;
    CLOSE max_length_cur;
    --
    IF length(:new.huo_value) > l_longest_value THEN
          hig.raise_ner ( pi_appl               => nm3type.c_hig
                              , pi_id                 => 69
                              , pi_supplementary_info => ' You have exceeded the defined limit of ' || l_longest_value || ' characters for this option.'
                              );
    END IF;
END huo_huol_length_trg;
/