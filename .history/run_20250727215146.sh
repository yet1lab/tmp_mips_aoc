#!/bin/bash
#=================================================
#                PROJECT RUNNER
#=================================================
ASM_FILE="$1"
DATA="sim/data.list"
MARS="tools/Mars.jar"
SRC_DIR="src"
SIM_DIR="sim"
BIN="test/sim.out"
VCD="test/dump.vcd"
TestBench="test/start.v"

CMD=$1                            # command option
FILE=${2#asm/}; FILE=${FILE%.asm} # extract file name

#=================================================
setup(){
    sudo apt update
    sudo apt install iverilog gtkwave

    curl -L -o tools/Mars.jar "https://github.com/dpetersanderson/MARS/releases/download/v.4.5.1/Mars4_5.jar"
}

compile(){
    files=$(find src -name '*.v')

    echo "[+] Compiling with Icarus Verilog..."
    iverilog -o $BIN $TestBench $files || exit 1
}

emulate(){
    [ "${FILE:-0}" != "0" ] && [ ! -f sim/${FILE}.list ] && \
        java -jar ${MARS} nc dump .text HexText sim/${FILE}.list asm/${FILE}.asm

    [ "${FILE:-0}" != "0" ] && \
        cp ${FILE}.list ${DATA}


}

#=================================================
#               COMMAND SELECTION
#=================================================
case $CMD in
    -s) setup;;
    -c) compile;;
    -e) emulate;;
esac    