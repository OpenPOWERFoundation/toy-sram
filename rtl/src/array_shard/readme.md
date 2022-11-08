# ToySRAM 'shard'

* hard array is decomposed into custom/RTL macros:

   * partial components

      * 16x12 custom subarray
      * RTL for internal logic

   * full components (netlist-style)

      * 16x12 custom subarray
      * wordline decoder
      * local eval
      * i/o

## Compile

* 64x24 single array

```
# shard array, simple RTL
verilator --lint-only -I. -Wno-LITENDIAN regfile_shard_2r1w_64x24.v

# shard array, netlist
verilator --lint-only -I. -Wno-LITENDIAN -Wno-MULTITOP sky130_hd.v sky130_fd.v wordlines_comp.v regfile_shard_2r1w_64x24_comp.v
```

* 64x72 logical array

```
# logical array, simple shard
verilator --lint-only -I. -Wno-LITENDIAN -Wno-MULTITOP sky130_hd.v sky130_fd.v regfile_shard_2r1w_64x24_comp.v ra_64x72_2r1w.v

# logical array, netlist shard
verilator --lint-only -I. -Wno-LITENDIAN -Wno-MULTITOP sky130_hd.v sky130_fd.v wordlines_comp.v regfile_shard_2r1w_64x24_comp.v ra_64x72_2r1w_comp.v
```


