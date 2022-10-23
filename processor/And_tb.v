`include "And.v"
`timescale 1ps/1ps

module And_tb();
And AndDUT(a,b,y);
reg a;
reg b;
wire y;
initial begin
  a = 0;
  b= 0;
  #10
  $display("%b",y);
end
endmodule