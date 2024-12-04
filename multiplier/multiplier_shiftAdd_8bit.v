`define M ACC[0]

module multiplier_shiftAdd_8bit(
    input Clk,
    input St,
    input [7:0] Mplier,
    input [7:0] Mcand,
    output Done,
    output [15:0] Result
);

    reg [4:0] State;
    reg [16:0] ACC;

    initial begin
        State = 0;
        ACC   = 0;
    end

    always @(posedge Clk)
    begin
        case (State)
            0: begin
                if (St == 1'b1) begin
                    ACC[16:8] <= 9'b000000000;  // Reset upper part of ACC
                    ACC[7:0] <= Mplier;         // Load Mplier to lower part of ACC
                    State <= 1;                 // Move to state 1
                end
            end
            1, 3, 5, 7, 9, 11, 13, 15: begin
                if (`M == 1'b1) begin
                    ACC[16:8] <= {1'b0, ACC[15:8]} + Mcand; // Add Mcand to upper part of ACC
                    State <= State + 1;
                end
                else begin
                    ACC <= {1'b0, ACC[16:1]};
                    State <= State + 2;
                end
            end 
            2, 4, 6, 8, 10, 12, 14, 16: begin
                ACC <= {1'b0, ACC[16:1]}; // Shift ACC right
                State <= State + 1;
            end
            17: begin
                State <= 0;          // Return to initial state
            end
        endcase
    end

    assign Done = (State == 17) ? 1'b1 : 1'b0;
    assign Result = (State == 17) ? ACC[15:0] : 16'b0;

endmodule 