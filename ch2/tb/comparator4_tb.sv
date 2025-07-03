`include "ch2/comparator4.sv"

module comparator4_tb();
    logic [3:0] a, b;
    logic last_gt, last_eq, last_lt;
    logic gt, eq, lt;

    comp_4 dut (
        .a(a),
        .b(b),
        .last_gt(last_gt),
        .last_eq(last_eq),
        .last_lt(last_lt),
        .gt(gt),
        .eq(eq),
        .lt(lt)
    );

    initial begin
        // Test case 1: a < b
        a = 4'b0010; b = 4'b0100; last_gt = 0; last_eq = 1; last_lt = 0;
        #10;
        assert (gt == 0 && eq == 0 && lt == 1);

        // Test case 2: a > b
        a = 4'b0100; b = 4'b0010; last_gt = 0; last_eq = 1; last_lt = 0;
        #10;
        assert (gt == 1 && eq == 0 && lt == 0);

        // Test case 3: a == b
        a = 4'b0011; b = 4'b0011; last_gt = 1; last_eq = 0; last_lt = 0;
        #10;
        assert (gt == 1 && eq == 0 && lt == 0); 

        // Test case 4: a < b with previous state
        a = 4'b0001; b = 4'b0010; last_gt = 1; last_eq = 0; last_lt = 0;
        #10;
        assert (gt == 0 && eq == 0 && lt == 1);

        // Test case 5: a > b with previous state
        a = 4'b0101; b = 4'b0011; last_gt = 1; last_eq = 0; last_lt = 0;
        #10;
        assert (gt == 1 && eq == 0 && lt == 0);
    end
endmodule