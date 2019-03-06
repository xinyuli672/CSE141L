// CSE141L
// Program State register

module ProgState (
  input init,
        CLK,
  output logic[1:0] ProgState = 0
  );

logic[1:0] next_ProgState;

always_comb next_ProgState = ProgState + 2'b01;

always @(negedge init) 
  ProgState <= next_ProgState;   // prog_state cycles through 1, 2, 3 following the init pulses the test bench provides

endmodule

        