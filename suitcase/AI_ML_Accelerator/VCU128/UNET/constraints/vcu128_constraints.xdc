
## clock signal
set_property PACKAGE_PIN BJ4 [get_ports clk_p]
set_property PACKAGE_PIN BK3 [get_ports clk_n]
set_property IOSTANDARD DIFF_SSTL12 [get_ports clk_n]
set_property IOSTANDARD DIFF_SSTL12 [get_ports clk_p]


#create_clock -period 10.000 [get_ports clk_p]


## uart0
set_property PACKAGE_PIN BP26     [get_ports "DEBUG_UART_RX"] ;# Bank  67 VCCO - VCC1V8   - IO_L2N_T0L_N3_67
set_property IOSTANDARD  LVCMOS18 [get_ports "DEBUG_UART_RX"] ;# Bank  67 VCCO - VCC1V8   - IO_L2N_T0L_N3_67
set_property PACKAGE_PIN BN26     [get_ports "DEBUG_UART_TX"] ;# Bank  67 VCCO - VCC1V8   - IO_L2P_T0L_N2_67
set_property IOSTANDARD  LVCMOS18 [get_ports "DEBUG_UART_TX"] ;# Bank  67 VCCO - VCC1V8   - IO_L2P_T0L_N2_67

## uart1
set_property PACKAGE_PIN BK28     [get_ports "SERIAL_UART_RX"] ;# Bank  67 VCCO - VCC1V8   - IO_L9N_T1L_N5_AD12N_67
set_property IOSTANDARD  LVCMOS18 [get_ports "SERIAL_UART_RX"] ;# Bank  67 VCCO - VCC1V8   - IO_L9N_T1L_N5_AD12N_67
set_property PACKAGE_PIN BJ28     [get_ports "SERIAL_UART_TX"] ;# Bank  67 VCCO - VCC1V8   - IO_L9P_T1L_N4_AD12P_67
set_property IOSTANDARD  LVCMOS18 [get_ports "SERIAL_UART_TX"] ;# Bank  67 VCCO - VCC1V8   - IO_L9P_T1L_N4_AD12P_67

## vio constraints
	set_false_path -from [get_cells -hierarchical -filter { NAME =~  "*Hold_probe_in*" &&  IS_SEQUENTIAL } ] -to [get_cells -hierarchical -filter { NAME =~  "*PROBE_IN_INST/probe_in_reg*" && IS_SEQUENTIAL} ]
	set_false_path -from [get_cells -hierarchical -filter { NAME =~  "*PROBE_IN_INST/probe_in_reg*" &&  IS_SEQUENTIAL} ] -to [get_cells -hierarchical -filter { NAME =~  "*data_int_sync1*" && IS_SEQUENTIAL }  ]

	set_false_path -from [get_cells -hierarchical -filter { NAME =~  "*committ_int*" && IS_SEQUENTIAL}] -to [get_cells -hierarchical -filter { NAME =~  "*Committ_1*" &&  IS_SEQUENTIAL} ]
	set_false_path -from [get_cells -hierarchical -filter { NAME =~  "*clear_int*" && IS_SEQUENTIAL}] -to [get_cells -hierarchical -filter { NAME =~  "*Probe_out*" && IS_SEQUENTIAL}] 
	set_false_path -from [get_cells -hierarchical -filter { NAME =~  "*clear_int*" && IS_SEQUENTIAL }] -to [get_cells -hierarchical -filter { NAME =~  "*PROBE_OUT_ALL_INST/G_PROBE_OUT[*].PROBE_OUT0_INST/data_int*" && IS_SEQUENTIAL}]
	set_false_path -from [get_cells -hierarchical -filter { NAME =~  "*data_int_*" && IS_SEQUENTIAL } ] -to [get_cells -hierarchical -filter { NAME =~  "*Probe_out_*" && IS_SEQUENTIAL} ]

