module sd_0110_mealy(
    input clk,
    input reset,
    input din,
    output reg dout
);

    // Definisi state sebagai parameter
    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;
    parameter S3 = 2'b11;
    
    reg [1:0] current_state, next_state;
    
    // Transisi state dan pengaturan nilai led pada clock edge
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
            dout <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == S3 && din == 0) begin
                dout <= 1;  
            end else begin
                dout <= 0;
            end
        end
    end
    
    // Logika next state
    always @(*) begin
        case (current_state)
            S0: begin
                if (din == 0)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (din == 1)
                    next_state = S2;
                else
                    next_state = S1;
                end
            S2: begin
                if (din == 1)
                    next_state = S3;
                else
                    next_state = S1;
            end
            S3: begin
                if (din == 0)
                    next_state = S1;
                else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

endmodule 