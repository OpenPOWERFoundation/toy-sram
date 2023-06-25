# magic -dnull -noconsole -rcfile magicdrc_bit.tcl toysram_bit.gds
# magic -rcfile magicdrc_bit.tcl toysram_bit.gds

source ../magic/.magic_tech/.magicrc

# openwrapper for non-cmdline
set cmdline 0
if {[catch {openwrapper}]} {
   set cmdline 1
}

# check drc
gds read toysram_bit.gds
load toysram_bit

# for some reason these don't return values; just puts
drc catchup
drc statistics
drc count total
# console sees errors (drc count) but doesn't show why until manually 'select more' again
select more
drc why

# quit if commandline
if {$cmdline} {
   quit
}
