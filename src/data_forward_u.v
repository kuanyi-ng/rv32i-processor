// might need to handle load instructions
// and instructions where they don't save C to x[rd]
// => Load, Jump
module data_forward_u (
    // Inputs from ID Stage (current cycle)
    input [4:0] rs1,
    input [4:0] rs2,

    // Inputs from EX Stage (current cycle)
    input wr_reg_n_in_ex,
    input [4:0] rd_in_ex,

    // Inputs form MEM Stage (current cycle)
    input wr_reg_n_in_mem,
    input [4:0] rd_in_mem,

    // Outputs to ID stage (current cycle)
    // 00: no forward, 01: forward rd_in_ex, 10: forward rd_in_mem
    output [1:0] forward_a,
    output [1:0] forward_b
);

    //
    // Main
    //
    assign forward_a = forward_ctrl(rs1, rd_in_ex, wr_reg_n_in_ex, rd_in_mem, wr_reg_n_in_mem);
    assign forward_b = forward_ctrl(rs2, rd_in_ex, wr_reg_n_in_ex, rd_in_mem, wr_reg_n_in_mem);

    //
    // Functions
    //
    function [1:0] forward_ctrl(input [4:0] rs, input [4:0] rd_in_ex, input wr_reg_n_ex, input [4:0] rd_in_mem, input wr_reg_n_in_mem);
        reg rs_updated_by_prev, rs_updated_by_prev_prev;

        begin
            rs_updated_by_prev = (!wr_reg_n_ex) && (rs == rd_in_ex);
            rs_updated_by_prev_prev = (!wr_reg_n_in_mem) && (rs == rd_in_mem);

            if ((!rs_updated_by_prev) && (!rs_updated_by_prev_prev)) begin
                // if data in x[rs] is not updated, don't forward
                forward_ctrl = 2'b00;
            end else if (rs_updated_by_prev) begin
                // x[rs] is updated by the instruciton in EX (previous instructions)
                // even if x[rs] is updated by the instruction in MEM (previous previous instructions)
                // the value updated by instruction in EX will be the latest value.
                // that's why we check rs_updated_by_prev first, then check rs_updated_by_prev_prev
                forward_ctrl = 2'b01;
            end else if (rs_updated_by_prev_prev) begin
                // x[rs] is updated by the instruction in MEM (previous previuos instructions)
                forward_ctrl = 2'b10;
            end else begin
                // NOTE: not sure what actually happen to got here
                forward_ctrl = 2'b00;
            end   
        end
    endfunction
    
endmodule