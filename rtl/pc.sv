import typepkg::*;

module pc (
    input logic clk, rst,
    input logic should_stall,
    input logic [31:0] next_pc,
    output logic [31:0] cur_pc
);
    always_ff @( posedge clk or posedge rst ) begin
        if (rst) begin
            cur_pc <= PC_RST_VAL;
        end else if (~should_stall) begin
            cur_pc <= next_pc;
        end
    end
endmodule