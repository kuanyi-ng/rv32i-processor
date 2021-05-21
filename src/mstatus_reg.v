module mstatus_reg (
    output [31:0] mstatus
);
    // Machine Status Register
    // Global interrupt-enable bits     : MIE, SIE, UIE
    reg mie = 1'b1;
    reg sie = 1'b0;
    reg uie = 1'b0;

    // Previous interrupt-enable bits   : MPIE, SPIE, UPIE
    reg mpie;
    reg spie;
    reg upie;

    // Previous Priviledge mode         : MPP, SPP
    // When a trap is taken from priviledge mode y into priviledge mode x,
    //  xPIE <= xIE, xIE <= 0, xPP <= y
    reg [1:0] mpp;
    reg spp;

    // Modify Priviledge                : MPRV (hardwired to 0 if U-mode not supported)
    localparam mprv = 1'b0;

    // Make Executable Readable         : MXR (hardwired to 0 if S-mode not supported)
    localparam mxr = 1'b0;

    // Permit Supervisor User Memory Access : SUM (hardwired to 0 if S-mode not supported)
    localparam sum = 1'b0;

    // Trap Virtual Memory              : TVM (hardwired to 0 if S-mode not supported)
    localparam tvm = 1'b0;

    // Timeout Wait                     : TW (hardwired to 0 if only M-mode supported)
    localparam tw = 1'b0;

    // Trap SRET                        : TSR (hardwired to 0 if S-mode not supported)
    localparam tsr = 1'b0;

    // SD, ?[7:0], TSR, TW, TVM, MXR, SUM, MPRV, XS[1:0], FS[1:0], MPP[1:0], ?[1:0], SPP, MPIE, ?, SPIE, UPIE, MIE, ?, SIE, UIE
    assign mstatus = { 1'b0, 8'b0, tsr, tw, tvm, mxr, sum, mprv, 2'b00, 2'b00, mpp, 2'b00, spp, mpie, 1'b0, spie, upie, mie, 1'b0, sie, uie };
    
endmodule