// © IBM Corp. 2022
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
// governing permissions & limitations under the License.
//
// Brief explanation of modifications:
//
// Modification 1: This modification extends the patent license to an implementation of the Work in physical form – i.e.,
// it unambiguously permits a user to make & use the physical chip.

// Wordline decodes
// Two versions:
//   12-in -> 64 one-hot (all selects, 1 comp used)
//   11-in -> 32 one-hot (half selects, 2 comps used)

`timescale 1 ps / 1 ps

module wordlines_comp_32 (

    input         rd0_c_na0,
    input         rd0_c_a0,
    input         rd0_na1_na2,
    input         rd0_na1_a2,
    input         rd0_a1_na2,
    input         rd0_a1_a2,
    input         rd0_xa3,
    input         rd0_na4_na5,
    input         rd0_na4_a5,
    input         rd0_a4_na5,
    input         rd0_a4_a5,
    output [0:31] rwl0_0,
    output [0:31] rwl0_1,

    input         rd1_c_na0,
    input         rd1_c_a0,
    input         rd1_na1_na2,
    input         rd1_na1_a2,
    input         rd1_a1_na2,
    input         rd1_a1_a2,
    input         rd1_xa3,
    input         rd1_na4_na5,
    input         rd1_na4_a5,
    input         rd1_a4_na5,
    input         rd1_a4_a5,
    output [0:31] rwl1_0,
    output [0:31] rwl1_1,

    input         wr0_c_na0,
    input         wr0_c_a0,
    input         wr0_na1_na2,
    input         wr0_na1_a2,
    input         wr0_a1_na2,
    input         wr0_a1_a2,
    input         wr0_xa3,
    input         wr0_na4_na5,
    input         wr0_na4_a5,
    input         wr0_a4_na5,
    input         wr0_a4_a5,
    output [0:31] wwl0_0,
    output [0:31] wwl0_1

);

wire [0:31] rwl0;
wire [0:31] rwl1;
wire [0:31] wwl0;

// 64 wordlines per port
// if center sel is a0, 00:31 to left, 32:63 to right
// if center sel is a3, xxx0xx to left, xxx1xx to right

decode_wordlines_32 rd0 (
    .c_na0(rd0_c_na0),
    .c_a0(rd0_c_a0),
    .na1_na2(rd0_na1_na2),
    .na1_a2(rd0_na1_a2),
    .a1_na2(rd0_a1_na2),
    .a1_a2(rd0_a1_a2),
    .xa3(rd0_xa3),
    .na4_na5(rd0_na4_na5),
    .na4_a5(rd0_na4_a5),
    .a4_na5(rd0_a4_na5),
    .a4_a5(rd0_a4_a5),
    .wl(rwl0)
);

decode_wordlines_32 rd1 (
    .c_na0(rd1_c_na0),
    .c_a0(rd1_c_a0),
    .na1_na2(rd1_na1_na2),
    .na1_a2(rd1_na1_a2),
    .a1_na2(rd1_a1_na2),
    .a1_a2(rd1_a1_a2),
    .xa3(rd1_xa3),
    .na4_na5(rd1_na4_na5),
    .na4_a5(rd1_na4_a5),
    .a4_na5(rd1_a4_na5),
    .a4_a5(rd1_a4_a5),
    .wl(rwl1)
);

decode_wordlines_32 wr0 (
    .c_na0(wr0_c_na0),
    .c_a0(wr0_c_a0),
    .na1_na2(wr0_na1_na2),
    .na1_a2(wr0_na1_a2),
    .a1_na2(wr0_a1_na2),
    .a1_a2(wr0_a1_a2),
    .xa3(wr0_xa3),
    .na4_na5(wr0_na4_na5),
    .na4_a5(wr0_na4_a5),
    .a4_na5(wr0_a4_na5),
    .a4_a5(wr0_a4_a5),
    .wl(wwl0)
);

// add level for up/dn?
assign rwl0_0 = rwl0;
assign rwl0_1 = rwl0;
assign rwl1_0 = rwl1;
assign rwl1_1 = rwl1;
assign wwl0_0 = wwl0;
assign wwl0_1 = wwl0;

endmodule
