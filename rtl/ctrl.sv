import typepkg::*;

module ctrl (
    input opcode_t id_opcode,
    input logic [2:0] id_funct3,
    input logic id_funct7_bit5,
    input logic [4:0] id_ra1,
    input logic [4:0] id_ra2,
    input logic [4:0] id_wa3,

    output alu_src_a_t id_alu_src_a,
    output alu_src_b_t id_alu_src_b,
    output alu_op_t id_alu_op,
    output logic id_reg_write_en,
    output reg_wb_src_t id_reg_wb_src,
    output mem_write_t id_mem_write,
    output mem_read_t id_mem_read,
    output logic id_is_branch,
    output logic id_is_jump,

    input logic ex_alu_zero,
    input logic ex_alu_less,
    input logic ex_alu_uless,
    input logic ex_is_branch,
    input logic [2:0] ex_branch_funct3,
    input logic ex_is_jump,
    input logic ex_is_load,
    output pc_src_t ex_pc_src,

    output logic should_stall,
    output logic should_flush
);
    always_comb begin : ID
        id_alu_src_a = ALU_SRC_A_RS1;
        id_alu_src_b = ALU_SRC_B_RS2;
        id_alu_op = ALU_OP_ADD;
        id_reg_write_en = 1'b0;
        id_reg_wb_src = REG_WB_SRC_ALU;
        id_mem_write = MEM_WRITE_NONE;
        id_mem_read = MEM_READ_NONE;
        id_is_branch = 1'b0;
        id_is_jump = 1'b0;

        case (id_opcode)
            OPCODE_LOAD: begin
                id_alu_src_b = ALU_SRC_B_IMM;
                id_reg_write_en = 1'b1;
                id_reg_wb_src = REG_WB_SRC_MEM;
                case (id_funct3)
                    FUNCT3_LB: id_mem_read = MEM_READ_BYTE;
                    FUNCT3_LH: id_mem_read = MEM_READ_HALF;
                    FUNCT3_LW: id_mem_read = MEM_READ_WORD;
                    FUNCT3_LBU: id_mem_read = MEM_READ_BYTE_U;
                    FUNCT3_LHU: id_mem_read = MEM_READ_HALF_U; 
                    default: id_mem_read = MEM_READ_NONE;
                endcase
            end
            OPCODE_OP_IMM: begin
                id_alu_src_b = ALU_SRC_B_IMM;
                id_reg_write_en = 1'b1;
                case (id_funct3)
                    FUNCT3_ADDI:    id_alu_op = ALU_OP_ADD;
                    FUNCT3_SLLI:    id_alu_op = ALU_OP_SLL;
                    FUNCT3_SLTI:    id_alu_op = ALU_OP_SLT;
                    FUNCT3_SLTIU:   id_alu_op = ALU_OP_SLTU;
                    FUNCT3_XORI:    id_alu_op = ALU_OP_XOR;
                    FUNCT3_SRLAI:
                        if (id_funct7_bit5)
                            id_alu_op = ALU_OP_SRA;
                        else
                            id_alu_op = ALU_OP_SRL; 
                    FUNCT3_ORI:     id_alu_op = ALU_OP_OR;
                    FUNCT3_ANDI:    id_alu_op = ALU_OP_AND;
                endcase
            end
            OPCODE_AUIPC: begin
                id_alu_src_a = ALU_SRC_A_PC;
                id_alu_src_b = ALU_SRC_B_IMM;
                id_reg_write_en = 1'b1;
            end
            OPCODE_STORE: begin
                id_alu_src_b = ALU_SRC_B_IMM;
                case (id_funct3)
                    FUNCT3_SB:  id_mem_write = MEM_WRITE_BYTE;
                    FUNCT3_SH:  id_mem_write = MEM_WRITE_HALF;
                    FUNCT3_SW:  id_mem_write = MEM_WRITE_WORD; 
                endcase
            end
            OPCODE_OP: begin
                id_reg_write_en = 1'b1;
                case (id_funct3)
                    FUNCT3_ADDSUB: 
                        if (id_funct7_bit5)
                            id_alu_op = ALU_OP_SUB;
                        else
                            id_alu_op = ALU_OP_ADD; 
                    FUNCT3_SLL:     id_alu_op = ALU_OP_SLL;
                    FUNCT3_SLT:     id_alu_op = ALU_OP_SLT;
                    FUNCT3_SLTU:    id_alu_op = ALU_OP_SLTU;
                    FUNCT3_XOR:     id_alu_op = ALU_OP_XOR;
                    FUNCT3_SRLA: 
                        if (id_funct7_bit5)
                            id_alu_op = ALU_OP_SRA;
                        else
                            id_alu_op = ALU_OP_SRL;
                    FUNCT3_OR:      id_alu_op = ALU_OP_OR;
                    FUNCT3_AND:     id_alu_op = ALU_OP_AND;
                endcase
            end
            OPCODE_LUI: begin
                id_alu_src_b = ALU_SRC_B_IMM;
                id_alu_op = ALU_OP_COPY_B;
                id_reg_write_en = 1'b1;
            end
            OPCODE_BRANCH: begin
                id_alu_op = ALU_OP_SUB;
                id_is_branch = 1'b1;
            end
            OPCODE_JALR: begin
                id_alu_src_b = ALU_SRC_B_IMM;
                id_alu_op = ALU_OP_ADD;
                id_reg_write_en = 1'b1;
                id_reg_wb_src = REG_WB_SRC_PC4;
                id_is_jump = 1'b1;
            end
            OPCODE_JAL: begin
                id_alu_src_a = ALU_SRC_A_PC;
                id_alu_src_b = ALU_SRC_B_IMM;
                id_alu_op = ALU_OP_ADD;
                id_reg_write_en = 1'b1;
                id_reg_wb_src = REG_WB_SRC_PC4;
                id_is_jump = 1'b1;
            end
            // TODO: fence.i
        endcase
    end

    always_comb begin : EX
        should_stall = 1'b0;
        should_flush = 1'b0;
        ex_pc_src = PC_SRC_PC4;

        if (ex_is_load) begin
            should_stall = 1'b1;
        end

        if (ex_is_branch) begin
            case (ex_branch_funct3)
                FUNCT3_BEQ: begin
                    if (ex_alu_zero) begin
                        ex_pc_src = PC_SRC_BRA;
                        should_flush = 1'b1;
                    end
                end
                FUNCT3_BNE: begin
                    if (~ex_alu_zero) begin
                        ex_pc_src = PC_SRC_BRA;
                        should_flush = 1'b1;
                    end
                end
                FUNCT3_BLT: begin
                    if (ex_alu_less) begin
                        ex_pc_src = PC_SRC_BRA;
                        should_flush = 1'b1;
                    end
                end
                FUNCT3_BGE: begin
                    if (~ex_alu_less) begin
                        ex_pc_src = PC_SRC_BRA;
                        should_flush = 1'b1;
                    end
                end
                FUNCT3_BLTU: begin
                    if (ex_alu_uless) begin
                        ex_pc_src = PC_SRC_BRA;
                        should_flush = 1'b1;
                    end
                end
                FUNCT3_BGEU: begin
                    if (~ex_alu_uless) begin
                        ex_pc_src = PC_SRC_BRA;
                        should_flush = 1'b1;
                    end
                end
            endcase
        end
        if (ex_is_jump) begin
            ex_pc_src = PC_SRC_ALU;
            should_flush = 1'b1;
        end
    end

endmodule