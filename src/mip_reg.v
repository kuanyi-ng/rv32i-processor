module mip_reg (
    input clk,
    input rst_n,

    output [31:0] mip
);

    // Machine Interrupt-Enable Register
    // External Interrupt-Enable
    reg meip, seip, ueip;
    // Timer Interrupt-Enable
    reg mtip, stip, utip;
    // Software Interrupt-Enable
    reg msip, ssip, usip;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            { meip, seip, ueip } <= 3'b000;
            { mtip, stip, utip } <= 3'b000;
            { msip, ssip, usip } <= 3'b000;
        end else begin
            { meip, seip, ueip } <= { meip, seip, ueip };
            { mtip, stip, utip } <= { mtip, stip, utip };
            { msip, ssip, usip } <= { msip, ssip, usip };
        end
    end

    assign mip = { 20'b0, meip, 1'b0, seip, ueip, mtip, 1'b0, stip, utip, msip, 1'b0, ssip, usip };

endmodule