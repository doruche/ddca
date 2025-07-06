`include "rtl/regfiles.sv"
import typepkg::*;

module regfiles_tb;
    logic clk;
    logic rst;
    logic [4:0] ra1, ra2, wa3;
    logic we;
    logic [31:0] wd3;
    logic [31:0] rd1, rd2;

    regfiles regfiles_inst (
        .clk(clk),
        .rst(rst),
        .ra1(ra1),
        .ra2(ra2),
        .wa3(wa3),
        .we(we),
        .wd3(wd3),
        .rd1(rd1),
        .rd2(rd2)
    );

    initial begin
        $dumpfile("regfiles_tb.vcd");
        $dumpvars(0, regfiles_tb);

        clk = 0;
        rst = 1; #10;
        rst = 0;

        ra1 = 5'd1; ra2 = 5'd3; wa3 = 5'd3; we = 0; wd3 = 32'hAABBCCDD;
        
        we = 1; we <= #10 0;

        repeat (20) begin
            #5; clk = ~clk;
        end

        $finish;
    end


endmodule