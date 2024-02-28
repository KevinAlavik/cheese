; Cheese boot entry
[bits 16] ; specifies that we're currently in 16 bit real mode to NASM
[org 0x7c00] ; this is the origin of our bootloader

; this is how you define constants by the way.
KERNEL_OFFSET equ 0x1000 ; This is the location where our kernel is located.

mov [BOOT_DRIVE], dl ; just to make sure we're safe

; This is the stack stuff! - sp is stack pointer.
xor ax, ax
mov es, ax
mov ds, ax
mov bp, 0x8000 ; Stack location
mov sp, bp

mov bx, KERNEL_OFFSET ; moving the kernel offset into the bx register
mov dh, 2

mov ah, 0x02 ; specifies we want to read sectors
mov al, dh ; Number of sectors to read, which is 2 in our case.
mov ch, 0x00 ; This is cylinder we want to read.
mov dh, 0x00 ; This is the head we want to read.
mov cl, 0x02 ; This is the sector we want to read.
mov dl, [BOOT_DRIVE] ; This is the drive we want to read.
int 13h ; No error management, do your homework Kevin!

mov ah, 0x0
mov al, 0x3
int 0x10  ; text mode, clears the screen

CODE_SEG equ GDT_code - GDT_start
DATA_SEG equ GDT_data - GDT_start

cli ; clear interrupts
lgdt [gdt_descriptor] ; load our GDT
mov eax, cr0
or eax, 1
mov cr0, eax
jmp CODE_SEG:start_pm ; jump to protected mode

jmp $ ; Infinite loop

BOOT_DRIVE: db 0

GDT_start:
	GDT_null:
		dd 0
		dd 0

	GDT_code:
		dw 0xffff
		dw 0x0
        db 0x0
        db 0b10011010
        db 0b11001111
        db 0x0

	GDT_data:
		dw 0xffff
		dw 0x0
        db 0x0
        db 0b10010010
        db 0b11001111
        db 0x0

GDT_end:

gdt_descriptor:
	dw GDT_end - GDT_start - 1
	dd GDT_start

[bits 32] ; we're now in protected mode

start_pm:
    ; Important! we need to setup the stack before anything. Otherwise the system will triple fault.
		mov ax, DATA_SEG
		mov ds, ax
		mov ss, ax
		mov es, ax
		mov fs, ax
		mov gs, ax

		mov ebp, 0x90000		; 32 bit stack base pointer
		mov esp, ebp

		jmp KERNEL_OFFSET   ; jump to the kernel offset

times 510-($-$$) db 0 ; Padding, so it's exactly 512 bytes.
dw 0xaa55 ; magic bytes
