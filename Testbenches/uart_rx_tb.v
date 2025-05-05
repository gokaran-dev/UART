`timescale 1ns / 1ps

module uart_rx_tb;

    parameter DBIT=8;
    parameter SB_TICK=16;
    parameter FINAL_VALUE=650; 

    reg clk=0;
    reg reset_n=0;
    reg rx=1;
    wire s_tick;
    wire rx_done_tick;
    wire [DBIT-1:0] rx_dout;


    timer_input #(.BITS(11)) baud_gen(
        .clk(clk),
        .reset_n(reset_n),
        .enable(1'b1),
        .FINAL_VALUE(FINAL_VALUE),
        .Q_reg(),     
        .done(s_tick)
    );


    uart_rx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) dut(
        .clk(clk),
        .reset_n(reset_n),
        .rx(rx),
        .s_tick(s_tick),
        .rx_done_tick(rx_done_tick),
        .rx_dout(rx_dout)
    );

    
    always #5 clk=~clk;

    //sending 1 UART frame
    task send_uart_byte(input [7:0]data);
        integer i, count;
        begin
            //Start bit
            rx=0;
            count=0;
            while(count<16) 
	    begin
                @(posedge s_tick);
                count=count+1;
            end

            // Data bits (LSB first)
            for(i=0;i<8;i=i+1) 
	    begin
                rx=data[i];
                count=0;
                while(count<16) 
		begin
                    @(posedge s_tick);
                    count = count+1;
                end
            end

            // Stop bit
            rx=1;
            count=0;
            while(count<16) 
		begin
                @(posedge s_tick);
                count=count+1;
            	end
        end
    endtask

    initial begin
        reset_n=0;
        #20;
        reset_n=1;
	//wait for sometime before sending
        #100;

        send_uart_byte(8'hA5);

        #1000;
    end

endmodule
