# Functional verification of array and site logic

### CURRENT (cocotb+iverilog)

* using cocotb instead of pyverilator [cocotb sim](./coco)


### OLD (pyverilator)

## check rtl

```
verilator --lint-only -Isrc -Wno-LITENDIAN src/test_ra_sdr.v
```

### build/sim

***not working at all with verilator v4.210***

```
sim -m sdr -c 1000 -t
```
