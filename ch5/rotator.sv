module lrot #(
    parameter roamt_width = 5
) (
    input logic [2**roamt_width-1:0] val,
    input logic [roamt_width-1:0] roamt,
    output logic [2**roamt_width-1:0] out
);
    localparam WIDTH = 2**roamt_width;

    assign out = (val << roamt) | (val >> (WIDTH - roamt));
endmodule

module rrot #(
    parameter roamt_width = 5
) (
    input logic [2**roamt_width-1:0] val,
    input logic [roamt_width-1:0] roamt,
    output logic [2**roamt_width-1:0] out
);
    localparam WIDTH = 2**roamt_width;

    assign out = (val >> roamt) | (val << (WIDTH - roamt));
endmodule