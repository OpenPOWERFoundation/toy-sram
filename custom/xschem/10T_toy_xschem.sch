v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
T {INV1} -10 -120 0 0 0.3 0.3 {}
T {INV2} -10 50 0 0 0.3 0.3 {}
T {left_N} -170 -110 0 0 0.3 0.3 {}
T {right_N} 150 -100 0 0 0.3 0.3 {}
T {Bot_left_N} -280 50 0 0 0.3 0.3 {}
T {Bot_right_N} 270 50 0 0 0.3 0.3 {}
T {Top_right_N} 260 -230 0 0 0.3 0.3 {}
T {Top_left_N} -290 -240 0 0 0.3 0.3 {}
N 40 -70 90 -70 {
lab=#net1}
N 40 20 60 20 {
lab=#net1}
N 60 -70 60 20 {
lab=#net1}
N -90 -70 -40 -70 {
lab=#net2}
N -60 -70 -60 20 {
lab=#net2}
N -60 20 -40 20 {
lab=#net2}
N -160 -70 -150 -70 {
lab=WBL}
N 150 -70 170 -70 {
lab=WBLb}
N -120 -140 -120 -110 {
lab=WWL}
N 120 -140 120 -110 {
lab=WWL}
N -120 -140 120 -140 {
lab=WWL}
N 120 -140 140 -140 {
lab=WWL}
N 60 20 180 20 {
lab=#net1}
N 180 20 200 20 {
lab=#net1}
N -180 20 -60 20 {
lab=#net2}
N -220 -130 -220 -10 {
lab=#net3}
N 240 -130 240 -10 {
lab=#net4}
N -180 -190 -160 -190 {
lab=RWL0}
N 180 -190 200 -190 {
lab=RWL1}
N -220 -160 -220 -130 {
lab=#net3}
N 240 -160 240 -130 {
lab=#net4}
N -220 -260 -220 -220 {
lab=RBL0}
N 240 -260 240 -220 {
lab=RBL1}
N 240 50 240 80 {
lab=GND}
N -220 50 -220 80 {
lab=GND}
N -230 20 -220 20 {
lab=GND}
N 240 20 250 20 {
lab=GND}
N 240 -190 250 -190 {
lab=GND}
N -230 -190 -220 -190 {
lab=GND}
C {INVX1.sym} 0 -70 0 0 {name=x1 VDD=VDD GND=GND}
C {INVX1.sym} 0 20 0 1 {name=x2 VDD=VDD GND=GND}
C {sky130_fd_pr/nfet_01v8.sym} -120 -90 1 0 {name=M1
L=0.15
W=0.14
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 120 -90 1 0 {name=M2
L=0.15
W=0.14
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} -200 20 0 1 {name=M3
L=0.15
W=0.14
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} -200 -190 0 1 {name=M4
L=0.15
W=0.21
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 220 20 0 0 {name=M5
L=0.15
W=0.14
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 220 -190 0 0 {name=M6
L=0.15
W=0.21
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {devices/lab_pin.sym} 170 -70 0 1 {name=l1 sig_type=std_logic lab=WBLb}
C {devices/lab_pin.sym} -160 -70 0 0 {name=l2 sig_type=std_logic lab=WBL}
C {devices/lab_pin.sym} 140 -140 0 1 {name=l3 sig_type=std_logic lab=WWL}
C {devices/lab_pin.sym} -160 -190 0 1 {name=l4 sig_type=std_logic lab=RWL0}
C {devices/lab_pin.sym} 180 -190 0 0 {name=l5 sig_type=std_logic lab=RWL1}
C {devices/lab_pin.sym} -220 -260 0 0 {name=l6 sig_type=std_logic lab=RBL0}
C {devices/lab_pin.sym} 240 -260 0 1 {name=l7 sig_type=std_logic lab=RBL1}
C {devices/lab_pin.sym} -220 80 0 0 {name=l8 sig_type=std_logic lab=GND}
C {devices/lab_pin.sym} 240 80 0 1 {name=l9 sig_type=std_logic lab=GND}
C {devices/lab_pin.sym} 250 20 0 1 {name=l10 sig_type=std_logic lab=GND}
C {devices/lab_pin.sym} 250 -190 0 1 {name=l11 sig_type=std_logic lab=GND}
C {devices/lab_pin.sym} 120 -70 1 1 {name=l12 sig_type=std_logic lab=GND}
C {devices/lab_pin.sym} -120 -70 1 1 {name=l13 sig_type=std_logic lab=GND}
C {devices/lab_pin.sym} -230 -190 2 1 {name=l14 sig_type=std_logic lab=GND}
C {devices/lab_pin.sym} -230 20 2 1 {name=l15 sig_type=std_logic lab=GND}
C {devices/ipin.sym} -30 -370 0 0 {name=p1 lab=WWL}
C {devices/ipin.sym} -30 -290 0 0 {name=p2 lab=RWL0}
C {devices/ipin.sym} -30 -270 0 0 {name=p3 lab=RWL1}
C {devices/ipin.sym} -30 -340 0 0 {name=p4 lab=WBL}
C {devices/ipin.sym} -30 -320 0 0 {name=p5 lab=WBLb}
C {devices/opin.sym} 80 -340 0 0 {name=p6 lab=RBL0}
C {devices/opin.sym} 80 -320 0 0 {name=p7 lab=RBL1}
