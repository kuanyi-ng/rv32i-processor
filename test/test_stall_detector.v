module test_data_forward_u ();
    reg [4:0] rs1, rs2, rd_in_ex;

    reg wr_reg_n_in_ex;
    reg [6:0] opcode_in_id, opcode_in_ex;

    wire stall;

    stall_detector subject(
        .rs1(rs1),
        .rs2(rs2),
        .opcode_in_id(opcode_in_id),
        .wr_reg_n_in_ex(wr_reg_n_in_ex),
        .rd_in_ex(rd_in_ex),
        .opcode_in_ex(opcode_in_ex),
        .stall(stall)
    );

    initial begin
        // assume all instructions involved try to update regfile
        // for simplicity and worst case
        assign wr_reg_n_in_ex = 1'b0;

        // both rs1 and rs2 are x0
        assign rs1 = 5'b00000;
        assign rs2 = 5'b00000;
        assign rd_in_ex = 5'b00000;
        assign opcode_in_id = 7'b0110011;   // R-Type
        assign opcode_in_ex = 7'b0000011;   // Load
        // stall: 0
        #5

        // both rs1, rs2 are not updated
        assign rs1 = 5'b00001;
        assign rs2 = 5'b00010;
        assign rd_in_ex = 5'b10001;
        assign opcode_in_id = 7'b0110011;   // R-Type
        assign opcode_in_ex = 7'b0000011;   // Load
        // stall: 0
        #5

        // instruction in EX is not Load instruction
        assign rs1 = 5'b00001;
        assign rs2 = 5'b00010;
        assign rd_in_ex = 5'b00001;
        assign opcode_in_id = 7'b0110011;   // R-Type
        assign opcode_in_ex = 7'b0110011;   // R-Type
        // stall: 0
        #5

        // EX instruction is Load instruction
        // ID instruction is Store instruction
        // rs1 not updated, rs2 not updated
        assign rs1 = 5'b00001;
        assign rs2 = 5'b00010;
        assign rd_in_ex = 5'b10001;
        assign opcode_in_id = 7'b0100011;   // Store
        assign opcode_in_ex = 7'b0000011;   // Load
        // stall: 0
        #5

        // EX instruction is Load instruction
        // ID instruction is Store instruction
        // rs1 not updated, rs2 updated
        assign rs1 = 5'b00001;
        assign rs2 = 5'b00010;
        assign rd_in_ex = 5'b00010;
        assign opcode_in_id = 7'b0100011;   // Store
        assign opcode_in_ex = 7'b0000011;   // Load
        // stall: 0
        #5

        // EX instruction is Load instruction
        // ID instruction is Store instruction
        // rs1 updated, rs2 not updated
        assign rs1 = 5'b00001;
        assign rs2 = 5'b00010;
        assign rd_in_ex = 5'b00001;
        assign opcode_in_id = 7'b0100011;   // Store
        assign opcode_in_ex = 7'b0000011;   // Load
        // stall: 1
        #5
  
        // EX instruction is Load instruction
        // ID instruction is Store instruction
        // rs1 updated, rs2 updated
        assign rs1 = 5'b00001;
        assign rs2 = 5'b00001;
        assign rd_in_ex = 5'b00001;
        assign opcode_in_id = 7'b0100011;   // Store
        assign opcode_in_ex = 7'b0000011;   // Load
        // stall: 1
        #5

        // rs1 is updated
        assign rs1 = 5'b00001;
        assign rs2 = 5'b00010;
        assign rd_in_ex = 5'b00001;
        assign opcode_in_id = 7'b0110011;   // R-Type
        assign opcode_in_ex = 7'b0000011;   // Load
        // stall: 1
        #5

        // rs2 is updated
        assign rs1 = 5'b00001;
        assign rs2 = 5'b00010;
        assign rd_in_ex = 5'b00010;
        assign opcode_in_id = 7'b0110011;   // R-Type
        assign opcode_in_ex = 7'b0000011;   // Load
        // stall: 1
        #5

        $finish;
    end

    initial begin
        $monitor("t: %3d, stall: %b", $time, stall);
    end
endmodule
