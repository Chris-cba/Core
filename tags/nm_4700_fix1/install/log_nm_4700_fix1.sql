BEGIN
--
  hig2.upgrade(p_product        => 'WMP'
              ,p_upgrade_script => 'log_nm_4700_fix1.sql'
              ,p_remarks        => 'WMP 4700 FIX 1'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
