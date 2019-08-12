module Shifter2(
    sign_Imm,
    shifted_Sign_Imm
    );

    input [25:0] sign_Imm;
    output reg [27:0] shifted_Sign_Imm;

    wire [1:0] bit_Zero;
    assign bit_Zero = 0;
    
    always@(*) begin
        shifted_Sign_Imm =  {{{sign_Imm[25:0]}}, bit_Zero[1:0] };
    end

endmodule