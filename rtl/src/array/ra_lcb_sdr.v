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

`include "toysram.vh"

module  ra_lcb_sdr (

    clk,
    reset,
    cfg,
    strobe

);

   parameter GENMODE = `GENMODE;	        // 0=NoDelay, 1=Delay
   input          clk;
   input          reset;
   input [0:`LCBSDR_CONFIGWIDTH-1] cfg;
   output         strobe;

   wire           clk_dly;
   wire           i;
   wire           o0;
   wire           o1;
   wire           clk_dly2;

// generate strobe
generate

  if (GENMODE == 0)
     assign strobe = !clk & !reset;
  else begin

   // generate a strobe for sdr
   // clk -> [delay] -> * --------------------- * -- and ---
   //                   | -- [delay] --- inv ---|

   // first edge delay
   ra_delay d0 (
      .i(i),
      .o(o0)
   );
   // remaining
   /*
   genvar i;
   for (i = 1; i < `MAX_PULSE_DELAYS-1; i = i + 1) begin : d1
      ra_delay (
         .i()
         .o()
      )
   end
   */
   // select tap based on cfg

   assign clk_dly = o0;

   // first width delay
   ra_delay w0 (
      .i(clk_dly),
      .o(o1)
   );

   // remaining
   // select tap based on cfg

   assign clk_dly2 = o1;


   // create strobe
   assign strobe = clk_dly & !clk_dly2;

  end

endgenerate

endmodule

