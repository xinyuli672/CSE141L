// Create Date:    2018.04.05
// Design Name:    ACDC
// Module Name:    TopLevel 
// CSE141L
// partial only										   
module TopLevel (		   // you will have the same 3 ports
  input start,	   // init/reset, active high
	input CLK,		   // clock -- posedge used inside design
  output halt		   // done flag from DUT
);

wire[9:0] PC, Target;            // program count
wire[8:0] Instruction;   // our 9-bit opcode
wire[7:0] ReadA, ReadB;  // reg_file outputs
wire[7:0] ALU_InA,
          ALU_InB, 	     // ALU operand inputs
          ALU_out;       // ALU result
wire[7:0] regWriteValue, // data in to reg file
          memWriteValue, // data in to data_memory
	   	    Mem_Out;	     // data out from data_memory

wire[1:0] ProgState;
 
wire Overflow_In, Overflow_Out, 
		 Flag_In, Flag_Out, FlagBranchEn;

wire  MEM_READ,	   		// data_memory read enable
			MEM_WRITE,	   // data_memory write enable
			reg_wr_en,	   // reg_file write enable
      reg_wr_imm_en,  // reg_file write immidiate enable
			overflow_write,	       // carry reg enable
      flag_write,      // flag control
			branch_en;	   // to program counter: branch enable
logic[15:0] cycle_ct;	   // standalone; NOT PC!

logic[2:0] lookupCode;

	ProgState ProgState1(
		.CLK					(CLK)			,
		.ProgState		(ProgState) ,
		.init					(start)
	);

// Fetch = Program Counter + Instruction ROM
// Program Counter
  IF IF1 (
	.Init        (start)       , 
	.Halt        (halt)        ,
	.Branch_en	 (branch_en)  ,
  .FLAG_IN     (FlagBranchEn)     ,
  .Target      (Target)      ,
	.CLK         (CLK)         ,    // (CLK) is required in Verilog, optional in SystemVerilog
	.PC          (PC)     	 	 ,       // program count = index to instruction memory
	.ProgState   (ProgState)
	);		

// Control decoder
  Ctrl Ctrl1 (
	  .Instruction     (Instruction)    ,    // from instr_ROM
	  .FLAG_IN         (Flag_In)        ,		 
	  .branch_en		   (branch_en)      ,    
    .flag_write      (flag_write)     ,
    .overflow_write  (overflow_write) ,
		.MEM_READ        (MEM_READ)       ,
		.MEM_WRITE       (MEM_WRITE)      ,
		.reg_wr_en       (reg_wr_en)      ,
		.reg_wr_imm_en   (reg_wr_imm_en) 
  );

// instruction ROM
  InstROM instr_ROM1 (
	  .InstAddress   (PC)              , 
	  .InstOut       (Instruction)
	);

  FLAG flag1 (
    .init          (start)      ,
    .flag_write    (flag_write) ,
    .FLAG_IN       (Flag_In)    ,
    .CLK           (CLK)        ,
    .FLAG_OUT      (Flag_Out)
  );

  OVERFLOW overflow1(
    .init              (start)          ,
    .overflow_write    (overflow_write) ,
    .OVERFLOW_IN       (Overflow_In)    ,
    .OVERFLOW_OUT      (Overflow_Out)		,
		.CLK							 (CLK)
  );

// reg file
	reg_file #(.W(8),.D(3)) reg_file1 (
		.CLK    	 (CLK)               ,
		.write_en  (reg_wr_en)         ,
    .write_imm (reg_wr_imm_en)     , 
		.raddrA    (Instruction[5:3])  , 
		.raddrB    (Instruction[2:0])  , 
		.waddr     (Instruction[5:3])  , 
		.data_in   (regWriteValue) , 
		.data_outA (ReadA) , 
		.data_outB (ReadB)
	);

  assign ALU_InA = (Instruction[8:6] == 3'b110) ? {2'b00, Instruction[5:0]} : ReadA;						   
	assign ALU_InB = (Instruction[8:6] == 3'b110) ? 8'b0000_0000 : ReadB;
	assign regWriteValue = (Instruction[8:6] == 3'b000) ? Mem_Out : ALU_out;  // 2:1 switch into reg_file
  assign memWriteValue = ALU_out;
    ALU ALU1  (
	  .INPUTA       (ALU_InA)          ,
	  .INPUTB       (ALU_InB)          ,  
	  .OP           (Instruction[8:6]) ,
    .FUNC         (Instruction[2:0]) ,
	  .OUT          (ALU_out)          ,
	  .FLAG_IN      (Flag_Out)          ,
    .OVERFLOW_IN  (Overflow_Out)      ,
	  .FLAG_OUT     (Flag_In)         ,
    .OVERFLOW_OUT (Overflow_In)			,
		.FLAG_BRANCH_EN (FlagBranchEn)
	  );

  //assign Flag_In = (ALU_out == 8'b00000000)? 1: 0;
  assign lookupCode = Instruction[5:3];
  
  LUT lut1 (
    .addr          (lookupCode),
		.ProgState		 (ProgState),
    .Target        (Target)
  );


	data_mem data_mem1(
		.DataAddress  (ReadB)            , 
		.ReadMem      (MEM_READ)         ,  
		.WriteMem     (MEM_WRITE)        , 
		.DataIn       (memWriteValue)    , 
		.DataOut      (Mem_Out)          , 
		.CLK 		  		(CLK)              ,
		.reset		    (start)
	);
	
// count number of instructions executed
always_ff @(posedge CLK)
  if (start == 1)	   // if(start)
  	cycle_ct <= 0;
  else if(halt == 0)   // if(!halt)
  	cycle_ct <= cycle_ct+16'b1;

endmodule
