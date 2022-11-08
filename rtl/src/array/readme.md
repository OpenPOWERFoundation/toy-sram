# ToySRAM

* 64x24 behaviorals

## Compile

```
# full behavioral
verilator --lint-only -I. -Wno-LITENDIAN regfile_64x24_2r1w_behav.v
# split into subarrays
verilator --lint-only -I. -Wno-LITENDIAN regfile_64x24_2r1w.v
```
