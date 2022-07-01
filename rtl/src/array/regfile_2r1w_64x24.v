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


// Behavioral for 64x24 toysram (sdr or ddr)
// I/Os are equivalent to physical macro
// This version has the enables encoded in a0.

`timescale 1 ps / 1 ps

module regfile_2r1w_64x24(

    rd0_c_na0,
    rd0_c_a0,
    rd0_na1_na2,
    rd0_na1_a2,
    rd0_a1_na2,
    rd0_a1_a2,
    rd0_na3,
    rd0_a3,
    rd0_na4_na5,
    rd0_na4_a5,
    rd0_a4_na5,
    rd0_a4_a5,
    rd0_dat,

    rd1_c_na0,
    rd1_c_a0,
    rd1_na1_na2,
    rd1_na1_a2,
    rd1_a1_na2,
    rd1_a1_a2,
    rd1_na3,
    rd1_a3,
    rd1_na4_na5,
    rd1_na4_a5,
    rd1_a4_na5,
    rd1_a4_a5,
    rd1_dat,

    wr0_c_na0,
    wr0_c_a0,
    wr0_na1_na2,
    wr0_na1_a2,
    wr0_a1_na2,
    wr0_a1_a2,
    wr0_na3,
    wr0_a3,
    wr0_na4_na5,
    wr0_na4_a5,
    wr0_a4_na5,
    wr0_a4_a5,
    wr0_dat

);

 //   -- predecoded address
 //   -- four groups of one hot encoded signals
 //   -- read address 0
 input   rd0_c_na0;
 input   rd0_c_a0;

 input   rd0_na1_na2;
 input   rd0_na1_a2;
 input   rd0_a1_na2;
 input   rd0_a1_a2;

 input   rd0_na3;
 input   rd0_a3;

 input   rd0_na4_na5;
 input   rd0_na4_a5;
 input   rd0_a4_na5;
 input   rd0_a4_a5;

 //   -- read address 1
 input   rd1_c_na0;
 input   rd1_c_a0;

 input   rd1_na1_na2;
 input   rd1_na1_a2;
 input   rd1_a1_na2;
 input   rd1_a1_a2;

 input   rd1_na3;
 input   rd1_a3;

 input   rd1_na4_na5;
 input   rd1_na4_a5;
 input   rd1_a4_na5;
 input   rd1_a4_a5;

//    -- write address 0
 input   wr0_c_na0;
 input   wr0_c_a0;

 input   wr0_na1_na2;
 input   wr0_na1_a2;
 input   wr0_a1_na2;
 input   wr0_a1_a2;

 input   wr0_na3;
 input   wr0_a3;

 input   wr0_na4_na5;
 input   wr0_na4_a5;
 input   wr0_a4_na5;
 input   wr0_a4_a5;

//    -- data ports
 output [0:23] rd0_dat;
 output [0:23] rd1_dat;
 input  [0:23] wr0_dat;

 wire rd0_enable;
 wire rd1_enable;
 wire wr0_enable;

 wire rd0_a0;
 wire rd0_a1;
 wire rd0_a2;
// wire rd0_a3;
 wire rd0_a4;
 wire rd0_a5;

 wire rd1_a0;
 wire rd1_a1;
 wire rd1_a2;
// wire rd1_a3;
 wire rd1_a4;
 wire rd1_a5;

 wire wr0_a0;
 wire wr0_a1;
 wire wr0_a2;
//wire wr0_a3;
 wire wr0_a4;
 wire wr0_a5;

// array cells
 reg[0:23] mem[0:63];

// decode inputs, rd0
 assign rd0_enable = rd0_c_a0 | rd0_c_na0;
 assign rd0_a0 = rd0_c_a0;
 assign rd0_a1 = rd0_a1_a2 | rd0_a1_na2;
 assign rd0_a2 = rd0_a1_a2 | rd0_na1_a2;
// assign rd0_a3 = rd0_a3;
 assign rd0_a4 = rd0_a4_a5 | rd0_a4_na5;
 assign rd0_a5 = rd0_a4_a5 | rd0_na4_a5;

// deocde inputs, rd1
 assign rd1_enable = rd1_c_a0 | rd1_c_na0;
 assign rd1_a0 = rd1_c_a0;
 assign rd1_a1 = rd1_a1_a2 | rd1_a1_na2;
 assign rd1_a2 = rd1_a1_a2 | rd1_na1_a2;
// assign rd1_a3 = rd1_a3;
 assign rd1_a4 = rd1_a4_a5 | rd1_a4_na5;
 assign rd1_a5 = rd1_a4_a5 | rd1_na4_a5;


// decode inputs, wr0
 assign wr0_enable = wr0_c_a0 | wr0_c_na0;
 assign wr0_a0 = wr0_c_a0;
 assign wr0_a1 = wr0_a1_a2 | wr0_a1_na2;
 assign wr0_a2 = wr0_a1_a2 | wr0_na1_a2;
// assign wr0_a3 = wr0_a3;
 assign wr0_a4 = wr0_a4_a5 | wr0_a4_na5;
 assign wr0_a5 = wr0_a4_a5 | wr0_na4_a5;


// read ports
 assign rd0_dat = (rd0_enable) ? mem[{rd0_a0, rd0_a1, rd0_a2, rd0_a3, rd0_a4, rd0_a5}] : 24'bX;
 assign rd1_dat = (rd1_enable) ? mem[{rd1_a0, rd1_a1, rd1_a2, rd1_a3, rd1_a4, rd1_a5}] : 24'bX;

// write port
 always @* begin
    if (wr0_enable) begin
       #10; // make sure addr settles
       if (wr0_enable) begin
          mem[{wr0_a0, wr0_a1, wr0_a2, wr0_a3, wr0_a4, wr0_a5}] <= wr0_dat;
          //$display("%0d wr0_en=%h @%0h=%0h", $time, wr0_enable, {wr0_a0, wr0_a1, wr0_a2, wr0_a3, wr0_a4, wr0_a5}, mem[{wr0_a0, wr0_a1, wr0_a2, wr0_a3, wr0_a4, wr0_a5}]);
       end
    end
 end

endmodule

