`include "rtl/pc.sv"

import typepkg::*;

module pc_tb;

    logic clk;
    logic rst;
    logic [31:0] next_pc;
    logic [31:0] cur_pc;

    pc pc_inst (
        .clk(clk),
        .rst(rst),
        .next_pc(next_pc),
        .cur_pc(cur_pc)
    );


    assign next_pc = cur_pc + 4;

    initial begin
        $dumpfile("pc_tb.vcd");
        $dumpvars(0, pc_tb);

        clk = 0;
        rst = 1; #10;
        rst = 0;

        repeat (100) begin
            #5 clk = ~clk;
        end

        $finish;
    end
endmodule