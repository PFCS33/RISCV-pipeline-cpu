`timescale 1ns / 1ps
`include "macro.vh"

module mux2(
    input[`BIT_WIDTH] op1,op2,
    input ctr,

    output reg[`BIT_WIDTH] res
);
always@(*) begin
    if (!ctr) res = op1;
    else res = op2;
end

endmodule


module mux3(
    input[`BIT_WIDTH] op1,op2,op3,
    input[1:0] ctr,
    
    output reg[`BIT_WIDTH] res
);
always@(*) begin
    case(ctr) 
        2'b00: res = op1;
        2'b01: res = op2;
        2'b10: res = op3;
        default: res = op1;
    endcase
end

endmodule