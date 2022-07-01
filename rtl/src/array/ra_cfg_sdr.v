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


// Local Configuration for arrays
//

`timescale 1 ns / 1 ns

`include "toysram.vh"

module ra_cfg_sdr(

    clk,
    reset,
    cfg_wr,
    cfg_dat,
    cfg

);

 parameter GENMODE = `GENMODE;	        // 0=NoDelay, 1=Delay
 parameter INIT = `LCBSDR_CONFIGWIDTH'b0;

   input  clk;
   input  reset;
   input  cfg_wr;
   input  [0:`LCBSDR_CONFIGWIDTH-1] cfg_dat;
   output [0:`LCBSDR_CONFIGWIDTH-1] cfg;

   reg    [0:`LCBSDR_CONFIGWIDTH-1] cfg_q;
   wire   [0:`LCBSDR_CONFIGWIDTH-1] cfg_d;

   // ff
   always @ (posedge clk) begin
      if (reset)
         cfg_q <= INIT;
      else
         cfg_q <= cfg_d;
   end

   // do something
   assign cfg_d = (cfg_wr) ? cfg_dat : cfg_q;

   // outputs
   assign cfg = cfg_q;

endmodule

