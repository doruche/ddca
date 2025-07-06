`include "rtl/core.sv"
`include "rtl/perips/mmodel.sv"

module rv32i_tb;
    logic clk;
    logic rst;

    // Memory model
    logic [31:0] insnmem_addr;
    logic [31:0] insnmem_data;

    logic [31:0] mem_addr;
    logic [31:0] mem_wdata;
    logic [31:0] mem_rdata_raw;
    logic mem_read_req;
    logic mem_write_req;
    logic [3:0] mem_byte_en;

    // Instantiate the memory model
    mmodel mmodel_inst (
        .clk(clk),
        .insnmem_addr(insnmem_addr),
        .insnmem_data(insnmem_data),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_rdata_raw(mem_rdata_raw),
        .mem_read_req(mem_read_req),
        .mem_write_req(mem_write_req),
        .mem_byte_en(mem_byte_en)
    );

    // Instantiate the core
    core core_inst (
        .clk(clk),
        .rst(rst),
        .insnmem_addr(insnmem_addr),
        .insnmem_data(insnmem_data),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_rdata_raw(mem_rdata_raw),
        .mem_read_req(mem_read_req),
        .mem_write_req(mem_write_req),
        .mem_byte_en(mem_byte_en)
    );

    generate
        genvar i;
        for (i = 0; i < 32; i++) begin
            initial begin
                $dumpvars(0, core_inst.u_regfiles.mem[i]);
            end
        end
    endgenerate

    initial begin
        $dumpfile("rv32i_tb.vcd");
        $dumpvars(0, rv32i_tb); 

        clk = 0;
        rst = 1; #10; rst = 0;

        repeat (1600) begin
            #5 clk = ~clk;
        end

        $display("final pc: %h", core_inst.cur_pc);

        $finish;
    end


endmodule