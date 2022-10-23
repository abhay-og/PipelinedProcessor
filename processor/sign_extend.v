module sign_extend(out32,in16); 

//Sign extension is a block that takes in your input data and
output[31:0] out32;

// append bits to it based on the MSB(most significant bit) value 
input[15:0] in16;

assign out32 =  {{16{in16[15]}},in16};
//to maintain sign integrity
endmodule