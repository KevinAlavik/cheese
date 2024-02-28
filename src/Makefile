all:
	 nasm -f bin boot/boot.asm -o bin/bootloader.bin
	 nasm -f elf32 kernel/kernel_entry.asm -o bin/krnl.o
	 gcc -ffreestanding -m32 -g -c kernel/kernel.c -o bin/kernel.o
	 nasm -f bin boot/zeroes.asm -o bin/zeroes.bin

	 ld -m elf_i386 -o "bin/full_kernel.bin" -Ttext 0x1000 "bin/krnl.o" "bin/kernel.o" --ignore-unresolved-symbol _GLOBAL_OFFSET_TABLE_ --oformat binary

	 cat "bin/bootloader.bin" "bin/full_kernel.bin" "bin/zeroes.bin" > "bin/OS.bin"

run:
	qemu-system-i386 -drive format=raw,file="bin/OS.bin",index=0,if=floppy -m 128M
