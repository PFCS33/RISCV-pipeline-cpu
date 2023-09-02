`timescale 1ns / 1ps
`include "macro.vh"

module reg_if_id(
    input clk,
    input rstn,

    // 写使能和空信号，nop时用
    input if_id_we,
    input empty,
    // 存储的if产生值
    input [`BIT_WIDTH] inst,     // 读取的指令
    input [`BIT_WIDTH] pc,  // 对应的pc

    output [`BIT_WIDTH] if_id_inst,
    output [`BIT_WIDTH] if_id_pc

);

// 寄存器变量，暂存值
reg [`BIT_WIDTH] inst_tmp;
reg [`BIT_WIDTH] pc_tmp;

always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            inst_tmp <= `ZERO_32;
            pc_tmp <= `ZERO_32;
        end
        // 刷空，产生nop
        else if (empty) begin
            inst_tmp <= `ZERO_32;
            pc_tmp <= `ZERO_32;
        end
        // 继续流水
        else if (if_id_we) begin
            inst_tmp <= inst;
            pc_tmp <= pc;
        end
        // 停滞
        else begin
            inst_tmp <= inst_tmp;
            pc_tmp <= pc_tmp;
        end
end





endmodule