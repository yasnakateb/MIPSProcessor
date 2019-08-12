module Shifter1(
    sign_Imm,
    shifted_Sign_Imm
    );

    parameter DATA_WIDTH = 32;
    input [DATA_WIDTH - 1:0] sign_Imm;
    output [DATA_WIDTH -1:0] shifted_Sign_Imm;
  
    assign shifted_Sign_Imm = sign_Imm << 2;

endmodule
