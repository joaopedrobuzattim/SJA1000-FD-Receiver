`include "can_testbench_defines.sv"

// ############################################################
// #                                                          #
// #               ------> PARAMETERS <------                 #
// #                                                          #
// ############################################################

//  CTU CAN FD Registers
localparam logic [15:0] CTU_CAN_FD_BASE       = 16'h0000;
localparam logic [15:0] MODE_OFFSET           = 16'h0004;
localparam logic [15:0] SETTINGS_OFFSET       = 16'h0004;
localparam logic [15:0] BTR_OFFSET            = 16'h0024;
localparam logic [15:0] BTR_FD_OFFSET         = 16'h0028;
localparam logic [15:0] TX_STATUS_OFFSET      = 16'h0070;
localparam logic [15:0] TX_COMMAND_OFFSET     = 16'h0074;
localparam logic [15:0] TX_PRIORITY_OFFSET    = 16'h0078;

// CTU CAN FD TX Buffer
localparam logic [15:0] TXTB1_DATA_1_OFFSET   = 16'h0100;
localparam logic [15:0] TXTB1_DATA_2_OFFSET   = 16'h0104;
localparam logic [15:0] TXTB1_DATA_3_OFFSET   = 16'h0108;
localparam logic [15:0] TXTB1_DATA_4_OFFSET   = 16'h010C;
localparam logic [15:0] TXTB1_DATA_5_OFFSET   = 16'h0110;
localparam logic [15:0] TXTB1_DATA_6_OFFSET   = 16'h0114;
localparam logic [15:0] TXTB1_DATA_7_OFFSET   = 16'h0118;
localparam logic [15:0] TXTB1_DATA_8_OFFSET   = 16'h011C;
localparam logic [15:0] TXTB1_DATA_9_OFFSET   = 16'h0120;
localparam logic [15:0] TXTB1_DATA_10_OFFSET  = 16'h0124;
localparam logic [15:0] TXTB1_DATA_11_OFFSET  = 16'h0128;
localparam logic [15:0] TXTB1_DATA_12_OFFSET  = 16'h012C;
localparam logic [15:0] TXTB1_DATA_13_OFFSET  = 16'h0130;
localparam logic [15:0] TXTB1_DATA_14_OFFSET  = 16'h0134;
localparam logic [15:0] TXTB1_DATA_15_OFFSET  = 16'h0138;
localparam logic [15:0] TXTB1_DATA_16_OFFSET  = 16'h013C;
localparam logic [15:0] TXTB1_DATA_17_OFFSET  = 16'h0140;
localparam logic [15:0] TXTB1_DATA_18_OFFSET  = 16'h0144;
localparam logic [15:0] TXTB1_DATA_19_OFFSET  = 16'h0148;
localparam logic [15:0] TXTB1_DATA_20_OFFSET  = 16'h014C;
localparam logic [15:0] TXTB1_DATA_21_OFFSET  = 16'h0150;

// CAN SJA1000 Registers
localparam logic [7:0]  REG_MOD               = 8'h00;
localparam logic [7:0]  REG_CMR               = 8'h01;
localparam logic [7:0]  REG_SR                = 8'h02;
localparam logic [7:0]  REG_IR_EXT            = 8'h03;
localparam logic [7:0]  REG_IER_EXT           = 8'h04;
localparam logic [7:0]  REG_BTR0              = 8'h06;
localparam logic [7:0]  REG_BTR1              = 8'h07;
localparam logic [7:0]  REG_ECC               = 8'h0C;
localparam logic [7:0]  REG_BTR0_FD           = 8'h19;
localparam logic [7:0]  REG_BTR1_FD           = 8'h1A;
localparam logic [7:0]  REG_CDR               = 8'h1F;

// ############################################################
// #                                                          #
// #                ------> STRUCTS <------                   #
// #                                                          #
// ############################################################

typedef struct { 
  logic reg_we;
  logic reg_re;
  logic [31:0] reg_data_in;
  logic [31:0] can_reg_data_out;
  logic [7:0] reg_addr_read;
  logic [7:0] reg_addr_write;
  logic rx_i;
  logic tx_o;
  logic bus_off_on;
  logic irqn;
} t_sja1000_can_fd;


typedef struct {
    logic rx_trigger_nbs;    
    logic rx_trigger_wbs;    
    logic tx_trigger;        
} t_ctu_can_fd_test_probe;


typedef struct { 
  logic res_n_out;
  logic scan_enable;             
  logic [31:0] write_data;      
  logic [31:0] read_data;       
  logic [15:0] address;         
  logic scs;                     
  logic srd;                     
  logic swr;                     
  logic [3:0] sbe;                
  logic inte;                    
  logic can_tx;                  
  logic can_rx;                  
  t_ctu_can_fd_test_probe test_probe;  
  logic [63:0] timestamp;        
} t_ctu_can_fd;

typedef struct { 
  logic [3:0] dlc;
  logic ide;
  logic rtr;
  logic fdf;
  logic [10:0] id_base;
  logic [17:0] id_ext;
  logic [7:0] data [0:63];
} t_can_data_frame;

struct {
  logic [6:0] prop_seg           = 7'd29;
  logic [5:0] phase_seg_1        = 6'd10;
  logic [5:0] phase_seg_2        = 6'd10;
  logic [7:0] baud_r_presc       = 8'd4;
  logic [4:0] sjw                = 5'd3;

  logic [5:0] prop_seg_fd        = 6'd29;
  logic [4:0] phase_seg_1_fd     = 5'd10;
  logic [4:0] phase_seg_2_fd     = 5'd10;
  logic [7:0] baud_r_presc_fd    = 8'd2;
  logic [4:0] sjw_fd             = 5'd3;
  
} ctu_can_fd_timing;

// CAN FD Tolerant - Timing Parameters
struct {
  logic [6:0] prop_seg           = 7'd29;
  logic [5:0] phase_seg_1        = 6'd9;
  logic [5:0] phase_seg_2        = 6'd9;
  logic [6:0] baud_r_presc       = 8'd1;
  logic [4:0] sjw                = 5'd2;
  logic       triple_sampling    = 1'b1;

  logic [5:0] prop_seg_fd        = 6'd29;
  logic [4:0] phase_seg_1_fd     = 5'd9;
  logic [4:0] phase_seg_2_fd     = 5'd9;
  logic [6:0] baud_r_presc_fd    = 8'd0;
  logic [4:0] sjw_fd             = 5'd2;
  logic       triple_sampling_fd = 1'b1;
  
} sja1000_can_fd_timing;

module tb_top();

logic      clk;
logic      extended_mode;
logic      reg_rst;
logic      rx;
logic      can_bus_short_rx;

`include "tb_tasks.sv"

t_sja1000_can_fd can_fd_tolerant, can_fd_receiver;

t_ctu_can_fd ctu_can_fd;


// CAN FD Tolerant
can_top_raw i_can_top_1
( 
  .reg_we_i(can_fd_tolerant.reg_we),
  .reg_re_i(can_fd_tolerant.reg_re),
  .reg_data_in(can_fd_tolerant.reg_data_in),
  .reg_data_out(can_fd_tolerant.can_reg_data_out),
  .reg_addr_read_i(can_fd_tolerant.reg_addr_read),
  .reg_addr_write_i(can_fd_tolerant.reg_addr_write),
  .reg_rst_i(~reg_rst),
  .clk_i(clk),
  .rx_i(can_bus_short_rx),
  .tx_o(can_fd_tolerant.tx_o),
  .bus_off_on(can_fd_tolerant.bus_off_on),
  .irq_on(can_fd_tolerant.irqn)
);

// CAN FD Receiver
can_top_raw i_can_top_2
( 
  .reg_we_i(can_fd_receiver.reg_we),
  .reg_re_i(can_fd_receiver.reg_re),
  .reg_data_in(can_fd_receiver.reg_data_in),
  .reg_data_out(can_fd_receiver.can_reg_data_out),
  .reg_addr_read_i(can_fd_receiver.reg_addr_read),
  .reg_addr_write_i(can_fd_receiver.reg_addr_write),
  .reg_rst_i(~reg_rst),
  .clk_i(clk),
  .rx_i(can_bus_short_rx),
  .tx_o(can_fd_receiver.tx_o),
  .bus_off_on(can_fd_receiver.bus_off_on),
  .irq_on(can_fd_receiver.irqn)
);

// Instanciando CTU CAN FD
can_top_level i_ctu_can_fd 
(
  .clk_sys(clk),
  .res_n(reg_rst),
  .res_n_out(ctu_can_fd.res_n_out),
  .scan_enable(ctu_can_fd.scan_enable),
  .data_in(ctu_can_fd.write_data),
  .data_out(ctu_can_fd.read_data),
  .adress(ctu_can_fd.address),
  .scs(ctu_can_fd.scs),
  .srd(ctu_can_fd.srd),
  .swr(ctu_can_fd.swr),
  .sbe(ctu_can_fd.sbe),
  .\int (ctu_can_fd.inte),
  .can_tx(ctu_can_fd.can_tx),
  .can_rx(can_bus_short_rx),
  .test_probe(ctu_can_fd.test_probe),
  .timestamp(ctu_can_fd.timestamp)
);

// Shorting RX Chanel
assign can_bus_short_rx = can_fd_tolerant.tx_o & ctu_can_fd.can_tx & can_fd_receiver.tx_o;


// Clock de 100MHz
initial
begin
  clk=0;
  forever #5 clk = ~clk;
end

initial
begin
  reg_rst = 1'b0;
  #1000;
  reg_rst = 1'b1;

  #1000;

  fd_frame_ISO_on_bus();
  
  reg_rst = 1'b0;
  #1000;
  reg_rst = 1'b1;
  #1000;

  fd_frame_NON_ISO_on_bus();

  reg_rst = 1'b0;
  #1000;
  reg_rst = 1'b1;
  #1000;

  SJA1000_send_extended_frame();
  
  reg_rst = 1'b0;
  #1000;
  reg_rst = 1'b1;
  #1000;

  error_caused_by_receiving_ISO_FD_Frame();
  // loop_sending_extended_frame();

  #12000;
  $stop;

end

// ############################################################
// #                                                          #
// #                  ------> TASKS <------                   #
// #                                                          #
// ############################################################

// Description: On this task, CTU CAN FD transmists a FD ISO message along the bus 
// and the controllers must handle according to their operation mode: 
// FD Tolerant, FD ISO Receiver, FD NON ISO Receiver 
task fd_frame_ISO_on_bus; 
begin
  bus_timing_register_configuration_CTU_CAN_FD();

  // Mode Reg - CTU CAN FD
  write_CTU_CAN_FD_register(4'b0011, CTU_CAN_FD_BASE + MODE_OFFSET, 32'b00000000000000000000000000010000);

  // Settings Reg - CTU CAN FD
  write_CTU_CAN_FD_register(4'b1100, CTU_CAN_FD_BASE + MODE_OFFSET, 32'b00000000010000000000000000000000);

  wait_11_bits(2000);

  // TX Buffer - CTU CAN FD
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_1_OFFSET,  32'b00000000000000000000001010001111);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_2_OFFSET,  32'b10101010101010101010101010101010);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_3_OFFSET,  32'b00000000000000000000000000000000);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_4_OFFSET,  32'b00000000000000000000000000000000);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_5_OFFSET,  32'b11111111111111111111111111111111);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_6_OFFSET,  32'b00000000000000000000000000000000);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_7_OFFSET,  32'b10101010101010101010101010101010);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_8_OFFSET,  32'b10101010101010101010101010101010);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_9_OFFSET,  32'b10101010101010101010101010101010);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_10_OFFSET, 32'b10101010101010101010101010101010);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_11_OFFSET, 32'b10101010101010101010101010101010);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_12_OFFSET, 32'b10101010101010101010101010101010);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_13_OFFSET, 32'b10101010101010101010101010101010);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_14_OFFSET, 32'b10101010101010101010101010101010);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_15_OFFSET, 32'b10101010101010101010101010101010);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_16_OFFSET, 32'b10101010101010101010101010101010);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_17_OFFSET, 32'b10101010101010101010101010101010);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_18_OFFSET, 32'b10101010101010101010101010101010);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_19_OFFSET, 32'b10101010101010101010101010101010);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_20_OFFSET, 32'b10101010101010101010101010101010);

  // Reset Mode - SJA1000
  write_CAN_FD_Tolerant_Register(REG_MOD, 8'h1);
  write_CAN_FD_Receiver_Register(REG_MOD, 8'h1);


  // Extended Mode - SJA10000
  write_CAN_FD_Tolerant_Register(REG_CDR, {1'b1, 7'h0});  
  write_CAN_FD_Receiver_Register(REG_CDR, {1'b1, 7'h0});  

  bus_timing_register_configuration_SJA1000();

  // Enable interruptions 
  write_CAN_FD_Tolerant_Register(REG_IER_EXT, 8'hFF);  
  write_CAN_FD_Receiver_Register(REG_IER_EXT, 8'hFF);  

  // Acceptance Code and Acceptance Mask - SJA10000
  write_CAN_FD_Tolerant_Register(8'd16, 8'ha6); // acceptance code 0
  write_CAN_FD_Tolerant_Register(8'd17, 8'hb0); // acceptance code 1
  write_CAN_FD_Tolerant_Register(8'd18, 8'h12); // acceptance code 2
  write_CAN_FD_Tolerant_Register(8'd19, 8'h30); // acceptance code 3
  write_CAN_FD_Tolerant_Register(8'd20, 8'hff); // acceptance mask 0
  write_CAN_FD_Tolerant_Register(8'd21, 8'hff); // acceptance mask 1
  write_CAN_FD_Tolerant_Register(8'd22, 8'hff); // acceptance mask 2
  write_CAN_FD_Tolerant_Register(8'd23, 8'hff); // acceptance mask 3

  write_CAN_FD_Receiver_Register(8'd16, 8'ha6); // acceptance code 0
  write_CAN_FD_Receiver_Register(8'd17, 8'hb0); // acceptance code 1
  write_CAN_FD_Receiver_Register(8'd18, 8'h12); // acceptance code 2
  write_CAN_FD_Receiver_Register(8'd19, 8'h30); // acceptance code 3
  write_CAN_FD_Receiver_Register(8'd20, 8'hff); // acceptance mask 0
  write_CAN_FD_Receiver_Register(8'd21, 8'hff); // acceptance mask 1
  write_CAN_FD_Receiver_Register(8'd22, 8'hff); // acceptance mask 2
  write_CAN_FD_Receiver_Register(8'd23, 8'hff); // acceptance mask 3

  // FD RX (ISO) - SJA1000
  write_CAN_FD_Receiver_Register(8'd24, 8'h3);

  // FD Tolerant - SJA1000
  write_CAN_FD_Tolerant_Register(8'd24, 8'h0);


  // Operation Mode - SJA1000
  write_CAN_FD_Tolerant_Register(REG_MOD, 8'h0);
  write_CAN_FD_Receiver_Register(REG_MOD, 8'h0);

 wait_11_bits(2000);

  // TX COMMAND - CTU CAN FD
  write_CTU_CAN_FD_register(4'b0011, CTU_CAN_FD_BASE + TX_COMMAND_OFFSET, 32'b00000000000000000000000100000010);

  // Wait for SJA1000 Receive interrupt 
  wait(can_fd_receiver.irqn == 1'b0);

  // Reading Interrupt Register
  can_fd_receiver.reg_re = 1'b1;
  can_fd_receiver.reg_addr_read = REG_IR_EXT;
  wait(can_fd_receiver.can_reg_data_out != 32'h0);

  assert (can_fd_receiver.can_reg_data_out == 32'h1) $display ("(%0t) Receive Interrupt on CAN 2!\n", $time);
  else $error("(%0t) Expect to read Receive Interrupt on CAN 2!\n", $time);
  
  @ (posedge clk);

  assert (can_fd_receiver.irqn == 1'b1) $display ("(%0t) CAN 2 Interrup Flag Reseted!\n", $time);
  else $error("(%0t) Expect CAN 2 Interrupt Signal to be on logic level 1!\n", $time);

  // Reading Status Register
  can_fd_receiver.reg_re = 1'b1;
  can_fd_receiver.reg_addr_read = REG_SR;
  wait (can_fd_receiver.can_reg_data_out[0] == 1'h1);
  $display("(%0t) CAN 2 has message(s) available at FIFO \n", $time);

  // Reading FIFO
  can_fd_receiver.reg_re = 1'b1;

  can_fd_receiver.reg_addr_read = 8'd16;  
  wait (can_fd_receiver.can_reg_data_out == 32'h0000002F);
  $display("(%0t) CAN 2 FIFO Data 0: %b\n", $time, can_fd_receiver.can_reg_data_out);
  $display("(%0t) ide: %b\n", $time, can_fd_receiver.can_reg_data_out[7]);
  $display("(%0t) fdf: %b\n", $time, can_fd_receiver.can_reg_data_out[5]);
  $display("(%0t) esi: %b\n", $time, can_fd_receiver.can_reg_data_out[4]);
  $display("(%0t) DLC: %b\n", $time, can_fd_receiver.can_reg_data_out[3:0]);

  can_fd_receiver.reg_addr_read = 8'd17;  
  wait (can_fd_receiver.can_reg_data_out == 32'h00000055);
  $display("(%0t) CAN 2 FIFO Data 1: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd18;  
  wait (can_fd_receiver.can_reg_data_out == 32'h00000040);
  $display("(%0t) CAN 2 FIFO Data 2: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd19;  
  wait (can_fd_receiver.can_reg_data_out == 32'hFFFFFFFF);
  $display("(%0t) CAN 2 FIFO Data 3: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd20;  
  wait (can_fd_receiver.can_reg_data_out == 32'h00000000);
  $display("(%0t) CAN 2 FIFO Data 4: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd21;  
  wait (can_fd_receiver.can_reg_data_out == 32'hAAAAAAAA);
  $display("(%0t) CAN 2 FIFO Data 5: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd22;  
  wait (can_fd_receiver.can_reg_data_out == 32'hAAAAAAAA);
  $display("(%0t) CAN 2 FIFO Data 6: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd23;  
  wait (can_fd_receiver.can_reg_data_out == 32'hAAAAAAAA);
  $display("(%0t) CAN 2 FIFO Data 7: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd24;  
  wait (can_fd_receiver.can_reg_data_out == 32'hAAAAAAAA);
  $display("(%0t) CAN 2 FIFO Data 8: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd25;  
  wait (can_fd_receiver.can_reg_data_out == 32'hAAAAAAAA);
  $display("(%0t) CAN 2 FIFO Data 9: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd26;  
  wait (can_fd_receiver.can_reg_data_out == 32'hAAAAAAAA);
  $display("(%0t) CAN 2 FIFO Data 10: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd27;  
  wait (can_fd_receiver.can_reg_data_out == 32'hAAAAAAAA);
  $display("(%0t) CAN 2 FIFO Data 11: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd28;  
  wait (can_fd_receiver.can_reg_data_out == 32'hAAAAAAAA);
  $display("(%0t) CAN 2 FIFO Data 12: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd32;  
  wait (can_fd_receiver.can_reg_data_out == 32'hAAAAAAAA);
  $display("(%0t) CAN 2 FIFO Data 13: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd33;  
  wait (can_fd_receiver.can_reg_data_out == 32'hAAAAAAAA);
  $display("(%0t) CAN 2 FIFO Data 14: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd34;  
  wait (can_fd_receiver.can_reg_data_out == 32'hAAAAAAAA);
  $display("(%0t) CAN 2 FIFO Data 15: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd35;  
  wait (can_fd_receiver.can_reg_data_out == 32'hAAAAAAAA);
  $display("(%0t) CAN 2 FIFO Data 16: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd36;  
  wait (can_fd_receiver.can_reg_data_out == 32'hAAAAAAAA);
  $display("(%0t) CAN 2 FIFO Data 17: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd37;  
  wait (can_fd_receiver.can_reg_data_out == 32'hAAAAAAAA);
  $display("(%0t) CAN 2 FIFO Data 18: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd38;  
  wait (can_fd_receiver.can_reg_data_out == 32'hAAAAAAAA);
  $display("(%0t) CAN 2 FIFO Data 17: %b\n", $time, can_fd_receiver.can_reg_data_out);

    can_fd_receiver.reg_addr_read = 8'd39;  
  wait (can_fd_receiver.can_reg_data_out == 32'hAAAAAAAA);
  $display("(%0t) CAN 2 FIFO Data 18: %b\n", $time, can_fd_receiver.can_reg_data_out);

  // Release RX Buffer Command
  write_CAN_FD_Receiver_Register(REG_CMR, 32'h4);

  // Reading Status Register
  can_fd_receiver.reg_re = 1'b1;
  can_fd_receiver.reg_addr_read = REG_SR;
  wait (can_fd_receiver.can_reg_data_out[0] == 1'h0);
  $display("(%0t) CAN 2 has no message(s) available at FIFO \n", $time);

end
endtask


// Description: On this task, CTU CAN FD transmists a FD NON ISO message along the bus 
// and the controllers must handle according to their operation mode: 
// FD Tolerant, FD ISO Receiver, FD NON ISO Receiver 
task fd_frame_NON_ISO_on_bus; 
begin
  bus_timing_register_configuration_CTU_CAN_FD();

  // Mode Reg - CTU CAN FD
  write_CTU_CAN_FD_register(4'b0011, CTU_CAN_FD_BASE + MODE_OFFSET, 32'b00000000000000000000000000010000);

  // Settings Reg - CTU CAN FD
  write_CTU_CAN_FD_register(4'b1100, CTU_CAN_FD_BASE + MODE_OFFSET, 32'b00000000110000000000000000000000);

  wait_11_bits(2000);

 // TX Buffer - CTU CAN FD
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_1_OFFSET,  32'b00000000000000000000001011000111);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_2_OFFSET,  32'b10101010101010101010101010101010);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_3_OFFSET,  32'b00000000000000000000000000000000);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_4_OFFSET,  32'b00000000000000000000000000000000);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_5_OFFSET,  32'b11111111111111111111111111111111);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_6_OFFSET,  32'b00000000000000000000000000000000);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_7_OFFSET,  32'b10101010101010101010101010101010);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_8_OFFSET,  32'b10101010101010101010101010101010);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_9_OFFSET,  32'b10101010101010101010101010101010);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_10_OFFSET, 32'b10101010101010101010101010101010);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_11_OFFSET, 32'b10101010101010101010101010101010);

  // Reset Mode - SJA1000
  write_CAN_FD_Tolerant_Register(REG_MOD, 8'h1);
  write_CAN_FD_Receiver_Register(REG_MOD, 8'h1);


  // Extended Mode - SJA10000
  write_CAN_FD_Tolerant_Register(REG_CDR, {1'b1, 7'h0});  
  write_CAN_FD_Receiver_Register(REG_CDR, {1'b1, 7'h0});  

  bus_timing_register_configuration_SJA1000();

  // Enable interruptions 
  write_CAN_FD_Tolerant_Register(REG_IER_EXT, 8'hFF);  
  write_CAN_FD_Receiver_Register(REG_IER_EXT, 8'hFF);  

  // Acceptance Code and Acceptance Mask - SJA10000
  write_CAN_FD_Tolerant_Register(8'd16, 8'ha6); // acceptance code 0
  write_CAN_FD_Tolerant_Register(8'd17, 8'hb0); // acceptance code 1
  write_CAN_FD_Tolerant_Register(8'd18, 8'h12); // acceptance code 2
  write_CAN_FD_Tolerant_Register(8'd19, 8'h30); // acceptance code 3
  write_CAN_FD_Tolerant_Register(8'd20, 8'hff); // acceptance mask 0
  write_CAN_FD_Tolerant_Register(8'd21, 8'hff); // acceptance mask 1
  write_CAN_FD_Tolerant_Register(8'd22, 8'hff); // acceptance mask 2
  write_CAN_FD_Tolerant_Register(8'd23, 8'hff); // acceptance mask 3

  write_CAN_FD_Receiver_Register(8'd16, 8'ha6); // acceptance code 0
  write_CAN_FD_Receiver_Register(8'd17, 8'hb0); // acceptance code 1
  write_CAN_FD_Receiver_Register(8'd18, 8'h12); // acceptance code 2
  write_CAN_FD_Receiver_Register(8'd19, 8'h30); // acceptance code 3
  write_CAN_FD_Receiver_Register(8'd20, 8'hff); // acceptance mask 0
  write_CAN_FD_Receiver_Register(8'd21, 8'hff); // acceptance mask 1
  write_CAN_FD_Receiver_Register(8'd22, 8'hff); // acceptance mask 2
  write_CAN_FD_Receiver_Register(8'd23, 8'hff); // acceptance mask 3

  // FD RX (NON ISO) - SJA1000
  write_CAN_FD_Receiver_Register(8'd24, 8'h1);

  // FD Tolerant - SJA1000
  write_CAN_FD_Tolerant_Register(8'd24, 8'h0);


  // Operation Mode - SJA1000
  write_CAN_FD_Tolerant_Register(REG_MOD, 8'h0);
  write_CAN_FD_Receiver_Register(REG_MOD, 8'h0);

  wait_11_bits(2000);

  // TX COMMAND - CTU CAN FD
  write_CTU_CAN_FD_register(4'b0011, CTU_CAN_FD_BASE + TX_COMMAND_OFFSET, 32'b00000000000000000000000100000010);

  // Wait for SJA1000 Receive interrupt 
  wait(can_fd_receiver.irqn == 1'b0);

  // Reading Interrupt Register
  can_fd_receiver.reg_re = 1'b1;
  can_fd_receiver.reg_addr_read = REG_IR_EXT;
  wait(can_fd_receiver.can_reg_data_out == 32'h1);

  assert (can_fd_receiver.can_reg_data_out == 32'h1) $display ("(%0t) Receive Interrupt on CAN 2!\n", $time);
  else $error("(%0t) Expect to read Receive Interrupt on CAN 2!\n", $time);
  
  @ (posedge clk);

  assert (can_fd_receiver.irqn == 1'b1) $display ("(%0t) CAN 2 Interrup Flag Reseted!\n", $time);
  else $error("(%0t) Expect CAN 2 Interrupt Signal to be on logic level 1!\n", $time);

  // Reading Status Register
  can_fd_receiver.reg_re = 1'b1;
  can_fd_receiver.reg_addr_read = REG_SR;
  wait (can_fd_receiver.can_reg_data_out[0] == 1'h1);
  $display("(%0t) CAN 2 has message(s) available at FIFO \n", $time);

  // Reading FIFO
  can_fd_receiver.reg_re = 1'b1;

  can_fd_receiver.reg_addr_read = 8'd16;  
  wait (can_fd_receiver.can_reg_data_out == 32'h000000A7);
  $display("(%0t) CAN 2 FIFO Data 0: %b\n", $time, can_fd_receiver.can_reg_data_out);
  $display("(%0t) ide: %b\n", $time, can_fd_receiver.can_reg_data_out[7]);
  $display("(%0t) fdf: %b\n", $time, can_fd_receiver.can_reg_data_out[5]);
  $display("(%0t) esi: %b\n", $time, can_fd_receiver.can_reg_data_out[4]);
  $display("(%0t) DLC: %b\n", $time, can_fd_receiver.can_reg_data_out[3:0]);

  can_fd_receiver.reg_addr_read = 8'd17;  
  wait (can_fd_receiver.can_reg_data_out == 32'h00000055);
  $display("(%0t) CAN 2 FIFO Data 1: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd18;  
  wait (can_fd_receiver.can_reg_data_out == 32'h00000055);
  $display("(%0t) CAN 2 FIFO Data 2: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd19;  
  wait (can_fd_receiver.can_reg_data_out == 32'h00000055);
  $display("(%0t) CAN 2 FIFO Data 3: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd20;  
  wait (can_fd_receiver.can_reg_data_out == 32'h00000050);
  $display("(%0t) CAN 2 FIFO Data 4: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd21;  
  wait (can_fd_receiver.can_reg_data_out == 32'hFFFFFFFF);
  $display("(%0t) CAN 2 FIFO Data 5: %b\n", $time, can_fd_receiver.can_reg_data_out);

  can_fd_receiver.reg_addr_read = 8'd22;  
  wait (can_fd_receiver.can_reg_data_out[23:0] == 24'h000000);
  $display("(%0t) CAN 2 FIFO Data 6: %b\n", $time, can_fd_receiver.can_reg_data_out[23:0]);

  // Release RX Buffer Command
  write_CAN_FD_Receiver_Register(REG_CMR, 32'h4);

  // Reading Status Register
  can_fd_receiver.reg_re = 1'b1;
  can_fd_receiver.reg_addr_read = REG_SR;
  wait (can_fd_receiver.can_reg_data_out[0] == 1'h0);
  $display("(%0t) CAN 2 has no message(s) available at FIFO \n", $time);


end
endtask


// Description: On this task, both SJA1000 controllers send extended frame
task SJA1000_send_extended_frame;
begin
  bus_timing_register_configuration_CTU_CAN_FD();

  // Mode Reg - CTU CAN FD
  write_CTU_CAN_FD_register(4'b0011, CTU_CAN_FD_BASE + MODE_OFFSET, 32'b00000000000000000000000000010000);

  // Settings Reg - CTU CAN FD
  write_CTU_CAN_FD_register(4'b1100, CTU_CAN_FD_BASE + MODE_OFFSET, 32'b00000000010000000000000000000000);

  wait_11_bits(2000);

  // Reset Mode - SJA1000
  write_CAN_FD_Tolerant_Register(REG_MOD, 8'h1);
  write_CAN_FD_Receiver_Register(REG_MOD, 8'h1);


  // Extended Mode - SJA10000
  write_CAN_FD_Tolerant_Register(REG_CDR, {1'b1, 7'h0});  
  write_CAN_FD_Receiver_Register(REG_CDR, {1'b1, 7'h0});  

  bus_timing_register_configuration_SJA1000();

  // Enable interruptions 
  write_CAN_FD_Tolerant_Register(REG_IER_EXT, 8'hFF);  
  write_CAN_FD_Receiver_Register(REG_IER_EXT, 8'hFF);  

  // Acceptance Code and Acceptance Mask - SJA10000
  write_CAN_FD_Tolerant_Register(8'd16, 8'ha6); // acceptance code 0
  write_CAN_FD_Tolerant_Register(8'd17, 8'hb0); // acceptance code 1
  write_CAN_FD_Tolerant_Register(8'd18, 8'h12); // acceptance code 2
  write_CAN_FD_Tolerant_Register(8'd19, 8'h30); // acceptance code 3
  write_CAN_FD_Tolerant_Register(8'd20, 8'hff); // acceptance mask 0
  write_CAN_FD_Tolerant_Register(8'd21, 8'hff); // acceptance mask 1
  write_CAN_FD_Tolerant_Register(8'd22, 8'hff); // acceptance mask 2
  write_CAN_FD_Tolerant_Register(8'd23, 8'hff); // acceptance mask 3

  write_CAN_FD_Receiver_Register(8'd16, 8'ha6); // acceptance code 0
  write_CAN_FD_Receiver_Register(8'd17, 8'hb0); // acceptance code 1
  write_CAN_FD_Receiver_Register(8'd18, 8'h12); // acceptance code 2
  write_CAN_FD_Receiver_Register(8'd19, 8'h30); // acceptance code 3
  write_CAN_FD_Receiver_Register(8'd20, 8'hff); // acceptance mask 0
  write_CAN_FD_Receiver_Register(8'd21, 8'hff); // acceptance mask 1
  write_CAN_FD_Receiver_Register(8'd22, 8'hff); // acceptance mask 2
  write_CAN_FD_Receiver_Register(8'd23, 8'hff); // acceptance mask 3

  // FD RX (NON ISO) - SJA1000
  write_CAN_FD_Receiver_Register(8'd24, 8'h1);

  // FD Tolerant - SJA1000
  write_CAN_FD_Tolerant_Register(8'd24, 8'h0);

  // Operation Mode - SJA1000
  write_CAN_FD_Tolerant_Register(REG_MOD, 8'h0);
  write_CAN_FD_Receiver_Register(REG_MOD, 8'h0);

wait_11_bits(2000);


// TX Buffer - SJA1000 
write_CAN_FD_Tolerant_Register(8'h10, 8'h88);
write_CAN_FD_Tolerant_Register(8'h11, 8'hA6);
write_CAN_FD_Tolerant_Register(8'h12, 8'h00);
write_CAN_FD_Tolerant_Register(8'h13, 8'h5A);
write_CAN_FD_Tolerant_Register(8'h14, 8'hA8);
write_CAN_FD_Tolerant_Register(8'h15, 8'hFF);
write_CAN_FD_Tolerant_Register(8'h16, 8'hFF);
write_CAN_FD_Tolerant_Register(8'h17, 8'hBC);
write_CAN_FD_Tolerant_Register(8'h18, 8'hDE);
write_CAN_FD_Tolerant_Register(8'h19, 8'hF0);
write_CAN_FD_Tolerant_Register(8'h1A, 8'h0F);
write_CAN_FD_Tolerant_Register(8'h1B, 8'hED);
write_CAN_FD_Tolerant_Register(8'h1C, 8'hCB);

write_CAN_FD_Receiver_Register(8'h10, 8'h88);
write_CAN_FD_Receiver_Register(8'h11, 8'hA6);
write_CAN_FD_Receiver_Register(8'h12, 8'h00);
write_CAN_FD_Receiver_Register(8'h13, 8'h5A);
write_CAN_FD_Receiver_Register(8'h14, 8'hA8);
write_CAN_FD_Receiver_Register(8'h15, 8'hFF);
write_CAN_FD_Receiver_Register(8'h16, 8'hFF);
write_CAN_FD_Receiver_Register(8'h17, 8'hBC);
write_CAN_FD_Receiver_Register(8'h18, 8'hDE);
write_CAN_FD_Receiver_Register(8'h19, 8'hF0);
write_CAN_FD_Receiver_Register(8'h1A, 8'h0F);
write_CAN_FD_Receiver_Register(8'h1B, 8'hED);
write_CAN_FD_Receiver_Register(8'h1C, 8'hCB);  
  
// FD Receiver TX Command - SJA1000
write_CAN_FD_Receiver_Register(REG_CMR, 8'h01);

// Wait for interruptions on CAN 1 and CAN 2
wait(can_fd_receiver.irqn == 1'b0 && can_fd_tolerant.irqn == 1'b0);

// Reading Interrupt Register CAN 2
can_fd_receiver.reg_re = 1'b1;
can_fd_receiver.reg_addr_read = REG_IR_EXT;
wait(can_fd_receiver.can_reg_data_out == 32'h2);
assert (can_fd_receiver.can_reg_data_out == 32'h2) $display ("(%0t) Transmit Interrupt on CAN 2!\n", $time);
else $error("(%0t) Expect to read Transmit Interrupt on CAN 2!\n", $time);
can_fd_receiver.reg_re = 1'b0;

// Reading Interrupt Register CAN 1
can_fd_tolerant.reg_re = 1'b1;
can_fd_tolerant.reg_addr_read = REG_IR_EXT;
wait(can_fd_tolerant.can_reg_data_out == 32'h1);
assert (can_fd_tolerant.can_reg_data_out == 32'h1) $display ("(%0t) Receive Interrupt on CAN 1!\n", $time);
else $error("(%0t) Expect to read Receive Interrupr on CAN 1!\n", $time);
can_fd_tolerant.reg_re = 1'b0;

// Reading Status Register
can_fd_tolerant.reg_re = 1'b1;
can_fd_tolerant.reg_addr_read = REG_SR;
wait (can_fd_tolerant.can_reg_data_out[0] == 1'h1);
$display("(%0t) CAN 1 has message(s) available at FIFO \n", $time);

// Reading FIFO
can_fd_tolerant.reg_re = 1'b1;

can_fd_tolerant.reg_addr_read = 8'd16;  
wait (can_fd_tolerant.can_reg_data_out == 32'h00000088);
$display("(%0t) CAN 1 FIFO Data 0: %b\n", $time, can_fd_tolerant.can_reg_data_out);
$display("(%0t) ide: %b\n", $time, can_fd_tolerant.can_reg_data_out[7]);
$display("(%0t) fdf: %b\n", $time, can_fd_tolerant.can_reg_data_out[5]);
$display("(%0t) esi: %b\n", $time, can_fd_tolerant.can_reg_data_out[4]);
$display("(%0t) DLC: %b\n", $time, can_fd_tolerant.can_reg_data_out[3:0]);

can_fd_tolerant.reg_addr_read = 8'd17;  
wait (can_fd_tolerant.can_reg_data_out == 32'h000000A6);
$display("(%0t) CAN 1 FIFO Data 1: %b\n", $time, can_fd_tolerant.can_reg_data_out);

can_fd_tolerant.reg_addr_read = 8'd18;  
wait (can_fd_tolerant.can_reg_data_out == 32'h00000000);
$display("(%0t) CAN 1 FIFO Data 2: %b\n", $time, can_fd_tolerant.can_reg_data_out);

can_fd_tolerant.reg_addr_read = 8'd19;  
wait (can_fd_tolerant.can_reg_data_out == 32'h0000005A);
$display("(%0t) CAN 1 FIFO Data 3: %b\n", $time, can_fd_tolerant.can_reg_data_out);

can_fd_tolerant.reg_addr_read = 8'd20;  
wait (can_fd_tolerant.can_reg_data_out == 32'h000000A8);
$display("(%0t) CAN 1 FIFO Data 4: %b\n", $time, can_fd_tolerant.can_reg_data_out);

can_fd_tolerant.reg_addr_read = 8'd21;  
wait (can_fd_tolerant.can_reg_data_out == 32'hFFFFBCDE);
$display("(%0t) CAN 1 FIFO Data 5: %b\n", $time, can_fd_tolerant.can_reg_data_out);

can_fd_tolerant.reg_addr_read = 8'd22;  
wait (can_fd_tolerant.can_reg_data_out == 32'hF00FEDCB);
$display("(%0t) CAN 1 FIFO Data 6: %b\n", $time, can_fd_tolerant.can_reg_data_out);

// Release RX Buffer Command
write_CAN_FD_Tolerant_Register(REG_CMR, 32'h4);

// Reading Status Register
can_fd_tolerant.reg_re = 1'b1;
can_fd_tolerant.reg_addr_read = REG_SR;
wait (can_fd_tolerant.can_reg_data_out[0] == 1'h0);
$display("(%0t) CAN 1 has no message(s) available at FIFO \n", $time);
can_fd_tolerant.reg_re = 1'b0;
can_fd_receiver.reg_re = 1'b0;

// FD Tolerant TX Command - SJA1000
write_CAN_FD_Tolerant_Register(REG_CMR, 8'h01);

// Wait for interruptions on CAN 1 and CAN 2
wait(can_fd_receiver.irqn == 1'b0 && can_fd_tolerant.irqn == 1'b0);

// Reading Interrupt Register CAN 2
can_fd_receiver.reg_re = 1'b1;
can_fd_receiver.reg_addr_read = REG_IR_EXT;
wait(can_fd_receiver.can_reg_data_out == 32'h1);
$display("(%0t) CAN 2 Interrupt Register: %h\n", $time, can_fd_receiver.can_reg_data_out);
can_fd_receiver.reg_re = 1'b0;

// Reading Interrupt Register CAN 1
can_fd_tolerant.reg_re = 1'b1;
can_fd_tolerant.reg_addr_read = REG_IR_EXT;
wait(can_fd_tolerant.can_reg_data_out == 32'h2);
$display("(%0t) CAN 1 Interrupt Register: %h\n", $time, can_fd_tolerant.can_reg_data_out);
can_fd_tolerant.reg_re = 1'b0;

// Reading Status Register
can_fd_receiver.reg_re = 1'b1;
can_fd_receiver.reg_addr_read = REG_SR;
wait (can_fd_receiver.can_reg_data_out[0] == 1'h1);
$display("(%0t) CAN 1 has message(s) available at FIFO \n", $time);

// Reading FIFO
can_fd_receiver.reg_re = 1'b1;

can_fd_receiver.reg_addr_read = 8'd16;  
wait (can_fd_receiver.can_reg_data_out == 32'h00000088);
$display("(%0t) CAN 1 FIFO Data 0: %b\n", $time, can_fd_receiver.can_reg_data_out);
$display("(%0t) ide: %b\n", $time, can_fd_receiver.can_reg_data_out[7]);
$display("(%0t) fdf: %b\n", $time, can_fd_receiver.can_reg_data_out[5]);
$display("(%0t) esi: %b\n", $time, can_fd_receiver.can_reg_data_out[4]);
$display("(%0t) DLC: %b\n", $time, can_fd_receiver.can_reg_data_out[3:0]);

can_fd_receiver.reg_addr_read = 8'd17;  
wait (can_fd_receiver.can_reg_data_out == 32'h000000A6);
$display("(%0t) CAN 1 FIFO Data 1: %b\n", $time, can_fd_receiver.can_reg_data_out);

can_fd_receiver.reg_addr_read = 8'd18;  
wait (can_fd_receiver.can_reg_data_out == 32'h00000000);
$display("(%0t) CAN 1 FIFO Data 2: %b\n", $time, can_fd_receiver.can_reg_data_out);

can_fd_receiver.reg_addr_read = 8'd19;  
wait (can_fd_receiver.can_reg_data_out == 32'h0000005A);
$display("(%0t) CAN 1 FIFO Data 3: %b\n", $time, can_fd_receiver.can_reg_data_out);

can_fd_receiver.reg_addr_read = 8'd20;  
wait (can_fd_receiver.can_reg_data_out == 32'h000000A8);
$display("(%0t) CAN 1 FIFO Data 4: %b\n", $time, can_fd_receiver.can_reg_data_out);

can_fd_receiver.reg_addr_read = 8'd21;  
wait (can_fd_receiver.can_reg_data_out == 32'hFFFFBCDE);
$display("(%0t) CAN 1 FIFO Data 5: %b\n", $time, can_fd_receiver.can_reg_data_out);

can_fd_receiver.reg_addr_read = 8'd22;  
wait (can_fd_receiver.can_reg_data_out == 32'hF00FEDCB);
$display("(%0t) CAN 1 FIFO Data 6: %b\n", $time, can_fd_receiver.can_reg_data_out);

end
endtask


// Description: On this task, wr on CTU CAN FD is performed
task write_CTU_CAN_FD_register;
  input [3:0] sbe_in;
  input [15:0] addr_in;
  input [31:0] data_in;

  begin
    $display("----------------------------------------\n");
    $display("(%0t) Writing CTU CAN FD register [%0d] (sbe: %0d) with 0x%0x", $time, addr_in, sbe_in, data_in);
    $display("----------------------------------------\n");
    @ (posedge clk);
    ctu_can_fd.scs = 1'b1;
    ctu_can_fd.swr = 1'b1;
    ctu_can_fd.address = addr_in;
    ctu_can_fd.write_data = data_in;
    ctu_can_fd.sbe = sbe_in;
    @ (posedge clk);
    @ (negedge clk);
    ctu_can_fd.scs = 1'b0;
    ctu_can_fd.swr = 1'b0;
    ctu_can_fd.sbe = 4'b0000;
  end
endtask

// Description: On this task, wr on CAN FD Tolerant is performed
task write_CAN_FD_Tolerant_Register;
  input [31:0] reg_addr;
  input [31:0] reg_data;

  begin
    $display("----------------------------------------\n");
    $display("(%0t) Writing on CAN FD Tolerant register [%0d] with 0x%0x", $time, reg_addr, reg_data);
    $display("----------------------------------------\n");
    @ (posedge clk);
    can_fd_tolerant.reg_addr_write = reg_addr;
    can_fd_tolerant.reg_data_in = reg_data;
    can_fd_tolerant.reg_we = 1'b1;
    @ (posedge clk);
    @ (negedge clk);
    can_fd_tolerant.reg_we = 1'b0;
    can_fd_tolerant.reg_addr_write = 'hx;
    can_fd_tolerant.reg_data_in = 'hx;
  end
endtask

// Description: On this task, wr on CAN FD Receiver is performed
task write_CAN_FD_Receiver_Register;
  input [31:0] reg_addr;
  input [31:0] reg_data;

  begin
    $display("----------------------------------------\n");
    $display("(%0t) Writing on CAN FD Receiver register [%0d] with 0x%0x", $time, reg_addr, reg_data);
    $display("----------------------------------------\n");
    @ (posedge clk);
    can_fd_receiver.reg_addr_write = reg_addr;
    can_fd_receiver.reg_data_in = reg_data;
    can_fd_receiver.reg_we = 1'b1;
    @ (posedge clk);
    @ (negedge clk);
    can_fd_receiver.reg_we = 1'b0;
    can_fd_receiver.reg_addr_write = 'hx;
    can_fd_receiver.reg_data_in = 'hx;
  end
endtask

// Description: On this task, Bus Timing Register are configured for CAN controllers
// obtaining the desired baud rate for CTU CAN FD
task bus_timing_register_configuration_CTU_CAN_FD; 
begin
  // clk -> 100MHz
  // Baud Rate -> 500Kbit/s
  // Baud Rate FD -> 2Mbit/s


  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + BTR_OFFSET, {
    ctu_can_fd_timing.sjw,
    ctu_can_fd_timing.baud_r_presc,
    ctu_can_fd_timing.phase_seg_2,
    ctu_can_fd_timing.phase_seg_1,
    ctu_can_fd_timing.prop_seg
  });
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + BTR_FD_OFFSET, {
    ctu_can_fd_timing.sjw_fd,
    ctu_can_fd_timing.baud_r_presc_fd,
    1'b0,
    ctu_can_fd_timing.phase_seg_2_fd,
    1'b0,
    ctu_can_fd_timing.phase_seg_1_fd,
    1'b0,
    ctu_can_fd_timing.prop_seg_fd
  });
end
endtask

// Description: On this task, Bus Timing Register are configured for CAN controllers
// obtaining the desired baud rate for SJA1000
task bus_timing_register_configuration_SJA1000; 
begin
  // clk -> 100MHz
  // Baud Rate -> 500Kbit/s
  // Baud Rate FD -> 2Mbit/s

  write_CAN_FD_Tolerant_Register(8'd6, {
    sja1000_can_fd_timing.triple_sampling,
    sja1000_can_fd_timing.sjw,
    sja1000_can_fd_timing.baud_r_presc,
    sja1000_can_fd_timing.phase_seg_2,
    sja1000_can_fd_timing.phase_seg_1,
    sja1000_can_fd_timing.prop_seg
  });
  write_CAN_FD_Tolerant_Register(8'd7, {
    sja1000_can_fd_timing.triple_sampling_fd,
    sja1000_can_fd_timing.sjw_fd,
    sja1000_can_fd_timing.baud_r_presc_fd,
    1'b0,
    sja1000_can_fd_timing.phase_seg_2_fd,
    1'b0,
    sja1000_can_fd_timing.phase_seg_1_fd,
    1'b0,
    sja1000_can_fd_timing.prop_seg_fd
  });

  write_CAN_FD_Receiver_Register(8'd6, {
    sja1000_can_fd_timing.triple_sampling,
    sja1000_can_fd_timing.sjw,
    sja1000_can_fd_timing.baud_r_presc,
    sja1000_can_fd_timing.phase_seg_2,
    sja1000_can_fd_timing.phase_seg_1,
    sja1000_can_fd_timing.prop_seg
  });
  write_CAN_FD_Receiver_Register(8'd7, {
    sja1000_can_fd_timing.triple_sampling_fd,
    sja1000_can_fd_timing.sjw_fd,
    sja1000_can_fd_timing.baud_r_presc_fd,
    1'b0,
    sja1000_can_fd_timing.phase_seg_2_fd,
    1'b0,
    sja1000_can_fd_timing.phase_seg_1_fd,
    1'b0,
    sja1000_can_fd_timing.prop_seg_fd
  });

end
endtask

// Description: On this task, a wait operation occurs. Useful after leaving configuration state
// and waiting for Bus Idle 
task wait_11_bits;
  input int bit_time_ns;
begin
  # (11*bit_time_ns);
end
endtask

// task send_bit;
//   input val;
//   begin
//     #1 rx=val;
//     repeat ((`CAN_TIMING1_TSEG1 + `CAN_TIMING1_TSEG2 + 3)*BRP) @ (posedge clk);
//   end
// endtask

// task send_fd_bit;
//   input val;
//   integer cnt;
//   begin
//     #1 rx=val;
//     repeat ((`CAN_TIMING1_TSEG1 + `CAN_TIMING1_TSEG2 + 3)*BRP/FDBRMUL) @ (posedge clk);
//   end
// endtask

// task send_bits;
//   input integer cnt;
//   input [1023:0] data;
//   integer c;
//   begin
//     for (c=cnt; c > 0; c=c-1)
//       send_bit(data[c-1]);
//   end
// endtask

// task send_fd_bits;
//   input integer cnt;
//   input [1023:0] data;
//   integer c;
//   begin
//     for (c=cnt; c > 0; c=c-1)
//       send_fd_bit(data[c-1]);
//   end
// endtask
endmodule