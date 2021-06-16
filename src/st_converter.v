`include "constants/funct3.v"

module st_converter (
    input [31:0] in,
    input [2:0] funct3,
    output [31:0] out
);
    assign out = prep_st_data(in, funct3);

function [31:0] prep_st_data(input [31:0] raw_data, input [2:0] funct3);
        begin
            case (funct3)
                // { 4{byte} }
                `SB_FUNCT3: prep_st_data = { 4{raw_data[7:0]} };
                
                // { 2{half_word} }
                `SH_FUNCT3: prep_st_data = { 2{raw_data[15:0]} };

                // { word }
                `SW_FUNCT3: prep_st_data = raw_data;

                // default: raw_data (does not perform any operation)
                default: prep_st_data = raw_data;
            endcase
        end
    endfunction
endmodule