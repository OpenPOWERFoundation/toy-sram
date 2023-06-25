# magic -rcfile magic.tcl

source ../magic/.magic_tech/.magicrc

# openwrapper for non-cmdline
set cmdline 0
if {[catch {openwrapper}]} {
   set cmdline 1
}

gds read toysram_bit.gds
load toysram_bit

# quit if commandline
if {$cmdline} {
   quit
}
