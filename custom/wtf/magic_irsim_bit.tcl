# magic -rcfile magic.tcl

source ../magic/.magic_tech/.magicrc

# openwrapper for non-cmdline
set cmdline 0
if {[catch {openwrapper}]} {
   set cmdline 1
}

gds read toysram_bit.gds
load toysram_bit

irsim $PDK_ROOT/sky130A/libs.tech/irsim/sky130A_1v98_27.prm toysram_bit.sim
h VDD
l GND_0
l GND_1
ana inv1_q inv2_q WWL WBL WBLb RWL0 RBL0 RWL1 RBL1

h RWL0
h RWL1
s 100

# write 1
h WWL
h WBL
l WBLb
# RBL's are floating except when pulled to 0 - force/release
u RBL0
u RBL1
s 10
x RBL0
x RBL1
s 10
s 100
s 100
l WWL
s 100

# write 0
h WWL
l WBL
h WBLb
# RBL's are floating except when pulled to 0 - force/release
u RBL0
u RBL1
s 10
x RBL0
x RBL1
s 10
s 100
s 100
l WWL
s 100

# write 1
h WWL
h WBL
l WBLb
# RBL's are floating except when pulled to 0 - force/release
u RBL0
u RBL1
s 10
x RBL0
x RBL1
s 10
s 100
s 100
l WWL
s 100

# disable rwl's
l RWL0
l RWL1
# RBL's are floating except when pulled to 0 - force/release
u RBL0
u RBL1
s 10
x RBL0
x RBL1
s 10
s 100




# quit if commandline
if {$cmdline} {
   quit
}
