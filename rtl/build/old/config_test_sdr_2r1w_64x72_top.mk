# design and tech

unit = test_sdr_2r1w_64x72_top

# top directory
export DESIGN_TOP = array
# unit directory (log, objects, reports, results)			
export DESIGN_NICKNAME = array_$(unit)
# macro
export DESIGN_NAME = $(unit)
#tech
export PLATFORM = sky130hd

# sources
export VERILOG_FILES = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_TOP)/src/verilog/work/test_sdr_2r1w_64x72_top.v))
export SDC_FILE = ./designs/$(PLATFORM)/$(DESIGN_TOP)/constraint_$(unit).sdc 

$(info Source files:)
$(info $(VERILOG_FILES))
$(info ..................................................)

# parms
export PLACE_DENSITY ?= 0.50
export ABC_CLOCK_PERIOD_IN_PS ?= 10

# must be multiples of placement site (0.46 x 2.72)
export DIE_AREA  =     0      0 3011.160 4022.880
export CORE_AREA = 5.520 10.880 3005.640 4012.000

