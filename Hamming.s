# .globl main
.data 0x10000000
prompt: .asciiz "Select An Option 1-8:
                1 - Enter a 4 bit code consisting of ones and zeros
                2 - Enter a 7 bit code consisting of ones and zeros
                3 - Print the entered 4 bit code
                4 - Print the entered 7 bit code
                5 - Detect error
                6 - Translate 4 bit to 7 bit
                7 - Translate 7 bit to 4 bit 
                8 - Quit
                
                Enter Selection Here:"
.data 0x100001D7
errorMessage: .asciiz "you have an error at: "
.data 0x10000400 # your range is 0x10000000 to 0x100003FF = 1024 bytes
HMGCW:    .asciiz    "1010001"  # This Hamming code word has one bit error
space:    .space     0x4
DATAW:    .asciiz    "1011"     # This data word corresponds to the corrected
                                # Hamming code word above

.text


#main:
        # lui  $a0, 0x1000
        # ori  $a0, $a0, 0x400
        # ori  $a1, $a0, 0x00C
        # jal  Hamming
        # or   $0,  $0,  $0

        # ori  $v0, $0, 0xA
        # syscall              # Exit syscall

Hamming:	# Your GetCode routine goes here
    #storing a0
    addi $s0, $a0, 0

    #storing a1
    addi $s1, $a1, 0

    #initializing response 1 
    addi $t0, $0, 1

    #initializing response 2
    addi $t1, $0, 2

     #initializing response 3 
    addi $t2, $0, 3

    #initializing response 4
    addi $t3, $0, 4

     #initializing response 5 
    addi $t4, $0, 5

    #initializing response 6
    addi $t5, $0, 6

     #initializing response 7 
    addi $t6, $0, 7

     #initializing response 8
    addi $t7, $0, 8

    #Printing the prompt
    addi $v0, $0, 4
	lui $a0, 0x1000        
	syscall

    

    #READING THE ENTRY 
    add $v0, $a1, $0
    addi $a1, $0,100
    addi $v0, $0, 5
    syscall

    addi $a0, $s0,0
    addi $a1, $s1,0
    
    #sb $0,0($a0) # overwriting enter key or use beq

    #Go To Enter 4 Bit
    beq $v0,$t0,Enter4bit
    add $0, $0,$0


    #Go To Enter 7 Bit
    beq $v0,$t1,Enter7bit
    add $0, $0,$0
    
    #Go To Print 4 Bit
    beq $v0,$t2,Print4bit
    add $0, $0,$0

    #Go To Print 7 Bit
    beq $v0,$t3,Print7bit
    add $0, $0,$0

    #Go To Detect
    beq $v0,$t4,Detect
    add $0, $0,$0

    #Go To Turn to 7
    beq $v0,$t5,Turn4To7
    add $0, $0,$0

    #Go To Turn to 4
    beq $v0,$t6,Turn7To4
    add $0, $0,$0

    #Quit
    beq $v0,$t7,Quit
    add $0, $0,$0

    j Hamming
    add $0, $0, $0
#Entering the 4 bit code 

Enter4bit:

    addi $a1, $0, 6
    addi $a0, $s1,0
    addi $v0, $0, 8
    syscall

    #sb $0,4($a0)

    add $a1, $a0, $0
    add $a0, $s0,$0

    j Hamming
    add $0, $0, $0
#Entering the 7 bit code 

Enter7bit:

    addi $a0, $s0, 0
    addi $a1, $0,9
    addi $v0, $0, 8
    syscall

    #sb $0,7($a0)

    add $a1, $s1, $0
    add $a0, $s0,$0

    j Hamming
    add $0, $0, $0
#Printing the 7 bit code to the console

Print7bit:

    addi $a0, $s0, 0
    addi $v0, $0, 4
    syscall

    j Hamming
    add $0, $0, $0

#Printing the 4 bit code to the console

Print4bit:

    addi $a0, $s1, 0
    addi $v0, $0, 4
    syscall

    addi $a0,$s0,0

    j Hamming
    add $0, $0, $0

#detecting if there is an error

Detect:
    add $a0, $s0, $0
    #c1
    lb $t0, ($a0)
    add $0, $0, $0
    lb $t1, 2($a0)
    add $0, $0, $0
    lb $t2, 4($a0)
    add $0, $0, $0
    lb $t3, 6($a0)
    add $0, $0, $0
    xor $t8,$t0,$t1
    xor $t8,$t2,$t8
    xor $t8,$t3,$t8
    

    #c2
    lb $t0, ($a0)
    add $0, $0, $0
    lb $t1, 1($a0)
    add $0, $0, $0
    lb $t2, 4($a0)
    add $0, $0, $0
    lb $t3, 5($a0)
    add $0, $0, $0
    xor $t7,$t0,$t1
    xor $t7,$t2,$t7
    xor $t7,$t3,$t7
    sll $t7, $t7, 1

    #c3
    lb $t0, ($a0)
    add $0, $0, $0
    lb $t1, 1($a0)
    add $0, $0, $0
    lb $t2, 2($a0)
    add $0, $0, $0
    lb $t3, 3($a0)
    add $0, $0, $0
    xor $t6,$t0,$t1
    xor $t6,$t2,$t6
    xor $t6,$t3,$t6
    sll $t6, $t6, 2

    add $t5,$t8,$t7
    add $t5,$t5,$t6

    #syscall 4, a0 at 0x100001D7
    lui $a0, 0x1000
    addi $a0, $a0, 0x01D7
    addi $v0, $0, 4
    syscall
    add $0,$0, $0
    addi $a0,$s0,0

    #syscall 1, a0 = $t5 
    addi $a0, $t5, 0
    addi $v0, $0, 1
    syscall
    add  $0, $0, $0
    addi $a0,$s0,0

    j Hamming
    add $0, $0, $0

#Turning 4 bit into a 7 bit 

Turn4To7:
    #b4
    lb $t8 ($a1)
    add $0, $0, $0
    sb $t8 ($a0)
    add $0, $0, $0

    #b3
    lb $t8 1($a1)
    add $0, $0, $0
    sb $t8 1($a0)
    add $0, $0, $0

    #b2
    lb $t8 2($a1)
    add $0, $0, $0
    sb $t8 2($a0)
    add $0, $0, $0

    #p3
    lb $t8, ($a1)
    add $0, $0, $0
    add $t0,$0, $t8

    lb $t8, 1($a1)
    add $0, $0, $0
    add $t1,$0,$t8

    lb $t8, 2($a1) 
    add $0, $0, $0
    add $t2,$0,$t8 

    xor $t8,$t0,$t1
    xor $t8,$t2,$t8
    sb $t8 3($a0)
    add $0, $0, $0
    #

    #b1
    lb $t8 3($a1)
    add $0, $0, $0
    sb $t8 4($a0)
    add $0, $0, $0

    #p2
    lb $t8, ($a1)
    add $0, $0, $0
    add $t0,$0, $t8

    lb $t8, 1($a1)
    add $0, $0, $0
    add $t1,$0,$t8

    lb $t8, 3($a1) 
    add $0, $0, $0
    add $t2,$0,$t8 

    xor $t8,$t0,$t1
    xor $t8,$t2,$t8
    sb $t8 5($a0)
    add $0, $0, $0
    
    #

    #p1
    lb $t8, ($a1)
    add $0, $0, $0
    add $t0,$0, $t8

    lb $t8, 2($a1)
    add $0, $0, $0
    add $t1,$0,$t8

    lb $t8, 3($a1) 
    add $0, $0, $0
    add $t2,$0,$t8 

    xor $t8,$t0,$t1
    xor $t8,$t2,$t8
    sb $t8 6($a0)
    add $0, $0, $0
    #

    j Hamming
    add $0, $0, $0

#Turning 7 bit into a 4 bit 

Turn7To4:
    add $a0, $s0, $0
    #c1
    lb $t0, ($a0)
    add $0, $0, $0
    lb $t1, 2($a0)
    add $0, $0, $0
    lb $t2, 4($a0)
    add $0, $0, $0
    lb $t3, 6($a0)
    add $0, $0, $0
    xor $t8,$t0,$t1
    xor $t8,$t2,$t8
    xor $t8,$t3,$t8
    

    #c2
    lb $t0, ($a0)
    add $0, $0, $0
    lb $t1, 1($a0)
    add $0, $0, $0
    lb $t2, 4($a0)
    add $0, $0, $0
    lb $t3, 5($a0)
    add $0, $0, $0
    xor $t7,$t0,$t1
    xor $t7,$t2,$t7
    xor $t7,$t3,$t7
    sll $t7, $t7, 1

    #c3
    lb $t0, ($a0)
    add $0, $0, $0
    lb $t1, 1($a0)
    add $0, $0, $0
    lb $t2, 2($a0)
    add $0, $0, $0
    lb $t3, 3($a0)
    add $0, $0, $0
    xor $t6,$t0,$t1
    xor $t6,$t2,$t6
    xor $t6,$t3,$t6
    sll $t6, $t6, 2

    add $t5,$t8,$t7
    add $t5,$t5,$t6
    

    addi $t0, $t0,7
    sub $t1,$t0,$t5
    add $t1, $t1, $a0

    lb $t0, ($t1)
    add $0, $0, $0
    xor $t0, $t0, 0x1

    lb $t8 ($a0)
    add $0, $0, $0
    sb $t8 ($a1)
    add $0, $0, $0


    lb $t8 1($a0)
    add $0, $0, $0
    sb $t8 1($a1)
    add $0, $0, $0


    lb $t8 2($a0)
    add $0, $0, $0
    sb $t8 2($a0)
    add $0, $0, $0


    lb $t8 4($a0)
    add $0, $0, $0
    sb $t8 4($a0)
    add $0, $0, $0

    j Hamming
    add $0, $0, $0

#Function for quiting 

done:
    jr $ra
    add $0, $0,$0timberlake {~} > 
