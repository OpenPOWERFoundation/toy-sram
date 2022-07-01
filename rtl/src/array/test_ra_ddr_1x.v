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


// Test array (DDR1x (sim only) - acts like DDR but only uses single clock
// 64 word 72 bit array
// LCB for strobe generation
// Config, BIST, etc.

`timescale 1 ns / 1 ns

`include "toysram.vh"

module  test_ra_ddr_1x (

    clk,
    reset,
    cfg_wr,
    cfg_dat,
    bist_ctl,
    bist_status,

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

   input          clk;
   input          reset;
   input          cfg_wr;
   input  [0:`LCBDDR_CONFIGWIDTH-1] cfg_dat;
   input  [0:31]  bist_ctl;
   output [0:31]  bist_status;
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

   wire           strobe;
   wire           el_sel;
   wire   [0:`LCBDDR_CONFIGWIDTH-1] cfg;
   wire           mux_rd0_enb;
   wire   [0:5]   mux_rd0_adr;
   wire           mux_rd1_enb;
   wire   [0:5]   mux_rd1_adr;
   wire           mux_rd2_enb;
   wire   [0:5]   mux_rd2_adr;
   wire           mux_rd3_enb;
   wire   [0:5]   mux_rd3_adr;
   wire           mux_wr0_enb;
   wire   [0:5]   mux_wr0_adr;
   wire   [0:71]  mux_wr0_dat;
   wire           mux_wr1_enb;
   wire   [0:5]   mux_wr1_adr;
   wire   [0:71]  mux_wr1_dat;


    ra_lcb_ddr lcb (

        .clk      (clk),
        .reset    (reset),
        .cfg      (cfg),
        .strobe   (strobe),  // not used
        .el_sel   (el_sel)

    );

    ra_cfg_ddr #(.INIT(-1)) cfig (

        .clk      (clk),
        .reset    (reset),
        .cfg_wr   (cfg_wr),
        .cfg_dat  (cfg_dat),
        .cfg      (cfg)

    );

    ra_bist_ddr bist (

        .clk         (clk),
        .reset       (reset),
        .ctl         (bist_ctl),
        .status      (bist_status),
        .rd0_enb_in  (rd_enb_0),
        .rd0_adr_in  (rd_adr_0),
        .rd0_dat     (rd_dat_0),
        .rd1_enb_in  (rd_enb_1),
        .rd1_adr_in  (rd_adr_1),
        .rd1_dat     (rd_dat_1),
        .rd2_enb_in  (rd_enb_2),
        .rd2_adr_in  (rd_adr_2),
        .rd2_dat     (rd_dat_2),
        .rd3_enb_in  (rd_enb_3),
        .rd3_adr_in  (rd_adr_3),
        .rd3_dat     (rd_dat_3),
        .wr0_enb_in  (wr_enb_0),
        .wr0_adr_in  (wr_adr_0),
        .wr0_dat_in  (wr_dat_0),
        .wr1_enb_in  (wr_enb_1),
        .wr1_adr_in  (wr_adr_1),
        .wr1_dat_in  (wr_dat_1),
        .rd0_enb_out (mux_rd0_enb),
        .rd0_adr_out (mux_rd0_adr),
        .rd1_enb_out (mux_rd1_enb),
        .rd1_adr_out (mux_rd1_adr),
        .rd2_enb_out (mux_rd2_enb),
        .rd2_adr_out (mux_rd2_adr),
        .rd3_enb_out (mux_rd3_enb),
        .rd3_adr_out (mux_rd3_adr),
        .wr0_enb_out (mux_wr0_enb),
        .wr0_adr_out (mux_wr0_adr),
        .wr0_dat_out (mux_wr0_dat),
        .wr1_enb_out (mux_wr1_enb),
        .wr1_adr_out (mux_wr1_adr),
        .wr1_dat_out (mux_wr1_dat)

    );

    ra_4r2w_64x72_ddr_1x ra (

        .clk        (clk),
        .reset      (reset),
        .strobe     (1'b1),
        .rd_enb_0   (mux_rd0_enb),
        .rd_adr_0   (mux_rd0_adr),
        .rd_dat_0   (rd_dat_0),
        .rd_enb_1   (mux_rd1_enb),
        .rd_adr_1   (mux_rd1_adr),
        .rd_dat_1   (rd_dat_1),
        .rd_enb_2   (mux_rd2_enb),
        .rd_adr_2   (mux_rd2_adr),
        .rd_dat_2   (rd_dat_2),
        .rd_enb_3   (mux_rd3_enb),
        .rd_adr_3   (mux_rd3_adr),
        .rd_dat_3   (rd_dat_3),
        .wr_enb_0   (mux_wr0_enb),
        .wr_adr_0   (mux_wr0_adr),
        .wr_dat_0   (mux_wr0_dat),
        .wr_enb_1   (mux_wr1_enb),
        .wr_adr_1   (mux_wr1_adr),
        .wr_dat_1   (mux_wr1_dat)

    );

endmodule
