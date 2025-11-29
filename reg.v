`timescale 1ns / 1ps
module reg_r(
input clk,
input rst,
input d,
input load,
output reg y

    );
    always @(posedge clk)
    begin
    if(rst)
    y<=1'b0;
    else if(load)
    y<=d;
    end
endmodule
