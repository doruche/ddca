`include "ch2/decoder8.sv"

module decoder8_tb();
    logic e3, e2n, e1n;
    logic [2:0] in;
    logic [7:0] outn;

    decoder8 uut (
        .e3(e3),
        .e2n(e2n),
        .e1n(e1n),
        .in(in),
        .outn(outn)
    );

    initial begin
        e3 = 1'b1; e2n = 1'b0; e1n = 1'b0;
        in = 3'b000; #10;
        assert(outn == 8'b1111_1110);

        in = 3'b001; #10;
        assert(outn == 8'b1111_1101);

        in = 3'b010; #10;
        assert(outn == 8'b1111_1011);

        in = 3'b011; #10;
        assert(outn == 8'b1111_0111);

        in = 3'b100; #10;
        assert(outn == 8'b1110_1111);

        in = 3'b101; #10;
        assert(outn == 8'b1101_1111);

        in = 3'b110; #10;
        assert(outn == 8'b1011_1111);

        in = 3'b111; #10;
        assert(outn == 8'b0111_1111);
    end

    initial begin
        $monitor("Time: %0t, e3: %b, e2n: %b, e1n: %b, in: %b, outn: %b", 
                 $time, e3, e2n, e1n, in, outn);
    end

endmodule