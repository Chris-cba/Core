CREATE OR REPLACE PACKAGE BODY hig_tab_fyr AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_tab_fyr.pkb	1.1 09/02/05
--       Module Name      : hig_tab_fyr.pkb
--       Date into SCCS   : 05/09/02 11:16:54
--       Date fetched Out : 07/06/13 14:10:25
--       SCCS Version     : 1.1
--
--
--   Author : 
--
--   Generated package DO NOT MODIFY
--
--   get_gen header : "@(#)hig_tab_fyr.pkb	1.1 09/02/05"
--   get_gen body   : @(#)hig_tab_fyr.pkb	1.1 09/02/05
--
-----------------------------------------------------------------------------
--
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
--
-----------------------------------------------------------------------------
--
   g_body_sccsid CONSTANT  VARCHAR2(2000) := '"@(#)hig_tab_fyr.pkb	1.1 09/02/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'hig_tab_fyr';
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
--
--   Function to get using FYR_PK constraint
--
FUNCTION get (pi_fyr_id            FINANCIAL_YEARS.fyr_id%TYPE
             ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
             ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
             ) RETURN FINANCIAL_YEARS%ROWTYPE IS
--
   CURSOR cs_fyr IS
   SELECT /*+ FIRST_ROWS(1) INDEX(fyr FYR_PK) */ 
          fyr_id
         ,fyr_start_date
         ,fyr_end_date
    FROM  FINANCIAL_YEARS fyr
   WHERE  fyr.fyr_id = pi_fyr_id;
--
   l_found  BOOLEAN;
   l_retval FINANCIAL_YEARS%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get');
--
   OPEN  cs_fyr;
   FETCH cs_fyr INTO l_retval;
   l_found := cs_fyr%FOUND;
   CLOSE cs_fyr;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'FINANCIAL_YEARS (FYR_PK)'
                                              ||CHR(10)||'fyr_id => '||pi_fyr_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get');
--
   RETURN l_retval;
--
END get;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using FYR_PK constraint
--
PROCEDURE del (pi_fyr_id            FINANCIAL_YEARS.fyr_id%TYPE
              ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
              ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
              ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
              ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del');
--
   -- Lock the row first
   l_rowid := lock_gen(
       pi_fyr_id            => pi_fyr_id
      ,pi_raise_not_found   => pi_raise_not_found
      ,pi_not_found_sqlcode => pi_not_found_sqlcode
      ,pi_locked_sqlcode    => pi_locked_sqlcode
      );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE /*+ ROWID(fyr)*/ FINANCIAL_YEARS fyr
      WHERE fyr.ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del');
--
END del;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using FYR_PK constraint
--
FUNCTION lock_gen (pi_fyr_id            FINANCIAL_YEARS.fyr_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_fyr IS
   SELECT /*+ FIRST_ROWS(1) INDEX(fyr FYR_PK) */ fyr.ROWID
    FROM  FINANCIAL_YEARS fyr
   WHERE  fyr.fyr_id = pi_fyr_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_gen');
--
   OPEN  cs_fyr;
   FETCH cs_fyr INTO l_retval;
   l_found := cs_fyr%FOUND;
   CLOSE cs_fyr;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'FINANCIAL_YEARS (FYR_PK)'
                                              ||CHR(10)||'fyr_id => '||pi_fyr_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_gen');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'FINANCIAL_YEARS (FYR_PK)'
                                              ||CHR(10)||'fyr_id => '||pi_fyr_id
                    );
--
END lock_gen;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using FYR_PK constraint
--
PROCEDURE lock_gen (pi_fyr_id            FINANCIAL_YEARS.fyr_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_gen');
--
   l_rowid := lock_gen
                   (pi_fyr_id            => pi_fyr_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_gen');
--
END lock_gen;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins (p_rec_fyr IN OUT FINANCIAL_YEARS%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins');
--
--
   INSERT INTO FINANCIAL_YEARS
   VALUES p_rec_fyr
  RETURNING fyr_id
           ,fyr_start_date
           ,fyr_end_date
     INTO   p_rec_fyr.fyr_id
           ,p_rec_fyr.fyr_start_date
           ,p_rec_fyr.fyr_end_date;
--
   nm_debug.proc_end(g_package_name,'ins');
--
END ins;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug (pi_rec_fyr FINANCIAL_YEARS%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug');
--
   nm_debug.debug('fyr_id         : '||pi_rec_fyr.fyr_id,p_level);
   nm_debug.debug('fyr_start_date : '||pi_rec_fyr.fyr_start_date,p_level);
   nm_debug.debug('fyr_end_date   : '||pi_rec_fyr.fyr_end_date,p_level);
--
   nm_debug.proc_end(g_package_name,'debug');
--
END debug;
--
-----------------------------------------------------------------------------
--
FUNCTION contiguous_sequence RETURN BOOLEAN IS

   total        number(4);
   total_contig number(4);
   min_date     date;

   -- count the number of continuous records
   -- these 2 cursors should give the same totals - all being well
   cursor total_cursor is
   select count(*)
        , min(fyr_start_date) 
   from financial_years;

   cursor contig_cursor is
   select count(distinct level) 
   from financial_years
   connect by prior to_char(fyr_end_date+1,'dd-mon-yy') =
                       to_char(fyr_start_date,'dd-mon-yy')
   start with fyr_start_date = min_date;
   
begin

   open total_cursor;
   fetch total_cursor into total, min_date;
   close total_cursor;
   
   if nvl(total, 0) != 0 then

      open contig_cursor;
      fetch contig_cursor into total_contig;
      close contig_cursor;

      if nvl(total,0) != nvl(total_contig,0) then
         RETURN(FALSE);
      end if;
   end if;

-- by default return TRUE   
   RETURN(TRUE);
END contiguous_sequence;
--
-----------------------------------------------------------------------------
--
PROCEDURE enforce_contiguous_sequence IS

BEGIN

 IF NOT contiguous_sequence THEN
    hig.raise_ner(pi_appl => nm3type.c_hig
	             ,pi_id   => 261);
 END IF;
 
END enforce_contiguous_sequence;
--
-----------------------------------------------------------------------------
--
END hig_tab_fyr;
/
