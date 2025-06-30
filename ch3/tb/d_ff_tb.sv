`include "ch3/d_ff.sv"

module d_ff_tb();

    logic d, clk;
    logic q, qn;

    d_ff dut (
        .d(d),
        .clk(clk),
        .q(q),
        .qn(qn)
    );

    initial begin
        d = 0;
        clk = 0;

        #5 d = 1; clk = 1; 
        #5 clk = 0; 
        #5 d = 0; clk = 1; 
        #5 clk = 0; 
        #5 d = 1; clk = 1; 
        #5 clk = 0; 

        $finish;
    end

    initial begin
        $monitor("Time: %0t | D: %b | CLK: %b | Q: %b | QN: %b", $time, d, clk, q, qn);
    end

endmodule