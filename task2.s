addi x1, x0, 0     # Add lower immediate to initialize address
addi x12, x0, 12   # The number of data is 12
li x3, 0xff          # Load immediate with initial value for min
addi x4, x0, 0              # Load immediate with initial value for max
loop:
    lw x5, 0(x1)            # Load word from memory at address pointed by x1 into x5
    sub x6, x5, x4          # Subtract x4 (max) from x5
    bge x6, x0, update_max  # If x6 (difference) is greater than or equal to 0, jump to update_max
    sub x6, x3, x5          # Subtract x3 (min) from x5
    bge x6, x0, update_min  # If x6 (difference) is greater than or equal to 0, jump to update_min
loop_end:
    addi x12, x12, -1       # Update x12 as loop variable
    addi x1, x1, 4          # Update x1 by 4 to move to the next variable
    beq x12, x0, end        # If x12 = 0 then jump to the end
    j loop                  # Jump to loop
update_max:
    add x4, x0, x5          # Update max with x5
    j loop_end                  # Jump to loop
update_min:
    add x3, x0, x5
    j loop_end
end:
    addi x21, x0, 136       # Initialize x21 = 0x88
    addi x22, x0, 132       # Initialize x22 = 0x84
    addi x23, x0, 128       # Initialize x23 = 0x80
    sw x3 0(x22)            # Prepare x3 for output in outport_1
    sw x4 0(x23)            # Prepare x4 for output in outport_0
    lw x20 0(x21)           # Get the value from inport_2
    sw x20 0(x21)           # Prepare x20 for outport in outport_2
finish:
     j finish