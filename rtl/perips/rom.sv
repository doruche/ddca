import typepkg::*;

module rom (
    input logic clk,
    input logic [ROM_BITS-3:0] addr,
    output logic [31:0] data
);
    // logic [31:0] mem [0:2**(ROM_BITS-2)-1];
    (* nomem2reg *)
    logic [31:0] mem [ROM_BASE_ADDR>>2:ROM_END_ADDR>>2-1];

    assign data = mem[addr];

    `ifdef BENCH
    generate
        genvar i;
        initial begin
            $readmemh(`ROM_HEX, mem);
        end
    endgenerate
    `endif
endmodule

module rombus (
    input logic clk,
    input logic [31:0] addr,
    output logic [31:0] data
);
    logic [31:0] q;

    rom u_rom (
        .clk(clk),
        .addr(addr[ROM_BITS-1:2]),
        .data(q)
    );

    always_comb begin
        if (addr >= ROM_BASE_ADDR && addr < ROM_END_ADDR) begin
            data = q;
        end else data = 'x;
    end

endmodule