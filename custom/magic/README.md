# Next Steps

* LVS (Open source)
    - Extract SPICE file from 10T_32x32_magic.mag.
    - Extract SPICE file from 10T_32x32_xschem.sch.
    - Run the script: runlvs_single.sh (Might have to look at the script and
      figure out what files need to be where). 
    - It will print a .out file.

* Extract GDS file (Magic)
    - Pull up 10T_32x32_magic.mag in magic.
    - In the magic terminal type: "gds".
    - That extracts the GDS file.

* Extract LEF file (NDA Flow)
    - There is a flow to do this in Abstract.
    - This needs all GDS files of layouts we want to use in synthesis and PnR.
    - Outputs a ".lef" file.

* Liberty Characterization (NDA Flow)
    - This needs SPICE files of our layout (i.e. SRAM) and the SPICE
      files of the SKY130 models (i.e. sky130_fd_pr__.....) 
    - This gives timing and power characteristics of the layout/cell.
    - Outputs a ".lib" file needed for synth and PnR.

* Synthesis (NDA Flow)
    - We need the Verilog files for design we want to make.
    - We need the Liberty file for our standard cell library so that it can
      make a "gate level" netlist of the design.
    - Will give us timing and power metrics of the design using our cells.
    - This produces a lot of files.

* Place and Route (NDA Flow)
    - This needs SPICE, LEF, GDS, LIB, Output from Synthesis.
    - This also outputs a bunch of files.
    - Our end goal is to have a GDS file of our placed and routed design.
    - "signoff.gds"
