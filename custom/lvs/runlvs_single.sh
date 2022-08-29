#!/bin/sh
CELL1=$(basename "$1" .spice)
CELL2=$(basename "$2" .spice)
##
# ./runlvs_single 10T_32x32_magic_flattened.spice 10T_32x32_xschem.spice
# $1 = 10T_32x32_magic_flattened.spice
# $2 = 10T_32x32_xschem.spice
#
# CELL1 = 10T_32x32_magic_flattened
# CELL2 = 10T_32x32_xschem
#
# 
##

netgen -noc << EOF
lvs "$1 x$CELL1" "$2 $CELL2" sky130A_setup.tcl $CELL1.out
quit
EOF
