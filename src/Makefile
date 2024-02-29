# Compiler and linker options
NASM=nasm
GCC=gcc
LD=ld
QEMU=qemu-system-i386

# Directories
SRC_DIR=kernel
INC_DIR=kernel/include
BOOT_DIR=boot
BIN_DIR=bin

# Source files
BOOT_ASM=$(wildcard $(BOOT_DIR)/*.asm)
KERNEL_ASM=$(wildcard $(SRC_DIR)/*.asm)
KERNEL_C=$(wildcard $(SRC_DIR)/*.c)
KERNEL_HEADERS=$(shell find $(INC_DIR) -name '*.h')
ZEROES_ASM=$(BOOT_DIR)/zeroes.asm

# Object files
BOOTLOADER_OBJ=$(patsubst $(BOOT_DIR)/%.asm,$(BIN_DIR)/%.bin,$(BOOT_ASM))
KERNEL_ASM_OBJ=$(patsubst $(SRC_DIR)/%.asm,$(BIN_DIR)/%.o,$(KERNEL_ASM))
KERNEL_C_OBJ=$(patsubst $(SRC_DIR)/%.c,$(BIN_DIR)/%.o,$(KERNEL_C))
ZEROES_OBJ=$(patsubst $(BOOT_DIR)/%.asm,$(BIN_DIR)/%.bin,$(ZEROES_ASM))

# Final binary
OS_BIN=$(BIN_DIR)/OS.bin

# Compiler flags
CFLAGS=-ffreestanding -m32 -g $(addprefix -I, $(INC_DIR))

# Linker flags
LDFLAGS=-m elf_i386 -Ttext 0x1000 --ignore-unresolved-symbol _GLOBAL_OFFSET_TABLE_ --oformat binary

# Build targets
all: $(OS_BIN)

$(OS_BIN): $(BOOTLOADER_OBJ) $(KERNEL_ASM_OBJ) $(KERNEL_C_OBJ) $(ZEROES_OBJ)
	cat $(BOOTLOADER_OBJ) $(KERNEL_ASM_OBJ) $(KERNEL_C_OBJ) $(ZEROES_OBJ) > $(OS_BIN)

$(BOOTLOADER_OBJ): $(BOOT_ASM)
	$(NASM) -f bin $< -o $@

$(KERNEL_ASM_OBJ): $(KERNEL_ASM)
	$(NASM) -f elf $< -o $@

$(BIN_DIR)/%.o: $(SRC_DIR)/%.c $(KERNEL_HEADERS)
	$(GCC) $(CFLAGS) -c $< -o $@

$(ZEROES_OBJ): $(ZEROES_ASM)
	$(NASM) -f bin $< -o $@

run: $(OS_BIN)
	$(QEMU) -serial stdio -drive format=raw,file=$(OS_BIN),index=0,if=floppy -m 128M

clean:
	rm -rf $(BIN_DIR)/*

.PHONY: all run clean
