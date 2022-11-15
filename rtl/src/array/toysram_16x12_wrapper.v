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
// governing permissions and limitations under the License.
//
// Brief explanation of modifications:
//
// Modification 1: This modification extends the patent license to an implementation of the Work in physical form – i.e.,
// it unambiguously permits a user to make and use the physical chip.

// Empty wrapper for 16x12 toysram subarray

`timescale 1 ps / 1 ps

module toysram_16x12 (

   input  [0:15]     RWL0,
   input  [0:15]     RWL1,
   input  [0:15]     WWL,
   output [0:11]     RBL0,
   output [0:11]     RBL1,
   input  [0:11]     WBL,
   input  [0:11]     WBLb
);

endmodule