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


// Behavioral for 64x24 toysram (sdr or ddr) using 16x12 hard subarrays

`timescale 1 ps / 1 ps

module regfile_64x24_2r1w (

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
    output [0:23] rd0_dat,

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
    output [0:23] rd1_dat,

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
    input [0:23]  wr0_dat

);

 // word & bit selects

 wire [0:15]      rwl0_00_15_00_11;
 wire [0:15]      rwl0_00_15_12_23;
 wire [0:15]      rwl1_00_15_00_11;
 wire [0:15]      rwl1_00_15_12_23;
 wire [0:15]      wwl_00_15_00_11;
 wire [0:15]      wwl_00_15_12_23;
 wire [0:11]      rbl0_00_15_00_11;
 wire [0:11]      rbl0_00_15_12_23;
 wire [0:11]      rbl1_00_15_00_11;
 wire [0:11]      rbl1_00_15_12_23;
 wire [0:11]      wbl_00_15_00_11;
 wire [0:11]      wbl_00_15_12_23;

 wire [0:15]      rwl0_16_31_00_11;
 wire [0:15]      rwl0_16_31_12_23;
 wire [0:15]      rwl1_16_31_00_11;
 wire [0:15]      rwl1_16_31_12_23;
 wire [0:15]      wwl_16_31_00_11;
 wire [0:15]      wwl_16_31_12_23;
 wire [0:11]      rbl0_16_31_00_11;
 wire [0:11]      rbl0_16_31_12_23;
 wire [0:11]      rbl1_16_31_00_11;
 wire [0:11]      rbl1_16_31_12_23;
 wire [0:11]      wbl_16_31_00_11;
 wire [0:11]      wbl_16_31_12_23;

 wire [0:15]      rwl0_32_47_00_11;
 wire [0:15]      rwl0_32_47_12_23;
 wire [0:15]      rwl1_32_47_00_11;
 wire [0:15]      rwl1_32_47_12_23;
 wire [0:15]      wwl_32_47_00_11;
 wire [0:15]      wwl_32_47_12_23;
 wire [0:11]      rbl0_32_47_00_11;
 wire [0:11]      rbl0_32_47_12_23;
 wire [0:11]      rbl1_32_47_00_11;
 wire [0:11]      rbl1_32_47_12_23;
 wire [0:11]      wbl_32_47_00_11;
 wire [0:11]      wbl_32_47_12_23;

 wire [0:15]      rwl0_48_63_00_11;
 wire [0:15]      rwl0_48_63_12_23;
 wire [0:15]      rwl1_48_63_00_11;
 wire [0:15]      rwl1_48_63_12_23;
 wire [0:15]      wwl_48_63_00_11;
 wire [0:15]      wwl_48_63_12_23;
 wire [0:11]      rbl0_48_63_00_11;
 wire [0:11]      rbl0_48_63_12_23;
 wire [0:11]      rbl1_48_63_00_11;
 wire [0:11]      rbl1_48_63_12_23;
 wire [0:11]      wbl_48_63_00_11;
 wire [0:11]      wbl_48_63_12_23;

// subarray cells; 4x2 16w/12b subarrays

// words 00:15
toysram_16x12 w00 (
   .RWL0(rwl0_00_15_00_11),
   .RWL1(rwl1_00_15_00_11),
   .WWL(wwl_00_15_00_11),
   .RBL0(rbl0_00_15_00_11),
   .RBL1(rbl1_00_15_00_11),
   .WBL(wbl_00_15_00_11),
   .WBLb(~wbl_00_15_00_11)
);
toysram_16x12 w01 (
   .RWL0(rwl0_00_15_12_23),
   .RWL1(rwl1_00_15_12_23),
   .WWL(wwl_00_15_12_23),
   .RBL0(rbl0_00_15_12_23),
   .RBL1(rbl1_00_15_12_23),
   .WBL(wbl_00_15_12_23),
   .WBLb(~wbl_00_15_12_23)
);

// words 16:31
toysram_16x12 w10 (
   .RWL0(rwl0_16_31_00_11),
   .RWL1(rwl1_16_31_00_11),
   .WWL(wwl_16_31_00_11),
   .RBL0(rbl0_16_31_00_11),
   .RBL1(rbl1_16_31_00_11),
   .WBL(wbl_16_31_00_11),
   .WBLb(~wbl_16_31_00_11)
);
toysram_16x12 w11 (
   .RWL0(rwl0_16_31_12_23),
   .RWL1(rwl1_16_31_12_23),
   .WWL(wwl_16_31_12_23),
   .RBL0(rbl0_16_31_12_23),
   .RBL1(rbl1_16_31_12_23),
   .WBL(wbl_16_31_12_23),
   .WBLb(~wbl_16_31_12_23)
);

// words 32:47
toysram_16x12 w20 (
   .RWL0(rwl0_32_47_00_11),
   .RWL1(rwl1_32_47_00_11),
   .WWL(wwl_32_47_00_11),
   .RBL0(rbl0_32_47_00_11),
   .RBL1(rbl1_32_47_00_11),
   .WBL(wbl_32_47_00_11),
   .WBLb(~wbl_32_47_00_11)
);
toysram_16x12 w21 (
   .RWL0(rwl0_32_47_12_23),
   .RWL1(rwl1_32_47_12_23),
   .WWL(wwl_32_47_12_23),
   .RBL0(rbl0_32_47_12_23),
   .RBL1(rbl1_32_47_12_23),
   .WBL(wbl_32_47_12_23),
   .WBLb(~wbl_32_47_12_23)
);

// words 48:63
toysram_16x12 w30 (
   .RWL0(rwl0_48_63_00_11),
   .RWL1(rwl1_48_63_00_11),
   .WWL(wwl_48_63_00_11),
   .RBL0(rbl0_48_63_00_11),
   .RBL1(rbl1_48_63_00_11),
   .WBL(wbl_48_63_00_11),
   .WBLb(~wbl_48_63_00_11)
);
toysram_16x12 w31 (
   .RWL0(rwl0_48_63_12_23),
   .RWL1(rwl1_48_63_12_23),
   .WWL(wwl_48_63_12_23),
   .RBL0(rbl0_48_63_12_23),
   .RBL1(rbl1_48_63_12_23),
   .WBL(wbl_48_63_12_23),
   .WBLb(~wbl_48_63_12_23)
);

// word lines

assign rwl0_00_15_00_11[0]  = rd0_c_na0 & rd0_na1_na2 & rd0_na3 & rd0_na4_na5;
assign rwl1_00_15_00_11[0]  = rd1_c_na0 & rd1_na1_na2 & rd1_na3 & rd1_na4_na5;
assign wwl_00_15_00_11[0]   = wr0_c_na0 & wr0_na1_na2 & wr0_na3 & wr0_na4_na5;

assign rwl0_00_15_00_11[1]  = rd0_c_na0 & rd0_na1_na2 & rd0_na3 & rd0_na4_a5;
assign rwl1_00_15_00_11[1]  = rd1_c_na0 & rd1_na1_na2 & rd1_na3 & rd1_na4_a5;
assign wwl_00_15_00_11[1]   = wr0_c_na0 & wr0_na1_na2 & wr0_na3 & wr0_na4_a5;

assign rwl0_00_15_00_11[2]  = rd0_c_na0 & rd0_na1_na2 & rd0_na3 & rd0_a4_na5;
assign rwl1_00_15_00_11[2]  = rd1_c_na0 & rd1_na1_na2 & rd1_na3 & rd1_a4_na5;
assign wwl_00_15_00_11[2]   = wr0_c_na0 & wr0_na1_na2 & wr0_na3 & wr0_a4_na5;

assign rwl0_00_15_00_11[3]  = rd0_c_na0 & rd0_na1_na2 & rd0_na3 & rd0_a4_a5;
assign rwl1_00_15_00_11[3]  = rd1_c_na0 & rd1_na1_na2 & rd1_na3 & rd1_a4_a5;
assign wwl_00_15_00_11[3]   = wr0_c_na0 & wr0_na1_na2 & wr0_na3 & wr0_a4_a5;

assign rwl0_00_15_00_11[4]  = rd0_c_na0 & rd0_na1_na2 & rd0_a3 & rd0_na4_na5;
assign rwl1_00_15_00_11[4]  = rd1_c_na0 & rd1_na1_na2 & rd1_a3 & rd1_na4_na5;
assign wwl_00_15_00_11[4]   = wr0_c_na0 & wr0_na1_na2 & wr0_a3 & wr0_na4_na5;

assign rwl0_00_15_00_11[5]  = rd0_c_na0 & rd0_na1_na2 & rd0_a3 & rd0_na4_a5;
assign rwl1_00_15_00_11[5]  = rd1_c_na0 & rd1_na1_na2 & rd1_a3 & rd1_na4_a5;
assign wwl_00_15_00_11[5]   = wr0_c_na0 & wr0_na1_na2 & wr0_a3 & wr0_na4_a5;

assign rwl0_00_15_00_11[6]  = rd0_c_na0 & rd0_na1_na2 & rd0_a3 & rd0_a4_na5;
assign rwl1_00_15_00_11[6]  = rd1_c_na0 & rd1_na1_na2 & rd1_a3 & rd1_a4_na5;
assign wwl_00_15_00_11[6]   = wr0_c_na0 & wr0_na1_na2 & wr0_a3 & wr0_a4_na5;

assign rwl0_00_15_00_11[7]  = rd0_c_na0 & rd0_na1_na2 & rd0_a3 & rd0_a4_a5;
assign rwl1_00_15_00_11[7]  = rd1_c_na0 & rd1_na1_na2 & rd1_a3 & rd1_a4_a5;
assign wwl_00_15_00_11[7]   = wr0_c_na0 & wr0_na1_na2 & wr0_a3 & wr0_a4_a5;

assign rwl0_00_15_00_11[8]  = rd0_c_na0 & rd0_na1_a2 & rd0_na3 & rd0_na4_na5;
assign rwl1_00_15_00_11[8]  = rd1_c_na0 & rd1_na1_a2 & rd1_na3 & rd1_na4_na5;
assign wwl_00_15_00_11[8]   = wr0_c_na0 & wr0_na1_a2 & wr0_na3 & wr0_na4_na5;

assign rwl0_00_15_00_11[9]  = rd0_c_na0 & rd0_na1_a2 & rd0_na3 & rd0_na4_a5;
assign rwl1_00_15_00_11[9]  = rd1_c_na0 & rd1_na1_a2 & rd1_na3 & rd1_na4_a5;
assign wwl_00_15_00_11[9]   = wr0_c_na0 & wr0_na1_a2 & wr0_na3 & wr0_na4_a5;

assign rwl0_00_15_00_11[10] = rd0_c_na0 & rd0_na1_a2 & rd0_na3 & rd0_a4_na5;
assign rwl1_00_15_00_11[10] = rd1_c_na0 & rd1_na1_a2 & rd1_na3 & rd1_a4_na5;
assign wwl_00_15_00_11[10]  = wr0_c_na0 & wr0_na1_a2 & wr0_na3 & wr0_a4_na5;

assign rwl0_00_15_00_11[11] = rd0_c_na0 & rd0_na1_a2 & rd0_na3 & rd0_a4_a5;
assign rwl1_00_15_00_11[11] = rd1_c_na0 & rd1_na1_a2 & rd1_na3 & rd1_a4_a5;
assign wwl_00_15_00_11[11]  = wr0_c_na0 & wr0_na1_a2 & wr0_na3 & wr0_a4_a5;

assign rwl0_00_15_00_11[12] = rd0_c_na0 & rd0_na1_a2 & rd0_a3 & rd0_na4_na5;
assign rwl1_00_15_00_11[12] = rd1_c_na0 & rd1_na1_a2 & rd1_a3 & rd1_na4_na5;
assign wwl_00_15_00_11[12]  = wr0_c_na0 & wr0_na1_a2 & wr0_a3 & wr0_na4_na5;

assign rwl0_00_15_00_11[13] = rd0_c_na0 & rd0_na1_a2 & rd0_a3 & rd0_na4_a5;
assign rwl1_00_15_00_11[13] = rd1_c_na0 & rd1_na1_a2 & rd1_a3 & rd1_na4_a5;
assign wwl_00_15_00_11[13]  = wr0_c_na0 & wr0_na1_a2 & wr0_a3 & wr0_na4_a5;

assign rwl0_00_15_00_11[14] = rd0_c_na0 & rd0_na1_a2 & rd0_a3 & rd0_a4_na5;
assign rwl1_00_15_00_11[14] = rd1_c_na0 & rd1_na1_a2 & rd1_a3 & rd1_a4_na5;
assign wwl_00_15_00_11[14]  = wr0_c_na0 & wr0_na1_a2 & wr0_a3 & wr0_a4_na5;

assign rwl0_00_15_00_11[15] = rd0_c_na0 & rd0_na1_a2 & rd0_a3 & rd0_a4_a5;
assign rwl1_00_15_00_11[15] = rd1_c_na0 & rd1_na1_a2 & rd1_a3 & rd1_a4_a5;
assign wwl_00_15_00_11[15]  = wr0_c_na0 & wr0_na1_a2 & wr0_a3 & wr0_a4_a5;

assign rwl0_00_15_12_23     = rwl0_00_15_00_11;
assign rwl1_00_15_12_23     = rwl1_00_15_00_11;
assign wwl_00_15_12_23      = wwl_00_15_00_11;

assign rwl0_16_31_00_11[0]  = rd0_c_na0 & rd0_a1_na2 & rd0_na3 & rd0_na4_na5;
assign rwl1_16_31_00_11[0]  = rd1_c_na0 & rd1_a1_na2 & rd1_na3 & rd1_na4_na5;
assign wwl_16_31_00_11[0]   = wr0_c_na0 & wr0_a1_na2 & wr0_na3 & wr0_na4_na5;

assign rwl0_16_31_00_11[1]  = rd0_c_na0 & rd0_a1_na2 & rd0_na3 & rd0_na4_a5;
assign rwl1_16_31_00_11[1]  = rd1_c_na0 & rd1_a1_na2 & rd1_na3 & rd1_na4_a5;
assign wwl_16_31_00_11[1]   = wr0_c_na0 & wr0_a1_na2 & wr0_na3 & wr0_na4_a5;

assign rwl0_16_31_00_11[2]  = rd0_c_na0 & rd0_a1_na2 & rd0_na3 & rd0_a4_na5;
assign rwl1_16_31_00_11[2]  = rd1_c_na0 & rd1_a1_na2 & rd1_na3 & rd1_a4_na5;
assign wwl_16_31_00_11[2]   = wr0_c_na0 & wr0_a1_na2 & wr0_na3 & wr0_a4_na5;

assign rwl0_16_31_00_11[3]  = rd0_c_na0 & rd0_a1_na2 & rd0_na3 & rd0_a4_a5;
assign rwl1_16_31_00_11[3]  = rd1_c_na0 & rd1_a1_na2 & rd1_na3 & rd1_a4_a5;
assign wwl_16_31_00_11[3]   = wr0_c_na0 & wr0_a1_na2 & wr0_na3 & wr0_a4_a5;

assign rwl0_16_31_00_11[4]  = rd0_c_na0 & rd0_a1_na2 & rd0_a3 & rd0_na4_na5;
assign rwl1_16_31_00_11[4]  = rd1_c_na0 & rd1_a1_na2 & rd1_a3 & rd1_na4_na5;
assign wwl_16_31_00_11[4]   = wr0_c_na0 & wr0_a1_na2 & wr0_a3 & wr0_na4_na5;

assign rwl0_16_31_00_11[5]  = rd0_c_na0 & rd0_a1_na2 & rd0_a3 & rd0_na4_a5;
assign rwl1_16_31_00_11[5]  = rd1_c_na0 & rd1_a1_na2 & rd1_a3 & rd1_na4_a5;
assign wwl_16_31_00_11[5]   = wr0_c_na0 & wr0_a1_na2 & wr0_a3 & wr0_na4_a5;

assign rwl0_16_31_00_11[6]  = rd0_c_na0 & rd0_a1_na2 & rd0_a3 & rd0_a4_na5;
assign rwl1_16_31_00_11[6]  = rd1_c_na0 & rd1_a1_na2 & rd1_a3 & rd1_a4_na5;
assign wwl_16_31_00_11[6]   = wr0_c_na0 & wr0_a1_na2 & wr0_a3 & wr0_a4_na5;

assign rwl0_16_31_00_11[7]  = rd0_c_na0 & rd0_a1_na2 & rd0_a3 & rd0_a4_a5;
assign rwl1_16_31_00_11[7]  = rd1_c_na0 & rd1_a1_na2 & rd1_a3 & rd1_a4_a5;
assign wwl_16_31_00_11[7]   = wr0_c_na0 & wr0_a1_na2 & wr0_a3 & wr0_a4_a5;

assign rwl0_16_31_00_11[8]  = rd0_c_na0 & rd0_a1_a2 & rd0_na3 & rd0_na4_na5;
assign rwl1_16_31_00_11[8]  = rd1_c_na0 & rd1_a1_a2 & rd1_na3 & rd1_na4_na5;
assign wwl_16_31_00_11[8]   = wr0_c_na0 & wr0_a1_a2 & wr0_na3 & wr0_na4_na5;

assign rwl0_16_31_00_11[9]  = rd0_c_na0 & rd0_a1_a2 & rd0_na3 & rd0_na4_a5;
assign rwl1_16_31_00_11[9]  = rd1_c_na0 & rd1_a1_a2 & rd1_na3 & rd1_na4_a5;
assign wwl_16_31_00_11[9]   = wr0_c_na0 & wr0_a1_a2 & wr0_na3 & wr0_na4_a5;

assign rwl0_16_31_00_11[10] = rd0_c_na0 & rd0_a1_a2 & rd0_na3 & rd0_a4_na5;
assign rwl1_16_31_00_11[10] = rd1_c_na0 & rd1_a1_a2 & rd1_na3 & rd1_a4_na5;
assign wwl_16_31_00_11[10]  = wr0_c_na0 & wr0_a1_a2 & wr0_na3 & wr0_a4_na5;

assign rwl0_16_31_00_11[11] = rd0_c_na0 & rd0_a1_a2 & rd0_na3 & rd0_a4_a5;
assign rwl1_16_31_00_11[11] = rd1_c_na0 & rd1_a1_a2 & rd1_na3 & rd1_a4_a5;
assign wwl_16_31_00_11[11]  = wr0_c_na0 & wr0_a1_a2 & wr0_na3 & wr0_a4_a5;

assign rwl0_16_31_00_11[12] = rd0_c_na0 & rd0_a1_a2 & rd0_a3 & rd0_na4_na5;
assign rwl1_16_31_00_11[12] = rd1_c_na0 & rd1_a1_a2 & rd1_a3 & rd1_na4_na5;
assign wwl_16_31_00_11[12]  = wr0_c_na0 & wr0_a1_a2 & wr0_a3 & wr0_na4_na5;

assign rwl0_16_31_00_11[13] = rd0_c_na0 & rd0_a1_a2 & rd0_a3 & rd0_na4_a5;
assign rwl1_16_31_00_11[13] = rd1_c_na0 & rd1_a1_a2 & rd1_a3 & rd1_na4_a5;
assign wwl_16_31_00_11[13]  = wr0_c_na0 & wr0_a1_a2 & wr0_a3 & wr0_na4_a5;

assign rwl0_16_31_00_11[14] = rd0_c_na0 & rd0_a1_a2 & rd0_a3 & rd0_a4_na5;
assign rwl1_16_31_00_11[14] = rd1_c_na0 & rd1_a1_a2 & rd1_a3 & rd1_a4_na5;
assign wwl_16_31_00_11[14]  = wr0_c_na0 & wr0_a1_a2 & wr0_a3 & wr0_a4_na5;

assign rwl0_16_31_00_11[15] = rd0_c_na0 & rd0_a1_a2 & rd0_a3 & rd0_a4_a5;
assign rwl1_16_31_00_11[15] = rd1_c_na0 & rd1_a1_a2 & rd1_a3 & rd1_a4_a5;
assign wwl_16_31_00_11[15]  = wr0_c_na0 & wr0_a1_a2 & wr0_a3 & wr0_a4_a5;

assign rwl0_16_31_12_23     = rwl0_16_31_00_11;
assign rwl1_16_31_12_23     = rwl1_16_31_00_11;
assign wwl_16_31_12_23      = wwl_16_31_00_11;

assign rwl0_32_47_00_11[0]  = rd0_c_a0 & rd0_na1_na2 & rd0_na3 & rd0_na4_na5;
assign rwl1_32_47_00_11[0]  = rd1_c_a0 & rd1_na1_na2 & rd1_na3 & rd1_na4_na5;
assign wwl_32_47_00_11[0]   = wr0_c_a0 & wr0_na1_na2 & wr0_na3 & wr0_na4_na5;

assign rwl0_32_47_00_11[1]  = rd0_c_a0 & rd0_na1_na2 & rd0_na3 & rd0_na4_a5;
assign rwl1_32_47_00_11[1]  = rd1_c_a0 & rd1_na1_na2 & rd1_na3 & rd1_na4_a5;
assign wwl_32_47_00_11[1]   = wr0_c_a0 & wr0_na1_na2 & wr0_na3 & wr0_na4_a5;

assign rwl0_32_47_00_11[2]  = rd0_c_a0 & rd0_na1_na2 & rd0_na3 & rd0_a4_na5;
assign rwl1_32_47_00_11[2]  = rd1_c_a0 & rd1_na1_na2 & rd1_na3 & rd1_a4_na5;
assign wwl_32_47_00_11[2]   = wr0_c_a0 & wr0_na1_na2 & wr0_na3 & wr0_a4_na5;

assign rwl0_32_47_00_11[3]  = rd0_c_a0 & rd0_na1_na2 & rd0_na3 & rd0_a4_a5;
assign rwl1_32_47_00_11[3]  = rd1_c_a0 & rd1_na1_na2 & rd1_na3 & rd1_a4_a5;
assign wwl_32_47_00_11[3]   = wr0_c_a0 & wr0_na1_na2 & wr0_na3 & wr0_a4_a5;

assign rwl0_32_47_00_11[4]  = rd0_c_a0 & rd0_na1_na2 & rd0_a3 & rd0_na4_na5;
assign rwl1_32_47_00_11[4]  = rd1_c_a0 & rd1_na1_na2 & rd1_a3 & rd1_na4_na5;
assign wwl_32_47_00_11[4]   = wr0_c_a0 & wr0_na1_na2 & wr0_a3 & wr0_na4_na5;

assign rwl0_32_47_00_11[5]  = rd0_c_a0 & rd0_na1_na2 & rd0_a3 & rd0_na4_a5;
assign rwl1_32_47_00_11[5]  = rd1_c_a0 & rd1_na1_na2 & rd1_a3 & rd1_na4_a5;
assign wwl_32_47_00_11[5]   = wr0_c_a0 & wr0_na1_na2 & wr0_a3 & wr0_na4_a5;

assign rwl0_32_47_00_11[6]  = rd0_c_a0 & rd0_na1_na2 & rd0_a3 & rd0_a4_na5;
assign rwl1_32_47_00_11[6]  = rd1_c_a0 & rd1_na1_na2 & rd1_a3 & rd1_a4_na5;
assign wwl_32_47_00_11[6]   = wr0_c_a0 & wr0_na1_na2 & wr0_a3 & wr0_a4_na5;

assign rwl0_32_47_00_11[7]  = rd0_c_a0 & rd0_na1_na2 & rd0_a3 & rd0_a4_a5;
assign rwl1_32_47_00_11[7]  = rd1_c_a0 & rd1_na1_na2 & rd1_a3 & rd1_a4_a5;
assign wwl_32_47_00_11[7]   = wr0_c_a0 & wr0_na1_na2 & wr0_a3 & wr0_a4_a5;

assign rwl0_32_47_00_11[8]  = rd0_c_a0 & rd0_na1_a2 & rd0_na3 & rd0_na4_na5;
assign rwl1_32_47_00_11[8]  = rd1_c_a0 & rd1_na1_a2 & rd1_na3 & rd1_na4_na5;
assign wwl_32_47_00_11[8]   = wr0_c_a0 & wr0_na1_a2 & wr0_na3 & wr0_na4_na5;

assign rwl0_32_47_00_11[9]  = rd0_c_a0 & rd0_na1_a2 & rd0_na3 & rd0_na4_a5;
assign rwl1_32_47_00_11[9]  = rd1_c_a0 & rd1_na1_a2 & rd1_na3 & rd1_na4_a5;
assign wwl_32_47_00_11[9]   = wr0_c_a0 & wr0_na1_a2 & wr0_na3 & wr0_na4_a5;

assign rwl0_32_47_00_11[10] = rd0_c_a0 & rd0_na1_a2 & rd0_na3 & rd0_a4_na5;
assign rwl1_32_47_00_11[10] = rd1_c_a0 & rd1_na1_a2 & rd1_na3 & rd1_a4_na5;
assign wwl_32_47_00_11[10]  = wr0_c_a0 & wr0_na1_a2 & wr0_na3 & wr0_a4_na5;

assign rwl0_32_47_00_11[11] = rd0_c_a0 & rd0_na1_a2 & rd0_na3 & rd0_a4_a5;
assign rwl1_32_47_00_11[11] = rd1_c_a0 & rd1_na1_a2 & rd1_na3 & rd1_a4_a5;
assign wwl_32_47_00_11[11]  = wr0_c_a0 & wr0_na1_a2 & wr0_na3 & wr0_a4_a5;

assign rwl0_32_47_00_11[12] = rd0_c_a0 & rd0_na1_a2 & rd0_a3 & rd0_na4_na5;
assign rwl1_32_47_00_11[12] = rd1_c_a0 & rd1_na1_a2 & rd1_a3 & rd1_na4_na5;
assign wwl_32_47_00_11[12]  = wr0_c_a0 & wr0_na1_a2 & wr0_a3 & wr0_na4_na5;

assign rwl0_32_47_00_11[13] = rd0_c_a0 & rd0_na1_a2 & rd0_a3 & rd0_na4_a5;
assign rwl1_32_47_00_11[13] = rd1_c_a0 & rd1_na1_a2 & rd1_a3 & rd1_na4_a5;
assign wwl_32_47_00_11[13]  = wr0_c_a0 & wr0_na1_a2 & wr0_a3 & wr0_na4_a5;

assign rwl0_32_47_00_11[14] = rd0_c_a0 & rd0_na1_a2 & rd0_a3 & rd0_a4_na5;
assign rwl1_32_47_00_11[14] = rd1_c_a0 & rd1_na1_a2 & rd1_a3 & rd1_a4_na5;
assign wwl_32_47_00_11[14]  = wr0_c_a0 & wr0_na1_a2 & wr0_a3 & wr0_a4_na5;

assign rwl0_32_47_00_11[15] = rd0_c_a0 & rd0_na1_a2 & rd0_a3 & rd0_a4_a5;
assign rwl1_32_47_00_11[15] = rd1_c_a0 & rd1_na1_a2 & rd1_a3 & rd1_a4_a5;
assign wwl_32_47_00_11[15]  = wr0_c_a0 & wr0_na1_a2 & wr0_a3 & wr0_a4_a5;

assign rwl0_32_47_12_23     = rwl0_32_47_00_11;
assign rwl1_32_47_12_23     = rwl1_32_47_00_11;
assign wwl_32_47_12_23      = wwl_32_47_00_11;

assign rwl0_48_63_00_11[0]  = rd0_c_a0 & rd0_a1_na2 & rd0_na3 & rd0_na4_na5;
assign rwl1_48_63_00_11[0]  = rd1_c_a0 & rd1_a1_na2 & rd1_na3 & rd1_na4_na5;
assign wwl_48_63_00_11[0]   = wr0_c_a0 & wr0_a1_na2 & wr0_na3 & wr0_na4_na5;

assign rwl0_48_63_00_11[1]  = rd0_c_a0 & rd0_a1_na2 & rd0_na3 & rd0_na4_a5;
assign rwl1_48_63_00_11[1]  = rd1_c_a0 & rd1_a1_na2 & rd1_na3 & rd1_na4_a5;
assign wwl_48_63_00_11[1]   = wr0_c_a0 & wr0_a1_na2 & wr0_na3 & wr0_na4_a5;

assign rwl0_48_63_00_11[2]  = rd0_c_a0 & rd0_a1_na2 & rd0_na3 & rd0_a4_na5;
assign rwl1_48_63_00_11[2]  = rd1_c_a0 & rd1_a1_na2 & rd1_na3 & rd1_a4_na5;
assign wwl_48_63_00_11[2]   = wr0_c_a0 & wr0_a1_na2 & wr0_na3 & wr0_a4_na5;

assign rwl0_48_63_00_11[3]  = rd0_c_a0 & rd0_a1_na2 & rd0_na3 & rd0_a4_a5;
assign rwl1_48_63_00_11[3]  = rd1_c_a0 & rd1_a1_na2 & rd1_na3 & rd1_a4_a5;
assign wwl_48_63_00_11[3]   = wr0_c_a0 & wr0_a1_na2 & wr0_na3 & wr0_a4_a5;

assign rwl0_48_63_00_11[4]  = rd0_c_a0 & rd0_a1_na2 & rd0_a3 & rd0_na4_na5;
assign rwl1_48_63_00_11[4]  = rd1_c_a0 & rd1_a1_na2 & rd1_a3 & rd1_na4_na5;
assign wwl_48_63_00_11[4]   = wr0_c_a0 & wr0_a1_na2 & wr0_a3 & wr0_na4_na5;

assign rwl0_48_63_00_11[5]  = rd0_c_a0 & rd0_a1_na2 & rd0_a3 & rd0_na4_a5;
assign rwl1_48_63_00_11[5]  = rd1_c_a0 & rd1_a1_na2 & rd1_a3 & rd1_na4_a5;
assign wwl_48_63_00_11[5]   = wr0_c_a0 & wr0_a1_na2 & wr0_a3 & wr0_na4_a5;

assign rwl0_48_63_00_11[6]  = rd0_c_a0 & rd0_a1_na2 & rd0_a3 & rd0_a4_na5;
assign rwl1_48_63_00_11[6]  = rd1_c_a0 & rd1_a1_na2 & rd1_a3 & rd1_a4_na5;
assign wwl_48_63_00_11[6]   = wr0_c_a0 & wr0_a1_na2 & wr0_a3 & wr0_a4_na5;

assign rwl0_48_63_00_11[7]  = rd0_c_a0 & rd0_a1_na2 & rd0_a3 & rd0_a4_a5;
assign rwl1_48_63_00_11[7]  = rd1_c_a0 & rd1_a1_na2 & rd1_a3 & rd1_a4_a5;
assign wwl_48_63_00_11[7]   = wr0_c_a0 & wr0_a1_na2 & wr0_a3 & wr0_a4_a5;

assign rwl0_48_63_00_11[8]  = rd0_c_a0 & rd0_a1_a2 & rd0_na3 & rd0_na4_na5;
assign rwl1_48_63_00_11[8]  = rd1_c_a0 & rd1_a1_a2 & rd1_na3 & rd1_na4_na5;
assign wwl_48_63_00_11[8]   = wr0_c_a0 & wr0_a1_a2 & wr0_na3 & wr0_na4_na5;

assign rwl0_48_63_00_11[9]  = rd0_c_a0 & rd0_a1_a2 & rd0_na3 & rd0_na4_a5;
assign rwl1_48_63_00_11[9]  = rd1_c_a0 & rd1_a1_a2 & rd1_na3 & rd1_na4_a5;
assign wwl_48_63_00_11[9]   = wr0_c_a0 & wr0_a1_a2 & wr0_na3 & wr0_na4_a5;

assign rwl0_48_63_00_11[10] = rd0_c_a0 & rd0_a1_a2 & rd0_na3 & rd0_a4_na5;
assign rwl1_48_63_00_11[10] = rd1_c_a0 & rd1_a1_a2 & rd1_na3 & rd1_a4_na5;
assign wwl_48_63_00_11[10]  = wr0_c_a0 & wr0_a1_a2 & wr0_na3 & wr0_a4_na5;

assign rwl0_48_63_00_11[11] = rd0_c_a0 & rd0_a1_a2 & rd0_na3 & rd0_a4_a5;
assign rwl1_48_63_00_11[11] = rd1_c_a0 & rd1_a1_a2 & rd1_na3 & rd1_a4_a5;
assign wwl_48_63_00_11[11]  = wr0_c_a0 & wr0_a1_a2 & wr0_na3 & wr0_a4_a5;

assign rwl0_48_63_00_11[12] = rd0_c_a0 & rd0_a1_a2 & rd0_a3 & rd0_na4_na5;
assign rwl1_48_63_00_11[12] = rd1_c_a0 & rd1_a1_a2 & rd1_a3 & rd1_na4_na5;
assign wwl_48_63_00_11[12]  = wr0_c_a0 & wr0_a1_a2 & wr0_a3 & wr0_na4_na5;

assign rwl0_48_63_00_11[13] = rd0_c_a0 & rd0_a1_a2 & rd0_a3 & rd0_na4_a5;
assign rwl1_48_63_00_11[13] = rd1_c_a0 & rd1_a1_a2 & rd1_a3 & rd1_na4_a5;
assign wwl_48_63_00_11[13]  = wr0_c_a0 & wr0_a1_a2 & wr0_a3 & wr0_na4_a5;

assign rwl0_48_63_00_11[14] = rd0_c_a0 & rd0_a1_a2 & rd0_a3 & rd0_a4_na5;
assign rwl1_48_63_00_11[14] = rd1_c_a0 & rd1_a1_a2 & rd1_a3 & rd1_a4_na5;
assign wwl_48_63_00_11[14]  = wr0_c_a0 & wr0_a1_a2 & wr0_a3 & wr0_a4_na5;

assign rwl0_48_63_00_11[15] = rd0_c_a0 & rd0_a1_a2 & rd0_a3 & rd0_a4_a5;
assign rwl1_48_63_00_11[15] = rd1_c_a0 & rd1_a1_a2 & rd1_a3 & rd1_a4_a5;
assign wwl_48_63_00_11[15]  = wr0_c_a0 & wr0_a1_a2 & wr0_a3 & wr0_a4_a5;

assign rwl0_48_63_12_23     = rwl0_48_63_00_11;
assign rwl1_48_63_12_23     = rwl1_48_63_00_11;
assign wwl_48_63_12_23      = wwl_48_63_00_11;


// bit lines

genvar i;
generate

for (i = 0; i < 12; i = i + 1) begin
   assign rd0_dat[i] = (~rbl0_00_15_00_11[i]) | (~rbl0_16_31_00_11[i]) | (~rbl0_32_47_00_11[i]) | (~rbl0_48_63_00_11[i]);
   assign rd1_dat[i] = (~rbl1_00_15_00_11[i]) | (~rbl1_16_31_00_11[i]) | (~rbl1_32_47_00_11[i]) | (~rbl1_48_63_00_11[i]);
end

for (i = 0; i < 12; i = i + 1) begin
   assign rd0_dat[i+12] = (~rbl0_00_15_12_23[i]) | (~rbl0_16_31_12_23[i]) | (~rbl0_32_47_12_23[i]) | (~rbl0_48_63_12_23[i]);
   assign rd1_dat[i+12] = (~rbl1_00_15_12_23[i]) | (~rbl1_16_31_12_23[i]) | (~rbl1_32_47_12_23[i]) | (~rbl1_48_63_12_23[i]);
end

endgenerate

assign wbl_00_15_00_11 = wr0_dat[0:11];
assign wbl_00_15_12_23 = wr0_dat[12:23];
assign wbl_16_31_00_11 = wr0_dat[0:11];
assign wbl_16_31_12_23 = wr0_dat[12:23];
assign wbl_32_47_00_11 = wr0_dat[0:11];
assign wbl_32_47_12_23 = wr0_dat[12:23];
assign wbl_48_63_00_11 = wr0_dat[0:11];
assign wbl_48_63_12_23 = wr0_dat[12:23];

endmodule
