`timescale 1ns/1ns
`define CLK_FRQ 125000000 //125MHz clock from Ethernet PHY IC1

module tone_generator (
    input clk,
    input output_enable,
    input [23:0] freq,
    input volume,
    output square_wave_out
);

    reg [23:0] clk_counter;
    reg square_wave;
    reg [23:0] tone_switch_period;
    wire duty_cycle;
    
    always @(*) begin
        if (freq == 0) tone_switch_period = 0;
        else tone_switch_period = `CLK_FRQ/freq >> 1;
    end
    
    always @(posedge clk) begin
        if (tone_switch_period == 0) begin
            clk_counter <= 0;
            square_wave <= 0;
        end else if (clk_counter == tone_switch_period) begin
            clk_counter <= 0;
            square_wave <= ~square_wave;
        end else
            clk_counter <= clk_counter + 1;
    end
        
    //volume = 0, duty_cycle = 25%
    //volume = 1, duty_cycle = 50%
    assign duty_cycle = (volume == 0)? (clk_counter[0] & clk_counter[1]) : (clk_counter[0]);
    
    assign square_wave_out = (output_enable == 0)? 1'b0: (square_wave & duty_cycle);
endmodule
