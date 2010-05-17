CREATE OR REPLACE TRIGGER hol_hov_length_trg
  BEFORE UPDATE
  ON hig_option_list
  FOR EACH ROW
DECLARE
  --
  CURSOR max_length_cur(p_hol_id IN VARCHAR2)
  IS
    SELECT max(hov_value) hov_value
      FROM (SELECT length(hov_value) hov_value
              FROM hig_option_values
             WHERE hov_id = p_hol_id
            UNION ALL
            SELECT length(huo_value) hov_value
              FROM hig_user_options
             WHERE huo_id = p_hol_id
                   AND :new.hol_user_option = 'Y');
--
  l_longest_value  NUMBER(8);
--
BEGIN
  --
  OPEN max_length_cur(p_hol_id => :new.hol_id);
  FETCH max_length_cur INTO l_longest_value;
  CLOSE max_length_cur;
  --
  IF :new.hol_max_length < l_longest_value THEN
    hig.
    raise_ner(
      pi_appl                 => nm3type.c_hig
     ,pi_id                   => 76
     ,pi_supplementary_info   => l_longest_value ||
                                '. An option value exists that is longer than the specified length.');
  END IF;
--
END hol_hov_length_trg;
/