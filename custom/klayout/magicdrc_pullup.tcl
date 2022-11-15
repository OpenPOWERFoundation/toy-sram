# magic -dnull -noconsole -rcfile magicdrc_pullup.tcl toysram_local_pullup.gds

source ../magic/.magic_tech/.magicrc
#sleep 10

gds read toysram_local_pullup.gds
load toysram_local_pullup

# for some reason these don't return values; just puts
drc catchup
drc statistics
drc count total

drc find 1
drc find 2
drc find 3
drc find 4
drc find 5

exit