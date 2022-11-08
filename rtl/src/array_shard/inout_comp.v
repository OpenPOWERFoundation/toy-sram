// © IBM Corp. 2022
// Licensed under the Apache License, Version 2.0 (the "License"), as modified by the terms below; you may not use the files in this
// repository except in compliance with the License as modified.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Modified Terms:
//
//   1)	For the purpose of the patent license granted to you in Section 3 of the License, the "Work" hereby includes implementations of
//   the work of authorship in physical form.
//
// Unless required by applicable law or agreed to in writing, the reference design distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language
// governing permissions & limitations under the License.
//
// Brief explanation of modifications:
//
// Modification 1: This modification extends the patent license to an implementation of the Work in physical form – i.e.,
// it unambiguously permits a user to make & use the physical chip.

`timescale 1 ps / 1 ps

// I/O pins/logic
// put address here for now so wires route through it

module inout_comp (

    input         rd0_c_na0,
    input         rd0_c_a0,
    input         rd0_na1_na2,
    input         rd0_na1_a2,
    input         rd0_a1_na2,
    input         rd0_a1_a2,
    input         rd0_na3,
    input         rd0_a3,
    input         rd0_na4_na5,
    input         rd0_na4_a5,
    input         rd0_a4_na5,
    input         rd0_a4_a5,

    input         rd1_c_na0,
    input         rd1_c_a0,
    input         rd1_na1_na2,
    input         rd1_na1_a2,
    input         rd1_a1_na2,
    input         rd1_a1_a2,
    input         rd1_na3,
    input         rd1_a3,
    input         rd1_na4_na5,
    input         rd1_na4_a5,
    input         rd1_a4_na5,
    input         rd1_a4_a5,

    input         wr0_c_na0,
    input         wr0_c_a0,
    input         wr0_na1_na2,
    input         wr0_na1_a2,
    input         wr0_a1_na2,
    input         wr0_a1_a2,
    input         wr0_na3,
    input         wr0_a3,
    input         wr0_na4_na5,
    input         wr0_na4_a5,
    input         wr0_a4_na5,
    input         wr0_a4_a5,

    output        rd0_c_na0_i,
    output        rd0_c_a0_i,
    output        rd0_na1_na2_i,
    output        rd0_na1_a2_i,
    output        rd0_a1_na2_i,
    output        rd0_a1_a2_i,
    output        rd0_na3_i,
    output        rd0_a3_i,
    output        rd0_na4_na5_i,
    output        rd0_na4_a5_i,
    output        rd0_a4_na5_i,
    output        rd0_a4_a5_i,

    output        rd1_c_na0_i,
    output        rd1_c_a0_i,
    output        rd1_na1_na2_i,
    output        rd1_na1_a2_i,
    output        rd1_a1_na2_i,
    output        rd1_a1_a2_i,
    output        rd1_na3_i,
    output        rd1_a3_i,
    output        rd1_na4_na5_i,
    output        rd1_na4_a5_i,
    output        rd1_a4_na5_i,
    output        rd1_a4_a5_i,

    output        wr0_c_na0_i,
    output        wr0_c_a0_i,
    output        wr0_na1_na2_i,
    output        wr0_na1_a2_i,
    output        wr0_a1_na2_i,
    output        wr0_a1_a2_i,
    output        wr0_na3_i,
    output        wr0_a3_i,
    output        wr0_na4_na5_i,
    output        wr0_na4_a5_i,
    output        wr0_a4_na5_i,
    output        wr0_a4_a5_i,

    input  [0:11] rd0_dat_0x0,
    input  [0:11] rd0_dat_0x1,
    input  [0:11] rd0_dat_1x0,
    input  [0:11] rd0_dat_1x1,
    output [0:23] rd0_dat,

    input  [0:11] rd1_dat_0x0,
    input  [0:11] rd1_dat_0x1,
    input  [0:11] rd1_dat_1x0,
    input  [0:11] rd1_dat_1x1,
    output [0:23] rd1_dat,

    input  [0:23] wr0_dat,
    output [0:11] wr0_dat_0x0,
    output [0:11] wr0_dat_b_0x0,
    output [0:11] wr0_dat_0x1,
    output [0:11] wr0_dat_b_0x1,
    output [0:11] wr0_dat_1x0,
    output [0:11] wr0_dat_b_1x0,
    output [0:11] wr0_dat_1x1,
    output [0:11] wr0_dat_b_1x1

);

assign rd0_c_na0_i = rd0_c_na0;
assign rd0_c_a0_i = rd0_c_a0;
assign rd0_na1_na2_i = rd0_na1_na2;
assign rd0_na1_a2_i = rd0_na1_a2;
assign rd0_a1_na2_i = rd0_a1_na2;
assign rd0_a1_a2_i = rd0_a1_a2;
assign rd0_na3_i = rd0_na3;
assign rd0_a3_i = rd0_a3;
assign rd0_na4_na5_i = rd0_na4_na5;
assign rd0_na4_a5_i = rd0_na4_a5;
assign rd0_a4_na5_i = rd0_a4_na5;
assign rd0_a4_a5_i = rd0_a4_a5;

// dot-or then buf?
assign rd0_dat = {rd0_dat_0x0 | rd0_dat_1x0, rd0_dat_0x1 | rd0_dat_1x1};
assign rd1_dat = {rd1_dat_0x0 | rd1_dat_1x0, rd1_dat_0x1 | rd1_dat_1x1};

genvar i;
for (i = 0; i < 12; i = i + 1) begin
  sky130_fd_sc_hd__buf_1 BUF_0 (.A(wr0_dat[i]), .X(wr0_dat_0x0[i]));
  sky130_fd_sc_hd__inv_1 INV_0 (.A(wr0_dat[i]), .Y(wr0_dat_b_0x0[i]));
  sky130_fd_sc_hd__buf_1 BUF_1 (.A(wr0_dat[i]), .X(wr0_dat_1x0[i]));
  sky130_fd_sc_hd__inv_1 INV_1 (.A(wr0_dat[i]), .Y(wr0_dat_b_1x0[i]));
end

for (i = 0; i < 12; i = i + 1) begin
  sky130_fd_sc_hd__buf_1 BUF_0 (.A(wr0_dat[i+12]), .X(wr0_dat_0x1[i]));
  sky130_fd_sc_hd__inv_1 INV_0 (.A(wr0_dat[i+12]), .Y(wr0_dat_b_0x1[i]));
  sky130_fd_sc_hd__buf_1 BUF_1 (.A(wr0_dat[i+12]), .X(wr0_dat_1x1[i]));
  sky130_fd_sc_hd__inv_1 INV_1 (.A(wr0_dat[i+12]), .Y(wr0_dat_b_1x1[i]));
end

endmodule

