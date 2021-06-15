`include "constants/ir_type.v"
`include "constants/predictor_state.v"

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
    // state [33:32] | target_addr [31:0]
    // - state: state of 2-bit predictor for this entry
    // - target_addr: addr to jump to when state == take
    reg [33:0] entries[0:TABLE_SIZE-1];

    //
    // Read (Ansynchronous)
    //

    wire is_u_jump_ir_in_if = is_u_jump_ir_ctrl(ir_type_in_if);
    wire [NUM_BITS-1:0] read_entry_id = entry_id_ctrl(pc_in_if);

    reg temp_u_jump;
    reg [1:0] state;
    reg [31:0] target_addr, temp_addr_prediction;
    always @(*) begin
        { state, target_addr } = entries[read_entry_id];

        case (state)
            `STRONG_DONT_TAKE,
            `WEAK_DONT_TAKE: begin
                temp_u_jump = 1'b0;
                temp_addr_prediction = pc4_in_if;
            end

            `WEAK_TAKE,
            `STRONG_TAKE: begin
                temp_u_jump = 1'b1;
                temp_addr_prediction = target_addr;
            end

            default: begin
                temp_u_jump = 1'b0;
                temp_addr_prediction = pc4_in_if;
                entries[read_entry_id][33:32] = 2'b01;
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
    wire [1:0] next_state = next_state_ctrl(entries[write_entry_id][32], is_prediction_wrong);

    always @(negedge clk) begin
        if (update_entry) begin
            entries[write_entry_id] <= { next_state, jump_addr_if_taken };
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

    function [1:0] next_state_ctrl(input curr_state, input is_prediction_wrong);
        // 2-bits predictor
        begin
            case ({ curr_state, is_prediction_wrong })
                { `STRONG_DONT_TAKE, 1'b0 }: next_state_ctrl = `STRONG_DONT_TAKE;
                { `STRONG_DONT_TAKE, 1'b1 }: next_state_ctrl = `WEAK_DONT_TAKE;
                { `WEAK_DONT_TAKE, 1'b0 }: next_state_ctrl = `STRONG_DONT_TAKE;
                { `WEAK_DONT_TAKE, 1'b1 }: next_state_ctrl = `WEAK_TAKE;
                { `WEAK_TAKE, 1'b0 }: next_state_ctrl = `STRONG_TAKE;
                { `WEAK_TAKE, 1'b1 }: next_state_ctrl = `WEAK_DONT_TAKE;
                { `STRONG_TAKE, 1'b0 }: next_state_ctrl = `STRONG_TAKE;
                { `STRONG_TAKE, 1'b1 }: next_state_ctrl = `WEAK_TAKE;

                default: next_state_ctrl = `WEAK_DONT_TAKE;
            endcase
        end
    endfunction

endmodule
