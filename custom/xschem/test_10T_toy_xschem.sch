v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N -230 -210 -230 -200 {
lab=VDD}
N -230 -140 -230 -130 {
lab=GND}
N -110 -620 -110 -610 {
lab=WWL}
N -110 -550 -110 -540 {
lab=GND}
N -110 -510 -110 -500 {
lab=WBL}
N -110 -440 -110 -430 {
lab=GND}
N -110 -410 -110 -400 {
lab=WBLb}
N -110 -340 -110 -330 {
lab=GND}
N -110 -300 -110 -290 {
lab=RWL0}
N -110 -230 -110 -220 {
lab=GND}
N -110 -200 -110 -190 {
lab=RWL0}
N -110 -130 -110 -120 {
lab=RWL1}
N -150 -40 -140 -40 {
lab=WWL}
N -150 -20 -140 -20 {
lab=WBL}
N -150 -0 -140 0 {
lab=WBLb}
N -150 20 -140 20 {
lab=RWL0}
N -150 40 -140 40 {
lab=RWL1}
N 160 -10 170 -10 {
lab=RBL0}
N 160 10 170 10 {
lab=RBL1}
C {devices/vsource.sym} -230 -170 0 0 {name=V1 value=3}
C {devices/lab_pin.sym} -150 -40 0 0 {name=l1 sig_type=std_logic lab=WWL}
C {devices/lab_pin.sym} -150 -20 0 0 {name=l2 sig_type=std_logic lab=WBL}
C {devices/lab_pin.sym} -150 0 0 0 {name=l3 sig_type=std_logic lab=WBLb}
C {devices/lab_pin.sym} -150 20 0 0 {name=l4 sig_type=std_logic lab=RWL0}
C {devices/lab_pin.sym} -150 40 0 0 {name=l5 sig_type=std_logic lab=RWL1}
C {devices/lab_pin.sym} 170 -10 0 1 {name=l6 sig_type=std_logic lab=RBL0}
C {devices/lab_pin.sym} 170 10 0 1 {name=l7 sig_type=std_logic lab=RBL1}
C {devices/lab_pin.sym} -230 -210 0 0 {name=l8 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} -230 -130 0 0 {name=l9 sig_type=std_logic lab=GND}
C {devices/vsource.sym} -110 -580 0 0 {name=VWWL value="pwl 0ns 0V 4.9ns 0V 5ns 1.8V 9.9ns 1.8V 10ns 0V 19.9ns 0V 20ns 1.8V 24.9ns 1.8V 25ns 0V"}
C {devices/lab_pin.sym} -110 -620 0 0 {name=l10 sig_type=std_logic lab=WWL}
C {devices/lab_pin.sym} -110 -540 0 0 {name=l11 sig_type=std_logic lab=GND}
C {devices/vsource.sym} -110 -470 0 0 {name=VWBL value="pwl 0ns 0V 4.9ns 0V 5ns 1.8V 9.9ns 1.8V 10ns 0V 19.9ns 0V 20ns 0V 24.9ns 0V 25ns 0V"}
C {devices/lab_pin.sym} -110 -430 0 0 {name=l13 sig_type=std_logic lab=GND}
C {devices/lab_pin.sym} -110 -330 0 0 {name=l15 sig_type=std_logic lab=GND}
C {devices/lab_pin.sym} -110 -220 0 0 {name=l17 sig_type=std_logic lab=GND}
C {devices/vsource.sym} -110 -160 0 0 {name=VRWL1 value=0V}
C {devices/lab_pin.sym} -110 -510 0 0 {name=l12 sig_type=std_logic lab=WBL}
C {devices/lab_pin.sym} -110 -410 0 0 {name=l14 sig_type=std_logic lab=WBLb}
C {devices/lab_pin.sym} -110 -300 0 0 {name=l16 sig_type=std_logic lab=RWL0}
C {devices/lab_pin.sym} -110 -120 0 0 {name=l18 sig_type=std_logic lab=RWL1}
C {devices/vsource.sym} -110 -370 0 0 {name=VWBLb value="pwl 0ns 0V 4.9ns 0V 5ns 0.0V 9.9ns 0.0V 10ns 0V 19.9ns 0V 20ns 1.8V 24.9ns 1.8V 25ns 0V"}
C {devices/vsource.sym} -110 -260 0 0 {name=VRWL0 value="pwl 0ns 0V 4.9ns 0V 5ns 0.0V 9.9ns 0.0V 10ns 1.8V 19.9ns 1.8V 20ns 0.0V 24.9ns 0.0V 25ns 1.8V"}
C {devices/lab_pin.sym} -110 -200 0 0 {name=l19 sig_type=std_logic lab=RWL0}
C {devices/code_shown.sym} 250 -30 0 0 {name=NGSPICE
only_toplevel=true
place=end
value="
.tran 1ps 30ns

.print DC V(WWL) V(RBL0) V(RBL1) V(RWL0) V(RWL1) V(RBL) V(RBLb)
.print tran V(WWL) V(RBL0) V(RBL1) V(RWL0) V(RWL1) V(RBL) V(RBLb)
.probe V(WWL) V(RBL0) V(RBL1) V(RWL0) V(RWL1) V(RBL) V(RBLb)
.op
"}
C {devices/code.sym} 240 -190 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.lib $::SKYWATER_MODELS/sky130.lib.spice tt

"}
C {10T_toy_xschem.sym} 10 0 0 0 {name=x1 VDD=VDD GND=GND}
