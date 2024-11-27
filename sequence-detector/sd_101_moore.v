// Sequence detector 101 using moore state non overlapping

module sd_101_moore(
    input wire clk,  
    input wire reset, 
    input wire data_in,  
    output reg detect
);

    // State declaration
    parameter S0 = 2'b00;
    parameter S1 = 2'b01; 
    parameter S2 = 2'b10;
    parameter S3 = 2'b11; 
    
    reg [1:0] current_state, next_state;
    
    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) 
            current_state <= S0;
        else
            current_state <= next_state;
    end
    
    // Next state logic
    always @(*) begin
        case (current_state)
            S0: begin
                if (data_in)
                    next_state = S1; 
                else
                    next_state = S0; 
                detect = 0;
            end
            
            S1: begin
                if (data_in)
                    next_state = S1;
                else
                    next_state = S2;
                detect = 0;   
            end

            S2: begin
                if (data_in)
                    next_state = S3;  
                else
                    next_state = S0;
                detect = 0;   
            end

            S3: begin
                if (data_in)
                    next_state = S1;
                else
                    next_state = S0;
                detect = 1; 
            end

            default: begin
                next_state = S0;
                detect = 0;
            end
        endcase
    end
 
endmodule 