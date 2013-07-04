CREATE OR REPLACE PACKAGE BODY higfav AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)higfav.pkb	1.10 07/13/06
--       Module Name      : higfav.pkb
--       Date into SCCS   : 06/07/13 12:02:30
--       Date fetched Out : 07/06/13 14:10:33
--       SCCS Version     : 1.10
--
--
--   Author : K Angus
--
--   Package for manipulating the system and user favourites.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '@(#)higfav.pkb	1.10 07/13/06';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  VARCHAR2(30)   := 'higfav';
--
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
PROCEDURE ins_huf(pi_huf_rec IN HIG_USER_FAVOURITES%ROWTYPE
                 ) IS
BEGIN
  INSERT INTO
    HIG_USER_FAVOURITES
        (huf_user_id
        ,huf_parent
        ,huf_child
        ,huf_descr
        ,huf_type
        )
  VALUES(pi_huf_rec.huf_user_id
        ,pi_huf_rec.huf_parent
        ,pi_huf_rec.huf_child
        ,pi_huf_rec.huf_descr
        ,pi_huf_rec.huf_type
        );
END ins_huf;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_hsf(pi_hsf_rec IN HIG_SYSTEM_FAVOURITES%ROWTYPE
                 ) IS
BEGIN
  INSERT INTO
    HIG_SYSTEM_FAVOURITES
        (hsf_user_id
        ,hsf_parent
        ,hsf_child
        ,hsf_descr
        ,hsf_type
        )
  VALUES(pi_hsf_rec.hsf_user_id
        ,pi_hsf_rec.hsf_parent
        ,pi_hsf_rec.hsf_child
        ,pi_hsf_rec.hsf_descr
        ,pi_hsf_rec.hsf_type
        );
END ins_hsf;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_huf_descr(pi_user_id IN HIG_USER_FAVOURITES.huf_user_id%TYPE
                       ,pi_parent  IN HIG_USER_FAVOURITES.huf_parent%TYPE
                       ,pi_child   IN HIG_USER_FAVOURITES.huf_child%TYPE
                       ,pi_descr   IN HIG_USER_FAVOURITES.huf_descr%TYPE
                       ) IS
BEGIN
  UPDATE
    HIG_USER_FAVOURITES
  SET
    huf_descr = pi_descr
  WHERE
    huf_user_id = pi_user_id
  AND
    huf_parent = pi_parent
  AND
    huf_child = pi_child;

END set_huf_descr;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_hsf_descr(pi_user_id IN HIG_SYSTEM_FAVOURITES.hsf_user_id%TYPE
                       ,pi_parent  IN HIG_SYSTEM_FAVOURITES.hsf_parent%TYPE
                       ,pi_child   IN HIG_SYSTEM_FAVOURITES.hsf_child%TYPE
                       ,pi_descr   IN HIG_SYSTEM_FAVOURITES.hsf_descr%TYPE
                       ) IS
BEGIN
  UPDATE
    HIG_SYSTEM_FAVOURITES
  SET
    hsf_descr = pi_descr
  WHERE
    hsf_user_id = pi_user_id
  AND
    hsf_parent = pi_parent
  AND
    hsf_child = pi_child;

END set_hsf_descr;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_hstf_descr(pi_parent  IN HIG_STANDARD_FAVOURITES.hstf_parent%TYPE
                        ,pi_child   IN HIG_STANDARD_FAVOURITES.hstf_child%TYPE
                        ,pi_descr   IN HIG_STANDARD_FAVOURITES.hstf_descr%TYPE
                       ) IS
BEGIN
  UPDATE
    HIG_STANDARD_FAVOURITES
  SET
    hstf_descr = pi_descr
  WHERE
    hstf_parent = pi_parent
  AND
    hstf_child = pi_child;

END set_hstf_descr;
--
-----------------------------------------------------------------------------
--
PROCEDURE del_huf_cascading(pi_user_id IN HIG_USER_FAVOURITES.huf_user_id%TYPE
                           ,pi_parent  IN HIG_USER_FAVOURITES.huf_parent%TYPE
                           ,pi_child   IN HIG_USER_FAVOURITES.huf_child%TYPE
                           ) IS
BEGIN
  DELETE
    HIG_USER_FAVOURITES huf1
  WHERE
    huf1.ROWID IN (SELECT
                      huf2.ROWID
                    FROM
                      HIG_USER_FAVOURITES huf2
                    WHERE
                      huf2.huf_user_id = pi_user_id
                    CONNECT BY
                      PRIOR huf2.huf_child = huf2.huf_parent
                    START WITH
                      huf2.huf_parent = pi_parent
                    AND
                      huf2.huf_child = pi_child
                    AND
                      huf2.huf_user_id = pi_user_id);
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE del_hsf_cascading(pi_user_id IN HIG_SYSTEM_FAVOURITES.hsf_user_id%TYPE
                           ,pi_parent  IN HIG_SYSTEM_FAVOURITES.hsf_parent%TYPE
                           ,pi_child   IN HIG_SYSTEM_FAVOURITES.hsf_child%TYPE
                           ) IS
BEGIN
  DELETE
    HIG_SYSTEM_FAVOURITES hsf1
  WHERE
    hsf1.ROWID IN (SELECT
                      hsf2.ROWID
                    FROM
                      HIG_SYSTEM_FAVOURITES hsf2
                    WHERE
                      hsf2.hsf_user_id = pi_user_id
                    CONNECT BY
                      PRIOR hsf2.hsf_child = hsf2.hsf_parent
                    START WITH
                      hsf2.hsf_parent = pi_parent
                    AND
                      hsf2.hsf_child = pi_child
                    AND
                      hsf2.hsf_user_id = pi_user_id);
END;
--
-----------------------------------------------------------------------------
--
FUNCTION include_node_in_standards_tree(pi_hstf_type            IN  HIG_STANDARD_FAVOURITES.hstf_type%TYPE
                                       ,pi_hstf_parent          IN  HIG_STANDARD_FAVOURITES.hstf_parent%TYPE
                                       ,pi_hstf_child           IN  HIG_STANDARD_FAVOURITES.hstf_child%TYPE
                                       ) RETURN VARCHAR2 IS

   l_retval VARCHAR2(1) := 'N';

   ---------------------------------------------------------
   -- For each hstf_type of 'F' (folder)
   -- we will only show the folder if there
   -- is a module that exists in the structure below
   -- that folder and the module can be ran by user
   ---------------------------------------------------------
   CURSOR c1(pi_start_with IN VARCHAR2) IS
   SELECT 'Y'
   FROM   HIG_STANDARD_FAVOURITES hstf
   WHERE  hstf_type = 'M'
   AND    Nm3user.user_can_run_module_vc(hstf_child) = 'Y'
   CONNECT BY PRIOR hstf_child  = hstf_parent
   START WITH       hstf_parent = pi_start_with;

BEGIN

     IF pi_hstf_type = 'F' THEN

        ------------------------------------------------------------------------------------------------
        -- if immediately under the FAVOURITES branch on the standards tree that the child is the actual
        -- product code - therefore see if the product is actually licenced - if not then go no further
        ------------------------------------------------------------------------------------------------
--        IF pi_hstf_parent = 'FAVOURITES' AND NOT Hig.is_product_licensed(pi_hstf_child) THEN
--          l_retval := 'N';
--        ELSE

           -------------------------------------------------------------------------------------------------------
           -- only show this folder if there are favourites of the given module type restriction at a lower level
           -- in the hierarchy
           -------------------------------------------------------------------------------------------------------
           OPEN c1(pi_hstf_child);
           FETCH c1 INTO l_retval;
           CLOSE c1;
--        END IF;

        IF l_retval IS NULL THEN
             l_retval := 'N';
        END IF;

     ELSIF pi_hstf_type = 'M' THEN
	    l_retval := Nm3user.user_can_run_module_vc(pi_hstf_child);
	 END IF;

     RETURN l_retval;

END include_node_in_standards_tree;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_hstf_for_tree ( po_tab_initial_state    IN OUT nm3type.tab_number
                             ,po_tab_depth            IN OUT nm3type.tab_number
                             ,po_tab_label            IN OUT nm3type.tab_varchar80
                             ,po_tab_icon             IN OUT nm3type.tab_varchar30
                             ,po_tab_data             IN OUT nm3type.tab_varchar30
                             ,po_tab_parent           IN OUT nm3type.tab_varchar30) IS


 CURSOR c_branches IS
 SELECT hpr.hpr_product c_branch
      , Null            c_depth
      , Null            c_type
 FROM   hig_products hpr
 WHERE  hpr.hpr_key IS NOT NULL
 AND  exists (select 'x'
              from   exor_product_txt ept
              where  ept.hpr_product   = hpr.hpr_product
              and    NVL(ept.exor_file_version,hpr.hpr_version) = hpr.hpr_version) 
 ORDER BY DECODE(hpr.hpr_product,'HIG',1
                             ,'NET',2
							 ,'AST',3
							 ,hpr.hpr_key) ASC;

							 
 l_tab_order_by         nm3type.tab_number; 
 l_tab_initial_state    nm3type.tab_number;
 l_tab_depth            nm3type.tab_number;
 l_tab_label            nm3type.tab_varchar80;
 l_tab_icon             nm3type.tab_varchar30;
 l_tab_data             nm3type.tab_varchar30;
 l_tab_parent           nm3type.tab_varchar30;   
 
--
-----------------
--
 PROCEDURE get_root_of_tree(po_tab_initial_state    IN OUT nm3type.tab_number
                           ,po_tab_depth            IN OUT nm3type.tab_number
                           ,po_tab_label            IN OUT nm3type.tab_varchar80
                           ,po_tab_icon             IN OUT nm3type.tab_varchar30
                           ,po_tab_data             IN OUT nm3type.tab_varchar30
                           ,po_tab_parent           IN OUT nm3type.tab_varchar30) IS

 
 BEGIN


      SELECT
             1                               initial_state
            ,1                               depth
            ,hstf_descr                      LABEL
            ,DECODE(hstf_type,'M', 'exormini'
                             ,'fdrclose')    icon
            ,hstf_child                      DATA
            ,hstf_parent                     PARENT
      BULK COLLECT INTO 
              po_tab_initial_state
             ,po_tab_depth
             ,po_tab_label
             ,po_tab_icon
             ,po_tab_data
             ,po_tab_parent
      FROM
            HIG_STANDARD_FAVOURITES
      WHERE hstf_parent = 'ROOT';
	  
 END get_root_of_tree;
--
-----------------
--
 PROCEDURE get_favs_for_branch(pi_start_with           IN     hig_standard_favourites.hstf_parent%TYPE
                              ,po_tab_initial_state    IN OUT nm3type.tab_number
                              ,po_tab_depth            IN OUT nm3type.tab_number
                              ,po_tab_label            IN OUT nm3type.tab_varchar80
                              ,po_tab_icon             IN OUT nm3type.tab_varchar30
                              ,po_tab_data             IN OUT nm3type.tab_varchar30
                              ,po_tab_parent           IN OUT nm3type.tab_varchar30
                              ,po_tab_order_by         IN OUT nm3type.tab_number) IS

   l_tab_order_by         nm3type.tab_number;
  
 
 BEGIN


      SELECT
             1                               initial_state
            ,depth+1                         depth
            ,hstf_descr                      LABEL
            ,DECODE(hstf_type,'M', 'exormini'
                             ,'fdrclose')    icon
            ,hstf_child                      DATA
            ,hstf_parent                     PARENT
            ,hstf_order                      order_by
      BULK COLLECT INTO
              po_tab_initial_state
             ,po_tab_depth
             ,po_tab_label
             ,po_tab_icon
             ,po_tab_data
             ,po_tab_parent
             ,po_tab_order_by
      FROM
             (SELECT
                     hstf_child
                    ,hstf_type
                    ,hstf_descr
                    ,LEVEL     depth
                    ,hstf_parent
                    ,hstf_order
              FROM
                     HIG_STANDARD_FAVOURITES
              CONNECT BY
              PRIOR  hstf_child = hstf_parent
              START WITH
                     hstf_child = pi_start_with
              ORDER SIBLINGS BY hstf_order ASC)
      WHERE
             higfav.include_node_in_standards_tree(hstf_type, hstf_parent, hstf_child) = 'Y';
 
 END get_favs_for_branch;
--
-----------------
--
 PROCEDURE get_favs_for_root(po_tab_initial_state    IN OUT nm3type.tab_number
                            ,po_tab_depth            IN OUT nm3type.tab_number
                            ,po_tab_label            IN OUT nm3type.tab_varchar80
                            ,po_tab_icon             IN OUT nm3type.tab_varchar30
                            ,po_tab_data             IN OUT nm3type.tab_varchar30
                            ,po_tab_parent           IN OUT nm3type.tab_varchar30
							,po_tab_order_by         IN OUT nm3type.tab_number) IS

   l_tab_order_by         nm3type.tab_number;
 
 BEGIN


      SELECT
             1                               initial_state
            ,depth                           depth
            ,hstf_descr                      LABEL
            ,DECODE(hstf_type,'M', 'exormini'
                             ,'fdrclose')    icon
            ,hstf_child                      DATA
            ,hstf_parent                     PARENT
            ,hstf_order                      order_by
      BULK COLLECT INTO
              po_tab_initial_state
             ,po_tab_depth
             ,po_tab_label
             ,po_tab_icon
             ,po_tab_data
             ,po_tab_parent
             ,po_tab_order_by
      FROM
             (SELECT
                     hstf_child
                    ,hstf_type
                    ,hstf_descr
                    ,LEVEL     depth
                    ,hstf_parent
                    ,hstf_order
              FROM
                     HIG_STANDARD_FAVOURITES
              CONNECT BY
              PRIOR  hstf_child = hstf_parent
              START WITH
                     hstf_child = 'FAVOURITES'
              ORDER SIBLINGS BY hstf_order ASC)
      WHERE
             higfav.include_node_in_standards_tree(hstf_type, hstf_parent, hstf_child) = 'Y'
      AND    depth = 2
      AND    hstf_type = 'M';			 
 
 END get_favs_for_root;
 
 
 PROCEDURE append IS
   l_nextrec              PLS_INTEGER; 
 BEGIN
 
    FOR v_nodes IN 1..l_tab_initial_state.COUNT LOOP
	 
        l_nextrec := po_tab_initial_state.COUNT+1;
	 
         po_tab_initial_state(l_nextrec) := l_tab_initial_state(v_nodes);
         po_tab_depth(l_nextrec)         := l_tab_depth(v_nodes);		 
         po_tab_label(l_nextrec)         := l_tab_label(v_nodes);	     						
         po_tab_icon(l_nextrec)          := l_tab_icon(v_nodes);
         po_tab_data(l_nextrec)          := l_tab_data(v_nodes);
	 po_tab_parent(l_nextrec)        := l_tab_parent(v_nodes);
		 
 	END LOOP;  -- v_nodes

 END append;
 
BEGIN


  ---------------------------
  -- Get the root of the menu
  ---------------------------
  get_root_of_tree(po_tab_initial_state    => po_tab_initial_state
                  ,po_tab_depth            => po_tab_depth
                  ,po_tab_label            => po_tab_label
                  ,po_tab_icon             => po_tab_icon
                  ,po_tab_data             => po_tab_data
                  ,po_tab_parent           => po_tab_parent);
  
 --------------------------------------------------------------------
 -- Build a branch for each product in hig_products that is licenced
 -------------------------------------------------------------------- 
 FOR v_recs IN c_branches LOOP
 
     get_favs_for_branch(pi_start_with           => v_recs.c_branch
                        ,po_tab_initial_state    => l_tab_initial_state
                        ,po_tab_depth            => l_tab_depth  
                        ,po_tab_label            => l_tab_label 
                        ,po_tab_icon             => l_tab_icon
                        ,po_tab_data             => l_tab_data
                        ,po_tab_parent           => l_tab_parent
						,po_tab_order_by         => l_tab_order_by);
						
    append;						
	
 END LOOP;  -- v_recs
 
 -------------------------------------------------------------------
 -- Finally, get any modules that sit directly under the root branch
 -------------------------------------------------------------------
 get_favs_for_root(po_tab_initial_state    => l_tab_initial_state
                  ,po_tab_depth            => l_tab_depth  
                  ,po_tab_label            => l_tab_label 
                  ,po_tab_icon             => l_tab_icon
                  ,po_tab_data             => l_tab_data
                  ,po_tab_parent           => l_tab_parent
		  ,po_tab_order_by         => l_tab_order_by);
 append;
						
END get_hstf_for_tree;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_hsf_for_tree ( pi_mode                 IN VARCHAR2 DEFAULT 'RUN'
                            ,po_tab_initial_state    IN OUT Nm3type.tab_number
                            ,po_tab_depth            IN OUT Nm3type.tab_number
                            ,po_tab_label            IN OUT Nm3type.tab_varchar80
                            ,po_tab_icon             IN OUT Nm3type.tab_varchar30
                            ,po_tab_data             IN OUT Nm3type.tab_varchar30
                            ,po_tab_parent           IN OUT Nm3type.tab_varchar30) IS

BEGIN

  ------------------------------------------------------------
  -- called from hig1807 program unit build_system_tree
  -- this will run a query and return in pl/sql tables
  -- all of the records that are used to construct the system
  -- administrators favourites
  ------------------------------------------------------------

  IF pi_mode = 'SELECT'  THEN

        SELECT
                 1                       initial_state,
                 LEVEL                   depth,
                 hsf_descr               LABEL,
                 DECODE(hsf_type
                                ,'M', 'exormini'
                                ,'fdrclose')    icon,
                 hsf_child               DATA,
                 hsf_parent
        BULK COLLECT INTO
                 po_tab_initial_state
                ,po_tab_depth
                ,po_tab_label
                ,po_tab_icon
                ,po_tab_data
                ,po_tab_parent
/*
        FROM
                 hig_system_favourites
        WHERE
                 hsf_user_id = 1
*/
        FROM
                 HIG_SYSTEM_FAVOURITES
                ,HIG_USERS
        WHERE
                 hus_username = Sys_Context('NM3CORE','APPLICATION_OWNER')
        AND      hsf_user_id = hus_user_id
--
        AND      hsf_type = 'F'
        CONNECT BY PRIOR
                     hsf_child = hsf_parent
        START WITH
                 hsf_parent = 'ROOT';
   ELSE

        SELECT
                 1                       initial_state,
                 depth                   depth,
                 hsf_descr               LABEL,
                 DECODE(hsf_type
                               ,'M', 'exormini'
                               ,'fdrclose')    icon,
                 hsf_child               DATA,
                 hsf_parent
        BULK COLLECT INTO
                 po_tab_initial_state
                ,po_tab_depth
                ,po_tab_label
                ,po_tab_icon
                ,po_tab_data
                ,po_tab_parent
        FROM
                (SELECT
                        hsf_child ,
                        hsf_type  ,
                        hsf_descr,
                        LEVEL     depth,
                        hsf_parent
/*
                 FROM
                        hig_system_favourites
                 WHERE
                        hsf_user_id = 1
*/
                 FROM
                        HIG_SYSTEM_FAVOURITES
                       ,HIG_USERS
                 WHERE
                        hus_username = Sys_Context('NM3CORE','APPLICATION_OWNER')
                 AND    hsf_user_id = hus_user_id
--
                 CONNECT BY PRIOR
                                hsf_child = hsf_parent
                 START WITH
                        hsf_parent = 'ROOT')
       WHERE     hsf_type = 'F'
       OR
                (hsf_child IN (SELECT
                                      hmr_module
                               FROM
                                      HIG_MODULE_ROLES,
                                      HIG_USER_ROLES
                               WHERE
                                      hmr_role = hur_role
                               AND
                                      hur_username = USER));
  END IF;
END get_hsf_for_tree;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_huf_for_tree ( pi_mode                 IN varchar2 DEFAULT 'RUN'
                            ,po_tab_initial_state    IN OUT nm3type.tab_number
                            ,po_tab_depth            IN OUT nm3type.tab_number
                            ,po_tab_label            IN OUT nm3type.tab_varchar80
                            ,po_tab_icon             IN OUT nm3type.tab_varchar30
                            ,po_tab_data             IN OUT nm3type.tab_varchar30
                            ,po_tab_parent           IN OUT nm3type.tab_varchar30) IS

BEGIN

  ------------------------------------------------------------
  -- called from hig1807 program unit build_user_tree
  -- this will run a query and return in pl/sql tables
  -- all of the records that are used to construct the user
  -- favourites
  ------------------------------------------------------------

  IF pi_mode = 'SELECT'  THEN

        SELECT
                 1                       initial_state,
                 level                   depth,
                 huf_descr               label,
                 Decode(huf_type
                                ,'M', 'exormini'
                                ,'fdrclose')    icon,
                 huf_child               data,
                 huf_parent
        BULK COLLECT INTO
                 po_tab_initial_state
                ,po_tab_depth
                ,po_tab_label
                ,po_tab_icon
                ,po_tab_data
                ,po_tab_parent
        FROM
                 hig_user_favourites
        WHERE
                 huf_user_id = To_Number(Sys_Context('NM3CORE','USER_ID'))
        AND      huf_type = 'F'
        START WITH
                 huf_child = 'FAVOURITES'
        AND      huf_user_id = To_Number(Sys_Context('NM3CORE','USER_ID'))
		CONNECT BY PRIOR
		         huf_child = huf_parent
        AND      huf_user_id = To_Number(Sys_Context('NM3CORE','USER_ID'));

   ELSE

        SELECT
                 1                       initial_state,
                 depth                   depth,
                 huf_descr               label,
                 Decode(huf_type
                               ,'M', 'exormini'
                               ,'fdrclose')    icon,
                 huf_child               data,
                 huf_parent
        BULK COLLECT INTO
                 po_tab_initial_state
                ,po_tab_depth
                ,po_tab_label
                ,po_tab_icon
                ,po_tab_data
                ,po_tab_parent
        FROM
                (SELECT
                        huf_child ,
                        huf_type  ,
                        huf_descr,
                        LEVEL     depth,
                        huf_parent
                 FROM
                        hig_user_favourites
                 WHERE
                        huf_user_id = To_Number(Sys_Context('NM3CORE','USER_ID'))
                 CONNECT BY PRIOR
				        huf_child = huf_parent
                 AND    huf_user_id = To_Number(Sys_Context('NM3CORE','USER_ID'))
                 START WITH
                        huf_parent = 'ROOT'
                 AND    huf_user_id = To_Number(Sys_Context('NM3CORE','USER_ID')))
       WHERE     huf_type = 'F'
       OR
                (huf_child IN (SELECT
                                      hmr_module
                               FROM
                                      hig_module_roles,
                                      hig_user_roles
                               WHERE
                                      hmr_role = hur_role
                               AND
                                      hur_username = Sys_Context('NM3_SECURITY_CTX','USERNAME')));

  END IF;

END get_huf_for_tree;
--
-----------------------------------------------------------------------------
--
END higfav;
/
