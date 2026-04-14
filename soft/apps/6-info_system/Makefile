include ../../Makefile.inc 

EXEC=main.elf

all: $(EXEC)
	$(firmware_words) ./bin/$(EXEC) -ram 0x20000 -max_addr 0x20000 -out hex/PROGROM.mem -from_addr 0x00000 -to_addr 0x0FFFF
	$(firmware_words) ./bin/$(EXEC) -ram 0x20000 -max_addr 0x20000 -out hex/DATARAM.mem -from_addr 0x10000 -to_addr 0x1FFFF
	@python3 ../../tools/conv_rom.py        --input hex/PROGROM.mem --output ../../../src/riscv/rom/mem_rom.vhd
	@python3 ../../tools/conv_ram.py        --input hex/DATARAM.mem --output ../../../src/riscv/ram/mem_ram.vhd
	@python3 ../../tools/conv_ram_altera.py --input hex/DATARAM.mem --output ../../../src/riscv/ram/mem_ram_altera.vhd
	@python3 ../../tools/conv_ram_5stg.py   --input hex/DATARAM.mem --output ../../../src/riscv/ram/mem_ram_dp.vhd

main.elf: ./obj/boot.o       \
				./obj/main.o
	$(RV_LD)  -o ./bin/$@ $^ $(LDFLAGS) -L../../libuc -luc
	$(RV_OBJ) -D ./bin/$(EXEC) > ./asm/$(EXEC).asm

./obj/main.o: ./src/main.c
	$(RV_GCC) $(GCCFLAGS) ./src/main.c -c -o ./obj/main.o -I../../libuc -fno-pic

./obj/boot.o : ../shared/boot.S
	$(RV_AS) $(ASFLAGS) ../shared/boot.S -o ./obj/boot.o

clean:
	rm -rf obj/*.o
	rm -rf hex/*.mem
	rm -rf bin/$(EXEC)
	rm -rf asm/$(EXEC).asm
