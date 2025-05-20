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
  logic rtr;
  logic ide;
  logic [10:0] id_base;
  logic [17:0] id_ext;
  logic [7:0] data [0:7];
} t_can_classic_frame;

typedef struct {
  logic [3:0] dlc;
  logic brs;
  logic ide;
  logic [10:0] id_base;
  logic [17:0] id_ext;
  logic [7:0] data [0:63];
} t_can_fd_frame;


