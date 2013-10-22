
-----------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY hig2 IS
-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid                     : $Header:   //vm_latest/archives/nm3/admin/pck/hig2.pkb-arc   2.5   Oct 22 2013 17:30:18   Rob.Coupe  $
--       Module Name                : $Workfile:   hig2.pkb  $
--       Date into PVCS             : $Date:   Oct 22 2013 17:30:18  $
--       Date fetched Out           : $Modtime:   Oct 22 2013 17:23:12  $
--       PVCS Version               : $Revision:   2.5  $
--       Based on SCCS version      : 1.4
--
--
--   Author :
--
-- This package contains various highways core procedures and functions.
-- Procedures which are executed frequently should be held in hig.pck.
-- Procedures which are executed sporadically should be held in hig2.pck.
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
   g_body_sccsid     CONSTANT  VARCHAR2(80) := '"@(#)hig2.pkb    1.4 02/22/06"';
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
--
PROCEDURE open_form_session_check 
IS
--
 l_usernames NM3TYPE.TAB_VARCHAR80;
 l_usercount NM3TYPE.TAB_VARCHAR80;
--
    CURSOR open_sess_cur IS
    SELECT username, count (*) usercount
      FROM v$session
         , hig_users
     WHERE hus_username = username 
       AND UPPER(program) = 'FRMWEB.EXE'
  GROUP BY username;
--
BEGIN
--
  OPEN open_sess_cur;
  FETCH open_sess_cur BULK COLLECT INTO l_usernames, l_usercount;
  CLOSE open_sess_cur;
  
  IF l_usernames.COUNT = 1
  THEN
    RAISE_APPLICATION_ERROR(-20001, 'The user '|| l_usernames(1) || ' currently has '|| l_usercount(1) ||' forms sessions open. You need to close these to continue.');
  ELSIF l_usernames.COUNT > 1
  THEN
    RAISE_APPLICATION_ERROR(-20001, 'There are '|| l_usernames.count || ' users that have open forms sessions. You need to close these to continue.');
  END IF;
--
END open_form_session_check; 
--
-----------------------------------------------------------------------------
--
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
-- This procedure checks to see if the upgrade should be allowed to continue 
-- based on the current version of the product
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
	  IF NVL( substr( l_rec_hpr.hpr_version, 1, instr( l_rec_hpr.hpr_version, '.', 1, 3)-1), c_nvl ) 
              NOT LIKE NVL( substr(p_new_version, 1, instr( p_new_version, '.', 1, 3)-1), c_nvl )
      AND NVL( substr( l_rec_hpr.hpr_version, 1, instr( l_rec_hpr.hpr_version, '.', 1, 3)-1), c_nvl ) 
              NOT LIKE NVL( substr(p_allowed_old_version_1, 1, instr( p_allowed_old_version_1, '.', 1, 3)-1), c_nvl )
	  THEN
         RAISE_APPLICATION_ERROR(-20000,'Upgrade of "'||p_product||'" from v'||l_rec_hpr.hpr_version||' to v'||p_new_version||' not allowed');
      END IF;
	END IF;
--
   IF NOT hig_process_framework.disable_check_scheduler_down
   THEN
     RAISE_APPLICATION_ERROR(-20000,'The Process Framework is shutting down but processes are still running.  Please try again later.'); 
   END IF;
   --
   open_form_session_check;
   --
END pre_upgrade_check;
--
-----------------------------------------------------------------------------
-- This procedure checks to see if the install should be allowed to continue 
-----------------------------------------------------------------------------
--
PROCEDURE pre_install_check
IS
BEGIN
--
   IF USER IN ('SYS','SYSTEM')
    THEN
      RAISE_APPLICATION_ERROR(-20000,'You cannot install Highways by exor as ' || USER);
   END IF;
--
   IF NOT hig_process_framework.disable_check_scheduler_down
   THEN
      RAISE_APPLICATION_ERROR(-20000,'The Process Framework is shutting down but processes are still running.  Please try again later.');
   END IF;
   
   open_form_session_check;
--
END pre_install_check;
--
-----------------------------------------------------------------------------
-- This procedure checks to see if the install should be allowed to continue 
-- if this product has dependencies on another product.
-- All products should depend on NM3 / Core.
PROCEDURE product_exists_at_version (p_product                   hig_products.hpr_product%TYPE
                                    ,p_version                   hig_products.hpr_version%TYPE
                                    ) IS
   l_rec_hpr    hig_products%ROWTYPE;
   l_found      BOOLEAN := FALSE;

BEGIN
--
  -- get row from hig products for product you are checking 
  l_rec_hpr := nm3get.get_hpr(pi_hpr_product => p_product
                             ,pi_raise_not_found => TRUE);

  -- return true if product found at required version is licensed, else default value remains
  IF p_version = l_rec_hpr.hpr_version AND l_rec_hpr.hpr_key IS NOT NULL THEN
    l_found := TRUE;
  ELSIF substr( p_version, 1, instr( p_version, '.', 1, 3)-1) = substr(l_rec_hpr.hpr_version, 1, instr( l_rec_hpr.hpr_version, '.', 1, 3)-1) THEN
    l_found := TRUE;
  END IF;       
  
  -- stop the installation if product was not found at required version 
  IF NOT l_found THEN
      RAISE_APPLICATION_ERROR(-20000,'Installation terminated: "'||p_product||'" version '||p_version||' must be installed and licensed');
  END IF;    
--
END product_exists_at_version;
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
--
-----------------------------------------------------------------------------
--
END hig2;
/
