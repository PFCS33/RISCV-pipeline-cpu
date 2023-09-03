`timescale 1ns / 1ps
`include "macro.vh"

module reg_exe_mem(
    input clk,
    input rstn,

    // from reg_id_exe
    input[`BIT_WIDTH] inst, pc,
    input [`BIT_WIDTH] imm,RD1,RD2,
    input reg_src,reg_we,dmem_we,branch,dmem_read,
    // from exe
    input [`BIT_WIDTH] alu_res, 
    // from branch_judge
    input jump,

    output[`BIT_WIDTH] exe_mem_inst, exe_mem_pc,
    output [`BIT_WIDTH] exe_mem_imm, exe_mem_RD1, exe_mem_RD2,
    output exe_mem_reg_src, exe_mem_reg_we, exe_mem_dmem_we, exe_mem_branch, exe_mem_dmem_read,
    output [`BIT_WIDTH] exe_mem_alu_res, 
    output exe_mem_jump
);

reg [`BIT_WIDTH] inst_tmp, pc_tmp;
reg  [`BIT_WIDTH] imm_tmp, RD1_tmp, RD2_tmp;
reg  reg_src_tmp, reg_we_tmp, dmem_we_tmp, branch_tmp, dmem_read_tmp;
reg  [`BIT_WIDTH] alu_res_tmp;
reg  jump_tmp;

always @(posedge clk or negedge rstn) begin
    if(!rstn)
    begin
        inst_tmp <= `ZERO_32;
        pc_tmp <= `ZERO_32;
        imm_tmp<= `ZERO_32;
        RD1_tmp<= `ZERO_32;
        RD2_tmp<= `ZERO_32;
        reg_src_tmp <= 0;
        reg_we_tmp<= 0;
        dmem_we_tmp <= 0;
        branch_tmp <= 0;
        dmem_read_tmp <= 0;
        alu_res_tmp<= `ZERO_32;
        jump_tmp  <= 0;
    end
    else 
    begin
        inst_tmp <= inst;
        pc_tmp <= pc;
        imm_tmp<= imm;
        RD1_tmp<= RD1;
        RD2_tmp<= RD2;
        reg_src_tmp <= reg_src;
        reg_we_tmp<= reg_we;
        dmem_we_tmp <= dmem_we;
        branch_tmp <= branch;
        dmem_read_tmp <= dmem_read;
        alu_res_tmp<= alu_res;
        jump_tmp  <= jump;
    end
 
end


assign exe_mem_inst = inst_tmp;
assign exe_mem_pc = pc_tmp;
assign exe_mem_imm = imm_tmp;
assign exe_mem_RD1 = RD1_tmp;
assign  exe_mem_RD2 = RD2_tmp;
assign exe_mem_reg_src = reg_src_tmp;
assign exe_mem_reg_we = reg_we_tmp;
assign exe_mem_dmem_we = dmem_we_tmp;
assign exe_mem_branch =branch_tmp;
assign exe_mem_dmem_read =dmem_read_tmp;
assign  exe_mem_alu_res =alu_res_tmp;
assign exe_mem_jump = jump_tmp;
endmodule