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
      case (ProgState)
        2'b00: PC <= 10'b00000_00001;     // PC of program 1
        2'b01: PC <= 10'b00000_00001;     // PC of program 2
        2'b10: PC <= 10'b00000_00010;     // PC of program 3
        default: PC <= 10'b00000_00000;
      endcase
      Halt <= 1'b0; // Done flag
    end

    if (Branch_en && FLAG_IN)	begin      // Conditional Jump
      PC <= Target;
      Halt <= 1'b0;
    end
    else if ((ProgState == 2'b00) || (ProgState == 2'b01) || (ProgState == 2'b10)) begin
      PC <= PC + 10'b00000_00001;
      Halt <= 1'b1;
    end
    else begin
      PC <= PC + 10'b00000_00001;		        // default increment (no need for ARM/MIPS +4 -- why?)
      Halt <= 1'b0;
    end
  end
endmodule
