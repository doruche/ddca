`include "ch4/devideby3.sv"

module devideby3_tb();
    logic clk;
    logic reset;
    logic y;

    // Instantiate the device under test (DUT)
    devideby3FSM dut (
        .clk(clk),
        .reset(reset),
        .y(y)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test sequence
    initial begin
        reset = 1; // Assert reset
        #1 reset = 0; // Deassert reset after 10 time units

        // Wait for a few clock cycles to observe the output
        #150;

        // Finish simulation
        $finish;
    end

    // Monitor output
    initial begin 
        $dumpfile("devideby3_tb.vcd");
        $dumpvars(0, devideby3_tb);

        $monitor("Time: %0t, Reset: %b, Output y: %b", $time, reset, y);
    end

endmodule