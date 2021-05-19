// interlock pipeline when memory access is not completed yet.
// when accessing the memory, the processor will receive acknowledge signals
// from the memory module.
// After a memory access (read/write) succeed, 
// processor will recieve active acknowledge signals.
module interlock_u (
    input imem_ack_n,   // 0: succeed, 1: still accessing
    input dmem_ack_n,   // 0: succeed, 1: still accessing

    output interlock
);

    //
    // Main
    //

    assign interlock = imem_ack_n || dmem_ack_n;
    
endmodule