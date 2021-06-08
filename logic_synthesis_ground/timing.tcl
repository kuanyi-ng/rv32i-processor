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

# Define which module is the Highest-level Module
current_design "data_forward_helper"

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
# for clk-independent module
create_clock -period 10.00 -w { 0 5.0 } -name clk
# for module with clk as input
# create_clock -period 10.00 -w { 0 5.0 } clk

set_clock_uncertainty -setup 0.0 [get_clock clk]
set_clock_uncertainty -hold 0.0 [get_clock clk]
set_input_delay 0.0 -clock clk [remove_from_collection [all_inputs] clk]
set_output_delay 0.0 -clock clk [remove_from_collection [all_outputs] clk]

# Check if Clock is created
derive_clocks

# Start Logical Synthesis
compile
ungroup -all -flatten
compile -incremental -map_effort high

# Check Design
check_design

# Show results
report_timing -path end -net -max_path 100
report_area
report_constraint -all_violators

write -hier -format verilog -output rv32_processor.vnet
write -hier -output rv32_processor.db

quit
