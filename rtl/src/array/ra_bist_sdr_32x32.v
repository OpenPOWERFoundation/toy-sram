`timescale 1 ns / 1 ns

`include "toysram.vh"

module ra_bist_sdr_32x32 (

    clk,
    reset,
    ctl,
    status,
    rd0_enb_in,
    rd0_adr_in,
    rd1_enb_in,
    rd1_adr_in,
    wr0_enb_in,
    wr0_adr_in,
    wr0_dat_in,
    rd0_enb_out,
    rd0_adr_out,
    rd0_dat,
    rd1_enb_out,
    rd1_adr_out,
    rd1_dat,
    wr0_enb_out,
    wr0_adr_out,
    wr0_dat_out,
    bist_fail,
    bist_passed
);

   parameter GENMODE = `GENMODE;	        // 0=NoDelay, 1=Delay

   input          clk;
   input          reset;
   input  [0:31]  ctl;

   input          rd0_enb_in;
   input  [0:4]   rd0_adr_in;
   input          rd1_enb_in;
   input  [0:4]   rd1_adr_in;
   input          wr0_enb_in;
   input  [0:4]   wr0_adr_in;
   input  [0:31]  wr0_dat_in;

   output [0:31]  status;
   output         rd0_enb_out;
   output [0:4]   rd0_adr_out;
   input  [0:31]  rd0_dat;
   output         rd1_enb_out;
   output [0:4]   rd1_adr_out;
   input  [0:31]  rd1_dat;
   output         wr0_enb_out;
   output [0:4]   wr0_adr_out;
   output [0:31]  wr0_dat_out;

   reg    [0:5]   seq_q;
   wire   [0:5]   seq_d;
   wire           active;
   wire           bist_rd0_enb;
   wire   [0:4]   bist_rd0_adr;
   wire           bist_rd1_enb;
   wire   [0:4]   bist_rd1_adr;
   wire           bist_wr0_enb;
   wire   [0:4]   bist_wr0_adr;
   wire   [0:31]  bist_wr0_dat;

   output         bist_fail;
   output         bist_passed;

   // ff
   always @ (posedge clk) begin
      if (reset)
         seq_q <= 6'h3F;
      else
         seq_q <= seq_d;
   end

   // do something
   assign seq_d = seq_q;
   assign active = seq_q != 6'h3F;
   assign status = 0;

/*
   A more practical implementation:
   make an up/down counter for interating through addresses.

   state machine for each part of the step: the best part about this is that
   states could be added for implementation withb GPIO/wishbone for external
   controls/different steps.

   s0: write 0s up (Idle)
   s1: write 1s down
   s2: read 1s down/check
   s3: write 0s up
   s4: read 0s up/check
   s5: write 1s up
   s6: read 1s up/check
   s7: flags


*/
   /*
   Outline for BIST
   ----------------------------------------------------------------------
   first off, how I think this thing is supposed to work is that we need a
   final flag signifying the BIST is successfully ran, and one where it fa-
   ils.
   uhhhhhh something's gotta happen here
   like:
   enable write data
   assign all 0s to addr 0x00-0x3F (using signals wr0_adr_in &
   wr0_dat_in)

   enable read data (rd0_enb_in)

   read addr 0x00-0x3f one at a time (rd0_adr_in/out and rd0_dat)

   after each read, write all 1s to each addr 0x00-0x3F
   ^^this happens after each read, so like, read data at 0x00, write all
   ones to 0x00, step forward to next address, 0x01 (process A)

   for each valid read of all 0s, save output in a 6-bit bus that counts
   up for each valid read or something

   now, step through the exact same read/write process but replacing
   all 1s with all 0s.

   read all 0s through same process (NO WRITE CHANGE THIS TIME)

   Now, write all 1s to each address 0x3F-0x00.
   repeat the process A, reading data at each address,replacing all 1s
   with all 0s for each address 0x3F-0x00, and keeping track of whether
   working or not.

   finally, read all 0s through same process (NO WRITE HERE EITHER)
   at the end, there's gotta be some kinda comparison where you check
   that the tests were valid for both ascending and descending runs.

   if both are valid, flag BIST_PASSED. if one of the runs is invalid,
   flag BIST_FAIL_UP, or BIST_FAIL_DOWN or both.

   */

   // outputs
   assign rd0_enb_out = (active) ? bist_rd0_enb : rd0_enb_in;
   assign rd0_adr_out = (active) ? bist_rd0_adr : rd0_adr_in;
   assign rd1_enb_out = (active) ? bist_rd1_enb : rd1_enb_in;
   assign rd1_adr_out = (active) ? bist_rd1_adr : rd1_adr_in;
   assign wr0_enb_out = (active) ? bist_wr0_enb : wr0_enb_in;
   assign wr0_adr_out = (active) ? bist_wr0_adr : wr0_adr_in;
   assign wr0_dat_out = (active) ? bist_wr0_dat : wr0_dat_in;
   //assign rd0_dat = (active) ? haven't done anything here yet

endmodule
