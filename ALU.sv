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
  input       SC_IN,      // shift in/carry in 
  output logic [7:0] OUT, // output reg [7:0] OUT,
  output logic SC_OUT,		// shift out/carry out or OVERFLOW
  output logic FLAG,      // flag
  );
	 
  op_mne op_mnemonic;			  // type enum: used for convenient waveform viewing
	
  always_comb begin

  case (OP)
    opLW : {SC_OUT, OUT} = {1'b0, INPUTA}

    opSW : {SC_OUT, OUT} = {1'b0, INPUTA}

    opADD : {SC_OUT, OUT} = {1'b0, INPUTA} + INPUTB + SC_IN; 
    opSUB : {SC_OUT, OUT} = {1'b0, INPUTA} + ~(INPUTB + SC_IN);

    opCEQ
    opCLT
    opSEI
    opOTHER
    op : {SC_OUT, OUT} = {INPUTA, SC_IN};  	                // shift left 
	  kRSH : {OUT, SC_OUT} = {SC_IN, INPUTA};			              // shift right

    kAND : begin                                           // bitwise AND
      OUT    = INPUTA & INPUTB;
			SC_OUT = 0;
		end

    kSUB : begin
	    OUT    = INPUTA + (~INPUTB) + SC_IN;	       // check me on this!
			SC_OUT = 0;                                   // check me on this!
	  end
    default: {SC_OUT,OUT} = 0;						       // no-op, zero out
  endcase

	case (OUT)
	  'b0     : ZERO = 1'b1;
	  default : ZERO = 1'b0;
	endcase



  op_mnemonic = op_mne'(OP);					  // displays operation name in waveform viewer
end			

always_comb BEVEN = OUT[0];          			  // note [0] -- look at LSB only

//    OP == 3'b101; //!INPUTB[0];               
// always_comb	branch_enable = opcode[8:6]==3'b101? 1 : 0;  

endmodule