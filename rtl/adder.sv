module adder (
    input logic [31:0] a, b,
    input logic cin,
    output logic [31:0] sum,
    output logic cout
);
    assign {cout, sum} = a + b + cin;
endmodule