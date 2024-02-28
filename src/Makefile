NASM=nasm
GCC=gcc
LD=ld
QEMU=qemu-system-i386

NASM_FLAGS=-f bin
GCC_FLAGS=-std=gnu11 -ffreestanding -fno-stack-protector -fno-stack-check -fno-lto -fno-PIE -fno-PIC -m32 -g -nostdinc -I$(KERNEL_DIR)/include
LD_FLAGS=-I$(KERNEL_DIR)/include -m elf_i386 -static -nostdlib -Ttext 0x1000 --ignore-unresolved-symbol _GLOBAL_OFFSET_TABLE_ --oformat binary

BOOT_DIR=boot
KERNEL_DIR=kernel
BIN_DIR=bin
TOOLS_DIR=tools

all: bootloader kernel cheese_install

bootloader: $(BIN_DIR)/bootloader.bin $(BIN_DIR)/cheese.bin

kernel: $(BIN_DIR)/full_kernel.bin

run: $(BIN_DIR)/OS.bin
	$(QEMU) -drive format=raw,file="$<",index=0,if=floppy -m 128M

$(BIN_DIR)/bootloader.bin: $(wildcard $(BOOT_DIR)/*.asm)
	$(NASM) $(NASM_FLAGS) $(BOOT_DIR)/boot.asm -o $@

$(BIN_DIR)/cheese.bin: $(wildcard $(BOOT_DIR)/*.asm)
	$(NASM) $(NASM_FLAGS) $(BOOT_DIR)/boot.asm -o $@

$(BIN_DIR)/%.o: $(KERNEL_DIR)/%.asm
	$(NASM) -f elf32 $< -o $@

$(BIN_DIR)/%.o: $(KERNEL_DIR)/%.c
	$(GCC) $(GCC_FLAGS) -c $< -o $@

$(BIN_DIR)/full_kernel.bin: $(wildcard $(KERNEL_DIR)/*.c) $(wildcard $(KERNEL_DIR)/*.asm)
	$(GCC) $(GCC_FLAGS) -c $^ -o $(BIN_DIR)/kernel.o
	$(NASM) -f elf32 $(KERNEL_DIR)/kernel_entry.asm -o $(BIN_DIR)/kernel_asm.o
	$(LD) $(LD_FLAGS) -o $@ $(BIN_DIR)/kernel.o $(BIN_DIR)/kernel_asm.o

$(BIN_DIR)/OS.bin: $(BIN_DIR)/bootloader.bin $(BIN_DIR)/full_kernel.bin $(BIN_DIR)/zeroes.bin
	cat "$(BIN_DIR)/bootloader.bin" "$(BIN_DIR)/full_kernel.bin" "$(BIN_DIR)/zeroes.bin" > "$(BIN_DIR)/OS.bin"

cheese_install: $(BIN_DIR)/OS.bin
	./$(TOOLS_DIR)/cheese_install.sh $(BIN_DIR)/cheese.bin $^ $(BIN_DIR)/OS.bin

clean:
	rm -rf $(BIN_DIR)/*

.PHONY: all bootloader kernel run cheese_install clean
