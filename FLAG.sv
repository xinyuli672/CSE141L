// CSE141L
// FLAG register
// acceot comparison results
// default = flag stays the same

module FLAG (
  input init,
        flag_write,
        FLAG_IN,
		CLK,
  output logic FLAG_OUT
  );

always @(posedge CLK)
  if (init) begin
    FLAG_OUT <= 0;
  end
  else if (flag_write) begin
    FLAG_OUT <= FLAG_IN
  end
  else FLAG_OUT <= FLAG_OUT
endmodule
        