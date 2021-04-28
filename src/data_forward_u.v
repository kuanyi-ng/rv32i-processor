// Don't need to care about the instruction executing in ID stage
// as all it cares is getting the latest value from registers.
//
// Need to be careful with the type of instructions currently
// executing in EX stage and MEM stage.
// Different type of instructions update the registers' values differently.
//
// LUI      : x[rd] <- C (E)
// AUIPC    : x[rd] <- C (E)
// I-type   : x[rd] <- C (E)
// R-type   : x[rd] <- C (E)
// Load     : x[rd] <- D (M)
// Store    : doesn't update
// JAL      : x[rd] <- PC + 4 (F)
// JALR     : x[rd] <- PC + 4 (F)
// Branch   : doesn't update
//
// Don't forward if rs1 or rs2 is x0
//
// Forwarding value from EX stage when Load instruction is executing in  EX stage
// will be fine as the value will not be used because
// pipieline stall will happen at the same time (triggered by another module)
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