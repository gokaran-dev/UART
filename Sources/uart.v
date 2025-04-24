`timescale 1ns / 1ps

module uart
    #(parameter DBIT=8,   
                SB_TICK=16, 
                FINAL_VALUE=650) 
    (
        input clk, reset_n,
        input rx, tx_start,
        input [DBIT-1:0] tx_din,
        output tx, rx_done_tick,
        output [DBIT-1:0] rx_dout,
        output tx_done_tick
    );

   
    wire s_tick;
    wire baud_done;

    timer_input #(.BITS(11)) baud_gen (
        .clk(clk),
        .reset_n(reset_n),
        .enable(1'b1),
        .FINAL_VALUE(FINAL_VALUE),
        .Q_reg(), // We don't need to store the counter value
        .done(baud_done)
    );

    assign s_tick = baud_done; 

 
    uart_rx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) rx_inst (
        .clk(clk),
        .reset_n(reset_n),
        .rx(rx),
        .s_tick(s_tick),
        .rx_done_tick(rx_done_tick),
        .rx_dout(rx_dout)
    );

  
    uart_tx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) tx_inst (
        .clk(clk),
        .reset_n(reset_n),
        .tx_start(tx_start),
        .s_tick(s_tick),
        .tx_din(tx_din),
        .tx_done_tick(tx_done_tick),
        .tx_reg(), 
        .tx(tx),
        .state_out() 
    );

endmodule
