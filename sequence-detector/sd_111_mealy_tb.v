module sd_111_mealy_tb;
    reg clk;
    reg reset;
    reg din;
    wire dout;
    wire [2:0] led;
    
    // Instansiasi modul DUT
    sd_111_mealy uut (
        .clk(clk),
        .reset(reset),
        .din(din),
        .dout(dout),
        .led(led)
    );
    
    // Clock generator
    always #5 clk = ~clk;
    
    // Proses uji
    initial begin
        clk = 0;
        reset = 1;
        din = 0;
        
        // Reset sistem
        #10; reset = 0;
        
        // Uji pola 101
        #10; din = 1;  
        #10; din = 0;  
        #10; din = 1;  
        #10; din = 1;
        #10; din = 1;
        #10; din = 1;
        #10; din = 0;
        #10; din = 1;
        #10; din = 1;
        #10; din = 1;
        #10; din = 0;
        
        // Selesai
        #10;
        $stop;
    end

endmodule 