// Design Name:    basic_proc
// Module Name:    IF 
// Project Name:   CSE141L
// Description:    instruction fetch (pgm ctr) for processor
//
// Revision:  2019.01.27
//
module IF(
  input Init,				    // reset, start, etc.
  input CLK,				    // PC can change on pos. edges only
  input Branch_en,
  input FLAG_IN,
  input [9:0] Target,
  input [1:0] ProgState,
  output logic [9:0] PC,	// program counter
  output logic Halt				  // Done flag
  );
	 
  always_ff @(posedge CLK) begin	            // or just always; always_ff is a linting construct
    if (Init) begin
 //     if (PC == 10'b00000_01000)
//        PC <= 10'b00000_01000;
//      else
        PC <= 10'b00000_00000;
      Halt <= 1'b0; // Done flag
    end

    if (Branch_en && FLAG_IN)	begin      // Conditional Jump
      PC <= Target;
      Halt <= 1'b0;
    end
    else if ((PC == 10'b00000_01000)) begin
      PC <= PC + 10'b00000_00001;
      Halt <= 1'b1;
    end
    else begin
      PC <= PC + 10'b00000_00001;		        // default increment (no need for ARM/MIPS +4 -- why?)
      Halt <= 1'b0;
    end
  end
endmodule
