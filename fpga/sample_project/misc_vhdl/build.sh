CWD=$(pwd)
cd Aa
make
cd $CWD
cat ./package.vhdl > lib/RtUart.vhdl
cat ./rt_clock_counter.vhdl >> lib/RtUart.vhdl
cat ./Aa/vhdl/AjitCustom/baud_control_calculator_global_package.vhdl >> lib/RtUart.vhdl
cat ./Aa/vhdl/AjitCustom/baud_control_calculator_test_bench.vhdl >> lib/RtUart.vhdl
cat ./Aa/vhdl/AjitCustom/baud_control_calculator.vhdl >> lib/RtUart.vhdl
cat ./configurable_self_tuning_uart.vhdl >> lib/RtUart.vhdl
