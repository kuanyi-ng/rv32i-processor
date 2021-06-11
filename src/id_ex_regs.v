module id_ex_regs (
    input clk,
    input rst_n,
    input stall,
    input interlock,

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

    input [6:0] opcode_in,
    output [6:0] opcode_out,

    input [31:0] imm_in,
    output [31:0] imm_out,

    input [31:0] z_in,
    output [31:0] z_out,

    input wr_reg_n_in,
    output wr_reg_n_out,

    input wr_csr_n_in,
    output wr_csr_n_out,

    input flush_in,
    output flush_out
);

    reg [31:0] pc;
    reg [31:0] pc4;
    reg [31:0] data1, data2;
    reg [6:0] funct7;
    reg [2:0] funct3;
    reg [4:0] rs2, rd;
    reg [11:0] csr_addr;
    reg [6:0] opcode;
    reg [31:0] imm;
    reg [31:0] z_;
    reg wr_reg_n;
    reg wr_csr_n;
    reg flush;

    wire stall_or_interlock = stall || interlock;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            pc <= 32'bx;
            pc4 <= 32'bx;
            data1 <= 32'bx;
            data2 <= 32'bx;
            funct7 <= 7'bx; // TODO: change to NOP
            funct3 <= 3'bx; // TODO: change to NOP
            rs2 <= 5'bx; // TODO: change to NOP
            rd <= 5'bx; // TODO: change to NOP
            csr_addr <= 12'bx;
            opcode <= 7'bx; // TODO: change to NOP
            imm <= 32'bx; // TODO: change to NOP
            z_ <= 32'bx;
            wr_reg_n <= 1'b1;   // default not to write
            wr_csr_n <= 1'b1;   // default not to write
            flush <= 1'b0;      // default not to flush
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
            opcode <= opcode;
            imm <= imm;
            z_ <= z_;
            // in order to prevent double detection of stall,
            // which will cause the pipeline to stall forever,
            // it is required to set wr signals to inactive.
            wr_reg_n <= 1'b1;
            wr_csr_n <= 1'b1;
            flush <= flush;
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
            opcode <= opcode_in;
            imm <= imm_in;
            z_ <= z_in;
            wr_reg_n <= wr_reg_n_in;
            wr_csr_n <= wr_csr_n_in;
            flush <= flush_in;
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
    assign opcode_out = opcode;
    assign imm_out = imm;
    assign z_out = z_;
    assign wr_reg_n_out = wr_reg_n;
    assign wr_csr_n_out = wr_csr_n;
    assign flush_out = flush;
    
endmodule
