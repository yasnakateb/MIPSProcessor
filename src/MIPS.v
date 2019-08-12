module MIPS(
    input clock,
    input rst,
    output [3:0] state
    );
     
    wire sig_Branch;
    wire sig_IntCause;
    wire sig_CauseWrite;
    wire sig_EPCWrite;
    wire sig_PCWrite;
    wire sig_MemWrite;
    wire sig_IRWrite;
    wire sig_RegDst;
    wire sig_ALUSrcA;
    wire [2:0] sig_ALUControl;
    wire [1:0] sig_ALUSrcB;
    wire [1:0] sig_MemtoReg;
    wire sig_IorD;  
    wire [31:0] _Int_Cause;      
    wire _Zero;
    wire _Pc_En; 
    wire [31:0] _Pc; 
    wire [31:0] _Pc_Prime;     
    wire [31:0] _Adr;
    wire [31:0] _Rd;
    wire [31:0] _Instr;
    wire [31:0] _Data;
    wire [4:0] _A3;
    wire [31:0] _Wd3;
    wire [31:0] _Rd1;
    wire [31:0] _Rd2;
    wire [31:0] _Sign_Imm;
    wire [31:0] _Reg_A;
    wire [31:0] _Reg_B;
    wire [31:0] _Src_A; 
    wire [31:0] _Src_B;
    wire [31:0] _Alu_Result;
    wire [1:0]  _Pc_Src;
    wire [31:0] _Pc_Jump;
    wire [27:0] _Pc_Jump_Prime;
    wire [31:0] _Alu_Out;
    wire _over_Flow;
    wire [31:0] _Sign_Imm_Shifted;
    wire [31:0] _Epc;
    wire [31:0] _C0;
    wire [31:0] _Cause;

    assign _Pc_Jump = { _Pc[31:28], _Pc_Jump_Prime[27:0] };

    Control_Unit control (
    .clock(clock), 
    .rst(rst), 
    .instr_Opcode(_Instr[31:26]), 
    .sig_MemtoReg(sig_MemtoReg), 
    .sig_RegDst(sig_RegDst), 
    .sig_IorD(sig_IorD), 
    .sig_PCSrc(_Pc_Src), 
    .sig_ALUSrcB(sig_ALUSrcB), 
    .sig_ALUSrcA(sig_ALUSrcA), 
    .sig_IRWrite(sig_IRWrite), 
    .sig_MemWrite(sig_MemWrite), 
    .sig_PCWrite(sig_PCWrite), 
    .sig_Branch(sig_Branch), 
    .sig_RegWrite(RegWrite), 
    .state(state), 
    .alu_Control(sig_ALUControl), 
    .instr_Function(_Instr[5:0]),
    .over_Flow(over_Flow),
    .sig_IntCause(sig_IntCause),
    .sig_CauseWrite(sig_CauseWrite),
    .sig_EPCWrite(sig_EPCWrite)
    );

    
    Register_En pc (    
    .clock(clock), 
    .enable(_Pc_En),
    .in(_Pc_Prime), 
    .out(_Pc)
    );
     
    
    Register_En epc (    
    .clock(clock), 
    .enable(sig_EPCWrite),
    .in(_Pc), 
    .out(_Epc)
    );
     
    
    Mux_Int_Cause mux_int_cause (
    .selector(sig_IntCause), 
    .mux_Out(_Int_Cause)
    );

     
    Register_En cause (     
    .clock(clock), 
    .enable(sig_CauseWrite),
    .in(_Int_Cause), 
    .out(_Cause)
    );
     
    
    Mux_Interupt mux_interupt (
    .input_13(_Cause), 
    .input_14(_Epc), 
    .selector(_Instr[15:11]), 
    .mux_Out(_C0)
    );


    Mux_2_Bit #(.DATA_WIDTH(32)) mux_i_or_d(
    .input_0(_Pc), 
    .input_1(_Alu_Out), 
    .selector(sig_IorD), 
    .mux_Out(_Adr)
    );
     
    
    Memory #(.DATA_WIDTH(256))memory (
    .clock(clock), 
    .sig_MemWrite(sig_MemWrite), 
    .adr(_Adr), 
    .wd(_Reg_B), 
    .rd(_Rd)
    );
     
     
    Register_En instr (   
    .clock(clock), 
    .enable(sig_IRWrite),
    .in(_Rd), 
    .out(_Instr)
    );
     
     
    Register data (     
    .clock(clock), 
    .in(_Rd), 
    .out(_Data)
    );
     
    
    Mux_2_Bit #(.DATA_WIDTH(5)) mux_reg_dst(
    .input_0(_Instr[20:16]), 
    .input_1(_Instr[15:11]), 
    .selector(sig_RegDst), 
    .mux_Out(_A3)
    );
     
    
     
    Mux_4_Bit #(.DATA_WIDTH(32)) mux_mem_to_reg (
    .input_0(_Alu_Out), 
    .input_1(_Data), 
    .input_2(_C0), 
    .input_3(0), 
    .selector(sig_MemtoReg), 
    .mux_Out(_Wd3)
    );
     
    
    Register_File register_file (
    .clock(clock),  
    .a1(_Instr[25:21]), 
    .a2(_Instr[20:16]), 
    .a3(_A3), 
    .wd3(_Wd3), 
    .sig_RegWrite(RegWrite), 
    .rd1(_Rd1), 
    .rd2(_Rd2)
    );
    

    Sign_Extention sign_extention (
    .immidiate(_Instr[15:0]), 
    .sign_Imm(_Sign_Imm)
    );
     
    
    Register reg_a (      
    .clock(clock), 
    .in(_Rd1), 
    .out(_Reg_A)
    );
     

    Register reg_b (      
    .clock(clock), 
    .in(_Rd2), 
    .out(_Reg_B)
    );
     
     
    Mux_2_Bit #(.DATA_WIDTH(32)) mux_alu_src_a(
    .input_0(_Pc), 
    .input_1(_Reg_A), 
    .selector(sig_ALUSrcA), 
    .mux_Out(_Src_A)
    );
     
     
    Mux_4_Bit #(.DATA_WIDTH(32)) mux_alu_src_b (
    .input_0(_Reg_B), 
    .input_1(4), //4should be here 
    .input_2(_Sign_Imm), 
    .input_3(_Sign_Imm_Shifted), 
    .selector(sig_ALUSrcB), 
    .mux_Out(_Src_B)
    );
     
 
    Shifter1 #(.DATA_WIDTH(32)) shifter_1 (
    .sign_Imm(_Sign_Imm), 
    .shifted_Sign_Imm(_Sign_Imm_Shifted)
    );
     
    
    Alu alu (
    .clock(clock),
    .alu_Control(sig_ALUControl), 
    .src_A(_Src_A), 
    .src_B(_Src_B), 
    .alu_Result(_Alu_Result), 
    .alu_Zero(_Zero),
    .over_Flow(over_Flow)
    );
     
     
    Control_Branch control_branch(
    .sig_Branch(sig_Branch), 
    .alu_Zero(_Zero), 
    .sig_PCWirte(sig_PCWrite), 
    .pc_En(_Pc_En)
    );
     
     
    Register alu_out (      
    .clock(clock), 
    .in(_Alu_Result), 
    .out(_Alu_Out)
    );
     
     
    Mux_4_Bit #(.DATA_WIDTH(32)) mux_pc_src (
    .input_0(_Alu_Result), 
    .input_1(_Alu_Out), 
    .input_2(_Pc_Jump), 
    .input_3(32'h80000180), 
    .selector(_Pc_Src), 
    .mux_Out(_Pc_Prime)
    );
     
     
    Shifter2 shifter_2 (
    .sign_Imm(_Instr[25:0]), 
    .shifted_Sign_Imm(_Pc_Jump_Prime)
    );
    
endmodule
