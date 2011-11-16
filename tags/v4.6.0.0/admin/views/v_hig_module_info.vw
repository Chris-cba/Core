Create Or Replace Force View V_Hig_Module_Info
(
Module,
Module_Mode,
Use_Gri,
Module_Name,
Module_Type,
Application
)
As
Select    -------------------------------------------------------------------------
          --   PVCS Identifiers :-
          --
          --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_hig_module_info.vw-arc   5.0   Nov 16 2011 15:26:32   Steve.Cooper  $
          --       Module Name      : $Workfile:   v_hig_module_info.vw  $
          --       Date into PVCS   : $Date:   Nov 16 2011 15:26:32  $
          --       Date fetched Out : $Modtime:   Nov 16 2011 15:25:12  $
          --       Version          : $Revision:   5.0  $
          --
          --
          -------------------------------------------------------------------------
          hm.Hmo_Module,
          hmr.Hmr_Mode,
          hm.Hmo_Use_Gri,
          hm.Hmo_Filename,
          Upper(hm.Hmo_Module_Type),
          hm.Hmo_Application
From      Hig_Module_Roles    hmr,
          Session_Roles       sr,
          Hig_Modules         hm
Where     hmr.Hmr_Role        =     sr.Role
And       hm.Hmo_Module       =     hmr.Hmr_Module
--View is ordered so Normal access to a module comes before readonly access.
Order By  hmr.Hmr_Mode
With Read Only
/

Comment on Table V_Hig_Module_Info Is 'Provides information about the modules that can be run given the roles active within the session.'
/

Comment on Column V_Hig_Module_Info.Module Is 'The module that can be run.'
/

Comment on Column V_Hig_Module_Info.Module_Mode Is 'The mode the module can be run in.'
/

Comment on Column V_Hig_Module_Info.Use_Gri Is 'Does the module user Gri.'
/

Comment on Column V_Hig_Module_Info.Module_Name Is 'The full name of the module.'
/

Comment on Column V_Hig_Module_Info.Module_Type Is 'The type of module form (FMX), report R25 etc.'
/

Comment on Column V_Hig_Module_Info.Application Is 'The application the module belongs to.'
/




