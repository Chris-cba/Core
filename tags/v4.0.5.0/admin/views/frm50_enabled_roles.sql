CREATE OR replace force view frm50_enabled_roles ( ROLE,
flag ) AS SELECT urp.granted_role ROLE,
       SUM(DISTINCT DECODE(rrp.granted_role,
   			'ORAFORMS$OSC',2,
     			'ORAFORMS$BGM',4,
	 		'ORAFORMS$DBG',1,0)) flag
FROM  sys.user_role_privs urp, role_role_privs rrp
WHERE urp.granted_role = rrp.ROLE (+)
  AND urp.granted_role NOT LIKE 'ORAFORMS$%'
  GROUP BY urp.granted_role
UNION
SELECT hmr_module ROLE, 0 flag
FROM hig_module_roles, session_roles, hig_roles, hig_products
WHERE hpr_key IS NOT NULL
AND hpr_product = hro_product
AND hro_role = ROLE
AND hro_role = hmr_role
/
