/**
	Compatibility module. Should not be used in new designs.
	Use can_top_raw with appropriate interface (can_ifc_*).
*/

`include "timescale.v"
`include "can_defines.v"

module can_top
(
  `ifdef CAN_WISHBONE_IF
    input  wire       wb_clk_i,
    input  wire       wb_rst_i,
    input  wire [7:0] wb_dat_i,
    output wire [7:0] wb_dat_o,
    input  wire       wb_cyc_i,
    input  wire       wb_stb_i,
    input  wire       wb_we_i,
    input  wire [7:0] wb_adr_i,
    output reg        wb_ack_o,
  `else
    input  wire       rst_i,
    input  wire       ale_i,
    input  wire       rd_i,
    input  wire       wr_i,
    inout  wire [7:0] port_0_io,
    input  wire       cs_can_i,
  `endif
  input  wire         clk_i,
  input  wire         rx_i,
  output wire         tx_o,
  output wire         bus_off_on,
  output wire         irq_on,
  output wire         clkout_o,
  output wire         bus_on_off

  // Bist
`ifdef CAN_BIST
  ,
  // debug chain signals
  input  wire mbist_si_i,       // bist scan serial in
  output wire mbist_so_o,       // bist scan serial out
  input [`CAN_MBIST_CTRL_WIDTH - 1:0] mbist_ctrl_i        // bist chain shift control
`endif
);


wire       reg_rst;
wire       reg_re;
wire       reg_we;
wire [7:0] reg_addr;
wire [7:0] reg_data_in;
wire [7:0] reg_data_out;

can_top_raw can_top_raw_inst (
  .reg_we_i(reg_we),
  .reg_re_i(reg_re),
  .reg_data_in(reg_data_in),
  .reg_data_out(reg_data_out),
  .reg_addr_read_i(reg_addr),
  .reg_addr_write_i(reg_addr),
  .reg_rst_i(reg_rst),

  .clk_i(clk_i),
  .rx_i(rx_i),
  .tx_o(tx_o),
  .bus_off_on(bus_on_off),
  .irq_on(irq_on),
  .clkout_o(clkout_o)

  // Bist
`ifdef CAN_BIST
  // debug chain signals
  .mbist_si_i(mbist_si_i),       // bist scan serial in
  .mbist_so_o(mbist_so_o),       // bist scan serial out
  .mbist_ctrl_i(mbist_ctrl_i)    // bist chain shift control
`endif
);

`ifdef CAN_WISHBONE_IF
  can_ifc_wb can_ifc_wb_inst (
    .clk_i(clk_i),
    .reg_rst_o(reg_rst),
    .reg_re_o(reg_re),
    .reg_we_o(reg_we),
    .reg_addr_o(reg_addr),
    .reg_data_in_o(reg_data_in),
    .reg_data_out_i(reg_data_out),
  
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_dat_i(wb_dat_i),
    .wb_dat_o(wb_dat_o),
    .wb_cyc_i(wb_cyc_i),
    .wb_stb_i(wb_stb_i),
    .wb_we_i(wb_we_i),
    .wb_adr_i(wb_adr_i),
    .wb_ack_o(wb_ack_o)
  );
`else
  wire       ale;
  wire       rd;
  wire       wr;
  wire [7:0] port_0;
  wire       cs_can;
  can_ifc_8051 can_ifc_wb_inst (
    .clk_i(clk_i),
    .reg_rst_o(reg_rst),
    .reg_re_o(reg_re),
    .reg_we_o(reg_we),
    .reg_addr_o(reg_addr),
    .reg_data_in_o(reg_data_in),
    .reg_data_out_i(reg_data_out),
  
    .rst_i(rst_i),
    .ale_i(ale),
    .rd_i(rd),
    .wr_i(wr),
    .port_0_io(port_0),
    .cs_can_i(cs_can)
    );
`endif
endmodule
