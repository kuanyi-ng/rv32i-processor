module mie_reg (
    output [31:0] mie
);

    // Machine Interrupt-Enable Register
    // External Interrupt-Enable
    reg meie, seie, ueie;
    // Timer Interrupt-Enable
    reg mtie, stie, utie;
    // Software Interrupt-Enable
    reg msie, ssie, usie;

    assign mie = { 20'b0, meie, 1'b0, seie, ueie, mtie, 1'b0, stie, utie, msie, 1'b0, ssie, usie };

endmodule