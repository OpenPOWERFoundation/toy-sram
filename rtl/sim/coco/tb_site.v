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


// Test array (SDR) wrapper for cocotb/icarus
// 32 word 32 bit array
// LCB for strobe generation
// Config, BIST, etc.

`timescale 1 ns / 1 ns

`include "defines.v"
`include "toysram.vh"

module  tb_site (

`ifdef USE_POWER_PINS
   inout vccd1,	// User area 1 1.8V supply
   inout vssd1,	// User area 1 digital ground
`endif

   // Wishbone Slave ports (WB MI A)
   input          wb_clk_i,
   input          wb_rst_i,
   input          wbs_stb_i,
   input          wbs_cyc_i,
   input          wbs_we_i,
   input  [3:0]   wbs_sel_i,
   input  [31:0]  wbs_dat_i,
   input  [31:0]  wbs_adr_i,
   output         wbs_ack_o,
   output [31:0]  wbs_dat_o,

   // Logic Analyzer Signals
   input  [127:0] la_data_in,
   output [127:0] la_data_out,
   input  [127:0] la_oenb,

   // IOs
   input  [`MPRJ_IO_PADS-1:0] io_in,
   output [`MPRJ_IO_PADS-1:0] io_out,
   output [`MPRJ_IO_PADS-1:0] io_oeb,

   // IRQ
   output [2:0] irq

);

   initial begin
      $dumpfile ("test_site.vcd");
      $dumpvars;
      #1;
   end

   toysram_site site (

`ifdef USE_POWER_PINS
      .vccd1(vccd1),
      .vssd1(vssd1),
`endif
      .wb_clk_i(wb_clk_i),
      .wb_rst_i(wb_rst_i),
      .wbs_stb_i(wbs_stb_i),
      .wbs_cyc_i(wbs_cyc_i),
      .wbs_we_i(wbs_we_i),
      .wbs_sel_i(wbs_sel_i),
      .wbs_dat_i(wbs_dat_i),
      .wbs_adr_i(wbs_adr_i),
      .wbs_ack_o(wbs_ack_o),
      .wbs_dat_o(wbs_dat_o),

   // Logic Analyzer Signals
   .la_data_in(la_data_in),
   .la_data_out(la_data_out),
   .la_oenb(la_oenb),


   // IOs
   .io_in(io_in),
   .io_out(io_out),
   .io_oeb(io_oeb),

   // IRQ
   .irq(irq)

   );


endmodule

