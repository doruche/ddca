`include "ch3/d_latch.sv"

module d_ff (
    input logic d, clk,
    output logic q, qn
);
    logic n1;

    d_latch d1 (
        .d(d),
        .clk(~clk),
        .q(n1),
        .qn()
    );

    d_latch d2 (
        .d(n1),
        .clk(clk),
        .q(q),
        .qn(qn)
    );

endmodule