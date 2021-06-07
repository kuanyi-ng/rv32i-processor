`include "constants/branch_alu_op.v"

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
                `EQ: branch_alu_out = (in1 == in2);

                // NE
                `NE: branch_alu_out = (in1 != in2);

                // JAL, JALR, MRET
                `JUMP: branch_alu_out = 1'b1;

                // Other instructions that doesn't need to branch / jump
                `NO_JUMP: branch_alu_out = 1'b0;

                // LT
                `LT: branch_alu_out = ($signed(in1) < $signed(in2));

                // GE
                `GE: branch_alu_out = ($signed(in1) >= $signed(in2));

                // LTU
                `LTU: branch_alu_out = (in1 < in2);

                // GEU
                `GEU: branch_alu_out = (in1 >= in2);

                // no default case as every case is covered
            endcase 
        end        
    endfunction    
endmodule