`timescale 1ns / 1ps
`include "macro.vh"


module reg_id_exe(
    input clk,
    input rstn,

    input empty,
    // from reg_if_id
    input [`BIT_WIDTH]inst, pc,
    // from rf
    input [`BIT_WIDTH]imm,RD1,RD2,
    // from cu
    input alu_src,reg_src,reg_we,dmem_we,branch,dmem_read,
    input [3:0] alu_op,

    output [`BIT_WIDTH]id_exe_inst, id_exe_pc,
    output [`BIT_WIDTH]id_exe_imm, id_exe_RD1, id_exe_RD2, 
    output id_exe_alu_src, id_exe_reg_src, id_exe_reg_we, id_exe_dmem_we, id_exe_branch, id_exe_dmem_read,
    output [3:0] id_exe_alu_op
);

reg [`BIT_WIDTH] inst_tmp,pc_tmp;
reg [`BIT_WIDTH] imm_tmp, RD1_tmp, RD2_tmp;
reg id_exe_alu_src_tmp, id_exe_reg_src_tmp, id_exe_reg_we_tmp, id_exe_dmem_we_tmp, id_exe_branch_tmp, id_exe_dmem_read_tmp;
reg [3:0] alu_op_tmp;

always@(posedge clk or negedge rstn) begin
    if(!rstn)
    begin
        inst_tmp<=`ZERO_32;
        pc_tmp <= `ZERO_32;
        imm_tmp<=`ZERO_32;
        RD1_tmp<=`ZERO_32;
        RD2_tmp<=`ZERO_32;
        id_exe_alu_src_tmp<=0;
        id_exe_reg_src_tmp<=0;
        id_exe_reg_we_tmp<=0;
        id_exe_dmem_we_tmp<=0;
        id_exe_branch_tmp<=0;
        id_exe_dmem_read_tmp<=0;
        alu_op_tmp<= 4'b0;
    end
    else if(empty)
    begin
        inst_tmp<=`ZERO_32;
        pc_tmp <= `ZERO_32;
        imm_tmp<=`ZERO_32;
        RD1_tmp<=`ZERO_32;
        RD2_tmp<=`ZERO_32;
        id_exe_alu_src_tmp<=0;
        id_exe_reg_src_tmp<=0;
        id_exe_reg_we_tmp<=0;
        id_exe_dmem_we_tmp<=0;
        id_exe_branch_tmp<=0;
        id_exe_dmem_read_tmp<=0;
        alu_op_tmp<= 4'b0;
    end
    else 
    begin
        inst_tmp<=inst;
        pc_tmp <= pc;
        imm_tmp<=imm;
        RD1_tmp<=RD1;
        RD2_tmp<=RD2;
        id_exe_alu_src_tmp<=alu_src;
        id_exe_reg_src_tmp<=reg_src;
        id_exe_reg_we_tmp<=reg_we;
        id_exe_dmem_we_tmp<=dmem_we;
        id_exe_branch_tmp<=branch;
        id_exe_dmem_read_tmp<=dmem_read;
        alu_op_tmp<= alu_op;
    end
end

assign id_exe_inst = inst_tmp;
assign id_exe_pc = pc_tmp;
assign id_exe_imm = imm_tmp;
assign id_exe_RD1 = RD1_tmp;
assign id_exe_RD2 = RD2_tmp;
assign id_exe_alu_src = id_exe_alu_src_tmp;
assign id_exe_reg_src = id_exe_reg_src_tmp;
assign id_exe_reg_we = id_exe_reg_we_tmp;
assign id_exe_dmem_we = id_exe_dmem_we_tmp;
assign id_exe_branch = id_exe_branch_tmp;
assign id_exe_dmem_read = id_exe_dmem_read_tmp;
assign id_exe_alu_op = alu_op_tmp;

endmodule