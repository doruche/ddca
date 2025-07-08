`ifndef TYPE_PKG
`define TYPE_PKG

package typepkg;

    typedef enum logic [3:0] {
        ALU_OP_ADD = 4'b0000,
        ALU_OP_SUB = 4'b0001,
        ALU_OP_AND = 4'b0010,
        ALU_OP_OR  = 4'b0011,
        ALU_OP_XOR = 4'b0100,
        ALU_OP_SLL = 4'b0101,
        ALU_OP_SRL = 4'b0110,
        ALU_OP_SRA = 4'b0111,
        ALU_OP_SLT = 4'b1000,
        ALU_OP_SLTU = 4'b1001,
        ALU_OP_COPY_A = 4'b1010, 
        ALU_OP_COPY_B = 4'b1011
    } alu_op_t;

    typedef enum logic [6:0] {
        OPCODE_LOAD     = 7'b0000011,
        OPCODE_OP_IMM   = 7'b0010011,
        OPCODE_AUIPC    = 7'b0010111,
        OPCODE_STORE    = 7'b0100011,
        OPCODE_OP       = 7'b0110011,
        OPCODE_LUI      = 7'b0110111,
        OPCODE_BRANCH   = 7'b1100011,
        OPCODE_JALR     = 7'b1100111,
        OPCODE_JAL      = 7'b1101111,
        OPCODE_FENCEI   = 7'b0001111,
        OPCODE_SYSTEM   = 7'b1110011
    } opcode_t;

    typedef enum logic  {
        ALU_SRC_A_RS1 = 1'b0,
        ALU_SRC_A_PC = 1'b1
    } alu_src_a_t;

    typedef enum logic {
        ALU_SRC_B_RS2 = 1'b0,
        ALU_SRC_B_IMM = 1'b1
    } alu_src_b_t;

    // regfiles write back source
    typedef enum logic [1:0] {
        REG_WB_SRC_ALU = 2'b00,
        REG_WB_SRC_MEM = 2'b01,
        REG_WB_SRC_PC4 = 2'b10 // for JAL and JALR
    } reg_wb_src_t;

    typedef enum logic [1:0] {
        PC_SRC_PC4 = 2'b00,
        PC_SRC_ALU = 2'b01,
        // We have to add another circuit to calculate BTA,
        // as the ALU is already used to indicate whether the branch can be taken.
        PC_SRC_BRA = 2'b10
    } pc_src_t;

    typedef enum logic [1:0] {
        MEM_WRITE_NONE = 2'b00,
        MEM_WRITE_BYTE = 2'b01,
        MEM_WRITE_HALF = 2'b10,
        MEM_WRITE_WORD = 2'b11
    } mem_write_t;

    typedef enum logic [1:0] {
        NONE = 2'b00,
        BYTE = 2'b01,
        HALF = 2'b10,
        WORD = 2'b11
    } mem_width_t;

    typedef struct packed {
        mem_width_t width;
        logic is_signed;
    } mem_fmt_t;

    typedef enum logic [2:0] {
        MEM_READ_NONE = 3'b000,
        MEM_READ_BYTE = 3'b001,
        MEM_READ_HALF = 3'b010,
        MEM_READ_WORD = 3'b011,
        MEM_READ_BYTE_U = 3'b100,
        MEM_READ_HALF_U = 3'b101
    } mem_read_t;

    typedef struct packed {
        logic [31:0] pc;
        logic [31:0] insn;
    } if_id_reg_t;

    typedef struct packed {
        logic [31:0] pc;
        logic [31:0] rd1;
        logic [31:0] rd2;
        logic [31:0] imm;
        logic [4:0] ra1;
        logic [4:0] ra2;
        logic [4:0] wa3;
        opcode_t opcode;
        logic [2:0] funct3;
        logic [6:0] funct7;

        alu_src_a_t alu_src_a;
        alu_src_b_t alu_src_b;
        alu_op_t alu_op;
        logic reg_write_en;
        reg_wb_src_t reg_wb_src;
        mem_write_t mem_write;
        mem_read_t mem_read;
        logic is_branch;
        logic is_jump;
    } id_ex_reg_t;

    typedef struct packed {
        logic [31:0] pc;
        logic [31:0] alu_res; // store addr or data to write into regfile
        logic [31:0] rd2;
        logic [4:0] wa3;

        logic reg_write_en;
        reg_wb_src_t reg_wb_src;
        mem_write_t mem_write;
        mem_read_t mem_read;
    } ex_mem_reg_t;

    typedef struct packed {
        logic [31:0] pc;
        logic [31:0] alu_res; // store addr or data to write into regfile
        logic [31:0] mem_rdata; // data read from memory
        logic [4:0] wa3;

        logic reg_write_en;
        reg_wb_src_t reg_wb_src;
        mem_write_t mem_write;
        mem_read_t mem_read;
    } mem_wb_reg_t;

    localparam BAD_VAL = 32'hdead_beef;

    localparam PC_RST_VAL = 32'h0000_0000;

    // [BASE, END)
    localparam ROM_BASE_ADDR = 32'h0000_0000;
    localparam ROM_SIZE = 32'h0000_1000;
    localparam ROM_END_ADDR = ROM_BASE_ADDR + ROM_SIZE;
    localparam ROM_BITS = 12;
    localparam RAM_BASE_ADDR = ROM_BASE_ADDR + ROM_SIZE;
    localparam RAM_SIZE = 32'h0000_2000;
    localparam RAM_END_ADDR = RAM_BASE_ADDR + RAM_SIZE;
    localparam RAM_BITS = 13;

    localparam FUNCT3_LB = 3'b000;
    localparam FUNCT3_LH = 3'b001;
    localparam FUNCT3_LW = 3'b010;
    localparam FUNCT3_LBU = 3'b100;
    localparam FUNCT3_LHU = 3'b101;

    localparam FUNCT3_ADDI = 3'b000;
    localparam FUNCT3_SLLI = 3'b001;
    localparam FUNCT3_SLTI = 3'b010;
    localparam FUNCT3_SLTIU = 3'b011;
    localparam FUNCT3_XORI = 3'b100;
    localparam FUNCT3_SRLAI = 3'b101;
    localparam FUNCT3_ORI = 3'b110;
    localparam FUNCT3_ANDI = 3'b111;

    localparam FUNCT3_SB = 3'b000;
    localparam FUNCT3_SH = 3'b001;
    localparam FUNCT3_SW = 3'b010;

    localparam FUNCT3_ADDSUB = 3'b000;
    localparam FUNCT3_SLL = 3'b001;
    localparam FUNCT3_SLT = 3'b010;
    localparam FUNCT3_SLTU = 3'b011;
    localparam FUNCT3_XOR = 3'b100;
    localparam FUNCT3_SRLA = 3'b101;
    localparam FUNCT3_OR = 3'b110;
    localparam FUNCT3_AND = 3'b111;

    localparam FUNCT3_BEQ = 3'b000;
    localparam FUNCT3_BNE = 3'b001;
    localparam FUNCT3_BLT = 3'b100;
    localparam FUNCT3_BGE = 3'b101;
    localparam FUNCT3_BLTU = 3'b110;
    localparam FUNCT3_BGEU = 3'b111;

    localparam FUNCT3_JALR = 3'b000;


    localparam FUNCT7_SLLI = 7'b0000000;
    localparam FUNCT7_SRLI = 7'b0000000;
    localparam FUNCT7_SRAI = 7'b0100000;
    localparam FUNCT7_ADD = 7'b0000000;
    localparam FUNCT7_SUB = 7'b0100000;
    localparam FUNCT7_SLL = 7'b0000000;
    localparam FUNCT7_SLT = 7'b0000000;
    localparam FUNCT7_SLTU = 7'b0000000;
    localparam FUNCT7_XOR = 7'b0000000;
    localparam FUNCT7_SRL = 7'b0000000;
    localparam FUNCT7_SRA = 7'b0100000;
    localparam FUNCT7_OR = 7'b0000000;
    localparam FUNCT7_AND = 7'b0000000;

    localparam INSN_NO_OP = 32'h00000013; // addi x0, x0, 0

endpackage

`endif