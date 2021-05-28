`include "m_info_regs.v"
`include "m_trap_setup_regs.v"
`include "mie_reg.v"
`include "mip_reg.v"
`include "mstatus_reg.v"
`include "csr_reg.v"

module csrs (
    input clk,
    input rst_n,

    // Inputs
    // Read
    input [11:0] csr_addr,
    // Write
    input [11:0] csr_wr_addr,
    input [31:0] csr_data_in,
    input wr_csr_n,

    // MRET
    input is_mret,

    // Outputs
    output reg [31:0] csr_out
);

    wire wr_csr = !wr_csr_n;

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

    localparam [11:0] mstatus_addr = 12'h300;
    localparam [11:0] misa_addr = 12'h301;
    localparam [11:0] mie_addr = 12'h304;
    localparam [11:0] mtvec_addr = 12'h305;
    localparam [11:0] mcounteren_addr = 12'h306;

    localparam [11:0] mscratch_addr = 12'h340;
    localparam [11:0] mepc_addr = 12'h341;
    localparam [11:0] mcause_addr = 12'h342;
    localparam [11:0] mtval_addr = 12'h343;
    localparam [11:0] mip_addr = 12'h344;

    //
    // Machine Information Registers
    // Read-only
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

    //
    // Machine Trap Setup
    // Read-only
    //

    wire [31:0] misa;
    wire [31:0] mtvec;
    wire [31:0] mcounteren;
    m_trap_setup_regs m_trap_setup_regs_inst(
        .misa(misa),
        .mtvec(mtvec),
        .mcounteren(mcounteren)
    );

    //
    // Machine Trap Setup
    //

    wire wr_mstatus = wr_csr && (csr_wr_addr == mstatus_addr);
    wire [1:0] priviledge_mode;
    wire [31:0] mstatus;
    mstatus_reg mstatus_reg_inst(
        .clk(clk),
        .rst_n(rst_n),
        .is_mret(is_mret),
        .mstatus_in(csr_data_in),
        .wr_mstatus(wr_mstatus),
        .priviledge_mode(priviledge_mode),
        .mstatus(mstatus)
    );

    wire wr_mie = wr_csr && (csr_wr_addr == mie_addr);
    wire [31:0] mie;
    mie_reg mie_reg_inst(
        .clk(clk),
        .rst_n(rst_n),
        .mie_in(csr_data_in),
        .wr_mie(wr_mie),
        .mie(mie)
    );

    //
    // Machine Trap Handling
    //

    wire wr_mscratch = wr_csr && (csr_wr_addr == mscratch_addr);
    wire [31:0] mscratch;
    csr_reg mscratch_reg_inst(
        .clk(clk),
        .rst_n(rst_n),
        .in(csr_data_in),
        .wr_reg(wr_mscratch),
        .out(mscratch)
    );

    localparam [31:0] mepc_reset_val = 32'bx;
    wire wr_mepc = wr_csr && (csr_wr_addr == mepc_addr);
    wire [31:0] mepc;
    csr_reg #(.rst_value(mepc_reset_val)) mepc_reg_inst(
        .clk(clk),
        .rst_n(rst_n),
        .in(csr_data_in),
        .wr_reg(wr_mepc),
        .out(mepc)
    );

    localparam [31:0] hard_reset_mcause_val = 32'b0;
    wire wr_mcause = wr_csr && (csr_wr_addr == mcause_addr);
    wire [31:0] mcause;
    csr_reg #(.rst_value(hard_reset_mcause_val)) mcause_reg_inst(
        .clk(clk),
        .rst_n(rst_n),
        .in(csr_data_in),
        .wr_reg(wr_mcause),
        .out(mcause)
    );

    wire wr_mtval = wr_csr && (csr_wr_addr == mtval_addr);
    wire [31:0] mtval;
    csr_reg mtval_reg_inst(
        .clk(clk),
        .rst_n(rst_n),
        .in(csr_data_in),
        .wr_reg(wr_mtval),
        .out(mtval)
    );

    wire wr_mip = wr_csr && (csr_wr_addr == mip_addr);
    wire [31:0] mip;
    mip_reg mip_reg_inst(
        .clk(clk),
        .rst_n(rst_n),
        .mip_in(csr_data_in),
        .wr_mip(wr_mip),
        .mip(mip)
    );

    always @(*) begin
        // NOTE: read mepc during mret instruction
        // - the csr_addr decoded from mepc = medeleg
        // - medeleg register doesn't exist in a M-only implementation
        // - but csr_addr is updated to point to mepc instead of medeleg in id_stage
        case (csr_addr)
                mvendorid_addr: csr_out = mvendorid;

                marchid_addr: csr_out = marchid;

                mimpid_addr: csr_out = mimpid;

                mhartid_addr: csr_out = mhartid;

                mstatus_addr: csr_out = mstatus;

                misa_addr: csr_out = misa;

                mie_addr: csr_out = mie;

                mtvec_addr: csr_out = mtvec;

                mcounteren_addr: csr_out = mcounteren;

                mscratch_addr: csr_out = mscratch;

                mepc_addr: csr_out = mepc;

                mcause_addr: csr_out = mcause;

                mtval_addr: csr_out = mtval;

                mip_addr: csr_out = mip;

                default: csr_out = 32'b0;
        endcase
    end

endmodule
