// The only instructions that uses b_ex in MEM stage are Store instructions.
// So it will not be a problem to forward_b even if the current instruction
// is not a Store instruction.
module ex_data_picker (
    // Input from EX Stage (current instruction)
    input [31:0] data2_from_id,

    // Input from MEM Stage (previous instruction)
    input [31:0] d_mem,

    // Input from Data Forwarding Unit
    input forward_b,

    // Output
    // value of B to pass on to MEM stage
    output [31:0] b_ex
);

    //
    // Main
    //
    assign b_ex = (forward_b) ? d_mem : data2_from_id;
    
endmodule