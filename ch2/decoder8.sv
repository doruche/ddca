// 74LS138 3-to-8 Decoder
module decoder8 (
    input logic e3, e2n, e1n,
    input logic [2:0] in,
    output logic [7:0] outn
);
    always_comb begin
        if (e3 == 1'b0 || e2n == 1'b1 || e1n == 1'b1) begin
            outn = 8'b1111_1111;
        end else begin
            case (in)
                8'b000: outn = 8'b1111_1110;
                8'b001: outn = 8'b1111_1101;
                8'b010: outn = 8'b1111_1011;
                8'b011: outn = 8'b1111_0111;
                8'b100: outn = 8'b1110_1111;
                8'b101: outn = 8'b1101_1111;
                8'b110: outn = 8'b1011_1111;
                8'b111: outn = 8'b0111_1111; 
            endcase
        end
    end
endmodule