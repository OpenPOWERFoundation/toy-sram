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

// Wordline decodes
// Two versions:
//   12-in -> 64 one-hot (all selects, 1 comp used)
//   11-in -> 32 one-hot (half selects, 2 comps used)

`timescale 1 ps / 1 ps

// (c0)(12) -> 8 one-hots A0:A7
// (3)(45)  -> 8 one-hots B0:B7
//  A x B   -> 64 one-hots W00:W63
module decode_wordlines_64 (

    input         c_na0,
    input         c_a0,
    input         na1_na2,
    input         na1_a2,
    input         a1_na2,
    input         a1_a2,
    input         na3,
    input         a3,
    input         na4_na5,
    input         na4_a5,
    input         a4_na5,
    input         a4_a5,
    output [0:63] wl

);

wire [0:7]  dcd_a_b;
wire [0:7]  dcd_a;
wire [0:7]  dcd_b_b;
wire [0:7]  dcd_b;
wire [0:63] wl_b;

sky130_fd_sc_hd__nand2_2 DCD_A0b (.A(c_na0), .B(na1_na2), .Y(dcd_a_b[0]));
sky130_fd_sc_hd__nand2_2 DCD_A1b (.A(c_na0), .B(na1_a2),  .Y(dcd_a_b[1]));
sky130_fd_sc_hd__nand2_2 DCD_A2b (.A(c_na0), .B(a1_na2),  .Y(dcd_a_b[2]));
sky130_fd_sc_hd__nand2_2 DCD_A3b (.A(c_na0), .B(a1_a2),   .Y(dcd_a_b[3]));
sky130_fd_sc_hd__nand2_2 DCD_A4b (.A(c_a0),  .B(na1_na2), .Y(dcd_a_b[4]));
sky130_fd_sc_hd__nand2_2 DCD_A5b (.A(c_a0),  .B(na1_a2),  .Y(dcd_a_b[5]));
sky130_fd_sc_hd__nand2_2 DCD_A6b (.A(c_a0),  .B(a1_na2),  .Y(dcd_a_b[6]));
sky130_fd_sc_hd__nand2_2 DCD_A7b (.A(c_a0),  .B(a1_a2),   .Y(dcd_a_b[7]));

sky130_fd_sc_hd__inv_2 DCD_A0 (.A(dcd_a_b[0]), .Y(dcd_a[0]));
sky130_fd_sc_hd__inv_2 DCD_A1 (.A(dcd_a_b[1]), .Y(dcd_a[1]));
sky130_fd_sc_hd__inv_2 DCD_A2 (.A(dcd_a_b[2]), .Y(dcd_a[2]));
sky130_fd_sc_hd__inv_2 DCD_A3 (.A(dcd_a_b[3]), .Y(dcd_a[3]));
sky130_fd_sc_hd__inv_2 DCD_A4 (.A(dcd_a_b[4]), .Y(dcd_a[4]));
sky130_fd_sc_hd__inv_2 DCD_A5 (.A(dcd_a_b[5]), .Y(dcd_a[5]));
sky130_fd_sc_hd__inv_2 DCD_A6 (.A(dcd_a_b[6]), .Y(dcd_a[6]));
sky130_fd_sc_hd__inv_2 DCD_A7 (.A(dcd_a_b[7]), .Y(dcd_a[7]));

sky130_fd_sc_hd__nand2_2 DCD_B0b (.A(na3),   .B(na4_na5), .Y(dcd_b_b[0]));
sky130_fd_sc_hd__nand2_2 DCD_B1b (.A(na3),   .B(na4_a5),  .Y(dcd_b_b[1]));
sky130_fd_sc_hd__nand2_2 DCD_B2b (.A(na3),   .B(a4_na5),  .Y(dcd_b_b[2]));
sky130_fd_sc_hd__nand2_2 DCD_B3b (.A(na3),   .B(a4_a5),   .Y(dcd_b_b[3]));
sky130_fd_sc_hd__nand2_2 DCD_B4b (.A(a3),    .B(na4_na5), .Y(dcd_b_b[4]));
sky130_fd_sc_hd__nand2_2 DCD_B5b (.A(a3),    .B(na4_a5),  .Y(dcd_b_b[5]));
sky130_fd_sc_hd__nand2_2 DCD_B6b (.A(a3),    .B(a4_na5),  .Y(dcd_b_b[6]));
sky130_fd_sc_hd__nand2_2 DCD_B7b (.A(a3),    .B(a4_a5),   .Y(dcd_b_b[6]));

sky130_fd_sc_hd__inv_2 DCD_B0 (.A(dcd_b_b[0]), .Y(dcd_b[0]));
sky130_fd_sc_hd__inv_2 DCD_B1 (.A(dcd_b_b[1]), .Y(dcd_b[1]));
sky130_fd_sc_hd__inv_2 DCD_B2 (.A(dcd_b_b[2]), .Y(dcd_b[2]));
sky130_fd_sc_hd__inv_2 DCD_B3 (.A(dcd_b_b[3]), .Y(dcd_b[3]));
sky130_fd_sc_hd__inv_2 DCD_B4 (.A(dcd_b_b[4]), .Y(dcd_b[4]));
sky130_fd_sc_hd__inv_2 DCD_B5 (.A(dcd_b_b[5]), .Y(dcd_b[5]));
sky130_fd_sc_hd__inv_2 DCD_B6 (.A(dcd_b_b[6]), .Y(dcd_b[6]));
sky130_fd_sc_hd__inv_2 DCD_B7 (.A(dcd_b_b[7]), .Y(dcd_b[7]));

genvar i, j;
generate
   for (i = 0; i < 8; i = i + 1) begin
      for (j = 0; j < 8; j = j + 1) begin
         sky130_fd_sc_hd__nand2_2 DCD_Cb (.A(dcd_a[i]), .B(dcd_b[j]), .Y(wl_b[i*8+j]));
         sky130_fd_sc_hd__inv_2 DCD_C (.A(wl_b[i*8+j]), .Y(wl[i*8+j]));
      end
   end
endgenerate

endmodule
