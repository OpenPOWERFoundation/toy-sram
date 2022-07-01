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

`include "defines.v"
`include "../toysram.vh"

// control macro
// does stuff

module control #(
   parameter ADDR_MASK = 'h0000F000,
   parameter CFG_ADDR =  'h0000E000,      // offset within RAx_ADDR
   parameter BIST_ADDR = 'h0000F000,      // offset within RAx_ADDR
   parameter CFG0_ADDR = 'h00000000,
   parameter CFG0_INIT = 'h00000001
)(
   `ifdef USE_POWER_PINS
    inout vccd1,
    inout vssd1
`endif

   input          clk,
   input          rst,

   input  [`MPRJ_IO_PADS-1:0] io_in,
   output [`MPRJ_IO_PADS-1:0] io_out,
   output [`MPRJ_IO_PADS-1:0] io_oeb,

   input          ctl_cmd_val,
   input          ra0_cmd_val,
   input  [31:0]  cmd_adr,
   input          cmd_we,
   input  [3:0]   cmd_sel,
   input  [31:0]  cmd_dat,
   output         rd_ack,
   output [31:0]  rd_dat,

   output         ra0_clk,
   output         ra0_rst,
   output         ra0_cfg_wr,
   input  [31:0]  ra0_cfg_rdat,
   output [31:0]  ra0_cfg_wdat,
   output [31:0]  ra0_bist_ctl,
   input  [31:0]  ra0_bist_status,
   output         ra0_r0_enb,
   output [4:0]   ra0_r0_adr,
   input  [31:0]  ra0_r0_dat,
   output         ra0_r1_enb,
   output [4:0]   ra0_r1_adr,
   input  [31:0]  ra0_r1_dat,
   output         ra0_w0_enb,
   output [4:0]   ra0_w0_adr,
   output [31:0]  ra0_w0_dat

);

   reg   [31:0]   cfg0_q;
   wire  [31:0]   cfg0_d;
   reg    [4:0]   seq_q;
   wire   [4:0]   seq_d;
   reg    [2:0]   rd_wait_q;
   wire   [2:0]   rd_wait_d;
   reg   [127:0]  scan_reg_q;
   wire  [127:0]  scan_reg_d;

   wire           ra0_bist_rd;
   wire           adr_bist;
   wire           adr_config;
   wire           special;
   wire           rd_start;
   wire   [1:0]   rd_type;
   wire   [2:0]   rdata_sel;
   wire           rd_data;

   wire           test_enable;
   wire           scan_clk;
   wire           scan_di;
   wire           scan_do;
   wire   [16:0]  scan_config;
   wire           io_ra0_clk;
   wire           io_ra0_rst;
   wire           io_ra0_r0_enb;
   wire           io_ra0_r1_enb;
   wire           io_ra0_w0_enb;
   wire   [4:0]   io_ra0_r0_adr;
   wire   [4:0]   io_ra0_r1_adr;
   wire   [4:0]   io_ra0_w0_adr;
   wire   [31:0]  io_ra0_w0_dat;

   // FF
   always @(posedge clk) begin
      if (rst) begin
         seq_q <= 'hFF;
         cfg0_q <= CFG0_INIT;
         rd_wait_q <= 0;
      end else begin
         seq_q <= seq_d;
         cfg0_q <= cfg0_d;
         rd_wait_q <= rd_wait_d;
      end
   end

   always @(posedge scan_clk) begin
      begin
         if (test_enable == 'b1) begin
            scan_reg_q <= {scan_reg_q[126:0], scan_di};
         end
      end
   end

   always @(posedge io_ra0_clk) begin
      if (test_enable == 'b1) begin
         scan_reg_q[122:91] <= {ra0_r0_dat};
         scan_reg_q[85:54]  <= {ra0_r1_dat};
      end
   end

   // GPIO
   //
   // Scan Controls
   //  test enable
   //  scan_clk
   //  scan_di
   //  scan_do
   //
   // Scan Config
   //  * have a way to single-step on-chip clk so can use it plus scan?
   //
   // Array Controls
   //  ra_clk
   //  ra_rst
   //  ra_r0_enb
   //  ra_r1_enb
   //  ra_w0_enb
   //
   //
   // Scannable RA0 Reg
   //  ra0_r0_adr
   //  ra0_r0_dat
   //  ra0_r1_adr
   //  ra0_r1_dat
   //  ra0_w0_adr
   //  ra0_w0_dat
   //
   //
   // Array Read/Write
   // 1. scan in adr/dat reg
   // 2. activate ra_clk and ra_xx_enb for port control (n cycles)
   // 3. scan out adr/dat reg
   //
   //
   // * not enough I/O to do full-speed reads/writes through I/O; enough for addresses, and could have data gen/chk logic for data

   assign test_enable = io_in[0];
   assign scan_clk = io_in[1];
   assign scan_di = io_in[2];
   assign io_out[3] = scan_do;

   assign io_ra0_clk = io_in[4];
   assign io_ra0_rst = io_in[5];
   assign io_ra0_r0_enb = io_in[6];
   assign io_ra0_r1_enb = io_in[7];
   assign io_ra0_w0_enb = io_in[8];

   //assign io_oeb = '{`MPRJ_IO_PADS'('h0000000000000008)};
   assign io_oeb = ~'h0000000000000008;

   assign io_ra0_r0_adr = scan_reg_q[127:123];
   //assign io_ra0_r0_dat = scan_reg_q[122:91]; // loaded by io_ra0_clk
   assign io_ra0_r1_adr = scan_reg_q[90:86];
   //assign io_ra0_r1_dat = scan_reg_q[85:54];  // loaded by io_ra0_clk
   assign io_ra0_w0_adr = scan_reg_q[53:49];
   assign io_ra0_w0_dat = scan_reg_q[48:17];

   assign scan_config = scan_reg_q[16:0];
   assign scan_do = scan_reg_q[127];

   // Internal Routing

   // CFG0
   // 31:03 Reserved
   // 02:00 Read Data Wait Cycles (after cmd cycle)
   assign cfg0_d = ctl_cmd_val & cmd_we & ((cmd_adr & ~ADDR_MASK) == CFG0_ADDR) ? cmd_dat : cfg0_q;

   // Array Routing

   assign adr_bist = (cmd_adr & ADDR_MASK) == (BIST_ADDR & ADDR_MASK);
   assign adr_config = (cmd_adr & ADDR_MASK) == (CFG_ADDR & ADDR_MASK);
   assign special = adr_bist | adr_config;

   assign ra0_bist_ctl = ra0_cmd_val & cmd_we & adr_bist ? cmd_dat : 'h00000000;
   assign ra0_bist_rd = ra0_cmd_val & ~cmd_we & adr_bist;
   assign ra0_cfg_wr = ra0_cmd_val & cmd_we & adr_config;
   assign ra0_cfg_wdat = cmd_dat;

   //  reads can use r0, r1, or both; if both, return either both hi or both lo data

   assign rd_type = cmd_adr[15:14];  // port addr 14 bits

   // or send test_enable and test_clk/rst to array
   assign ra0_clk = test_enable ? io_ra0_clk : clk;
   assign ra0_rst = test_enable ? io_ra0_rst : rst;

   assign ra0_r0_enb = test_enable ? io_ra0_r0_enb : ra0_cmd_val & ~special & ~cmd_we & (rd_type[0] | ~rd_type[1]);
   assign ra0_r1_enb = test_enable ? io_ra0_r1_enb : ra0_cmd_val & ~special & ~cmd_we & (rd_type[0] | rd_type[1]);
   assign ra0_r0_adr = test_enable ? io_ra0_r0_adr : cmd_adr[4:0];                                                // adr=row
   assign ra0_r1_adr = test_enable ? io_ra0_r1_adr : rd_type == 'b01 ? cmd_adr[4:0] : cmd_adr[10:6];              // adr=row
   assign ra0_w0_enb = test_enable ? io_ra0_w0_enb : ra0_cmd_val & cmd_we & cmd_sel[0];                           // sel=port
   assign ra0_w0_adr = test_enable ? io_ra0_w0_adr : cmd_adr[4:0];                                                // adr=row
   assign ra0_w0_dat = test_enable ? io_ra0_w0_dat : cmd_dat;                                                     //


   // Command Sequencer
   // rd_data in 1+ cycs; all reads use same timing

   //tbl cmdseq
   //n seq_q                             seq_d
   //n |     ctl_cmd_val                 |     rd_start
   //n |     |ra0_cmd_val                |     | rd_ack
   //n |     ||cmd_we                    |     | | rdata_sel
   //n |     ||| rd_type                 |     | | |
   //n |     ||| |  adr_bist             |     | | |
   //n |     ||| |  |adr_config          |     | | |
   //n |     ||| |  ||      rd_data      |     | | |
   //n |     ||| |  ||      |            |     | | |
   //n |     ||| |  ||      |            |     | | |
   //n |     ||| |  ||      |            |     | | |
   //b 43210 ||| 10 ||      |            43210 | | 210
   //t iiiii iii ii ii      i            ooooo o o ooo
   //*------------------------------------------------
   //* Idle ******************************************
   //s 11111 00- -- --      -            11111 0 0 000          * ...zzz..zzzzz....
   //s 11111 1-1 -- --      -            11111 0 0 000          * write ctl
   //s 11111 -11 -- --      -            11111 0 0 000          * write ra
   //s 11111 1-0 -- 00      -            00001 1 0 000          * rd ctl cfg
   //s 11111 1-0 -- 1-      -            00010 1 0 000          * rd bist
   //s 11111 1-0 -- -1      -            00011 1 0 000          * rd cfg
   //s 11111 -10 00 --      -            00100 1 0 000          * rd r0
   //s 11111 -10 01 --      -            00101 1 0 000          * rd r1
   //s 11111 -10 10 --      -            00110 1 0 000          * rd r0+r1 lo
   //s 11111 -10 11 --      -            00111 1 0 000          * rd r0_r1 hi
   //* Read CTL **************************************
   //s 00001 --- -- --      0            00001 0 0 100
   //s 00001 --- -- --      1            11111 0 1 100
   //* Read BIST *************************************
   //s 00010 --- -- --      0            00010 0 0 101
   //s 00010 --- -- --      1            11111 0 1 101
   //* Read CFG **************************************
   //s 00011 --- -- --      0            00011 0 0 110
   //s 00011 --- -- --      1            11111 0 1 110
   //* Read R0 ***************************************
   //s 00100 --- -- --      0            00100 0 0 000
   //s 00100 --- -- --      1            11111 0 1 000
   //* Read R1 ***************************************
   //s 00101 --- -- --      0            00101 0 0 001
   //s 00101 --- -- --      1            11111 0 1 001
   //* Read R0+R1 Lo *********************************
   //s 00110 --- -- --      0            00110 0 0 010
   //s 00110 --- -- --      1            11111 0 1 010
   //* Read R0+R1 Hi *********************************
   //s 00111 --- -- --      0            00111 0 0 011
   //s 00111 --- -- --      1            11111 0 1 011

   //*------------------------------------------------
   //tbl cmdseq_d

   // use same timing for ra accesses and others
   assign rd_wait_d = rd_start ? cfg0_q[2:0] :
                      (rd_wait_q != 0) ? rd_wait_q - 1 :
                      rd_wait_q;

   assign rd_data = rd_wait_q == 0;

   assign rd_dat = rdata_sel == 'b000 ? ra0_r0_dat :
                   rdata_sel == 'b001 ? ra0_r1_dat :
                   rdata_sel == 'b010 ? {ra0_r1_dat[15:0],ra0_r0_dat[15:0]} :
                   rdata_sel == 'b011 ? {ra0_r1_dat[31:16],ra0_r0_dat[31:16]} :
                   rdata_sel == 'b100 ? cfg0_q :
                   rdata_sel == 'b101 ? ra0_bist_status :
                   rdata_sel == 'b110 ? ra0_cfg_rdat :
                   'hFFFFFFFF;

   // Generated...
   //vtable cmdseq
assign seq_d[4] =
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ~ctl_cmd_val & ~ra0_cmd_val) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ctl_cmd_val & cmd_we) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ra0_cmd_val & cmd_we) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & ~seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & ~seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & ~seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & rd_data);
assign seq_d[3] =
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ~ctl_cmd_val & ~ra0_cmd_val) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ctl_cmd_val & cmd_we) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ra0_cmd_val & cmd_we) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & ~seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & ~seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & ~seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & rd_data);
assign seq_d[2] =
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ~ctl_cmd_val & ~ra0_cmd_val) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ctl_cmd_val & cmd_we) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ra0_cmd_val & cmd_we) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ra0_cmd_val & ~cmd_we & ~rd_type[1] & ~rd_type[0]) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ra0_cmd_val & ~cmd_we & ~rd_type[1] & rd_type[0]) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ra0_cmd_val & ~cmd_we & rd_type[1] & ~rd_type[0]) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ra0_cmd_val & ~cmd_we & rd_type[1] & rd_type[0]) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & ~seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & ~seq_q[1] & ~seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & ~seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & ~seq_q[1] & seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & ~seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & ~seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & rd_data);
assign seq_d[1] =
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ~ctl_cmd_val & ~ra0_cmd_val) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ctl_cmd_val & cmd_we) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ra0_cmd_val & cmd_we) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ctl_cmd_val & ~cmd_we & adr_bist) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ctl_cmd_val & ~cmd_we & adr_config) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ra0_cmd_val & ~cmd_we & rd_type[1] & ~rd_type[0]) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ra0_cmd_val & ~cmd_we & rd_type[1] & rd_type[0]) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & ~seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & ~seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & ~seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & ~seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & ~seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & rd_data);
assign seq_d[0] =
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ~ctl_cmd_val & ~ra0_cmd_val) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ctl_cmd_val & cmd_we) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ra0_cmd_val & cmd_we) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ctl_cmd_val & ~cmd_we & ~adr_bist & ~adr_config) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ctl_cmd_val & ~cmd_we & adr_config) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ra0_cmd_val & ~cmd_we & ~rd_type[1] & rd_type[0]) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ra0_cmd_val & ~cmd_we & rd_type[1] & rd_type[0]) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & ~seq_q[1] & seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & ~seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & ~seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & ~seq_q[1] & seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & ~seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & rd_data);
assign rd_start =
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ctl_cmd_val & ~cmd_we & ~adr_bist & ~adr_config) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ctl_cmd_val & ~cmd_we & adr_bist) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ctl_cmd_val & ~cmd_we & adr_config) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ra0_cmd_val & ~cmd_we & ~rd_type[1] & ~rd_type[0]) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ra0_cmd_val & ~cmd_we & ~rd_type[1] & rd_type[0]) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ra0_cmd_val & ~cmd_we & rd_type[1] & ~rd_type[0]) +
  (seq_q[4] & seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ra0_cmd_val & ~cmd_we & rd_type[1] & rd_type[0]);
assign rd_ack =
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & ~seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & ~seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & ~seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & rd_data);
assign rdata_sel[2] =
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & ~seq_q[1] & seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & ~seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & ~seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & seq_q[0] & rd_data);
assign rdata_sel[1] =
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & ~seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & rd_data);
assign rdata_sel[0] =
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & ~seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & ~seq_q[2] & seq_q[1] & ~seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & ~seq_q[1] & seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & ~seq_q[1] & seq_q[0] & rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & ~rd_data) +
  (~seq_q[4] & ~seq_q[3] & seq_q[2] & seq_q[1] & seq_q[0] & rd_data);
   //vtable cmdseq

endmodule
