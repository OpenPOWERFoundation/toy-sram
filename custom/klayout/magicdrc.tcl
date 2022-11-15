# magic -dnull -noconsole -rcfile magicdrc.tcl local_eval.gds

source ../magic/.magic_tech/.magicrc
#sleep 10

gds read local_eval.gds
load toysram_local_eval

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