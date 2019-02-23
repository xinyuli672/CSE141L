// CSE141L
// Program State register

module ProgState (
  input init,
        Halt,
  output logic[1:0] ProgState
  );

// initial begin
//   ProgState <= 2'b00;
// end

always_comb
  if (init)
    ProgState = 2'b00;
  else if (Halt)
    ProgState = ProgState + 2'b01;
  else ProgState = ProgState;

endmodule
        