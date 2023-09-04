`include "macro.vh"

module pc(
    input clk,
    input rstn,

    input pc_we,   // pc 写使能，遇到hazards时阻止pc更新
    input [`BIT_WIDTH] npc, // 下一个指令地址
    output reg [`BIT_WIDTH] pc //输出值，真正的取指地址
);

    initial 
    begin
        pc = `ZERO_32;
    end
    always@(posedge clk or negedge rstn) begin
        // 复位信号，置0
        if (!rstn) begin
            pc <= `ZERO_32;
        end
        // 允许取下一个地址
        else if (pc_we) begin
            pc <= npc;
        end
        // 停止取下一指令
        else begin
            pc <= pc;
        end
    end

endmodule