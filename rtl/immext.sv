import typepkg::*;

module immext (
    input logic [31:0] insn,
    output logic [31:0] imm
);
    always @(*) begin
        case (insn[6:0])
            OPCODE_LOAD,
            OPCODE_OP_IMM,
            OPCODE_JALR:
                imm = {{20{insn[31]}}, insn[31:20]}; // I-type
            OPCODE_AUIPC,
            OPCODE_LUI:
                imm = {insn[31:12], 12'b0}; // U-type
            OPCODE_STORE:
                imm = {{20{insn[31]}}, insn[31:25], insn[11:7]}; // S-type
            OPCODE_BRANCH:
                imm = {{20{insn[31]}}, insn[7], insn[30:25], insn[11:8], 1'b0}; // B-type
            OPCODE_JAL: begin
                imm = {{12{insn[31]}}, insn[19:12], insn[20], insn[30:21], 1'b0}; // J-type
            end
            default: imm = 32'b0;
        endcase
    end
endmodule