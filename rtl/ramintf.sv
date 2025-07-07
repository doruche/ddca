import typepkg::*;

// RAM Interface of the processor
module ramintf (
    // signals used by the processor
    input logic clk,
    input logic re,
    input mem_fmt_t fmt,
    input logic [31:0] addr,
    input logic [31:0] wdata,
    output logic [31:0] rdata,

    // ports connected to rambus
    output logic [31:0] bus_addr,
    input logic [31:0] bus_rdata,
    output logic bus_re, bus_we,
    output logic [3:0] bus_wstrb,
    output logic [31:0] bus_wdata
);
    logic [31:0] pos_fixed_rdata;
    logic [31:0] sign_fixed_rdata;

    assign bus_addr = addr;
    assign bus_re = re;
    assign bus_we = (fmt.width != NONE);

    // spec demands that the alignments must be multiple of the width,
    // and we should raise an exception if not.
    // we have no privilege architecture, so just ignore the misaligned accesses.
    always @(*) begin
        case (fmt.width)
            NONE: bus_wstrb = 4'b0000;
            BYTE: bus_wstrb = 4'b0001 << (addr[1:0]);
            HALF: bus_wstrb = 4'b0011 << (addr[1:0]);
            WORD: bus_wstrb = 4'b1111 << (addr[1:0]);
        endcase
    end
    assign bus_wdata = wdata << (addr[1:0] * 8);

    assign pos_fixed_rdata = bus_rdata >> (addr[1:0] * 8);

    always @(*) begin
        case (fmt.width)
            NONE:   sign_fixed_rdata = 'x;
            BYTE:   sign_fixed_rdata = {{24{fmt.is_signed & pos_fixed_rdata[7]}}, pos_fixed_rdata[7:0]};
            HALF:   sign_fixed_rdata = {{16{fmt.is_signed & pos_fixed_rdata[15]}}, pos_fixed_rdata[15:0]};
            WORD:   sign_fixed_rdata = pos_fixed_rdata;
        endcase
    end

    assign rdata = sign_fixed_rdata;
endmodule