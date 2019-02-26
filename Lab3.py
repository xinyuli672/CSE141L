

print('Running Lab3:')



#fileObj = open("filename", "mode") 
filename = "Assembly1.txt"

read_file = open(filename, "r") 

#Print read_file

#w_file is the file we are writing to

w_file = open("Machine3.txt", "w")


#Open a file name and read each line
#to strip \n newline chars
#lines = [line.rstrip('\n') for line in open('filename')]  

#1. open the file
#2. for each line in the file,
#3.     split the string by white spaces
#4.      if the first string == SEI then op3 = 0, else op3 = 1
#5.      
with open(filename, 'r') as f:
  for line in f:
    print line
    str_array = line.split()
    instruction = str_array[0]

    print instruction
    print str_array

    if instruction == "SEI": # I-type
      opcode = "110"
      imm = str_array[1]  #need to reformat without the hashtag
      imm = imm[1:]
      bin_imm = '{0:06b}'.format(int(imm)) #6 bit immediate
      #str_array[2] should be the comment
      return_set = opcode + bin_imm + '\t' + "#" + " " + instruction \
           + " " + "#" + imm 
      w_file.write(return_set + '\n')
    else:      
      op1 = str_array[1]
      # R-type
      if instruction == "LW":
        opcode = "000"
        op2 = str_array[2]
      elif instruction == "SW":
        opcode = "001" 
        op2 = str_array[2]
      elif instruction == "ADD":
        opcode = "010"
        op2 = str_array[2]
      elif instruction == "SUB":
        opcode = "011"
        op2 = str_array[2]
      elif instruction == "CEQ":
        opcode = "100" 
        op2 = str_array[2]
      elif instruction == "CLT": 
        opcode = "101"
        op2 = str_array[2] 
      # O-type
      elif instruction == "SHIFTL_X":
        opcode = "111"
        op2 = "000"
      elif instruction == "SHIFTL_F":
        opcode = "111"
        op2 = "001"
      elif instruction == "SHIFTL_O":
        opcode = "111"
        op2 = "010"
      elif instruction == "SHIFTR_X":
        opcode = "111"
        op2 = "011"
      elif instruction == "SHIFTR_F":
        opcode = "111"
        op2 = "100"
      elif instruction == "SHIFTR_O":
        opcode = "111"
        op2 = "101"
      elif instruction == "B0":
        opcode = "111"
        op2 = "110"
      elif instruction == "B1":
        opcode = "111"
        op2 = "111"
      else:
        opcode = "error: undefined opcode"
        print "error: undefined opcode"
    
      #7 registers
      print op1

      if (op1 == "$R0,"):
        reg1 = "000"
      elif (op1 == "$R1,"):
        reg1 = "001"
      elif (op1 == "$R2,"):
        reg1 = "010" 
      elif (op1 == "$R3,"):
        reg1 = "011"
      elif (op1 == "$R4,"):
        reg1 = "100"
      elif (op1 == "$R5,"):
        reg1 = "101"
      elif (op1 == "$R6,"):
        reg1 = "110"


      if (op2 == "$R0"):
        reg2 = "000"
      elif (op2 == "$R1"):
        reg2 = "001"
      elif (op2 == "$R2"):
        reg2 = "010" 
      elif (op2 == "$R3"):
        reg2 = "011"
      elif (op2 == "$R4"):
        reg2 = "100"
      elif (op2 == "$R5"):
        reg2 = "101"
      elif (op2 == "$R6"):
        reg2 = "110"
      else: 
        reg2 = op2

      return_rtype = opcode + reg1 + reg2 \
                    + '\t' + "#" + " " + instruction \
                    + " " + op1 

      w_file.write(return_rtype + '\n' )



w_file.close()
   

      


