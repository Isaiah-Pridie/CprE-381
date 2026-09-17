# Proj1_base_test.s
#
# Instructions tested:
#   add, addi, and, andi, lui, lw, xor, xori, or, ori,
#   slt, slti, sltiu, sll, srl, sra, sw, sub, beq, bne,
#   blt, bge, bltu, bgeu, jal, jalr, lb, lh, lbu, lhu,
#   slli, srli, srai, auipc, wfi
# ============================================================

.data
word_val:  .word  0x00000F0F     # 32-bit test value for lw
byte_val:  .byte  0xAB           # signed byte  (0xAB = -85 signed)
           .byte  0              # padding
           .byte  0              # padding
           .byte  0              # padding
half_val:  .half  0x1234         # signed halfword
           .half  0              # padding
store_buf: .word  0              # scratch buffer for sw/lw round-trip

.text
# LUI test
      lui   s0, 1              # s0 = 0x00001000
      lui   s1, 0x10           # s1 = 0x00010000

# AUIPC test
      auipc s2, 0              # s2 = PC of this instruction
      auipc s3, 1              # s3 = PC + 0x1000

# ADD / ADDI / SUB test
      li    s4, 100            # s4 = 100
      li    s5, 55             # s5 = 55
         nop
      addi  s8, zero, -1       # s8 = -1  (tests sign-extension)
      add   s6, s4, s5         # s6 = 155
      sub   s7, s4, s5         # s7 = 45

# AND / ANDI test
      li    t0, 0xFF
         nop
      andi  t2, s4, 0x0F       # t2 = 100 & 0x0F = 4
      and   t1, s4, t0         # t1 = 100 & 0xFF = 100

# OR / ORI test
      li    t0, 0x0F
      ori   t4, s4, 3          # t4 = 100 | 3   = 103
         nop
      or    t3, s4, t0         # t3 = 100 | 0x0F = 111

# XOR / XORI test
      xor   t5, s4, s5         # t5 = 100 ^ 55
      xori  t6, s4, 0xFF       # t6 = 100 ^ 0xFF

# SLT / SLTI / SLTIU test
      slt   s0, s5, s4         # s0 = (55 < 100)  = 1  signed
      slt   s1, s8, zero       # s1 = (-1 < 0)    = 1  signed
      slti  s2, s4, 200        # s2 = (100 < 200) = 1
      slti  s3, s4, 50         # s3 = (100 < 50)  = 0
      sltiu s4, s4, 200        # s4 = (100 <u 200)= 1
      sltiu s5, s8, 1          # s5 = (0xFFFF.. <u 1) = 0  (huge unsigned)

# SLL / SLLI test
      li    t0, 1
      li    t1, 4
      slli  t4, s6, 2          # t4 = 155 << 2 = 620  (s6 still = 155)
      slli  t3, t0, 8          # t3 = 1 << 8  = 256
      sll   t2, t0, t1         # t2 = 1 << 4  = 16

# SRL / SRLI test
      li    t5, 0x7F           # t5 = 127
         nop 
         nop
      srl   t6, t5, t1         # t6 = 127 >> 4  = 7   (logical, zero-fill)
      srli  s0, t5, 3          # s0 = 127 >> 3  = 15

# SRA / SRAI test
      lui   s1, 0x80000        # s1 = 0x80000000 (MSB set = negative)
      li    t0, 1
         nop
      srai  s3, s1, 4          # s3 = 0x80000000 >> 4 = 0xF8000000
      sra   s2, s1, t0         # s2 = 0x80000000 >> 1 = 0xC0000000

# SW / LW test
      lui   t0, 0x10010       # la    t0, store_buf      # t0 = address of store_buf
      lui   t1, 0x1           # li    t1, 0xABC
         nop                  #
      addi  t0, t0, 12        #
      addi  t1, t1, -1348     #
         nop
         nop

      sw    t1, 0(t0)          # mem[store_buf] = 0xABC
      lw    t2, 0(t0)          # t2 = 0xABC  (verify round-trip)

# LB / LBU test
      lui   t0, 0x10010       # la    t0, byte_val
         nop                  #
         nop                  #
      addi  t0, t0, 4          #
         nop                  
         nop                  

      lb    t3, 0(t0)          # t3 = sign-extended 0xAB -> 0xFFFFFFAB
      lbu   t4, 0(t0)          # t4 = zero-extended 0xAB -> 0x000000AB

# LH / LHU test
      lui   t0, 0x10010       # la    t0, half_val
         nop                  #
         nop                  #
      addi  t0, t0, 8         #
         nop                  
         nop

      lh    t5, 0(t0)          # t5 = sign-extended 0x1234 -> 0x00001234
      lhu   t6, 0(t0)          # t6 = zero-extended 0x1234 -> 0x00001234

# LW test
      lui   t0, 0x10010       # la    t0, word_val
         nop 
         nop
      lw    s4, 0(t0)          # s4 = 0x00000F0F

# BEQ test
      li    t0, 42
      li    t1, 42
         nop
         nop
      beq   t0, t1, beq_taken
         nop
      addi  s5, zero, -1       # POISON — must not execute
beq_taken:
      li    s5, 1              # s5 = 1

# BNE test
      li    t0, 10
      li    t1, 20
         nop
         nop
      bne   t0, t1, bne_taken
         nop
      addi  s6, zero, -1       # POISON
bne_taken:
      li    s6, 2              # s6 = 2

# BLT test
      li    t0, -5
      li    t1, 5
         nop
         nop
      blt   t0, t1, blt_taken  # -5 < 5
         nop
      addi  s7, zero, -1       # POISON
blt_taken:
      li    s7, 3              # s7 = 3

# BGE test
      li    t0, 10
      li    t1, 10
         nop
         nop
      bge   t0, t1, bge_taken  # 10 >= 10
         nop
      addi  s8, zero, -1       # POISON
bge_taken:
      li    s8, 4              # s8 = 4

# BLTU test
      li    t0, 1
      li    t1, -1             # t1 = 0xFFFFFFFF (huge unsigned)
         nop
         nop
      bltu  t0, t1, bltu_taken # 1 <u 0xFFFFFFFF
         nop
      addi  s9, zero, -1       # POISON
bltu_taken:
      li    s9, 5              # s9 = 5

# BGEU test
      li    t0, -1             # t0 = 0xFFFFFFFF
      li    t1, 1
         nop 
         nop 
      bgeu  t0, t1, bgeu_taken # 0xFFFFFFFF >=u 1
         nop
      addi  s10, zero, -1      # POISON
bgeu_taken:
      li    s10, 6             # s10 = 6

# JAL test
      jal   ra, jal_target     # ra = return addr, jump to jal_target
         nop
      addi  s11, zero, -1      # POISON
jal_return:
      li    s11, 7             # s11 = 7  (landed back here via jalr below)
      jal   zero, jalr_test    # skip subroutine body, go to jalr_test
         nop

jal_target:
      li    a0, 8              # a0 = 8  (inside subroutine)
      jalr  zero, 0(ra)        # return to jal_return
         nop
         nop

# JALR test
jalr_test:
      auipc a1, 0              # a1 = current PC
         nop 
         nop 
      addi  a1, a1, 40         # a1 = address of instruction after jalr
         nop
         nop
      jalr  ra, 0(a1)          # jump to a1; ra = PC+4 (unused here)
         nop
         nop
      addi  a2, zero, -1       # POISON
      li    a2, 9              # a2 = 9  (execution resumes here)

# HALT
die:
      nop 
      nop
      nop
      nop
      nop
      wfi