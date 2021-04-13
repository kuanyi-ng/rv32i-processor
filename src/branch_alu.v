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
        reg signed [31:0] s_in1;
        reg signed [31:0] s_in2;

        begin
            s_in1 = in1;
            s_in2 = in2;

            case (op)
                // EQ
                3'b000: branch_alu_out = (in1 == in2) ? 1'b1 : 1'b0;

                // NE
                3'b001: branch_alu_out = (in1 != in2) ? 1'b1: 1'b0;

                // LT
                3'b010: branch_alu_out = (s_in1 < s_in2) ? 1'b1 : 1'b0;

                // LTU
                3'b011: branch_alu_out = (in1 < in2) ? 1'b1 : 1'b0;

                // GE
                3'b100: branch_alu_out = (s_in1 > s_in2) ? 1'b1 : 1'b0;

                // GEU
                3'b101: branch_alu_out = (in1 > in2) ? 1'b1 : 1'b0;

                // JAL
                3'b110: branch_alu_out = 1'b1;

                // JALR
                3'b111: branch_alu_out = 1'b1;

                // all cases covered, so no default value is required
                // default: false (don't branch / jump just in case something went wrong)
                default: branch_alu_out = 1'b0;
            endcase 
        end        
    endfunction    
endmodule