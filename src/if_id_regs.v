`include "constants/pipeline_regs_default.v"

module if_id_regs (
    input clk,
    input rst_n,
    input stall,
    input interlock,
    input pipeline_flush,

    input [31:0] pc_in,
    output [31:0] pc_out,

    input [31:0] pc4_in,
    output [31:0] pc4_out,

    input [31:0] ir_in,
    output [31:0] ir_out,

    input [3:0] ir_type_in,
    output [3:0] ir_type_out,

    input flush_in,
    output flush_out,

    input i_addr_misaligned_in,
    output i_addr_misaligned_out,

    input jump_prediction_in,
    output jump_prediction_out,

    input [31:0] addr_prediction_in,
    output [31:0] addr_prediction_out
);

    reg [31:0] pc;
    reg [31:0] pc4;
    reg [31:0] ir;
    reg [3:0] ir_type;
    reg flush;
    reg i_addr_misaligned;
    reg jump_prediction;
    reg [31:0] addr_prediction;

    localparam [31:0] NOP_IR = { 12'b0, 5'b0, 3'b0, 5'b0, 7'b0010011 };

    wire stall_or_interlock = (stall || interlock);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            pc <= `DEFAULT_PC;
            pc4 <= `DEFAULT_PC4;
            ir <= NOP_IR;
            ir_type <= `DEFAULT_IR_TYPE;
            flush <= `DEFAULT_FLUSH;
            i_addr_misaligned <= 1'b0; // default for no misalignment
        end else if (stall_or_interlock) begin
            // holds the same value when stall or interlock
            pc <= pc;
            pc4 <= pc4;
            ir <= ir;
            ir_type <= ir_type;
            flush <= flush;
            i_addr_misaligned <= i_addr_misaligned;
            jump_prediction <= jump_prediction;
            addr_prediction <= addr_prediction;
        end else begin
            // update value
            pc <= pc_in;
            pc4 <= pc4_in;
            ir <= ir_in;
            ir_type <= ir_type_in;
            flush <= pipeline_flush || flush_in;
            i_addr_misaligned <= i_addr_misaligned_in;
            jump_prediction <= jump_prediction_in;
            addr_prediction <= addr_prediction_in;
        end
    end

    assign pc_out = pc;
    assign pc4_out = pc4;
    assign ir_out = ir;
    assign ir_type_out = ir_type;
    assign flush_out = flush;
    assign i_addr_misaligned_out = i_addr_misaligned;
    assign jump_prediction_out = jump_prediction;
    assign addr_prediction_out = addr_prediction;

endmodule
