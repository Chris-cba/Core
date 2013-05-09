BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4600_fix7.sql'
              ,p_remarks        => 'NM 4600 FIX 7'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
