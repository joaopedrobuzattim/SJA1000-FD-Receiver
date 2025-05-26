//////////////////////////////////////////////////////////////////////
////                                                              ////
////  can_operation_control_fsm.sv                                ////
////                                                              ////
////  Description: Combinational next-state logic for handling    ////
////  CAN controller operation states                             ////
////                                                              ////
////  Author(s):                                                  ////
////       João Pedro Buzatti                                     ////
////                                                              ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

module can_operation_control_fsm (

    input           clk_i,
    input           rst_i,

    // Data Path Flags
    input           go_oc_integrating_i,
    input           go_oc_transmitting_i,
    input           go_oc_receiving_i,
    input           go_oc_idle_i,
    input           reset_mode_i,
    input           bus_free_i,

    // Current State
    output          is_transmitting_o
);


// ########################################################
// # Enum State Definition
// ########################################################  
typedef enum { 
            S_OC_IDLE,
            S_OC_TRANSMITTING,
            S_OC_INTEGRATING,
            S_OC_RECEIVING,
            S_OC_OFF
        } CAN_op_states;


CAN_op_states next_state, current_state;


// ########################################################
// # State Memory
// ########################################################
always_ff @(posedge clk_i, posedge rst_i, posedge reset_mode_i) begin
    if (rst_i)
        current_state <= S_OC_OFF;
    else if (reset_mode_i)
        current_state <= S_OC_OFF;
    else
        current_state <= next_state;
end

// ########################################################
// # Next State Logic
// ########################################################
always_comb begin
    next_state = current_state;

    case (current_state)
        S_OC_OFF: begin
            if (go_oc_integrating_i) begin
                next_state = S_OC_INTEGRATING;
            end
        end
        S_OC_INTEGRATING: begin
            if(bus_free_i) begin
                next_state = S_OC_IDLE;
            end
        end
        S_OC_IDLE: begin
            if(go_oc_transmitting_i) begin
                next_state = S_OC_TRANSMITTING;
            end
            else if(go_oc_receiving_i) begin
                next_state = S_OC_RECEIVING;
            end else if(go_oc_idle_i) begin
                next_state = S_OC_IDLE;
            end
        end
        S_OC_TRANSMITTING: begin
            if(go_oc_receiving_i) begin
                next_state = S_OC_RECEIVING;
            end else if(go_oc_idle_i) begin
                next_state = S_OC_IDLE;
            end 
        end
        S_OC_RECEIVING: begin
            if(go_oc_transmitting_i) begin
                next_state = S_OC_TRANSMITTING;
            end else if(go_oc_idle_i) begin
                next_state = S_OC_IDLE;
            end 
        end
        endcase
    end

// ########################################################
// # Current State Logic
// ########################################################
assign is_transmitting_o = (current_state == S_OC_TRANSMITTING);

endmodule