// CSE141L
// possible lookup table for PC target
// leverage a few-bit pointer to a wider number
module LUT(
  input[4:0] addr,
  output logic[9:0] Target
  );

always_comb begin
  case (addr)		 
	5'b00000: Target = 10'b0000000000;
  5'b00001: Target = 10'b0000000000;
  5'b00010: Target = 10'b0000000000;
  5'b00011: Target = 10'b0000000000;
  5'b00100: Target = 10'b0000000000;
  5'b00101: Target = 10'b0000000000;
  5'b00110: Target = 10'b0000000000;
  5'b00111: Target = 10'b0000000000;
  5'b01000: Target = 10'b0000000000;
  5'b01001: Target = 10'b0000000000;
  5'b01010: Target = 10'b0000000000;
  5'b01011: Target = 10'b0000000000;
  5'b01100: Target = 10'b0000000000;
  5'b01101: Target = 10'b0000000000;
  5'b01111: Target = 10'b0000000000;
  default: Target = 10'b0000000000;
  endcase
end
endmodule