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


// Local Clock Buffer for arrays
// Generates sim or implementation logic, depending on GENMODE.

`timescale 1 ns / 1 ns

/*
Config_LCB

   31 enable delay
   30 sdr=0 ddr=1
28:29 tap1 sel (pulse width)
26:27 tap2 sel (pulse 2 separation gross)
24:25 tap3 sel (pulse 2 separation fine)
*/

module  ra_lcb #(

    parameter GENMODE = 0

) (
    input         clk,
    input         reset,
    input [0:31]  cfg,
    output        strobe

);

reg               no_delay_q;
reg               no_delay_b_q;
reg               ddr_q;
reg    [0:3]      tap1_sel_q;
reg    [0:2]      tap2_sel_q;
reg    [0:3]      tap3_sel_q;

wire   [0:3]      delay1;
wire   [0:3]      tap1;
wire              tap1_b;
wire              pulse1_b;
wire              delay2_b;
wire   [0:15]     delay2;
wire   [0:2]      tap2;
wire              tap2_b;
wire   [0:3]      delay3;
wire   [0:3]      tap3;
wire              pulse2_b;
wire              pulse;

// predecode and keep locally
//wtf  make these dff cells?
always @(posedge clk) begin

   no_delay_q      <= ~cfg[31];
   no_delay_b_q    <= cfg[31];
   ddr_q           <= cfg[30];
   tap1_sel_q[0]   <= cfg[28:29] == 2'b00;
   tap1_sel_q[1]   <= cfg[28:29] == 2'b01;
   tap1_sel_q[2]   <= cfg[28:29] == 2'b10;
   tap1_sel_q[3]   <= cfg[28:29] == 2'b11;
   tap2_sel_q[0]   <= cfg[26:27] == 2'b00;
   tap2_sel_q[1]   <= cfg[26:27] == 2'b01;
   tap2_sel_q[2]   <= cfg[26:27] == 2'b10;
   //tap2_sel_q[3]   <= cfg[26:27] == 2'b11;
   tap3_sel_q[0]   <= cfg[24:25] == 2'b00;
   tap3_sel_q[1]   <= cfg[24:25] == 2'b01;
   tap3_sel_q[2]   <= cfg[24:25] == 2'b10;
   tap3_sel_q[3]   <= cfg[24:25] == 2'b11;

end

// generate strobe
// array needs strobe to precharge the bitlines before evaluate phase
// strobe is AND'd with enable/addr to create precharge signal -> strobe=0 == precharge
// sdr: one strobe per clk
// ddr: two strobes per clk; early/late select for addr sel/data out latch

generate

if (GENMODE == 0)

   assign strobe = ~clk;

else begin

   genvar i;

   // dly1 - create pulse 1 (and 2 if ddr) width
   sky130_fd_sc_hd__buf_1 dly1_0(.A(clk), .X(delay1[0]));

   //wtf need to size properly; could spread into 1/2/4/7 etc.
   // there are buf_[1,2,4,6,8,12,16]
   //           bufbuf_[8,16]
   //           clkbuf_[1,2,4,8,16]
   //           clkdlybufs15_[1,2]
   //           clkdlybufs18_[1,2]
   //           clkdlybufs25_[1,2]
   //           blkdlybufs50_[1,2]
   for (i = 1; i < 4; i = i + 1) begin
      sky130_fd_sc_hd__buf_1 dly1_n(.A(delay1[i-1]), .X(delay1[i]));
   end

   for (i = 0; i < 4; i = i + 1) begin
      sky130_fd_sc_hd__and2_1 dly1_sel(.A(tap1_sel_q[i]), .B(delay1[i]), .X(tap1[i]));
   end

   sky130_fd_sc_hd__nor4_1 dly1_or(.A(tap1[0]), .B(tap1[1]), .C(tap1[2]), .D(tap1[3]), .X(tap1_b));

   sky130_fd_sc_hd__nand2_1 dly1_out(.A(clk), .B(tap1_b), .Y(pulse1_b));

   // dly2 - create pulse 2 separation (disable for sdr)
   sky130_fd_sc_hd__and2_1 dly2_in(.A(ddr_q), .B(pulse1_b), .X(delay2_b));
   sky130_fd_sc_hd__inv_1 dly2_0(.A(delay2_b), .Y(delay2[0]));

   // 2-stage
   // +8/12/16
   // +0/1/2/3
   for (i = 1; i < 16; i = i + 1) begin
      sky130_fd_sc_hd__inv_1 dly2_n(.A(delay2[i-1]), .Y(delay2[i]));
   end

   sky130_fd_sc_hd__and2_1 dly2_sel0(.A(tap2_sel_q[0]), .B(delay2[7]),  .X(tap2[0]));
   sky130_fd_sc_hd__and2_1 dly2_sel1(.A(tap2_sel_q[1]), .B(delay2[11]), .X(tap2[1]));
   sky130_fd_sc_hd__and2_1 dly2_sel2(.A(tap2_sel_q[2]), .B(delay2[15]), .X(tap2[2]));

   sky130_fd_sc_hd__or3_1 dly3_0(.A(tap2[0]), .B(tap2[1]), .C(tap2[2]), .X(delay3[0]));
   for (i = 1; i < 4; i = i + 1) begin
      sky130_fd_sc_hd__buf_1 dly3_n (.A(delay3[i-1]), .X(delay3[i]));
   end

   for (i = 0; i < 4; i = i + 1) begin
      sky130_fd_sc_hd__and2_1 dly3_sel(.A(tap3_sel_q[i]), .B(delay3[i]), .X(tap3[i]));
   end

   sky130_fd_sc_hd__nor4_1 dly3_out(.A(tap3[0]), .B(tap3[1]), .C(tap3[2]), .D(tap3[3]), .X(pulse2_b));

   // combine
   sky130_fd_sc_hd__nand2_1 pulse12(.A(pulse1_b), .B(pulse2_b), .Y(pulse));

   // select and invert (neg-active precharge)
   sky130_fd_sc_hd__a22oi_1 strobe_out(.A1(no_delay_q), .A2(clk), .B1(no_delay_b_q), .B2(pulse), .X(strobe));

end

endgenerate

endmodule

