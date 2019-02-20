//This file defines the parameters used in the alu
// CSE141L
package definitions;
    
// Instruction map
const logic [2:0]opLW  = 3'b000;
const logic [2:0]opSW  = 3'b001;
const logic [2:0]opADD  = 3'b010;
const logic [2:0]opSUB  = 3'b011;
const logic [2:0]opCEQ  = 3'b100;
const logic [2:0]opCLT  = 3'b101;
const logic [2:0]opSEI  = 3'b110;
const logic [2:0]opOTHER = 3'b111;

// Function map
const logic [2:0]fnSHIFTL_X  = 3'b000;
const logic [2:0]fnSHIFTL_F  = 3'b001;
const logic [2:0]fnSHIFTL_O  = 3'b010;
const logic [2:0]fnSHIFTR_X  = 3'b011;
const logic [2:0]fnSHIFTR_F  = 3'b100;
const logic [2:0]fnSHIFTR_O  = 3'b101;
//const logic [2:0]fnB0 = 3'b110;
//const logic [2:0]fnB1 = 3'b111;

// enum names will appear in timing diagram
typedef enum logic[2:0] {
    LW, SW, ADD, SUB, 
    CEQ, CLT, SEI} op_mne;
 
endpackage // definitions
