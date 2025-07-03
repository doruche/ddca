// 74LS85
module comp_4 (
    input logic [3:0] a, b,
    input logic last_gt, last_eq, last_lt,
    output logic gt, eq, lt
);
    always_comb begin
        if (a > b) begin
            gt = 1; eq = 0; lt = 0;
        end else if (a < b) begin
            gt = 0; eq = 0; lt = 1;
        end else begin
            gt = last_gt;
            eq = last_eq;
            lt = last_lt;
        end
    end
endmodule