`include "ch2/encoder8.sv"

module encoder8_tb();
    logic [7:0] in;
    logic [2:0] out;
    logic valid;

    encoder8 dut (
        .in(in),
        .out(out),
        .valid(valid)
    );

    initial begin
        in = 8'b0000_0000;
        #10;
        assert (out === 3'bx && valid === 1'bx);

        in = 8'b0000_0001;
        #10;
        assert (out == 3'b000 && valid == 1'b1);

        in = 8'b0000_0010;
        #10;
        assert (out == 3'b001 && valid == 1'b1);

        in = 8'b0000_0100;
        #10;
        assert (out == 3'b010 && valid == 1'b1);

        in = 8'b0000_1000;
        #10;
        assert (out == 3'b011 && valid == 1'b1);

        in = 8'b0001_0000;
        #10;
        assert (out == 3'b100 && valid == 1'b1);

        in = 8'b0010_0000;
        #10;
        assert (out == 3'b101 && valid == 1'b1);

        in = 8'b0100_0000;
        #10;
        assert (out == 3'b110 && valid == 1'b1);

        in = 8'b1000_0000;
        #10;
        assert (out == 3'b111 && valid == 1'b1);

        in = 8'b0001_0001;
        #10;
        assert (out === 3'bx && valid === 1'b1);
    end

endmodule