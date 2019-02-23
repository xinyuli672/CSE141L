// CSE141L
import definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[8:0] Instruction,	   // machine code
  input FLAG_IN, 
  output logic branch_en,
               flag_write,
               overflow_write,
               MEM_READ,
               MEM_WRITE,
               reg_wr_en,
               reg_wr_imm_en
  );
// jump on right shift that generates a zero
always_comb
begin
  // Write the branch enable
  if (Instruction[8:6] ==  opOTHER && (Instruction[2:0] == fnB0
      || Instruction[2:0] == fnB1) && FLAG_IN)
    branch_en = 1;
  else
    branch_en = 0;

  // Write the flag write control
  if (Instruction[8:6] == opCEQ || Instruction[8:6] == opCLT)
    flag_write = 1;
  else 
    flag_write = 0;

  // write the overflow write control
  if (Instruction[8:6] == opADD || Instruction[8:6] == opSUB)
    overflow_write = 1;
  else if (Instruction[8:6] == opOTHER) begin
    if (Instruction[2:0] != fnB0 && Instruction[2:0] != fnB1)
      overflow_write = 1;
    else 
      overflow_write = 0;
  end
  else overflow_write = 0;

  // Mem Read
  if(Instruction[8:6] == opLW)
    MEM_READ = 1;
  else
    MEM_READ = 0;

  // Mem Write
  if(Instruction[8:6] == opSW)
    MEM_WRITE = 1;
  else
    MEM_WRITE = 0;

  // register write enable
  if(Instruction[8:6] == opSW || Instruction[8:6] == opCEQ || Instruction[8:6] == opCLT)
    reg_wr_en = 0;
  else if (Instruction[8:6] == opOTHER) begin
    if(Instruction[8:6] != fnB0 || Instruction[8:6] != fnB1)
      reg_wr_en = 1;
    else
      reg_wr_en = 0;
  end
  else
      reg_wr_en = 0;
  // register write immidate enable
  if(Instruction[8:6] == opSEI)
    reg_wr_imm_en = 1;
  else 
    reg_wr_imm_en = 0;
    
end
endmodule