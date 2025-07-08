`include "rtl/datapath.sv"
`include "rtl/ctrl.sv"
`include "rtl/ramintf.sv"
import typepkg::*;

module core (
    input logic clk,
    input logic rst,
    input logic [31:0] insn,
    output logic [31:0] pc,

    output logic [31:0] bus_addr,
    input logic [31:0] bus_rdata,
    output logic bus_re, bus_we,
    output logic [3:0] bus_wstrb,
    output logic [31:0] bus_wdata
);
    opcode_t    id_opcode;
    logic [2:0] id_funct3;
    logic [6:0] id_funct7;
    logic [4:0] id_ra1, id_ra2, id_wa3;
    alu_src_a_t id_alu_src_a;
    alu_src_b_t id_alu_src_b;
    alu_op_t    id_alu_op;
    logic id_reg_write_en;
    reg_wb_src_t id_reg_wb_src;
    mem_read_t id_mem_read;
    mem_write_t id_mem_write;
    logic id_is_branch;
    logic id_is_jump;

    logic ex_alu_zero;
    logic ex_alu_less;
    logic ex_alu_uless;
    pc_src_t ex_pc_src;
    logic ex_is_branch;
    logic ex_is_jump;
    logic ex_is_load;
    logic [2:0] ex_branch_funct3;


    mem_fmt_t mem_fmt;
    logic [31:0] mem_addr;
    logic [31:0] mem_wdata;
    logic [31:0] mem_rdata;
    logic mem_re, mem_we;

    logic should_stall;
    logic should_flush;

    datapath u_datapath (
        .clk(clk),
        .rst(rst),
        .insn(insn),
        .pc(pc),
        .id_opcode(id_opcode),
        .id_funct3(id_funct3),
        .id_funct7(id_funct7),
        .id_ra1(id_ra1),
        .id_ra2(id_ra2),
        .id_wa3(id_wa3),
        .should_stall(should_stall),
        .should_flush(should_flush),
        .id_alu_src_a(id_alu_src_a),
        .id_alu_src_b(id_alu_src_b),
        .id_alu_op(id_alu_op),
        .id_reg_write_en(id_reg_write_en),
        .id_reg_wb_src(id_reg_wb_src),
        .id_mem_read(id_mem_read),
        .id_mem_write(id_mem_write),
        .id_is_branch(id_is_branch),
        .id_is_jump(id_is_jump),
        .ex_alu_zero(ex_alu_zero),
        .ex_alu_less(ex_alu_less),
        .ex_alu_uless(ex_alu_uless),
        .ex_pc_src(ex_pc_src),
        .ex_is_branch(ex_is_branch),
        .ex_branch_funct3(ex_branch_funct3),
        .ex_is_jump(ex_is_jump),
        .ex_is_load(ex_is_load),
        .mem_fmt(mem_fmt),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata),
        .mem_re(mem_re),
        .mem_we(mem_we)
    );

    ctrl u_ctrl (
        .id_opcode(id_opcode),
        .id_funct3(id_funct3),
        .id_funct7_bit5(id_funct7[5]),
        .id_ra1(id_ra1),
        .id_ra2(id_ra2),
        .id_wa3(id_wa3),
        .id_is_branch(id_is_branch),
        .id_is_jump(id_is_jump),
        .id_alu_src_a(id_alu_src_a),
        .id_alu_src_b(id_alu_src_b),
        .id_alu_op(id_alu_op),
        .id_reg_write_en(id_reg_write_en),
        .id_reg_wb_src(id_reg_wb_src),
        .id_mem_write(id_mem_write),
        .id_mem_read(id_mem_read),
        .ex_alu_zero(ex_alu_zero),
        .ex_alu_less(ex_alu_less),
        .ex_alu_uless(ex_alu_uless),
        .ex_is_branch(ex_is_branch),
        .ex_is_jump(ex_is_jump),
        .ex_is_load(ex_is_load),
        .ex_branch_funct3(ex_branch_funct3),
        .ex_pc_src(ex_pc_src),
        .should_stall(should_stall),
        .should_flush(should_flush)
    );

    ramintf u_ramintf (
        .clk(clk),
        .re(mem_re),
        .fmt(mem_fmt),
        .addr(mem_addr),
        .wdata(mem_wdata),
        .rdata(mem_rdata),
        .bus_addr(bus_addr),
        .bus_rdata(bus_rdata),
        .bus_re(bus_re),
        .bus_we(bus_we),
        .bus_wstrb(bus_wstrb),
        .bus_wdata(bus_wdata)
    );

endmodule