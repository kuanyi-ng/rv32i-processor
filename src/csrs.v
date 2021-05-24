`include "m_info_regs.v"
`include "m_trap_setup_regs.v"
`include "mie_reg.v"
`include "mip_reg.v"
`include "mstatus_reg.v"
`include "reg32.v"

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

    wire [1:0] priviledge_mode;
    wire [31:0] mstatus;
    mstatus_reg mstatus_reg_inst(
        .clk(clk),
        .rst_n(rst_n),
        .priviledge_mode(priviledge_mode),
        .mstatus(mstatus)
    );

    wire wr_mie = !wr_csr_n && (csr_wr_addr == mie_addr);
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

    wire [31:0] mscratch_in;
    wire [31:0] mscratch;
    reg32 mscratch_reg_inst(
        .clk(clk),
        .rst_n(rst_n),
        .in(mscratch_in),
        .out(mscratch)
    );

    wire [31:0] mepc_in;
    wire [31:0] mepc;
    reg32 mepc_reg_inst(
        .clk(clk),
        .rst_n(rst_n),
        .in(mepc_in),
        .out(mepc)
    );

    localparam [31:0] hard_reset_mcause_val = 32'b0;
    wire [31:0] mcause_in;
    wire [31:0] mcause;
    reg32 #(.rst_value(hard_reset_mcause_val)) mcause_reg_inst(
        .clk(clk),
        .rst_n(rst_n),
        .in(mcause_in),
        .out(mcause)
    );

    wire [31:0] mtval_in;
    wire [31:0] mtval;
    reg32 mtval_reg_inst(
        .clk(clk),
        .rst_n(rst_n),
        .in(mtval_in),
        .out(mtval)
    );

    wire [31:0] mip;
    mip_reg mip_reg_inst(
        .clk(clk),
        .rst_n(rst_n),
        .mip(mip)
    );
    
    assign csr_out = csr_read_value(csr_addr);

    //
    // Function
    //

    function [31:0] csr_read_value(input [11:0] csr_addr);
        begin
            case (csr_addr)
                mvendorid_addr: csr_read_value = mvendorid;

                marchid_addr: csr_read_value = marchid;

                mimpid_addr: csr_read_value = mimpid;

                mhartid_addr: csr_read_value = mhartid;

                mstatus_addr: csr_read_value = mstatus;

                misa_addr: csr_read_value = misa;

                mie_addr: csr_read_value = mie;

                mtvec_addr: csr_read_value = mtvec;

                mcounteren_addr: csr_read_value = mcounteren;

                mscratch_addr: csr_read_value = mscratch;

                mepc_addr: csr_read_value = mepc;

                mcause_addr: csr_read_value = mcause;

                mtval_addr: csr_read_value = mtval;

                mip_addr: csr_read_value = mip;

                default: csr_read_value = 32'b0;
            endcase
        end
    endfunction
    
endmodule
