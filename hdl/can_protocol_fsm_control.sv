//////////////////////////////////////////////////////////////////////
////                                                              ////
////  can_protocol_fsm_control.v                                  ////
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

module can_protocol_fsm_control 
(   
    input           clk_i,
    input           rst_i,

    input           sample_point_i,
    input           sampled_bit_i,
    input           bit_de_stuff_i,
    input           fd_tolerant_i,
    input           ide_i,
    input           fdf_skip_finished_i,
    input           remote_rq_i,
    input           en_FD_iso_i,
    input           edl_i,
    input           node_bus_off_i,
    input           transmitter_i,
    input           error_frame_ended_i,
    input           overload_frame_ended_i,
    input           err_condition_i,
    input           overload_condition_i,
    input           overload_request_i,
    input           reset_mode_i,
    input           reset_mode_q_i,
    input           bus_free_i,
    input     [2:0] eof_cnt_i,
    input     [8:0] bit_cnt_i,
    input     [6:0] data_len_i
);
    typedef enum { 
                PC_BUS_IDLE,
                PC_ID_1,
                PC_RTR_1,
                PC_IDE,
                PC_ID_2,
                PC_RTR_2,
                PC_R1,
                PC_R0,
                PC_R0_FD,
                PC_SKIP_FDF,
                PC_BRS,
                PC_ESI,
                PC_DLC,
                PC_DATA,
                PC_STUFF_COUNT,
                PC_CRC,
                PC_CRC_LIM,
                PC_ACK,
                PC_ACK_FD_1,
                PC_ACK_FD_2,
                PC_ACK_LIM,
                PC_EOF,
                PC_INTER,
                PC_ERROR,
                PC_OVERLOAD,
                PC_TRANSMITING_ERROR,
                PC_OFF,
                PC_INTEGRATING
            } CAN_controller_states;

CAN_controller_states current_state, next_state;

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
        current_state <= PC_OFF;
    else
        current_state <= next_state;
end

    always_comb begin
        next_state = current_state;

        case (current_state)
            PC_OFF: begin
                if ((~reset_mode_i) & reset_mode_q_i) begin
                    next_state = PC_INTEGRATING;
                end
            end
            PC_INTEGRATING: begin
                if(bus_free_i) begin
                    next_state = PC_BUS_IDLE;
                end
            end
            PC_ERROR: begin
                if (error_frame_ended_i & (~overload_request_i)) begin
                    next_state = PC_INTER;
                end else if (overload_condition_i) begin
                    next_state = PC_OVERLOAD;
                end
            end
            PC_OVERLOAD:begin
                if (overload_frame_ended_i & (~overload_request_i)) begin
                    next_state = PC_INTER;
                end
            end
            PC_BUS_IDLE: begin
                if (sample_point_i & (~sampled_bit_i)) begin
                    next_state = PC_ID_1;
                end else if (err_condition_i) begin
                    next_state = PC_ERROR;
                end
            end
            PC_ID_1: begin
                if (sample_point_i & (~bit_de_stuff_i) & bit_cnt_i[3:0] == 4'd10) begin
                    next_state = PC_RTR_1;
                end else if (err_condition_i) begin
                    next_state = PC_ERROR;
                end
            end
            PC_RTR_1: begin
                if (sample_point_i & (~bit_de_stuff_i)) begin
                    next_state = PC_IDE;
                end else if (err_condition_i) begin
                    next_state = PC_ERROR;
                end
            end
            PC_IDE: begin
                if (sample_point_i & (~bit_de_stuff_i) & sampled_bit_i) begin
                    next_state = PC_ID_2;
                end else if (sample_point_i & (~bit_de_stuff_i) & (~sampled_bit_i)) begin
                    next_state = PC_R0;
                end else if (err_condition_i) begin
                    next_state = PC_ERROR;
                end
            end
            PC_ID_2: begin
                if (sample_point_i & (~bit_de_stuff_i) & bit_cnt_i[4:0] == 5'd17) begin
                    next_state = PC_RTR_2;
                end else if (err_condition_i) begin
                    next_state = PC_ERROR;
                end
            end
            PC_RTR_2: begin
                if((~bit_de_stuff_i) & sample_point_i) begin
                    next_state = PC_R1;
                end else if (err_condition_i) begin
                    next_state = PC_ERROR;
                end
            end
            PC_R1:begin
                if((~bit_de_stuff_i) & sample_point_i & (~sampled_bit_i)) begin
                    next_state = PC_R0;
                end else if ( ~(fd_tolerant_i) & (~bit_de_stuff_i) & sample_point_i & sampled_bit_i & ide_i) begin
                    next_state = PC_R0_FD;
                end else if ( fd_tolerant_i & sample_point_i & (~bit_de_stuff_i) & sampled_bit_i & ide_i ) begin
                    next_state = PC_SKIP_FDF;
                end else if (err_condition_i) begin
                    next_state = PC_ERROR;
                end
            end
            PC_R0: begin
                if (sample_point_i & (~bit_de_stuff_i) & (~sampled_bit_i)) begin
                    next_state = PC_DLC;
                end else if ( ~(fd_tolerant_i) & sample_point_i & (~bit_de_stuff_i) & sampled_bit_i & (~ide_i)) begin 
                    next_state = PC_R0_FD;
                end else if( fd_tolerant_i & sample_point_i & (~bit_de_stuff_i) & sampled_bit_i & (~ide_i)) begin
                    next_state = PC_SKIP_FDF;
                end else if (err_condition_i) begin
                    next_state = PC_ERROR;
                end
            end
            PC_SKIP_FDF: begin
                if(fdf_skip_finished_i & (~overload_request_i)) begin
                    next_state = PC_INTER;
                end else if (err_condition_i) begin
                    next_state = PC_ERROR;
                end
            end
            PC_DLC: begin
                if( (~bit_de_stuff_i) & sample_point_i & (bit_cnt_i[1:0] == 2'd3) & (~remote_rq_i)) begin
                    next_state = PC_DATA;
                end else if ( (~bit_de_stuff_i) & sample_point_i & edl_i & en_FD_iso_i & (~sampled_bit_i) & bit_cnt_i[1:0] == 2'd3 & (~(|data_len_i[2:0])) ) begin
                    next_state = PC_STUFF_COUNT;
                end else if ( (~bit_de_stuff_i) & sample_point_i & (~en_FD_iso_i |  ~edl_i) & bit_cnt_i[1:0] == 2'd3 & ( (~sampled_bit_i) & (~(|data_len_i[2:0])) | remote_rq_i ) ) begin
                    next_state = PC_CRC;
                end else if (err_condition_i) begin
                    next_state = PC_ERROR;
                end
            end
            PC_R0_FD: begin
                if (sample_point_i & (~bit_de_stuff_i)) begin
                    next_state = PC_BRS;
                end else if (err_condition_i) begin
                    next_state = PC_ERROR;
                end
            end
            PC_BRS: begin
                if (sample_point_i & (~bit_de_stuff_i)) begin
                    next_state = PC_ESI;
                end else if (err_condition_i) begin
                    next_state = PC_ERROR;
                end
            end
            PC_ESI: begin
                if (sample_point_i & (~bit_de_stuff_i)) begin
                    next_state = PC_DLC;
                end else if (err_condition_i) begin
                    next_state = PC_ERROR;
                end
            end
            PC_DATA: begin
                if((~bit_de_stuff_i) & sample_point_i & edl_i & en_FD_iso_i & (bit_cnt_i[8:0] == ((data_len_i<<3) - 1'b1))) begin
                    next_state = PC_STUFF_COUNT;
                end else if ((~bit_de_stuff_i) & sample_point_i & (~en_FD_iso_i |  ~edl_i) & (bit_cnt_i[8:0] == ((data_len_i<<3) - 1'b1)) ) begin
                    next_state = PC_CRC;
                end else if (err_condition_i) begin
                    next_state = PC_ERROR;
                end
            end
            PC_STUFF_COUNT: begin
                if ((~bit_de_stuff_i) & sample_point_i & bit_cnt_i[1:0] == 2'd3) begin
                    next_state = PC_CRC;
                end else if (err_condition_i) begin
                    next_state = PC_ERROR;
                end
            end
            PC_CRC: begin
                if( (~bit_de_stuff_i) & sample_point_i & ( ( ~edl_i & (bit_cnt_i[3:0] == 4'd14) ) | (  edl_i & data_len_i <= 7'd16 & (bit_cnt_i[4:0] == 5'd21) ) | (  edl_i & data_len_i  > 7'd16 & (bit_cnt_i[4:0] == 5'd26) ) ) ) begin
                    next_state = PC_CRC_LIM;
                end else if (err_condition_i) begin
                    next_state = PC_ERROR;
                end 
            end
            PC_CRC_LIM: begin
                if (err_condition_i) begin
                    next_state = PC_ERROR;
                end
                else if ((~bit_de_stuff_i) & sample_point_i & (~edl_i)) begin
                    next_state = PC_ACK;
                end 
                else if ((~bit_de_stuff_i) & sample_point_i & (edl_i)) begin
                    next_state = PC_ACK_FD_1;
                end
            end
            PC_ACK: begin
                if (err_condition_i) begin
                    next_state = PC_ERROR;
                end else if (sample_point_i) begin
                    next_state = PC_ACK_LIM;
                end
            end
            PC_ACK_FD_1: begin
                if (err_condition_i) begin
                    next_state = PC_ERROR;
                end else if (sample_point_i) begin
                    next_state = PC_ACK_FD_2;
                end
            end
            PC_ACK_FD_2: begin
                if (err_condition_i) begin
                    next_state = PC_ERROR;
                end else if (sample_point_i) begin
                    next_state = PC_ACK_LIM;
                end
            end
            PC_ACK_LIM: begin
                if(err_condition_i) begin 
                    next_state = PC_ERROR;
                end else if (sample_point_i) begin
                    next_state = PC_EOF;
                end 
            end
            PC_EOF: begin
                if( (sample_point_i &  (eof_cnt_i == 3'd6)) & (~overload_request_i) ) begin
                    next_state = PC_INTER;
                end else if ( err_condition_i ) begin
                    next_state = PC_ERROR;
                end else if (overload_condition_i) begin
                    next_state = PC_OVERLOAD;
                end
            end
            PC_INTER: begin
                if(sample_point_i & sampled_bit_i & bit_cnt_i[1:0] == 2'd2 & (~node_bus_off_i))begin
                    next_state = PC_BUS_IDLE;
                end else if ( sample_point_i & (~sampled_bit_i) & bit_cnt_i[1:0] == 2'd2 ) begin
                    next_state = PC_ID_1;
                end else if ( err_condition_i ) begin
                    next_state = PC_ERROR;
                end
            end
        endcase
    end
    
endmodule



