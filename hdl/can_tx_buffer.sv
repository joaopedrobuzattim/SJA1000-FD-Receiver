//////////////////////////////////////////////////////////////////////
////                                                              ////
////  can_tx_buffer.v                                             ////
////                                                              ////
////  Description: CAN Transmission Buffer                        ////
////                                                              ////
////  Author(s):                                                  ////
////       João Pedro Buzatti                                     ////
////                                                              ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


module can_tx_buffer
( 
  clk,
  rst,
  we,
  addr,
  data_in,

  transmit_buffer_status,

  /* Mode register */
  reset_mode,

  /* Operation Mode Register*/
  extended_mode,
    
  /* Tx data registers. Holding identifier (basic mode), tx frame information (extended mode) and data */
  tx_data_0,
  tx_data_1,
  tx_data_2,
  tx_data_3,
  tx_data_4,
  tx_data_5,
  tx_data_6,
  tx_data_7,
  tx_data_8,
  tx_data_9,
  tx_data_10,
  tx_data_11,
  tx_data_12
  /* End: Tx data registers */
  
);

input         clk;
input         rst;
input         we;
input   [3:0] addr;
input   [7:0] data_in;

input         transmit_buffer_status;

input        extended_mode;

input       reset_mode;

/* Tx data registers. Holding identifier (basic mode), tx frame information (extended mode) and data */
output  [7:0] tx_data_0;
output  [7:0] tx_data_1;
output  [7:0] tx_data_2;
output  [7:0] tx_data_3;
output  [7:0] tx_data_4;
output  [7:0] tx_data_5;
output  [7:0] tx_data_6;
output  [7:0] tx_data_7;
output  [7:0] tx_data_8;
output  [7:0] tx_data_9;
output  [7:0] tx_data_10;
output  [7:0] tx_data_11;
output  [7:0] tx_data_12;
/* End: Tx data registers */

/* This section is for BASIC and EXTENDED mode */
wire we_tx_data_0               = we & (~reset_mode) & ((~extended_mode) & (addr == 8'd0) | extended_mode & (addr == 8'd0)) & transmit_buffer_status;
wire we_tx_data_1               = we & (~reset_mode) & ((~extended_mode) & (addr == 8'd1) | extended_mode & (addr == 8'd1)) & transmit_buffer_status;
wire we_tx_data_2               = we & (~reset_mode) & ((~extended_mode) & (addr == 8'd2) | extended_mode & (addr == 8'd2)) & transmit_buffer_status;
wire we_tx_data_3               = we & (~reset_mode) & ((~extended_mode) & (addr == 8'd3) | extended_mode & (addr == 8'd3)) & transmit_buffer_status;
wire we_tx_data_4               = we & (~reset_mode) & ((~extended_mode) & (addr == 8'd4) | extended_mode & (addr == 8'd4)) & transmit_buffer_status;
wire we_tx_data_5               = we & (~reset_mode) & ((~extended_mode) & (addr == 8'd5) | extended_mode & (addr == 8'd5)) & transmit_buffer_status;
wire we_tx_data_6               = we & (~reset_mode) & ((~extended_mode) & (addr == 8'd6) | extended_mode & (addr == 8'd6)) & transmit_buffer_status;
wire we_tx_data_7               = we & (~reset_mode) & ((~extended_mode) & (addr == 8'd7) | extended_mode & (addr == 8'd7)) & transmit_buffer_status;
wire we_tx_data_8               = we & (~reset_mode) & ((~extended_mode) & (addr == 8'd8) | extended_mode & (addr == 8'd8)) & transmit_buffer_status;
wire we_tx_data_9               = we & (~reset_mode) & ((~extended_mode) & (addr == 8'd9) | extended_mode & (addr == 8'd9)) & transmit_buffer_status;
wire we_tx_data_10              = we & (~reset_mode) & (                                     extended_mode & (addr == 8'd10)) & transmit_buffer_status;
wire we_tx_data_11              = we & (~reset_mode) & (                                     extended_mode & (addr == 8'd11)) & transmit_buffer_status;
wire we_tx_data_12              = we & (~reset_mode) & (                                     extended_mode & (addr == 8'd12)) & transmit_buffer_status;
/* End: This section is for BASIC and EXTENDED mode */


// Tx Buffer Registers

/* Tx data 0 register. */
can_register_asyn #(8) TX_DATA_REG0
( .data_in(data_in),
  .data_out(tx_data_0),
  .we(we_tx_data_0),
  .clk(clk),
  .rst(rst)
);
/* End: Tx data 0 register. */


/* Tx data 1 register. */
can_register_asyn #(8) TX_DATA_REG1
( .data_in(data_in),
  .data_out(tx_data_1),
  .we(we_tx_data_1),
  .clk(clk),
  .rst(rst)
);
/* End: Tx data 1 register. */


/* Tx data 2 register. */
can_register_asyn #(8) TX_DATA_REG2
( .data_in(data_in),
  .data_out(tx_data_2),
  .we(we_tx_data_2),
  .clk(clk),
  .rst(rst)
);
/* End: Tx data 2 register. */


/* Tx data 3 register. */
can_register_asyn #(8) TX_DATA_REG3
( .data_in(data_in),
  .data_out(tx_data_3),
  .we(we_tx_data_3),
  .clk(clk),
  .rst(rst)
);
/* End: Tx data 3 register. */


/* Tx data 4 register. */
can_register_asyn #(8) TX_DATA_REG4
( .data_in(data_in),
  .data_out(tx_data_4),
  .we(we_tx_data_4),
  .clk(clk),
  .rst(rst)
);
/* End: Tx data 4 register. */


/* Tx data 5 register. */
can_register_asyn #(8) TX_DATA_REG5
( .data_in(data_in),
  .data_out(tx_data_5),
  .we(we_tx_data_5),
  .clk(clk),
  .rst(rst)
);
/* End: Tx data 5 register. */


/* Tx data 6 register. */
can_register_asyn #(8) TX_DATA_REG6
( .data_in(data_in),
  .data_out(tx_data_6),
  .we(we_tx_data_6),
  .clk(clk),
  .rst(rst)
);
/* End: Tx data 6 register. */


/* Tx data 7 register. */
can_register_asyn #(8) TX_DATA_REG7
( .data_in(data_in),
  .data_out(tx_data_7),
  .we(we_tx_data_7),
  .clk(clk),
  .rst(rst)
);
/* End: Tx data 7 register. */


/* Tx data 8 register. */
can_register_asyn #(8) TX_DATA_REG8
( .data_in(data_in),
  .data_out(tx_data_8),
  .we(we_tx_data_8),
  .clk(clk),
  .rst(rst)
);
/* End: Tx data 8 register. */


/* Tx data 9 register. */
can_register_asyn #(8) TX_DATA_REG9
( .data_in(data_in),
  .data_out(tx_data_9),
  .we(we_tx_data_9),
  .clk(clk),
  .rst(rst)
);
/* End: Tx data 9 register. */


/* Tx data 10 register. */
can_register_asyn #(8) TX_DATA_REG10
( .data_in(data_in),
  .data_out(tx_data_10),
  .we(we_tx_data_10),
  .clk(clk),
  .rst(rst)
);
/* End: Tx data 10 register. */


/* Tx data 11 register. */
can_register_asyn #(8) TX_DATA_REG11
( .data_in(data_in),
  .data_out(tx_data_11),
  .we(we_tx_data_11),
  .clk(clk),
  .rst(rst)
);
/* End: Tx data 11 register. */


/* Tx data 12 register. */
can_register_asyn #(8) TX_DATA_REG12
( .data_in(data_in),
  .data_out(tx_data_12),
  .we(we_tx_data_12),
  .clk(clk),
  .rst(rst)
);
/* End: Tx data 12 register. */

endmodule