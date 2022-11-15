v {xschem version=3.1.0 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 430 -160 430 -140 {
lab=RBL_R_b}
N 430 -110 480 -110 {
lab=RBL_R_b}
N 430 -190 480 -190 {
lab=GND}
N 430 -140 430 -110 {
lab=RBL_R_b}
N 430 -260 430 -220 {
lab=VDD}
N 400 -140 430 -140 {
lab=RBL_R_b}
N 240 -70 480 -70 {
lab=RBL_L_b}
C {devices/ipin.sym} 390 -190 0 0 {name=p1 lab=PRE_R_b}
C {devices/ipin.sym} 240 -70 0 0 {name=p4 lab=RBL_L_b
}
C {devices/ipin.sym} 400 -140 0 0 {name=p5 lab=RBL_R_b}
C {devices/opin.sym} 600 -90 0 0 {name=p6 lab=RBL_O}
C {sky130_fd_pr/pfet_01v8.sym} 410 -190 0 0 {name=M2
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
model=pfet_01v8
spiceprefix=X
}
C {stdcells/NAND2.sym} 540 -90 0 0 {name=x1 VCCPIN=VCC VSSPIN=VSS VCCBPIN=VCC VSSBPIN=VSS}
C {devices/iopin.sym} 430 -260 0 0 {name=p2 lab=VDD
}
C {devices/iopin.sym} 480 -190 0 0 {name=p3 lab=GND
}
