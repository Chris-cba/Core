CREATE OR REPLACE PACKAGE BODY hig_web_context_help AS
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_web_context_help.pkb	1.1 12/11/02
--       Module Name      : hig_web_context_help.pkb
--       Date into SCCS   : 02/12/11 10:18:10
--       Date fetched Out : 05/01/17 16:31:21
--       SCCS Version     : 1.1
--
--
--   Author : Kevin Angus
--
--   hig_web_context_help body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '"@(#)hig_web_context_help.pkb	1.1 12/11/02"';

  g_package_name CONSTANT varchar2(30) := 'hghgfh';
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
FUNCTION get_html (  pc_module       varchar2,
                     pc_current_item varchar2) RETURN varchar2 IS
  --
  --
  -- Get product Area for module from Hig Modules
  --
  lc_product hig_products.hpr_product%TYPE;
  lc_block   hig_web_contxt_hlp.hwch_block%TYPE := SUBSTR(pc_current_item,1,INSTR(pc_current_item,'.')-1);
  lc_item    hig_web_contxt_hlp.hwch_item%TYPE  := SUBSTR(pc_current_item,INSTR(pc_current_item,'.')+1);
  --
  lc_html_string hig_web_contxt_hlp.hwch_html_string%TYPE;
  --
  lc_html_base_string hig_options.hop_value%TYPE := hig.get_sysopt('HTML_BASE');
  --
  lc_contents_page hig_options.hop_value%TYPE := hig.get_sysopt('HTMLHLPST');
  --
  CURSOR c1 IS
    SELECT hwch_html_string
	FROM   hig_web_contxt_hlp
	WHERE  hwch_product = lc_product
	AND    hwch_module  = UPPER(pc_module)
	AND    hwch_block   = lc_block
	AND    hwch_item    = lc_item;
  --
  CURSOR c2 IS
    SELECT hwch_html_string
	FROM   hig_web_contxt_hlp
	WHERE  hwch_product = lc_product
	AND    hwch_module  = UPPER(pc_module)
	AND    hwch_block   = lc_block
	AND    hwch_item    IS NULL;
  --
  CURSOR c3 IS
    SELECT hwch_html_string
	FROM   hig_web_contxt_hlp
	WHERE  hwch_product = lc_product
	AND    hwch_module  = UPPER(pc_module)
	AND    hwch_block   IS NULL
	AND    hwch_item    IS NULL;
  --
  CURSOR c4 IS
    SELECT hwch_html_string
	FROM   hig_web_contxt_hlp
	WHERE  hwch_product = lc_product
	AND    hwch_module  IS NULL
	AND    hwch_block   IS NULL
	AND    hwch_item    IS NULL;
  --
    CURSOR c5 IS
    SELECT decode(hmo_application, 'ENQ', 'DOC'
                                 , 'TMA_PR','TMA'
                                 , hmo_application)
    FROM   hig_modules
    WHERE  hmo_module = pc_module;
  --
BEGIN
   --
  -- IF pc_module IS NOT NULL THEN
     OPEN c5;
     FETCH c5
     INTO lc_product;
     CLOSE c5;
  /* ELSE
     hig.get_product(lc_product);
   END IF;
   --
   hig.get_product(lc_product);*/
   --
   OPEN  c1;
   FETCH c1
   INTO  lc_html_string;
   CLOSE c1;
   --
   IF lc_html_string IS NOT NULL THEN
     RETURN lc_html_base_string||lc_html_string;
   END IF;
   --
   OPEN  c2;
   FETCH c2
   INTO  lc_html_string;
   CLOSE c2;
   --
   IF lc_html_string IS NOT NULL THEN
     RETURN lc_html_base_string||lc_html_string;
   END IF;
   --
   OPEN  c3;
   FETCH c3
   INTO  lc_html_string;
   CLOSE c3;
   --
   IF lc_html_string IS NOT NULL THEN
     RETURN lc_html_base_string||lc_html_string;
   END IF;
   --
   OPEN  c4;
   FETCH c4
   INTO  lc_html_string;
   CLOSE c4;
   --
   IF lc_html_string IS NOT NULL THEN
     RETURN lc_html_base_string||lc_html_string;
   END IF;
   --
   RETURN lc_html_base_string||lc_contents_page;
   --
   EXCEPTION
     WHEN no_data_found THEN
       RETURN lc_contents_page;
     WHEN others THEN
       -- Consider logging the error and then re-raise
       RETURN lc_contents_page;
  END get_html;
  --
  -- Allow functionality not unlike WINHELP to just pass in Module Name as context
  --
  FUNCTION get_html ( pc_module_name  varchar2) RETURN varchar2 IS
  --
  lc_html_string varchar2(2000);
  --
  BEGIN
    lc_html_string := hig_web_context_help.get_html(pc_module_name,NULL);
    RETURN lc_html_string;
  END get_html;
  --
END hig_web_context_help;
/
