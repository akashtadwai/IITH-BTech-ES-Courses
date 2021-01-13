#include "Assembler.h"
#include "bits/stdc++.h"
using namespace std;

bool toInstructions = false; //flag to check to convert Instructions to Binary or Binary to Instructions

int main(int argc, char **argv) {
  if (argc < 3) {
    cout<<"Please specify correct number of arguments! \n";
    cout << "Usage: ./Assembler <inputfile> <outputfile> <option:-i>\n";
    return 0;
  }
  string output(argv[2]);
  string input(argv[1]);
  for (size_t i = 3; i < argc; i++) {
    string choice = argv[i];
    if (choice.find('i') != string::npos)
      toInstructions = true;
  }
  // open the input file
  fstream inputFile;
  inputFile.open(input.c_str());

  if (!inputFile) {
    cout << "Unable to Open input file: " << input << "\n";
    exit(0);
  }

  // open the output file
  ofstream outputFile;
  outputFile.open(output.c_str());

  if (!outputFile) {
    cout << "Unable to Open OutputFile: " << output << "\n";
    exit(0);
  }
  initializeInstructions();
  initializeRegs();

  // Call a function based on command line switch i.e, -d for converting binary back to MIPS
  if (toInstructions)
    disassembler(inputFile, outputFile);
  else 
    assembler(inputFile, outputFile, true);
  

  return 0;
}