module instruction_decode(input clk,input[31:0] IF_instruction, output[5:0] op, output[4:0] rs,output[4:0] rt,output [4:0] rd,output[5:0] funct,output [15:0] imm);
  
  //breaks the IF instruction into components(opcode,rs,rt,rd,function,immediate) according to indexing of bits
    assign op=IF_instruction[31:26];
    assign rs=IF_instruction[25:21];
    assign rt=IF_instruction[20:16];
    assign rd=IF_instruction[15:11];
    assign funct=IF_instruction[5:0];
    assign imm=IF_instruction[15:0];
    
        
endmodule