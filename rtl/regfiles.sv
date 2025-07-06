module regfiles (
    input logic clk,
    input logic rst,
    input logic [4:0] ra1, ra2, wa3,
    input logic we,
    input logic [31:0] wd3,
    output logic [31:0] rd1, rd2
);
    logic [31:0] mem [31:0];

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (int i = 0; i < 32; i++) begin
                mem[i] <= 32'b0;
            end
        end else if (we && wa3 != 0) begin
            mem[wa3] <= wd3;
        end
    end

    assign rd1 = (ra1 == 0) ? 32'b0 : mem[ra1];
    assign rd2 = (ra2 == 0) ? 32'b0 : mem[ra2];


endmodule