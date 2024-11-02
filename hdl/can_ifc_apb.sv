`include "timescale.sv"
module can_ifc_apb
(
    output wire        reg_rst_o,
    output wire        reg_re_o,
    output wire        reg_we_o,
    output wire  [7:0] reg_addr_read_o,
    output wire  [7:0] reg_addr_write_o,
    output wire  [7:0] reg_data_in_o,
    input  wire  [7:0] reg_data_out_i,

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
    input  wire        s_apb_pwrite
);
// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
// ADDR_LSB is used for addressing 32/64 bit registers/memories
// ADDR_LSB = 2 for 32 bits (n downto 2)
// ADDR_LSB = 3 for 64 bits (n downto 3)
localparam integer ADDR_LSB = (32/32) + 1;

assign reg_data_in_o    = s_apb_pwdata[7:0];
assign s_apb_prdata     = {24'h000000, reg_data_out_i};

assign reg_addr_read_o  = s_apb_paddr[ADDR_LSB+8-1 : ADDR_LSB];
assign reg_addr_write_o = s_apb_paddr[ADDR_LSB+8-1 : ADDR_LSB];

assign reg_re_o         = s_apb_psel & ~s_apb_pwrite; // & s_apb_enable???
assign reg_we_o         = s_apb_psel &  s_apb_pwrite & ~s_apb_penable;
// ignore s_apb_pstrb
// ignore s_apb_pprot

assign s_apb_pready     = 1;
assign s_apb_pslverr    = 0;

assign reg_rst_o        = ~arstn;

endmodule
