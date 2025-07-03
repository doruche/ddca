module lshifter #(
    parameter shamt_width = 5
) (
    input logic [2**shamt_width-1:0] val,
    input logic [shamt_width-1:0] shamt,
    output logic [2**shamt_width-1:0] out
);
    assign out = val << shamt;
endmodule

module rlshifter #(
    parameter shamt_width = 5
) (
    input logic [2**shamt_width-1:0] val,
    input logic [shamt_width-1:0] shamt,
    output logic [2**shamt_width-1:0] out
);
    assign out = val >> shamt;
endmodule

module rashifter #(
    parameter shamt_width = 5
) (
    input logic [2**shamt_width-1:0] val,
    input logic [shamt_width-1:0] shamt,
    output logic [2**shamt_width-1:0] out
);
    assign out = val >>> shamt; 
endmodule