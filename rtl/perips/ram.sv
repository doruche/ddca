import typepkg::*;

module ram (
    input logic clk,
    input logic [RAM_BITS-3:0] addr,
    input logic [31:0] wdata,
    input logic we,
    input logic [3:0] wstrb,
    output logic [31:0] rdata
);
    // logic [31:0] mem [0:2**(RAM_BITS-2)-1];
    logic [31:0] mem [RAM_BASE_ADDR>>2:RAM_END_ADDR>>2-1];

    assign rdata = mem[addr];

    always_ff @( posedge clk ) begin
        if (we) begin
            if(wstrb[0]) mem[addr][7:0] <= wdata[7:0];
            if(wstrb[1]) mem[addr][15:8] <= wdata[15:8];
            if(wstrb[2]) mem[addr][23:16] <= wdata[23:16];
            if(wstrb[3]) mem[addr][31:24] <= wdata[31:24];
        end
    end

    `ifdef BENCH
        initial begin
            $readmemh("tests/custom/hex/calc_ram.hex", mem);
        end
    `endif


endmodule

module rambus (
    input logic clk,
    input logic [31:0] addr,
    input logic [31:0] wdata,
    input logic re, we,
    input logic [3:0] wstrb,
    output logic [31:0] rdata
);
    logic [31:0] q;

    ram u_ram (
        .clk(clk),
        .addr(addr[RAM_BITS-1:2]),
        .wdata(wdata),
        .we(we),
        .wstrb(wstrb),
        .rdata(q)
    );

    always_comb begin
        if (addr >= RAM_BASE_ADDR && addr < RAM_END_ADDR && re)
            rdata = q;
        else rdata = 'x; 
    end

endmodule