CREATE OR REPLACE PACKAGE BODY nm3user AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3user.pkb-arc   2.7   Oct 12 2011 10:23:42   Steve.Cooper  $
--       Mg_user_id_tabodule Name      : $Workfile:   nm3user.pkb  $
--       Date into PVCS   : $Date:   Oct 12 2011 10:23:42  $
--       Date fetched Out : $Modtime:   Oct 12 2011 10:17:38  $
--       Version          : $Revision:   2.7  $
--       Based on SCCS version : 1.21
-------------------------------------------------------------------------
--   Author : Rob Coupe
--
--   NM3 user package
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2000
-----------------------------------------------------------------------------
   g_body_sccsid     CONSTANT  varchar2(2000) := '$Revision:   2.7  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name CONSTANT  varchar2(2000) := 'nm3user';
--
  g_my_user_hist user_hist_item := user_hist_item (user_hist_modules (user_hist_module (NULL, NULL)));
  --

  g_public_username CONSTANT hig_users.hus_username%TYPE := 'PUBLIC';
  g_public_name     CONSTANT hig_users.hus_name%TYPE     := 'Public Access';
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
  PROCEDURE instantiate_user IS
  BEGIN
    instantiate_user_history;
  END instantiate_user;
--
-----------------------------------------------------------------------------
--
  PROCEDURE set_effective_date ( p_date IN date ) IS
  BEGIN
     IF p_date IS NULL
      THEN
        hig.raise_ner (pi_appl               => nm3type.c_net
                      ,pi_id                 => 282
                      ,pi_supplementary_info => g_package_name||'.set_effective_date(p_date)'
                      );
     END IF;
     nm3ctx.Set_Core_Context  (
                              p_Attribute =>  'EFFECTIVE_DATE',
                              p_Value     =>  To_Char(Trunc(p_Date),'DD-MON-YYYY')
                              );                          
  END set_effective_date;
--
-----------------------------------------------------------------------------
--
  PROCEDURE set_user_date_mask ( p_mask IN varchar2) IS
--
    l_date varchar2(80);
--
    ex_dateformat EXCEPTION;
--
    PRAGMA EXCEPTION_INIT( ex_dateformat, -1821 );
--
    CURSOR c1 IS
      SELECT TO_CHAR(TO_DATE( TO_CHAR( SYSDATE, p_mask ), p_mask ), 'DD-MON-YYYY' )
      FROM dual;
--
  BEGIN
--
    l_date := TO_CHAR( SYSDATE, p_mask);
--
    OPEN c1;
    FETCH c1 INTO l_date;
    CLOSE c1;

    nm3ctx.Set_Core_Context (
                            p_Attribute =>  'USER_DATE_MASK',
                            p_Value     =>  p_mask
                            ); 
--
     set_user_option (pi_huo_id     => 'DATE_MASK'
                     ,pi_huo_value  => p_mask
                     );
--
  EXCEPTION
    WHEN ex_dateformat THEN
      RAISE_APPLICATION_ERROR( -20001, 'Invalid Date format mask');
    WHEN others THEN
      RAISE_APPLICATION_ERROR( -20002, 'Date format mask not set - Error code '||SQLCODE);
  END set_user_date_mask;
--
-----------------------------------------------------------------------------
--
  PROCEDURE set_user_length_units( p_unit_id IN number ) IS
  BEGIN
--
    IF nm3unit.unit_exists( 'LENGTH', p_unit_id )
     THEN
--
      nm3ctx.Set_Core_Context (
                              p_Attribute =>  'USER_LENGTH_UNITS',
                              p_Value     =>  Ltrim(To_Char(p_unit_id))
                              );
                              
        set_user_option (pi_huo_id    => 'PREFUNITS'
                        ,pi_huo_value => p_unit_id
                        );
--
    ELSE
--
      RAISE_APPLICATION_ERROR( -20003, 'Invalid Unit Reference' );
--
    END IF;
--
  END set_user_length_units;
--
----------------------------------------------------------------------------------
--
  PROCEDURE instantiate_user_history IS
     CURSOR c1 IS
      SELECT huh_user_history
      FROM hig_user_history
      WHERE huh_user_id   = To_Number(Sys_Context('NM3CORE','USER_ID'))
      AND huh_user_history IS NOT NULL;
--
  BEGIN
	-- retrieve existing history
	OPEN  c1;
	FETCH c1 INTO g_my_user_hist;
	CLOSE c1;
--
	-- initialize history storage
 	g_my_user_hist:= g_my_user_hist.initialize_varray();
--
  END instantiate_user_history;
--
-----------------------------------------------------------------------------
--
  PROCEDURE set_history_rec ( p_module IN varchar2) IS
--
	CURSOR c1 (c_module varchar2) IS
        SELECT hmo_fastpath_invalid
         FROM  hig_modules
        WHERE  hmo_module = c_module;
--
	l_fastpath_invalid varchar2(1) := 'Y';
--
  BEGIN
--
	OPEN  c1 (p_module);
	FETCH c1 INTO l_fastpath_invalid;
	CLOSE c1;
--
	IF l_fastpath_invalid = 'N' THEN
		g_my_user_hist:= g_my_user_hist.add_new_module (p_module);
                maintain_user_history;
	END IF;
--
  END set_history_rec;
--
-----------------------------------------------------------------------------
--
  PROCEDURE maintain_user_history IS
--
    PRAGMA autonomous_transaction;
--
  BEGIN
--
    DELETE FROM hig_user_history
    WHERE huh_user_id = To_Number(Sys_Context('NM3CORE','USER_ID'));
--
    INSERT INTO hig_user_history
    VALUES (To_Number(Sys_Context('NM3CORE','USER_ID')),
           g_my_user_hist
           );
--
    COMMIT;
--
  END maintain_user_history;
--
-----------------------------------------------------------------------------
--
  FUNCTION  get_history_rec ( p_index IN number ) RETURN hig_modules.hmo_module%TYPE IS
  BEGIN
--
    RETURN g_my_user_hist.get_module(p_index);
--
  END get_history_rec;
--
-----------------------------------------------------------------------------
--
  PROCEDURE dump_user_history IS
  BEGIN
--
    g_my_user_hist.dump_module_hist();
--
  END dump_user_history;
--
-----------------------------------------------------------------------------
--
  FUNCTION  convert_char_date ( p_char_date IN varchar2 ) RETURN varchar2 IS
  BEGIN
--
    RETURN TO_CHAR(hig.date_convert(p_char_date),Sys_Context('NM3CORE','USER_DATE_MASK') );
--
  END convert_char_date;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_username(p_user_id IN hig_users.hus_user_id%TYPE) RETURN hig_users.hus_username%TYPE IS
--
    CURSOR c1 IS
      SELECT hus_username
      FROM   hig_users
      WHERE  hus_user_id = p_user_id;
--
    l_retval hig_users.hus_username%TYPE;
--
  BEGIN
--
    OPEN  c1 ;
    FETCH c1 INTO l_retval;
    IF c1%NOTFOUND THEN
      l_retval := 'No DCD inspector';
    END IF;
    CLOSE c1;
--
    RETURN l_retval;
--
  END get_username;
--
-----------------------------------------------------------------------------
--
FUNCTION user_can_run_module(p_module IN hig_module_roles.hmr_module%TYPE) RETURN boolean IS

   CURSOR c1 (c_module  hig_modules.hmo_module%TYPE
              ,c_sysdate hig_user_roles.hur_start_date%TYPE
              ) IS
      SELECT 1
      FROM   hig_module_roles
            ,hig_user_roles
			,hig_modules
			,hig_products
      WHERE  hmo_module      = c_module
	   AND   hpr_product     = hmo_application
	   AND   hpr_key IS NOT NULL
       AND   hmr_module      = hmo_module
       AND   hmr_role        = hur_role
       AND   hur_username    = Sys_Context('NM3_SECURITY_CTX','USERNAME')
       AND   hur_start_date <= c_sysdate;

    l_dummy  pls_integer;
    l_retval boolean;
  
  BEGIN
  
 
    OPEN  c1 (c_module  => UPPER(p_module)
             ,c_sysdate => TRUNC(SYSDATE)
             );
    FETCH c1 INTO l_dummy;
    l_retval := c1%FOUND;
    CLOSE c1;
  -- nm_debug.debug('reteval at the end '||l_retval);
    RETURN l_retval;
    
  END user_can_run_module;
--
-----------------------------------------------------------------------------
--
FUNCTION user_can_run_module_vc(p_module IN hig_module_roles.hmr_module%TYPE) RETURN VARCHAR2 IS

  BEGIN

     IF user_can_run_module(p_module) THEN
	    RETURN('Y');
     ELSE
	    RETURN('N');
	 END IF;
  
  END user_can_run_module_vc;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_public_user_details(po_pub_username OUT varchar2
                                 ,po_pub_name     OUT varchar2
                                 ) IS
BEGIN
  po_pub_username := g_public_username;
  po_pub_name     := g_public_name;
END get_public_user_details;
--
-----------------------------------------------------------------------------
--
PROCEDURE restricted_user_check IS
BEGIN
  nm_debug.proc_start(g_package_name , 'restricted_user_check');
  IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'FALSE'  THEN
    RAISE_APPLICATION_ERROR( -20997, 'USER IS RESTRICTED, You cannot perform this operation.');
 END IF;
  nm_debug.proc_end(g_package_name , 'restricted_user_check');
END restricted_user_check;
--
-----------------------------------------------------------------------------
--
FUNCTION user_has_role(pi_user IN hig_users.hus_username%TYPE DEFAULT Sys_Context('NM3_SECURITY_CTX','USERNAME')
                      ,pi_role IN hig_roles.hro_role%TYPE
                      ) RETURN boolean IS

  CURSOR c_hur IS
    SELECT
      1
    FROM
      hig_user_roles
    WHERE
      hur_username = pi_user
    AND
      hur_role = pi_role;

  l_dummy pls_integer;

  l_retval boolean;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'user_has_role');

  OPEN c_hur;
    FETCH c_hur INTO l_dummy;
    l_retval := c_hur%FOUND;
  CLOSE c_hur;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'user_has_role');

  RETURN l_retval;

END user_has_role;
--
-----------------------------------------------------------------------------
--
FUNCTION user_has_priv(pi_user IN hig_users.hus_username%TYPE DEFAULT Sys_Context('NM3_SECURITY_CTX','USERNAME')
                      ,pi_priv IN dba_sys_privs.PRIVILEGE%TYPE
                      ) RETURN boolean IS

  CURSOR c_privs IS
    SELECT
      1
    FROM
      dba_sys_privs
    WHERE
      grantee = pi_user
    AND
      PRIVILEGE = UPPER(pi_priv);

  l_dummy pls_integer;

  l_retval boolean;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'user_has_priv');

  OPEN c_privs;
    FETCH c_privs INTO l_dummy;
    l_retval := c_privs%FOUND;
  CLOSE c_privs;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'user_has_priv');

  RETURN l_retval;

END user_has_priv;
--
-----------------------------------------------------------------------------
--
FUNCTION get_hus (pi_hus_user_id IN hig_users.hus_user_id%TYPE) RETURN hig_users%ROWTYPE IS
--
   CURSOR cs_hus (c_id hig_users.hus_user_id%TYPE) IS
   SELECT *
    FROM  hig_users
   WHERE  hus_user_id = c_id;
--
   l_rec_hus hig_users%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name, 'get_hus');
--
   OPEN  cs_hus (pi_hus_user_id);
   FETCH cs_hus INTO l_rec_hus;
   IF cs_hus%NOTFOUND
    THEN
      CLOSE cs_hus;
      RAISE_APPLICATION_ERROR(-20001,'UserID '||pi_hus_user_id||' not found in HIG_USERS');
   END IF;
   CLOSE cs_hus;
--
   RETURN l_rec_hus;
--
   nm_debug.proc_end (g_package_name, 'get_hus');
--
END get_hus;
--
-----------------------------------------------------------------------------
--
FUNCTION get_hus (pi_hus_username IN hig_users.hus_username%TYPE DEFAULT Sys_Context('NM3_SECURITY_CTX','USERNAME') ) RETURN hig_users%ROWTYPE IS
--
   CURSOR cs_hus IS
   SELECT *
    FROM  hig_users
   WHERE  hus_username = pi_hus_username;
--
   l_rec_hus hig_users%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name, 'get_hus');
--
   OPEN  cs_hus;
   FETCH cs_hus INTO l_rec_hus;
   IF cs_hus%NOTFOUND
    THEN
      CLOSE cs_hus;
      RAISE_APPLICATION_ERROR(-20001,'User '||pi_hus_username||' not found in HIG_USERS');
   END IF;
   CLOSE cs_hus;
--
   RETURN l_rec_hus;
--
   nm_debug.proc_end (g_package_name, 'get_hus');
--
END get_hus;
--
-----------------------------------------------------------------------------
--
PROCEDURE lock_account(pi_username IN hig_users.hus_username%TYPE
                      ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'lock_account');

  EXECUTE IMMEDIATE 'alter user ' || pi_username || ' account lock';

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'lock_account');

END lock_account;
--
-----------------------------------------------------------------------------
--
PROCEDURE unlock_account(pi_username IN hig_users.hus_username%TYPE
                        ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'unlock_account');

  EXECUTE IMMEDIATE 'alter user ' || pi_username || ' account unlock';

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'unlock_account');

END unlock_account;
--
-----------------------------------------------------------------------------
--
FUNCTION get_du(pi_username IN dba_users.username%TYPE
               ) RETURN dba_users%ROWTYPE IS

  l_retval dba_users%ROWTYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_du');

  SELECT
    *
  INTO
    l_retval
  FROM
    dba_users
  WHERE
    username = UPPER(pi_username);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_du');

  RETURN l_retval;

EXCEPTION
  WHEN no_data_found
  THEN
    hig.raise_ner(pi_appl               => nm3type.c_hig
                 ,pi_id                 => 67
                 ,pi_supplementary_info => 'DBA_USERS.username = ' || pi_username);

  WHEN too_many_rows
  THEN
    hig.raise_ner(pi_appl               => nm3type.c_hig
                 ,pi_id                 => 105
                 ,pi_supplementary_info => 'DBA_USERS.username = ' || pi_username);

END get_du;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_preferred_lrm (pi_group_type   IN nm_group_types.ngt_group_type%TYPE
                            ,pi_set_user_opt IN boolean DEFAULT TRUE
                            ) IS
BEGIN
--
   IF pi_group_type IS NULL
     OR nm3get.get_ngt (pi_ngt_group_type => pi_group_type).ngt_group_type IS NOT NULL
    THEN
      nm3ctx.Set_Core_Context (
                              p_Attribute =>  'PREFERRED_LRM',
                              p_Value     =>  pi_group_type
                              );
      IF pi_set_user_opt
      THEN
        set_user_option (pi_huo_id    => 'PREFLRM'
                        ,pi_huo_value => pi_group_type
                        );
     END IF;
   END IF;
--
END set_preferred_lrm;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_user_option (pi_huo_hus_user_id        hig_user_options.huo_hus_user_id%TYPE
                          ,pi_huo_id                 hig_user_options.huo_id%TYPE
                          ,pi_huo_value              hig_user_options.huo_value%TYPE
                          ) IS
--
   PRAGMA autonomous_transaction;
--
   l_rec_huo hig_user_options%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'set_user_option');
--
   l_rec_huo.huo_hus_user_id := pi_huo_hus_user_id;
   l_rec_huo.huo_id          := pi_huo_id;
   l_rec_huo.huo_value       := pi_huo_value;
--
   nm3del.del_huo (pi_huo_hus_user_id   => l_rec_huo.huo_hus_user_id
                  ,pi_huo_id            => l_rec_huo.huo_id
                  ,pi_raise_not_found   => FALSE
                  );
--
   IF l_rec_huo.huo_value IS NOT NULL
    THEN
      nm3ins.ins_huo (p_rec_huo => l_rec_huo);
   END IF;
--
   nm_debug.proc_end(g_package_name,'set_user_option');
--
   COMMIT;
--
END set_user_option;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_user_option (pi_huo_id                 hig_user_options.huo_id%TYPE
                          ,pi_huo_value              hig_user_options.huo_value%TYPE
                          ) IS
BEGIN
   nm3user.set_user_option (pi_huo_hus_user_id => To_Number(Sys_Context('NM3CORE','USER_ID'))
                           ,pi_huo_id          => pi_huo_id
                           ,pi_huo_value       => pi_huo_value
                           );
END set_user_option;
--
-----------------------------------------------------------------------------
--
FUNCTION get_user_roi_details RETURN nm3extent.rec_roi_details IS
--
   l_rec_roi_details nm3extent.rec_roi_details;
--
BEGIN

--
   BEGIN
      nm3extent.get_roi_details (pi_roi_type    => Sys_Context('NM3CORE','ROI_TYPE')
                                ,pi_roi_id      => To_Number(Sys_Context('NM3CORE','ROI_ID'))
                                ,po_roi_details => l_rec_roi_details
                                );
   EXCEPTION
      WHEN others
       THEN
         NULL;
   END;
--
   RETURN l_rec_roi_details;
--
END get_user_roi_details;
--
-----------------------------------------------------------------------------
--
FUNCTION get_user_roi_name RETURN nm_elements.ne_unique%TYPE IS
   l_rec_roi_details nm3extent.rec_roi_details;
BEGIN
   l_rec_roi_details := nm3user.get_user_roi_details;
   RETURN l_rec_roi_details.roi_name;
END get_user_roi_name;
--
-----------------------------------------------------------------------------
--
FUNCTION get_user_roi_descr RETURN nm_elements.ne_descr%TYPE IS
   l_rec_roi_details nm3extent.rec_roi_details;
BEGIN
   l_rec_roi_details := nm3user.get_user_roi_details;
   RETURN l_rec_roi_details.roi_descr;
END get_user_roi_descr;
--
-----------------------------------------------------------------------------
--
FUNCTION get_user_roi_id RETURN nm_elements.ne_id%TYPE IS
   l_rec_roi_details nm3extent.rec_roi_details;
BEGIN
   l_rec_roi_details := nm3user.get_user_roi_details;
   RETURN l_rec_roi_details.roi_id;
END get_user_roi_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_user_roi_type RETURN varchar2 IS
   l_rec_roi_details nm3extent.rec_roi_details;
BEGIN
   l_rec_roi_details := nm3user.get_user_roi_details;
   RETURN l_rec_roi_details.roi_type;
END get_user_roi_type;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_user_roi_details (pi_roi_id   number
                               ,pi_roi_type varchar2
                               ) IS
--
   l_rec_roi_details nm3extent.rec_roi_details;
--
BEGIN
--
   -- Check to make sure the ROI is valid
   nm3extent.get_roi_details (pi_roi_type    => pi_roi_type
                             ,pi_roi_id      => pi_roi_id
                             ,po_roi_details => l_rec_roi_details
                             );
--
   nm3ctx.Set_Core_Context  (
                            p_Attribute =>  'ROI_ID',
                            p_Value     =>  To_Char(pi_roi_id)
                            );
                    
   nm3user.set_user_option   (pi_huo_id    => 'ROI_ID'
                             ,pi_huo_value => pi_roi_id
                             );
--  
   nm3ctx.Set_Core_Context  (
                            p_Attribute =>  'ROI_ID',
                            p_Value     =>  pi_roi_type
                            );                             

   nm3user.set_user_option   (pi_huo_id    => 'ROI_TYPE'
                             ,pi_huo_value => pi_roi_type
                             );
--
END set_user_roi_details;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_user_def_inv_attr_set(pi_nias_id nm_inv_attribute_sets.nias_id%TYPE
                                   ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'set_user_def_inv_attr_set');

  nm3ctx.Set_Core_Context (
                          p_Attribute =>  'DEFAULT_INV_ATTR_SET',
                          p_Value     =>  Ltrim(To_Char(pi_Nias_Id))
                          ); 

  nm3user.set_user_option(pi_huo_id    => 'DEFATTRSET'
                         ,pi_huo_value => pi_nias_id);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'set_user_def_inv_attr_set');

END set_user_def_inv_attr_set;
--
-----------------------------------------------------------------------------
--
PROCEDURE copy_user (pi_hus_user_id_old   IN     hig_users.hus_user_id%TYPE
                    ,pi_hus_name          IN     hig_users.hus_name%TYPE
                    ,pi_hus_initials      IN     hig_users.hus_initials%TYPE
                    ,pi_hus_username      IN     hig_users.hus_username%TYPE
                    ,pi_password          IN     VARCHAR2
                    ,pi_hus_start_date    IN     hig_users.hus_start_date%TYPE
                    ,pi_hus_unrestricted  IN     hig_users.hus_unrestricted%TYPE
                    ,pi_copy_roles        IN     BOOLEAN DEFAULT TRUE
                    ,pi_copy_admin_units  IN     BOOLEAN DEFAULT TRUE
                    ,pi_copy_user_options IN     BOOLEAN DEFAULT TRUE
                    ,po_hus_user_id_new      OUT hig_users.hus_user_id%TYPE
                    ) IS
--
   CURSOR cs_da (c_username VARCHAR2) IS
   SELECT default_tablespace
         ,temporary_tablespace
         ,profile
    FROM  dba_users
   WHERE  username = c_username;
--
   CURSOR cs_dtq (c_username   VARCHAR2
                 ,c_tablespace VARCHAR2
                 ) IS
   SELECT max_bytes
    FROM  dba_ts_quotas
   WHERE  username        = c_username
    AND   tablespace_name = c_tablespace;
--
   l_default_tablespace   VARCHAR2(30);
   l_temporary_tablespace VARCHAR2(30);
   l_profile              VARCHAR2(30);
   l_quota                VARCHAR2(30);
--
   l_rec_hus_old          hig_users%ROWTYPE;
   l_rec_hus_new          hig_users%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'copy_user');
--
   l_rec_hus_old := nm3get.get_hus (pi_hus_user_id_old);
--
   l_rec_hus_new                       := l_rec_hus_old;
   l_rec_hus_new.hus_user_id           := Null;
   l_rec_hus_new.hus_name              := pi_hus_name;
   l_rec_hus_new.hus_initials          := pi_hus_initials;
   l_rec_hus_new.hus_username          := pi_hus_username;
   l_rec_hus_new.hus_start_date        := pi_hus_start_date;
   l_rec_hus_new.hus_unrestricted      := pi_hus_unrestricted;
   l_rec_hus_new.hus_is_hig_owner_flag := 'N';
--
   OPEN  cs_da (c_username => l_rec_hus_old.hus_username);
   FETCH cs_da
    INTO l_default_tablespace
        ,l_temporary_tablespace
        ,l_profile;
   CLOSE cs_da;
--
   OPEN  cs_dtq (c_username   => l_rec_hus_old.hus_username
                ,c_tablespace => l_default_tablespace
                );
   FETCH cs_dtq INTO l_quota;
   CLOSE cs_dtq;
   IF l_quota = -1
    THEN
      l_quota := 'UNLIMITED';
   END IF;
--
   nm3ddl.create_user (p_rec_hus            => l_rec_hus_new
                      ,p_password           => pi_password
                      ,p_default_tablespace => l_default_tablespace
                      ,p_temp_tablespace    => l_temporary_tablespace
                      ,p_default_quota      => l_quota
                      ,p_profile            => l_profile
                      );
--
   IF pi_copy_roles
    THEN
      INSERT INTO hig_user_roles
            (hur_username
            ,hur_role
            ,hur_start_date
            )
      SELECT pi_hus_username
            ,hur_role
            ,pi_hus_start_date
       FROM  hig_user_roles
      WHERE  hur_username = l_rec_hus_old.hus_username;
      --
      -- This will not grant the roles. this cannot be done in here
      --  as oracle gets itself tied up in knots with the permissions
      --
   ELSE
      INSERT INTO hig_user_roles
             (hur_username
             ,hur_role
             ,hur_start_date
             )
      VALUES (pi_hus_username
             ,'HIG_USER'
             ,pi_hus_start_date
             );
   END IF;
--
   IF pi_copy_admin_units
    THEN
      INSERT INTO nm_user_aus_all
            (nua_user_id
            ,nua_admin_unit
            ,nua_start_date
            ,nua_end_date
            ,nua_mode
            )
      SELECT l_rec_hus_new.hus_user_id
            ,nua_admin_unit
            ,GREATEST(nua_start_date,pi_hus_start_date)
            ,nua_end_date
            ,nua_mode
       FROM  nm_user_aus_all
      WHERE  nua_user_id = l_rec_hus_old.hus_user_id
       AND  (nua_end_date IS NULL
            OR nua_end_date > pi_hus_start_date
            );
   END IF;
--
   IF pi_copy_user_options
    THEN
      INSERT INTO hig_user_options
            (huo_hus_user_id
            ,huo_id
            ,huo_value
            )
      SELECT l_rec_hus_new.hus_user_id
            ,huo_id
            ,huo_value
       FROM  hig_user_options
      WHERE  huo_hus_user_id = l_rec_hus_old.hus_user_id;
   END IF;
--
   po_hus_user_id_new := l_rec_hus_new.hus_user_id;
--
   COMMIT;
--
   nm_debug.proc_end(g_package_name,'copy_user');
--
END copy_user;
--
-----------------------------------------------------------------------------
--
FUNCTION historic_mode RETURN boolean IS

  l_retval boolean := FALSE;

BEGIN
  IF To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY') <> Trunc(SYSDATE) THEN
  	l_retval := TRUE;
  END IF;
  
  RETURN l_retval;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION user_is_higowner(pi_username IN hig_users.hus_username%TYPE DEFAULT Sys_Context('NM3_SECURITY_CTX','USERNAME')) RETURN BOOLEAN IS

BEGIN
  RETURN(Nm3get.get_hus (pi_hus_username => pi_username ).hus_is_hig_owner_flag = 'Y');
EXCEPTION
 WHEN OTHERS THEN
  RETURN(FALSE);  
END user_is_higowner;
--
-----------------------------------------------------------------------------
--
FUNCTION user_is_higowner_yn(pi_username IN hig_users.hus_username%TYPE DEFAULT Sys_Context('NM3_SECURITY_CTX','USERNAME')) RETURN VARCHAR2 IS

BEGIN
  RETURN(Nm3get.get_hus (pi_hus_username => pi_username ).hus_is_hig_owner_flag);
EXCEPTION
 WHEN OTHERS THEN
  RETURN('N');  
END user_is_higowner_yn;
--
-----------------------------------------------------------------------------
--
FUNCTION get_default_temp_tablespace 
RETURN VARCHAR2 
IS
  CURSOR temp_tab_space(p_tablespace_name VARCHAR2)
  IS
  SELECT DISTINCT tablespace_name
  FROM dba_tablespaces
  WHERE contents = 'TEMPORARY'
  AND tablespace_name = p_tablespace_name;
  --
  retval VARCHAR2(100);
  --
BEGIN
  OPEN temp_tab_space(hig.get_sysopt('TMPTBLSPCE'));
  FETCH temp_tab_space INTO retval;
  IF temp_tab_space%NOTFOUND THEN
    BEGIN
      SELECT DISTINCT tablespace_name
      INTO retval
      FROM dba_tablespaces
      WHERE contents = 'TEMPORARY';
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
        retval:= NULL;
      WHEN NO_DATA_FOUND THEN
        retval:= NULL;
    END;
  END IF;
RETURN retval;
END get_default_temp_tablespace;
--
FUNCTION get_default_user_tablespace 
RETURN VARCHAR2 
IS
  CURSOR def_tab_space(p_tablespace_name VARCHAR2)
  IS
  SELECT DISTINCT tablespace_name
  FROM user_tablespaces
  WHERE contents = 'PERMANENT'
  AND tablespace_name != 'HHINV_LOAD_3_SPACE'
  AND tablespace_name = p_tablespace_name;
--
  retval VARCHAR2(100);
--
BEGIN
--
  OPEN def_tab_space(hig.get_sysopt('USRTBLSPCE'));
  FETCH def_tab_space INTO retval;
    IF def_tab_space%NOTFOUND THEN
      BEGIN
        SELECT DISTINCT tablespace_name
        INTO retval
        FROM user_tablespaces
        WHERE contents = 'PERMANENT'
        AND tablespace_name != 'HHINV_LOAD_3_SPACE';
      EXCEPTION
        WHEN TOO_MANY_ROWS THEN
          retval:= NULL;
        WHEN NO_DATA_FOUND THEN
          retval:= NULL;
      END;
    END IF;
  CLOSE def_tab_space;
RETURN retval;
--
END get_default_user_tablespace;
--
FUNCTION get_default_user_profile 
RETURN VARCHAR2 
IS
  CURSOR def_profile(p_profile_name VARCHAR2)
  IS
  SELECT distinct profile
  FROM dba_profiles
  WHERE profile = p_profile_name;
--
  retval VARCHAR2(100);
--
BEGIN
  OPEN def_profile(hig.get_sysopt('USRPROFILE'));
  FETCH def_profile INTO retval;
    IF def_profile%NOTFOUND THEN
      BEGIN  
        SELECT distinct profile
        INTO retval
        FROM dba_profiles;
      EXCEPTION
        WHEN TOO_MANY_ROWS THEN
          retval:= NULL;
        WHEN NO_DATA_FOUND THEN
          retval:= NULL;
      END;
    END IF;
  CLOSE def_profile;
  NULL;
RETURN retval;
END get_default_user_profile;
--
----------------------------------------------------------------------------------------------------------
--
Function Get_Default_User_Tablesp_Quota (
                                        p_User    In    Dba_Ts_Quotas.Username%Type
                                        ) Return Dba_Ts_Quotas.Max_Bytes%Type
Is
  l_Quota   Dba_Ts_Quotas.Max_Bytes%Type;
Begin
  Select  dtq.Max_Bytes
  Into    l_Quota
  From    Dba_Ts_Quotas   dtq,
          Dba_Users       du
  Where   du.Username           =   dtq.Username    
  And     dtq.Tablespace_Name   =   du.Default_Tablespace
  And     dtq.Username          =   p_User;
  
  Return(l_Quota);
  
Exception
  When No_Data_Found Then
    Raise_Application_Error(-20001,'User ' || p_User || ' has no quota on their default tablespace.');

End Get_Default_User_Tablesp_Quota;
                                                    
END nm3user;
/
