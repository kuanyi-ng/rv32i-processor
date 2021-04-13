module ld_converter (
    input [31:0] in, // data read from memory
    input [1:0] offset, // addr[1:0]
    input [2:0] format, // ir[14:12]: funct3
    output reg [31:0] out
);
    always @(in or offset or format) begin
        // in: abcd_efgh
        case (format)
            // LB
            // out: sext(xy) where xy is from { ab, cd, ef, gh }
            3'b000: out <= ld_ext_b(in, offset, 1'b1);

            // LH
            // out: sext(wxyz) where wxyz is from { abcd, efgh }
            3'b001: out <= ld_ext_h(in, offset, 1'b1);

            // LW
            // out: abcd_efgh
            3'b010: out <= in;

            // LBU
            // out: ext(xy) where xy is from { ab, cd, ef, gh }
            3'b100: out <= ld_ext_b(in, offset, 1'b0);

            // LHU
            // out: ext(wxyz) where wxyz is from { abcd, efgh }
            3'b101: out <= ld_ext_h(in, offset, 1'b0);

            // default: in (doesn't perform any operations)
            default: out <= in;
        endcase
    end

    function [31:0] ld_ext_b(input [31:0] in, input [1:0] offset, input s_ext);
        reg [7:0] data;

        begin
            // extract one byte of data from in
            case (offset)
                2'b00: data = in[7:0];
                2'b01: data = in[15:8];
                2'b10: data = in[23:16];
                2'b11: data = in[31:24];
                // doesn't require default as every case is covered.
            endcase

            // extend extracted data to 32 bits
            ld_ext_b = (s_ext == 1'b1) ? { { 24{data[7]} }, data } : { 24'b0, data };
        end
    endfunction

    function [31:0] ld_ext_h(input [31:0] in, input [1:0] offset, input s_ext);
        reg [15:0] data;

        begin
            // extract half word of data from in
            case (offset)
                2'b00: data = in[15:0];
                2'b10: data = in[31:16];
                // default: in[15:0] for the moment (TODO)
                default: data = in[15:0];
            endcase
            
            // extend extracted data to 32 bits
            ld_ext_h = (s_ext == 1'b1) ? { { 16{data[15]} }, data } : { 16'b0, data };
        end
    endfunction
endmodule