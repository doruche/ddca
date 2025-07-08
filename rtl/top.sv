`include "rtl/core.sv"
`include "rtl/perips/ram.sv"
`include "rtl/perips/rom.sv"
import typepkg::*;

module top (
    input logic clk,
    input logic rst
);
    logic [31:0] insn;
    logic [31:0] pc;

    logic [31:0] rambus_addr;
    logic [31:0] rambus_rdata;
    logic rambus_re, rambus_we;
    logic [3:0] rambus_wstrb;
    logic [31:0] rambus_wdata;

    core u_core (
        .clk(clk),
        .rst(rst),
        .insn(insn),
        .pc(pc),
        .bus_addr(rambus_addr),
        .bus_rdata(rambus_rdata),
        .bus_re(rambus_re),
        .bus_we(rambus_we),
        .bus_wstrb(rambus_wstrb),
        .bus_wdata(rambus_wdata)
    );

    rombus u_rombus (
        .clk(clk),
        .addr(pc),
        .data(insn)
    );

    rambus u_rambus (
        .clk(clk),
        .addr(rambus_addr),
        .wdata(rambus_wdata),
        .re(rambus_re),
        .we(rambus_we),
        .wstrb(rambus_wstrb),
        .rdata(rambus_rdata)
    );

endmodule