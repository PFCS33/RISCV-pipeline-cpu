`timescale 1ns / 1ps

module mycpu(
    input         rst,
    input         clkn,

    // rom 指令存储器接口
    output [31:0] inst_addr,
    input  [31:0] inst_rdata,

    // ram 内存接口
    input  [31:0] dmem_rdata,
    output        dmem_wen,
    output [31:0] dmem_addr,
    output [31:0] dmem_wdata
);


endmodule