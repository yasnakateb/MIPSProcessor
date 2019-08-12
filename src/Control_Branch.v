module Control_Branch( 
    sig_Branch,
    alu_Zero,
    sig_PCWirte,
    pc_En
    );

    input sig_Branch;
    input alu_Zero;
    input sig_PCWirte;
    output pc_En;

    wire out1,out2;
    assign out1 = sig_Branch & alu_Zero;
    assign pc_En = out1 | sig_PCWirte;

endmodule 
    
