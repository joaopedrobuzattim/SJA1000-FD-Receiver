`include "timescale.sv"
`include "can_defines.sv"
`include "can_testbench_defines.sv"

module tb_top();

parameter Tp = 1;
parameter BRP = 2*(`CAN_TIMING0_BRP + 1);
parameter FDBRMUL = 2; // 4* faster that BRP

reg         clk;
reg         extended_mode;
reg        reg_rst;
logic      rx;

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
  logic [1:0] irqns;
  logic tx_we_i;
  logic [3:0] tx_addr_i;
  logic [7:0] tx_data_i;
} t_sja1000_fd_signals;

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
} t_ctu_can_fd_signals;

// ENDEREÇOS DOS REGISTRADORES CTU CAN FD
localparam logic [15:0] CTU_CAN_FD_BASE       = 16'h0000;
localparam logic [15:0] MODE_OFFSET           = 16'h0004;
localparam logic [15:0] SETTINGS_OFFSET       = 16'h0004;
localparam logic [15:0] BTR_OFFSET            = 16'h0024;
localparam logic [15:0] BTR_FD_OFFSET         = 16'h0028;
localparam logic [15:0] TX_STATUS_OFFSET      = 16'h0070;
localparam logic [15:0] TX_COMMAND_OFFSET     = 16'h0074;
localparam logic [15:0] TX_PRIORITY_OFFSET    = 16'h0078;

// ENDEREÇOS DO BUFFER DE TRANSMISSÃO CTU CAN FD
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


// Instantiate can_top module
can_top_raw i_can_top
( 
  .reg_we_i(t_sja1000_fd_signals.reg_we),
  .reg_re_i(t_sja1000_fd_signals.reg_re),
  .reg_data_in(t_sja1000_fd_signals.reg_data_in),
  .reg_data_out(t_sja1000_fd_signals.can_reg_data_out),
  .reg_addr_read_i(t_sja1000_fd_signals.reg_addr_read),
  .reg_addr_write_i(t_sja1000_fd_signals.reg_addr_write),
  .tx_we_i(t_sja1000_fd_signals.tx_we_i),
  .tx_addr_i(t_sja1000_fd_signals.tx_addr_i),
  .tx_data_i(t_sja1000_fd_signals.tx_data_i),
  .reg_rst_i(~reg_rst),
  .clk_i(clk),
  .rx_i(t_sja1000_fd_signals.tx_o & t_ctu_can_fd_signals.can_tx),
  .tx_o(t_sja1000_fd_signals.tx_o),
  .bus_off_on(t_sja1000_fd_signals.bus_off_on),
  .irq_on(t_sja1000_fd_signals.irqns[0])
);

// Instanciando CTU CAN FD
can_top_level ctu_can_fd 
(
  .clk_sys(clk),
  .res_n(reg_rst),
  .res_n_out(t_ctu_can_fd_signals.res_n_out),
  .scan_enable(t_ctu_can_fd_signals.scan_enable),
  .data_in(t_ctu_can_fd_signals.write_data),
  .data_out(t_ctu_can_fd_signals.read_data),
  .adress(t_ctu_can_fd_signals.address),
  .scs(t_ctu_can_fd_signals.scs),
  .srd(t_ctu_can_fd_signals.srd),
  .swr(t_ctu_can_fd_signals.swr),
  .sbe(t_ctu_can_fd_signals.sbe),
  .\int (t_ctu_can_fd_signals.inte),
  .can_tx(t_ctu_can_fd_signals.can_tx),
  .can_rx(t_sja1000_fd_signals.tx_o & t_ctu_can_fd_signals.can_tx),
  .test_probe(t_ctu_can_fd_signals.test_probe),
  .timestamp(t_ctu_can_fd_signals.timestamp)
);

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

  // Escrevendo em CTU CAN FD

  // BTR
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + BTR_OFFSET, 32'b00001000001000001000001010001010);

  // BTR FD
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + BTR_FD_OFFSET, 32'b00001000000100001000001010001010);

  // Mode Reg
  write_CTU_CAN_FD_register(4'b0011, CTU_CAN_FD_BASE + MODE_OFFSET, 32'b00000000000000000000000000010000);

  // Settings Reg
  write_CTU_CAN_FD_register(4'b1100, CTU_CAN_FD_BASE + MODE_OFFSET, 32'b00000000010000000000000000000000);

  #50000;

  // Escrevendo dados no buffer de transmissão
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_1_OFFSET, 32'b00000000000000000000001010001000);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_2_OFFSET, 32'b10101010101010101010101010101010);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_3_OFFSET, 32'b00000000000000000000000000000000);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_4_OFFSET, 32'b00000000000000000000000000000000);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_5_OFFSET, 32'b11111111111111111111111111111111);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_6_OFFSET, 32'b00000000000000000000000000000000);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_7_OFFSET, 32'b10101010101010101010101010101010);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_8_OFFSET, 32'b10101010101010101010101010101010);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_9_OFFSET, 32'b10101010101010101010101010101010);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_10_OFFSET, 32'b10101010101010101010101010101010);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_11_OFFSET, 32'b10101010101010101010101010101010);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_12_OFFSET, 32'b10101010101010101010101010101010);

  // Escrevendo em SJA1000 FD

  // Entrando em Reset Mode
  write_SJA1000_FD_register(8'd0, {7'h0, `CAN_MODE_RESET});
  repeat (50) @ (posedge clk);


  // Set Clock Divider register
  extended_mode = 1'b1;
  write_SJA1000_FD_register(8'd31, {extended_mode, 7'h0});    // Setting the extended mode

  // Set bus timing register 0
  write_SJA1000_FD_register(8'd6, {`CAN_TIMING0_SJW, `CAN_TIMING0_BRP});

  // Set bus timing register 0 FD
  write_SJA1000_FD_register(8'd25, {`CAN_TIMING0_SJW_FD, `CAN_TIMING0_BRP_FD});

  // Set bus timing register 1
  write_SJA1000_FD_register(8'd7, {`CAN_TIMING1_SAM, `CAN_TIMING1_TSEG2, `CAN_TIMING1_TSEG1});
  
  // Set bus timing register 1 FD
  write_SJA1000_FD_register(8'd26, {`CAN_TIMING1_SAM_FD, `CAN_TIMING1_TSEG2_FD, `CAN_TIMING1_TSEG1_FD});

  // Set Acceptance Code and Acceptance Mask registers (
  if (extended_mode)
    begin
      write_SJA1000_FD_register(8'd16, 8'ha6); // acceptance code 0
      write_SJA1000_FD_register(8'd17, 8'hb0); // acceptance code 1
      write_SJA1000_FD_register(8'd18, 8'h12); // acceptance code 2
      write_SJA1000_FD_register(8'd19, 8'h30); // acceptance code 3
      write_SJA1000_FD_register(8'd20, 8'hff); // acceptance mask 0
      write_SJA1000_FD_register(8'd21, 8'hff); // acceptance mask 1
      write_SJA1000_FD_register(8'd22, 8'hff); // acceptance mask 2
      write_SJA1000_FD_register(8'd23, 8'hff); // acceptance mask 3
    end
  else
    begin
      write_SJA1000_FD_register(8'd4, 8'he8); // acceptance code
      write_SJA1000_FD_register(8'd5, 8'hff); // acceptance mask
    end

  // Habilitando recepcao de frames FD ISO
  write_SJA1000_FD_register(8'd24, 8'h3);

  repeat (50) @ (posedge clk);

  write_SJA1000_FD_register(8'd0, {7'h0, ~(`CAN_MODE_RESET)});

  #50000;

  // Escrevendo no registrador de TX COMMAND de CTU CAN FD
  write_CTU_CAN_FD_register(4'b0011, CTU_CAN_FD_BASE + TX_COMMAND_OFFSET, 32'b00000000000000000000000100000010);

 #120000;

  write_CTU_CAN_FD_register(4'b1100, CTU_CAN_FD_BASE + MODE_OFFSET, 32'b00000000000000000000000000000000);

  // Sending non-ISO frame
   
  reg_rst = 1'b0;
  #1000;
  reg_rst = 1'b1;

  #1000;

  // Escrevendo em CTU CAN FD

  // BTR
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + BTR_OFFSET, 32'b00001000001000001000001010001010);

  // BTR FD
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + BTR_FD_OFFSET, 32'b00001000000100001000001010001010);

  // Mode Reg
  write_CTU_CAN_FD_register(4'b0011, CTU_CAN_FD_BASE + MODE_OFFSET, 32'b00000000000000000000000000010000);

  // Settings Reg
  write_CTU_CAN_FD_register(4'b1100, CTU_CAN_FD_BASE + MODE_OFFSET, 32'b00000000110000000000000000000000);

  #50000;

  // Escrevendo dados no buffer de transmissão
  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_1_OFFSET, 32'b00000000000000000000001010001000);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_2_OFFSET, 32'b10101010101010101010101010101010);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_3_OFFSET, 32'b00000000000000000000000000000000);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_4_OFFSET, 32'b00000000000000000000000000000000);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_5_OFFSET, 32'b11111111111111111111111111111111);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_6_OFFSET, 32'b00000000000000000000000000000000);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_7_OFFSET, 32'b10101010101010101010101010101010);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_8_OFFSET, 32'b10101010101010101010101010101010);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_9_OFFSET, 32'b10101010101010101010101010101010);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_10_OFFSET, 32'b10101010101010101010101010101010);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_11_OFFSET, 32'b10101010101010101010101010101010);

  write_CTU_CAN_FD_register(4'b1111, CTU_CAN_FD_BASE + TXTB1_DATA_12_OFFSET, 32'b10101010101010101010101010101010);

  // Escrevendo em SJA1000 FD

  // Entrando em Reset Mode
  write_SJA1000_FD_register(8'd0, {7'h0, `CAN_MODE_RESET});
  repeat (50) @ (posedge clk);


  // Set Clock Divider register
  extended_mode = 1'b1;
  write_SJA1000_FD_register(8'd31, {extended_mode, 7'h0});    // Setting the extended mode

  // Set bus timing register 0
  write_SJA1000_FD_register(8'd6, {`CAN_TIMING0_SJW, `CAN_TIMING0_BRP});

  // Set bus timing register 0 FD
  write_SJA1000_FD_register(8'd25, {`CAN_TIMING0_SJW_FD, `CAN_TIMING0_BRP_FD});

  // Set bus timing register 1
  write_SJA1000_FD_register(8'd7, {`CAN_TIMING1_SAM, `CAN_TIMING1_TSEG2, `CAN_TIMING1_TSEG1});
  
  // Set bus timing register 1 FD
  write_SJA1000_FD_register(8'd26, {`CAN_TIMING1_SAM_FD, `CAN_TIMING1_TSEG2_FD, `CAN_TIMING1_TSEG1_FD});
 
  // Set Acceptance Code and Acceptance Mask registers (
  if (extended_mode)
    begin
      write_SJA1000_FD_register(8'd16, 8'ha6); // acceptance code 0
      write_SJA1000_FD_register(8'd17, 8'hb0); // acceptance code 1
      write_SJA1000_FD_register(8'd18, 8'h12); // acceptance code 2
      write_SJA1000_FD_register(8'd19, 8'h30); // acceptance code 3
      write_SJA1000_FD_register(8'd20, 8'hff); // acceptance mask 0
      write_SJA1000_FD_register(8'd21, 8'hff); // acceptance mask 1
      write_SJA1000_FD_register(8'd22, 8'hff); // acceptance mask 2
      write_SJA1000_FD_register(8'd23, 8'hff); // acceptance mask 3
    end
  else
    begin
      write_SJA1000_FD_register(8'd4, 8'he8); // acceptance code
      write_SJA1000_FD_register(8'd5, 8'hff); // acceptance mask
    end

  // Habilitando recepcao de frames FD ISO
  write_SJA1000_FD_register(8'd24, 8'h1);

  repeat (50) @ (posedge clk);

  write_SJA1000_FD_register(8'd0, {7'h0, ~(`CAN_MODE_RESET)});

  #50000;

  // Escrevendo no registrador de TX COMMAND de CTU CAN FD
  write_CTU_CAN_FD_register(4'b0011, CTU_CAN_FD_BASE + TX_COMMAND_OFFSET, 32'b00000000000000000000000100000010);
#120000;

  // Escrevendo no Buffer de transmissão do SJA1000
  write_SJA1000_FD_tx_buffer(4'h00, 8'h88);
  write_SJA1000_FD_tx_buffer(4'h01, 8'hA6);
  write_SJA1000_FD_tx_buffer(4'h02, 8'h00);
  write_SJA1000_FD_tx_buffer(4'h03, 8'h5A);
  write_SJA1000_FD_tx_buffer(4'h04, 8'hA8);
  write_SJA1000_FD_tx_buffer(4'h05, 8'hFF);
  write_SJA1000_FD_tx_buffer(4'h06, 8'hFF);
  write_SJA1000_FD_tx_buffer(4'h07, 8'hBC);
  write_SJA1000_FD_tx_buffer(4'h08, 8'hDE);
  write_SJA1000_FD_tx_buffer(4'h09, 8'hF0);
  write_SJA1000_FD_tx_buffer(4'h0A, 8'h0F);
  write_SJA1000_FD_tx_buffer(4'h0B, 8'hED);
  write_SJA1000_FD_tx_buffer(4'h0C, 8'hCB); 
  
  // SJA1000 Transmitindo
  write_SJA1000_FD_register(8'h01, 8'h01);

  #120000;
  $stop;

end

// Tasks

task write_CTU_CAN_FD_register;
  input [3:0] sbe_in;
  input [15:0] addr_in;
  input [31:0] data_in;

  begin
    $display("(%0t) Writing CTU CAN FD register [%0d] (sbe: %0d) with 0x%0x", $time, addr_in, sbe_in, data_in);
    @ (posedge clk);
    t_ctu_can_fd_signals.scs = 1'b1;
    t_ctu_can_fd_signals.swr = 1'b1;
    t_ctu_can_fd_signals.address = addr_in;
    t_ctu_can_fd_signals.write_data = data_in;
    t_ctu_can_fd_signals.sbe = sbe_in;
    @ (posedge clk);
    @ (negedge clk);
    t_ctu_can_fd_signals.scs = 1'b0;
    t_ctu_can_fd_signals.swr = 1'b0;
    t_ctu_can_fd_signals.sbe = 4'b0000;
  end
endtask

task write_SJA1000_FD_register;
  input [7:0] reg_addr;
  input [7:0] reg_data;

  begin
    $display("(%0t) Writing SJA1000 Modified register [%0d] with 0x%0x", $time, reg_addr, reg_data);
    @ (posedge clk);
    t_sja1000_fd_signals.reg_addr_write = reg_addr;
    t_sja1000_fd_signals.reg_data_in = reg_data;
    t_sja1000_fd_signals.reg_we = 1'b1;
    @ (posedge clk);
    @ (negedge clk);
    t_sja1000_fd_signals.reg_we = 1'b0;
    t_sja1000_fd_signals.reg_addr_write = 'hx;
    t_sja1000_fd_signals.reg_data_in = 'hx;
  end
endtask

task write_SJA1000_FD_tx_buffer;
  input [3:0] tx_addr;
  input [7:0] tx_data;

  begin
    $display("(%0t) Writing SJA1000 Modified Tx Buffer [%0d] with 0x%0x", $time, tx_addr, tx_data);
    @ (posedge clk);
    t_sja1000_fd_signals.tx_we_i = 1'b1;
    t_sja1000_fd_signals.tx_addr_i = tx_addr;
    t_sja1000_fd_signals.tx_data_i = tx_data;
    @ (posedge clk);
    @ (negedge clk);
    t_sja1000_fd_signals.tx_we_i = 1'b0;
    t_sja1000_fd_signals.tx_addr_i = 'hx;
    t_sja1000_fd_signals.tx_data_i = 'hx;
  end
endtask

task send_bit;
  input val;
  begin
    #1 rx=val;
    repeat ((`CAN_TIMING1_TSEG1 + `CAN_TIMING1_TSEG2 + 3)*BRP) @ (posedge clk);
  end
endtask

task send_fd_bit;
  input val;
  integer cnt;
  begin
    #1 rx=val;
    repeat ((`CAN_TIMING1_TSEG1 + `CAN_TIMING1_TSEG2 + 3)*BRP/FDBRMUL) @ (posedge clk);
  end
endtask

task send_bits;
  input integer cnt;
  input [1023:0] data;
  integer c;
  begin
    for (c=cnt; c > 0; c=c-1)
      send_bit(data[c-1]);
  end
endtask

task send_fd_bits;
  input integer cnt;
  input [1023:0] data;
  integer c;
  begin
    for (c=cnt; c > 0; c=c-1)
      send_fd_bit(data[c-1]);
  end
endtask

always @ (posedge clk)
begin
  if (tb_top.i_can_top.i_can_bsp.go_rx_idle)
    $display("*I (%0t) INFO: go_rx_idle", $time);
  if (tb_top.i_can_top.i_can_bsp.go_rx_id1)
    $display("*I (%0t) INFO: go_rx_id1", $time);
  if (tb_top.i_can_top.i_can_bsp.go_rx_rtr1)
    $display("*I (%0t) INFO: go_rx_rtr1", $time);
  if (tb_top.i_can_top.i_can_bsp.go_rx_ide)
    $display("*I (%0t) INFO: go_rx_ide", $time);
  if (tb_top.i_can_top.i_can_bsp.go_rx_id2)
    $display("*I (%0t) INFO: go_rx_id2", $time);
  if (tb_top.i_can_top.i_can_bsp.go_rx_rtr2)
    $display("*I (%0t) INFO: go_rx_rtr2", $time);
  if (tb_top.i_can_top.i_can_bsp.go_rx_r1)
    $display("*I (%0t) INFO: go_rx_r1", $time);
  if (tb_top.i_can_top.i_can_bsp.go_rx_r0)
    $display("*I (%0t) INFO: go_rx_r0", $time);
  if (tb_top.i_can_top.i_can_bsp.go_rx_dlc)
    $display("*I (%0t) INFO: go_rx_dlc", $time);
  if (tb_top.i_can_top.i_can_bsp.go_rx_data)
    $display("*I (%0t) INFO: go_rx_data", $time);
  if (tb_top.i_can_top.i_can_bsp.go_rx_crc)
    $display("*I (%0t) INFO: go_rx_crc", $time);
  if (tb_top.i_can_top.i_can_bsp.go_rx_crc_lim)
    $display("*I (%0t) INFO: go_rx_crc_lim", $time);
  if (tb_top.i_can_top.i_can_bsp.go_rx_ack)
    $display("*I (%0t) INFO: go_rx_ack", $time);
  if (tb_top.i_can_top.i_can_bsp.go_rx_ack_lim)
    $display("*I (%0t) INFO: go_rx_ack_lim", $time);
  if (tb_top.i_can_top.i_can_bsp.go_rx_eof)
    $display("*I (%0t) INFO: go_rx_eof", $time);
  if (tb_top.i_can_top.i_can_bsp.go_rx_inter)
    $display("*I (%0t) INFO: go_rx_inter", $time);
  if (tb_top.i_can_top.i_can_bsp.go_overload_frame)
    $display("*I (%0t) INFO: go_overload_frame", $time);
  if (tb_top.i_can_top.i_can_bsp.go_error_frame)
    $display("*I (%0t) INFO: go_error_frame", $time);
  if (tb_top.i_can_top.i_can_bsp.go_tx)
    $display("*I (%0t) INFO: go_tx", $time);
  if (tb_top.i_can_top.i_can_bsp.error_frame_ended)
    $display("*I (%0t) INFO: error_frame_ended", $time);
end

endmodule