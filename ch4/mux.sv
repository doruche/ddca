module mux2
    #(parameter width = 8)
    (input logic [width-1:0] a,
     input logic [width-1:0] b,
     input logic sel,
     output logic [width-1:0] y);
    assign y = sel ? b : a;
endmodule

module mux4_12(
    input logic [11:0] a, b, c, d,
    input logic [1:0] sel,
    output logic [11:0] y
);
    logic [11:0] low, hi;

    mux2 #(.width(12)) mux_low (
        .a(a),
        .b(b),
        .sel(sel[0]),
        .y(low)
    );

    mux2 #(.width(12)) mux_hi (
        .a(c),
        .b(d),
        .sel(sel[0]),
        .y(hi)
    );

    mux2 #(.width(12)) mux_out (
        .a(low),
        .b(hi),
        .sel(sel[1]),
        .y(y)
    );
endmodule