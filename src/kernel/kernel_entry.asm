section .text
    BITS 32  ; Set the assembly mode to 32 bits
    extern main  ; Declare the main function as external

    global _start  ; Define _start as the entry point
_start:
    call main  ; Call the main function which is in C
    jmp $     ; Infinite loop, since the main function is expected to never return
