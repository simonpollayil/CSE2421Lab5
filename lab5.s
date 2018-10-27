# S I M O N  P O L L A Y I L  &  R E E C E  P A R T R I D G E #
# L A B  5 #

# D A T A  S E C T I O N #

.section .rodata
LC0: .string "Products\n"
LC1: .string "%i\n"
LC2: .string "Inverted elements in Array\n"
LC3: .string "Elements in Array\n"
LC4: .string "\n"

.data
sizeQArrays:
  .quad 6
QArray1:
  .quad 10
  .quad 25
  .quad 33
  .quad 48
  .quad 125
  .quad 550
QArray2:
  .quad 20
  .quad -37
  .quad 42
  .quad -61
  .quad 75
  .quad 117

# M A I N  P R O C E D U R E #

.text
.globl main
.type main, @function

main:

  pushq %rsp                               # do stack alignment
  movq %rsp, %rbp
  movq sizeQArrays, %rdi                   # move 6 byte size to register for first parameter
  movq $QArray1, %rsi                      # move 8 byte pointer to register for second parameter
  movq $QArray2, %rdx                      # move 8 byte pointer to register for third parameter
  call multQuads                           # calling multQuads
  movq sizeQArrays, %rdi                   # move 6 byte size to register for first parameter
  movq $QArray1, %rsi                      # move 8 byte pointer to register for second parameter
  call printArray                          # calling printArray
  movq sizeQArrays, %rdi                   # move 6 byte size to register for first parameter
  movq $QArray1, %rsi                      # move 8 byte pointer to register for second parameter
  call invertArray                         # calling invertArray
  movq sizeQArrays, %rdi                   # move 6 byte size to register for first parameter
  movq $QArray1, %rsi                      # move 8 byte pointer to register for second parameter
  call printArray                          # calling printArray
  movq sizeQArrays, %rdi                   # move 6 byte size to register for first parameter
  movq $QArray1, %rsi                      # move 8 byte pointer to register for second parameter
  movq $QArray2, %rdx                      # move 8 byte pointer to register for third parameter
  call multQuads                           # calling multQuads
  movq $0, %rax		 	                       # move value to return register
  leave
  ret
  .size main, .-main

# M U L T I P L I C A T I O N  P R O C E D U R E #

.globl multQuads
.type multQuads, @function

multQuads:

  pushq %rbp
  movq %rsp, %rbp
  pushq %rdi                               # preserve parameter on stack
  pushq %rsi                               # preserve parameter on stack
  pushq %rdx                               # preserve parameter on stack
  movq $LC0, %rdi                          # pass pointer to read-only "Products\n" string
  movq $0, %rax
  call printf                              # (ask grader if this procedure is correct for printing products)
  popq %rdx
  popq %rsi
  popq %rdi
  movq $0, %r8                             # initialize index for array access in caller save register

multLoop:

  cmpq %r8, %rdi                           # compare QArray1 index to size
  je multExit                              # exit if equal
  movq $0, %rcx                            # clear %rcx to store 1st 64 bit operand - multiplicand
  movq (%rsi,%r8,8), %rcx                  # move QArray1 multiplicand into 4 least significant bytes of %rcx
  movq $0, %r9                             # clear %r9 to store 2nd 64 bit operand multiplier
  movq (%rdx,%r8,8), %r9                   # move QArray2 multiplier into 4 least significant bytes of %r9
  imulq %rcx, %r9                          # multiply by QArray2 op
  pushq %rdi                               # preserve %rdi on stack
  pushq %rsi                               # preserve %rsi on stack
  pushq %rdx                               # preserve %rdx on stack
  pushq %r8                                # preserve %r8 on stack (with index)
  movq $LC1, %rdi                          # pass pointer to read only "%i\n" string as first parameter
  movq %r9, %rsi                           # pass 4 byte mult result to printf as 2nd parameter
  movq $0, %rax                            # set parameter for number of SSE registers used
  call printf
  popq %r8                                 # restore %r8 from stack (with index)
  popq %rdx                                # restore parameter from stack
  popq %rsi                                # restore parameter from stack
  popq %rdi                                # restore parameter from stack
  incq %r8                                 # increment index (ask grader)
  jmp multLoop

multExit:

  movq $LC4, %rdi                          # pass address of read only string as first parameter to print blank line
  movq $0, %rax                            # set parameter for number of SSE registers used
  call printf
  leave
  ret
  .size multQuads, .-multQuads

# I N V E R T I N G  P R O C E D U R E #

.globl invertArray
.type invertArray, @function

invertArray:

  pushq %rbp
  movq %rsp, %rbp
  movq %rdi, %r8                           # Setting %r8 as the size of array
  movq $0, %r9                             # Setting %r9 as the first pointer for the array
  movq %rsi, %rbx                          # Setting rbx as the copy for array to take end value to swap
  movq %rsi, %rdx                          # Setting rdx as the copy for array to take start value to swap

loopInvert:

  decq %r8                                 # decrementing end index
  movq (%rbx,%r8,8), %r10                  # taking end value and storing it into r10
  movq (%rdx,%r9,8), %r11                  # taking start value and storing it into r11
  movq %r10, (%rsi,%r9,8)                  # Storing end value as start value in actual array
  movq %r11, (%rsi,%r8,8)                  # Storing start value as end value in actual array
  incq %r9                                 # increment start index
  cmpq %r8, %r9                            # compare QArray1 index to size
  je exitInvert                            # exit if equal or less than
  jmp loopInvert

exitInvert:

  leave
  ret

  .size invertArray, .-invertArray

# P R I N T I N G  P R O C E D U R E #

.globl printArray
.type printArray, @function

printArray:

  pushq %rbp
  movq %rsp, %rbp
  pushq %rdi                               # preserve parameter on stack
  pushq %rsi                               # preserve parameter on stack
  movq $LC3, %rdi                          # pass pointer to read-only "Elements in Array\n" string
  movq $0, %rax
  call printf
  popq %rsi
  popq %rdi
  movq $0, %r8                             # initialize index for array access in caller save register

printLoop:

  cmpq %r8, %rdi                           # compare QArray1 index to size
  je printExit                             # exit if equal
  movq $0, %rcx                            # clear %rcx to store 1st 64 bit operand - multiplicand
  movq (%rsi,%r8,8), %rcx                  # move QArray1 multiplicand into 8 least significant bytes of %rcx
  pushq %rdi                               # preserve %rdi on stack
  pushq %rsi                               # preserve %rsi on stack
  pushq %r8                                # preserve %r8 on stack (with index)
  movq $LC1, %rdi                          # pass pointer to read only "%i\n" string as first parameter
  movq %rcx, %rsi                          # pass 8 byte mult result to printf as 2nd parameter
  movq $0, %rax                            # set parameter for number of SSE registers used
  call printf
  popq %r8                                 # restore %r8 from stack (with index)
  popq %rsi                                # restore parameter from stack
  popq %rdi                                # restore parameter from stack
  incq %r8                                 # include index
  jmp printLoop

printExit:

  movq $LC4, %rdi                          # pass address of read only string as first parameter to print blank line
  movq $0, %rax                            # set parameter for number of SSE registers used
  call printf
  leave
  ret
  .size printArray, .-printArray
