# PipelinedProcessor
This project is an implementation of a 5-stage pipelined MIPS based processor. The implementation is based on a 
limited ISA, and the implementation was verified by testbenching the various modules used in the project. 
The 'processor.v' contains code for data path and control path is the main file for verilog 32-Bit microprocessor.
On running 'processor.v' pipelining is getting executed. module instruction_fetch reads 'bin_output.txt' and gives instruction 
corresponding to PC value.


*******************INSTRUCTION FOR USE**********************

FIBONACCI:: assembly code given in 'Fibonacci.txt', RESULT stored in $3 

FACTORIAL:: assembly code given in 'Factorial.txt', RESULT stored in $1

1) copy the code from the respective text files and paste in 'code_w.txt'
2) run ISA.cpp
3) find the 32 - bit binary code in 'bin_output.txt' file
4) run processor.v 
5) registers will be displayed for different PC values
6) final result will be displayed in respective registers
