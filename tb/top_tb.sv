`include "rtl/top.sv"

module top_tb;

    logic clk;
    logic rst;

    top u_top (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 0;
        rst = 1; #5; rst = 0; #5;

        repeat (400) begin
            clk = ~clk; #5;
        end
    end

    generate
        genvar i;
        for (i = 0; i < 32;  i++) begin
            initial begin
                $dumpfile("tb/target/top_tb.vcd");
                $dumpvars(0, u_top.u_core.u_datapath.u_regfiles.mem[i]);
            end
        end
    endgenerate

    initial begin
        $dumpfile("tb/target/top_tb.vcd");
        $dumpvars(0, top_tb);
    end

endmodule