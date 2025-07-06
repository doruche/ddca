import typepkg::*;

module ctrl (
    input opcode_t opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    input logic alu_zero,
    input logic alu_less,
    input logic alu_uless,
    output pc_src_t pc_src,
    output alu_src_a_t alu_src_a,
    output alu_src_b_t alu_src_b,
    output alu_op_t alu_op,
    output logic reg_write,
    output reg_wb_src_t reg_wb_src,
    output mem_write_t mem_write,
    output mem_read_t mem_read
);
    logic take_branch;

    always @(*) begin
        // default values to avoid latches
        pc_src = PC_SRC_PC4;
        alu_src_a = ALU_SRC_A_RS1;
        alu_src_b = ALU_SRC_B_RS2;
        alu_op = ALU_OP_ADD;
        reg_write = 1'b0;
        reg_wb_src = REG_WB_SRC_ALU;
        mem_write = MEM_WRITE_NONE;
        mem_read = MEM_READ_NONE;

        take_branch = 1'b0;

        // decode
        case (opcode)
            OPCODE_LOAD: begin
                `ifdef BENCH
                    $display("ctrl.sv: OPCODE_LOAD");
                `endif
                reg_write = 1'b1;
                alu_src_a = ALU_SRC_A_RS1;
                alu_src_b = ALU_SRC_B_IMM;
                alu_op = ALU_OP_ADD;
                reg_wb_src = REG_WB_SRC_MEM;
                case (funct3)
                    FUNCT3_LB: mem_read = MEM_READ_BYTE;
                    FUNCT3_LH: mem_read = MEM_READ_HALF;
                    FUNCT3_LW: mem_read = MEM_READ_WORD;
                    FUNCT3_LBU: mem_read = MEM_READ_BYTE_U;
                    FUNCT3_LHU: mem_read = MEM_READ_HALF_U;
                    default: mem_read = MEM_READ_NONE;
                endcase
            end
            OPCODE_OP_IMM: begin
                `ifdef BENCH
                    $display("ctrl.sv: OPCODE_OP_IMM");
                `endif

                reg_write = 1'b1;
                alu_src_a = ALU_SRC_A_RS1;
                alu_src_b = ALU_SRC_B_IMM;
                reg_wb_src = REG_WB_SRC_ALU;
                case (funct3)
                    FUNCT3_ADDI: alu_op = ALU_OP_ADD;
                    FUNCT3_SLLI: begin
                        if (~funct7[5]) begin
                            alu_op = ALU_OP_SLL;
                        end else begin
                            alu_op = ALU_OP_ADD;
                            `ifdef BENCH
                                $error("ctrl.sv: SLLI with funct7[5] set is not allowed");
                            `endif
                        end
                    end
                    FUNCT3_SLTI: alu_op = ALU_OP_SLT;
                    FUNCT3_SLTIU: alu_op = ALU_OP_SLTU;
                    FUNCT3_XORI: alu_op = ALU_OP_XOR;
                    FUNCT3_SRLAI: begin
                        if (funct7[5])  alu_op = ALU_OP_SRA;
                        else alu_op = ALU_OP_SRL;
                    end
                    FUNCT3_ORI: alu_op = ALU_OP_OR;
                    FUNCT3_ANDI: alu_op = ALU_OP_AND;
                    default: begin
                        alu_op = ALU_OP_ADD;
                        `ifdef BENCH
                            $error("ctrl.sv: unknown funct3 for OPCODE_OP_IMM: %b", funct3);
                        `endif
                    end
                endcase
            end
            OPCODE_AUIPC: begin
                `ifdef BENCH
                    $display("ctrl.sv: OPCODE_AUIPC");
                `endif
                reg_write = 1'b1;
                alu_src_a = ALU_SRC_A_PC;
                alu_src_b = ALU_SRC_B_IMM;
                alu_op = ALU_OP_ADD;
                reg_wb_src = REG_WB_SRC_ALU;
            end
            OPCODE_STORE: begin
                `ifdef BENCH
                    $display("ctrl.sv: OPCODE_STORE");
                `endif
                alu_src_a = ALU_SRC_A_RS1;
                alu_src_b = ALU_SRC_B_IMM;
                alu_op = ALU_OP_ADD;
                case (funct3)
                    FUNCT3_SB: mem_write = MEM_WRITE_BYTE;
                    FUNCT3_SH: mem_write = MEM_WRITE_HALF;
                    FUNCT3_SW: mem_write = MEM_WRITE_WORD;
                    default: begin
                        mem_write = MEM_WRITE_NONE;
                        $error("ctrl.sv: unknown funct3 for OPCODE_STORE: %b", funct3);
                    end
                endcase
            end
            OPCODE_OP: begin
                `ifdef BENCH
                    $display("ctrl.sv: OPCODE_OP");
                `endif
                reg_write = 1'b1;
                alu_src_a = ALU_SRC_A_RS1;
                alu_src_b = ALU_SRC_B_RS2;
                reg_wb_src = REG_WB_SRC_ALU;
                case ({funct7[5], funct3})
                    {1'b0, FUNCT3_ADDSUB}: alu_op = ALU_OP_ADD; // ADD
                    {1'b1, FUNCT3_ADDSUB}: alu_op = ALU_OP_SUB; // SUB
                    {1'b0, FUNCT3_SLL}: alu_op = ALU_OP_SLL; // SLL
                    {1'b0, FUNCT3_SLT}: alu_op = ALU_OP_SLT; // SLT
                    {1'b0, FUNCT3_SLTU}: alu_op = ALU_OP_SLTU; // SLTU
                    {1'b0, FUNCT3_XOR}: alu_op = ALU_OP_XOR; // XOR
                    {1'b0, FUNCT3_SRAL}: alu_op = ALU_OP_SRL; // SRL
                    {1'b1, FUNCT3_SRAL}: alu_op = ALU_OP_SRA; // SRA
                    {1'b0, FUNCT3_OR}: alu_op = ALU_OP_OR; // OR
                    {1'b0, FUNCT3_AND}: alu_op = ALU_OP_AND; // AND
                    default: begin
                        alu_op = ALU_OP_ADD;
                        $error("ctrl.sv: unknown funct7 and funct3 for OPCODE_OP: %b %b", funct7, funct3);
                    end
                endcase
            end
            OPCODE_LUI: begin
                `ifdef BENCH
                    $display("ctrl.sv: OPCODE_LUI");
                `endif
                reg_wb_src = REG_WB_SRC_ALU;
                alu_src_b = ALU_SRC_B_IMM;
                alu_op = ALU_OP_COPY_B;
                reg_write = 1'b1;
            end
            OPCODE_BRANCH: begin
                `ifdef BENCH
                    $display("ctrl.sv: OPCODE_BRANCH");
                `endif
                alu_src_a = ALU_SRC_A_RS1;
                alu_src_b = ALU_SRC_B_RS2;
                alu_op = ALU_OP_SUB;
                case (funct3)
                    FUNCT3_BEQ: take_branch = alu_zero;
                    FUNCT3_BNE: take_branch = ~alu_zero;
                    FUNCT3_BLT: take_branch = alu_less;
                    FUNCT3_BGE: take_branch = ~alu_less;
                    FUNCT3_BLTU: take_branch = alu_uless;
                    FUNCT3_BGEU: take_branch = ~alu_uless;
                    default: begin
                        take_branch = 1'b0;
                        $error("ctrl.sv: unknown funct3 for OPCODE_BRANCH: %b", funct3);
                    end
                endcase
                if (take_branch) begin
                    pc_src = PC_SRC_ALU;
                end else begin
                    pc_src = PC_SRC_PC4;
                end
            end
            OPCODE_JALR: begin
                `ifdef BENCH
                    $display("ctrl.sv: OPCODE_JALR");
                `endif
                reg_write = 1'b1;
                alu_src_a = ALU_SRC_A_RS1;
                alu_src_b = ALU_SRC_B_IMM;
                alu_op = ALU_OP_ADD;
                reg_wb_src = REG_WB_SRC_PC4;
                pc_src = PC_SRC_ALU;
            end
            OPCODE_JAL: begin
                `ifdef BENCH
                    $display("ctrl.sv: OPCODE_JAL");
                `endif
                reg_write = 1'b1;
                pc_src = PC_SRC_ALU;
                alu_src_a = ALU_SRC_A_PC;
                alu_src_b = ALU_SRC_B_IMM;
                alu_op = ALU_OP_ADD;
                reg_wb_src = REG_WB_SRC_PC4;
            end
            default: begin
                pc_src = PC_SRC_PC4;
                alu_src_a = ALU_SRC_A_RS1;
                alu_src_b = ALU_SRC_B_RS2;
                alu_op = ALU_OP_ADD;
                reg_write = 1'b0;
                reg_wb_src = REG_WB_SRC_ALU;
                mem_write = MEM_WRITE_NONE;
                mem_read = MEM_READ_NONE;
            end
        endcase        

    end
endmodule