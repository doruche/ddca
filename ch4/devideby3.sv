module devideby3FSM (
    input logic clk,
    input logic reset,
    output logic y
);
    typedef enum logic [1:0] { S0, S1, S2 } state;
    state cur_state, next_state;

    // Asynchronous reset
    always_ff @( posedge clk, posedge reset ) begin
        if (reset) cur_state <= S0;
        else cur_state <= next_state;  
    end

    always_comb begin
        case (cur_state)
            S0: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S0;
            default: next_state = S0; // Default case to ensure synthesis tool generates combinational logic
        endcase
    end

    assign y = (cur_state == S0);
endmodule