// CSE141L  Winter 2019
// test bench to be used to verify student projects
// pulses start while loading program 1 operand into DUT
//  waits for done pulse from DUT
//  reads and verifies result from DUT against its own computation
// pulses start while loading program 2 operands into DUT
//  waits for done pulse from DUT
//  reads and verifies result from DUT against its own computation
// pulses start while loading program 3 operand into DUT
//  waits for done pulse from DUT
//  reads and verifies result from DUT against its own computation
 
module test_bench_all();

logic clk, 		           // system clock runs test bench and DUT
      start;               // request to DUT
wire  done;			       // acknowledge back from DUT

// your design goes here
// *** change device and port names as needed ***
TopLevel d1(.CLK(clk), .start(start), .halt(done));

// program 1 variables
logic[63:0] dividend;      // fixed for pgm 1 at 64'h8000_0000_0000_0000;
logic[15:0] divisor1;	   // divisor 1 (sole operand for 1/x) to DUT
logic[63:0] quotient1;	   // internal wide-precision result
logic[15:0] result1,	   // desired final result, rounded to 16 bits
            result1_DUT;   // actual result from DUT
real quotientR;			   // quotient in $real format
// program 2 variables
logic[15:0] div_in2;	   // dividend 2 to DUT
logic[ 7:0] divisor2;	   // divisor 2 to DUT
logic[23:0] result2,	   // desired final result, rounded to 24 bits
            result2_DUT;   // actual result from DUT
// program 3 variables
logic[15:0] dat_in3;	   // operand to DUT
logic[ 7:0] result3;	   // expected SQRT(operand) result from DUT
logic[47:0] square3;	   // internal expansion of operand
logic[ 7:0] result3_DUT;   // actual SQRT(operand) result from DUT
real argument, result, 	   // reals used in test bench square root algorithm
     error, result_new;
// clock -- controls all timing, data flow in hardware and test bench
always begin
       clk = 0;
  #5ns clk = 1;
  #5ns;
end

initial begin

  

// preload operands and launch program 3
  start = 1;

  #10ns for(int i=0; i<256; i++) begin
        d1.data_mem1.core[i] = 8'h0;      // clear data_mem
      end
// insert operand
  dat_in3 = 16;//65535;		   // *** try various values here ***
// *** change names of memory or its guts as needed ***
  d1.data_mem1.core[16] = dat_in3[15: 8];
  d1.data_mem1.core[17] = dat_in3[ 7: 0]; 
  if(dat_in3==0) result3 = 0;   // trap 0 case up front
  else div3;
  #20ns start = 0;
  #20ns wait(done);
// *** change names of memory or its guts as needed ***
  result3_DUT = d1.data_mem1.core[18];     
  $display("operand = %h, sqrt = %h",dat_in3,result3);
  if(result3==result3_DUT) $display("success -- match3");
  else $display("OOPS3! expected %h, got %h",result3,result3_DUT);

  #10ns $stop;
end

/*
task automatic div1;
  quotient1 = dividend/divisor1;
  result1 = quotient1[63:48]+quotient1[47];                                  // half-LSB upward rounding
  quotientR = 1.00000/$itor(divisor1);
endtask

task automatic div2;
  dividend = div_in2<<48;
  quotient1 = dividend/divisor2;
  result2 = quotient1[63:40]+quotient1[39];                                  // half-LSB upward rounding
  quotientR = $itor(div_in2)/$itor(divisor2);
//  $display ("dividend = %h, divisor2 = %h, quotient = %h, result2 = %h, equiv to %10.5f",dividend, divisor2, quotient1, result2, quotientR); 
endtask
*/
task automatic div3;
  argument = $itor(dat_in3);
//  real error, result_new;
  result = 1.0;
  error = 1.0;
  while (error > 0.001) begin
    result_new = argument/2.0/result + result/2.0;
    error = (result_new - result)/result;
    if (error < 0.0) error = -error;
      result = result_new;
  end
  result3 = $rtoi(result);
  if(!(&(result3))) 
    result3 = $rtoi(result+0.5);
endtask

endmodule