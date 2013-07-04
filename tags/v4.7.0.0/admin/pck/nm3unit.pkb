create or replace package body nm3unit as
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3unit.pkb-arc   2.3   Jul 04 2013 16:35:54   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3unit.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:35:54  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:20  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 1.12
-------------------------------------------------------------------------
--   Author : Rob Coupe
--
--   nm3unit package
--
-----------------------------------------------------------------------------
-- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '$Revision:   2.3  $';
--  g_body_sccsid is the SCCS ID for the package body
   g_package_name    CONSTANT  VARCHAR2(30)   := 'nm3unit';
--
   TYPE tab_rec_un IS TABLE OF nm_units%ROWTYPE INDEX BY BINARY_INTEGER;
   g_tab_rec_un tab_rec_un;
   TYPE tab_rec_uc IS TABLE OF nm_unit_conversions%ROWTYPE INDEX BY BINARY_INTEGER;
   g_tab_rec_uc tab_rec_uc;
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
function get_default_unit_id return number is
begin
  return g_def_unit_id;
end;
--
-----------------------------------------------------------------------------
--
function get_next_ud_domain_id return number is
  cursor c1 is
    select ud_domain_id_seq.nextval from dual;
  retval number;
  begin
    open c1;
    fetch c1 into retval;
    close c1;
    return retval;
  end;
--
-----------------------------------------------------------------------------
--
function get_next_unit_id return number is
  cursor c1 is
    select un_unit_id_seq.nextval from dual;
  retval number;
  begin
    open c1;
    fetch c1 into retval;
    close c1;
    return retval;
  end;
--
-----------------------------------------------------------------------------
--
  function get_length_units return number is
  begin
    return g_def_unit_id;
  end;
--
-----------------------------------------------------------------------------
--
  function get_unit_name( p_un_id in number) return varchar2 is
     retval nm_units.un_unit_name%TYPE;
  begin
     IF g_tab_rec_un.EXISTS(p_un_id)
      THEN
        retval := g_tab_rec_un(p_un_id).un_unit_name;
     END IF;
    return retval;
  end;
--
-----------------------------------------------------------------------------
--
  function get_unit_id ( p_un_name in varchar2) return number is
     retval number;
     l_i PLS_INTEGER;
  begin
    l_i := g_tab_rec_un.FIRST;
    WHILE l_i IS NOT NULL
     LOOP
       IF g_tab_rec_un(l_i).un_unit_name = p_un_name
        THEN
          retval := g_tab_rec_un(l_i).un_unit_id;
          EXIT;
       END IF;
       l_i := g_tab_rec_un.NEXT(l_i);
    END LOOP;
    return retval;
  end;
--
-----------------------------------------------------------------------------
--
function convert_unit( p_un_id_in in number, p_un_id_out in number, p_value in number ) return number is
--
   l_rec_uc nm_unit_conversions%ROWTYPE;
--
  l_retval        number :=0;
--
  l_format_mask   varchar2(80)  := get_unit_mask(p_un_id_out);
--
begin
--
   IF p_un_id_in = p_un_id_out
    THEN
      RETURN p_value;
   END IF;
--
   l_rec_uc := get_uc(p_un_id_in,p_un_id_out);
--
   IF l_rec_uc.uc_conversion_factor IS NULL
    THEN
      DECLARE
         l_cur nm3type.ref_cursor;
         l_sql nm3type.max_varchar2;
      BEGIN
         l_sql :=           'SELECT TO_NUMBER(TO_CHAR('||l_rec_uc.uc_function||'(:l_old_value)'
                 ||CHR(10)||'                        ,'||CHR(39)||l_format_mask||CHR(39)
                 ||CHR(10)||'                        )'
                 ||CHR(10)||'                )'
                 ||CHR(10)||' FROM DUAL';
         OPEN  l_cur FOR l_sql USING p_value;
         FETCH l_cur
          INTO l_retval;
         CLOSE l_cur;
      EXCEPTION
--
          WHEN invalid_number
           THEN
             IF l_cur%ISOPEN
              THEN
                CLOSE l_cur;
             END IF;
            RAISE_APPLICATION_ERROR(-20001,'Unit conversion failed '||l_rec_uc.uc_function
                                           ||'('||p_value||') format mask '||l_format_mask
                                   );
      END;
   ELSE
      l_retval := TO_NUMBER(TO_CHAR(p_value*l_rec_uc.uc_conversion_factor,l_format_mask));
   END IF;
--
   RETURN l_retval;
--
end convert_unit;
--
-----------------------------------------------------------------------------
--
function get_unit_function ( p_un_id_in in number, p_un_id_out in number ) return varchar2 is
--
   not_found EXCEPTION;
   PRAGMA EXCEPTION_INIT(not_found,-20001);
--
BEGIN
--
   RETURN get_uc(p_un_id_in,p_un_id_out).uc_function;
--
EXCEPTION
--
   WHEN not_found
    THEN
      RETURN NULL;
--
end get_unit_function;
--
-----------------------------------------------------------------------------
--
  function get_gty_units    ( p_gty in varchar2 ) return number is
  cursor c1 is
    select nt_length_unit
    from nm_group_types, nm_types
    where ngt_group_type = p_gty
    and nt_type = ngt_nt_type;
  --
  retval number;
  begin
    open c1;
    fetch c1 into retval;
    if c1%notfound then
       raise_application_error(-20001, 'No units found');
       close c1;
    else
       close c1;
       return retval;
    end if;
  end;
--
-----------------------------------------------------------------------------
--
  function unit_exists ( p_domain_name in nm_unit_domains.ud_domain_name%type, p_unit_id in nm_units.un_unit_id%type ) return boolean is
  cursor c1 is
  select 'x' from nm_units, nm_unit_domains
  where un_unit_id = p_unit_id
  and   un_domain_id = ud_domain_id
  and   ud_domain_name = p_domain_name;

  dummy varchar2(1);
  retval boolean;
  begin
    open c1;
    fetch c1 into dummy;
    retval := c1%found;
    close c1;
    return retval;
  end;
--
-----------------------------------------------------------------------------
--
  function get_unit_mask ( p_unit_id in nm_units.un_unit_id%type ) return varchar2 is
  retval varchar2(80);
  begin
     IF g_tab_rec_un.EXISTS(p_unit_id)
      THEN
        retval := g_tab_rec_un(p_unit_id).un_format_mask;
     END IF;
    return retval;
  end;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_unit_conversion_function
                (pi_unit_id_in    IN nm_unit_conversions.uc_unit_id_in%TYPE
                ,pi_unit_id_out   IN nm_unit_conversions.uc_unit_id_out%TYPE
                ) IS
--
   l_uc nm_unit_conversions%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'build_unit_conversion_function');
--
   l_uc := get_uc (pi_unit_id_in, pi_unit_id_out);
--
   nm_debug.debug(l_uc.uc_conversion);
   nm3ddl.create_object_and_syns (l_uc.uc_function,l_uc.uc_conversion);
--
   nm_debug.proc_end(g_package_name,'build_unit_conversion_function');
--
END build_unit_conversion_function;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_all_unit_conv_functions IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'build_all_unit_conv_functions');
--
   FOR cs_rec IN (SELECT uc_unit_id_in
                        ,uc_unit_id_out
                        ,uc_function
                   FROM  nm_unit_conversions
                  ORDER BY uc_function
                 )
    LOOP
      nm_debug.debug(cs_rec.uc_unit_id_in||'->'||cs_rec.uc_unit_id_out||':'||cs_rec.uc_function);
      build_unit_conversion_function (cs_rec.uc_unit_id_in
                                     ,cs_rec.uc_unit_id_out
                                     );
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'build_all_unit_conv_functions');
--
END build_all_unit_conv_functions;
--
-----------------------------------------------------------------------------
--
FUNCTION get_function_from_factor (p_function_name nm_unit_conversions.uc_function%TYPE
                                  ,p_factor        nm_unit_conversions.uc_conversion_factor%TYPE
                                  ) RETURN nm_unit_conversions.uc_conversion%TYPE IS
--
   l_retval nm_unit_conversions.uc_conversion%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_function_from_factor');
--
   l_retval :=   'CREATE OR REPLACE FUNCTION '||p_function_name
      ||CHR(10)||'        (UNITSIN IN NUMBER) RETURN NUMBER IS'
      ||CHR(10)||'BEGIN'
      ||CHR(10)||'   RETURN UNITSIN*'||p_factor||';'
      ||CHR(10)||'END '||p_function_name||';';
--
   nm_debug.proc_end(g_package_name,'get_function_from_factor');
--
   RETURN l_retval;
--
END get_function_from_factor;
--
-----------------------------------------------------------------------------
--
function get_uc (p_un_id_in  in number
                ,p_un_id_out in number
                ) return nm_unit_conversions%ROWTYPE IS
--
--   CURSOR cs_uc ( c_un_id_in in number, c_un_id_out in number) IS
--   SELECT *
--    FROM  nm_unit_conversions
--    where uc_unit_id_in  = c_un_id_in
--    and   uc_unit_id_out = c_un_id_out;
--
   l_rec_uc nm_unit_conversions%ROWTYPE;
--
begin
--
   nm_debug.proc_start(g_package_name,'get_uc');
--
   FOR i IN 1..g_tab_rec_uc.COUNT
    LOOP
      IF   g_tab_rec_uc(i).uc_unit_id_in  = p_un_id_in
       AND g_tab_rec_uc(i).uc_unit_id_out = p_un_id_out
       THEN
         l_rec_uc := g_tab_rec_uc(i);
         EXIT;
      END IF;
   END LOOP;
   IF l_rec_uc.uc_unit_id_in IS NULL
    THEN
      RAISE_APPLICATION_ERROR(-20001,'No Unit conversion found '||p_un_id_in||'->'||p_un_id_out);
   END IF;
--   OPEN  cs_uc (p_un_id_in,p_un_id_out);
--   FETCH cs_uc INTO l_rec_uc;
--   IF cs_uc%NOTFOUND
--    THEN
--      CLOSE cs_uc;
--      RAISE_APPLICATION_ERROR(-20001,'No Unit conversion found '||p_un_id_in||'->'||p_un_id_out);
--   END IF;
--   CLOSE cs_uc;
--
   nm_debug.proc_end(g_package_name,'get_uc');
--
   RETURN l_rec_uc;
--
END get_uc;
--
-----------------------------------------------------------------------------
--
FUNCTION get_formatted_value (p_value   NUMBER
                             ,p_unit_id nm_units.un_unit_id%TYPE
                             ) RETURN nm_units.un_format_mask%TYPE IS
--
   l_retval nm_units.un_format_mask%TYPE;
   l_mask   nm_units.un_format_mask%TYPE;
--
BEGIN
--
   l_mask := get_unit_mask (p_unit_id);
--
   IF l_mask IS NOT NULL
    THEN
     l_retval := to_char(p_value,l_mask);
   ELSE
     l_retval := to_char(p_value);
   END IF;
--
   RETURN l_retval;
--
END get_formatted_value;
--
-----------------------------------------------------------------------------
--
function get_tol_from_unit_mask ( p_unit in number ) return number is

l_unit    nm_units%rowtype;
le10      number;
l_dp      integer;

begin

  l_unit := nm3get.get_un( p_unit );

--  nm_debug.debug_on;
--  nm_debug.debug('Units = '||l_unit.un_unit_name);
--  nm_debug.debug('Format = '||l_unit.un_format_mask);

  l_dp := length( substr( l_unit.un_format_mask, instr( l_unit.un_format_mask, '.', 1)+ 1));

  if l_dp = length( l_unit.un_format_mask ) then
--    nm_debug.debug('No DP');

    l_dp := 0;

  end if;

--  nm_debug.debug('DP = '||to_char(l_dp));

  le10   := power( 10, (-1 * ( l_dp + 1 ))) * 5;

--  nm_debug.debug('Working to '||to_char( le10 )||' tolerance');

  return le10;

end;
--
-----------------------------------------------------------------------------
--

FUNCTION get_rounding (p_tol IN NUMBER) RETURN INTEGER IS
  llog10   NUMBER;
  retval   INTEGER;
BEGIN
  IF p_tol = 0 THEN
     raise_application_error (-20002, 'Zero is out of range');
  END IF;

  llog10 := LOG (10, p_tol);
  -- Task 0110157, 0110158 and 4300
  retval := ABS (TRUNC (llog10)) + SIGN (llog10 * -1) - 1;
  RETURN retval;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION char_time_to_seconds(pi_time IN VARCHAR2) RETURN NUMBER IS

BEGIN

 RETURN(
      TO_NUMBER(TO_CHAR(TO_DATE(pi_time,'HH24:MI'), 'SSSSS'))
       );
       

END char_time_to_seconds;
--
-----------------------------------------------------------------------------
--
FUNCTION seconds_to_char_time(pi_seconds_past_midnight IN NUMBER) RETURN VARCHAR2 IS

BEGIN

 RETURN(
        TO_CHAR(TO_DATE(pi_seconds_past_midnight,'SSSSS'),'HH24:MI')
     );

END seconds_to_char_time;
--
-----------------------------------------------------------------------------
--
PROCEDURE instantiate_data IS
   CURSOR cs_un IS
   SELECT *
    FROM  nm_units;
   CURSOR cs_uc IS
   SELECT *
    FROM  nm_unit_conversions;
BEGIN
   g_tab_rec_un.DELETE;
   g_tab_rec_uc.DELETE;
   FOR cs_rec IN cs_un
    LOOP
      g_tab_rec_un(cs_rec.un_unit_id) := cs_rec;
   END LOOP;
   FOR cs_rec IN cs_uc
    LOOP
      g_tab_rec_uc(g_tab_rec_uc.COUNT+1) := cs_rec;
   END LOOP;
END instantiate_data;
--
-----------------------------------------------------------------------------
--
BEGIN
   instantiate_data;
end  nm3unit;
/
