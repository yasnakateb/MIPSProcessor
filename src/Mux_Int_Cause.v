module Mux_Int_Cause(
  selector,
  mux_Out
    );

  input selector;
  output reg [31:0] mux_Out;
  
  always @ (*) begin
    case (selector)
      1'b0: 
        mux_Out = 32'h30;
      1'b1: 
        mux_Out = 32'h28;
      default: 
        mux_Out = 32'bx; 
    endcase
  end

endmodule
