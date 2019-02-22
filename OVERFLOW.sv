// CSE141L
// OVERFLOW register
// acceot comparison results
// default = overflow resets

module OVERFLOW (
  input init,
        overflow_write,
        OVERFLOW_IN,
		    CLK,
  output logic OVERFLOW_OUT
  );

always_ff @(posedge CLK)
  if (init) begin
    OVERFLOW_OUT <= 0;
  end
  else if (overflow_write) begin
    OVERFLOW_OUT <= OVERFLOW_IN;
  end
  else OVERFLOW_OUT <= 0;
endmodule
        