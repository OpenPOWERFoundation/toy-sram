# General Notes

## SDR/DDR

* logical wrappers instantiate hard array 
* SDR: use multiple hard array instances to add ports
* DDR: use early/late pulses to double read/write ports 

### DDR Implementation

* strobes are generated from clk based on configurable delay parameters

## Test site arrays

* 2R1W, SDR - this is the sdr hard array and simple logical wrapper using single clock
* 4R2W, DDR - this is the ddr hard array and double-rate logical wrapper generating early/late pulses

### Configuration options

* SDR clock frequency (external to logical array)
* DDR clock frequency (external to logical array)

* SDR Pulse Control
* DDR Pulse Control

