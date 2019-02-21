// CSE141L
// possible lookup table for PC target
// leverage a few-bit pointer to a wider number
module LUT(
  input[2:0] addr,
  input      Halt,
  output[2:0] program,
  output logic[9:0] Target
  );

  logic [23:0] target_array[3]

always_ff @(posedge CLK)
  if (Halt)
    program <= program + 1;

always_comb begin
  case (addr)		 
	3'b000: Target = target_array[program][23:21];
  3'b001: Target = target_array[program][20:18];
  3'b010: Target = target_array[program][17:15];
  3'b011: Target = target_array[program][14:12];
  3'b100: Target = target_array[program][11:9];
  3'b101: Target = target_array[program][8:6];
  3'b110: Target = target_array[program][5:3];
  3'b111: Target = target_array[program][2:0];
  endcase
end

initial begin
  $readmemb("branch_target.txt",target_array);
  program = 3'b000;
end

endmodule