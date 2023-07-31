# magic -rcfile magic.tcl

source ../magic/.magic_tech/.magicrc

# openwrapper for non-cmdline
set cmdline 0
if {[catch {openwrapper}]} {
   set cmdline 1
}

gds read toysram_bit.gds
load toysram_bit
select

# create toysram_bit.ext
extract cell toysram_bit

#wtf what are these doing?  do i want lvs? which options?
# create toysram_bit.spice
ext2spice scale off
# for spice sim
ext2spice -F -f ngspice

# create toysram_bit.sim
ext2sim -R -C

# create lef
lef write

# quit if commandline
if {$cmdline} {
   quit
}
