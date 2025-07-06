`include "ch7/insnmem.sv"

module insnmem_tb();
    logic [7:0] addr;
    logic [31:0] data;

    insnmem #(
        .size(4096)
    ) uut (
        .a(addr),
        .rd(data)
    );

    initial begin
        // Initialize memory with some test instructions
        uut.mem[0] = 8'h00; // NOP
        uut.mem[1] = 8'h00;
        uut.mem[2] = 8'h00;
        uut.mem[3] = 8'h00;

        uut.mem[4] = 8'h01;
        uut.mem[5] = 8'h02;
        uut.mem[6] = 8'h03;
        uut.mem[7] = 8'h04;

        // Test reading from address 0
        addr = 8'h00;
        #10;
        assert(data == 32'h00000000) else $error("Test failed at address 0");

        // Test reading from address 4
        addr = 8'h04;
        #10;
        assert(data == 32'h04030201) else $error("Test failed at address 4");

        $finish;
    end

endmodule