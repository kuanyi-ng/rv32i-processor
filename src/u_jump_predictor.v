`include "constants/ir_type.v"

// Unconditional Jump Predictor
//
// Table (Memory) are
// Ansynchronous Read, Synchronous Write
module u_jump_predictor #(
    // NOTE:
    // keep TABLE_SIZE <= 4096
    // TABLE_SIZE = 2 ^ NUM_BITS
    parameter TABLE_SIZE = 32,
    parameter NUM_BITS = 5
) (
    input clk,

    // Inputs from IF Stage
    // - used for read operation
    input [31:0] pc_in_if,
    input [31:0] pc4_in_if,
    input [3:0] ir_type_in_if,

    // Inputs from EX Stage
    // - used for write operation
    input [31:0] pc_in_ex,
    input [3:0] ir_type_in_ex,
    input [31:0] jump_addr_if_taken,    // c_ex
    input is_prediction_wrong,

    // Output to IF Stage
    output u_jump,
    output [31:0] addr_prediction
);

    // Entries of table
    // Identifier of entries in table:
    // - to differentiate instructions
    //   - pc[NUM_BITS+1:2] ( 2^(NUM_BITS-1) entries each mode)
    //
    // What to store?
    // init [33] | state [32] | target_addr [31:0]
    // - init: whether target_addr's value is available or not
    // - state: state of 1-bit predictor for this entry
    //   - take: 1, don't take: 0
    // - target_addr: addr to jump to when state == take
    reg [33:0] entries[0:TABLE_SIZE-1];

    //
    // Read (Ansynchronous)
    //

    wire is_u_jump_ir_in_if = is_u_jump_ir_ctrl(ir_type_in_if);
    wire [NUM_BITS-1:0] read_entry_id = entry_id_ctrl(pc_in_if);

    reg init, state, temp_u_jump;
    reg [31:0] target_addr, temp_addr_prediction;
    always @(*) begin
        { init, state, target_addr } = entries[read_entry_id];

        // init | state | u_jump
        // 0    | 0     | 0
        // 0    | 1     | 0 (not init yet)
        // 1    | 0     | 0
        // 1    | 1     | 1
        case ({ init, state })
            2'b00,
            2'b01: begin
                temp_u_jump = 1'b0;
                temp_addr_prediction = pc4_in_if; // maybe change this to pc4
            end
            2'b10: begin
                temp_u_jump = 1'b0;
                temp_addr_prediction = pc4_in_if;
            end
            2'b11: begin
                temp_u_jump = 1'b1;
                temp_addr_prediction = target_addr;
            end

            // default added to handle cases where
            // either init / state is 1'bx
            default: begin
                temp_u_jump = 1'b0;
                temp_addr_prediction = pc4_in_if;
                // default to { not_init, not_take }
                entries[read_entry_id][33:32] = { 1'b0, 1'b0 };
            end
        endcase
    end
    assign u_jump = (is_u_jump_ir_in_if) ? temp_u_jump : 1'b0;
    assign addr_prediction = (is_u_jump_ir_in_if) ? temp_addr_prediction : pc4_in_if;

    //
    // Write (Synchronous)
    //

    wire is_u_jump_ir_in_ex = is_u_jump_ir_ctrl(ir_type_in_ex);
    wire [NUM_BITS-1:0] write_entry_id = entry_id_ctrl(pc_in_ex);
    wire update_entry = is_u_jump_ir_in_ex && is_prediction_wrong;
    wire next_state = next_state_ctrl(entries[write_entry_id][32], is_prediction_wrong);

    always @(negedge clk) begin
        if (update_entry) begin
            // update init to 1
            // update state to jump_result (1-bit predictor)
            // update target_addr to jump_addr_if_taken
            entries[write_entry_id] <= { 1'b1, next_state, jump_addr_if_taken };
        end else begin
            entries[write_entry_id] <= entries[write_entry_id];
        end
    end

    //
    // Function
    //

    function is_u_jump_ir_ctrl(input [3:0] ir_type);
        begin
            is_u_jump_ir_ctrl = (ir_type == `JAL_IR) || (ir_type == `JALR_IR) || (ir_type == `BRANCH_IR);
        end
    endfunction

    function [NUM_BITS-1:0] entry_id_ctrl(input [31:0] pc);
        begin
            // Differentiating between user and machine instruction doesn't help much
            // when most of the instructions are user-level.
            // Differentiating between them will make the prediction table usage down to 50%.
            entry_id_ctrl = pc[NUM_BITS+1:2];
        end
    endfunction

    function next_state_ctrl(input curr_state, input is_prediction_wrong);
        // 1-bit predictor
        begin
            // curr_state   | is_prediction_wrong   | next_state
            // 0            | 0                     | 0
            // 0            | 1                     | 1
            // 1            | 0                     | 1
            // 1            | 1                     | 0
            next_state_ctrl = (is_prediction_wrong) ? ~curr_state : curr_state;
        end
    endfunction

endmodule
