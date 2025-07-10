`include "rtl/alu.sv"
import typepkg::*;

module alu_tb;
    logic [31:0] operand_a;
    logic [31:0] operand_b;
    alu_op_t alu_op;
    logic [31:0] result;
    logic alu_zero;
    logic alu_less;
    logic alu_uless;

    // Instantiate the ALU
    alu alu_inst (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .alu_op(alu_op),
        .result(result),
        .alu_zero(alu_zero),
        .alu_less(alu_less),
        .alu_uless(alu_uless)
    );

    initial begin
        // add
        $display("alu_tb: add tests");
        alu_op = ALU_OP_ADD;

        operand_a = 32'h00000001;
        operand_b = 32'h00000002;
        #10;
        assert (result == operand_a + operand_b); 

        operand_a = 32'h00101010;
        operand_b = 32'h01101001;
        #10;
        assert (result == operand_a + operand_b);

        operand_a = 32'hFFFFFFFF;
        operand_b = 32'h00000001;
        #10;
        assert (result == operand_a + operand_b);

        operand_a = 32'h80000000;
        operand_b = 32'h80000000;
        #10;
        assert (result == operand_a + operand_b);

        operand_a = 32'h12345678;
        operand_b = 32'h87654321;
        #10;
        assert (result == operand_a + operand_b);

        operand_a = 32'h93827164;
        operand_b = 32'h34353637;
        #10;
        assert (result == operand_a + operand_b);

        // sub
        $display("alu_tb: sub tests");
        alu_op = ALU_OP_SUB;

        operand_a = 32'h00000003;
        operand_b = 32'h00000001;
        #10;
        assert (result == operand_a - operand_b);

        operand_a = 32'h00000000;
        operand_b = 32'h00000001;
        #10;
        assert (result == operand_a - operand_b);

        operand_a = 32'h12345678;
        operand_b = 32'h87654321;
        #10;
        assert (result == operand_a - operand_b);

        operand_a = 32'h80000000;
        operand_b = 32'h80000000;
        #10;
        assert (result == operand_a - operand_b);

        // and tests
        $display("alu_tb: and tests");
        alu_op = ALU_OP_AND;

        operand_a = 32'hFFFFFFFF;
        operand_b = 32'h00000000;
        #10;
        assert (result == (operand_a & operand_b));

        operand_a = 32'h12345678;
        operand_b = 32'h87654321;
        #10;
        assert (result == (operand_a & operand_b));

        operand_a = 32'hFFFF0000;
        operand_b = 32'h0000FFFF;
        #10;
        assert (result == (operand_a & operand_b));

        // or tests
        $display("alu_tb: or tests");
        alu_op = ALU_OP_OR;

        operand_a = 32'hFFFFFFFF;
        operand_b = 32'h00000000;
        #10;
        assert (result == (operand_a | operand_b));

        operand_a = 32'h12345678;
        operand_b = 32'h87654321;
        #10;
        assert (result == (operand_a | operand_b));

        operand_a = 32'hFFFF0000;
        operand_b = 32'h0000FFFF;
        #10;
        assert (result == (operand_a | operand_b));

        // xor tests
        $display("alu_tb: xor tests");
        alu_op = ALU_OP_XOR;

        operand_a = 32'hFFFFFFFF;
        operand_b = 32'h00000000;
        #10;
        assert (result == (operand_a ^ operand_b));

        operand_a = 32'h12345678;
        operand_b = 32'h87654321;
        #10;
        assert (result == (operand_a ^ operand_b));

        operand_a = 32'hFFFF0000;
        operand_b = 32'h0000FFFF;
        #10;
        assert (result == (operand_a ^ operand_b));

        // sll tests
        $display("alu_tb: sll tests");
        alu_op = ALU_OP_SLL;

        operand_a = 32'h00000001;
        operand_b = 32'h00000002;
        #10;
        assert (result == (operand_a << operand_b[4:0]));

        operand_a = 32'h00000004;
        operand_b = 32'h00000001;
        #10;
        assert (result == (operand_a << operand_b[4:0]));

        operand_a = 32'h80000000;
        operand_b = 32'h00000001;
        #10;
        assert (result == (operand_a << operand_b[4:0]));

        // srl tests
        $display("alu_tb: srl tests");
        alu_op = ALU_OP_SRL;

        operand_a = 32'h00000004;
        operand_b = 32'h00000001;
        #10;
        assert (result == (operand_a >> operand_b[4:0]));

        operand_a = 32'h80000000;
        operand_b = 32'h00000001;
        #10;
        assert (result == (operand_a >> operand_b[4:0]));

        operand_a = 32'hFFFFFFFF;
        operand_b = 32'h00000001;
        #10;
        assert (result == (operand_a >> operand_b[4:0]));

        // sra tests
        $display("alu_tb: sra tests");
        alu_op = ALU_OP_SRA;

        operand_a = 32'hFFFFFFFF;
        operand_b = 32'h00000001;
        #10;
        assert (result == 32'hFFFFFFFF);

        operand_a = 32'h80000000;
        operand_b = 32'h00000001;
        #10;
        assert (result == 32'hC0000000);
        
        operand_a = 32'hffff1000;
        operand_b = 32'h00000002;
        #10;
        assert (result == 32'hFFFFC400);

        // slt tests
        $display("alu_tb: slt tests");
        alu_op = ALU_OP_SLT;

        operand_a = 32'h00000001;
        operand_b = 32'h00000002;
        #10;
        assert (result == 32'h00000001 && alu_less == 1'b1);

        operand_a = 32'h00000002;
        operand_b = 32'h00000001;
        #10;
        assert (result == 32'h00000000 && alu_less == 1'b0);

        operand_a = 32'hFFFFFFFF;
        operand_b = 32'h00000001;
        #10;
        assert (result == 32'h00000001 && alu_less == 1'b1);

        // sltu tests
        $display("alu_tb: sltu tests");
        alu_op = ALU_OP_SLTU;

        operand_a = 32'h00000001;
        operand_b = 32'h00000002;
        #10;
        assert (result == 32'h00000001 && alu_uless == 1'b1);

        operand_a = 32'h00000002;
        operand_b = 32'h00000001;
        #10;
        assert (result == 32'h00000000 && alu_uless == 1'b0);

        operand_a = 32'hFFFFFFFF;
        operand_b = 32'h00000001;
        #10;
        assert (result == 32'h00000000 && alu_uless == 1'b0);

        // copy A tests
        $display("alu_tb: copy A tests");
        alu_op = ALU_OP_COPY_A;

        operand_a = 32'h00000001;
        operand_b = 32'h00000000;
        #10;
        assert (result == operand_a);

        operand_a = 32'hFFFFFFFF;
        operand_b = 32'h00000000;
        #10;
        assert (result == operand_a);

        $display("alu_tb: all tests passed");
        $finish;
    end

    initial begin
        $monitor(">>>\ttime: %0t, a: %h, b: %h, op: %b, result: %h, zero: %b, less: %b, uless: %b",
                 $time, operand_a, operand_b, alu_op, result, alu_zero, alu_less, alu_uless);
    end
endmodule