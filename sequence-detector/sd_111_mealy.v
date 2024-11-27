module sd_111_mealy(
    input clk,
    input reset,
    input din,
    output reg dout,
    output reg [2:0] led
);

    // Definisi state sebagai parameter
    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;
    
    reg [1:0] current_state, next_state;
    
    // Transisi state dan pengaturan nilai led pada clock edge
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
            led <= 3'b000; 
            dout <= 0;
        end else begin
            current_state <= next_state;
            // Set led dan dout berdasarkan kondisi state dan din
            if (current_state == S2 && din == 1) begin
                led <= 3'b111;
                dout <= 1;  
            end else begin
                led <= 3'b000;
                dout <= 0;
            end
        end
    end
    
    // Logika next state
    always @(*) begin
        case (current_state)
            S0: begin
                if (din == 1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (din == 1)
                    next_state = S2;
                else
                    next_state = S0;
            end
            S2: begin
                if (din == 1) begin
                    next_state = S2;
                end else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

endmodule 