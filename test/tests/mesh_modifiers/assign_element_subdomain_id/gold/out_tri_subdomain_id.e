CDF      
      
len_string     !   len_line   Q   four      	time_step          len_name   !   num_dim       	num_nodes      	   num_elem      
num_el_blk        num_node_sets         num_side_sets         num_el_in_blk1        num_nod_per_el1       num_el_in_blk2        num_nod_per_el2       num_side_ss1      num_side_ss2      num_side_ss3      num_side_ss4      num_nod_ns1       num_nod_ns2       num_nod_ns3       num_nod_ns4       num_nod_var       num_info  C         api_version       @�
=   version       @�
=   floating_point_word_size            	file_size               int64_status             title         out_tri_subdomain_id.e     maximum_name_length                     
time_whole                            s   	eb_status                             	@   eb_prop1               name      ID              	H   	ns_status         	                    	P   ns_prop1      	         name      ID              	`   	ss_status         
                    	p   ss_prop1      
         name      ID              	�   coordx                      H      	�   coordy                      H      	�   eb_names                       D      
    ns_names      	                 �      
d   ss_names      
                 �      
�   
coor_names                         D      l   node_num_map                    $      �   connect1                  	elem_type         TRI3                �   connect2                  	elem_type         TRI3          H      �   elem_num_map                           4   elem_ss1                          T   side_ss1                          \   elem_ss2                          d   side_ss2                          l   elem_ss3                          t   side_ss3                          |   elem_ss4                          �   side_ss4                          �   node_ns1                          �   node_ns2                          �   node_ns3                          �   node_ns4                          �   vals_nod_var1                          H      s$   name_nod_var                       $      �   info_records                      f4      �                                                                       ?�      ?�              ?�      ?�      ?�              ?�                      ?�      ?�              ?�      ?�      ?�      ?�                                                                          right                            top                              left                             bottom                           top                              left                             right                            bottom                                                                                                                          	               	                                                         	                                                                                 	         	                  u                                   ####################                                                             # Created by MOOSE #                                                             ####################                                                             ### Command Line Arguments ###                                                   -i                                                                               tri_with_subdomainid_test.i                                                                                                                                       ### Version Info ###                                                             Framework Information:                                                           MOOSE version:           git commit 1a85df1 on 2015-10-08                        PETSc Version:           3.6.0                                                   Current Time:            Thu Oct  8 14:21:39 2015                                Executable Timestamp:    Thu Oct  8 14:20:14 2015                                                                                                                                                                                                  ### Input File ###                                                                                                                                                []                                                                                 name                           =                                                 initial_from_file_timestep     = END                                             initial_from_file_var          = INVALID                                         block                          = INVALID                                         coord_type                     = XYZ                                             fe_cache                       = 0                                               kernel_coverage_check          = 1                                               material_coverage_check        = 1                                               rz_coord_axis                  = Y                                               type                           = FEProblem                                       use_legacy_uo_aux_computation  = INVALID                                         use_legacy_uo_initialization   = INVALID                                         element_order                  = AUTO                                            order                          = AUTO                                            side_order                     = AUTO                                            active_bcs                     = INVALID                                         active_kernels                 = INVALID                                         inactive_bcs                   = INVALID                                         inactive_kernels               = INVALID                                         start                          = 0                                               dimNearNullSpace               = 0                                               dimNullSpace                   = 0                                               error_on_jacobian_nonzero_reallocation = 0                                       petsc_inames                   =                                                 petsc_options                  = INVALID                                         petsc_values                   =                                                 solve                          = 1                                               use_nonlinear                  = 1                                             []                                                                                                                                                                [BCs]                                                                                                                                                               [./left]                                                                           boundary                     = 3                                                 implicit                     = 1                                                 name                         = BCs/left                                          type                         = DirichletBC                                       use_displaced_mesh           = 0                                                 variable                     = u                                                 diag_save_in                 = INVALID                                           save_in                      = INVALID                                           seed                         = 0                                                 value                        = 0                                               [../]                                                                                                                                                             [./right]                                                                          boundary                     = 1                                                 implicit                     = 1                                                 name                         = BCs/right                                         type                         = DirichletBC                                       use_displaced_mesh           = 0                                                 variable                     = u                                                 diag_save_in                 = INVALID                                           save_in                      = INVALID                                           seed                         = 0                                                 value                        = 1                                               [../]                                                                          []                                                                                                                                                                [Executioner]                                                                      name                           = Executioner                                     type                           = Steady                                          compute_initial_residual_before_preset_bcs = 0                                   l_abs_step_tol                 = -1                                              l_max_its                      = 10000                                           l_tol                          = 1e-05                                           line_search                    = default                                         nl_abs_step_tol                = 1e-50                                           nl_abs_tol                     = 1e-50                                           nl_max_funcs                   = 10000                                           nl_max_its                     = 50                                              nl_rel_step_tol                = 1e-50                                           nl_rel_tol                     = 1e-08                                           no_fe_reinit                   = 0                                               petsc_options                  = INVALID                                         petsc_options_iname            = INVALID                                         petsc_options_value            = INVALID                                         solve_type                     = PJFNK                                           restart_file_base              =                                                 splitting                      = INVALID                                       []                                                                                                                                                                [Executioner]                                                                      _fe_problem                    = 0x7fc09a044a00                                []                                                                                                                                                                [Kernels]                                                                                                                                                           [./diff]                                                                           name                         = Kernels/diff                                      type                         = Diffusion                                         block                        = INVALID                                           diag_save_in                 = INVALID                                           implicit                     = 1                                                 save_in                      = INVALID                                           seed                         = 0                                                 use_displaced_mesh           = 0                                                 variable                     = u                                               [../]                                                                          []                                                                                                                                                                [Mesh]                                                                             name                           = Mesh                                            displacements                  = INVALID                                         block_id                       = INVALID                                         block_name                     = INVALID                                         boundary_id                    = INVALID                                         boundary_name                  = INVALID                                         construct_side_list_from_node_list = 0                                           ghosted_boundaries             = INVALID                                         ghosted_boundaries_inflation   = INVALID                                         patch_size                     = 40                                              second_order                   = 0                                               skip_partitioning              = 0                                               type                           = GeneratedMesh                                   uniform_refine                 = 0                                               centroid_partitioner_direction = INVALID                                         dim                            = 2                                               distribution                   = DEFAULT                                         elem_type                      = TRI3                                            nemesis                        = 0                                               nx                             = 2                                               ny                             = 2                                               nz                             = 0                                               partitioner                    = default                                         patch_update_strategy          = never                                           xmax                           = 1                                               xmin                           = 0                                               ymax                           = 1                                               ymin                           = 0                                               zmax                           = 0                                               zmin                           = 0                                             []                                                                                                                                                                [Mesh]                                                                           []                                                                                                                                                                [MeshModifiers]                                                                                                                                                     [./subdomain_id]                                                                   name                         = MeshModifiers/subdomain_id                        type                         = AssignElementSubdomainID                          _mesh                        = 0x7fc09a043200                                    depends_on                   = INVALID                                           subdomain_ids                = '0 1 1 1 1 1 1 0'                               [../]                                                                          []                                                                                                                                                                [Outputs]                                                                          checkpoint                     = 0                                               color                          = 1                                               console                        = 1                                               csv                            = 0                                               dofmap                         = 0                                               execute_on                     = 'INITIAL TIMESTEP_END'                          exodus                         = 1                                               file_base                      = out_tri_subdomain_id                            gmv                            = 0                                               gnuplot                        = 0                                               hide                           = INVALID                                         interval                       = 1                                               name                           = Outputs                                         nemesis                        = 0                                               output_if_base_contains        = INVALID                                         print_linear_residuals         = 1                                               print_mesh_changed_info        = 0                                               print_perf_log                 = 0                                               show                           = INVALID                                         solution_history               = 0                                               sync_times                     =                                                 tecplot                        = 0                                               vtk                            = 0                                               xda                            = 0                                               xdr                            = 0                                                                                                                                [./console]                                                                        name                         = Outputs/console                                   type                         = Console                                           additional_execute_on        = INVALID                                           all_variable_norms           = 0                                                 append_displaced             = 0                                                 append_restart               = 0                                                 end_time                     = INVALID                                           execute_elemental_variables  = 1                                                 execute_input                = 1                                                 execute_input_on             = INVALID                                           execute_nodal_variables      = 1                                                 execute_on                   = 'FAILED INITIAL LINEAR NONLINEAR TIMESTEP_... BEGIN TIMESTEP_END'                                                                  execute_postprocessors_on    = 'INITIAL TIMESTEP_END'                            execute_scalar_variables     = 1                                                 execute_scalars_on           = 'INITIAL TIMESTEP_END'                            execute_system_information   = 1                                                 execute_system_information_on = INITIAL                                          execute_vector_postprocessors = 1                                                execute_vector_postprocessors_on = 'INITIAL TIMESTEP_END'                        file_base                    = out_tri_subdomain_id                              fit_mode                     = ENVIRONMENT                                       hide                         = INVALID                                           interval                     = 1                                                 linear_residual_dt_divisor   = 1000                                              linear_residual_end_time     = INVALID                                           linear_residual_start_time   = INVALID                                           linear_residuals             = 0                                                 max_rows                     = 15                                                nonlinear_residual_dt_divisor = 1000                                             nonlinear_residual_end_time  = INVALID                                           nonlinear_residual_start_time = INVALID                                          nonlinear_residuals          = 0                                                 outlier_multiplier           = '0.8 2'                                           outlier_variable_norms       = 1                                                 output_file                  = 0                                                 output_if_base_contains      =                                                   output_linear                = 0                                                 output_nonlinear             = 0                                                 output_postprocessors        = 1                                                 output_screen                = 1                                                 padding                      = 4                                                 perf_header                  = INVALID                                           perf_log                     = 0                                                 print_mesh_changed_info      = 0                                                 scientific_time              = 0                                                 setup_log                    = INVALID                                           setup_log_early              = 0                                                 show                         = INVALID                                           show_multiapp_name           = 0                                                 solve_log                    = INVALID                                           start_time                   = INVALID                                           sync_only                    = 0                                                 sync_times                   =                                                   system_info                  = 'AUX EXECUTION FRAMEWORK MESH NONLINEAR'          time_precision               = INVALID                                           time_tolerance               = 1e-14                                             use_displaced                = 0                                                 verbose                      = 0                                               [../]                                                                                                                                                             [./exodus]                                                                         name                         = Outputs/exodus                                    type                         = Exodus                                            additional_execute_on        = INVALID                                           append_displaced             = 0                                                 append_oversample            = 0                                                 elemental_as_nodal           = 0                                                 end_time                     = INVALID                                           execute_elemental_on         = INVALID                                           execute_elemental_variables  = 1                                                 execute_input                = 1                                                 execute_input_on             = INITIAL                                           execute_nodal_on             = INVALID                                           execute_nodal_variables      = 1                                                 execute_on                   = 'INITIAL TIMESTEP_END'                            execute_postprocessors_on    = INVALID                                           execute_scalar_variables     = 1                                                 execute_scalars_on           = INVALID                                           execute_system_information   = 1                                                 execute_vector_postprocessors = 1                                                file                         = INVALID                                           file_base                    = out_tri_subdomain_id                              hide                         = INVALID                                           interval                     = 1                                                 linear_residual_dt_divisor   = 1000                                              linear_residual_end_time     = INVALID                                           linear_residual_start_time   = INVALID                                           linear_residuals             = 0                                                 nonlinear_residual_dt_divisor = 1000                                             nonlinear_residual_end_time  = INVALID                                           nonlinear_residual_start_time = INVALID                                          nonlinear_residuals          = 0                                                 output_if_base_contains      =                                                   output_linear                = 0                                                 output_material_properties   = 0                                                 output_nonlinear             = 0                                                 output_postprocessors        = 1                                                 oversample                   = 0                                                 padding                      = 3                                                 position                     = INVALID                                           refinements                  = 0                                                 scalar_as_nodal              = 0                                                 sequence                     = INVALID                                           show                         = INVALID                                           show_material_properties     = INVALID                                           start_time                   = INVALID                                           sync_only                    = 0                                                 sync_times                   =                                                   time_tolerance               = 1e-14                                             use_displaced                = 0                                               [../]                                                                          []                                                                                                                                                                [Variables]                                                                                                                                                         [./u]                                                                              block                        = INVALID                                           eigen                        = 0                                                 family                       = LAGRANGE                                          initial_condition            = INVALID                                           name                         = Variables/u                                       order                        = FIRST                                             outputs                      = INVALID                                           scaling                      = 1                                                 initial_from_file_timestep   = END                                               initial_from_file_var        = INVALID                                         [../]                                                                          []                                                                                                                                                                ?�              ?�������?�              ?�      ?�      ?�              ?�      