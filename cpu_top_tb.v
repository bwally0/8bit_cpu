`timescale 1ns / 1ps

module cpu_top_tb;

    reg CLK100MHZ;
    reg [15:0] SW;
    wire [15:0] LED;
    wire [6:0] C;
    wire [7:0] AN;
    wire DP;

    cpu_top #(
        .CLOCK_DIV(10)
    ) uut (
        .CLK100MHZ(CLK100MHZ),
        .SW(SW),
        .LED(LED),
        .C(C),
        .AN(AN),
        .DP(DP)
    );

    initial begin
        CLK100MHZ = 0;
        forever #5 CLK100MHZ = ~CLK100MHZ;
    end

    // Stimulus
    initial begin
        SW = 16'b0;       // all off
        SW[1] = 1'b1;     // assert reset
        #50;
        SW[1] = 1'b0;     // release reset
        SW[0] = 1'b1;     // enable start clock
        SW[2] = 1'b0;     // hlt off

        #5000;
    end

endmodule
