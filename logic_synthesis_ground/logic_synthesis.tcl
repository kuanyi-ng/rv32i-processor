# Get the program needed for Logical Synthesis
set search_path [concat "/usr/local/lib/hit18-lib/kyoto_lib/synopsys/" $search_path]
set LIB_MAX_FILE {HIT018.db}
set link_library $LIB_MAX_FILE
set target_library $LIB_MAX_FILE

# Read Verilog Modules
# Top Module
# read_verilog ./top.v
# Analyze and Elaborate Parameterized Modules

analyze -format verilog ./data_forward_helper.v
elaborate data_forward_helper

analyze -format verilog ./DW_ram_2r_w_s_dff.v
elaborate DW_ram_2r_w_s_dff

analyze -format verilog ./rf32x32.v
elaborate rf32x32

analyze -format verilog ./csr_reg.v
elaborate csr_reg

analyze -format verilog ./jump_predictor.v
elaborate jump_predictor

analyze -format verilog ./top.v
elaborate top

# Define which module is the Highest-level Module
current_design "top"

# Max Area of Circuits
# Usually speed is more important, so just aim for the best area
# by setting max_area to 0
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

# Check if Clock is created
derive_clocks

# Start Logical Synthesis
compile
# ungroup -all -flatten
compile -incremental -map_effort high -area_effort high -incremental_mapping
# compile -map_effort medium -area_effort high -incremental_mapping

# Check Design
check_design

# Show results
report_timing -net
report_cell
report_area
report_power
report_constraint -all_violators
report_reference

write -hier -format verilog -output rv32_processor.vnet
write -hier -output rv32_processor.db

quit
