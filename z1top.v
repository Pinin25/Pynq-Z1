`timescale 1ns/1ns

module z1top (
    input CLK_125MHZ_FPGA,
    input [3:0] BUTTONS,
    input [1:0] SWITCHES,
    output [5:0] LEDS,
    output aud_pwm,
    output aud_sd
);

    assign aud_sd = 1;
    assign LEDS[3:0] = BUTTONS[3:0];
    
    tone_generator audio_controller(
        .clk(CLK_125MHZ_FPGA),
        .output_enable(SWITCHES[0]),
        .freq({13'd0, BUTTONS[3:0]} << 7),
        .volume(SWITCHES[1]),
        .square_wave_out(aud_pwm)
    );
    
endmodule
