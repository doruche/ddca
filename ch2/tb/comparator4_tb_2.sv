`include "ch2/comparator4.sv"

module comparator4_tb_2();
    // create a 8-bit comparator
    logic [7:0] a, b;
    logic low_t, low_eq, low_lt;
    logic gt, eq, lt;

    comp_4 high (
        .a(a[7:4]),
        .b(b[7:4]),
        .last_gt(low_gt),
        .last_eq(low_eq),
        .last_lt(low_lt),
        .gt(gt),
        .eq(eq),
        .lt(lt)
    );

    comp_4 low (
        .a(a[3:0]),
        .b(b[3:0]),
        .last_gt(1'b0),
        .last_eq(1'b1),
        .last_lt(1'b0),
        .gt(low_gt),
        .eq(low_eq),
        .lt(low_lt)
    );

    initial begin
        a = 8'b1001_1111; b = 8'b0111_1111; #5;
        assert (gt == 1 && eq == 0 && lt == 0);

        a = 8'b0111_1111; b = 8'b1001_1111; #5;
        assert (gt == 0 && eq == 0 && lt == 1);

        a = 8'b0101_1100; b = 8'b0101_0111; #5;
        assert (gt == 1 && eq == 0 && lt == 0);

        a = 8'b0101_0101; b = 8'b0101_0101; #5;
        assert (gt == 0 && eq == 1 && lt == 0);
    
        $finish;
    end

    initial begin
        $monitor("At time %t: a = %b, b = %b, gt = %b, eq = %b, lt = %b",
                  $time, a, b, gt, eq, lt);
    end

endmodule