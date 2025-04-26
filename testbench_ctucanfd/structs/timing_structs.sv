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
