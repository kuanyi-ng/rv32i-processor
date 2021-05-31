module mstatus_reg (
    input clk,
    input rst_n,

    input is_mret,
    input exception_raised,

    input [31:0] mstatus_in,
    input wr_mstatus,

    output [1:0] priviledge_mode,
    output [31:0] mstatus
);

    localparam [1:0] machine_mode = 2'b11;
    localparam [1:0] supervisor_mode = 2'b01;
    localparam [1:0] user_mode = 2'b00;

    reg [1:0] current_mode;

    // Machine Status Register
    // Global interrupt-enable bits     : MIE, SIE, UIE
    reg mie;
    reg sie;
    reg uie;

    // Previous interrupt-enable bits   : MPIE, SPIE, UPIE
    reg mpie, spie, upie;

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

    // NOTE:
    // using `posedge clk` will only output the new value on the next posedge of clk (= posedge of next cycle)
    // using `negedge clk` will ouput the new value on the next negedge of clk (= negedge of current cycle)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // on reset,
            // priviledge mode is set to M
            // MIE is reset to 0
            // User-mode not supported
            { current_mode, mpp, spp } <= { machine_mode, machine_mode, 1'b0 };
            { mie, sie, uie } <= 3'b100;
            { mpie, spie, upie } <= 3'b000;
        end else if (exception_raised) begin
            { current_mode, mpp } <= { machine_mode, current_mode };
            { mpie, mie } <= { mie, 1'b0 };
        end else if (is_mret) begin
            { mie, mpie } <= { mpie, 1'b1 };
        end else if (wr_mstatus) begin
            // TODO: not sure how to update current_mode
            { mie, sie, uie } <= { mstatus_in[3], mstatus_in[1:0] };
            { mpie, spie, upie } <= { mstatus_in[7], mstatus_in[5:4] };
            { mpp, spp } <= { mstatus_in[12:11], mstatus_in[8] };
        end else begin
            // No interruption
            current_mode <= current_mode;
            { mie, sie, uie } <= { mie, sie, uie };
            { mpie, spie, upie } <= { mpie, spie, upie };
            { mpp, spp } <= { mpp, spp };
        end
    end

    // SD, ?[7:0], TSR, TW, TVM, MXR, SUM, MPRV, XS[1:0], FS[1:0], MPP[1:0], ?[1:0], SPP, MPIE, ?, SPIE, UPIE, MIE, ?, SIE, UIE
    assign mstatus = { 1'b0, 8'b0, tsr, tw, tvm, mxr, sum, mprv, 2'b00, 2'b00, mpp, 2'b00, spp, mpie, 1'b0, spie, upie, mie, 1'b0, sie, uie };
    
    assign priviledge_mode = current_mode;

endmodule