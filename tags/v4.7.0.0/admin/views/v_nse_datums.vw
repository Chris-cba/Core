CREATE OR replace force view v_nse_datums AS
SELECT
  nsm_nse_id nse_id,
  nsm_id,
  nsm_ne_id,
  nsm_seq_no,
  nsd_ne_id,
  nsd_seq_no,
  nsd_begin_mp,
  nsd_end_mp
FROM
  nm_saved_extent_members,
  nm_saved_extent_member_datums
WHERE
  nsm_id = nsd_nsm_id;
/
