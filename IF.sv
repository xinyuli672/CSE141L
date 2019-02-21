// Design Name:    basic_proc
// Module Name:    IF 
// Project Name:   CSE141L
// Description:    instruction fetch (pgm ctr) for processor
//
// Revision:  2019.01.27
//
module IF(
  input Init,				    // reset, start, etc. 
  input Halt,				    // 1: freeze PC; 0: run PC
  input CLK,				    // PC can change on pos. edges only
  input Branch_abs,
  input FLAG_IN,
  input [9:0] Target,
  output logic [9:0] PC	// program counter
  );
	 
  always_ff @(posedge CLK)	            // or just always; always_ff is a linting construct
    if (Init)
      PC <= 0; // for first program; want different value for 2nd or 3rd
    else if (Halt)
      PC <= PC;
    else if (Branch_abs && FLAG_IN)	      // Conditional Jump
      PC <= Target;
    else
      PC <= PC + 1;		                      // default increment (no need for ARM/MIPS +4 -- why?)

endmodule
