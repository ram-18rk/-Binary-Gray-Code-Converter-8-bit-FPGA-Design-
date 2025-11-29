`timescale 1ns / 1ps
module datapath(
input clk,
input rst,
input [7:0]data_in,//input data
output [7:0]data_out,//output data
input R1_in,
input R2_in,
input R3_in,
input R4_in,
input [2:0]bit_index,//bit number that we're currently working
input R1_bit_sel,//selcet bit index usage
input load_R2_bit,
input use_R1_for_R3,
input use_R1_for_R4,
output [7:0]R2_q,//outputdata
output xor_out,
output R3_q,
output R4_q
    );
    wire [7:0]R1_q;
    reg [7:0]R2_q_reg;
    //Instantiate parallel load and save the parallel-data in R1_q
    pipo R1_reg(.clk(clk),.rst(rst),.load(R1_in),.d(data_in),.y(R1_q));
pipo R2_reg(.clk(clk),.rst(rst),.load(R2_in),.d(data_in),.y());
//Instantiate single bit reg  
//selecting bit that are need to be operated
reg_r R3_reg(.clk(clk),.rst(rst),.load(R3_in),.d(use_R1_for_R3?(R1_bit_sel?R1_q[bit_index+1]:R1_q[bit_index]):R2_q[bit_index+1]),.y(R3_q));
reg_r R4_reg(
    .clk(clk),
    .rst(rst),
    .load(R4_in),
    .d( (bit_index == 3'd7) ? 1'b0 :    // for MSB force 0 so XOR = R1[7]
        (use_R1_for_R4 ? R1_q[bit_index] : R2_q_reg[bit_index+1]) ),
    .y(R4_q)
);
//XOR
xor_gate u_xor(.a(R3_q),.b(R4_q),.y(xor_out));
always @(posedge clk or posedge rst)
begin
    if(rst)
        R2_q_reg <= 8'b0;
    else if(load_R2_bit) begin
        if(bit_index == 3'd7)
            // MSB: just copy input MSB (works for both bin->gray and gray->bin)
            R2_q_reg[7] <= R1_q[7];
        else
            // other bits use XOR result
            R2_q_reg[bit_index] <= xor_out;
    end
end

assign R2_q=R2_q_reg;
assign data_out=R2_q_reg;
endmodule
