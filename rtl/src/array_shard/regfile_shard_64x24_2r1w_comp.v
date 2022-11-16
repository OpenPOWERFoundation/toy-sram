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


// Behavioral for 64x24 toysram (sdr or ddr), 'shard' (semi-hard)
// 16x12 hard subarrays plus decoder, eval, io comps
//  OR
// 32x12 hard subarrays plus decoder, io comps

`timescale 1 ps / 1 ps
module regfile_shard_64x24_2r1w_comp #(
    parameter integer RA_32x12 = 1
) (

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

// internal passed from io to decoders
wire        rd0_c_na0_i;
wire        rd0_c_a0_i;
wire        rd0_na1_na2_i;
wire        rd0_na1_a2_i;
wire        rd0_a1_na2_i;
wire        rd0_a1_a2_i;
wire        rd0_na3_i;
wire        rd0_a3_i;
wire        rd0_na4_na5_i;
wire        rd0_na4_a5_i;
wire        rd0_a4_na5_i;
wire        rd0_a4_a5_i;

wire        rd1_c_na0_i;
wire        rd1_c_a0_i;
wire        rd1_na1_na2_i;
wire        rd1_na1_a2_i;
wire        rd1_a1_na2_i;
wire        rd1_a1_a2_i;
wire        rd1_na3_i;
wire        rd1_a3_i;
wire        rd1_na4_na5_i;
wire        rd1_na4_a5_i;
wire        rd1_a4_na5_i;
wire        rd1_a4_a5_i;

wire        wr0_c_na0_i;
wire        wr0_c_a0_i;
wire        wr0_na1_na2_i;
wire        wr0_na1_a2_i;
wire        wr0_a1_na2_i;
wire        wr0_a1_a2_i;
wire        wr0_na3_i;
wire        wr0_a3_i;
wire        wr0_na4_na5_i;
wire        wr0_na4_a5_i;
wire        wr0_a4_na5_i;
wire        wr0_a4_a5_i;

// word selects
wire [0:31] rwl0_0x0;
wire [0:31] rwl1_0x0;
wire [0:31] wwl0_0x0;
wire [0:31] rwl0_0x1;
wire [0:31] rwl1_0x1;
wire [0:31] wwl0_0x1;

wire [0:31] rwl0_1x0;
wire [0:31] rwl1_1x0;
wire [0:31] wwl0_1x0;
wire [0:31] rwl0_1x1;
wire [0:31] rwl1_1x1;
wire [0:31] wwl0_1x1;

// subarray ins/outs
wire [0:15] rwl0_000;
wire [0:15] rwl1_000;
wire [0:15] wwl0_000;
wire [0:11] rbl0_000;
wire [0:11] rbl1_000;
wire [0:11] wbl0_000;
wire [0:11] wbl0_b_000;

wire [0:15] rwl0_001;
wire [0:15] rwl1_001;
wire [0:15] wwl0_001;
wire [0:11] rbl0_001;
wire [0:11] rbl1_001;
wire [0:11] wbl0_001;
wire [0:11] wbl0_b_001;

wire [0:15] rwl0_010;
wire [0:15] rwl1_010;
wire [0:15] wwl0_010;
wire [0:11] rbl0_010;
wire [0:11] rbl1_010;
wire [0:11] wbl0_010;
wire [0:11] wbl0_b_010;

wire [0:15] rwl0_011;
wire [0:15] rwl1_011;
wire [0:15] wwl0_011;
wire [0:11] rbl0_011;
wire [0:11] rbl1_011;
wire [0:11] wbl0_011;
wire [0:11] wbl0_b_011;

wire [0:15] rwl0_100;
wire [0:15] rwl1_100;
wire [0:15] wwl0_100;
wire [0:11] rbl0_100;
wire [0:11] rbl1_100;
wire [0:11] wbl0_100;
wire [0:11] wbl0_b_100;

wire [0:15] rwl0_101;
wire [0:15] rwl1_101;
wire [0:15] wwl0_101;
wire [0:11] rbl0_101;
wire [0:11] rbl1_101;
wire [0:11] wbl0_101;
wire [0:11] wbl0_b_101;

wire [0:15] rwl0_110;
wire [0:15] rwl1_110;
wire [0:15] wwl0_110;
wire [0:11] rbl0_110;
wire [0:11] rbl1_110;
wire [0:11] wbl0_110;
wire [0:11] wbl0_b_110;

wire [0:15] rwl0_111;
wire [0:15] rwl1_111;
wire [0:15] wwl0_111;
wire [0:11] rbl0_111;
wire [0:11] rbl1_111;
wire [0:11] wbl0_111;
wire [0:11] wbl0_b_111;

// local evals
wire        pre0_0x0_b;
wire        pre0_0x0;
wire        pre0_0x1_b;
wire        pre0_0x1;
wire        pre0_1x0_b;
wire        pre0_1x0;
wire        pre0_1x1_b;
wire        pre0_1x1;

wire        pre1_0x0_b;
wire        pre1_0x0;
wire        pre1_0x1_b;
wire        pre1_0x1;
wire        pre1_1x0_b;
wire        pre1_1x0;
wire        pre1_1x1_b;
wire        pre1_1x1;

wire [0:11] rbl0_0x0;
wire [0:11] rbl0_0x1;
wire [0:11] rbl0_1x0;
wire [0:11] rbl0_1x1;

wire [0:11] rbl1_0x0;
wire [0:11] rbl1_0x1;
wire [0:11] rbl1_1x0;
wire [0:11] rbl1_1x1;

// write data
wire [0:11] wbl0_0x0;
wire [0:11] wbl0_0x1;
wire [0:11] wbl0_1x0;
wire [0:11] wbl0_1x1;
wire [0:11] wbl0_b_0x0;
wire [0:11] wbl0_b_0x1;
wire [0:11] wbl0_b_1x0;
wire [0:11] wbl0_b_1x1;

// subarray cells; 4x2 16w/12b subarrays
//
// bits are stacked vertically, words horizontally
// gap-d = dcd
// gap-e = local eval
// gap-i = i/o
//
//   b---> e <---b
//         --------> i
//   ^
//   |
//   wwwww   wwwww
//  gap-d produces 64 wordlines per port
//  gap-e(2) produce 24 L-R bitlines per port
//  gap-i produces 24 bitlines per port
//
// subarrays
//
//   000 e 010  i  100 e 110
//   ddddddddddddddddddddddd
//   001 e 011  i  101 e 111
//
// @1,2,4,5 are subarray word-selects
// @0,3 are final 2 data selects (gap-e, gap-i)
//
// if @0 is final select, subarrays:
//   00x=W0xx0xx  01x=W0xx1xx  10x=W1xx0xx 11x=W1xx1xx (0xx=W0xxxxx, 1xx=W1xxxxx)
// if @3 is final select, subarrays:
//   00x=W0xx0xx  01x=W1xx0xx  10x=W0xx1xx 11x=W1xx1xx (0xx=Wxxx0xx, 1xx=Wxxx1xx)
//
// 32x12 subarrays are L/R pairs and local eval

// subarrays
generate

if (RA_32x12 == 0) begin

   toysram_16x12 r000 (
      .RWL0(rwl0_000),
      .RWL1(rwl1_000),
      .WWL(wwl0_000),
      .RBL0(rbl0_000),
      .RBL1(rbl1_000),
      .WBL(wbl0_000),
      .WBLb(wbl0_b_000)
   );
   toysram_16x12 r001 (
      .RWL0(rwl0_001),
      .RWL1(rwl1_001),
      .WWL(wwl0_001),
      .RBL0(rbl0_001),
      .RBL1(rbl1_001),
      .WBL(wbl0_001),
      .WBLb(wbl0_b_001)
   );

   toysram_16x12 r010 (
      .RWL0(rwl0_010),
      .RWL1(rwl1_010),
      .WWL(wwl0_010),
      .RBL0(rbl0_010),
      .RBL1(rbl1_010),
      .WBL(wbl0_010),
      .WBLb(wbl0_b_010)
   );

   toysram_16x12 r011 (
      .RWL0(rwl0_011),
      .RWL1(rwl1_011),
      .WWL(wwl0_011),
      .RBL0(rbl0_011),
      .RBL1(rbl1_011),
      .WBL(wbl0_011),
      .WBLb(wbl0_b_011)
   );

   toysram_16x12 r100 (
      .RWL0(rwl0_100),
      .RWL1(rwl1_100),
      .WWL(wwl0_100),
      .RBL0(rbl0_100),
      .RBL1(rbl1_100),
      .WBL(wbl0_100),
      .WBLb(wbl0_b_100)
   );

   toysram_16x12 r101 (
      .RWL0(rwl0_101),
      .RWL1(rwl1_101),
      .WWL(wwl0_101),
      .RBL0(rbl0_101),
      .RBL1(rbl1_101),
      .WBL(wbl0_101),
      .WBLb(wbl0_b_101)
   );

   toysram_16x12 r110 (
      .RWL0(rwl0_110),
      .RWL1(rwl1_110),
      .WWL(wwl0_110),
      .RBL0(rbl0_110),
      .RBL1(rbl1_110),
      .WBL(wbl0_110),
      .WBLb(wbl0_b_110)
   );

   toysram_16x12 r111 (
      .RWL0(rwl0_111),
      .RWL1(rwl1_111),
      .WWL(wwl0_111),
      .RBL0(rbl0_111),
      .RBL1(rbl1_111),
      .WBL(wbl0_111),
      .WBLb(wbl0_b_111)
   );

end else begin

   // words 00:31
   toysram_32x12 r00 (
      .RWL0(rwl0_0x0),
      .RWL1(rwl1_0x0),
      .WWL(wwl0_0x0),
      .RBL0(rbl0_0x0),
      .RBL1(rbl1_0x0),
      .WBL(wbl0_0x0),
      .WBLb(wbl0_b_0x0)
   );

   toysram_32x12 r01 (
      .RWL0(rwl0_0x1),
      .RWL1(rwl1_0x1),
      .WWL(wwl0_0x1),
      .RBL0(rbl0_0x1),
      .RBL1(rbl1_0x1),
      .WBL(wbl0_0x1),
      .WBLb(wbl0_b_0x1)
   );

   // words 32:47
   toysram_32x12 r10 (
      .RWL0(rwl0_1x0),
      .RWL1(rwl1_1x0),
      .WWL(wwl0_1x0),
      .RBL0(rbl0_1x0),
      .RBL1(rbl1_1x0),
      .WBL(wbl0_1x0),
      .WBLb(wbl0_b_1x0)
   );

   // words 48:63
   toysram_32x12 r11 (
      .RWL0(rwl0_1x1),
      .RWL1(rwl1_1x1),
      .WWL(wwl0_1x1),
      .RBL0(rbl0_1x1),
      .RBL1(rbl1_1x1),
      .WBL(wbl0_1x1),
      .WBLb(wbl0_b_1x1)
   );

end
endgenerate

// wordline decodes to one-hots; separate copies for up/down
// separate comps for L/R so i/o macro can divide the center; a3
//  distinguishes L/R
wordlines_comp_32 dcd_0 (

    .rd0_c_na0(rd0_c_na0_i),
    .rd0_c_a0(rd0_c_a0_i),
    .rd0_na1_na2(rd0_na1_na2_i),
    .rd0_na1_a2(rd0_na1_a2_i),
    .rd0_a1_na2(rd0_a1_na2_i),
    .rd0_a1_a2(rd0_a1_a2_i),
    .rd0_xa3(rd0_na3_i),
    //.rd0_na3(rd0_na3_i),
    //.rd0_a3(rd0_a3_i),
    .rd0_na4_na5(rd0_na4_na5_i),
    .rd0_na4_a5(rd0_na4_a5_i),
    .rd0_a4_na5(rd0_a4_na5_i),
    .rd0_a4_a5(rd0_a4_a5_i),
    .rwl0_0(rwl0_0x0),
    .rwl0_1(rwl0_0x1),
    .rd1_c_na0(rd1_c_na0_i),
    .rd1_c_a0(rd1_c_a0_i),
    .rd1_na1_na2(rd1_na1_na2_i),
    .rd1_na1_a2(rd1_na1_a2_i),
    .rd1_a1_na2(rd1_a1_na2_i),
    .rd1_a1_a2(rd1_a1_a2_i),
    .rd1_xa3(rd1_na3_i),
    //.rd1_na3(rd1_na3_i),
    //.rd1_a3(rd1_a3_i),
    .rd1_na4_na5(rd1_na4_na5_i),
    .rd1_na4_a5(rd1_na4_a5_i),
    .rd1_a4_na5(rd1_a4_na5_i),
    .rd1_a4_a5(rd1_a4_a5_i),
    .rwl1_0(rwl1_0x0),
    .rwl1_1(rwl1_0x1),
    .wr0_c_na0(wr0_c_na0_i),
    .wr0_c_a0(wr0_c_a0_i),
    .wr0_na1_na2(wr0_na1_na2_i),
    .wr0_na1_a2(wr0_na1_a2_i),
    .wr0_a1_na2(wr0_a1_na2_i),
    .wr0_a1_a2(wr0_a1_a2_i),
    .wr0_xa3(wr0_na3_i),
    //.wr0_na3(wr0_na3_i),
    //.wr0_a3(wr0_a3_i),
    .wr0_na4_na5(wr0_na4_na5_i),
    .wr0_na4_a5(wr0_na4_a5_i),
    .wr0_a4_na5(wr0_a4_na5_i),
    .wr0_a4_a5(wr0_a4_a5_i),
    .wwl0_0(wwl0_0x0),
    .wwl0_1(wwl0_0x1)

);

wordlines_comp_32 dcd_1 (

    .rd0_c_na0(rd0_c_na0_i),
    .rd0_c_a0(rd0_c_a0_i),
    .rd0_na1_na2(rd0_na1_na2_i),
    .rd0_na1_a2(rd0_na1_a2_i),
    .rd0_a1_na2(rd0_a1_na2_i),
    .rd0_a1_a2(rd0_a1_a2_i),
    .rd0_xa3(rd0_a3_i),
    //.rd0_na3(rd0_na3_i),
    //.rd0_a3(rd0_a3_i),
    .rd0_na4_na5(rd0_na4_na5_i),
    .rd0_na4_a5(rd0_na4_a5_i),
    .rd0_a4_na5(rd0_a4_na5_i),
    .rd0_a4_a5(rd0_a4_a5_i),
    .rwl0_0(rwl0_1x0),
    .rwl0_1(rwl0_1x1),
    .rd1_c_na0(rd1_c_na0_i),
    .rd1_c_a0(rd1_c_a0_i),
    .rd1_na1_na2(rd1_na1_na2_i),
    .rd1_na1_a2(rd1_na1_a2_i),
    .rd1_a1_na2(rd1_a1_na2_i),
    .rd1_a1_a2(rd1_a1_a2_i),
    .rd1_xa3(rd1_a3_i),
    //.rd1_na3(rd1_na3_i),
    //.rd1_a3(rd1_a3_i),
    .rd1_na4_na5(rd1_na4_na5_i),
    .rd1_na4_a5(rd1_na4_a5_i),
    .rd1_a4_na5(rd1_a4_na5_i),
    .rd1_a4_a5(rd1_a4_a5_i),
    .rwl1_0(rwl1_1x0),
    .rwl1_1(rwl1_1x1),
    .wr0_c_na0(wr0_c_na0_i),
    .wr0_c_a0(wr0_c_a0_i),
    .wr0_na1_na2(wr0_na1_na2_i),
    .wr0_na1_a2(wr0_na1_a2_i),
    .wr0_a1_na2(wr0_a1_na2_i),
    .wr0_a1_a2(wr0_a1_a2_i),
    .wr0_xa3(wr0_a3_i),
    //.wr0_na3(wr0_na3_i),
    //.wr0_a3(wr0_a3_i),
    .wr0_na4_na5(wr0_na4_na5_i),
    .wr0_na4_a5(wr0_na4_a5_i),
    .wr0_a4_na5(wr0_a4_na5_i),
    .wr0_a4_a5(wr0_a4_a5_i),
    .wwl0_0(wwl0_1x0),
    .wwl0_1(wwl0_1x1)

 );

generate

if (RA_32x12 == 0) begin

   assign rwl0_000 = rwl0_0x0[0:15];
   assign rwl0_001 = rwl0_0x1[0:15];
   assign rwl0_010 = rwl0_0x0[16:31];
   assign rwl0_011 = rwl0_0x1[16:31];
   assign rwl0_100 = rwl0_1x0[0:15];
   assign rwl0_101 = rwl0_1x1[0:15];
   assign rwl0_110 = rwl0_1x0[16:31];
   assign rwl0_111 = rwl0_1x1[16:31];

   assign rwl1_000 = rwl1_0x0[0:15];
   assign rwl1_001 = rwl1_0x1[0:15];
   assign rwl1_010 = rwl1_0x0[16:31];
   assign rwl1_011 = rwl1_0x1[16:31];
   assign rwl1_100 = rwl1_1x0[0:15];
   assign rwl1_101 = rwl1_1x1[0:15];
   assign rwl1_110 = rwl1_1x0[16:31];
   assign rwl1_111 = rwl1_1x1[16:31];

   assign wwl0_000 = wwl0_0x0[0:15];
   assign wwl0_001 = wwl0_0x1[0:15];
   assign wwl0_010 = wwl0_0x0[16:31];
   assign wwl0_011 = wwl0_0x1[16:31];
   assign wwl0_100 = wwl0_1x0[0:15];
   assign wwl0_101 = wwl0_1x1[0:15];
   assign wwl0_110 = wwl0_1x0[16:31];
   assign wwl0_111 = wwl0_1x1[16:31];

   // local eval

   //wtf move to decode!
   // precharge repower
   // during precharge c_na0 = c_a0 = 0
   // 4 copies to 000/010, 001/011, 100/110, 101,111 quads
   // rd0
   sky130_fd_sc_hd__inv_2 inv0_0x0_b (.A(rd0_c_na0),  .Y(pre0_0x0_b));
   sky130_fd_sc_hd__inv_2 inv0_0x0   (.A(pre0_0x0_b), .Y(pre0_0x0));
   sky130_fd_sc_hd__inv_2 inv0_0x1_b (.A(rd0_c_na0),  .Y(pre0_0x1_b));
   sky130_fd_sc_hd__inv_2 inv0_0x1   (.A(pre0_0x1_b), .Y(pre0_0x1));
   sky130_fd_sc_hd__inv_2 inv0_1x0_b (.A(rd0_c_a0),   .Y(pre0_1x0_b));
   sky130_fd_sc_hd__inv_2 inv0_1x0   (.A(pre0_1x0_b), .Y(pre0_1x0));
   sky130_fd_sc_hd__inv_2 inv0_1x1_b (.A(rd0_c_a0),   .Y(pre0_1x1_b));
   sky130_fd_sc_hd__inv_2 inv0_1x1   (.A(pre0_1x1_b), .Y(pre0_1x1));
   // rd1
   sky130_fd_sc_hd__inv_2 inv1_0x0_b (.A(rd0_c_na0),  .Y(pre1_0x0_b));
   sky130_fd_sc_hd__inv_2 inv1_0x0   (.A(pre1_0x0_b), .Y(pre1_0x0));
   sky130_fd_sc_hd__inv_2 inv1_0x1_b (.A(rd0_c_na0),  .Y(pre1_0x1_b));
   sky130_fd_sc_hd__inv_2 inv1_0x1   (.A(pre1_0x1_b), .Y(pre1_0x1));
   sky130_fd_sc_hd__inv_2 inv1_1x0_b (.A(rd0_c_a0),   .Y(pre1_1x0_b));
   sky130_fd_sc_hd__inv_2 inv1_1x0   (.A(pre1_1x0_b), .Y(pre1_1x0));
   sky130_fd_sc_hd__inv_2 inv1_1x1_b (.A(rd0_c_a0),   .Y(pre1_1x1_b));
   sky130_fd_sc_hd__inv_2 inv1_1x1   (.A(pre1_1x1_b), .Y(pre1_1x1));

   // quad local evals, 2 ports
   local_eval_comp eval_0x0 (
   .PRE0_b(pre0_0x0), .RBL0_L(rbl0_000), .RBL0_R(rbl0_010), .RBL0_O_b(rbl0_0x0),
   .PRE1_b(pre1_0x0), .RBL1_L(rbl1_000), .RBL1_R(rbl1_010), .RBL1_O_b(rbl1_0x0)
   );
   local_eval_comp eval_0x1 (
   .PRE0_b(pre0_0x1), .RBL0_L(rbl0_001), .RBL0_R(rbl0_011), .RBL0_O_b(rbl0_0x1),
   .PRE1_b(pre1_0x1), .RBL1_L(rbl1_001), .RBL1_R(rbl1_011), .RBL1_O_b(rbl1_0x1)
   );
   local_eval_comp eval_1x0 (
   .PRE0_b(pre0_1x0), .RBL0_L(rbl0_100), .RBL0_R(rbl0_110), .RBL0_O_b(rbl0_1x0),
   .PRE1_b(pre1_1x0), .RBL1_L(rbl1_100), .RBL1_R(rbl1_110), .RBL1_O_b(rbl1_1x0)
   );
   local_eval_comp eval_1x1 (
   .PRE0_b(pre0_1x1), .RBL0_L(rbl0_101), .RBL0_R(rbl0_111), .RBL0_O_b(rbl0_1x1),
   .PRE1_b(pre1_1x1), .RBL1_L(rbl1_101), .RBL1_R(rbl1_111), .RBL1_O_b(rbl1_1x1)
   );

end

endgenerate

// separate ports by quads for placement
// address passes through - should start decode here
// final 2:1 select for reads
// fanout +/- for writes
// wtf do wbl get another level buffering for far pairs? where? local eval col?
inout_comp io (

    .rd0_c_na0(rd0_c_na0),
    .rd0_c_a0(rd0_c_a0),
    .rd0_na1_na2(rd0_na1_na2),
    .rd0_na1_a2(rd0_na1_a2),
    .rd0_a1_na2(rd0_a1_na2),
    .rd0_a1_a2(rd0_a1_a2),
    .rd0_na3(rd0_na3),
    .rd0_a3(rd0_a3),
    .rd0_na4_na5(rd0_na4_na5),
    .rd0_na4_a5(rd0_na4_a5),
    .rd0_a4_na5(rd0_a4_na5),
    .rd0_a4_a5(rd0_a4_a5),

    .rd1_c_na0(rd1_c_na0),
    .rd1_c_a0(rd1_c_a0),
    .rd1_na1_na2(rd1_na1_na2),
    .rd1_na1_a2(rd1_na1_a2),
    .rd1_a1_na2(rd1_a1_na2),
    .rd1_a1_a2(rd1_a1_a2),
    .rd1_na3(rd1_na3),
    .rd1_a3(rd1_a3),
    .rd1_na4_na5(rd1_na4_na5),
    .rd1_na4_a5(rd1_na4_a5),
    .rd1_a4_na5(rd1_a4_na5),
    .rd1_a4_a5(rd1_a4_a5),

    .wr0_c_na0(wr0_c_na0),
    .wr0_c_a0(wr0_c_a0),
    .wr0_na1_na2(wr0_na1_na2),
    .wr0_na1_a2(wr0_na1_a2),
    .wr0_a1_na2(wr0_a1_na2),
    .wr0_a1_a2(wr0_a1_a2),
    .wr0_na3(wr0_na3),
    .wr0_a3(wr0_a3),
    .wr0_na4_na5(wr0_na4_na5),
    .wr0_na4_a5(wr0_na4_a5),
    .wr0_a4_na5(wr0_a4_na5),
    .wr0_a4_a5(wr0_a4_a5),

    .rd0_c_na0_i(rd0_c_na0_i),
    .rd0_c_a0_i(rd0_c_a0_i),
    .rd0_na1_na2_i(rd0_na1_na2_i),
    .rd0_na1_a2_i(rd0_na1_a2_i),
    .rd0_a1_na2_i(rd0_a1_na2_i),
    .rd0_a1_a2_i(rd0_a1_a2_i),
    .rd0_na3_i(rd0_na3_i),
    .rd0_a3_i(rd0_a3_i),
    .rd0_na4_na5_i(rd0_na4_na5_i),
    .rd0_na4_a5_i(rd0_na4_a5_i),
    .rd0_a4_na5_i(rd0_a4_na5_i),
    .rd0_a4_a5_i(rd0_a4_a5_i),

    .rd1_c_na0_i(rd1_c_na0_i),
    .rd1_c_a0_i(rd1_c_a0_i),
    .rd1_na1_na2_i(rd1_na1_na2_i),
    .rd1_na1_a2_i(rd1_na1_a2_i),
    .rd1_a1_na2_i(rd1_a1_na2_i),
    .rd1_a1_a2_i(rd1_a1_a2_i),
    .rd1_na3_i(rd1_na3_i),
    .rd1_a3_i(rd1_a3_i),
    .rd1_na4_na5_i(rd1_na4_na5_i),
    .rd1_na4_a5_i(rd1_na4_a5_i),
    .rd1_a4_na5_i(rd1_a4_na5_i),
    .rd1_a4_a5_i(rd1_a4_a5_i),

    .wr0_c_na0_i(wr0_c_na0_i),
    .wr0_c_a0_i(wr0_c_a0_i),
    .wr0_na1_na2_i(wr0_na1_na2_i),
    .wr0_na1_a2_i(wr0_na1_a2_i),
    .wr0_a1_na2_i(wr0_a1_na2_i),
    .wr0_a1_a2_i(wr0_a1_a2_i),
    .wr0_na3_i(wr0_na3_i),
    .wr0_a3_i(wr0_a3_i),
    .wr0_na4_na5_i(wr0_na4_na5_i),
    .wr0_na4_a5_i(wr0_na4_a5_i),
    .wr0_a4_na5_i(wr0_a4_na5_i),
    .wr0_a4_a5_i(wr0_a4_a5_i),

    .rd0_dat_0x0(rbl0_0x0),
    .rd0_dat_0x1(rbl0_0x1),
    .rd0_dat_1x0(rbl0_1x0),
    .rd0_dat_1x1(rbl0_1x1),
    .rd0_dat(rd0_dat),

    .rd1_dat_0x0(rbl1_0x0),
    .rd1_dat_0x1(rbl1_0x1),
    .rd1_dat_1x0(rbl1_1x0),
    .rd1_dat_1x1(rbl1_1x1),
    .rd1_dat(rd1_dat),

    .wr0_dat(wr0_dat),
    .wr0_dat_0x0(wbl0_0x0),
    .wr0_dat_b_0x0(wbl0_b_0x0),
    .wr0_dat_0x1(wbl0_0x1),
    .wr0_dat_b_0x1(wbl0_b_0x1),
    .wr0_dat_1x0(wbl0_1x0),
    .wr0_dat_b_1x0(wbl0_b_1x0),
    .wr0_dat_1x1(wbl0_1x1),
    .wr0_dat_b_1x1(wbl0_b_1x1)

);

assign wbl0_000 = wbl0_0x0;
assign wbl0_001 = wbl0_0x1;
assign wbl0_010 = wbl0_0x0;
assign wbl0_011 = wbl0_0x1;
assign wbl0_100 = wbl0_1x0;
assign wbl0_101 = wbl0_0x1;
assign wbl0_110 = wbl0_1x0;
assign wbl0_111 = wbl0_0x1;

assign wbl0_b_000 = wbl0_b_0x0;
assign wbl0_b_001 = wbl0_b_0x1;
assign wbl0_b_010 = wbl0_b_0x0;
assign wbl0_b_011 = wbl0_b_0x1;
assign wbl0_b_100 = wbl0_b_1x0;
assign wbl0_b_101 = wbl0_b_0x1;
assign wbl0_b_110 = wbl0_b_1x0;
assign wbl0_b_111 = wbl0_b_0x1;

endmodule
