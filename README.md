# ICE2603-Final-Project
Contains the code and report of the final project for the course ICE2603 in SJTU

## How to run the program

- Create a Vivado Project in a similar way throughout the course
- Add the source files, constraint files and simulation files provided in the repository.
- Generate the bitstream and use an FPGA board to validate the result.

Note that in the implementation, the first two numbers on the led are the last two digits of the student number. You can modify it in `sc_cpu_iotest.v` easily. The last line of constraint file `.constr` has to be modified accordingly (perhaps). Check the possible error from the step `Generate Bitstream`, and change the corresponding `net` to the constraint. Simply follow the instruction given by Vivado is enough.
