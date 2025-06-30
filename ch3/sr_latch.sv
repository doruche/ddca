module sr_latch (
    input logic s, r,
    output logic q, qn
);
    assign q = ~(r | qn);
    assign qn = ~(s | q);
endmodule

