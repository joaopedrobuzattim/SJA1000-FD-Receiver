// Modulo criado para exibir os estados da FSM de rx em um enum, para facilitar a visualizacao



module can_bsp_fsm (clk, data, enable, initialize, crc);


parameter Tp = 1;

//Criando registrador de currentState para facilitar visualizacao do Frame
typedef enum {BUS_IDLE, ID_1,RTR_1 ,IDE,ID_2 , RTR_2 , R1 , R0 , R0_FD , BRS, ESI, DLC, DATA, CRC, CRC_LIM, ACK, ACK_LIM, EOF, INTER} RxStates;

RxStates currentState_rx;



endmodule