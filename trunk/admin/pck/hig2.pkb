
-----------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY hig2 IS
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig2.pkb	1.4 02/22/06
--       Module Name      : hig2.pkb
--       Date into SCCS   : 06/02/22 14:14:58
--       Date fetched Out : 07/06/13 14:10:27
--       SCCS Version     : 1.4
--
--
--   Author :
--
-- This package contains various highways core procedures and functions.
-- Procedures which are executed frequently should be held in hig.pck.
-- Procedures which are executed sporadically should be held in hig2.pck.
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2000
-----------------------------------------------------------------------------
   g_body_sccsid     CONSTANT  VARCHAR2(80) := '"@(#)hig2.pkb	1.4 02/22/06"';
--  g_body_sccsid is the SCCS ID for the package body
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
-- Procedure to keep a log of all installations, upgrades and patches
-- applied to each product on the system.

PROCEDURE upgrade
(p_product         IN  hig_upgrades.hup_product%TYPE,
 p_upgrade_script  IN  hig_upgrades.upgrade_script%TYPE,
 p_remarks         IN  hig_upgrades.remarks%TYPE,
 p_to_version      IN  hig_upgrades.to_version%TYPE)
IS

l_version hig_upgrades.from_version%TYPE;

CURSOR c1 IS
SELECT hpr_version
FROM   hig_products
WHERE  hpr_product = p_product;

BEGIN

OPEN c1;
FETCH c1 INTO l_version;
IF c1%FOUND THEN

   UPDATE hig_products
   SET    hpr_version = p_to_version
   WHERE  hpr_product = p_product
   AND    p_to_version IS NOT NULL;

   INSERT INTO hig_upgrades
       (hup_product,
	date_upgraded,
	from_version,
	to_version,
	upgrade_script,
	executed_by,
	remarks)
   VALUES
       (p_product,
	SYSDATE,
	l_version,
	NVL(p_to_version,'Unchanged'),
	p_upgrade_script,
	USER,
	p_remarks);
   COMMIT;
ELSE
   dbms_output.put_line('Error updating the version - product record not found');
END IF;

CLOSE c1;

END upgrade;
--
-----------------------------------------------------------------------------
--
PROCEDURE pre_upgrade_check (p_product               hig_products.hpr_product%TYPE
                            ,p_new_version           hig_products.hpr_version%TYPE
                            ,p_allowed_old_version_1 hig_products.hpr_version%TYPE
                            ,p_allowed_old_version_2 hig_products.hpr_version%TYPE DEFAULT NULL
                            ,p_allowed_old_version_3 hig_products.hpr_version%TYPE DEFAULT NULL
                            ,p_allowed_old_version_4 hig_products.hpr_version%TYPE DEFAULT NULL
                            ) IS
--
   CURSOR cs_hpr (c_hpr_product hig_products.hpr_product%TYPE) IS
   SELECT *
    FROM  hig_products
   WHERE  hpr_product = c_hpr_product;
--
   l_rec_hpr hig_products%ROWTYPE;
   l_found   BOOLEAN;
--
   c_nvl CONSTANT VARCHAR2(4) := '¼`|~';
--
BEGIN
--
   IF USER IN ('SYS','SYSTEM')
    THEN
      RAISE_APPLICATION_ERROR(-20000,'You cannot install Highways by exor as ' || USER);
   END IF;
--
   OPEN  cs_hpr (p_product);
   FETCH cs_hpr INTO l_rec_hpr;
   l_found := cs_hpr%FOUND;
   CLOSE cs_hpr;
--
   IF NOT l_found
    THEN
      RAISE_APPLICATION_ERROR(-20000,'HIG_PRODUCTS record not found for "'||p_product||'"');
   END IF;
--
   IF l_rec_hpr.hpr_key IS NULL
    THEN
      RAISE_APPLICATION_ERROR(-20000,'Product "'||p_product||'" is not licensed');
   END IF;
--
   IF NVL(l_rec_hpr.hpr_version,c_nvl) NOT IN (p_new_version
                                              ,p_allowed_old_version_1
                                              ,NVL(p_allowed_old_version_2,c_nvl)
                                              ,NVL(p_allowed_old_version_3,c_nvl)
                                              ,NVL(p_allowed_old_version_4,c_nvl)
                                              )
    THEN
      RAISE_APPLICATION_ERROR(-20000,'Upgrade of "'||p_product||'" from v'||l_rec_hpr.hpr_version||' to v'||p_new_version||' not allowed');
   END IF;
--
END pre_upgrade_check;
--
-----------------------------------------------------------------------------
--
PROCEDURE oracle_version_check(pi_min_version IN VARCHAR2) IS

 l_dummy VARCHAR2(1);

BEGIN

 SELECT 'X'
 INTO l_dummy
 FROM  v$instance
 WHERE version >= pi_min_version;

EXCEPTION
  WHEN no_data_found THEN
      RAISE_APPLICATION_ERROR(-20001,'RDBMS version must be  at least '||pi_min_version);   

END oracle_version_check;


END hig2;
/
