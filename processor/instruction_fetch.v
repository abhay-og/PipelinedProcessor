module instruction_fetch(
    input [31:0] pc,
    output [31:0] instruction
);

integer fd;
reg [7:0] character;
reg [31:0] temp;

always @(pc) begin
    fd  = $fopen("PipelinedProcessor\assembler\bin_output.txt","r");
    for(integer i = 0 ;i<=pc;i++)begin
        for(integer j = 0; j<=32 ;j++) begin
            character = $fgetc(fd)-48;
            temp[31-j]=character[0];
        
        
        end
    end
    $fclose(fd);


end

assign instruction = temp;


endmodule