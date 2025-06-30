`include "ch3/sr_latch.sv"
 
module sr_latch_tb();
    logic s, r;
    logic q, qn;

    sr_latch dut (
        .s(s),
        .r(r),
        .q(q),
        .qn(qn)
    );

    initial begin
        s = 1; r = 0;
        #10;
        $display("s=%b, r=%b, q=%b, qn=%b", s, r, q, qn);
        assert(q == 1 && qn == 0);

        s = 0; r = 0;
        #10;
        $display("s=%b, r=%b, q=%b, qn=%b", s, r, q, qn);
        assert(q == 1 && qn == 0); // State should remain unchanged

        s = 0; r = 1;
        #10;
        $display("s=%b, r=%b, q=%b, qn=%b", s, r, q, qn);
        assert(q == 0 && qn == 1);

        s = 0; r = 0;
        #10;
        $display("s=%b, r=%b, q=%b, qn=%b", s, r, q, qn);
        assert(q == 0 && qn == 1); // State should remain unchanged

        s = 1; r = 1;
        #10;
        $display("s=%b, r=%b, q=%b, qn=%b", s, r, q, qn);
        assert(q === 0 && qn === 0);

        $finish;
    end

endmodule