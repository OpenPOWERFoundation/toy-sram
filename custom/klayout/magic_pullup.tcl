# magic -rcfile magic.tcl

source ../magic/.magic_tech/.magicrc

gds read toysram_local_pullup.gds
load toysram_local_pullup

# for some reason these don't return values; just puts
drc catchup
drc statistics
drc count total
