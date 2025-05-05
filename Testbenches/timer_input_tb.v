`timescale 1ns / 1ps

module timer_input_tb;

    parameter BITS=11;
    parameter FINAL_VALUE=650;

    reg clk=0;
    reg reset_n=0;
    reg enable=0;
    wire done;
    wire [BITS-1:0] Q;


    timer_input #(.BITS(BITS)) uut(
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .FINAL_VALUE(FINAL_VALUE),
        .Q_reg(Q),
        .done(done)
    );


    always #5 clk=~clk;

    initial begin
        // Assert reset
        #10 reset_n=1;
        #10 enable=1;

       
        #300;

        $finish;
    end

endmodule
