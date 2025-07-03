`include "ch5/alu.sv"

module alu_tb();

    logic [31:0] a, b, result;
    logic [2:0] control;
    logic z, n, c, v;

    ALU alu_inst (
        .a(a),
        .b(b),
        .control(control),
        .result(result),
        .z(z),
        .n(n),
        .c(c),
        .v(v)
    );

    initial begin
        a = 32'h00000001; b = 32'h00000001; control = 3'b000; // ADD
        #10;
        a = 32'h00000002; b = 32'h00000001; control = 3'b001; // SUB
        #10;
        a = 32'h00000003; b = 32'h00000001; control = 3'b010; // AND
        #10;
        a = 32'h00000003; b = 32'h00000001; control = 3'b011; // OR
        #10;
        a = 32'h00000003; b = 32'h00000001; control = 3'b101; // SLT
        #10;

        // Test overflow
        a = 32'h7FFFFFFF; b = 32'h00000010; control = 3'b000;
        #10;

        // Test carry
        a = 32'hFFFFFFFF; b = 32'h00000010; control = 3'b000;
        #10;

        $finish;
    end

    initial begin
        $monitor("Time: %0t, A: %h, B: %h, Control: %b, Result: %h, Z: %b, N: %b, C: %b, V: %b",
                 $time, a, b, control, result, z, n, c, v);
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);
    end

endmodule