CREATE OR REPLACE FORCE VIEW hig_file_transfer_batch
(
  hftb_hftq_batch_no
 ,hftb_total
 ,hftb_compl
 ,hftb_error
)
AS
  SELECT hftl_hftq_batch_no
       , count(*)
       , count(no_compl)
       , count(no_error)
    FROM (SELECT DISTINCT
                 hftl_hftq_batch_no
                ,hftl_hftq_id
                ,hftq_status
                ,hftq_hp_process_id
                ,decode(hftq_status, 'TRANSFER COMPLETE', 'X', NULL) no_compl
                ,decode(hftq_status, 'ERROR', 'X', NULL) no_error
            FROM hig_file_transfer_log, hig_file_transfer_queue
           WHERE hftq_id = hftl_hftq_id)
  GROUP BY hftl_hftq_batch_no
  ORDER BY hftl_hftq_batch_no DESC
/