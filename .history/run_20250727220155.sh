#!/bin/bash
#=================================================
#                PROJECT RUNNER
#=================================================
ASM_FILE="$1"
DATA="sim/data.list"
MARS="tools/Mars.jar"
OUT="sim/sim.out"
VCD="sim/wave.vcd"
TestBench="sim/start.v"

CMD=$1                            # get cmd option
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
    iverilog -o $OUT $TestBench $files || exit 1
}

emulate(){
    [ "${FILE:-0}" != "0" ] && {
        echo "[+] Compiling assembly with Mars..."
        java -jar ${MARS} nc dump .text HexText $DATA asm/${FILE}.asm
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