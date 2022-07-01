set clk_name clock
set clk_period 10
set input_delay_value 1
set output_delay_value 1

# define clock 
# nclk[0]: clk
# nclk[1]: reset
# nclk[2]: clk2x (fpga)
# nclk[3]: clk4x (fpga)

#set clkPort [lindex [get_ports $clk_name] 0]    ;#wtf IS SELECTING 0 ALWAYS CORRECT??? tritoncts doesnt like this
set clkPort [get_ports $clk_name]
create_clock $clkPort -name clock -period $clk_period

# apply clock to ins and outs
set clk_index [lsearch [all_inputs] $clkPort]
set all_inputs_wo_clk [lreplace [all_inputs] $clk_index $clk_index]
set_input_delay $input_delay_value -clock [get_clocks clk] $all_inputs_wo_clk  
set_output_delay $output_delay_value -clock [get_clocks clk] [all_outputs]
