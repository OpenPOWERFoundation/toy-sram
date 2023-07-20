# gdsfactory cell

```
# gen toysram_bit.gds
bit_v0.02.py 4.75,2.5
# extract
magic -dnull -noconsole -rcfile magic_extract_bit.tcl toysram_bit.gds
# irsim
magic -rcfile magic_irsim_bit.tcl toysram_bit.gds&
# lvs
netgen -batch lvs "toysram_bit.spice toysram_bit" "../xschem/10T_toy_xschem.spice 10T_toy_xschem" sky130A_setup.tcl netgen.log
# lef
magic -rcfile magic.tcl toysram_bit.gds
# console
select
lef write
```