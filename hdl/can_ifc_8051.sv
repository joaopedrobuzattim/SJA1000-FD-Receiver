//////////////////////////////////////////////////////////////////////
////                                                              ////
////  can_top.v                                                   ////
////                                                              ////
////                                                              ////
////  This file is part of the CAN Protocol Controller            ////
////  http://www.opencores.org/projects/can/                      ////
////                                                              ////
////                                                              ////
////  Author(s):                                                  ////
////       Igor Mohor                                             ////
////       igorm@opencores.org                                    ////
////                                                              ////
////                                                              ////
////  All additional information is available in the README.txt   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2002, 2003, 2004 Authors                       ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//// The CAN protocol is developed by Robert Bosch GmbH and       ////
//// protected by patents. Anybody who wants to implement this    ////
//// CAN IP core on silicon has to obtain a CAN protocol license  ////
//// from Bosch.                                                  ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

// synopsys translate_off
`include "timescale.sv"
// synopsys translate_on
`include "can_defines.sv"

module can_ifc_8051
(
  input  wire       clk_i,
  output wire       reg_rst_o,
  output wire       reg_re_o,
  output wire       reg_we_o,
  output wire [7:0] reg_addr_o,
  output wire [7:0] reg_data_in_o,
  input  wire [7:0] reg_data_out_i,

  input  wire       rst_i,
  input  wire       ale_i,
  input  wire       rd_i,
  input  wire       wr_i,
  inout  wire [7:0] port_0_io,
  input  wire       cs_can_i
);

parameter Tp = 1;

  reg    [7:0] addr_latched;
  reg          wr_i_q;
  reg          rd_i_q;

  // Latching address
  always @ (posedge clk_i or posedge rst_i)
  begin
    if (rst_i)
      addr_latched <= 8'h0;
    else if (ale_i)
      addr_latched <=#Tp port_0_io;
  end


  // Generating delayed wr_i and rd_i signals
  always @ (posedge clk_i or posedge rst_i)
  begin
    if (rst_i)
      begin
        wr_i_q <= 1'b0;
        rd_i_q <= 1'b0;
      end
    else
      begin
        wr_i_q <=#Tp wr_i;
        rd_i_q <=#Tp rd_i;
      end
  end


  wire reg_cs;
  assign reg_cs = ((wr_i & (~wr_i_q)) | (rd_i & (~rd_i_q))) & cs_can_i;

  assign reg_rst_o       = rst_i;
  assign reg_we_o        = reg_cs & wr_i;
  assign reg_re_o        = reg_cs & ~wr_i;
  assign reg_addr_o      = addr_latched;
  assign reg_data_in_o   = port_0_io;
  assign port_0_io       = (cs_can_i & rd_i)? reg_data_out_i : 8'hz;

endmodule
