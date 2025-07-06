`include "rtl/ctrl.sv"
`include "rtl/insndec.sv"
import typepkg::*;

module ctrl_tb;
    logic [31:0] insn;
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic alu_zero;
    logic alu_less;
    logic alu_uless;

    pc_src_t pc_src;
    alu_src_a_t alu_src_a;
    alu_src_b_t alu_src_b;
    alu_op_t alu_op;
    logic reg_write;
    reg_wb_src_t reg_wb_src;
    mem_write_t mem_write;
    mem_read_t mem_read;

    insndec u_insndec (
        .insn(insn),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7)
    );

    ctrl u_ctrl (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .alu_zero(alu_zero),
        .alu_less(alu_less),
        .alu_uless(alu_uless),
        .pc_src(pc_src),
        .alu_src_a(alu_src_a),
        .alu_src_b(alu_src_b),
        .alu_op(alu_op),
        .reg_write(reg_write),
        .reg_wb_src(reg_wb_src),
        .mem_write(mem_write),
        .mem_read(mem_read)
    );

    initial begin
        insn = 32'h14d28393; // addi x7, x5, 333
        #10;
        assert(pc_src == PC_SRC_PC4);
        assert(alu_src_a == ALU_SRC_A_RS1);
        assert(alu_src_b == ALU_SRC_B_IMM);
        assert(alu_op == ALU_OP_ADD);
        assert(reg_write == 1'b1);
        assert(reg_wb_src == REG_WB_SRC_ALU);
        assert(mem_write == MEM_WRITE_NONE);
        assert(mem_read == MEM_READ_NONE);

        insn = 32'hfd634f93; // xori x31, x6, -42
        #10;
        assert(pc_src == PC_SRC_PC4);
        assert(alu_src_a == ALU_SRC_A_RS1);
        assert(alu_src_b == ALU_SRC_B_IMM);
        assert(alu_op == ALU_OP_XOR);
        assert(reg_write == 1'b1);
        assert(reg_wb_src == REG_WB_SRC_ALU);
        assert(mem_write == MEM_WRITE_NONE);
        assert(mem_read == MEM_READ_NONE);

        insn = 32'h00309497; // auipc x9, 777
        #10;
        assert(pc_src == PC_SRC_PC4);
        assert(alu_src_a == ALU_SRC_A_PC);
        assert(alu_src_b == ALU_SRC_B_IMM);
        assert(alu_op == ALU_OP_ADD);
        assert(reg_write == 1'b1);
        assert(reg_wb_src == REG_WB_SRC_ALU);
        assert(mem_write == MEM_WRITE_NONE);
        assert(mem_read == MEM_READ_NONE);

        insn = 32'hff806237; // lui x4, -2042
        #10;
        assert(pc_src == PC_SRC_PC4);
        assert(alu_src_b == ALU_SRC_B_IMM);
        assert(alu_op == ALU_OP_COPY_B);
        assert(reg_write == 1'b1);
        assert(reg_wb_src == REG_WB_SRC_ALU);
        assert(mem_write == MEM_WRITE_NONE);
        assert(mem_read == MEM_READ_NONE);

        insn = 32'h14a0a0a3; // sw x10, 321(x1)
        #10;
        assert(pc_src == PC_SRC_PC4);
        assert(alu_src_a == ALU_SRC_A_RS1);
        assert(alu_src_b == ALU_SRC_B_IMM);
        assert(alu_op == ALU_OP_ADD);
        assert(reg_write == 1'b0);
        assert(reg_wb_src == REG_WB_SRC_ALU);
        assert(mem_write == MEM_WRITE_WORD);
        assert(mem_read == MEM_READ_NONE);

        // here we have no way to test branch instructions without a full ALU

        insn = 32'h084003ef; // jal x7, 132
        #10;
        assert(pc_src == PC_SRC_ALU);
        assert(alu_src_a == ALU_SRC_A_PC);
        assert(alu_src_b == ALU_SRC_B_IMM);
        assert(alu_op == ALU_OP_ADD);
        assert(reg_write == 1'b1);
        assert(reg_wb_src == REG_WB_SRC_PC4);
        assert(mem_write == MEM_WRITE_NONE);
        assert(mem_read == MEM_READ_NONE);

        $finish;
    end

    initial begin
        $monitor("\tTime: %0t,\n\tinsn: %h, opcode: %b, funct3: %b, funct7: %b, \n\tpc_src: %0d, alu_src_a: %0d, alu_src_b: %0d, alu_op: %0d, \n\treg_write: %b, reg_wb_src: %0d, mem_write: %0d, mem_read: %0d",
                 $time, insn, opcode, funct3, funct7,
                 pc_src, alu_src_a, alu_src_b, alu_op,
                 reg_write, reg_wb_src, mem_write, mem_read);
    end


endmodule