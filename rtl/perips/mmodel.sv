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
    localparam MEM_SIZE = 8192;
    
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
        
        // $readmemh("tests/custom/hex/calc.hex", mem);
        
        // $readmemh("tests/isa/rv32ui-p-simple.verilog", mem);

        // $readmemh("tests/isa/rv32ui-p-addi.verilog", mem);
        // $readmemh("tests/isa/rv32ui-p-slli.verilog", mem);
        // $readmemh("tests/isa/rv32ui-p-slti.verilog", mem);
        // $readmemh("tests/isa/rv32ui-p-sltiu.verilog", mem);
        // $readmemh("tests/isa/rv32ui-p-xori.verilog", mem);
        // $readmemh("tests/isa/rv32ui-p-ori.verilog", mem);
        // $readmemh("tests/isa/rv32ui-p-andi.verilog", mem);
        // $readmemh("tests/isa/rv32ui-p-srli.verilog", mem);
        // $readmemh("tests/isa/rv32ui-p-srai.verilog", mem);

        // $readmemh("tests/isa/rv32ui-p-add.verilog", mem);
        // $readmemh("tests/isa/rv32ui-p-sub.verilog", mem); $display("expected final pc: 0x000004dc");
        // $readmemh("tests/isa/rv32ui-p-sll.verilog", mem); $display("expected final pc: 0x0000056c");
        // $readmemh("tests/isa/rv32ui-p-slt.verilog", mem); $display("expected final pc: 0x000004e4");
        // $readmemh("tests/isa/rv32ui-p-sltu.verilog", mem); $display("expected final pc: 0x000004e4");
        // $readmemh("tests/isa/rv32ui-p-xor.verilog", mem); $display("expected final pc: 0x000004dc");
        // $readmemh("tests/isa/rv32ui-p-srl.verilog", mem); $display("expected final pc: 0x000005a0");
        // $readmemh("tests/isa/rv32ui-p-sra.verilog", mem); $display("expected final pc: 0x000005b8");
        // $readmemh("tests/isa/rv32ui-p-or.verilog", mem); $display("expected final pc: 0x000004e0");
        // $readmemh("tests/isa/rv32ui-p-and.verilog", mem); $display("expected final pc: 0x000004d4");

        // $readmemh("tests/isa/rv32ui-p-lb.verilog", mem); $display("expected final pc: 0x00000268");
        // $readmemh("tests/isa/rv32ui-p-lh.verilog", mem); $display("expected final pc: 0x00000288");
        // $readmemh("tests/isa/rv32ui-p-lw.verilog", mem); $display("expected final pc: 0x000002a8");
        // $readmemh("tests/isa/rv32ui-p-lbu.verilog", mem); $display("expected final pc: 0x00000268");
        // $readmemh("tests/isa/rv32ui-p-lhu.verilog", mem); $display("expected final pc: 0x0000029c");

        // $readmemh("tests/isa/rv32ui-p-sb.verilog", mem); $display("expected final pc: 0x00000410");
        // $readmemh("tests/isa/rv32ui-p-sh.verilog", mem); $display("expected final pc: 0x00000494");
        // $readmemh("tests/isa/rv32ui-p-sw.verilog", mem); $display("expected final pc: 0x000004a0");

        // $readmemh("tests/isa/rv32ui-p-auipc.verilog", mem); $display("expected final pc: 0x00000060");
        // $readmemh("tests/isa/rv32ui-p-lui.verilog", mem); $display("expected final pc: 0x0000007c");

        // $readmemh("tests/isa/rv32ui-p-beq.verilog", mem); $display("expected final pc: 0x000002dc");
        // $readmemh("tests/isa/rv32ui-p-bne.verilog", mem); $display("expected final pc: 0x000002e0");
        // $readmemh("tests/isa/rv32ui-p-blt.verilog", mem); $display("expected final pc: 0x000002dc");
        // $readmemh("tests/isa/rv32ui-p-bge.verilog", mem); $display("expected final pc: 0x0000033c");
        // $readmemh("tests/isa/rv32ui-p-bltu.verilog", mem); $display("expected final pc: 0x00000310");
        // $readmemh("tests/isa/rv32ui-p-bgeu.verilog", mem); $display("expected final pc: 0x00000370");

        // $readmemh("tests/isa/rv32ui-p-jal.verilog", mem); $display("expected final pc: 0x00000070");
        // $readmemh("tests/isa/rv32ui-p-jalr.verilog", mem); $display("expected final pc: 0x000000f0");

        // $readmemh("tests/isa/rv32ui-p-fence_i.verilog", mem); $display("expected final pc: 0x000000ec");

        end
    `endif

endmodule