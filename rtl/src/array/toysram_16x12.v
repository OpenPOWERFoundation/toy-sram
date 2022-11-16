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
   input  [0:11]     WBLb

);

reg [0:11] mem_00;
reg [0:11] mem_01;
reg [0:11] mem_02;
reg [0:11] mem_03;
reg [0:11] mem_04;
reg [0:11] mem_05;
reg [0:11] mem_06;
reg [0:11] mem_07;
reg [0:11] mem_08;
reg [0:11] mem_09;
reg [0:11] mem_10;
reg [0:11] mem_11;
reg [0:11] mem_12;
reg [0:11] mem_13;
reg [0:11] mem_14;
reg [0:11] mem_15;

// word-select
// the bits are negative-active at this point
// the cell outputs 0 if stored '1' AND RWLx; RBLx[0:11] are dot-AND'ed
assign RBL0 = ~(mem_00  & {12{RWL0[0]}})  &
              ~(mem_01  & {12{RWL0[1]}})  &
              ~(mem_02  & {12{RWL0[2]}})  &
              ~(mem_03  & {12{RWL0[3]}})  &
              ~(mem_04  & {12{RWL0[4]}})  &
              ~(mem_05  & {12{RWL0[5]}})  &
              ~(mem_06  & {12{RWL0[6]}})  &
              ~(mem_07  & {12{RWL0[7]}})  &
              ~(mem_08  & {12{RWL0[8]}})  &
              ~(mem_09  & {12{RWL0[9]}})  &
              ~(mem_10  & {12{RWL0[10]}}) &
              ~(mem_11  & {12{RWL0[11]}}) &
              ~(mem_12  & {12{RWL0[12]}}) &
              ~(mem_13  & {12{RWL0[13]}}) &
              ~(mem_14  & {12{RWL0[14]}}) &
              ~(mem_15  & {12{RWL0[15]}});

assign RBL1 = ~(mem_00  & {12{RWL1[0]}})  &
              ~(mem_01  & {12{RWL1[1]}})  &
              ~(mem_02  & {12{RWL1[2]}})  &
              ~(mem_03  & {12{RWL1[3]}})  &
              ~(mem_04  & {12{RWL1[4]}})  &
              ~(mem_05  & {12{RWL1[5]}})  &
              ~(mem_06  & {12{RWL1[6]}})  &
              ~(mem_07  & {12{RWL1[7]}})  &
              ~(mem_08  & {12{RWL1[8]}})  &
              ~(mem_09  & {12{RWL1[9]}})  &
              ~(mem_10  & {12{RWL1[10]}}) &
              ~(mem_11  & {12{RWL1[11]}}) &
              ~(mem_12  & {12{RWL1[12]}}) &
              ~(mem_13  & {12{RWL1[13]}}) &
              ~(mem_14  & {12{RWL1[14]}}) &
              ~(mem_15  & {12{RWL1[15]}});

always @(posedge WWL[0]) begin
   mem_00 <= WBL | ~WBLb;
end

always @(posedge WWL[1]) begin
   mem_01 <= WBL | ~WBLb;
end

always @(posedge WWL[2]) begin
   mem_02 <= WBL | ~WBLb;
end

always @(posedge WWL[3]) begin
   mem_03 <= WBL | ~WBLb;
end

always @(posedge WWL[4]) begin
   mem_04 <= WBL | ~WBLb;
end

always @(posedge WWL[5]) begin
   mem_05 <= WBL | ~WBLb;
end

always @(posedge WWL[6]) begin
   mem_06 <= WBL | ~WBLb;
end

always @(posedge WWL[7]) begin
   mem_07 <= WBL | ~WBLb;
end

always @(posedge WWL[8]) begin
   mem_08 <= WBL | ~WBLb;
end

always @(posedge WWL[9]) begin
   mem_09 <= WBL | ~WBLb;
end

always @(posedge WWL[10]) begin
   mem_10 <= WBL | ~WBLb;
end

always @(posedge WWL[11]) begin
   mem_11 <= WBL | ~WBLb;
end

always @(posedge WWL[12]) begin
   mem_12 <= WBL | ~WBLb;
end

always @(posedge WWL[13]) begin
   mem_13 <= WBL | ~WBLb;
end

always @(posedge WWL[14]) begin
   mem_14 <= WBL | ~WBLb;
end

always @(posedge WWL[15]) begin
   mem_15 <= WBL | ~WBLb;
end

// assert errors (multiwrite, etc.)

endmodule