module st_converter (
    input [31:0] in,
    input [2:0] funct3,
    output [31:0] out
);
    assign out = prep_st_data(in, funct3);

function [31:0] prep_st_data(input [31:0] raw_data, input [2:0] funct3);
        begin
            case (funct3)
                // SB
                // { 4{byte} }
                3'b000: prep_st_data = { 4{raw_data[7:0]} };
                
                // SH
                // { 2{half_word} }
                3'b001: prep_st_data = { 2{raw_data[15:0]} };

                // SW
                // { word }
                3'b010: prep_st_data = raw_data;

                // default: raw_data (does not perform any operation)
                default: prep_st_data = raw_data;
            endcase
        end
    endfunction
endmodule