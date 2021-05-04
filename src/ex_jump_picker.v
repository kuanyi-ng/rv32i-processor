module ex_jump_picker (
    // Inputs
    input jump_from_branch_alu,
    input flush_from_id,

    // Outputs
    output jump
);

    // Even if current instruction is a branch instruction
    // and the branch result is 1 (jump),
    // need to set jump as 0 if flush.
    // (came from previous branhc instruction)
    assign jump = (flush_from_id) ? 1'b0 : jump_from_branch_alu;
    
endmodule
