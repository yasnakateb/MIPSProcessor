module Register( 
    clock,
    in,
    out
    );
      
    input clock;
    input [31:0] in;
    output  [31:0]out;
    
    reg [31:0] out ;
    always @ (*) begin
        out <= in;  
    end
    
endmodule 
