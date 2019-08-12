module Control_Unit( 
    clock,
    rst,
    instr_Opcode,
    instr_Function,
    over_Flow,
    sig_MemtoReg,
    sig_RegDst,
    sig_IorD,
    sig_PCSrc,
    sig_ALUSrcB, 
    sig_ALUSrcA, 
    sig_IRWrite, 
    sig_MemWrite,
    sig_PCWrite,
    sig_Branch,
    sig_RegWrite,
    sig_IntCause,
    sig_CauseWrite,
    sig_EPCWrite,
    state,
    alu_Control,
    );

    input clock;
    input rst;
    input [5:0] instr_Opcode;
    input [5:0] instr_Function;
    input over_Flow;
    output [1:0] sig_MemtoReg;
    output sig_RegDst;
    output sig_IorD;
    output [1:0]sig_PCSrc;
    output [1:0] sig_ALUSrcB;
    output sig_ALUSrcA;
    output sig_IRWrite;
    output sig_MemWrite;
    output sig_PCWrite;
    output sig_Branch;
    output sig_RegWrite;
    output sig_IntCause;
    output sig_CauseWrite;
    output sig_EPCWrite;
    output reg [3:0] state;
    output reg [2:0] alu_Control;

    parameter STATE_0 = 0;
    parameter STATE_1 = 1;
    parameter STATE_2 = 2;
    parameter STATE_3 = 3;
    parameter STATE_4 = 4;
    parameter STATE_5 = 5;
    parameter STATE_6 = 6;
    parameter STATE_7 = 7;
    parameter STATE_8 = 8;
    parameter STATE_9 = 9;
    parameter STATE_10 = 10;
    parameter STATE_11 = 11;
    parameter STATE_12 = 12;
    parameter STATE_13 = 13;
    parameter STATE_14 = 14;
    
    parameter R_TYPE = 6'b000000; //R_Type  
    parameter LW = 6'b100011;     //Lw
    parameter SW = 6'b101011;     //Sw
    parameter BEQ = 6'b000100;    //Beq
    parameter ADDI = 6'b001000;   //Addi
    parameter J = 6'b000010;      //J
    parameter MFC0 = 6'b010000;   // Mfc0
     

    wire [1:0] alu_Op;
    always@(posedge clock) begin
        if (rst) 
            state <= 4'd0;
        else begin
            case(state)
                STATE_0: 
                    state <= 4'd1;
                STATE_1:begin
                    if (instr_Opcode == J)
                        state <= 4'd11;
                    else if (instr_Opcode == ADDI)
                        state <= 4'd9;
                    else if (instr_Opcode == BEQ)
                        state <= 4'd8;
                    else if (instr_Opcode == R_TYPE)
                        state <= 4'd6;
                    else if (instr_Opcode == SW)
                        state <= 4'd2;
                    else if (instr_Opcode == LW)
                        state <= 4'd2;
                    else if (instr_Opcode == MFC0)
                        state <= 4'd14;
                    else 
                        state <= 4'd12;
                end                         
                STATE_2: begin
                    if (instr_Opcode == SW) 
                        state <= 4'd5;
                    else if (instr_Opcode == LW) 
                        state <= 4'd3;
                end 
                STATE_3:
                    state <= 4'd4;
                STATE_4:
                    state <= 4'd0;
                STATE_5:
                    state <= 4'd0;      
                STATE_6: begin
                    if (over_Flow)
                        state <= 4'd13;
                    else 
                        state <= 4'd7;
                end     
                STATE_7:
                    state <= 4'd0;
                STATE_8:
                    state <= 4'd0;  
                STATE_9:
                    state <= 4'd10;         
                STATE_10:
                    state <= 4'd0;              
                STATE_11 :
                    state <= 4'd0;              
                STATE_12 :
                    state <= 4'd0;              
                STATE_13 :
                    state <= 4'd0;              
                STATE_14 :
                    state <= 4'd0;              
                default : state <= 4'd0;
            endcase 
        end
    end

    assign sig_IorD = (rst == 1'b1) ? 1'b0  :(((state == 4'd5)|| (state == 4'd3)) ? 1'b1 : 1'b0);
    
    assign sig_ALUSrcA = (rst == 1'b1) ? 1'b0  :(((state == 4'd9)|| (state == 4'd8)|| (state == 4'd6)|| (state == 4'd2)) ? 1'b1 : 1'b0);
    
    assign sig_ALUSrcB = (rst == 1'b1) ? 2'b00 :((state == 4'd0)? 2'b01 : ((state == 4'd1) ? 2'b11 : (((state == 4'd9) || (state == 4'd2)) ? 2'b10 : 2'b00)));
    
    assign alu_Op = (rst == 1'b1) ? 1'b0  :((state == 4'd8)? 2'b01: ((state == 4'd6) ? 2'b10 : 2'b00));
    
    assign sig_PCSrc = (rst == 1'b1) ? 2'b00 :((state == 4'd12)||(state == 4'd13) ? 2'b11 :((state == 4'd11) ? 2'b10: ((state == 4'd8) ? 2'b01 : 2'b00)));
    
    assign sig_IRWrite = (rst == 1'b1) ? 1'b0  :((state  == 4'd0) ? 1'b1 : 1'b0);
    
    assign sig_PCWrite = (rst == 1'b1) ? 1'b0  :(((state == 4'd0) || (state == 4'd11) || (state == 4'd13) || (state == 4'd12)) ? 1'b1 : 1'b0);
    
    assign sig_Branch = (rst == 1'b1) ? 1'b0  :((state == 4'd8) ? 1'b1 : 1'b0);
    
    assign sig_RegDst = (rst == 1'b1) ? 1'b0  :((state == 4'd7)? 1'b1 : 1'b0);
    
    assign sig_MemtoReg = (rst == 1'b1) ? 2'b00 :((state == 4'd4) ? 2'b01 : ((state ==4'd14) ? 2'b10 : 2'b00));
    
    assign sig_RegWrite = (rst == 1'b1) ? 1'b0  :(((state == 4'd4) || (state == 4'd7) || (state == 4'd10) || (state == 4'd14) ) ? 1'b1 : 1'b0);
    
    assign sig_MemWrite = (rst == 1'b1) ? 1'b0  :((state == 4'd5) ? 1'b1 : 1'b0);
    
    assign sig_IntCause = (rst == 1'b1) ? 1'b0  :((state == 4'd13) ? 1'b0 : ( (state == 4'd12) ? 1'b1 : 1'b0));
    
    assign sig_CauseWrite = (rst == 1'b1) ? 1'b0  :(((state == 4'd12) || (state == 4'd13)) ? 1'b1 : 1'b0);
    
    assign sig_EPCWrite = (rst == 1'b1) ? 1'b0  :(((state == 4'd12) || (state == 4'd11)) ? 1'b1 : 1'b0);
    
        
    always @(alu_Op or instr_Function) begin
        if (alu_Op ==0)
            alu_Control <= 3'b010;              // add 
        else if (alu_Op[0] ==1 )
            alu_Control <= 3'b110;              // sub          
        
        else if (alu_Op[1] ==1 ) begin
            case (instr_Function)
                6'b100000 : 
                    alu_Control <= 3'b010;  // add
                6'b100010 : 
                    alu_Control <= 3'b110;  // sub 
                6'b100100 : 
                    alu_Control <= 3'b000;  // and 
                6'b100101 : 
                    alu_Control <= 3'b001;  // or
                6'b101010 : 
                    alu_Control <= 3'b111;  // slt
                6'b100110 : 
                    alu_Control <= 3'b101;  // Xor 
                default :   
                    alu_Control <= 3'bxxx;
            endcase                 
        end
        else 
            alu_Control <= 3'bxxx;
    end         
        
endmodule   
