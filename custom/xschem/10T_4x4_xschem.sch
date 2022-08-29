v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N -450 -300 -430 -300 {
lab=WWL_0}
N -450 -330 -450 -300 {
lab=WWL_0}
N -450 -330 -50 -330 {
lab=WWL_0}
N -50 -330 -50 -300 {
lab=WWL_0}
N -440 -180 -440 -150 {
lab=WWL_1}
N -440 -180 -40 -180 {
lab=WWL_1}
N -40 -180 -40 -150 {
lab=WWL_1}
N -430 -240 -50 -240 {
lab=RWL_0}
N -440 -90 -40 -90 {
lab=RWL_1}
N -430 -220 -50 -220 {
lab=RWL_0}
N -440 -70 -40 -70 {
lab=RWL_1}
N -100 -610 -100 -600 {
lab=VDD}
N -100 -540 -100 -530 {
lab=GND}
N 20 -1020 20 -1010 {
lab=WBL_1}
N 20 -950 20 -940 {
lab=GND}
N 20 -910 20 -900 {
lab=WBLb_1}
N 20 -840 20 -830 {
lab=GND}
N 20 -810 20 -800 {
lab=WWL_1}
N 20 -740 20 -730 {
lab=GND}
N 20 -700 20 -690 {
lab=RWL_1}
N 20 -630 20 -620 {
lab=GND}
N -430 -240 -430 -220 {
lab=RWL_0}
N -440 -90 -440 -70 {
lab=RWL_1}
N -560 -450 -560 -130 {
lab=WBL_0}
N -560 -130 -440 -130 {
lab=WBL_0}
N -560 -280 -430 -280 {
lab=WBL_0}
N -580 -420 -580 -110 {
lab=WBLb_0}
N -580 -110 -430 -110 {
lab=WBLb_0}
N -580 -260 -430 -260 {
lab=WBLb_0}
N -70 -460 -70 -130 {
lab=WBL_1}
N -70 -130 -40 -130 {
lab=WBL_1}
N -70 -280 -50 -280 {
lab=WBL_1}
N -90 -420 -90 -110 {
lab=WBLb_1}
N -90 -110 -40 -110 {
lab=WBLb_1}
N -90 -260 -50 -260 {
lab=WBLb_1}
N -130 -270 -120 -270 {
lab=RBL0_0}
N -120 -270 -120 10 {
lab=RBL0_0}
N -140 -120 -120 -120 {
lab=RBL0_0}
N -130 -250 -110 -250 {
lab=RBL1_0}
N -110 -250 -110 10 {
lab=RBL1_0}
N -140 -100 -110 -100 {
lab=RBL1_0}
N 250 -270 290 -270 {
lab=RBL0_1}
N 290 -270 290 -10 {
lab=RBL0_1}
N 260 -120 290 -120 {
lab=RBL0_1}
N 250 -250 270 -250 {
lab=RBL1_1}
N 270 -250 300 -250 {
lab=RBL1_1}
N 300 -250 300 10 {
lab=RBL1_1}
N 260 -100 300 -100 {
lab=RBL1_1}
N -120 0 -120 10 {
lab=RBL0_0}
C {10T_toy_xschem.sym} -280 -260 0 0 {name=x1 VDD=VDD GND=GND}
C {10T_toy_xschem.sym} -290 -110 0 0 {name=x2 VDD=VDD GND=GND}
C {10T_toy_xschem.sym} 110 -110 0 0 {name=x3 VDD=VDD GND=GND}
C {10T_toy_xschem.sym} 100 -260 0 0 {name=x4 VDD=VDD GND=GND}
C {devices/lab_pin.sym} -560 -450 0 0 {name=l3 sig_type=std_logic lab=WBL_0}
C {devices/lab_pin.sym} -70 -460 0 0 {name=l4 sig_type=std_logic lab=WBL_1}
C {devices/lab_pin.sym} -580 -420 0 0 {name=l6 sig_type=std_logic lab=WBLb_0}
C {devices/lab_pin.sym} -90 -420 0 0 {name=l7 sig_type=std_logic lab=WBLb_1}
C {devices/lab_pin.sym} -430 -240 0 0 {name=l17 sig_type=std_logic lab=RWL_0}
C {devices/lab_pin.sym} -440 -90 0 0 {name=l19 sig_type=std_logic lab=RWL_1}
C {devices/lab_pin.sym} -450 -320 0 0 {name=l21 sig_type=std_logic lab=WWL_0}
C {devices/lab_pin.sym} -440 -170 0 0 {name=l22 sig_type=std_logic lab=WWL_1}
C {devices/code_shown.sym} 370 -370 0 0 {name=NGSPICE
only_toplevel=true
place=end
value="
.tran 1ps 30ns
.save all

"}
C {devices/code.sym} 360 -530 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.lib $::SKYWATER_MODELS/sky130.lib.spice tt

"}
C {devices/vsource.sym} -100 -570 0 0 {name=V1 value=3}
C {devices/lab_pin.sym} -100 -610 0 0 {name=l23 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} -100 -530 0 0 {name=l24 sig_type=std_logic lab=GND}
C {devices/vsource.sym} 20 -980 0 0 {name=VWWL value="pwl 0ns 0V 5n 0.0v 5.1n 1.8v 10n 1.8v 10.1n 0v"}
C {devices/lab_pin.sym} 20 -1020 0 0 {name=l25 sig_type=std_logic lab=WBL_1}
C {devices/lab_pin.sym} 20 -940 0 0 {name=l26 sig_type=std_logic lab=GND}
C {devices/vsource.sym} 20 -870 0 0 {name=VWBL value="pwl 0ns 0V "}
C {devices/lab_pin.sym} 20 -830 0 0 {name=l27 sig_type=std_logic lab=GND}
C {devices/lab_pin.sym} 20 -730 0 0 {name=l28 sig_type=std_logic lab=GND}
C {devices/lab_pin.sym} 20 -620 0 0 {name=l29 sig_type=std_logic lab=GND}
C {devices/lab_pin.sym} 20 -910 0 0 {name=l30 sig_type=std_logic lab=WBLb_1}
C {devices/lab_pin.sym} 20 -810 0 0 {name=l31 sig_type=std_logic lab=WWL_1}
C {devices/lab_pin.sym} 20 -700 0 0 {name=l32 sig_type=std_logic lab=RWL_1}
C {devices/vsource.sym} 20 -770 0 0 {name=VWBLb value="pwl 0ns 0V "}
C {devices/vsource.sym} 20 -660 0 0 {name=VRWL0 value="pwl 0ns 0v"}
C {devices/vsource.sym} -160 -980 0 0 {name=VWWL1 value="pwl 0ns 0V 5n 0.0v 5.1n 1.8v 10n 1.8v 10.1n 0v"}
C {devices/vsource.sym} -160 -880 0 0 {name=VWBL1 value="pwl 0ns 0V "}
C {devices/vsource.sym} -160 -780 0 0 {name=VWBLb1 value="pwl 0ns 0V 4.9n 0.0v 5n 1.8v 9.9n 1.8v 10n 0v"}
C {devices/vsource.sym} -160 -680 0 0 {name=VRWL2 value="pwl 0ns 0V 10.5n 0v 10.6n 1.8v"}
C {devices/lab_pin.sym} -160 -1010 0 0 {name=l1 sig_type=std_logic lab=WBL_0}
C {devices/lab_pin.sym} -160 -910 0 0 {name=l2 sig_type=std_logic lab=WBLb_0}
C {devices/lab_pin.sym} -160 -950 0 0 {name=l5 sig_type=std_logic lab=GND}
C {devices/lab_pin.sym} -160 -850 0 0 {name=l8 sig_type=std_logic lab=GND}
C {devices/lab_pin.sym} -160 -750 0 0 {name=l18 sig_type=std_logic lab=GND}
C {devices/lab_pin.sym} -160 -650 0 0 {name=l20 sig_type=std_logic lab=GND}
C {devices/lab_pin.sym} -160 -810 0 0 {name=l35 sig_type=std_logic lab=WWL_0}
C {devices/lab_pin.sym} -160 -710 0 0 {name=l36 sig_type=std_logic lab=RWL_0}
C {devices/lab_pin.sym} -120 10 0 0 {name=l9 sig_type=std_logic lab=RBL0_0}
C {devices/lab_pin.sym} -110 10 2 0 {name=l10 sig_type=std_logic lab=RBL1_0}
C {devices/lab_pin.sym} 290 -10 0 0 {name=l11 sig_type=std_logic lab=RBL0_1}
C {devices/lab_pin.sym} 300 10 2 0 {name=l12 sig_type=std_logic lab=RBL1_1}
