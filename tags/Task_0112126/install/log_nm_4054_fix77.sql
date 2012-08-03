BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4054_fix77.sql'
              ,p_remarks        => 'NET 4054 FIX 77'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
