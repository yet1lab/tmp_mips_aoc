#!/bin/bash
#=================================================
#                PROJECT RUNNER
#=================================================
CMD=$1  # get cmd option
ASM=$2  # get asm code

MARS="tools/Mars.jar"
DATA="sim/data.list"

OUT="sim/sim.out"
VCD="sim/wave.vcd"
TestBench="sim/start.v"
#=================================================
setup(){
    sudo apt update
    sudo apt install iverilog gtkwave

    curl -L -o tools/Mars.jar "https://github.com/dpetersanderson/MARS/releases/download/v.4.5.1/Mars4_5.jar"
}

compile(){
    files=$(find src -name '*.v')

    echo "[+] Compiling with Icarus Verilog..."
    iverilog -o $OUT $TestBench $files || exit 1
}

emulate(){
    [ "${FILE:-0}" != "0" ] && {
        echo "[+] Compiling assembly with Mars..."
        java -jar ${MARS} nc dump .text HexText $DATA $FILE
    }       

}

#=================================================
#               COMMAND SELECTION
#=================================================
case $CMD in
    -s) setup;;
    -c) compile;;
    -e) emulate;;
esac    