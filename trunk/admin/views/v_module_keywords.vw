CREATE OR replace force view V_MODULE_KEYWORDS AS
SELECT
  hmk_hmo_module,
  hmo_title,
  hmo_application,
  hmk_owner,
  hus_name,
  hmk_keyword
FROM
  hig_module_keywords,
  hig_modules,
  hig_users
WHERE
  hmk_hmo_module = hmo_module
AND
  hmk_owner = hus_user_id
/
