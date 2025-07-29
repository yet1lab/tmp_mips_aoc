#!/bin/bash
#=================================================
#                PROJECT RUNNER
#=================================================
ASM_FILE="$1"
DATA="sim/data.list"
MARS="tools/Mars.jar"
SRC_DIR="src"
SIM_DIR="sim"
BIN="sim/sim.out"
VCD="sim/dump.vcd"
TB="sim/tb_mips.v"

CMD=$1
FILE=${2#asm/}; FILE=${FILE%.asm} # extract file name

#=================================================
setup(){
    sudo apt update
    sudo apt install iverilog gtkwave

    curl -L -o tools/Mars.jar "https://github.com/dpetersanderson/MARS/releases/download/v.4.5.1/Mars4_5.jar"
}

compile(){

# Arquivos
SRC_FILES=$(find "sim" -name '*.v')


# Compila com iverilog
echo "[+] Compilando com Icarus Verilog..."
iverilog -o $BIN $TB $SRC_FILES || exit 1
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