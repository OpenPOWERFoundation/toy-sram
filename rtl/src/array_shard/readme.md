# ToySRAM 'shard'

* hard array is decomposed into custom/RTL macros:

   * full components (netlist-style, sky130)

      * 16x12 custom subarray
      * wordline decoder
      * local eval
      * i/o

## Compile

* 64x24 single array

```
verilator --lint-only -I. -Wno-LITENDIAN -Wno-MULTITOP sky130_hd.v sky130_fd.v wordlines_comp.v regfile_shard_64x24_2r1w_comp.v
```

* 64x72 logical array

```
# logical array, netlist shard
verilator --lint-only -I. -Wno-LITENDIAN -Wno-MULTITOP sky130_hd.v sky130_fd.v wordlines_comp.v regfile_shard_64x24_2r1w_comp.v ra_64x72_2r1w_comp.v
```


