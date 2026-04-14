# MAC-OS
#RV_GCC=riscv64-elf-gcc
#RV_AS=riscv64-elf-as
#RV_AR=riscv64-elf-ar
#RV_LD=riscv64-elf-ld
#RV_OBJ=riscv64-elf-objdump
#RV_RANLIB=riscv64-elf-ranlib

# LINUX
RV_GCC=riscv64-linux-gnu-gcc-12
RV_AS=riscv64-linux-gnu-as
RV_AR=riscv64-linux-gnu-ar
RV_LD=riscv64-linux-gnu-ld
RV_OBJ=riscv64-linux-gnu-objdump
RV_RANLIB=riscv64-linux-gnu-ranlib

ASFLAGS= -march=rv32i -mabi=ilp32
# -fno-stack-protector -w -Wl,--no-relax -DTIME -DUSE_MYSTDLIB -fno-pic
GCCFLAGS=-march=rv32i -mabi=ilp32 -O2 -DRISCV -fno-stack-protector
LDFLAGS=-T linker.ld -m elf32lriscv -nostdlib

firmware_words=../../tools/firmware_words/firmware_words

