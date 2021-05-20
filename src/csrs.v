`include "m_info_regs.v"

module csrs (
    input clk,
    input rst_n,

    // Inputs
    input [11:0] csr_addr,

    // Outputs
    output [31:0] csr_out
);

    //
    // Priviledge Mode
    //

    localparam [1:0] machine_mode = 2'b11;

    //
    // CSRs Address
    //
    
    localparam [11:0] mvendorid_addr = 12'hf11;
    localparam [11:0] marchid_addr = 12'hf12;
    localparam [11:0] mimpid_addr = 12'hf13;
    localparam [11:0] mhartid_addr = 12'hf14;

    //
    // Machine Information Registers
    //

    wire [31:0] mvendorid;
    wire [31:0] marchid;
    wire [31:0] mimpid;
    wire [31:0] mhartid;
    m_info_regs m_info_regs_inst(
        .mvendorid(mvendorid),
        .marchid(marchid),
        .mimpid(mimpid),
        .mhartid(mhartid)
    );
    
    reg [31:0] csr_out_value;
    always @(posedge clk or negedge rst_n) begin
        case (csr_addr)
            mvendorid_addr: csr_out_value <= mvendorid;

            marchid_addr: csr_out_value <= marchid;

            mimpid_addr: csr_out_value <= mimpid;

            mhartid_addr: csr_out_value <= mhartid;

            default: csr_out_value <= 32'b0;
        endcase
    end

    assign csr_out = csr_out_value;
    
endmodule