// 74HC151
module mux8 (
    input logic [7:0] in,
    input logic [2:0] sel,
    input logic en,
    output logic out
);
    assign out = en ? in[sel] : 1'b0;
endmodule