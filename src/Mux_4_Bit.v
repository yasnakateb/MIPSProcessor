module Mux_4_Bit( 
  input_0,
  input_1,
  input_2,
  input_3,
  selector,
  mux_Out
  );

  parameter DATA_WIDTH = 32;
  input [DATA_WIDTH -1:0] input_0;               
  input [DATA_WIDTH -1:0] input_1;  
  input [DATA_WIDTH -1:0] input_2;               
  input [DATA_WIDTH -1:0] input_3;                
  input [1:0]selector;              
  output reg [DATA_WIDTH -1:0] mux_Out;
                     
  always @ (*) begin
    case (selector)
      2'b00 : 
        mux_Out = input_0;
      2'b01 : 
        mux_Out = input_1;
      2'b10 : 
        mux_Out = input_2;
      2'b11 : 
        mux_Out = input_3;
      default : 
        mux_Out = 32'bx; 
    endcase
  end
    
endmodule

