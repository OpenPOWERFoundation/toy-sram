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

// Custom local eval cell (domino precharge and L/R subarray bit select)
module local_eval (

    input         PRE_b,
    input         RBL_L,
    input         RBL_R,
    output        RBL_O_b

);

sky130_fd_pr__pfet_01v8 PRE_L (.G(PRE_b), .D(RBL_L));
sky130_fd_pr__pfet_01v8 PRE_R (.G(PRE_b), .D(RBL_R));
sky130_fd_sc_hd__nand2_1 SEL (.A(RBL_L), .B(RBL_R), .X(RBL_O_b));

endmodule

// 2 reads x 12 bits x 2 ports (one quad)
module local_eval_comp (

    input         PRE0_b,
    input  [0:11] RBL0_L,
    input  [0:11] RBL0_R,
    output [0:11] RBL0_O_b,
    input         PRE1_b,
    input  [0:11] RBL1_L,
    input  [0:11] RBL1_R,
    output [0:11] RBL1_O_b

);

genvar i;
for (i = 0; i < 12; i = i + 1) begin
   local_eval eval_0 (.PRE_b(PRE0_b), .RBL_L(RBL0_L[i]), .RBL_R(RBL0_R[i]), .RBL_O_b(RBL0_O_b[i]));
   local_eval eval_1 (.PRE_b(PRE1_b), .RBL_L(RBL1_L[i]), .RBL_R(RBL1_R[i]), .RBL_O_b(RBL1_O_b[i]));
end

endmodule
