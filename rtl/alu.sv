import typepkg::*;

module alu (
    input logic [31:0] operand_a,
    input logic [31:0] operand_b,
    input alu_op_t alu_op,
    output logic [31:0] result,
    output logic alu_zero,
    output logic alu_less,
    output logic alu_uless
);
    logic [31:0] temp_result;

    // icarus does not support constant selecting in always_comb,
    // so we have to use always @(*), and make sure all cases are covered.
    always @(*) begin
        case (alu_op)
            ALU_OP_ADD:     temp_result = operand_a + operand_b;
            ALU_OP_SUB:     temp_result = operand_a - operand_b;
            ALU_OP_AND:     temp_result = operand_a & operand_b;
            ALU_OP_OR:      temp_result = operand_a | operand_b;
            ALU_OP_XOR:     temp_result = operand_a ^ operand_b;
            ALU_OP_SLL:     temp_result = operand_a << operand_b[4:0];
            ALU_OP_SRL:     temp_result = operand_a >> operand_b[4:0];
            ALU_OP_SRA:     temp_result = $signed(operand_a) >>> operand_b[4:0];
            ALU_OP_SLT:     temp_result = $signed(operand_a) < $signed(operand_b) ? 1 : 0;
            ALU_OP_SLTU:    temp_result = operand_a < operand_b ? 1 : 0;
            ALU_OP_COPY_A:  temp_result = operand_a;
            ALU_OP_COPY_B:  temp_result = operand_b;
            default:        temp_result = 'x;
        endcase

        result = temp_result;

        alu_zero = (result == 32'b0);
        alu_less = $signed(operand_a) < $signed(operand_b);
        alu_uless = operand_a < operand_b;
    end
endmodule