`timescale 1ns / 1ps

module uart_rx_board
    #(parameter DBIT=8,   
                SB_TICK=16, 
                FINAL_VALUE=650) 
    (
        input clk, reset_n,
        input rx,
        output rx_done_tick,
        output [DBIT-1:0] rx_dout
    );

   
    wire s_tick;
    wire baud_done;

    timer_input #(.BITS(11)) baud_gen(
        .clk(clk),
        .reset_n(reset_n),
        .enable(1'b1),
        .FINAL_VALUE(FINAL_VALUE),
        .Q_reg(),
        .done(baud_done)
    );

    assign s_tick=baud_done; 

 
    uart_rx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) rx_inst(
        .clk(clk),
        .reset_n(reset_n),
        .rx(rx),
        .s_tick(s_tick),
        .rx_done_tick(rx_done_tick),
        .rx_dout(rx_dout)
    );


endmodule
