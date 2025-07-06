`include "rtl/pc.sv"
`include "rtl/insndec.sv"
`include "rtl/immext.sv"
`include "rtl/ctrl.sv"
`include "rtl/regfiles.sv"
`include "rtl/alu.sv"

import typepkg::*;

module core (
    input logic clk,
    input logic rst,
    output logic [31:0] insnmem_addr,
    input logic [31:0] insnmem_data,
    
    output logic [31:0] mem_addr,
    output logic [31:0] mem_wdata,
    input logic [31:0] mem_rdata_raw,
    output logic mem_read_req,
    output logic mem_write_req,
    output logic [3:0] mem_byte_en
);
    // pc
    pc_src_t pc_src;
    logic [31:0] cur_pc, next_pc;
    logic [31:0] insn;
    
    // insn & immext
    opcode_t opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [4:0] ra1, ra2, wa3;
    logic [31:0] imm;

    // regfiles
    logic [31:0] rd1, rd2, wd3;
    reg_wb_src_t reg_wb_src;
    logic reg_write;

    // alu
    alu_src_a_t alu_src_a;
    alu_src_b_t alu_src_b;
    logic [31:0] alu_a, alu_b, alu_res;
    logic alu_zero, alu_less, alu_uless;
    alu_op_t alu_op;

    // mem
    mem_write_t mem_write;
    mem_read_t mem_read;
    logic [31:0] mem_rdata; // processed mem_rdata_raw

    // wire connections
    insndec u_insndec (
        .insn(insn),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .rs1(ra1),
        .rs2(ra2),
        .rd(wa3)
    );

    pc u_pc (
        .clk(clk),
        .rst(rst),
        .next_pc(next_pc),
        .cur_pc(cur_pc)
    );

    immext u_immext (
        .insn(insn),
        .imm(imm)
    );

    regfiles u_regfiles (
        .clk(clk),
        .rst(rst),
        .ra1(ra1),
        .ra2(ra2),
        .wa3(wa3),
        .we(reg_write),
        .wd3(wd3),
        .rd1(rd1),
        .rd2(rd2)
    );

    alu u_alu (
        .operand_a(alu_a),
        .operand_b(alu_b),
        .alu_op(alu_op),
        .result(alu_res),
        .alu_zero(alu_zero),
        .alu_less(alu_less),
        .alu_uless(alu_uless)
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


    // ctrl connections
    
    always_comb begin : insn_ctrl
        insnmem_addr = cur_pc;
        insn = insnmem_data;
    end
    
    always_comb begin : alu_src_ctrl
        alu_a = BAD_VAL;
        alu_b = BAD_VAL;
        case (alu_src_a)
            ALU_SRC_A_RS1: alu_a = rd1;
            ALU_SRC_A_PC: alu_a = cur_pc;
        endcase
        case (alu_src_b)
            ALU_SRC_B_RS2: alu_b = rd2;
            ALU_SRC_B_IMM: alu_b = imm;
        endcase
    end

    // pc_src
    always_comb begin : pc_src_ctrl
        next_pc = BAD_VAL;
        case (pc_src)
            PC_SRC_PC4: next_pc = cur_pc + 4;
            PC_SRC_ALU: next_pc = alu_res;
        endcase
    end

    // reg_wb_src
    always_comb begin : reg_wb_src_ctrl
        wd3 = BAD_VAL;
        if (reg_write) begin
            case (reg_wb_src)
                REG_WB_SRC_ALU: wd3 = alu_res;
                REG_WB_SRC_MEM: wd3 = mem_rdata;
                REG_WB_SRC_PC4: wd3 = cur_pc + 4;
            endcase
        end
    end

    // mem
    always @(*) begin : mem_ctrl
        mem_addr = alu_res;
        mem_wdata = rd2;

        mem_rdata = BAD_VAL;
        mem_read_req = 1'b0;
        mem_write_req = 1'b0;
        mem_byte_en = 4'b0;

        if (mem_write != MEM_WRITE_NONE) begin
            mem_write_req = 1'b1;
            case (mem_write)
                MEM_WRITE_BYTE: mem_byte_en = 4'b0001;
                MEM_WRITE_HALF: mem_byte_en = 4'b0011;
                MEM_WRITE_WORD: mem_byte_en = 4'b1111;
            endcase
        end
        
        if (mem_read != MEM_READ_NONE) begin
            mem_read_req = 1'b1;

            case (mem_read)
                MEM_READ_BYTE: begin
                    mem_byte_en = 4'b0001;
                    mem_rdata = {{24{mem_rdata_raw[7]}}, mem_rdata_raw[7:0]};
                end
                MEM_READ_HALF: begin
                    mem_byte_en = 4'b0011;
                    mem_rdata = {{16{mem_rdata_raw[15]}}, mem_rdata_raw[15:0]};
                end
                MEM_READ_WORD: begin
                    mem_byte_en = 4'b1111;
                    mem_rdata = mem_rdata_raw;
                end
                MEM_READ_BYTE_U: begin
                    mem_byte_en = 4'b0001;
                    mem_rdata = {24'b0, mem_rdata_raw[7:0]};
                end
                MEM_READ_HALF_U: begin
                    mem_byte_en = 4'b0011;
                    mem_rdata = {16'b0, mem_rdata_raw[15:0]};
                end
            endcase
        end
    end

endmodule