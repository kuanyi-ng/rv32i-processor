module mip_reg (
    output [31:0] mip
);

    // Machine Interrupt-Enable Register
    // External Interrupt-Enable
    reg meip, seip, ueip;
    // Timer Interrupt-Enable
    reg mtip, stip, utip;
    // Software Interrupt-Enable
    reg msip, ssip, usip;

    assign mip = { 20'b0, meip, 1'b0, seip, ueip, mtip, 1'b0, stip, utip, msip, 1'b0, ssip, usip };

endmodule