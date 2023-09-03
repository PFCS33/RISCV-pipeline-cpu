`timescale 1ns / 1ps
`include "macro.vh"

module forwarding_mem_wb_1(
    // mem 阶段准备store的寄存器
    input exe_mem_dmem_we, 
    input [4:0] exe_mem_rs2,
    
    // wb 阶段准备写入的寄存器
    input mem_wb_reg_we,
    input [4:0] mem_wb_rd,
    output reg forward_wd
);
always@(*) begin
    if (mem_wb_reg_we && exe_mem_dmem_we) begin
        if (exe_mem_rs2 == mem_wb_rd) forward_wd = 1;
        else forward_wd = 0;
    end
    else forward_wd = 0;
end


endmodule