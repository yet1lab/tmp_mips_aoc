#!/bin/bash
#=================================================
#                PROJECT RUNNER
#=================================================
ASM_FILE="$1"
DATA="sim/data.list"
MARS="tools/Mars.jar"
#=================================================
setup(){
    sudo apt update
    sudo apt install iverilog gtkwave

    curl -L -o tools/Mars.jar "https://github.com/dpetersanderson/MARS/releases/download/v.4.5.1/Mars4_5.jar"
}

compile(){
    [ "${1:-0}" != "0" ] && {  # if have argument
        file=${1#asm/}
        file=${file%.asm}
        [ -f $1 ] && java -jar $MARS nc dump .text HexText $DATA ${file}
        cp ${file}.
    }
}

emulate(){
    echo ok
}

#=================================================
#               COMMAND SELECTION
#=================================================
case $1 in
    -s) setup;;
    -c) compile $2;;
    -e) emulate $2;;
esac    