//////////////////////////////////////////////////////////////////////
////                                                              ////
////  can_dlc_decoder.sv                                          ////
////                                                              ////
////  Utilizado para decodificar o Data Lenght Code em frames FD  ////
//////////////////////////////////////////////////////////////////////

`include "timescale.sv"


module can_dlc_decoder(
  input  logic [3:0] data_len_in,
  input  logic       fd_frame_in,   
  output logic [6:0] data_len_out
);

    
  always_comb begin
    if(fd_frame_in) begin
        case (data_len_in)
            4'b0000: data_len_out = 7'd0;
            4'b0001: data_len_out = 7'd1;
            4'b0010: data_len_out = 7'd2;
            4'b0011: data_len_out = 7'd3;
            4'b0100: data_len_out = 7'd4;
            4'b0101: data_len_out = 7'd5;
            4'b0110: data_len_out = 7'd6;
            4'b0111: data_len_out = 7'd7;
            4'b1000: data_len_out = 7'd8;
            4'b1001: data_len_out = 7'd12;
            4'b1010: data_len_out = 7'd16;
            4'b1011: data_len_out = 7'd20;
            4'b1100: data_len_out = 7'd24;
            4'b1101: data_len_out = 7'd32;
            4'b1110: data_len_out = 7'd48;
            default: data_len_out = 7'd64;
        endcase
    end else begin
        case (data_len_in)
            4'b0000: data_len_out = 7'd0;
            4'b0001: data_len_out = 7'd1;
            4'b0010: data_len_out = 7'd2;
            4'b0011: data_len_out = 7'd3;
            4'b0100: data_len_out = 7'd4;
            4'b0101: data_len_out = 7'd5;
            4'b0110: data_len_out = 7'd6;
            4'b0111: data_len_out = 7'd7;
            default: data_len_out = 7'd8;
        endcase
    end
  end

endmodule