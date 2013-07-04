CREATE OR REPLACE PROCEDURE check_x_attr (p_number_of_each NUMBER DEFAULT 1000) IS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)check_x_attr.sql	1.2 08/02/01
--       Module Name      : check_x_attr.sql
--       Date into SCCS   : 01/08/02 11:48:36
--       Date fetched Out : 07/06/13 17:07:16
--       SCCS Version     : 1.2
--
--
--   Author : Jonathan Mills
--
--   Procedure to check existing inventory data against x-attibute validation rules
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_count      number := 0;
   l_each_count number := 0;
--
begin
--
   nm_debug.delete_debug(TRUE);
   nm_debug.debug_on;
   nm_debug.set_level(-1);
--
   SAVEPOINT top_of_script;
--
   FOR cs_nit IN (SELECT nit_inv_type
                   FROM  nm_inv_types
                  WHERE EXISTS (SELECT 1
                                 FROM  nm_inv_items
                                WHERE  iit_inv_type = nit_inv_type
                               )
                 )
    LOOP
--
      nm_debug.debug(cs_nit.nit_inv_type||' Started',-1);
      l_each_count := 0;
--
      for cs_rec in (select rowid iit_rowid
                           ,iit_inv_type
                           ,iit_ne_id
                           ,iit_primary_key
                       from nm_inV_items_all
                     WHERE  iit_inv_type = cs_nit.nit_inv_type
                      AND   rownum <= p_number_of_each
                     ORDER BY iit_ne_id
                    )
       LOOP
         DECLARE
            l_x_Attr_fail EXCEPTION;
            PRAGMA EXCEPTION_INIT (l_x_attr_fail,-20760);
         BEGIN
--
            SAVEPOINT top_of_loop;
            l_count      := l_count + 1;
            l_each_count := l_each_count + 1;
--
            IF l_count/1000 = TRUNC(l_count/1000)
             THEN
               nm_debug.debug(l_count||' records checked',-1);
            END IF;
--
            update nm_inv_items
             SET iit_x = iit_x
            WHERE rowid = cs_rec.iit_rowid;
--
         EXCEPTION
            WHEN l_x_Attr_fail
             THEN
               nm_debug.debug(cs_rec.iit_primary_key||' : '||cs_rec.iit_ne_id||' : '||sqlerrm,-1);
            WHEN others
             THEN
               Null;
--
         END;
--
         ROLLBACK TO top_of_loop;
--
      END LOOP;
--
      nm_debug.debug(cs_nit.nit_inv_type||' Finished - '||l_each_count||' records checked',-1);
--
   END LOOP;
--
   ROLLBACK TO top_of_script;
--
   nm_debug.set_level(3);
   nm_debug.debug_off;
--
end check_x_attr;
/
