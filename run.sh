#!/bin/bash
#=================================================
#                PROJECT RUNNER
#=================================================
CMD=$1  # get cmd option
ASM=$2  # get asm code

MARS="tools/Mars.jar"
MEM="sim/memory.list"
BIN="sim/machine.out"
VCD="sim/waves.vcd"
GTKW="sim/waves.gtkw"
TestBench="sim/testbench.v"
#=================================================
setup(){
    sudo apt update
    sudo apt install iverilog gtkwave

    curl -L -o tools/Mars.jar "https://github.com/dpetersanderson/MARS/releases/download/v.4.5.1/Mars4_5.jar"
}

compile(){
    files=$(find src -name '*.v')
    iverilog -o $BIN $TestBench $files || exit 1
}

emulate(){
    [ "${ASM:-0}" != "0" ] && \
        java -jar $MARS nc dump .text BinaryText $MEM $ASM

    vvp $BIN || exit 1     # run verilog
    gtkwave $VCD $GTKW &   # Open gtkwave
}

help(){
  echo "BASIC COMMANDS
  ./run.sh -s                 # to setup
  ./run.sh -c                 # to compile
  ./run.sh -e                 # to emulate
  ./run.sh -e {asm/file.asm}  # to emulate asm
"
}
#=================================================
#               COMMAND SELECTION
#=================================================
case $CMD in
    -s) setup;;
    -c) compile;;
    -e) emulate;;
    *)  help;;
esac
