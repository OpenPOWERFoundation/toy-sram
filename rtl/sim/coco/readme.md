# Cocotb + Icarus Verilog Array Sim

Cocotb test created from original pyverilator version - run random commands using 64x72 logical array.

## Array Wrapper

* compile and run

```
make -f Makefile_sdr_32x32 build

```

* just run (tb.py changes, etc.)

```
make -f Makefile_sdr_32x32 run

```

* results

```
make -f Makefile_sdr_32x32 run >& sim_32x32.txt

MODULE=tb TESTCASE=tb_32x32 TOPLEVEL=test_ra_sdr_32x32 TOPLEVEL_LANG=verilog \
         /usr/local/bin/vvp -M /home/wtf/.local/lib/python3.8/site-packages/cocotb/libs -m libcocotbvpi_icarus   build_32x32/sim.vvp
     -.--ns INFO     cocotb.gpi                         ..mbed/gpi_embed.cpp:76   in set_program_name_in_venv        Did not detect Python virtual environment. Using system-wide Python interpreter
     -.--ns INFO     cocotb.gpi                         ../gpi/GpiCommon.cpp:99   in gpi_print_registered_impl       VPI registered
     0.00ns INFO     Running on Icarus Verilog version 12.0 (devel)
     0.00ns INFO     Running tests with cocotb v1.7.0.dev0 from /home/wtf/.local/lib/python3.8/site-packages/cocotb
     0.00ns INFO     Seeding Python random module with 1654704020
     0.00ns INFO     Found test tb.tb_32x32
     0.00ns INFO     running tb_32x32 (1/0)
                       ToySRAM 32x32 array test
     0.00ns INFO     [00000001] [00000001] Resetting...
     9.00ns INFO     [00000010] [00000010] Releasing reset.
    25.00ns INFO     [00000027] Initializing array...
    25.00ns INFO     [00000027] Port=0 WR @00=00555500
    26.00ns INFO     [00000028] Port=0 WR @01=01555501
    27.00ns INFO     [00000029] Port=0 WR @02=02555502
    28.00ns INFO     [00000030] Port=0 WR @03=03555503
    29.00ns INFO     [00000031] Port=0 WR @04=04555504
    30.00ns INFO     [00000032] Port=0 WR @05=05555505
    31.00ns INFO     [00000033] Port=0 WR @06=06555506
    32.00ns INFO     [00000034] Port=0 WR @07=07555507
    33.00ns INFO     [00000035] Port=0 WR @08=08555508
...
 10037.50ns INFO     [00010039] Port=0 WR @12=6C6FD11E
 10038.50ns INFO     [00010040] Port=0 WR @17=545B517F
 10039.50ns INFO     [00010041] Port=0 RD @08
 10039.50ns INFO     [00010041] Port=1 RD @0E
 10041.50ns INFO     [00010043] * RD COMPARE * port=0 adr=08 act=BE99B13E exp=BE99B13E
 10041.50ns INFO     [00010043] * RD COMPARE * port=1 adr=0E act=97A2D496 exp=97A2D496
 10041.50ns INFO     [00010043] Port=0 WR @1A=76434F37
 10041.50ns INFO     [00010043] Port=1 RD @0D
 10042.50ns INFO     [00010044] Port=0 WR @12=069ECCCE
 10042.50ns INFO     [00010044] Port=0 RD @13
 10043.50ns INFO     [00010045] * RD COMPARE * port=1 adr=0D act=C1C0D7D8 exp=C1C0D7D8
 10043.50ns INFO     [00010045] Port=0 WR @05=58E318E7
 10043.50ns INFO     [00010045] Port=0 RD @10
 10043.50ns INFO     [00010045] Port=1 RD @00
 10044.50ns INFO     [00010046] * RD COMPARE * port=0 adr=13 act=1D975E90 exp=1D975E90
 10044.50ns INFO     [00010046] Port=0 RD @14
 10044.50ns INFO     [00010046] Port=1 RD @1D
 10045.50ns INFO     [00010047] * RD COMPARE * port=0 adr=10 act=F82AB140 exp=F82AB140
 10045.50ns INFO     [00010047] * RD COMPARE * port=1 adr=00 act=3C2E724D exp=3C2E724D
 10046.50ns INFO     [00010048] * RD COMPARE * port=0 adr=14 act=1A27AA07 exp=1A27AA07
 10046.50ns INFO     [00010048] * RD COMPARE * port=1 adr=1D act=5B9AE71C exp=5B9AE71C
 10047.50ns INFO     [00010049] Quiescing...
 10057.00ns INFO     [00010059] Done.
 10057.00ns INFO     [00010059] Final State

Reads Port 0:  4005
Reads Port 1:  4052
Writes Port 0: 4055
 10057.00ns INFO     [00010059] [00010059] You has opulence.
 10057.00ns INFO     tb_32x32 passed
 10057.00ns INFO     **************************************************************************************
                     ** TEST                          STATUS  SIM TIME (ns)  REAL TIME (s)  RATIO (ns/s) **
                     **************************************************************************************
                     ** tb.tb_32x32                    PASS       10057.00           8.54       1177.70  **
                     **************************************************************************************
                     ** TESTS=0 PASS=1 FAIL=0 SKIP=0              10057.00           8.56       1174.42  **
                     **************************************************************************************

VCD info: dumpfile test_ra_sdr_32x32.vcd opened for output.
VCD warning: $dumpvars: Package ($unit) is not dumpable with VCD.
make[1]: Leaving directory '/media/wtf/WD_USBC_4T/projects/toy-sram/rtl/sim/coco'
vcd2fst test_ra_sdr_32x32.vcd test_ra_sdr_32x32.fst
#rm test_ra_sdr_32x32.vcd

```

```
gtkwave test_ra_sdr_32x32.fst wtf_test_ra_sdr_32x32.gtkw
```

## Test Site

* compile and run

```
make -f Makefile_site build

```

* just run (tb.py changes, etc.)

```
make -f Makefile_site run

```

* results

```
     0.00ns INFO     Running on Icarus Verilog version 12.0 (devel)
     0.00ns INFO     Running tests with cocotb v1.7.0.dev0 from /home/wtf/.local/lib/python3.8/site-packages/cocotb
     0.00ns INFO     Seeding Python random module with 1655136638
     0.00ns INFO     Found test tb.tb_site
     0.00ns INFO     running tb_site (1/0)
                       ToySRAM site test
VCD info: dumpfile test_site.vcd opened for output.
VCD warning: $dumpvars: Package ($unit) is not dumpable with VCD.
     0.00ns INFO     [00000001] Resetting...
     9.00ns INFO     [00000010] Releasing reset.
    15.00ns INFO     [00000017] Writing Port 0 @00100000 00=633212F3
    17.00ns INFO     [00000019] Reading Port 0 @00100000 00
    22.00ns INFO     [00000024] Read Data: 633212F3
    22.00ns INFO     [00000024] Writing Port 0 @00100001 01=6A0278C9
    24.00ns INFO     [00000026] Reading Port 0 @00100001 01
    29.00ns INFO     [00000031] Read Data: 6A0278C9
...
  1769.00ns INFO     [00001770] Writing W0@15=08675309...
  1769.00ns INFO     [00001770] Scanning in...
  1798.00ns INFO     [00001800] ...tick...
  1898.00ns INFO     [00001900] ...tick...
  1998.00ns INFO     [00002000] ...tick...
  2075.00ns INFO     [00002076] Blipping RA0 clk...
  2098.00ns INFO     [00002100] ...tick...
  2175.00ns INFO     [00002176] Reading R0@15, R1@16...
  2175.00ns INFO     [00002176] Scanning in...
  2198.00ns INFO     [00002200] ...tick...
  2298.00ns INFO     [00002300] ...tick...
  2398.00ns INFO     [00002400] ...tick...
  2481.00ns INFO     [00002482] Blipping RA0 clk...
  2498.00ns INFO     [00002500] ...tick...
  2581.00ns INFO     [00002582] Blipping RA0 clk...
  2598.00ns INFO     [00002600] ...tick...
  2681.00ns INFO     [00002682] Blipping RA0 clk...
  2698.00ns INFO     [00002700] ...tick...
  2781.00ns INFO     [00002782] Scanning out...
  2798.00ns INFO     [00002800] ...tick...
  2898.00ns INFO     [00002900] ...tick...
  2998.00ns INFO     [00003000] ...tick...
  3035.00ns INFO     [00003036] ScanData=78433A984C075227A100000000000000
  3035.00ns INFO     [00003036]  r0 adr:0F
  3035.00ns INFO     [00003036]  r0 dat:08675309
  3035.00ns INFO     [00003036]  r1 adr:10
  3035.00ns INFO     [00003036]  r1 dat:1D489E84
  3035.00ns INFO     [00003036]  w0 adr:00
  3035.00ns INFO     [00003036]  w0 dat:00000000
  3035.00ns INFO     [00003036]     cfg:00000
  3035.00ns INFO     [00003036] Done
  3044.00ns INFO     tb_site passed
  3044.00ns INFO     **************************************************************************************
                     ** TEST                          STATUS  SIM TIME (ns)  REAL TIME (s)  RATIO (ns/s) **
                     **************************************************************************************
                     ** tb.tb_site                     PASS        3044.00           0.87       3517.25  **
                     **************************************************************************************
                     ** TESTS=0 PASS=1 FAIL=0 SKIP=0               3044.00           0.89       3420.87  **
                     **************************************************************************************
```