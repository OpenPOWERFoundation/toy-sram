// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

`include "toysram.vh"

/*
 * toysram_site
 * user_project for custom toysram cell/array


 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module toysram_site #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
   inout          vccd1,	// User area 1 1.8V supply
   inout          vssd1,	// User area 1 digital ground
`endif

   // Wishbone Slave ports (WB MI A)
   input          wb_clk_i,
   input          wb_rst_i,
   input          wbs_stb_i,
   input          wbs_cyc_i,
   input          wbs_we_i,
   input [3:0]    wbs_sel_i,
   input [31:0]   wbs_dat_i,
   input [31:0]   wbs_adr_i,
   output         wbs_ack_o,
   output [31:0]  wbs_dat_o,

   // Logic Analyzer Signals
`ifndef RA_SIM
   input  [127:0] la_data_in,
   output [127:0] la_data_out,
   input  [127:0] la_oenb,
`endif

   // IOs
   input  [`MPRJ_IO_PADS-1:0] io_in,
   output [`MPRJ_IO_PADS-1:0] io_out,
   output [`MPRJ_IO_PADS-1:0] io_oeb,

   // IRQ
   output [2:0] irq
);

   wire           clk;
   wire           rst;

   wire   [31:0]  rdata;
   wire   [31:0]  wdata;
   wire   [31:0]  count;

   wire           valid;
   wire   [3:0]   wstrb;
   wire   [31:0]  la_write;

   wire           wb_cmd_val;
   wire   [31:0]  wb_cmd_adr;
   wire           wb_cmd_we;
   wire   [3:0]   wb_cmd_sel;
   wire   [31:0]  wb_cmd_dat;
   wire           wb_rd_ack;
   wire   [31:0]  wb_rd_dat;
   wire   [31:0]  cmd_adr;
   wire           cmd_we;
   wire   [3:0]   cmd_sel;
   wire   [31:0]  cmd_dat;
   wire           ctl_cmd_val;
   wire           ra0_cmd_val;
   wire           ctl_rd_ack;
   wire   [31:0]  ctl_rd_dat;
   wire           ra0_clk;
   wire           ra0_rst;
   wire           ra0_cfg_wr;
   wire   [31:0]  ra0_cfg_rdat;
   wire   [31:0]  ra0_cfg_wdat;
   wire   [31:0]  ra0_bist_ctl;
   wire   [31:0]  ra0_bist_status;
   wire           ra0_r0_enb;
   wire   [4:0]   ra0_r0_adr;
   wire   [31:0]  ra0_r0_dat;
   wire           ra0_r1_enb;
   wire   [4:0]   ra0_r1_adr;
   wire   [31:0]  ra0_r1_dat;
   wire           ra0_w0_enb;
   wire   [4:0]   ra0_w0_adr;
   wire   [31:0]  ra0_w0_dat;

   // WB MI A
   assign valid = wbs_cyc_i && wbs_stb_i;
   assign wstrb = wbs_sel_i & {4{wbs_we_i}};
   assign wbs_dat_o = rdata;
   assign wdata = wbs_dat_i;

   // IRQ
   assign irq = 3'b000;	// Unused


   //wtf connect these to the array sigs?
   // LA
   //assign la_data_out = {{(127-BITS){1'b0}}, count};
   assign la_data_out = 0;
   // Assuming LA probes [63:32] are for controlling the count register
   //assign la_write = ~la_oenb[63:32] & ~{BITS{valid}};
   assign la_write = 0;

   // Assuming LA probes [65:64] are for controlling the count clk & reset
   //assign clk = (~la_oenb[64]) ? la_data_in[64]: wb_clk_i;
   //assign rst = (~la_oenb[65]) ? la_data_in[65]: wb_rst_i;
   assign clk = wb_clk_i;
   assign rst = wb_rst_i;

   // WB slave
   // convert rd/wr commands to/from WB and route to:
   // 1. config space
   // 2. array space
   wb_slave #(
   ) wb (

`ifdef USE_POWER_PINS
      .vccd1(vccd1),
      .vssd1(vssd1),
`endif
      .clk(clk),
      .rst(rst),
      .wbs_stb_i(wbs_stb_i),
      .wbs_cyc_i(wbs_cyc_i),
      .wbs_we_i(wbs_we_i),
      .wbs_sel_i(wbs_sel_i),
      .wbs_dat_i(wbs_dat_i),
      .wbs_adr_i(wbs_adr_i),
      .wbs_ack_o(wbs_ack_o),
      .wbs_dat_o(wbs_dat_o),
      .cmd_val(wb_cmd_val),
      .cmd_adr(wb_cmd_adr),
      .cmd_we(wb_cmd_we),
      .cmd_sel(wb_cmd_sel),
      .cmd_dat(wb_cmd_dat),
      .rd_ack(wb_rd_ack),
      .rd_dat(wb_rd_dat)
   );

   cfg #(
   ) cfg (

`ifdef USE_POWER_PINS
      .vccd1(vccd1),
      .vssd1(vssd1),
`endif
      .clk(clk),
      .rst(rst),
      .wb_cmd_val(wb_cmd_val),
      .wb_cmd_adr(wb_cmd_adr),
      .wb_cmd_we(wb_cmd_we),
      .wb_cmd_sel(wb_cmd_sel),
      .wb_cmd_dat(wb_cmd_dat),
      .wb_rd_ack(wb_rd_ack),
      .wb_rd_dat(wb_rd_dat),
      .cmd_adr(cmd_adr),
      .cmd_we(cmd_we),
      .cmd_sel(cmd_sel),
      .cmd_dat(cmd_dat),
      .ctl_cmd_val(ctl_cmd_val),
      .ra0_cmd_val(ra0_cmd_val),
      .ctl_rd_ack(ctl_rd_ack),
      .ctl_rd_dat(ctl_rd_dat)
   );

/*
   // I/O interface
   io_intf io (

`ifdef USE_POWER_PINS
      .vccd1(vccd1),
      .vssd1(vssd1),
`endif
      .clk(clk),
      .rst(rst)

   );
*/

   // array and i/o interfaces
   control #(
   ) ctl (
`ifdef USE_POWER_PINS
      .vccd1(vccd1),
      .vssd1(vssd1),
`endif
      .clk(clk),
      .rst(rst),
      .io_in(io_in),
      .io_out(io_out),
      .io_oeb(io_oeb),
      .ctl_cmd_val(ctl_cmd_val),
      .ra0_cmd_val(ra0_cmd_val),
      .cmd_we(cmd_we),
      .cmd_adr(cmd_adr),
      .cmd_sel(cmd_sel),
      .cmd_dat(cmd_dat),
      .rd_ack(ctl_rd_ack),
      .rd_dat(ctl_rd_dat),
      .ra0_clk(ra0_clk),
      .ra0_rst(ra0_rst),
      .ra0_cfg_wr(ra0_cfg_wr),
      .ra0_cfg_rdat(), //'hFFFFFFFF'),                   //wtf need to add to ra for read
      .ra0_cfg_wdat(ra0_cfg_wdat),
      .ra0_bist_ctl(ra0_bist_ctl),
      .ra0_bist_status(ra0_bist_status),
      .ra0_r0_enb(ra0_r0_enb),
      .ra0_r0_adr(ra0_r0_adr),
      .ra0_r0_dat(ra0_r0_dat),
      .ra0_r1_enb(ra0_r1_enb),
      .ra0_r1_adr(ra0_r1_adr),
      .ra0_r1_dat(ra0_r1_dat),
      .ra0_w0_enb(ra0_w0_enb),
      .ra0_w0_adr(ra0_w0_adr),
      .ra0_w0_dat(ra0_w0_dat)
   );

   // arrays
   test_ra_sdr_32x32 #(
      .RA_SELECT(`RA_SELECT)
   ) ra_0 (
`ifdef USE_POWER_PINS
      .vccd1(vccd1),
      .vssd1(vssd1),
`endif
      .clk(ra0_clk),
      .reset(ra0_rst),
      .cfg_wr(ra0_cfg_wr),
      .cfg_dat(ra0_cfg_wdat),
      .bist_ctl(ra0_bist_ctl),
      .bist_status(ra0_bist_status),
      .rd_enb_0(ra0_r0_enb),
      .rd_adr_0(ra0_r0_adr),
      .rd_dat_0(ra0_r0_dat),
      .rd_enb_1(ra0_r1_enb),
      .rd_adr_1(ra0_r1_adr),
      .rd_dat_1(ra0_r1_dat),
      .wr_enb_0(ra0_w0_enb),
      .wr_adr_0(ra0_w0_adr),
      .wr_dat_0(ra0_w0_dat)
   );

endmodule

`default_nettype wire
