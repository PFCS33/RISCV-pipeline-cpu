`timescale 1ns / 1ps
`include "macro.vh"

module alu(
    input [`BIT_WIDTH] in1,in2,
    input [3:0] alu_op,

    output reg ZF, // 零标志
    output reg [`BIT_WIDTH] res // 计算结果
);

always @(*) begin
    case (alu_op)
        `ALU_ADD:
            res = in1+in2;
        `ALU_SUB:
            res= in1-in2;
        `ALU_SLL:
            res= in1<<in2;
        `ALU_SRL:
            res= in1 >>in2;
        `ALU_SRA:
            // 算术移动
            res = $signed (in1) >>> in2;
        `ALU_SLT:
            begin
                // 异号情况
                if((in1[31] ^ in2[31]) ==1'b1)
                    if(in1[31]== 1'b1)
                        res= 1;
                    else   
                        res= 0;
                else    
                    res = (in1<in2)? 1 : 0;
            end
        `ALU_SLTU:
            res =  (in1<in2)? 1 : 0;
        `ALU_AND:
            res = in1 & in2;
        `ALU_OR:
            res = in1 | in2;
        `ALU_XOR:
            res = in1 ^ in2;
        `ALU_NOP:
            res= 0;
        default: 
            res=0;
    endcase
    ZF =  (res == 0)? 1:0;
end

endmodule