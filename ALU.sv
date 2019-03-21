// Create Date:    2016.10.15
// Module Name:    ALU 
// Project Name:   CSE141L
//
// Revision 2018.01.27
// Additional Comments: 
//   combinational (unclocked) ALU
import definitions::*;  // includes package "definitions"

module ALU (
  input [7:0] INPUTA,     // data input 1
              INPUTB,     // data input 2
  input [2:0] OP,				  // ALU opcode, part of microcode
  input [2:0] FUNC,       // Last 3 bit for func O-type
  input       FLAG_IN,
  input       OVERFLOW_IN,    // shift in/carry in or OVERFLOW in
  output logic [7:0] OUT,     // output reg [7:0] OUT,
  output logic FLAG_OUT,      // Flag
  output logic OVERFLOW_OUT,	// shift out/carry out or OVERFLOW out
  output logic FLAG_BRANCH_EN
  );
	 
  op_mne op_mnemonic;			  // type enum: used for convenient waveform viewing
	
  always_comb begin
  /**
   * This case section deal witht the overflow and flag results, and also calculation 
   */
  case (OP)
    opLW : begin
      {OVERFLOW_OUT, OUT} = {1'b0, INPUTB};
      FLAG_OUT = FLAG_IN;
      FLAG_BRANCH_EN = 1'b0;
    end
    opSW : begin 
      {OVERFLOW_OUT, OUT} = {1'b0, INPUTA};
      FLAG_OUT = FLAG_IN;
      FLAG_BRANCH_EN = 1'b0;
    end

    opADD : begin
      {OVERFLOW_OUT, OUT} = {1'b0, INPUTA} + INPUTB + OVERFLOW_IN; 
      FLAG_OUT = FLAG_IN;
      FLAG_BRANCH_EN = 1'b0;
    end

    opSUB : begin 
      OUT = INPUTA + ((~INPUTB) + {7'b0000000, ~OVERFLOW_IN});
      if (INPUTA < INPUTB)
        OVERFLOW_OUT = 1'b1;
      else begin
        OVERFLOW_OUT = 1'b0;
        FLAG_OUT = FLAG_IN;
        FLAG_BRANCH_EN = 1'b0;
      end
    end

    opCEQ : begin
      if (INPUTA == INPUTB) begin
        {OVERFLOW_OUT, FLAG_OUT} = {1'b0, 1'b1};
        OUT = 8'b0000_0000;
        FLAG_BRANCH_EN = 1'b0;
      end else begin
        {OVERFLOW_OUT, FLAG_OUT} = {1'b0, 1'b0};
        OUT = 8'b0000_0000;
        FLAG_BRANCH_EN = 1'b0;
      end
    end

    opCLT : begin
      if (INPUTA < INPUTB) begin
        {OVERFLOW_OUT, FLAG_OUT} = {1'b0, 1'b1};
        OUT = 8'b0000_0000;
        FLAG_BRANCH_EN = 1'b0;
      end else begin
        {OVERFLOW_OUT, FLAG_OUT} = {1'b0, 1'b0};
        OUT = 8'b0000_0000;
        FLAG_BRANCH_EN = 1'b0;
      end
    end

    opSEI : begin
      {OVERFLOW_OUT, OUT} = {1'b0, INPUTA};
      FLAG_OUT = FLAG_IN;
      FLAG_BRANCH_EN = 1'b0;
    end

    default : begin

    case (FUNC)
      fnSHIFTL_X : begin
        {OVERFLOW_OUT, OUT} = {INPUTA, 1'b0};
        FLAG_OUT = FLAG_IN;
        FLAG_BRANCH_EN = 1'b0;
      end
      fnSHIFTL_F : begin  
        {OVERFLOW_OUT, OUT} = {INPUTA, FLAG_IN};
        FLAG_OUT = FLAG_IN;
        FLAG_BRANCH_EN = 1'b0;
      end
      fnSHIFTL_O : begin  
        {OVERFLOW_OUT, OUT} = {INPUTA, OVERFLOW_IN};
        FLAG_OUT = FLAG_IN;
        FLAG_BRANCH_EN = 1'b0;
      end
      fnSHIFTR_X : begin
        {OUT, OVERFLOW_OUT} = {1'b0, INPUTA};
        FLAG_OUT = FLAG_IN;
        FLAG_BRANCH_EN = 1'b0;
      end
      fnSHIFTR_F : begin
        {OUT, OVERFLOW_OUT} = {FLAG_IN, INPUTA};
        FLAG_OUT = FLAG_IN;
        FLAG_BRANCH_EN = 1'b0;
      end
      fnSHIFTR_O : begin
        {OUT, OVERFLOW_OUT} = {OVERFLOW_IN, INPUTA};
        FLAG_OUT = FLAG_IN;
        FLAG_BRANCH_EN = 1'b0;
      end
      fnB0: begin
        {OVERFLOW_OUT, OUT} = {1'b0, 8'b0000_0000};
        FLAG_OUT = FLAG_IN;
        if (!FLAG_IN)
          FLAG_BRANCH_EN = 1'b1;
        else
          FLAG_BRANCH_EN = 1'b0;
      end
      fnB1: begin
        {OVERFLOW_OUT, OUT} = {1'b0, 8'b0000_0000};
        FLAG_OUT = FLAG_IN;
        if (FLAG_IN)
          FLAG_BRANCH_EN = 1'b1;
        else
          FLAG_BRANCH_EN = 1'b0;
      end
      default : begin
        {OVERFLOW_OUT, OUT} = {1'b0, 8'b0000_0000};
        FLAG_OUT = FLAG_IN;
      end
    endcase

    end
  endcase

  op_mnemonic = op_mne'(OP);					  // displays operation name in waveform viewer
end			

endmodule