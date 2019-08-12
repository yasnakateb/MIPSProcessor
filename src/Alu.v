module Alu(
    clock,
    alu_Control,
    src_A,
    src_B,
    alu_Result,
    alu_Zero,
    over_Flow,
    );

    input clock;
    input [2:0] alu_Control;
    input [31:0] src_A;
    input [31:0] src_B;
    output reg[31:0] alu_Result;
    output alu_Zero;
    output reg over_Flow;

    reg extra;
    always  @(posedge clock) begin   
        case(alu_Control)
            3'b010: begin
                alu_Result =  src_A + src_B; 
                {extra, alu_Result} = {src_A[31], src_A} + {src_B[31], src_B};
                over_Flow  = ({extra, alu_Result[31]} == 2'b01 );
            end
            3'b110: begin
                alu_Result  =  src_A - src_B;
                {extra, alu_Result} = {src_A[31], src_A} - {src_B[31], src_B};
                over_Flow  = ({extra, alu_Result[31]} == 2'b01 );
            end
            3'b000: 
                alu_Result  =  src_A & src_B; 
            3'b001:
                alu_Result  =  src_A | src_B; 
            3'b101:
                alu_Result  =  src_A ^ src_B; 
            3'b111: begin 
                if  (src_A < src_B) 
                    alu_Result =1;
                else 
                    alu_Result =0;        
            end
            default:
                alu_Result = 32'hxxxxxxxx;
        endcase
    end 
    
    assign alu_Zero = (alu_Result == 32'd0) ? 1'd1 : 1'd0;
    
endmodule
