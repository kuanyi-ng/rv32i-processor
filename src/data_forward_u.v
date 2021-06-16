`include "constants/ir_type.v"

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
    input [4:0] rs2_in_ex,
    input [4:0] rd_in_ex,
    input [3:0] ir_type_in_ex,

    // Inputs form MEM Stage (current cycle)
    input wr_reg_n_in_mem,
    input [4:0] rd_in_mem,
    input [3:0] ir_type_in_mem,

    // Outputs to ID stage (current cycle)
    // 00: no forward, 01: forward rd_in_ex, 10: forward rd_in_mem
    output [1:0] forward_data1,
    output [1:0] forward_data2,
    output forward_b
);

    //
    // Main
    //
    assign forward_data1 = forward_ctrl(rs1, rd_in_ex, wr_reg_n_in_ex, ir_type_in_ex, rd_in_mem, wr_reg_n_in_mem);
    assign forward_data2 = forward_ctrl(rs2, rd_in_ex, wr_reg_n_in_ex, ir_type_in_ex, rd_in_mem, wr_reg_n_in_mem);
    assign forward_b = forward_b_ctrl(rs2_in_ex, rd_in_mem, wr_reg_n_in_mem, ir_type_in_mem);

    //
    // Functions
    //
    function [1:0] forward_ctrl(
        input [4:0] rs,
        input [4:0] rd_in_ex,
        input wr_reg_n_in_ex,
        input [3:0] ir_type_in_ex,
        input [4:0] rd_in_mem,
        input wr_reg_n_in_mem
    );
        reg is_load_in_ex;
        reg rs_updated_by_prev, rs_updated_by_prev_prev;

        begin
            is_load_in_ex = (ir_type_in_ex == `LOAD_IR);
            rs_updated_by_prev = (!wr_reg_n_in_ex) && (rs == rd_in_ex) && (rs != 5'b00000);
            rs_updated_by_prev_prev = (!wr_reg_n_in_mem) && (rs == rd_in_mem) && (rs != 5'b00000);

            case ({ rs_updated_by_prev, rs_updated_by_prev_prev })
                // if data in x[rs] is not updated, don't forward
                2'b00: forward_ctrl = 2'b00;

                // x[rs] is updated by the instruction in MEM (previous previuos instructions)
                2'b01: forward_ctrl = 2'b10;

                // x[rs] is updated by the instruciton in EX (previous instructions)
                // even if x[rs] is updated by the instruction in MEM (previous previous instructions)
                // the value updated by instruction in EX will be the latest value.
                //
                // However, only forward data from EX stage if the instruction in EX stage
                // is not a load instruction as the data from load instruction wil
                // only be available in MEM stage
                2'b10,
                2'b11: forward_ctrl = (is_load_in_ex) ? 2'b00 : 2'b01;
            endcase
        end
    endfunction

    function forward_b_ctrl(input [4:0] rs2_in_ex, input [4:0] rd_in_mem, input wr_reg_n_in_mem, input [3:0] ir_type_in_mem);
        // Only forward d_mem from MEM stage to EX stage in the following situation
        //
        // lw   x8, 0x0(x16)    d_mem from MEM stage of this instruction
        // sw   x8, 0x4(x16)    forward to b_ex of EX stage of this instruction
        reg is_load_in_mem;
        reg rs2_updated_by_prev;

        begin
            is_load_in_mem = (ir_type_in_mem == `LOAD_IR);
            rs2_updated_by_prev = (!wr_reg_n_in_mem) && (rs2_in_ex == rd_in_mem) && (rs2_in_ex != 5'b00000);

            forward_b_ctrl = (rs2_updated_by_prev && is_load_in_mem);
        end
    endfunction
    
endmodule