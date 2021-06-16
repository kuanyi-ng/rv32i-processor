`include "../src/u_jump_predictor.v"
`include "../src/constants/ir_type.v"

module test_u_jump_predictor ();
    reg clk;

    reg [2:0] shorten_pc_in_if;
    wire [31:0] pc_in_if = { 29'b0, shorten_pc_in_if };
    reg [3:0] ir_type_in_if;
    
    reg [2:0] shorten_pc_in_ex;
    wire [31:0] pc_in_ex = { 29'b0, shorten_pc_in_ex };
    reg [3:0] ir_type_in_ex;
    reg [31:0] jump_addr_if_taken;
    reg predicted_jump;
    reg jump_result;
    
    wire u_jump;
    wire [31:0] prediction_addr;

    // use a smaller table for testing

    u_jump_predictor #(
        .TABLE_SIZE(8)
    ) subject(
        .clk(clk),
        .pc_in_if(pc_in_if),
        .ir_type_in_if(ir_type_in_if),
        .pc_in_ex(pc_in_ex),
        .ir_type_in_ex(ir_type_in_ex),
        .jump_addr_if_taken(jump_addr_if_taken),
        .predicted_jump(predicted_jump),
        .jump_result(jump_result),
        .u_jump(u_jump),
        .prediction_addr(prediction_addr)
    );

    // clock generation
    always begin
        clk = 1'b1;
        #5 clk = 1'b0;
        #5;
    end

    initial begin
        // 1st access
        // predict not taken (wrong)
        shorten_pc_in_if = 3'b100;
        ir_type_in_if = `JAL_IR;
        #10
        // later updated by EX stage
        shorten_pc_in_if = 3'b000;
        ir_type_in_if = `JAL_IR;
        shorten_pc_in_ex = 3'b100;
        ir_type_in_ex = `JAL_IR;
        jump_addr_if_taken = 32'ha;
        predicted_jump = 1'b0;
        jump_result = 1'b1;
        #10

        // 2nd access
        // predict taken (correct)
        shorten_pc_in_if = 3'b100;
        ir_type_in_if = `JALR_IR;
        #10
        // not updated by EX stage
        shorten_pc_in_if = 3'b000;
        ir_type_in_if = `JALR_IR;
        shorten_pc_in_ex = 3'b100;
        ir_type_in_ex = `JALR_IR;
        jump_addr_if_taken = 32'hb;
        predicted_jump = 1'b1;
        jump_result = 1'b1;
        #10

        // 3rd access
        // predict taken (wrong)
        shorten_pc_in_if = 3'b100;
        ir_type_in_if = `JAL_IR;
        #10
        // later updated by EX stage
        shorten_pc_in_if = 3'b000;
        ir_type_in_if = `JAL_IR;
        shorten_pc_in_ex = 3'b100;
        ir_type_in_ex = `JAL_IR;
        jump_addr_if_taken = 32'hc;
        predicted_jump = 1'b1;
        jump_result = 1'b0;
        #10

        // 4th access
        // predict taken (correct)
        shorten_pc_in_if = 3'b100;
        ir_type_in_if = `JALR_IR;
        #10
        // later updated by EX stage
        shorten_pc_in_if = 3'b000;
        ir_type_in_if = `JALR_IR;
        shorten_pc_in_ex = 3'b100;
        ir_type_in_ex = `JALR_IR;
        jump_addr_if_taken = 32'hd;
        predicted_jump = 1'b0;
        jump_result = 1'b0;
        #10

        $finish;
    end

    initial begin
        $monitor(
            "t: %d,\npc_in_if: %h,\nir_type_in_if: %h,\npc_in_ex: %h,\ir_type_in_ex: %h,\njump_addr_if_taken: %h,\npredicted_jump: %b,\njump_result: %b,u_jump: %b,\nprediction_addr: %h\n",
            $time,
            pc_in_if,
            ir_type_in_if,
            pc_in_ex,
            ir_type_in_ex,
            jump_addr_if_taken,
            predicted_jump,
            jump_result,
            u_jump,
            prediction_addr
        );
    end

endmodule
