/*
 * Copyright (c) 2024 Christopher Pacejo
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module psu_sequencer #(parameter integer steps = 8) (
  input wire clk, input wire rst_n,
  output wire [steps:0] ctl0, output wire [steps:0] ctl1,
  output wire r0_w2_en, output wire r1_w3_en,
  output wire r2_w0_en, output wire r3_w1_en
);
  reg [3:0] phase;
  reg [steps-1:0] step;

  always @(posedge clk or negedge rst_n)
    if (!rst_n) begin
      phase <= 4'b1000;
      step <= 1 << (steps-1);
    end else begin
      step <= {step[steps-2:0], step[steps-1]};
      phase <= step[steps-1] ? {phase[2:0], phase[3]} : phase;
    end

  assign ctl0[0] = (phase[2] & step[steps-1]) | phase[3];
  assign ctl1[0] = (phase[3] & step[steps-1]) | phase[0];

  generate
    genvar i;
    for (i = 1; i < steps; i = i + 1) begin
      assign ctl0[i] = (phase[0] & step[i-1]) | (phase[2] & step[steps-i-1]);
      assign ctl1[i] = (phase[1] & step[i-1]) | (phase[3] & step[steps-i-1]);
    end
  endgenerate

  assign ctl0[steps] = (phase[0] & step[steps-1]) | phase[1];
  assign ctl1[steps] = (phase[1] & step[steps-1]) | phase[2];

  assign r0_w2_en = phase[1] & step[steps-1];
  assign r1_w3_en = phase[2] & step[steps-1];
  assign r2_w0_en = phase[3] & step[steps-1];
  assign r3_w1_en = phase[0] & step[steps-1];

endmodule
