module instruction_fetch(
    input [31:0] pc,
    output [31:0] instruction
);

integer fd;
reg [7:0] character;
reg [31:0] temp;
// reg [31:0] pc2;

always @(pc) begin
    fd  = $fopen("./my_file.txt","r");
    for(integer i = 0 ;i<=pc;i++)begin
        for(integer j = 0; j<=32 ;j++) begin
            character = $fgetc(fd)-48;
            temp[31-j]=character[0];
        
        
        end
        // $display("%b",temp);
    end
    $fclose(fd);


end

assign instruction = temp;

//    initial begin
//         pc2 = 0;
//         #5;
//         pc2 = 1;
//         #1;
//         $display(" hello %b",temp);
//         #2;
//         pc2 = 3;
//         #1555;
//         $display(" hello %b",temp);
//     end

endmodule