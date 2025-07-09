`include "rtl/insndec.sv"
`include "rtl/alu.sv"
`include "rtl/pc.sv"
`include "rtl/immext.sv"
`include "rtl/regfiles.sv"
import typepkg::*;

module datapath (
    input logic clk,
    input logic rst,

    input logic [31:0] insn,
    output logic [31:0] pc,

    output opcode_t id_opcode,
    output logic [2:0] id_funct3,
    output logic [6:0] id_funct7,
    output logic [4:0] id_ra1,
    output logic [4:0] id_ra2,
    output logic [4:0] id_wa3,

    input logic should_stall,
    input logic flush_if_id,
    input logic flush_id_ex,

    input alu_src_a_t id_alu_src_a,
    input alu_src_b_t id_alu_src_b,
    input alu_op_t id_alu_op,
    input logic id_reg_write_en,
    input reg_wb_src_t id_reg_wb_src,
    input mem_read_t id_mem_read,
    input mem_write_t id_mem_write,
    input logic id_is_branch,
    input logic id_is_jump,
    
    output logic ex_alu_zero,
    output logic ex_alu_less,
    output logic ex_alu_uless,
    output logic ex_is_branch,
    output logic [2:0] ex_branch_funct3,
    output logic ex_is_jump,
    output logic ex_is_load,
    output logic [4:0] ex_wa3,
    input pc_src_t ex_pc_src,
    output mem_fmt_t mem_fmt,
    output logic [31:0] mem_addr,
    output logic [31:0] mem_wdata,
    input logic [31:0] mem_rdata,
    output logic mem_re, mem_we
);
    // naming convention:
    // [stage]_[signal] - signal produced from combinal logic in that stage
    
    if_id_reg_t if_id_reg;
    id_ex_reg_t id_ex_reg;
    ex_mem_reg_t ex_mem_reg;
    mem_wb_reg_t mem_wb_reg;

    logic [31:0] cur_pc;
    logic [31:0] next_pc;


    logic [31:0] id_imm;
    logic [31:0] id_rd1;
    logic [31:0] id_rd2;

    logic [31:0] ex_actual_rd1;
    logic [31:0] ex_actual_rd2;
    logic [31:0] ex_alu_a;
    logic [31:0] ex_alu_b;
    logic [31:0] ex_alu_res;
    logic [31:0] wb_result;

    // PC
    always @(*) begin
        case (ex_pc_src)
            PC_SRC_PC4: next_pc = cur_pc + 4;
            PC_SRC_ALU: next_pc = ex_alu_res;
            PC_SRC_BRA: next_pc = id_ex_reg.pc + id_ex_reg.imm;
            default:    next_pc = 'x;
        endcase
    end

    always_ff @( posedge clk or posedge rst ) begin : IF_ID
        if (rst || flush_if_id) begin
            if_id_reg.pc <= PC_RST_VAL;
            if_id_reg.insn <= INSN_NO_OP;
        end else if (~should_stall && clk) begin
            if_id_reg.pc <= cur_pc;
            if_id_reg.insn <= insn;
        end
    end

    always_ff @( posedge clk or posedge rst ) begin : ID_EX
        if (rst || flush_id_ex) begin
            id_ex_reg.reg_write_en <= 0;
            id_ex_reg.mem_read <= MEM_READ_NONE;
            id_ex_reg.mem_write <= MEM_WRITE_NONE;
            id_ex_reg.is_branch <= 0;
            id_ex_reg.is_jump <= 0;
        end else if (clk) begin
            id_ex_reg.pc <= if_id_reg.pc;
            id_ex_reg.ra1 <= id_ra1;
            id_ex_reg.ra2 <= id_ra2;
            id_ex_reg.wa3 <= id_wa3;
            id_ex_reg.opcode <= id_opcode;
            id_ex_reg.funct3 <= id_funct3;
            id_ex_reg.funct7 <= id_funct7;
            id_ex_reg.imm <= id_imm;
            id_ex_reg.rd1 <= id_rd1;
            id_ex_reg.rd2 <= id_rd2;

            id_ex_reg.alu_src_a <= id_alu_src_a;
            id_ex_reg.alu_src_b <= id_alu_src_b;
            id_ex_reg.alu_op <= id_alu_op;
            id_ex_reg.reg_write_en <= id_reg_write_en;
            id_ex_reg.reg_wb_src <= id_reg_wb_src;
            id_ex_reg.mem_read <= id_mem_read;
            id_ex_reg.mem_write <= id_mem_write;
            id_ex_reg.is_branch <= id_is_branch;
            id_ex_reg.is_jump <= id_is_jump;
        end
    end

    always_ff @( posedge clk or posedge rst ) begin : EX_MEM
        if (rst) begin
            ex_mem_reg.reg_write_en <= 0;
            ex_mem_reg.mem_read <= MEM_READ_NONE;
            ex_mem_reg.mem_write <= MEM_WRITE_NONE;
        end else if (clk) begin
            ex_mem_reg.pc <= id_ex_reg.pc;
            ex_mem_reg.wa3 <= id_ex_reg.wa3;
            ex_mem_reg.alu_res <= ex_alu_res;
            ex_mem_reg.rd2 <= ex_actual_rd2;

            ex_mem_reg.reg_write_en <= id_ex_reg.reg_write_en;
            ex_mem_reg.reg_wb_src <= id_ex_reg.reg_wb_src;
            ex_mem_reg.mem_read <= id_ex_reg.mem_read;
            ex_mem_reg.mem_write <= id_ex_reg.mem_write;
        end
    end

    // EX
    assign ex_is_branch = id_ex_reg.is_branch;
    assign ex_is_jump = id_ex_reg.is_jump;
    assign ex_branch_funct3 = id_ex_reg.funct3;
    assign ex_is_load = id_ex_reg.mem_read != MEM_READ_NONE;
    assign ex_wa3 = id_ex_reg.wa3;


    always_ff @( posedge clk or posedge rst ) begin : MEM_WB
        if (rst) begin
            mem_wb_reg.reg_write_en <= 0;
            mem_wb_reg.mem_read <= MEM_READ_NONE;
            mem_wb_reg.mem_write <= MEM_WRITE_NONE;
        end else if (clk) begin
            mem_wb_reg.pc <= ex_mem_reg.pc;
            mem_wb_reg.wa3 <= ex_mem_reg.wa3;
            mem_wb_reg.alu_res <= ex_mem_reg.alu_res;
            mem_wb_reg.mem_rdata <= mem_rdata;

            mem_wb_reg.reg_write_en <= ex_mem_reg.reg_write_en;
            mem_wb_reg.reg_wb_src <= ex_mem_reg.reg_wb_src;
            mem_wb_reg.mem_read <= ex_mem_reg.mem_read;
            mem_wb_reg.mem_write <= ex_mem_reg.mem_write;
        end
    end

    always @(*) begin : Forwarding
        // prio: MEM > WB > NONE
        if ((id_ex_reg.ra1 == ex_mem_reg.wa3) && ex_mem_reg.reg_write_en && id_ex_reg.ra1 != 0)
            ex_actual_rd1 = ex_mem_reg.alu_res;
        else if ((id_ex_reg.ra1 == mem_wb_reg.wa3) && mem_wb_reg.reg_write_en && id_ex_reg.ra1 != 0)
            ex_actual_rd1 = wb_result;
        else
            ex_actual_rd1 = id_ex_reg.rd1;

        if ((id_ex_reg.ra2 == ex_mem_reg.wa3) && ex_mem_reg.reg_write_en && id_ex_reg.ra2 != 0)
            ex_actual_rd2 = ex_mem_reg.alu_res;
        else if ((id_ex_reg.ra2 == mem_wb_reg.wa3) && mem_wb_reg.reg_write_en && id_ex_reg.ra2 != 0)
            ex_actual_rd2 = wb_result;
        else
            ex_actual_rd2 = id_ex_reg.rd2;
    end
    
    always @(*) begin : ALU_Selection
        case (id_ex_reg.alu_src_a)
            ALU_SRC_A_RS1:  ex_alu_a = ex_actual_rd1;
            ALU_SRC_A_PC:   ex_alu_a = id_ex_reg.pc;
            default:        ex_alu_a = 'x;
        endcase
        case (id_ex_reg.alu_src_b)
            ALU_SRC_B_RS2:  ex_alu_b = ex_actual_rd2;
            ALU_SRC_B_IMM:  ex_alu_b = id_ex_reg.imm;
            default:        ex_alu_b = 'x;
        endcase
    end

    always @(*) begin : Memory_Operation
        mem_re = ex_mem_reg.mem_read != MEM_READ_NONE;
        mem_we = ex_mem_reg.mem_write != MEM_WRITE_NONE;
        mem_addr = ex_mem_reg.alu_res;
        mem_wdata = ex_mem_reg.rd2;
        mem_fmt.width = NONE;
        mem_fmt.is_signed = 1;

        // sign does not count for write operations
        case (ex_mem_reg.mem_write)
            MEM_WRITE_BYTE: mem_fmt.width = BYTE;
            MEM_WRITE_HALF: mem_fmt.width = HALF;
            MEM_WRITE_WORD: mem_fmt.width = WORD; 
        endcase

        case (ex_mem_reg.mem_read)
            MEM_READ_BYTE: mem_fmt.width = BYTE;
            MEM_READ_HALF: mem_fmt.width = HALF;
            MEM_READ_WORD: mem_fmt.width = WORD;
            MEM_READ_BYTE_U: begin
                mem_fmt.width = BYTE;
                mem_fmt.is_signed = 0;
            end
            MEM_READ_HALF_U: begin
                mem_fmt.width = HALF;
                mem_fmt.is_signed = 0;
            end
        endcase
    end

    always @(*) begin: WriteBack_Selection
        case (mem_wb_reg.reg_wb_src)
            REG_WB_SRC_ALU: wb_result = mem_wb_reg.alu_res;
            REG_WB_SRC_MEM: wb_result = mem_wb_reg.mem_rdata;
            REG_WB_SRC_PC4: wb_result = mem_wb_reg.pc + 4;
            default: wb_result = 'x;
        endcase
    end


    pc u_pc (
        .clk(clk),
        .rst(rst),
        .should_stall(should_stall),
        .next_pc(next_pc),
        .cur_pc(cur_pc)
    );
    assign pc = cur_pc;

    immext u_immext (
        .insn(if_id_reg.insn),
        .imm(id_imm)
    );

    insndec u_insndec (
        .insn(if_id_reg.insn),
        .opcode(id_opcode),
        .funct3(id_funct3),
        .funct7(id_funct7),
        .rs1(id_ra1),
        .rs2(id_ra2),
        .rd(id_wa3)
    );

    alu u_alu (
        .operand_a(ex_alu_a),
        .operand_b(ex_alu_b),
        .alu_op(id_ex_reg.alu_op),
        .result(ex_alu_res),
        .alu_zero(ex_alu_zero),
        .alu_less(ex_alu_less),
        .alu_uless(ex_alu_uless)
    );

    regfiles u_regfiles (
        .clk(clk),
        .rst(rst),
        .ra1(id_ra1),
        .ra2(id_ra2),
        .wa3(mem_wb_reg.wa3),
        .we(mem_wb_reg.reg_write_en),
        .wd3(wb_result),
        .rd1(id_rd1),
        .rd2(id_rd2)
    );
endmodule