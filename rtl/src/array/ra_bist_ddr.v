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


// Local BIST for arrays
// Pass array inputs through, or generate locally for test/manual access.
// May want status_valid, ctl_valid sigs.
// Want separate cmds for enter/exit functional?
// ctl:
//    00000000 - functional mode
//    800000aa - read adr aa
//    900000aa - write adr aa (next 3 cycs are data)
//    F00000tt - run bist test tt
//
// status:
//
//

`timescale 1 ns / 1 ns

`include "toysram.vh"

module ra_bist_ddr (

    clk,
    reset,
    ctl,
    status,
    rd0_enb_in,
    rd0_adr_in,
    rd1_enb_in,
    rd1_adr_in,
    rd2_enb_in,
    rd2_adr_in,
    rd3_enb_in,
    rd3_adr_in,
    wr0_enb_in,
    wr0_adr_in,
    wr0_dat_in,
    wr1_enb_in,
    wr1_adr_in,
    wr1_dat_in,
    rd0_enb_out,
    rd0_adr_out,
    rd0_dat,
    rd1_enb_out,
    rd1_adr_out,
    rd1_dat,
    rd2_enb_out,
    rd2_adr_out,
    rd2_dat,
    rd3_enb_out,
    rd3_adr_out,
    rd3_dat,
    wr0_enb_out,
    wr0_adr_out,
    wr0_dat_out,
    wr1_enb_out,
    wr1_adr_out,
    wr1_dat_out

);

 parameter GENMODE = `GENMODE;	        // 0=NoDelay, 1=Delay

   input          clk;
   input          reset;
   input  [0:31]  ctl;

   input          rd0_enb_in;
   input  [0:5]   rd0_adr_in;
   input          rd1_enb_in;
   input  [0:5]   rd1_adr_in;
   input          rd2_enb_in;
   input  [0:5]   rd2_adr_in;
   input          rd3_enb_in;
   input  [0:5]   rd3_adr_in;
   input          wr0_enb_in;
   input  [0:5]   wr0_adr_in;
   input  [0:71]  wr0_dat_in;
   input          wr1_enb_in;
   input  [0:5]   wr1_adr_in;
   input  [0:71]  wr1_dat_in;

   output [0:31]  status;
   output         rd0_enb_out;
   output [0:5]   rd0_adr_out;
   input  [0:71]  rd0_dat;
   output         rd1_enb_out;
   output [0:5]   rd1_adr_out;
   input  [0:71]  rd1_dat;
   output         rd2_enb_out;
   output [0:5]   rd2_adr_out;
   input  [0:71]  rd2_dat;
   output         rd3_enb_out;
   output [0:5]   rd3_adr_out;
   input  [0:71]  rd3_dat;
   output         wr0_enb_out;
   output [0:5]   wr0_adr_out;
   output [0:71]  wr0_dat_out;
   output         wr1_enb_out;
   output [0:5]   wr1_adr_out;
   output [0:71]  wr1_dat_out;

   reg    [0:5]   seq_q;
   wire   [0:5]   seq_d;
   wire           active;
   wire           bist_rd0_enb;
   wire   [0:5]   bist_rd0_adr;
   wire           bist_rd1_enb;
   wire   [0:5]   bist_rd1_adr;
   wire           bist_rd2_enb;
   wire   [0:5]   bist_rd2_adr;
   wire           bist_rd3_enb;
   wire   [0:5]   bist_rd3_adr;
   wire           bist_wr0_enb;
   wire   [0:5]   bist_wr0_adr;
   wire   [0:71]  bist_wr0_dat;
   wire           bist_wr1_enb;
   wire   [0:5]   bist_wr1_adr;
   wire   [0:71]  bist_wr1_dat;

   // ff
   always @ (posedge clk) begin
      if (reset)
         seq_q <= 6'h3F;
      else
         seq_q <= seq_d;
   end

   // do something
   assign seq_d = seq_q;
   assign active = seq_q != 6'h3F;
   assign status = 0;

   // outputs
   assign rd0_enb_out = (active) ? bist_rd0_enb : rd0_enb_in;
   assign rd0_adr_out = (active) ? bist_rd0_adr : rd0_adr_in;
   assign rd1_enb_out = (active) ? bist_rd1_enb : rd1_enb_in;
   assign rd1_adr_out = (active) ? bist_rd1_adr : rd1_adr_in;
   assign rd2_enb_out = (active) ? bist_rd2_enb : rd2_enb_in;
   assign rd2_adr_out = (active) ? bist_rd2_adr : rd2_adr_in;
   assign rd3_enb_out = (active) ? bist_rd3_enb : rd3_enb_in;
   assign rd3_adr_out = (active) ? bist_rd3_adr : rd3_adr_in;
   assign wr0_enb_out = (active) ? bist_wr0_enb : wr0_enb_in;
   assign wr0_adr_out = (active) ? bist_wr0_adr : wr0_adr_in;
   assign wr0_dat_out = (active) ? bist_wr0_dat : wr0_dat_in;
   assign wr1_enb_out = (active) ? bist_wr1_enb : wr1_enb_in;
   assign wr1_adr_out = (active) ? bist_wr1_adr : wr1_adr_in;
   assign wr1_dat_out = (active) ? bist_wr1_dat : wr1_dat_in;

endmodule

