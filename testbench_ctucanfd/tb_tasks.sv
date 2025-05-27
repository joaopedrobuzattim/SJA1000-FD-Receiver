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


can_fd_tolerant.reg_re = 1'b1;
can_fd_tolerant.reg_addr_read = 8'd3;
while (1) begin
  
//$display("(%0t) Writing on CAN FD Receiver TX Buffer [%0x]\n",$time ,can_fd_tolerant.can_reg_data_out);
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

wait(can_fd_receiver.irqn == 1'b0);

can_fd_receiver.reg_re = 1'b1;
can_fd_receiver.reg_addr_read = 8'd3;
wait(can_fd_receiver.can_reg_data_out[0] == 1'b1);
can_fd_receiver.reg_re = 1'b0;
end
end
endtask