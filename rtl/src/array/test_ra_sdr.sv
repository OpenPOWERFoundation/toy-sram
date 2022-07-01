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

// Test array (SDR)
// 64 word 72 bit array
// LCB for strobe generation
// Config, BIST, etc.

`timescale 1 ns/1 ps
`include "toysram.vh"

module  test_ra_sdr ();

   logic                           clk;
   logic 			   reset;
   logic 			   cfg_wr;
   logic [0:`LCBSDR_CONFIGWIDTH-1] cfg_dat;
   logic [0:31] 		   bist_ctl;
   logic [0:31] 		   bist_status;
   logic 			   rd_enb_0;
   logic [0:5] 			   rd_adr_0;
   logic [0:71] 		   rd_dat_0;
   logic 			   rd_enb_1;
   logic [0:5] 			   rd_adr_1;
   logic [0:71] 		   rd_dat_1;
   logic 			   wr_enb_0;
   logic [0:5] 			   wr_adr_0;
   logic [0:71] 		   wr_dat_0;

   logic 			   strobe;
   logic [0:`LCBSDR_CONFIGWIDTH-1] cfg;
   logic 			   mux_rd0_enb;
   logic [0:5] 			   mux_rd0_adr;
   logic 			   mux_rd1_enb;
   logic [0:5] 			   mux_rd1_adr;
   logic 			   mux_wr0_enb;
   logic [0:5] 			   mux_wr0_adr;
   logic [0:71] 		   mux_wr0_dat;

   initial
     begin
	$dumpfile("test_ra_sdr.vcd");
	$dumpvars (0,test_ra_sdr.lcb);
	$dumpvars (0,test_ra_sdr.cfig);
	$dumpvars (0,test_ra_sdr.bist);
	$dumpvars (0,test_ra_sdr.ra);
     end


   initial
     begin
	clk = 1'b1;
	forever #5 clk = ~clk;
     end



   ra_lcb_sdr lcb (.clk      (clk),
		   .reset    (reset),
		   .cfg      (cfg),
		   .strobe   (strobe));

   ra_cfg_sdr #(.INIT(-1)) cfig (.clk (clk),
				  .reset    (reset),
				  .cfg_wr   (cfg_wr),
				  .cfg_dat  (cfg_dat),
				  .cfg      (cfg));

   ra_bist_sdr bist (.clk         (clk),
		     .reset       (reset),
		     .ctl         (bist_ctl),
		     .status      (bist_status),
		     .rd0_enb_in  (rd_enb_0),
		     .rd0_adr_in  (rd_adr_0),
		     .rd0_dat     (rd_dat_0),
		     .rd1_enb_in  (rd_enb_1),
		     .rd1_adr_in  (rd_adr_1),
		     .rd1_dat     (rd_dat_1),
		     .wr0_enb_in  (wr_enb_0),
		     .wr0_adr_in  (wr_adr_0),
		     .wr0_dat_in  (wr_dat_0),
		     .rd0_enb_out (mux_rd0_enb),
		     .rd0_adr_out (mux_rd0_adr),
		     .rd1_enb_out (mux_rd1_enb),
		     .rd1_adr_out (mux_rd1_adr),
		     .wr0_enb_out (mux_wr0_enb),
		     .wr0_adr_out (mux_wr0_adr),
		     .wr0_dat_out (mux_wr0_dat));


   ra_2r1w_64x72_sdr ra (.clk        (clk),
			 .reset      (reset),
			 .strobe     (strobe),
			 .rd_enb_0   (mux_rd0_enb),
			 .rd_adr_0   (mux_rd0_adr),
			 .rd_dat_0   (rd_dat_0),
			 .rd_enb_1   (mux_rd1_enb),
			 .rd_adr_1   (mux_rd1_adr),
			 .rd_dat_1   (rd_dat_1),
			 .wr_enb_0   (mux_wr0_enb),
			 .wr_adr_0   (mux_wr0_adr),
			 .wr_dat_0   (mux_wr0_dat));

   initial
     begin
	#0   reset = 1'b1;
	#0   wr_enb_0 = 1'b0;
	#0   wr_adr_0 = 6'h0;
	#0   rd_adr_0 = 6'h0;
	#0   rd_adr_1 = 6'h0;
	#0   rd_enb_0 = 1'b0;
	#0   rd_enb_1 = 1'b0;
	#0   bist_ctl = 32'h0;
	#0   cfg_wr = 1'b0;
	#0   cfg_dat = 16'h0;
	#15  reset = 1'b0;

   	#400 wr_enb_0 = 1'b1;
	#0   wr_adr_0 = 6'h0;

	#0   wr_adr_0 = 6'b00_0000;
    #0   wr_dat_0 = 6'b00_1111;

   	#10  wr_adr_0 = 6'b00_0010;
    #0   wr_dat_0 = 6'b00_1001;

	#10  wr_adr_0 = 6'b00_0100;
    #0   wr_dat_0 = 6'b00_1100;

	#10  wr_adr_0 = 6'b00_0110;
    #0   wr_adr_0 = 6'b00_1101;

	#10  wr_adr_0 = 6'b00_1000;
    #0   wr_adr_0 = 6'b00_1000;

    #5 wr_enb_0 = 0;

    #5 rd_enb_0 = 1;
    #0 rd_enb_1 = 1;

    #10 rd_adr_0 = 6'b00_0000;
    #0  rd_adr_1 = 6'b00_0010;

    #10 rd_adr_0 = 6'b00_0100;
    #0  rd_adr_1 = 6'b00_0110;

    #10 rd_adr_0 = 6'b00_1000;

    #5 rd_enb_0 = 0;
    #0 rd_enb_1 = 0;


     end

endmodule
