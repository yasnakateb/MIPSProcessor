module Mux_Interupt(
    input_13,
    input_14,
    selector,
    mux_Out
    );
    
    input [31:0] input_13;
    input [31:0] input_14;
    input [4:0]selector;
    output reg [31:0] mux_Out;
    
    always @ (*) begin
        case (selector)
            5'd13: 
                mux_Out =  input_13;
            5'd14: 
                mux_Out =  input_14;
            default: 
                mux_Out = 32'bx; 
        endcase
    end

endmodule




