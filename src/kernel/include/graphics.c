#include "graphics.h"

unsigned char* location;

void put_pixel(int x, int y, int VGA_COLOR)
{
    location = (unsigned char*)0xA0000 + 320 * y + x;
    *location = (unsigned char)VGA_COLOR;
}

void line_d(int x, int y, int width, int VGA_COLOR)
{
    for(int i = 0; i < width; i++)
    {
        put_pixel(x, y, VGA_COLOR);
        x++;
        y++;
    }
}

void line_di(int x, int y, int width, int VGA_COLOR)
{
    for(int i = 0; i < width; i++)
    {
        put_pixel(x, y, VGA_COLOR);
        x--;
        y++;
    }
}

void line(int x, int y, int width, int VGA_COLOR)
{
    for(int i = 0; i < width; i++)
    {
        put_pixel(x, y, VGA_COLOR);
        x++;
    }
}

void line_v(int x, int y, int width, int VGA_COLOR)
{
    for(int i = 0; i < width; i++)
    {
        put_pixel(x, y, VGA_COLOR);
        y++;
    }
}