// Create Date:    2018.04.05
// Design Name:    ACDC
// Module Name:    TopLevel 
// CSE141L
// partial only										   
module ACDC (		   // you will have the same 3 ports
  input start,	   // init/reset, active high
	input CLK,		   // clock -- posedge used inside design
  output halt		   // done flag from DUT
);

wire[9:0] PC;            // program count
wire[8:0] Instruction;   // our 9-bit opcode
wire[7:0] ReadA, ReadB;  // reg_file outputs
wire[7:0] ALU_InA, ALU_InB, 	   // ALU operand inputs
          ALU_out;       // ALU result
wire[7:0] regWriteValue, // data in to reg file
          memWriteValue, // data in to data_memory
	   	    Mem_Out;	   // data out from data_memory

wire Overflow_In, Overflow_Out, 
		 Flag_In, Flag_Out;

wire  MEM_READ,	   // data_memory read enable
			MEM_WRITE,	   // data_memory write enable
			reg_wr_en,	   // reg_file write enable
			overflow_en,	       // carry reg enable
			branch_en;	   // to program counter: branch enable
logic[15:0] cycle_ct;	   // standalone; NOT PC!
logic       SC_IN;         // carry register (loop with ALU) 
	
// count number of instructions executed
always_ff @(posedge CLK)
  if (start == 1)	   // if(start)
  	cycle_ct <= 0;
  else if(halt == 0)   // if(!halt)
  	cycle_ct <= cycle_ct+16'b1;

always_ff @(posedge CLK)    // carry/shift in/out register
  if(sc_clr)				// tie sc_clr low if this function not needed
    SC_IN <= 0;             // clear/reset the carry (optional)
  else if(sc_en)			// tie sc_en high if carry always updates on every clock cycle (no holdovers)
    SC_IN <= SC_OUT;        // update the carry  

endmodule
