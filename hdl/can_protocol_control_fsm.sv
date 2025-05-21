//////////////////////////////////////////////////////////////////////
////                                                              ////
////  can_protocol_control_fsm.sv                                 ////
////                                                              ////
////  Description: Combinational next-state logic for handling    ////
////  CAN protocol states                                         ////
////                                                              ////
////  Author(s):                                                  ////
////       João Pedro Buzatti                                     ////
////                                                              ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
module can_protocol_control_fsm 
(   
    input           clk_i,
    input           rst_i,

    // Data Path Flags
    input           reset_mode_i,
    input           reset_mode_q_i,
    input           bus_free_i,
    input           go_rx_inter_i,
    input           go_rx_idle_i,
    input           go_overload_frame_i,
    input           go_error_frame_i,
    input           overload_frame_ended_i,
    input           go_rx_skip_fdf_i,
    input           go_rx_id1_i,
    input           go_rx_rtr1_i,
    input           go_rx_rtr2_i,
    input           go_rx_ide_i,
    input           go_rx_id2_i,
    input           go_rx_r0_i,
    input           go_rx_r1_i,
    input           go_rx_r0_fd_i,
    input           go_rx_dlc_i,
    input           go_rx_crc_i,
    input           go_rx_crc_lim_i,
    input           go_rx_ack_i,
    input           go_rx_ack_lim_i,
    input           go_rx_data_i,
    input           go_rx_stuff_count_i,
    input           go_rx_esi_i,
    input           go_rx_brs_i,
    input           go_rx_ack_fd_1_i,
    input           go_rx_ack_fd_2_i,
    input           go_rx_eof_i,

    // Current State
    output          is_inter_o,
    output          is_idle_o,
    output          is_overload_frame_o,
    output          is_error_frame_o,
    output          is_skip_fdf_o,
    output          is_id1_o,
    output          is_rtr1_o,
    output          is_rtr2_o,
    output          is_ide_o,
    output          is_id2_o,
    output          is_r0_o,
    output          is_r1_o,
    output          is_r0_fd_o,
    output          is_dlc_o,
    output          is_crc_o,
    output          is_crc_lim_o,
    output          is_ack_o,
    output          is_ack_lim_o,
    output          is_data_o,
    output          is_stuff_count_o,
    output          is_esi_o,
    output          is_brs_o,
    output          is_ack_fd_1_o,
    output          is_ack_fd_2_o,
    output          is_eof_o
);

// ########################################################
// # Enum State Definition
// ########################################################  
typedef enum { 
            S_BUS_IDLE,
            S_ID_1,
            S_RTR_1,
            S_IDE,
            S_ID_2,
            S_RTR_2,
            S_R1,
            S_R0,
            S_R0_FD,
            S_SKIP_FDF,
            S_BRS,
            S_ESI,
            S_DLC,
            S_DATA,
            S_STUFF_COUNT,
            S_CRC,
            S_CRC_LIM,
            S_ACK,
            S_ACK_FD_1,
            S_ACK_FD_2,
            S_ACK_LIM,
            S_EOF,
            S_INTER,
            S_ERROR,
            S_OVERLOAD,
            S_TRANSMITING_ERROR,
            S_OFF,
            S_INTEGRATING
        } CAN_controller_states;


CAN_controller_states next_state, current_state;

// ########################################################
// # State Memory
// ########################################################
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
        current_state <= S_OFF;
    else
        current_state <= next_state;
end

// ########################################################
// # Next State Logic
// ########################################################
always_comb begin
    next_state = current_state;

    case (current_state)
        S_OFF: begin
            if ((~reset_mode_i) & reset_mode_q_i) begin
                next_state = S_INTEGRATING;
            end
        end
        S_INTEGRATING: begin
            if(bus_free_i) begin
                next_state = S_BUS_IDLE;
            end
        end
        S_ERROR: begin
            if (go_rx_inter_i) begin
                next_state = S_INTER;
            end else if (go_overload_frame_i) begin
                next_state = S_OVERLOAD;
            end
        end
        S_OVERLOAD:begin
            if (go_rx_inter_i) begin
                next_state = S_INTER;
            end else if (go_error_frame_i) begin
                next_state = S_ERROR;
            end
        end
        S_BUS_IDLE: begin
            if (go_rx_id1_i) begin
                next_state = S_ID_1;
            end else if (go_error_frame_i) begin
                next_state = S_ERROR;
            end
        end
        S_ID_1: begin
            if (go_rx_rtr1_i) begin
                next_state = S_RTR_1;
            end else if (go_error_frame_i) begin
                next_state = S_ERROR;
            end
        end
        S_RTR_1: begin
            if (go_rx_ide_i) begin
                next_state = S_IDE;
            end else if (go_error_frame_i) begin
                next_state = S_ERROR;
            end
        end
        S_IDE: begin
            if (go_rx_id2_i) begin
                next_state = S_ID_2;
            end else if (go_rx_r0_i) begin
                next_state = S_R0;
            end else if (go_error_frame_i) begin
                next_state = S_ERROR;
            end
        end
        S_ID_2: begin
            if (go_rx_rtr2_i) begin
                next_state = S_RTR_2;
            end else if (go_error_frame_i) begin
                next_state = S_ERROR;
            end
        end
        S_RTR_2: begin
            if(go_rx_r1_i) begin
                next_state = S_R1;
            end else if (go_error_frame_i) begin
                next_state = S_ERROR;
            end
        end
        S_R1: begin
            if(go_rx_r0_i) begin
                next_state = S_R0;
            end else if (go_rx_skip_fdf_i) begin
                next_state = S_SKIP_FDF;
            end else if (go_rx_r0_fd_i) begin
                next_state = S_R0_FD;
            end else if (go_error_frame_i) begin
                next_state = S_ERROR;
            end
        end
        S_R0: begin
            if (go_rx_dlc_i) begin
                next_state = S_DLC;
            end else if (go_rx_r0_fd_i) begin 
                next_state = S_R0_FD;
            end else if(go_rx_skip_fdf_i) begin
                next_state = S_SKIP_FDF;
            end else if (go_error_frame_i) begin
                next_state = S_ERROR;
            end
        end
        S_SKIP_FDF: begin
            if(go_rx_inter_i) begin
                next_state = S_INTER;
            end else if (go_error_frame_i) begin
                next_state = S_ERROR;
            end
        end
        S_DLC: begin
            if(go_rx_data_i) begin
                next_state = S_DATA;
            end else if (go_rx_stuff_count_i) begin
                next_state = S_STUFF_COUNT;
            end else if (go_rx_crc_i) begin
                next_state = S_CRC;
            end else if (go_error_frame_i) begin
                next_state = S_ERROR;
            end
        end
        S_R0_FD: begin
            if (go_rx_brs_i) begin
                next_state = S_BRS;
            end else if (go_error_frame_i) begin
                next_state = S_ERROR;
            end
        end
        S_BRS: begin
            if (go_rx_esi_i) begin
                next_state = S_ESI;
            end else if (go_error_frame_i) begin
                next_state = S_ERROR;
            end
        end
        S_ESI: begin
            if (go_rx_dlc_i) begin
                next_state = S_DLC;
            end else if (go_error_frame_i) begin
                next_state = S_ERROR;
            end
        end
        S_DATA: begin
            if(go_rx_stuff_count_i) begin
                next_state = S_STUFF_COUNT;
            end else if (go_rx_crc_i) begin
                next_state = S_CRC;
            end else if (go_error_frame_i) begin
                next_state = S_ERROR;
            end
        end
        S_STUFF_COUNT: begin
            if (go_rx_crc_i) begin
                next_state = S_CRC;
            end else if (go_error_frame_i) begin
                next_state = S_ERROR;
            end
        end
        S_CRC: begin
            if(go_rx_crc_lim_i) begin
                next_state = S_CRC_LIM;
            end else if (go_error_frame_i) begin
                next_state = S_ERROR;
            end 
        end
        S_CRC_LIM: begin
            if (go_error_frame_i) begin
                next_state = S_ERROR;
            end
            else if (go_rx_ack_i) begin
                next_state = S_ACK;
            end 
            else if (go_rx_ack_fd_1_i) begin
                next_state = S_ACK_FD_1;
            end
        end
        S_ACK: begin
            if (go_error_frame_i) begin
                next_state = S_ERROR;
            end else if (go_rx_ack_lim_i) begin
                next_state = S_ACK_LIM;
            end
        end
        S_ACK_FD_1: begin
            if (go_error_frame_i) begin
                next_state = S_ERROR;
            end else if (go_rx_ack_fd_2_i) begin
                next_state = S_ACK_FD_2;
            end
        end
        S_ACK_FD_2: begin
            if (go_error_frame_i) begin
                next_state = S_ERROR;
            end else if (go_rx_ack_lim_i) begin
                next_state = S_ACK_LIM;
            end
        end
        S_ACK_LIM: begin
            if(go_error_frame_i) begin 
                next_state = S_ERROR;
            end else if (go_rx_eof_i) begin
                next_state = S_EOF;
            end 
        end
        S_EOF: begin
            if( go_rx_inter_i ) begin
                next_state = S_INTER;
            end else if ( go_error_frame_i ) begin
                next_state = S_ERROR;
            end else if ( go_overload_frame_i ) begin
                next_state = S_OVERLOAD;
            end
        end
        S_INTER: begin
            if(go_rx_idle_i)begin
                next_state = S_BUS_IDLE;
            end else if ( go_rx_id1_i ) begin
                next_state = S_ID_1;
            end else if ( go_error_frame_i ) begin
                next_state = S_ERROR;
            end else if ( go_overload_frame_i ) begin
                next_state = S_OVERLOAD;
            end
        end
    endcase
end

// ########################################################
// # Current State Logic
// ########################################################

assign is_inter_o = (current_state == S_INTER);
assign is_idle_o =  (current_state == S_BUS_IDLE);
assign is_overload_frame_o = (current_state == S_OVERLOAD);
assign is_error_frame_o = (current_state == S_ERROR);
assign is_skip_fdf_o = (current_state == S_SKIP_FDF);
assign is_id1_o = (current_state == S_ID_1);
assign is_rtr1_o = (current_state == S_RTR_1);
assign is_rtr2_o = (current_state == S_RTR_2);
assign is_ide_o = (current_state == S_IDE);
assign is_id2_o = (current_state == S_ID_2);
assign is_r0_o = (current_state == S_R0);
assign is_r1_o = (current_state == S_R1);
assign is_r0_fd_o = (current_state == S_R0_FD);
assign is_dlc_o = (current_state == S_DLC);
assign is_crc_o = (current_state == S_CRC);
assign is_crc_lim_o = (current_state == S_CRC_LIM);
assign is_ack_o = (current_state == S_ACK);
assign is_ack_lim_o = (current_state == S_ACK_LIM);
assign is_data_o = (current_state == S_DATA);
assign is_stuff_count_o = (current_state == S_STUFF_COUNT);
assign is_esi_o = (current_state == S_ESI);
assign is_brs_o = (current_state == S_BRS);
assign is_ack_fd_1_o = (current_state == S_ACK_FD_1);
assign is_ack_fd_2_o = (current_state == S_ACK_FD_2);
assign is_eof_o = (current_state == S_EOF);


endmodule