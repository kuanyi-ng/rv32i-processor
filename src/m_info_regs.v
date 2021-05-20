// All the CSRs in this module is read-only
// They are all hard-coded
// 
// TODO: check if rst_n affects them
module m_info_regs (
    output [31:0] mvendorid,
    output [31:0] marchid,
    output [31:0] mimpid,
    output [31:0] mhartid
);

    assign mvendorid = 32'b0;
    assign marchid = 32'b0;
    assign mimpid = 32'b0;
    assign mhartid = 32'b0;
    
endmodule