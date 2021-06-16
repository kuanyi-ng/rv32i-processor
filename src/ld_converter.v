`include "constants/funct3.v"

module ld_converter (
    input [31:0] in,    // data read from memory
    input [2:0] funct3,
    output [31:0] out
);

    //
    // Main
    //
    assign out = prep_ld_data(in, funct3);

    //
    // Functions
    //
    function [31:0] prep_ld_data(input [31:0] in, input [2:0] funct3);
        // data read from memory
        // - size: word => xxxx_xxxx
        // - size: half => 0000_xxxx
        // - size: byte => 0000_00xx
        begin
            case (funct3)
                // out: sext(xy) where xy is from { ab, cd, ef, gh }
                `LB_FUNCT3: prep_ld_data = ld_ext_b(in, 1'b1);

                // out: sext(wxyz) where wxyz is from { abcd, efgh }
                `LH_FUNCT3: prep_ld_data = ld_ext_h(in, 1'b1);

                // out: abcd_efgh
                `LW_FUNCT3: prep_ld_data = in;

                // out: ext(xy) where xy is from { ab, cd, ef, gh }
                `LBU_FUNCT3: prep_ld_data = ld_ext_b(in, 1'b0);

                // out: ext(wxyz) where wxyz is from { abcd, efgh }
                `LHU_FUNCT3: prep_ld_data = ld_ext_h(in, 1'b0);

                // default: in (doesn't perform any operations)
                default: prep_ld_data = in;
            endcase
        end
    endfunction

    function [31:0] ld_ext_b(input [31:0] in, input s_ext);
        reg [7:0] data;

        begin
            data = in[7:0];

            if (s_ext) ld_ext_b = { { 24{data[7]} }, data };
            else ld_ext_b = { 24'b0, data };
        end
    endfunction

    function [31:0] ld_ext_h(input [31:0] in, input s_ext);
        reg [15:0] data;

        begin
            data = in[15:0];

            if (s_ext) ld_ext_h = { { 16{data[15]} }, data };
            else ld_ext_h = { { 16'b0 }, data };
        end
    endfunction
endmodule
