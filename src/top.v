module top (
    input clk,
    input rst_n,

    // Instructions Memory
    output [31:0] IAD,  // Instruction Address Bus
    input [31:0] IDT,   // Instruction Data Bus
    input ACKI_n,       // Acknowledge from Instruction Memory, 0: ready to access, 1: not ready

    // Data Memory
    output [31:0] DAD,  // Data Address Bus
    inout [31:0] DDT,   // Data Data Bus
    output MREQ,        // Memory Request, 0: don't access, 1: access
    output WRITE,       // Write to Data Memory, 0: don't write, 1: write
    output [1:0] SIZE,  // Access Size of Data Memory
    input ACKD_n        // Acknowledge from Data Memory, 0: ready to access, 1: not ready
);
    //
    // IF
    //

    wire [31:0] next_pc; 
    wire [31:0] current_pc;
    reg32 pc_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(next_pc),
        .default_in(32'h0001_0000),
        .out(current_pc)
    );

    if_stage if_stage_inst(
        .current_pc(current_pc),
        .c(32'd0),
        .jump_or_branch(1'd0),
        .next_pc(next_pc)
    );

    assign IAD = (ACKI_n == 1'b0) ? current_pc : 32'hZ;

    //
    // IF-ID
    //

    wire [31:0] pc_from_if;
    reg32 pc_if_id_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(current_pc),
        .default_in(32'h0001_0000),
        .out(pc_from_if)
    );

    wire [31:0] ir_from_if;
    reg32 ir_if_id_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(IDT),
        .default_in(32'hZ),
        .out(ir_from_if)
    );

endmodule