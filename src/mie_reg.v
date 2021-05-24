module mie_reg (
    input clk,
    input rst_n,

    input [31:0] mie_in,
    input wr_mie_n,

    output [31:0] mie
);

    // Machine Interrupt-Enable Register
    // External Interrupt-Enable
    reg meie, seie, ueie;
    // Timer Interrupt-Enable
    reg mtie, stie, utie;
    // Software Interrupt-Enable
    reg msie, ssie, usie;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            { meie, seie, ueie } <= 3'b000;
            { mtie, stie, utie } <= 3'b000;
            { msie, ssie, usie } <= 3'b000;
        end else if (~wr_mie_n) begin
            { meie ,seie, ueie } <= { mie_in[11], mie_in[9:8] };
            { mtie, stie, utie } <= { mie_in[7], mie_in[5:4] };
            { msie, ssie, usie } <= { mie_in[3], mie_in[1:0] };
        end else begin
            { meie, seie, ueie } <= { meie, seie, ueie };
            { mtie, stie, utie } <= { mtie, stie, utie };
            { msie, ssie, usie } <= { msie, ssie, usie };
        end
    end

    assign mie = { 20'b0, meie, 1'b0, seie, ueie, mtie, 1'b0, stie, utie, msie, 1'b0, ssie, usie };

endmodule