module Mux_2_Bit(
    input_0,
    input_1,
    selector,
    mux_Out
    );

    parameter DATA_WIDTH = 32;
    input [DATA_WIDTH -1:0] input_0;               
    input [DATA_WIDTH -1:0] input_1;                
    input selector;              
    output reg [DATA_WIDTH -1:0] mux_Out;
    
    always @ (*) begin
      case (selector)
        1'b0: 
          mux_Out = input_0;
        1'b1: 
          mux_Out = input_1;
        default: 
          mux_Out = 32'bx; 
      endcase
    end

endmodule
