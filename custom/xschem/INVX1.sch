v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N -50 -40 -40 -40 {
lab=A}
N 0 -10 0 10 {
lab=Y}
N -0 -70 10 -70 {
lab=VDD}
N 10 -70 10 -40 {
lab=VDD}
N 0 -40 10 -40 {
lab=VDD}
N -0 40 10 40 {
lab=GND}
N 10 40 10 70 {
lab=GND}
N 0 70 10 70 {
lab=GND}
N 0 -80 0 -70 {
lab=VDD}
N 0 70 0 80 {
lab=GND}
N -50 -40 -50 40 {
lab=A}
N -50 40 -40 40 {
lab=A}
N 0 0 10 0 {
lab=Y}
C {sky130_fd_pr/nfet_01v8.sym} -20 40 0 0 {name=M1
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
C {sky130_fd_pr/pfet_01v8.sym} -20 -40 0 0 {name=M2
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
C {devices/ipin.sym} -50 0 0 0 {name=p1 lab=A}
C {devices/opin.sym} 10 0 0 0 {name=p2 lab=Y}
C {devices/lab_pin.sym} 0 -80 0 0 {name=l1 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} 0 80 0 0 {name=l2 sig_type=std_logic lab=GND}
