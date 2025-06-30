// CD4532

module pri_encoder8 (
    input logic [7:0] in,
    input logic ei,
    output logic [2:0] out,
    output logic eo, gs
);
    always_comb begin
        if (ei == 0) begin
            out = 3'b000;
            eo = 1'b0;
            gs = 1'b0;
        end else begin
            if (in == 8'b0000_0000) begin
                out = 3'b000;
                eo = 1'b1;
                gs = 1'b0;
            end else begin
                eo = 1'b0;
                gs = 1'b1;
                casez (in)
                    8'b1???????: out = 3'b111;
                    8'b01??????: out = 3'b110;
                    8'b001?????: out = 3'b101;
                    8'b0001????: out = 3'b100;
                    8'b00001???: out = 3'b011;
                    8'b000001??: out = 3'b010;
                    8'b0000001?: out = 3'b001;
                    8'b00000001: out = 3'b000;
                endcase
            end
            // end else if (in[7]) begin
            //     out = 3'b111;
            //     eo = 1'b0;
            //     gs = 1'b1;
            // end else if (in[6]) begin
            //     out = 3'b110;
            //     eo = 1'b0;
            //     gs = 1'b1;
            // end else if (in[5]) begin
            //     out = 3'b101;
            //     eo = 1'b0;
            //     gs = 1'b1;
            // end else if (in[4]) begin
            //     out = 3'b100;
            //     eo = 1'b0;
            //     gs = 1'b1;
            // end else if (in[3]) begin
            //     out = 3'b011;
            //     eo = 1'b0;
            //     gs = 1'b1;
            // end else if (in[2]) begin
            //     out = 3'b010;
            //     eo = 1'b0;
            //     gs = 1'b1;
            // end else if (in[1]) begin
            //     out = 3'b001;
            //     eo = 1'b0;
            //     gs = 1'b1;
            // end
        end
    end
endmodule