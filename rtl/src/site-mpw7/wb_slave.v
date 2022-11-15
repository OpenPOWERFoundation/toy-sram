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

// Wishbone slave macro
// Bridges internal read/write commands to/from Wishbone.
// Only accepts requests matching BASE_ADDR, BASE_MASK; address passed
//  on as command does not include upper 4 bits.

module wb_slave #(
   parameter BASE_ADDR = 'h30000000,
   parameter BASE_MASK = 'hF0000000
) (
`ifdef USE_POWER_PINS
   inout                vccd1,
   inout                vssd1,
`endif
   input                clk,
   input                rst,
   input                wbs_stb_i,
   input                wbs_cyc_i,
   input                wbs_we_i,
   input  [3:0]         wbs_sel_i,
   input  [31:0]        wbs_dat_i,
   input  [31:0]        wbs_adr_i,
   output               wbs_ack_o,
   output [31:0]        wbs_dat_o,
   output               cmd_val,
   output [31:0]        cmd_adr,
   output               cmd_we,
   output [3:0]         cmd_sel,
   output [31:0]        cmd_dat,
   input                rd_ack,
   input  [31:0]        rd_dat

);

   reg                  cmd_val_q;
   wire                 cmd_val_d;
   reg    [31:0]        cmd_adr_q;
   wire   [31:0]        cmd_adr_d;
   reg                  cmd_we_q;
   wire                 cmd_we_d;
   reg    [3:0]         cmd_sel_q;
   wire   [3:0]         cmd_sel_d;
   reg    [31:0]        cmd_dat_q;
   wire   [31:0]        cmd_dat_d;
   reg                  rd_ack_q;
   wire                 rd_ack_d;
   reg    [31:0]        rd_dat_q;
   wire   [31:0]        rd_dat_d;

   wire                 stall;
   wire                 base_match;
   wire                 ack;

   // FF
   always @(posedge clk) begin
      if (rst) begin
         cmd_val_q <= 1'b0;
         cmd_adr_q <= 31'h0;
         cmd_we_q <= 1'b0;
         cmd_sel_q <= 4'b0;
         cmd_dat_q <= 32'h0;
         rd_ack_q <= 1'b0;
         rd_dat_q <= 32'h0;
      end else begin
         cmd_val_q <= cmd_val_d;
         cmd_adr_q <= cmd_adr_d;
         cmd_we_q <= cmd_we_d;
         cmd_sel_q <= cmd_sel_d;
         cmd_dat_q <= cmd_dat_d;
         rd_ack_q <= rd_ack_d;
         rd_dat_q <= rd_dat_d;
      end
   end

   // WB

   assign stall = 'b0;
   assign base_match = wbs_cyc_i & ((wbs_adr_i & BASE_MASK) == BASE_ADDR);

   //assign cmd_val_d = (base_match & wbs_stb_i & ~stall) |
   //                   (cmd_val_q & ~ack);
   // equiv for wb
   assign cmd_val_d = base_match & wbs_stb_i & ~stall & ~ack;
   assign cmd_adr_d = {4'b0, wbs_adr_i[27:0]};
   assign cmd_we_d = wbs_we_i;
   assign cmd_sel_d = wbs_sel_i;
   assign cmd_dat_d = wbs_dat_i;
   assign ack = rd_ack_q | (cmd_val_q & cmd_we_q);  // block with reset?
   assign wbs_ack_o = ack;
   assign wbs_dat_o = rd_dat_q;

   // Outputs

   assign cmd_val = cmd_val_q;
   assign cmd_adr = cmd_adr_q;
   assign cmd_we = cmd_we_q;
   assign cmd_sel = cmd_sel_q;
   assign cmd_dat = cmd_dat_q;

   // Inputs
   assign rd_ack_d = rd_ack;
   assign rd_dat_d = rd_dat;

endmodule