--  '@(#)rseheids.sql	1.1 04/18/01' - SCCS INFO
--    The two minus signs are needed to make the line a COMMENT line
--    The word REM does NOT work.
select rse_he_id  from road_sections
where rse_he_id in
(select rsm_rse_he_id_of from road_seg_membs
		  connect by prior rsm_rse_he_id_of = rsm_rse_he_id_in
		  start with rsm_rse_he_id_in = :c_road_id)
 union
 select rse_he_id from road_sections
 where rse_he_id= :c_road_id
