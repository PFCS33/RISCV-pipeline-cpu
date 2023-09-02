`timescale 1ns / 1ps
`include "macro.vh"

module npc(
    input [`BIT_WIDTH] pc_now,  //当前pc值
    input branch, // 是否是分支指令
    input jump, // 是否需要跳转
    input [6:0] exe_mem_opcode,   // 根据跳转的opcode判断 npc结果

    input [`BIT_WIDTH] exe_mem_pc, // 保存到exe_mem流水阶段的pc值
    input [`BIT_WIDTH] imm, // imm值
    input [`BIT_WIDTH] exe_mem_alu_res,     // alu计算结果
    output reg[`BIT_WIDTH] pc_new
);


always @(*) begin
    // jar 指令/ branch 跳转
    if((exe_mem_opcode == `OPCODE_UJ) || (branch&& jump))
    begin
        pc_new = exe_mem_pc + imm;
    end
    // alu 结果forward
    else if(exe_mem_opcode == `OPCODE_JALR)
    begin
        pc_new= exe_mem_alu_res;
    end
    else if(branch && !jump) 
    begin
        pc_new = exe_mem_pc +4;
    end
    else    
        pc_new= pc_now +4;
end



endmodule



