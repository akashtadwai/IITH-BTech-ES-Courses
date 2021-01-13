#include "Assembler.h"
#include "bits/stdc++.h"
using namespace std;
int pc = 0;
vector<Instructions> instructions;
vector<string> regNames;
vector<Label> labels;
string cloned_line;
void initializeInstructions() {
  instructions.clear();

  // Rtype instructions
  instructions.push_back(RType("add $rd, $rs, $rt", 0, 32));
  instructions.push_back(RType("addu $rd, $rs, $rt", 0, 33));
  instructions.push_back(RType("sub $rd, $rs, $rt", 0, 34));
  instructions.push_back(RType("subu $rd, $rs, $rt", 0, 35));
  instructions.push_back(RType("and $rd, $rs, $rt", 0, 36));
  instructions.push_back(RType("or $rd, $rs, $rt", 0, 37));
  instructions.push_back(RType("nor $rd, $rs, $rt", 0, 39));
  instructions.push_back(RType("slt $rd, $rs, $rt", 0, 42));
  instructions.push_back(RType("sltu $rd, $rs, $rt", 0, 43));
  instructions.push_back(RType("sll $rd, $rt, shamt", 0, 0));
  instructions.push_back(RType("srl $rd, $rt, shamt", 0, 2));
  instructions.push_back(RType("jr $rs", 0, 8));

  // Itype instructions
  instructions.push_back(IType("addi $rt, $rs, imm", 8));
  instructions.push_back(IType("addiu $rt, $rs, imm", 9));
  instructions.push_back(IType("andi $rt, $rs, imm", 12));
  instructions.push_back(IType("ori $rt, $rs, imm", 13));
  instructions.push_back(IType("slti $rt, $rs, imm", 10));
  instructions.push_back(IType("sltiu $rt, $rs, imm", 11));
  instructions.push_back(IType("lui $rt, $rs, imm", 15));
  instructions.push_back(
      IType("beq $rs, $rt, offset", 0x4, Instructions::Jump));
  instructions.push_back(
      IType("bne $rs, $rt, offset", 0x5, Instructions::Jump));
  instructions.push_back(
      IType("lw $rt, offset($rs)", 0x23, Instructions::Offset));
  instructions.push_back(
      IType("sw $rt, offset($rs)", 0x2b, Instructions::Offset));

  // J type instructions
  instructions.push_back(JType("j target", 2));
  instructions.push_back(JType("jal target", 3));
}

void initializeRegs() {
  regNames.clear();

  // All the register names
  string names = "$zero $at $v0 $v1 $a0 $a1 $a2 $a3 $t0 $t1 "
                 "$t2 $t3 $t4 $t5 $t6 $t7 $s0 $s1 $s2 $s3 $s4 "
                 "$s5 $s6 $s7 $t8 $t9 $k0 $k1 $gp $sp $fp $ra";

  stringstream ss(names);

  // storing all reg names in a vector
  string reg;
  while (getline(ss, reg, ' ')) {
    regNames.push_back(reg);
  }
}

string parse(string line) {
  string whitespaces(" \n\r\t\f\v");
  // get positions of first and last non whitespace character
  int posfirst = line.find_first_not_of(whitespaces);

  // parse off the whitespace
  if (posfirst != string::npos)
    line = line.substr(posfirst);

  int poslast = line.find_last_not_of(whitespaces);

  if (poslast != string::npos)
    line = line.substr(0, poslast + 1);

  return line;
}

Instructions makeInstruction(string line, Instructions::Type type, int opcode) {
  // parse the line similarly to the assembler
  line = parse(line);
  vector<Instructions::RegisterType> regOrder;

  // finding opname i.e string value upto first occurence of whitespace
  string opname = line.substr(0, line.find(' '));

  while (line.find('$') != string::npos) {
    int pos = line.find('$');
    string reg = line.substr(pos, 3); // get the reg name
    line = line.substr(0, pos) + line.substr(pos + 3);

    // we only accept $rs, $rt and $rd here
    if (reg == "$rs")
      regOrder.push_back(Instructions::rs);
    else if (reg == "$rt")
      regOrder.push_back(Instructions::rt);
    else if (reg == "$rd")
      regOrder.push_back(Instructions::rd);
  }

  int commas = count(line.begin(), line.end(), ',');
  bool parens =
      line.find('(') != string::npos && line.find(')') != string::npos;

  // build the Instructions data
  Instructions instr;
  instr.opname = opname;
  instr.opcode = opcode;
  instr.funct = 0;
  instr.type = type;
  instr.regOrder = regOrder;
  instr.flag = Instructions::None;
  instr.commaCount = commas;
  instr.hasParanthesis = parens;

  return instr;
}

Instructions RType(string line, int opcode, int funct) {
  Instructions instr = makeInstruction(line, Instructions::R, opcode);
  instr.funct = funct; // assign the function
  return instr;
}

Instructions IType(string line, int opcode, Instructions::Flag flag) {
  Instructions instr = makeInstruction(line, Instructions::I, opcode);
  instr.flag = flag; // assign a special function

  return instr;
}

Instructions JType(string line, int opcode) {
  Instructions instr = makeInstruction(line, Instructions::J, opcode);
  instr.flag = Instructions::Jump;

  return instr;
}

Instructions getInstruction(string opname) {
  for (size_t i = 0; i < instructions.size(); i++) {
    if (opname == instructions[i].opname) {
      return instructions[i];
    }
  }

  Instructions instr;
  instr.type = Instructions::Error;
  return instr;
}

Instructions getInstruction(bitset<32> bitInstr) {
  // get the opcode
  bitset<6> opcode(0);
  for (size_t i = 26, k = 0; i < 32; i++, k++) {
    opcode[k] = bitInstr[i];
  }

  // if this has an opcode of 0 we need to get the funct
  bitset<6> funct(0);
  if (opcode == bitset<6>(0)) {
    for (size_t i = 0, k = 0; i < 6; i++, k++) {
      funct[k] = bitInstr[i];
    }
  }

  // find the corresponding Instructions
  for (size_t i = 0; i < instructions.size(); i++) {
    bitset<6> instrFunct(instructions[i].funct);
    bitset<6> instrOpcode(instructions[i].opcode);
    if (instrOpcode == opcode and instrFunct == funct) {
      return instructions[i];
    }
  }

  Instructions instr;
  instr.type = Instructions::Error;
  return instr;
}

bitset<5> getRegister(bitset<32> bitInstr, int l, int r) {
  bitset<5> reg;
  for (size_t i = l, k = 0; i < r; i++, k++) {
    reg[k] = bitInstr[i];
  }
  return reg;
}

bool writeInstruction(Instructions instr, vector<int> regs, int num,
                      ofstream &output, bool hexOutput) {
  // check if we have enough reg values for this Instructions
  if (instr.regOrder.size() != regs.size()) {
    cout << "Register values aren't enough, expected no. is: "
         << instr.regOrder.size() << "\n";
    return false;
  }

  // write the opcode which is always 6 bits
  bitset<6> opbits(instr.opcode);

  stringstream out;
  out << opbits;

  // rtype Instructions
  if (instr.type == Instructions::R) {
    bitset<5> rs(0);
    bitset<5> rt(0);
    bitset<5> rd(0);

    // set the register values in order
    for (size_t i = 0; i < regs.size(); i++) {
      Instructions::RegisterType t = instr.regOrder[i];
      if (t == Instructions::rs)
        rs = bitset<5>(regs[i]);
      else if (t == Instructions::rt)
        rt = bitset<5>(regs[i]);
      else if (t == Instructions::rd)
        rd = bitset<5>(regs[i]);
    }

    bitset<5> shamt(num);

    bitset<6> funct(instr.funct);

    out << rs << rt << rd << shamt << funct;

  } else if (instr.type == Instructions::I) {
    // calculate jump length offset somewhere in here.
    bitset<5> rs(0);
    bitset<5> rt(0);

    // set the register values in order
    for (size_t i = 0; i < regs.size(); i++) {
      Instructions::RegisterType t = instr.regOrder[i];
      if (t == Instructions::rs)
        rs = bitset<5>(regs[i]);
      else if (t == Instructions::rt)
        rt = bitset<5>(regs[i]);
    }

    bitset<16> imm(num);

    out << rs << rt << imm;

  } else if (instr.type == Instructions::J) {
    bitset<26> target(num);
    out << target;
  }

  string line;
  out >> line;

  // output in hexadecimal format
  if (hexOutput) {
    bitset<32> hexVal(line);
    output << line;
    output << "\t#(";
    output << "0x" << hex << setfill('0') << setw(8) << hexVal.to_ulong();
    output << ", " << cloned_line;
    output << ")";
  }
  output << "\n";

  return true;
}

void writeInstruction(Instructions instr, bitset<32> bitInstr,
                      ofstream &output) {
  output << instr.opname << " ";
  if (instr.type == Instructions::R) {
    // read all the register values
    bitset<5> rs = getRegister(bitInstr, 21, 26);
    bitset<5> rt = getRegister(bitInstr, 16, 21);
    bitset<5> rd = getRegister(bitInstr, 11, 16);
    bitset<5> shamt = getRegister(bitInstr, 6, 11);

    for (size_t i = 0; i < instr.regOrder.size(); i++) {
      Instructions::RegisterType t = instr.regOrder[i];
      if (t == Instructions::rs)
        output << getRegName(rs.to_ulong());
      else if (t == Instructions::rt)
        output << getRegName(rt.to_ulong());
      else if (t == Instructions::rd)
        output << getRegName(rd.to_ulong());

      if (i != instr.regOrder.size() - 1) {
        output << ", ";
      }
    }

    if (shamt.to_ulong() > 0) {
      output << ", " << shamt.to_ulong();
    }

  } else if (instr.type == Instructions::I) {
    bitset<5> rs = getRegister(bitInstr, 21, 26);
    bitset<5> rt = getRegister(bitInstr, 16, 21);

    // read 16 bit immediate value
    bitset<16> imm(0);
    for (size_t i = 0, k = 0; i < 16; i++, k++) {
      imm[k] = bitInstr[i];
    }

    for (size_t i = 0; i < instr.regOrder.size(); i++) {
      Instructions::RegisterType t = instr.regOrder[i];
      if (t == Instructions::rs) {
        // handling things like 8($s0)
        if (instr.flag == Instructions::Offset) {
          int immediate = imm.to_ulong();
          // reading negative number
          uint16_t full = -1;
          uint16_t half = full / 2;
          if (immediate > half) {
            immediate -= full;
            immediate--;
          }

          output << immediate;
          output << "(" << getRegName(rs.to_ulong()) << ")";

        } else {
          output << getRegName(rs.to_ulong());
        }

      } else if (t == Instructions::rt) {
        output << getRegName(rt.to_ulong());
      }

      if (i != instr.regOrder.size() - 1) {
        output << ", ";
      }
    }

    if (instr.flag != Instructions::Offset) {
      int immediate = imm.to_ulong();
      if (instr.flag == Instructions::Jump) {
        // reading -ve number
        uint16_t full = -1;
        uint16_t half = full / 2;
        if (immediate > half) {
          immediate -= full;
          immediate -= 1;
        }
        immediate *= 4;
      }

      output << ", " << immediate;
    }

  } else if (instr.type == Instructions::J) {
    // read 26 bit target address
    bitset<26> target(0);
    for (size_t i = 0, k = 0; i < 26; i++, k++) {
      target[k] = bitInstr[i];
    }

    int value = target.to_ulong();
    value *= 4;

    output << value;
  }

  output << "\n";
}

int getRegNum(string reg) {
  // find the index of the register
  for (size_t i = 0; i < regNames.size(); i++) {
    if (reg == regNames[i]) {
      return i;
    }
  }

  return -1;
}

string getRegName(int num) { return regNames[num]; }

Label createLabel(string name) {
  Label label;
  label.name = name;
  label.address = -1;
  label.last = false;
  return label;
}

Label getLabel(string name) {
  for (size_t i = 0; i < labels.size(); i++) {
    if (labels[i].name == name) {
      return labels[i];
    }
  }

  return createLabel("Error");
}

void assembler(fstream &input, ofstream &output, bool HexOutput) {
  pc = 0x00400000;
  stringstream ss;

  // parse for labels and comments
  string line;
  while (getline(input, line)) {
    ss << line << "\n";
    // remove comment
    if (line.find('#') != string::npos)
      line = line.substr(0, line.find('#'));
    
    line = parse(line);

    // parse for labels
    if (line.find(':') != string::npos) {
      int pos = line.find(':');
      string label = line.substr(0, pos);

      string alphanumeric(
          "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_");
      if (label.find_first_not_of(alphanumeric) != string::npos) {
        cout << "label error: \"" << label << "\"\n";
        cout << "labels should only contain alphanumeric "
                "characters\nAborting...\n";
        return;
      }
      string numbers("0123456789");
      if (label.find_first_of(numbers) == 0) {
        cout << "label error: \"" << label << "\"\n";
        cout << "labels should not start with a number\nAborting...\n";
        return;
      }

      line = line.substr(pos + 1);
      line = parse(line);
      labels.push_back(createLabel(label));
    }

    // if line is empty after parse/remove comment skip
    if (line.empty())
      continue;

    // set the address of the label to the next line of code
    if (labels.size() > 0) {
      Label &label = labels[labels.size() - 1];
      if (label.address < 0) {
        label.address = pc;
        // cout << "label \"" << label.name << "\" at address " <<
        // label.address << "\n";
      }
    }
    pc += 4;
  }

  // checking for label at end of code eg exit label
  for (size_t i = 0; i < labels.size(); i++) {
    Label &label = labels[i];
    if (label.address < 0) {
      label.address = pc - 0x000004;
      label.last = true;
    }
  }

  // reset program counter
  pc = 0x00400000;
  int lineNum = 1;

  while (getline(ss, line)) {
    string fullLine = line;
    // remove comment
    if (line.find('#') != string::npos)
      line = line.substr(0, line.find('#'));

    line = parse(line);

    // parse for labels
    if (line.find(':') != string::npos) {
      int pos = line.find(':');
      line = line.substr(pos + 1);
      line = parse(line);
    }

    // if line is empty after parse/remove comment skip
    if (line.empty()) {
      ++lineNum;
      continue;
    }

    string opname;
    cloned_line = line;
    // parse the opname
    if (line.find(' ') != string::npos) {
      int pos = line.find(' ');
      opname = line.substr(0, pos);
      line = line.substr(pos + 1);
    }

    Instructions instr = getInstruction(opname);
    if (instr.type == Instructions::Error) {
      cout << opname << " is not a valid operation\naborting\n";
      return;
    }

    int commas = count(line.begin(), line.end(), ',');
    if (commas != instr.commaCount) {
      cout << "syntax error on line " << lineNum << ": " << fullLine << "\n";
      cout << "missing \',\'\naborting\n";
      return;
    }

    bool parens =
        line.find('(') != string::npos && line.find(')') != string::npos;
    if (parens != instr.hasParanthesis) {
      cout << "syntax error on line " << lineNum << ": " << fullLine << "\n";
      cout << "missing \'(\' or \')\'\naborting\n";
      return;
    }

    // parse out the registers by looking for $
    vector<int> regs;
    while (line.find('$') != string::npos) {
      int pos = line.find('$');
      string reg = line.substr(pos, 3);
      int len =
          reg == "$ze"
              ? 5
              : 3; // special case for $zero which is only > 2 letter register
      reg = line.substr(pos, len); // reparse reg incase it's $zero
      line = line.substr(0, pos) + line.substr(pos + len);

      // get the register value
      int regNum = getRegNum(reg);
      if (regNum < 0) {
        cout << reg << " is not a valid register name\naborting\n";
        return;
      }
      regs.push_back(regNum);
    }

    // parse for immediate/offset/shamt
    bool immediateSet = false;
    int imm = 0;

    // we include - so we can have negatives
    string numbers("-0123456789");
    int posf = line.find_first_of(numbers);
    int posl = line.find_last_of(numbers);

    if (posf != string::npos) {
      immediateSet = true;
      stringstream ss(line.substr(posf, posl + 1));
      ss >> imm;
    }

    // calculate jump offset if applicable
    if (instr.flag == Instructions::Jump) {
      line = parse(line);
      string labelName = line;
      string alphanumeric(
          "ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz1234567890");
      int posl = line.find_last_not_of(alphanumeric);
      if (posl != string::npos)
        labelName = line.substr(posl + 1);
      Label label = getLabel(labelName);
      if (label.address < 0) {
        if (!immediateSet) {
          cout << "label " << labelName << " does not exist\nAborting...\n";
          return;

        } else
          imm /= 4;

      } else {
        immediateSet = true;

        // calculate the jump offset
        if (instr.type == Instructions::I) {
          int offset = label.address - pc;
          imm = offset;
          imm /= 4;
          if (imm > 0 or imm < 0)
            imm -= 1;
          if (label.last)
            imm++;

        } else if (instr.type == Instructions::J) {
          imm = label.address;
          imm /= 4;
          if (label.last)
            imm++;
        }
      }
    }

    if ((instr.type == Instructions::I || instr.type == Instructions::J) and
        !immediateSet) {
      cout << "immediate/offset/label expected none are found\naborting...\n";
      return;
    }

    // an error occured while writing the Instructions it will be printed out
    if (!writeInstruction(instr, regs, imm, output, HexOutput)) {
      return;
    }

    pc += 4;
    lineNum++;
  }
}

// For binary numbers
void disassembler(fstream &input, ofstream &output) {
  string fullFile;
  string line;
  while (getline(input, line)) {
    if (line.find('#') != string::npos) {
      line = line.substr(0, line.find('#'));
    }
    line = parse(line);
    fullFile += line;
  }

  // read the input 32 characters at a time
  while (fullFile.size() >= 32) {
    string bitstring = fullFile.substr(0, 32);
    fullFile = fullFile.substr(32);

    bitset<32> bitInstr(bitstring);
    Instructions instr = getInstruction(bitInstr);

    if (instr.type == Instructions::Error) {
      cout << "Instructions not supported by this disassembler.\n";
      return;
    }
    writeInstruction(instr, bitInstr, output);
  }
}