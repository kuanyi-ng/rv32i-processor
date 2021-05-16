# Get the program needed for Logical Synthesis
set search_path [concat "/usr/local/lib/hit18-lib/kyoto_lib/synopsys/" $search_path]
set LIB_MAX_FILE {HIT018.db}
set link_library $LIB_MAX_FILE
set target_library $LIB_MAX_FILE

# Read Verilog Modules
# NOTE: need to read low-level modules first

# Modules in IF stage
read_verilog pc_adder.v
read_verilog if_ctrl.v

# Modules in ID stage
read_verilog ir_splitter.v
read_verilog imm_extractor.v

# Modules in EX stage
read_verilog ex_ctrl.v
read_verilog alu.v
read_verilog branch_alu.v

# Modules in MEM stage
read_verilog mem_ctrl.v
read_verilog st_converter.v
read_verilog ld_converter.v

# Modules in WB stage
read_verilog wb_ctrl.v

# Module used by rf32x32.v
read_verilog DW_ram_2r_w_s_dff.v

# Modules in Top Module
read_verilog data_forward_helper.v
read_verilog data_forward_u.v
read_verilog ex_data_picker.v
read_verilog ex_jump_picker.v
read_verilog ex_mem_regs.v
read_verilog ex_stage.v
read_verilog flush_u.v
read_verilog id_data_picker.v
read_verilog id_ex_regs.v
read_verilog id_flush_picker.v
read_verilog id_stage.v
read_verilog id_wr_reg_n_picker.v
read_verilog if_id_regs.v
read_verilog if_stage.v
read_verilog mem_stage.v
read_verilog mem_wb_regs.v
read_verilog pc_reg.v
read_verilog rf32x32.v
read_verilog stall_detector.v
read_verilog wb_stage.v

# Top Module
read_verilog top.v

# Define which module is the Highest-level Module
current_design "top"

# Max Area of Circuits
set_max_area 0

# Max Fan-out
# From Wikipedia,
# The greatest number of inputs of gates of the same type to which
# the output can be safely connected.
# NOTE: Google Image "fanout" for better idea
set_max_fanout 64 [current_design]

# Create Clock
create_clock -period 10.00 clk
set_clock_uncertainty -setup 0.0 [get_clock clk]
set_clock_uncertainty -hold 0.0 [get_clock clk]
set_input_delay 0.0 -clock clk [remove_from_collection [all_inputs] clk]
set_output_delay 0.0 -clock clk [remove_from_collection [all_outputs] clk]

# Start Logical Synthesis
compile -map_effort mediium -area_effort high -incremental_mapping

# Show results
report_timing -max_paths 1
report_area
report_power

write -hier -format verilog -output rv32_processor.vnet
write -hier -output rv32_processor.db

quit
