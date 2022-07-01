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
// Manages config registers and routes cmd val

module cfg #(
   parameter CFG0_INIT = 'h00000000,
   parameter ADDR_MASK = 'hFFFF0000,
   parameter CFG_ADDR =  'h00000000,
   parameter CTL_ADDR =  'h00010000,
   parameter RA0_ADDR =  'h00100000
)(
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
   output         cfg_cmd_val,
   output         ra0_cmd_val,
   input          ctl_rd_ack,
   input  [31:0]  ctl_rd_dat

);

   reg    [7:0]   seq_q;
   wire   [7:0]   seq_d;

   reg    [31:0]  cfg0_q;
   wire   [31:0]  cfg0_d;

   // FF
   always @(posedge clk) begin
      if (rst) begin
         seq_q <= 'hFF;
         cfg0_q <= CFG0_INIT;
      end else begin
         seq_q <= seq_d;
         cfg0_q <= cfg0_d;
      end
   end

   // Common
   assign cmd_adr = wb_cmd_adr;
   assign cmd_we = wb_cmd_we;
   assign cmd_sel = wb_cmd_sel;
   assign cmd_dat = wb_cmd_dat;

   // Macro Routing
   assign cfg_cmd_val = wb_cmd_val & ((wb_cmd_adr & ADDR_MASK) == (CFG_ADDR & ADDR_MASK));
   assign cfg0_d = cfg_cmd_val & cmd_we ? cmd_dat : cfg0_q;


   assign ctl_cmd_val = wb_cmd_val & ((wb_cmd_adr & ADDR_MASK) == (CTL_ADDR & ADDR_MASK));
   assign ra0_cmd_val = wb_cmd_val & ((wb_cmd_adr & ADDR_MASK) == (RA0_ADDR & ADDR_MASK));

   assign wb_rd_ack = ctl_rd_ack;
   assign wb_rd_dat = ctl_rd_dat;

endmodule
