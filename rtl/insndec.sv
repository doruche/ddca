import typepkg::*;

module insndec (
    input logic [31:0] insn,
    output opcode_t opcode,
    output logic [2:0] funct3,
    output logic [6:0] funct7,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [4:0] rd
);
    assign opcode = opcode_t'(insn[6:0]);
    assign funct3 = insn[14:12];
    assign funct7 = insn[31:25];
    assign rs1 = insn[19:15];
    assign rs2 = insn[24:20];
    assign rd = insn[11:7];
endmodule