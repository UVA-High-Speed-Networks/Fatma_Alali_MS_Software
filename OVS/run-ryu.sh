# This script run the controller (Ryu)
# you can change the function you want you switch to perform
# e.g., below we want uor switch to perform as a L3 switch

cd ryu/
./bin/ryu-manager --verbose ryu/app/simple_switch_13.py
