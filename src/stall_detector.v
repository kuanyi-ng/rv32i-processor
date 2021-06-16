`include "constants/ir_type.v"

module stall_detector (
    // Inputs from ID Stage (current cycle)
    input [4:0] rs1,
    input [4:0] rs2,
    input [3:0] ir_type_in_id,

    // Inputs from EX Stage (current cycle)
    input wr_reg_n_in_ex,
    input [4:0] rd_in_ex,
    input [3:0] ir_type_in_ex,

    // Outputs
    output stall
);

    //
    // Main
    //
    assign stall = stall_ctrl(
        rs1,
        rs2,
        ir_type_in_id,
        wr_reg_n_in_ex,
        rd_in_ex,
        ir_type_in_ex
    );

    //
    // Functions
    //
    function stall_ctrl(
        input [4:0] rs1,
        input [4:0] rs2,
        input [3:0] ir_type_in_id,
        input wr_reg_n_in_ex,
        input [4:0] rd_in_ex,
        input [3:0] ir_type_in_ex
    );
        // stall pipeline when Load-Use situtation occurs.
        // e.g. 
        //      Load instruction
        //      instruction
        //
        // Data Forwarding can solve when it's Load-Store
        // (only when rs2 of store instruction is updated,
        // stalling is required for Store instruction is rs1 is updated by Load)
        // but not for the other case, so pipeline stall is needed.
        // 
        reg is_store_in_id, is_load_in_ex;
        reg rs1_updated, rs2_updated;

        begin
            is_store_in_id = (ir_type_in_id == `STORE_IR);
            is_load_in_ex = (ir_type_in_ex == `LOAD_IR);
            // register is updated if all the following are true
            // - it will be overwritten
            //   - wr_reg_n == 1'b0
            //   - rs == rd
            // - rs is not x0
            rs1_updated = (!wr_reg_n_in_ex) && (rs1 == rd_in_ex) && (rs1 != 5'b00000);
            rs2_updated = (!wr_reg_n_in_ex) && (rs2 == rd_in_ex) && (rs2 != 5'b00000);

            if ((!rs1_updated) && (!rs2_updated)) begin
                stall_ctrl = 1'b0;
            end else begin
                case ({ is_load_in_ex, is_store_in_id })
                    2'b11: begin
                        // latest value for rs2 (in EX stage) of Store instruction
                        // can be forwarded from MEM stage of Load instruction
                        //
                        // possible values of rs1_update, rs2_updated:
                        // (0, 0): don't stall (handled by previous case)
                        // (0, 1): don't stall
                        // (1, 0): stall
                        // (1, 1): stall
                        stall_ctrl = rs1_updated;
                    end

                    2'b10: stall_ctrl = rs1_updated || rs2_updated;

                    // don't need to stall if it's not load instruction in EX stage
                    // (probably) all cases can be handled by data forwarding.
                    default: stall_ctrl = 1'b0;
                endcase
            end
        end
    endfunction
endmodule