module insnmem #(
    parameter size = 4096
) (
    input logic [7:0] a,
    output logic [31:0] rd
);
    logic [7:0] mem [size-1:0];
    
    assign rd = {mem[a+3], mem[a+2], mem[a+1], mem[a]};
endmodule