# magic -rcfile magic.tcl

source ../magic/.magic_tech/.magicrc

gds read local_eval.gds
load toysram_local_eval

# for some reason these don't return values; just puts
drc catchup
drc statistics
drc count total
