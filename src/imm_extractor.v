module imm_extractor (
    input [31:0] in,
    input [2:0] imm_type,
    output reg [31:0] out
);

    always @(in or imm_type) begin
        case (imm_type)
            // I-Type
            3'b000: out <= i_imm(in);

            // B-Type
            3'b001: out <= b_imm(in);

            // S-Type
            // 3'b010: 

            // U-Type
            // 3'b011: 

            // J-Type
            // 3'b100: 

            // default: 0
            default: out <= 32'd0;
        endcase
    end

    // I_imm <= sext(IR[31:20])
    function [31:0] i_imm(input [31:0] in);
        reg [11:0] imm;

        begin
            imm = in[31:20];
            i_imm = { { 20{imm[11]} }, imm }; // sign extend
        end
    endfunction

    // B_imm <= sext({ IR[31], IR[7], IR[30:25], IR[11:8], 0 })
    function [31:0] b_imm(input [31:0] in);
        reg [12:0] imm;

        begin
            imm = { in[31], in[7], in[30:25], in[11:8], 1'b0 };
            b_imm = { { 19{imm[12]} }, imm }; // sign extend
        end
    endfunction
endmodule
