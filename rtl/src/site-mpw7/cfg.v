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

`timescale 1 ns / 1 ns

`include "../toysram.vh"

// configuration macro
// Manages config registers and routes cmd valids to CFG, CTRL, RAx.

module cfg (
`ifdef USE_POWER_PINS
   inout vccd1,	// User area 1 1.8V supply
   inout vssd1,	// User area 1 digital ground
`endif

   input          clk,
   input          rst,
   input          wb_cmd_val,
   input  [31:0]  wb_cmd_adr,
   input          wb_cmd_we,
   input  [3:0]   wb_cmd_sel,
   input  [31:0]  wb_cmd_dat,
   output         wb_rd_ack,
   output [31:0]  wb_rd_dat,

   output [31:0]  cmd_adr,
   output         cmd_we,
   output [3:0]   cmd_sel,
   output [31:0]  cmd_dat,

   output         ctl_cmd_val,
   output         ra0_cmd_val,
   input          ctl_rd_ack,
   input  [31:0]  ctl_rd_dat

);

   reg            ack_q;
   wire           ack_d;

   // FF
   always @(posedge clk) begin
      if (rst) begin
         ack_q <= 1'b0;
      end else begin
         ack_q <= ack_d;
      end
   end

   // Common
   assign cmd_adr = wb_cmd_adr;
   assign cmd_we = wb_cmd_we;
   assign cmd_sel = wb_cmd_sel;
   assign cmd_dat = wb_cmd_dat;

   // Macro Routing
   // account for ack pipeline back to wb
   assign ack_d = ctl_rd_ack;

   assign ctl_cmd_val = wb_cmd_val & ~ack_q & ((wb_cmd_adr & `UNIT_MASK) == `CTL_ADDR);
   assign ra0_cmd_val = wb_cmd_val & ~ack_q & ((wb_cmd_adr & `UNIT_MASK) == `RA0_ADDR);

   assign wb_rd_ack = ctl_rd_ack;
   assign wb_rd_dat = ctl_rd_dat;

endmodule
