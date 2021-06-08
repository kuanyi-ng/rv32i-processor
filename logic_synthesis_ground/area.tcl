# Get the program needed for Logical Synthesis
set search_path [concat "/usr/local/lib/hit18-lib/kyoto_lib/synopsys/" $search_path]
set LIB_MAX_FILE {HIT018.db}
set link_library $LIB_MAX_FILE
set target_library $LIB_MAX_FILE

# Read Verilog Modules

analyze -format verilog ./ex_stage.v
elaborate ex_stage

# Define which module is the Highest-level Module
current_design "ex_stage"

set_structure -boolean true

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

# Start Logical Synthesis
ungroup -all -flatten
compile -incremental -area_effort high

# Check Design
check_design

# Show results
report_area
report_constraint -verbose
report_reference

write -hier -format verilog -output rv32_processor.vnet
write -hier -output rv32_processor.db

quit
