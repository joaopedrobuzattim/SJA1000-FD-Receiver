`include "timescale.sv"
`include "can_defines.sv"
`include "can_testbench_defines.sv"

module tb_top();

logic      clk;
logic      extended_mode;
logic      reg_rst;
logic      rx;
logic      can_bus_short_rx;

`include "tb_tasks.sv"

struct { 
  logic reg_we;
  logic reg_re;
  logic [7:0] reg_data_in;
  logic [7:0] can_reg_data_out;
  logic [7:0] reg_addr_read;
  logic [7:0] reg_addr_write;
  logic rx_i;
  logic tx_o;
  logic bus_off_on;
  logic irqn;
  logic tx_we_i;
  logic [3:0] tx_addr_i;
  logic [7:0] tx_data_i;
} t_can_fd_tolerant;

struct { 
  logic reg_we;
  logic reg_re;
  logic [7:0] reg_data_in;
  logic [7:0] can_reg_data_out;
  logic [7:0] reg_addr_read;
  logic [7:0] reg_addr_write;
  logic rx_i;
  logic tx_o;
  logic bus_off_on;
  logic irqn;
  logic tx_we_i;
  logic [3:0] tx_addr_i;
  logic [7:0] tx_data_i;
} t_can_fd_receiver;

// Sinais para conectar as portas de CTU CAN FD

typedef struct {
    logic rx_trigger_nbs;    // std_logic -> logic
    logic rx_trigger_wbs;    // std_logic -> logic
    logic tx_trigger;        // std_logic -> logic
} t_ctu_can_fd_test_probe;


struct { 
  logic res_n_out;
  logic scan_enable;             // std_logic -> logic
  logic [31:0] write_data;          // std_logic_vector(31 downto 0) -> logic [31:0]
  logic [31:0] read_data;         // std_logic_vector(31 downto 0) -> logic [31:0]
  logic [15:0] address;          // std_logic_vector(15 downto 0) -> logic [15:0]
  logic scs;                     // std_logic -> logic
  logic srd;                     // std_logic -> logic
  logic swr;                     // std_logic -> logic
  logic [3:0] sbe;               // std_logic_vector(3 downto 0) -> logic [3:0]
  logic inte;                    // std_logic -> logic
  logic can_tx;                  // std_logic -> logic
  logic can_rx;                  // std_logic -> logic
  t_ctu_can_fd_test_probe test_probe;  // Assume t_ctu_can_fd_test_probe is a struct or user-defined type in SystemVerilog
  logic [63:0] timestamp;        // std_logic_vector(63 downto 0) -> logic [63:0]
} t_ctu_can_fd;


// CAN FD Tolerant
can_top_raw i_can_top_1
( 
  .reg_we_i(t_can_fd_tolerant.reg_we),
  .reg_re_i(t_can_fd_tolerant.reg_re),
  .reg_data_in(t_can_fd_tolerant.reg_data_in),
  .reg_data_out(t_can_fd_tolerant.can_reg_data_out),
  .reg_addr_read_i(t_can_fd_tolerant.reg_addr_read),
  .reg_addr_write_i(t_can_fd_tolerant.reg_addr_write),
  .tx_we_i(t_can_fd_tolerant.tx_we_i),
  .tx_addr_i(t_can_fd_tolerant.tx_addr_i),
  .tx_data_i(t_can_fd_tolerant.tx_data_i),
  .reg_rst_i(~reg_rst),
  .clk_i(clk),
  .rx_i(can_bus_short_rx),
  .tx_o(t_can_fd_tolerant.tx_o),
  .bus_off_on(t_can_fd_tolerant.bus_off_on),
  .irq_on(t_can_fd_tolerant.irqn)
);

// CAN FD Receiver
can_top_raw i_can_top_2
( 
  .reg_we_i(t_can_fd_receiver.reg_we),
  .reg_re_i(t_can_fd_receiver.reg_re),
  .reg_data_in(t_can_fd_receiver.reg_data_in),
  .reg_data_out(t_can_fd_receiver.can_reg_data_out),
  .reg_addr_read_i(t_can_fd_receiver.reg_addr_read),
  .reg_addr_write_i(t_can_fd_receiver.reg_addr_write),
  .tx_we_i(t_can_fd_receiver.tx_we_i),
  .tx_addr_i(t_can_fd_receiver.tx_addr_i),
  .tx_data_i(t_can_fd_receiver.tx_data_i),
  .reg_rst_i(~reg_rst),
  .clk_i(clk),
  .rx_i(can_bus_short_rx),
  .tx_o(t_can_fd_receiver.tx_o),
  .bus_off_on(t_can_fd_receiver.bus_off_on),
  .irq_on(t_can_fd_receiver.irqn)
);

// Instanciando CTU CAN FD
can_top_level ctu_can_fd 
(
  .clk_sys(clk),
  .res_n(reg_rst),
  .res_n_out(t_ctu_can_fd.res_n_out),
  .scan_enable(t_ctu_can_fd.scan_enable),
  .data_in(t_ctu_can_fd.write_data),
  .data_out(t_ctu_can_fd.read_data),
  .adress(t_ctu_can_fd.address),
  .scs(t_ctu_can_fd.scs),
  .srd(t_ctu_can_fd.srd),
  .swr(t_ctu_can_fd.swr),
  .sbe(t_ctu_can_fd.sbe),
  .\int (t_ctu_can_fd.inte),
  .can_tx(t_ctu_can_fd.can_tx),
  .can_rx(can_bus_short_rx),
  .test_probe(t_ctu_can_fd.test_probe),
  .timestamp(t_ctu_can_fd.timestamp)
);

// Shorting RX Chanel
assign can_bus_short_rx = t_can_fd_tolerant.tx_o & t_ctu_can_fd.can_tx & t_can_fd_receiver.tx_o;


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
  //fd_frame_NON_ISO_on_bus();
  //error_caused_by_receiving_ISO_FD_Frame();
  // SJA1000_send_extended_frame();
  //loop_sending_extended_frame();

  #12000;
  $stop;

end

// ############################################################
// #                                                          #
// #                  ------> TASKS <------                   #
// #                                                          #
// ############################################################

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
    t_ctu_can_fd.scs = 1'b1;
    t_ctu_can_fd.swr = 1'b1;
    t_ctu_can_fd.address = addr_in;
    t_ctu_can_fd.write_data = data_in;
    t_ctu_can_fd.sbe = sbe_in;
    @ (posedge clk);
    @ (negedge clk);
    t_ctu_can_fd.scs = 1'b0;
    t_ctu_can_fd.swr = 1'b0;
    t_ctu_can_fd.sbe = 4'b0000;
  end
endtask

// Description: On this task, wr on CAN FD Tolerant is performed
task write_CAN_FD_Tolerant_Register;
  input [7:0] reg_addr;
  input [7:0] reg_data;

  begin
    $display("----------------------------------------\n");
    $display("(%0t) Writing on CAN FD Tolerant register [%0d] with 0x%0x", $time, reg_addr, reg_data);
    $display("----------------------------------------\n");
    @ (posedge clk);
    t_can_fd_tolerant.reg_addr_write = reg_addr;
    t_can_fd_tolerant.reg_data_in = reg_data;
    t_can_fd_tolerant.reg_we = 1'b1;
    @ (posedge clk);
    @ (negedge clk);
    t_can_fd_tolerant.reg_we = 1'b0;
    t_can_fd_tolerant.reg_addr_write = 'hx;
    t_can_fd_tolerant.reg_data_in = 'hx;
  end
endtask

// Description: On this task, wr on CAN FD Receiver is performed
task write_CAN_FD_Receiver_Register;
  input [7:0] reg_addr;
  input [7:0] reg_data;

  begin
    $display("----------------------------------------\n");
    $display("(%0t) Writing on CAN FD Receiver register [%0d] with 0x%0x", $time, reg_addr, reg_data);
    $display("----------------------------------------\n");
    @ (posedge clk);
    t_can_fd_receiver.reg_addr_write = reg_addr;
    t_can_fd_receiver.reg_data_in = reg_data;
    t_can_fd_receiver.reg_we = 1'b1;
    @ (posedge clk);
    @ (negedge clk);
    t_can_fd_receiver.reg_we = 1'b0;
    t_can_fd_receiver.reg_addr_write = 'hx;
    t_can_fd_receiver.reg_data_in = 'hx;
  end
endtask

// Description: On this task, wr on TX Buffer of CAN FD Tolerant is performed
task write_CAN_FD_Tolerant_TX_Buffer;
  input [3:0] tx_addr;
  input [7:0] tx_data;

  begin
    $display("----------------------------------------\n");
    $display("(%0t) Writing on CAN FD Tolerant TX Buffer [%0d] with 0x%0x", $time, tx_addr, tx_data);
    $display("----------------------------------------\n");
    @ (posedge clk);
    t_can_fd_tolerant.tx_we_i = 1'b1;
    t_can_fd_tolerant.tx_addr_i = tx_addr;
    t_can_fd_tolerant.tx_data_i = tx_data;
    @ (posedge clk);
    @ (negedge clk);
    t_can_fd_tolerant.tx_we_i = 1'b0;
    t_can_fd_tolerant.tx_addr_i = 'hx;
    t_can_fd_tolerant.tx_data_i = 'hx;
  end
endtask

// Description: On this task, wr on TX Buffer of CAN FD Receiver is performed
task write_CAN_FD_Receiver_TX_Buffer;
  input [3:0] tx_addr;
  input [7:0] tx_data;

  begin
    $display("----------------------------------------\n");
    $display("(%0t) Writing on CAN FD Receiver TX Buffer [%0d] with 0x%0x", $time, tx_addr, tx_data);
    $display("----------------------------------------\n");
    @ (posedge clk);
    t_can_fd_receiver.tx_we_i = 1'b1;
    t_can_fd_receiver.tx_addr_i = tx_addr;
    t_can_fd_receiver.tx_data_i = tx_data;
    @ (posedge clk);
    @ (negedge clk);
    t_can_fd_receiver.tx_we_i = 1'b0;
    t_can_fd_receiver.tx_addr_i = 'hx;
    t_can_fd_receiver.tx_data_i = 'hx;
  end
endtask

// Description: On this task, Bus Timing Register are configured for CAN controllers
// obtaining the desired baud rate for CTU CAN FD
task bus_timing_register_configuration_CTU_CAN_FD; 
begin
  // clk -> 100MHz
  // Baud Rate -> 500Kbit/s
  // Baud Rate FD -> 2Mbit/s


  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + BTR_OFFSET, 32'b00011000001000010100010100011101);
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + BTR_FD_OFFSET, 32'b00011000000010010100010100011101);
end
endtask

// Description: On this task, Bus Timing Register are configured for CAN controllers
// obtaining the desired baud rate for SJA1000
task bus_timing_register_configuration_SJA1000; 
begin
  // clk -> 100MHz
  // Baud Rate -> 500Kbit/s
  // Baud Rate FD -> 2Mbit/s

  write_CAN_FD_Tolerant_Register(8'd6, 8'hC4);
  write_CAN_FD_Tolerant_Register(8'd25, 8'hC4);
  write_CAN_FD_Tolerant_Register(8'd7, 8'h3e);
  write_CAN_FD_Tolerant_Register(8'd26, 8'h02);

  write_CAN_FD_Receiver_Register(8'd6, 8'hC4);
  write_CAN_FD_Receiver_Register(8'd25, 8'hC4);
  write_CAN_FD_Receiver_Register(8'd7, 8'h3e);
  write_CAN_FD_Receiver_Register(8'd26, 8'h02);

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

//Description: Decode Error Capture Code
task automatic can_bus_error_decoder_SJA1000(input logic [7:0] ecc_value);
  logic [4:0] ecc_bits;
  ecc_bits = ecc_value[4:0];

  case (ecc_bits)
    5'b00011: $display("Start of Frame\n");
    5'b00010: $display("ID.28 to ID.21\n");
    5'b00110: $display("ID.20 to ID.18\n");
    5'b00100: $display("Bit SRTR\n");
    5'b00101: $display("Bit IDE\n");
    5'b00111: $display("ID.17 to ID.13\n");
    5'b01111: $display("ID.12 to ID.5\n");
    5'b01110: $display("ID.4 to ID.0\n");
    5'b01100: $display("Bit RTR\n");
    5'b01101: $display("Reserved Bit 1\n");
    5'b01001: $display("Reserved Bit 0\n");
    5'b01011: $display("Data Length Code\n");
    5'b01010: $display("Data Field\n");
    5'b01000: $display("CRC Sequence\n");
    5'b11000: $display("CRC Delimiter\n");
    5'b11001: $display("Acknowledge Slot\n");
    5'b11011: $display("Acknowledge Delimiter\n");
    5'b11010: $display("End of Frame\n");
    5'b10010: $display("Intermission\n");
    5'b10001: $display("Active Error Flag\n");
    5'b10110: $display("Passive Error Flag\n");
    5'b10011: $display("Tolerate Dominant Bits\n");
    5'b10111: $display("Error Delimiter\n");
    5'b11100: $display("Overload Flag\n");
    default:  $display("Unknown Field\n");
  endcase
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