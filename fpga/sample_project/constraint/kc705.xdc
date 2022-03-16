
# Clock signal
set_property PACKAGE_PIN AD12 [get_ports clk_p]
    set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_p]
set_property PACKAGE_PIN AD11 [get_ports clk_n]
    set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_n]
create_clock -period 5.000 -name clk_p [get_ports clk_p] 
# UART
set_property PACKAGE_PIN K24 [get_ports {Tx}]					
	set_property IOSTANDARD LVCMOS25 [get_ports {Tx}]
set_property PACKAGE_PIN M19 [get_ports {Rx}]					
	set_property IOSTANDARD LVCMOS25 [get_ports Rx}]
	
#Push Buttons	
#North button
set_property PACKAGE_PIN AA12 [get_ports reset_clk]						
            set_property IOSTANDARD LVCMOS15 [get_ports reset_clk]           	
#East button
set_property PACKAGE_PIN AG5 [get_ports reset]						
        set_property IOSTANDARD LVCMOS15 [get_ports reset]
    

