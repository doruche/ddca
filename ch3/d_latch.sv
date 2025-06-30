`include "ch3/sr_latch.sv"

module d_latch (
    input logic d, clk,
    output logic q, qn
);
    logic s, r;
    assign s = d & clk;
    assign r = ~d & clk;
    
    sr_latch sr_latch_inst (
        .s(s),
        .r(r),
        .q(q),
        .qn(qn)
    );
endmodule