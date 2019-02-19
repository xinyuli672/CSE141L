// Create Date:    15:50:22 10/02/2016 
// Design Name:    ACDC
// Module Name:    InstROM 
// Project Name:   CSE141L
// Tool versions: 
// Description: Verilog module -- instruction ROM template	
//	 preprogrammed with instruction values (see case statement)
//
// Revision: 
//
module InstROM #(parameter A=3, W=3) (
  input       [A-1:0] InstAddress,
  output logic[W-1:0] InstOut);
	 
// Instruction format: {3bit opcode, 3bit r1, 3bit r2 or func; 3bit opcode, 6bit immediate}
	 
  always_comb 
	 case (InstAddress)
    //opcode = 0 lw
  	  0 : InstOut = 'b000;  
    //opcode = 1 sw
  	  1 : InstOut = 'b001; 
    //opcode = 2 add
      2 : InstOut = 'b010;  
    //opcode = 3 sub
      3 : InstOut = 'b011;  
    //opcode = 4 ceq
      4 : InstOut = 'b100; 
    //opcode = 5 clt
      5 : InstOut = 'b101;  
    //opcode = 6 sei
      6 : InstOut = 'b110; 
    //opcode = 7 O-type
      7 : InstOut = 'b110;

  endcase

// alternative expression
//   need $readmemh or $readmemb to initialize all of the elements
  logic[W-1:0] inst_rom[2**(A)];
  always_comb InstOut = inst_rom[InstAddress];
 
//  initial begin		                  // load from external text file
//  	$readmemb("machine_code.txt",inst_rom);
//  end 
  
endmodule
