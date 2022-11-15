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

module toysram_32x12 (

   input  [0:31]     RWL0,
   input  [0:31]     RWL1,
   input  [0:31]     WWL,
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
reg [0:11] mem_16;
reg [0:11] mem_17;
reg [0:11] mem_18;
reg [0:11] mem_19;
reg [0:11] mem_20;
reg [0:11] mem_21;
reg [0:11] mem_22;
reg [0:11] mem_23;
reg [0:11] mem_24;
reg [0:11] mem_25;
reg [0:11] mem_26;
reg [0:11] mem_27;
reg [0:11] mem_28;
reg [0:11] mem_29;
reg [0:11] mem_30;
reg [0:11] mem_31;

// word-select
// the bits are negative-active at this point in the 16x12 but
//  the local eval is done between subarray pairs, so bits are positive going out
assign RBL0 = ~((mem_00 & {12{RWL0[0]}})  & (mem_16 & {12{RWL0[16]}})) &
              ~((mem_01 & {12{RWL0[1]}})  & (mem_17 & {12{RWL0[17]}})) &
              ~((mem_02 & {12{RWL0[2]}})  & (mem_18 & {12{RWL0[18]}})) &
              ~((mem_03 & {12{RWL0[3]}})  & (mem_19 & {12{RWL0[19]}})) &
              ~((mem_04 & {12{RWL0[4]}})  & (mem_20 & {12{RWL0[20]}})) &
              ~((mem_05 & {12{RWL0[5]}})  & (mem_21 & {12{RWL0[21]}})) &
              ~((mem_06 & {12{RWL0[6]}})  & (mem_22 & {12{RWL0[22]}})) &
              ~((mem_07 & {12{RWL0[7]}})  & (mem_23 & {12{RWL0[23]}})) &
              ~((mem_08 & {12{RWL0[8]}})  & (mem_24 & {12{RWL0[24]}})) &
              ~((mem_09 & {12{RWL0[9]}})  & (mem_25 & {12{RWL0[25]}})) &
              ~((mem_10 & {12{RWL0[10]}}) & (mem_26 & {12{RWL0[26]}})) &
              ~((mem_11 & {12{RWL0[11]}}) & (mem_27 & {12{RWL0[27]}})) &
              ~((mem_12 & {12{RWL0[12]}}) & (mem_28 & {12{RWL0[28]}})) &
              ~((mem_13 & {12{RWL0[13]}}) & (mem_29 & {12{RWL0[29]}})) &
              ~((mem_14 & {12{RWL0[14]}}) & (mem_30 & {12{RWL0[30]}})) &
              ~((mem_15 & {12{RWL0[15]}}) & (mem_31 & {12{RWL0[31]}}));

assign RBL0 = ~((mem_00 & {12{RWL1[0]}})  & (mem_16 & {12{RWL1[16]}})) &
              ~((mem_01 & {12{RWL1[1]}})  & (mem_17 & {12{RWL1[17]}})) &
              ~((mem_02 & {12{RWL1[2]}})  & (mem_18 & {12{RWL1[18]}})) &
              ~((mem_03 & {12{RWL1[3]}})  & (mem_19 & {12{RWL1[19]}})) &
              ~((mem_04 & {12{RWL1[4]}})  & (mem_20 & {12{RWL1[20]}})) &
              ~((mem_05 & {12{RWL1[5]}})  & (mem_21 & {12{RWL1[21]}})) &
              ~((mem_06 & {12{RWL1[6]}})  & (mem_22 & {12{RWL1[22]}})) &
              ~((mem_07 & {12{RWL1[7]}})  & (mem_23 & {12{RWL1[23]}})) &
              ~((mem_08 & {12{RWL1[8]}})  & (mem_24 & {12{RWL1[24]}})) &
              ~((mem_09 & {12{RWL1[9]}})  & (mem_25 & {12{RWL1[25]}})) &
              ~((mem_10 & {12{RWL1[10]}}) & (mem_26 & {12{RWL1[26]}})) &
              ~((mem_11 & {12{RWL1[11]}}) & (mem_27 & {12{RWL1[27]}})) &
              ~((mem_12 & {12{RWL1[12]}}) & (mem_28 & {12{RWL1[28]}})) &
              ~((mem_13 & {12{RWL1[13]}}) & (mem_29 & {12{RWL1[29]}})) &
              ~((mem_14 & {12{RWL1[14]}}) & (mem_30 & {12{RWL1[30]}})) &
              ~((mem_15 & {12{RWL1[15]}}) & (mem_31 & {12{RWL1[31]}}));

always @(posedge WWL[0]) begin
   mem_00 <= ~WBLb;
end

always @(posedge WWL[1]) begin
   mem_01 <= ~WBLb;
end

always @(posedge WWL[2]) begin
   mem_02 <= ~WBLb;
end

always @(posedge WWL[3]) begin
   mem_03 <= ~WBLb;
end

always @(posedge WWL[4]) begin
   mem_04 <= ~WBLb;
end

always @(posedge WWL[5]) begin
   mem_05 <= ~WBLb;
end

always @(posedge WWL[6]) begin
   mem_06 <= ~WBLb;
end

always @(posedge WWL[7]) begin
   mem_07 <= ~WBLb;
end

always @(posedge WWL[8]) begin
   mem_08 <= ~WBLb;
end

always @(posedge WWL[9]) begin
   mem_09 <= ~WBLb;
end

always @(posedge WWL[10]) begin
   mem_10 <= ~WBLb;
end

always @(posedge WWL[11]) begin
   mem_11 <= ~WBLb;
end

always @(posedge WWL[12]) begin
   mem_12 <= ~WBLb;
end

always @(posedge WWL[13]) begin
   mem_13 <= ~WBLb;
end

always @(posedge WWL[14]) begin
   mem_14 <= ~WBLb;
end

always @(posedge WWL[15]) begin
   mem_15 <= ~WBLb;
end

always @(posedge WWL[16]) begin
   mem_16 <= ~WBLb;
end

always @(posedge WWL[17]) begin
   mem_17 <= ~WBLb;
end

always @(posedge WWL[18]) begin
   mem_18 <= ~WBLb;
end

always @(posedge WWL[19]) begin
   mem_19 <= ~WBLb;
end

always @(posedge WWL[20]) begin
   mem_20 <= ~WBLb;
end

always @(posedge WWL[21]) begin
   mem_21 <= ~WBLb;
end

always @(posedge WWL[22]) begin
   mem_22 <= ~WBLb;
end

always @(posedge WWL[23]) begin
   mem_23 <= ~WBLb;
end

always @(posedge WWL[24]) begin
   mem_24 <= ~WBLb;
end

always @(posedge WWL[25]) begin
   mem_25 <= ~WBLb;
end

always @(posedge WWL[26]) begin
   mem_26 <= ~WBLb;
end

always @(posedge WWL[27]) begin
   mem_27 <= ~WBLb;
end

always @(posedge WWL[28]) begin
   mem_28 <= ~WBLb;
end

always @(posedge WWL[29]) begin
   mem_29 <= ~WBLb;
end

always @(posedge WWL[30]) begin
   mem_30 <= ~WBLb;
end

always @(posedge WWL[31]) begin
   mem_31 <= ~WBLb;
end

// assert errors (multiwrite, etc.)

endmodule