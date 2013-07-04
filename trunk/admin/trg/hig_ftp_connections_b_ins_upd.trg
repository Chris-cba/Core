CREATE OR REPLACE TRIGGER hig_ftp_connections_b_ins_upd
 BEFORE INSERT OR UPDATE OR DELETE
 ON HIG_FTP_CONNECTIONS
 FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/hig_ftp_connections_b_ins_upd.trg-arc   2.2   Jul 04 2013 09:53:16   James.Wadsworth  $
--       Module Name      : $Workfile:   hig_ftp_connections_b_ins_upd.trg  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:53:16  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:35:30  $
--       PVCS Version     : $Revision:   2.2  $
--
--
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_sysdate       DATE;
   l_user          VARCHAR2(30);
   l_forward_slash VARCHAR2(1) := '/';
   l_back_slash    VARCHAR2(1) := '\';
   l_rec_hfc       hig_ftp_connections%ROWTYPE;
--
  FUNCTION check_last_char ( pi_input IN VARCHAR2 )
  RETURN VARCHAR2
  IS
  BEGIN
    RETURN CASE 
             WHEN SUBSTR( pi_input
                         , LENGTH(pi_input)
                         , 1) NOT IN (l_back_slash,l_forward_slash)
             THEN pi_input||l_forward_slash
             ELSE pi_input
           END ;
  END check_last_char;
--
BEGIN
--
  IF NOT DELETING THEN
    :NEW.hfc_ftp_in_dir      := REPLACE (check_last_char (:NEW.hfc_ftp_in_dir), l_back_slash, l_forward_slash);
    :NEW.hfc_ftp_out_dir     := REPLACE (check_last_char (:NEW.hfc_ftp_out_dir), l_back_slash, l_forward_slash);
    :NEW.hfc_ftp_arc_in_dir  := REPLACE (check_last_char (:NEW.hfc_ftp_arc_in_dir), l_back_slash, l_forward_slash);
    :NEW.hfc_ftp_arc_out_dir := REPLACE (check_last_char (:NEW.hfc_ftp_arc_out_dir), l_back_slash, l_forward_slash);
  END IF;
--
  l_rec_hfc.hfc_id                  := NVL (:NEW.hfc_id,:OLD.hfc_id);
  l_rec_hfc.hfc_hft_id              := NVL (:NEW.hfc_hft_id,:OLD.hfc_hft_id);
  l_rec_hfc.hfc_name                := NVL (:NEW.hfc_name,:OLD.hfc_name);
  l_rec_hfc.hfc_nau_admin_unit      := NVL (:NEW.hfc_nau_admin_unit,:OLD.hfc_nau_admin_unit);
  l_rec_hfc.hfc_nau_unit_code       := NVL (:NEW.hfc_nau_unit_code,:OLD.hfc_nau_unit_code);
  l_rec_hfc.hfc_nau_admin_type      := NVL (:NEW.hfc_nau_admin_type,:OLD.hfc_nau_admin_type);
  l_rec_hfc.hfc_ftp_username        := NVL (:NEW.hfc_ftp_username,:OLD.hfc_ftp_username);
  l_rec_hfc.hfc_ftp_password        := NVL (:NEW.hfc_ftp_password,:OLD.hfc_ftp_password);
  l_rec_hfc.hfc_ftp_host            := NVL (:NEW.hfc_ftp_host,:OLD.hfc_ftp_host);
  l_rec_hfc.hfc_ftp_port            := NVL (:NEW.hfc_ftp_port,:OLD.hfc_ftp_port);
  l_rec_hfc.hfc_ftp_in_dir          := NVL (:NEW.hfc_ftp_in_dir,:OLD.hfc_ftp_in_dir);
  l_rec_hfc.hfc_ftp_out_dir         := NVL (:NEW.hfc_ftp_out_dir,:OLD.hfc_ftp_out_dir);
  l_rec_hfc.hfc_ftp_arc_username    := NVL (:NEW.hfc_ftp_arc_username,:OLD.hfc_ftp_arc_username);
  l_rec_hfc.hfc_ftp_arc_password    := NVL (:NEW.hfc_ftp_arc_password,:OLD.hfc_ftp_arc_password);
  l_rec_hfc.hfc_ftp_arc_host        := NVL (:NEW.hfc_ftp_arc_host,:OLD.hfc_ftp_arc_host);
  l_rec_hfc.hfc_ftp_arc_port        := NVL (:NEW.hfc_ftp_arc_port,:OLD.hfc_ftp_arc_port);
  l_rec_hfc.hfc_ftp_arc_in_dir      := NVL (:NEW.hfc_ftp_arc_in_dir,:OLD.hfc_ftp_arc_in_dir);
  l_rec_hfc.hfc_ftp_arc_out_dir     := NVL (:NEW.hfc_ftp_arc_out_dir,:OLD.hfc_ftp_arc_out_dir);
--
  nm3ftp.assess_acl ( pi_rec_hfc => l_rec_hfc
                    , pi_mode    => CASE
                                      WHEN INSERTING THEN nm3type.c_inserting
                                      WHEN DELETING  THEN nm3type.c_deleting
                                      WHEN UPDATING  THEN nm3type.c_updating
                                    END  );
--
END hig_ftp_connections_b_ins_upd;
/
