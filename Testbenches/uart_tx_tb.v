`timescale 1ns / 1ps

module uart_tx_tb;

    // Parameters
    parameter DBIT=8;
    parameter SB_TICK=16;
    parameter FINAL_VALUE=650; 


    reg clk, reset_n;
    reg tx_start;
    reg [DBIT-1:0] tx_din;
    wire tx_done_tick;
    wire [DBIT-1:0] b_next;
    wire [3:0] s;
    wire tx_reg;
    wire tx;
    wire [1:0] state_out;
    

    wire s_tick; 
    timer_input #(.BITS(11)) baud_rate_gen (
        .clk(clk),
        .reset_n(reset_n),
        .enable(1'b1),  
        .FINAL_VALUE(FINAL_VALUE),  
        .Q_reg(),   
        .done(s_tick)
    );

    uart_tx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uut(
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


    always #5 clk = ~clk;


    initial begin
 
        clk = 0;
        reset_n = 0;
        tx_start = 0;
        tx_din = 8'b10101010;

        // Reset pulse
        #20 reset_n = 1;

     
        #100;
        tx_start = 1;  
        #10;
        tx_start = 0; 

       
        wait(tx_done_tick);
        #1000;

        $finish;
    end

endmodule
