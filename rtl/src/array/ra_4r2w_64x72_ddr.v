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


// Logical wrapper for 64x72 array (DDR)

// The encode logic and arrays are the same for sdr and ddr.  The ports are
//  mux'd between first and second half of cycle using el_sel.

`timescale 1 ns / 1 ns

`include "toysram.vh"

module  ra_4r2w_64x72_ddr (

    clk,
    reset,
    strobe,
    el_sel,
    rd_enb_0,
    rd_adr_0,
    rd_dat_0,
    rd_enb_1,
    rd_adr_1,
    rd_dat_1,
    rd_enb_2,
    rd_adr_2,
    rd_dat_2,
    rd_enb_3,
    rd_adr_3,
    rd_dat_3,
    wr_enb_0,
    wr_adr_0,
    wr_dat_0,
    wr_enb_1,
    wr_adr_1,
    wr_dat_1

);

 parameter GENMODE = `GENMODE;	        // 0=NoDelay, 1=Delay

   input          clk;
   input          reset;
   input          strobe;
   input          el_sel;

   input          rd_enb_0;
   input  [0:5]   rd_adr_0;
   output [0:71]  rd_dat_0;

   input          rd_enb_1;
   input  [0:5]   rd_adr_1;
   output [0:71]  rd_dat_1;

   input          rd_enb_2;
   input  [0:5]   rd_adr_2;
   output [0:71]  rd_dat_2;

   input          rd_enb_3;
   input  [0:5]   rd_adr_3;
   output [0:71]  rd_dat_3;

   input          wr_enb_0;
   input  [0:5]   wr_adr_0;
   input  [0:71]  wr_dat_0;

   input          wr_enb_1;
   input  [0:5]   wr_adr_1;
   input  [0:71]  wr_dat_1;

   reg            rd_enb_0_q;
   reg    [0:5]   rd_adr_0_q;
   reg    [0:71]  rd_dat_0_q;
   reg    [0:71]  rd_dat_0_hold_q;

   reg            rd_enb_1_q;
   reg    [0:5]   rd_adr_1_q;
   reg    [0:71]  rd_dat_1_q;
   reg    [0:71]  rd_dat_1_hold_q;

   reg            rd_enb_2_q;
   reg    [0:5]   rd_adr_2_q;
   reg    [0:71]  rd_dat_2_q;

   reg            rd_enb_3_q;
   reg    [0:5]   rd_adr_3_q;
   reg    [0:71]  rd_dat_3_q;

   reg            wr_enb_0_q;
   reg    [0:5]   wr_adr_0_q;
   reg    [0:71]  wr_dat_0_q;

   reg            wr_enb_1_q;
   reg    [0:5]   wr_adr_1_q;
   reg    [0:71]  wr_dat_1_q;

   // read 0
   wire           rd0_c_na0;
   wire           rd0_c_a0;
   wire           rd0_na1_na2;
   wire           rd0_na1_a2;
   wire           rd0_a1_na2;
   wire           rd0_a1_a2;
   wire           rd0_na3;
   wire           rd0_a3;
   wire           rd0_na4_na5;
   wire           rd0_na4_a5;
   wire           rd0_a4_na5;
   wire           rd0_a4_a5;
   wire   [0:71]  ra_rd_dat_0;

   // read 1
   wire           rd1_c_na0;
   wire           rd1_c_a0;
   wire           rd1_na1_na2;
   wire           rd1_na1_a2;
   wire           rd1_a1_na2;
   wire           rd1_a1_a2;
   wire           rd1_na3;
   wire           rd1_a3;
   wire           rd1_na4_na5;
   wire           rd1_na4_a5;
   wire           rd1_a4_na5;
   wire           rd1_a4_a5;
   wire   [0:71]  ra_rd_dat_1;

   // read 2
   wire           rd2_c_na0;
   wire           rd2_c_a0;
   wire           rd2_na1_na2;
   wire           rd2_na1_a2;
   wire           rd2_a1_na2;
   wire           rd2_a1_a2;
   wire           rd2_na3;
   wire           rd2_a3;
   wire           rd2_na4_na5;
   wire           rd2_na4_a5;
   wire           rd2_a4_na5;
   wire           rd2_a4_a5;
   wire   [0:71]  ra_rd_dat_2;

   // read 3
   wire           rd3_c_na0;
   wire           rd3_c_a0;
   wire           rd3_na1_na2;
   wire           rd3_na1_a2;
   wire           rd3_a1_na2;
   wire           rd3_a1_a2;
   wire           rd3_na3;
   wire           rd3_a3;
   wire           rd3_na4_na5;
   wire           rd3_na4_a5;
   wire           rd3_a4_na5;
   wire           rd3_a4_a5;
   wire   [0:71]  ra_rd_dat_3;

   // write 0
   wire           wr0_c_na0;
   wire           wr0_c_a0;
   wire           wr0_na1_na2;
   wire           wr0_na1_a2;
   wire           wr0_a1_na2;
   wire           wr0_a1_a2;
   wire           wr0_na3;
   wire           wr0_a3;
   wire           wr0_na4_na5;
   wire           wr0_na4_a5;
   wire           wr0_a4_na5;
   wire           wr0_a4_a5;
   wire           ra_wr_enb_0;
   wire   [0:5]   ra_wr_adr_0;

   // write 1
   wire           wr1_c_na0;
   wire           wr1_c_a0;
   wire           wr1_na1_na2;
   wire           wr1_na1_a2;
   wire           wr1_a1_na2;
   wire           wr1_a1_a2;
   wire           wr1_na3;
   wire           wr1_a3;
   wire           wr1_na4_na5;
   wire           wr1_na4_a5;
   wire           wr1_a4_na5;
   wire           wr1_a4_a5;
   wire           ra_wr_enb_1;
   wire   [0:5]   ra_wr_adr_1;

   wire           rd_enb_02;
   wire   [0:5]   rd_adr_02;
   wire           rd_enb_13;
   wire   [0:5]   rd_adr_13;
   wire           wr_enb_01;
   wire   [0:5]   wr_adr_01;
   wire   [0:71]  wr_dat_01;
   wire           strobe_int;

// latch inputs
// reset all; only enb required
   always @ (posedge clk) begin
      if (reset == 1'b1) begin
         rd_enb_0_q <= 0;
         rd_adr_0_q <= 0;
         rd_enb_1_q <= 0;
         rd_adr_1_q <= 0;
         rd_enb_2_q <= 0;
         rd_adr_2_q <= 0;
         rd_enb_3_q <= 0;
         rd_adr_3_q <= 0;
         wr_enb_0_q <= 0;
         wr_adr_0_q <= 0;
         wr_dat_0_q <= 0;
         wr_enb_1_q <= 0;
         wr_adr_1_q <= 0;
         wr_dat_1_q <= 0;
      end else begin
         rd_enb_0_q <= rd_enb_0;
         rd_adr_0_q <= rd_adr_0;
         rd_enb_1_q <= rd_enb_1;
         rd_adr_1_q <= rd_adr_1;
         rd_enb_2_q <= rd_enb_2;
         rd_adr_2_q <= rd_adr_2;
         rd_enb_3_q <= rd_enb_3;
         rd_adr_3_q <= rd_adr_3;
         wr_enb_0_q <= wr_enb_0;
         wr_adr_0_q <= wr_adr_0;
         wr_dat_0_q <= wr_dat_0;
         wr_enb_1_q <= wr_enb_1;
         wr_adr_1_q <= wr_adr_1;
         wr_dat_1_q <= wr_dat_1;
      end
  end

// latch read data
// early reads are double latched to hold during next cycle
   generate

   always @ (posedge strobe) begin
     	rd_dat_0_q <= (!el_sel) ? ra_rd_dat_0 : rd_dat_0_q;
     	rd_dat_1_q <= (!el_sel) ? ra_rd_dat_1 : rd_dat_1_q;
     	rd_dat_2_q <= (el_sel)  ? ra_rd_dat_0 : rd_dat_2_q;
      rd_dat_3_q <= (el_sel)  ? ra_rd_dat_1 : rd_dat_3_q;
   end
   always @ (posedge clk) begin
      rd_dat_0_hold_q <= rd_dat_0_q;
      rd_dat_1_hold_q <= rd_dat_1_q;
   end
   assign rd_dat_0 = rd_dat_0_hold_q;
   assign rd_dat_1 = rd_dat_1_hold_q;
   assign rd_dat_2 = rd_dat_2_q;
   assign rd_dat_3 = rd_dat_3_q;

   endgenerate

   assign rd_enb_02 = (el_sel) ? rd_enb_2_q : rd_enb_0_q;
   assign rd_adr_02 = (el_sel) ? rd_adr_2_q : rd_adr_0_q;
   assign rd_enb_13 = (el_sel) ? rd_enb_3_q : rd_enb_1_q;
   assign rd_adr_13 = (el_sel) ? rd_adr_3_q : rd_adr_1_q;
   assign wr_enb_01 = (el_sel) ? wr_enb_1_q : wr_enb_0_q;
   assign wr_adr_01 = (el_sel) ? wr_adr_1_q : wr_adr_0_q;
   assign wr_dat_01 = (el_sel) ? wr_dat_1_q : wr_dat_0_q;

   // don't use the clock as data in sim mode
   if (`GENMODE == 0)
      assign strobe_int = 1'b1;
   else
      assign strobe_int = strobe;

  // generate the controls for the array

  address_clock_sdr_2r1w_64

  #( .GENMODE(GENMODE)
  )

  add_clk

  (
      .strobe       (strobe_int),

      .rd_enb_0     (rd_enb_02),
      .rd_adr_0     (rd_adr_02),
      .rd_enb_1     (rd_enb_13),
      .rd_adr_1     (rd_adr_13),
      .wr_enb_0     (wr_enb_01),
      .wr_adr_0     (wr_adr_01),

      // read 0
      .rd0_c_na0   (rd0_c_na0),
      .rd0_c_a0    (rd0_c_a0),
      .rd0_na1_na2 (rd0_na1_na2),
      .rd0_na1_a2  (rd0_na1_a2),
      .rd0_a1_na2  (rd0_a1_na2),
      .rd0_a1_a2   (rd0_a1_a2),
      .rd0_na3     (rd0_na3),
      .rd0_a3      (rd0_a3),
      .rd0_na4_na5 (rd0_na4_na5),
      .rd0_na4_a5  (rd0_na4_a5),
      .rd0_a4_na5  (rd0_a4_na5),
      .rd0_a4_a5   (rd0_a4_a5),

      // read 1
      .rd1_c_na0   (rd1_c_na0),
      .rd1_c_a0    (rd1_c_a0),
      .rd1_na1_na2 (rd1_na1_na2),
      .rd1_na1_a2  (rd1_na1_a2),
      .rd1_a1_na2  (rd1_a1_na2),
      .rd1_a1_a2   (rd1_a1_a2),
      .rd1_na3     (rd1_na3),
      .rd1_a3      (rd1_a3),
      .rd1_na4_na5 (rd1_na4_na5),
      .rd1_na4_a5  (rd1_na4_a5),
      .rd1_a4_na5  (rd1_a4_na5),
      .rd1_a4_a5   (rd1_a4_a5),

      // write 0
      .wr0_c_na0   (wr0_c_na0),
      .wr0_c_a0    (wr0_c_a0),
      .wr0_na1_na2 (wr0_na1_na2),
      .wr0_na1_a2  (wr0_na1_a2),
      .wr0_a1_na2  (wr0_a1_na2),
      .wr0_a1_a2   (wr0_a1_a2),
      .wr0_na3     (wr0_na3),
      .wr0_a3      (wr0_a3),
      .wr0_na4_na5 (wr0_na4_na5),
      .wr0_na4_a5  (wr0_na4_a5),
      .wr0_a4_na5  (wr0_a4_na5),
      .wr0_a4_a5   (wr0_a4_a5)

  );

  // three hard arrays

  regfile_2r1w_64x24 array0(

      // predecoded address
      // read 0
      .rd0_c_na0   (rd0_c_na0),
      .rd0_c_a0    (rd0_c_a0),
      .rd0_na1_na2 (rd0_na1_na2),
      .rd0_na1_a2  (rd0_na1_a2),
      .rd0_a1_na2  (rd0_a1_na2),
      .rd0_a1_a2   (rd0_a1_a2),
      .rd0_na3     (rd0_na3),
      .rd0_a3      (rd0_a3),
      .rd0_na4_na5 (rd0_na4_na5),
      .rd0_na4_a5  (rd0_na4_a5),
      .rd0_a4_na5  (rd0_a4_na5),
      .rd0_a4_a5   (rd0_a4_a5),
      .rd0_dat     (ra_rd_dat_0[0:23]),

      // read 1
      .rd1_c_na0   (rd1_c_na0),
      .rd1_c_a0    (rd1_c_a0),
      .rd1_na1_na2 (rd1_na1_na2),
      .rd1_na1_a2  (rd1_na1_a2),
      .rd1_a1_na2  (rd1_a1_na2),
      .rd1_a1_a2   (rd1_a1_a2),
      .rd1_na3     (rd1_na3),
      .rd1_a3      (rd1_a3),
      .rd1_na4_na5 (rd1_na4_na5),
      .rd1_na4_a5  (rd1_na4_a5),
      .rd1_a4_na5  (rd1_a4_na5),
      .rd1_a4_a5   (rd1_a4_a5),
      .rd1_dat    (ra_rd_dat_1[0:23]),

      // write 0
      .wr0_c_na0   (wr0_c_na0),
      .wr0_c_a0    (wr0_c_a0),
      .wr0_na1_na2 (wr0_na1_na2),
      .wr0_na1_a2  (wr0_na1_a2),
      .wr0_a1_na2  (wr0_a1_na2),
      .wr0_a1_a2   (wr0_a1_a2),
      .wr0_na3     (wr0_na3),
      .wr0_a3      (wr0_a3),
      .wr0_na4_na5 (wr0_na4_na5),
      .wr0_na4_a5  (wr0_na4_a5),
      .wr0_a4_na5  (wr0_a4_na5),
      .wr0_a4_a5   (wr0_a4_a5),
      .wr0_dat     (wr_dat_01[0:23])

  );

  regfile_2r1w_64x24 array1(

      // predecoded address
      // read 0
      .rd0_c_na0   (rd0_c_na0),
      .rd0_c_a0    (rd0_c_a0),
      .rd0_na1_na2 (rd0_na1_na2),
      .rd0_na1_a2  (rd0_na1_a2),
      .rd0_a1_na2  (rd0_a1_na2),
      .rd0_a1_a2   (rd0_a1_a2),
      .rd0_na3     (rd0_na3),
      .rd0_a3      (rd0_a3),
      .rd0_na4_na5 (rd0_na4_na5),
      .rd0_na4_a5  (rd0_na4_a5),
      .rd0_a4_na5  (rd0_a4_na5),
      .rd0_a4_a5   (rd0_a4_a5),
      .rd0_dat     (ra_rd_dat_0[24:47]),

      // read 1
      .rd1_c_na0   (rd1_c_na0),
      .rd1_c_a0    (rd1_c_a0),
      .rd1_na1_na2 (rd1_na1_na2),
      .rd1_na1_a2  (rd1_na1_a2),
      .rd1_a1_na2  (rd1_a1_na2),
      .rd1_a1_a2   (rd1_a1_a2),
      .rd1_na3     (rd1_na3),
      .rd1_a3      (rd1_a3),
      .rd1_na4_na5 (rd1_na4_na5),
      .rd1_na4_a5  (rd1_na4_a5),
      .rd1_a4_na5  (rd1_a4_na5),
      .rd1_a4_a5   (rd1_a4_a5),
      .rd1_dat     (ra_rd_dat_1[24:47]),

      // write 0
      .wr0_c_na0   (wr0_c_na0),
      .wr0_c_a0    (wr0_c_a0),
      .wr0_na1_na2 (wr0_na1_na2),
      .wr0_na1_a2  (wr0_na1_a2),
      .wr0_a1_na2  (wr0_a1_na2),
      .wr0_a1_a2   (wr0_a1_a2),
      .wr0_na3     (wr0_na3),
      .wr0_a3      (wr0_a3),
      .wr0_na4_na5 (wr0_na4_na5),
      .wr0_na4_a5  (wr0_na4_a5),
      .wr0_a4_na5  (wr0_a4_na5),
      .wr0_a4_a5   (wr0_a4_a5),
      .wr0_dat     (wr_dat_01[24:47])

  );

  regfile_2r1w_64x24 array2(

      // predecoded address
      // read 0
      .rd0_c_na0   (rd0_c_na0),
      .rd0_c_a0    (rd0_c_a0),
      .rd0_na1_na2 (rd0_na1_na2),
      .rd0_na1_a2  (rd0_na1_a2),
      .rd0_a1_na2  (rd0_a1_na2),
      .rd0_a1_a2   (rd0_a1_a2),
      .rd0_na3     (rd0_na3),
      .rd0_a3      (rd0_a3),
      .rd0_na4_na5 (rd0_na4_na5),
      .rd0_na4_a5  (rd0_na4_a5),
      .rd0_a4_na5  (rd0_a4_na5),
      .rd0_a4_a5   (rd0_a4_a5),
      .rd0_dat     (ra_rd_dat_0[48:71]),

      // read 1
      .rd1_c_na0   (rd1_c_na0),
      .rd1_c_a0    (rd1_c_a0),
      .rd1_na1_na2 (rd1_na1_na2),
      .rd1_na1_a2  (rd1_na1_a2),
      .rd1_a1_na2  (rd1_a1_na2),
      .rd1_a1_a2   (rd1_a1_a2),
      .rd1_na3     (rd1_na3),
      .rd1_a3      (rd1_a3),
      .rd1_na4_na5 (rd1_na4_na5),
      .rd1_na4_a5  (rd1_na4_a5),
      .rd1_a4_na5  (rd1_a4_na5),
      .rd1_a4_a5   (rd1_a4_a5),
      .rd1_dat     (ra_rd_dat_1[48:71]),

      // write 0
      .wr0_c_na0   (wr0_c_na0),
      .wr0_c_a0    (wr0_c_a0),
      .wr0_na1_na2 (wr0_na1_na2),
      .wr0_na1_a2  (wr0_na1_a2),
      .wr0_a1_na2  (wr0_a1_na2),
      .wr0_a1_a2   (wr0_a1_a2),
      .wr0_na3     (wr0_na3),
      .wr0_a3      (wr0_a3),
      .wr0_na4_na5 (wr0_na4_na5),
      .wr0_na4_a5  (wr0_na4_a5),
      .wr0_a4_na5  (wr0_a4_na5),
      .wr0_a4_a5   (wr0_a4_a5),
      .wr0_dat     (wr_dat_01[48:71])

  );

endmodule

