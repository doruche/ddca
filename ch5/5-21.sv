// shifts left by 2 bits.
module sulotion (
    input logic [31:0] in,
    output logic [31:0] out
);
    assign out = {in[29:0], 2'b00};
endmodule