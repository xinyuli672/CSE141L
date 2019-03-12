module Exception (
  input [1:0] ProgState,
  input [7:0] DataIn,
  input [8:0] Instruction,
  input [9:0] PC,
  input CLK,
  output logic [7:0] divisor_msb,
  output logic [7:0] divisor_lsb
  );

always_ff @(posedge CLK)
  if (ProgState == 2'b01) begin
    // Inputting the value of the divisor
    if (Instruction == 9'b000_000_111) // lw R0, RIM
      divisor_msb <= DataIn;
    else if (Instruction == 9'b000_001_111) // lw R1, RIM
      divisor_lsb <= DataIn;
    else begin
      divisor_msb <= divisor_msb;
      divisor_lsb <= divisor_lsb;
    end

    // Checking for 0
    if (PC == 10'b00001_00100) begin
      if (divisor_msb == 8'b0000_0000 && divisor_lsb == 8'b0000_0000 ) 
        $display("Exception: Divisor is 0\n");
    end
  end else if (ProgState == 2'b10) begin
    if (Instruction == 9'b000_010_111) // lw R2, RIM
      divisor_msb <= DataIn;

    if (PC == 10'b00010_10100) begin
      if (divisor_msb == 8'b0000_0000)
        $display("Exception: Divisor is 0\n");
    end
  end else if (ProgState == 2'b11) begin

  end else begin
    divisor_msb <= 0;
    divisor_lsb <= 0;
  end
endmodule
        