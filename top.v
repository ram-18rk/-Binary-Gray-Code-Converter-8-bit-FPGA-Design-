`timescale 1ns / 1ps
module fsm(
input clk,
input rst,
input start,
input convert,//0:binary to gray,1:gray to binary
output reg done,
output reg R1_in,
output reg R2_in,
output reg R3_in,
output reg R4_in,
output reg R1_bit_sel,
output reg load_R2_bit,
output reg use_R1_for_R3,
output reg use_R1_for_R4,
output reg [2:0]bit_index
    );
    //parameters list
    parameter S_IDEAL=3'b000;
    parameter S_LOAD_R1=3'b001;
    parameter S_INIT_MSB=3'b010;
    parameter S_PROCESS=3'b011;
    parameter S_NEXT_BIT=3'b100;
    parameter S_DONE=3'b101;
    reg [2:0]next_state;
    reg [2:0]state;
    reg [2:0]index;
    //STATE REGISTERS
always @(posedge clk or posedge rst)
begin
    if (rst)
        state <= S_IDEAL;
    else
        state <= next_state;
end
    //INDEX
always @(posedge clk or posedge rst)
begin
if(rst)
index<=3'd7;
else if(state==S_INIT_MSB)
index<=3'd6;
else if(state==S_NEXT_BIT)
index<=index-1'b1;
end
//State Transitions
always @(*)
begin
next_state=state;//default cases
R1_in  = 0;
R2_in  = 0;
R3_in  = 0;
R4_in  = 0;
R1_bit_sel = 0;
load_R2_bit = 0;
use_R1_for_R3 = 0;
use_R1_for_R4 = 0;
done   = 0;
bit_index = index;
case(state)
S_IDEAL:begin
if(start)
next_state=S_LOAD_R1;
end
S_LOAD_R1:begin
R1_in=1;
next_state=S_INIT_MSB;
end
S_INIT_MSB:begin
bit_index=index;
use_R1_for_R3=1;
use_R1_for_R4=0;
R3_in=1;
R4_in=1;
load_R2_bit=1;
next_state=S_PROCESS;
end
S_PROCESS:begin
bit_index=index;
if(convert==1'b0)
begin//binary to gray
use_R1_for_R3=1;
use_R1_for_R4=1;
R1_bit_sel=1;
R3_in=1;
R4_in=1;
load_R2_bit=1;
end
else//gray to binary
begin
use_R1_for_R3=0;
use_R1_for_R4=1;
R1_bit_sel=0;
R3_in=1;
R4_in=1;
load_R2_bit=1;
end
if(index==3'd0)
next_state=S_DONE;
else
next_state=S_NEXT_BIT;
end
S_NEXT_BIT:begin
next_state=S_PROCESS;
end
S_DONE:begin
done=1;
if(!start)
next_state=S_IDEAL;
end
default:begin
next_state=S_IDEAL;
end
endcase
end 
endmodule
