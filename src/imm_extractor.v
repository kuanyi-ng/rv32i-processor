module imm_extractor (
    input [31:0] in,
    input [2:0] imm_type,
    output [31:0] out
);

    assign out = imm(in, imm_type);

    function [31:0] imm(input [31:0] in, input [2:0] imm_type);
       begin
        case (imm_type)
            // I-Type (include jalr)
            3'b000: imm = i_imm(in);

            // B-Type
            3'b001: imm = b_imm(in);

            // S-Type
            3'b010: imm = s_imm(in);

            // U-Type
            3'b011: imm = u_imm(in);

            // J-Type (doesn't include jalr)
            3'b100: imm = j_imm(in);

            // shamt_imm
            // NOTE: maybe can pass it on as it is
            // imm = in;
            // as the lower 5 bits will be extracted within alu
            3'b101: imm = shamt_imm(in);

            // default: 0
            default: imm = 32'd0;
        endcase
       end
    endfunction

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
        reg [11:0] imm;

        begin
            imm = { in[31], in[7], in[30:25], in[11:8] };
            b_imm = { { 19{imm[11]} }, imm, 1'b0 }; // sign extend
        end
    endfunction

    // S_imm <= sext({ IR[31:25], IR[11:7] })
    function [31:0] s_imm(input [31:0] in);
        reg [11:0] imm;

        begin
            imm = { in[31:25], in[11:7] };
            s_imm = { { 20{imm[11]} }, imm }; // sign extend
        end
    endfunction

    // U_imm <= sext(IR[31:12] << 12)
    function [31:0] u_imm(input [31:0] in);
        begin
            u_imm = in[31:12] << 4'd12;
        end
    endfunction

    // J_imm <= sext({ IR[31], IR[19:12], IR[20], IR[30:21], 0 })
    function [31:0] j_imm(input [31:0] in);
        reg [19:0] imm;

        begin
            imm = { in[31], in[19:12], in[20], in[30:21] };
            j_imm = { { 11{imm[19]} }, imm, 1'b0 };
        end
    endfunction

    // shamt_imm <= ext({ IR[24:20] })
    function [31:0] shamt_imm(input [31:0] in);
        begin
            shamt_imm = { 27'd0, in[24:20] };
        end
    endfunction
endmodule
