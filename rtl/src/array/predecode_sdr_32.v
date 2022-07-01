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

// Predecode of 5 address bits into 4 one hot encodings

`timescale 1 ns / 1 ns

module predecode_sdr_32(

    strobe,
    enable,
    address,

    // 12 predecoded address lines 2 - 4 - 2 - 4 one hot encoding
    c_na0,  // clock and not address(0)
    c_a0,   // clock and address(0)
    na1_na2,// not address(1) and not address(2)
    na1_a2, // not address(1) and address(2)
    a1_na2, // address(1) and not address(2)
    a1_a2,  // address(1) and address(2)
    na3,    // not address(3)
    a3,     // address(3)
    na4,    // not address(4)
    a4      // address(4)
);

   input       strobe;
   input 	   enable;
   input [0:4] address;

   output 	   c_na0;
   output 	   c_a0;
   output 	   na1_na2;
   output 	   na1_a2;
   output 	   a1_na2;
   output 	   a1_a2;  // address(1) and address(2)
   output 	   na3;    // not address(3)
   output 	   a3;     // address(3)
   output 	   na4;    // not address(4)
   output 	   a4;     // address(4)

   wire clock_enable;

   wire [0:4] inv_address;

   wire n_c_na0;
   wire n_c_a0;
   wire n_na1_na2;
   wire n_na1_a2;
   wire n_a1_na2;
   wire n_a1_a2;
   wire n_na4;
   wire n_a4;

  // and read or write enable with clock
  // does this need to be SSB placed?
  assign clock_enable = strobe & enable;

  assign inv_address[0] = (~(address[0]));
  assign inv_address[1] = (~(address[1]));
  assign inv_address[2] = (~(address[2]));
  assign inv_address[3] = (~(address[3]));
  assign inv_address[4] = (~(address[4]));

  // A(0) address predecode and gating with clock

  assign c_na0 = clock_enable & inv_address[0];

  assign c_a0 = clock_enable & address[0];


  // A(1:2) address predecode

  assign na1_na2 = inv_address[1] & inv_address[2];

  assign na1_a2 = inv_address[1] & address[2];

  assign a1_na2 = address[1] & inv_address[2];

  assign a1_a2 = address[1] & address[2];


  // A(3) address predecode

  assign na3 = inv_address[3];
  assign a3  = address[3];

  // A(4) address predecode

  assign na4 = inv_address[4];
  assign a4 = address[4];

endmodule
