// © IBM Corp. 2021
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


// Address and clocking synthesized logic for SDR 2r1w 32 word array
// Two modes:
//   1. nodelay: for sim, FPGA - clk (SDR) or clk2x (DDR) produce strobe
//   2. delay: for implementation, strobes are configured, and derived from clk

`timescale 1 ns / 1 ns

module address_clock_sdr_2r1w_32 (

    strobe,

    // address ports and associated enable signals
    rd_enb_0,
    rd_adr_0,
    rd_enb_1,
    rd_adr_1,
    wr_enb_0,
    wr_adr_0,

    // predecoded address signal
    // four groups of one hot encoded signals
    // read address 0
    rd0_c_na0,
    rd0_c_a0,
    rd0_na1_na2,
    rd0_na1_a2,
    rd0_a1_na2,
    rd0_a1_a2,
    rd0_na3,
    rd0_a3,
    rd0_na4,
    rd0_a4,

    // read address 1
    rd1_c_na0,
    rd1_c_a0,
    rd1_na1_na2,
    rd1_na1_a2,
    rd1_a1_na2,
    rd1_a1_a2,
    rd1_na3,
    rd1_a3,
    rd1_na4,
    rd1_a4,

    // write address 0
    wr0_c_na0,
    wr0_c_a0,
    wr0_na1_na2,
    wr0_na1_a2,
    wr0_a1_na2,
    wr0_a1_a2,
    wr0_na3,
    wr0_a3,
    wr0_na4,
    wr0_a4

 );

 parameter GENMODE = 0;			// 0=NoDelay, 1=Delay

 input      strobe;

 // address ports and associated enable signals
 input       rd_enb_0;
 input [0:4] rd_adr_0;
 input       rd_enb_1;
 input [0:4] rd_adr_1;
 input       wr_enb_0;
 input [0:4] wr_adr_0;

 // predecoded address signal
 // four groups of one hot encoded signals
 // read address 0
 output   rd0_c_na0;
 output   rd0_c_a0;

 output   rd0_na1_na2;
 output   rd0_na1_a2;
 output   rd0_a1_na2;
 output   rd0_a1_a2;

 output   rd0_na3;
 output   rd0_a3;

 output   rd0_na4;
 output   rd0_a4;

    // read address 1
 output   rd1_c_na0;
 output   rd1_c_a0;

 output   rd1_na1_na2;
 output   rd1_na1_a2;
 output   rd1_a1_na2;
 output   rd1_a1_a2;

 output   rd1_na3;
 output   rd1_a3;

 output   rd1_na4;
 output   rd1_a4;

    // write address 0
 output   wr0_c_na0;
 output   wr0_c_a0;

 output   wr0_na1_na2;
 output   wr0_na1_a2;
 output   wr0_a1_na2;
 output   wr0_a1_a2;

 output   wr0_na3;
 output   wr0_a3;

 output   wr0_na4;
 output   wr0_a4;

   // one predecoder per port

  predecode_sdr_32 predecode_r0(
      .strobe(strobe),
      .enable(rd_enb_0),
      .address(rd_adr_0),
      .c_na0(rd0_c_na0),
      .c_a0(rd0_c_a0),
      .na1_na2(rd0_na1_na2),
      .na1_a2(rd0_na1_a2),
      .a1_na2(rd0_a1_na2),
      .a1_a2(rd0_a1_a2),
      .na3(rd0_na3),
      .a3(rd0_a3),
      .na4(rd0_na4),
      .a4(rd0_a4)
  );

  predecode_sdr_32 predecode_r1(
      .strobe(strobe),
      .enable(rd_enb_1),
      .address(rd_adr_1),
      .c_na0(rd1_c_na0),
      .c_a0(rd1_c_a0),
      .na1_na2(rd1_na1_na2),
      .na1_a2(rd1_na1_a2),
      .a1_na2(rd1_a1_na2),
      .a1_a2(rd1_a1_a2),
      .na3(rd1_na3),
      .a3(rd1_a3),
      .na4(rd1_na4),
      .a4(rd1_a4)
   );

   predecode_sdr_32 predecode_w0(
      .strobe(strobe),
      .enable(wr_enb_0),
      .address(wr_adr_0),
      .c_na0(wr0_c_na0),
      .c_a0(wr0_c_a0),
      .na1_na2(wr0_na1_na2),
      .na1_a2(wr0_na1_a2),
      .a1_na2(wr0_a1_na2),
      .a1_a2(wr0_a1_a2),
      .na3(wr0_na3),
      .a3(wr0_a3),
      .na4(wr0_na4),
      .a4(wr0_a4)
   );

endmodule
