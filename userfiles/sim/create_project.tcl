#
# Vivado (TM) v2016.4_sdx (64-bit)
#
# create_project.tcl: Tcl script for re-creating project 'wrapper'
#
# Generated by Vivado on Mon Jun 12 18:08:44 +0900 2017
# IP Build 1759159 on Thu Jan 26 07:31:30 MST 2017
#
# This file contains the Vivado Tcl commands for re-creating the project to the state*
# when this script was generated. In order to re-create the project, please source this
# file in the Vivado Tcl Shell.
#
# * Note that the runs in the created project will be configured the same way as the
#   original project, however they will not be launched automatically. To regenerate the
#   run results please launch the synthesis/implementation runs as needed.
#
#*****************************************************************************************

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir [file dirname [info script]]

set proj_name wrapper
set proj_dir "[file normalize $origin_dir/project]"

set essentials_dir "[file normalize "$origin_dir/../../vivado-essentials"]"
set usr_dir "[file normalize "$origin_dir/.."]"

# Create project
create_project -force $proj_name "$proj_dir/" -part xc7z020clg484-1

# Set project properties
set obj [get_projects wrapper]
set_property "board_part" "em.avnet.com:zed:part0:1.3" $obj
set_property "default_lib" "xil_defaultlib" $obj
set_property "ip_cache_permissions" "read write" $obj
set_property "sim.ip.auto_export_scripts" "1" $obj
set_property "simulator_language" "Mixed" $obj
set_property "xpm_libraries" "XPM_CDC XPM_MEMORY" $obj
set_property "xsim.array_display_limit" "64" $obj
set_property "xsim.trace_limit" "65536" $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 $usr_dir/verilog/wrapper.v \
 $usr_dir/verilog/binary_counter_11bit.v \
 $usr_dir/verilog/three_line_buffer.v \
 $usr_dir/verilog/control_generator.v \
 $usr_dir/verilog/fixed_three_line_buffer.v \
 $usr_dir/verilog/conv_rgb2y.v \
 $usr_dir/ip/c_counter_binary_11bit/c_counter_binary_11bit.xci \
 $usr_dir/ip/fifo_fwft_32x16/fifo_fwft_32x16.xci \
 $usr_dir/ip/fifo_fwft_32x4096/fifo_fwft_32x4096.xci \
 $usr_dir/ip/fifo_fwft_96x16/fifo_fwft_96x16.xci \
 $usr_dir/ip/mult_150/mult_150.xci \
 $usr_dir/ip/mult_29/mult_29.xci \
 $usr_dir/ip/mult_77/mult_77.xci \
 $essentials_dir/fifo_32x512/fifo_32x512.xci \
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property "top" "wrapper" $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file $origin_dir/constrs/zed.xdc
set file_added [add_files -norecurse -fileset $obj $file]
set file "$origin_dir/constrs/zed.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property "file_type" "XDC" $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property "target_constrs_file" $origin_dir/constrs/zed.xdc $obj

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
set files [list \
 $origin_dir/verilog/fixed_signal_generator.v \
 $origin_dir/verilog/fixed_lb_tb.v \
 $origin_dir/cfg/behav.wcfg \
]
add_files -norecurse -fileset $obj $files

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property "top" "fixed_lb_tb" $obj
set_property "transport_int_delay" "0" $obj
set_property "transport_path_delay" "0" $obj
set_property "xelab.nosort" "1" $obj
set_property "xelab.unifast" "" $obj
set_property "xsim.view" "[file normalize "$origin_dir/cfg/behav.wcfg"]" $obj

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
  create_run -name synth_1 -part xc7z020clg484-1 -flow {Vivado Synthesis 2016} -strategy "Vivado Synthesis Defaults" -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2016" [get_runs synth_1]
}
set obj [get_runs synth_1]

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
  create_run -name impl_1 -part xc7z020clg484-1 -flow {Vivado Implementation 2016} -strategy "Vivado Implementation Defaults" -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
  set_property flow "Vivado Implementation 2016" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property "steps.write_bitstream.args.readback_file" "0" $obj
set_property "steps.write_bitstream.args.verbose" "0" $obj

# set the current impl run
current_run -implementation [get_runs impl_1]

puts "INFO: Project created:wrapper"
