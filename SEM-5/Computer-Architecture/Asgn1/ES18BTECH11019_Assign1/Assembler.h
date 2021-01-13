#ifndef ASSEMBLER_H
#define ASSEMBLER_H
#include <bits/stdc++.h>
using namespace std;

void initializeInstructions();
string parse(string line);
class Instructions {
public:
  string opname;
  int opcode;
  int funct;
  int commaCount;
  bool hasParanthesis;
  typedef enum RegisterType { rs, rt, rd } RegisterType;
  vector<RegisterType> regOrder;
  typedef enum Type { R, I, J, Error } Type;
  Type type;
  typedef enum Flag { None, Jump, Offset } Flag;
  Flag flag;
};

class Label {
public:
  string name;
  int address;
  bool last;
};
Label createLabel(string name);
Label getLabel(string name);


void initializeRegs();

Instructions makeInstruction(string line, Instructions::Type type, int opcode);
Instructions RType(string line, int opcode, int funct);
Instructions IType(string line, int opcode,
                   Instructions::Flag flag = Instructions::None);
Instructions JType(string line, int opcode);

Instructions getInstruction(string opname);
Instructions getInstruction(bitset<32> bitInstr);

bitset<5> getRegister(bitset<32> bitInstr, int l, int r);

bool writeInstruction(Instructions instr, vector<int>regs, int num,
                      ofstream &output, bool HexOutput);
void writeInstruction(Instructions instr, bitset<32> bitInstr,
                      ofstream &output);

int getRegNum(string reg);
string getRegName(int num);

void assembler(fstream &input, ofstream &output, bool HexOutput);
void disassembler(fstream &input, ofstream &output);
#endif