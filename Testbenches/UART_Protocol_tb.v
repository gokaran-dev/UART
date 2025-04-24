`timescale 1ns / 1ps

module uart_tb;

    parameter DBIT = 8;
    parameter SB_TICK = 16;
    parameter FINAL_VALUE = 650;

    reg clk = 0;
    reg reset_n = 0;
    reg tx_start = 0;
    reg [DBIT-1:0] tx_din = 8'hA5;  // example data to send
    wire tx, rx;
    wire rx_done_tick;
    wire [DBIT-1:0] rx_dout;
    wire tx_done_tick;

    // Generate clock
    always #5 clk = ~clk; // 100 MHz

    // Instantiate UART top
    uart #(.DBIT(DBIT), .SB_TICK(SB_TICK), .FINAL_VALUE(FINAL_VALUE)) dut (
        .clk(clk),
        .reset_n(reset_n),
        .rx(rx),
        .tx_start(tx_start),
        .tx_din(tx_din),
        .tx(tx),
        .rx_done_tick(rx_done_tick),
        .rx_dout(rx_dout),
        .tx_done_tick(tx_done_tick)
    );

    // Loop TX back to RX
    assign rx = tx;

    initial begin
        reset_n = 0;
        #100;
        reset_n = 1;

        // Wait a bit before starting transmission
        #1000;
        tx_start = 1;
        #10;
        tx_start = 0;

        // Wait long enough for transmission and reception
        #200000;
    end

endmodule
