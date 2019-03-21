// Create Date:   2017.01.25
// Design Name:   TopLevel Test Bench
// Module Name:   TopLevel_tb.v
//  CSE141L
// This is NOT synthesizable; use for logic simulation only
// Verilog Test Fixture created for module: TopLevel

module TopLevel_tb;	     // Lab 17

// To DUT Inputs
  logic start;
  logic CLK;

// From DUT Outputs
  wire halt;		   // done flag

// Instantiate the Device Under Test (DUT)
  TopLevel DUT (
	.start(start),
	.CLK(CLK), 
	.halt(halt)
	);

initial begin
  start = 1;
// Initialize DUT's data memory
#10ns for(int i=0; i<256; i++) begin
        DUT.data_mem1.core[i] = 8'h0;	     // clear data_mem
      end

  //program 3
  DUT.data_mem1.core[16] = 8'b0000_0000;      //operand
  DUT.data_mem1.core[17] = 8'b0000_0010;      //operand = 16
  DUT.data_mem1.core[18] = 8'b0000_0000;      //result = 4


// students may also pre_load desired constants into data_mem
// Initialize DUT's register file
for(int j=0; j<16; j++)
  DUT.reg_file1.registers[j] = 8'b0;    // default -- clear it
// students may pre-load desired constants into the reg_file
    
// launch program in DUT
  #10ns start = 0;
// Wait for done flag, then display results
  wait (halt);
  #10ns 
  $display("addr[16] = ",DUT.data_mem1.core[16], "\n");
  $display("addr[17] = ",DUT.data_mem1.core[17], "\n");
  $display("addr[18] = ",DUT.data_mem1.core[18], "\n");

  $display("instruction = %d %t",DUT.PC,$time);
  $display("register 1 = %d", DUT.reg_file1.registers[0]);
  #10ns $stop;			   
end

always begin   // clock period = 10 Verilog time units
  #5ns  CLK = 1;
  #5ns  CLK = 0;
end
      
endmodule

