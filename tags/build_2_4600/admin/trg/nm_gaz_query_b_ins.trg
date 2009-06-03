CREATE OR REPLACE TRIGGER nm_gaz_query_b_ins
  BEFORE INSERT 
  ON nm_gaz_query
  FOR EACH ROW
DECLARE
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_gaz_query_b_ins.trg-arc   3.0   Jun 03 2009 16:24:48   lsorathia  $
--       Module Name      : $Workfile:   nm_gaz_query_b_ins.trg  $
--       Date into SCCS   : $Date:   Jun 03 2009 16:24:48  $
--       Date fetched Out : $Modtime:   Jun 03 2009 16:12:40  $
--       SCCS Version     : $Revision:   3.0  $
--       Based on 
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--

   l_ne_id Number ;
   l_offset Number; 
   CURSOR c_get_sub_class (qp_qroup_type nm_group_types.ngt_group_type%TYPE)
   IS
   SELECT Count(nsc_sub_class) cnt 
   FROM   nm_type_subclass
         ,nm_nt_groupings
         ,nm_group_types
   WHERE  nng_group_type = qp_qroup_type
   AND    nng_nt_type = nsc_nw_type
   AND    ngt_group_type = nng_group_type
   AND    ngt_reverse_allowed = 'N';
   l_cnt Number ;
--
BEGIN
--   
   IF  :new.NGQ_AMBIG_SUB_CLASS IS NOT NULL
   AND nvl(hig.get_sysopt('DISAMBIGSC'),'N') = 'Y'
   THEN 
       OPEN  c_get_sub_class(nm3get.get_ne(:new.NGQ_SOURCE_ID).ne_gty_group_type);
       FETCH c_get_sub_class INTO l_cnt ;
       CLOSE c_get_sub_class;
       IF  l_cnt > 1
       THEN
           nm3wrap.get_ambiguous_lrefs(:new.NGQ_SOURCE_ID
                                      ,:new.NGQ_BEGIN_MP
                                      ,:new.NGQ_AMBIG_SUB_CLASS);  
           nm3wrap.lref_get_row( 1
                                ,l_ne_id
                                ,l_offset);    
           :new.NGQ_BEGIN_DATUM_NE_ID  := Nvl(l_ne_id,:new.NGQ_BEGIN_DATUM_NE_ID) ;
           :new.NGQ_BEGIN_DATUM_OFFSET := Nvl(l_offset,:new.NGQ_BEGIN_DATUM_OFFSET) ;
                                                                                
           --
           nm3wrap.get_ambiguous_lrefs(:new.NGQ_SOURCE_ID
                                      ,:new.NGQ_END_MP                               
                                      ,:new.NGQ_AMBIG_SUB_CLASS);                
           nm3wrap.lref_get_row( 1
                                ,l_ne_id
                                ,l_offset);    
           --  
           :new.NGQ_end_DATUM_NE_ID  := Nvl(l_ne_id,:new.NGQ_end_DATUM_NE_ID)   ;
           :new.NGQ_end_DATUM_OFFSET := Nvl(l_offset,:new.NGQ_end_DATUM_OFFSET) ;
       END IF ;
   END IF ;
--
END  ;
/
