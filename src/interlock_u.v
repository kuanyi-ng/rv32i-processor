`include "constants/ir_type.v"

// interlock pipeline when memory access is not completed yet.
// when accessing the memory, the processor will receive acknowledge signals
// from the memory module.
// After a memory access (read/write) succeed, 
// processor will recieve active acknowledge signals.
module interlock_u (
    input imem_ack_n,   // 0: succeed, 1: still accessing
    input dmem_ack_n,   // 0: succeed, 1: still accessing
    input [3:0] ir_type, // ir_type from MEM Stage

    output interlock
);

    //
    // Main
    //

    assign interlock = imem_ack_n || dmem_interlock_ctrl(dmem_ack_n, ir_type);

    //
    // Function
    //

    function dmem_interlock_ctrl(input dmem_ack_n, input [3:0] ir_type);
        reg is_load, is_store;

        begin
            is_load = (ir_type == `LOAD_IR);
            is_store = (ir_type == `STORE_IR);

            // only interlock when memory access doesn't complete
            // for Load or Store instructions
            dmem_interlock_ctrl = (is_load || is_store) && dmem_ack_n;
        end
    endfunction
    
endmodule
