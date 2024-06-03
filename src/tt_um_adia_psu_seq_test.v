/*
 * Copyright (c) 2024 Applied Invention, LLC
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_adia_psu_seq_test (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  wire [8:0] ctl0;
  wire [8:0] ctl1;
  wire r0_w2_en, r1_w3_en, r2_w0_en, r3_w1_en;

  psu_sequencer #(8) seq (clk, rst_n, ctl0, ctl1, r0_w2_en, r1_w3_en, r2_w0_en, r3_w1_en);

  assign uo_out[0] = ui_in[0];
  assign uo_out[7:1] = ui_in[0] ? ctl1[7:1] : ctl0[7:1];
  assign uio_out[0] = ctl0[0];
  assign uio_out[1] = ctl0[8];
  assign uio_out[2] = ctl1[0];
  assign uio_out[3] = ctl1[8];
  assign uio_out[4] = r0_w2_en;
  assign uio_out[5] = r1_w3_en;
  assign uio_out[6] = r2_w0_en;
  assign uio_out[7] = r3_w1_en;

  assign uio_oe = 'hff;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, 1'b0};

endmodule
