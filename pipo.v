`timescale 1ns / 1ps
module pipo(
input clk,
input rst,
input load,
input [7:0]d,
output reg [7:0]y

    );
always@(posedge clk)
    begin 
    if(rst)
    y<=8'b0;
    else if(load)
    y<=d;
    end
endmodule
