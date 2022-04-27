# Clock signal
set_property PACKAGE_PIN W5 [get_ports CLK100MHZ]							
set_property IOSTANDARD LVCMOS33 [get_ports CLK100MHZ]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5}   [get_ports CLK100MHZ]
 

# LEDS
set_property PACKAGE_PIN U16 [get_ports {LED}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED}]
	


##Buttons
set_property PACKAGE_PIN U18 [get_ports btnC]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnC]


##USB-RS232 Interface
set_property PACKAGE_PIN B18 [get_ports Rx]						
	set_property IOSTANDARD LVCMOS33 [get_ports Rx]
set_property PACKAGE_PIN A18 [get_ports Tx]						
	set_property IOSTANDARD LVCMOS33 [get_ports Tx]



