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
  input       OVERFLOW_IN,// shift in/carry in or OVERFLOW in
  output logic [7:0] OUT, // output reg [7:0] OUT,
  output logic FLAG_OUT,      // Flag
  output logic OVERFLOW_OUT,		// shift out/carry out or OVERFLOW out
  );
	 
  op_mne op_mnemonic;			  // type enum: used for convenient waveform viewing
	
  always_comb begin
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

//always_comb BEVEN = OUT[0];          			  // note [0] -- look at LSB only

// OP == 3'b101; //!INPUTB[0];               
// always_comb	branch_enable = opcode[8:6]==3'b101? 1 : 0;  

endmodule





//    case(OP)
//	  kADDL : {SC_OUT,OUT} = INPUTA + INPUTB ;    // LSW add operation
//	  kLSAL : {SC_OUT,OUT} = (INPUTA<<1) ;  	  // LSW shift instruction
//	  kADDU : begin
//	            OUT = INPUTA + INPUTB + SC_IN;    // MSW add operation
//                SC_OUT = 0;   
//              end
//	  kLSAU : begin
//	            OUT = (INPUTA<<1) + SC_IN;  	  // MSW shift instruction
//                SC_OUT = 0;
//               end
//      kXOR  : OUT = INPUTA ^ INPUTB;
//	  kBRNE : OUT = INPUTA - INPUTB;   // use in conjunction w/ instruction decode 
//  endcase