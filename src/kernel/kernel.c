#include "lib/serial.h"

void main()
{
    outb8(QEMU_SERIAL_PORT, 'A');
    return;
}
