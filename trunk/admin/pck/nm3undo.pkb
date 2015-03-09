CREATE OR REPLACE PACKAGE BODY Nm3undo
IS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm3undo.pkb-arc   2.21   Mar 09 2015 17:00:58   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3undo.pkb  $
--       Date into PVCS   : $Date:   Mar 09 2015 17:00:58  $
--       Date fetched Out : $Modtime:   Mar 09 2015 16:59:24  $
--       PVCS Version     : $Revision:   2.21  $
--
--   Author : ITurnbull
--
--     nm3undo package. Used for unsplit, unmerge, unreplace
--
--
-----------------------------------------------------------------------------
-- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '"$Revision:   2.21  $"';
--  g_body_sccsid is the SCCS ID for the package body
   g_package_name   CONSTANT VARCHAR2 (2000) := 'nm3undo';
--
   c_split          CONSTANT VARCHAR2 (1)    := 'S';
   c_merge          CONSTANT VARCHAR2 (1)    := 'M';
   c_replace        CONSTANT VARCHAR2 (1)    := 'R';
   c_close          CONSTANT VARCHAR2 (1)    := 'C';

--
-----------------------------------------------------------------------------
--
   FUNCTION get_version
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_sccsid;
   END get_version;

--
-----------------------------------------------------------------------------
--
   FUNCTION get_body_version
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_body_sccsid;
   END get_body_version;

--
-----------------------------------------------------------------------------
--
PROCEDURE undo_scheme (p_ne_id_1     nm_elements.ne_id%TYPE DEFAULT NULL
                      ,p_ne_id_2     nm_elements.ne_id%TYPE DEFAULT NULL
                      ,p_ne_id_3     nm_elements.ne_id%TYPE DEFAULT NULL
                      ,p_operation   NM_ELEMENT_HISTORY.neh_operation%TYPE
                      ,p_op_date     DATE) IS
  product_not_licenced EXCEPTION;
BEGIN
  IF NOT hig.is_product_licensed(nm3type.c_stp) THEN
    RAISE product_not_licenced;
  END IF;

  CASE p_operation
    WHEN c_close THEN
--
     EXECUTE IMMEDIATE 'BEGIN' || CHR (10) ||
                       '   stp_network_ops.undo_close(pi_ne_id => :p_ne_id_1);' || CHR (10) ||
                       'END;'
                       USING IN p_ne_id_1;
--
   WHEN c_split THEN
     EXECUTE IMMEDIATE 'BEGIN' || CHR (10) ||
                       '   stp_network_ops.undo_split(pi_ne_id_old   => :pi_ne_id_old' || CHR (10) ||
                       '                             ,pi_ne_id_new_1 => :pi_ne_id_new_1' || CHR (10) ||
                       '                             ,pi_ne_id_new_2 => :pi_ne_id_new_2' || CHR (10) ||
                       '                             ,pi_op_date     => :pi_op_date);' || CHR (10) ||
                       'END;'
                       USING IN p_ne_id_1
                               ,p_ne_id_2
                               ,p_ne_id_3
                               ,p_op_date;
   WHEN c_merge THEN
     EXECUTE IMMEDIATE 'BEGIN' || CHR (10) ||
                       '   stp_network_ops.undo_merge(pi_merged_ne_id   => :pi_ne_id_old' || CHR (10) ||
                       '                             ,pi_ne_id_old_1    => :pi_ne_id_new_1' || CHR (10) ||
                       '                             ,pi_ne_id_old_2    => :pi_ne_id_new_2' || CHR (10) ||
                       '                             ,pi_effective_date => :pi_op_date);' || CHR (10) ||
                       'END;'
                       USING IN p_ne_id_3
                               ,p_ne_id_1
                               ,p_ne_id_2
                               ,p_op_date;
   WHEN c_replace THEN
     EXECUTE IMMEDIATE 'BEGIN' || CHR (10) ||
                       '   stp_network_ops.undo_replace(pi_ne_id_new   => :pi_ne_id_new' || CHR (10) ||
                       '                               ,pi_ne_id_old   => :pi_ne_id_old' || CHR (10) ||
                       '                               ,pi_op_date     => :pi_op_date);' || CHR (10) ||
                       'END;'
                       USING IN p_ne_id_1
                               ,p_ne_id_2
                               ,p_op_date;
   ELSE
     NULL; -- something screwy has been input
  END CASE;

EXCEPTION
  WHEN product_not_licenced THEN
    NULL;
END undo_scheme;
--
-----------------------------------------------------------------------------
--
   PROCEDURE undo_other_products (
      p_ne_id_1     nm_elements.ne_id%TYPE DEFAULT NULL,
      p_ne_id_2     nm_elements.ne_id%TYPE DEFAULT NULL,
      p_ne_id_3     nm_elements.ne_id%TYPE DEFAULT NULL,
      p_operation   NM_ELEMENT_HISTORY.neh_operation%TYPE,
      p_op_date     DATE
   )
   IS
   BEGIN

      Nm_Debug.proc_start (g_package_name, 'UNDO_OTHER_PRODUCTS');

      -- check product install
      --
      -- <ACC>
      --
      IF Hig.is_product_licensed (Nm3type.c_acc)
      THEN
         -- undo the action
         IF p_operation = c_split
         THEN                                                        -- split
--
          -- passes the ne_ids of the 2 new/split elements
            EXECUTE IMMEDIATE    ' BEGIN'
                              || CHR (10)
                              || '    accsplit.undo_split( pi_ne_id_old   => :p_ne_id_1'
                              || CHR (10)
                              || '                        ,pi_ne_id_new_1 => :p_ne_id_2'
                              || CHR (10)
                              || '                        ,pi_ne_id_new_2 => :p_ne_id_3'
                              || CHR (10)
                              || '                        ,pi_op_date     => :p_op_date);'
                              || CHR (10)
                              || 'END;'
                        USING IN p_ne_id_1, p_ne_id_2, p_ne_id_3, p_op_date;
--
         ELSIF p_operation = c_merge
         THEN                                                         -- merge
            -- passes the ne_id of the new/merged element
            EXECUTE IMMEDIATE    ' BEGIN'
                              || CHR (10)
                              || '    accmerge.undo_merge( pi_ne_id_old_1 => :pi_ne_id__1'
                              || CHR (10)
                              || '                        ,pi_ne_id_old_2 => :p_ne_id_2'
                              || CHR (10)
                              || '                        ,pi_ne_id_new => :pi_ne_id_3'
                              || CHR (10)
                              || '                        ,pi_op_date     => :p_op_date);'
                              || CHR (10)
                              || 'END;'
                        USING IN p_ne_id_1, p_ne_id_2, p_ne_id_3, p_op_date;
--
         ELSIF p_operation = c_replace
         THEN                                                       -- replace
        -- passes the ne_id of the new element
--
            EXECUTE IMMEDIATE    'BEGIN'
                              || CHR (10)
                              || '   accreplace.undo_replace( pi_ne_id_new => :p_ne_id_1'
                              || CHR (10)
                              || '                           ,pi_ne_id_old => :p_ne_id_2'
                              || CHR (10)
                              || '                           ,pi_op_date     => :p_op_date);'
                              || CHR (10)
                              || 'END;'
                        USING IN p_ne_id_1, p_ne_id_2, p_op_date;
--
         ELSIF p_operation = c_close
         THEN                                                         -- close
           -- passes the ne_id of the element
--
            EXECUTE IMMEDIATE    'BEGIN'
                              || CHR (10)
                              || '   accclose.undo_close(:p_ne_id_1);'
                              || CHR (10)
                              || 'END;'
                        USING IN p_ne_id_1;
--
         END IF;
      END IF;

      --
      -- </ACC>
      --
      --
      -- <STR>
      --
      -- check product is installed
      IF Hig.is_product_licensed (Nm3type.c_str)
      THEN
         -- undo the action
         IF p_operation = c_split
         THEN                                                        -- split
            -- passes the ne_ids of the 2 new/split elements
            EXECUTE IMMEDIATE    'DECLARE'
                              || CHR (10)
                              || '    l_err_no NUMBER;'
                              || CHR (10)
                              || '    l_err_msg VARCHAR(100);'
                              || CHR (10)
                              || ' BEGIN'
                              || CHR (10)
                              || '    Strsplit.check_data_unsplit(:p_ne_id_2,:p_ne_id_3,:p_op_date,l_err_no,l_err_msg);'
                              || CHR (10)
                              || 'END;'
                        USING IN p_ne_id_2, p_ne_id_3, p_op_date;

--
            EXECUTE IMMEDIATE    'BEGIN'
                              || CHR (10)
                              || '   Strsplit.unsplit_data(:p_ne_id_1, :p_ne_id_2,:p_ne_id_3, :p_op_date);'
                              || CHR (10)
                              || 'END;'
                        USING IN p_ne_id_1, p_ne_id_2, p_ne_id_3, p_op_date;
--
         ELSIF p_operation = c_merge
         THEN                                                         -- merge
            -- passes the ne_id of the new/merged element
            EXECUTE IMMEDIATE    'DECLARE'
                              || CHR (10)
                              || '    l_err_no NUMBER;'
                              || CHR (10)
                              || '    l_err_msg VARCHAR(100);'
                              || CHR (10)
                              || ' BEGIN'
                              || CHR (10)
                              || '    Strmerge.check_data_unmerge(:p_ne_id_3,:p_ne_id_1,:p_ne_id_2,:p_op_date,l_err_no,l_err_msg);'
                              || CHR (10)
                              || 'END;'
                        USING IN p_ne_id_3,p_ne_id_1,p_ne_id_2,p_op_date;

--
            EXECUTE IMMEDIATE    'BEGIN'
                              || CHR (10)
                              || '   Strmerge.unmerge_data(:p_ne_id_3, :p_ne_id_1, :p_ne_id_2, :p_op_date);'
                              || CHR (10)
                              || 'END;'
                        USING IN p_ne_id_3,p_ne_id_1,p_ne_id_2,p_op_date;
--
         ELSIF p_operation = c_replace
         THEN                                                       -- replace
            -- passes the ne_id of the new element
            EXECUTE IMMEDIATE    'DECLARE'
                              || CHR (10)
                              || '    l_err_no NUMBER;'
                              || CHR (10)
                              || '    l_err_msg VARCHAR(100);'
                              || CHR (10)
                              || ' BEGIN'
                              || CHR (10)
                              || '    Strrepl.check_data_unreplace(:p_ne_id_1,:p_op_date,l_err_no,l_err_msg);'
                              || CHR (10)
                              || 'END;'
                        USING IN p_ne_id_1, p_op_date;

--
            EXECUTE IMMEDIATE    'BEGIN'
                              || CHR (10)
                              || '   Strrepl.unreplace_data(:p_ne_id_2, :p_ne_id_1, :p_op_date);'
                              || CHR (10)
                              || 'END;'
                        USING IN p_ne_id_2, p_ne_id_1, p_op_date;
--
         ELSIF p_operation = c_close
         THEN                                                         -- close
            -- passes the ne_id of the element
            EXECUTE IMMEDIATE    'DECLARE'
                              || CHR (10)
                              || '    l_err_no NUMBER;'
                              || CHR (10)
                              || '    l_err_msg VARCHAR(100);'
                              || CHR (10)
                              || ' BEGIN'
                              || CHR (10)
                              || '    Strclose.check_data_unclose(:p_ne_id_1,l_err_no,l_err_msg);'
                              || CHR (10)
                              || 'END;'
                        USING IN p_ne_id_1;

--
            EXECUTE IMMEDIATE    'BEGIN'
                              || CHR (10)
                              || '   Strclose.unclose_data(:p_ne_id_1, :p_op_date);'
                              || CHR (10)
                              || 'END;'
                        USING IN p_ne_id_1, p_op_date;
--
         END IF;
      END IF;

      --
      -- </STR>
      --
      --
      -- <MAI>
      --
      -- check product is installed
      IF Hig.is_product_licensed (Nm3type.c_mai)
      THEN
         -- undo the action
         IF p_operation = c_split
         THEN
            EXECUTE IMMEDIATE    'DECLARE'
                              || CHR (10)
                              || '   c_id_orig       CONSTANT NUMBER := :p_ne_id_orig;'
                              || CHR (10)
                              || '   c_id_new_1      CONSTANT NUMBER := :p_ne_id_new_1;'
                              || CHR (10)
                              || '   c_id_new_2      CONSTANT NUMBER := :p_ne_id_new_2;'
                              || CHR (10)
                              || '   c_op_date       CONSTANT DATE   := :p_op_date;'
                              || CHR (10)
                              || '   l_errors                 nm3type.max_varchar2;'
                              || CHR (10)
                              || '   l_error_string           nm3type.max_varchar2;'
                              || CHR (10)
                              || 'BEGIN'
                              || CHR (10)
                              || '   maisplit.check_data_unsplit'
                              || CHR (10)
                              || '      (p_id1           => c_id_new_1'
                              || CHR (10)
                              || '      ,p_id2           => c_id_new_2'
                              || CHR (10)
                              || '      ,p_actioned      => c_op_date'
                              || CHR (10)
                              || '      ,p_errors        => l_errors'
                              || CHR (10)
                              || '      ,p_error_string  => l_error_string'
                              || CHR (10)
                              || '      );'
                              || CHR (10)
                              || '   maisplit.unsplit_data'
                              || CHR (10)
                              || '      (p_id           => c_id_orig'
                                                      -- section to be unsplit
                              || CHR (10)
                              || '      ,p_id1          => c_id_new_1'
                                                        -- first split section
                              || CHR (10)
                              || '      ,p_id2          => c_id_new_2'
                                                       -- second split section
                              || CHR (10)
                              || '      ,p_history_date => c_op_date'
                              || CHR (10)
                              || '      );'
                              || CHR (10)
                              || 'END;'
                        USING IN p_ne_id_1, p_ne_id_2, p_ne_id_3, p_op_date;
         ELSIF p_operation = c_merge
         THEN
            EXECUTE IMMEDIATE    'DECLARE'
                              || CHR (10)
                              || '   c_id_to_unmerge CONSTANT NUMBER := :p_ne_id_unmerge;'
                              || CHR (10)
                              || '   c_id_orig_1     CONSTANT NUMBER := :p_ne_id_orig_1;'
                              || CHR (10)
                              || '   c_id_orig_2     CONSTANT NUMBER := :p_ne_id_orig_2;'
                              || CHR (10)
                              || '   c_op_date       CONSTANT DATE   := :p_op_date;'
                              || CHR (10)
                              || '   l_errors                 nm3type.max_varchar2;'
                              || CHR (10)
                              || '   l_error_string           nm3type.max_varchar2;'
                              || CHR (10)
                              || 'BEGIN'
                              || CHR (10)
                              || '   maimerge.check_data_unmerge'
                              || CHR (10)
                              || '      (p_id            => c_id_to_unmerge'
                              || CHR (10)
                              || '      ,p_actioned_date => c_op_date'
                              || CHR (10)
                              || '      ,p_errors        => l_errors'
                              || CHR (10)
                              || '      ,p_error_string  => l_error_string'
                              || CHR (10)
                              || '      );'
                              || CHR (10)
                              || '   maimerge.unmerge_data'
                              || CHR (10)
                              || '      (p_id           => c_id_to_unmerge'
                              || CHR (10)
                              || '      ,p_rse_he_id_1  => c_id_orig_1'
                              || CHR (10)
                              || '      ,p_rse_he_id_2  => c_id_orig_2'
                              || CHR (10)
                              || '      ,p_history_date => c_op_date'
                              || CHR (10)
                              || '      );'
                              || CHR (10)
                              || 'END;'
                        USING IN p_ne_id_3, p_ne_id_1, p_ne_id_2, p_op_date;
         ELSIF p_operation = c_replace
         THEN
            EXECUTE IMMEDIATE    'DECLARE'
                              || CHR (10)
                              || '   c_id_orig CONSTANT NUMBER := :p_ne_id_orig;'
                              || CHR (10)
                              || '   c_id_del  CONSTANT NUMBER := :p_ne_id_del;'
                              || CHR (10)
                              || '   c_op_date CONSTANT DATE   := :p_op_date;'
                              || CHR (10)
                              || '   l_errors           nm3type.max_varchar2;'
                              || CHR (10)
                              || '   l_error_string     nm3type.max_varchar2;'
                              || CHR (10)
                              || 'BEGIN'
                              || CHR (10)
                              || '   mairepl.check_data_unreplace'
                              || CHR (10)
                              || '      (p_id            => c_id_del'
                              || CHR (10)
                              || '      ,p_actioned_date => c_op_date'
                              || CHR (10)
                              || '      ,p_errors        => l_errors'
                              || CHR (10)
                              || '      ,p_error_string  => l_error_string'
                              || CHR (10)
                              || '      );'
                              || CHR (10)
                              || '   mairepl.unreplace_data'
                              || CHR (10)
                              || '      (p_id_orig      => c_id_orig'
                              || CHR (10)
                              || '      ,p_id_del       => c_id_del'
                              || CHR (10)
                              || '      ,p_history_date => c_op_date'
                              || CHR (10)
                              || '      );'
                              || CHR (10)
                              || 'END;'
                        USING IN p_ne_id_2, p_ne_id_1, p_op_date;
         ELSIF p_operation = c_close
         THEN
            EXECUTE IMMEDIATE    'BEGIN'
                              || CHR (10)
                              || '   maiclose.unclose_data'
                              || CHR (10)
                              || '      (p_id           => :p_ne_id_1'
                              || CHR (10)
                              || '      ,p_history_date => :p_op_date'
                              || CHR (10)
                              || '      );'
                              || CHR (10)
                              || 'END;'
                        USING IN p_ne_id_1, p_op_date;
         END IF;
      END IF;

      --
      -- </MAI>
      --
      -- Schemes
      undo_scheme(p_ne_id_1   => p_ne_id_1
                 ,p_ne_id_2   => p_ne_id_2
                 ,p_ne_id_3   => p_ne_id_3
                 ,p_operation => p_operation
                 ,p_op_date   => p_op_date);
      --

      -- check product install
      --
      -- <PROW>
      --
      IF Hig.is_product_licensed (Nm3type.c_prow)
      THEN
         -- undo the action
         IF p_operation = c_split
         THEN -- split
          -- passes the ne_ids of the 2 new/split elements and the id of the original element
            EXECUTE IMMEDIATE    ' BEGIN'
                              || CHR (10)|| '    prowsplit.unsplit_data( p_old_id   => :p_ne_id_1'
                              || CHR (10)|| '                           ,p_new_id1 => :p_ne_id_2'
                              || CHR (10)|| '                           ,p_new_id2 => :p_ne_id_3);'
                              || CHR (10)|| 'END;'
                        USING IN p_ne_id_1, p_ne_id_2, p_ne_id_3;
--
         ELSIF p_operation = c_merge
         THEN -- merge
            -- passes the ne_id of the merged element and the id's of the 2 original elements
            EXECUTE IMMEDIATE    ' BEGIN'
                              || CHR (10)|| '    prowmerge.unmerge_data( p_new_id => :p_ne_id_1'
                              || CHR (10)|| '                           ,p_old_id1 => :p_ne_id_2'
                              || CHR (10)|| '                           ,p_old_id2 => :p_ne_id_3);'
                              || CHR (10)|| 'END;'
                        USING IN p_ne_id_1, p_ne_id_2, p_ne_id_3;
--
         END IF;
      END IF;

      --
      -- </PROW>
      --

      --
      -- <UKP>
      --
      IF Hig.is_product_licensed (Nm3type.c_ukp)
      THEN
         -- undo the action
         IF p_operation = c_split
         THEN

            EXECUTE IMMEDIATE 'BEGIN'
                || CHR (10)|| '   ukpsplit.undo_split( p_rse_original => :p_ne_id_1 '
                || CHR (10)|| '                       ,p_rse_split1   => :p_ne_id_2 '
                || CHR (10)|| '                       ,p_rse_split2   => :p_ne_id_3);'
                || CHR (10)|| 'END;'
            USING IN p_ne_id_1, p_ne_id_2, p_ne_id_3;
--
         ELSIF p_operation = c_merge     
         THEN

            EXECUTE IMMEDIATE 'BEGIN'
                || CHR (10)|| '   ukpmerge.check_undo_merge( p_merged_rse    => :p_ne_id_3 '
                || CHR (10)|| '                             ,p_actioned_date => :p_op_date );'
                || CHR (10)|| 'END;'
            USING IN p_ne_id_3, p_op_date;

            EXECUTE IMMEDIATE 'BEGIN'
                || CHR (10)|| '   ukpmerge.undo_merge( p_merged_rse => :p_ne_id_3 '
                || CHR (10)|| '                       ,p_old_rse_1  => :p_ne_id_1 '
                || CHR (10)|| '                       ,p_old_rse_2  => :p_ne_id_2 );'
                || CHR (10)|| 'END;'
            USING IN p_ne_id_3, p_ne_id_1, p_ne_id_2;

         ELSIF p_operation = c_replace
         THEN
         
            EXECUTE IMMEDIATE 'BEGIN'
                || CHR (10)|| '   ukprepl.undo_replace( p_new_rse      => :p_ne_id_1'
                || CHR (10)|| '                        ,p_original_rse => :p_ne_id_2);'
                || CHR (10)|| 'END;'
            USING IN p_ne_id_1, p_ne_id_2;

         ELSIF p_operation = c_close
         THEN

            EXECUTE IMMEDIATE 'BEGIN'
                || CHR (10)|| '   ukpclose.undo_close( p_rse     => :p_ne_id_1'
                || CHR (10)|| '                       ,p_op_date => :p_op_date);'
                || CHR (10)|| 'END;'
            USING IN p_ne_id_1, p_op_date;
            
         END IF;

      END IF;

      -- check product install
      -- </UKP>
      --

      Nm_Debug.proc_end (g_package_name, 'UNDO_OTHER_PRODUCTS');

   END undo_other_products;

--
-----------------------------------------------------------------------------
--
   PROCEDURE lock_parent (p_ne_id nm_elements.ne_id%TYPE)
   IS
   BEGIN
      Nm_Debug.proc_start (g_package_name, 'lock_parent');
      Nm3lock.lock_parent (p_ne_id);
      Nm_Debug.proc_end (g_package_name, 'lock_parent');
   END;

--
-----------------------------------------------------------------------------
--
   PROCEDURE get_undo_data (
      p_ne_id        IN       nm_elements.ne_id%TYPE,
      p_operation    OUT      VARCHAR2,
      p_ne_id_new1   OUT      nm_elements.ne_id%TYPE,
      p_ne_id_new2   OUT      nm_elements.ne_id%TYPE,
      p_ne_id_old1   OUT      nm_elements.ne_id%TYPE,
      p_ne_id_old2   OUT      nm_elements.ne_id%TYPE
   )
   IS
      CURSOR c_hist_from_new (c_ne_id nm_elements.ne_id%TYPE)
      IS
         SELECT neh.neh_ne_id_new, neh.neh_ne_id_old, neh.neh_operation
           FROM NM_ELEMENT_HISTORY neh
          WHERE neh.neh_ne_id_new = c_ne_id
            AND NOT EXISTS (
                   SELECT 1
                     FROM NM_MEMBERS_ALL
                    WHERE nm_ne_id_of = neh.neh_ne_id_new
                      AND TRUNC (nm_date_modified) >
                                                 TRUNC (neh.neh_actioned_date))
            AND NOT EXISTS (SELECT 1
                              FROM NM_ELEMENT_HISTORY neh2
                             WHERE neh2.neh_ne_id_old = neh.neh_ne_id_new);

      CURSOR c_hist_from_old (c_ne_id nm_elements.ne_id%TYPE)
      IS
         SELECT neh.neh_ne_id_new, neh.neh_ne_id_old, neh.neh_operation
           FROM NM_ELEMENT_HISTORY neh
          WHERE neh.neh_ne_id_old = c_ne_id
            AND NOT EXISTS (
                   SELECT 1
                     FROM NM_MEMBERS_ALL
                    WHERE nm_ne_id_of = neh.neh_ne_id_new
                      AND TRUNC (nm_date_modified) >
                                                 TRUNC (neh.neh_actioned_date))
            AND NOT EXISTS (SELECT 1
                              FROM NM_ELEMENT_HISTORY neh2
                             WHERE neh2.neh_ne_id_old = neh.neh_ne_id_new);

      l_op    NM_ELEMENT_HISTORY.neh_operation%TYPE;
      l_new   nm_elements.ne_id%TYPE;
      l_old   nm_elements.ne_id%TYPE;
   BEGIN
      OPEN c_hist_from_new (p_ne_id);

      FETCH c_hist_from_new
       INTO l_new, l_old, l_op;

      IF c_hist_from_new%NOTFOUND
      THEN
         CLOSE c_hist_from_new;

         OPEN c_hist_from_old (p_ne_id);

         FETCH c_hist_from_old
          INTO l_new, l_old, l_op;

         IF c_hist_from_old%NOTFOUND
         THEN
            CLOSE c_hist_from_old;

            RAISE_APPLICATION_ERROR (-20001,
                                     'No suitable operations to undo');
         ELSE
            p_operation := l_op;
            p_ne_id_new1 := l_new;
            p_ne_id_old1 := l_old;

            IF l_op = 'S'
            THEN
               FETCH c_hist_from_old
                INTO l_new, l_old, l_op;

--        split - need to get the others - there will be two new for one old
                  p_ne_id_new2 := l_new;
                  p_ne_id_old2 := NULL;
            ELSIF l_op = 'M' then

              open c_hist_from_new( l_new );

              fetch c_hist_from_new into l_new, l_old, l_op;
              p_ne_id_new1 := l_new;
              p_ne_id_old1 := l_old;
              fetch c_hist_from_new into l_new, l_old, l_op;
--        merge - need to get the others - there will be two old for one new
              p_ne_id_new2 := NULL;
              p_ne_id_old2 := l_old;
              close c_hist_from_new;

            ELSE
               p_ne_id_new2 := NULL;
               p_ne_id_old2 := NULL;
            END IF;

            CLOSE c_hist_from_old;
         END IF;
      ELSE
         p_operation := l_op;
         p_ne_id_new1 := l_new;
         p_ne_id_old1 := l_old;

         IF l_op = 'M'
         THEN
            FETCH c_hist_from_new
             INTO l_new, l_old, l_op;

--      merge - need to get the others - there will be two old for one new
             p_ne_id_new2 := NULL;
             p_ne_id_old2 := l_old;

         ELSIF l_op = 'S' then
           open c_hist_from_old ( l_old );
           fetch c_hist_from_old into l_new, l_old, l_op;
           p_ne_id_new1 := l_new;
           p_ne_id_old1 := l_old;

--      split - need to get the others - there will be two new for one old

           fetch c_hist_from_old into l_new, l_old, l_op;
           p_ne_id_new2 := l_new;
           p_ne_id_old2 := NULL;

           close c_hist_from_old;

         ELSE
            p_ne_id_new2 := NULL;
            p_ne_id_old2 := NULL;
         END IF;

         CLOSE c_hist_from_new;
      END IF;

   END;

--
-----------------------------------------------------------------------------
--
   PROCEDURE check_members_added (
      pi_ne_id_old1   nm_elements.ne_id%TYPE,
      pi_ne_id_old2   nm_elements.ne_id%TYPE DEFAULT NULL,
      pi_ne_id_new1   nm_elements.ne_id%TYPE,
      pi_ne_id_new2   nm_elements.ne_id%TYPE DEFAULT NULL
   )
   -- checks if element as been added to any groups or
   -- had any inventory located on it since the day it was created
   IS
      CURSOR c1 (
         c_ne_id_old1   nm_elements.ne_id%TYPE,
         c_ne_id_old2   nm_elements.ne_id%TYPE,
         c_ne_id_new1   nm_elements.ne_id%TYPE,
         c_ne_id_new2   nm_elements.ne_id%TYPE
      )
      IS
         SELECT 1
           FROM nm_members a
          WHERE a.nm_ne_id_of IN (c_ne_id_new1, c_ne_id_new2)
            AND NOT EXISTS (
                   SELECT 1
                     FROM NM_MEMBERS_ALL b
                    WHERE b.nm_ne_id_in = a.nm_ne_id_in
                      AND b.nm_ne_id_of IN (c_ne_id_old1, c_ne_id_old2));

      dummy   NUMBER;
   BEGIN
      Nm_Debug.proc_start (g_package_name, 'check_members_added');

      OPEN c1 (pi_ne_id_old1, pi_ne_id_old2, pi_ne_id_new1, pi_ne_id_new2);

      FETCH c1
       INTO dummy;

      CLOSE c1;

      IF dummy > 0
      THEN
         RAISE_APPLICATION_ERROR (-20301,
                                  'Elements membership has been modified'
                                 );
      END IF;

      Nm_Debug.proc_end (g_package_name, 'check_members_added');
   END check_members_added;

--
-----------------------------------------------------------------------------
--
   PROCEDURE delete_element (
      p_ne_id_1   nm_elements.ne_id%TYPE,
      p_ne_id_2   nm_elements.ne_id%TYPE DEFAULT NULL
   )
   IS
   BEGIN
      Nm_Debug.proc_start (g_package_name, 'delete_element');

      -- delete the 1st element
--
      DELETE      NM_ELEMENTS_ALL
            WHERE ne_id = p_ne_id_1;

     -- AE - Don't need this as trigger handles it now.
     -- nm3sdm.remove_element_shapes(p_ne_id => p_ne_id_1 );
--
      -- delete 2nd element if required
      IF p_ne_id_2 IS NOT NULL
      THEN
         DELETE NM_ELEMENTS_ALL
          WHERE ne_id = p_ne_id_2;
      --   nm3sdm.remove_element_shapes(p_ne_id => p_ne_id_2 );
      END IF;

--
      Nm_Debug.proc_end (g_package_name, 'delete_element');
   END;

--
------------------------------------------------------------------------------------------------
--
   FUNCTION check_history (
      p_ne_id           nm_elements.ne_id%TYPE,
      p_neh_operation   NM_ELEMENT_HISTORY.neh_operation%TYPE
   )
      -- Check if any of the new ne_ids, for the old_ne_id has any history records
      -- if it does then return true
   RETURN BOOLEAN
   IS
      CURSOR c1
      IS
         SELECT neh_ne_id_new
           FROM NM_ELEMENT_HISTORY
          WHERE neh_ne_id_old = p_ne_id AND neh_operation = p_neh_operation;

      CURSOR c2 (c_ne_id nm_elements.ne_id%TYPE)
      IS
         SELECT 1
           FROM NM_ELEMENT_HISTORY neh
          WHERE neh_ne_id_old = c_ne_id
            and neh.neh_operation IN (nm3net_history.c_neh_op_split
                                     ,nm3net_history.c_neh_op_merge
                                     ,nm3net_history.c_neh_op_replace
                                     ,nm3net_history.c_neh_op_close
                                     ,nm3net_history.c_neh_op_reclassify
                                     ,nm3net_history.c_neh_op_reverse);

      v_found   NUMBER;
      retval    BOOLEAN := FALSE;
   BEGIN
      Nm_Debug.proc_start (g_package_name, 'check_history');

      FOR c1rec IN c1
      LOOP
         OPEN c2 (c1rec.neh_ne_id_new);

         FETCH c2
          INTO v_found;

         IF c2%FOUND
         THEN
            retval := TRUE;
         END IF;

         CLOSE c2;
      END LOOP;

--
      Nm_Debug.proc_end (g_package_name, 'check_history');

      IF retval
      THEN
         RAISE_APPLICATION_ERROR
                            (-20302,
                             'Other Network Operations performed on elements'
                            );
      END IF;

      RETURN retval;
   END check_history;

--
------------------------------------------------------------------------------------------------
--
   PROCEDURE delete_element_history (
      p_neh_ne_id_old   NM_ELEMENT_HISTORY.neh_ne_id_old%TYPE,
      p_neh_operation   NM_ELEMENT_HISTORY.neh_operation%TYPE
   )
   IS
   BEGIN
      Nm_Debug.proc_start (g_package_name, 'delete_element_history');

      DELETE      NM_ELEMENT_HISTORY
            WHERE neh_ne_id_old = p_neh_ne_id_old
              AND neh_operation = p_neh_operation;

      Nm_Debug.proc_end (g_package_name, 'delete_element_history');
   END delete_element_history;
--
------------------------------------------------------------------------------------------------
--
  PROCEDURE delete_element_history_for_new(pi_ne_id_new nm_element_history.neh_ne_id_new%type
                                          ) IS
  BEGIN
    nm_debug.proc_start(p_package_name   => g_package_name
                       ,p_procedure_name => 'delete_element_history_for_new');

  delete
    nm_element_history neh
  where
    neh.neh_ne_id_old = pi_ne_id_new;

    nm_debug.proc_end(p_package_name   => g_package_name
                     ,p_procedure_name => 'delete_element_history_for_new');

  END delete_element_history_for_new;
--
------------------------------------------------------------------------------------------------
--
-- return the node_id at the point two elements are connected
   FUNCTION connected_at (
      p_ne_id_1   nm_node_usages.nnu_ne_id%TYPE,
      p_ne_id_2   nm_node_usages.nnu_ne_id%TYPE
   )
      RETURN nm_node_usages.nnu_no_node_id%TYPE
   IS
      CURSOR cs_check (
         c_ne_id_1   nm_node_usages.nnu_ne_id%TYPE,
         c_ne_id_2   nm_node_usages.nnu_ne_id%TYPE
      )
      IS
         SELECT nnu1.nnu_no_node_id
           FROM nm_node_usages nnu1, nm_node_usages nnu2
          WHERE nnu1.nnu_ne_id = c_ne_id_1
            AND nnu2.nnu_ne_id = c_ne_id_2
            AND nnu1.nnu_no_node_id = nnu2.nnu_no_node_id;

--
      retval   nm_node_usages.nnu_no_node_id%TYPE   := NULL;
--
   BEGIN
      Nm_Debug.proc_start (g_package_name, 'connected_at');

      IF Nm3net.check_element_connectivity (p_ne_id_1, p_ne_id_2)
      THEN
         OPEN cs_check (p_ne_id_1, p_ne_id_2);

         FETCH cs_check
          INTO retval;

         CLOSE cs_check;
      END IF;

      Nm_Debug.proc_end (g_package_name, 'connected_at');
      RETURN retval;
   END connected_at;

--
------------------------------------------------------------------------------------------------
--
   PROCEDURE unsplit (p_ne_id nm_elements.ne_id%TYPE)
   IS
      error_loc integer := 0 ;
      CURSOR c1
      IS
         SELECT neh_ne_id_new, neh_effective_date
           FROM NM_ELEMENT_HISTORY
          WHERE neh_ne_id_old = p_ne_id AND neh_operation = c_split;

      l_ne_id_1                 nm_elements.ne_id%TYPE;
      l_ne_id_2                 nm_elements.ne_id%TYPE;
      l_effective_date          DATE;
      c_ausec_status   CONSTANT VARCHAR2 (3)           := Nm3ausec.get_status;

      --
      PROCEDURE set_for_return
      IS
      BEGIN
         error_loc := 1 ;
         Nm3ausec.set_status (c_ausec_status);
         Nm3merge.set_nw_operation_in_progress (FALSE);
         error_loc := 2 ;
      END set_for_return;

      PROCEDURE unsplit_datum (
         pi_ne_id            IN   nm_elements.ne_id%TYPE,
         pi_ne_id_1          IN   nm_elements.ne_id%TYPE,
         pi_ne_id_2          IN   nm_elements.ne_id%TYPE,
         pi_effective_date   IN   DATE
      )
      IS
      BEGIN
         error_loc := 3 ;
--         Nm_Debug.debug_on;
--         Nm_Debug.DEBUG('In Unsplit');
         -- delete the nm_members
         DELETE      NM_MEMBERS_ALL
               WHERE nm_ne_id_of IN (pi_ne_id_1, pi_ne_id_2);
         error_loc := 4 ;

         -- unclose the element
         UPDATE NM_ELEMENTS_ALL
            SET ne_end_date = NULL
          WHERE ne_id = p_ne_id;
         error_loc := 5 ;

         Nm_Debug.DEBUG ('Checking for AD data to unsplit');

         IF Nm3nwad.ad_data_exist (pi_ne_id,true)
         THEN
            Nm_Debug.DEBUG ('Unsplitting - '||pi_ne_id_1||'-'||pi_ne_id_2||'-'||pi_ne_id);
            error_loc := 9 ;
            Nm3nwad.do_ad_unsplit (pi_new_ne_id1      => pi_ne_id_1,
                                   pi_new_ne_id2      => pi_ne_id_2,
                                   pi_old_ne_id       => pi_ne_id
                                  );
            error_loc := 10 ;
         END IF;

         DECLARE
            CURSOR cs_nmh (
               c_nmh_ne_id_of_old     nm_members.nm_ne_id_of%TYPE,
               c_nmh_ne_id_of_new_1   nm_members.nm_ne_id_of%TYPE,
               c_nmh_ne_id_of_new_2   nm_members.nm_ne_id_of%TYPE
            )
            IS
               SELECT nmh_nm_ne_id_in, nmh_nm_ne_id_of_old, nmh_nm_begin_mp,
                      nmh_nm_start_date, nmh_nm_end_date
                 FROM NM_MEMBER_HISTORY
                WHERE nmh_nm_ne_id_of_new IN
                                (c_nmh_ne_id_of_new_1, c_nmh_ne_id_of_new_2)
                  AND nmh_nm_ne_id_of_old = c_nmh_ne_id_of_old;

            l_tab_ne_id_in     Nm3type.tab_number;
            l_tab_ne_id_of     Nm3type.tab_number;
            l_tab_begin_mp     Nm3type.tab_number;
            l_tab_start_date   Nm3type.tab_date;
            l_tab_end_date     Nm3type.tab_date;
         BEGIN
            error_loc := 6 ;

            OPEN cs_nmh (pi_ne_id, pi_ne_id_1, pi_ne_id_2);

            FETCH cs_nmh
            BULK COLLECT INTO l_tab_ne_id_in, l_tab_ne_id_of, l_tab_begin_mp,
                   l_tab_start_date, l_tab_end_date;

            CLOSE cs_nmh;
            error_loc := 7 ;

            -- This is debug code for when you get a 112 or other error
            -- Comment out the forall and comment this in to see where the error is
/*
            for i in 1..l_tab_ne_id_in.count
            loop
                nm_debug.debug('------ ' || i || ' ------');
                nm_debug.debug('nm_ne_id_in   = ' || l_tab_ne_id_in (i)    );
                nm_debug.debug('nm_ne_id_of   = ' || l_tab_ne_id_of (i)    );
                nm_debug.debug('nm_begin_mp   = ' || l_tab_begin_mp (i)    );
                nm_debug.debug('nm_start_date = ' || to_char(l_tab_start_date (i),'DD-MON-YYYY hh24:mi')  );
                nm_debug.debug('nm_end_date   = ' || l_tab_end_date (i)    );
                for l_of in ( select * from nm_elements_all where ne_id = l_tab_ne_id_of(i) )
                loop
                  nm_debug.debug('Of Unique = ' || l_of.ne_unique || ', start date = ' || l_of.ne_start_date || ', end_date = ' || l_of.ne_end_date ) ;
                end loop;
                for l_in in ( select * from nm_elements_all where ne_id = l_tab_ne_id_in(i) )
                loop
                  nm_debug.debug('In Unique = ' || l_in.ne_unique || ', start date = ' || l_in.ne_start_date || ', end_date = ' || l_in.ne_end_date ) ;
                end loop;
               UPDATE NM_MEMBERS_ALL
                  SET nm_end_date = l_tab_end_date (i)
                WHERE nm_ne_id_in = l_tab_ne_id_in (i)
                  AND nm_ne_id_of = l_tab_ne_id_of (i)
                  AND nm_begin_mp = l_tab_begin_mp (i)
                  AND nm_start_date = l_tab_start_date (i);
            end loop ;
            nm_debug.debug_off;
*/
            FORALL i IN 1 .. l_tab_ne_id_in.COUNT
               UPDATE NM_MEMBERS_ALL
                  SET nm_end_date = l_tab_end_date (i)
                WHERE nm_ne_id_in = l_tab_ne_id_in (i)
                  AND nm_ne_id_of = l_tab_ne_id_of (i)
                  AND nm_begin_mp = l_tab_begin_mp (i)
                  AND nm_start_date = l_tab_start_date (i);
--*/
            error_loc := 8 ;
         END;

--          IF Nm3nwad.ad_data_exist (pi_ne_id, TRUE)
--          THEN
--             Nm3nwad.do_ad_unsplit (pi_new_ne_id1      => pi_ne_id_1,
--                                    pi_new_ne_id2      => pi_ne_id_2,
--                                    pi_old_ne_id       => pi_ne_id
--                                   );
--          END IF;

         undo_other_products (p_ne_id_1        => pi_ne_id        -- old ne_id
                                                          ,
                              p_ne_id_2        => pi_ne_id_1      -- new ne_id
                                                            ,
                              p_ne_id_3        => pi_ne_id_2      -- new ne_id
                                                            ,
                              p_operation      => c_split,
                              p_op_date        => pi_effective_date
                             );

         error_loc := 11 ;
         -- unendate the node_usages
         UPDATE NM_NODE_USAGES_ALL
            SET nnu_end_date = NULL
          WHERE nnu_ne_id = pi_ne_id;
         --
         -- delete the history
         delete_element_history (pi_ne_id, c_split);

         delete_element_history_for_new(pi_ne_id_new => pi_ne_id_1);
         delete_element_history_for_new(pi_ne_id_new => pi_ne_id_2);

         error_loc := 12 ;

         -- delete the new elements
         delete_element (pi_ne_id_1, pi_ne_id_2);
         error_loc := 13 ;
      END unsplit_datum;

      PROCEDURE unsplit_group (
         pi_ne_id            IN   nm_elements.ne_id%TYPE,
         pi_ne_id_1          IN   nm_elements.ne_id%TYPE,
         pi_ne_id_2          IN   nm_elements.ne_id%TYPE,
         pi_effective_date   IN   DATE
      )
      IS
         l_tab_ne_id_of     Nm3type.tab_number; 
         l_rec_nm           nm_members%ROWTYPE;
      BEGIN
         nm_debug.debug_on;
          -- unsplit the underlying datums
		select nm_ne_id_of
          BULK COLLECT
          INTO l_tab_ne_id_of
		from  (
        SELECT distinct nm_ne_id_of
          FROM nm_members_all, 
               nm_elements_all, 
               nm_element_history a, 
               nm_element_history b
         WHERE nm_ne_id_in = pi_ne_id
           AND nm_ne_id_of = ne_id
           AND a.neh_ne_id_old = nm_ne_id_of 
           AND a.neh_operation = 'S'
           AND a.neh_effective_date = b.neh_effective_date
           AND b.neh_ne_id_old = pi_ne_id 
           AND b.neh_operation = 'S'
           AND nvl(a.neh_descr, '£$%^') = nvl(b.neh_descr, '£$%^')
           AND nm_end_date = a.neh_effective_date
           order by nm_start_date desc
           )
		where rownum = 1;
         
         -- unclose the element
         error_loc := 20 ;
         UPDATE NM_ELEMENTS_ALL
            SET ne_end_date = NULL
          WHERE ne_id = p_ne_id;
         error_loc := 21 ;

------------------------------------------
-- restore any of OF memberships that
-- were end dated on the effective date
------------------------------------------
         UPDATE NM_MEMBERS_ALL
            SET nm_end_date = NULL
          WHERE nm_ne_id_of = pi_ne_id
            AND nm_end_date = pi_effective_date
            AND nm_ne_id_in IN (SELECT nm_ne_id_in
                                  FROM NM_MEMBERS_ALL
                                 WHERE nm_ne_id_of IN
                                                     (pi_ne_id_1, pi_ne_id_2));

         error_loc := 22 ;
------------------------------------------
-- restore any of IN memberships based on
-- memberships created for the 2 new groups
-- that were created from split
-----------------------------------------
         UPDATE NM_MEMBERS_ALL
            SET nm_end_date = NULL
          WHERE nm_ne_id_in = pi_ne_id
            AND nm_end_date = pi_effective_date
            AND nm_ne_id_of IN (SELECT nm_ne_id_of
                                  FROM NM_MEMBERS_ALL
                                 WHERE nm_ne_id_in IN
                                                     (pi_ne_id_1, pi_ne_id_2));
         error_loc := 23 ;
------------------------------------------
-- undo any changes to other products
-----------------------------------------
         undo_other_products (p_ne_id_1        => pi_ne_id        -- old ne_id
                             ,p_ne_id_2        => pi_ne_id_1      -- new ne_id
                             ,p_ne_id_3        => pi_ne_id_2      -- new ne_id
                             ,p_operation      => c_split
                             ,p_op_date        => pi_effective_date
                             );

         error_loc := 24 ;
------------------------------------------
-- remove any trace of 2 new groups
-----------------------------------------
         DELETE FROM NM_MEMBERS_ALL
               WHERE nm_ne_id_of IN (pi_ne_id_1, pi_ne_id_2);

         error_loc := 25 ;
         DELETE FROM NM_MEMBERS_ALL
               WHERE nm_ne_id_in IN (pi_ne_id_1, pi_ne_id_2);

         error_loc := 26 ;
         -- delete the history
         delete_element_history (pi_ne_id, c_split);

         delete_element_history_for_new(pi_ne_id_new => pi_ne_id_1);
         delete_element_history_for_new(pi_ne_id_new => pi_ne_id_2);

         error_loc := 27 ;
-------------------------------
-- Delete Shape of new elements
-------------------------------
         Nm3sdm.delete_route_shape (p_ne_id => pi_ne_id_1);
         error_loc := 28 ;
         Nm3sdm.delete_route_shape (p_ne_id => pi_ne_id_2);
         error_loc := 29 ;

         IF Nm3nwad.ad_data_exist (pi_ne_id)
         -- CWS 01/JUN/2010 0109668
         OR Nm3nwad.ad_data_exist (pi_ne_id_1)
         OR Nm3nwad.ad_data_exist (pi_ne_id_2)
         THEN
            error_loc := 30 ;
            Nm3nwad.do_ad_unsplit (pi_new_ne_id1      => pi_ne_id_1,
                                   pi_new_ne_id2      => pi_ne_id_2,
                                   pi_old_ne_id       => pi_ne_id
                                  );
            error_loc := 31 ;
         END IF;

         -- delete the new elements
         delete_element (pi_ne_id_1, pi_ne_id_2);
            error_loc := 32 ;
         --Rescaling original group
--         nm3rsc.rescale_route(pi_ne_id          => pi_ne_id
--                             ,pi_effective_date => pi_effective_date
--                             ,pi_offset_st      => 0
--                             ,pi_st_element_id  => NULL
--                             ,pi_use_history    => 'N'
--                             ,pi_ne_start       => NULL);
         Nm3sdm.restore_route_shape (p_ne_id      => pi_ne_id,
                                     p_date       => pi_effective_date
                                    );
            error_loc := 33 ;

         
        --nm_debug.debug('==> Tab Count = '||l_tab_ne_id_of.COUNT);
        IF l_tab_ne_id_of.COUNT >0 
          THEN
          FOR i IN 1..l_tab_ne_id_of.COUNT LOOP
           -- nm_debug.debug('==> unsplitting ' ||l_tab_ne_id_of(i));
            
            unsplit (p_ne_id => l_tab_ne_id_of(i));
          
          END LOOP;
         END IF;
         
            
      END unsplit_group;
   BEGIN
      error_loc := 40 ;
      Nm_Debug.proc_start (g_package_name, 'unsplit_datum_or_group');
      Nm3ausec.set_status (Nm3type.c_off);
      Nm3merge.set_nw_operation_in_progress;

      error_loc := 41 ;
      IF NOT check_history (p_ne_id, c_split)
      THEN
         -- get the two new elements
         OPEN c1;

         FETCH c1
          INTO l_ne_id_1, l_effective_date;

         FETCH c1
          INTO l_ne_id_2, l_effective_date;

         CLOSE c1;

         -- lock the route to avoid dual editing
         error_loc := 42 ;
         lock_parent (l_ne_id_1);
         -- check that the elements have not been added to
         -- any more groups or have had any inventory located
         -- on them
         check_members_added (pi_ne_id_old1      => p_ne_id,
                              pi_ne_id_old2      => NULL,
                              pi_ne_id_new1      => l_ne_id_1,
                              pi_ne_id_new2      => l_ne_id_1
                             );

         error_loc := 43 ;
         --CWS 0111024 Lateral Offsets
         IF NVL(hig.get_sysopt('XSPOFFSET'),'N') = 'Y'
         THEN
           EXECUTE IMMEDIATE 'BEGIN xncc_herm_xsp.delete_herm_xsp(:l_ne_id_1); END;' USING l_ne_id_1;
           EXECUTE IMMEDIATE 'BEGIN xncc_herm_xsp.delete_herm_xsp(:l_ne_id_2); END;' USING l_ne_id_2;
           EXECUTE IMMEDIATE 'BEGIN xncc_herm_xsp.unclose_herm_xsp(:p_ne_id); END;' USING p_ne_id;
         END IF;
         --
         IF Nm3net.element_is_a_datum (pi_ne_id => p_ne_id)
         THEN
           error_loc := 44 ;
            unsplit_datum (pi_ne_id               => p_ne_id,
                           pi_ne_id_1             => l_ne_id_1,
                           pi_ne_id_2             => l_ne_id_2,
                           pi_effective_date      => l_effective_date
                          );
            error_loc := 45 ;
         ELSIF Nm3net.element_is_a_group (pi_ne_id => p_ne_id)
         THEN
            error_loc := 46 ;
            unsplit_group (pi_ne_id               => p_ne_id,
                           pi_ne_id_1             => l_ne_id_1,
                           pi_ne_id_2             => l_ne_id_2,
                           pi_effective_date      => l_effective_date
                          );
            error_loc := 47 ;
         END IF;
      END IF;

      set_for_return;
      error_loc := 99 ;
      Nm_Debug.proc_end (g_package_name, 'unsplit');
   EXCEPTION
      WHEN OTHERS
      THEN
         declare
           err_mess varchar2(2000) := substr(nm3flx.parse_error_message(sqlerrm),1,2000) ;
           colon_loc integer ;
         begin
           colon_loc := instr(err_mess,':');
           err_mess := substr(err_mess,1,colon_loc) || ' unsplit step '
                              || to_char(error_loc)
                              || substr(err_mess,colon_loc+1);
           set_for_return;
           ROLLBACK;
           Raise_application_error(-20000, err_mess );
         end ;
   END unsplit;

--
------------------------------------------------------------------------------------------------
--
   -- takes one of the old elements and gets the other one
   PROCEDURE unmerge (p_ne_id nm_elements.ne_id%TYPE)
   IS
      error_loc integer := 0 ;
      CURSOR c1 (c_ne_id nm_elements.ne_id%TYPE)
      IS
         SELECT b.neh_ne_id_old neh_ne_id_old
           FROM NM_ELEMENT_HISTORY a, NM_ELEMENT_HISTORY b
          WHERE a.neh_ne_id_old = c_ne_id
            AND a.neh_ne_id_new = b.neh_ne_id_new
            AND a.neh_operation = c_merge;

      l_ne_id_1   nm_elements.ne_id%TYPE;
      l_ne_id_2   nm_elements.ne_id%TYPE;
   BEGIN
      Nm_Debug.proc_start (g_package_name, 'unmerge');

      OPEN c1 (p_ne_id);

      FETCH c1
       INTO l_ne_id_1;

      FETCH c1
       INTO l_ne_id_2;

      CLOSE c1;

--
      unmerge (l_ne_id_1, l_ne_id_2);
--
      Nm_Debug.proc_end (g_package_name, 'unmerge');
   END unmerge;

--
------------------------------------------------------------------------------------------------
--
-- takes the two original elements that were merged
   PROCEDURE unmerge (
      p_ne_id_1   nm_elements.ne_id%TYPE,
      p_ne_id_2   nm_elements.ne_id%TYPE
   )
   IS
      error_loc integer := 0 ;
      CURSOR c1
      IS
         SELECT neh_ne_id_new, neh_effective_date
           FROM NM_ELEMENT_HISTORY
          WHERE neh_ne_id_old IN (p_ne_id_1, p_ne_id_2)
            AND neh_operation = c_merge;

--
      v_ne_id                   nm_elements.ne_id%TYPE                 := NULL;
      l_effective_date          NM_ELEMENT_HISTORY.neh_effective_date%TYPE;
--
      c_ausec_status   CONSTANT VARCHAR2 (3)            := Nm3ausec.get_status;

      PROCEDURE set_for_return
      IS
      BEGIN
         Nm3ausec.set_status (c_ausec_status);
         Nm3merge.set_nw_operation_in_progress (FALSE);
      END set_for_return;

      PROCEDURE unmerge_datum (
         pi_ne_id            IN   nm_elements.ne_id%TYPE,
         pi_ne_id_1          IN   nm_elements.ne_id%TYPE,
         pi_ne_id_2          IN   nm_elements.ne_id%TYPE,
         pi_effective_date   IN   DATE
      )
      IS
      BEGIN
         error_loc := 101 ;
         IF pi_ne_id IS NOT NULL
         THEN
            error_loc := 102 ;
            -- delete nm_members
            DELETE      NM_MEMBERS_ALL
                  WHERE nm_ne_id_of = pi_ne_id;

            -- resolve the ad link data

            IF Nm3nwad.ad_data_exist (pi_ne_id_1, TRUE)
            or Nm3nwad.ad_data_exist (pi_ne_id_2, TRUE)
            THEN
              error_loc := 1021 ;
               Nm3nwad.do_ad_unmerge (pi_new_ne_id       => pi_ne_id,
                                      pi_old_ne_id1      => pi_ne_id_1,
                                      pi_old_ne_id2      => pi_ne_id_2
                                     );
            END IF;

            error_loc := 1031 ;

            -- unclose any nodes that underpin the elements.

            UPDATE NM_NODES_ALL
               SET no_end_date = NULL
             WHERE no_node_id in ( select ne_no_start
                                   from nm_elements_all
                                   where ne_id in (pi_ne_id_1, pi_ne_id_2)
                                   union
                                   select ne_no_end
                                   from nm_elements_all
                                   where ne_id in (pi_ne_id_1, pi_ne_id_2)
                                 );


            error_loc := 103 ;
            -- unclose nm_elements
            UPDATE NM_ELEMENTS_ALL
               SET ne_end_date = NULL
             WHERE ne_id IN (pi_ne_id_1, pi_ne_id_2);

            error_loc := 104 ;
            -- unendate the node_usages
            UPDATE NM_NODE_USAGES_ALL
               SET nnu_end_date = NULL
             WHERE nnu_ne_id IN (pi_ne_id_1, pi_ne_id_2);

            error_loc := 105 ;
            undo_other_products (p_ne_id_1        => pi_ne_id_1,
                                 p_ne_id_2        => pi_ne_id_2,
                                 p_ne_id_3        => pi_ne_id     -- new ne_id
                                                             ,
                                 p_operation      => c_merge,
                                 p_op_date        => pi_effective_date
                                );

            --
            -- groups
            error_loc := 106 ;
            DECLARE
               CURSOR cs_nmh (
                  c_nmh_ne_id_of_new     nm_members.nm_ne_id_of%TYPE,
                  c_nmh_ne_id_of_old_1   nm_members.nm_ne_id_of%TYPE,
                  c_nmh_ne_id_of_old_2   nm_members.nm_ne_id_of%TYPE
               )
               IS
                  SELECT nmh_nm_ne_id_in, nmh_nm_ne_id_of_old,
                         nmh_nm_begin_mp, nmh_nm_start_date, nmh_nm_end_date
                    FROM NM_MEMBER_HISTORY
                   WHERE nmh_nm_ne_id_of_new = c_nmh_ne_id_of_new
                     AND nmh_nm_ne_id_of_old IN
                                 (c_nmh_ne_id_of_old_1, c_nmh_ne_id_of_old_2);

               l_tab_ne_id_in     Nm3type.tab_number;
               l_tab_ne_id_of     Nm3type.tab_number;
               l_tab_begin_mp     Nm3type.tab_number;
               l_tab_start_date   Nm3type.tab_date;
               l_tab_end_date     Nm3type.tab_date;
            BEGIN
               OPEN cs_nmh (v_ne_id, p_ne_id_1, p_ne_id_2);

               FETCH cs_nmh
               BULK COLLECT INTO l_tab_ne_id_in, l_tab_ne_id_of,
                      l_tab_begin_mp, l_tab_start_date, l_tab_end_date;

               CLOSE cs_nmh;

               error_loc := 107 ;
            -- This is debug code for when you get a or other error
            -- Comment out the forall and comment this in to see where the error is
/*
            nm_debug.debug_on ;
            for i in 1..l_tab_ne_id_in.count
            loop
                nm_debug.debug('------ ' || i || ' ------');
                nm_debug.debug('nm_ne_id_in   = ' || l_tab_ne_id_in (i)    );
                nm_debug.debug('nm_ne_id_of   = ' || l_tab_ne_id_of (i)    );
                nm_debug.debug('nm_begin_mp   = ' || l_tab_begin_mp (i)    );
                nm_debug.debug('nm_start_date = ' || to_char(l_tab_start_date (i),'DD-MON-YYYY hh24:mi')  );
                nm_debug.debug('nm_end_date   = ' || l_tab_end_date (i)    );
                for l_of in ( select * from nm_elements_all where ne_id = l_tab_ne_id_of(i) )
                loop
                  nm_debug.debug('Of Unique = ' || l_of.ne_unique || ', start date = ' || l_of.ne_start_date || ', end_date = ' || l_of.ne_end_date ) ;
                end loop;
                for l_in in ( select * from nm_elements_all where ne_id = l_tab_ne_id_in(i) )
                loop
                  nm_debug.debug('In Unique = ' || l_in.ne_unique || ', start date = ' || l_in.ne_start_date || ', end_date = ' || l_in.ne_end_date ) ;
                end loop;
               UPDATE NM_MEMBERS_ALL
                  SET nm_end_date = l_tab_end_date (i)
                WHERE nm_ne_id_in = l_tab_ne_id_in (i)
                  AND nm_ne_id_of = l_tab_ne_id_of (i)
                  AND nm_begin_mp = l_tab_begin_mp (i)
                  AND nm_start_date = l_tab_start_date (i);
            end loop ;
            nm_debug.debug_off;
--*/
--/*
               FORALL i IN 1 .. l_tab_ne_id_in.COUNT
                  UPDATE NM_MEMBERS_ALL
                     SET nm_end_date = l_tab_end_date (i)
                   WHERE nm_ne_id_in = l_tab_ne_id_in (i)
                     AND nm_ne_id_of = l_tab_ne_id_of (i)
                     AND nm_begin_mp = l_tab_begin_mp (i)
                     AND nm_start_date = l_tab_start_date (i);
--*/
             END;
/*

            IF     Nm3nwad.ad_data_exist (pi_ne_id_1)
               AND Nm3nwad.ad_data_exist (pi_ne_id_2)
            THEN
              error_loc := 108 ;
               Nm3nwad.do_ad_unmerge (pi_new_ne_id       => pi_ne_id,
                                      pi_old_ne_id1      => pi_ne_id_1,
                                      pi_old_ne_id2      => pi_ne_id_2
                                     );
            END IF;
*/            
            
            error_loc := 109 ;

            -- delete the history
            delete_element_history (pi_ne_id_1, c_merge);
            error_loc := 110 ;
            -- delete the history
            delete_element_history (pi_ne_id_2, c_merge);

            delete_element_history_for_new(pi_ne_id_new => pi_ne_id);

            error_loc := 111 ;
            -- delete nm_elements for v_ne_id
            delete_element (pi_ne_id);
         END IF;
         error_loc := 112 ;
      END unmerge_datum;

--
      PROCEDURE unmerge_group (
         pi_ne_id            IN   nm_elements.ne_id%TYPE,
         pi_ne_id_1          IN   nm_elements.ne_id%TYPE,
         pi_ne_id_2          IN   nm_elements.ne_id%TYPE,
         pi_effective_date   IN   DATE
      )
      IS
         l_rec_nm   nm_members%ROWTYPE;
      BEGIN
         -- unclose the element
         error_loc := 120 ;
         UPDATE NM_ELEMENTS_ALL
            SET ne_end_date = NULL
          WHERE ne_id IN (pi_ne_id_1, pi_ne_id_2);

------------------------------------------
-- restore any of OF memberships that
-- were end dated on the effective date
-----------------------------------------
         error_loc := 121 ;
         UPDATE NM_MEMBERS_ALL
            SET nm_end_date = NULL
          WHERE nm_ne_id_of IN (pi_ne_id_1, pi_ne_id_2)
            AND nm_end_date = pi_effective_date
            AND nm_ne_id_in IN (SELECT nm_ne_id_in
                                  FROM NM_MEMBERS_ALL
                                 WHERE nm_ne_id_of = pi_ne_id);

  ------------------------------------------
-- restore any of IN memberships based on
-- memberships created for the new group
-- that was created from merge
-----------------------------------------
         error_loc := 122 ;
         UPDATE NM_MEMBERS_ALL
            SET nm_end_date = NULL
          WHERE nm_ne_id_in IN (pi_ne_id_1, pi_ne_id_2)
            AND nm_end_date = pi_effective_date            
            AND nm_ne_id_of IN (SELECT nm_ne_id_of
                                  FROM NM_MEMBERS_ALL
                                 WHERE nm_ne_id_in = pi_ne_id);

  ------------------------------------------
-- remove any trace of new groups
-----------------------------------------
         error_loc := 123 ;
         DELETE FROM NM_MEMBERS_ALL
               WHERE nm_ne_id_of = pi_ne_id;

         error_loc := 124 ;
         DELETE FROM NM_MEMBERS_ALL
               WHERE nm_ne_id_in = pi_ne_id;

         -- delete the history
         error_loc := 125 ;
         delete_element_history (pi_ne_id_1, c_merge);
         error_loc := 126 ;
         delete_element_history (pi_ne_id_2, c_merge);
         error_loc := 127 ;

         delete_element_history_for_new(pi_ne_id_new => pi_ne_id);

         undo_other_products (p_ne_id_1        => pi_ne_id_1,
                              p_ne_id_2        => pi_ne_id_2,
                              p_ne_id_3        => pi_ne_id        -- new ne_id
                                                          ,
                              p_operation      => c_merge,
                              p_op_date        => pi_effective_date
                             );
---------------------------
-- Delete Shape of group
---------------------------
         error_loc := 128 ;
         Nm3sdm.delete_route_shape (p_ne_id => pi_ne_id);

         IF Nm3nwad.ad_data_exist (pi_ne_id_1, TRUE)
         OR Nm3nwad.ad_data_exist (pi_ne_id_2, TRUE)
         THEN
           error_loc := 129 ;
            Nm3nwad.do_ad_unmerge (pi_new_ne_id       => pi_ne_id,
                                   pi_old_ne_id1      => pi_ne_id_1,
                                   pi_old_ne_id2      => pi_ne_id_2
                                  );
         END IF;
         error_loc := 130 ;

         -- delete the group
         delete_element (pi_ne_id);
         --Rescaling original groups
--         nm3rsc.rescale_route(pi_ne_id          => pi_ne_id_1
--                             ,pi_effective_date => pi_effective_date
--                             ,pi_offset_st      => 0
--                             ,pi_st_element_id  => NULL
--                             ,pi_use_history    => 'N'
--                             ,pi_ne_start       => NULL);

         --         nm3rsc.rescale_route(pi_ne_id          => pi_ne_id_2
--                             ,pi_effective_date => pi_effective_date
--                             ,pi_offset_st      => 0
--                             ,pi_st_element_id  => NULL
--                             ,pi_use_history    => 'N'
--                             ,pi_ne_start       => NULL);
         error_loc := 131 ;
         Nm3sdm.restore_route_shape (p_ne_id      => pi_ne_id_1,
                                     p_date       => pi_effective_date
                                    );
         error_loc := 132 ;
         Nm3sdm.restore_route_shape (p_ne_id      => pi_ne_id_2,
                                     p_date       => pi_effective_date
                                    );
      END unmerge_group;
   BEGIN
      Nm_Debug.proc_start (g_package_name, 'unmerge');
      Nm3ausec.set_status (Nm3type.c_off);
      Nm3merge.set_nw_operation_in_progress;

      error_loc := 140 ;
      IF     NOT check_history (p_ne_id_1, c_merge)
         AND NOT check_history (p_ne_id_2, c_merge)
      THEN
         OPEN c1;

         FETCH c1
          INTO v_ne_id, l_effective_date;

         CLOSE c1;

         -- lock the route to avoid dual editing
         error_loc := 141 ;
         lock_parent (v_ne_id);
         -- check that the elements have not been added to
         -- any more groups or have had any inventory located
         -- on them
         error_loc := 142 ;
         check_members_added (pi_ne_id_old1      => p_ne_id_1,
                              pi_ne_id_old2      => p_ne_id_2,
                              pi_ne_id_new1      => v_ne_id,
                              pi_ne_id_new2      => NULL
                             );
         --CWS 0111024 Lateral Offsets
         IF NVL(hig.get_sysopt('XSPOFFSET'),'N') = 'Y'
         THEN
           EXECUTE IMMEDIATE 'BEGIN xncc_herm_xsp.delete_herm_xsp(:v_ne_id); END;' USING v_ne_id;
           EXECUTE IMMEDIATE 'BEGIN xncc_herm_xsp.unclose_herm_xsp(:p_ne_id_1); END;' USING p_ne_id_1;
           EXECUTE IMMEDIATE 'BEGIN xncc_herm_xsp.unclose_herm_xsp(:p_ne_id_2); END;' USING p_ne_id_2;
         END IF;
         --
         IF Nm3net.element_is_a_datum (pi_ne_id => v_ne_id)
         THEN
           error_loc := 143 ;
            unmerge_datum (pi_ne_id               => v_ne_id,
                           pi_ne_id_1             => p_ne_id_1,
                           pi_ne_id_2             => p_ne_id_2,
                           pi_effective_date      => l_effective_date
                          );
         ELSIF Nm3net.element_is_a_group (pi_ne_id => v_ne_id)
         THEN
           error_loc := 144 ;
            unmerge_group (pi_ne_id               => v_ne_id,
                           pi_ne_id_1             => p_ne_id_1,
                           pi_ne_id_2             => p_ne_id_2,
                           pi_effective_date      => l_effective_date
                          );
         END IF;
      END IF;
      error_loc := 145 ;

      set_for_return;
      Nm_Debug.proc_end (g_package_name, 'unmerge');
   EXCEPTION
      WHEN OTHERS
      THEN
         declare
           err_mess varchar2(2000) := substr(nm3flx.parse_error_message(sqlerrm),1,2000) ;
           colon_loc integer ;
         begin
           colon_loc := instr(err_mess,':');
           err_mess := substr(err_mess,1,colon_loc) || ' unmerge step '
                              || to_char(error_loc)
                              || substr(err_mess,colon_loc+1);
           set_for_return;
           ROLLBACK;
           Raise_application_error(-20000, err_mess );
         end ;
   END unmerge;

--
------------------------------------------------------------------------------------------------
--
   PROCEDURE unreplace (p_ne_id nm_elements.ne_id%TYPE)
   IS
      CURSOR c1
      IS
         SELECT neh_ne_id_new, neh_effective_date
           FROM NM_ELEMENT_HISTORY
          WHERE neh_ne_id_old IN (p_ne_id) AND neh_operation = c_replace;

      v_ne_id                   nm_elements.ne_id%TYPE                := NULL;
      l_effective_date          NM_ELEMENT_HISTORY.neh_effective_date%TYPE;
--
      c_ausec_status   CONSTANT VARCHAR2 (3)           := Nm3ausec.get_status;

--
      PROCEDURE set_for_return
      IS
      BEGIN
         Nm3ausec.set_status (c_ausec_status);
         Nm3merge.set_nw_operation_in_progress (FALSE);
      END set_for_return;
   BEGIN
      Nm_Debug.proc_start (g_package_name, 'unreplace');
      Nm3ausec.set_status (Nm3type.c_off);
      Nm3merge.set_nw_operation_in_progress;

--
      IF NOT check_history (p_ne_id, c_replace)
      THEN
         OPEN c1;

         FETCH c1
          INTO v_ne_id, l_effective_date;

         CLOSE c1;

         -- lock the route to avoid dual editing
         lock_parent (v_ne_id);
         -- check that the elements have not been added to
         -- any more groups or have had any inventory located on them
         check_members_added (pi_ne_id_old1      => p_ne_id,
                              pi_ne_id_old2      => NULL,
                              pi_ne_id_new1      => v_ne_id,
                              pi_ne_id_new2      => NULL
                             );

         IF v_ne_id IS NOT NULL
         THEN
            -- delete nm_members v_ne_id
            DELETE      NM_MEMBERS_ALL
                  WHERE nm_ne_id_of = v_ne_id;

            -- unclose nm_elements p_ne_id
            UPDATE NM_ELEMENTS_ALL
               SET ne_end_date = NULL
             WHERE ne_id = p_ne_id;

            undo_other_products (p_ne_id_1        => v_ne_id      -- new ne_id
                                                            ,
                                 p_ne_id_2        => p_ne_id      -- old ne_id
                                                            ,
                                 p_operation      => c_replace,
                                 p_op_date        => l_effective_date
                                );

            -- unclose nm_members p_ne_id groups
            DECLARE
               CURSOR cs_nmh (
                  c_nmh_ne_id_of_new   nm_members.nm_ne_id_of%TYPE,
                  c_nmh_ne_id_of_old   nm_members.nm_ne_id_of%TYPE
               )
               IS
                  SELECT nmh_nm_ne_id_in, nmh_nm_ne_id_of_old,
                         nmh_nm_begin_mp, nmh_nm_start_date, nmh_nm_end_date
                    FROM NM_MEMBER_HISTORY
                   WHERE nmh_nm_ne_id_of_new = c_nmh_ne_id_of_new
                     AND nmh_nm_ne_id_of_old = c_nmh_ne_id_of_old;

               l_tab_ne_id_in     Nm3type.tab_number;
               l_tab_ne_id_of     Nm3type.tab_number;
               l_tab_begin_mp     Nm3type.tab_number;
               l_tab_start_date   Nm3type.tab_date;
               l_tab_end_date     Nm3type.tab_date;
            BEGIN
               OPEN cs_nmh (v_ne_id, p_ne_id);

               FETCH cs_nmh
               BULK COLLECT INTO l_tab_ne_id_in, l_tab_ne_id_of,
                      l_tab_begin_mp, l_tab_start_date, l_tab_end_date;

               CLOSE cs_nmh;

               FORALL i IN 1 .. l_tab_ne_id_in.COUNT
                  UPDATE NM_MEMBERS_ALL
                     SET nm_end_date = l_tab_end_date (i)
                   WHERE nm_ne_id_in = l_tab_ne_id_in (i)
                     AND nm_ne_id_of = l_tab_ne_id_of (i)
                     AND nm_begin_mp = l_tab_begin_mp (i)
                     AND nm_start_date = l_tab_start_date (i);
            END;

            IF Nm3nwad.ad_data_exist (v_ne_id)
            THEN
               Nm3nwad.do_ad_unreplace (pi_old_ne_id => v_ne_id);
            END IF;

          --            UPDATE NM_MEMBERS_ALL
          --            SET nm_end_date = NULL
          --            WHERE nm_ne_id_of = p_ne_id
          --         AND nm_type = 'G'
          --              AND TRUNC(nm_date_modified) = ( SELECT MAX(TRUNC(nm_date_modified))
          --                                       FROM NM_MEMBERS_ALL
          --                                       WHERE nm_ne_id_of = p_ne_id
          --                                     );
          --
          --            -- unclose nm_members p_ne_id
          --       -- inv items that are not  closed
          --            UPDATE NM_MEMBERS_ALL
          --            SET nm_end_date = NULL
          --            WHERE nm_ne_id_of = p_ne_id
          --         AND nm_type = 'I'
          --         AND nm_ne_id_in IN ( SELECT iit_ne_id
          --                              FROM NM_INV_ITEMS_ALL
          --                         WHERE iit_end_date IS NULL
          --                           AND iit_inv_type = nm_obj_type);
            -- delete the history
            delete_element_history (p_ne_id, c_replace);
            --
            delete_element_history_for_new(pi_ne_id_new => v_ne_id);
            -- CWS 0111024 lateral offsets
            IF NVL(hig.get_sysopt('XSPOFFSET'),'N') = 'Y'
            THEN
              EXECUTE IMMEDIATE 'BEGIN xncc_herm_xsp.delete_herm_xsp(:v_ne_id); END;' USING v_ne_id;
              EXECUTE IMMEDIATE 'BEGIN xncc_herm_xsp.unclose_herm_xsp(:p_ne_id); END;' USING p_ne_id;
            END IF;
            --
            -- delete nm_elements v_ne_id
            delete_element (v_ne_id);
            --
            -- unendate the node_usages
            UPDATE NM_NODE_USAGES_ALL
               SET nnu_end_date = NULL
             WHERE nnu_ne_id = p_ne_id;
--
         END IF;
      END IF;

      set_for_return;
   EXCEPTION
      WHEN OTHERS
      THEN
         set_for_return;
         RAISE;
   END unreplace;
--
------------------------------------------------------------------------------------------------
--
   PROCEDURE unclose (p_ne_id nm_elements.ne_id%TYPE)
   IS
      CURSOR c1
      IS
         SELECT neh_effective_date, a.ROWID neh_rowid
           FROM NM_ELEMENT_HISTORY a
          WHERE neh_ne_id_old = p_ne_id
            AND neh_ne_id_new = p_ne_id
            AND neh_operation = c_close;

--
      CURSOR c_check_parent (c_ne_id nm_elements.ne_id%TYPE)
      IS
         SELECT 1
           FROM nm_elements
          WHERE ne_id =
                   Nm3net.get_parent_ne_id
                          (c_ne_id,
                           Nm3net.get_parent_type (Nm3net.Get_Nt_Type (c_ne_id)
                                                  )
                          );

--
      l_parent_exists           NUMBER (1);
--
      v_close_date              DATE;
      l_neh_rowid               ROWID;
--
      c_ausec_status   CONSTANT VARCHAR2 (3) := Nm3ausec.get_status;

      --
      PROCEDURE set_for_return
      IS
      BEGIN
         Nm3ausec.set_status (c_ausec_status);
         Nm3merge.set_nw_operation_in_progress (FALSE);
      END set_for_return;
   BEGIN
--
      Nm_Debug.proc_start (g_package_name, 'unclose');
--
      Nm3nwval.network_operations_check (Nm3nwval.c_unclose);
--
      Nm3ausec.set_status (Nm3type.c_off);
      
      Nm3merge.set_nw_operation_in_progress;

      -- get the date the element was closed
      OPEN c1;

--
      FETCH c1
       INTO v_close_date, l_neh_rowid;

--
      IF c1%NOTFOUND
      THEN
         CLOSE c1;

         RAISE_APPLICATION_ERROR
                          (-20001,
                           'Element has NOT been closed WITH closed FUNCTION'
                          );
      END IF;

--
      CLOSE c1;

--
      DECLARE
         e_inclusion_not_found   EXCEPTION;
         PRAGMA EXCEPTION_INIT (e_inclusion_not_found, -20001);
      BEGIN
         OPEN c_check_parent (p_ne_id);

         FETCH c_check_parent
          INTO l_parent_exists;

         IF c_check_parent%NOTFOUND
         THEN
            RAISE_APPLICATION_ERROR
                       (-20002,
                        'Elements Parent Route is closed. Unable to unclose.'
                       );

            CLOSE c_check_parent;
         END IF;

         CLOSE c_check_parent;
      EXCEPTION
         WHEN e_inclusion_not_found
         THEN
            NULL;
      END;
--
--    unclose any nodes that underpin the elements.

      UPDATE NM_NODES_ALL
           SET no_end_date = NULL
        WHERE no_node_id in ( select ne_no_start
                               from nm_elements_all
                               where ne_id = p_ne_id
                               union
                               select ne_no_end
                               from nm_elements_all
                               where ne_id = p_ne_id
                             );
--   unclose element
      UPDATE nm_elements_all
         SET ne_end_date = NULL
       WHERE ne_id = p_ne_id;
--
--  Remove element close history
--
      DELETE nm_element_history
       WHERE neh_ne_id_new = p_ne_id
         AND neh_ne_id_old = p_ne_id
         AND neh_operation = 'C';
--
      undo_other_products (p_ne_id_1        => p_ne_id
                          ,p_operation      => c_close
                          ,p_op_date        => v_close_date
                          );

--
-- unclose the groups
      DECLARE
         CURSOR cs_nmh (
            c_nmh_ne_id_of_new   nm_members.nm_ne_id_of%TYPE,
            c_nmh_ne_id_of_old   nm_members.nm_ne_id_of%TYPE
         )
         IS
            SELECT nmh_nm_ne_id_in, nmh_nm_ne_id_of_old, nmh_nm_begin_mp,
                   nmh_nm_start_date, nmh_nm_end_date, nmh_nm_type
              FROM NM_MEMBER_HISTORY
             WHERE (nmh_nm_ne_id_of_new = c_nmh_ne_id_of_new
               AND nmh_nm_ne_id_of_old = c_nmh_ne_id_of_old);

         l_tab_ne_id_in     Nm3type.tab_number;
         l_tab_ne_id_of     Nm3type.tab_number;
         l_tab_begin_mp     Nm3type.tab_number;
         l_tab_start_date   Nm3type.tab_date;
         l_tab_end_date     Nm3type.tab_date;
         l_tab_nm_type      Nm3type.tab_varchar4;
      --
      BEGIN
         OPEN cs_nmh (p_ne_id, p_ne_id);

         FETCH cs_nmh
         BULK COLLECT INTO l_tab_ne_id_in, l_tab_ne_id_of, l_tab_begin_mp,
                l_tab_start_date, l_tab_end_date, l_tab_nm_type;

         CLOSE cs_nmh;

         -- Un-end date any inventory
         FORALL i IN 1 .. l_tab_ne_id_in.COUNT
            UPDATE NM_INV_ITEMS_ALL
               SET iit_end_date =
                      DECODE (GREATEST (NVL (l_tab_end_date (i),
                                             Nm3type.c_big_date
                                            ),
                                        iit_end_date
                                       ),
                              Nm3type.c_big_date, NULL,
                              GREATEST (l_tab_end_date (i), iit_end_date)
                             )
             WHERE iit_ne_id = l_tab_ne_id_in (i) AND l_tab_nm_type (i) = 'I';
         -- Un-end date the membership records
         FORALL i IN 1 .. l_tab_ne_id_in.COUNT
            UPDATE NM_MEMBERS_ALL
               SET nm_end_date = l_tab_end_date (i)
             WHERE nm_ne_id_in = l_tab_ne_id_in (i)
               AND nm_ne_id_of = l_tab_ne_id_of (i)
               AND nm_begin_mp = l_tab_begin_mp (i)
               AND nm_start_date = l_tab_start_date (i);
      END;
-- Task 0111307 CWS code block added to undo the closures to a groups
-- unclose the children
      IF NM3GET.GET_NE_ALL(PI_NE_ID => p_ne_id).NE_TYPE IN ('P','G')
      THEN
        DECLARE
           l_neh_ne_id          Nm3type.tab_number;
           l_neh_effective_date Nm3type.tab_date;
           -- A list of the elements that need to be unclosed. Checks need to
           -- be done here to ensure
           CURSOR cs_neh (
              c_ne_id   nm_elements.ne_id%TYPE
           )
           IS
           select ne_id, neh_effective_date 
               from NM_ELEMENT_HISTORY
                  , NM_ELEMENTS_ALL
               where neh_ne_id_old = ne_id
               and neh_operation = 'C'
               and neh_effective_date = ne_end_date
               and (ne_id = c_ne_id
               OR  ne_id IN (SELECT NM_NE_ID_OF
                           FROM NM_MEMBERS_ALL
                           START WITH NM_NE_ID_IN = c_ne_id
                           CONNECT BY NM_NE_ID_IN = PRIOR NM_NE_ID_OF)
                           );

           -- A list of the members that need to be unclosed
           CURSOR cs_nmh (
              c_nmh_ne_id_of_old   nm_members.nm_ne_id_of%TYPE
           )
           IS
              SELECT nmh_nm_ne_id_in, nmh_nm_ne_id_of_old, nmh_nm_begin_mp,
                     nmh_nm_start_date, nmh_nm_end_date, nmh_nm_type
                FROM NM_MEMBER_HISTORY
                START WITH nmh_nm_ne_id_in = c_nmh_ne_id_of_old
                CONNECT BY nmh_nm_ne_id_in = PRIOR nmh_nm_ne_id_of_old;

           l_tab_ne_id_in     Nm3type.tab_number;
           l_tab_ne_id_of     Nm3type.tab_number;
           l_tab_begin_mp     Nm3type.tab_number;
           l_tab_start_date   Nm3type.tab_date;
           l_tab_end_date     Nm3type.tab_date;
           l_tab_nm_type      Nm3type.tab_varchar4;
           --
        BEGIN
           OPEN cs_neh (p_ne_id);
           FETCH cs_neh
           BULK COLLECT INTO l_neh_ne_id, l_neh_effective_date;
           CLOSE cs_neh;
            
           OPEN cs_nmh (p_ne_id);
           FETCH cs_nmh
           BULK COLLECT INTO l_tab_ne_id_in, l_tab_ne_id_of, l_tab_begin_mp,
                              l_tab_start_date, l_tab_end_date, l_tab_nm_type;
            CLOSE cs_nmh;
           -- Unclose elements
           FORALL i IN 1 .. l_neh_ne_id.COUNT
              UPDATE nm_elements_all
                 SET ne_end_date = NULL
               WHERE ne_id = l_neh_ne_id (i)
                 AND ne_end_date = l_neh_effective_date(i);
           
           -- Un-end date the membership records
           FORALL i IN 1 .. l_tab_ne_id_in.COUNT
              UPDATE nm_members_all
                 SET nm_end_date = l_tab_end_date(i)
               WHERE nm_ne_id_in = l_tab_ne_id_in(i)
                 AND nm_ne_id_of = l_tab_ne_id_of(i)
                 AND nm_begin_mp = l_tab_begin_mp(i)
                 AND nm_start_date = l_tab_start_date(i);

           -- Un end date the inventory on the children
           FORALL i IN 1 .. l_tab_ne_id_in.COUNT
           UPDATE nm_inv_items_all
              SET iit_end_date =  l_tab_end_date(i)
            WHERE iit_ne_id IN
              (SELECT nmh_nm_ne_id_in 
                 FROM nm_member_history 
                WHERE nmh_nm_ne_id_of_new = l_tab_ne_id_of(i)
                  AND nmh_nm_ne_id_of_old = l_tab_ne_id_of(i)
                  AND NMH_NM_TYPE = 'I');

           -- Un end date the inventory on the children
           FORALL i IN 1 .. l_tab_ne_id_in.COUNT
           UPDATE nm_members_all
              SET nm_end_date =  l_tab_end_date(i)
            WHERE (nm_ne_id_of, nm_ne_id_in) IN
              (SELECT nmh_nm_ne_id_of_old, nmh_nm_ne_id_in 
                 FROM nm_member_history 
                WHERE nmh_nm_ne_id_of_new = l_tab_ne_id_of(i)
                  AND nmh_nm_ne_id_of_old = l_tab_ne_id_of(i)
                  AND nmh_nm_type IN ('P','G'));

           -- Delete element history records 
           FORALL i IN 1 .. l_neh_ne_id.COUNT
              DELETE nm_element_history
               WHERE neh_ne_id_new = l_neh_ne_id(i)
                 AND neh_ne_id_old = l_neh_ne_id(i)
                 AND neh_effective_date = l_neh_effective_date(i)
                 AND neh_operation = 'C';
           
           -- Delete the membership history records
           FORALL i IN 1 .. l_tab_ne_id_in.COUNT
              DELETE nm_member_history
               WHERE nmh_nm_ne_id_in = l_tab_ne_id_in (i)
                 AND nmh_nm_ne_id_of_new = l_tab_ne_id_of (i)
                 AND nmh_nm_ne_id_of_old = l_tab_ne_id_of (i)
                 AND nmh_nm_begin_mp = l_tab_begin_mp (i)
                 AND nmh_nm_start_date = l_tab_start_date (i);
           
           -- Unclose other products.
           FOR i IN 1 .. l_neh_ne_id.COUNT LOOP
           undo_other_products (p_ne_id_1        => l_neh_ne_id(i)
                               ,p_ne_id_2        => l_neh_ne_id(i)
                               ,p_operation      => c_close
                               ,p_op_date        => l_neh_effective_date(i)
                               );
           END LOOP;

        END;
      END IF;
      -- Task 0111307 End
      --
--RC> Problems here - code has been uncommented since group members and assets were not being unlcosed.      
--    Also, added the v_close_date below because otherwise, a member that was closed at the max date (not at the close date of the element) would be unclosed!      --
--
	  
    UPDATE NM_MEMBERS_ALL
    SET nm_end_date = NULL
    WHERE nm_ne_id_of = p_ne_id
    AND nm_type = 'G'
    AND TRUNC(nm_date_modified) = ( SELECT MAX(TRUNC(nm_date_modified))
                             FROM NM_MEMBERS_ALL
                             WHERE nm_ne_id_of = p_ne_id
                         )  ;
----
---- unclose inv_items closed on the day the element was closed
---- that are on the element
    UPDATE NM_INV_ITEMS_ALL
    SET iit_end_date = NULL
    WHERE iit_end_date = v_close_date
    AND iit_ne_id IN ( SELECT nm_ne_id_in
                       FROM NM_MEMBERS_ALL
                WHERE nm_ne_id_of = p_ne_id
                  AND nm_type = 'I'
				  AND nm_end_date = v_close_date );
----
---- unclose inv_items locations closed on the day the element was closed
---- could cause problems if inv_items are closed on same day that
---- are not related to the element being closed
  UPDATE NM_MEMBERS_ALL
    SET nm_end_date = NULL
    WHERE nm_ne_id_of = p_ne_id
      AND nm_type = 'I'
      AND nm_end_date = v_close_date;
--
-- unendate the node_usages
      UPDATE NM_NODE_USAGES_ALL
         SET nnu_end_date = NULL
       WHERE nnu_ne_id = p_ne_id;

--
-- delete the nm_element_history record
      DELETE NM_ELEMENT_HISTORY
      WHERE  ROWID = l_neh_rowid;
--
      --RC if it is a route then restore any route shapes.
      IF Nm3net.element_is_a_group (pi_ne_id => p_ne_id)
      THEN
         Nm3sdm.restore_route_shape (p_ne_id      => p_ne_id,
                                     p_date       => v_close_date
                                    );
      END IF;
     /*--
      DECLARE
         l_inv_to_check nm3type.tab_number;
         l_count        PLS_INTEGER := 0;
      BEGIN
         FOR i IN 1..nm3merge.g_tab_nmh_nm_ne_id_in.COUNT
          LOOP
            IF   nm3merge.g_tab_nmh_nm_type(i) = 'I'
             AND nm3inv.get_inv_type(nm3merge.g_tab_nmh_nm_obj_type(i)).nit_end_loc_only = 'N'
             THEN
               l_count                 := l_inv_to_check.COUNT + 1;
               l_inv_to_check(l_count) := nm3merge.g_tab_nmh_nm_ne_id_in(i);
            END IF;
         END LOOP;
         FORALL i IN 1..l_count
            UPDATE NM_INV_ITEMS
             SET   iit_end_date = NULL
            WHERE  iit_ne_id    = l_inv_to_check(i);
      END;*/
      -- CWS 0109500 0109770 1/6/10 restore any additional data.
      --
      UPDATE nm_inv_items_all
      SET    iit_end_date = NULL
      WHERE  iit_ne_id IN
       (SELECT nad_iit_ne_id
        FROM   nm_nw_ad_link_all
        WHERE  nad_ne_id = p_ne_id
        AND    nad_end_date = iit_end_date
       );
      --
      UPDATE nm_nw_ad_link_all
      SET    nad_end_date = NULL
      WHERE  nad_ne_id = p_ne_id;
     --
      set_for_return;
      Nm_Debug.proc_end (g_package_name, 'unclose');
 /*  EXCEPTION
      WHEN OTHERS
      THEN
         set_for_return;
         RAISE;*/
   END unclose;
--
------------------------------------------------------------------------------------------------
--
END Nm3undo;
/
