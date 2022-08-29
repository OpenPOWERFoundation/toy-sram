v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
T {INV_0} 0 85 0 1 0.5 0.5 { hcenter=true}
T {INV_1} 0 -185 0 0 0.5 0.5 { hcenter=true}
N 0 200 0 240 {
lab=left_net}
N 40 170 40 270 {
lab=right_net}
N 0 300 0 320 {
lab=VGND}
N 0 120 0 140 {
lab=VPWR}
N -20 270 0 270 {
lab=VGND}
N -20 170 0 170 {
lab=PWELL}
N 0 -70 0 -30 {
lab=right_net}
N -40 -100 -40 0 {
lab=left_net}
N 0 30 0 50 {
lab=VGND}
N 0 -150 0 -130 {
lab=VPWR}
N 0 0 20 0 {
lab=VGND}
N 0 -100 20 -100 {
lab=PWELL}
N -60 220 0 220 {
lab=left_net}
N 0 -50 60 -50 {
lab=right_net}
N 40 220 120 220 {
lab=right_net}
N 120 -50 120 220 {
lab=right_net}
N 60 -50 120 -50 {
lab=right_net}
N -100 220 -60 220 {
lab=left_net}
N -100 -50 -40 -50 {
lab=left_net}
N -100 -50 -100 220 {
lab=left_net}
N -260 10 -260 160 {
lab=left_net}
N -260 220 -260 270 {
lab=bit_v}
N -370 -20 -370 190 {
lab=WL1}
N -370 -20 -300 -20 {
lab=WL1}
N -370 190 -300 190 {
lab=WL1}
N 270 0 270 150 {
lab=right_net}
N 270 210 270 260 {
lab=bit_b_v}
N 380 -30 380 180 {
lab=WL2}
N 310 -30 380 -30 {
lab=WL2}
N 310 180 380 180 {
lab=WL2}
N -260 190 -240 190 {
lab=VGND}
N -260 -20 -240 -20 {
lab=PWELL}
N 250 180 270 180 {
lab=VGND}
N 250 -30 270 -30 {
lab=PWELL}
N 120 70 270 70 {
lab=right_net}
N 260 -0 270 0 {
lab=right_net}
N 260 -60 260 -0 {
lab=right_net}
N 260 -60 270 -60 {
lab=right_net}
N -260 100 -100 100 {
lab=left_net}
N -260 10 -250 10 {
lab=left_net}
N -250 -50 -250 10 {
lab=left_net}
N -260 -50 -250 -50 {
lab=left_net}
C {sky130_fd_pr/nfet_01v8.sym} 20 270 0 1 {name=Mnpd_1
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
C {sky130_fd_pr/pfet_01v8.sym} 20 170 0 1 {name=Mppu_2
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
model=pfet_01v8
spiceprefix=X
}
C {devices/ipin.sym} 0 -330 0 0 {name=p1 lab=VPWR}
C {devices/ipin.sym} 0 -310 0 0 {name=p2 lab=VGND}
C {devices/lab_pin.sym} 0 120 0 1 {name=l1 sig_type=std_logic lab=VPWR}
C {devices/lab_pin.sym} 0 320 0 1 {name=l2 sig_type=std_logic lab=VGND}
C {devices/lab_pin.sym} -20 270 0 0 {name=l3 sig_type=std_logic lab=VSUBS}
C {devices/lab_pin.sym} -20 170 0 0 {name=l4 sig_type=std_logic lab=PWELL}
C {sky130_fd_pr/nfet_01v8.sym} -20 0 0 0 {name=Mnpd_0
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
C {sky130_fd_pr/pfet_01v8.sym} -20 -100 0 0 {name=Mppu_1
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
model=pfet_01v8
spiceprefix=X
}
C {devices/lab_pin.sym} 0 -150 0 0 {name=l5 sig_type=std_logic lab=VPWR}
C {devices/lab_pin.sym} 0 50 0 0 {name=l6 sig_type=std_logic lab=VGND}
C {devices/lab_pin.sym} 20 0 0 1 {name=l7 sig_type=std_logic lab=VSUBS}
C {devices/lab_pin.sym} 20 -100 0 1 {name=l8 sig_type=std_logic lab=PWELL}
C {devices/lab_pin.sym} 380 80 0 1 {name=l10 sig_type=std_logic lab=WL2}
C {sky130_fd_pr/nfet_01v8.sym} -280 190 0 0 {name=Mnpass_1
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
C {devices/lab_pin.sym} -260 270 0 0 {name=l12 sig_type=std_logic lab=bit_v}
C {sky130_fd_pr/pfet_01v8.sym} -280 -20 0 0 {name=Mppu_3
L=0.025
W=0.14
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 290 180 0 1 {name=Mnpass_0
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
C {devices/lab_pin.sym} 270 260 0 1 {name=l9 sig_type=std_logic lab=bit_b_v}
C {sky130_fd_pr/pfet_01v8.sym} 290 -30 0 1 {name=Mppu_0
L=0.025
W=0.14
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {devices/lab_pin.sym} -240 190 0 1 {name=l14 sig_type=std_logic lab=VSUBS}
C {devices/lab_pin.sym} -240 -20 0 1 {name=l15 sig_type=std_logic lab=PWELL}
C {devices/lab_pin.sym} 250 180 0 0 {name=l16 sig_type=std_logic lab=VSUBS}
C {devices/lab_pin.sym} 250 -30 0 0 {name=l17 sig_type=std_logic lab=PWELL}
C {devices/lab_pin.sym} -370 100 0 0 {name=l11 sig_type=std_logic lab=WL1}
C {devices/ipin.sym} 0 -270 0 0 {name=p3 lab=WL1}
C {devices/ipin.sym} 0 -250 0 0 {name=p4 lab=WL2}
C {devices/iopin.sym} 130 -300 0 0 {name=p5 lab=bit_v}
C {devices/iopin.sym} 130 -280 0 0 {name=p6 lab=bit_b_v}
C {devices/lab_pin.sym} 120 40 0 1 {name=l13 sig_type=std_logic lab=right_net}
C {devices/lab_pin.sym} -100 50 0 0 {name=l18 sig_type=std_logic lab=left_net}
C {devices/ipin.sym} 0 -350 0 0 {name=p7 lab=PWELL}
