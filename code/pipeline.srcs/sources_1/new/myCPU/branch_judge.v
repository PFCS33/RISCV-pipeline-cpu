`timescale 1ns / 1ps
`include "macro.vh"

module branch_judge(
    input [`BIT_WIDTH] inst,
    input [`BIT_WIDTH] in1, in2,

    // 输出 jump 信号
    output reg jump
);

always @(*) 
begin
    if(inst[6:0] == `OPCODE_B)
    begin
        case(inst[14:12])
        `FUNC3_BEQ: jump = (in1 == in2) ? 1'b1 : 1'b0;
        `FUNC3_BNE: jump = (in1 == in2) ? 1'b0 : 1'b1;
        `FUNC3_BLT:
         begin
            if((in1[31] ^ in2[31]) ==1'b1)
                if(in1[31]== 1'b1)
                    jump= 1;
                else   
                    jump= 0;
            else    
                jump = (in1<in2)? 1 : 0;
        end
        `FUNC3_BGE: 
            if((in1[31] ^ in2[31]) ==1'b1)
                if(in1[31]== 1'b1)
                    jump= 0;
                else   
                    jump= 1;
            else    
                jump = (in1<in2)? 1 : 0;
        `FUNC3_BLTU: jump = (in1 < in2) ? 1'b1 : 1'b0;
        `FUNC3_BGEU: jump = (in1 >= in2) ? 1'b1 : 1'b0;
        default: jump = 1'b0;
        endcase
    end
    else
        jump=1;
    
end

endmodule
