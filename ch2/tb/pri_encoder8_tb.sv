`include "ch2/pri_encoder8.sv"

module pri_encoder8_tb();

    logic [7:0] in;
    logic ei;
    logic [2:0] out;
    logic eo, gs;

    pri_encoder8 uut (
        .in(in),
        .ei(ei),
        .out(out),
        .eo(eo),
        .gs(gs)
    );

    initial begin
        ei = 0;
        // Nothing should happen
        in = 8'b00111010;
        #10;

        // Test case 1: Normal operation with ei = 1
        ei = 1;
        in = 8'b0000_0001; // Expect out = 3'b000, eo = 0, gs = 1
        #10;
        
        // Test case 2: Normal operation with ei = 1
        in = 8'b0000_0010; // Expect out = 3'b001, eo = 0, gs = 1
        #10;

        // Test case 3: Normal operation with ei = 1
        in = 8'b0000_0100; // Expect out = 3'b010, eo = 0, gs = 1
        #10;

        // Test case 4: Normal operation with ei = 1
        in = 8'b0000_1000; // Expect out = 3'b011, eo = 0, gs = 1
        #10;

        // Test case 5: Normal operation with ei = 1
        in = 8'b0001_0000; // Expect out = 3'b100, eo = 0, gs = 1
        #10;

        // Test case 6: Normal operation with ei = 1
        in = 8'b0010_0000; // Expect out = 3'b101, eo = 0, gs = 1
        #10;

        // Test case 7: Normal operation with ei = 1
        in = 8'b0100_0000; // Expect out = 3'b110, eo = 0, gs = 1
        #10;

        // Test case 8: Normal operation with ei = 1
        in = 8'b1000_0000; // Expect out = 3'b111, eo = 0, gs = 1
        #10;

        // Test case for all zeros with ei=1
        in = 8'b0000_0000; // Expect out = 3'b000, eo = 1, gs = 0
        #10;

        in = 8'b1010_0010;
        #10;

        in = 8'b0111_0100;
        #10;

        $finish;        
    end

    initial begin
        $monitor("Time: %0t, in: %b, ei: %b, out: %b, eo: %b, gs: %b", 
                 $time, in, ei, out, eo, gs);
    end

endmodule