module Memory(
    clock,
    sig_MemWrite, 
    adr, 
    wd, 
    rd 
    );

    input clock;
    input sig_MemWrite; 
    input [31:0] adr; 
    input [31:0] wd ; 
    output reg [31:0] rd; 

    parameter DATA_WIDTH = 256;
    reg [31:0] ram [0:DATA_WIDTH-1];
    
    initial begin 
        $readmemb("rams_init_file.data",ram,0,DATA_WIDTH-1);
    end
    always @(posedge clock) begin
        if(sig_MemWrite == 0)
            rd = ram[adr];
        else
            ram[adr] = wd;
    end
        
endmodule
