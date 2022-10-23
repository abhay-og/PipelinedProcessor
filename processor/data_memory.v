module data_memory(input clk,
                   input[31 : 0] address,
                   input[31 : 0] write_data,
                   input e_write_mem,
                   output[31 : 0] read_data);
    

    reg[31:0] data_memory[0 : 1023]; // memory has size of 1024*4 bytes
    integer i;
    //by default memory contains zeroes
    initial begin
        for(i=0;i<1024;i=i+1) //same time
                data_memory[i] <= 32'd0;
    end
    
    
    always @(posedge clk) begin  
        if (e_write_mem)  //change data of memory only when write is enabled otherwise hazard
            data_memory[address] <= write_data; 
    end  
    
     // the value in read_data may or may not be used but assinging it does not cause any problems
    assign read_data = data_memory[address];
    
endmodule