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
      reg_wr_imm_en,  // reg_file write immidiate enable
			overflow_write,	       // carry reg enable
      flag_write,      // flag control
			branch_en;	   // to program counter: branch enable
logic[15:0] cycle_ct;	   // standalone; NOT PC!

// Fetch = Program Counter + Instruction ROM
// Program Counter
  IF IF1 (
	.Init       (start), 
	.Halt              ,  // SystemVerilg shorthand for .halt(halt), 
	.branch_abs	       ,  // branch enable
  .FLAG_IN           ,
  .Target            ,
	.CLK        (CLK)  ,  // (CLK) is required in Verilog, optional in SystemVerilog
	.PC             	  // program count = index to instruction memory
	);		

// Control decoder
  Ctrl Ctrl1 (
	.Instruction,    // from instr_ROM
	.FLAG_IN,		 // to PC
	.branch_en,		 // to PC
  .flag_write,
  .overflow_write
  );

// instruction ROM
  InstROM instr_ROM1(
	.InstAddress   (PC), 
	.InstOut       (Instruction)
	);
  assign load_inst = Instruction[8:6]==3'b000;  // calls out load specially


// reg file
	reg_file #(.W(8),.D(3)) reg_file1 (
		.CLK    				  ,
		.write_en  (reg_wr_en)    ,
    .write_imm (reg_wr_imm_en), 
		.raddrA    (Instruction[5:3]), 
		.raddrB    (Instruction[2:0]), 
		.waddr     (Instruction[5:3]), 
		.data_in   (regWriteValue) , 
		.data_outA (ReadA        ) , 
		.data_outB (ReadB		 )
	);

// one pointer, two adjacent read accesses: (optional approach)
//	.raddrA (Instruction[5:3]);
//	.raddrB (Instruction[5:3]);

  assign InA = ReadA;						          // connect RF out to ALU in
	assign InB = ReadB;
	assign MEM_WRITE = (Instruction[8:6] == 9'b001);       // sw command
	assign regWriteValue = load_inst? Mem_Out : ALU_out;  // 2:1 switch into reg_file
    ALU ALU1  (
	  .INPUTA  (InA),
	  .INPUTB  (InB), 
	  .OP      (Instruction[8:6]),
    .FUNC    (Instruction[2:0]),
	  .OUT     (ALU_out),//regWriteValue),
	  .FLAG_IN   ,
    .OVERFLOW_IN,
	  .FLAG_OUT,
    .OVERFLOW_OUT
	  );
  
	data_mem data_mem1(
		.DataAddress  (ReadA)    , 
		.ReadMem      (1'b1),          //(MEM_READ) ,   always enabled 
		.WriteMem     (MEM_WRITE), 
		.DataIn       (memWriteValue), 
		.DataOut      (Mem_Out)  , 
		.CLK 		  		     ,
		.reset		  (start)
	);
	
// count number of instructions executed
always_ff @(posedge CLK)
  if (start == 1)	   // if(start)
  	cycle_ct <= 0;
  else if(halt == 0)   // if(!halt)
  	cycle_ct <= cycle_ct+16'b1;

endmodule
