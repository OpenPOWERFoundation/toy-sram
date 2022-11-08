# Cocotb + Icarus Verilog Array Sim

## Array Wrapper

* two versions
   * Makefile_64x72 (behavioral-only)
   * Makefile_64x72_shard (behavioral, netlist-style RTL)

* compile and run

```
make RANDOM_SEED=8675309 -f Makefile_64x72_shard build
gtkwave tb_ra_64x72.fst ra_64x72_2r1w.gtkw
```

* just run

```
make -f Makefile_64x72_shard
```

* results

```
MODULE=tb_ra_64x72 TESTCASE=tb TOPLEVEL=tb_ra_64x72_2r1w TOPLEVEL_LANG=verilog \
         /usr/local/bin/vvp -M /home/wtf/.local/lib/python3.10/site-packages/cocotb/libs -m libcocotbvpi_icarus   sim_build/sim.vvp
     -.--ns INFO     gpi                                ..mbed/gpi_embed.cpp:76   in set_program_name_in_venv        Did not detect Python virtual environment. Using system-wide Python interpreter
     -.--ns INFO     gpi                                ../gpi/GpiCommon.cpp:101  in gpi_print_registered_impl       VPI registered
     0.00ns INFO     cocotb                             Running on Icarus Verilog version 12.0 (devel)
     0.00ns INFO     cocotb                             Running tests with cocotb v1.7.1 from /home/wtf/.local/lib/python3.10/site-packages/cocotb
     0.00ns INFO     cocotb                             Seeding Python random module with supplied seed 8675309
     0.00ns INFO     cocotb.regression                  Found test tb_ra_64x72.tb
     0.00ns INFO     cocotb.regression                  running tb (1/1)
                                                          ToySRAM 64x72 array test
     0.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000001] Resetting...
     9.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000010] Releasing reset.
    25.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000027] Initializing array...
    25.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000027] Port=0 WR @00=005555555555555500
    26.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000028] Port=0 WR @01=015555555555555501
    27.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000029] Port=0 WR @02=025555555555555502
    28.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000030] Port=0 WR @03=035555555555555503
    29.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000031] Port=0 WR @04=045555555555555504
    30.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000032] Port=0 WR @05=055555555555555505
    31.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000033] Port=0 WR @06=065555555555555506
    32.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000034] Port=0 WR @07=075555555555555507
    33.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000035] Port=0 WR @08=085555555555555508
    34.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000036] Port=0 WR @09=095555555555555509
    35.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000037] Port=0 WR @0A=0A555555555555550A
    36.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000038] Port=0 WR @0B=0B555555555555550B
    37.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000039] Port=0 WR @0C=0C555555555555550C
    38.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000040] Port=0 WR @0D=0D555555555555550D
    39.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000041] Port=0 WR @0E=0E555555555555550E
    40.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000042] Port=0 WR @0F=0F555555555555550F
    41.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000043] Port=0 WR @10=105555555555555510
    42.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000044] Port=0 WR @11=115555555555555511
    43.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000045] Port=0 WR @12=125555555555555512
    44.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000046] Port=0 WR @13=135555555555555513
    45.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000047] Port=0 WR @14=145555555555555514
    46.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000048] Port=0 WR @15=155555555555555515
    47.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000049] Port=0 WR @16=165555555555555516
    48.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000050] Port=0 WR @17=175555555555555517
    49.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000051] Port=0 WR @18=185555555555555518
    50.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000052] Port=0 WR @19=195555555555555519
    51.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000053] Port=0 WR @1A=1A555555555555551A
    52.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000054] Port=0 WR @1B=1B555555555555551B
    53.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000055] Port=0 WR @1C=1C555555555555551C
    54.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000056] Port=0 WR @1D=1D555555555555551D
    55.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000057] Port=0 WR @1E=1E555555555555551E
    56.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000058] Port=0 WR @1F=1F555555555555551F
    57.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000059] Port=0 WR @20=205555555555555520
    58.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000060] Port=0 WR @21=215555555555555521
    59.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000061] Port=0 WR @22=225555555555555522
    60.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000062] Port=0 WR @23=235555555555555523
    61.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000063] Port=0 WR @24=245555555555555524
    62.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000064] Port=0 WR @25=255555555555555525
    63.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000065] Port=0 WR @26=265555555555555526
    64.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000066] Port=0 WR @27=275555555555555527
    65.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000067] Port=0 WR @28=285555555555555528
    66.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000068] Port=0 WR @29=295555555555555529
    67.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000069] Port=0 WR @2A=2A555555555555552A
    68.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000070] Port=0 WR @2B=2B555555555555552B
    69.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000071] Port=0 WR @2C=2C555555555555552C
    70.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000072] Port=0 WR @2D=2D555555555555552D
    71.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000073] Port=0 WR @2E=2E555555555555552E
    72.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000074] Port=0 WR @2F=2F555555555555552F
    73.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000075] Port=0 WR @30=305555555555555530
    74.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000076] Port=0 WR @31=315555555555555531
    75.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000077] Port=0 WR @32=325555555555555532
    76.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000078] Port=0 WR @33=335555555555555533
    77.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000079] Port=0 WR @34=345555555555555534
    78.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000080] Port=0 WR @35=355555555555555535
    79.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000081] Port=0 WR @36=365555555555555536
    80.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000082] Port=0 WR @37=375555555555555537
    81.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000083] Port=0 WR @38=385555555555555538
    82.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000084] Port=0 WR @39=395555555555555539
    83.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000085] Port=0 WR @3A=3A555555555555553A
    84.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000086] Port=0 WR @3B=3B555555555555553B
    85.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000087] Port=0 WR @3C=3C555555555555553C
    86.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000088] Port=0 WR @3D=3D555555555555553D
    87.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000089] Port=0 WR @3E=3E555555555555553E
    88.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000090] Port=0 WR @3F=3F555555555555553F
    89.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000091] Running random commands...
    89.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00000091] Port=0 WR @29=9BFB82E63586CCC8C7
    90.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00000092] Port=0 WR @1C=23C37F63E32FE18FAE
    90.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00000092] Port=0 RD @0D
    91.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00000093] Port=0 RD @1E
    91.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00000093] Port=1 RD @05
    92.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00000094] * RD COMPARE * port=0 adr=0D act=0D555555555555550D exp=0D555555555555550D
    92.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00000094] Port=0 RD @32
    93.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00000095] * RD COMPARE * port=0 adr=1E act=1E555555555555551E exp=1E555555555555551E
    93.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00000095] * RD COMPARE * port=1 adr=05 act=055555555555555505 exp=055555555555555505
    93.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00000095] Port=0 WR @0F=AC194AC63383A4B51D
    94.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00000096] * RD COMPARE * port=0 adr=32 act=325555555555555532 exp=325555555555555532
    95.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00000097] Port=1 RD @0C
    96.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00000098] Port=0 WR @34=84DC7761056CBA5416
    96.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00000098] Port=0 RD @2C
    96.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00000098] Port=1 RD @0A
    97.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00000099] * RD COMPARE * port=1 adr=0C act=0C555555555555550C exp=0C555555555555550C
    97.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00000099] Port=0 WR @35=C827951DD9AF778AA6
    98.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00000100] ...tick...
...

 50067.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050069] * RD COMPARE * port=1 adr=1A act=BD0918D335EAE57EB8 exp=BD0918D335EAE57EB8
 50067.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050069] Port=0 RD @2D
 50067.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050069] Port=1 RD @3C
 50068.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050070] Port=0 RD @03
 50069.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050071] * RD COMPARE * port=0 adr=2D act=DD22A03EC8ECED56A5 exp=DD22A03EC8ECED56A5
 50069.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050071] * RD COMPARE * port=1 adr=3C act=E2D4702C0CFAF156D5 exp=E2D4702C0CFAF156D5
 50069.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050071] Port=0 WR @27=2912D1F5B60C23A494
 50069.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050071] Port=0 RD @2B
 50070.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050072] * RD COMPARE * port=0 adr=03 act=37E14D57DAA64D10D7 exp=37E14D57DAA64D10D7
 50070.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050072] Port=0 RD @01
 50071.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050073] * RD COMPARE * port=0 adr=2B act=2637DB380BED8B3991 exp=2637DB380BED8B3991
 50071.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050073] Port=0 WR @17=EC8135D0A0CE1AF036
 50072.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050074] * RD COMPARE * port=0 adr=01 act=BAD2EFF3CF3A88BEF4 exp=BAD2EFF3CF3A88BEF4
 50072.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050074] Port=0 WR @3E=DABCF1EB8186F007B4
 50072.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050074] Port=0 RD @06
 50073.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050075] Port=0 RD @2D
 50074.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050076] * RD COMPARE * port=0 adr=06 act=119CDD1F186BC31FAC exp=119CDD1F186BC31FAC
 50074.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050076] Port=0 WR @0E=F4852272F5E53D788B
 50074.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050076] Port=1 RD @1F
 50075.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050077] * RD COMPARE * port=0 adr=2D act=DD22A03EC8ECED56A5 exp=DD22A03EC8ECED56A5
 50075.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050077] Port=0 RD @28
 50076.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050078] * RD COMPARE * port=1 adr=1F act=DE5FE08C9855989C00 exp=DE5FE08C9855989C00
 50076.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050078] Port=0 WR @13=F5B2F5D804B13021B0
 50077.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050079] * RD COMPARE * port=0 adr=28 act=B867B78554C2B54D81 exp=B867B78554C2B54D81
 50077.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050079] Port=0 WR @2A=83BA688D6465DCDB94
 50079.50ns INFO     cocotb.tb_ra_64x72_2r1w            [00050081] Quiescing...
 50089.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00050091] Done.
 50089.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00050091] Final State

Reads Port 0:  19885
Reads Port 1:  19982
Writes Port 0: 19944
 50089.00ns INFO     cocotb.tb_ra_64x72_2r1w            [00050091] You has opulence.
 50089.00ns INFO     cocotb.regression                  tb passed
 50089.00ns INFO     cocotb.regression                  **************************************************************************************
                                                        ** TEST                          STATUS  SIM TIME (ns)  REAL TIME (s)  RATIO (ns/s) **
                                                        **************************************************************************************
                                                        ** tb_ra_64x72.tb                 PASS       50089.00          57.99        863.71  **
                                                        **************************************************************************************
                                                        ** TESTS=1 PASS=1 FAIL=0 SKIP=0              50089.00          58.21        860.44  **
                                                        **************************************************************************************

```