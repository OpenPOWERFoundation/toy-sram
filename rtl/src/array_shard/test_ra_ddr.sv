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

module  test_ra_ddr ();

   logic                            clk;
   logic 			    clk2x;
   logic 			    reset;
   logic 			    cfg_wr;
   logic [0:`LCBDDR_CONFIGWIDTH-1]  cfg_dat;
   logic [0:31] 		    bist_ctl;
   logic [0:31] 		    bist_status;
   logic 			    rd_enb_0;
   logic [0:5] 			    rd_adr_0;
   logic [0:71] 		    rd_dat_0;
   logic 			    rd_enb_1;
   logic [0:5] 			    rd_adr_1;
   logic [0:71] 		    rd_dat_1;
   logic 			    rd_enb_2;
   logic [0:5] 			    rd_adr_2;
   logic [0:71] 		    rd_dat_2;
   logic 			    rd_enb_3;
   logic [0:5] 			    rd_adr_3;
   logic [0:71] 		    rd_dat_3;
   logic 			    wr_enb_0;
   logic [0:5] 			    wr_adr_0;
   logic [0:71] 		    wr_dat_0;
   logic 			    wr_enb_1;
   logic [0:5] 			    wr_adr_1;
   logic [0:71] 		    wr_dat_1;
   
   logic 			    strobe;
   logic 			    el_sel;
   logic [0:`LCBDDR_CONFIGWIDTH-1]  cfg;
   logic 			    mux_rd0_enb;
   logic [0:5] 			    mux_rd0_adr;
   logic 			    mux_rd1_enb;
   logic [0:5] 			    mux_rd1_adr;
   logic 			    mux_rd2_enb;
   logic [0:5] 			    mux_rd2_adr;
   logic 			    mux_rd3_enb;
   logic [0:5] 			    mux_rd3_adr;
   logic 			    mux_wr0_enb;
   logic [0:5] 			    mux_wr0_adr;
   logic [0:71] 		    mux_wr0_dat;
   logic 			    mux_wr1_enb;
   logic [0:5] 			    mux_wr1_adr;
   logic [0:71] 		    mux_wr1_dat;
   
   initial
     begin
	clk = 1'b1;
	clk2x = 1'b1;	
	forever #10 clk = ~clk;
	forever #5 clk2x = ~clk2x;	
     end


    ra_lcb_ddr lcb (

        .clk      (clk2x),
        .reset    (reset),
        .cfg      (cfg),
        .strobe   (strobe),
        .el_sel   (el_sel)

    );

    ra_cfg_ddr #(.INIT(-1)) cfig (

        .clk      (clk),
        .reset    (reset),
        .cfg_wr   (cfg_wr),
        .cfg_dat  (cfg_dat),
        .cfg      (cfg)

    );

    ra_bist_ddr bist (

        .clk         (clk),
        .reset       (reset),
        .ctl         (bist_ctl),
        .status      (bist_status),
        .rd0_enb_in  (rd_enb_0),
        .rd0_adr_in  (rd_adr_0),
        .rd0_dat     (rd_dat_0),
        .rd1_enb_in  (rd_enb_1),
        .rd1_adr_in  (rd_adr_1),
        .rd1_dat     (rd_dat_1),
        .rd2_enb_in  (rd_enb_2),
        .rd2_adr_in  (rd_adr_2),
        .rd2_dat     (rd_dat_2),
        .rd3_enb_in  (rd_enb_3),
        .rd3_adr_in  (rd_adr_3),
        .rd3_dat     (rd_dat_3),
        .wr0_enb_in  (wr_enb_0),
        .wr0_adr_in  (wr_adr_0),
        .wr0_dat_in  (wr_dat_0),
        .wr1_enb_in  (wr_enb_1),
        .wr1_adr_in  (wr_adr_1),
        .wr1_dat_in  (wr_dat_1),
        .rd0_enb_out (mux_rd0_enb),
        .rd0_adr_out (mux_rd0_adr),
        .rd1_enb_out (mux_rd1_enb),
        .rd1_adr_out (mux_rd1_adr),
        .rd2_enb_out (mux_rd2_enb),
        .rd2_adr_out (mux_rd2_adr),
        .rd3_enb_out (mux_rd3_enb),
        .rd3_adr_out (mux_rd3_adr),
        .wr0_enb_out (mux_wr0_enb),
        .wr0_adr_out (mux_wr0_adr),
        .wr0_dat_out (mux_wr0_dat),
        .wr1_enb_out (mux_wr1_enb),
        .wr1_adr_out (mux_wr1_adr),
        .wr1_dat_out (mux_wr1_dat)

    );

    ra_4r2w_64x72_ddr ra (

        .clk        (clk),
        .reset      (reset),
        .strobe     (strobe),
        .el_sel     (el_sel),
        .rd_enb_0   (mux_rd0_enb),
        .rd_adr_0   (mux_rd0_adr),
        .rd_dat_0   (rd_dat_0),
        .rd_enb_1   (mux_rd1_enb),
        .rd_adr_1   (mux_rd1_adr),
        .rd_dat_1   (rd_dat_1),
        .rd_enb_2   (mux_rd2_enb),
        .rd_adr_2   (mux_rd2_adr),
        .rd_dat_2   (rd_dat_2),
        .rd_enb_3   (mux_rd3_enb),
        .rd_adr_3   (mux_rd3_adr),
        .rd_dat_3   (rd_dat_3),
        .wr_enb_0   (mux_wr0_enb),
        .wr_adr_0   (mux_wr0_adr),
        .wr_dat_0   (mux_wr0_dat),
        .wr_enb_1   (mux_wr1_enb),
        .wr_adr_1   (mux_wr1_adr),
        .wr_dat_1   (mux_wr1_dat)

    );   

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
	#31  reset = 1'b0;	

   	#400 wr_enb_0 = 1'b1;
	#0   wr_adr_0 = 6'h0;
	#0   wr_adr_0 = 6'b00_0000;
   	#10  wr_adr_0 = 6'b00_0010;
	#10  wr_adr_0 = 6'b00_0100;
	#10  wr_adr_0 = 6'b00_0110;
	#10  wr_adr_0 = 6'b00_1000;		

	

     end

endmodule
