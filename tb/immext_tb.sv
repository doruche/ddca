`include "rtl/immext.sv"
import typepkg::*;

module immext_tb;
    logic [31:0] insn;
    logic [31:0] imm;

    // Instantiate the immext module
    immext uut (
        .insn(insn),
        .imm(imm)
    );

    initial begin
        // I-type
        insn = 32'h14d28393; // addi x7, x5, 333
        #10;
        assert (imm == 333); 

        insn = 32'hfd634f93; // xori x31, x6, -42
        #10;
        assert (imm == -42);

        // U-type
        insn = 32'h00309497; // auipc x9, 777
        #10;
        assert (imm[31:12] == 777);

        insn = 32'hff806237; // lui x4, -2042
        #10;
        assert ($signed(imm[31:12]) == -2042);

        // S-type
        insn = 32'h14a0a0a3; // sw x10, 321(x1)
        #10;
        assert (imm == 321);

        insn = 32'hf43ea7a3; // sw x3, -177(x29)
        #10;
        assert (imm == -177);
        
        // B-type
        insn = 32'h3e831363; // bne x6, x8, 998
        #10;
        assert (imm == 998);

        insn = 32'h9841cae3; // blt x3, x4, -1644
        #10;
        assert (imm == -1644);

        // J-type
        insn = 32'h084003ef; // jal x7, 132
        #10;
        assert (imm == 132);

        insn = 32'hb2fff7ef; // jal x15, -1234
        #10;
        assert (imm == -1234);

        insn = 32'hff1ff4ef; // jal x9, -16
        #10;
        assert (imm == -16);

        $finish;
    end
endmodule