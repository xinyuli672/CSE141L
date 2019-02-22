// CSE141L
// Program State register

module ProgState (
  input Halt,
		    CLK,
  output logic[1:0] ProgState = 2'b00
  );

// initial begin
//   ProgState <= 2'b00;
// end

always_ff @(posedge CLK)
  if (Halt) begin
    ProgState <= ProgState + 2'b01;
  end
  else ProgState <= ProgState;
endmodule
        