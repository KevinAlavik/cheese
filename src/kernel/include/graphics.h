#ifndef GRAPHICS_H
#define GRAPHICS_H

void put_pixel(int x, int y, int VGA_COLOR);
void line_d(int x, int y, int width, int VGA_COLOR);
void line_di(int x, int y, int width, int VGA_COLOR);
void line(int x, int y, int width, int VGA_COLOR);
void line_v(int x, int y, int width, int VGA_COLOR);

#endif