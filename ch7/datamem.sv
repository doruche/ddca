module datamem #(
    parameter size = 4096
) (
    input logic clk, we3,
    input logic [31:0] ra1, ra2, wa3,
    input logic [31:0] wd3,
    output logic [31:0] rd1, rd2
);
    logic [7:0] mem [size-1:0];

    always_ff @( posedge clk ) begin
        if (we3) begin
            mem[wa3] <= wd3[7:0];
            mem[wa3+1] <= wd3[15:8];
            mem[wa3+2] <= wd3[23:16];
            mem[wa3+3] <= wd3[31:24];
        end
    end

    assign rd1 = {mem[ra1+3], mem[ra1+2], mem[ra1+1], mem[ra1]};
    assign rd2 = {mem[ra2+3], mem[ra2+2], mem[ra2+1], mem[ra2]};
endmodule