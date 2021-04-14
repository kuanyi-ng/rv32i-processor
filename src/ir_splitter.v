module ir_splitter (
    input [31:0] ir,
    output [6:0] opcode,
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,
    output [2:0] funct3,
    output [6:0] funct7
);
    assign opcode = ir[6:0];
    assign rs1 = ir[19:15];
    assign rs2 = ir[24:20];
    assign rd = ir[11:7];
    assign funct3 = ir[14:12];
    assign funct7 = ir[31:25];
endmodule