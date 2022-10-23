// `include "main\mux2x1_1.v"

//bit wise
// S Write Register
module mux2x1_32( Y,D0, D1, S);
output [31:0] Y; // Address Out
input [31:0] D0, D1; // Address In 1 and 2
input S;
mux2x1_1 mux0(Y[0],D0[0],D1[0],S);
mux2x1_1 mux1(Y[1],D0[1],D1[1],S);
mux2x1_1 mux2(Y[2],D0[2],D1[2],S);
mux2x1_1 mux3(Y[3],D0[3],D1[3],S);
mux2x1_1 mux4(Y[4],D0[4],D1[4],S);
mux2x1_1 mux5(Y[5],D0[5],D1[5],S);
mux2x1_1 mux6(Y[6],D0[6],D1[6],S);
mux2x1_1 mux7(Y[7],D0[7],D1[7],S);
mux2x1_1 mux8(Y[8],D0[8],D1[8],S);
mux2x1_1 mux9(Y[9],D0[9],D1[9],S);
mux2x1_1 mux10(Y[10],D0[10],D1[10],S);
mux2x1_1 mux11(Y[11],D0[11],D1[11],S);
mux2x1_1 mux12(Y[12],D0[12],D1[12],S);
mux2x1_1 mux13(Y[13],D0[13],D1[13],S);
mux2x1_1 mux14(Y[14],D0[14],D1[14],S);
mux2x1_1 mux15(Y[15],D0[15],D1[15],S);
mux2x1_1 mux16(Y[16],D0[16],D1[16],S);
mux2x1_1 mux17(Y[17],D0[17],D1[17],S);
mux2x1_1 mux18(Y[18],D0[18],D1[18],S);
mux2x1_1 mux19(Y[19],D0[19],D1[19],S);
mux2x1_1 mux20(Y[20],D0[20],D1[20],S);
mux2x1_1 mux21(Y[21],D0[21],D1[21],S);
mux2x1_1 mux22(Y[22],D0[22],D1[22],S);
mux2x1_1 mux23(Y[23],D0[23],D1[23],S);
mux2x1_1 mux24(Y[24],D0[24],D1[24],S);
mux2x1_1 mux25(Y[25],D0[25],D1[25],S);
mux2x1_1 mux26(Y[26],D0[26],D1[26],S);
mux2x1_1 mux27(Y[27],D0[27],D1[27],S);
mux2x1_1 mux28(Y[28],D0[28],D1[28],S);
mux2x1_1 mux29(Y[29],D0[29],D1[29],S);
mux2x1_1 mux30(Y[30],D0[30],D1[30],S);
mux2x1_1 mux31(Y[31],D0[31],D1[31],S);

endmodule

module mux2x1_1(Y, D0, D1, S);

//Y = D0.S’ + D1.S

output Y;
input D0, D1, S;
wire T1, T2, Sbar;

assign T1 = D1&S;
assign T2 = D0&Sbar;
assign Sbar = ~S;
assign Y = T1|T2;


endmodule

//bit wise
// S Write Register
module mux2x1_5( Y,D0, D1, S);
output [4:0] Y; // Address Out
input [4:0] D0, D1; // Address In 1 and 2
input S;
mux2x1_1 mux0(Y[0],D0[0],D1[0],S);
mux2x1_1 mux1(Y[1],D0[1],D1[1],S);
mux2x1_1 mux2(Y[2],D0[2],D1[2],S);
mux2x1_1 mux3(Y[3],D0[3],D1[3],S);
mux2x1_1 mux4(Y[4],D0[4],D1[4],S);
endmodule
