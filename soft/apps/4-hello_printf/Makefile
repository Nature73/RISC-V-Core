include ../../Makefile.inc 

EXEC=hello_world.elf

all: $(EXEC)
	$(firmware_words) ./bin/$(EXEC) -ram 0x20000 -max_addr 0x20000 -out hex/PROGROM.mem -from_addr 0x00000 -to_addr 0x0FFFF
	$(firmware_words) ./bin/$(EXEC) -ram 0x20000 -max_addr 0x20000 -out hex/DATARAM.mem -from_addr 0x10000 -to_addr 0x1FFFF
	$(firmware_words) ./bin/$(EXEC) -ram 0x20000 -max_addr 0x20000 -out hex/firmware.mem
	@python3 ../../tools/conv_rom.py        --input hex/PROGROM.mem --output ../../../src/riscv/rom/mem_rom.vhd
	@python3 ../../tools/conv_ram.py        --input hex/DATARAM.mem --output ../../../src/riscv/ram/mem_ram.vhd
	@python3 ../../tools/conv_ram_altera.py --input hex/DATARAM.mem --output ../../../src/riscv/ram/mem_ram_altera.vhd
	@python3 ../../tools/conv_ram_5stg.py   --input hex/DATARAM.mem --output ../../../src/riscv/ram/mem_ram_dp.vhd

hello_world.elf: obj/boot.o    \
				 obj/hello_world.o \
				 obj/print.o   \
				 obj/mul.o     \
				 obj/div.o
	$(RV_LD)  -o ./bin/$@ $^ $(LDFLAGS) 
	$(RV_OBJ) -D ./bin/$(EXEC) > ./asm/$(EXEC).asm

obj/hello_world.o: src/hello_world.c
	$(RV_GCC) $(GCCFLAGS) src/hello_world.c -c -o obj/hello_world.o

obj/boot.o : ../shared/boot.S
	$(RV_AS) $(ASFLAGS) ../shared/boot.S -o obj/boot.o

obj/print.o : ../shared/print.c
	$(RV_GCC) $(GCCFLAGS) ../shared/print.c -c -o obj/print.o

obj/mul.o : ../shared/mul.S
	$(RV_AS) $(ASFLAGS) ../shared/mul.S -o obj/mul.o

obj/div.o : ../shared/div.S
	$(RV_AS) $(ASFLAGS) ../shared/div.S -o obj/div.o

clean:
	rm -rf obj/*.o
	rm -rf hex/*.mem
	rm -rf bin/$(EXEC)
	rm -rf asm/$(EXEC).asm
