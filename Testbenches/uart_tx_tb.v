`timescale 1ns / 1ps

module uart_tx_tb;

    // Parameters
    parameter DBIT = 8;
    parameter SB_TICK = 16;
    parameter FINAL_VALUE = 650;  // For 9600 baud rate with 16x oversampling (650 counts)

    // Testbench signals
    reg clk, reset_n;
    reg tx_start;
    reg [DBIT-1:0] tx_din;
    wire tx_done_tick;
    wire [DBIT-1:0] b_next;
    wire [3:0] s;
    wire tx_reg;
    wire tx;
    wire [1:0] state_out;
    
    // Instantiate the timer_input (Baud rate generator)
    wire s_tick;  // Baud rate done signal to use as s_tick
    timer_input #(.BITS(11)) baud_rate_gen (
        .clk(clk),
        .reset_n(reset_n),
        .enable(1'b1),  // Enable the counter
        .FINAL_VALUE(FINAL_VALUE),  // Value to count to (650 for 9600 baud rate)
        .Q_reg(),   // We don't need to use Q_reg in this case
        .done(s_tick)  // This will be our s_tick for uart_tx
    );

    // Instantiate uart_tx
    uart_tx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uut (
        .clk(clk),
        .reset_n(reset_n),
        .tx_start(tx_start),
        .s_tick(s_tick),
        .tx_din(tx_din),
        .s_reg(s),
        .b_next(b_next),
        .tx_reg(tx_reg),
        .tx_done_tick(tx_done_tick),
        .tx(tx),
        .state_out(state_out)
    );

    // Clock generation (100MHz)
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        // Initialize
        clk = 0;
        reset_n = 0;
        tx_start = 0;
        tx_din = 8'b10101010;

        // Reset pulse
        #20 reset_n = 1;

        // Wait and start transmission
        #100;
        tx_start = 1;   // Start the transmission
        #10;
        tx_start = 0;   // De-assert to simulate button press

        // Wait for transmission to complete
        wait(tx_done_tick);
        #100;

        // End simulation
        $finish;
    end

endmodule
