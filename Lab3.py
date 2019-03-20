

print('Running Lab3:')



#fileObj = open("filename", "mode") 
filename = ["newProgram.txt"]
writefile = ["MachineCode.txt"]
PC = 0
for x in range(0,1):
  read_file = open(str(filename[x]), "r") 

  #Print read_file

  #w_file is the file we are writing to

  w_file = open(str(writefile[x]), "w")
  branch_file = open("branch_target.txt", 'w')


  #Open a file name and read each line
  #to strip \n newline chars
  #lines = [line.rstrip('\n') for line in open('filename')]  

  #1. open the file
  #2. for each line in the file,
  #3.     split the string by white spaces
  #4.      if the first string == SEI then op3 = 0, else op3 = 1
  #5.      
  with open(str(filename[x]), 'r') as f:
    for line in f:
      if line.strip():
        print(line)
        str_array = line.split()
        instruction = str_array[0]


        print(str_array)
        if len(str_array)!=1:
          print(instruction)
          
          if instruction == "#":
            print("comment\n")
          elif instruction == "SEI": # I-type
            opcode = "110"
            imm = str_array[1]  
            bin_imm = '{0:06b}'.format(int(imm)) #6 bit immediate
            return_set = opcode + bin_imm
            w_file.write(return_set + '\n')
            PC += 1
          else:      
            op1 = str_array[1]
            otype = 0
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
              otype = 1
            elif instruction == "SHIFTL_F":
              opcode = "111"
              op2 = "001"
              otype = 1
            elif instruction == "SHIFTL_O":
              opcode = "111"
              op2 = "010"
              otype = 1
            elif instruction == "SHIFTR_X":
              opcode = "111"
              op2 = "011"
              otype = 1
            elif instruction == "SHIFTR_F":
              opcode = "111"
              op2 = "100"
              otype = 1
            elif instruction == "SHIFTR_O":
              opcode = "111"
              op2 = "101"
              otype = 1
            elif instruction == "B0":
              opcode = "111"
              op2 = "110"
              otype = 1
            elif instruction == "B1":
              opcode = "111"
              op2 = "111"
              otype = 1
            else:
              opcode = "error: undefined opcode"
              print("error: undefined opcode")
        
            #7 registers
            print(op1)

            if (op1 == "R0," or op1 == "R0"):
              reg1 = "000"
            elif (op1 == "R1," or op1 == "R1"):
              reg1 = "001"
            elif (op1 == "R2," or op1 == "R2"):
              reg1 = "010" 
            elif (op1 == "R3," or op1 == "R3"):
              reg1 = "011"
            elif (op1 == "R4," or op1 == "R4"):
              reg1 = "100"
            elif (op1 == "R5," or op1 == "R5"):
              reg1 = "101"
            elif (op1 == "R6," or op1 == "R6"):
              reg1 = "110"
            elif (op1 == "RIM," or op1 == "RIM"):
              reg1 = "111"
            else:
              reg1 = str('{0:03b}'.format(int(op1)))

            if (op2 == "R0"):
              reg2 = "000"
            elif (op2 == "R1"):
              reg2 = "001"
            elif (op2 == "R2"):
              reg2 = "010" 
            elif (op2 == "R3"):
              reg2 = "011"
            elif (op2 == "R4"):
              reg2 = "100"
            elif (op2 == "R5"):
              reg2 = "101"
            elif (op2 == "R6"):
              reg2 = "110"
            elif (op2 == "RIM"):
              reg2 = "111"
            else: 
              reg2 = op2
            if otype == 1:
              return_rtype = opcode + reg1 + reg2
            else:
              return_rtype = opcode + reg1 + reg2
            w_file.write(return_rtype + '\n' )
            PC += 1
          
        
        elif len(str_array) == 1:
          pc_imm = '{0:010b}'.format(PC)
          w_file.write(str_array[0])
          branch_file.write(pc_imm + " " + str(PC) + '\n')

        


  w_file.close()
   

      


