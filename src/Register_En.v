module Register_En( 
    clock,
    enable,
    in,
    out
    );

    input clock;
    input enable;
    input [31:0] in;
    output  [31:0] out;
    
    reg [31:0] out;
    initial begin 
        out = 0; 
    end 
    
    always @ (clock) begin
        if (enable ==1'b1)
            out <= in;  
    end 
        
endmodule 
