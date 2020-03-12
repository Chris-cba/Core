CREATE OR REPLACE PACKAGE BODY sdl_process
AS
    --<PACKAGE>
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_process.pkb-arc   1.6   Mar 12 2020 18:18:06   Vikas.Mhetre  $
    --       Module Name      : $Workfile:   sdl_process.pkb  $
    --       Date into PVCS   : $Date:   Mar 12 2020 18:18:06  $
    --       Date fetched Out : $Modtime:   Mar 12 2020 18:08:58  $
    --       PVCS Version     : $Revision:   1.6  $
    --
    --   Author : R.A. Coupe
    --
    --   Package for handling the processes in SDL product
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    --
    -- The main purpose of this package is to provide a single package as an interface to the
    -- various SDL processes

    --</PACKAGE>

    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.6  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'SDL_PROCESS';

    --p_batch_id => p_batch_id, p_tol_load => 5, p_tol_nw => 5, p_tol_unit_id => 7, p_stop_count => 5);
    ----------------------------------------------------------------------------
    --
    FUNCTION get_version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN g_sccsid;
    END get_version;
    --
    ----------------------------------------------------------------------------
    --
    FUNCTION get_body_version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN g_body_sccsid;
    END get_body_version;
    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE set_working_parameters (p_batch_id      IN     NUMBER,
                                      p_tol_load         OUT NUMBER,
                                      p_tol_nw           OUT NUMBER,
                                      p_tol_unit_id      OUT NUMBER,
                                      p_stop_count       OUT NUMBER);
    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE load_validate (p_batch_id IN NUMBER)
    IS
        l_tol_load      NUMBER;
        l_tol_nw        NUMBER;
        l_tol_unit_id   NUMBER;
        l_stop_count    NUMBER;
    BEGIN
        set_working_parameters (p_batch_id,
                                l_tol_load,
                                l_tol_nw,
                                l_tol_unit_id,
                                l_stop_count);

        SDL_AUDIT.LOG_PROCESS_START (p_batch_id,
                                     'ADJUST',
                                     NULL,
                                     NULL,
                                     NULL);
        sdl_validate.VALIDATE_ADJUSTMENT_RULES (p_batch_id);
        SDL_AUDIT.LOG_PROCESS_END (p_batch_id, 'ADJUST');
        --
        SDL_AUDIT.LOG_PROCESS_START (p_batch_id,
                                     'LOAD_VALIDATION',
                                     l_tol_nw,
                                     l_tol_nw,
                                     g_sdo_tol);
        SDL_VALIDATE.VALIDATE_BATCH (p_batch_id);
        SDL_AUDIT.LOG_PROCESS_END (p_batch_id, 'LOAD_VALIDATION');
    END load_validate;
    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE reverse_geoms(p_batch_id IN NUMBER, p_sld_keys IN int_array_type) IS
    BEGIN
       FOR i IN 1..p_sld_keys.COUNT LOOP
       SDL_AUDIT.LOG_PROCESS_START (p_batch_id,
                                     'REVERSE',
                                     NULL,
                                     NULL,
                                     NULL,
                                     p_sld_keys(i));
       END LOOP;                 
       
       sdl_edit.reverse_datum_geometries(p_sld_keys);
                           
       FOR i IN 1..p_sld_keys.COUNT LOOP
       SDL_AUDIT.LOG_PROCESS_END (p_batch_id,
                                     'REVERSE',
                                     p_sld_keys(i));
       END LOOP;

    END reverse_geoms;
    --
    ----------------------------------------------------------------------------
    --	
    PROCEDURE topo_generation (p_batch_id IN NUMBER)
    IS
        l_tol_load      NUMBER;
        l_tol_nw        NUMBER;
        l_tol_unit_id   NUMBER;
        l_stop_count    NUMBER;
    BEGIN
        set_working_parameters (p_batch_id,
                                l_tol_load,
                                l_tol_nw,
                                l_tol_unit_id,
                                l_stop_count);
        SDL_VALIDATE.reset_load_status(p_batch_id);
        SDL_AUDIT.LOG_PROCESS_START (p_batch_id          => p_batch_id,
                                     p_process           => 'TOPO_GENERATION',
                                     p_buffer            => l_tol_nw,
                                     p_match_tolerance   => l_tol_load,
                                     p_tolerance         => g_sdo_tol);
        SDL_TOPO.generate_wip_topo_nw (p_batch_id      => p_batch_id,
                                       p_tol_load      => l_tol_load,
                                       p_tol_nw        => l_tol_nw,
                                       p_tol_unit_id   => l_tol_unit_id,
                                       p_stop_count    => l_stop_count);
        SDL_AUDIT.LOG_PROCESS_END (p_batch_id, 'TOPO_GENERATION');
    END topo_generation;
    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE datum_validation (p_batch_id IN NUMBER)
    IS
        l_tol_load      NUMBER;
        l_tol_nw        NUMBER;
        l_tol_unit_id   NUMBER;
        l_stop_count    NUMBER;
    BEGIN
        set_working_parameters (p_batch_id,
                                l_tol_load,
                                l_tol_nw,
                                l_tol_unit_id,
                                l_stop_count);
        --
        SDL_AUDIT.LOG_PROCESS_START (p_batch_id          => p_batch_id,
                                     p_process           => 'DATUM_VALIDATION',
                                     p_buffer            => l_tol_nw,
                                     p_match_tolerance   => l_tol_load,
                                     p_tolerance         => g_sdo_tol);
        SDL_STATS.match_nodes (p_batch_id, l_tol_nw, g_sdo_tol);
        SDL_VALIDATE.validate_datums_in_batch (p_batch_id => p_batch_id);
        SDL_STATS.GENERATE_STATISTICS_ON_SWD (p_batch_id    => p_batch_id,
                                              p_buffer      => l_tol_nw,
                                              p_tolerance   => g_sdo_tol);
        SDL_STATS.GENERATE_STATISTICS_ON_SLD (p_batch_id    => p_batch_id,
                                              p_buffer      => l_tol_nw,
                                              p_tolerance   => g_sdo_tol);
        sdl_validate.update_load_datum_status(p_batch_id);
        SDL_AUDIT.LOG_PROCESS_END (p_batch_id, 'DATUM_VALIDATION');
    END datum_validation;
    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE analysis (p_batch_id   IN NUMBER,
                        p_swd_id     IN NUMBER DEFAULT NULL)
    IS
        l_tol_load      NUMBER;
        l_tol_nw        NUMBER;
        l_tol_unit_id   NUMBER;
        l_stop_count    NUMBER;
    BEGIN
        set_working_parameters (p_batch_id,
                                l_tol_load,
                                l_tol_nw,
                                l_tol_unit_id,
                                l_stop_count);
        --
        SDL_AUDIT.LOG_PROCESS_START (p_batch_id          => p_batch_id,
                                     p_process           => 'ANALYSIS',
                                     p_buffer            => l_tol_nw,
                                     p_match_tolerance   => l_tol_load,
                                     p_tolerance         => g_sdo_tol);
        NULL;                     -- further analysis such as pline-stats etc.
        SDL_AUDIT.LOG_PROCESS_END (p_batch_id, 'ANALYSIS');
    END analysis;
    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE transfer (p_batch_id IN NUMBER)
    IS
        l_tol_load      NUMBER;
        l_tol_nw        NUMBER;
        l_tol_unit_id   NUMBER;
        l_stop_count    NUMBER;
    BEGIN
        set_working_parameters (p_batch_id,
                                l_tol_load,
                                l_tol_nw,
                                l_tol_unit_id,
                                l_stop_count);

        SDL_AUDIT.LOG_PROCESS_START (p_batch_id,
                                     'TRANSFER',
                                     NULL,
                                     NULL,
                                     NULL);
        SDL_TRANSFER.TRANSFER_DATUMS (p_batch_id => p_batch_id);
        SDL_AUDIT.LOG_PROCESS_END (p_batch_id, 'TRANSFER');
    END transfer;
    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE reject (p_batch_id IN NUMBER)
    IS
    BEGIN
        SDL_AUDIT.LOG_PROCESS_START (p_batch_id,
                                     'REJECT',
                                     NULL,
                                     NULL,
                                     NULL);
        NULL;                                             -- set reject status
        SDL_AUDIT.LOG_PROCESS_END (p_batch_id, 'REJECT');
    END reject;
    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE set_working_parameters (p_batch_id      IN     NUMBER,
                                      p_tol_load         OUT NUMBER,
                                      p_tol_nw           OUT NUMBER,
                                      p_tol_unit_id      OUT NUMBER,
                                      p_stop_count       OUT NUMBER)
    IS
    BEGIN
        SELECT sp_tol_load_search,
               sp_tol_nw_search,
               sp_tol_search_unit,
               sp_stop_count
          INTO p_tol_load,
               p_tol_nw,
               p_tol_unit_id,
               p_stop_count
          FROM sdl_profiles, sdl_file_submissions
         WHERE sfs_id = p_batch_id AND sfs_sp_id = sp_id;
    END set_working_parameters;
    --
    ----------------------------------------------------------------------------
    --
--main segment to instantiate the default parameters	
BEGIN
    DECLARE
        l_diminfo   sdo_dim_array;
    BEGIN
        SELECT m.sdo_diminfo
          INTO l_diminfo
          FROM mdsys.sdo_geom_metadata_table m
         WHERE     sdo_owner = SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
               AND sdo_table_name = 'SDL_LOAD_DATA'
               AND sdo_column_name = 'SLD_WORKING_GEOMETRY';

        g_sdo_tol := l_diminfo (1).sdo_tolerance;
    END;
END sdl_process;
/