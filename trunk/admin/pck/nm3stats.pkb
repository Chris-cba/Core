CREATE OR REPLACE PACKAGE BODY nm3stats AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3stats.pkb-arc   2.2   Jul 04 2013 16:32:58   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3stats.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:32:58  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:20  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.11
-------------------------------------------------------------------------
--
--   Author : Jonathan Mills
--
--   NM3 Statistics package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '$Revision:   2.2  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  VARCHAR2(30)   := 'nm3stats';
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
FUNCTION initialise_statistic_array RETURN nm_statistic_array IS
BEGIN
   RETURN nm_statistic_array(nm_statistic_array_type(nm_statistic(NULL
                                                                 ,NULL
                                                                 )
                                                    )
                            ,NULL --nsa_sum_x            NUMBER
                            ,NULL --nsa_sum_y            NUMBER
                            ,NULL --nsa_min_x            NUMBER
                            ,NULL --nsa_min_y            NUMBER
                            ,NULL --nsa_max_x            NUMBER
                            ,NULL --nsa_max_y            NUMBER
                            ,NULL --nsa_first_x          NUMBER
                            ,NULL --nsa_first_y          NUMBER
                            ,NULL --nsa_last_x           NUMBER
                            ,NULL --nsa_last_y           NUMBER
                            ,NULL --nsa_y_weighted_ave_x   NUMBER
                            ,NULL --nsa_x_weighted_ave_y   NUMBER
                            ,NULL --nsa_sum_xy_product     NUMBER
                            ,NULL --nsa_max_dec_places_x   NUMBER
                            ,NULL --nsa_max_dec_places_y   NUMBER
                            ,NULL --nsa_median_x           NUMBER
                            ,NULL --nsa_median_y           NUMBER
                            ,NULL --nsa_mean_x             NUMBER
                            ,NULL --nsa_mean_y             NUMBER
                            ,NULL --nsa_sd_x               NUMBER
                            ,NULL --nsa_sd_y               NUMBER
                            ,NULL --nsa_var_x              NUMBER
                            ,NULL --nsa_var_y              NUMBER
                            ,NULL --nsa_biased_sd_x        NUMBER
                            ,NULL --nsa_biased_sd_y        NUMBER
                            ,NULL --nsa_biased_var_x       NUMBER
                            ,NULL --nsa_biased_var_y       NUMBER
                            );
END initialise_statistic_array;
--
-----------------------------------------------------------------------------
--
/*
FUNCTION get_vkm ( p_start_date DATE
                  ,p_end_date   DATE
                  ,p_ne_id      NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                 )
RETURN NUMBER
IS
  l_start_date VARCHAR2(16) := nm3flx.string(TO_CHAR(p_start_date,'DD-MON-YYYY'));
  l_end_date   VARCHAR2(16) := nm3flx.string(TO_CHAR(p_end_date,'DD-MON-YYYY'));

  l_inv_col       VARCHAR2(30) := 'iit_aadt';
  l_inv_year_col  VARCHAR2(30)  := 'iit_year';
  l_traffic_table VARCHAR2(30) := 'V_NM_TSDA_NW';

  l_rtrn NUMBER;

  l_range_start_date VARCHAR2(200);
  l_range_end_date   VARCHAR2(200);

  c1 nm3type.ref_cursor;
BEGIN

   l_range_start_date := nm3flx.string( '01-JAN-' )||'||NVL(TO_CHAR('||l_inv_year_col||',9999),'||nm3flx.string(  '1900' )||'),'||nm3flx.string('DD-MON-YYYY')||')';
   l_range_end_date   := nm3flx.string( '31-DEC-' )||'||NVL(TO_CHAR('||l_inv_year_col||',9999),'||nm3flx.string(  '1900' )||'),'||nm3flx.string('DD-MON-YYYY')||')';

   OPEN c1 FOR
              'SELECT /*+RULE */  /* sum (( '||l_inv_col||' * '

   ||CHR(10)||'              (least( to_date('||l_end_date||'),'
   ||CHR(10)||'                      to_date('||l_range_end_date||')'
   ||CHR(10)||'              -'
   ||CHR(10)||'              greatest( to_date('||l_start_date||'),'
   ||CHR(10)||'                      to_date('||l_range_start_date||' ) + 1'
   ||CHR(10)||'             ) / 365'
   ||CHR(10)||'           ) * ( m.nte_end_mp - m.nte_begin_mp) )/1000'
   ||CHR(10)||'  FROM '||l_traffic_table||'  iit'
   ||CHR(10)||'       , nm_nw_temp_extents m'
   ||CHR(10)||' WHERE m.nte_ne_id_of = iit.ne_id_of'
   ||CHR(10)||'   AND m.nte_job_id = '||p_ne_id
   ||CHR(10)||'   AND TO_DATE('||l_range_start_date
   ||CHR(10)||'       <  to_date('||l_end_date||')'
   ||CHR(10)||'   AND TO_DATE('||l_range_end_date
   ||CHR(10)||'       >  TO_DATE('||l_start_date||')';

   FETCH c1 INTO l_rtrn;

   CLOSE c1;

   RETURN l_rtrn;
END get_vkm;
--
*/

function yr_first_day( p_yr in number ) return date is
begin
  if p_yr is not null then
    return to_date('0101'||to_char(p_yr),'DDMMYYYY');
  else
    return null;
  end if;
end;

-----------------------------------------------------------------------------

function yr_last_day( p_yr in number ) return date is
begin
  if p_yr is not null then
    return to_date('3112'||to_char(p_yr),'DDMMYYYY');
  else
    return null;
  end if;
end;
-----------------------------------------------------------------------------
--

/*
function get_vkm ( p_start_date DATE
                   ,p_end_date   DATE
                   ,p_ne_id      NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                   ) return number is

cursor c1( c_ne_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE ) is
  select sum ( (
            (least( a.nm_end_mp, nte_end_mp) - greatest(a.nm_begin_mp, nte_begin_mp))*0.001 * i.iit_length ) *
            (least(  yr_last_day( i.iit_end_chain ), p_end_date) -
             greatest(  yr_first_day( i.iit_end_chain ), p_start_date))+1 )/1000000
  from nm_members a, nm_inv_items i, nm_nw_temp_extents
  where a.nm_ne_id_of = nte_ne_id_of
  and   a.nm_begin_mp <= nte_end_mp
  and   a.nm_end_mp >= nte_begin_mp
  and   a.nm_obj_type = 'TSDA'
  and   a.nm_ne_id_in = i.iit_ne_id
  and   nte_job_id = c_ne_id
  and   i.iit_end_chain between to_number( to_char( p_start_date, 'YYYY'))
                        and     to_number( to_char( p_end_date, 'YYYY'));

retval number;

begin

  open c1( p_ne_id );
  fetch c1 into retval;
  close c1;
  return retval;

end;
*/
-----------------------------------------------------------------------------
function get_vkm(p_start_date IN DATE
                ,p_end_date   IN DATE
                ,p_ne_id      IN nm_elements_all.ne_id%TYPE) RETURN NUMBER IS
  --
  lv_sql    nm3type.max_varchar2;
  lv_sql2   nm3type.max_varchar2;
  lv_retval NUMBER;
  --
  lv_nit_inv_type   VARCHAR2(4);
  lv_aadt_col       VARCHAR2(50);
  lv_start_date_col VARCHAR2(50);
  lv_end_date_col   VARCHAR2(50);
  --
begin
  --Get Traffic Data Information
  BEGIN
    lv_sql := 'select atd_nit_inv_type, atd_aadt_col, atd_start_date_col, atd_end_date_col from acc_traffic_data';
    execute immediate lv_sql
       into lv_nit_inv_type
           ,lv_aadt_col
           ,lv_start_date_col
           ,lv_end_date_col
          ;
  EXCEPTION
    WHEN OTHERS
     THEN
        lv_nit_inv_type := NULL;
  END;
  --
  IF lv_nit_inv_type IS NOT NULL
   THEN
      lv_sql2 := 'SELECT SUM( ((LEAST(a.nm_end_mp, b.nm_end_mp)-GREATEST(a.nm_begin_mp, b.nm_begin_mp)) * i.'||lv_aadt_col||')'
               ||' * (LEAST(yr_last_day(i.'||lv_end_date_col||'), :cp_end_date) - GREATEST(yr_first_day(i.'||lv_start_date_col||'), :cp_start_date)) '
               ||' +1) /1000000 '
               ||'  FROM nm_members a '
               ||'      ,nm_inv_items i '
               ||'      ,nm_members b '
               ||' WHERE a.nm_ne_id_of  = b.nm_ne_id_of '
               ||'   AND a.nm_begin_mp <= b.nm_end_mp '
               ||'   AND a.nm_end_mp   >= b.nm_begin_mp '
               ||'   AND a.nm_obj_type  = '||nm3flx.string(lv_nit_inv_type)
               ||'   AND a.nm_ne_id_in  = i.iit_ne_id '
               ||'   AND b.nm_ne_id_in  = :cp_ne_id '
               ||'   AND i.'||lv_start_date_col||' >= TO_NUMBER(TO_CHAR(:cp_start_date, '||nm3flx.string('YYYY')||')) '
               ||'   AND i.'||lv_end_date_col||' <= TO_NUMBER(TO_CHAR(:cp_end_date, '||nm3flx.string('YYYY')||')) '
              ;
      execute immediate lv_sql2
         into lv_retval
        using p_end_date
             ,p_start_date
             ,p_ne_id
             ,p_start_date
             ,p_end_date
            ;
  END IF;
  --
  RETURN lv_retval;
  --
end;
END nm3stats;
/
