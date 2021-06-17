`include "constants/pipeline_regs_default.v"

module id_ex_regs (
    input clk,
    input rst_n,
    input stall,
    input interlock,
    input pipeline_flush,

    input [31:0] pc_in,
    output [31:0] pc_out,

    input [31:0] pc4_in,
    output [31:0] pc4_out,

    input [31:0] data1_in, data2_in,
    output [31:0] data1_out, data2_out,

    input [6:0] funct7_in,
    output [6:0] funct7_out,

    input [2:0] funct3_in,
    output [2:0] funct3_out,

    input [4:0] rs2_in,
    output [4:0] rs2_out,

    input [4:0] rd_in,
    output [4:0] rd_out,

    input [11:0] csr_addr_in,
    output [11:0] csr_addr_out,

    input [3:0] ir_type_in,
    output [3:0] ir_type_out,

    input wr_reg_n_in,
    output wr_reg_n_out,

    input wr_csr_n_in,
    output wr_csr_n_out,

    input flush_in,
    output flush_out,

    input jump_prediction_in,
    output jump_prediction_out,

    input [31:0] addr_prediction_in,
    output [31:0] addr_prediction_out,

    input [31:0] in1_in,
    output [31:0] in1_out,

    input [31:0] in2_in,
    output [31:0] in2_out
);

    reg [31:0] pc;
    reg [31:0] pc4;
    reg [31:0] data1, data2;
    reg [6:0] funct7;
    reg [2:0] funct3;
    reg [4:0] rs2, rd;
    reg [11:0] csr_addr;
    reg [3:0] ir_type;
    reg wr_reg_n;
    reg wr_csr_n;
    reg flush;
    reg jump_prediction;
    reg [31:0] addr_prediction;
    reg [31:0] in1, in2;

    wire stall_or_interlock = stall || interlock;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            pc <= `DEFAULT_PC;
            pc4 <= `DEFAULT_PC4;
            data1 <= `ZERO_32BIT;
            data2 <= `ZERO_32BIT;
            funct7 <= `DEFAULT_FUNCT7;
            funct3 <= `DEFAULT_FUNCT3;
            rs2 <= `DEFAULT_REG;
            rd <= `DEFAULT_REG;
            csr_addr <= `DEFAULT_CSR_ADDR;
            ir_type <= `DEFAULT_IR_TYPE;
            wr_reg_n <= `DEFAULT_WR_N;
            wr_csr_n <= `DEFAULT_WR_N;
            flush <= `DEFAULT_FLUSH;
            jump_prediction <= 1'b0;
            addr_prediction <= `DEFAULT_PC4;
            in1 <= `ZERO_32BIT;
            in2 <= `ZERO_32BIT;
        end else if (stall_or_interlock) begin
            // since interlock behaves just like stall
            pc <= pc;
            pc4 <= pc4;
            data1 <= data1;
            data2 <= data2;
            funct7 <= funct7;
            funct3 <= funct3;
            rs2 <= rs2;
            rd <= rd;
            csr_addr <= csr_addr;
            ir_type <= ir_type;
            // in order to prevent double detection of stall,
            // which will cause the pipeline to stall forever,
            // it is required to set wr signals to inactive.
            wr_reg_n <= 1'b1;
            wr_csr_n <= 1'b1;
            flush <= flush;
            jump_prediction <= jump_prediction;
            addr_prediction <= addr_prediction;
            in1 <= in1;
            in2 <= in2;
        end else begin
            pc <= pc_in;
            pc4 <= pc4_in;
            data1 <= data1_in;
            data2 <= data2_in;
            funct7 <= funct7_in;
            funct3 <= funct3_in;
            rs2 <= rs2_in;
            rd <= rd_in;
            csr_addr <= csr_addr_in;
            ir_type <= ir_type_in;
            wr_reg_n <= (pipeline_flush) ? 1'b1 : wr_reg_n_in;
            wr_csr_n <= (pipeline_flush) ? 1'b1 : wr_csr_n_in;
            flush <= pipeline_flush || flush_in;
            jump_prediction <= jump_prediction_in;
            addr_prediction <= addr_prediction_in;
            in1 <= in1_in;
            in2 <= in2_in;
        end
    end

    assign pc_out = pc;
    assign pc4_out = pc4;
    assign data1_out = data1;
    assign data2_out = data2;
    assign funct7_out = funct7;
    assign funct3_out = funct3;
    assign rs2_out = rs2;
    assign csr_addr_out = csr_addr;
    assign rd_out = rd;
    assign ir_type_out = ir_type;
    assign wr_reg_n_out = wr_reg_n;
    assign wr_csr_n_out = wr_csr_n;
    assign flush_out = flush;
    assign jump_prediction_out = jump_prediction;
    assign addr_prediction_out = addr_prediction;
    assign in1_out = in1;
    assign in2_out = in2;
    
endmodule
