`include "timescale.sv"

module sja1000
(
    input  wire        can_rx,
    output wire        can_tx,
    output wire        bus_off_on,

    input  wire        aclk,
    input  wire        arstn,

    input  wire [31:0] s_apb_paddr,
    input  wire        s_apb_penable,
    input  wire  [2:0] s_apb_pprot,
    output wire [31:0] s_apb_prdata,
    output wire        s_apb_pready,
    input  wire        s_apb_psel,
    output wire        s_apb_pslverr,
    input  wire  [3:0] s_apb_pstrb,
    input  wire [31:0] s_apb_pwdata,
    input  wire        s_apb_pwrite,

    output wire        irq
);
wire reg_we;
wire reg_re;
wire reg_rst;
wire [7:0] reg_data_in;
wire [7:0] reg_data_out;
wire [7:0] reg_addr_read;
wire [7:0] reg_addr_write;

wire irq_n;
assign irq = ~irq_n;

can_ifc_apb can_ifc_apb_inst (
    .aclk(aclk),
    .arstn(arstn),

    .s_apb_paddr(s_apb_paddr),
    .s_apb_penable(s_apb_penable),
    .s_apb_pprot(s_apb_pprot),
    .s_apb_prdata(s_apb_prdata),
    .s_apb_pready(s_apb_pready),
    .s_apb_psel(s_apb_psel),
    .s_apb_pslverr(s_apb_pslverr),
    .s_apb_pstrb(s_apb_pstrb),
    .s_apb_pwdata(s_apb_pwdata),
    .s_apb_pwrite(s_apb_pwrite),

    .reg_rst_o(reg_rst),
    .reg_re_o(reg_re),
    .reg_we_o(reg_we),
    .reg_addr_read_o(reg_addr_read),
    .reg_addr_write_o(reg_addr_write),
    .reg_data_in_o(reg_data_in),
    .reg_data_out_i(reg_data_out)
);

//assign reg_data_out = reg_addr_read; // DBG
can_top_raw can_top_raw_inst (
    .reg_we_i(reg_we),
    .reg_re_i(reg_re),
    .reg_data_in(reg_data_in),
    .reg_data_out(reg_data_out),
    .reg_addr_read_i(reg_addr_read),
    .reg_addr_write_i(reg_addr_write),
    .reg_rst_i(reg_rst),

    .clk_i(aclk),
    .rx_i(can_rx),
    .tx_o(can_tx),
    .bus_off_on(bus_off_on),
    .irq_on(irq_n),
    .clkout_o()
);

endmodule
