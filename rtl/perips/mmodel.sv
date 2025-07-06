import typepkg::*;

module mmodel (
    input logic clk,

    input logic [31:0] insnmem_addr,
    output logic [31:0] insnmem_data,

    input logic [31:0] mem_addr,
    input logic [31:0] mem_wdata,
    output logic [31:0] mem_rdata_raw,

    input logic mem_read_req,
    input logic mem_write_req,
    input logic [3:0] mem_byte_en
);
    localparam MEM_SIZE = 4096;
    
    logic [7:0] mem [0: MEM_SIZE-1];

    logic [31:0] temp_rdata;

    assign insnmem_data = {
        mem[insnmem_addr+3], 
        mem[insnmem_addr+2], 
        mem[insnmem_addr+1], 
        mem[insnmem_addr]
    };

    // data memory read
    always @(*) begin
        // mem_rdata_raw = BAD_VAL;
        temp_rdata = BAD_VAL;
        if (mem_read_req) begin
            if (mem_addr < MEM_SIZE) begin
                if (mem_byte_en[0]) temp_rdata[7:0] = mem[mem_addr];
                if (mem_byte_en[1]) temp_rdata[15:8] = mem[mem_addr+1];
                if (mem_byte_en[2]) temp_rdata[23:16] = mem[mem_addr+2];
                if (mem_byte_en[3]) temp_rdata[31:24] = mem[mem_addr+3];
            end else begin
                `ifdef BENCH
                    $error("mmodel.sv: memory read out of bounds: %0h", mem_addr);
                `endif
            end
        end
        mem_rdata_raw = temp_rdata;
    end

    // data memory write
    always_ff @( posedge clk ) begin
        if (mem_write_req) begin
            if (mem_byte_en[0]) mem[mem_addr] <= mem_wdata[7:0];
            if (mem_byte_en[1]) mem[mem_addr+1] <= mem_wdata[15:8];
            if (mem_byte_en[2]) mem[mem_addr+2] <= mem_wdata[23:16];
            if (mem_byte_en[3]) mem[mem_addr+3] <= mem_wdata[31:24];
        end
    end

    `ifdef BENCH
        initial begin
        
        $readmemh("tests/custom/hex/calc.hex", mem);
        
        // $readmemh("tests/isa/rv32ui-p-imple.verilog", mem);

        end
    `endif

endmodule