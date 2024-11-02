`include "timescale.sv"

module can_crc_destuff(clk, rst, data, data_prev, enable, bit_cnt, fixed_stuff_bit_error, crc_17_o, crc_21_o);

parameter Tp = 1;

input clk, rst;
input enable;
input data;
input [8:0] bit_cnt;
input data_prev;

output fixed_stuff_bit_error;
output [16:0] crc_17_o;
output [20:0] crc_21_o;

reg [16:0] crc_17_r;
reg [20:0] crc_21_r;
wire stuff_bit_crc;      

assign crc_17_o = crc_17_r;
assign crc_21_o = crc_21_r;
assign stuff_bit_crc =  (bit_cnt == 9'd0 | bit_cnt == 9'd5 | bit_cnt == 9'd10 | bit_cnt == 9'd15 | bit_cnt == 9'd20 | bit_cnt == 9'd25);
assign fixed_stuff_bit_error = enable & stuff_bit_crc &  (data == data_prev);

always @ (posedge clk or posedge rst)
begin
  if (rst) begin
    crc_17_r <= #Tp 17'h0;
    crc_21_r <= #Tp 21'h0;
  end
  else if(enable) begin
    if ( ~ stuff_bit_crc ) begin
        crc_17_r <=#Tp {crc_17_r[15:0], data};
        crc_21_r <=#Tp {crc_21_r[19:0], data};
    end
  end
end

endmodule