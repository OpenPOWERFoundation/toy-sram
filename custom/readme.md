# Custom Cell Design

#### Prerequisites

* Magic (VERSION TODO) - Layout
* Xschem (VERSION TODO) - Schematic capture
* Netgen-lvs (VERSION TODO) - Layout Vs. Schematic
* Ngspice (VERSION TODO) - SPICE simulation

## 10T RAM Cell

* domino 10T 2R1W
   * domino background
      * clocked logic family (each gate has a clock)
         * clock low, 'precharge' -> node high
         * clock high, 'evaluate' -> node based on input(s), can only go low now
         * clock signal ensures critical path only traverses through cells during 'evaluate'
      * since only switches in one direction, no pmos pullups needed
         * effective transistor load is lower for previous stage
            * smaller circuit for given capacitance, or
            * stronger drive for given capacitance
            * faster since no pmos/nmos contention during switching
      * noninverting logic
         * each domino cell is a single-stage dynamic cell followed by an inverter
         * glitchless

<image src="./10T.png">

 * array
   * in cell, read is bottom of domino (evaluate)
   * subarray is 16x12 cells
   * 'local eval' is top of domino (precharge) and inverter (NAND2 between (2) subarrays)
   * (8) subarrays create 64wx24b 'hard' array
   * surrounding logical array does strobe/addr predecode and addr/data latching; (3) subarrays for 64x72_2R1W
   * DDR adds double in/out latches, early/late select, and DDR-compatible strobe

## Local Eval

* precharge
* 2:1 select

<image src="./local_eval.png">

* nand2 with precharge pmos pullups on RBL_R, RBL_R
* insert the pullups between p/n

### Precharge Pullup Only

* magic

   * load sky130_fd_sc_hd__inv_1 (open technology mgr)
   * ```gds``` in console
   * now have sky130_fd_sc__hd__inv_1.gds

* klayout sky130_fd_sc__hd__inv_1.gds
   * hack
   * check with ```magic -dnull -noconsole -rcfile magicdrc_pullup.tcl toysram_local_pullup.gds``` while hacking
   * drc clean with nfet side mostly removed; can't remove layer 81 (get drc);
   because i haven't removed bottom of cell yet (gnd, etc)?

* now stack these with 12x2 nands to make local_eval_stack


## Tools

```
cd xschem
export PDK_ROOT=/data/projects/open_pdks/sky130
# yikes! nfet references through current dir
ln -s $PDK_ROOT/sky130B/libs.tech/xschem/sky130_fd_pr sky130_fd_pr
xschem --rcfile $PDK_ROOT/sky130B/libs.tech/xschem/xschemrc 10T_toy_xschem.sch

xschem --rcfile $PDK_ROOT/sky130B/libs.tech/xschem/xschemrc local_eval.sch

```

```
cd magic
export PDK_ROOT=/data/projects/open_pdks/sky130
magic -rcfile .magic_tech/.magicrc 10T_toy_magic.mag
console:
'gds' creates gds
'lef writeall' creates lef


magic -rcfile .magic_tech/.magicrc local_eval.mag
# use options->cell mgr to select cell; then can see layout (top is (UNNAMED) at start)
# windows->set editable
# box upper pmos section and 'a' (select all)
# 'move up 50'
```


































### Setup
A template `.magicrc` file can be found in `magic/.magic_tech`. This
config file works with the SKY130 technology. Changes will need to be made to
the .magicrc file so that `PDK_ROOT` points to this repo. All the
relevant Magic tech files are also found in `magic/.magic_tech`.

The SKY130 model files are found in `sky130A/` which are used when
simulating a SPICE file in Ngspice.

A tcl script to generate SPICE from Magic layout can be found in
`magic/magic_spice_extract.tcl`. A tcl script to run LVS can be
found in `lvs/runlvs_single.sh`.

