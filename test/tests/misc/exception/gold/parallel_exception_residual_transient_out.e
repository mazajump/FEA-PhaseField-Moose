CDF      
      
len_string     !   len_line   Q   four      	time_step          len_name   !   num_dim       	num_nodes      H   num_elem   2   
num_el_blk        num_node_sets         num_side_sets         num_el_in_blk1        num_nod_per_el1       num_el_in_blk2        num_nod_per_el2       num_side_ss1      num_side_ss2      num_nod_ns1       num_nod_ns2       num_nod_var       num_info  a         api_version       @�
=   version       @�
=   floating_point_word_size            	file_size               int64_status             title         ,parallel_exception_residual_transient_out.e    maximum_name_length                    
time_whole                            �   	eb_status                             �   eb_prop1               name      ID                 	ns_status         	                       ns_prop1      	         name      ID                 	ss_status         
                       ss_prop1      
         name      ID              $   coordx                     @      ,   coordy                     @      
l   eb_names                       D      �   ns_names      	                 D      �   ss_names      
                 D      4   
coor_names                         D      x   node_num_map                          �   connect1                  	elem_type         QUAD4        �      �   connect2                  	elem_type         QUAD4        �      l   elem_num_map                    �      �   elem_ss1                          �   side_ss1                          �   elem_ss2                          �   side_ss2                              node_ns1                             node_ns2                          ,   vals_nod_var1                         @      �$   name_nod_var                       $      D   info_records                      o�      h                                    ?�      ?�333333?�333332?�      ?�������?�������������������������333334��333333��      ��      ?�333334?�      ?�����������������333334��      ?�333334?�      ?�����������������333337��      ?�333334?�      ?�����������������333334��      ?�333334?�      ?�����������������333333��      @      @ffffff@ffffff@      @ ������@ ������?�ffffff?�ffffff?�333333?�333333?�      ?�      @ffffff@      @ ������?�ffffff?�333333?�      @ffffff@      @ ������?�ffffff?�333332?�      @ffffff@      @ ������?�ffffff?�333333?�      @ffffff@      @ ������?�ffffff?�333333?�      ?�      ?�      ?�333333?�333334?�      ?�333334?�      ?�333334?�      ?�333335?�      ?�333333?�������?�������?�������?�������?�������?���������������������������������������������������������333334��333333��333335��333334��333334��333334��      ��      ��      ��      ��      ��      ?�      ?�      ?�333334?�333334?�      ?�333334?�      ?�333334?�      ?�333335?�      ?�333333?�������?�������?�������?�������?�������?���������������������������������������������������������333334��333333��333335��333335��333334��333334��      ��      ��      ��      ��      ��                                                                                                                                                                                                                                                                                                                 	   
                                                                      !   "   #   $   %   &   '   (   )   *   +   ,   -   .   /   0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ?   @   A   B   C   D   E   F   G   H                                          	   
      	         
                                          
         
                                                                                                                                                       !            "   !         #   "         $   #   %   &   '   (   &   )   *   '   )   +   ,   *   +   -   .   ,   -   /   0   .   (   '   1   2   '   *   3   1   *   ,   4   3   ,   .   5   4   .   0   6   5   2   1   7   8   1   3   9   7   3   4   :   9   4   5   ;   :   5   6   <   ;   8   7   =   >   7   9   ?   =   9   :   @   ?   :   ;   A   @   ;   <   B   A   >   =   C   D   =   ?   E   C   ?   @   F   E   @   A   G   F   A   B   H   G                           	   
                                                                      !   "   #   $   %   &   '   (   )   *   +   ,   -   .   /   0   1   2                                 .   /   0   1   2                         !   "   #   $   C   D   E   F   G   Hu                                   ####################                                                             # Created by MOOSE #                                                             ####################                                                             ### Command Line Arguments ###                                                   -snes_converged_reason                                                           -ksp_converged_reason                                                            -i                                                                               parallel_exception_residual_transient.i                                                                                                                           ### Version Info ###                                                             Framework Information:                                                           MOOSE version:           git commit c16b26e on 2015-06-04                        PETSc Version:           3.5.4                                                   Current Time:            Thu Jun  4 14:35:13 2015                                Executable Timestamp:    Thu Jun  4 14:27:23 2015                                                                                                                                                                                                  ### Input File ###                                                                                                                                                []                                                                                 initial_from_file_timestep     = 2                                               initial_from_file_var          = INVALID                                         block                          = INVALID                                         coord_type                     = XYZ                                             fe_cache                       = 0                                               kernel_coverage_check          = 1                                               name                           = 'MOOSE Problem'                                 rz_coord_axis                  = Y                                               type                           = FEProblem                                       use_legacy_uo_aux_computation  = INVALID                                         use_legacy_uo_initialization   = INVALID                                         element_order                  = AUTO                                            order                          = AUTO                                            side_order                     = AUTO                                            active_bcs                     = INVALID                                         active_kernels                 = INVALID                                         inactive_bcs                   = INVALID                                         inactive_kernels               = INVALID                                         start                          = 0                                               dimNearNullSpace               = 0                                               dimNullSpace                   = 0                                               error_on_jacobian_nonzero_reallocation = 0                                       long_name                      =                                                 solve                          = 1                                               use_nonlinear                  = 1                                             []                                                                                                                                                                [BCs]                                                                                                                                                               [./right]                                                                          boundary                     = 2                                                 type                         = DirichletBC                                       use_displaced_mesh           = 0                                                 variable                     = u                                                 long_name                    = BCs/right                                         seed                         = 0                                                 value                        = 1                                               [../]                                                                                                                                                             [./right2]                                                                         boundary                     = 1                                                 type                         = DirichletBC                                       use_displaced_mesh           = 0                                                 variable                     = u                                                 long_name                    = BCs/right2                                        seed                         = 0                                                 value                        = 0                                               [../]                                                                          []                                                                                                                                                                [Executioner]                                                                      type                           = Transient                                       compute_initial_residual_before_preset_bcs = 0                                   l_abs_step_tol                 = -1                                              l_max_its                      = 10000                                           l_tol                          = 1e-05                                           line_search                    = default                                         nl_abs_step_tol                = 1e-50                                           nl_abs_tol                     = 1e-50                                           nl_max_funcs                   = 10000                                           nl_max_its                     = 50                                              nl_rel_step_tol                = 1e-50                                           nl_rel_tol                     = 1e-08                                           no_fe_reinit                   = 0                                               petsc_options                  = INVALID                                         petsc_options_iname            = INVALID                                         petsc_options_value            = INVALID                                         solve_type                     = PJFNK                                           abort_on_solve_fail            = 0                                               dt                             = 0.01                                            dtmax                          = 1e+30                                           dtmin                          = 0.005                                           end_time                       = 1e+30                                           long_name                      = Executioner                                     n_startup_steps                = 0                                               num_steps                      = 5                                               picard_abs_tol                 = 1e-50                                           picard_max_its                 = 1                                               picard_rel_tol                 = 1e-08                                           predictor_scale                = INVALID                                         reset_dt                       = 0                                               restart_file_base              =                                                 scheme                         = implicit-euler                                  splitting                      = INVALID                                         ss_check_tol                   = 1e-08                                           ss_tmin                        = 0                                               start_time                     = 0                                               time_period_ends               = INVALID                                         time_period_starts             = INVALID                                         time_periods                   = INVALID                                         timestep_tolerance             = 2e-14                                           trans_ss_check                 = 0                                               use_multiapp_dt                = 0                                               verbose                        = 0                                             []                                                                                                                                                                [Executioner]                                                                      _fe_problem                    = 0x7fc672040c00                                []                                                                                                                                                                [Kernels]                                                                                                                                                           [./diff]                                                                           type                         = Diffusion                                         block                        = INVALID                                           diag_save_in                 = INVALID                                           long_name                    = Kernels/diff                                      save_in                      = INVALID                                           seed                         = 0                                                 use_displaced_mesh           = 0                                                 variable                     = u                                               [../]                                                                                                                                                             [./exception]                                                                      type                         = ExceptionKernel                                   block                        = INVALID                                           diag_save_in                 = INVALID                                           long_name                    = Kernels/exception                                 save_in                      = INVALID                                           seed                         = 0                                                 use_displaced_mesh           = 0                                                 variable                     = u                                                 when                         = residual                                        [../]                                                                                                                                                             [./time_deriv]                                                                     type                         = TimeDerivative                                    block                        = INVALID                                           diag_save_in                 = INVALID                                           long_name                    = Kernels/time_deriv                                lumping                      = 0                                                 save_in                      = INVALID                                           seed                         = 0                                                 use_displaced_mesh           = 0                                                 variable                     = u                                               [../]                                                                          []                                                                                                                                                                [Mesh]                                                                             displacements                  = INVALID                                         block_id                       = INVALID                                         block_name                     = INVALID                                         boundary_id                    = INVALID                                         boundary_name                  = INVALID                                         construct_side_list_from_node_list = 0                                           ghosted_boundaries             = INVALID                                         ghosted_boundaries_inflation   = INVALID                                         patch_size                     = 40                                              second_order                   = 0                                               skip_partitioning              = 0                                               type                           = FileMesh                                        uniform_refine                 = 0                                               centroid_partitioner_direction = INVALID                                         dim                            = 3                                               distribution                   = DEFAULT                                         file                           = 2squares.e                                      long_name                      = Mesh                                            nemesis                        = 0                                               partitioner                    = default                                         patch_update_strategy          = never                                         []                                                                                                                                                                [Outputs]                                                                          checkpoint                     = 0                                               color                          = 1                                               console                        = 1                                               csv                            = 0                                               dofmap                         = 0                                               exodus                         = 1                                               file_base                      = INVALID                                         gmv                            = 0                                               gnuplot                        = 0                                               hide                           = INVALID                                         interval                       = 1                                               nemesis                        = 0                                               output_final                   = 0                                               output_if_base_contains        = INVALID                                         output_initial                 = 1                                               output_intermediate            = 1                                               output_on                      = 'INITIAL TIMESTEP_END'                          output_timestep_end            = 1                                               print_linear_residuals         = 1                                               print_mesh_changed_info        = 0                                               print_perf_log                 = 1                                               show                           = INVALID                                         solution_history               = 0                                               sync_times                     =                                                 tecplot                        = 0                                               vtk                            = 0                                               xda                            = 0                                               xdr                            = 0                                                                                                                                [./console]                                                                        type                         = Console                                           additional_output_on         = INVALID                                           all_variable_norms           = 0                                                 append_displaced             = 0                                                 append_restart               = 0                                                 end_time                     = INVALID                                           file_base                    = INVALID                                           fit_mode                     = ENVIRONMENT                                       hide                         = INVALID                                           interval                     = 1                                                 libmesh_log                  = 1                                                 linear_residual_dt_divisor   = 1000                                              linear_residual_end_time     = INVALID                                           linear_residual_start_time   = INVALID                                           linear_residuals             = 0                                                 long_name                    = Outputs/console                                   max_rows                     = 15                                                nonlinear_residual_dt_divisor = 1000                                             nonlinear_residual_end_time  = INVALID                                           nonlinear_residual_start_time = INVALID                                          nonlinear_residuals          = 0                                                 outlier_multiplier           = '0.8 2'                                           outlier_variable_norms       = 1                                                 output_elemental_variables   = 1                                                 output_failed                = 0                                                 output_file                  = 0                                                 output_final                 = 0                                                 output_if_base_contains      =                                                   output_initial               = 1                                                 output_input                 = 1                                                 output_input_on              = INVALID                                           output_intermediate          = 1                                                 output_linear                = 0                                                 output_nodal_variables       = 1                                                 output_nonlinear             = 0                                                 output_on                    = 'FAILED NONLINEAR TIMESTEP_BEGIN TIMESTEP_... END'                                                                                 output_postprocessors        = 1                                                 output_postprocessors_on     = TIMESTEP_END                                      output_scalar_variables      = 1                                                 output_scalars_on            = TIMESTEP_END                                      output_screen                = 1                                                 output_system_information    = 1                                                 output_system_information_on = INITIAL                                           output_timestep_end          = 1                                                 output_vector_postprocessors = 1                                                 output_vector_postprocessors_on = TIMESTEP_END                                   padding                      = 4                                                 perf_header                  = INVALID                                           perf_log                     = 0                                                 print_mesh_changed_info      = 0                                                 scientific_time              = 0                                                 setup_log                    = INVALID                                           setup_log_early              = 0                                                 show                         = INVALID                                           show_multiapp_name           = 0                                                 solve_log                    = INVALID                                           start_time                   = INVALID                                           sync_only                    = 0                                                 sync_times                   =                                                   system_info                  = 'AUX EXECUTION FRAMEWORK MESH NONLINEAR'          time_precision               = INVALID                                           time_tolerance               = 1e-14                                             use_displaced                = 0                                                 verbose                      = 0                                               [../]                                                                                                                                                             [./exodus]                                                                         type                         = Exodus                                            additional_output_on         = INVALID                                           append_displaced             = 0                                                 append_oversample            = 0                                                 elemental_as_nodal           = 0                                                 end_time                     = INVALID                                           ensight_time                 = 0                                                 file                         = INVALID                                           file_base                    = INVALID                                           hide                         = INVALID                                           interval                     = 1                                                 linear_residual_dt_divisor   = 1000                                              linear_residual_end_time     = INVALID                                           linear_residual_start_time   = INVALID                                           linear_residuals             = 0                                                 long_name                    = Outputs/exodus                                    nonlinear_residual_dt_divisor = 1000                                             nonlinear_residual_end_time  = INVALID                                           nonlinear_residual_start_time = INVALID                                          nonlinear_residuals          = 0                                                 output_elemental_on          = INVALID                                           output_elemental_variables   = 1                                                 output_failed                = 0                                                 output_final                 = 0                                                 output_if_base_contains      =                                                   output_initial               = 1                                                 output_input                 = 1                                                 output_input_on              = INITIAL                                           output_intermediate          = 1                                                 output_linear                = 0                                                 output_material_properties   = 0                                                 output_nodal_on              = INVALID                                           output_nodal_variables       = 1                                                 output_nonlinear             = 0                                                 output_on                    = 'INITIAL TIMESTEP_END'                            output_postprocessors        = 1                                                 output_postprocessors_on     = INVALID                                           output_scalar_variables      = 1                                                 output_scalars_on            = INVALID                                           output_system_information    = 1                                                 output_timestep_end          = 1                                                 output_vector_postprocessors = 1                                                 oversample                   = 0                                                 padding                      = 3                                                 position                     = INVALID                                           refinements                  = 0                                                 scalar_as_nodal              = 0                                                 sequence                     = INVALID                                           show                         = INVALID                                           show_material_properties     = INVALID                                           start_time                   = INVALID                                           sync_only                    = 0                                                 sync_times                   =                                                   time_tolerance               = 1e-14                                             use_displaced                = 0                                               [../]                                                                          []                                                                                                                                                                [Variables]                                                                                                                                                         [./u]                                                                              block                        = INVALID                                           eigen                        = 0                                                 family                       = LAGRANGE                                          initial_condition            = 0                                                 order                        = FIRST                                             outputs                      = INVALID                                           scaling                      = 1                                                 initial_from_file_timestep   = 2                                                 initial_from_file_var        = INVALID                                         [../]                                                                          []                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ?tz�G�{��P��K��P��&�:>�_*<H
>�_`����P�q��>�^�>��P��R�>�_)��{��P�R��>�_!�>P�V�!$>�_!`� ���D����D`����@ݰW���C�dW���C񳾿��Cj!W?`����u?`������?`����z�?`������?`�����?`����'>��R-�\'���R-�\D￧R-�]x��R-�[ׁ��R-�\\��R-�\@�?�     ?�     ?�     ?�     ?�     ?�                                                                                                                                                                                                                                                                                                     ?��Q��>��h[V**>��hd�00?	��1��?	��<K��>��h\��?	��2��>��hwWo�?	��1`½>��hT�[�?	��4�>��hs	�f?	��/Rn}?KZ��FV?KZ�(��?KZ�瞠?KZ�ь�?KZ�~��?KZ�\�?��o�&�?��o�fJ?��o��?��o��?��o��>?��o���?�5�\{)M?�5�\{k�?�5�\{��?�5�\{[�?�5�\{-$?�5�\{U	?�     ?�     ?�     ?�     ?�     ?�                                                                                                                                                                                                                                                                                                     ?�������?�4��7O?�4��$�?B`�q�X�?B`�r!_#?�4���?B`�r&��?�5 1��?B`�q�h4?�4� ��?B`�r�?�5 6�[?B`�q�?w>�b�?w>��7?w>�K�?w>��?w>�?w>���?�}wa���?�}wa�y_?�}wa�L�?�}wa��[?�}waҴ	?�}waҪ?���U?���U,?���UD�?���U0�?���U�?���U�?�     ?�     ?�     ?�     ?�     ?�                                                                                                                                                                                                                                                                                                     ?���Q�?C �Ξl?C �Ε�?e���
?e���U�?C ��e3�?e���ը?C �Φ�r?e���H�?C �Ν�?e����Q?C �Ί��?e����?�ѹq��?�ѹq�v?�ѹq՗�?�ѹq�	�?�ѹqկ�?�ѹq�?�OG����?�OG��Ŭ?�OG��":?�OG���8?�OG��ڼ?�OG��԰?ڴ��ܾ�?ڴ����j?ڴ���ʭ?ڴ����?ڴ��ܶZ?ڴ��ܶy?�     ?�     ?�     ?�     ?�     ?�                                                                                                                                                                                                                                                                                                     ?�
=p��?aC���)?aC���?}Ё����?}Ё��6�?aC���Q?}Ё��/?aC����?}Ё��g�?aC���g�?}Ё���-?aC����?}Ё���?�'����?�'����+?�'����?�'����m?�'���2?�'���F�?�ҚVn ?�ҚV7c?�ҚVd�?�ҚVj�?�ҚVS�?�ҚVZX?޺��H��?޺��H�!?޺��H�a?޺��H��?޺��H��?޺��H�n?�     ?�     ?�     ?�     ?�     ?�                                                                                                                                                                                                                                                                                                     