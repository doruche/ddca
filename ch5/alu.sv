/*
Figure 5.18 (b)
ALUControl  Function
000         Add
001         Subtract
010         And
011         Or
101         SLT     Set control[1] to 1 as we want the adder to perform a subtraction
Flags   { Z, N, C, V }
*/
module ALU #(
    parameter width = 32
) (
    input logic [width-1:0] a, b,
    input logic [2:0] control,
    output logic [width-1:0] result,
    output logic z, n, c, v
);
    localparam X_INPUT = {width{1'bx}};

    logic [width-1:0] add_out, and_out, or_out, slt_out;
    mux8 #(.width(width)) final_mux (
        .in({
            X_INPUT, 
            X_INPUT, 
            slt_out, 
            X_INPUT, 
            or_out, 
            and_out, 
            add_out, 
            add_out
        }),
        .sel(control),
        .out(result)
    );

    logic [width-1:0] add_sub_b_input;
    logic add_sub_c_output;

    assign add_sub_b_input = control[0] ? ~b : b;

    adder #(.width(width)) add_sub (
        .a(a),
        .b(add_sub_b_input),
        .cin(control[0]),
        .sum(add_out),
        .cout(add_sub_c_output)
    );

    assign and_out = a & b;
    assign or_out = a | b;

    // SLT outputs a true when overflow ^ add_out[width-1]
    assign slt_out = {{width{1'b0}}, (v ^ add_out[width-1])};

    // flags
    assign z = (result == 0);
    assign n = result[width-1];
    assign c = add_sub_c_output & (control == 3'b000 || control == 3'b001);
    
    // overflow detection
    // 1. ALU is performing addition or subtraction or SLT
    // 2. A and sum have opposite signs
    // 3. A + B -> AB > 0 or A - B -> AB < 0
    logic cond1, cond2, cond3;
    assign cond1 = ~control[1];
    assign cond2 = a[width-1] ^ add_out[width-1];
    assign cond3 = ~(control[0] ^ a[width-1] ^ b[width-1]);
    assign v = cond1 & cond2 & cond3;

endmodule


// submodules
module mux8 #(
    parameter width = 32
) (
    input logic [width*8-1:0] in,
    input logic [2:0] sel,
    output logic [width-1:0] out
);
    assign out = in[sel*width +: width];    
endmodule

module adder #(
    parameter width = 32
) (
    input logic [width-1:0] a, b,
    input logic cin,
    output logic [width-1:0] sum,
    output logic cout
);
    assign {cout, sum} = a + b + cin;
endmodule