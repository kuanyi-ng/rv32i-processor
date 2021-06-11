`include "constants/opcode.v"
`include "constants/ir_type.v"
`include "constants/funct3.v"

// convert opcode (7bits) into ir_type (4bits)
module ir_type_converter (
	input [6:0] opcode,
	input [2:0] funct3,

	output [3:0] ir_type
);

	assign ir_type = ir_type_ctrl(opcode, funct3);

	function [3:0] ir_type_ctrl(input [6:0] opcode, input [2:0] funct3);
		case (opcode)
			`LUI_OP: ir_type_ctrl = `LUI_IR;

			`AUIPC_OP: ir_type_ctrl = `AUIPC_IR;

			`JAL_OP: ir_type_ctrl = `JAL_IR;

			`JALR_OP: ir_type_ctrl = `JALR_IR;

			`BRANCH_OP: ir_type_ctrl = `BRANCH_IR;

			`LOAD_OP: ir_type_ctrl = `LOAD_IR;

			`STORE_OP: ir_type_ctrl = `STORE_IR;

			`I_TYPE_OP: ir_type_ctrl = `REG_IMM_IR;

			`R_TYPE_OP: ir_type_ctrl = `REG_REG_IR;

			`SYSTEM_OP: begin
				if (funct3 == `SYS_CALL_FUNCT3) ir_type_ctrl = `SYS_CALL_IR;
				else ir_type_ctrl = `CSR_IR;
			end

			default: ir_type_ctrl = `X_IR;
		endcase
	endfunction

endmodule
