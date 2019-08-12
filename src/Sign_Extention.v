module Sign_Extention(
    immidiate,
    sign_Imm
    );

    input [15:0] immidiate;
    output reg [31:0] sign_Imm;

    always @(*) begin
        sign_Imm[31:0] <= { {16{immidiate[15]}}, immidiate[15:0]};
    end

endmodule