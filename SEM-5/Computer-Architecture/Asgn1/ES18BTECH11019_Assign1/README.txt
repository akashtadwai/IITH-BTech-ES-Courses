Instructions:

To increase the code modularity, I have handled all the instructions in one file.
    Compile and test all: $ bash run_tests.sh
    clean up object files: $ make clean
    Compile Individually:
        1) $ make --> This compiles and links all the files,
        2) Assembler (input.asm --> output.txt)        : $ ./Assembler input.asm output.txt
        3) ConvertAssembly (input.txt --> output.asm)  : $ ./Assembler input.txt output.asm -i
        
    NOTE: It is advised to keep all the tests in "sample_tests" if extra tests are conducted and simply use "run_tests" script,
          so that no extra *.txt files are created in current directory.

Workflow:
    Assemble --> Disassemble --> Reassemble --> diff
    - I have written all the functions in Assembler.h file
    - After running $ bash run_tests.sh an "outputs" folder is created in the current directory which contains,
    - "binary/" folder contains *.txt files corresponding to Instructions in "sample_tests/" (MIPS --> Binary)
    - "instr/" folder contains instructions in *.txt format corresponding to files in "binary/" (Binary --> MIPS)
    - "binary_test/" folder contains *.txt files corresponding to "instr/" folder (MIPS(from instr/) --> Binary)
    - log.txt contains difference b/w "binary/" and "binary_test/" files (if any)
      to know if both Assembler and ConvertAssembly are working properly.