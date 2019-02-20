// CSE141L
// program counter
// accepts branch and jump instructions
// default = increment by 1
module PC(
  input init,
        jump_en,		// relative
				branch_en,		// 
				CLK,
  output logic halt,
  output logic [9:0] PC);

always @(posedge CLK)
  if (init) begin
    PC <= 0;
	  halt <= 0;
  end 
endmodule
        