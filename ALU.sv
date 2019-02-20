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
  output logic overflow_write
  );
	 
  op_mne op_mnemonic;			  // type enum: used for convenient waveform viewing
	
  always_comb begin
  /**
   * This case section deal witht the overflow and flag results, and also calculation 
   */
  case (OP)
    opLW : {OVERFLOW_OUT, OUT} = {1'b0, INPUTB};
    opSW : {OVERFLOW_OUT, OUT} = {1'b0, INPUTB};

    opADD : {OVERFLOW_OUT, OUT} = {1'b0, INPUTA} + INPUTB + OVERFLOW_IN; 
    opSUB : {OVERFLOW_OUT, OUT} = {1'b0, INPUTA} + ~(INPUTB + OVERFLOW_IN);

    opCEQ : (INPUTA == INPUTB) ? {OVERFLOW_OUT, FLAG_OUT} = {1'b0, 1'b1} : {OVERFLOW_OUT, FLAG_OUT} = {1'b0, 1'b0};
    opCLT : (INPUTA < INPUTB) ? {OVERFLOW_OUT, FLAG-OUT} = {1'b0, 1'b1} : {OVERFLOW_OUT, FLAG_OUT} = {1'b0, 1'b0};
    opSEI : {OVERFLOW_OUT, OUT} = {1'b0, INPUTB};
    default : begin

    case (FUNC)
      fnSHIFTL_X : {OVERFLOW_OUT, OUT} = {INPUTA, 1'b00};
      fnSHIFTL_F : {OVERFLOW_OUT, OUT} = {INPUTA, FLAG_IN};
      fnSHIFTL_O : {OVERFLOW_OUT, OUT} = {INPUTA, OVERFLOW_IN};
      fnSHIFTR_X : {OUT, OVERFLOW_OUT} = {1'b00, INPUTA};
      fnSHIFTR_F : {OUT, OVERFLOW_OUT} = {FLAG_IN, INPUTA};
      fnSHIFTR_O : {OUT, OVERFLOW_OUT} = {OVERFLOW_IN, INPUTA};
      //fnB0 : 
      //fnB1 :
      default : {OVERFLOW_OUT, OUT} = {1'b0, 0};
    endcase

    end
  endcase

  op_mnemonic = op_mne'(OP);					  // displays operation name in waveform viewer
end			

endmodule