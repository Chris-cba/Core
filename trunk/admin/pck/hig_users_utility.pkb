CREATE OR REPLACE PACKAGE BODY hig_users_utility
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header   //vm_latest/archives/nm3/admin/pck/hig_user_utility.pkb-arc   3.0 Mar 31 2009 10:10:10   Linesh Sorathia  $
--       Module Name      : $Workfile:   hig_users_utility.pkb  $
--       Date into PVCS   : $Date:   May 08 2009 15:36:14  $
--       Date fetched Out : $Modtime:   Apr 29 2009 10:50:22  $
--       Version          : $Revision:   3.1  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   3.1  $';

  g_package_name CONSTANT varchar2(30) := 'hig_users_utility';
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
PROCEDURE upd_huc(pi_huc_rec          IN l_huc_rec
                 ,po_error_text OUT    Varchar2 )
IS
--
BEGIN
--
   IF Nvl(pi_huc_rec.HUD_huc_id,0) > 0 
   THEN
   --
       UPDATE hig_user_contacts_all
       SET    HUC_ADDRESS1       = pi_huc_rec.HUD_HUC_ADDRESS1,
              HUC_ADDRESS2       = pi_huc_rec.HUD_HUC_ADDRESS2 ,
              HUC_ADDRESS3       = pi_huc_rec.HUD_HUC_ADDRESS3,
              HUC_ADDRESS4       = pi_huc_rec.HUD_HUC_ADDRESS4,
              HUC_ADDRESS5       = pi_huc_rec.HUD_HUC_ADDRESS5,
              huc_tel_type_1     = pi_huc_rec.HUD_huc_tel_type_1,
              HUC_TELEPHONE_1    = pi_huc_rec.HUD_HUC_TELEPHONE_1,
              huc_primary_tel_1  = pi_huc_rec.HUD_huc_primary_tel_1,
              huc_tel_type_2     = pi_huc_rec.HUD_huc_tel_type_2,
              HUC_TELEPHONE_2    = pi_huc_rec.HUD_HUC_TELEPHONE_2 ,
              huc_primary_tel_2  = pi_huc_rec.HUD_huc_primary_tel_2,
              huc_tel_type_3     = pi_huc_rec.HUD_huc_tel_type_3,
              HUC_TELEPHONE_3    = pi_huc_rec.HUD_HUC_TELEPHONE_3,
              huc_primary_tel_3  = pi_huc_rec.HUD_huc_primary_tel_3 ,
              huc_tel_type_4     = pi_huc_rec.HUD_huc_tel_type4,
              HUC_TELEPHONE_4    = pi_huc_rec.HUD_HUC_TELEPHONE_4,
              huc_primary_tel_4  = pi_huc_rec.HUD_huc_primary_tel_4,
              HUC_POSTCODE       = pi_huc_rec.HUD_HUC_POSTCODE,
              HUC_DATE_MODIFIED  = sysdate,
              HUC_MODIFIED_BY    = user
       WHERE  huc_id             = pi_huc_rec.HUD_huc_id ;
   ELSE
       INSERT INTO hig_user_contacts_all
      (HUC_ID,
       huc_hus_user_id,
       HUC_ADDRESS1,
       HUC_ADDRESS2,
       HUC_ADDRESS3,
       HUC_ADDRESS4,
       HUC_ADDRESS5,
       huc_tel_type_1,
       HUC_TELEPHONE_1,
       huc_primary_tel_1 ,
       huc_tel_type_2 ,
       HUC_TELEPHONE_2,
       huc_primary_tel_2 ,
       huc_tel_type_3,
       HUC_TELEPHONE_3,
       huc_primary_tel_3 ,
       huc_tel_type_4,
       HUC_TELEPHONE_4,
       huc_primary_tel_4 ,
       HUC_POSTCODE,
       HUC_DATE_CREATED,
       HUC_DATE_MODIFIED,
       HUC_MODIFIED_BY,
       HUC_CREATED_BY)
       VALUES 
       (hig_hus_id_seq.nextval ,
        pi_huc_rec.HUD_hus_user_id ,
        pi_huc_rec.HUD_HUC_ADDRESS1, 
        pi_huc_rec.HUD_HUC_ADDRESS2, 
        pi_huc_rec.HUD_HUC_ADDRESS3, 
        pi_huc_rec.HUD_HUC_ADDRESS4, 
        pi_huc_rec.HUD_HUC_ADDRESS5, 
        pi_huc_rec.HUD_huc_tel_type_1, 
        pi_huc_rec.HUD_HUC_TELEPHONE_1, 
        pi_huc_rec.HUD_huc_primary_tel_1 , 
        pi_huc_rec.HUD_huc_tel_type_2, 
        pi_huc_rec.HUD_HUC_TELEPHONE_2, 
        pi_huc_rec.HUD_huc_primary_tel_2 , 
        pi_huc_rec.HUD_huc_tel_type_3, 
        pi_huc_rec.HUD_HUC_TELEPHONE_3, 
        pi_huc_rec.HUD_huc_primary_tel_3 , 
        pi_huc_rec.HUD_huc_tel_type4, 
        pi_huc_rec.HUD_HUC_TELEPHONE_4, 
        pi_huc_rec.HUD_huc_primary_tel_4 , 
        pi_huc_rec.HUD_HUC_POSTCODE, 
        Sysdate, 
        Sysdate, 
        User, 
        User 
        ) ;     
   --
   END IF ;
--
END upd_huc;
--
FUNCTION  get_primary_contact(pi_hus_user_id hig_users.hus_user_id%TYPE)
RETURN    hig_user_details_vw.HUD_huc_telephone_1%TYPE
IS
--
   CURSOR c_get_primary_contact
   IS
   SELECT CASE  
              WHEN huc_primary_tel_1 = 'Y' THEN huc_telephone_1
              WHEN huc_primary_tel_2 = 'Y' THEN huc_telephone_2
              WHEN huc_primary_tel_3 = 'Y' THEN huc_telephone_3
              WHEN huc_primary_tel_4 = 'Y' THEN huc_telephone_4
          END primary_contact
   FROM   hig_user_contacts_all
   WHERE  huc_hus_user_id = pi_hus_user_id ;
   l_primary_contact hig_user_details_vw.HUD_huc_telephone_1%TYPE ;

--
BEGIN
--
   OPEN  c_get_primary_contact;
   FETCH c_get_primary_contact INTO l_primary_contact;
   CLOSE c_get_primary_contact ;
   
   RETURN l_primary_contact;
--
END get_primary_contact;
--
FUNCTION  get_primary_contact(pi_hus_username hig_users.hus_username%TYPE DEFAULT User)
RETURN    hig_user_details_vw.HUD_huc_telephone_1%TYPE
IS
--
   CURSOR c_get_primary_contact
   IS
   SELECT CASE  
              WHEN huc_primary_tel_1 = 'Y' THEN huc_telephone_1
              WHEN huc_primary_tel_2 = 'Y' THEN huc_telephone_2
              WHEN huc_primary_tel_3 = 'Y' THEN huc_telephone_3
              WHEN huc_primary_tel_4 = 'Y' THEN huc_telephone_4
          END primary_contact
   FROM   hig_user_contacts_all
   WHERE  huc_hus_user_id = (SELECT hus_user_id 
                             FROM   hig_users 
                             WHERE  hus_username = pi_hus_username) ;
   l_primary_contact hig_user_details_vw.HUD_huc_telephone_1%TYPE ;

--
BEGIN
--
   OPEN  c_get_primary_contact;
   FETCH c_get_primary_contact INTO l_primary_contact;
   CLOSE c_get_primary_contact ;
   
   RETURN l_primary_contact;
--
END get_primary_contact;
--
FUNCTION get_telephone_no(pi_hus_user_id hig_users.hus_user_id%TYPE
                         ,pi_tel_type    hig_user_contacts_all.huc_tel_type_1%TYPE)
                          RETURN hig_user_contacts_all.huc_telephone_1%TYPE
IS
--
   CURSOR c_get_tel_no
   IS
   SELECT CASE  
              WHEN huc_tel_type_1 = pi_tel_type THEN huc_telephone_1
              WHEN huc_tel_type_2 = pi_tel_type THEN huc_telephone_2
              WHEN huc_tel_type_3 = pi_tel_type THEN huc_telephone_3
              WHEN huc_tel_type_4 = pi_tel_type THEN huc_telephone_4
          END tel_no
   FROM   hig_user_contacts_all
   WHERE  huc_hus_user_id = pi_hus_user_id ;
   
   l_tel_no hig_user_contacts_all.huc_telephone_1%TYPE ;

--
BEGIN
--
   OPEN  c_get_tel_no;
   FETCH c_get_tel_no INTO l_tel_no;
   CLOSE c_get_tel_no;
   
   RETURN l_tel_no;
--
END get_telephone_no;
--
FUNCTION get_telephone_no(pi_hus_username hig_users.hus_username%TYPE 
                         ,pi_tel_type     hig_user_contacts_all.huc_tel_type_1%TYPE)
                          RETURN hig_user_contacts_all.huc_telephone_1%TYPE
IS
--
CURSOR c_get_tel_no
   IS
   SELECT CASE  
              WHEN huc_tel_type_1 = pi_tel_type THEN huc_telephone_1
              WHEN huc_tel_type_2 = pi_tel_type THEN huc_telephone_2
              WHEN huc_tel_type_3 = pi_tel_type THEN huc_telephone_3
              WHEN huc_tel_type_4 = pi_tel_type THEN huc_telephone_4
          END tel_no
   FROM   hig_user_contacts_all
   WHERE  huc_hus_user_id = (SELECT hus_user_id 
                             FROM   hig_users 
                             WHERE  hus_username = pi_hus_username) ;
                             
   l_tel_no hig_user_contacts_all.huc_telephone_1%TYPE ;

--
BEGIN
--
   OPEN  c_get_tel_no;
   FETCH c_get_tel_no INTO l_tel_no;
   CLOSE c_get_tel_no;
   
   RETURN l_tel_no;
--
END get_telephone_no;
--
END hig_users_utility ;
/

