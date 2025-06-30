`include "ch3/d_latch.sv"

module d_latch_tb();
    logic d, clk;
    logic q, qn;

    d_latch dut (
        .d(d),
        .clk(clk),
        .q(q),
        .qn(qn)
    );

    initial begin
        d = 0;
        clk = 0;

        #5 d = 1; clk = 1; #0;
        assert(q == 1 && qn == 0);
        #5 clk = 0; #0;
        assert(q == 1 && qn == 0);
        #5 d = 0; clk = 1; #0; 
        assert(q == 0 && qn == 1);
        #5 clk = 0; #0;
        assert(q == 0 && qn == 1);
        #5 d = 1; clk = 1; #0;
        assert(q == 1 && qn == 0);
        #5 clk = 0; #0;
        assert(q == 1 && qn == 0);

        $finish;
    end

    initial begin
        $monitor("Time: %0t | D: %b | CLK: %b | Q: %b | QN: %b", $time, d, clk, q, qn);
    end
endmodule