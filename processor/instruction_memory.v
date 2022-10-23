module instruction_memory(input [31:0] address,
                        output [31:0] instruction);

reg [31:0] ins_memory[1023:0];

initial begin
    for(integer i=0;i<256;i++) begin
        ins_memory[i] <= 32'd0;
    end
end

assign instruction = ins_memory[address];

endmodule