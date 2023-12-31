`timescale 1ns / 1ps
`include "macro.vh"

module rf(
    input clk,  
    input rstn,
    input we,           //写使能
    input [4:0] RA1,    //读地址1 (寄存器数组的下标)
    input [4:0] RA2,    //读地址2
    input [4:0] WA,     //写地址
    input [`BIT_WIDTH] WD,    //写数据

    output [`BIT_WIDTH] RD1,  //读出的数据1
    output [`BIT_WIDTH] RD2,  //读出的数据2

    // debug
    output [`BIT_WIDTH] debug_reg1,
    output [`BIT_WIDTH] debug_reg2,
    output [`BIT_WIDTH] debug_reg3,
    output [`BIT_WIDTH] debug_reg4,
    output [`BIT_WIDTH] debug_reg5,
    output [`BIT_WIDTH] debug_reg6,
    output [`BIT_WIDTH] debug_reg7

);

reg [`BIT_WIDTH] regFiles [`BIT_WIDTH];     //寄存器堆

integer i; // flush counter
// 上升沿写数据
always@(posedge clk or negedge rstn) 
begin
    // 清零
    if (!rstn) begin
        for (i = 0; i < 32; i = i + 1) begin
            regFiles[i] <= i;
        end
    end
    // 写数据
    else if (we) 
    begin
        regFiles[WA] <= WD;
    end
    regFiles[0] <= 0; 

end

// 读寄存器数据 (0号寄存器返回0)
assign RD1=(RA1==0)? `ZERO_32: regFiles[RA1];
assign RD2=(RA2==0)? `ZERO_32: regFiles[RA2];

assign debug_reg1=regFiles[5];  // t0
assign debug_reg2=regFiles[6]; // t1
assign debug_reg3=regFiles[7]; // t2
assign debug_reg4=regFiles[28]; // t3
assign debug_reg5=regFiles[29]; // t4
assign debug_reg6=regFiles[30]; // t5
assign debug_reg7=regFiles[31]; // t6

endmodule
