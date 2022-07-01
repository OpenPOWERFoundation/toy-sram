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

module ra_bist_sdr (

    clk,
    reset,
    ctl,
    status,
    rd0_enb_in,
    rd0_adr_in,
    rd1_enb_in,
    rd1_adr_in,
    wr0_enb_in,
    wr0_adr_in,
    wr0_dat_in,
    rd0_enb_out,
    rd0_adr_out,
    rd0_dat,
    rd1_enb_out,
    rd1_adr_out,
    rd1_dat,
    wr0_enb_out,
    wr0_adr_out,
    wr0_dat_out

);

 parameter GENMODE = `GENMODE;	        // 0=NoDelay, 1=Delay

   input          clk;
   input          reset;
   input  [31:0]  ctl;

   input          rd0_enb_in;
   input  [5:0]   rd0_adr_in;
   input          rd1_enb_in;
   input  [5:0]   rd1_adr_in;
   input          wr0_enb_in;
   input  [5:0]   wr0_adr_in;
   input  [71:0]  wr0_dat_in;

   output [31:0]  status;
   output         rd0_enb_out;
   output [5:0]   rd0_adr_out;
   input  [71:0]  rd0_dat;
   output         rd1_enb_out;
   output [5:0]   rd1_adr_out;
   input  [71:0]  rd1_dat;
   output         wr0_enb_out;
   output [5:0]   wr0_adr_out;
   output [71:0]  wr0_dat_out;

   reg    [5:0]   seq_q;
   wire   [5:0]   seq_d;
   wire           active;
   wire           bist_rd0_enb;
   wire   [5:0]   bist_rd0_adr;
   wire           bist_rd1_enb;
   wire   [5:0]   bist_rd1_adr;
   wire           bist_wr0_enb;
   wire   [5:0]   bist_wr0_adr;
   wire   [71:0]  bist_wr0_dat;

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
   assign wr0_enb_out = (active) ? bist_wr0_enb : wr0_enb_in;
   assign wr0_adr_out = (active) ? bist_wr0_adr : wr0_adr_in;
   assign wr0_dat_out = (active) ? bist_wr0_dat : wr0_dat_in;
   //assign rd0_dat = (active) ? haven't done anything here yet

endmodule
