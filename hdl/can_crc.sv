//////////////////////////////////////////////////////////////////////
////                                                              ////
////  can_crc.v                                                   ////
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
//
// CVS Revision History
//
// $Log: not supported by cvs2svn $
// Revision 1.4  2003/07/16 13:16:51  mohor
// Fixed according to the linter.
//
// Revision 1.3  2003/02/10 16:02:11  mohor
// CAN is working according to the specification. WB interface and more
// registers (status, IRQ, ...) needs to be added.
//
// Revision 1.2  2003/02/09 02:24:33  mohor
// Bosch license warning added. Error counters finished. Overload frames
// still need to be fixed.
//
// Revision 1.1  2003/01/08 02:10:54  mohor
// Acceptance filter added.
//
//
//
//

// synopsys translate_off
`include "timescale.sv"
// synopsys translate_on

module can_crc (clk, data, stuff_bit, enable, initialize, FD_iso, crc_15, crc_17, crc_21);


parameter Tp = 1;
parameter CRC15_POL = 15'hC599;
parameter CRC17_POL = 17'h3685B;
parameter CRC21_POL = 21'h302899;

input         clk;
input         data;
input         stuff_bit;
input         enable;
input         initialize;
input         FD_iso;

// CRC 15
output [14:0] crc_15;
reg    [14:0] crc_15_r;
wire          crc_15_next;
wire   [14:0] crc_15_tmp;

assign crc_15_next = data ^ crc_15[14];
assign crc_15_tmp = crc_15<<1;
assign crc_15 = crc_15_r;

// CRC 17
output [16:0] crc_17;
reg    [16:0] crc_17_r;
wire          crc_17_next;
wire   [16:0] crc_17_tmp;

assign crc_17_next = data ^ crc_17[16];
assign crc_17_tmp = crc_17<<1;
assign crc_17 = crc_17_r;

// CRC 21
output [20:0] crc_21;
reg    [20:0] crc_21_r;
wire          crc_21_next;
wire   [20:0] crc_21_tmp;

assign crc_21_next = data ^ crc_21[20];
assign crc_21_tmp = crc_21<<1;
assign crc_21 = crc_21_r;

always @ (posedge clk)
begin
  if(initialize & ~FD_iso) begin
    crc_15_r <= #Tp 15'h0;
    crc_17_r <= #Tp 17'h0;
    crc_21_r <= #Tp 21'h0;
  end
  else if (initialize & FD_iso) begin
    crc_15_r <= #Tp 15'h0;
    crc_17_r <= #Tp 17'h10000;
    crc_21_r <= #Tp 21'h100000;
  end
  else if (enable)
    begin

      // Bit stuffs não são utilizados no calculo do CRC de frames CAN Classico
      if (crc_15_next & ~stuff_bit) begin
        crc_15_r <= #Tp crc_15_tmp ^ CRC15_POL;
      end else if (~crc_15_next & ~stuff_bit) begin
        crc_15_r <= #Tp crc_15_tmp;
      end

      if (crc_17_next) begin
        crc_17_r <= #Tp crc_17_tmp ^ CRC17_POL;
      end else begin
        crc_17_r <= #Tp crc_17_tmp;
      end 

      if (crc_21_next) begin
        crc_21_r <= #Tp crc_21_tmp ^ CRC21_POL;
      end else begin
        crc_21_r <= #Tp crc_21_tmp;
      end

    end
end


endmodule
