// CSE141L
// possible lookup table for PC target
// leverage a few-bit pointer to a wider number
module LUT(
  input[2:0] addr,
  input[1:0] ProgState,
  output logic[9:0] Target
  );

  logic[9:0] source [24];

initial $readmemb("branch_target.txt", source); 

always_comb begin
  case ({ProgState, addr})
  5'b01_000: Target = source[0];
  5'b01_001: Target = source[1];
  5'b01_010: Target = source[2];
  5'b01_011: Target = source[3];
  5'b01_100: Target = source[4];
  5'b01_101: Target = source[5];
  5'b01_110: Target = source[6];
  5'b01_111: Target = source[7];

  5'b10_000: Target = source[8];
  5'b10_001: Target = source[9];
  5'b10_010: Target = source[10];
  5'b10_011: Target = source[11];
  5'b10_100: Target = source[12];
  5'b10_101: Target = source[13];
  5'b10_110: Target = source[14];
  5'b10_111: Target = source[15];

  5'b11_000: Target = source[16];
  5'b11_001: Target = source[17];
  5'b11_010: Target = source[18];
  5'b11_011: Target = source[19];
  5'b11_100: Target = source[20];
  5'b11_101: Target = source[21];
  5'b11_110: Target = source[22];
  5'b11_111: Target = source[23];
  default: Target = source[0];
  endcase
end
endmodule