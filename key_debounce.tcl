set_location_assignment PIN_M16 -to key_in
set_location_assignment PIN_E1 -to clk
set_location_assignment PIN_E15 -to rst_n
set_location_assignment PIN_A2 -to led

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to key_in
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to rst_n
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led
