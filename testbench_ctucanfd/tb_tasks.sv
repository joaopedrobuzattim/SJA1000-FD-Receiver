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
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_21_OFFSET, 32'b10101010101010101010101010101010);

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

  #1000000;

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
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_1_OFFSET,  32'b00000000000000000000001010001000);
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

  #500000;

end
endtask

// Description: On this task, CTU CAN FD transmists a FD ISO message along the bus 
// and the controller should throw and error frame 
task error_caused_by_receiving_ISO_FD_Frame; 
begin
  bus_timing_register_configuration_CTU_CAN_FD();

  // Mode Reg - CTU CAN FD
  write_CTU_CAN_FD_register(4'b0011, CTU_CAN_FD_BASE + MODE_OFFSET, 32'b00000000000000000000000000010000);

  // Settings Reg - CTU CAN FD
  write_CTU_CAN_FD_register(4'b1100, CTU_CAN_FD_BASE + MODE_OFFSET, 32'b00000000010000000000000000000000);

  wait_11_bits(2000);

 // TX Buffer - CTU CAN FD
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_1_OFFSET,  32'b00000000000000000000001010001000);
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

 // Wait for SJA1000 interrupt 
 wait(t_can_fd_receiver.irqn == 1'b0);

 // Reading Bus Error Interrupt - SJA1000
t_can_fd_receiver.reg_re = 1'b1;
t_can_fd_receiver.reg_addr_read = 8'd3;
wait (t_can_fd_receiver.can_reg_data_out == 8'b10000000);
@ (posedge clk);
@ (negedge clk);

// Decoding Error Capture Code - SJA1000
t_can_fd_receiver.reg_re = 1'b1;
t_can_fd_receiver.reg_addr_read = REG_ECC;
wait (t_can_fd_receiver.can_reg_data_out != 8'b00000000);
can_bus_error_decoder_SJA1000(t_can_fd_receiver.can_reg_data_out);
@ (posedge clk);
@ (negedge clk);

// Reading Error Passive Interrupt - SJA1000
t_can_fd_receiver.reg_re = 1'b1;
t_can_fd_receiver.reg_addr_read = 8'd3;
wait (t_can_fd_receiver.can_reg_data_out == 8'b00100000);

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

wait(t_can_fd_receiver.irqn == 1'b0 && t_can_fd_tolerant.irqn == 1'b0);

// Reading Transmit Interrupt on FD Receiver 
t_can_fd_receiver.reg_re = 1'b1;
t_can_fd_receiver.reg_addr_read = 8'd3;
wait (t_can_fd_receiver.can_reg_data_out == 8'b00000010);
@ (posedge clk);
@ (negedge clk);
t_can_fd_receiver.reg_re = 1'b0;
t_can_fd_receiver.reg_addr_read = 8'hx;

// Reading Receive Interrupt on FD Tolerant - SJA1000
t_can_fd_tolerant.reg_re = 1'b1;
t_can_fd_tolerant.reg_addr_read = 8'd3;
wait (t_can_fd_tolerant.can_reg_data_out == 8'b00000001);
@ (posedge clk);
@ (negedge clk);
t_can_fd_tolerant.reg_re = 1'b0;
t_can_fd_tolerant.reg_addr_read = 8'hx;

// FD Tolerant TX Command - SJA1000
write_CAN_FD_Tolerant_Register(REG_CMR, 8'h01);

wait(t_can_fd_receiver.irqn == 1'b0 && t_can_fd_tolerant.irqn == 1'b0);

// Reading Transmit Interrupt on FD Tolerant 
t_can_fd_tolerant.reg_re = 1'b1;
t_can_fd_tolerant.reg_addr_read = 8'd3;
wait (t_can_fd_tolerant.can_reg_data_out == 8'b00000011);
@ (posedge clk);
@ (negedge clk);
t_can_fd_tolerant.reg_re = 1'b0;

// Reading Receive Interrupt on FD Receiver - SJA1000
t_can_fd_receiver.reg_re = 1'b1;
t_can_fd_receiver.reg_addr_read = 8'd3;
wait (t_can_fd_receiver.can_reg_data_out == 8'b00000001);
@ (posedge clk);
@ (negedge clk);
t_can_fd_receiver.reg_re = 1'b0;

end
endtask

// Description: On this task, extended classical CAN frame is sended in loop mode
task loop_sending_extended_frame;
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


t_can_fd_tolerant.reg_re = 1'b1;
t_can_fd_tolerant.reg_addr_read = 8'd3;
while (1) begin
  
//$display("(%0t) Writing on CAN FD Receiver TX Buffer [%0x]\n",$time ,t_can_fd_tolerant.can_reg_data_out);
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

write_CAN_FD_Tolerant_Register(REG_CMR, 8'h01);

wait(t_can_fd_receiver.irqn == 1'b0);

t_can_fd_receiver.reg_re = 1'b1;
t_can_fd_receiver.reg_addr_read = 8'd3;
wait(t_can_fd_receiver.can_reg_data_out[0] == 1'b1);
t_can_fd_receiver.reg_re = 1'b0;
end
end
endtask