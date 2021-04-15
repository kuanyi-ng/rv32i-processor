module ex_ctrl (
    input [6:0] opcode,
    input [3:0] funct3,
    input [6:0] funct7,
    output a_sel            // 0: data1, 1: pc
);
    //
    // main
    //
    assign a_sel = a_sel_out(opcode);

    //
    // functions
    //
    function a_sel_out(input [6:0] opcode);
        // since most instructions use data1,
        // we will only check if the instructions need pc
        reg is_aupic;
        reg is_jal;
        reg is_branch;

        begin
            // AUPIC, JAL, Branch
            is_aupic = (opcode == 7'b0010111);
            is_jal = (opcode == 7'b1101111);
            is_branch = (opcode == 7'b1100011);

            a_sel_out = is_aupic || is_jal || is_branch;            
        end
    endfunction
endmodule