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
// governing permissions and limitations under the License.
//
// Brief explanation of modifications:
//
// Modification 1: This modification extends the patent license to an implementation of the Work in physical form – i.e.,
// it unambiguously permits a user to make and use the physical chip.

// Behavioral for 16x12 toysram subarray

`timescale 1 ps / 1 ps

module toysram_16x12 (

   input  [0:15]     RWL0,
   input  [0:15]     RWL1,
   input  [0:15]     WWL,
   output [0:11]     RBL0,
   output [0:11]     RBL1,
   input  [0:11]     WBL,
   input  [0:11]     WBLb,
);

reg [0:11]  mem[0:15];

for (i = 0; i < 15; i = i + 1) begin
   always @(posedge WWL[i]) begin
      mem[i] <= not WBLb;  // 00=1 01=0 10=1 11=0
   end
end

// word-select
assign RBL0 = (mem[0]  and {12{RWL0[0]}})  |
              (mem[1]  and {12{RWL0[1]}})  |
              (mem[2]  and {12{RWL0[2]}})  |
              (mem[3]  and {12{RWL0[3]}})  |
              (mem[4]  and {12{RWL0[4]}})  |
              (mem[5]  and {12{RWL0[5]}})  |
              (mem[6]  and {12{RWL0[6]}})  |
              (mem[7]  and {12{RWL0[7]}})  |
              (mem[8]  and {12{RWL0[8]}})  |
              (mem[9]  and {12{RWL0[9]}})  |
              (mem[10] and {12{RWL0[10]}}) |
              (mem[11] and {12{RWL0[11]}}) |
              (mem[12] and {12{RWL0[12]}}) |
              (mem[13] and {12{RWL0[13]}}) |
              (mem[14] and {12{RWL0[14]}}) |
              (mem[15] and {12{RWL0[15]}});

assign RBL1 = (mem[0]  and {12{RWL1[0]}})  |
              (mem[1]  and {12{RWL1[1]}})  |
              (mem[2]  and {12{RWL1[2]}})  |
              (mem[3]  and {12{RWL1[3]}})  |
              (mem[4]  and {12{RWL1[4]}})  |
              (mem[5]  and {12{RWL1[5]}})  |
              (mem[6]  and {12{RWL1[6]}})  |
              (mem[7]  and {12{RWL1[7]}})  |
              (mem[8]  and {12{RWL1[8]}})  |
              (mem[9]  and {12{RWL1[9]}})  |
              (mem[10] and {12{RWL1[10]}}) |
              (mem[11] and {12{RWL1[11]}}) |
              (mem[12] and {12{RWL1[12]}}) |
              (mem[13] and {12{RWL1[13]}}) |
              (mem[14] and {12{RWL1[14]}}) |
              (mem[15] and {12{RWL1[15]}});

endmodule