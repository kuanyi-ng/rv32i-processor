module flush_u (
    input jump,

    output flush
);
    
    // Need to flush the next 2 instructions
    // if current instruction results in a jump
    assign flush = jump;

endmodule