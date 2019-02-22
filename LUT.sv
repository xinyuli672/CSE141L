// CSE141L
// possible lookup table for PC target
// leverage a few-bit pointer to a wider number
module LUT(
  input[2:0] addr,
  input[1:0] ProgState,
  output logic[7:0] Target;
  );

  logic[9:0] source [24];

initial $readmemb("branch_target.txt", source); 

always_comb begin
  case ({ProgState, addr})
  5'b00_000: Target = source[0];
  5'b00_001: Target = source[1];
  5'b00_010: Target = source[2];
  5'b00_011: Target = source[3];
  5'b00_100: Target = source[4];
  5'b00_101: Target = source[5];
  5'b00_110: Target = source[6];
  5'b00_111: Target = source[7];
  endcase
end
endmodule