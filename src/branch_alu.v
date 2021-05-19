// decide whether to branch / jump
// return a boolean value (represented with 1 bit)
module branch_alu (
    input [31:0] in1,
    input [31:0] in2,
    input [2:0] branch_alu_op,
    output out
);
    //
    // main
    //
    assign out = branch_alu_out(in1, in2, branch_alu_op);

    //
    // functions
    //
    function branch_alu_out(input [31:0] in1, input [31:0] in2, input [2:0] op);
        begin
            case (op)
                // EQ
                3'b000: branch_alu_out = (in1 == in2);

                // NE
                3'b001: branch_alu_out = (in1 != in2);

                // JAL, JALR
                3'b010: branch_alu_out = 1'b1;

                // Other instructions that doesn't need to branch / jump
                3'b011: branch_alu_out = 1'b0;

                // LT
                3'b100: branch_alu_out = ($signed(in1) < $signed(in2));

                // GE
                3'b101: branch_alu_out = ($signed(in1) >= $signed(in2));

                // LTU
                3'b110: branch_alu_out = (in1 < in2);

                // GEU
                3'b111: branch_alu_out = (in1 >= in2);

                // no default case as every case is covered
            endcase 
        end        
    endfunction    
endmodule