CREATE OR REPLACE TRIGGER V_NM_MSV_THEME_DEF_TRG
INSTEAD OF DELETE OR INSERT OR UPDATE
ON V_NM_MSV_THEME_DEF
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : %W% %G%
--       Module Name      : %M%
--       Date into SCCS   : %E% %U%
--       Date fetched Out : %D% %T%
--       SCCS Version     : %I%
--
--   Author : Francis Fish
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
cursor c_get_theme_xml is
select styling_rules
from   user_sdo_themes
where  name            = :old.vnmt_theme_name
and    base_table      = :old.vnmt_base_table
and    geometry_column = :old.vnmt_geometry_column
;
l_xml  varchar2(4000) ;
procedure no_null_today
  ( p_name varchar2
  , p_value varchar2
  ) is
begin
  if p_value is null
  then
    raise_application_error(-20000,p_name ||  ' may not be null'); 
  end if ;
end no_null_today;

BEGIN
   if inserting
   then
    null ;
   elsif updating
   then
     if  :old.vnmt_theme_name          != :new.vnmt_theme_name          
     and :old.vnmt_base_table          != :new.vnmt_base_table          
     and :old.vnmt_geometry_column     != :new.vnmt_geometry_column
     then
        -- Updating these columns is meaningless, run away
       return ;
     end if ;
     
     no_null_today('vnmt_rule_column'       , :new.vnmt_rule_column          );
     no_null_today('vnmt_rule_label_column' , :new.vnmt_rule_label_column    );
     no_null_today('vnmt_rule_label_style'  , :new.vnmt_rule_label_style     );
     no_null_today('vnmt_rule_label'        , :new.vnmt_rule_label           );
                   
     if    :old.vnmt_rule_column                != :new.vnmt_rule_column         
        or nvl(:old.vnmt_rule_style,'xXxxX')    != nvl(:new.vnmt_rule_style,'xXxxX')           
        or nvl(:old.vnmt_rule_features,'xXxxX') != nvl(:new.vnmt_rule_features,'xXxxX')        
        or :old.vnmt_rule_label_column          != :new.vnmt_rule_label_column   
        or :old.vnmt_rule_label_style           != :new.vnmt_rule_label_style    
        or :old.vnmt_rule_label                 != :new.vnmt_rule_label
     then
       open c_get_theme_xml ;
       fetch c_get_theme_xml
       into l_xml ;
       close c_get_theme_xml ;
       l_xml := nm3_msv_xml.update_styling_rules
         ( p_xml                        => l_xml
         , p_search_rule_column         => :old.vnmt_rule_column        
         , p_search_rule_style          => :old.vnmt_rule_style          
         , p_search_rule_features       => :old.vnmt_rule_features       
         , p_search_rule_label_column   => :old.vnmt_rule_label_column   
         , p_search_rule_label_style    => :old.vnmt_rule_label_style    
         , p_search_rule_label          => :old.vnmt_rule_label          
         , p_update_rule_column         => :new.vnmt_rule_column         
         , p_update_rule_style          => :new.vnmt_rule_style          
         , p_update_rule_features       => :new.vnmt_rule_features       
         , p_update_rule_label_column   => :new.vnmt_rule_label_column   
         , p_update_rule_label_style    => :new.vnmt_rule_label_style    
         , p_update_rule_label          => :new.vnmt_rule_label         
         )  ;
       
         update user_sdo_themes
            set styling_rules = l_xml
          where  name            = :old.vnmt_theme_name
            and  base_table      = :old.vnmt_base_table
            and  geometry_column = :old.vnmt_geometry_column
         ;

     end if ;

     

   end if ;

END V_NM_MSV_THEME_DEF_TRG;
/
