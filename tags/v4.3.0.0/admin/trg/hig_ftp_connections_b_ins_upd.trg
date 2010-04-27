CREATE OR REPLACE TRIGGER hig_ftp_connections_b_ins_upd
 BEFORE INSERT OR UPDATE
 ON HIG_FTP_CONNECTIONS
 FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/hig_ftp_connections_b_ins_upd.trg-arc   2.0   Apr 27 2010 13:50:34   aedwards  $
--       Module Name      : $Workfile:   hig_ftp_connections_b_ins_upd.trg  $
--       Date into PVCS   : $Date:   Apr 27 2010 13:50:34  $
--       Date fetched Out : $Modtime:   Apr 27 2010 13:49:48  $
--       PVCS Version     : $Revision:   2.0  $
--
--
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
   l_sysdate       DATE;
   l_user          VARCHAR2(30);
   l_forward_slash VARCHAR2(1) := '/';
   l_back_slash    VARCHAR2(1) := '\';
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
  :NEW.hfc_ftp_in_dir := REPLACE (check_last_char (:NEW.hfc_ftp_in_dir), l_back_slash, l_forward_slash);
--
  :NEW.hfc_ftp_out_dir := REPLACE (check_last_char (:NEW.hfc_ftp_out_dir), l_back_slash, l_forward_slash);
--
  :NEW.hfc_ftp_arc_in_dir := REPLACE (check_last_char (:NEW.hfc_ftp_arc_in_dir), l_back_slash, l_forward_slash);
--
  :NEW.hfc_ftp_arc_out_dir := REPLACE (check_last_char (:NEW.hfc_ftp_arc_out_dir), l_back_slash, l_forward_slash);
--
END hig_ftp_connections_b_ins_upd;
/
