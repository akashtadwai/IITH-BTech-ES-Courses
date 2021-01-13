#!/usr/bin/env bash
make clean
make
echo "Generating outputs for files in tests"
mkdir {outputs,binary,instr,binary_test}
touch log.txt
for path in ./sample_data/*.asm; do
    name="${path##*/}"
    name2="$(basename ./sample_data/"$name" .asm)"
    ./Assembler "${path}" binary/"$name2"bin.txt #(MIPS --> Binary)
    ./Assembler binary/"$name2"bin.txt instr/"$name2"instr.txt -i #(Binary --> MIPS_test)
    ./Assembler instr/"$name2"instr.txt binary_test/"$name2"bintest.txt #(MIPS_test --> binary)
    echo "${name}" >>log.txt
    diff <(sed 's/#.*//' binary/"$name2"bin.txt) <(sed 's/#.*//' binary_test/"$name2"bintest.txt) >> log.txt # ignoring lines after the '#' keyword as they are comments.
done
mv -v binary instr binary_test outputs/
printf "\nThe following are the differences...\n"
cat log.txt
mv log.txt outputs/