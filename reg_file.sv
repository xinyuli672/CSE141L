// Create Date:    2017.01.25
// Design Name:    ACDC
// Module Name:    reg_file 
//
// Additional Comments: 					  $clog2

module reg_file #(parameter W=8, D=3)(		 // W = data path width; D = pointer width
  input           CLK,
                  write_en,
                  write_imm,
  input  [ D-1:0] raddrA,
                  raddrB,
                  waddr,
  input  [ W-1:0] data_in,
  //input  [ W-1:0] imm_in,
  output logic [ W-1:0] data_outA,
  output logic [W-1:0] data_outB
  );

// W bits wide [W-1:0] and 2**3 registers deep 	 
logic [W-1:0] registers[2**D];

// combinational reads w/ blanking of address 0
//assign      data_outA = raddrA? registers[raddrA] : '0;	 // can't read from addr 0, just like MIPS
always_comb data_outA = registers[raddrA];               // can read from addr 0, just like ARM
always_comb data_outB = registers[raddrB];               // can read from addr 0, just like ARM

// sequential (clocked) writes 
always_ff @ (posedge CLK)
  // reserve register[7] in reg file for special purpose register RIM
  if (write_en && write_imm)
    registers[7] <= data_in;
  else if (write_en)	                             
    registers[waddr] <= data_in;
  

endmodule
