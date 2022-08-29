# Custom Cell

### Prerequisites

* Magic (VERSION TODO) - Layout
* Xschem (VERSION TODO) - Schematic capture
* Netgen-lvs (VERSION TODO) - Layout Vs. Schematic
* Ngspice (VERSION TODO) - SPICE simulation

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

