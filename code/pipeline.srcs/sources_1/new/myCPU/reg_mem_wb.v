`timescale 1ns / 1ps
`include "macro.vh"

module reg_mem_wb(
    input clk,
    input rstn,

    // from reg_exe_mem
    input [`BIT_WIDTH] inst, pc,
    input [`BIT_WIDTH] alu_result,
    input reg_we, reg_src,
    // from dmem, read data
    input [`BIT_WIDTH] dmem_rdata,

    output [`BIT_WIDTH] mem_wb_inst,
    output [`BIT_WIDTH] mem_wb_alu_result,
    output mem_wb_reg_we, mem_wb_reg_src,
    output [`BIT_WIDTH] mem_wb_dmem_rdata

);

reg [`BIT_WIDTH] inst_tmp;
reg [`BIT_WIDTH] alu_result_tmp;
reg  reg_we_tmp, reg_src_tmp;
reg [`BIT_WIDTH] dmem_rdata_tmp;

always@(posedge clk or negedge rstn) 
begin
    if(!rstn)
    begin
        inst_tmp <= `ZERO_32;
        alu_result_tmp <= `ZERO_32;
        reg_we_tmp <= 0;
        reg_src_tmp <= 0;
        dmem_rdata_tmp <= `ZERO_32;
    end
    else
    begin
        inst_tmp<= inst;
        if (inst[6:0] == `OPCODE_UJ || inst[6:0] == `OPCODE_JALR) 
        begin
            alu_result_tmp <= pc + 4;
        end
        else alu_result_tmp <= alu_result;
        reg_we_tmp <= reg_we;
        reg_src_tmp <= reg_src;
        dmem_rdata_tmp <= dmem_rdata;

    end
end

assign mem_wb_inst = inst_tmp;
assign mem_wb_alu_result = alu_result_tmp;
assign mem_wb_reg_we =reg_we_tmp;
assign mem_wb_reg_src = reg_src_tmp;
assign mem_wb_dmem_rdata = dmem_rdata_tmp;


endmodule